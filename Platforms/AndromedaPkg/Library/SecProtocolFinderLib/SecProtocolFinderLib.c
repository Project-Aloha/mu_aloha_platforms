/** @file
    Copyright (c) 2024-2026. DuoWoA Authors. All rights reserved.
    Copyright (c) 2024-2026. Project Aloha Authors. All rights reserved.

    SPDX-License-Identifier: MIT
*/

#include "SecProtocolFinderLib.h"
#include <Library/BaseLib.h>
#include <Library/CacheMaintenanceLib.h>
#include <Library/ConfigurationMapHelperLib.h>
#include <Library/DebugLib.h>
#include <Library/MemoryMapHelperLib.h>
#include <Library/PlatformHobs.h>
#include <Library/PlatformMemoryMapLib.h>
#include <Library/SecProtocolFinderLib.h>

/* Variables */
STATIC UINTN             ScheIntrAddr = 0;
STATIC UINTN             SecDTOpsAddr = 0;
STATIC LK_INIT_FUNCTIONS LkInitFuncs  = {0};

/* Funcs */
/**
 * Find the buffer to the header of XBLCore.te
 *
 * @param TEInfo provide filePath, will also set TEBuffer in it.
 * @return EFI_STATUS EFI_SUCCESS if found, EFI_NOT_FOUND if not found.
 */
STATIC
EFI_STATUS
FindTeAddr(TE_INFO_STRUCT *TEInfo)
{
  ARM_MEMORY_REGION_DESCRIPTOR_EX PreFD  = {0};
  EFI_STATUS                      Status = EFI_SUCCESS;

  // Get Previous UEFI FD Address
  Status = LocateMemoryMapAreaByName("FD Reserved I", &PreFD);
  if (EFI_ERROR(Status)) {
    DEBUG(
        (DEBUG_ERROR,
         "Failed to locate \"FD Reserved I\", search \"UEFI FD\" instead.\n"));

    Status = LocateMemoryMapAreaByName("UEFI FD", &PreFD);
    if (EFI_ERROR(Status)) {
      DEBUG((DEBUG_ERROR, "Failed to find \"UEFI FD\"\n"));
      Status = EFI_NOT_FOUND;
      goto exit;
    }
  }

  // Find Signature 0x565A 'VZ' And Arch 0x64AA 'd'
  PreFD.Address += 0x1000; // Add 0x1000 here to skip useless data

  UINT64 MaxAddressForFDRegion = (UINT64)PreFD.Address + PreFD.Length;

  for (UINT64 SecurityCoreAddress = (UINT64)PreFD.Address;
       SecurityCoreAddress < MaxAddressForFDRegion; SecurityCoreAddress += 4) {
    if (*(UINT32 *)(SecurityCoreAddress) == 0xAA645A56) {
      // Got size info
      TEInfo->fileSize =
          0xFFFFFF &
          *(UINT32 *)(SecurityCoreAddress -
                      4); // Top 1 Byte is 0x12, the reset part is TE size.
      TEInfo->teSize = TEInfo->fileSize - sizeof(EFI_TE_IMAGE_HEADER);

      // Reach end of header
      UINT64 EndOfHeaderAddress =
          SecurityCoreAddress + sizeof(EFI_TE_IMAGE_HEADER) +
          EFI_IMAGE_SIZEOF_SECTION_HEADER *
              ((EFI_TE_IMAGE_HEADER *)SecurityCoreAddress)->NumberOfSections;

      for (UINT64 ProgramBufferAddress = EndOfHeaderAddress;
           ProgramBufferAddress < MaxAddressForFDRegion;
           ProgramBufferAddress += 4) {
        if (*(UINT32 *)ProgramBufferAddress != 0x0) {
          // Store Address
          TEInfo->TEBuffer      = (VOID *)SecurityCoreAddress;
          TEInfo->programBuffer = (VOID *)ProgramBufferAddress;
          goto exitLoop;
        }
      }
    }
  }

exitLoop:
  if (TEInfo->TEBuffer == 0) {
    DEBUG((DEBUG_ERROR, "XBLCore.te not found\n"));
    Status = EFI_NOT_FOUND;
    goto exit;
  }

// Print Header information
#if 0
  DEBUG(
      (DEBUG_WARN,
       "Signature              0x%08X\n"
       "Machine                0x%08X\n"
       "NumberOfSections       0x%08X\n"
       "Subsystem              0x%08X\n",
       TEInfo->teHeader->Signature, TEInfo->teHeader->Machine,
       TEInfo->teHeader->NumberOfSections, TEInfo->teHeader->Subsystem));

  DEBUG(
      (DEBUG_WARN,
       "StrippedSize           0x%08X\n"
       "AddressOfEntryPoint    0x%08X\n"
       "BaseOfCode             0x%08X\n"
       "ImageBase              0x%08lX\n"
       "Program offset:        0x%08lX\n",
       TEInfo->teHeader->StrippedSize, TEInfo->teHeader->AddressOfEntryPoint,
       TEInfo->teHeader->BaseOfCode, TEInfo->teHeader->ImageBase,
       TEInfo->programBuffer - TEInfo->TEBuffer));

  DEBUG(
      (DEBUG_WARN,
    "TE File Size              0x%08X\n"
    "TE Size                   0x%08X\n",
    TEInfo->fileSize,
    TEInfo->teSize));

  // Memory dump for debugging
  UINTN end = PreFD.Address + 0x3000;
  for (UINTN address = PreFD.Address; address < end; address++) {
    if(address%0x20 == 0){
        DEBUG((EFI_D_WARN, "\n0x%llX: %02X", address, *(UINT8*)address));
    }
    else{
      DEBUG((EFI_D_WARN, " %02X", *(UINT8*)address));
    }
  }
#endif

exit:
  return Status;
}

