#include <Library/CrTargetTrngLib.h>

STATIC CONST CR_TRNG_CONFIG  Sm8350TrngConfig = {
  .BaseAddress       = 0x010D3000,
  .MmioSize          = 0x1000,
  .DataOutOffset     = 0x0000,
  .StatusOffset      = 0x0004,
  .DataAvailableMask = BIT0,
  .MaxEntropyBits    = 32,
  .PollDelayUs       = 200,
  .TimeoutUs         = 10000,
};

CONST CR_TRNG_CONFIG *
CrTargetGetTrngConfig (
  VOID
  )
{
  return &Sm8350TrngConfig;
}