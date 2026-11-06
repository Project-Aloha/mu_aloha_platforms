// SPDX-License-Identifier: GPL-2.0-only
// Early USB engine adapted from lenovo-grub (GPL-2.0-only).
#include <PiPei.h>
#include <Library/ArmLib.h>
#include <Library/ArmMmuLib.h>
#include <Library/BaseLib.h>
#include <Library/BaseMemoryLib.h>
#include <Library/CacheMaintenanceLib.h>
#include <Library/HobLib.h>
#include <Library/IoLib.h>
#include <Library/PrePiLib.h>
#include <Library/PrePiHobListPointerLib.h>
#include <libfdt.h>

#include "../Drivers/UsbConsoleDxe/usb-phy.h"
static void ConsoleReceive(uint8_t C) { (VOID)C; }
STATIC VOID EarlyLog(CONST CHAR8 *Text, UINTN WaitUs) {
  if (!tbusb.active) return;
  while (*Text) tbusb_queue_locked(*Text++);
  // Remain responsive during CDC enumeration before DXE has a timer.
  for (UINTN I=0; I<WaitUs/1000; ++I) { tbusb_poll_locked(); usb_delay(1000); }
}
#define FD_BASE 0x40090000ULL
#define FD_SIZE 0x800000ULL
#define ARENA 0x50000000ULL
#define ARENA_SIZE 0x10000000ULL
#define FB_BASE 0x7bce0000ULL
#define FB_SIZE 0x1f20000ULL
#define ATTR (EFI_RESOURCE_ATTRIBUTE_PRESENT | EFI_RESOURCE_ATTRIBUTE_INITIALIZED | EFI_RESOURCE_ATTRIBUTE_TESTED | EFI_RESOURCE_ATTRIBUTE_WRITE_BACK_CACHEABLE)
VOID EFIAPI ProcessLibraryConstructorList (VOID);
STATIC VOID Stop (VOID) { for (;;) { CpuDeadLoop (); } }
STATIC BOOLEAN Overlap (UINT64 A, UINT64 N, UINT64 B, UINT64 M) {
  return N != 0 && M != 0 && (A > MAX_UINT64-N || B > MAX_UINT64-M || (A < B+M && B < A+N));
}
STATIC UINT64 Cells64 (CONST fdt32_t *P) { return ((UINT64)fdt32_to_cpu(P[0]) << 32) | fdt32_to_cpu(P[1]); }
STATIC BOOLEAN Protected (UINT64 Base, UINT64 Size) {
  return Overlap(Base,Size,ARENA,ARENA_SIZE) || Overlap(Base,Size,FD_BASE,FD_SIZE);
}
STATIC BOOLEAN ValidateDt (CONST VOID *Dt) {
  INT32 Node, Len, Chosen, Reserved, Child, I;
  CONST fdt32_t *Reg;
  CONST VOID *Prop;
  UINT64 Base, Size;
  BOOLEAN Ram = FALSE, Framebuffer = FALSE;
  // Validate pointer before dereferencing. LK DT must be outside our writable regions.
  if ((UINTN)Dt < 0x40000000ULL || (UINTN)Dt > 0x13ff00000ULL ||
      ((UINTN)Dt & 7) != 0 || Protected((UINTN)Dt, 40) || fdt_check_header(Dt) != 0 ||
      fdt_totalsize(Dt) > 0x100000 || Protected((UINTN)Dt, fdt_totalsize(Dt)) ||
      fdt_node_check_compatible(Dt,0,"mediatek,MT6768") != 0 ||
      fdt_address_cells(Dt,0) != 2 || fdt_size_cells(Dt,0) != 2) return FALSE;
  for (Node=fdt_next_node(Dt,-1,NULL); Node>=0; Node=fdt_next_node(Dt,Node,NULL)) {}
  if (Node != -FDT_ERR_NOTFOUND || fdt_num_mem_rsv(Dt)<0) return FALSE;
  // Linux dynamic CMA nodes have not been allocated at this entry stage.
  fdt_for_each_subnode(Node,Dt,0) {
    Prop = fdt_getprop(Dt,Node,"device_type",&Len);
    if (Prop == NULL || Len != 7 || CompareMem(Prop,"memory",7) != 0) continue;
    Reg = fdt_getprop(Dt,Node,"reg",&Len);
    if (Reg == NULL || Len <= 0 || (Len % 16) != 0) return FALSE;
    for (I=0; I<Len/4; I+=4) {
      Base=Cells64(Reg+I); Size=Cells64(Reg+I+2);
      if (Base <= FD_BASE && Size <= MAX_UINT64-Base && Base+Size >= ARENA+ARENA_SIZE) Ram=TRUE;
    }
  }
  if (!Ram) return FALSE;
  Reserved=fdt_path_offset(Dt,"/reserved-memory");
  if (Reserved < 0 || fdt_address_cells(Dt,Reserved)!=2 || fdt_size_cells(Dt,Reserved)!=2) return FALSE;
  fdt_for_each_subnode(Child,Dt,Reserved) {
    Reg=fdt_getprop(Dt,Child,"reg",&Len);
    if (Reg == NULL) continue;
    if (Len<=0 || Len%16) return FALSE;
    for (I=0; I<Len/4; I+=4) {
      Base=Cells64(Reg+I); Size=Cells64(Reg+I+2);
      if (Protected(Base,Size)) return FALSE;
      if (Base==FB_BASE && Size==FB_SIZE) Framebuffer=TRUE;
    }
  }
  for (I=0; I<fdt_num_mem_rsv(Dt); ++I) {
    if (fdt_get_mem_rsv(Dt,I,&Base,&Size)!=0 || Protected(Base,Size)) return FALSE;
  }
  Chosen=fdt_path_offset(Dt,"/chosen");
  if (Chosen<0 || !Framebuffer) return FALSE;
  Reg=fdt_getprop(Dt,Chosen,"linux,initrd-start",&Len);
  if (Reg!=NULL) {
    if (Len!=4 && Len!=8) return FALSE;
    Base=Len==4 ? fdt32_to_cpu(*Reg) : Cells64(Reg);
    Reg=fdt_getprop(Dt,Chosen,"linux,initrd-end",&Len);
    if (Reg==NULL || (Len!=4 && Len!=8)) return FALSE;
    Size=Len==4 ? fdt32_to_cpu(*Reg) : Cells64(Reg);
    if (Size<Base || Protected(Base,Size-Base)) return FALSE;
  }
  return TRUE;
}
VOID EFIAPI LenovoPrePi (VOID *Dt, UINTN ImageBase) {
  ARM_MEMORY_REGION_DESCRIPTOR Map[] = {
    {0,0,0x40000000,ARM_MEMORY_REGION_ATTRIBUTE_DEVICE},
    {FD_BASE,FD_BASE,FD_SIZE,ARM_MEMORY_REGION_ATTRIBUTE_WRITE_BACK},
    {ARENA,ARENA,ARENA_SIZE,ARM_MEMORY_REGION_ATTRIBUTE_WRITE_BACK},
    {FB_BASE,FB_BASE,FB_SIZE,ARM_MEMORY_REGION_ATTRIBUTE_UNCACHED_UNBUFFERED},
    {0,0,0,0}
  };
  EFI_HOB_HANDOFF_INFO_TABLE *Hob;
  EFI_STATUS Status;
  // No arena, framebuffer, watchdog or MMU writes until this guard passes.
  if (ImageBase!=FD_BASE || !ValidateDt(Dt)) Stop();
  // Bounded standalone bring-up: reset after 30 seconds even if DXE hangs.
  // Register encoding follows the matching downstream mtk_wdt driver.
  // Preserve reset routing/polarity; select reset rather than IRQ/dual mode.
  // No writes to PMIC, RTC or boot-mode flags, and no persistent installation.
  MmioWrite32(0x10007004,(30U << 11) | 8U);
  MmioWrite32(0x10007008,0x1971);
  MmioWrite32(0x10007000,(MmioRead32(0x10007000) & ~((1U<<3)|(1U<<6))) | 0x22000001);
  usb_service_start();
  EarlyLog("TB311FU SEC: DT accepted; watchdog 30s\r\n",3000000);
  ArmEnableVFP();
  if (ArmReadCurrentEL()==AARCH64_EL2) {
    ArmWriteHcr(ARM_HCR_TGE);
    ArmWriteCntHctl(CNTHCTL_EL2_EL1PCTEN | CNTHCTL_EL2_EL1PCEN);
  }
  Hob=HobConstructor((VOID *)(UINTN)ARENA,ARENA_SIZE,(VOID *)(UINTN)ARENA,(VOID *)(UINTN)(ARENA+ARENA_SIZE-0x10000));
  PrePeiSetHobList(Hob);
  ProcessLibraryConstructorList();
  EarlyLog("SEC: HOB ready\r\n",100000);
  BuildResourceDescriptorHob(EFI_RESOURCE_SYSTEM_MEMORY,ATTR,ARENA,ARENA_SIZE);
  BuildResourceDescriptorHob(EFI_RESOURCE_MEMORY_RESERVED,ATTR,FD_BASE,FD_SIZE);
  BuildMemoryAllocationHob(FD_BASE,FD_SIZE,EfiBootServicesCode);
  BuildStackHob(ARENA+ARENA_SIZE-0x10000,0x10000);
  BuildCpuHob(ArmGetPhysicalAddressBits(),16);
  SetBootMode(BOOT_WITH_DEFAULT_SETTINGS);
  EarlyLog("SEC: enabling MMU\r\n",100000);
  Status=ArmConfigureMmu(Map,NULL,NULL);
  if (EFI_ERROR(Status)) Stop();
  EarlyLog("SEC: MMU ready\r\n",100000);
  BuildFvHob(FD_BASE+0x8000,FD_SIZE-0x8000);
  EarlyLog("SEC: decompress FV\r\n",100000);
  Status=DecompressFirstFv();
  if (EFI_ERROR(Status)) Stop();
  EarlyLog("SEC: FV ready; entering DXE\r\n",500000);
  usb_service_stop();
  // Allow the host to retire the SEC CDC device before DXE re-enumerates it.
  usb_delay(300000);
  Status=LoadDxeCoreFromFv(NULL,0x20000);
  usb_service_start();
  EarlyLog("SEC: DXE loader returned unexpectedly\r\n",1000000);
  (VOID)Status;
  Stop();
}
