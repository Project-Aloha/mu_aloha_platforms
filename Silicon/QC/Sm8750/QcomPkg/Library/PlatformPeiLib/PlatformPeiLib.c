/** @file

  Copyright (c) 2011-2014, ARM Limited. All rights reserved.
  Copyright (c) 2014, Linaro Limited. All rights reserved.
  Copyright (c) 2023, DuoWoA Authors. All rights reserved.

  SPDX-License-Identifier: BSD-2-Clause-Patent

  Expose the configuration and serial-library interfaces consumed by Qualcomm
  firmware services during DXE.

**/

#include <PiPei.h>

#include <Library/BaseLib.h>
#include <Library/ConfigurationMapHelperLib.h>
#include <Library/HobLib.h>
#include <Library/MemoryMapHelperLib.h>
#include <Library/PcdLib.h>
#include <Library/SecProtocolFinderLib.h>
#include <Library/SerialPortLib.h>
#include <Library/PlatformHobs.h>

STATIC
EFI_STATUS
GetMemoryInfoByName(
    CHAR8 *RegionName, ARM_MEMORY_REGION_DESCRIPTOR_EX *MemRegions)
{
  return LocateMemoryMapAreaByName(RegionName, MemRegions);
}

STATIC
EFI_STATUS
GetMemoryInfoByAddress(
    UINT64 RegionBaseAddress, ARM_MEMORY_REGION_DESCRIPTOR_EX *MemRegions)
{
  return LocateMemoryMapAreaByAddress(RegionBaseAddress, MemRegions);
}

STATIC
EFI_STATUS
GetConfigString(CHAR8 *Key, CHAR8 *Value, UINTN *ValBuffSize)
{
  CONST CHAR8 OsType[] = "WP";
  RETURN_STATUS Status;

  if (Key == NULL || ValBuffSize == NULL) {
    return EFI_INVALID_PARAMETER;
  }
  if (AsciiStriCmp(Key, "OsTypeString") != 0) {
    return EFI_NOT_FOUND;
  }
  // Report the required byte count, including NUL, without attempting a copy.
  if (Value == NULL || *ValBuffSize < sizeof(OsType)) {
    *ValBuffSize = sizeof(OsType);
    return EFI_BUFFER_TOO_SMALL;
  }
  Status = AsciiStrCpyS(Value, *ValBuffSize, OsType);
  if (RETURN_ERROR(Status)) {
    return (EFI_STATUS)Status;
  }
  *ValBuffSize = sizeof(OsType);
  return EFI_SUCCESS;
}

STATIC
EFI_STATUS
GetConfigUint32(CHAR8 *Key, UINT32 *Value)
{
  return LocateConfigurationMapUINT32ByName(Key, Value);
}

STATIC
EFI_STATUS
GetConfigUint64(CHAR8 *Key, UINT64 *Value)
{
  return LocateConfigurationMapUINT64ByName(Key, Value);
}

// The shim keeps no separate serial queues; there are no bytes to flush.
STATIC
UINTN
SerialFlush(VOID) { return 0; }

STATIC
UINTN
SerialControl(IN UINTN Arg, IN UINTN Param)
{
  (VOID)Arg;
  (VOID)Param;
  // No shim-specific serial control commands are implemented.
  return EFI_UNSUPPORTED;
}

STATIC
UINTN
SerialDrain(VOID) { return 0; }

STATIC
EFI_STATUS
InstallXblLibrary(IN CHAR8 *LibName, IN UINT32 LibVersion, IN VOID *LibIntf)
{
  (VOID)LibVersion;
  if (LibName == NULL || LibIntf == NULL) {
    return EFI_INVALID_PARAMETER;
  }
  // The loader exposes fixed library instances, not a runtime registry.
  return EFI_UNSUPPORTED;
}

STATIC UefiCfgLibType mConfigLibrary = {0x00010002,          GetMemoryInfoByName,
                            GetConfigString, GetConfigUint32,
                            GetConfigUint64,  GetMemoryInfoByAddress};

STATIC SioPortLibType mSerialPortLibrary = {
    0x00010001, SerialPortRead, SerialPortWrite, SerialPortPoll,
    SerialDrain,     SerialFlush,         SerialControl,        SerialPortSetAttributes,
};

