# INF QcomPkg/XBLCore/XBLCore.inf

#FILE FREEFORM = DDE58710-41CD-4306-DBFB-3FA90BB1D2DD {
#    SECTION UI = "uefiplat.cfg"
#    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/uefiplat.cfg
#}

INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/CPRDxe/CPRDxe.inf
INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/ShmBridgeDxe/ShmBridgeDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbDeviceDxe/UsbDeviceDxe.inf
INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/UsbInitDxe/UsbInitDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbMsdDxe/UsbMsdDxe.inf
INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/XhciPciEmulationDxe/XhciPciEmulationDxe.inf
INF AndromedaPkg/Driver/SimpleFbDxe/SimpleFbDxe.inf

INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/CookieDxe/CookieDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/AkmuDxe/AkmuDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SidDxe/SidDxe.inf
#INF MdeModulePkg/Core/Dxe/DxeMain.inf
#INF ArmPkg/Drivers/CpuDxe/CpuDxe.inf
#INF MdeModulePkg/Core/RuntimeDxe/RuntimeDxe.inf
#INF MdeModulePkg/Universal/SecurityStubDxe/SecurityStubDxe.inf
#INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SecRSADxe/SecRSADxe.inf
#INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ASN1X509Dxe/ASN1X509Dxe.inf
#INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/VerifiedBootDxe/VerifiedBootDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TzDxe/ScmDxeLA.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TzDxe/TzDxeLA.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SimpleTextInOutSerialDxe/SimpleTextInOutSerial.inf
#INF MdeModulePkg/Universal/WatchdogTimerDxe/WatchdogTimer.inf
#INF MdeModulePkg/Universal/CapsuleRuntimeDxe/CapsuleRuntimeDxe.inf
#INF MdeModulePkg/Universal/ReportStatusCodeRouter/RuntimeDxe/RscRtDxe.inf
#INF MdeModulePkg/Universal/StatusCodeHandler/RuntimeDxe/SCHandlerRtDxe.inf
#INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/VariableDxe/VariableDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/EmbeddedMonotonicCounter/EmbeddedMonotonicCounter.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ResetRuntimeDxe/ResetRuntimeDxe.inf
#INF EmbeddedPkg/RealTimeClockRuntimeDxe/RealTimeClockRuntimeDxe.inf
#INF EmbeddedPkg/MetronomeDxe/MetronomeDxe.inf
#INF MdeModulePkg/Universal/PrintDxe/PrintDxe.inf
#INF MdeModulePkg/Universal/DevicePathDxe/DevicePathDxe.inf
#INF MdeModulePkg/Universal/Console/ConPlatformDxe/ConPlatformDxe.inf
#INF MdeModulePkg/Universal/Console/ConSplitterDxe/ConSplitterDxe.inf
#INF MdeModulePkg/Universal/Console/GraphicsConsoleDxe/GraphicsConsoleDxe.inf
#INF MdeModulePkg/Universal/HiiDatabaseDxe/HiiDatabaseDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/FontDxe/FontDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/EnvDxe/EnvDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/QcomWDogDxe/QcomWDogDxe.inf
#INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/QcomMpmTimerDxe/QcomMpmTimerDxe.inf
#INF ArmPkg/Drivers/ArmGic/ArmGicDxe.inf
#INF ArmPkg/Drivers/TimerDxe/TimerDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ChipInfoDxe/ChipInfoDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SmemDxe/SmemDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ULogDxe/ULogDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/NpaDxe/NpaDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/CmdDbDxe/CmdDbDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/RpmhDxe/RpmhDxe.inf
#INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/CPRDxe/CPRDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PdcDxe/PdcDxe.inf
#INF MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.inf
#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.inf
#INF FatPkg/EnhancedFatDxe/Fat.inf
#INF MdeModulePkg/Universal/Disk/UnicodeCollation/EnglishDxe/EnglishDxe.inf
#INF MdeModulePkg/Universal/FvSimpleFileSystemDxe/FvSimpleFileSystemDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/PatchedBinaries/DALSYSDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ClockDxe/ClockDxe.inf
#INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HALIOMMUDxe/HALIOMMUDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HWIODxe/HWIODxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/GpiDxe/GpiDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/I2CDxe/I2CDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SPMIDxe/SPMIDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SdccDxe/SdccDxe.inf
#INF QcomPkg/Drivers/UFSDxe/UFSDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TLMMDxe/TLMMDxe.inf
#INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/DisplayDxe/DisplayDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PlatformInfoDxe/PlatformInfoDxe.inf
#INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ButtonsDxe/ButtonsDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PmicDxe/PmicDxeLa.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ChargerExDxe/ChargerExDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/QcomChargerDxe/QcomChargerDxeLA.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbPwrCtrlDxe/UsbPwrCtrlDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/AdcDxe/AdcDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TsensDxe/TsensDxe.inf
#INF QcomPkg/Drivers/LimitsDxe/LimitsDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/DDRInfoDxe/DDRInfoDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbfnDwc3Dxe/UsbfnDwc3Dxe.inf
#INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbMsdDxe/UsbMsdDxe.inf
#INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbDeviceDxe/UsbDeviceDxe.inf
#INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbConfigDxe/UsbConfigDxe.inf
#INF QcomPkg/Drivers/HashDxe/HashDxe.inf
#INF QcomPkg/Drivers/CipherDxe/CipherDxe.inf
#INF QcomPkg/Drivers/RNGDxe/RngDxe.inf
#INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/QcomBds/QcomBds.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PILDxe/PILDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Application/QcomChargerApp/QcomChargerApp.inf
#INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ShmBridgeDxe/ShmBridgeDxeLA.inf

