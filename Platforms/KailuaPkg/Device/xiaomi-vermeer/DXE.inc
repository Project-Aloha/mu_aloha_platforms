#FILE FREEFORM = DDE58710-41CD-4306-DBFB-3FA90BB1D2DD {
#    SECTION UI = "uefiplat.cfg"
#    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/uefiplat.cfg
#}

INF AndromedaPkg/Driver/SimpleFbDxe/SimpleFbDxe.inf
INF AndromedaPkg/Driver/RamPartitionDxe/RamPartitionDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/EnvDxe/EnvDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ParserDxe/ParserDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SerialPortDxe/SerialPortDxe.inf
#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/VerifiedBootDxe/VerifiedBootDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PsStateDxe/PsStateDxe.inf
#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/VariableDxe/VariableDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/EmbeddedMonotonicCounter/EmbeddedMonotonicCounter.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ResetRuntimeDxe/ResetRuntimeDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/FontDxe/FontDxe.inf
#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/QcomWDogDxe/QcomWDogDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ChipInfoDxe/ChipInfoDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/IPCCDxe/IPCCDxe.inf
#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/GLinkDxe/GLinkDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PlatformInfoDxe/PlatformInfoDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/DALSYSDxe/DALSYSDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HALIOMMUDxe/HALIOMMUDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/HWIODxe/HWIODxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/I2CDxe/I2CDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TLMMDxe/TLMMDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/CmdDbDxe/CmdDbDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PwrUtilsDxe/PwrUtilsDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/RpmhDxe/RpmhDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/NpaDxe/NpaDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ULogDxe/ULogDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/VcsDxe/VcsDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ICBDxe/ICBDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SmemDxe/SmemDxe.inf
#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/QcomBds/QcomBds.inf
#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Application/QcomChargerApp/QcomChargerApp.inf
#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/RscDxe/RscDxe.inf

# Patched Binaries
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/PatchedBinaries/ButtonsDxe.inf
INF QcomPkg/PatchedBinaries/SPMIDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/PatchedBinaries/UFSDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/PatchedBinaries/UsbConfigDxe.inf
INF QcomPkg/PatchedBinaries/ClockDxe.inf
#INF AndromedaPkg/Driver/DisplayCallerDxe/DisplayCallerDxe.inf
#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/PatchedBinaries/DisplayDxe.inf
INF QcomPkg/PatchedBinaries/PmicDxeLa.inf
#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/PatchedBinaries/QcomChargerDxeLA.inf

# DXE without depex
#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TzDxe/ScmDxeCompat.inf
FILE DRIVER = D8F91DDC-87C8-42A2-963E-8DD24A9F1FB5 {
    SECTION PE32 = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TzDxe/ScmDxeCompat.efi
    SECTION UI = "ScmDxeCompat"
}

#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TzDxe/TzDxeLA.inf
FILE DRIVER = CF6DFC66-14AB-4E13-84DB-9C02912D1404 {
    SECTION PE32 = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TzDxe/TzDxeLA.efi
    SECTION UI = "TzDxe"
}

#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ShmBridgeDxe/ShmBridgeDxeLA.inf
FILE DRIVER = 41EBB6A6-2C19-4C02-841D-848CE004A282 {
    SECTION PE32 = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ShmBridgeDxe/ShmBridgeDxeLA.efi
    SECTION UI = "ShmBridgeDxe"
}

#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/QRKSDxe/QRKSDxe.inf
FILE DRIVER = 3CF7F36E-5A97-496A-BB4B-D4F9937FA311 {
    SECTION PE32 = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/QRKSDxe/QRKSDxe.efi
    SECTION UI = "QRKSDxe"
}

FILE DRIVER = 6b38f7b4-ad98-40e9-9093-aca2b5a253c4 {
    SECTION PE32 = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.efi
    SECTION UI = "DiskIoDxe"
}

