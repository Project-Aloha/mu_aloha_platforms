// SPDX-License-Identifier: GPL-2.0-only
// Adapted from lenovo-grub's single-CPU polled USB console. No storage interface.
#include <Uefi.h>
#include <Protocol/SimpleTextIn.h>
#include <Protocol/SimpleTextOut.h>
#include <Protocol/DevicePath.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Library/BaseMemoryLib.h>
#include <Library/PrintLib.h>
#include "usb-phy.h"
STATIC UINT8 mInput[512];
STATIC UINTN mHead,mTail;
STATIC EFI_EVENT mTimer,mExit;
STATIC EFI_SIMPLE_TEXT_INPUT_PROTOCOL mIn;
STATIC EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL mOut;
STATIC EFI_SIMPLE_TEXT_OUTPUT_MODE mMode={1,0,EFI_LIGHTGRAY,0,0,TRUE};
STATIC VOID ConsoleReceive(UINT8 C) {
  if (mHead-mTail<sizeof(mInput)) mInput[mHead++ & (sizeof(mInput)-1)]=C;
}
STATIC VOID EFIAPI Poll(EFI_EVENT Event,VOID *Context) {
  EFI_TPL Old;
  (VOID)Event;(VOID)Context;
  Old=gBS->RaiseTPL(TPL_NOTIFY);
  tbusb_poll_locked();
  if (mHead!=mTail) gBS->SignalEvent(mIn.WaitForKey);
  gBS->RestoreTPL(Old);
}
STATIC VOID EFIAPI WaitKey(EFI_EVENT Event,VOID *Context) {
  (VOID)Event;(VOID)Context;
  Poll(NULL,NULL);
}
STATIC EFI_STATUS EFIAPI ResetIn(EFI_SIMPLE_TEXT_INPUT_PROTOCOL *This,BOOLEAN Extended) {
  EFI_TPL Old=gBS->RaiseTPL(TPL_NOTIFY);
  (VOID)This;(VOID)Extended;
  mTail=mHead;
  gBS->RestoreTPL(Old);
  return EFI_SUCCESS;
}
STATIC EFI_STATUS EFIAPI ReadKey(EFI_SIMPLE_TEXT_INPUT_PROTOCOL *This,EFI_INPUT_KEY *Key) {
  EFI_TPL Old;
  UINT8 C;
  (VOID)This;
  if (Key==NULL) return EFI_INVALID_PARAMETER;
  Poll(NULL,NULL);
  Old=gBS->RaiseTPL(TPL_NOTIFY);
  if (mHead==mTail) { gBS->RestoreTPL(Old);return EFI_NOT_READY; }
  C=mInput[mTail++ & (sizeof(mInput)-1)];
  gBS->RestoreTPL(Old);
  Key->ScanCode=C==27 ? SCAN_ESC : SCAN_NULL;
  Key->UnicodeChar=C==27 ? 0 : (C=='\n' ? '\r' : C);
  return EFI_SUCCESS;
}
// Keep output usable before timer interrupts have been validated. Bound the
// wait so an absent host cannot block boot indefinitely. Caller holds TPL_NOTIFY.
STATIC VOID Drain(VOID) {
  for (UINTN I=0; I<200; ++I) {
    tbusb_poll_locked();
    if (tbusb.head==tbusb.tail && !tbusb.bulk_zlp) break;
    usb_delay(100);
  }
}
STATIC VOID Send(CONST CHAR8 *Text) {
  EFI_TPL Old=gBS->RaiseTPL(TPL_NOTIFY);
  while (*Text) tbusb_queue_locked(*Text++);
  Drain();
  gBS->RestoreTPL(Old);
}
STATIC EFI_STATUS EFIAPI Output(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL *This,CHAR16 *Text) {
  EFI_TPL Old;
  (VOID)This;
  if (Text==NULL) return EFI_INVALID_PARAMETER;
  Old=gBS->RaiseTPL(TPL_NOTIFY);
  while (*Text) {
    CHAR16 C=*Text++;
    tbusb_queue_locked(C<=127 ? (CHAR8)C : '?');
    if(C=='\r') mMode.CursorColumn=0;
    else if(C=='\n') { if(mMode.CursorRow<39) mMode.CursorRow++; }
    else if(C=='\b') { if(mMode.CursorColumn>0) mMode.CursorColumn--; }
    else if(++mMode.CursorColumn>=80) {mMode.CursorColumn=0;if(mMode.CursorRow<39)mMode.CursorRow++;}
  }
  Drain();
  gBS->RestoreTPL(Old);
  return EFI_SUCCESS;
}
STATIC EFI_STATUS EFIAPI Test(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL *This,CHAR16 *Text) {
  (VOID)This;
  if(Text==NULL)return EFI_INVALID_PARAMETER;
  while(*Text)if(*Text++>127)return EFI_UNSUPPORTED;
  return EFI_SUCCESS;
}
STATIC EFI_STATUS EFIAPI Query(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL *This,UINTN Mode,UINTN *Columns,UINTN *Rows) {
  (VOID)This;
  if(Mode!=0)return EFI_UNSUPPORTED;
  if(Columns==NULL || Rows==NULL)return EFI_INVALID_PARAMETER;
  *Columns=80;*Rows=40;return EFI_SUCCESS;
}
STATIC EFI_STATUS EFIAPI Clear(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL *This) {
  (VOID)This;Send("\x1b[2J\x1b[H");mMode.CursorColumn=mMode.CursorRow=0;return EFI_SUCCESS;
}
STATIC EFI_STATUS EFIAPI SetMode(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL *This,UINTN Mode) {
  if(Mode!=0)return EFI_UNSUPPORTED;
  return Clear(This);
}
STATIC EFI_STATUS EFIAPI Attribute(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL *This,UINTN Value) {
  (VOID)This;
  if(Value>0x7f)return EFI_UNSUPPORTED;
  mMode.Attribute=(INT32)Value;return EFI_SUCCESS;
}
STATIC EFI_STATUS EFIAPI Cursor(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL *This,UINTN Column,UINTN Row) {
  CHAR8 Buffer[32];(VOID)This;
  if(Column>=80 || Row>=40)return EFI_UNSUPPORTED;
  AsciiSPrint(Buffer,sizeof(Buffer),"\x1b[%u;%uH",(UINT32)Row+1,(UINT32)Column+1);Send(Buffer);
  mMode.CursorColumn=(INT32)Column;mMode.CursorRow=(INT32)Row;return EFI_SUCCESS;
}
STATIC EFI_STATUS EFIAPI Enable(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL *This,BOOLEAN Visible) {
  (VOID)This;Send(Visible ? "\x1b[?25h" : "\x1b[?25l");mMode.CursorVisible=Visible;return EFI_SUCCESS;
}
STATIC EFI_STATUS EFIAPI ResetOut(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL *This,BOOLEAN Extended) {
  (VOID)Extended;return Clear(This);
}
STATIC EFI_SIMPLE_TEXT_INPUT_PROTOCOL mIn={ResetIn,ReadKey,NULL};
STATIC EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL mOut={ResetOut,Output,Test,Query,SetMode,Attribute,Clear,Cursor,Enable,&mMode};
STATIC struct { VENDOR_DEVICE_PATH Vendor;EFI_DEVICE_PATH_PROTOCOL End; } mPath={
 {{HARDWARE_DEVICE_PATH,HW_VENDOR_DP,{sizeof(VENDOR_DEVICE_PATH),0}},
 {0x762bad54,0x26d6,0x42d7,{0x8d,0x79,0xc3,0xa7,0xc8,0x46,0x59,0x1f}}},
 {END_DEVICE_PATH_TYPE,END_ENTIRE_DEVICE_PATH_SUBTYPE,{sizeof(EFI_DEVICE_PATH_PROTOCOL),0}}
};
STATIC VOID EFIAPI Exit(EFI_EVENT Event,VOID *Context) {
  (VOID)Event;(VOID)Context;
  gBS->SetTimer(mTimer,TimerCancel,0);
  usb_service_stop();
}
STATIC VOID Stage(CONST CHAR8 *Text, UINTN Milliseconds) {
  EFI_TPL Old=gBS->RaiseTPL(TPL_NOTIFY);
  while (*Text) tbusb_queue_locked(*Text++);
  for (UINTN I=0; I<Milliseconds; ++I) { tbusb_poll_locked(); usb_delay(1000); }
  gBS->RestoreTPL(Old);
}
EFI_STATUS EFIAPI UsbEntry(EFI_HANDLE Image,EFI_SYSTEM_TABLE *SystemTable) {
  EFI_STATUS Status;EFI_HANDLE Handle=NULL;
  (VOID)Image;(VOID)SystemTable;
  if(!usb_service_start())return EFI_UNSUPPORTED;
  Stage("DXE USB: controller ready\r\n",2000);
  Status=gBS->CreateEvent(EVT_NOTIFY_WAIT,TPL_CALLBACK,WaitKey,NULL,&mIn.WaitForKey);
  if(EFI_ERROR(Status))goto Fail;
  Status=gBS->CreateEvent(EVT_TIMER|EVT_NOTIFY_SIGNAL,TPL_CALLBACK,Poll,NULL,&mTimer);
  if(EFI_ERROR(Status))goto Fail;
  Status=gBS->CreateEvent(EVT_SIGNAL_EXIT_BOOT_SERVICES,TPL_NOTIFY,Exit,NULL,&mExit);
  if(EFI_ERROR(Status))goto Fail;
  Stage("DXE USB: events ready; starting timer\r\n",100);
  Status=gBS->SetTimer(mTimer,TimerPeriodic,10000);
  if(EFI_ERROR(Status))goto Fail;
  Stage("DXE USB: timer ready; installing console\r\n",100);
  Status=gBS->InstallMultipleProtocolInterfaces(&Handle,&gEfiSimpleTextInProtocolGuid,&mIn,
    &gEfiSimpleTextOutProtocolGuid,&mOut,&gEfiDevicePathProtocolGuid,&mPath,NULL);
  if(!EFI_ERROR(Status)){Stage("DXE USB: console installed\r\n",100);return Status;}
Fail:
  Stage("DXE USB: initialization failed\r\n",100);
  if(mTimer!=NULL){gBS->SetTimer(mTimer,TimerCancel,0);gBS->CloseEvent(mTimer);}
  if(mExit!=NULL)gBS->CloseEvent(mExit);
  if(mIn.WaitForKey!=NULL)gBS->CloseEvent(mIn.WaitForKey);
  usb_service_stop();return Status;
}
