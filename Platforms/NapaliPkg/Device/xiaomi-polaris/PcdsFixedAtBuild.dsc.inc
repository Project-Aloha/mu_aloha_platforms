[PcdsFixedAtBuild.common]
gAndromedaPkgTokenSpaceGuid.PcdMipiFrameBufferWidth|1080
gAndromedaPkgTokenSpaceGuid.PcdMipiFrameBufferHeight|2160

# Smbios Info
gAndromedaPkgTokenSpaceGuid.PcdSmbiosSystemBrand|"Xiaomi"
gAndromedaPkgTokenSpaceGuid.PcdSmbiosSystemModel|"MIX 2S"
gAndromedaPkgTokenSpaceGuid.PcdSmbiosSystemRetailModel|"polaris"
gAndromedaPkgTokenSpaceGuid.PcdSmbiosSystemRetailSku|"MIX 2S"
gAndromedaPkgTokenSpaceGuid.PcdSmbiosProcessorModel|"Snapdragon (TM) 845 @ 2.80 GHz"
gAndromedaPkgTokenSpaceGuid.PcdSmbiosProcessorRetailModel|"SDM845"
gAndromedaPkgTokenSpaceGuid.PcdSmbiosBoardModel|"polaris"

gAndromedaPkgTokenSpaceGuid.PcdABLProduct|"polaris"

# Display Caller
gAndromedaPkgTokenSpaceGuid.PcdDisplayCallerExitDisableDisplay|FALSE
gAndromedaPkgTokenSpaceGuid.PcdDisplayCallerStallBeforeEnable|2000

[PcdsDynamicDefault.common]
gEfiMdeModulePkgTokenSpaceGuid.PcdVideoHorizontalResolution|1080
gEfiMdeModulePkgTokenSpaceGuid.PcdVideoVerticalResolution|2160
gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoHorizontalResolution|1080
gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoVerticalResolution|2160
gEfiMdeModulePkgTokenSpaceGuid.PcdSetupConOutColumn|135 # = 1080 / EFI_GLYPH_WIDTH(8)
gEfiMdeModulePkgTokenSpaceGuid.PcdSetupConOutRow|113    # = 2160 / EFI_GLYPH_HEIGHT(19)
gEfiMdeModulePkgTokenSpaceGuid.PcdConOutColumn|135      # = 1080 / EFI_GLYPH_WIDTH(8)
gEfiMdeModulePkgTokenSpaceGuid.PcdConOutRow|113         # = 2160 / EFI_GLYPH_HEIGHT(19)
