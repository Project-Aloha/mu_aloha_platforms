/** @file
  Acknowledge entry into Aloha BDS to the Lenovo Elden Android bootloader.
  This is independent of the selected EFI application or operating system.
  SPDX-License-Identifier: BSD-2-Clause-Patent
**/
#include <Uefi.h>
#include <Uefi/UefiGpt.h>
#include <Protocol/BlockIo.h>
#include <Protocol/PartitionInfo.h>
#include <Protocol/NonDiscoverableDevice.h>
#include <Protocol/ScsiPassThruExt.h>
#include <Guid/NonDiscoverableDevice.h>
#include <Library/BaseMemoryLib.h>
#include <Library/DevicePathLib.h>
#include <Library/DebugLib.h>
#include <Library/UefiBootServicesTableLib.h>
#include "MsPlatformDevicesLib.h"

// Qualcomm A/B attributes from QcomModulePkg/Include/Library/PartitionTableUpdate.h.
#define SLOT_ACTIVE       BIT50
#define SLOT_SUCCESSFUL   BIT54
#define SLOT_UNBOOTABLE   BIT55
#define GPT_BUFFER_ALIGN  65536

STATIC BOOLEAN mBootAcknowledgementAttempted;

// Resolve an already enumerated GPT partition to its source UFS disk. A name
// on USB/SD or a foreign controller must never authorize an Android slot write.
STATIC EFI_STATUS
GetBootPartitionDisk (EFI_HANDLE Partition, EFI_HANDLE *Disk)
{
  EFI_DEVICE_PATH_PROTOCOL *Path, *Node, *Hd, *Copy, *Remaining;
  EFI_HANDLE Controller;
  NON_DISCOVERABLE_DEVICE *Device;
  EFI_STATUS Status;

  Path = DevicePathFromHandle(Partition);
  if (Path == NULL || !IsDevicePathValid(Path, 4096)) return EFI_NOT_FOUND;
  Node = Path;
  Status = gBS->LocateDevicePath(&gEfiExtScsiPassThruProtocolGuid, &Node, &Controller);
  if (EFI_ERROR(Status)) return EFI_NOT_FOUND;
  // A generic SCSI transport alone is not authority to modify slot metadata.
  // Require the on-board UFS controller described by the platform resources.
  Status = gBS->HandleProtocol(Controller, &gEdkiiNonDiscoverableDeviceProtocolGuid, (VOID **)&Device);
  if (EFI_ERROR(Status) || Device == NULL || Device->Type == NULL ||
      !CompareGuid(Device->Type, &gEdkiiNonDiscoverableUfsDeviceGuid) ||
      Device->Resources == NULL || Device->Resources->Desc != ACPI_ADDRESS_SPACE_DESCRIPTOR ||
      Device->Resources->ResType != ACPI_ADDRESS_SPACE_TYPE_MEM ||
      Device->Resources->AddrRangeMin != 0x01d84000 || Device->Resources->AddrLen != 0x4000)
    return EFI_NOT_FOUND;
  if (DevicePathType(Node) != MESSAGING_DEVICE_PATH || DevicePathSubType(Node) != MSG_UFS_DP ||
      DevicePathNodeLength(Node) != sizeof(UFS_DEVICE_PATH) || ((UFS_DEVICE_PATH *)Node)->Lun >= 8)
    return EFI_NOT_FOUND;
  Hd = NextDevicePathNode(Node);
  if (DevicePathType(Hd) != MEDIA_DEVICE_PATH || DevicePathSubType(Hd) != MEDIA_HARDDRIVE_DP ||
      DevicePathNodeLength(Hd) != sizeof(HARDDRIVE_DEVICE_PATH) ||
      !IsDevicePathEnd(NextDevicePathNode(Hd))) return EFI_NOT_FOUND;
  Copy = DuplicateDevicePath(Path);
  if (Copy == NULL) return EFI_OUT_OF_RESOURCES;
  SetDevicePathEndNode((EFI_DEVICE_PATH_PROTOCOL *)((UINT8 *)Copy + ((UINT8 *)Hd - (UINT8 *)Path)));
  Remaining = Copy;
  Status = gBS->LocateDevicePath(&gEfiBlockIoProtocolGuid, &Remaining, Disk);
  if (!EFI_ERROR(Status) && !IsDevicePathEnd(Remaining)) Status = EFI_NOT_FOUND;
  gBS->FreePool(Copy);
  return Status;
}

