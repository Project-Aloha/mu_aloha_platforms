# msmnilePkg Porting Guide. 
## **[中文版](SimpleGuide.CN.md)**
## **⚠ Notice, Do not try it on Google devices, Sony devices or Samsung devices.**

> ### The Guide has 4 parts.
>> 0. Introduce some directories and files.
>> 1. Early porting and tests.
>> 2. Try to boot windows and test UFS & USB.
>> 3. Patch binaries.
___
## **Part 0.** Introduce some directories and files.
  - We only need to know few directories and files under `Platform/SurfaceDuo1Pkg/`
    ```
    ~/mu-msmnile$ tree Platforms/SurfaceDuo1Pkg/ -L 2 -d
    Platforms/SurfaceDuo1Pkg/
    |-- AcpiTables
    |   |-- 8150
    |   |-- CustomizedACPI
    |   `-- Include
    |-- Device
    |   |-- asus-I001DC
    |   |-- kakao-pine
    |   |-- lg-alphaplus
    |   |-- lg-betalm
    |   |-- lg-flashlmdd
    |   |-- lg-mh2lm
    |   |-- lg-mh2lm5g
    |   |-- meizu-m928q
    |   |-- nubia-tp1803
    |   |-- oneplus-guacamole
    |   |-- oneplus-hotdog
    |   |-- samsung-beyond1qlte
    |   |-- xiaomi-andromeda
    |   |-- xiaomi-cepheus
    |   |-- xiaomi-hercules
    |   |-- xiaomi-nabu
    |   |-- xiaomi-raphael
    |   `-- xiaomi-vayu
    |-- Driver
    |   |-- GpioButtons
    |   `-- KernelErrataPatcher
    |-- FdtBlob
    |-- Include
    |   |-- Configuration
    |   |-- Library
    |   `-- Resources
    |-- Library
    |   |-- MemoryInitPeiLib
    |   |-- MsPlatformDevicesLib
    |   |-- PlatformPeiLib
    |   |-- PlatformPrePiLib
    |   |-- PlatformThemeLib
    |   `-- RFSProtectionLib
    |-- PatchedBinaries
    `-- PythonLibs
    ```
    - **AcpiTables/**
      * *Stores ACPI tables.*
    - **Device/**
      * *Stores each device's specific binaries and configurations.*
      * *The subfolder's name should be `brand-codename`.*
    - **Driver/**
      * *Stores uefi drivers.*
    - **FdtBlob/**
      * *Contains SurfaceDuo's flat device tree blob.*
    - **Include/**
      * *Contains C headers.*
    - **Library/**
      * *Contains libs the drivers need.*
    - **PatchedBinaries/**
      * *Contains patched binaries for SurfaceDuo1.*
    - **PythonLibs/**
      * *Stores python libs.*
  - Let's take a closer look at `Device/nubia-tp1803`. 
    ```
    ~/mu-msmnile/Platforms/SurfaceDuo1Pkg/Device$ tree -L 1  nubia-tp1803/
    ├── ACPI
    ├── APRIORI.inc
    ├── Binaries
    ├── Defines.dsc.inc
    ├── DeviceTreeBlob
    ├── DXE.dsc.inc
    ├── DXE.inc
    ├── Library
    ├── PatchedBinaries
    └── PcdsFixedAtBuild.dsc.inc
    ```
    - **ACPI/**
      * *Stores device's dsdt table.*
    - **Binaries/**
      * *Stores device's firmware binaries.*
    - **PatchedBinaries/**
      * *As its name, it stores patched binaries for the device.*
    - **Library/**
      * *Put device specific Library*
    - **DeviceTreeBlob/**
      * *Put device tree blob*
        - *In subdir `Linux` stores mainline linux dtb, file name must be `linux-codename.dtb`*
        - *In subdir `Android` store Android dtb, file name must be `android-codename.dtb`*
    - **APRIORI.inc**
      * *Load Order of Dxe*
      * *Included by SurfaceDuo1.fdf*
    - **DXE.dsc**
      * *Declare Drivers*
      * *Included by SurfaceDuo1.fdf*
    - **DXE.dsc.inc**
      * *Declare Drivers*
      * *Included by SurfaceDuo1.dsc*
    - **Defines.dsc.inc**
      * *Macros for special use.*
      * *For detailed about Macros, please read [DefinesGuidance.md](DefinesGuidance.md)*
    - **PcdsFixedAtBuild.dsc.inc**
      * *Included by SurfaceDuo1.dsc.*
      * *Stores device specific pcds. (e.g Screen resolution)*
___
## **Part 1.** Early porting and tests.
  - For example, porting uefi for meizu 16T.
    1. Search for its code name: m928q.
    2. Copy `oneplus-guacamole/` to `meizu-m928q/`. (brand-codename).
    3. Remove all files under `meizu-m928q/Binaries` & `meizu-m928q/PatchedBinaries.`
    4. Extract files from your device's xbl and put them under Binaries.
        + *Download and compile [UefiReader](https://github.com/WOA-Project/UEFIReader)*
        + *Connect your phone to your computer and execute the command on your computer.*
          ```
          adb shell su -c "dd if=/dev/block/by-name/xbl_a of=/sdcard/xbl.img"
          adb pull /sdcard/xbl.img .
          ```
        + *Execute UefiReader.exe <Path-to-xbl.img> <Path-to-output-folder>*
        + *Put output into `meizu-m928q/Binaries`.*
    5. Edit `${brand-codename}/DXE.inc`, `${brand-codename}/APRIORI.inc`, `${brand-codename}/DXE.dsc.inc`.
        + *See the difference by `diff`*
          ```
          $ diff meizu-m928q/Binaries/DXE.inc oneplus-guacamole/Binaries/DXE.inc 
          23d22
          < INF QcomPkg/Drivers/SimpleTextInOutSerialDxe/SimpleTextInOutSerial.inf
          97,102d95
          < FILE FREEFORM = A91D838E-A5FA-4138-825D-455E23030795 {
          <     SECTION UI = "logo2_ChargingMode.bmp"
          <     SECTION RAW = RawFiles/logo2_ChargingMode.bmp
          < }
            ...
          ```
        + *So you have to edit `Raw Files` part in `${brand-codename}/DXE.inc` and add SimpleTextInOutSerial in `${brand-codename}/DXE.inc` and `${brand-codename}/DXE.dsc.inc`*
        + *If SimpleTextInOutSerial is also set in Binaries/APRIORI.inc, you need to add it into `${brand-codename}/APRIORI.inc`*
    6. Enable MLVM in `Defines.dsc.inc` (FALSE -> TRUE)
    7. Edit resolution in `PcdFixedAtBuild.dsc.inc`.
    8. Patch your device's dxe and put them under `PatchedBinaries/`.
    9. Replace `android-guacamole.dtb` with `android-m928q.dtb` (you can find your device's dtb in `/sys/firmware/fdt`, or see [Additions](#additions))
    10. Replace `linux-guacamole.dtb` with `linux-m928q.dtb`.(if you do not have, create a dummy one by `touch linux-m928q.dtb`)
    11. Build it.
    12. Test it.
        + *Connect your phone to your computer and execute it on your computer.*
          ```
          adb reboot bootloader
          fastboot boot Build/meizu-m928q/meizu-m928q.img
          ```
  - Your device will enter UEFI Shell if porting success.
  - What if it stacks, reboots or crashes ?
    * See part 3 and patch your device's firmware binaries, or contact us.
___
## **Part 2.** Try to boot windows.
  *The DSDT for guacamole is the basic DSDT. It only contains USB & UFS.*
  - Setup Windows PE environment on your device.
  - Try to boot into Windows PE.
  - What if it stacks, reboots or crashes ?
    * Check MemoryMap *(brand-codename/Library/PlatformMemoryMapLib/PlatformMemoryMapLib.c)*.
    * Check DeviceConfigurationMap *(brand-codename/Configuration/DeviceConfigurationMap.h)*.
    * Check HAS_MLVM in `Defines.dsc.inc`, if windows hangs up at boot, try to set it to `TRUE`.
  - Usb not working with external power supply?
    * Patch firmware binaries.
  *It will boot into PE if porting success.*
___
## **Part 3.** Patch binaries.
  - Which binary needs Patch ?
    * If your phone stack while loading PILDxe, patch UFSDxe.
    * If your phone can not connect with PC via KDNET, or USB not working in windows(with external power), patch UsbConfigDxe.
    * If your phone can not use button at uefi stage, please patch ButtonsDxe.
  - Where to patch ?
    * The most simple way to know where to patch:
      + Find one other device's original xxxDxe.efi and its patched xxxDxe.efi .
      + Dump hex and get where & what to patch.
        ```
        hexdump -C a_xxxDxe.efi > a.txt
        hexdump -C b_xxxDxe.efi > b.txt
        diff a.txt b.txt
        ```
        - Example: 
            * UFSDxe.efi (nabu):
            ```
            ~/mu-msmnile/Platforms/SurfaceDuo1Pkg/Device/xiaomi-nabu$ diff a.txt b.txt 
            383c383
            < 000025f0  00 00 80 52 c0 03 5f d6  fd 7b 03 a9 fd c3 00 91  |...R.._..{......|
            ---
            > 000025f0  ff 03 01 d1 f4 4f 02 a9  fd 7b 03 a9 fd c3 00 91  |.....O...{......|
            913c913
            < 00004710  20 00 80 52 c0 03 5f d6  fd 43 00 91 e8 7b 00 32  | ..R.._..C...{.2|
            ---
            > 00004710  ff 83 00 d1 fd 7b 01 a9  fd 43 00 91 e8 7b 00 32  |.....{...C...{.2|
            ```
    * How to patch ?
      + Now you know the difference addr is `0x000025f0` and `0x00004710`.
      + Open the two efi files in IDA (or other tools), find the function near `0x000025f0` and `0x00004710`.
      + See which instructions were modified.
      + Open your device's xxxDxe.efi in IDA.
      + Find the same function(s).
      + Apply the same patch for your device's xxxDxe.efi .
      + Put the patched binaries under `PatchedBinaries/`.
      + Check DXE.inc and DXE.dsc.inc for the paths to your device's patched binaries.
___
## **Additions**
  - How to get dtb of my device? *assume in termux environment*
    * Download Magiskboot. ([Prebuilt](https://github.com/TeamWin/external_magisk-prebuilt/blob/android-11/prebuilt/))
    * Get boot image from your phone.
      ```
      sudo cp /dev/block/by-name/boot ~/split-appended-dtb/myboot.img
      ```
    * Split dtb from you phone's boot.
      ```
      ./magiskboot_arm unpack myboot.img
      ```
    * Renamed `kernel_dtb`(or `dtb`) to android-`codename`.dtb and put it into Device/*\<brand-codename\>*/DeviceTreeBlob/Android/.
  - Should MLVM always be `TRUE`?
    * In early test you can set it to `TRUE` to avoid MLVM issue.
    * If you can boot windows, turn it to `FALSE` and have a try.
    * Set MLVM to `TRUE` will occupy about 300MB Ram.
___
***Don't forget to add your device and maintainer into [README](../README.md).***  
***Thanks for your hard works.***