# Patched Binaries
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HALIOMMUDxe/HALIOMMUDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UFSDxe/UFSDxe.inf
INF QcomPkg/PatchedBinaries/UsbConfigDxe.inf
INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/PatchedBinaries/ButtonsDxe.inf

# DXE without depex
FILE DRIVER = 6b38f7b4-ad98-40e9-9093-aca2b5a253c4 {
    SECTION PE32 = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.efi
    SECTION UI = "DiskIoDxe"
}

FILE DRIVER = 1fa1f39e-feff-4aae-bd7b-38a070a3b609 {
    SECTION PE32 = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.efi
    SECTION UI = "PartitionDxe"
}

FILE DRIVER = f09ad92e-4e91-490f-ab99-e69939b840b2 {
    SECTION UI = "LimitsDxe"
    SECTION RAW = Epsilon/BOOT.XF.3.0-00527-SM8150LZB-1/QcomPkg/Drivers/LimitsDxe/LimitsDxe.raw
    SECTION PE32 = Epsilon/BOOT.XF.3.0-00527-SM8150LZB-1/QcomPkg/Drivers/LimitsDxe/LimitsDxe.efi
}

FILE DRIVER = 3adf8dda-1850-44c5-8c63-bb991849bc6f {
    SECTION UI = "HashDxe"
    SECTION RAW = Epsilon/BOOT.XF.3.0-00527-SM8150LZB-1/QcomPkg/Drivers/HashDxe/HashDxe.raw
    SECTION PE32 = Epsilon/BOOT.XF.3.0-00527-SM8150LZB-1/QcomPkg/Drivers/HashDxe/HashDxe.efi
}

FILE DRIVER = 5f0937cd-73f9-445e-b320-bb6fd5d3cbde {
    SECTION UI = "CipherDxe"
    SECTION RAW = Epsilon/BOOT.XF.3.0-00527-SM8150LZB-1/QcomPkg/Drivers/CipherDxe/CipherDxe.raw
    SECTION PE32 = Epsilon/BOOT.XF.3.0-00527-SM8150LZB-1/QcomPkg/Drivers/CipherDxe/CipherDxe.efi
}

FILE DRIVER = b0d3689e-11f8-43c6-8ece-023a29cec35b {
    SECTION UI = "RngDxe"
    SECTION RAW = Epsilon/BOOT.XF.3.0-00527-SM8150LZB-1/QcomPkg/Drivers/RNGDxe/RngDxe.raw
    SECTION PE32 = Epsilon/BOOT.XF.3.0-00527-SM8150LZB-1/QcomPkg/Drivers/RNGDxe/RngDxe.efi
}

#
#FILE DRIVER = 32C71E68-83A8-46ED-AED1-094E71B12057 {
#    SECTION PE32 = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SecRSADxe/SecRSADxe.efi
#    SECTION UI = "SecRSADxe"
#}
#
#FILE DRIVER = C2F9A4F5-F7B4-43E7-BA99-5EA804CC103A {
#    SECTION PE32 = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ASN1X509Dxe/ASN1X509Dxe.efi
#    SECTION UI = "ASN1X509Dxe"
#}