STATIC EFI_STATUS
FindAndroidBootDisk (EFI_HANDLE *Disk, EFI_PARTITION_ENTRY BootEntries[2])
{
  EFI_HANDLE *Handles = NULL, Candidate;
  EFI_PARTITION_INFO_PROTOCOL *Info;
  EFI_STATUS Status;
  UINTN Count = 0, I, SlotIndex;
  BOOLEAN Found[2] = { FALSE, FALSE };

  *Disk = NULL;
  Status = gBS->LocateHandleBuffer(ByProtocol, &gEfiPartitionInfoProtocolGuid, NULL, &Count, &Handles);
  if (EFI_ERROR(Status)) return Status;
  Status = EFI_COMPROMISED_DATA;
  if (Count > 512) goto Done;
  for (I = 0; I < Count; I++) {
    if (EFI_ERROR(gBS->HandleProtocol(Handles[I], &gEfiPartitionInfoProtocolGuid, (VOID **)&Info)) ||
        Info == NULL || Info->Type != PARTITION_TYPE_GPT) continue;
    if (CompareMem(Info->Info.Gpt.PartitionName, L"boot_a", sizeof(L"boot_a")) == 0) SlotIndex = 0;
    else if (CompareMem(Info->Info.Gpt.PartitionName, L"boot_b", sizeof(L"boot_b")) == 0) SlotIndex = 1;
    else continue;
    Status = GetBootPartitionDisk(Handles[I], &Candidate);
    if (Status == EFI_NOT_FOUND) continue;
    if (EFI_ERROR(Status)) goto Done;
    Status = EFI_COMPROMISED_DATA;
    if (Found[SlotIndex] || (*Disk != NULL && *Disk != Candidate)) goto Done;
    *Disk = Candidate;
    Found[SlotIndex] = TRUE;
    CopyMem(&BootEntries[SlotIndex], &Info->Info.Gpt, sizeof(BootEntries[SlotIndex]));
  }
  Status = EFI_NOT_FOUND;
  if (Found[0] && Found[1]) Status = EFI_SUCCESS;
Done:
  gBS->FreePool(Handles);
  return Status;
}

// Partition discovery belongs to PartitionDxe. These bounded checks apply only
// to the boot disk immediately before modifying its raw GPT metadata.
STATIC BOOLEAN
IsBootGptHeaderValid (EFI_PARTITION_TABLE_HEADER *Header, EFI_LBA Here, EFI_LBA Other)
{
  UINT32 Saved, Crc;
  EFI_STATUS Status;
  if (Header->Header.Signature != EFI_PTAB_HEADER_ID || Header->Header.Revision != 0x10000 ||
      Header->Header.HeaderSize != sizeof(*Header) || Header->Header.Reserved != 0 ||
      Header->MyLBA != Here || Header->AlternateLBA != Other ||
      Header->FirstUsableLBA > Header->LastUsableLBA ||
      Header->SizeOfPartitionEntry != sizeof(EFI_PARTITION_ENTRY) ||
      Header->NumberOfPartitionEntries == 0 || Header->NumberOfPartitionEntries > 256) return FALSE;
  Saved = Header->Header.CRC32;
  Header->Header.CRC32 = 0;
  Status = gBS->CalculateCrc32(Header, Header->Header.HeaderSize, &Crc);
  Header->Header.CRC32 = Saved;
  return !EFI_ERROR(Status) && Crc == Saved;
}

