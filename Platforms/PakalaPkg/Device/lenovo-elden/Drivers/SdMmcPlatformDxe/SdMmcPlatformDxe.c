// SPDX-License-Identifier: BSD-2-Clause-Patent
// Lenovo Y700 Gen4 SDCC2: source SDHCI/ADMA, without vendor SDCC execution.
#include <PiDxe.h>
#include <Guid/EventGroup.h>
#include <Protocol/PciIo.h>
#include <Protocol/SdMmcOverride.h>
#include <Library/BaseLib.h>
#include <Library/IoLib.h>
#include <Library/NonDiscoverableDeviceRegistrationLib.h>
#include <Library/TimerLib.h>
#include <Library/UefiBootServicesTableLib.h>
#include "SdPower.h"

#define SDCC2_CONTROLLER_BASE 0x08804000
#define SDCC2_PAD_CONTROL  0x0f1db000
#define SDCC2_CARD_DETECT_INPUT   0x0f137004

// Qualcomm Clock protocol entry points used to configure SDCC2.
typedef EFI_STATUS (EFIAPI *ELDEN_CLOCK_GET_ID)(VOID *, CONST CHAR8 *, UINTN *);
typedef EFI_STATUS (EFIAPI *ELDEN_CLOCK_ENABLE)(VOID *, UINTN);
typedef EFI_STATUS (EFIAPI *ELDEN_CLOCK_SET_FREQUENCY)(VOID *, UINTN, UINT32, UINT32, UINT32 *);
typedef struct {
  UINT64 Version;
  ELDEN_CLOCK_GET_ID GetId;
  ELDEN_CLOCK_ENABLE Enable;
  VOID *Disable;
  VOID *IsEnabled;
  VOID *IsOn;
  ELDEN_CLOCK_SET_FREQUENCY SetFrequency;
} ELDEN_CLOCK_PROTOCOL;

STATIC EFI_GUID mClockProtocolGuid = {0x241afae6,0x885f,0x4f6c,{0xa7,0xea,0xc2,0x8e,0xab,0x79,0xc3,0xe5}};
STATIC EFI_HANDLE mControllerHandle;
STATIC EFI_PCI_IO_PROTOCOL_IO_MEM mOriginalMemRead;
STATIC EFI_PCI_IO_PROTOCOL_IO_MEM mOriginalMemWrite;
STATIC BOOLEAN mControllerReady;
STATIC UINT32 mBaseClockHz;
STATIC EFI_STATUS mInitializationStatus = EFI_NOT_READY;

STATIC VOID
AcknowledgePowerEvent(VOID)
{
  UINT32 PendingEvents = MmioRead32(SDCC2_CONTROLLER_BASE + 0x240) & 15;
  UINT32 Acknowledgement = 0;
  UINTN I;
  if (PendingEvents == 0) return;
  for (I = 0; I < 10; I++) {
    MmioWrite32(SDCC2_CONTROLLER_BASE + 0x248, PendingEvents);
    if ((MmioRead32(SDCC2_CONTROLLER_BASE + 0x240) & PendingEvents) == 0) break;
    MicroSecondDelay(10);
  }
  // Rails remain at 2.96V; low-voltage signaling is not advertised.
  if ((PendingEvents & 3) != 0) Acknowledgement |= BIT0;
  if ((PendingEvents & 12) != 0) Acknowledgement |= BIT2;
  MmioWrite32(SDCC2_CONTROLLER_BASE + 0x24c, Acknowledgement);
}

STATIC EFI_STATUS EFIAPI
ReadControllerMemory(EFI_PCI_IO_PROTOCOL *This, EFI_PCI_IO_PROTOCOL_WIDTH Width, UINT8 Bar,
         UINT64 Offset, UINTN Count, VOID *Data)
{
  EFI_STATUS Status;
  if (!mControllerReady) return EFI_NOT_READY;
  AcknowledgePowerEvent();
  Status = mOriginalMemRead(This, Width, Bar, Offset, Count, Data);
  if (!EFI_ERROR(Status) && Offset == 0x24 && Width == EfiPciIoWidthUint32 && Count == 1) {
    // Card-detect uses TLMM GPIO55, not the SDHCI controller's unwired CD pin.
    *(UINT32 *)Data &= ~(BIT16 | BIT17 | BIT18);
    *(UINT32 *)Data |= BIT17;
    if ((MmioRead32(SDCC2_CARD_DETECT_INPUT) & 1) != 0) *(UINT32 *)Data |= BIT16 | BIT18;
  }
  return Status;
}

