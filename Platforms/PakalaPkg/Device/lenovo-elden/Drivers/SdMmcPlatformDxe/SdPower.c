// SPDX-License-Identifier: BSD-2-Clause-Patent
#include <PiDxe.h>
#include <Library/BaseLib.h>
#include <Library/IoLib.h>
#include <Library/UefiBootServicesTableLib.h>
#include "SdPower.h"

STATIC BOOLEAN mPowerInitializationAttempted;
STATIC EFI_STATUS mPowerInitializationStatus = EFI_NOT_READY;

// Submit active votes through HLOS DRV2 TCS1, without changing TCS0's IRQ
// configuration. This platform does not dispatch RpmhDxe or start APs;
// introducing either requires a shared TCS ownership design first.
STATIC EFI_STATUS
EldenSdVrmVote (UINT32 Address, UINT32 Value)
{
  CONST UINTN TcsControlBase = 0x16520d00;
  CONST UINTN VoteTcsBase = 0x16520fa0; // TCS1: 0xd00 + 0x2a0
  UINT32 SavedCommand[3], I;
  EFI_TPL OldTpl;
  EFI_STATUS Status = EFI_NOT_READY;
  BOOLEAN Allowed = FALSE;
  BOOLEAN SawIncomplete;
  UINT32 Completion;

  // These VRM command-DB resources supply the SD socket and controller.
  // Restrict writes to their qualified voltage, mode and enable requests.
  switch (Address) {
    case 0x41700: case 0x41600: Allowed = Value == 2960; break;
    case 0x42200: Allowed = Value == 1200; break;
    case 0x41704: case 0x41604: case 0x42204: Allowed = Value == 1; break;
    case 0x41708: case 0x41608: case 0x42208: Allowed = Value == 7; break;
    default: break;
  }
  if (!Allowed) return EFI_ACCESS_DENIED;
  OldTpl = gBS->RaiseTPL(TPL_HIGH_LEVEL);
  // Fail closed on any difference from the qualified idle environment.
  // In particular, do not steal an IRQ-enabled TCS or clear others' IRQs.
  if (MmioRead32(TcsControlBase) != 1 || MmioRead32(TcsControlBase + 4) != 0) goto Done;
  for (I = 0; I < 3; I++) {
    UINTN TcsBase = TcsControlBase + I * 0x2a0;
    if (MmioRead32(TcsBase + 0x24) != 0 ||
        MmioRead32(TcsBase + 0x28) != 1 ||
        MmioRead32(TcsBase + 0x2c) != 0) goto Done;
  }
  SavedCommand[0] = MmioRead32(VoteTcsBase + 0x34);
  SavedCommand[1] = MmioRead32(VoteTcsBase + 0x38);
  SavedCommand[2] = MmioRead32(VoteTcsBase + 0x3c);
  // RPMH command: length=8, write, response required. One command per transfer.
  MmioWrite32(VoteTcsBase + 0x34, 0x10108);
  MmioWrite32(VoteTcsBase + 0x38, Address);
  MmioWrite32(VoteTcsBase + 0x3c, Value);
  MemoryFence();
  MmioWrite32(VoteTcsBase + 0x2c, 1);
  MmioWrite32(VoteTcsBase + 0x24, 0x10000);
  MemoryFence();
  if (MmioRead32(VoteTcsBase + 0x24) != 0x10000) {
    Status = EFI_DEVICE_ERROR;
    goto Done; // Do not reuse a TCS whose state is no longer known.
  }
  // A completion already present before trigger is not evidence for this
  // request. Require an observed incomplete sample before accepting done.
  SawIncomplete = ((MmioRead32(VoteTcsBase + 0x40) & BIT16) == 0);
  MmioWrite32(VoteTcsBase + 0x24, 0x1010000);
  MemoryFence();
  Status = EFI_TIMEOUT;
  // The TCS interrupt is masked, so completion need not set IRQ status.
  // Poll command completion and TCS idle instead.
  // No Stall/event dispatch at HIGH_LEVEL. This is an iteration bound,
  // deliberately not described as a calibrated millisecond timeout.
  for (I = 0; I < 1000000; I++) {
    Completion = MmioRead32(VoteTcsBase + 0x40);
    if ((Completion & BIT16) == 0) SawIncomplete = TRUE;
    if (SawIncomplete && ((Completion & 0x10100) == 0x10100) &&
        (MmioRead32(VoteTcsBase + 0x28) == 1)) {
      Status = EFI_SUCCESS;
      break;
    }
    CpuPause();
  }
  if (Status == EFI_TIMEOUT) {
    goto Done; // Never reuse an in-flight TCS.
  }
  // Clear trigger, then mode; only reclaim our completed TCS1.
  MmioWrite32(VoteTcsBase + 0x24, 0x10000);
  MemoryFence();
  if (MmioRead32(VoteTcsBase + 0x24) != 0x10000) { Status = EFI_DEVICE_ERROR; goto Done; }
  MmioWrite32(VoteTcsBase + 0x24, 0);
  MemoryFence();
  if (MmioRead32(VoteTcsBase + 0x24) != 0) { Status = EFI_DEVICE_ERROR; goto Done; }
  MmioWrite32(VoteTcsBase + 0x2c, 0);
  MmioWrite32(TcsControlBase + 8, BIT1);
  MmioWrite32(VoteTcsBase + 0x34, SavedCommand[0]);
  MmioWrite32(VoteTcsBase + 0x38, SavedCommand[1]);
  MmioWrite32(VoteTcsBase + 0x3c, SavedCommand[2]);
  MemoryFence();
Done:
  gBS->RestoreTPL(OldTpl);
  return Status;
}

