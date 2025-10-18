APRIORI DXE {
    # First, install the PCD driver and call DxeInit
    INF MdeModulePkg/Core/Dxe/DxeMain.inf
    INF MdeModulePkg/Universal/PCD/Dxe/Pcd.inf

    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/EnvDxe/EnvDxe.inf

    INF MdeModulePkg/Universal/ReportStatusCodeRouter/RuntimeDxe/ReportStatusCodeRouterRuntimeDxe.inf
    INF MdeModulePkg/Universal/StatusCodeHandler/RuntimeDxe/StatusCodeHandlerRuntimeDxe.inf
    INF MdeModulePkg/Core/RuntimeDxe/RuntimeDxe.inf

    # Next, install cpu protocol and enable the interrupt controller
    INF ArmPkg/Drivers/CpuDxe/CpuDxe.inf
    INF ArmPkg/Drivers/ArmGicDxe/ArmGicDxe.inf

    # Core Drivers
    INF ArmPkg/Drivers/TimerDxe/TimerDxe.inf
    INF EmbeddedPkg/MetronomeDxe/MetronomeDxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SmemDxe/SmemDxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/DALSYSDxe/DALSYSDxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HWIODxe/HWIODxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ChipInfoDxe/ChipInfoDxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PlatformInfoDxe/PlatformInfoDxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/GLinkDxe/GLinkDxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ULogDxe/ULogDxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/NpaDxe/NpaDxe.inf
    INF QcomPkg/PatchedBinaries/ClockDxe.inf

    FILE DRIVER = 6b38f7b4-ad98-40e9-9093-aca2b5a253c4 {
        SECTION PE32 = Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/DiskIoDxe/DiskIoDxe.efi
        SECTION UI = "DiskIoDxe"
    }

    FILE DRIVER = 1fa1f39e-feff-4aae-bd7b-38a070a3b609 {
        SECTION PE32 = Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/PartitionDxe/PartitionDxe.efi
        SECTION UI = "PartitionDxe"
    }

    INF MdeModulePkg/Universal/Disk/UnicodeCollation/EnglishDxe/EnglishDxe.inf
    INF MdeModulePkg/Universal/FvSimpleFileSystemDxe/FvSimpleFileSystemDxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SdccDxe/SdccDxe.inf
    INF Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/UFSDxe/UFSDxe.inf
    INF MdeModulePkg/Universal/WatchdogTimerDxe/WatchdogTimer.inf

#    FILE DRIVER = 5E0EAE60-EAED-4D75-B8BF-EDBBAABC3F09{
#        SECTION UI = "SecurityDxe"
#        SECTION PE32 = Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/SecurityDxe/SecurityDxe.efi
#    }
    
    INF FatPkg/EnhancedFatDxe/Fat.inf
    INF MdeModulePkg/Bus/Pci/PciBusDxe/PciBusDxe.inf

#    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TzDxe/TzDxeLA.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/QdssDxe/QdssDxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TLMMDxe/TLMMDxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SPMIDxe/SPMIDxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ResetRuntimeDxe/ResetRuntimeDxe.inf
    INF Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/I2CDxe/I2CDxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PmicDxe/PmicDxeLa.inf
    INF MdeModulePkg/Universal/Variable/RuntimeDxe/VariableRuntimeDxe.inf
#    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/DisplayDxe/DisplayDxe.inf

    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/EmbeddedMonotonicCounter/EmbeddedMonotonicCounter.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/EmbeddedPkg/RealTimeClockRuntimeDxe/RealTimeClockRuntimeDxe.inf
    INF MdeModulePkg/Universal/PrintDxe/PrintDxe.inf
    INF MdeModulePkg/Universal/DevicePathDxe/DevicePathDxe.inf
    INF MdeModulePkg/Universal/CapsuleRuntimeDxe/CapsuleRuntimeDxe.inf
    INF MdeModulePkg/Universal/HiiDatabaseDxe/HiiDatabaseDxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/FontDxe/FontDxe.inf
    INF MdeModulePkg/Universal/BdsDxe/BdsDxe.inf

#    FILE DRIVER = 32C71E68-83A8-46ED-AED1-094E71B12057 {
#        SECTION PE32 = NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SecRSADxe/SecRSADxe.efi
#        SECTION UI = "SecRSADxe"
#    }

#    FILE DRIVER = C2F9A4F5-F7B4-43E7-BA99-5EA804CC103A {
#        SECTION PE32 = NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ASN1X509Dxe/ASN1X509Dxe.inf
#        SECTION UI = "ASN1X509Dxe"
#    }

    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/AdcDxe/AdcDxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/QcomChargerDxe/QcomChargerDxeLA.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbfnDwc3Dxe/UsbfnDwc3Dxe.inf
    INF Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/XhciPciEmulationDxe/XhciPciEmulationDxe.inf

    # INF Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/XhciDxe/XhciDxe.inf
    FILE DRIVER = B7F50E91-A759-412C-ADE4-DCD03E7F7C28 {
            SECTION PE32 = Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/XhciDxe/XhciDxe.efi
            SECTION UI = "XhciDxe"
    }

    # INF Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/UsbBusDxe/UsbBusDxe.inf
    FILE DRIVER = 240612B7-A063-11D4-9A3A-0090273FC14D {
            SECTION PE32 = Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/UsbBusDxe/UsbBusDxe.efi
            SECTION UI = "UsbBusDxe"
    }

    # INF Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/UsbKbDxe/UsbKbDxe.inf
    FILE DRIVER = 2D2E62CF-9ECF-43B7-8219-94E7FC713DFE {
            SECTION PE32 = Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/UsbKbDxe/UsbKbDxe.efi
            SECTION UI = "UsbKbDxe"
    }

    # INF Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/UsbMassStorageDxe/UsbMassStorageDxe.inf
    FILE DRIVER = 9FB4B4A7-42C0-4BCD-8540-9BCC6711F83E {
            SECTION PE32 = Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/UsbMassStorageDxe/UsbMassStorageDxe.efi
            SECTION UI = "UsbMassStorageDxe"
    }

    INF NazgulPkg/Device/$(TARGET_DEVICE)/PatchedBinaries/UsbConfigDxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbDeviceDxe/UsbDeviceDxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ButtonsDxe/ButtonsDxe.inf
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TsensDxe/TsensDxe.inf

#    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/LimitsDxe/LimitsDxe.inf
    FILE DRIVER = f09ad92e-4e91-490f-ab99-e69939b840b2 {
        SECTION UI = "LimitsDxe"
        SECTION PE32 = Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/LimitsDxe/LimitsDxe.efi
    }

#    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/MdtpDxe/MdtpDxe.inf
    FILE DRIVER = 409D636E-8DBB-46DF-AE8F-D8D69F0A5A2F {
        SECTION UI = "MdtpDxe"
        SECTION PE32 = NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/MdtpDxe/MdtpDxe.efi
    }

#    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HashDxe/HashDxe.inf
    FILE DRIVER = 3adf8dda-1850-44c5-8c63-bb991849bc6f {
        SECTION UI = "HashDxe"
        SECTION PE32 = Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/HashDxe/HashDxe.efi
    }

#    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/RNGDxe/RngDxe.inf
    FILE DRIVER = b0d3689e-11f8-43c6-8ece-023a29cec35b {
        SECTION UI = "RngDxe"
        SECTION PE32 = Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/RNGDxe/RngDxe.efi
    }
    INF NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/MpPowerDxe/MpPowerDxe.inf

    INF Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/AdapterInformationDxe/AdapterInformationDxe.inf
    INF Nazgul/BOOT.XF.1.2.2-00131-M8998WZB-1/QcomPkg/Drivers/OSConfigDxe/OSConfigDxe.inf

    INF MdeModulePkg/Universal/Console/ConPlatformDxe/ConPlatformDxe.inf
    INF MdeModulePkg/Universal/Console/ConSplitterDxe/ConSplitterDxe.inf

#    INF MdeModulePkg/Universal/Console/GraphicsConsoleDxe/GraphicsConsoleDxe.inf
    FILE DRIVER = cccb0c28-4b24-11d5-9a5a-0090273fc14d {
            SECTION PE32 = NazgulPkg/Device/$(TARGET_DEVICE)/Binaries/MdeModulePkg/Universal/Console/GraphicsConsoleDxe/GraphicsConsoleDxe.efi
            SECTION UI = "GraphicsConsoleDxe"
    }

    INF AndromedaPkg/Driver/SimpleFbDxe/SimpleFbDxe.inf
}
