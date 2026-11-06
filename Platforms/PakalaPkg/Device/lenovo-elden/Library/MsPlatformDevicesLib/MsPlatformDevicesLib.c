/** @file
  Console and storage devices for Lenovo Y700 Gen4.
  SPDX-License-Identifier: BSD-2-Clause-Patent
**/
#include <Uefi.h>
#include <Configuration/BootDevices.h>
#include <Guid/OSKDevicePath.h>
#include <Library/DebugLib.h>
#include <Library/DeviceBootManagerLib.h>
#include <Library/DevicePathLib.h>
#include <Library/MsPlatformDevicesLib.h>
#include <Library/UefiBootManagerLib.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Protocol/GraphicsOutput.h>
#include "MsPlatformDevicesLib.h"

typedef struct {
  VENDOR_DEVICE_PATH Vendor;
  EFI_DEVICE_PATH_PROTOCOL End;
} ELDEN_CONSOLE_DEVICE_PATH;

STATIC ELDEN_CONSOLE_DEVICE_PATH mOskDevicePath = {
    {{HARDWARE_DEVICE_PATH, HW_VENDOR_DP, {sizeof(VENDOR_DEVICE_PATH), 0}}, OSK_DEVICE_PATH_GUID},
    {END_DEVICE_PATH_TYPE, END_ENTIRE_DEVICE_PATH_SUBTYPE, {END_DEVICE_PATH_LENGTH, 0}}};
STATIC BDS_CONSOLE_CONNECT_ENTRY mPlatformConsoles[] = {
    {(EFI_DEVICE_PATH_PROTOCOL *)&DisplayDevicePath, CONSOLE_OUT | STD_ERROR},
    {(EFI_DEVICE_PATH_PROTOCOL *)&KeypadDevicePath, CONSOLE_IN},
    {(EFI_DEVICE_PATH_PROTOCOL *)&mOskDevicePath, CONSOLE_IN},
    {NULL, 0}};

EFI_DEVICE_PATH_PROTOCOL *EFIAPI GetSdCardDevicePath(VOID)
{
  return (EFI_DEVICE_PATH_PROTOCOL *)&SdcardDevicePath;
}

BOOLEAN EFIAPI PlatformIsDevicePathUsb(IN EFI_DEVICE_PATH_PROTOCOL *DevicePath)
{
  EFI_DEVICE_PATH_PROTOCOL *Node;

  for (Node = DevicePath; !IsDevicePathEnd(Node); Node = NextDevicePathNode(Node)) {
    if (DevicePathType(Node) == MESSAGING_DEVICE_PATH &&
        (DevicePathSubType(Node) == MSG_USB_CLASS_DP ||
         DevicePathSubType(Node) == MSG_USB_WWID_DP ||
         DevicePathSubType(Node) == MSG_USB_DP)) {
      return TRUE;
    }
  }

  return FALSE;
}

BDS_CONSOLE_CONNECT_ENTRY *EFIAPI GetPlatformConsoleList(VOID)
{
  return mPlatformConsoles;
}

EFI_HANDLE EFIAPI GetPlatformPreferredConsole(OUT EFI_DEVICE_PATH_PROTOCOL **DevicePath)
{
  EFI_STATUS Status;
  EFI_HANDLE Handle = NULL;
  EFI_DEVICE_PATH_PROTOCOL *TempDevicePath;

  *DevicePath = NULL;
  TempDevicePath = (EFI_DEVICE_PATH_PROTOCOL *)&DisplayDevicePath;
  Status = gBS->LocateDevicePath(
      &gEfiGraphicsOutputProtocolGuid, &TempDevicePath, &Handle);
  if (EFI_ERROR(Status) || !IsDevicePathEnd(TempDevicePath)) {
    DEBUG((DEBUG_ERROR, "%a: Unable to locate preferred console: %r\n",
           __FUNCTION__, Status));
    return NULL;
  }

  gBS->ConnectController(Handle, NULL, NULL, TRUE);
  // BDS owns and frees the returned GOP device path.
  *DevicePath = EfiBootManagerGetGopDevicePath(Handle);
  return Handle;
}

EFI_DEVICE_PATH_PROTOCOL **EFIAPI GetPlatformConnectOnConInList(VOID)
{
  return NULL;
}

EFI_DEVICE_PATH_PROTOCOL **EFIAPI GetPlatformConnectList(VOID)
{
  // Connect boot media after console setup. The controller DXE drivers own
  // hardware initialization; keep boot selection in the common BDS policy.
  EldenConnectStorage();
  return NULL;
}
