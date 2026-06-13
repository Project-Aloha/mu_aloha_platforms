/**************************
 * Description:
   Add RAM Partitions.
   Read Ram Partitions Info by EFI_RAMPARTITION_PROTOCOL and add them.


 * Reference Codes
 * abl/edk2/QcomModulePkg/Library/BootLib/Board.c

 - License:
 * Copyright (c) 2015-2018, 2020, The Linux Foundation. All rights reserved.
 * Copyright (c) 2022. Sunflower2333. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 * * Redistributions of source code must retain the above copyright
 *  notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above
 * copyright notice, this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided
 *  with the distribution.
 *   * Neither the name of The Linux Foundation nor the names of its
 * contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

**************************/
/*-------------------------Headers------------------------------*/
#include <Library/BaseLib.h>
#include <Library/UefiLib.h>
#include <Library/DebugLib.h>
#include <Library/PrintLib.h>
#include <Library/BaseMemoryLib.h>
#include <Library/DxeServicesLib.h>
#include <Library/MemoryAllocationLib.h>
#include <Library/UefiDriverEntryPoint.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Guid/DxeServices.h>
#include <Library/DxeServicesTableLib.h>

#include <Library/ArmMmuLib.h>
#include <Library/ArmPlatformLib.h>
#include <Library/PcdLib.h>
#include <Library/IoLib.h>

#include <Library/PlatformMemoryMapLib.h>

#include <Protocol/EFIRamPartition.h>

#include "ExtendedMemoryMap.h"

/*-------------------------Macros------------------------------*/
#define GENERIC_RAM_BASE FixedPcdGet64(PcdSystemMemoryBase)
// #define GAP_END_ADDR 0xC0000000
#define SIZE_2GB 0x80000000

#ifdef HAS_MLVM
#define MLVM_BASE 0xA0000000
#endif
/*-------------------------Global_Variable------------------------------*/
RamPartitionEntry *RamPartitionEntries = NULL;

/*-------------------------Functions--------------------------*/

/*
 *
 * GetRamPartitions
 *   - Read RamPartitionEntry from Smem.
 *
 *       out RamPartitionEntry
 *           An array contains each partitions's Base address and
 * AvailableLength
 *
 *       out NumPartitions
 *           Number of RAM Partitions.
 *
 */
STATIC
EFI_STATUS
GetRamPartitions(
    OUT RamPartitionEntry **RamPartitions, OUT UINT32 *NumPartitions)
{

  EFI_STATUS                 Status           = EFI_NOT_FOUND;
  EFI_RAMPARTITION_PROTOCOL *pRamPartProtocol = NULL;

  Status = gBS->LocateProtocol(
      &gEfiRamPartitionProtocolGuid, NULL, (VOID **)&pRamPartProtocol);
  if (EFI_ERROR(Status) || (pRamPartProtocol == NULL)) {
    DEBUG(
        (EFI_D_ERROR,
         "Locate EFI_RAMPARTITION_Protocol failed, Status =  (0x%x)\r\n",
         Status));
    return EFI_NOT_FOUND;
  }
  Status =
      pRamPartProtocol->GetRamPartitions(pRamPartProtocol, NULL, NumPartitions);
  if (Status == EFI_BUFFER_TOO_SMALL) {
    *RamPartitions =
        AllocateZeroPool(*NumPartitions * sizeof(RamPartitionEntry));
    if (*RamPartitions == NULL)
      return EFI_OUT_OF_RESOURCES;

    Status = pRamPartProtocol->GetRamPartitions(
        pRamPartProtocol, *RamPartitions, NumPartitions);
    if (EFI_ERROR(Status) || (*NumPartitions < 1)) {
      DEBUG((EFI_D_ERROR, "Failed to get RAM partitions"));
      FreePool(*RamPartitions);
      *RamPartitions = NULL;
      return EFI_NOT_FOUND;
    }
  }
  else {
    DEBUG((EFI_D_ERROR, "Error Occured while populating RamPartitions\n"));
    return EFI_PROTOCOL_ERROR;
  }
  return Status;
}

EFI_STATUS
EFIAPI
AddRamPartition(
    IN EFI_PHYSICAL_ADDRESS Base, IN UINT64 Length, IN UINT64 ArmAttributes,
    IN EFI_MEMORY_TYPE EfiMemoryType)
{
  EFI_STATUS          Status           = EFI_SUCCESS;
  EFI_GCD_MEMORY_TYPE EfiGcdMemoryType = EfiGcdMemoryTypeReserved;

  switch (EfiMemoryType) {
  case EfiReservedMemoryType:
    EfiGcdMemoryType = EfiGcdMemoryTypeReserved;
    DEBUG((EFI_D_INFO, "Default Type: EfiGcdMemoryTypeReserved\n"));
    break;
  case EfiConventionalMemory:
    EfiGcdMemoryType = EfiGcdMemoryTypeSystemMemory;
    DEBUG((EFI_D_INFO, "Default Type: EfiGcdMemoryTypeSystemMemory\n"));
    break;
  default:
    EfiGcdMemoryType = EfiGcdMemoryTypeReserved;
    DEBUG((EFI_D_INFO, "Choose Type: EfiGcdMemoryTypeReserved\n"));
    break;
  }

  if (Length == 0)
    return EFI_INVALID_PARAMETER;

  DEBUG(
      (EFI_D_ERROR, "Adding Memory Space: 0x%08llx 0x%08llx\n", Base, Length));
  Status = gDS->AddMemorySpace(EfiGcdMemoryType, Base, Length, 0xF);
  if (EFI_ERROR(Status)) {
    DEBUG((EFI_D_ERROR, "AddMemorySpace Failed ! %r\n", Status));
    return Status;
  }

  Status = ArmSetMemoryAttributes(Base, Length, ArmAttributes, 0);
  if (EFI_ERROR(Status)) {
    DEBUG((EFI_D_ERROR, "ArmSetMemoryAttributes Failed ! %r\n", Status));
    return Status;
  }

  Status = gDS->SetMemorySpaceAttributes(Base, Length, EFI_MEMORY_WB);
  if (EFI_ERROR(Status)) {
    DEBUG((EFI_D_ERROR, "ArmClearMemoryRegionReadOnly Failed ! %r\n", Status));
    return Status;
  }

  return Status;
}

