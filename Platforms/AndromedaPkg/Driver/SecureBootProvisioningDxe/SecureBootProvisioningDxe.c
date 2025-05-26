/** @file SecureBootProvisioningDxe.c

    This file contains functions for provisioning Secure Boot.

    Copyright (C) DuoWoA authors. All rights reserved.
    Copyright (C) Microsoft Corporation. All rights reserved.
    SPDX-License-Identifier: BSD-2-Clause-Patent

**/

#include <Base.h>
#include <Uefi.h>

#include <Pi/PiFirmwareFile.h>

#include <Library/BaseLib.h>
#include <Library/BaseCryptLib.h>
#include <Library/BaseMemoryLib.h>
#include <Library/DebugLib.h>
#include <Library/DxeServicesLib.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Library/UefiDriverEntryPoint.h>
#include <Library/UefiLib.h>
#include <Library/UefiRuntimeServicesTableLib.h>
#include <Library/MemoryAllocationLib.h>
#include <Library/MuSecureBootKeySelectorLib.h>

#include <Guid/GlobalVariable.h>
#include <Guid/FileInfo.h>

//
// Global variables.
//
VOID *mFileSystemRegistration = NULL;

/**
  Helper function to query whether the secure boot variable is in place.
  For Project Mu Code if the PK is set then Secure Boot is enforced (there is no
  SetupMode)

  @retval     TRUE if secure boot is enabled, FALSE otherwise.
**/
BOOLEAN
IsSecureBootOn()
{
#if SECURE_BOOT == 1
  return TRUE;
#else
  EFI_STATUS Status;
  UINTN      PkSize = 0;

  Status = gRT->GetVariable(
      EFI_PLATFORM_KEY_NAME, &gEfiGlobalVariableGuid, NULL, &PkSize, NULL);
  if ((Status == EFI_BUFFER_TOO_SMALL) && (PkSize > 0)) {
    DEBUG(
        (DEBUG_INFO, "%a - PK exists.  Secure boot on.  Pk Size is 0x%X\n",
         __FUNCTION__, PkSize));
    return TRUE;
  }

  DEBUG(
      (DEBUG_INFO, "%a - PK doesn't exist.  Secure boot off\n", __FUNCTION__));
  return FALSE;
#endif
}

