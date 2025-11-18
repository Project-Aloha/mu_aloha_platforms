#!/bin/bash

rm ./payload.bin
cp ./BootShim.bin ./kernel
cat ./SM8250_EFI_SB.fd >> ./kernel
size=$(stat --printf="%s" ./kernel)

echo -n "554E434F4D505245535345445F494D47" | xxd -r -p > ./payload.bin
printf "0: %.8x" $size | sed -E 's/0: (..)(..)(..)(..)/0: \4\3\2\1/' | xxd -r -g0 >> ./payload.bin
cat ./BootShim.bin >> ./payload.bin
cat ./SM8250_EFI_SB.fd >> ./payload.bin
cat ./devicetree >> ./payload.bin

# Make android boot
python3 ./mkbootimg.py \
  --kernel ./payload.bin \
  --ramdisk ./ramdisk \
  -o qcom-kona.img \
  --pagesize 0x1000 \
  --header_version 0 \
  --cmdline "console=ttyMSM0,115200n8 earlycon=msm_geni_serial,0xa90000 androidboot.hardware=qcom androidboot.console=ttyMSM0 androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 service_locator.enable=1 androidboot.usbcontroller=a600000.dwc3 swiotlb=2048 buildvariant=userdebug" \
  --base 0x0 \
  --os_patch_level 2019-04-01 \
  --second_offset 0x00f00000 \
  --ramdisk_offset 0x01000000 \
  --kernel_offset 0x00008000 \
  --second ./second