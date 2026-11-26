FILE FREEFORM = 7E374E25-8E01-4FEE-87F2-390C23C606CD {
    SECTION RAW = SurfaceDuoACPI/845/builtin/MADT.aml
    SECTION RAW = SurfaceDuoACPI/845/builtin/CSRT.aml
    SECTION RAW = SurfaceDuoACPI/845/builtin/DBG2.aml
    SECTION RAW = $(PACKAGE_NAME)/Device/$(TARGET_DEVICE)/ACPI/DSDT.aml
    SECTION RAW = SurfaceDuoACPI/845/builtin/FACP.aml
    SECTION RAW = SurfaceDuoACPI/845/builtin/GTDT.aml
    SECTION RAW = SurfaceDuoACPI/845/builtin/IORT.aml
#    SECTION RAW = SurfaceDuoACPI/845/builtin/MCFG.aml
    SECTION RAW = SurfaceDuoACPI/845/builtin/PPTT.aml

#    SECTION RAW = SurfaceDuoACPI/QcomACPI/common/builtin/SSDT.aml
#    SECTION RAW = SurfaceDuoACPI/QcomACPI/common/builtin/TPMDev.dat
#    SECTION RAW = SurfaceDuoACPI/QcomACPI/common/builtin/SoftwareTpm2Table.aml
	SECTION UI = "AcpiTables"
}
