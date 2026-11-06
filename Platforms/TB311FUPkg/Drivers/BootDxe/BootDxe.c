// SPDX-License-Identifier: BSD-2-Clause-Patent
#include <Uefi.h>
#include <Protocol/Bds.h>
#include <Protocol/SimpleTextOut.h>
#include <Protocol/SimpleTextIn.h>
#include <Protocol/FirmwareVolume2.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Library/DxeServicesTableLib.h>
#include <Library/DevicePathLib.h>
#include <Library/MemoryAllocationLib.h>
#include <Library/BaseLib.h>
STATIC EFI_HANDLE mImage;
STATIC VOID EFIAPI Boot (EFI_BDS_ARCH_PROTOCOL *This) {
  EFI_HANDLE *Handles, Shell;
  UINTN Count,I;
  EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL *Out;
  EFI_SIMPLE_TEXT_INPUT_PROTOCOL *In;
  EFI_DEVICE_PATH_PROTOCOL *Path;
  MEDIA_FW_VOL_FILEPATH_DEVICE_PATH File;
  EFI_STATUS Status;
  EFI_GUID ShellGuid = {0x7c04a583,0x9e3e,0x4f1c,{0xad,0x65,0xe0,0x52,0x68,0xd0,0xb4,0xd1}};
  (VOID)This;
  // UEFI consumers retain this string after ExitBootServices.
  gST->FirmwareVendor=AllocateRuntimeCopyPool(sizeof(L"Lenovo TB311FU experimental"),L"Lenovo TB311FU experimental");
  gST->FirmwareRevision=1;
  while (!EFI_ERROR(gDS->Dispatch())) {}
  // GOP is an output controller; connecting it starts GraphicsConsoleDxe.
  if (!EFI_ERROR(gBS->LocateHandleBuffer(AllHandles,NULL,NULL,&Count,&Handles))) {
    for (I=0;I<Count;++I) gBS->ConnectController(Handles[I],NULL,NULL,TRUE);
    FreePool(Handles);
  }
  if (!EFI_ERROR(gBS->LocateHandleBuffer(ByProtocol,&gEfiSimpleTextOutProtocolGuid,NULL,&Count,&Handles))) {
    for (I=0;I<Count;++I) {
      if (EFI_ERROR(gBS->HandleProtocol(Handles[I],&gEfiSimpleTextOutProtocolGuid,(VOID **)&Out))) continue;
      gST->ConOut=Out; gST->ConsoleOutHandle=Handles[I];
      gST->StdErr=Out; gST->StandardErrorHandle=Handles[I];
      gST->Hdr.CRC32=0;
      gBS->CalculateCrc32(gST,gST->Hdr.HeaderSize,&gST->Hdr.CRC32);
      Out->Reset(Out,FALSE);
      Out->OutputString(Out,L"Lenovo TB311FU - UEFI bring-up\r\nRAM 256 MiB / GOP LK / Shell\r\n");
      // Prefer the duplex USB console for the Shell; still show the GOP banner.
      if (!EFI_ERROR(gBS->HandleProtocol(Handles[I],&gEfiSimpleTextInProtocolGuid,(VOID **)&In))) {
        gST->ConIn=In; gST->ConsoleInHandle=Handles[I];
        break;
      }
    }
    FreePool(Handles);
    gST->Hdr.CRC32=0;
    gBS->CalculateCrc32(gST,gST->Hdr.HeaderSize,&gST->Hdr.CRC32);
  }
  if (gST->ConOut!=NULL) gST->ConOut->OutputString(gST->ConOut,L"BDS: locating Shell\r\n");
  Status=EFI_NOT_FOUND;
  if (!EFI_ERROR(gBS->LocateHandleBuffer(ByProtocol,&gEfiFirmwareVolume2ProtocolGuid,NULL,&Count,&Handles))) {
    for (I=0;I<Count;++I) {
      File.Header.Type=MEDIA_DEVICE_PATH;
      File.Header.SubType=MEDIA_PIWG_FW_FILE_DP;
      SetDevicePathNodeLength(&File.Header,sizeof(File));
      File.FvFileName=ShellGuid;
      Path=AppendDevicePathNode(DevicePathFromHandle(Handles[I]),&File.Header);
      if (Path==NULL) continue;
      if (gST->ConOut!=NULL) gST->ConOut->OutputString(gST->ConOut,L"BDS: loading Shell\r\n");
      Status=gBS->LoadImage(FALSE,mImage,Path,NULL,0,&Shell);
      FreePool(Path);
      if (!EFI_ERROR(Status)) {
        if (gST->ConOut!=NULL) gST->ConOut->OutputString(gST->ConOut,L"BDS: starting Shell\r\n");
        Status=gBS->StartImage(Shell,NULL,NULL); break;
      }
    }
    FreePool(Handles);
  }
  if (gST->ConOut!=NULL) gST->ConOut->OutputString(gST->ConOut,L"Shell retornou ou falhou. Reinicie pelo botao Power.\r\n");
  for (;;) gBS->Stall(1000000);
}
STATIC EFI_BDS_ARCH_PROTOCOL mBds={Boot};
EFI_STATUS EFIAPI BootEntry(EFI_HANDLE Image,EFI_SYSTEM_TABLE *SystemTable) {
  EFI_HANDLE Handle=NULL;
  (VOID)SystemTable;
  mImage=Image;
  return gBS->InstallMultipleProtocolInterfaces(&Handle,&gEfiBdsArchProtocolGuid,&mBds,NULL);
}
