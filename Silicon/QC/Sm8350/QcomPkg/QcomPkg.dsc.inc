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
  *_*_*_CC_FLAGS = -march=armv8.2-a+crypto+rcpc 

[PcdsFixedAtBuild.common]
  gArmTokenSpaceGuid.PcdSystemMemoryBase|0x80000000         # Starting address, 2GB Base
  gAndromedaPkgTokenSpaceGuid.PcdCpuVectorBaseAddress|0x9ff8c000
  gArmTokenSpaceGuid.PcdArmArchTimerSecIntrNum|29
  gArmTokenSpaceGuid.PcdArmArchTimerIntrNum|30
  gArmTokenSpaceGuid.PcdGicDistributorBase|0x17a00000
  gArmTokenSpaceGuid.PcdGicRedistributorsBase|0x17a60000

  gEfiMdeModulePkgTokenSpaceGuid.PcdAcpiDefaultOemRevision|0x00008350
  gEmbeddedTokenSpaceGuid.PcdPrePiStackBase|0x9ff90000
  gEmbeddedTokenSpaceGuid.PcdPrePiStackSize|0x00040000      # 256K stack
  gEmbeddedTokenSpaceGuid.PcdInterruptBaseAddress|0x09bc0000
  gEmbeddedTokenSpaceGuid.PcdPrePiCpuIoSize|44

  gAndromedaPkgTokenSpaceGuid.PcdSmbiosProcessorModel|"Snapdragon (TM) 888 @ 2.84 GHz"
  gAndromedaPkgTokenSpaceGuid.PcdSmbiosProcessorRetailModel|"SM8350"

  gArmPlatformTokenSpaceGuid.PcdCoreCount|8
  gArmPlatformTokenSpaceGuid.PcdClusterCount|3

  # UART
  gAndromedaPkgTokenSpaceGuid.PcdUartSerialBase|0x0098C000

[LibraryClasses.common]
  # Move PlatformMemoryMapLib to Device/<device>/Library
  # And moved this Line to SurfaceDuo2.dsc
  #  PlatformMemoryMapLib|QcomPkg/Library/PlatformMemoryMapLib/PlatformMemoryMapLib.inf

  # Move PlatformConfigurationMapLib to Device/<device>/Library
  # And moved this Line to SurfaceDuo2.dsc
  #  PlatformConfigurationMapLib|QcomPkg/Library/PlatformConfigurationMapLib/PlatformConfigurationMapLib.inf

  PlatformPeiLib|QcomPkg/PlatformPei/PlatformPeiLib.inf
  PlatformPrePiLib|QcomPkg/Library/PlatformPrePiLib/PlatformPrePiLib.inf
  AslUpdateLib|AndromedaPkg/Library/DxeAslUpdateLib/DxeAslUpdateLib.inf
  RFSProtectionLib|QcomPkg/Library/RFSProtectionLib/RFSProtectionLib.inf

  AcpiPlatformUpdateLib|QcomPkg/Library/AcpiPlatformUpdateLib/AcpiPlatformUpdateLib.inf
  PlatformThemeLib|QcomPkg/Library/PlatformThemeLib/PlatformThemeLib.inf

  ConsoleMsgLib|PcBdsPkg/Library/ConsoleMsgLibNull/ConsoleMsgLibNull.inf