/**
 * @param TEInfo TE information struct.
 * @param Data is the buffer need to find in buffer.
 * @param Size is the size of Data buffer.
 * @param DataInBuffer offset of data in buffer.
 * @retval status
 **/
STATIC
EFI_STATUS
find_data_in_buffer(
    IN OUT TE_INFO_STRUCT *TEInfo, IN VOID *Data, IN UINTN Size,
    OUT UINTN *DataInBuffer)
{
  for (UINTN i = 0; i <= TEInfo->teSize - Size; i++) {
    if (CompareMem(TEInfo->programBuffer + i, Data, Size) == 0) {
      *DataInBuffer = (UINTN)i;
      return EFI_SUCCESS;
    }
  }
  return EFI_NOT_FOUND; // Not found
}

/**
 * @param TEInfo TE information struct.
 * @param KeyGuid is the buffer need to find in buffer.
 * @param GuidInBuffer offset of guid in buffer.
 * @retval status
 **/
STATIC
EFI_STATUS
find_guid_in_buffer(
    IN OUT TE_INFO_STRUCT *TEInfo, IN GUID *KeyGuid, OUT UINTN *GuidInBuffer)
{
  return find_data_in_buffer(TEInfo, KeyGuid, 16, GuidInBuffer);
}

STATIC
BOOLEAN
validate_adrp(IN OUT INST *inst)
{
  // Store Values by macros
  inst->adrp.op1   = ADRP_OP1(inst->val);
  inst->adrp.op2   = ADRP_OP2(inst->val);
  inst->adrp.Rd    = ADRP_RD(inst->val);
  inst->adrp.immhi = ADRP_IMMHI(inst->val);
  inst->adrp.immlo = ADRP_IMMLO(inst->val);
  return (inst->adrp.op1 == 1 && inst->adrp.op2 == 16 && inst->adrp.Rd <= 30);
}

STATIC
BOOLEAN
validate_add(IN OUT INST *inst)
{
  // Store Values by macros
  inst->add.op1   = ADD_OP1(inst->val);
  inst->add.op2   = ADD_OP2(inst->val);
  inst->add.Rd    = ADD_RD(inst->val);
  inst->add.Rn    = ADD_RN(inst->val);
  inst->add.imm12 = ADD_IMM12(inst->val);
  inst->add.s     = ADD_S(inst->val);
  inst->add.sf    = ADD_SF(inst->val);
  inst->add.sh    = ADD_SH(inst->val);
  return (inst->add.op1 == 0 && inst->add.s == 0 && inst->add.op2 == 34);
}

STATIC
BOOLEAN
validate_bl(IN OUT INST *inst)
{
  inst->bl.imm26 = BL_IMM26(inst->val);
  inst->bl.op    = BL_OP(inst->val);
  return (inst->bl.op == 0b100101);
}

STATIC
BOOLEAN
validate_ret(IN INST *inst) { return (inst->val == 0xD65F03C0); }

STATIC
BOOLEAN
validate_movz(INST *inst)
{
  inst->movz.sf    = MOV_SF(inst->val);
  inst->movz.opc   = MOV_OPC(inst->val);
  inst->movz.hw    = MOV_HW(inst->val);
  inst->movz.imm16 = MOV_IMM16(inst->val);
  inst->movz.Rd    = MOV_RD(inst->val);

  return (inst->movz.opc == 0b10100101);
}

STATIC
BOOLEAN
validate_movk(INST *inst)
{
  inst->movk.sf    = MOV_SF(inst->val);
  inst->movk.opc   = MOV_OPC(inst->val);
  inst->movk.hw    = MOV_HW(inst->val);
  inst->movk.imm16 = MOV_IMM16(inst->val);
  inst->movk.Rd    = MOV_RD(inst->val);

  return (inst->movk.opc == 0b11100101);
}

STATIC
VOID parse_adrp(IN OUT INST *inst, IN UINT32 offset)
{
  // Store immediate number
  inst->adrp.imm = (inst->adrp.immhi << 2 | inst->adrp.immlo) << 12;
  // Store PC and Register(after executing adrp) address
  inst->adrp.pc               = offset;
  inst->adrp.RdAfterExecution = ((inst->adrp.pc >> 12) << 12) + inst->adrp.imm;
};

STATIC
VOID parse_bl(IN OUT INST *inst, IN UINT32 offset)
{
  // Store immediate number
  inst->bl.imm = (inst->bl.imm26 & (1 << 25))
                     ? (inst->bl.imm26 | (~(0ULL) & 0xfc000000)) << 2
                     : (inst->bl.imm26) << 2;
  // Store PC and Register(after executing bl) address
  inst->bl.pc       = offset;
  inst->bl.jumpAddr = inst->bl.pc + inst->bl.imm;
};

