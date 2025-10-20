## This Repo Is Based On [mu_andromeda_platforms](https://github.com/WOA-Project/mu_andromeda_platforms/)

### Thanks for [Gustave](https://github.com/gus33000)'s instructions!

# [Project Mu](https://microsoft.github.io/mu/) UEFI Implementation for Devices with Snapdragon™ inside.

## For users

You can download the latest UEFI build by clicking [here](https://github.com/Project-Aloha/mu_aloha_platforms/actions).

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/Project-Aloha/mu_aloha_platforms/all_reference_platforms.yml)

## What's this?

This package demonstrates an AArch64 UEFI implementation for hacked devices with qcom silicons. Currently it is able to boot Windows 10 ARM64 as well as Windows 11 ARM64. Please be aware that devices with no dsdt support have limited support.

## Support Status

Applicable to all supported targets unless noted.

- Low-speed I/O: I2C, SPI, GPIO, SPMI and Pinmux (TLMM).
- Power Management: PMIC and Resource Power Manager (RPM).
- High-speed I/O for firmware and HLOS: UFS 3.1
- Peripherals: side-band buttons (TLMM GPIO and PMIC GPIO), USB
- Display FrameBuffer

## What can you do?

Please see https://Project-Aloha.github.io for some tutorials.

## Build

### Minimum System Requirements

- At least 2 cores x86_64 processor running at 2Ghz or higher implementing the X86 ISA with 64 bit AMD extensions (AMD64) (Currently, building on any other ISA is not supported. In other words, do. not. build. this. on. a. phone. running. android. please.)
- SSD
- A linux environment capable of running below tool stack:
  - Bash
  - Python 3.12 or higher (python3.12, python3.12-venv, python3.12-pip)
  - mono-devel
  - git-core, git
  - build-essential
  - clangpdb (or higher), llvm, ggc-aarch64-linux-gnu
- Exported CLANGPDB_BIN environment variable pointing to LLVM 10 binary folder
- Exported CLANGPDB_AARCH64_PREFIX variable equalling to aarch64-linux-gnu-

### Build Instructions

- Clone this repository to a reasonable location on your disk (There is absolutely no need to initialize submodules, stuart will do it for you later on)
- Run the following commands in order, with 0 typo, and without copy pasting all of them blindly all at once:

1. Setup Base environment

```
./build_setup.sh
pip install --upgrade -r pip-requirements.txt
./build_uefi.py --init
```

*Alternatively, use docker if you don't have Ubuntu 24.04 environment*

```
sudo docker build -t mu:v1 .
sudo docker run -v $(pwd):/build/ -it mu:v1
```

*Then finish the following process in docker environment*

2. Build UEFI & Generate Android Boot Image
> Usage: build_uefi.py -d \<target-device\> -s \<secureboot status\> -t \<build type\>  
- Exmaple with secure boot off and release build:
  ```
  ./build_uefi.py -d <target-name>
  ```

- Exmaple with secure boot on:
  ```
  ./build_uefi.py -d <target-name> -s 1
  ```

- Exmaple with secure boot off and DEBUG build:
  ```
  ./build_uefi.py -d <target-name> -t DEBUG
  ```

- Tips:
  - Use `-p all` to build devices in all platforms.
  - Use `-d all -p <target-platform>` to build all devices in same platform.
  - Use `-i` or `--init` to reinitialize build environment. Generally it's useful after a rebase update.

- If the build is sucessful, the bootable artifact can be found at Build/xxxxPkg/\<target-device\>.img.

## Target list

### Snapdragon 835 (*MSM8998*)

#### OnePlus Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| OnePlus 5T                           | oneplus-dumpling       | ✅              | [qaz6750](https://github.com/qaz6750)              |

#### Xiaomi Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Xiaomi 6                             | Xiaomi-sagit           | ✅              | [qaz6750](https://github.com/qaz6750)              |

### Snapdragon 845/850 (*SDM845*)

#### OnePlus Devices