FILE DRIVER = 1fa1f39e-feff-4aae-bd7b-38a070a3b609 {
    SECTION PE32 = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.efi
    SECTION UI = "PartitionDxe"
}

#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/LimitsDxe/LimitsDxe.inf
FILE DRIVER =  F09AD92E-4E91-490F-AB99-E69939B840B2 {
    SECTION PE32 = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/LimitsDxe/LimitsDxe.efi
    SECTION UI = "LimitsDxe"
}

#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/RNGDxe/RngDxe.inf
#FILE DRIVER = B0D3689E-11F8-43C6-8ECE-023A29CEC35B {
#    SECTION UI = "RngDxe"
#    SECTION PE32 = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/RNGDxe/RngDxe.efi
#}

# Raw Files
FILE FREEFORM = A91D838E-A5FA-4138-825D-455E23030794 {
    SECTION UI = "logo1.bmp"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/logo1.bmp
}


FILE FREEFORM = 8CAE2C55-FC5A-410B-812B-8CA22F572F36 {
    SECTION UI = "Panel_truly_wqxga_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_truly_wqxga_dsc_cmd.xml
}


FILE FREEFORM = 13AC9DC9-0092-4374-AE1A-06FF35950FD0 {
    SECTION UI = "Panel_truly_wqxga_dsc_vid.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_truly_wqxga_dsc_vid.xml
}


FILE FREEFORM = FC6315F9-F8FE-4222-A1E3-226DF55D7592 {
    SECTION UI = "Panel_truly_wqxga_dual_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_truly_wqxga_dual_cmd.xml
}


FILE FREEFORM = 95E7B040-26A2-4511-9ABB-1D95D6DA7082 {
    SECTION UI = "Panel_truly_wqxga_dual_vid.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_truly_wqxga_dual_vid.xml
}


FILE FREEFORM = 8BC595B7-391A-4A9A-8256-5B9983B30392 {
    SECTION UI = "Panel_sharp_4k_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_sharp_4k_dsc_cmd.xml
}


FILE FREEFORM = 19B58ACD-B1F8-4078-B9A5-A33584B680E2 {
    SECTION UI = "Panel_sharp_4k_dsc_vid.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_sharp_4k_dsc_vid.xml
}


FILE FREEFORM = 0AE323D6-2EBE-11E8-8349-9BA636A0D80C {
    SECTION UI = "Panel_sharp_1080p_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_sharp_1080p_cmd.xml
}


FILE FREEFORM = 87273B42-311D-11E8-9324-DFB2DADFC3D1 {
    SECTION UI = "Panel_truly_1080p_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_truly_1080p_cmd.xml
}


FILE FREEFORM = BAFD3200-311D-11E8-8651-0FB3CACF38FB {
    SECTION UI = "Panel_truly_1080p_vid.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_truly_1080p_vid.xml
}


FILE FREEFORM = 88CA5ABF-D0AC-4093-A68C-0CFAE1EF9635 {
    SECTION UI = "Panel_boe_amoled_wqhd_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_boe_amoled_wqhd_dsc_cmd.xml
}


FILE FREEFORM = 6523A5C9-91CB-45C0-A2DC-25997CF23369 {
    SECTION UI = "Panel_boe_amoled_wqhd_dsc_vid.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_boe_amoled_wqhd_dsc_vid.xml
}


FILE FREEFORM = D7170685-5965-4B44-9305-37CDB199B9BE {
    SECTION UI = "Panel_boe_amoled_fhd_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_boe_amoled_fhd_dsc_cmd.xml
}


FILE FREEFORM = 8F276EE4-E75E-4C3B-8BCC-C37771E26478 {
    SECTION UI = "Panel_nt36860_wqhd_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_nt36860_wqhd_dsc_cmd.xml
}


FILE FREEFORM = 6F2D4884-D8A0-11E9-AF7A-D77B1FE990EC {
    SECTION UI = "Panel_nt36860_wqhd_dsc_vid.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_nt36860_wqhd_dsc_vid.xml
}


