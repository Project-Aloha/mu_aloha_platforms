[Components.common]
MdeModulePkg/Universal/BdsDxe/BdsDxe.inf {
  <LibraryClasses>
    MsPlatformDevicesLib|$(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Library/MsPlatformDevicesLib/MsPlatformDevicesLib.inf
    NULL|AndromedaPkg/Library/KernelErrataPatcherLib/KernelErrataPatcherLib.inf
}
$(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Drivers/SdMmcPlatformDxe/SdMmcPlatformDxe.inf
MdeModulePkg/Bus/Pci/NonDiscoverablePciDeviceDxe/NonDiscoverablePciDeviceDxe.inf {
  <LibraryClasses>
    # SDCC2 and UFS use inherited identity DMA mappings, not vendor private domains.
    IoMmuLib|MdeModulePkg/Library/IoMmuLibNull/IoMmuLibNull.inf
}
MdeModulePkg/Bus/Pci/SdMmcPciHcDxe/SdMmcPciHcDxe.inf
MdeModulePkg/Bus/Sd/SdDxe/SdDxe.inf
$(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Drivers/UfsPlatformDxe/UfsPlatformDxe.inf
MdeModulePkg/Bus/Pci/UfsPciHcDxe/UfsPciHcDxe.inf
MdeModulePkg/Bus/Ufs/UfsPassThruDxe/UfsPassThruDxe.inf
$(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Drivers/PmicKeysDxe/PmicKeysDxe.inf
AndromedaPkg/Driver/GpioButtons/GpioButtons.inf
$(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PwrUtilsDxe/PwrUtilsDxe.inf
AndromedaPkg/Driver/SimpleFbDxe/SimpleFbDxe.inf
$(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Override/AndromedaPkg/Driver/RamPartitionDxe/RamPartitionDxe.inf
$(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/EnvDxe/EnvDxeEnhanced.inf
$(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SmemDxe/SmemDxe.inf
$(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/DALSYSDxe/DALSYSDxe.inf
$(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HWIODxe/HWIODxe.inf
$(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ChipInfoDxe/ChipInfoDxe.inf
$(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PlatformInfoDxe/PlatformInfoDxe.inf
$(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/CmdDbDxe/CmdDbDxe.inf
SecurityPkg/RandomNumberGenerator/RngDxe/RngDxe.inf {
  <LibraryClasses>
    # Use CPU RNDR and the Arm firmware TRNG interface as entropy sources.
    RngLib|MdePkg/Library/BaseRngLib/BaseRngLib.inf
    ArmTrngLib|ArmPkg/Library/ArmTrngLib/ArmTrngLib.inf
}
