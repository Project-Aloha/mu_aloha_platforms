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
  gAndromedaPkgTokenSpaceGuid.PcdCpuVectorBaseAddress|0xa7600000
  gArmTokenSpaceGuid.PcdArmArchTimerSecIntrNum|29
  gArmTokenSpaceGuid.PcdArmArchTimerIntrNum|30
  gArmTokenSpaceGuid.PcdGicDistributorBase|0x17100000
  gArmTokenSpaceGuid.PcdGicRedistributorsBase|0x17180000
  gArmTokenSpaceGuid.PcdGicInterruptInterfaceBase|0x17140000

  gEfiMdeModulePkgTokenSpaceGuid.PcdAcpiDefaultOemRevision|0x00008550
  gEmbeddedTokenSpaceGuid.PcdPrePiStackBase|0xa760d000
  gEmbeddedTokenSpaceGuid.PcdPrePiStackSize|0x00040000      # 256K stack
  # TODO: Find the PcdInterruptBaseAddress
  gEmbeddedTokenSpaceGuid.PcdInterruptBaseAddress|0x09bc0000
  gEmbeddedTokenSpaceGuid.PcdPrePiCpuIoSize|44

  gAndromedaPkgTokenSpaceGuid.PcdSmbiosProcessorModel|"Snapdragon (TM) 8 Gen 2 @ 3.19 GHz"
  gAndromedaPkgTokenSpaceGuid.PcdSmbiosProcessorRetailModel|"SM8550"

  gArmPlatformTokenSpaceGuid.PcdCoreCount|8
  gArmPlatformTokenSpaceGuid.PcdClusterCount|3

  # UART
  gAndromedaPkgTokenSpaceGuid.PcdUartSerialBase|0xA9C000

[LibraryClasses.common]
  # Different Device has different Memory Map.
  # So the define of this Lib is moved to KailuaPkg/Kailua.dsc
  #PlatformMemoryMapLib|QcomPkg/Library/PlatformMemoryMapLib/PlatformMemoryMapLib.inf

  # Different Device has different Configuration Map.
  # So the define of this Lib is moved to KailuaPkg/Kailua.dsc
  #PlatformConfigurationMapLib|QcomPkg/Library/PlatformConfigurationMapLib/PlatformConfigurationMapLib.inf

  PlatformPeiLib|QcomPkg/PlatformPei/PlatformPeiLib.inf
  PlatformPrePiLib|QcomPkg/Library/PlatformPrePiLib/PlatformPrePiLib.inf
  AslUpdateLib|AndromedaPkg/Library/DxeAslUpdateLib/DxeAslUpdateLib.inf
  RFSProtectionLib|QcomPkg/Library/RFSProtectionLib/RFSProtectionLib.inf

  AcpiPlatformUpdateLib|QcomPkg/Library/AcpiPlatformUpdateLib/AcpiPlatformUpdateLib.inf
  PlatformThemeLib|QcomPkg/Library/PlatformThemeLib/PlatformThemeLib.inf

  ConsoleMsgLib|PcBdsPkg/Library/ConsoleMsgLibNull/ConsoleMsgLibNull.inf