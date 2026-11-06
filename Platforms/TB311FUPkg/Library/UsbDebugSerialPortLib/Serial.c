// SPDX-License-Identifier: GPL-2.0-only
// Temporary DXE-core diagnostics. Single CPU, synchronous polled PIO.
#include <Base.h>
#include <Library/SerialPortLib.h>
#include "../../Drivers/UsbConsoleDxe/usb-phy.h"
static void ConsoleReceive(uint8_t C) { (VOID)C; }
RETURN_STATUS EFIAPI SerialPortInitialize(VOID) { (VOID)usb_service_stop; return RETURN_SUCCESS; }
UINTN EFIAPI SerialPortWrite(UINT8 *Buffer, UINTN Count) {
  if (!tbusb.active) {
    if (!usb_service_start()) return 0;
    for (UINTN I=0; I<1500; ++I) { tbusb_poll_locked(); usb_delay(1000); }
  }
  for (UINTN I=0; I<Count; ++I) tbusb_queue_locked(Buffer[I]);
  for (UINTN I=0; I<2+Count/32; ++I) { tbusb_poll_locked(); usb_delay(1000); }
  return Count;
}
UINTN EFIAPI SerialPortRead(UINT8 *B, UINTN N) { (VOID)B; (VOID)N; return 0; }
BOOLEAN EFIAPI SerialPortPoll(VOID) { return FALSE; }
RETURN_STATUS EFIAPI SerialPortSetControl(UINT32 C) { (VOID)C; return RETURN_UNSUPPORTED; }
RETURN_STATUS EFIAPI SerialPortGetControl(UINT32 *C) { (VOID)C; return RETURN_UNSUPPORTED; }
RETURN_STATUS EFIAPI SerialPortSetAttributes(UINT64 *B,UINT32 *F,UINT32 *T,EFI_PARITY_TYPE *P,UINT8 *D,EFI_STOP_BITS_TYPE *S) {
 (VOID)B;(VOID)F;(VOID)T;(VOID)P;(VOID)D;(VOID)S;return RETURN_UNSUPPORTED;
}