FILE FREEFORM = 81CE7295-491D-4E3F-AAA7-AB43FEF2F615 {
    SECTION UI = "Panel_r66451_60hz_fhd_plus_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_r66451_60hz_fhd_plus_dsc_cmd.xml
}


FILE FREEFORM = 8297C793-9861-422C-9F67-D447AF1EA812 {
    SECTION UI = "Panel_r66451_120hz_fhd_plus_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_r66451_120hz_fhd_plus_dsc_cmd.xml
}


FILE FREEFORM = 61156380-EB8A-4618-940F-AB9BDEA1EEC2 {
    SECTION UI = "Panel_r66451_120hz_fhd_plus_dsc_cmd_hdk.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_r66451_120hz_fhd_plus_dsc_cmd_hdk.xml
}


FILE FREEFORM = 44B09226-C2B4-45ED-AA6F-6686DB103978 {
    SECTION UI = "Panel_r66451_120hz_fhd_plus_dsc_vid.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_r66451_120hz_fhd_plus_dsc_vid.xml
}


FILE FREEFORM = D3F8580C-CCB8-4804-BB03-776E7B542FC2 {
    SECTION UI = "Panel_secondary_truly_1080p_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_secondary_truly_1080p_cmd.xml
}


FILE FREEFORM = D192FEE9-6A04-4BE8-ABFE-5534E2B457EC {
    SECTION UI = "Panel_secondary_truly_1080p_vid.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_secondary_truly_1080p_vid.xml
}


FILE FREEFORM = 9874B60A-6B80-4D76-8EEB-7862C780EC03 {
    SECTION UI = "Panel_r66451_144hz_fhd_plus_dsc_cmd_cphy.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_r66451_144hz_fhd_plus_dsc_cmd_cphy.xml
}


FILE FREEFORM = BC28E12E-C7E0-47F9-BBF9-0B45ED6F4B18 {
    SECTION UI = "Panel_r66451_144hz_fhd_plus_dsc_vid_cphy.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_r66451_144hz_fhd_plus_dsc_vid_cphy.xml
}


FILE FREEFORM = 637AD94D-7D9B-4D5F-B420-770B65BECDA8 {
    SECTION UI = "Panel_r66451_60hz_fhd_plus_dsc_vid.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_r66451_60hz_fhd_plus_dsc_vid.xml
}


FILE FREEFORM = AE3F9548-010C-4AEC-A9D2-4AE3E16D2F8B {
    SECTION UI = "Panel_vtdr6130_144hz_fhd_plus_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_vtdr6130_144hz_fhd_plus_dsc_cmd.xml
}


FILE FREEFORM = 12372575-2A07-4C4E-BE92-6093A55FED33 {
    SECTION UI = "Panel_vtdr6130_144hz_fhd_plus_dsc_vid.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_vtdr6130_144hz_fhd_plus_dsc_vid.xml
}


FILE FREEFORM = 36630E03-0236-4983-ABDE-F982B23419FE {
    SECTION UI = "Panel_vtdr6130_60hz_fhd_plus_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_vtdr6130_60hz_fhd_plus_dsc_cmd.xml
}


FILE FREEFORM = 573FA171-1D5C-4C12-BDC8-19DCEFBBD483 {
    SECTION UI = "Panel_vtdr6130_60hz_fhd_plus_dsc_vid.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_vtdr6130_60hz_fhd_plus_dsc_vid.xml
}


FILE FREEFORM = 0A60AF27-D18D-452F-BB8B-1A886F7F6CCC {
    SECTION UI = "Panel_sharp_120hz_qhd_plus_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_sharp_120hz_qhd_plus_dsc_cmd.xml
}


FILE FREEFORM = 81466938-BB9E-43DC-A208-A41BA82A5861 {
    SECTION UI = "Panel_sharp_120hz_qhd_plus_dsc_vid.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_sharp_120hz_qhd_plus_dsc_vid.xml
}


