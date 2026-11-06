// SPDX-License-Identifier: BSD-2-Clause-Patent
#include <PiDxe.h>
#include <Library/DxeCoreEntryPoint.h>
#include <Library/BaseLib.h>
#include <Library/SerialPortLib.h>
VOID *gHobList = NULL;
VOID EFIAPI _ModuleEntryPoint(VOID *HobStart) {
  UINT8 Text[] = "DXE: entry reached\r\n";
  gHobList=HobStart;
  SerialPortWrite(Text,sizeof(Text)-1);
  ProcessModuleEntryPointList(HobStart);
  CpuDeadLoop();
}
VOID EFIAPI EfiMain(VOID *HobStart) { _ModuleEntryPoint(HobStart); }
