// SPDX-License-Identifier: BSD-2-Clause-Patent
// Lenovo Y700 Gen4 platform adaptation for the EDK2 source UFS/SCSI stack.
#include <PiDxe.h>
#include <IndustryStandard/UfsHci.h>
#include <Guid/EventGroup.h>
#include <Protocol/PciIo.h>
#include <Protocol/UfsHostControllerPlatform.h>
#include <Library/BaseLib.h>
#include <Library/IoLib.h>
#include <Library/NonDiscoverableDeviceRegistrationLib.h>
#include <Library/UefiBootServicesTableLib.h>
#include "UfsLink.h"

#define UFS_CONTROLLER_BASE 0x01d84000
// MEM_CFG is not defined by the common UFSHCI header.
// MCQ_CFG at 0x380 describes queue configuration, not the active mode.
#define UFS_MEM_CFG_OFFSET 0x300
#define UFS_MEM_CFG_MCQ_MODE_SELECT BIT0
STATIC EFI_HANDLE mControllerHandle;
STATIC EFI_PCI_IO_PROTOCOL_IO_MEM mOriginalMemRead, mOriginalMemWrite;
STATIC BOOLEAN mControllerReady;
STATIC BOOLEAN mInheritedLinkSaved;

STATIC EFI_STATUS EFIAPI
ReadControllerMemory(EFI_PCI_IO_PROTOCOL *This, EFI_PCI_IO_PROTOCOL_WIDTH Width, UINT8 Bar,
         UINT64 Offset, UINTN Count, VOID *Data)
{
  return mControllerReady ? mOriginalMemRead(This, Width, Bar, Offset, Count, Data) : EFI_NOT_READY;
}

STATIC EFI_STATUS EFIAPI
WriteControllerMemory(EFI_PCI_IO_PROTOCOL *This, EFI_PCI_IO_PROTOCOL_WIDTH Width, UINT8 Bar,
          UINT64 Offset, UINTN Count, VOID *Data)
{
  return mControllerReady ? mOriginalMemWrite(This, Width, Bar, Offset, Count, Data) : EFI_NOT_READY;
}

STATIC EFI_STATUS EFIAPI
InitializeController(NON_DISCOVERABLE_DEVICE *Device)
{
  EFI_PCI_IO_PROTOCOL *PciIo;
  EFI_STATUS Status;
  (VOID)Device;
  Status = gBS->HandleProtocol(mControllerHandle, &gEfiPciIoProtocolGuid, (VOID **)&PciIo);
  if (EFI_ERROR(Status)) return Status;
  // PCI I/O is recreated on driver reconnect, while this platform DXE remains
  // loaded. Only an already wrapped interface may reuse the ready state;
  // a new interface needs fresh guards and its own DMA64 attribute setup.
  if (PciIo->Mem.Read == ReadControllerMemory)
    return mControllerReady ? EFI_SUCCESS : EFI_NOT_READY;
  mControllerReady = FALSE;
  mOriginalMemRead = PciIo->Mem.Read;
  mOriginalMemWrite = PciIo->Mem.Write;
  PciIo->Mem.Read = ReadControllerMemory;
  PciIo->Mem.Write = WriteControllerMemory;
  // XBL loaded this image from UFS. Retain its PHY calibration, clock/rail
  // votes and SID 0x60 bypass context. Never take over active legacy/MCQ queues.
  if (MmioRead32(UFS_CONTROLLER_BASE + UFS_HC_ENABLE_OFFSET) != 1 || !(MmioRead32(UFS_CONTROLLER_BASE + UFS_HC_STATUS_OFFSET) & BIT0) ||
      (MmioRead32(UFS_CONTROLLER_BASE + UFS_MEM_CFG_OFFSET) & UFS_MEM_CFG_MCQ_MODE_SELECT) || MmioRead32(UFS_CONTROLLER_BASE + UFS_HC_UTRLDBR_OFFSET) != 0 ||
      MmioRead32(UFS_CONTROLLER_BASE + UFS_HC_UTMRLDBR_OFFSET) != 0) return EFI_NOT_READY;
  if (MmioRead32(UFS_CONTROLLER_BASE + UFS_HC_CAP_OFFSET) & UFS_HC_CAP_64ADDR) {
    Status = PciIo->Attributes(PciIo, EfiPciIoAttributeOperationEnable,
                             EFI_PCI_IO_ATTRIBUTE_DUAL_ADDRESS_CYCLE, NULL);
    if (EFI_ERROR(Status)) return Status;
  }
  MmioWrite32(UFS_CONTROLLER_BASE + UFS_HC_IE_OFFSET, 0);
  MmioWrite32(UFS_CONTROLLER_BASE + UFS_HC_UTRLRSR_OFFSET, 0);
  MmioWrite32(UFS_CONTROLLER_BASE + UFS_HC_UTMRLRSR_OFFSET, 0);
  MmioWrite32(UFS_CONTROLLER_BASE + UFS_HC_IS_OFFSET, MAX_UINT32);
  MemoryFence();
  // NonDiscoverablePciDeviceDxe does not propagate InitializeController failures. Keep
  // PCI MMIO gated until the inherited controller passes the checks above.
  mControllerReady = TRUE;
  return EFI_SUCCESS;
}