FILE FREEFORM = 23EB5E2D-4A4D-4B35-BB7B-BE39D7EE440D {
    SECTION UI = "Panel_secondary_vtdr6130_144hz_fhd_plus_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_secondary_vtdr6130_144hz_fhd_plus_dsc_cmd.xml
}


FILE FREEFORM = A413F4E1-50FE-4848-82F1-EFB814608221 {
    SECTION UI = "Panel_secondary_vtdr6130_144hz_fhd_plus_dsc_vid.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_secondary_vtdr6130_144hz_fhd_plus_dsc_vid.xml
}


FILE FREEFORM = EB0A97F6-39DB-41D4-9B3C-CA3BADC144B4 {
    SECTION UI = "Panel_truly_wqxga_cmd_splitlink.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_truly_wqxga_cmd_splitlink.xml
}


FILE FREEFORM = 683F6260-3744-4AE9-9AEC-3ED2CE3F0062 {
    SECTION UI = "Panel_M2_38_0c_0a_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_M2_38_0c_0a_dsc_cmd.xml
}


FILE FREEFORM = 0E3E03CE-A63D-4603-A171-8D0C8FCFFC44 {
    SECTION UI = "Panel_M3_38_0c_0a_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_M3_38_0c_0a_dsc_cmd.xml
}


FILE FREEFORM = 7A8443CA-A29C-4488-853C-2AE73DE462A3 {
    SECTION UI = "Panel_M3GL_38_0c_0a_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_M3GL_38_0c_0a_dsc_cmd.xml
}


FILE FREEFORM = F2992DB9-EC8F-44DA-96D8-805F74EE205B {
    SECTION UI = "Panel_M2A_42_02_0b_ltpo_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_M2A_42_02_0b_ltpo_dsc_cmd.xml
}


FILE FREEFORM = 485D1440-5080-899F-A66A-A88C777411EF {
    SECTION UI = "Panel_M11_42_02_0a_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_M11_42_02_0a_dsc_cmd.xml
}


FILE FREEFORM = FFEAE931-57CA-449B-AE6A-A9D68A7A8790 {
    SECTION UI = "Panel_N11_42_02_0a_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_N11_42_02_0a_dsc_cmd.xml
}


FILE FREEFORM = 922A8AF4-47F4-44F7-97C4-D6D157F694B7 {
    SECTION UI = "Panel_M1_42_02_0a_ltpo_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_M1_42_02_0a_ltpo_dsc_cmd.xml
}


FILE FREEFORM = 4C2A42CA-B71A-2527-A327-2B5A3BCDBA52 {
    SECTION UI = "Panel_M18_38_0c_0a_prim_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_M18_38_0c_0a_prim_dsc_cmd.xml
}


FILE FREEFORM = 7B5C21BC-B31A-3215-B235-5A3B2AEACB31 {
    SECTION UI = "Panel_M18_38_0c_0a_sec_dsc_cmd.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_M18_38_0c_0a_sec_dsc_cmd.xml
}


FILE FREEFORM = 43013DAA-0CE4-4D82-99EE-17F772A38401 {
    SECTION UI = "Panel_N81A_36_02_0a_duldsi_dsc_vid.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_N81A_36_02_0a_duldsi_dsc_vid.xml
}


FILE FREEFORM = 9A2A35AB-C69B-2729-A529-4C2A6BECAA74 {
    SECTION UI = "Panel_secondary_sim_vid.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_secondary_sim_vid.xml
}


FILE FREEFORM = F4A245C8-940E-4523-A53B-82E3C8BC6970 {
    SECTION UI = "Panel_r66451_120hz_fhd_plus_dsc_cmd_demura.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_r66451_120hz_fhd_plus_dsc_cmd_demura.xml
}


FILE FREEFORM = 3DE03011-41E8-4353-A4E5-02721E71A0F4 {
    SECTION UI = "Panel_vtdr6130_144hz_fhd_plus_dsc_cmd_demura.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_vtdr6130_144hz_fhd_plus_dsc_cmd_demura.xml
}


