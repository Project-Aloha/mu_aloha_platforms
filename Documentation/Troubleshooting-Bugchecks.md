# Troubleshooting: Windows bugchecks at boot / first setup

Most "Windows won't boot on my device" reports come down to one rule:

> **The UEFI build, the Windows build and the driver pack (BSP) must come from the same
> generation.** Mixing eras produces bugchecks that look convincingly like hardware or
> firmware faults.

The four most common stop codes, what they look like, and what they actually are
(root-caused on xiaomi-nabu / sm8150; the mechanisms are platform-level, so they likely
apply to other targets too — data in
[Project-Aloha/mu_aloha_platforms#766](https://github.com/Project-Aloha/mu_aloha_platforms/issues/766)):

| Stop code | Looks like | Actual cause | Fix |
|---|---|---|---|
| `0x7B` INACCESSIBLE_BOOT_DEVICE, instant | "storufs can't drive my UFS / bad UFS vendor" | The Windows volume was formatted with Linux `mkfs.ntfs` (unreliable for the boot path, especially on native-4Kn storage), or an old-era Windows image under a new-era UEFI | Format the volume from Windows tools (`Format-Volume`/diskpart); keep generations matched |
| `0x1D5` DRIVER_PNP_WATCHDOG on `qcsmmu`, ~6 min in, device install never starts | "SMMU driver broken" | Booting a **pre-MmuDetach** (before Jan 2026) UEFI **ephemerally** via `fastboot boot` leaves SMMU state Windows can't take over. The same image *flashed* works | Use a current UEFI (post-MmuDetach boots fine even ephemerally), or flash the boot image instead of `fastboot boot` |
| `0x3B` SYSTEM_SERVICE_EXCEPTION in `win32kbase`, every boot, during device setup | "touch driver broken" | Windows 24H2 26100.1 RTM: win32k itself faults when a touch driver registers its pointer device (`rimInUserCritCreatePointerDeviceInfo`). Microsoft code, fixed in later builds | Use the Windows build your driver pack's install guide specifies (e.g. 25H2 for 2501+ packs) — it's a hard requirement, not a preference |
| `0xA` IRQL_NOT_LESS_OR_EQUAL in `ntoskrnl`, very early, no dump written | "random / kernel incompatible" | A newer-era Windows kernel (e.g. 26200) under an older-era UEFI | Update the UEFI to the generation matching the Windows build |

Two extra notes:

- **Retrying the same boot is information-free** for `0x3B`/`0xA`-class failures — they replay
  deterministically. Change one of the three components instead.
- **UFS vendor variants (Samsung/Micron/SKHynix) are not a Windows failure class.** A Samsung
  KLUEG8UHDC unit runs Windows fully (WiFi/BT/audio/touch) on current builds with `PUS3=1`
  (2.504 V VCC). If your unit boots Linux/Android, the storage is fine — check the version
  pairing first.
