APRIORI DXE {

    # First, install the PCD driver and call DxeInit
    INF MdeModulePkg/Core/Dxe/DxeMain.inf
    INF MdeModulePkg/Universal/PCD/Dxe/Pcd.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/EnvDxe/EnvDxe.inf

    INF MdeModulePkg/Core/RuntimeDxe/RuntimeDxe.inf

    # Next, install cpu protocol and enable the interrupt controller
    INF ArmPkg/Drivers/CpuDxe/CpuDxe.inf
    INF ArmPkg/Drivers/ArmGicDxe/ArmGicDxe.inf

    # Core Drivers
    INF EmbeddedPkg/MetronomeDxe/MetronomeDxe.inf
    INF ArmPkg/Drivers/TimerDxe/TimerDxe.inf
    INF AndromedaPkg/Driver/RamPartitionDxe/RamPartitionDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SmemDxe/SmemDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/DALSYSDxe/DALSYSDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HWIODxe/HWIODxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ChipInfoDxe/ChipInfoDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PlatformInfoDxe/PlatformInfoDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HALIOMMUDxe/HALIOMMUDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ULogDxe/ULogDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/CmdDbDxe/CmdDbDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PwrUtilsDxe/PwrUtilsDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/NpaDxe/NpaDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/RpmhDxe/RpmhDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/VcsDxe/VcsDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ClockDxe/ClockDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ICBDxe/ICBDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ShmBridgeDxe/ShmBridgeDxeLA.inf

    FILE DRIVER = 4B4973EE-401B-4F36-A6A9-533DFCCDFC33 {
            SECTION PE32 = KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TzDxe/ScmDxeLA.efi
            SECTION UI = "ScmDxeLA"
    }

    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TLMMDxe/TLMMDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SPMIDxe/SPMIDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/I2CDxe/I2CDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ResetRuntimeDxe/ResetRuntimeDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PmicDxe/PmicDxeLa.inf

    FILE DRIVER = 6b38f7b4-ad98-40e9-9093-aca2b5a253c4 {
            SECTION PE32 = KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.efi
            SECTION UI = "DiskIoDxe"
    }

    FILE DRIVER = 1fa1f39e-feff-4aae-bd7b-38a070a3b609 {
            SECTION PE32 = KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.efi
            SECTION UI = "PartitionDxe"
    }

    INF MdeModulePkg/Universal/Disk/UnicodeCollation/EnglishDxe/EnglishDxe.inf
    INF MdeModulePkg/Universal/FvSimpleFileSystemDxe/FvSimpleFileSystemDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/PatchedBinaries/SdccDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/PatchedBinaries/UFSDxe.inf
    INF MdeModulePkg/Bus/Pci/NvmExpressDxe/NvmExpressDxe.inf
    INF FatPkg/EnhancedFatDxe/Fat.inf

    FILE DRIVER = CF6DFC66-14AB-4E13-84DB-9C02912D1404 {
            SECTION PE32 = KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TzDxe/TzDxeLA.efi
            SECTION UI = "TzDxeLA"
    }

    INF MdeModulePkg/Universal/Variable/RuntimeDxe/VariableRuntimeDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/PatchedBinaries/QcomWDogDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/DDRInfoDxe/DDRInfoDxe.inf

    FILE DRIVER = 1C04F529-0612-4319-9315-B2E75C16810A {
            SECTION PE32 = KodiakPkg/Device/$(TARGET_DEVICE)/PatchedBinaries/FeatureEnablerDxe.efi
            SECTION UI = "FeatureEnablerDxe"
    }

    INF AndromedaPkg/Driver/SimpleFbDxe/SimpleFbDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SamsungDxe/BoardInfoDxe/BoardInfoDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SamsungDxe/CcicDxe/CcicDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SamsungDxe/RedriverDxe/RedriverDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SamsungDxe/MuicDxe/MuicDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SamsungDxe/ChgDxe/ChgDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/FvUtilsDxe/FvUtilsDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PILProxyDxe/PILProxyDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PILDxe/PILDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/IPCCDxe/IPCCDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/GLinkDxe/GLinkDxe.inf
    INF MdeModulePkg/Universal/WatchdogTimerDxe/WatchdogTimer.inf
#    INF MdeModulePkg/Universal/SecurityStubDxe/SecurityStubDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/EmbeddedMonotonicCounter/EmbeddedMonotonicCounter.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/EmbeddedPkg/RealTimeClockRuntimeDxe/RealTimeClockRuntimeDxe.inf
    INF MdeModulePkg/Universal/PrintDxe/PrintDxe.inf
    INF MdeModulePkg/Universal/DevicePathDxe/DevicePathDxe.inf
    INF MdeModulePkg/Universal/CapsuleRuntimeDxe/CapsuleRuntimeDxe.inf
    INF MdeModulePkg/Universal/HiiDatabaseDxe/HiiDatabaseDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/FontDxe/FontDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SPIDxe/SPIDxe.inf
    INF Kodiak/BOOT.MXF.1.0.1-00206-KODIAKWP-1/QcomPkg/Drivers/UsbPwrCtrlDxe/UsbPwrCtrlDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbfnDwc3Dxe/UsbfnDwc3Dxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/XhciPciEmulationDxe/XhciPciEmulationDxe.inf

    FILE DRIVER = B7F50E91-A759-412C-ADE4-DCD03E7F7C28 {
            SECTION PE32 = KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/XhciDxe/XhciDxe.efi
            SECTION UI = "XhciDxe"
    }

    FILE DRIVER = 240612B7-A063-11D4-9A3A-0090273FC14D {
            SECTION PE32 = KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbBusDxe/UsbBusDxe.efi
            SECTION UI = "UsbBusDxe"
    }

#    FILE DRIVER = 2D2E62CF-9ECF-43B7-8219-94E7FC713DFE {
#            SECTION PE32 = KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbKbDxe/UsbKbDxe.efi
#            SECTION UI = "UsbKbDxe"
#    }

    FILE DRIVER = 9FB4B4A7-42C0-4BCD-8540-9BCC6711F83E {
            SECTION PE32 = KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbMassStorageDxe/UsbMassStorageDxe.efi
            SECTION UI = "UsbMassStorageDxe"
    }

    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbMsdDxe/UsbMsdDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/PatchedBinaries/UsbConfigDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbInitDxe/UsbInitDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbDeviceDxe/UsbDeviceDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ButtonsDxe/ButtonsDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TsensDxe/TsensDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/LimitsDxe/LimitsDxe.inf
    #INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/CPRDxe/CPRDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/GpiDxe/GpiDxe.inf
    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UCDxe/UCDxe.inf

    FILE DRIVER = B0D3689E-11F8-43C6-8ECE-023A29CEC35B {
            SECTION PE32 = KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/RNGDxe/RngDxe.efi
            SECTION UI = "RngDxe"
    }

    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SimpleTextInOutSerialDxe/SimpleTextInOutSerial.inf
    INF MdeModulePkg/Universal/Console/ConPlatformDxe/ConPlatformDxe.inf
    INF MdeModulePkg/Universal/Console/ConSplitterDxe/ConSplitterDxe.inf

    FILE DRIVER = cccb0c28-4b24-11d5-9a5a-0090273fc14d {
            SECTION PE32 = KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/MdeModulePkg/Universal/Console/GraphicsConsoleDxe/GraphicsConsoleDxe.efi
            SECTION UI = "GraphicsConsoleDxe"
    }

    FILE DRIVER = C2F9A4F5-F7B4-43E7-BA99-5EA804CC103A {
        SECTION PE32 = KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ASN1X509Dxe/ASN1X509Dxe.efi
        SECTION UI = "ASN1X509Dxe"
    }

    FILE DRIVER = 32C71E68-83A8-46ED-AED1-094E71B12057 {
        SECTION PE32 = KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SecRSADxe/SecRSADxe.efi
        SECTION UI = "SecRSADxe"
    }

    INF KodiakPkg/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/VerifiedBootDxe/VerifiedBootDxe.inf
    INF Kodiak/BOOT.MXF.1.0.1-00206-KODIAKWP-1/QcomPkg/Drivers/PciHostBridgeDxe/PciHostBridgeDxe.inf
    INF Kodiak/BOOT.MXF.1.0.1-00206-KODIAKWP-1/QcomPkg/Drivers/RawFileSystemDxe/RawFileSystemDxe.inf
    INF Kodiak/BOOT.MXF.1.0.1-00206-KODIAKWP-1/QcomPkg/Drivers/RawFsSimpleFsDxe/RawFsSimpleFsDxe.inf
    INF Kodiak/BOOT.MXF.1.0.1-00206-KODIAKWP-1/QcomPkg/Drivers/AdapterInformationDxe/AdapterInformationDxe.inf
#    INF Kodiak/BOOT.MXF.1.0.1-00206-KODIAKWP-1/QcomPkg/Drivers/SecurityDxe/SecurityDxe.inf
#    INF Kodiak/BOOT.MXF.1.0.1-00206-KODIAKWP-1/QcomPkg/Drivers/TrEEDxe/TpmDxe.inf
#    INF Kodiak/BOOT.MXF.1.0.1-00206-KODIAKWP-1/QcomPkg/Drivers/TrEEDxe/TrEEDxe.inf
}
