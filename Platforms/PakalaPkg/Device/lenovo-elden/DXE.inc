# Minimal imported service set; preserve stock PON configuration.
INF MdeModulePkg/Universal/Console/GraphicsConsoleDxe/GraphicsConsoleDxe.inf
INF MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Drivers/UfsPlatformDxe/UfsPlatformDxe.inf
INF MdeModulePkg/Bus/Pci/UfsPciHcDxe/UfsPciHcDxe.inf
INF MdeModulePkg/Bus/Ufs/UfsPassThruDxe/UfsPassThruDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Drivers/SdMmcPlatformDxe/SdMmcPlatformDxe.inf
INF MdeModulePkg/Bus/Pci/NonDiscoverablePciDeviceDxe/NonDiscoverablePciDeviceDxe.inf
INF MdeModulePkg/Bus/Pci/SdMmcPciHcDxe/SdMmcPciHcDxe.inf
INF MdeModulePkg/Bus/Sd/SdDxe/SdDxe.inf
# Publish the ACPI SDT protocol without installing board ACPI tables.
INF MdeModulePkg/Universal/Acpi/AcpiTableDxe/AcpiTableDxe.inf
FILE DRIVER = CB29F4D1-7F37-4692-A416-93E82E219711 {
  SECTION DXE_DEPEX_EXP = { gEldenDalSysProtocolGuid AND gEldenNpaLogProtocolGuid }
  SECTION PE32 = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/NpaDxe/NpaDxe.efi
  SECTION UI = "NpaDxe"
}
# Stock command database and power resource services.
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PwrUtilsDxe/PwrUtilsDxe.inf
# Retain stock dependencies plus Env constructor and PwrUtils table service.
FILE DRIVER = 4DB5DEA6-5302-4D1A-8A82-677A683B0D29 {
  SECTION DXE_DEPEX_EXP = { gEldenDalSysProtocolGuid AND gEldenClockChipInfoProtocolGuid AND gEldenClockCmdDbProtocolGuid AND gEldenEnvServicesProtocolGuid AND gEldenPwrUtilsProtocolGuid AND gEldenNpaProtocolGuid }
  SECTION PE32 = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ClockDxe/ClockDxe.efi
  SECTION UI = "ClockDxe"
}
INF AndromedaPkg/Driver/SimpleFbDxe/SimpleFbDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Override/AndromedaPkg/Driver/RamPartitionDxe/RamPartitionDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Drivers/PmicKeysDxe/PmicKeysDxe.inf
INF AndromedaPkg/Driver/GpioButtons/GpioButtons.inf
# SPMI protocol only: no ButtonsDxe or PmicDxe/PON configuration.
FILE DRIVER = 2A7B4BEF-80CD-49E1-B473-374BA4D673FC {
  SECTION DXE_DEPEX_EXP = { gEldenDalSysProtocolGuid }
  SECTION PE32 = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SPMIDxe/SPMIDxe.efi
  SECTION UI = "SPMIDxe"
}
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/CmdDbDxe/CmdDbDxe.inf
INF SecurityPkg/RandomNumberGenerator/RngDxe/RngDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/EnvDxe/EnvDxeEnhanced.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SmemDxe/SmemDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/DALSYSDxe/DALSYSDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HWIODxe/HWIODxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ChipInfoDxe/ChipInfoDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PlatformInfoDxe/PlatformInfoDxe.inf
# ULog's DAL constructor requires the DALSys protocol.
# Stock DEPEX is TRUE; encode the missing dependency without patching its PE.
FILE DRIVER = E43128A8-8692-42B6-8AFA-676158578D18 {
  SECTION DXE_DEPEX_EXP = { gEldenDalSysProtocolGuid }
  SECTION PE32 = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ULogDxe/ULogDxe.efi
  SECTION UI = "ULogDxe"
}
