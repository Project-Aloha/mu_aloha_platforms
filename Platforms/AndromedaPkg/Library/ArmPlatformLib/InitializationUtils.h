/** @file

  Copyright (c) 2022-2024 DuoWoA authors

  SPDX-License-Identifier: MIT

**/
#ifndef _INITIALIZATION_UTILS_H_
#define _INITIALIZATION_UTILS_H_

VOID EarlyInitialization(VOID);

UINTN
ArmPlatformIsPrimaryCore (
  IN UINTN MpId
  );
#endif /* _INITIALIZATION_UTILS_H_ */