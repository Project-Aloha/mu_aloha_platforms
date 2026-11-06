// SPDX-License-Identifier: BSD-2-Clause-Patent
// Restore the XBL link profile after the standard UFS controller reset.
#include <Uefi.h>
#include <IndustryStandard/UfsHci.h>
#include <Library/TimerLib.h>
#include "UfsLink.h"

#define PA_ACTIVETXDATALANES 0x1560
#define PA_TXGEAR           0x1568
#define PA_TXTERMINATION    0x1569
#define PA_HSSERIES         0x156a
#define PA_PWRMODE          0x1571
#define PA_ACTIVERXDATALANES 0x1580
#define PA_RXGEAR           0x1583
#define PA_RXTERMINATION    0x1584
#define UFS_IS_UPMS         BIT4
#define UFS_HCS_UPMCRS_MASK (BIT8 | BIT9 | BIT10)
#define UFS_HCS_PWR_LOCAL   BIT8

typedef enum {
  LinkRxGear,
  LinkRxLanes,
  LinkRxTermination,
  LinkTxGear,
  LinkTxLanes,
  LinkTxTermination,
  LinkHsSeries,
  LinkAttributeCount
} UFS_LINK_ATTRIBUTE_INDEX;

// Use the same named fields when saving, validating and restoring the profile.
STATIC CONST UINT16 mLinkAttributes[LinkAttributeCount] = {
  [LinkRxGear]        = PA_RXGEAR,
  [LinkRxLanes]       = PA_ACTIVERXDATALANES,
  [LinkRxTermination] = PA_RXTERMINATION,
  [LinkTxGear]        = PA_TXGEAR,
  [LinkTxLanes]       = PA_ACTIVETXDATALANES,
  [LinkTxTermination] = PA_TXTERMINATION,
  [LinkHsSeries]      = PA_HSSERIES
};
STATIC UINT32 mInheritedAttributes[ARRAY_SIZE(mLinkAttributes)], mInheritedPowerMode;
STATIC BOOLEAN mLinkProfileValid;

STATIC EFI_STATUS
AccessUicAttribute(EDKII_UFS_HC_DRIVER_INTERFACE *Interface, BOOLEAN Write,
          UINT16 Id, UINT32 *Value)
{
  EDKII_UIC_COMMAND Command;
  EFI_STATUS Status;

  Command.Opcode = Write ? UfsUicDmeSet : UfsUicDmeGet;
  Command.Arg1 = (UINT32)Id << 16;
  Command.Arg2 = 0;
  Command.Arg3 = Write ? *Value : 0;
  Status = Interface->UfsExecUicCommand(Interface, &Command);
  if (!EFI_ERROR(Status) && !Write) *Value = Command.Arg3;
  return Status;
}

EFI_STATUS
EldenUfsSaveLink(EDKII_UFS_HC_DRIVER_INTERFACE *Interface)
{
  EFI_STATUS Status;
  UINTN I;

  mLinkProfileValid = FALSE;
  if (Interface == NULL || Interface->UfsExecUicCommand == NULL) return EFI_INVALID_PARAMETER;
  Status = AccessUicAttribute(Interface, FALSE, PA_PWRMODE, &mInheritedPowerMode);
  if (EFI_ERROR(Status)) return Status;
  // Only reuse a negotiated HS profile. Never infer a target from the device's
  // maximum gear: the inherited PHY calibration and clocks must also match.
  if (((mInheritedPowerMode >> 4) != 1 && (mInheritedPowerMode >> 4) != 4) ||
      ((mInheritedPowerMode & 15) != 1 && (mInheritedPowerMode & 15) != 4)) return EFI_UNSUPPORTED;
  for (I = 0; I < ARRAY_SIZE(mLinkAttributes); I++) {
    Status = AccessUicAttribute(Interface, FALSE, mLinkAttributes[I], &mInheritedAttributes[I]);
    if (EFI_ERROR(Status)) return Status;
  }
  if (mInheritedAttributes[LinkRxGear] == 0 || mInheritedAttributes[LinkRxGear] > 5 ||
      mInheritedAttributes[LinkTxGear] == 0 || mInheritedAttributes[LinkTxGear] > 5 ||
      mInheritedAttributes[LinkRxLanes] == 0 || mInheritedAttributes[LinkRxLanes] > 2 ||
      mInheritedAttributes[LinkTxLanes] == 0 || mInheritedAttributes[LinkTxLanes] > 2 ||
      mInheritedAttributes[LinkRxTermination] != 1 || mInheritedAttributes[LinkTxTermination] != 1 ||
      (mInheritedAttributes[LinkHsSeries] != 1 && mInheritedAttributes[LinkHsSeries] != 2)) return EFI_UNSUPPORTED;
  mLinkProfileValid = TRUE;
  return EFI_SUCCESS;
}

