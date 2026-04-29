## This Doc will introduce some Defines you may need in Defines.dsc.inc
___
> **HAS_MLVM**  
  * Type
    - Boolean
  * Why define it ?
    - Some devices have MLVM region, some do not.
    - If the device has MLVM enabled, MLVM regions will be protected, and they'll be un-readable and un-writeable.
  * What happened when **1**?
    - If `HAS_MLVM = TRUE`, the MLVM regions will be reserved, so HLOS will not use this region.
    - Total RAM size will decrease about 400MB.
  * Where used it ?
    - `HAS_MLVM` is used in Platforms/AndromedaPkg/Driver/RamPartitionDxe/ExtendedMemoryMap.h.

> **CUST_PLATFORM_PRE_PI_LIB**  
  * Type
    - Boolean
  * Why define it ?
    - Some device may want to customized `IsLinuxBootRequested()` function in Library/PlatformPrePiLib/PlatformUtils.c 
    - The `IsLinuxBootRequested()` function is used to judge the direction where to boot.
      + return `TRUE`
        * boot to Android
      + return `FALSE`
        * boot to UEFI
  * What happened when **1**?
    - The build-system will try to find PlatformPrePiLib under Device/$(brand-codename)/Library/PlatformPrePiLib/
  * Where used it ?
    - `CUST_PLATFORM_PRE_PI_LIB`  is used in Platforms/AndromedaPkg/Andromeda.dsc.inc
    - Line: 395

> **CUST_LOGO**  
  * Type
    - Boolean
  * Why define it ?
    - Some Device may want it's own logo. (i.e. Brand's Logo)
  * What happened when **1**?
    - The Boot Logo will be replaced with the one under Device/$(brand-codename)/Include/Resources/CustBootLogo.bmp
  * Where used it ?
    - `CUST_LOGO` is used in Platforms/AndromedaPkg/Frontpage.fdf.inc
