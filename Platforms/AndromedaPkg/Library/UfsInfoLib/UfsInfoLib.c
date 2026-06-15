/** @file
  Copyright (c) 2026 AlohaWoA authors
  SPDX-License-Identifier: BSD-2-Clause
**/

#include <Uefi.h>

#include <Library/BaseMemoryLib.h>
#include <Library/CacheMaintenanceLib.h>
#include <Library/DebugLib.h>
#include <Library/IoLib.h>
#include <Library/MemoryAllocationLib.h>
#include <Library/MemoryMapHelperLib.h>
#include <Library/UefiBootServicesTableLib.h>

#include <IndustryStandard/Ufs.h>
#include <IndustryStandard/UfsHci.h>

#include <Library/UfsInfoLib.h>

#define WAIT_SLOT_FREE_TIMEOUT_US 10000 // 10ms
#define ROUNDUP8(x) (((x) % 8 == 0) ? (x) : ((x) / 8 + 1) * 8)

EFI_STATUS
GetUfsSpecVer(OUT UINT16 *SpecVer)
{
  ARM_MEMORY_REGION_DESCRIPTOR_EX UfsRegion = {0};
  UTP_QUERY_REQ_UPIU             *QueryReq;
  UTP_QUERY_RESP_UPIU            *QueryResp;
  UTP_TRD                        *Trd;
  UFS_DEV_DESC                   *pUfsDeviceDescriptor = NULL;
  UFS_SPEC_VERSION                Ver;
  BOOLEAN                         SlotFound = FALSE;
  UINT8                           NUTRS; // Num of UTP Transfer Request Slots
  UINT8                           Slot = 0xFF;
  UINT32                          RegVal;
  UINT64                          UtrlAddr = 0;
  UINT64                          UfsMem;

  EFI_PHYSICAL_ADDRESS CmdDescAddr;
  EFI_STATUS           Status = EFI_SUCCESS;

  // Locate ufs mmio region
  Status = LocateMemoryMapAreaByName("UFS UFS REGS", &UfsRegion);
  if (EFI_ERROR(Status)) {
    DEBUG((DEBUG_WARN, "%a: Failed to locate UFS MMIO region.\n", __func__));
    DEBUG((DEBUG_WARN, "%a: Use default address: 0x%lx\n", __func__, 0x1D84000));
    UfsMem = 0x1D84000;
  } else {
    // Ufshci offset(0x4000) + Ufshci region size(0x3000)
    if (UfsRegion.Address == 0x1D80000 && UfsRegion.Length >= 0x4000 + 0x3000)
      UfsMem = UfsRegion.Address + 0x4000;
    else // Customized address? Ignore size checks.
      UfsMem = UfsRegion.Address;
  }

  DEBUG(
      (DEBUG_WARN, "%a: UFS MMIO region located at 0x%lx\n", __func__, UfsMem));

  // Check if ufs storage chip is present
  RegVal = MmioRead32(UfsMem + UFS_HC_STATUS_OFFSET);
  if ((RegVal & UFS_HC_HCS_DP) == 0) {
    DEBUG((DEBUG_ERROR, "%a: UFS device not present !!\n", __func__));
    return EFI_NOT_FOUND;
  }

  // Get controller's capabilities
  RegVal = MmioRead32(UfsMem + UFS_HC_CAP_OFFSET);
  NUTRS  = 1 + ((UFS_HC_CAP *)&RegVal)->Nutrs;

  // Find a free slot
  for (UINT32 i = 0; i < WAIT_SLOT_FREE_TIMEOUT_US; i++) {
    RegVal = MmioRead32(UfsMem + UFS_HC_UTRLDBR_OFFSET);
    for (Slot = 0; Slot < NUTRS; Slot++) {
      if ((RegVal & (BIT0 << Slot)) == 0) {
        SlotFound = TRUE;
        break;
      }
    }
    if (SlotFound)
      break;
    gBS->Stall(1);
  }
  if (!SlotFound) {
    DEBUG(
        (DEBUG_ERROR,
         "%a: No free UTP transfer request list slot found !! UTRLDBR=0x%x\n",
         __func__, RegVal));
    return EFI_TIMEOUT;
  }

  // Read current UTRL base address.
  UtrlAddr = ((UINT64)MmioRead32(UfsMem + UFS_HC_UTRLBAU_OFFSET) << 32) |
             MmioRead32(UfsMem + UFS_HC_UTRLBA_OFFSET);

  // Allocate 1 page for cmd descriptor buffer
  Status = gBS->AllocatePages(
      AllocateAnyPages, EfiBootServicesData, 1, &CmdDescAddr);
  if (EFI_ERROR(Status)) {
    DEBUG((DEBUG_ERROR, "%a: Allocate pages for UPIU failed !\n", __func__));
    return Status;
  }
  ASSERT((UINTN)(CmdDescAddr & (128 - 1)) == 0);
  ZeroMem((VOID *)(UINTN)CmdDescAddr, EFI_PAGE_SIZE);

  // Construct Query Request UPIU
  QueryReq               = (UTP_QUERY_REQ_UPIU *)(UINTN)CmdDescAddr;
  QueryReq->TransCode    = 0x16;
  QueryReq->TaskTag      = 1;
  QueryReq->QueryFunc    = QUERY_FUNC_STD_READ_REQ;
  QueryReq->Tsf.Opcode   = UtpQueryFuncOpcodeRdDesc;
  QueryReq->Tsf.DescId   = UfsDeviceDesc;
  QueryReq->Tsf.Index    = 0;
  QueryReq->Tsf.Selector = 0;
  QueryReq->Tsf.Length   = SwapBytes16(sizeof(UFS_DEV_DESC));

  QueryResp =
      (UTP_QUERY_RESP_UPIU *)(UINTN)(CmdDescAddr +
                                     ((sizeof(UTP_QUERY_REQ_UPIU) + 3) & ~3));

  Trd = ((UTP_TRD *)(UINTN)UtrlAddr) + Slot;
  ZeroMem(Trd, sizeof(UTP_TRD));
  Trd->Int    = UFS_INTERRUPT_COMMAND;
  Trd->Dd     = UfsDataIn;
  Trd->Ct     = UFS_STORAGE_COMMAND_TYPE;
  Trd->Ocs    = UFS_HC_TRD_OCS_INIT_VALUE;
  Trd->UcdBa  = (UINT32)RShiftU64((UINT64)(UINTN)CmdDescAddr, 7);
  Trd->UcdBaU = (UINT32)RShiftU64((UINT64)(UINTN)CmdDescAddr, 32);
  Trd->RuL    = (UINT16)DivU64x32(
      (UINT64)ROUNDUP8(sizeof(UTP_QUERY_RESP_UPIU)) +
          ROUNDUP8(sizeof(UFS_DEV_DESC)),
      sizeof(UINT32));
  Trd->RuO = (UINT16)DivU64x32(
      (UINT64)ROUNDUP8(sizeof(UTP_QUERY_REQ_UPIU)), sizeof(UINT32));
  // PRDT must be zero in DM cmd
  Trd->PrdtL = 0x00;

  // Flush Cache
  WriteBackInvalidateDataCacheRange((VOID *)(UINTN)CmdDescAddr, EFI_PAGE_SIZE);
  WriteBackInvalidateDataCacheRange((VOID *)Trd, sizeof(UTP_TRD));

  // Start exec command
  // start utp transfer request
  RegVal = MmioRead32(UfsMem + UFS_HC_UTRLRSR_OFFSET);
  if ((RegVal & UFS_HC_UTRLRSR) != UFS_HC_UTRLRSR) {
    MmioWrite32(UfsMem + UFS_HC_UTRLRSR_OFFSET, UFS_HC_UTRLRSR);
  }
  // Ring doorbell!
  MmioWrite32(UfsMem + UFS_HC_UTRLDBR_OFFSET, BIT0 << Slot);

  // Wait for cmd completion
  // Poll our slot in doorbell reg
  SlotFound = FALSE;
  for (UINT32 i = 0; i < WAIT_SLOT_FREE_TIMEOUT_US; i++) {
    RegVal = MmioRead32(UfsMem + UFS_HC_UTRLDBR_OFFSET);
    if ((RegVal & (BIT0 << Slot)) == 0) {
      SlotFound = TRUE;
      break;
    }
    gBS->Stall(1);
  }
  if (!SlotFound) {
    DEBUG(
        (DEBUG_ERROR, "%a: UFS command timeout ! UTRLDBR=0x%x\n", __func__,
         RegVal));
    Status = EFI_TIMEOUT;
    goto free_exit;
  }

  // Invalid Caches
  InvalidateDataCacheRange((VOID *)(UINTN)CmdDescAddr, EFI_PAGE_SIZE);
  InvalidateDataCacheRange((VOID *)Trd, sizeof(UTP_TRD));

  // Check Overall command status
  if (Trd->Ocs != 0) {
    DEBUG((DEBUG_ERROR, "%a: UFS TRD OCS error: 0x%x\n", __func__, Trd->Ocs));
    Status = EFI_DEVICE_ERROR;
    goto free_exit;
  }

  // Check Query Response code
  if (QueryResp->QueryResp != UfsUtpQueryResponseSuccess) {
    DEBUG(
        (DEBUG_ERROR, "%a: Query Response error: 0x%x\n", __func__,
         QueryResp->QueryResp));
    Status = EFI_DEVICE_ERROR;
    goto free_exit;
  }

  // Get Device Descriptor
  pUfsDeviceDescriptor =
      (UFS_DEV_DESC *)(UINTN)(CmdDescAddr +
                              ((sizeof(UTP_QUERY_REQ_UPIU) + 3) & ~3) +
                              sizeof(UTP_QUERY_RESP_UPIU));

  // Fill result
  Ver.Data = SwapBytes16(pUfsDeviceDescriptor->SpecVersion);
  *SpecVer = Ver.Bits.Major;

  // Print device descriptor.
  DEBUG((DEBUG_INFO, "\n========================="));
  DEBUG((DEBUG_INFO, "\n  UFS Device Descriptor  "));
  DEBUG((DEBUG_INFO, "\n=========================\n"));
  DEBUG(
      (DEBUG_INFO, "  Length:             %d bytes\n",
       pUfsDeviceDescriptor->Length));
  DEBUG(
      (DEBUG_INFO, "  Number of LUs:      %d\n", pUfsDeviceDescriptor->NumLun));
  DEBUG((
      DEBUG_INFO, "  Number of W-LUs:    %d\n", pUfsDeviceDescriptor->NumWLun));
  DEBUG(
      (DEBUG_INFO, "  Boot Enable:        0x%02x\n",
       pUfsDeviceDescriptor->BootEn));
  DEBUG(
      (DEBUG_WARN, "  Manufacturer ID:    0x%04x\n",
       SwapBytes16(pUfsDeviceDescriptor->ManufacturerId)));
  DEBUG(
      (DEBUG_INFO, "  Device Version:     0x%04x\n",
       SwapBytes16(pUfsDeviceDescriptor->DeviceVersion)));
  DEBUG(
      (DEBUG_INFO, "  SpecVersion: 0x%04x -> %d.%d%d (UFS %d.%d)\n",
       pUfsDeviceDescriptor->SpecVersion, Ver.Bits.Major, Ver.Bits.Minor,
       Ver.Bits.Suffix, Ver.Bits.Major, Ver.Bits.Minor));

  // Done !
  Status = EFI_SUCCESS;

free_exit:
  gBS->FreePages(CmdDescAddr, 1);
  return Status;
}