STATIC
UINT64
parse_movz_with_movk(INST *movz_inst, INST *movk_inst)
{
  movz_inst->movz.imm = movz_inst->movz.hw * 16;
  movk_inst->movk.imm = movk_inst->movk.hw * 16;
  return (movz_inst->movz.imm16 << movz_inst->movz.imm) |
         (movk_inst->movk.imm16 << movk_inst->movk.imm);
}

STATIC
UINT64
offset_to_phy_addr(IN TE_INFO_STRUCT *Binary, IN UINT64 offset)
{
  return Binary->teHeader->BaseOfCode + Binary->teHeader->ImageBase + offset;
}

STATIC
UINT64
phy_addr_to_offset(IN TE_INFO_STRUCT *Binary, IN UINT64 PhyAddr)
{
  return PhyAddr - Binary->teHeader->BaseOfCode - Binary->teHeader->ImageBase;
}

STATIC
EFI_STATUS
find_first_ret_before_offset(
    IN TE_INFO_STRUCT *Binary, IN UINTN offset, OUT UINTN *PhyAddr)
{
  if (NULL == Binary || 0 == offset)
    return EFI_INVALID_PARAMETER;

  while (offset >= 4) {
    INST instruction = {.val = *(UINT32 *)(Binary->programBuffer + offset - 4)};

    // Check RET
    if (validate_ret(&instruction)) {
      // Got it
      *PhyAddr = offset_to_phy_addr(Binary, offset - 4);
      return EFI_SUCCESS;
    }
    offset -= 4;
  }

  DEBUG(
      (DEBUG_WARN, "RET instruction not found before offset 0x%lX\n", offset));
  *PhyAddr = 0;
  return EFI_NOT_FOUND;
}

STATIC
EFI_STATUS
find_first_bl_before_offset(
    IN TE_INFO_STRUCT *Binary, IN UINTN offset, OUT UINTN *PhyAddr)
{
  if (NULL == Binary || 0 == offset)
    return EFI_INVALID_PARAMETER;

  while (offset >= 4) {
    INST instruction = {.val = *(UINT32 *)(Binary->programBuffer + offset - 4)};

    // Check BL
    if (validate_bl(&instruction)) {
      // Got it
      *PhyAddr = offset_to_phy_addr(Binary, offset - 4);
      return EFI_SUCCESS;
    }
    offset -= 4;
  }
  DEBUG((DEBUG_WARN, "BL instruction not found before offset 0x%lX\n", offset));
  *PhyAddr = 0;
  return EFI_NOT_FOUND;
}

STATIC
EFI_STATUS
find_first_bl_after_offset(
    IN TE_INFO_STRUCT *Binary, IN UINT64 offset, OUT UINT64 *TargetAddress)
{
  if (NULL == Binary || 0 == offset)
    return EFI_INVALID_PARAMETER;

  while (offset < Binary->fileSize - 4) {
    offset += 4;
    INST instruction = {.val = *(UINT32 *)(Binary->programBuffer + offset)};

    // Check BL
    if (validate_bl(&instruction)) {
      // Got it
      *TargetAddress = offset_to_phy_addr(Binary, offset);
      return EFI_SUCCESS;
    }
  }
  // not found
  DEBUG((DEBUG_WARN, "BL instruction not found after offset 0x%lX\n", offset));
  *TargetAddress = 0;
  return EFI_NOT_FOUND;
}

STATIC
EFI_STATUS
get_bl_target_addr(
    IN TE_INFO_STRUCT *Binary, IN UINT64 bl_offset, OUT UINT64 *TargetAddress)
{
  if (NULL == Binary || 0 == bl_offset)
    return EFI_INVALID_PARAMETER;

  INST instruction = {.val = *(UINT32 *)(Binary->programBuffer + bl_offset)};

  // Check BL
  if (validate_bl(&instruction)) {
    // Found a valid BL instruction
    parse_bl(&instruction, bl_offset);
    *TargetAddress = offset_to_phy_addr(Binary, instruction.bl.jumpAddr);
    return EFI_SUCCESS;
  }

  DEBUG((DEBUG_WARN, "BL instruction not found at offset 0x%lX\n", bl_offset));
  *TargetAddress = 0;
  return EFI_NOT_FOUND;
}

STATIC
EFI_STATUS find_caller_addr_of_func_with_offset(
    IN TE_INFO_STRUCT *Binary, IN UINT64 target_offset,
    OUT UINTN *TargetAddress)
{
  // enumerate all BL instructions
  for (UINT32 offset = 0;
       offset < Binary->fileSize - 8 - sizeof(EFI_TE_IMAGE_HEADER);
       offset += 4) {
    INST instruction = {.val = *(UINT32 *)(Binary->programBuffer + offset)};

    // Check BL
    if (validate_bl(&instruction)) {
      // Found a valid BL instruction
      parse_bl(&instruction, offset);
      // Trying jump to address before te region or after te region
      if (instruction.bl.jumpAddr < 0 ||
          instruction.bl.jumpAddr > Binary->teSize)
        continue;

      // Check if the offset equals to our function offset
      if (target_offset == instruction.bl.jumpAddr) {
        *TargetAddress = offset_to_phy_addr(Binary, instruction.bl.pc);
        return EFI_SUCCESS;
      }
    }
  }

  DEBUG((DEBUG_WARN, "Caller Address not found\n"));
  *TargetAddress = 0;
  return EFI_NOT_FOUND;
}