EFI_STATUS
EFIAPI
TryWritePlatformSiPolicy(EFI_HANDLE SfsHandle)
{
  EFI_STATUS Status = EFI_SUCCESS;

  EFI_SIMPLE_FILE_SYSTEM_PROTOCOL *EfiSfsProtocol;
  EFI_FILE_PROTOCOL               *FileProtocol;
  EFI_FILE_PROTOCOL               *PayloadFileProtocol;

  EFI_GUID *FileGuid             = NULL;
  UINT8    *mSiPolicyDefault     = NULL;
  UINTN     mSiPolicyDefaultSize = 0;
  UINT8     mSiPolicyDefaultHash[SHA256_DIGEST_SIZE];

  UINT8    *SiPolicyEfiSfs          = NULL;
  UINTN     SiPolicyEfiSfsInfoSize  = 0;
  UINTN     SiPolicyEfiSfsSize      = 0;
  UINT8     SiPolicyEfiSfsHash[SHA256_DIGEST_SIZE];

  FileGuid                       = PcdGetPtr(PcdSystemIntegrityPolicyFile);

  // Get the SiPolicy image from FV.
  //
  Status = GetSectionFromAnyFv(
      FileGuid, EFI_SECTION_RAW, 0, (VOID **)&mSiPolicyDefault,
      &mSiPolicyDefaultSize);

  DEBUG(
      (DEBUG_INFO, "%a: HandleProtocol gEfiSimpleFileSystemProtocolGuid\n",
       __FUNCTION__));

  Status = gBS->HandleProtocol(
      SfsHandle, &gEfiSimpleFileSystemProtocolGuid, (VOID **)&EfiSfsProtocol);

  if (EFI_ERROR(Status)) {
    DEBUG((DEBUG_ERROR, "Failed to invoke HandleProtocol.\n"));
    goto exit;
  }

  DEBUG((DEBUG_INFO, "%a: OpenVolume EfiSfsProtocol\n", __FUNCTION__));

  Status = EfiSfsProtocol->OpenVolume(EfiSfsProtocol, &FileProtocol);

  if (EFI_ERROR(Status)) {
    DEBUG((DEBUG_ERROR, "Fail to get file protocol handle\n"));
    goto exit;
  }

  DEBUG(
      (DEBUG_INFO, "%a: FileProtocol \\EFI\\Microsoft\\Boot\\bootmgfw.efi\n",
       __FUNCTION__));

  Status = FileProtocol->Open(
      FileProtocol, &PayloadFileProtocol,
      L"\\EFI\\Microsoft\\Boot\\bootmgfw.efi", EFI_FILE_MODE_READ,
      EFI_FILE_READ_ONLY | EFI_FILE_HIDDEN | EFI_FILE_SYSTEM);

  if (EFI_ERROR(Status)) {
    DEBUG((DEBUG_INFO, "Failed to open bootmgfw.efi: %r\n", Status));
    goto exit;
  }

  DEBUG(
      (DEBUG_INFO, "%a: Close \\EFI\\Microsoft\\Boot\\bootmgfw.efi\n",
       __FUNCTION__));

  Status = PayloadFileProtocol->Close(PayloadFileProtocol);
  if (EFI_ERROR(Status)) {
    DEBUG((DEBUG_ERROR, "Failed to close bootmgfw.efi: %r\n", Status));
  }

  DEBUG(
      (DEBUG_ERROR, "%a: Open \\EFI\\Microsoft\\Boot\\SiPolicy.p7b\n",
       __FUNCTION__));

  Status = FileProtocol->Open(
      FileProtocol, &PayloadFileProtocol,
      L"\\EFI\\Microsoft\\Boot\\SiPolicy.p7b",
      EFI_FILE_MODE_READ | EFI_FILE_MODE_WRITE, 0);

  if (EFI_ERROR(Status) && Status != EFI_NOT_FOUND) {
    DEBUG((DEBUG_ERROR, "Failed to open SiPolicy.p7b: %r\n", Status));
    goto exit;
  }

  // File already exists. No need to write it again.
  if (Status != EFI_NOT_FOUND) {
    // SecureBoot is off. Delete it.
    if (!IsSecureBootOn()) {
      PayloadFileProtocol->Delete(PayloadFileProtocol);
      Status = EFI_SUCCESS;
      goto exit;
    } else {
      // Get the size of SiPolicy.p7b from the EfiSfs Volume.
      Status = PayloadFileProtocol->GetInfo(
          PayloadFileProtocol, &gEfiFileInfoGuid, &SiPolicyEfiSfsInfoSize, NULL);
    
      if (Status == EFI_BUFFER_TOO_SMALL) {
        EFI_FILE_INFO *FileInfo = AllocatePool(SiPolicyEfiSfsInfoSize);

        Status = PayloadFileProtocol->GetInfo(
            PayloadFileProtocol, &gEfiFileInfoGuid, &SiPolicyEfiSfsInfoSize, FileInfo);
        SiPolicyEfiSfsSize = FileInfo->FileSize;

        if (!EFI_ERROR(Status)) {
            DEBUG((EFI_D_ERROR, "SiPolicyEfiSfsSiz Size: %ld kilobyte \n", SiPolicyEfiSfsSize));
        }
      }

      SiPolicyEfiSfs = AllocatePool(SiPolicyEfiSfsSize);
      Status = PayloadFileProtocol->Read(
          PayloadFileProtocol, &SiPolicyEfiSfsSize, SiPolicyEfiSfs);

      Sha256HashAll(SiPolicyEfiSfs, SiPolicyEfiSfsSize, SiPolicyEfiSfsHash);
      Sha256HashAll(mSiPolicyDefault, mSiPolicyDefaultSize, mSiPolicyDefaultHash);

      // Compare the SiPolicy files to determine whether an update is needed.
      if (CompareMem(SiPolicyEfiSfsHash, mSiPolicyDefaultHash, SHA256_DIGEST_SIZE) == 0) {
        Status = SetSecureBootConfig(0);
        goto exit;
      } else {
        // If an update is required, then delete the original SiPolicy first.
        PayloadFileProtocol->Delete(PayloadFileProtocol);
      }
    }
    // File does not exist, if SB is off, do not add the file.
  } else if (!IsSecureBootOn()) {
      Status = EFI_SUCCESS;
      goto exit;
  }

  Status = FileProtocol->Open(
      FileProtocol, &PayloadFileProtocol,
      L"\\EFI\\Microsoft\\Boot\\SiPolicy.p7b",
      EFI_FILE_MODE_READ | EFI_FILE_MODE_WRITE | EFI_FILE_MODE_CREATE, 0);

  if (EFI_ERROR(Status)) {
    DEBUG((DEBUG_ERROR, "Failed to open SiPolicy.p7b: %r\n", Status));
    goto exit;
  }

  DEBUG(
      (DEBUG_INFO, "%a: Write \\EFI\\Microsoft\\Boot\\SiPolicy.p7b\n",
       __FUNCTION__));

  Status = PayloadFileProtocol->Write(
      PayloadFileProtocol, &mSiPolicyDefaultSize, mSiPolicyDefault);
  if (EFI_ERROR(Status)) {
    DEBUG((DEBUG_ERROR, "Failed to write SiPolicy.p7b: %r\n", Status));
  }

  DEBUG(
      (DEBUG_INFO, "%a: Close \\EFI\\Microsoft\\Boot\\SiPolicy.p7b\n",
       __FUNCTION__));

  Status = PayloadFileProtocol->Close(PayloadFileProtocol);
  if (EFI_ERROR(Status)) {
    DEBUG((DEBUG_ERROR, "Failed to close SiPolicy.p7b: %r\n", Status));
  }

  Status = SetSecureBootConfig(0);

exit:
  return Status;
}