FILE DRIVER = B7F50E91-A759-412C-ADE4-DCD03E7F7C28 {
    SECTION PE32 = Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/XhciDxe/XhciDxe.efi
    SECTION UI = "XhciDxe"
}

FILE DRIVER = 240612B7-A063-11D4-9A3A-0090273FC14D {
    SECTION PE32 = Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/UsbBusDxe/UsbBusDxe.efi
    SECTION UI = "UsbBusDxe"
}

FILE DRIVER = 2D2E62CF-9ECF-43B7-8219-94E7FC713DFE {
    SECTION PE32 = Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/UsbKbDxe/UsbKbDxe.efi
    SECTION UI = "UsbKbDxe"
}

FILE DRIVER = 9FB4B4A7-42C0-4BCD-8540-9BCC6711F83E {
    SECTION PE32 = Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/UsbMassStorageDxe/UsbMassStorageDxe.efi
    SECTION UI = "UsbMassStorageDxe"
}

# Raw Files

FILE FREEFORM = A91D838E-A5FA-4138-825D-455E2303079E {
    SECTION UI = "BDS_Menu.cfg"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/BDS_Menu.cfg
}


FILE FREEFORM = A91D838E-A5FA-4138-825D-455E23030794 {
    SECTION UI = "logo1.bmp"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/logo1.bmp
}


FILE FREEFORM = 8CAE2C55-FC5A-410B-812B-8CA22F572F36 {
    SECTION UI = "Panel_truly_wqxga_dsc_cmd.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_truly_wqxga_dsc_cmd.xml
}


FILE FREEFORM = 13AC9DC9-0092-4374-AE1A-06FF35950FD0 {
    SECTION UI = "Panel_truly_wqxga_dsc_vid.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_truly_wqxga_dsc_vid.xml
}


FILE FREEFORM = FC6315F9-F8FE-4222-A1E3-226DF55D7592 {
    SECTION UI = "Panel_truly_wqxga_dual_cmd.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_truly_wqxga_dual_cmd.xml
}


FILE FREEFORM = 95E7B040-26A2-4511-9ABB-1D95D6DA7082 {
    SECTION UI = "Panel_truly_wqxga_dual_vid.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_truly_wqxga_dual_vid.xml
}


FILE FREEFORM = 8BC595B7-391A-4A9A-8256-5B9983B30392 {
    SECTION UI = "Panel_sharp_4k_dsc_cmd.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_sharp_4k_dsc_cmd.xml
}


FILE FREEFORM = 19B58ACD-B1F8-4078-B9A5-A33584B680E2 {
    SECTION UI = "Panel_sharp_4k_dsc_vid.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_sharp_4k_dsc_vid.xml
}


FILE FREEFORM = 0AE323D6-2EBE-11E8-8349-9BA636A0D80C {
    SECTION UI = "Panel_sharp_1080p_cmd.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_sharp_1080p_cmd.xml
}


FILE FREEFORM = 87273B42-311D-11E8-9324-DFB2DADFC3D1 {
    SECTION UI = "Panel_truly_1080p_cmd.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_truly_1080p_cmd.xml
}


FILE FREEFORM = BAFD3200-311D-11E8-8651-0FB3CACF38FB {
    SECTION UI = "Panel_truly_1080p_vid.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_truly_1080p_vid.xml
}


FILE FREEFORM = 88CA5ABF-D0AC-4093-A68C-0CFAE1EF9635 {
    SECTION UI = "Panel_boe_amoled_wqhd_dsc_cmd.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_boe_amoled_wqhd_dsc_cmd.xml
}


FILE FREEFORM = A8913C67-C8BF-45BC-838B-06567B243C4B {
    SECTION UI = "LGD_SW43402_cmd_dsc_xmldata.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/LGD_SW43402_cmd_dsc_xmldata.xml
}


FILE FREEFORM = 0403864B-B97A-431D-8487-6D5CE6A87B2B {
    SECTION UI = "TIANMA_RM69299_cmd_xmldata.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/TIANMA_RM69299_cmd_xmldata.xml
}


FILE FREEFORM = 88A05962-8920-42C1-AA37-630F18720FE6 {
    SECTION UI = "TOVISMD_RM69299_cmd_xmldata.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/TOVISMD_RM69299_cmd_xmldata.xml
}


FILE FREEFORM = 5948B346-E5FE-4DBD-BB8F-4E7278C8D830 {
    SECTION UI = "TOVISMD_RM69299_dv1_cmd_xmldata.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/TOVISMD_RM69299_dv1_cmd_xmldata.xml
}


