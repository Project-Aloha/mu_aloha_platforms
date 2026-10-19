# Patched Binaries

This file describes the patched PCIe DXE used by Xiaomi Haydn.

## PciHostBridgeDxe

Based on the Arcata PCI HostBridge DXE and patched for the Haydn SM8350 PCIe0
controller, PHY, clocks, GPIOs, memory window, ICB and IOMMU configuration.

It also enables the required WLAN regulators and configures WLAN_EN GPIO64
before initializing PCIe.

The driver passes local PE, relocation and firmware packaging checks. PCIe and
the WLAN endpoint enumerate in UEFI, while Windows handoff and Wi-Fi operation
still require device testing.