| Device                               | Target name            | DSDT Support    | Maintainers                                        |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| OnePlus 6                            | oneplus-enchilada      | ✅              | [Daniel224455](https://github.com/Daniel224455)    |


### Snapdragon 855/855+/860 (*SM8150*)

#### Qualcomm Technologies, Inc. Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Qualcomm Technologies, Inc. MTP 8150 | qcom-mtp8150           | ✅              | NONE                                               |
| Qualcomm Technologies, Inc. QRD 8150 | qcom-qrd8150           | ✅              | sunflower2333                                      |

#### ASUS Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| ASUS ROG2                            | asus-I001DC            | ✅              | [sunflower2333](https://github.com/sunflower2333)  |

#### Axon Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Axon Stage 5G                        | kakao-pine             | ❌              | [AKA](https://github.com/AKAsaliza)                |

#### BlackShark Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| BlackShark 2                         | blackshark-skywalker   | ❌              | NONE                                               |
| BlackShark 2 Pro                     | blackshark-darklighter | ❌              | NONE                                               |

#### HTC Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| HTC 5G Hub                           | htc-rtx                | ❌              | NONE                                               |

#### LG Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| LG G8                                | lg-alphaplus           | ✅              | sunflower2333                                      |
| LG G8S                               | lg-betalm              | ✅              | [J0SH1X](https://github.com/J0SH1X)                |
| LG G8X                               | lg-mh2lm               | ✅              | [Molly Sophia](https://github.com/MollySophia)     |
| LG V50                               | lg-flashlmdd           | ✅              | [AKA](https://github.com/AKAsaliza)                |
| LG V50S                              | lg-mh2lm5g             | ✅              | [AKA](https://github.com/AKAsaliza)                |

#### Meizu Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Meizu 16s                            | meizu-m971q            | ❌              | NONE                                               |
| Meizu 16T                            | meizu-m928q            | ❌              | NONE                                               |

#### Nubia Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Nubia Mini 5G                        | nubia-tp1803           | ✅              | [Alula](https://github.com/alula)                  |
| Nubia RedMagic 3                     | nubia-nx629j           | ❌              | NONE                                               |
| Nubia RedMagic 3S                    | nubia-nx629jv1s        | ❌              | NONE                                               |

#### OnePlus Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| OnePlus 7                            | oneplus-guacamoleb     | ✅              | NONE                                               |
| OnePlus 7 Pro                        | oneplus-guacamole      | ✅              | [Waseem Alkurdi](https://github.com/WaseemAlkurdi) |
| OnePlus 7T                           | oneplus-hotdogb        | ✅              | UNKNOWN                                            |
| OnePlus 7T Pro                       | oneplus-hotdog         | ✅              | [Morc](https://github.com/TheMorc)                 |
| OnePlus 7T Pro 5G                    | oneplus-hotdogg        | ✅              | NONE                                               |

#### OPPO Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| OPPO Reno 10X                        | oppo-op46c3            | ❌              | NONE                                               |
| OPPO Reno ACE                        | oppo-pclm10            | ✅              | NONE                                               |

#### Realme Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Realme X2 Pro                        | realme-rmx1931         | ❌              | NONE                                               |
| Realme X3 SuperZoom                  | realme-rmx2086         | ✅              | NONE                                               |

#### Samsung Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Samsung Galaxy Fold                  | samsung-winner         | ✅              | [Ost268](https://github.com/Ost268)                |
| Samsung Galaxy S10                   | samsung-beyond1qlte    | ✅              | [Ww](https://github.com/Idonotkno)                 |
| Samsung Galaxy Tab S6                | samsung-gts6l          | ✅              | NONE                                               |
| Samsung Galaxy Tab S6 WIFI           | samsung-gts6lwifi      | ✅              | [qaz6750](https://github.com/qaz6750)              |

#### Smartisan Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Smartisan Pro 3                      | smartisan-aries        | ❌              | NONE                                               |

#### Xiaomi Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Xiaomi 9                             | xiaomi-cepheus         | ✅              | [qaz6750](https://github.com/qaz6750)              |
| Xiaomi K20 Pro                       | xiaomi-raphael         | ✅              | [Degdag](https://github.com/degdag)&sunflower2333  |
| Xiaomi Mix Alpha u2                  | xiaomi-avenger         | ❌              | NONE                                               |
| Xiaomi Mix3 5G                       | xiaomi-andromeda       | ✅              | NONE                                               |
| Xiaomi Mix3.5                        | xiaomi-hercules        | ✅              | NONE                                               |
| Xiaomi Pad 5                         | xiaomi-nabu            | ✅              | [Map220v](https://github.com/map220v)              |
| Xiaomi Poco X3 Pro                   | xiaomi-vayu            | ✅              | [Degdag](https://github.com/degdag)                |


### Snapdragon 675/720G/7c/7c Gen 2 (*SM6250*/*SM7125*/*SC7180*)

#### Qualcomm Technologies, Inc. Devices

| Device                               | Target name            | DSDT Support    | Maintainers                                        |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Qualcomm Technologies, Inc. QRD 7125 | qcom-qrd7125           | ✅              | sunflower2333                                      |

#### Xiaomi Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Xiaomi Note 9S                       | xiaomi-miatoll         | ✅              | Icesito                                            |

### Snapdragon 730/730G/732G (*SM7150*)

#### Qualcomm Technologies, Inc. Devices

| Device                               | Target name            | DSDT Support    | Maintainers                                        |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Qualcomm Technologies, Inc. QRD 7150 | qcom-qrd7150           | ✅              | [qaz6750](https://github.com/qaz6750)              |

#### Xiaomi Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Xiaomi POCO X3                       | xiaomi-surya           | ✅              | [remtrik](https://github.com/remtrik)              |


### Snapdragon 778G/7c+ Gen 3 (*SM7325*/*SC7280*)

#### Qualcomm Technologies, Inc. Devices

| Device                               | Target name            | DSDT Support    | Maintainers                                        |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Qualcomm Technologies, Inc. QRD 7325 | qcom-qrd7325           | ✅              | [Ayu](https://github.com/chenyu0329)&sunflower2333 |


### Snapdragon 888/888+/888 4G/G3x Gen 1 (*SM8350*/*SM8350P*/*SG8175P*)

#### Qualcomm Technologies, Inc. Devices

| Device                               | Target name            | DSDT Support    | Maintainers                                        |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Qualcomm Technologies, Inc. MTP 8350 | qcom-mtp8350           | ✅              | [Ayu](https://github.com/chenyu0329)               |

#### Samsung Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Galaxy Z Fold 3 5G                   | samsung-q2q            | ✅              | None                                               |

#### ZTE Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| ZTE A31 Pro                          | zte-p875a02            | ✅              | None                                               |

#### Xiaomi Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Xiaomi K40 Pro                       | xiaomi-haydn           | ❌              | None                                               |
| Xiaomi Mi 11                         | xiaomi-venus           | ✅              | None                                               |

### Snapdragon 8 Gen 1 / 8+ Gen 1 / 7+ Gen 2 (*SM8450/SM8475/SM7475*)

#### Qualcomm Technologies, Inc. Devices

| Device                               | Target name            | DSDT Support    | Maintainers                                        |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Qualcomm Technologies, Inc. HDK 8450 | qcom-hdk8450           | ❌              | None                                               |

#### Xiaomi Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Xiaomi Pad 6 Pro                     | xiaomi-liuqin          | ❌              | None                                               |


### Snapdragon 8 Gen 2 (*SM8550*)

#### Qualcomm Technologies, Inc. Devices

| Device                               | Target name            | DSDT Support    | Maintainers                                        |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Qualcomm Technologies, Inc. QRD 8550 | qcom-qrd8550           | ❌              | None                                               |

#### AYANEO Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| AYANEO Pocket S                      | ayaneo-aps             | ❌              | None                                               |

#### AYN Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| AYN Odin 2                           | ayn-odin2              | ❌              | None                                               |

#### Nubia Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Nubia RedMagic 8 Pro                 | nubia-nx729j           | ❌              | None                                               |

#### Oneplus Devices
| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Oneplus 11 5G                        | oneplus-salami         | ❌              | None                                               |

#### Xiaomi Devices

| Device                               | Target name            | DSDT Support    | Contributors                                       |
|--------------------------------------|------------------------|-----------------|----------------------------------------------------|
| Xiaomi 13                            | xiaomi-fuxi            | ❌              | None                                               |
| Xiaomi 13 Pro                        | xiaomi-nuwa            | ❌              | None                                               |
| Xiaomi Pad6 S Pro                    | xiaomi-sheng           | ❌              | None                                               |
| Xiaomi K60 Pro                       | xiaomi-socrates        | ❌              | None                                               |


## Acknowledgements
- Gustave Monce and his [mu_andromeda_platforms](https://github.com/WOA-Project/mu_andromeda_platforms)
- [EFIDroid Project](http://efidroid.org)
- Andrei Warkentin and his [RaspberryPiPkg](https://github.com/andreiw/RaspberryPiPkg)
- Sarah Purohit
- [Googulator](https://github.com/Googulator/)
- [Ben (Bingxing) Wang](https://github.com/imbushuo/)
- Samuel Tulach and his [Rainbow Patcher](https://github.com/SamuelTulach/rainbow)
- [BigfootACA](https://github.com/BigfootACA) and his [SimpleInit](https://github.com/BigfootACA/simple-init)
- [Uotan](https://github.com/Uotan-Dev)
- Developers in [Project-Silicium](https://github.com/Project-Silicium)
- Developers in [Renegade Project](https://github.com/edk2-porting)
- Lemon ICE

## License ![License](https://img.shields.io/github/license/Project-Aloha/mu_aloha_platforms)
