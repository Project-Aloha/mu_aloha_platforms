// SPDX-License-Identifier: BSD-2-Clause-Patent
#include <AsmMacroIoLib.h>
.text
.align 3
.global _ModuleEntryPoint
.type _ModuleEntryPoint, %function
_ModuleEntryPoint:
  msr daifset, #0xf
  mrs x2, CurrentEL
  cmp x2, #4
  b.eq 1f
  cmp x2, #8
  b.ne 9f
  mrs x3, sctlr_el2
  b 2f
1: mrs x3, sctlr_el1
2: tst x3, #1
  b.ne 9f
  tst x3, #4
  b.ne 9f
  adr x4, EarlyStackTop
  mov sp, x4
  bl LenovoPrePi
9: wfi
  b 9b
.balign 16
EarlyStack:
.space 0x10000
EarlyStackTop:
