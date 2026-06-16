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

################################################################################
#
# Defines Section - statements that will be processed to create a Makefile.
#
################################################################################
[Defines]
  PLATFORM_NAME                  = Kodiak
  PLATFORM_GUID                  = b6325ac2-9f3f-4b1d-b129-ac7b35ddde60
  PLATFORM_VERSION               = 0.1
  DSC_SPECIFICATION              = 0x00010005
  OUTPUT_DIRECTORY               = Build/$(PLATFORM_NAME)Pkg
  SUPPORTED_ARCHITECTURES        = AARCH64
  BUILD_TARGETS                  = DEBUG|RELEASE
  SKUID_IDENTIFIER               = DEFAULT
  PACKAGE_NAME                   = $(PLATFORM_NAME)Pkg
  FLASH_DEFINITION               = $(PACKAGE_NAME)/$(PLATFORM_NAME).fdf
  SECURE_BOOT                    = 0
  USE_PHYSICAL_TIMER             = 0

  USE_SCREEN_FOR_SERIAL_OUTPUT    = 1
  USE_UART_GENI_FOR_SERIAL_OUTPUT = 0
  USE_UART_DM_FOR_SERIAL_OUTPUT   = 0
  USE_MEMORY_FOR_SERIAL_OUTPUT    = 0

  DEFAULT_KEYS                   = FALSE
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

  PLATFORM_HAS_ACTLR_EL1_UNIMPLEMENTED_ERRATA         = 1
  PLATFORM_HAS_AMCNTENSET0_EL0_UNIMPLEMENTED_ERRATA   = 0
  PLATFORM_HAS_GIC_V3_WITHOUT_IRM_FLAG_SUPPORT_ERRATA = 1
  PLATFORM_HAS_PSCI_MEMPROTECT_FAILING_ERRATA         = 0
[PcdsFixedAtBuild.common]
  # Platform-specific
  gArmTokenSpaceGuid.PcdSystemMemorySize|0x200000000        # 8GB Size

  gAndromedaPkgTokenSpaceGuid.PcdABLProduct|"kodiak"

#[PcdsDynamicDefault.common]
#  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoHorizontalResolution|1344
#  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoVerticalResolution|1892
#  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoHorizontalResolution|1344
#  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoVerticalResolution|1892
#  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupConOutRow|99 # 99.57
#  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupConOutColumn|168
#  gEfiMdeModulePkgTokenSpaceGuid.PcdConOutRow|99 # 99.57
#  gEfiMdeModulePkgTokenSpaceGuid.PcdConOutColumn|168

[Components.common]
  AndromedaPkg/Driver/SimpleFbDxe/SimpleFbDxe.inf
  AndromedaPkg/Driver/GpioButtons/GpioButtons.inf

[LibraryClasses.common]
  # Move PlatformMemoryMapLib form Silicon/QC/QCxxxx/Library to Device/<device>/Library
  PlatformMemoryMapLib|KodiakPkg/Device/$(TARGET_DEVICE)/Library/PlatformMemoryMapLib/PlatformMemoryMapLib.inf

  # Move PlatformConfigurationMapLib form Silicon/QC/QCxxxx/Library to Device/<device>/Library/
  PlatformConfigurationMapLib|KodiakPkg/Device/$(TARGET_DEVICE)/Library/PlatformConfigurationMapLib/PlatformConfigurationMapLib.inf

!include KodiakPkg/Device/$(TARGET_DEVICE)/DXE.dsc.inc
!include QcomPkg/QcomPkg.dsc.inc
!include KodiakPkg/Device/$(TARGET_DEVICE)/PcdsFixedAtBuild.dsc.inc
!include AndromedaPkg/Andromeda.dsc.inc
!include AndromedaPkg/Frontpage.dsc.inc