STATIC
EFI_STATUS
find_caller_addr_of_func_with_codes(
    IN TE_INFO_STRUCT *Binary, IN UINT8 *insts_buf, IN UINTN insts_size,
    OUT UINTN *PhyAddr)
{
  EFI_STATUS Status       = EFI_SUCCESS;
  UINT64     insts_offset = 0;

  if (NULL == Binary || NULL == insts_buf || 0 == insts_size)
    return EFI_INVALID_PARAMETER;

  Status = find_data_in_buffer(Binary, insts_buf, insts_size, &insts_offset);
  if (EFI_ERROR(Status))
    goto exit;

  Status = find_caller_addr_of_func_with_offset(Binary, insts_offset, PhyAddr);
  if (EFI_ERROR(Status))
    goto exit;

  return EFI_SUCCESS;

exit:
  DEBUG((DEBUG_WARN, "Caller Address not found\n"));
  *PhyAddr = 0;
  return EFI_NOT_FOUND;
}

STATIC
EFI_STATUS
find_protocol_scheduler(
    IN TE_INFO_STRUCT *Binary, IN GUID *KeyGuid, OUT UINTN *TargetAddress)
{
  // Find Guid Offset
  UINTN      GuidOffset = 0;
  EFI_STATUS status     = find_guid_in_buffer(Binary, KeyGuid, &GuidOffset);
  if (EFI_ERROR(status)) {
    DEBUG((DEBUG_WARN, "Scheduler guid not found in buffer\n"));
    return EFI_NOT_FOUND;
  }

  // Find all ADRP function
  for (UINT32 offset = 0;
       offset < Binary->fileSize - 8 - sizeof(EFI_TE_IMAGE_HEADER);
       offset += 4) {

    INST instruction = {.val = *(UINT32 *)(Binary->TEBuffer + offset)};
    // Check adrp
    if (validate_adrp(&instruction)) {
      // Found a valid adrp instruction
      parse_adrp(&instruction, offset);
      // Check if there is an add function at next next instruction
      INST nnInst = {.val = *(UINT32 *)(Binary->TEBuffer + offset + 8)};
      if (validate_add(&nnInst)) {

        // Get target address
        UINT32 target_address =
            instruction.adrp.RdAfterExecution + nnInst.add.imm12;
        if (target_address == GuidOffset) {
          // Get the adrp instruction before current adrp.
          INST bInst = {.val = *(UINT32 *)(Binary->TEBuffer + offset - 4)};
          // Check adrp
          if (validate_adrp(&bInst)) {
            // Found a valid adrp instruction
            parse_adrp(&bInst, offset);

            // Check Add
            INST nInst = {.val = *(UINT32 *)(Binary->TEBuffer + offset + 4)};
            if (validate_add(&nInst)) {
              // Get target address
              *TargetAddress = bInst.adrp.RdAfterExecution + nInst.add.imm12 +
                               Binary->teHeader->BaseOfCode +
                               Binary->teHeader->ImageBase;
              return EFI_SUCCESS;
            }
          }
        }
      }
    }
  }

  DEBUG((DEBUG_WARN, "Scheduler Protocol Address not found (variant 1)\n"));
  TargetAddress = 0;
  return EFI_NOT_FOUND;
}

STATIC
EFI_STATUS
find_protocol_scheduler_v2(
    IN TE_INFO_STRUCT *Binary, IN GUID *KeyGuid, OUT UINTN *TargetAddress)
{
  // Find Guid Offset
  UINTN      GuidOffset = 0;
  EFI_STATUS status     = find_guid_in_buffer(Binary, KeyGuid, &GuidOffset);
  if (EFI_ERROR(status)) {
    DEBUG((DEBUG_WARN, "Scheduler guid not found in buffer\n"));
    return EFI_NOT_FOUND;
  }

  // Find all ADRP function
  for (UINT32 offset = 0;
       offset < Binary->fileSize - 8 - sizeof(EFI_TE_IMAGE_HEADER);
       offset += 4) {

    INST instruction = {.val = *(UINT32 *)(Binary->TEBuffer + offset)};
    // Check adrp
    if (validate_adrp(&instruction)) {
      // Found a valid adrp instruction
      parse_adrp(&instruction, offset);
      // Check if there is an add function at next instruction
      INST nInst = {.val = *(UINT32 *)(Binary->TEBuffer + offset + 4)};
      if (validate_add(&nInst)) {

        // Get target address
        UINT32 target_address =
            instruction.adrp.RdAfterExecution + nInst.add.imm12;
        if (target_address == GuidOffset) {
          // Get the adrp instruction before current adrp.
          INST bInst = {.val = *(UINT32 *)(Binary->TEBuffer + offset - 8)};
          // Check adrp
          if (validate_adrp(&bInst)) {
            // Found a valid adrp instruction
            parse_adrp(&bInst, offset);

            // Check Add
            INST nInst = {.val = *(UINT32 *)(Binary->TEBuffer + offset - 4)};
            if (validate_add(&nInst)) {
              // Get target address
              *TargetAddress = bInst.adrp.RdAfterExecution + nInst.add.imm12 +
                               Binary->teHeader->BaseOfCode +
                               Binary->teHeader->ImageBase;
              return EFI_SUCCESS;
            }
          }
        }
      }
    }
  }

  DEBUG((DEBUG_WARN, "Scheduler Protocol Address not found (variant v2)\n"));
  TargetAddress = 0;
  return EFI_NOT_FOUND;
}