EFI_STATUS
EldenUfsRestoreLink(EDKII_UFS_HC_DRIVER_INTERFACE *Interface)
{
  EDKII_UFS_HOST_CONTROLLER_PROTOCOL *HostController;
  EFI_STATUS Status;
  UINT32 Value, PowerResult;
  UINTN I;

  if (Interface == NULL || Interface->UfsExecUicCommand == NULL) return EFI_INVALID_PARAMETER;
  HostController = Interface->UfsHcProtocol;
  if (HostController == NULL || HostController->Read == NULL || HostController->Write == NULL)
    return EFI_INVALID_PARAMETER;
  if (!mLinkProfileValid) return EFI_NOT_READY;
  // HCE reset + Link Startup is needed for this device's fDeviceInit sequence,
  // but it also drops the link to PWM G1. Restore only XBL's negotiated link
  // settings, keeping its board-specific PHY, reference clock and supplies.
  // Otherwise metadata scanning and loading the kernel/initrd run at PWM speed.
  for (I = 0; I < ARRAY_SIZE(mLinkAttributes); I++) {
    Value = mInheritedAttributes[I];
    Status = AccessUicAttribute(Interface, TRUE, mLinkAttributes[I], &Value);
    if (EFI_ERROR(Status)) return Status;
  }
  Value = UFS_IS_UPMS;
  Status = HostController->Write(HostController, EfiUfsHcWidthUint32, UFS_HC_IS_OFFSET, 1, &Value);
  if (EFI_ERROR(Status)) return Status;
  Value = mInheritedPowerMode;
  Status = AccessUicAttribute(Interface, TRUE, PA_PWRMODE, &Value);
  if (EFI_ERROR(Status)) return Status;
  // UIC command acceptance is not power-change completion. Wait for UPMS and
  // check the local result before permitting block I/O on the new link.
  for (I = 0; I < 1000000; I++) {
    Status = HostController->Read(HostController, EfiUfsHcWidthUint32, UFS_HC_IS_OFFSET, 1, &Value);
    if (EFI_ERROR(Status)) return Status;
    if (Value & UFS_IS_UPMS) break;
    MicroSecondDelay(1);
  }
  if (I == 1000000) return EFI_TIMEOUT;
  Status = HostController->Read(HostController, EfiUfsHcWidthUint32, UFS_HC_STATUS_OFFSET, 1, &PowerResult);
  if (EFI_ERROR(Status)) return Status;
  Value = UFS_IS_UPMS;
  Status = HostController->Write(HostController, EfiUfsHcWidthUint32, UFS_HC_IS_OFFSET, 1, &Value);
  if (EFI_ERROR(Status)) return Status;
  if ((PowerResult & UFS_HCS_UPMCRS_MASK) != UFS_HCS_PWR_LOCAL) return EFI_DEVICE_ERROR;
  for (I = 0; I < ARRAY_SIZE(mLinkAttributes); I++) {
    Status = AccessUicAttribute(Interface, FALSE, mLinkAttributes[I], &Value);
    if (EFI_ERROR(Status)) return Status;
    if (Value != mInheritedAttributes[I]) return EFI_DEVICE_ERROR;
  }
  Status = AccessUicAttribute(Interface, FALSE, PA_PWRMODE, &Value);
  if (EFI_ERROR(Status)) return Status;
  return Value == mInheritedPowerMode ? EFI_SUCCESS : EFI_DEVICE_ERROR;
}
