APRIORI DXE {
    # First, install the PCD driver and call DxeInit
    INF MdeModulePkg/Core/Dxe/DxeMain.inf
    INF MdeModulePkg/Universal/PCD/Dxe/Pcd.inf

    # INF MdeModulePkg/Universal/ReportStatusCodeRouter/RuntimeDxe/ReportStatusCodeRouterRuntimeDxe.inf
    # INF MdeModulePkg/Universal/StatusCodeHandler/RuntimeDxe/StatusCodeHandlerRuntimeDxe.inf
    INF MdeModulePkg/Core/RuntimeDxe/RuntimeDxe.inf

    # Next, install cpu protocol and enable the interrupt controller
    INF ArmPkg/Drivers/CpuDxe/CpuDxe.inf
    INF ArmPkg/Drivers/ArmGicDxe/ArmGicDxe.inf

    # Core Drivers
    INF EmbeddedPkg/MetronomeDxe/MetronomeDxe.inf
    INF ArmPkg/Drivers/TimerDxe/TimerDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/EnvDxe/EnvDxe.inf
    INF AndromedaPkg/Driver/RamPartitionDxe/RamPartitionDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SmemDxe/SmemDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/DALSYSDxe/DALSYSDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HWIODxe/HWIODxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ChipInfoDxe/ChipInfoDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PlatformInfoDxe/PlatformInfoDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HALIOMMUDxe/HALIOMMUDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ULogDxe/ULogDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/CmdDbDxe/CmdDbDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/NpaDxe/NpaDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/RpmhDxe/RpmhDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PdcDxe/PdcDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ClockDxe/ClockDxe.inf
    INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/ShmBridgeDxe/ShmBridgeDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TzDxe/ScmDxeLA.inf
    INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/GLinkDxe/GLinkDxe.inf

#    INF MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.inf
    FILE DRIVER = 6b38f7b4-ad98-40e9-9093-aca2b5a253c4 {
            SECTION PE32 = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.efi
            SECTION UI = "DiskIoDxe"
    }

#    INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.inf
    FILE DRIVER = 1fa1f39e-feff-4aae-bd7b-38a070a3b609 {
            SECTION PE32 = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.efi
            SECTION UI = "PartitionDxe"
    }

    INF MdeModulePkg/Universal/Disk/UnicodeCollation/EnglishDxe/EnglishDxe.inf
    INF MdeModulePkg/Universal/FvSimpleFileSystemDxe/FvSimpleFileSystemDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SdccDxe/SdccDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UFSDxe/UFSDxe.inf
    INF FatPkg/EnhancedFatDxe/Fat.inf

#   INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/VerifiedBootDxe/VerifiedBootDxe.inf

    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TzDxe/TzDxeLA.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/QcomWDogDxe/QcomWDogDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TLMMDxe/TLMMDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SPMIDxe/SPMIDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/DDRInfoDxe/DDRInfoDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ResetRuntimeDxe/ResetRuntimeDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/I2CDxe/I2CDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PmicDxe/PmicDxeLa.inf
#   INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/VariableDxe/VariableDxe.inf
    INF MdeModulePkg/Universal/Variable/RuntimeDxe/VariableRuntimeDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/DisplayDxe/DisplayDxe.inf

    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PILDxe/PILDxe.inf
    INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/CPRDxe/CPRDxe.inf
    INF MdeModulePkg/Universal/WatchdogTimerDxe/WatchdogTimer.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/EmbeddedMonotonicCounter/EmbeddedMonotonicCounter.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/EmbeddedPkg/RealTimeClockRuntimeDxe/RealTimeClockRuntimeDxe.inf
    INF MdeModulePkg/Universal/PrintDxe/PrintDxe.inf
    INF MdeModulePkg/Universal/DevicePathDxe/DevicePathDxe.inf
    INF MdeModulePkg/Universal/CapsuleRuntimeDxe/CapsuleRuntimeDxe.inf
    INF MdeModulePkg/Universal/HiiDatabaseDxe/HiiDatabaseDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/FontDxe/FontDxe.inf
    INF MdeModulePkg/Universal/BdsDxe/BdsDxe.inf
    #INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SecRSADxe/SecRSADxe.inf
#    FILE DRIVER = 32C71E68-83A8-46ED-AED1-094E71B12057 {
#        SECTION PE32 = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SecRSADxe/SecRSADxe.efi
#        SECTION UI = "SecRSADxe"
#    }
    #INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ASN1X509Dxe/ASN1X509Dxe.inf
#    FILE DRIVER = C2F9A4F5-F7B4-43E7-BA99-5EA804CC103A {
#        SECTION PE32 = SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ASN1X509Dxe/ASN1X509Dxe.efi
#        SECTION UI = "ASN1X509Dxe"
#    }

    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/AdcDxe/AdcDxe.inf
#    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbPwrCtrlDxe/UsbPwrCtrlDxe.inf
    INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/PmicGlinkDxe/PmicGlinkDxe.inf
    INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/UsbPwrCtrlDxe/UsbPwrCtrlDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/QcomChargerDxe/QcomChargerDxeLA.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ChargerExDxe/ChargerExDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbfnDwc3Dxe/UsbfnDwc3Dxe.inf
    INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/XhciPciEmulationDxe/XhciPciEmulationDxe.inf
    # INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/XhciDxe/XhciDxe.inf
    FILE DRIVER = B7F50E91-A759-412C-ADE4-DCD03E7F7C28 {
            SECTION PE32 = Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/XhciDxe/XhciDxe.efi
            SECTION UI = "XhciDxe"
    }

    # INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/UsbBusDxe/UsbBusDxe.inf
    FILE DRIVER = 240612B7-A063-11D4-9A3A-0090273FC14D {
            SECTION PE32 = Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/UsbBusDxe/UsbBusDxe.efi
            SECTION UI = "UsbBusDxe"
    }

#    # INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/UsbKbDxe/UsbKbDxe.inf
#    FILE DRIVER = 2D2E62CF-9ECF-43B7-8219-94E7FC713DFE {
#            SECTION PE32 = Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/UsbKbDxe/UsbKbDxe.efi
#            SECTION UI = "UsbKbDxe"
#    }

    # INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/UsbMassStorageDxe/UsbMassStorageDxe.inf
    FILE DRIVER = 9FB4B4A7-42C0-4BCD-8540-9BCC6711F83E {
            SECTION PE32 = Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/UsbMassStorageDxe/UsbMassStorageDxe.efi
            SECTION UI = "UsbMassStorageDxe"
    }

    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbConfigDxe/UsbConfigDxe.inf
    INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/UsbInitDxe/UsbInitDxe.inf
    INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/UsbDeviceDxe/UsbDeviceDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ButtonsDxe/ButtonsDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TsensDxe/TsensDxe.inf

#    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/LimitsDxe/LimitsDxe.inf
    FILE DRIVER = f09ad92e-4e91-490f-ab99-e69939b840b2 {
            SECTION UI = "LimitsDxe"
            SECTION RAW = Epsilon/BOOT.XF.3.0-00527-SM8150LZB-1/QcomPkg/Drivers/LimitsDxe/LimitsDxe.raw
            SECTION PE32 = Epsilon/BOOT.XF.3.0-00527-SM8150LZB-1/QcomPkg/Drivers/LimitsDxe/LimitsDxe.efi
    }
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/GpiDxe/GpiDxe.inf
    INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/PciHostBridgeDxe/PciHostBridgeDxe.inf


#    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HashDxe/HashDxe.inf
    FILE DRIVER = 3adf8dda-1850-44c5-8c63-bb991849bc6f {
            SECTION UI = "HashDxe"
            SECTION RAW = Epsilon/BOOT.XF.3.0-00527-SM8150LZB-1/QcomPkg/Drivers/HashDxe/HashDxe.raw
            SECTION PE32 = Epsilon/BOOT.XF.3.0-00527-SM8150LZB-1/QcomPkg/Drivers/HashDxe/HashDxe.efi
    }

#    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/CipherDxe/CipherDxe.inf
    FILE DRIVER = 5f0937cd-73f9-445e-b320-bb6fd5d3cbde {
            SECTION UI = "CipherDxe"
            SECTION RAW = Epsilon/BOOT.XF.3.0-00527-SM8150LZB-1/QcomPkg/Drivers/CipherDxe/CipherDxe.raw
            SECTION PE32 = Epsilon/BOOT.XF.3.0-00527-SM8150LZB-1/QcomPkg/Drivers/CipherDxe/CipherDxe.efi
    }

#    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/RNGDxe/RngDxe.inf
    FILE DRIVER = b0d3689e-11f8-43c6-8ece-023a29cec35b {
            SECTION UI = "RngDxe"
            SECTION RAW = Epsilon/BOOT.XF.3.0-00527-SM8150LZB-1/QcomPkg/Drivers/RNGDxe/RngDxe.raw
            SECTION PE32 = Epsilon/BOOT.XF.3.0-00527-SM8150LZB-1/QcomPkg/Drivers/RNGDxe/RngDxe.efi
    }

    INF Cambria/BOOT.XF.3.0.1-00243-SC8180XWZB-2/QcomPkg/Drivers/AdapterInformationDxe/AdapterInformationDxe.inf

    INF MdeModulePkg/Universal/Console/ConPlatformDxe/ConPlatformDxe.inf
    INF MdeModulePkg/Universal/Console/ConSplitterDxe/ConSplitterDxe.inf

    INF MdeModulePkg/Universal/Console/GraphicsConsoleDxe/GraphicsConsoleDxe.inf
    INF AndromedaPkg/Driver/SimpleFbDxe/SimpleFbDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HwBoardIdDxe/HwBoardIdDxe.inf
    INF SurfaceDuo1Pkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SimpleTextInOutSerialDxe/SimpleTextInOutSerial.inf
}
