/** @file

  Patches NTOSKRNL to not cause a SError when reading/writing ACTLR_EL1
  Patches NTOSKRNL to not cause a SError when reading/writing AMCNTENSET0_EL0
  Patches NTOSKRNL to not cause a bugcheck when attempting to use
  PSCI_MEMPROTECT Due to an issue in QHEE

  Based on https://github.com/SamuelTulach/rainbow

  Copyright (c) 2021 Samuel Tulach
  Copyright (c) 2022-2023 DuoWoA authors

  SPDX-License-Identifier: MIT

**/
#include "KernelErrataPatcherLib.h"
#include "ShellCode.h"

#if PLATFORM_HAS_ACTLR_EL1_UNIMPLEMENTED_ERRATA == 0
#if PLATFORM_HAS_AMCNTENSET0_EL0_UNIMPLEMENTED_ERRATA == 0
#if PLATFORM_HAS_GIC_V3_WITHOUT_IRM_FLAG_SUPPORT_ERRATA == 0
#if PLATFORM_HAS_PSCI_MEMPROTECT_FAILING_ERRATA == 0
#error "No errata to patch"
#endif
#endif
#endif
#endif

// Please see ./ShellCode/Reference/ShellCode.c for what this does
UINT8 OslArm64TransferToKernelShellCode[] = {
#if PLATFORM_HAS_ACTLR_EL1_UNIMPLEMENTED_ERRATA == 1
    // ACTLR_EL1
    ACTLR_EL1_UNIMPLEMENTED_PATCH,
#endif

#if PLATFORM_HAS_AMCNTENSET0_EL0_UNIMPLEMENTED_ERRATA == 1
    // AMCNTENSET0_EL0
    AMCNTENSET0_EL0_UNIMPLEMENTED_PATCH,
#endif

#if PLATFORM_HAS_GIC_V3_WITHOUT_IRM_FLAG_SUPPORT_ERRATA == 1
    // IRM
    GIC_V3_WITHOUT_IRM_FLAG_SUPPORT_PATCH,

    // IRM_X8
    GIC_V3_WITHOUT_IRM_FLAG_SUPPORT_X8_VARIANT_PATCH,
#endif

#if PLATFORM_HAS_PSCI_MEMPROTECT_FAILING_ERRATA == 1
    // PSCI_MEMPROTECT
    PSCI_MEMPROTECT_FAILING_PATCH,
#endif
};

#if PLATFORM_HAS_ACTLR_EL1_UNIMPLEMENTED_ERRATA == 1
VOID KernelErrataPatcherApplyReadACTLREL1Patches(
    EFI_PHYSICAL_ADDRESS Base, UINTN Size)
{
  // Fix up #0 (28 10 38 D5 -> 08 00 80 D2) (ACTRL_EL1 Register Read)
  UINT8                FixedInstruction0[] = {0x08, 0x00, 0x80, 0xD2};
  EFI_PHYSICAL_ADDRESS IllegalInstruction0 =
      FindPattern(Base, Size, "28 10 38 D5");

  if (IllegalInstruction0 != 0) {
    FirmwarePrint("mrs x8, actlr_el1         -> 0x%p\n", IllegalInstruction0);

    CopyMemory(
        IllegalInstruction0, (EFI_PHYSICAL_ADDRESS)FixedInstruction0,
        sizeof(FixedInstruction0));
  }
}
#endif

VOID InjectCodeIntoOsLoaderArm64TransferToKernel(
    EFI_PHYSICAL_ADDRESS NewOslArm64TransferToKernelAddr,
    EFI_PHYSICAL_ADDRESS current)
{
  FirmwarePrint(
      "Patching bl OsLoaderArm64TransferToKernel -> (phys) 0x%p\n", current);

  *(UINT32 *)current = ARM64_BRANCH_LOCATION_INSTRUCTION(
      current, NewOslArm64TransferToKernelAddr);

  FirmwarePrint(
      "Patching OsLoaderArm64TransferToKernel -> (phys) 0x%p\n",
      OslArm64TransferToKernelAddr);

  // Copy shell code right before the
  // OsLoaderArm64TransferToKernelFunction
  CopyMemory(
      NewOslArm64TransferToKernelAddr,
      (EFI_PHYSICAL_ADDRESS)OslArm64TransferToKernelShellCode,
      sizeof(OslArm64TransferToKernelShellCode));
}