STATIC EFI_STATUS EFIAPI
WriteControllerMemory(EFI_PCI_IO_PROTOCOL *This, EFI_PCI_IO_PROTOCOL_WIDTH Width, UINT8 Bar,
          UINT64 Offset, UINTN Count, VOID *Data)
{
  EFI_STATUS Status;
  if (!mControllerReady) return EFI_NOT_READY;
  Status = mOriginalMemWrite(This, Width, Bar, Offset, Count, Data);
  AcknowledgePowerEvent();
  return Status;
}

STATIC EFI_STATUS EFIAPI
InitializeController(NON_DISCOVERABLE_DEVICE *Device)
{
  EFI_PCI_IO_PROTOCOL *PciIo;
  ELDEN_CLOCK_PROTOCOL *Clock = NULL;
  UINTN AhbClockId = 0, AppsClockId = 0;
  EFI_STATUS Status;
  (VOID)Device;
  Status = gBS->HandleProtocol(mControllerHandle, &gEfiPciIoProtocolGuid, (VOID **)&PciIo);
  if (EFI_ERROR(Status)) return Status;
  // Reuse the result only for this wrapped PCI I/O instance. On reconnect,
  // gate the new instance until setup succeeds; stale readiness must not let
  // register accesses through after a clock or power initialization failure.
  if (PciIo->Mem.Read == ReadControllerMemory) return mInitializationStatus;
  mControllerReady = FALSE;
  mOriginalMemRead = PciIo->Mem.Read;
  mOriginalMemWrite = PciIo->Mem.Write;
  PciIo->Mem.Read = ReadControllerMemory;
  PciIo->Mem.Write = WriteControllerMemory;
  Status = gBS->LocateProtocol(&mClockProtocolGuid, NULL, (VOID **)&Clock);
  if (EFI_ERROR(Status)) goto Done;
  if (Clock == NULL || Clock->Version != 0x1000b) { Status = EFI_UNSUPPORTED; goto Done; }
  Status = Clock->GetId(Clock, "gcc_sdcc2_ahb_clk", &AhbClockId);
  if (EFI_ERROR(Status)) goto Done;
  Status = Clock->GetId(Clock, "gcc_sdcc2_apps_clk", &AppsClockId);
  if (EFI_ERROR(Status)) goto Done;
  Status = Clock->Enable(Clock, AhbClockId);
  if (EFI_ERROR(Status)) goto Done;
  Status = Clock->SetFrequency(Clock, AppsClockId, 50000000, 3, &mBaseClockHz);
  if (EFI_ERROR(Status)) goto Done;
  if (mBaseClockHz != 50000000) { Status = EFI_UNSUPPORTED; goto Done; }
  Status = Clock->Enable(Clock, AppsClockId);
  if (EFI_ERROR(Status)) goto Done;
  Status = EldenSdEnablePower();
  if (EFI_ERROR(Status)) goto Done;
  MmioWrite32(SDCC2_PAD_CONTROL, 0x1e92);
  MmioWrite32(SDCC2_CONTROLLER_BASE + 0x20c, 0xa9c | BIT15);
  MmioWrite32(SDCC2_CONTROLLER_BASE + 0x244, 0);
  MmioWrite32(SDCC2_CONTROLLER_BASE + 0x248, 15);
  mControllerReady = TRUE;
Done:
  mInitializationStatus = Status;
  return Status;
}

STATIC EFI_STATUS EFIAPI
OverrideCapabilities(EFI_HANDLE Controller, UINT8 Slot, VOID *Data, UINT32 *BaseClockMHz)
{
  if (Controller != mControllerHandle || Slot != 0) return EFI_NOT_FOUND;
  if (Data == NULL || BaseClockMHz == NULL) return EFI_INVALID_PARAMETER;
  if (EFI_ERROR(mInitializationStatus)) return mInitializationStatus;
  // Fail instead of silently selecting PIO if the ADMA capability is absent.
  if ((*(UINT64 *)Data & BIT19) == 0) return EFI_UNSUPPORTED;
  // Keep ADMA2 and 64-bit DMA. Only 3V SD modes are supported by this power path.
  *(UINT64 *)Data &= ~(BIT18 | BIT24 | BIT26 | BIT30 | BIT31 | BIT32 | BIT33 | BIT34);
  *(UINT64 *)Data |= BIT25;
  *BaseClockMHz = mBaseClockHz / 1000000;
  return EFI_SUCCESS;
}

