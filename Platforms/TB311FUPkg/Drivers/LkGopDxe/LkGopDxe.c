// SPDX-License-Identifier: BSD-2-Clause-Patent
// Initial TB311FU GOP for the exact LK state measured by lenovo-grub/video.c.
// Requires MMIO and the framebuffer reservation mapped by the platform first.
// Never reprograms display, clocks, PHY or overlay registers.
#include <Uefi.h>
#include <Protocol/GraphicsOutput.h>
#include <Protocol/DevicePath.h>
#include <Library/BaseMemoryLib.h>
#include <Library/CacheMaintenanceLib.h>
#include <Library/IoLib.h>
#include <Library/MemoryAllocationLib.h>
#include <Library/UefiBootServicesTableLib.h>

#define WIDTH 1200U
#define HEIGHT 1920U
#define OVL 0x1400b000UL
#define FB_START 0x7bce0000UL
#define FB_END 0x7dc00000UL

STATIC UINTN mBase[2];
STATIC UINTN mPitch[2];
STATIC EFI_GRAPHICS_OUTPUT_BLT_PIXEL *mShadow;
STATIC EFI_GRAPHICS_OUTPUT_MODE_INFORMATION mInfo = {
  0, WIDTH, HEIGHT, PixelBltOnly, {0, 0, 0, 0}, WIDTH
};
STATIC EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE mMode = {
  1, 0, &mInfo, sizeof (mInfo), 0, 0
};
STATIC struct {
  VENDOR_DEVICE_PATH Vendor;
  EFI_DEVICE_PATH_PROTOCOL End;
} mPath = {
  {{HARDWARE_DEVICE_PATH, HW_VENDOR_DP, {sizeof (VENDOR_DEVICE_PATH), 0}},
   {0x1cda36ee, 0x57fc, 0x474f, {0xbf,0x43,0xea,0xb8,0x83,0x52,0xf6,0x69}}},
  {END_DEVICE_PATH_TYPE, END_ENTIRE_DEVICE_PATH_SUBTYPE,
   {sizeof (EFI_DEVICE_PATH_PROTOCOL), 0}}
};

STATIC BOOLEAN Rectangle (UINTN X, UINTN Y, UINTN W, UINTN H) {
  return X < WIDTH && Y < HEIGHT && W <= WIDTH - X && H <= HEIGHT - Y;
}

STATIC EFI_STATUS Probe (VOID) {
  UINTN I;
  if (MmioRead32 (OVL + 0x0c) != 1 ||
      MmioRead32 (OVL + 0x20) != 0x078004b0 ||
      MmioRead32 (OVL + 0x24) != 0x85000001 ||
      MmioRead32 (OVL + 0x2c) != 9 ||
      MmioRead32 (OVL + 0x1000 + 0x2c) != 0) {
    return EFI_UNSUPPORTED;
  }
  for (I = 0; I < 2; I++) {
    UINTN Offset = (I == 0 ? 0 : 3 * 0x20);
    UINTN Address, Bytes;
    if (MmioRead32 (OVL + Offset + 0x30) != 0x27ff ||
        MmioRead32 (OVL + Offset + 0x38) != 0x078004b0 ||
        MmioRead32 (OVL + Offset + 0x3c) != 0) {
      return EFI_UNSUPPORTED;
    }
    mPitch[I] = MmioRead32 (OVL + Offset + 0x44);
    if (mPitch[I] != (I == 0 ? 4864 : 4800)) {
      return EFI_UNSUPPORTED;
    }
    Address = MmioRead32 (OVL + Offset + 0xf40);
    Bytes = (HEIGHT - 1) * mPitch[I] + WIDTH * 4;
    if (Address + 1 < Bytes) {
      return EFI_UNSUPPORTED;
    }
    mBase[I] = Address + 1 - Bytes;
    if ((mBase[I] & 3) != 0 || mBase[I] < FB_START ||
        mBase[I] >= FB_END || Bytes > FB_END - mBase[I]) {
      return EFI_UNSUPPORTED;
    }
  }
  return EFI_SUCCESS;
}

STATIC VOID Present (UINTN X, UINTN Y, UINTN W, UINTN H) {
  UINTN Layer, Row, Col;
  for (Layer = 0; Layer < 2; Layer++) {
    for (Row = 0; Row < H; Row++) {
      // LK configured horizontal and vertical flip. Expose upright GOP pixels.
      UINT32 *Out = (UINT32 *)(mBase[Layer] +
        (HEIGHT - 1 - Y - Row) * mPitch[Layer]);
      for (Col = 0; Col < W; Col++) {
        EFI_GRAPHICS_OUTPUT_BLT_PIXEL *P = &mShadow[(Y + Row) * WIDTH + X + Col];
        Out[WIDTH - 1 - X - Col] = 0xff000000U |
          ((UINT32)P->Red << 16) | ((UINT32)P->Green << 8) | P->Blue;
      }
      WriteBackDataCacheRange (&Out[WIDTH - X - W], W * 4);
    }
  }
}

STATIC EFI_STATUS EFIAPI Query (
  EFI_GRAPHICS_OUTPUT_PROTOCOL *This, UINT32 ModeNumber,
  UINTN *SizeOfInfo, EFI_GRAPHICS_OUTPUT_MODE_INFORMATION **Info
  ) {
  if (This == NULL || SizeOfInfo == NULL || Info == NULL) return EFI_INVALID_PARAMETER;
  if (ModeNumber != 0) return EFI_INVALID_PARAMETER;
  *Info = AllocateCopyPool (sizeof (mInfo), &mInfo);
  if (*Info == NULL) return EFI_OUT_OF_RESOURCES;
  *SizeOfInfo = sizeof (mInfo);
  return EFI_SUCCESS;
}