FILE FREEFORM = AFFA3B2A-F117-4C0F-B433-525C0D00F103 {
    SECTION UI = "LGD_SW43410_cmd_dsc_xmldata.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/LGD_SW43410_cmd_dsc_xmldata.xml
}


FILE FREEFORM = 7B72E877-8D0D-4CE5-8D68-D7348197E57D {
    SECTION UI = "LGD_SW43410_pp2_cmd_dsc_xmldata.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/LGD_SW43410_pp2_cmd_dsc_xmldata.xml
}


FILE FREEFORM = 8C041291-C436-4296-89FE-71B4FD8151DB {
    SECTION UI = "LGD_SW43410_dv1_cmd_dsc_xmldata.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/LGD_SW43410_dv1_cmd_dsc_xmldata.xml
}


FILE FREEFORM = A9B82323-9B9A-41B7-9110-6958629B0ABB {
    SECTION UI = "LGD_SW43410_dv2_cmd_dsc_xmldata.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/LGD_SW43410_dv2_cmd_dsc_xmldata.xml
}


FILE FREEFORM = C9B406D4-748B-43EC-BC2D-9CDB7658D8F3 {
    SECTION UI = "LGD_SW43410_pv_cmd_dsc_xmldata.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/LGD_SW43410_pv_cmd_dsc_xmldata.xml
}


FILE FREEFORM = 79F68BA0-8F99-41B5-A5CF-7BB55E18EDF2 {
    SECTION UI = "LGD_SW43410_dv2_gi_cmd_dsc_xmldata.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/LGD_SW43410_dv2_gi_cmd_dsc_xmldata.xml
}


FILE FREEFORM = DB0B8D85-55BC-49E2-996D-5AC7ED8CF7A3 {
    SECTION UI = "LGD_SW43410_pv_gi_cmd_dsc_xmldata.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/LGD_SW43410_pv_gi_cmd_dsc_xmldata.xml
}


FILE FREEFORM = 546D7B82-2933-488A-B074-7137CE2DEF46 {
    SECTION UI = "LGD_SW43410_mp_cmd_dsc_xmldata.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/LGD_SW43410_mp_cmd_dsc_xmldata.xml
}


FILE FREEFORM = 041D6E89-3EA9-431E-8F77-C72B2F61683B {
    SECTION UI = "TOVISMD_RM692A9_pp1_cmd_xmldata.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/TOVISMD_RM692A9_pp1_cmd_xmldata.xml
}


FILE FREEFORM = 505DE8EE-EC22-496A-AEC8-16A8131A5B86 {
    SECTION UI = "TIANMAMD_R66456_pp1_cmd_xmldata.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/TIANMAMD_R66456_pp1_cmd_xmldata.xml
}


FILE FREEFORM = D650272F-9195-464C-8875-1BED84961DA1 {
    SECTION UI = "TIANMAMD_R66456_dv1_cmd_xmldata.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/TIANMAMD_R66456_dv1_cmd_xmldata.xml
}


FILE FREEFORM = 9C54C069-B503-4153-AC5A-39A687DACB2A {
    SECTION UI = "TIANMAMD_R66456_dv2_cmd_xmldata.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/TIANMAMD_R66456_dv2_cmd_xmldata.xml
}


FILE FREEFORM = 3FF68EA2-BED1-4609-B713-A5A8F72D27C7 {
    SECTION UI = "TIANMAMD_R66456_pv_cmd_xmldata.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/TIANMAMD_R66456_pv_cmd_xmldata.xml
}


FILE FREEFORM = 45A8FDA2-4FAD-4234-BCDA-D1778611CE13 {
    SECTION UI = "Panel_boe_amoled_wqhd_dsc_vid.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_boe_amoled_wqhd_dsc_vid.xml
}


FILE FREEFORM = 2BCA3B86-E175-4609-AC7F-207908B89C75 {
    SECTION UI = "Panel_primary_sharp_1080p_cmd.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_primary_sharp_1080p_cmd.xml
}


FILE FREEFORM = A3607731-F28D-496C-83D3-FB182F885F8C {
    SECTION UI = "Panel_secondary_truly_1080p_cmd.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_secondary_truly_1080p_cmd.xml
}


FILE FREEFORM = 32C7620B-9746-4BB6-8166-605682A2C58A {
    SECTION UI = "Panel_nt36850_truly_wqhd_cmd.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_nt36850_truly_wqhd_cmd.xml
}


