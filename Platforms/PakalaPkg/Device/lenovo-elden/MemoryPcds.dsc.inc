# SPDX-License-Identifier: BSD-2-Clause-Patent
# Device memory layout included by the Pakala platform DSC.
[PcdsFixedAtBuild.common]
  gAndromedaPkgTokenSpaceGuid.PcdCpuVectorBaseAddress|0xA7600000
  gEmbeddedTokenSpaceGuid.PcdPrePiStackBase|0xD7BC0000
  gEmbeddedTokenSpaceGuid.PcdPrePiStackSize|0x00040000

# FDF/BootShim FD base must be 0xD7C00000, size 0x00400000.
# Do not infer total installed RAM from the small early DXE arena.