/**
  New File System Discovered.

  Register this device as a possible UEFI Log device.

  @param    Event           Not Used.
  @param    Context         Not Used.

  @retval   none

  This may be called for multiple device arrivals, so the Event is not closed.

**/
VOID EFIAPI OnFileSystemNotification(IN EFI_EVENT Event, IN VOID *Context)
{
  UINTN       HandleCount;
  EFI_HANDLE *HandleBuffer;
  EFI_STATUS  Status;

  DEBUG((DEBUG_INFO, "%a: Entry...\n", __FUNCTION__));

  for (;;) {
    //
    // Get the next handle
    //
    Status = gBS->LocateHandleBuffer(
        ByRegisterNotify, NULL, mFileSystemRegistration, &HandleCount,
        &HandleBuffer);
    //
    // If not found, or any other error, we're done
    //
    if (EFI_ERROR(Status)) {
      break;
    }

    // Spec says we only get one at a time using ByRegisterNotify
    ASSERT(HandleCount == 1);

    DEBUG(
        (DEBUG_INFO, "%a: processing a potential efiesp device on handle %p\n",
         __FUNCTION__, HandleBuffer[0]));

    TryWritePlatformSiPolicy(HandleBuffer[0]);

    FreePool(HandleBuffer);
  }
}

/**
    ProcessFileSystemRegistration

    This function registers for FileSystemProtocols, and then
    checks for any existing FileSystemProtocols, and adds them
    to the LOG_DEVICE list.

    @param       VOID

    @retval      EFI_SUCCESS     FileSystem protocol registration successful
    @retval      error code      Something went wrong.

 **/
EFI_STATUS
ProcessFileSystemRegistration(VOID)
{
  EFI_EVENT  FileSystemCallBackEvent;
  EFI_STATUS Status;

  //
  // Always register for file system notifications.  They may arrive at any
  // time.
  //
  DEBUG((DEBUG_INFO, "Registering for file systems notifications\n"));
  Status = gBS->CreateEvent(
      EVT_NOTIFY_SIGNAL, TPL_CALLBACK, OnFileSystemNotification, NULL,
      &FileSystemCallBackEvent);

  if (EFI_ERROR(Status)) {
    DEBUG(
        (DEBUG_ERROR, "%a: failed to create callback event (%r)\n",
         __FUNCTION__, Status));
    goto Cleanup;
  }

  Status = gBS->RegisterProtocolNotify(
      &gEfiSimpleFileSystemProtocolGuid, FileSystemCallBackEvent,
      &mFileSystemRegistration);

  if (EFI_ERROR(Status)) {
    DEBUG(
        (DEBUG_ERROR,
         "%a: failed to register for file system notifications (%r)\n",
         __FUNCTION__, Status));
    gBS->CloseEvent(FileSystemCallBackEvent);
    goto Cleanup;
  }

  //
  // Process any existing File System that were present before the registration.
  //
  OnFileSystemNotification(FileSystemCallBackEvent, NULL);

Cleanup:
  return Status;
}

EFI_STATUS
EFIAPI
SecureBootProvisioningDxeInitialize(
    IN EFI_HANDLE ImageHandle, IN EFI_SYSTEM_TABLE *SystemTable)
{
  return ProcessFileSystemRegistration();
}