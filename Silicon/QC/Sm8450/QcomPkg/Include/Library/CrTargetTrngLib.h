#pragma once

#include <Base.h>

typedef struct {
  UINTN   BaseAddress;
  UINTN   MmioSize;
  UINTN   DataOutOffset;
  UINTN   StatusOffset;
  UINT32  DataAvailableMask;
  UINTN   MaxEntropyBits;
  UINTN   PollDelayUs;
  UINTN   TimeoutUs;
} CR_TRNG_CONFIG;

CONST CR_TRNG_CONFIG *
CrTargetGetTrngConfig (
  VOID
  );