FILE FREEFORM = 0EF4D970-0B59-4AF4-A8F7-F6A239EED792 {
    SECTION UI = "Panel_vtdr6130_144hz_fhd_plus_dsc_cmd_rfi.xml"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/Panel_vtdr6130_144hz_fhd_plus_dsc_cmd_rfi.xml
}


FILE FREEFORM = 03E9256F-E621-48D8-8576-7E3B4FCF2D41 {
    SECTION UI = "PanelSimConfig.csv"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/PanelSimConfig.csv
}


FILE FREEFORM = 21E9BDD9-6C3F-4F10-84A5-BBEC322741F1 {
    SECTION UI = "uefipil.cfg"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/uefipil.cfg
}


FILE FREEFORM = 45FE4B7C-150C-45DA-A021-4BEB2048EC6F {
    SECTION UI = "QcomChargerCfg.cfg"
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/RawFiles/QcomChargerCfg.cfg
}

###### FV2 ######
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SimpleTextInOutSerialDxe/SimpleTextInOutSerial.inf
INF MdeModulePkg/Universal/PrintDxe/PrintDxe.inf
INF MdeModulePkg/Universal/Console/ConPlatformDxe/ConPlatformDxe.inf
INF MdeModulePkg/Universal/Console/ConSplitterDxe/ConSplitterDxe.inf
INF MdeModulePkg/Universal/Console/GraphicsConsoleDxe/GraphicsConsoleDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/CPRDxe/CPRDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/GpiDxe/GpiDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SPIDxe/SPIDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SdccDxe/SdccDxe.inf
#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ChargerExDxe/ChargerExDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PmicGlinkDxe/PmicGlinkDxe.inf
#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/QcomChargerDxe/QcomChargerDxeLA.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbPwrCtrlDxe/UsbPwrCtrlDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/TsensDxe/TsensDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/DDRInfoDxe/DDRInfoDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbfnDwc3Dxe/UsbfnDwc3Dxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/XhciPciEmulationDxe/XhciPciEmulationDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/XhciDxe/XhciDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbBusDxe/UsbBusDxe.inf
#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbKbDxe/UsbKbDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbMassStorageDxe/UsbMassStorageDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbMsdDxe/UsbMsdDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbDeviceDxe/UsbDeviceDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UsbInitDxe/UsbInitDxe.inf

#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UCDxe/UCDxe.inf
FILE DRIVER = 5F0937CD-73F9-445E-B320-BB6FD5D3CBDE {
    SECTION PE32 = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/UCDxe/UCDxe.efi
    SECTION UI = "UCDxe"
}
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PILDxe/PILDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/PILProxyDxe/PILProxyDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SPSSDxe/SPSSDxe.inf
INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/FvUtilsDxe/FvUtilsDxe.inf

# Dxe without depex 
#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ASN1X509Dxe/ASN1X509Dxe.inf
FILE DRIVER = C2F9A4F5-F7B4-43E7-BA99-5EA804CC103A {
    SECTION PE32 = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/ASN1X509Dxe/ASN1X509Dxe.efi
    SECTION UI = "ASN1X509Dxe"
}

#INF $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SecRSADxe/SecRSADxe.inf
FILE DRIVER = 32C71E68-83A8-46ED-AED1-094E71B12057 {
    SECTION UI = "SecRSADxe"
    SECTION PE32 = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/Binaries/QcomPkg/Drivers/SecRSADxe/SecRSADxe.efi
}

# Patched Binaries
#INF QcomPkg/PatchedBinaries/FeatureEnablerDxe.inf
FILE DRIVER = 1C04F529-0612-4319-9315-B2E75C16810A {
    SECTION PE32 = QcomPkg/PatchedBinaries/FeatureEnablerDxe.efi
    SECTION UI = "FeatureEnablerDxe"
}
