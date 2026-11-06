// SPDX-License-Identifier: BSD-2-Clause
// Inherited-state MSDC0 PIO adapted from lenovo-grub/src/storage.h.
// Original algorithm: freeBSD-tablet/port/tb311fu_msdc.c (BSD-2-Clause).
#include <Uefi.h>
#include <Protocol/BlockIo.h>
#include <Protocol/DevicePath.h>
#include <Library/IoLib.h>
#include <Library/BaseMemoryLib.h>
#include <Library/UefiBootServicesTableLib.h>
#include <stdint.h>
#define SD_BASE 0x11230000UL
#define SD_EVENTS 0x0000d700U
#define SD_ERRORS 0xfff9a080U
struct storage_state {
 unsigned failed;
 uint32_t r1;
 uint8_t sector[512];
};
static struct storage_state sd __attribute__((section(".data")))={0};
static uint32_t sd_le32(const uint8_t *p) {
 return (uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);
}
static uint64_t sd_now(void) {uint64_t n;__asm__ volatile("mrs %0,cntpct_el0":"=r"(n));return n;}
static uint64_t sd_hz(void) {uint64_t n;__asm__ volatile("mrs %0,cntfrq_el0":"=r"(n));return n;}
static uint32_t sd_read(unsigned r){return MmioRead32(SD_BASE+r);}
static void sd_write(unsigned r,uint32_t v){MmioWrite32(SD_BASE+r,v);}
static int sd_clear(unsigned reg,uint32_t mask) {
 uint64_t start=sd_now(),hz=sd_hz();
 for(unsigned i=0;i<100000;i++) {
  if(!(sd_read(reg)&mask))return 1;
  if(sd_now()-start>hz/10)break;
 }return 0;
}
static int sd_command(unsigned opcode,uint32_t arg,uint8_t *data) {
 if(sd.failed || (opcode!=13 && opcode!=8 && opcode!=17))return 0;
 if((opcode==13)!=(data==0))return 0;
 if(!sd_clear(0x3c,3))goto fail;
 if(data){sd_write(0x14,1U<<31);if(!sd_clear(0x14,1U<<31))goto fail;sd_write(0x50,1);}
 sd_write(0x0c,SD_EVENTS);
 uint32_t cmd=opcode|(1U<<7);
 if(data)cmd|=(1U<<11)|(512U<<16);
 sd_write(0x38,arg);sd_write(0x34,cmd);
 uint64_t start=sd_now(),hz=sd_hz();unsigned done=0,events=0;
 for(unsigned loops=0;loops<1000000;loops++) {
  uint32_t flags=sd_read(0x0c)&SD_EVENTS;events|=flags;if(flags)sd_write(0x0c,flags);
  if(events&0xc600)goto fail;
  if(events&0x100){sd.r1=sd_read(0x40);if(sd.r1&SD_ERRORS)goto fail;if(!data)return 1;}
  if(data) {
   while(done<512 && (sd_read(0x14)&255)>=4) {
    uint32_t w=sd_read(0x1c);for(unsigned j=0;j<4;j++)data[done++]=(uint8_t)(w>>(j*8));
   }
  }
  if((events&0x1100)==0x1100 && done==512)return 1;
  if(sd_now()-start>hz)break;
 }
fail:sd.failed=1;return 0;
}

