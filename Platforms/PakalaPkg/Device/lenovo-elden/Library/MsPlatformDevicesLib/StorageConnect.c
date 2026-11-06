/** @file
  Connect initialized storage controllers during BDS.
  SPDX-License-Identifier: BSD-2-Clause-Patent
**/
#include <Uefi.h>
#include <Guid/NonDiscoverableDevice.h>
#include <Protocol/NonDiscoverableDevice.h>
#include <Protocol/ScsiIo.h>
#include <Protocol/ScsiPassThruExt.h>
#include <Protocol/DevicePath.h>
#include <Library/BaseMemoryLib.h>
#include <Library/DevicePathLib.h>
#include <Library/UefiBootServicesTableLib.h>
#include "MsPlatformDevicesLib.h"

STATIC VOID
ConnectUfsLuns (EFI_HANDLE Controller)
{
  EFI_HANDLE *Handles;
  EFI_DEVICE_PATH_PROTOCOL *Parent, *Path, *Node;
  EFI_STATUS Status;
  UINTN Count, I, Prefix;
  EFI_EXT_SCSI_PASS_THRU_PROTOCOL *PassThru;

  // Expose ordinary LUNs; PartitionDxe owns partition-table validation.
  gBS->ConnectController(Controller, NULL, NULL, FALSE);
  // An already connected controller need not start another driver. The source
  // UFS driver publishes PassThru only after successful initialization.
  if (EFI_ERROR(gBS->HandleProtocol(Controller, &gEfiExtScsiPassThruProtocolGuid,
                                   (VOID **)&PassThru))) return;
  Parent = DevicePathFromHandle(Controller);
  if (Parent == NULL || !IsDevicePathValid(Parent, 4096)) return;
  Prefix = GetDevicePathSize(Parent) - END_DEVICE_PATH_LENGTH;
  if (Prefix == 0) return;
  Status = gBS->LocateHandleBuffer(ByProtocol, &gEfiScsiIoProtocolGuid, NULL, &Count, &Handles);
  if (EFI_ERROR(Status)) return;
  for (I = 0; I < Count; I++) {
    Path = DevicePathFromHandle(Handles[I]);
    if (Path == NULL || !IsDevicePathValid(Path, 4096) ||
        GetDevicePathSize(Path) <= Prefix + END_DEVICE_PATH_LENGTH ||
        CompareMem(Parent, Path, Prefix) != 0) continue;
    Node = (EFI_DEVICE_PATH_PROTOCOL *)((UINT8 *)Path + Prefix);
    // RPMB and other well-known LUNs must not acquire disk/partition drivers.
    if (DevicePathType(Node) != MESSAGING_DEVICE_PATH || DevicePathSubType(Node) != MSG_UFS_DP ||
        DevicePathNodeLength(Node) != sizeof(UFS_DEVICE_PATH) || ((UFS_DEVICE_PATH *)Node)->Lun >= 8) continue;
    gBS->ConnectController(Handles[I], NULL, NULL, TRUE);
  }
  gBS->FreePool(Handles);
}

VOID
EldenConnectStorage (VOID)
{
  EFI_HANDLE *Handles = NULL;
  UINTN HandleCount = 0;
  EFI_STATUS Status;
  NON_DISCOVERABLE_DEVICE *Device;

  Status = gBS->LocateHandleBuffer(ByProtocol, &gEdkiiNonDiscoverableDeviceProtocolGuid,
                                  NULL, &HandleCount, &Handles);
  if (!EFI_ERROR(Status)) {
    UINTN I;
    for (I = 0; I < HandleCount; I++) {
      Status = gBS->HandleProtocol(Handles[I], &gEdkiiNonDiscoverableDeviceProtocolGuid,
                                   (VOID **)&Device);
      if (EFI_ERROR(Status) || Device == NULL || Device->Type == NULL) continue;
      if (CompareGuid(Device->Type, &gEdkiiNonDiscoverableUfsDeviceGuid)) {
        ConnectUfsLuns(Handles[I]);
      } else if (CompareGuid(Device->Type, &gEdkiiNonDiscoverableSdhciDeviceGuid)) {
        // Standard recursion connects the SD bus, card, partitions and filesystems.
        gBS->ConnectController(Handles[I], NULL, NULL, TRUE);
      }
    }
  }
  if (Handles != NULL) gBS->FreePool(Handles);
}
