# INF QcomPkg/XBLCore/XBLCore.inf

#FILE FREEFORM = DDE58710-41CD-4306-DBFB-3FA90BB1D2DD {
#    SECTION UI = "uefiplat.cfg"
#    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/uefiplat.cfg
#}

INF Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/AdapterInformationDxe/AdapterInformationDxe.inf
#INF Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/CPRDxe/CPRDxe.inf
INF Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/OSConfigDxe/OSConfigDxe.inf
INF Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/ShmBridgeDxe/ShmBridgeDxe.inf
INF Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/UsbDeviceDxe/UsbDeviceDxe.inf
INF Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/UsbInitDxe/UsbInitDxe.inf
INF Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/UsbMsdDxe/UsbMsdDxe.inf
INF Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/XhciPciEmulationDxe/XhciPciEmulationDxe.inf
INF Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/DppDxe/DppDxe.inf
INF Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/RawFileSystemDxe/RawFileSystemDxe.inf
INF Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/UsbfnChgDxe/UsbfnChgDxe.inf
INF AndromedaPkg/Driver/SimpleFbDxe/SimpleFbDxe.inf

#INF MdeModulePkg/Core/Dxe/DxeMain.inf
#INF ArmPkg/Drivers/CpuDxe/CpuDxe.inf
#INF MdeModulePkg/Core/RuntimeDxe/RuntimeDxe.inf
#INF MdeModulePkg/Universal/SecurityStubDxe/SecurityStubDxe.inf
#INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SecRSADxe/SecRSADxe.inf
#INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ASN1X509Dxe/ASN1X509Dxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/VerifiedBootDxe/VerifiedBootDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TzDxe/ScmDxeLA.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TzDxe/TzDxeLA.inf
#INF MdeModulePkg/Universal/WatchdogTimerDxe/WatchdogTimer.inf
#INF MdeModulePkg/Universal/CapsuleRuntimeDxe/CapsuleRuntimeDxe.inf
#INF MdeModulePkg/Universal/ReportStatusCodeRouter/RuntimeDxe/RscRtDxe.inf
#INF MdeModulePkg/Universal/StatusCodeHandler/RuntimeDxe/SCHandlerRtDxe.inf
#INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/VariableDxe/VariableDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/EmbeddedMonotonicCounter/EmbeddedMonotonicCounter.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SimpleTextInOutSerialDxe/SimpleTextInOutSerial.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ResetRuntimeDxe/ResetRuntimeDxe.inf
#INF EmbeddedPkg/RealTimeClockRuntimeDxe/RealTimeClockRuntimeDxe.inf
#INF EmbeddedPkg/MetronomeDxe/MetronomeDxe.inf
#INF MdeModulePkg/Universal/PrintDxe/PrintDxe.inf
#INF MdeModulePkg/Universal/DevicePathDxe/DevicePathDxe.inf
#INF MdeModulePkg/Universal/Console/ConPlatformDxe/ConPlatformDxe.inf
#INF MdeModulePkg/Universal/Console/ConSplitterDxe/ConSplitterDxe.inf
#INF MdeModulePkg/Universal/Console/GraphicsConsoleDxe/GraphicsConsoleDxe.inf
#INF MdeModulePkg/Universal/HiiDatabaseDxe/HiiDatabaseDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/FontDxe/FontDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/EnvDxe/EnvDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/QcomWDogDxe/QcomWDogDxe.inf
#INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/QcomMpmTimerDxe/QcomMpmTimerDxe.inf
#INF ArmPkg/Drivers/ArmGic/ArmGicDxe.inf
#INF ArmPkg/Drivers/TimerDxe/TimerDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ChipInfoDxe/ChipInfoDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SmemDxe/SmemDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ULogDxe/ULogDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/NpaDxe/NpaDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/CmdDbDxe/CmdDbDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/RpmhDxe/RpmhDxe.inf
#INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/CPRDxe/CPRDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PdcDxe/PdcDxe.inf
#INF MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.inf
#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.inf
#INF FatPkg/EnhancedFatDxe/Fat.inf
#INF MdeModulePkg/Universal/Disk/UnicodeCollation/EnglishDxe/EnglishDxe.inf
#INF MdeModulePkg/Universal/FvSimpleFileSystemDxe/FvSimpleFileSystemDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/DALSYSDxe/DALSYSDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ClockDxe/ClockDxe.inf
#INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HALIOMMUDxe/HALIOMMUDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HWIODxe/HWIODxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/GpiDxe/GpiDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/I2CDxe/I2CDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SPMIDxe/SPMIDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SdccDxe/SdccDxe.inf
#INF QcomPkg/Drivers/UFSDxe/UFSDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TLMMDxe/TLMMDxe.inf
#INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/DisplayDxe/DisplayDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PlatformInfoDxe/PlatformInfoDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ButtonsDxe/ButtonsDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PmicDxe/PmicDxeLa.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ChargerExDxe/ChargerExDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/QcomChargerDxe/QcomChargerDxeLA.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/AdcDxe/AdcDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TsensDxe/TsensDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/LimitsDxe/LimitsDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/DDRInfoDxe/DDRInfoDxe.inf
#INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HashDxe/HashDxe.inf
#INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/CipherDxe/CipherDxe.inf
#INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/RNGDxe/RngDxe.inf
#INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/QcomBds/QcomBds.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PILDxe/PILDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Application/QcomChargerApp/QcomChargerApp.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbPwrCtrlDxe/UsbPwrCtrlDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbConfigDxe/UsbConfigDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbfnDwc3Dxe/UsbfnDwc3Dxe.inf
#INF MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ShmBridgeDxe/ShmBridgeDxeLA.inf

