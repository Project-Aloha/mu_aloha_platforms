## @file
#
#  Copyright (c) 2011-2015, ARM Limited. All rights reserved.
#  Copyright (c) 2014, Linaro Limited. All rights reserved.
#  Copyright (c) 2015 - 2016, Intel Corporation. All rights reserved.
#  Copyright (c) 2018 - 2019, Bingxing Wang. All rights reserved.
#
#  SPDX-License-Identifier: BSD-2-Clause-Patent
#
##
[BuildOptions.common]
  *_*_*_CC_FLAGS = -march=armv9-a+crypto+rcpc

[PcdsFixedAtBuild.common]
  gArmTokenSpaceGuid.PcdSystemMemoryBase|0x80000000         # Starting address, 2GB Base
  gArmTokenSpaceGuid.PcdArmArchTimerSecIntrNum|29
  gArmTokenSpaceGuid.PcdArmArchTimerIntrNum|30
  # Lenovo Elden stock DTB: GICD=0x16000000, GICR=0x16080000 (stride 0x40000).
  # 0x16040000 is ITS, NOT a legacy GICC interface.
  gArmTokenSpaceGuid.PcdGicDistributorBase|0x16000000
  gArmTokenSpaceGuid.PcdGicRedistributorsBase|0x16080000
  gArmTokenSpaceGuid.PcdGicInterruptInterfaceBase|0

  gEfiMdeModulePkgTokenSpaceGuid.PcdAcpiDefaultOemRevision|0x00008750

  gAndromedaPkgTokenSpaceGuid.PcdSmbiosProcessorModel|"Snapdragon 8 Elite"
  gAndromedaPkgTokenSpaceGuid.PcdSmbiosProcessorRetailModel|"SM8750"

  gArmPlatformTokenSpaceGuid.PcdCoreCount|8

  # UART
  gAndromedaPkgTokenSpaceGuid.PcdUartSerialBase|0xA9C000

[LibraryClasses.common]
  PlatformPeiLib|QcomPkg/Library/PlatformPeiLib/PlatformPeiLib.inf
  PlatformPrePiLib|QcomPkg/Library/PlatformPrePiLib/PlatformPrePiLib.inf
  PlatformThemeLib|MsGraphicsPkg/Library/SamplePlatformThemeLib/PlatformThemeLib.inf

  AcpiPlatformUpdateLib|QcomPkg/Library/AcpiPlatformUpdateLibNull/AcpiPlatformUpdateLibNull.inf