STATIC UINT32 mSavedCfg, mSavedInten;
STATIC EFI_EVENT mExitEvent;
STATIC VOID EFIAPI RestoreController (EFI_EVENT Event, VOID *Context) {
  (VOID)Event; (VOID)Context;
  sd_write(0,mSavedCfg);
  sd_write(0x10,mSavedInten);
}
STATIC EFI_STATUS EFIAPI Reset (EFI_BLOCK_IO_PROTOCOL *This, BOOLEAN Extended) {
  (VOID)This; (VOID)Extended;
  return sd.failed ? EFI_DEVICE_ERROR : EFI_SUCCESS;
}
STATIC EFI_STATUS EFIAPI ReadBlocks (EFI_BLOCK_IO_PROTOCOL *This, UINT32 MediaId,
  EFI_LBA Lba, UINTN Size, VOID *Buffer) {
  UINTN Blocks, Index;
  if (MediaId != This->Media->MediaId) return EFI_MEDIA_CHANGED;
  if (Size == 0) return EFI_SUCCESS;
  if (Buffer == NULL) return EFI_INVALID_PARAMETER;
  if (Size % 512 != 0) return EFI_BAD_BUFFER_SIZE;
  Blocks=Size/512;
  if (Lba > This->Media->LastBlock || Blocks-1 > This->Media->LastBlock-Lba)
    return EFI_INVALID_PARAMETER;
  for (Index=0; Index<Blocks; ++Index)
    if (!sd_command(17,(UINT32)(Lba+Index),(UINT8 *)Buffer+Index*512))
      return EFI_DEVICE_ERROR;
  return EFI_SUCCESS;
}
STATIC EFI_STATUS EFIAPI WriteBlocks (EFI_BLOCK_IO_PROTOCOL *This, UINT32 MediaId,
  EFI_LBA Lba, UINTN Size, VOID *Buffer) {
  (VOID)This; (VOID)MediaId; (VOID)Lba; (VOID)Size; (VOID)Buffer;
  return EFI_WRITE_PROTECTED;
}
STATIC EFI_STATUS EFIAPI FlushBlocks (EFI_BLOCK_IO_PROTOCOL *This) {
  (VOID)This;
  return EFI_SUCCESS;
}
STATIC EFI_BLOCK_IO_MEDIA mMedia = {
  .MediaId=1, .MediaPresent=TRUE, .ReadOnly=TRUE, .BlockSize=512
};
STATIC EFI_BLOCK_IO_PROTOCOL mBlock = {
  EFI_BLOCK_IO_PROTOCOL_REVISION, &mMedia, Reset, ReadBlocks, WriteBlocks, FlushBlocks
};
STATIC struct {
  VENDOR_DEVICE_PATH Vendor;
  EFI_DEVICE_PATH_PROTOCOL End;
} mPath = {
  {{HARDWARE_DEVICE_PATH,HW_VENDOR_DP,{sizeof(VENDOR_DEVICE_PATH),0}},
   {0xec0e5f6a,0xdc99,0x41bc,{0x90,0x7a,0x75,0x37,0x89,0x8b,0xa1,0x21}}},
  {END_DEVICE_PATH_TYPE,END_ENTIRE_DEVICE_PATH_SUBTYPE,{sizeof(EFI_DEVICE_PATH_PROTOCOL),0}}
};
EFI_STATUS EFIAPI MsdcEntry (EFI_HANDLE Image, EFI_SYSTEM_TABLE *SystemTable) {
  EFI_STATUS Status;
  EFI_HANDLE Handle=NULL;
  UINT32 Sectors;
  (VOID)Image; (VOID)SystemTable;
  // Require the LK-initialized clock, controller and transfer state.
  if ((MmioRead32(0x10001094UL)&4) || (MmioRead32(0x100010c8UL)&(1U<<9)))
    return EFI_NOT_READY;
  mSavedCfg=sd_read(0);
  if (!(mSavedCfg&1) || !(mSavedCfg&(1U<<7)) || (sd_read(0x9c)&1))
    return EFI_NOT_READY;
  mSavedInten=sd_read(0x10);
  sd_write(0x10,0); sd_write(0,mSavedCfg|8);
  if (!sd_command(13,1U<<16,NULL) || (sd.r1&0x1f00)!=0x900 ||
      !sd_command(8,0,sd.sector)) goto Fail;
  Sectors=sd_le32(sd.sector+212);
  // Expose only 512-byte user-area sectors, with command queuing disabled.
  if (!Sectors || (sd.sector[179]&7) || (sd.sector[15]&1) || sd.sector[61])
    goto Fail;
  mMedia.LastBlock=(EFI_LBA)Sectors-1;
  Status=gBS->CreateEvent(EVT_SIGNAL_EXIT_BOOT_SERVICES,TPL_NOTIFY,
    RestoreController,NULL,&mExitEvent);
  if (EFI_ERROR(Status)) { RestoreController(NULL,NULL); return Status; }
  Status=gBS->InstallMultipleProtocolInterfaces(&Handle,
    &gEfiDevicePathProtocolGuid,&mPath,&gEfiBlockIoProtocolGuid,&mBlock,NULL);
  if (EFI_ERROR(Status)) {
    gBS->CloseEvent(mExitEvent); RestoreController(NULL,NULL);
  }
  return Status;
Fail:
  RestoreController(NULL,NULL);
  return EFI_DEVICE_ERROR;
}