STATIC
EFI_STATUS
LoadXblLibrary(CHAR8 *LibName, UINT32 LibVersion, VOID **LibIntf)
{
  if (LibIntf == NULL)
    return EFI_INVALID_PARAMETER;
  *LibIntf = NULL;
  if (LibName == NULL)
    return EFI_INVALID_PARAMETER;

  if (AsciiStriCmp(LibName, "UEFI Config Lib") == 0) {
    *LibIntf = &mConfigLibrary;
    return EFI_SUCCESS;
  }

  if (AsciiStriCmp(LibName, "SerialPort Lib") == 0) {
    *LibIntf = &mSerialPortLibrary;
    return EFI_SUCCESS;
  }

  return EFI_NOT_FOUND;
}

STATIC ShLibLoaderType mLibraryLoader = {0x00010001, InstallXblLibrary, LoadXblLibrary};

STATIC
VOID BuildMemHobForFv(VOID)
{
  EFI_PEI_HOB_POINTERS      HobPtr;
  EFI_HOB_FIRMWARE_VOLUME2 *Hob = NULL;

  HobPtr.Raw = GetHobList();
  while ((HobPtr.Raw = GetNextHob(EFI_HOB_TYPE_FV2, HobPtr.Raw)) != NULL) {
    Hob = HobPtr.FirmwareVolume2;
    /* Build memory allocation HOB to mark it as BootServicesData */
    BuildMemoryAllocationHob(
        Hob->BaseAddress, EFI_SIZE_TO_PAGES(Hob->Length) * EFI_PAGE_SIZE,
        EfiBootServicesData);
    HobPtr.Raw = GET_NEXT_HOB(HobPtr);
  }
}

STATIC GUID mInfoBlockHobGuid   = EFI_INFORMATION_BLOCK_GUID;
STATIC GUID mFvDecompressHobGuid = EFI_FV_DECOMPRESS_GUID;
STATIC GUID mLibraryLoaderHobGuid     = EFI_SHIM_LIBRARY_GUID;

STATIC EFI_STATUS
InstallPlatformHob(VOID)
{
  STATIC BOOLEAN Initialized;
  ARM_MEMORY_REGION_DESCRIPTOR_EX InfoBlock;
  EFI_STATUS Status;
  UINTN FvBaseAddress;
  UINTN InfoBlockAddress;
  UINTN LibraryLoaderAddress = (UINTN)&mLibraryLoader;
  UINTN SchedulerInterface = 0;
  UINTN DtbExtensionProtocol = 0;

  if (Initialized) return EFI_SUCCESS;
  Status = LocateMemoryMapAreaByName("Info Blk", &InfoBlock);
  if (EFI_ERROR(Status)) return Status;
  FvBaseAddress = (UINTN)PcdGet64(PcdFvBaseAddress);
  InfoBlockAddress = InfoBlock.Address;

  // Vendor libraries still consume these inherited interfaces in single-core boot.
  InitProtocolFinder(&SchedulerInterface, &DtbExtensionProtocol);
  BuildMemHobForFv();
  BuildGuidDataHob(
      &mInfoBlockHobGuid, &InfoBlockAddress, sizeof(InfoBlockAddress));
  BuildGuidDataHob(&mLibraryLoaderHobGuid, &LibraryLoaderAddress, sizeof(LibraryLoaderAddress));
  BuildGuidDataHob(&mFvDecompressHobGuid, &FvBaseAddress, sizeof(FvBaseAddress));
  BuildGuidDataHob(&gEfiSchedIntfGuid, &SchedulerInterface, sizeof(SchedulerInterface));
  BuildGuidDataHob(&gEfiSecDtbGuid, &DtbExtensionProtocol, sizeof(DtbExtensionProtocol));

  Initialized = TRUE;
  return EFI_SUCCESS;
}

EFI_STATUS
EFIAPI
PlatformPeim(VOID)
{

  BuildFvHob(PcdGet64(PcdFvBaseAddress), PcdGet32(PcdFvSize));

  return InstallPlatformHob();
}
