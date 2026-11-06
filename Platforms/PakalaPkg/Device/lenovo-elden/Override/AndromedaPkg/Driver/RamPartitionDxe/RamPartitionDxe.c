/**************************
 * Description:
   Publish high RAM reported by EFI_RAMPARTITION_PROTOCOL.


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
// Lenovo Y700 Gen4 reports fragmented RAM banks, including platform
// reservations. Keep this policy local to the board.
#include <PiDxe.h>
#include <Library/ArmMmuLib.h>
#include <Library/DebugLib.h>
#include <Library/DxeServicesTableLib.h>
#include <Library/MemoryAllocationLib.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Protocol/EFIRamPartition.h>

STATIC
EFI_STATUS
GetRamPartitions(
    OUT RamPartitionEntry **RamPartitions, OUT UINT32 *NumPartitions)
{
  EFI_STATUS Status;
  EFI_RAMPARTITION_PROTOCOL *RamPartitionProtocol;

  *RamPartitions = NULL;
  *NumPartitions = 0;
  Status = gBS->LocateProtocol(
      &gEfiRamPartitionProtocolGuid, NULL, (VOID **)&RamPartitionProtocol);
  if (EFI_ERROR(Status))
    return Status;

  Status = RamPartitionProtocol->GetRamPartitions(
      RamPartitionProtocol, NULL, NumPartitions);
  if (Status != EFI_BUFFER_TOO_SMALL || *NumPartitions == 0)
    return EFI_PROTOCOL_ERROR;

  *RamPartitions = AllocateZeroPool(*NumPartitions * sizeof(**RamPartitions));
  if (*RamPartitions == NULL)
    return EFI_OUT_OF_RESOURCES;

  Status = RamPartitionProtocol->GetRamPartitions(
      RamPartitionProtocol, *RamPartitions, NumPartitions);
  if (EFI_ERROR(Status)) {
    FreePool(*RamPartitions);
    *RamPartitions = NULL;
  }
  return Status;
}

STATIC
EFI_STATUS
AddHighRamPartition(IN EFI_PHYSICAL_ADDRESS Base, IN UINT64 Length)
{
  EFI_GCD_MEMORY_SPACE_DESCRIPTOR Descriptor;
  EFI_PHYSICAL_ADDRESS End = Base + Length;
  EFI_PHYSICAL_ADDRESS Next;
  EFI_STATUS Status;

  // Preserve reservations and memory already published by the platform.
  // Split at GCD boundaries so a reservation does not discard the usable
  // RAM on either side of it.
  while (Base < End) {
    Status = gDS->GetMemorySpaceDescriptor(Base, &Descriptor);
    if (EFI_ERROR(Status))
      return Status;
    Next = MIN(End, Descriptor.BaseAddress + Descriptor.Length);
    if (Next <= Base)
      return EFI_COMPROMISED_DATA;

    if (Descriptor.GcdMemoryType == EfiGcdMemoryTypeNonExistent) {
      if (Descriptor.ImageHandle != NULL)
        return EFI_ACCESS_DENIED;

      // Bound each addition so page-table allocations for the next chunk
      // can use memory made available by the preceding one.
      Next = Base + MIN(Next - Base, SIZE_2GB);
      // AddMemorySpace exposes RAM to DXE allocations. Map it first:
      // allocating page tables must not select unmapped RAM. ArmMmuLib
      // expects EFI cache flags, not ARM_MEMORY_REGION_ATTRIBUTES.
      Status = ArmSetMemoryAttributes(Base, Next - Base, EFI_MEMORY_WB, 0);
      if (EFI_ERROR(Status))
        return Status;

      Status = gDS->AddMemorySpace(
          EfiGcdMemoryTypeSystemMemory, Base, Next - Base,
          EFI_MEMORY_UC | EFI_MEMORY_WC | EFI_MEMORY_WT | EFI_MEMORY_WB);
      if (EFI_ERROR(Status))
        return Status;

      Status = gDS->SetMemorySpaceAttributes(Base, Next - Base, EFI_MEMORY_WB);
      if (EFI_ERROR(Status))
        return Status;
    }
    Base = Next;
  }
  return EFI_SUCCESS;
}

EFI_STATUS
EFIAPI
RamPartitionDxeInitialize(
    IN EFI_HANDLE ImageHandle, IN EFI_SYSTEM_TABLE *SystemTable)
{
  RamPartitionEntry *RamPartitions;
  EFI_PHYSICAL_ADDRESS Base;
  EFI_PHYSICAL_ADDRESS End;
  UINT32 NumPartitions;
  UINT32 Index;
  EFI_STATUS Status;

  Status = GetRamPartitions(&RamPartitions, &NumPartitions);
  if (EFI_ERROR(Status)) {
    DEBUG((DEBUG_ERROR, "Failed to read RAM partitions: %r\n", Status));
    return Status;
  }

  for (Index = 0; Index < NumPartitions; Index++) {
    Base = RamPartitions[Index].Base;
    if (RamPartitions[Index].AvailableLength > MAX_UINT64 - Base) {
      Status = EFI_COMPROMISED_DATA;
      break;
    }
    End = Base + RamPartitions[Index].AvailableLength;

    // PlatformMemoryMapLib describes the low DDR used by firmware and
    // PrePi. Do not infer usable low RAM from gaps between its HOBs.
    // Only extend the map with the high DDR banks reported by firmware.
    if (End <= BASE_4GB || Base == End)
      continue;
    Base = MAX(Base, BASE_4GB);
    if (((Base | End) & EFI_PAGE_MASK) != 0) {
      Status = EFI_COMPROMISED_DATA;
      break;
    }

    Status = AddHighRamPartition(Base, End - Base);
    if (EFI_ERROR(Status)) {
      DEBUG((DEBUG_ERROR, "Failed to add RAM [%lx, %lx): %r\n", Base, End, Status));
      break;
    }
  }
  FreePool(RamPartitions);
  return Status;
}