EFI_STATUS
EFIAPI
SpiltAndAddRamPartitions(
    IN EFI_PHYSICAL_ADDRESS Base, IN UINT64 Length, IN UINT64 ArmAttributes,
    IN EFI_MEMORY_TYPE EfiMemoryType)
{
  EFI_STATUS Status = EFI_SUCCESS;

  if (Length > SIZE_2GB) {
    for (UINT16 parts = Length / SIZE_2GB; parts > 0; parts--) {
      Status = AddRamPartition(Base, SIZE_2GB, ArmAttributes, EfiMemoryType);
      Base   = Base + SIZE_2GB;
    }
    Status =
        AddRamPartition(Base, Length % SIZE_2GB, ArmAttributes, EfiMemoryType);
    goto exit;
  }

  if (Length <= SIZE_2GB) {
    Status = AddRamPartition(Base, Length, ArmAttributes, EfiMemoryType);
  }

exit:
  return Status;
}

//
// Driver Entry Point
//
EFI_STATUS
EFIAPI
RamPartitionDxeInitialize(
    IN EFI_HANDLE ImageHandle, IN EFI_SYSTEM_TABLE *SystemTable)
{
  EFI_STATUS                       Status = EFI_SUCCESS;
  UINT32                           i, NumPartitionEntries = 0;
  PARM_MEMORY_REGION_DESCRIPTOR_EX MemoryDescriptorEx =
      gExtendedMemoryDescriptorEx;
  UINTN Index = 1;

  // Get RAM Partition Info
  NumPartitionEntries = 0;
  Status = GetRamPartitions(&RamPartitionEntries, &NumPartitionEntries);
  if (EFI_ERROR(Status)) {
    DEBUG(
        (EFI_D_ERROR, "Failed to initialize RamPartitionDxe! Status: %r\n",
         Status));
    return Status;
  }

  // Update Extended Memory Map, although it's meaningless.
  DEBUG((EFI_D_INFO, "RAM Partitions\n"));
  for (i = 0; i < NumPartitionEntries; i++) {
    DEBUG(
        (EFI_D_INFO, "RAM Entry %d: Base:  0x%016lx ", i,
         RamPartitionEntries[i].Base));
    DEBUG(
        (EFI_D_INFO, "AvailableLength: 0x%016lx \n",
         RamPartitionEntries[i].AvailableLength));

#ifdef HAS_MLVM
    // Update the first MLVM region for 855 Platform.
    if (RamPartitionEntries[i].Base == GENERIC_RAM_BASE) {
      MemoryDescriptorEx[0].Length =
          RamPartitionEntries[i].AvailableLength + GENERIC_RAM_BASE - MLVM_BASE;
      SpiltAndAddRamPartitions(
          MemoryDescriptorEx[0].Address, MemoryDescriptorEx[0].Length,
          MemoryDescriptorEx[0].ArmAttributes,
          MemoryDescriptorEx[0].MemoryType);
      continue;
    }
#endif

    // Perhaps some platforms allocated an area for RAM before 0x80000000.
    // Here we only consider the size of the area as 0x40000000.
    // Memory range: 0x40000000-0x80000000
    if (RamPartitionEntries[i].Base == 0x40000000) {
      MemoryDescriptorEx[Index].Address = 0x40000000;
      MemoryDescriptorEx[Index].Length  = 0x40000000;
      Index++;
      continue;
    }

    // Update RAM Partitions.
    // You should have mapped 4GB RAM in PEI stage.
    // End Address of 4GB: 0x180000000
    if ((RamPartitionEntries[i].Base < 0x180000000) &&
        ((RamPartitionEntries[i].Base +
          RamPartitionEntries[i].AvailableLength) > 0x180000000)) {
      MemoryDescriptorEx[Index].Address = 0x180000000;
      MemoryDescriptorEx[Index].Length =
          RamPartitionEntries[i].Base + RamPartitionEntries[i].AvailableLength -
          0x180000000;
      Index++;
      continue;
    }
    else if (
        (RamPartitionEntries[i].Base < 0x180000000) &&
        ((RamPartitionEntries[i].Base +
          RamPartitionEntries[i].AvailableLength) <= 0x180000000))
      continue;

    MemoryDescriptorEx[Index].Address = RamPartitionEntries[i].Base;
    MemoryDescriptorEx[Index].Length  = RamPartitionEntries[i].AvailableLength;
    Index++;
  }

  Index = 1;
  while (MemoryDescriptorEx[Index].Length != 0) {
    ASSERT(Index < MAX_ARM_MEMORY_REGION_DESCRIPTOR_COUNT);
    SpiltAndAddRamPartitions(
        MemoryDescriptorEx[Index].Address, MemoryDescriptorEx[Index].Length,
        MemoryDescriptorEx[Index].ArmAttributes,
        MemoryDescriptorEx[Index].MemoryType);
    Index++;
  }
  FreePool(RamPartitionEntries);
  return Status;
}