# Patched Binaries
INF QcomPkg/PatchedBinaries/78EF0A56-1CF0-4535-B5DA-F6FD2F405A25.inf
INF QcomPkg/PatchedBinaries/HALIOMMUDxe.inf
INF MooreaPkg/Device/$(TARGET_DEVICE)/PatchedBinaries/UFSDxe.inf

# DXE without depex
FILE DRIVER = 6b38f7b4-ad98-40e9-9093-aca2b5a253c4 {
    SECTION PE32 = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/DiskIoDxe/DiskIoDxe.efi
    SECTION UI = "DiskIoDxe"
}

FILE DRIVER = 1fa1f39e-feff-4aae-bd7b-38a070a3b609 {
    SECTION PE32 = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PartitionDxe/PartitionDxe.efi
    SECTION UI = "PartitionDxe"
}

FILE DRIVER = 3adf8dda-1850-44c5-8c63-bb991849bc6f {
    SECTION UI = "HashDxe"
#    SECTION RAW = Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/HashDxe/HashDxe.raw
    SECTION PE32 = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HashDxe/HashDxe.efi
}

FILE DRIVER = 5f0937cd-73f9-445e-b320-bb6fd5d3cbde {
    SECTION UI = "CipherDxe"
#    SECTION RAW = Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/CipherDxe/CipherDxe.raw
    SECTION PE32 = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/CipherDxe/CipherDxe.efi
}

FILE DRIVER = b0d3689e-11f8-43c6-8ece-023a29cec35b {
    SECTION UI = "RngDxe"
#    SECTION RAW = Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/RNGDxe/RngDxe.raw
    SECTION PE32 = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/RNGDxe/RngDxe.efi
}

FILE DRIVER = 32C71E68-83A8-46ED-AED1-094E71B12057 {
    SECTION PE32 = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SecRSADxe/SecRSADxe.efi
    SECTION UI = "SecRSADxe"
}

FILE DRIVER = C2F9A4F5-F7B4-43E7-BA99-5EA804CC103A {
    SECTION PE32 = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ASN1X509Dxe/ASN1X509Dxe.efi
    SECTION UI = "ASN1X509Dxe"
}

FILE DRIVER = B7F50E91-A759-412C-ADE4-DCD03E7F7C28 {
    SECTION PE32 = Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/XhciDxe/XhciDxe.efi
    SECTION UI = "XhciDxe"
}

FILE DRIVER = 240612B7-A063-11D4-9A3A-0090273FC14D {
    SECTION PE32 = Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/UsbBusDxe/UsbBusDxe.efi
    SECTION UI = "UsbBusDxe"
}

#FILE DRIVER = 2D2E62CF-9ECF-43B7-8219-94E7FC713DFE {
#    SECTION PE32 = Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/UsbKbDxe/UsbKbDxe.efi
#    SECTION UI = "UsbKbDxe"
#}

FILE DRIVER = 9FB4B4A7-42C0-4BCD-8540-9BCC6711F83E {
    SECTION PE32 = Rennell/BOOT.XF.3.1.1-00014-SC7180XWZB-1/QcomPkg/Drivers/UsbMassStorageDxe/UsbMassStorageDxe.efi
    SECTION UI = "UsbMassStorageDxe"
}

# Raw Files
FILE FREEFORM = A91D838E-A5FA-4138-825D-455E2303079E {
    SECTION UI = "BDS_Menu.cfg"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/BDS_Menu.cfg
}


