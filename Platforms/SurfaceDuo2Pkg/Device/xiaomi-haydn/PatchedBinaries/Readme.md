# Patched Binaries

This file describes the patches applied to UEFI DXE used by Xiaomi Haydn.

## PciHostBridgeDxe

Taken from Arcata and patched for the Haydn SM8350 PCIe0 controller, PHY,
clocks, GPIOs, memory window, ICB and IOMMU configuration.

WLAN regulators and WLAN_EN GPIO64 are enabled before PCIe initialization.

## DisplayDxe

Taken from Haydn XBL. MMU-related SID setup was patched to skip recreating
existing display MMU domains.

Panel reset and the main panel power-up callback are bypassed to reuse
the state left by the previous boot stage.

Initial PHY PLL initialization, DSI controller reset, PHY setup and LP11
setup are bypassed. Later clock configuration and normal modeset remain.

Panel selection is fixed to K11 to avoid temporary DSI initialization and
shutdown during panel detection, which caused display corruption. Normal
XML-based panel initialization, DSC setup and brightness control are retained.

The original ProjectType query is retained outside panel selection.

## CPRDxe

Taken from Haydn XBL. The core CPR initialization routine was patched to
return success without running. The preceding MMCX register mapping is retained.