STATIC
EFI_STATUS
find_protocol_xbldt(
    IN TE_INFO_STRUCT *Binary, IN GUID *KeyGuid, OUT UINTN *TargetAddress)
{
  // Find Guid Offset
  UINTN      GuidOffset = 0;
  EFI_STATUS status     = find_guid_in_buffer(Binary, KeyGuid, &GuidOffset);
  if (EFI_ERROR(status)) {
    DEBUG((DEBUG_WARN, "XBLDT guid not found in buffer\n"));
    return EFI_NOT_FOUND;
  }

  // Find all ADRP function
  for (UINT32 offset = 0;
       offset < Binary->fileSize - 8 - sizeof(EFI_TE_IMAGE_HEADER);
       offset += 4) {
    INST instruction = {.val = *(UINT32 *)(Binary->TEBuffer + offset)};

    // Check adrp
    if (validate_adrp(&instruction)) {
      // Found a valid adrp instruction
      parse_adrp(&instruction, offset);

      // Check if there is an add function at next instruction
      INST nInst = {.val = *(UINT32 *)(Binary->TEBuffer + offset + 4)};
      if (validate_add(&nInst)) {
        // Get target address
        UINT32 target_address =
            instruction.adrp.RdAfterExecution + nInst.add.imm12;
        if (target_address == GuidOffset) {
          // Get the adrp instruction at 3 instructions before current one.
          INST bbbInst = {.val = *(UINT32 *)(Binary->TEBuffer + offset - 12)};
          // Check adrp
          if (validate_adrp(&bbbInst)) {
            // Found a valid adrp instruction
            parse_adrp(&bbbInst, offset);

            // Check Add
            INST bbInst = {.val = *(UINT32 *)(Binary->TEBuffer + offset - 8)};
            if (validate_add(&bbInst)) {
              // Get target address
              *TargetAddress = bbbInst.adrp.RdAfterExecution +
                               bbInst.add.imm12 + Binary->teHeader->BaseOfCode +
                               Binary->teHeader->ImageBase;
              return EFI_SUCCESS;
            }
          }
        }
      }
    }
  }

  DEBUG((DEBUG_WARN, "XBLDT Protocol Address not found\n"));
  return EFI_NOT_FOUND;
}

STATIC
EFI_STATUS
get_scheduler_revision(
    IN TE_INFO_STRUCT *Binary,
    IN UINT64          CallerAddress, // caller of set_scheduler_config
    OUT UINT64        *Revision)
{
  EFI_STATUS Status = EFI_SUCCESS;

  // Find sec protocol revision
  Status = find_first_bl_before_offset(
      Binary, phy_addr_to_offset(Binary, CallerAddress), &CallerAddress);
  if (EFI_ERROR(Status))
    goto err_exit;

  Status = find_first_bl_before_offset(
      Binary, phy_addr_to_offset(Binary, CallerAddress), &CallerAddress);
  if (EFI_ERROR(Status))
    goto err_exit;

  Status = get_bl_target_addr(
      Binary, phy_addr_to_offset(Binary, CallerAddress), &CallerAddress);
  if (EFI_ERROR(Status))
    goto err_exit;

  INST movz = {
      .val = *(UINT32 *)(Binary->programBuffer +
                         phy_addr_to_offset(Binary, CallerAddress))};
  INST movk = {
      .val = *(UINT32 *)(Binary->programBuffer + 4 +
                         phy_addr_to_offset(Binary, CallerAddress))};
  if (validate_movz(&movz) && validate_movk(&movk)) {
    *Revision = parse_movz_with_movk(&movz, &movk);
    return EFI_SUCCESS;
  }

err_exit:
  DEBUG((DEBUG_ERROR, "Failed to parse scheduler revision\n"));
  *Revision = 0;
  return EFI_NOT_FOUND;
}