STATIC EFI_STATUS EFIAPI SetMode (EFI_GRAPHICS_OUTPUT_PROTOCOL *This, UINT32 ModeNumber) {
  if (This == NULL) return EFI_INVALID_PARAMETER;
  if (ModeNumber != 0) return EFI_UNSUPPORTED;
  ZeroMem (mShadow, WIDTH * HEIGHT * sizeof (*mShadow));
  Present (0, 0, WIDTH, HEIGHT);
  return EFI_SUCCESS;
}

STATIC EFI_STATUS EFIAPI Blt (
  EFI_GRAPHICS_OUTPUT_PROTOCOL *This, EFI_GRAPHICS_OUTPUT_BLT_PIXEL *Buffer,
  EFI_GRAPHICS_OUTPUT_BLT_OPERATION Operation,
  UINTN SourceX, UINTN SourceY, UINTN DestinationX, UINTN DestinationY,
  UINTN Width, UINTN Height, UINTN Delta
  ) {
  UINTN Row, Col, Stride, BufferX, BufferY;
  EFI_TPL OldTpl;
  if (This == NULL || Width == 0 || Height == 0 ||
      (UINT32)Operation >= EfiGraphicsOutputBltOperationMax) return EFI_INVALID_PARAMETER;
  if (Operation != EfiBltVideoToVideo && Buffer == NULL) return EFI_INVALID_PARAMETER;
  if (Operation != EfiBltVideoToBltBuffer &&
      !Rectangle (DestinationX, DestinationY, Width, Height)) return EFI_INVALID_PARAMETER;
  if ((Operation == EfiBltVideoToVideo || Operation == EfiBltVideoToBltBuffer) &&
      !Rectangle (SourceX, SourceY, Width, Height)) return EFI_INVALID_PARAMETER;
  Stride = 0;
  if (Operation == EfiBltBufferToVideo || Operation == EfiBltVideoToBltBuffer) {
    BufferX = Operation == EfiBltBufferToVideo ? SourceX : DestinationX;
    BufferY = Operation == EfiBltBufferToVideo ? SourceY : DestinationY;
    if (Width > MAX_UINTN / sizeof (*Buffer)) return EFI_INVALID_PARAMETER;
    if (Delta == 0) Delta = Width * sizeof (*Buffer);
    if (Delta % sizeof (*Buffer) != 0) return EFI_INVALID_PARAMETER;
    Stride = Delta / sizeof (*Buffer);
    if (BufferX > Stride || Width > Stride - BufferX ||
        BufferY > MAX_UINTN - Height ||
        BufferY + Height > MAX_UINTN / Delta) return EFI_INVALID_PARAMETER;
  }
  OldTpl = gBS->RaiseTPL (TPL_NOTIFY);
  for (Row = 0; Row < Height; Row++) {
    UINTN R = Row;
    // Bottom-up copy preserves overlapping video rectangles, CopyMem handles X.
    if (Operation == EfiBltVideoToVideo && DestinationY > SourceY) R = Height - 1 - Row;
    switch (Operation) {
    case EfiBltVideoFill:
      for (Col = 0; Col < Width; Col++)
        mShadow[(DestinationY + R) * WIDTH + DestinationX + Col] = *Buffer;
      break;
    case EfiBltBufferToVideo:
      CopyMem (&mShadow[(DestinationY + R) * WIDTH + DestinationX],
        &Buffer[(SourceY + R) * Stride + SourceX], Width * sizeof (*Buffer));
      break;
    case EfiBltVideoToBltBuffer:
      CopyMem (&Buffer[(DestinationY + R) * Stride + DestinationX],
        &mShadow[(SourceY + R) * WIDTH + SourceX], Width * sizeof (*Buffer));
      break;
    case EfiBltVideoToVideo:
      CopyMem (&mShadow[(DestinationY + R) * WIDTH + DestinationX],
        &mShadow[(SourceY + R) * WIDTH + SourceX], Width * sizeof (*Buffer));
      break;
    default:
      break;
    }
  }
  if (Operation != EfiBltVideoToBltBuffer) Present (DestinationX, DestinationY, Width, Height);
  gBS->RestoreTPL (OldTpl);
  return EFI_SUCCESS;
}

STATIC EFI_GRAPHICS_OUTPUT_PROTOCOL mGop = {Query, SetMode, Blt, &mMode};

EFI_STATUS EFIAPI LkGopEntryPoint (EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable) {
  EFI_STATUS Status;
  EFI_HANDLE Handle = NULL;
  Status = Probe ();
  if (EFI_ERROR (Status)) return Status;
  mShadow = AllocateZeroPool (WIDTH * HEIGHT * sizeof (*mShadow));
  if (mShadow == NULL) return EFI_OUT_OF_RESOURCES;
  Status = gBS->InstallMultipleProtocolInterfaces (&Handle,
    &gEfiDevicePathProtocolGuid, &mPath,
    &gEfiGraphicsOutputProtocolGuid, &mGop, NULL);
  if (EFI_ERROR (Status)) {
    FreePool (mShadow);
  } else {
    Present (0, 0, WIDTH, HEIGHT);
  }
  return Status;
}