// The stock command database protocol exposes QueryAddress at offset 0x10
// with the arguments (This, Name, UINT32 *Address).
// Query returns EFI_SUCCESS even when the resource is absent (Address=0).
// These are command-DB addresses, NOT SPMI register addresses.
STATIC EFI_STATUS
InitializeSdPower (VOID)
{
  EFI_GUID CmdDbProtocolGuid = {0x1c34f691,0xd33d,0x4e14,{0xb8,0xf8,0x32,0xc6,0xc0,0x29,0xe9,0x5b}};
  typedef EFI_STATUS (EFIAPI *CMD_DB_QUERY_ADDRESS)(VOID *, CONST CHAR8 *, UINT32 *);
  UINT64 *CmdDb = NULL;
  CONST CHAR8 *ResourceNames[] = {"ldob9", "ldob8", "ldoi2"};
  CONST UINT32 Millivolts[] = {2960, 2960, 1200};
  CONST UINT32 ExpectedAddresses[] = {0x41700, 0x41600, 0x42200};
  UINT32 CommandIndex;
  UINT32 Address, Version, Config, Major;
  UINTN I, Base;
  EFI_STATUS Status;

  Status = gBS->LocateProtocol(&CmdDbProtocolGuid, NULL, (VOID **)&CmdDb);
  if (EFI_ERROR(Status)) return Status;
  if (CmdDb == NULL || CmdDb[0] != 0x10000 || CmdDb[2] == 0)
    return EFI_UNSUPPORTED;
  for (I = 0; I < ARRAY_SIZE(ResourceNames); I++) {
    Address = 0;
    Status = ((CMD_DB_QUERY_ADDRESS)(UINTN)CmdDb[2])(CmdDb, ResourceNames[I], &Address);
    // Linux cmd-db.c: address bits 18:16 identify the hardware slave;
    // all three must be VRM (4). Do not use an arbitrary returned address.
    if (EFI_ERROR(Status)) return Status;
    if (Address == 0 || (Address & 3) != 0 ||
        ((Address >> 16) & 7) != 4 || Address != ExpectedAddresses[I]) {
      return EFI_UNSUPPORTED;
    }
  }
  // SM8750 apps_rsc DRV2, mapped as device memory by APSS_HM.
  Base = 0x16520000;
  Version = MmioRead32(Base);
  Config = MmioRead32(Base + 0xc);
  Major = (Version >> 16) & 0xff;
  if (Major != 3 || Version != 0x30800 || Config != 0x800c8104) {
    return EFI_UNSUPPORTED;
  }
  for (I = 0; I < ARRAY_SIZE(ResourceNames); I++) {
    // Configure voltage and mode BEFORE enable; keep all rails enabled.
    CONST UINT32 Offsets[] = {0, 8, 4};
    UINT32 Values[3];
    Values[0] = Millivolts[I]; Values[1] = 7; Values[2] = 1;
    for (CommandIndex = 0; CommandIndex < ARRAY_SIZE(Offsets); CommandIndex++) {
      Status = EldenSdVrmVote(ExpectedAddresses[I] + Offsets[CommandIndex], Values[CommandIndex]);
      if (EFI_ERROR(Status)) {
        // Do not retry a failed power vote.
        return Status;
      }
    }
  }
  return EFI_SUCCESS;
}


EFI_STATUS
EldenSdEnablePower (VOID)
{
  // A completed sequence needs no further votes. A failed sequence may have
  // left a request in flight: return its original error rather than retrying.
  if (!mPowerInitializationAttempted) {
    mPowerInitializationAttempted = TRUE;
    mPowerInitializationStatus = InitializeSdPower();
  }
  return mPowerInitializationStatus;
}