STATIC
EFI_STATUS
FindLKFuncs(IN TE_INFO_STRUCT *Binary, OUT LK_INIT_FUNCTIONS *LkFuncs)
{
  EFI_STATUS Status           = EFI_SUCCESS;
  UINT64     TmpCallerOffset  = 0;
  UINT64     TmpTargetAddress = 0;

  STATIC UINT8 set_scheduler_config_bin[] = {
      0x01, 0x00, 0x40, 0xB9, // ldr w1, [x0]
      0x3F, 0x04, 0x00, 0x71  // cmp w1, #1
  };
  STATIC UINT8 aux_core_entry_bin[] = {
      0x02, 0x20, 0x18, 0xD5, // msr ttbr0_el1, x2
      0xDF, 0x3F, 0x03, 0xD5, // isb
      0x02, 0x00, 0x80, 0x52, // mov w2, #0
      0x22, 0x20, 0x18, 0xD5  // msr ttbr1_el1, x2
  };

  if (NULL == Binary || NULL == LkFuncs)
    return EFI_INVALID_PARAMETER;

  // Check if already initialized
  if (LkFuncs->Initialized == TRUE)
    return EFI_SUCCESS;

  LkFuncs->Initialized = FALSE;

  // Find the place that calls this function
  Status = find_caller_addr_of_func_with_codes(
      Binary, set_scheduler_config_bin, sizeof(set_scheduler_config_bin),
      &TmpCallerOffset);
  if (EFI_ERROR(Status)) {
    DEBUG((DEBUG_ERROR, "Failed to find caller of set_scheduler_config\n"));
    goto exit;
  }

  // Get the first RET before the caller
  Status = find_first_ret_before_offset(
      Binary, phy_addr_to_offset(Binary, TmpCallerOffset), &TmpCallerOffset);
  if (EFI_ERROR(Status)) {
    DEBUG(
        (DEBUG_ERROR,
         "Failed to find RET before caller of set_scheduler_config\n"));
    goto exit;
  }

  // Find the caller of the function after RET
  Status = find_caller_addr_of_func_with_offset(
      Binary, phy_addr_to_offset(Binary, TmpCallerOffset) + 4,
      &TmpCallerOffset);
  if (EFI_ERROR(Status)) {
    DEBUG((DEBUG_ERROR, "Failed to find caller of function after RET\n"));
    goto exit;
  }
  Status = get_bl_target_addr(
      Binary, phy_addr_to_offset(Binary, TmpCallerOffset), &TmpTargetAddress);
  if (EFI_ERROR(Status)) {
    DEBUG(
        (DEBUG_ERROR, "Failed to find target address of function after RET\n"));
    goto exit;
  }
  LkFuncs->lk_gic_config = (VOID *)TmpTargetAddress;

  // Find sec protocol revision
  Status = get_scheduler_revision(Binary, TmpCallerOffset, &LkFuncs->Revision);
  if (EFI_ERROR(Status) || LkFuncs->Revision <= 0x10000) {
    DEBUG((DEBUG_ERROR, "Failed to find scheduler revision\n"));
    goto exit;
  }

  if (LkFuncs->Revision >= 0x10003) {
    UINT64 ret_address                 = 0;
    UINT64 start_scheduler_func_caller = 0;
    // Find revision 1.3 arguements
    Status = find_first_ret_before_offset(
        Binary, phy_addr_to_offset(Binary, TmpCallerOffset), &ret_address);
    // Find who calls this function
    Status = find_caller_addr_of_func_with_offset(
        Binary, phy_addr_to_offset(Binary, ret_address + 4),
        &start_scheduler_func_caller);
    DEBUG(
        (DEBUG_WARN, "StartSchedulerFunc caller at 0x%lX\n",
         start_scheduler_func_caller));
    // Parse ADRL X1, #immediate, it should be right before the BL
    INST adrp_inst = {
        .val = *(
            UINT32 *)(Binary->programBuffer +
                      phy_addr_to_offset(Binary, start_scheduler_func_caller) -
                      8)};
    if (validate_adrp(&adrp_inst)) {
      parse_adrp(
          &adrp_inst,
          phy_addr_to_offset(Binary, start_scheduler_func_caller) - 4);
      INST add_inst = {
          .val = *(UINT32 *)(Binary->programBuffer +
                             phy_addr_to_offset(
                                 Binary, start_scheduler_func_caller) -
                             4)};
      if (validate_add(&add_inst)) {
        LkFuncs->arg1_of_config_and_start_scheduler_func =
            (VOID *)offset_to_phy_addr(
                Binary, adrp_inst.adrp.RdAfterExecution + add_inst.add.imm12);
        DEBUG(
            (EFI_D_WARN, "StartSchedulerFunc arguement at 0x%lX\n",
             (UINTN)LkFuncs->arg1_of_config_and_start_scheduler_func));
      }
    }
  }

  // Find next next BL
  Status = find_first_bl_after_offset(
      Binary, phy_addr_to_offset(Binary, TmpCallerOffset), &TmpCallerOffset);
  if (EFI_ERROR(Status)) {
    DEBUG((DEBUG_ERROR, "Failed to find next BL after lk_gic_config\n"));
    goto exit;
  }
  Status = find_first_bl_after_offset(
      Binary, phy_addr_to_offset(Binary, TmpCallerOffset), &TmpCallerOffset);
  if (EFI_ERROR(Status)) {
    DEBUG((DEBUG_ERROR, "Failed to find next next BL after lk_gic_config\n"));
    goto exit;
  }
  Status = get_bl_target_addr(
      Binary, phy_addr_to_offset(Binary, TmpCallerOffset), &TmpTargetAddress);
  if (EFI_ERROR(Status)) {
    DEBUG(
        (DEBUG_ERROR,
         "Failed to find target address of next BL after lk_gic_config\n"));
    goto exit;
  }
  LkFuncs->lk_init_shutdown1 = (VOID *)TmpTargetAddress;

  if (0x10000 <= LkFuncs->Revision && LkFuncs->Revision <= 0x10002) {
    // Find next BL
    Status = find_first_bl_after_offset(
        Binary, phy_addr_to_offset(Binary, TmpCallerOffset), &TmpCallerOffset);
    if (EFI_ERROR(Status)) {
      DEBUG((DEBUG_ERROR, "Failed to find next BL after lk_init_shutdown1\n"));
      goto exit;
    }
    Status = get_bl_target_addr(
        Binary, phy_addr_to_offset(Binary, TmpCallerOffset), &TmpTargetAddress);
    if (EFI_ERROR(Status)) {
      DEBUG(
          (DEBUG_ERROR, "Failed to find target address of next BL after "
                        "lk_init_shutdown1\n"));
      goto exit;
    }
    LkFuncs->lk_init_shutdown2 = (VOID *)TmpTargetAddress;
  }

  // Find kernel init
  Status = find_first_bl_after_offset(
      Binary, phy_addr_to_offset(Binary, TmpCallerOffset), &TmpCallerOffset);
  if (EFI_ERROR(Status)) {
    DEBUG((DEBUG_ERROR, "Failed to find next BL after lk_init_shutdown2\n"));
    goto exit;
  }
  Status = get_bl_target_addr(
      Binary, phy_addr_to_offset(Binary, TmpCallerOffset), &TmpTargetAddress);
  if (EFI_ERROR(Status)) {
    DEBUG(
        (DEBUG_ERROR,
         "Failed to find target address of next BL after lk_init_shutdown2\n"));
    goto exit;
  }
  LkFuncs->lk_init_scheduler = (VOID *)TmpTargetAddress;

  // Find aux_core_entry
  Status = find_data_in_buffer(
      Binary, aux_core_entry_bin, sizeof(aux_core_entry_bin),
      &TmpTargetAddress);
  if (EFI_ERROR(Status)) {
    DEBUG((DEBUG_ERROR, "Failed to find aux_core_entry\n"));
    goto exit;
  }
  TmpTargetAddress = offset_to_phy_addr(Binary, TmpTargetAddress) -
                     4 * 3; // 3 instructions before
  LkFuncs->lk_aux_cores_entry_point = (VOID *)TmpTargetAddress;

  // Validate all functions physical addresses
  // The physical address Should locate in TE region
  if ((UINTN)LkFuncs->lk_gic_config <
          Binary->teHeader->ImageBase + Binary->teHeader->BaseOfCode ||
      (UINTN)LkFuncs->lk_gic_config > Binary->teHeader->ImageBase +
                                          Binary->teHeader->BaseOfCode +
                                          Binary->teSize ||
      (UINTN)LkFuncs->lk_init_shutdown1 <
          Binary->teHeader->ImageBase + Binary->teHeader->BaseOfCode ||
      (UINTN)LkFuncs->lk_init_shutdown1 > Binary->teHeader->ImageBase +
                                              Binary->teHeader->BaseOfCode +
                                              Binary->teSize ||
      ((LkFuncs->Revision) <= 0x10002 &&
       ((UINTN)LkFuncs->lk_init_shutdown2 <
            Binary->teHeader->ImageBase + Binary->teHeader->BaseOfCode ||
        (UINTN)LkFuncs->lk_init_shutdown2 > Binary->teHeader->ImageBase +
                                                Binary->teHeader->BaseOfCode +
                                                Binary->teSize)) ||
      (UINTN)LkFuncs->lk_init_scheduler <
          Binary->teHeader->ImageBase + Binary->teHeader->BaseOfCode ||
      (UINTN)LkFuncs->lk_init_scheduler > Binary->teHeader->ImageBase +
                                              Binary->teHeader->BaseOfCode +
                                              Binary->teSize ||
      (UINTN)LkFuncs->lk_aux_cores_entry_point <
          Binary->teHeader->ImageBase + Binary->teHeader->BaseOfCode ||
      (UINTN)LkFuncs->lk_aux_cores_entry_point >
          Binary->teHeader->ImageBase + Binary->teHeader->BaseOfCode +
              Binary->teSize) {
    DEBUG((DEBUG_ERROR, "One or more LK function addresses are invalid\n"));
    Status = EFI_NOT_FOUND;
    goto exit;
  }
  else
    LkFuncs->Initialized = TRUE;

exit:
  return Status;
}