STATIC EFI_STATUS EFIAPI
NotifyPhase(EFI_HANDLE Controller, UINT8 Slot, EDKII_SD_MMC_PHASE_TYPE Type, VOID *Data)
{
  if (Controller != mControllerHandle || Slot != 0) return EFI_NOT_FOUND;
  if ((UINT32)Type > EdkiiSdMmcGetOperatingParam ||
      (Type == EdkiiSdMmcGetOperatingParam && Data == NULL)) return EFI_INVALID_PARAMETER;
  if (EFI_ERROR(mInitializationStatus)) return mInitializationStatus;
  if (Type == EdkiiSdMmcGetOperatingParam) {
    EDKII_SD_MMC_OPERATING_PARAMETERS *Parameters = Data;
    Parameters->BusWidth = 4;
    Parameters->ClockFreq = 25;
    Parameters->DriverStrength.Sd = SdDriverStrengthTypeB;
  }
  return EFI_SUCCESS;
}

STATIC EDKII_SD_MMC_OVERRIDE mSdMmcOverride = {
  EDKII_SD_MMC_OVERRIDE_PROTOCOL_VERSION, OverrideCapabilities, NotifyPhase
};

STATIC VOID EFIAPI
OnExitBootServices(EFI_EVENT Event, VOID *Context)
{
  UINTN I;
  (VOID)Event;
  (VOID)Context;
  if (!mControllerReady) return;
  // Stop this controller before Linux reuses DMA buffers; do not touch shared SMMU state.
  MmioWrite32(SDCC2_CONTROLLER_BASE + 0x38, 0);
  MmioWrite8(SDCC2_CONTROLLER_BASE + 0x2f, BIT1 | BIT2);
  for (I = 0; I < 1000 && MmioRead8(SDCC2_CONTROLLER_BASE + 0x2f) != 0; I++) MicroSecondDelay(10);
  MmioAnd16(SDCC2_CONTROLLER_BASE + 0x2c, (UINT16)~BIT2);
  MmioWrite32(SDCC2_CONTROLLER_BASE + 0x30, MAX_UINT32);
  MemoryFence();
}

EFI_STATUS EFIAPI
EldenSdMmcPlatformEntryPoint(EFI_HANDLE Image, EFI_SYSTEM_TABLE *Table)
{
  EFI_HANDLE Handle = NULL;
  EFI_EVENT Event;
  EFI_STATUS Status;
  (VOID)Image;
  (VOID)Table;
  Status = gBS->InstallProtocolInterface(&Handle, &gEdkiiSdMmcOverrideProtocolGuid,
                                        EFI_NATIVE_INTERFACE, &mSdMmcOverride);
  if (EFI_ERROR(Status)) return Status;
  Status = gBS->CreateEventEx(EVT_NOTIFY_SIGNAL, TPL_NOTIFY, OnExitBootServices, NULL,
                             &gEfiEventExitBootServicesGuid, &Event);
  if (EFI_ERROR(Status)) goto UninstallOverride;
  // SM8750 advertises coherent SDCC2 DMA. Keep the inherited stream bypass;
  // no vendor HALIOMMU attachment is needed for identity-mapped PCI I/O DMA.
  Status = RegisterNonDiscoverableMmioDevice(2, NonDiscoverableDeviceTypeSdhci,
    NonDiscoverableDeviceDmaTypeCoherent, InitializeController, &mControllerHandle, 1, (UINTN)SDCC2_CONTROLLER_BASE, (UINTN)0x1000);
  if (!EFI_ERROR(Status)) return EFI_SUCCESS;
  gBS->CloseEvent(Event);
UninstallOverride:
  // A failed entry unloads this image: do not leave protocol or event callbacks
  // pointing into its freed code. Preserve the original initialization error.
  gBS->UninstallProtocolInterface(Handle, &gEdkiiSdMmcOverrideProtocolGuid, &mSdMmcOverride);
  return Status;
}