STATIC EFI_STATUS
WriteAndVerifyBlocks (EFI_BLOCK_IO_PROTOCOL *BlockIo, UINT32 MediaId, EFI_LBA Lba,
                UINTN BufferSize, VOID *Data, VOID *VerifyBuffer)
{
  EFI_STATUS Status;
  Status = BlockIo->WriteBlocks(BlockIo, MediaId, Lba, BufferSize, Data);
  if (EFI_ERROR(Status)) return Status;
  Status = BlockIo->FlushBlocks(BlockIo);
  if (EFI_ERROR(Status)) return Status;
  Status = BlockIo->ReadBlocks(BlockIo, MediaId, Lba, BufferSize, VerifyBuffer);
  if (EFI_ERROR(Status)) return Status;
  return CompareMem(Data, VerifyBuffer, BufferSize) == 0 ? EFI_SUCCESS : EFI_DEVICE_ERROR;
}

VOID
EldenAcknowledgeBoot (VOID)
{
  EFI_HANDLE Disk;
  EFI_BLOCK_IO_PROTOCOL *BlockIo;
  VOID *Allocation = NULL;
  UINT8 *PrimaryBlock, *BackupBlock, *PrimaryEntries, *BackupEntries, *VerifyBuffer;
  EFI_PARTITION_TABLE_HEADER *PrimaryHeader, *BackupHeader;
  EFI_PARTITION_ENTRY BootEntriesSnapshot[2], *PartitionEntries, *ActiveSlot;
  EFI_GUID ZeroGuid = {0};
  UINTN EntryArrayBytes, EntryArrayBufferSize, EntryArrayBlocks, I, J, SlotAIndex = MAX_UINTN, SlotBIndex = MAX_UINTN;
  UINT32 Crc, MediaId;
  EFI_STATUS Status;

  // Do not retry within a boot after a partial GPT write or an I/O failure.
  if (mBootAcknowledgementAttempted) return;
  mBootAcknowledgementAttempted = TRUE;
  // Use standard partition information instead of scanning every UFS GPT.
  Status = FindAndroidBootDisk(&Disk, BootEntriesSnapshot);
  if (EFI_ERROR(Status)) return;
  Status = gBS->HandleProtocol(Disk, &gEfiBlockIoProtocolGuid, (VOID **)&BlockIo);
  if (EFI_ERROR(Status) || BlockIo == NULL || BlockIo->Media == NULL) return;
  if (!BlockIo->Media->MediaPresent || BlockIo->Media->LogicalPartition || BlockIo->Media->RemovableMedia ||
      BlockIo->Media->BlockSize != 4096 || BlockIo->Media->LastBlock < 16 || BlockIo->Media->ReadOnly ||
      BlockIo->Media->IoAlign > GPT_BUFFER_ALIGN ||
      (BlockIo->Media->IoAlign > 1 && (BlockIo->Media->IoAlign & (BlockIo->Media->IoAlign - 1)) != 0) ||
      BlockIo->ReadBlocks == NULL || BlockIo->WriteBlocks == NULL || BlockIo->FlushBlocks == NULL) return;
  Status = gBS->AllocatePool(EfiBootServicesData, 6 * GPT_BUFFER_ALIGN, &Allocation);
  if (EFI_ERROR(Status)) return;
  PrimaryBlock = (UINT8 *)(((UINTN)Allocation + GPT_BUFFER_ALIGN - 1) & ~(UINTN)(GPT_BUFFER_ALIGN - 1));
  BackupBlock = PrimaryBlock + GPT_BUFFER_ALIGN;
  PrimaryEntries = BackupBlock + GPT_BUFFER_ALIGN;
  BackupEntries = PrimaryEntries + GPT_BUFFER_ALIGN;
  VerifyBuffer = BackupEntries + GPT_BUFFER_ALIGN;
  PrimaryHeader = (EFI_PARTITION_TABLE_HEADER *)PrimaryBlock;
  BackupHeader = (EFI_PARTITION_TABLE_HEADER *)BackupBlock;
  MediaId = BlockIo->Media->MediaId;

  // Preserve complete sectors and padding, and reject a stale or inconsistent
  // table rather than using it to repair either copy during acknowledgement.
  Status = BlockIo->ReadBlocks(BlockIo, MediaId, 1, 4096, PrimaryBlock);
  if (EFI_ERROR(Status)) goto Done;
  Status = BlockIo->ReadBlocks(BlockIo, MediaId, BlockIo->Media->LastBlock, 4096, BackupBlock);
  if (EFI_ERROR(Status)) goto Done;
  Status = EFI_COMPROMISED_DATA;
  if (!IsBootGptHeaderValid(PrimaryHeader, 1, BlockIo->Media->LastBlock) ||
      !IsBootGptHeaderValid(BackupHeader, BlockIo->Media->LastBlock, 1)) goto Done;
  EntryArrayBytes = PrimaryHeader->NumberOfPartitionEntries * sizeof(EFI_PARTITION_ENTRY);
  EntryArrayBufferSize = (EntryArrayBytes + 4095) & ~(UINTN)4095;
  EntryArrayBlocks = EntryArrayBufferSize / 4096;
  if (PrimaryHeader->FirstUsableLBA < 2 + EntryArrayBlocks || PrimaryHeader->PartitionEntryLBA < 2 ||
      PrimaryHeader->PartitionEntryLBA > PrimaryHeader->FirstUsableLBA - EntryArrayBlocks ||
      PrimaryHeader->LastUsableLBA >= BlockIo->Media->LastBlock - EntryArrayBlocks ||
      BackupHeader->FirstUsableLBA != PrimaryHeader->FirstUsableLBA || BackupHeader->LastUsableLBA != PrimaryHeader->LastUsableLBA ||
      CompareMem(&BackupHeader->DiskGUID, &PrimaryHeader->DiskGUID, sizeof(EFI_GUID)) != 0 ||
      BackupHeader->NumberOfPartitionEntries != PrimaryHeader->NumberOfPartitionEntries ||
      BackupHeader->PartitionEntryArrayCRC32 != PrimaryHeader->PartitionEntryArrayCRC32 ||
      BackupHeader->PartitionEntryLBA <= PrimaryHeader->LastUsableLBA ||
      BackupHeader->PartitionEntryLBA > BlockIo->Media->LastBlock - EntryArrayBlocks) goto Done;
  Status = BlockIo->ReadBlocks(BlockIo, MediaId, PrimaryHeader->PartitionEntryLBA, EntryArrayBufferSize, PrimaryEntries);
  if (EFI_ERROR(Status)) goto Done;
  Status = BlockIo->ReadBlocks(BlockIo, MediaId, BackupHeader->PartitionEntryLBA, EntryArrayBufferSize, BackupEntries);
  if (EFI_ERROR(Status)) goto Done;
  Status = gBS->CalculateCrc32(PrimaryEntries, EntryArrayBytes, &Crc);
  if (EFI_ERROR(Status)) goto Done;
  Status = EFI_COMPROMISED_DATA;
  if (Crc != PrimaryHeader->PartitionEntryArrayCRC32 || CompareMem(PrimaryEntries, BackupEntries, EntryArrayBytes) != 0) goto Done;
  PartitionEntries = (EFI_PARTITION_ENTRY *)PrimaryEntries;
  for (I = 0; I < PrimaryHeader->NumberOfPartitionEntries; I++) {
    if (CompareMem(&PartitionEntries[I].PartitionTypeGUID, &ZeroGuid, sizeof(ZeroGuid)) == 0) continue;
    if (PartitionEntries[I].StartingLBA < PrimaryHeader->FirstUsableLBA || PartitionEntries[I].EndingLBA > PrimaryHeader->LastUsableLBA ||
        PartitionEntries[I].StartingLBA > PartitionEntries[I].EndingLBA) goto Done;
    for (J = 0; J < I; J++) {
      if (CompareMem(&PartitionEntries[J].PartitionTypeGUID, &ZeroGuid, sizeof(ZeroGuid)) == 0) continue;
      if (PartitionEntries[I].StartingLBA <= PartitionEntries[J].EndingLBA && PartitionEntries[J].StartingLBA <= PartitionEntries[I].EndingLBA) goto Done;
    }
    if (CompareMem(PartitionEntries[I].PartitionName, L"boot_a", sizeof(L"boot_a")) == 0) {
      if (SlotAIndex != MAX_UINTN) goto Done;
      SlotAIndex = I;
    }
    if (CompareMem(PartitionEntries[I].PartitionName, L"boot_b", sizeof(L"boot_b")) == 0) {
      if (SlotBIndex != MAX_UINTN) goto Done;
      SlotBIndex = I;
    }
  }
  if (SlotAIndex == MAX_UINTN || SlotBIndex == MAX_UINTN ||
      CompareMem(&PartitionEntries[SlotAIndex], &BootEntriesSnapshot[0], sizeof(BootEntriesSnapshot[0])) != 0 ||
      CompareMem(&PartitionEntries[SlotBIndex], &BootEntriesSnapshot[1], sizeof(BootEntriesSnapshot[1])) != 0 ||
      ((PartitionEntries[SlotAIndex].Attributes & SLOT_ACTIVE) != 0) == ((PartitionEntries[SlotBIndex].Attributes & SLOT_ACTIVE) != 0)) goto Done;
  I = SlotBIndex;
  if ((PartitionEntries[SlotAIndex].Attributes & SLOT_ACTIVE) != 0) I = SlotAIndex;
  ActiveSlot = &PartitionEntries[I];
  if ((ActiveSlot->Attributes & SLOT_UNBOOTABLE) != 0) goto Done;
  if ((ActiveSlot->Attributes & SLOT_SUCCESSFUL) != 0) { Status = EFI_SUCCESS; goto Done; }

  // ABL exhausts retry_count after seven unacknowledged boots, even when
  // Aloha and Linux work. Reaching BDS acknowledges Aloha independently of
  // the chosen EFI OS. Do not reset retry_count or alter the other slot.
  ActiveSlot->Attributes |= SLOT_SUCCESSFUL;
  ((EFI_PARTITION_ENTRY *)BackupEntries)[I].Attributes = ActiveSlot->Attributes;
  Status = gBS->CalculateCrc32(PrimaryEntries, EntryArrayBytes, &Crc);
  if (EFI_ERROR(Status)) goto Done;
  PrimaryHeader->PartitionEntryArrayCRC32 = BackupHeader->PartitionEntryArrayCRC32 = Crc;
  PrimaryHeader->Header.CRC32 = BackupHeader->Header.CRC32 = 0;
  Status = gBS->CalculateCrc32(PrimaryHeader, PrimaryHeader->Header.HeaderSize, &PrimaryHeader->Header.CRC32);
  if (EFI_ERROR(Status)) goto Done;
  Status = gBS->CalculateCrc32(BackupHeader, BackupHeader->Header.HeaderSize, &BackupHeader->Header.CRC32);
  if (EFI_ERROR(Status)) goto Done;

  // GPT has no atomic two-copy update. Flush and verify the backup first;
  // stop on error, without rebuilding metadata or touching partition contents.
  Status = WriteAndVerifyBlocks(BlockIo, MediaId, BackupHeader->PartitionEntryLBA, EntryArrayBufferSize, BackupEntries, VerifyBuffer);
  if (EFI_ERROR(Status)) goto Done;
  Status = WriteAndVerifyBlocks(BlockIo, MediaId, BackupHeader->MyLBA, 4096, BackupBlock, VerifyBuffer);
  if (EFI_ERROR(Status)) goto Done;
  Status = WriteAndVerifyBlocks(BlockIo, MediaId, PrimaryHeader->PartitionEntryLBA, EntryArrayBufferSize, PrimaryEntries, VerifyBuffer);
  if (EFI_ERROR(Status)) goto Done;
  Status = WriteAndVerifyBlocks(BlockIo, MediaId, PrimaryHeader->MyLBA, 4096, PrimaryBlock, VerifyBuffer);
Done:
  if (EFI_ERROR(Status))
    DEBUG((DEBUG_ERROR, "Lenovo Elden: boot-slot acknowledgement failed: %r\n", Status));
  gBS->FreePool(Allocation);
}