FILE FREEFORM = 2FD70D55-C89A-47C8-A960-5A3AAA10426C {
    SECTION UI = "Panel_sdx55_truly_wqxga_dual_cmd.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_sdx55_truly_wqxga_dual_cmd.xml
}


FILE FREEFORM = 13E35E77-F1E0-4639-9021-70CBA62FB897 {
    SECTION UI = "Panel_sdx55_truly_wqxga_dual_vid.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_sdx55_truly_wqxga_dual_vid.xml
}


FILE FREEFORM = 07777D7D-677F-47F4-A1FB-3BB1E08E607A {
    SECTION UI = "Panel_sdx55_sharp_4k_dsc_cmd.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_sdx55_sharp_4k_dsc_cmd.xml
}


FILE FREEFORM = 151F4DFB-643B-418D-ACB3-A66BC8D7A4EF {
    SECTION UI = "Panel_sdx55_sharp_4k_dsc_vid.xml"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_sdx55_sharp_4k_dsc_vid.xml
}


FILE FREEFORM = 3E5584ED-05D4-4267-9048-0D47F76F4248 {
    SECTION UI = "battery_symbol_Soc10.bmp"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/battery_symbol_Soc10.bmp
}


FILE FREEFORM = 4753E815-DDD8-402D-BF69-9B8C4EB7573E {
    SECTION UI = "battery_symbol_NoBattery.bmp"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/battery_symbol_NoBattery.bmp
}


FILE FREEFORM = 03DED53E-BECD-428F-9F79-5ABA64C58445 {
    SECTION UI = "battery_symbol_Nocharger.bmp"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/battery_symbol_Nocharger.bmp
}


FILE FREEFORM = 8B86CD38-C772-4FCF-85AA-345B2B3C1AB4 {
    SECTION UI = "battery_symbol_LowBatteryCharging.bmp"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/battery_symbol_LowBatteryCharging.bmp
}


FILE FREEFORM = 3FD97907-93F1-4349-AF3C-3B68B0A5E626 {
    SECTION UI = "battery_symbol_LowBattery.bmp"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/battery_symbol_LowBattery.bmp
}


FILE FREEFORM = E2EA5A4F-98BD-4203-AB49-399505DDFB7D {
    SECTION UI = "tsens_thermal_symbol.bmp"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/tsens_thermal_symbol.bmp
}


FILE FREEFORM = C72FB1A9-5527-4E13-BAC4-F671D0330145 {
    SECTION UI = "tsens_thermal_err_symbol.bmp"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/tsens_thermal_err_symbol.bmp
}


FILE FREEFORM = B0F8D1BE-5353-4812-B1F6-07E7768204CC {
    SECTION UI = "battery_symbol_DebugBoot.bmp"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/battery_symbol_DebugBoot.bmp
}


FILE FREEFORM = F9E8F683-E065-4E09-B4F9-0230D7CECD08 {
    SECTION UI = "battery_symbol_DebugStay.bmp"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/battery_symbol_DebugStay.bmp
}


FILE FREEFORM = A1E235DE-E825-4591-9623-C43175811826 {
    SECTION UI = "SecParti.cfg"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/SecParti.cfg
}


FILE FREEFORM = 21E9BDD9-6C3F-4F10-84A5-BBEC322741F1 {
    SECTION UI = "uefipil.cfg"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/uefipil.cfg
}


FILE FREEFORM = 45FE4B7C-150C-45DA-A021-4BEB2048EC6F {
    SECTION UI = "QcomChargerCfg.cfg"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/QcomChargerCfg.cfg
}


FILE FREEFORM = F780C779-DD7C-47CD-BD1A-5EB414C51704 {
    SECTION UI = "BATTERY.PROVISION"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/BATTERY.PROVISION
}


FILE FREEFORM = 06F6916B-0F5D-4BFD-BB0E-FBBF343B9483 {
    SECTION UI = "BATTERY_ALPHALM.PROVISION"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/BATTERY_ALPHALM.PROVISION
}


FILE FREEFORM = 23DD6DDA-3CBB-407E-82C1-255C4942CA1D {
    SECTION UI = "BATTERY_BETALM.PROVISION"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/BATTERY_BETALM.PROVISION
}


FILE FREEFORM = 0460EC31-D7ED-4B08-AF65-18F8FD2D8A00 {
    SECTION UI = "BATTERY_MH2LM.PROVISION"
    SECTION RAW = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/RawFiles/BATTERY_MH2LM.PROVISION
}
