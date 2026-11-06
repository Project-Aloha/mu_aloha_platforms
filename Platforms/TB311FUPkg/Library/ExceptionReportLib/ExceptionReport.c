// SPDX-License-Identifier: BSD-2-Clause-Patent
#include <Uefi.h>
#include <Library/BaseLib.h>
#include <Library/PrintLib.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Guid/DebugImageInfoTable.h>
#include <Protocol/DebugSupport.h>
#include <Protocol/LoadedImage.h>
STATIC BOOLEAN mReporting;
STATIC VOID Report(CONST CHAR16 *Label,UINT64 A,UINT64 B) {
  CHAR16 Line[120];
  UnicodeSPrint(Line,sizeof(Line),L"%s %016lx %016lx\r\n",Label,A,B);
  if(gST->ConOut!=NULL)gST->ConOut->OutputString(gST->ConOut,Line);
}
VOID DefaultExceptionHandler(EFI_EXCEPTION_TYPE Type,EFI_SYSTEM_CONTEXT Context) {
  EFI_SYSTEM_CONTEXT_AARCH64 *C=Context.SystemContextAArch64;
  if(mReporting)CpuDeadLoop();
  mReporting=TRUE;
  Report(L"EXCEPTION / PC",Type,C->ELR);
  Report(L"LR / ESR",C->LR,C->ESR);
  Report(L"FAR / SP",C->FAR,C->SP);
  Report(L"X0 / X1",C->X0,C->X1);
  Report(L"X2 / X3",C->X2,C->X3);
  // Locate the caller without dereferencing a potentially corrupt frame chain.
  for(UINTN I=0;I<gST->NumberOfTableEntries;++I) {
    EFI_GUID *G=&gST->ConfigurationTable[I].VendorGuid;
    if(G->Data1!=gEfiDebugImageInfoTableGuid.Data1)continue;
    EFI_DEBUG_IMAGE_INFO_TABLE_HEADER *H=gST->ConfigurationTable[I].VendorTable;
    for(UINTN J=0;J<H->TableSize;++J) {
      EFI_DEBUG_IMAGE_INFO_NORMAL *N=H->EfiDebugImageInfoTable[J].NormalImage;
      if(N==NULL || N->ImageInfoType!=EFI_DEBUG_IMAGE_INFO_TYPE_NORMAL || N->LoadedImageProtocolInstance==NULL)continue;
      EFI_LOADED_IMAGE_PROTOCOL *L=N->LoadedImageProtocolInstance;
      UINTN Base=(UINTN)L->ImageBase;
      if(C->LR>=Base && C->LR<Base+L->ImageSize)Report(L"CALLER BASE / OFFSET",Base,C->LR-Base);
    }
  }
  CpuDeadLoop();
}