FILE FREEFORM = A91D838E-A5FA-4138-825D-455E23030794 {
    SECTION UI = "logo1.bmp"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/logo1.bmp
}


FILE FREEFORM = 88CA5ABF-D0AC-4093-A68C-0CFAE1EF9635 {
    SECTION UI = "Panel_boe_amoled_wqhd_dsc_cmd.xml"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_boe_amoled_wqhd_dsc_cmd.xml
}


FILE FREEFORM = 45A8FDA2-4FAD-4234-BCDA-D1778611CE13 {
    SECTION UI = "Panel_boe_amoled_wqhd_dsc_vid.xml"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_boe_amoled_wqhd_dsc_vid.xml
}


FILE FREEFORM = 92FA25C1-5EDD-4328-8924-A66F25F82500 {
    SECTION UI = "Panel_boe_amoled_fhd_plus_dsc_cmd.xml"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_boe_amoled_fhd_plus_dsc_cmd.xml
}


FILE FREEFORM = 6343A5E1-E477-452A-B62C-1560C4CBD9F5 {
    SECTION UI = "Panel_secondary_truly_1080p_cmd.xml"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_secondary_truly_1080p_cmd.xml
}


FILE FREEFORM = 151C5D22-957F-4861-A605-E27154BBDA25 {
    SECTION UI = "Panel_secondary_truly_1080p_vid.xml"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_secondary_truly_1080p_vid.xml
}


FILE FREEFORM = 0155F46D-AE6B-45F3-9273-ED5234366857 {
    SECTION UI = "Panel_sharp_wqhd_dualdsi_cmd.xml"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_sharp_wqhd_dualdsi_cmd.xml
}


FILE FREEFORM = 6AA4C932-31FA-4136-9F8F-0954BB55C2F3 {
    SECTION UI = "Panel_sharp_wqhd_dualdsi_vid.xml"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_sharp_wqhd_dualdsi_vid.xml
}


FILE FREEFORM = 3E5584ED-05D4-4267-9048-0D47F76F4248 {
    SECTION UI = "battery_symbol_Soc10.bmp"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/battery_symbol_Soc10.bmp
}


FILE FREEFORM = 4753E815-DDD8-402D-BF69-9B8C4EB7573E {
    SECTION UI = "battery_symbol_NoBattery.bmp"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/battery_symbol_NoBattery.bmp
}


FILE FREEFORM = 03DED53E-BECD-428F-9F79-5ABA64C58445 {
    SECTION UI = "battery_symbol_Nocharger.bmp"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/battery_symbol_Nocharger.bmp
}


FILE FREEFORM = 8B86CD38-C772-4FCF-85AA-345B2B3C1AB4 {
    SECTION UI = "battery_symbol_LowBatteryCharging.bmp"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/battery_symbol_LowBatteryCharging.bmp
}


FILE FREEFORM = 3FD97907-93F1-4349-AF3C-3B68B0A5E626 {
    SECTION UI = "battery_symbol_LowBattery.bmp"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/battery_symbol_LowBattery.bmp
}


FILE FREEFORM = E2EA5A4F-98BD-4203-AB49-399505DDFB7D {
    SECTION UI = "tsens_thermal_symbol.bmp"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/tsens_thermal_symbol.bmp
}


FILE FREEFORM = C72FB1A9-5527-4E13-BAC4-F671D0330145 {
    SECTION UI = "tsens_thermal_err_symbol.bmp"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/tsens_thermal_err_symbol.bmp
}


FILE FREEFORM = B0F8D1BE-5353-4812-B1F6-07E7768204CC {
    SECTION UI = "battery_symbol_DebugBoot.bmp"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/battery_symbol_DebugBoot.bmp
}


FILE FREEFORM = F9E8F683-E065-4E09-B4F9-0230D7CECD08 {
    SECTION UI = "battery_symbol_DebugStay.bmp"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/battery_symbol_DebugStay.bmp
}


FILE FREEFORM = A1E235DE-E825-4591-9623-C43175811826 {
    SECTION UI = "SecParti.cfg"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/SecParti.cfg
}


FILE FREEFORM = 21E9BDD9-6C3F-4F10-84A5-BBEC322741F1 {
    SECTION UI = "uefipil.cfg"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/uefipil.cfg
}


FILE FREEFORM = 45FE4B7C-150C-45DA-A021-4BEB2048EC6F {
    SECTION UI = "QcomChargerCfg.cfg"
    SECTION RAW = MooreaPkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/QcomChargerCfg.cfg
}