VOID InitProtocolFinder(
    IN EFI_PHYSICAL_ADDRESS *ScheAddr, IN EFI_PHYSICAL_ADDRESS *XBLDTOpsAddr)
{
  EFI_STATUS    status               = EFI_SUCCESS;
  STATIC UINT32 EnableMultiThreading = 0;

  // Do search only once
  if (ScheIntrAddr != 0 || SecDTOpsAddr != 0) {
    if (NULL != ScheAddr) {
      *ScheAddr = ScheIntrAddr;
    }

    if (NULL != XBLDTOpsAddr) {
      *XBLDTOpsAddr = SecDTOpsAddr;
    }
    return;
  }

  TE_INFO_STRUCT CoreTE = {0};

  // Find and fill TE info in memory
  if (EFI_ERROR(FindTeAddr(&CoreTE))) {
    DEBUG((DEBUG_ERROR, "Failed to find TE address\n"));
    return;
  };

  // Find Scheduler address
  if (NULL != ScheAddr) {
    status =
        find_protocol_scheduler(&CoreTE, &gEfiSchedIntfGuid, &ScheIntrAddr);

    if (!ScheIntrAddr) {
      // Try variant 2
      DEBUG((EFI_D_WARN, "try find scheduler variant 2\n"));
      status = find_protocol_scheduler_v2(
          &CoreTE, &gEfiSchedIntfGuid, &ScheIntrAddr);
    }

    ASSERT(!EFI_ERROR(status));

    if (!EFI_ERROR(status)) {
      // Fill caller's address
      *ScheAddr = ScheIntrAddr;
    }
  }

  // Find XBLDT address
  if (NULL != XBLDTOpsAddr) {
    status = find_protocol_xbldt(&CoreTE, &gEfiSecDtbGuid, &SecDTOpsAddr);
    ASSERT(!EFI_ERROR(status));

    if (!EFI_ERROR(status)) {
      // Fill caller's address
      *XBLDTOpsAddr = SecDTOpsAddr;
    }
  }

  // Check MultiThreading Enable Flag
  status = LocateConfigurationMapUINT32ByName(
      "EnableMultiThreading", &EnableMultiThreading);
  if (!EFI_ERROR(status) && EnableMultiThreading != 0 &&
      LkInitFuncs.Initialized == FALSE) {
    // Initialize LK functions
    status = FindLKFuncs(&CoreTE, &LkInitFuncs);
  }

  /* Ensure cache coherence */
  WriteBackInvalidateDataCacheRange(&LkInitFuncs, sizeof(LkInitFuncs));
}