STATIC EFI_STATUS EFIAPI
NotifyPhase(EFI_HANDLE Controller, EDKII_UFS_HC_PLATFORM_CALLBACK_PHASE Type, VOID *Data)
{
  EDKII_UFS_HC_DRIVER_INTERFACE *Interface = Data;
  EFI_STATUS Status;
  if (Controller != mControllerHandle) return EFI_NOT_FOUND;
  if (!mControllerReady) return EFI_NOT_READY;
  if (Type == EdkiiUfsHcPreHce) {
    Status = EldenUfsSaveLink(Interface);
    mInheritedLinkSaved = !EFI_ERROR(Status);
    // A missing HS profile leaves the standard PWM initialization unchanged.
    // Never guess an HS gear when XBL did not provide a usable profile.
  }
  if (Type == EdkiiUfsHcPostLinkStartup) {
    if (mInheritedLinkSaved) {
      Status = EldenUfsRestoreLink(Interface);
      if (EFI_ERROR(Status)) return Status;
    }
    // UfsPassThruDxe publishes ExtScsiPassThru only after initialization
    // completes. Do not publish a second, independently maintained ready flag.
  }
  return EFI_SUCCESS;
}

// Waking XBL's Hibern8 link alone permits NOP but this device rejects the next
// fDeviceInit Query. Use the source driver's normal HCE reset + Link Startup;
// neither PHY reprogramming nor the vendor UFSDxe/HALIOMMU entry is required.
STATIC EDKII_UFS_HC_PLATFORM_PROTOCOL mUfsPlatform = {
  EDKII_UFS_HC_PLATFORM_PROTOCOL_VERSION, NULL, NotifyPhase,
  EdkiiUfsCardRefClkFreqObsolete, FALSE, FALSE
};

STATIC VOID EFIAPI
OnExitBootServices(EFI_EVENT Event, VOID *Context)
{
  (VOID)Event;
  (VOID)Context;
  if (!mControllerReady) return;
  MmioWrite32(UFS_CONTROLLER_BASE + UFS_HC_IE_OFFSET, 0);
  MmioWrite32(UFS_CONTROLLER_BASE + UFS_HC_UTRLRSR_OFFSET, 0);
  MmioWrite32(UFS_CONTROLLER_BASE + UFS_HC_UTMRLRSR_OFFSET, 0);
  MemoryFence();
}

EFI_STATUS EFIAPI
EldenUfsPlatformEntryPoint(EFI_HANDLE Image, EFI_SYSTEM_TABLE *Table)
{
  EFI_HANDLE Handle = NULL;
  EFI_EVENT Event;
  EFI_STATUS Status;
  (VOID)Image;
  (VOID)Table;
  Status = gBS->InstallProtocolInterface(&Handle, &gEdkiiUfsHcPlatformProtocolGuid,
                                        EFI_NATIVE_INTERFACE, &mUfsPlatform);
  if (EFI_ERROR(Status)) return Status;
  Status = gBS->CreateEventEx(EVT_NOTIFY_SIGNAL, TPL_NOTIFY, OnExitBootServices, NULL,
                             &gEfiEventExitBootServicesGuid, &Event);
  if (!EFI_ERROR(Status)) {
    // Register during DXE. ConnectController invokes InitializeController and the
    // standard UFS platform callbacks, just as for the SD platform driver.
    Status = RegisterNonDiscoverableMmioDevice(3, NonDiscoverableDeviceTypeUfs,
      NonDiscoverableDeviceDmaTypeCoherent, InitializeController, &mControllerHandle, 1,
      (UINTN)UFS_CONTROLLER_BASE, (UINTN)0x4000);
    if (!EFI_ERROR(Status)) return EFI_SUCCESS;
    gBS->CloseEvent(Event);
  }
  gBS->UninstallProtocolInterface(Handle, &gEdkiiUfsHcPlatformProtocolGuid, &mUfsPlatform);
  return Status;
}