BOOLEAN FindAndInjectIntoOsLoaderArm64TransferToKernel(
    EFI_PHYSICAL_ADDRESS winloadBase, UINT32 BaseOffset,
    UINT32 InstructionPatternMatch)
{
  EFI_PHYSICAL_ADDRESS OslArm64TransferToKernelAddr =
      winloadBase + 0xC00 + BaseOffset;
  EFI_PHYSICAL_ADDRESS NewOslArm64TransferToKernelAddr =
      OslArm64TransferToKernelAddr - sizeof(OslArm64TransferToKernelShellCode);

  for (EFI_PHYSICAL_ADDRESS current = OslArm64TransferToKernelAddr;
       current < OslArm64TransferToKernelAddr + SCAN_MAX;
       current += sizeof(UINT32)) {

    if (ARM64_BRANCH_LOCATION_INSTRUCTION(
            current, OslArm64TransferToKernelAddr) == *(UINT32 *)current &&
        *(UINT32 *)(current + sizeof(UINT32)) == InstructionPatternMatch) {
      InjectCodeIntoOsLoaderArm64TransferToKernel(
          NewOslArm64TransferToKernelAddr, current);
      return TRUE;
    }
  }

  return FALSE;
}

VOID OslInterceptMain(IN EFI_PHYSICAL_ADDRESS fwpKernelSetupPhase1)
{
  FirmwarePrint(
      "OslFwpKernelSetupPhase1   -> (phys) 0x%p\n", fwpKernelSetupPhase1);

  UINTN                tempSize = SCAN_MAX;
  EFI_PHYSICAL_ADDRESS winloadBase =
      LocateWinloadBase(fwpKernelSetupPhase1, &tempSize);

  EFI_STATUS Status = UnprotectWinload(winloadBase + EFI_PAGE_SIZE, tempSize);
  if (EFI_ERROR(Status)) {
    FirmwarePrint(
        "Could not unprotect winload -> (phys) 0x%p (size) 0x%p %r\n",
        winloadBase, tempSize, Status);

    goto exit;
  }

  // Fix up winload.efi
  // This fixes Boot Debugger
  FirmwarePrint(
      "Patching OsLoader         -> (phys) 0x%p (size) 0x%p\n",
      fwpKernelSetupPhase1, SCAN_MAX);

#if PLATFORM_HAS_ACTLR_EL1_UNIMPLEMENTED_ERRATA == 1
  KernelErrataPatcherApplyReadACTLREL1Patches(fwpKernelSetupPhase1, SCAN_MAX);
#endif

  BOOLEAN InjectedShellCode = FindAndInjectIntoOsLoaderArm64TransferToKernel(
      winloadBase,
      NT_OS_LOADER_ARM64_TRANSFER_TO_KERNEL_FUNCTION_OFFSET_RUBIDIUM,
      0x52800015);

  if (!InjectedShellCode) {
    InjectedShellCode = FindAndInjectIntoOsLoaderArm64TransferToKernel(
        winloadBase,
        NT_OS_LOADER_ARM64_TRANSFER_TO_KERNEL_FUNCTION_OFFSET_KRYPTON,
        0x52800015);
  }

  if (!InjectedShellCode) {
    InjectedShellCode = FindAndInjectIntoOsLoaderArm64TransferToKernel(
        winloadBase,
        NT_OS_LOADER_ARM64_TRANSFER_TO_KERNEL_FUNCTION_OFFSET_BROMINE,
        0x52800014);
  }

  if (!InjectedShellCode) {
    InjectedShellCode = FindAndInjectIntoOsLoaderArm64TransferToKernel(
        winloadBase,
        NT_OS_LOADER_ARM64_TRANSFER_TO_KERNEL_FUNCTION_OFFSET_SELENIUM,
        0xD2800002);
  }

  if (!InjectedShellCode) {
    InjectedShellCode = FindAndInjectIntoOsLoaderArm64TransferToKernel(
        winloadBase,
        NT_OS_LOADER_ARM64_TRANSFER_TO_KERNEL_FUNCTION_OFFSET_GERMANIUM,
        0xD2800002);
  }

  if (!InjectedShellCode) {
    InjectedShellCode = FindAndInjectIntoOsLoaderArm64TransferToKernel(
        winloadBase, NT_OS_LOADER_ARM64_TRANSFER_TO_KERNEL_FUNCTION_OFFSET, 0xD2800002);
  }

  FirmwarePrint(
      "Protecting winload        -> (phys) 0x%p (size) 0x%p\n", winloadBase,
      tempSize);

  Status = ReProtectWinload(winloadBase + EFI_PAGE_SIZE, tempSize);
  if (EFI_ERROR(Status)) {
    FirmwarePrint(
        "Could not reprotect winload -> (phys) 0x%p (size) 0x%p %r\n",
        winloadBase, tempSize, Status);

    goto exit;
  }

exit:
  FirmwarePrint(
      "OslFwpKernelSetupPhase1   <- (phys) 0x%p\n", fwpKernelSetupPhase1);
}