VOID StartUpScheduler(VOID *PeiContinueBoot, VOID *AuxCoresEntryPoint)
{
  EFI_STATUS status = EFI_SUCCESS;

  // Check if LK functions are initialized
  if (LkInitFuncs.Initialized == FALSE) {
    DEBUG(
        (DEBUG_ERROR, "LK functions not initialized or Multithreading not "
                      "enabled, cannot start scheduler!\n"));
    return;
  }

  if (!EFI_ERROR(status)) {
    UINT32                          MaxCoreCnt       = 0;
    UINT32                          EarlyInitCoreCnt = 0;
    ARM_MEMORY_REGION_DESCRIPTOR_EX SchedHeap        = {0};

    // Get Max Core Count
    status = LocateConfigurationMapUINT32ByName("MaxCoreCnt", &MaxCoreCnt);
    if (EFI_ERROR(status) || MaxCoreCnt == 0) {
      MaxCoreCnt = 8; // Default max core count
    }

    // Get Early Init Core Count
    status = LocateConfigurationMapUINT32ByName(
        "EarlyInitCoreCnt", &EarlyInitCoreCnt);
    if (EFI_ERROR(status) || EarlyInitCoreCnt == 0) {
      EarlyInitCoreCnt = 2; // Default early init core count
    }

    status = LocateMemoryMapAreaByName("Sched Heap", &SchedHeap);
    if (EFI_ERROR(status)) {
      DEBUG((DEBUG_ERROR, "Failed to locate \"Sched Heap\"\r\n"));
    }

    // Find init function addresses
    LkInitFuncs.lk_gic_config();
    LkInitFuncs.lk_init_shutdown1(MaxCoreCnt);
    DEBUG(
        (DEBUG_WARN, "\tScheduler Revision\t\t: %d.%d\r\n",
         LkInitFuncs.Revision >> 16, LkInitFuncs.Revision & 0xFFFF));
    DEBUG(
        (EFI_D_WARN,
         "\tMultiThreading\t\t: ON\r\n\tCPU Cores\t\t: %d (init %d)\r\n",
         MaxCoreCnt, EarlyInitCoreCnt));

    if (LkInitFuncs.Revision <= 0x10002) {
      LkInitFuncs.lk_init_shutdown2();

      LkInitFuncs.lk_init_scheduler(
          (VOID *)PeiContinueBoot,
          0, // Args?
          SchedHeap.Address, SchedHeap.Length, AuxCoresEntryPoint, MaxCoreCnt,
          EarlyInitCoreCnt);
    }
    else if (LkInitFuncs.Revision >= 0x10003) {
      DEBUG(
          (EFI_D_ERROR, "                  Init scheduler v3: 0x%08lX",
           (UINT64)LkInitFuncs.arg1_of_config_and_start_scheduler_func
               ->CoreRelatedMask));
      LkInitFuncs.lk_init_scheduler_v3(
          (VOID *)PeiContinueBoot,
          0, // Args?
          SchedHeap.Address, SchedHeap.Length, AuxCoresEntryPoint,
          AuxCoresEntryPoint, MaxCoreCnt, EarlyInitCoreCnt,
          LkInitFuncs.arg1_of_config_and_start_scheduler_func->CoreRelatedMask);
    }

    // Should never reach here
    DEBUG((EFI_D_WARN, "MultiThreading Scheduler failed to start!\n"));
  }

  DEBUG((EFI_D_WARN, "\tMultiThreading\t\t: OFF\n"));
}

VOID BootSecondaryCpu(UINTN CpuIdx)
{
  if (LkInitFuncs.lk_aux_cores_entry_point != NULL)
    LkInitFuncs.lk_aux_cores_entry_point(CpuIdx);

  DEBUG((EFI_D_WARN, "\tCore %d hang up\t\t\n", CpuIdx));

  // Boot Failed?
  while (1) {
    asm volatile("wfi\n\t" : : : "memory");
  }
}
