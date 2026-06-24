## @file
#
#  Copyright (c) 2011-2015, ARM Limited. All rights reserved.
#  Copyright (c) 2014, Linaro Limited. All rights reserved.
#  Copyright (c) 2015 - 2016, Intel Corporation. All rights reserved.
#  Copyright (c) 2018, Bingxing Wang. All rights reserved.
#
#  SPDX-License-Identifier: BSD-2-Clause-Patent
#
##

!ifndef TARGET_DEVICE
  !error "TARGET_DEVICE must be defined"
!endif

################################################################################
#
# Defines Section - statements that will be processed to create a Makefile.
#
################################################################################
[Defines]
  PLATFORM_NAME                  = Rennell
  PLATFORM_GUID                  = b6325ac2-9f3f-4b1d-b129-ac7b35ddde62
  PLATFORM_VERSION               = 0.1
  DSC_SPECIFICATION              = 0x00010005
  OUTPUT_DIRECTORY               = Build/$(PLATFORM_NAME)Pkg
  SUPPORTED_ARCHITECTURES        = AARCH64
  BUILD_TARGETS                  = DEBUG|RELEASE
  SKUID_IDENTIFIER               = DEFAULT
  PACKAGE_NAME                   = $(PLATFORM_NAME)Pkg
  FLASH_DEFINITION               = $(PACKAGE_NAME)/$(PLATFORM_NAME).fdf
  SECURE_BOOT                    = 1
  USE_PHYSICAL_TIMER             = 1

  USE_SCREEN_FOR_SERIAL_OUTPUT    = 0
  USE_UART_GENI_FOR_SERIAL_OUTPUT = 0
  USE_UART_DM_FOR_SERIAL_OUTPUT   = 0
  USE_MEMORY_FOR_SERIAL_OUTPUT    = 0

  USE_SIMPLEFBDXE                = 1

  DEFAULT_KEYS                   = TRUE
  PK_DEFAULT_FILE                = AndromedaPkg/Include/Resources/SecureBoot/keystore/WOAMSMNILE-PK.der
  KEK_DEFAULT_FILE1              = AndromedaPkg/Include/Resources/SecureBoot/keystore/KEK/Certificates/MicCorKEKCA2011_2011-06-24.der
  KEK_DEFAULT_FILE2              = AndromedaPkg/Include/Resources/SecureBoot/keystore/KEK/Certificates/microsoft_corporation_kek_2k_ca_2023.der
  KEK_DEFAULT_FILE3              = AndromedaPkg/Include/Resources/SecureBoot/keystore/WOAMSMNILE-KEK.der
  DB_DEFAULT_FILE1               = AndromedaPkg/Include/Resources/SecureBoot/keystore/DB/Certificates/MicWinProPCA2011_2011-10-19.der
  DB_DEFAULT_FILE2               = AndromedaPkg/Include/Resources/SecureBoot/keystore/DB/Certificates/windows_uefi_ca_2023.der
  DB_DEFAULT_FILE3               = AndromedaPkg/Include/Resources/SecureBoot/keystore/DB/Certificates/MicCorUEFCA2011_2011-06-27.der
  DB_DEFAULT_FILE4               = AndromedaPkg/Include/Resources/SecureBoot/keystore/DB/Certificates/microsoft_uefi_ca_2023.der
  DB_DEFAULT_FILE5               = AndromedaPkg/Include/Resources/SecureBoot/keystore/DB/Certificates/microsoft_option_rom_uefi_ca_2023.der
  DBX_DEFAULT_FILE1              = AndromedaPkg/Include/Resources/SecureBoot/Artifacts/Aarch64/DefaultDbx.bin

  DXE_CRYPTO_SERVICES            = STANDARD
  PEI_CRYPTO_SERVICES            = NONE
  RUNTIMEDXE_CRYPTO_SERVICES     = NONE
  SMM_CRYPTO_SERVICES            = NONE
  STANDALONEMM_CRYPTO_SERVICES   = NONE
  DXE_CRYPTO_ARCH                = AARCH64
  RUNTIMEDXE_CRYPTO_ARCH         = AARCH64
  PEI_CRYPTO_ARCH                = NONE
  SMM_CRYPTO_ARCH                = NONE
  STANDALONEMM_CRYPTO_ARCH       = NONE

  PLATFORM_HAS_ACTLR_EL1_UNIMPLEMENTED_ERRATA         = 0
  PLATFORM_HAS_AMCNTENSET0_EL0_UNIMPLEMENTED_ERRATA   = 0
  PLATFORM_HAS_GIC_V3_WITHOUT_IRM_FLAG_SUPPORT_ERRATA = 0
  PLATFORM_HAS_PSCI_MEMPROTECT_FAILING_ERRATA         = 1

!include RennellPkg/Device/$(TARGET_DEVICE)/Defines.dsc.inc

[BuildOptions.common]

GCC:*_*_AARCH64_CC_FLAGS = -DSILICON_PLATFORM=7125

[PcdsFixedAtBuild.common]
  # Platform-specific
  gArmTokenSpaceGuid.PcdSystemMemorySize|0x180000000            # 6GB

  gAndromedaPkgTokenSpaceGuid.PcdABLProduct|"rennell"

[Components.common]
  # Graphics Driver
  !if $(USE_SIMPLEFBDXE) == TRUE
    AndromedaPkg/Driver/SimpleFbDxe/SimpleFbDxe.inf
  !endif
  AndromedaPkg/Driver/GpioButtons/GpioButtons.inf

  # Auto Memory Adder
  AndromedaPkg/Driver/RamPartitionDxe/RamPartitionDxe.inf

# Device Specific Drivers
!include RennellPkg/Device/$(TARGET_DEVICE)/DXE.dsc.inc

[LibraryClasses.common]
  # Move PlatformMemoryMapLib to Device/<device>/Library
  PlatformMemoryMapLib|RennellPkg/Device/$(TARGET_DEVICE)/Library/PlatformMemoryMapLib/PlatformMemoryMapLib.inf

  # Move PlatformConfigurationMapLib to Device/<device>/Library
  PlatformConfigurationMapLib|RennellPkg/Device/$(TARGET_DEVICE)/Library/PlatformConfigurationMapLib/PlatformConfigurationMapLib.inf


# Suggest you updating them to your device's dsc.inc.
#[PcdsDynamicDefault.common]
#  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoHorizontalResolution|1080
#  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoVerticalResolution|2248
#  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoHorizontalResolution|1080
#  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoVerticalResolution|2248
#  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupConOutRow|120 # 94.73
#  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupConOutColumn|90 # 168.75
#  gEfiMdeModulePkgTokenSpaceGuid.PcdConOutRow|120 # 94.73
#  gEfiMdeModulePkgTokenSpaceGuid.PcdConOutColumn|90 # 168.75

!include QcomPkg/QcomPkg.dsc.inc
!include RennellPkg/Device/$(TARGET_DEVICE)/PcdsFixedAtBuild.dsc.inc
!include AndromedaPkg/Andromeda.dsc.inc
!include AndromedaPkg/Frontpage.dsc.inc
