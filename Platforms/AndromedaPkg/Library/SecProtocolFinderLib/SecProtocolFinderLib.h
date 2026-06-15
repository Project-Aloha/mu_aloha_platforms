/** @file
    Copyright (c) 2024-2026. DuoWoA Authors. All rights reserved.
    Copyright (c) 2024-2026. Project Aloha Authors. All rights reserved.

    SPDX-License-Identifier: MIT
*/
#ifndef _QC_SEC_PROTOCOLS_LOCATOR_SEC_LIB_H_
#define _QC_SEC_PROTOCOLS_LOCATOR_SEC_LIB_H_
#include <IndustryStandard/PeImage.h>
#include <Library/BaseMemoryLib.h>
#include <Uefi.h>

/* ADRP Instruction */
typedef struct arm64_adrp {
  // extra data
  UINT32 Val; // value in union
  UINT32 imm;
  UINT64 pc;
  UINT64 RdAfterExecution;
  // instruction bit field data
  UINT8  Rd;
  UINT32 immhi;
  UINT8  op2;
  UINT8  immlo;
  UINT8  op1;
} Arm64Adrp;

/* ADD Instruction */
typedef struct arm64_add {
  // extra data
  UINT32 Val; // value in union
  UINT32 imm;
  UINT64 pc;
  UINT64 RdAfterExecution;
  // instruction bit field data
  UINT8  Rd;
  UINT8  Rn;
  UINT16 imm12;
  UINT8  sh;
  UINT8  op2;
  UINT8  s;
  UINT8  op1;
  UINT8  sf;
} Arm64Add;

typedef struct arm64_bl {
  // extra data
  UINT32 Val; // value in union
  INT32  imm;
  UINT64 pc;
  UINT64 jumpAddr;
  // instruction bit field data
  UINT32 imm26;
  UINT8  op;
} Arm64Bl;

typedef struct arm64_mov {
  // extra data
  UINT32 Val; // value in union
  UINT64 imm;
  // instruction instructure
  UINT8  Rd;
  UINT16 imm16;
  UINT8  hw;
  UINT8  opc;
  UINT8  sf;
} Arm64Mov;

/* MASKs to get args value in ADRP */
#define ADRP_RD(Ins) ((Ins) & 0x1F)
#define ADRP_IMMHI(Ins) (((Ins) >> 5) & 0x7FFFF)
#define ADRP_OP2(Ins) (((Ins) >> 24) & 0x1F)
#define ADRP_IMMLO(Ins) (((Ins) >> 29) & 0x3)
#define ADRP_OP1(Ins) (((Ins) >> 31) & 0x1)

/* MASKs to get args value in ADD */
#define ADD_RD(Ins) ((Ins) & 0x1F)
#define ADD_RN(Ins) (((Ins) >> 5) & 0x1F)
#define ADD_IMM12(Ins) (((Ins) >> 10) & 0xFFF)
#define ADD_SH(Ins) (((Ins) >> 22) & 0x1)
#define ADD_OP2(Ins) (((Ins) >> 23) & 0x3F)
#define ADD_S(Ins) (((Ins) >> 29) & 0x1)
#define ADD_OP1(Ins) (((Ins) >> 30) & 0x1)
#define ADD_SF(Ins) (((Ins) >> 31) & 0x1)

/* MASKs to get args value in BL */
#define BL_IMM26(Ins) ((Ins) & 0x3FFFFFF)
#define BL_OP(Ins) (((Ins) >> 26) & 0x3f)

/* MASKs to get args value in MOVK/MOVZ */
#define MOV_SF(Ins) (((Ins) >> 31) & 0x1)
#define MOV_OPC(Ins) (((Ins) >> 23) & 0xFF)
#define MOV_HW(Ins) (((Ins) >> 21) & 0x3)
#define MOV_IMM16(Ins) (((Ins) >> 5) & 0xFFFF)
#define MOV_RD(Ins) ((Ins) & 0x1f)

/* A Union for uni operations of instructions */
typedef union Ins {
  Arm64Adrp adrp;
  Arm64Add  add;
  Arm64Bl   bl;
  Arm64Mov  movz;
  Arm64Mov  movk;
  UINT32    val;
} INST;

// TE informations
typedef struct {
  union {
    VOID                *TEBuffer;
    EFI_TE_IMAGE_HEADER *teHeader;
  };
  VOID *programBuffer;
  UINTN teSize;
  UINTN fileSize;
} TE_INFO_STRUCT;

// LK Functions in Sec
typedef VOID (*LK_CONTINUE_BOOT)(VOID *ARG);
typedef VOID (*LK_AUX_CORE_ENTRY)(UINT64 CoreIdx);
typedef VOID (*LK_GIC_CONFIG)(VOID);
typedef VOID (*LK_SHUTDOWN_INIT1)(UINT64 MaxCoreCnt);
typedef VOID (*LK_SHUTDOWN_INIT2)(VOID);
typedef VOID (*LK_SCHEDULER_INIT)(
    LK_CONTINUE_BOOT PeiContinueBoot, UINT64 zero, UINT64 SchedHeapBase,
    UINT64 SchedHeapSize, LK_AUX_CORE_ENTRY AuxCoresEntryPoint,
    UINT32 MaxCoreCnt, UINT32 EarlyInitCoreCnt);

typedef VOID (*LK_SCHEDULER_INIT_V3)(
    LK_CONTINUE_BOOT PeiContinueBoot, UINT64 zero, UINT64 SchedHeapBase,
    UINT64 SchedHeapSize, LK_AUX_CORE_ENTRY AuxCoresEntryPoint1,
    LK_AUX_CORE_ENTRY AuxCoresEntryPoint2, UINT32 MaxCoreCnt,
    UINT32 EarlyInitCoreCnt, UINT64 CoreRelatedMask);

typedef VOID (*LK_AUX_CORES_ENTRY_POINT)(UINTN CpuIdx);

#pragma pack(1)
typedef struct {
  UINT32 Revision;          // 0x10000
  UINT32 MaxCoreCount;      // MaxCoreCount
  UINT32 EarlyInitCoreCnt;  // EarlyInitCoreCnt
  UINT32 IsFunctionalCoreCountToOverrideFlag; // ? IsFunctionalCoreCountToOverrideFlag, is 6 on sm8850
  UINT64 CoreRelatedMask;   // ? unknown
  UINT64 TimeStamp;         // read from CNTVCT_EL0, guess boot time.
  UINT64 UefiStackBase;     // UEFI Stack base
} LK_START_ARG1;
#pragma pack()

typedef struct {
  UINT64                   Revision;
  BOOLEAN                  Initialized;
  LK_GIC_CONFIG            lk_gic_config;
  union {
    LK_SCHEDULER_INIT      lk_init_scheduler;
    LK_SCHEDULER_INIT_V3   lk_init_scheduler_v3;
  };
  LK_SHUTDOWN_INIT1        lk_init_shutdown1;
  LK_SHUTDOWN_INIT2        lk_init_shutdown2;
  LK_AUX_CORES_ENTRY_POINT lk_aux_cores_entry_point;
  LK_START_ARG1           *arg1_of_config_and_start_scheduler_func;
} LK_INIT_FUNCTIONS;

#endif /* _QC_SEC_PROTOCOLS_LOCATOR_SEC_LIB_H_ */
