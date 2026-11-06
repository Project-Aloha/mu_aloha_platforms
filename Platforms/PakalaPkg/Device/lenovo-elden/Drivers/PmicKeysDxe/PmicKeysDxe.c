// Lenovo Elden read-only PMIC buttons. No PON configuration or reset writes.
#include <Uefi.h>
#include <Configuration/BootDevices.h>
#include <Protocol/DevicePath.h>
#include <Protocol/SimpleTextIn.h>
#include <Protocol/SimpleTextInEx.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Library/BaseMemoryLib.h>
typedef struct ELDEN_SPMI_PROTOCOL ELDEN_SPMI_PROTOCOL;

struct ELDEN_SPMI_PROTOCOL {
  UINT64 Revision;
  UINT32(EFIAPI *Read)(
      ELDEN_SPMI_PROTOCOL *, UINT32, UINT32, UINT32, UINT32, UINT8 *, UINT32, UINT32 *);
};

typedef enum { ButtonVolumeUp, ButtonVolumeDown, ButtonPower, ButtonCount } PMIC_BUTTON;

typedef struct {
  EFI_KEY_DATA Key;
  EFI_KEY_NOTIFY_FUNCTION NotifyFunction;
} KEY_NOTIFICATION;

typedef struct {
  UINTN DebounceSamples;
  UINTN HeldSamples;
  BOOLEAN RawPressed;
  BOOLEAN Pressed;
  BOOLEAN LongPressReported;
  BOOLEAN Armed;
} BUTTON_STATE;

STATIC EFI_GUID mSpmiProtocolGuid = {
    0xfa5f306b, 0xf47d, 0x4ac4, {0xa4, 0x7d, 0x88, 0x2f, 0x82, 4, 0xec, 0x30}};
STATIC ELDEN_SPMI_PROTOCOL *mSpmiProtocol;
STATIC EFI_SIMPLE_TEXT_INPUT_PROTOCOL mTextInput;
STATIC EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL mTextInputEx;
STATIC EFI_KEY_DATA mKeyQueue[16];
STATIC UINTN mQueueHead, mQueueTail;
STATIC KEY_NOTIFICATION mKeyNotifications[16];
STATIC BUTTON_STATE mButtonStates[ButtonCount];

STATIC VOID QueueKeyStroke(UINT16 ScanCode, CHAR16 UnicodeChar)
{
  EFI_KEY_DATA KeyData;
  UINTN I, Next = (mQueueTail + 1) % 16;
  ZeroMem(&KeyData, sizeof(KeyData));
  KeyData.Key.ScanCode = ScanCode;
  KeyData.Key.UnicodeChar = UnicodeChar;
  if (Next != mQueueHead) {
    mKeyQueue[mQueueTail] = KeyData;
    mQueueTail = Next;
  }
  for (I = 0; I < 16; I++) {
    if (mKeyNotifications[I].NotifyFunction && mKeyNotifications[I].Key.Key.ScanCode == ScanCode &&
        mKeyNotifications[I].Key.Key.UnicodeChar == UnicodeChar &&
        mKeyNotifications[I].Key.KeyState.KeyShiftState == 0 &&
        mKeyNotifications[I].Key.KeyState.KeyToggleState == 0)
      mKeyNotifications[I].NotifyFunction(&KeyData);
  }
}

STATIC VOID EFIAPI PollButtons(EFI_EVENT Event, VOID *Context)
{
  UINT8 VolumeUpStatus, PonStatus;
  UINT32 BytesRead;
  UINTN I;
  BOOLEAN Pressed[ButtonCount];
  if (!mSpmiProtocol) {
    if (EFI_ERROR(gBS->LocateProtocol(&mSpmiProtocolGuid, NULL, (VOID **)&mSpmiProtocol)))
      return;
    if (mSpmiProtocol->Revision != 0x10003 || !mSpmiProtocol->Read) {
      mSpmiProtocol = NULL;
      return;
    }
  }
  BytesRead = 0;
  if (mSpmiProtocol->Read(mSpmiProtocol, 0, 1, 0, 0x8d10, &VolumeUpStatus, 1, &BytesRead) != 0 ||
      BytesRead != 1)
    goto Failed;
  BytesRead = 0;
  // Stock DT: PMK8550 SID0 pon_hlos@1300. Gen3 RT_STS bits 6/7.
  if (mSpmiProtocol->Read(mSpmiProtocol, 0, 0, 0, 0x1310, &PonStatus, 1, &BytesRead) != 0 ||
      BytesRead != 1)
    goto Failed;
  Pressed[ButtonVolumeUp] = (VolumeUpStatus & 1) == 0;
  Pressed[ButtonVolumeDown] = (PonStatus & BIT6) != 0;
  Pressed[ButtonPower] = (PonStatus & BIT7) != 0;
  for (I = 0; I < ButtonCount; I++) {
    if (Pressed[I] != mButtonStates[I].RawPressed) {
      mButtonStates[I].RawPressed = Pressed[I];
      mButtonStates[I].DebounceSamples = 0;
    }
    if (mButtonStates[I].DebounceSamples < 2)
      mButtonStates[I].DebounceSamples++;
    if (mButtonStates[I].DebounceSamples < 2)
      continue;
    if (!mButtonStates[I].Armed) {
      if (!Pressed[I])
        mButtonStates[I].Armed = TRUE;
      continue;
    }
    if (Pressed[I] != mButtonStates[I].Pressed) {
      mButtonStates[I].Pressed = Pressed[I];
      if (Pressed[I]) {
        mButtonStates[I].HeldSamples = 0;
        mButtonStates[I].LongPressReported = FALSE;
      }
      else if (!mButtonStates[I].LongPressReported) {
        QueueKeyStroke(
            I == ButtonVolumeUp     ? SCAN_UP
            : I == ButtonVolumeDown ? SCAN_DOWN
                                    : SCAN_NULL,
            I == ButtonPower ? CHAR_CARRIAGE_RETURN : 0);
      }
    }
    if (Pressed[I] && !mButtonStates[I].LongPressReported && ++mButtonStates[I].HeldSamples >= 40) {
      mButtonStates[I].LongPressReported = TRUE;
      if (I == ButtonVolumeUp)
        QueueKeyStroke(SCAN_NULL, CHAR_TAB);
      if (I == ButtonVolumeDown)
        QueueKeyStroke(SCAN_ESC, 0);
      // A long power press is reserved for the existing hardware reset mechanism.
    }
  }
  return;
Failed:
  ZeroMem(mButtonStates, sizeof(mButtonStates)); // Never turn a failed read into a key release.
}

STATIC VOID EFIAPI NotifyKeyAvailable(EFI_EVENT Event, VOID *Context)
{
  if (mQueueHead != mQueueTail)
    gBS->SignalEvent(Event);
}

STATIC EFI_STATUS EFIAPI ResetInputEx(EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL *This, BOOLEAN Verify)
{
  EFI_TPL OldTpl = gBS->RaiseTPL(TPL_CALLBACK);
  mQueueHead = mQueueTail = 0;
  gBS->RestoreTPL(OldTpl);
  return EFI_SUCCESS;
}

STATIC EFI_STATUS EFIAPI ResetInput(EFI_SIMPLE_TEXT_INPUT_PROTOCOL *This, BOOLEAN Verify)
{
  return ResetInputEx(&mTextInputEx, Verify);
}

STATIC EFI_STATUS EFIAPI ReadKeyStrokeEx(EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL *This, EFI_KEY_DATA *Key)
{
  EFI_TPL OldTpl;
  if (!Key)
    return EFI_INVALID_PARAMETER;
  OldTpl = gBS->RaiseTPL(TPL_CALLBACK);
  if (mQueueHead == mQueueTail) {
    gBS->RestoreTPL(OldTpl);
    return EFI_NOT_READY;
  }
  *Key = mKeyQueue[mQueueHead];
  mQueueHead = (mQueueHead + 1) % 16;
  gBS->RestoreTPL(OldTpl);
  return EFI_SUCCESS;
}

STATIC EFI_STATUS EFIAPI ReadKeyStroke(EFI_SIMPLE_TEXT_INPUT_PROTOCOL *This, EFI_INPUT_KEY *Key)
{
  EFI_KEY_DATA KeyData;
  EFI_STATUS Status;
  if (!Key)
    return EFI_INVALID_PARAMETER;
  Status = ReadKeyStrokeEx(&mTextInputEx, &KeyData);
  if (!EFI_ERROR(Status))
    *Key = KeyData.Key;
  return Status;
}

STATIC EFI_STATUS EFIAPI
SetToggleState(EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL *This, EFI_KEY_TOGGLE_STATE *ToggleState)
{
  return ToggleState ? EFI_UNSUPPORTED : EFI_INVALID_PARAMETER;
}

STATIC EFI_STATUS EFIAPI RegisterKeyNotify(
    EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL *This, EFI_KEY_DATA *Key,
    EFI_KEY_NOTIFY_FUNCTION NotifyFunction, VOID **Handle)
{
  UINTN I;
  EFI_TPL OldTpl;
  if (!Key || !NotifyFunction || !Handle)
    return EFI_INVALID_PARAMETER;
  OldTpl = gBS->RaiseTPL(TPL_CALLBACK);
  // Repeated registration must return the existing handle without consuming
  // another notification slot. Search before allocating, even if slots are full.
  for (I = 0; I < 16; I++) {
    if (mKeyNotifications[I].NotifyFunction == NotifyFunction &&
        mKeyNotifications[I].Key.Key.ScanCode == Key->Key.ScanCode &&
        mKeyNotifications[I].Key.Key.UnicodeChar == Key->Key.UnicodeChar &&
        mKeyNotifications[I].Key.KeyState.KeyShiftState == Key->KeyState.KeyShiftState &&
        mKeyNotifications[I].Key.KeyState.KeyToggleState == Key->KeyState.KeyToggleState) {
      *Handle = &mKeyNotifications[I];
      gBS->RestoreTPL(OldTpl);
      return EFI_SUCCESS;
    }
  }
  for (I = 0; I < 16; I++)
    if (!mKeyNotifications[I].NotifyFunction) {
      mKeyNotifications[I].Key = *Key;
      mKeyNotifications[I].NotifyFunction = NotifyFunction;
      *Handle = &mKeyNotifications[I];
      gBS->RestoreTPL(OldTpl);
      return EFI_SUCCESS;
    }
  gBS->RestoreTPL(OldTpl);
  return EFI_OUT_OF_RESOURCES;
}

STATIC EFI_STATUS EFIAPI UnregisterKeyNotify(EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL *This, VOID *Handle)
{
  UINTN I;
  EFI_TPL OldTpl = gBS->RaiseTPL(TPL_CALLBACK);
  for (I = 0; I < 16; I++)
    if (Handle == &mKeyNotifications[I] && mKeyNotifications[I].NotifyFunction) {
      mKeyNotifications[I].NotifyFunction = NULL;
      gBS->RestoreTPL(OldTpl);
      return EFI_SUCCESS;
    }
  gBS->RestoreTPL(OldTpl);
  return EFI_INVALID_PARAMETER;
}

EFI_STATUS EFIAPI EldenPmicKeysEntryPoint(EFI_HANDLE Image, EFI_SYSTEM_TABLE *SystemTable)
{
  EFI_STATUS Status;
  EFI_EVENT Timer = NULL;
  EFI_HANDLE Handle = NULL;
  mTextInput.Reset = ResetInput;
  mTextInput.ReadKeyStroke = ReadKeyStroke;
  mTextInputEx.Reset = ResetInputEx;
  mTextInputEx.ReadKeyStrokeEx = ReadKeyStrokeEx;
  mTextInputEx.SetState = SetToggleState;
  mTextInputEx.RegisterKeyNotify = RegisterKeyNotify;
  mTextInputEx.UnregisterKeyNotify = UnregisterKeyNotify;
  Status = gBS->CreateEvent(
      EVT_NOTIFY_WAIT, TPL_NOTIFY, NotifyKeyAvailable, NULL, &mTextInput.WaitForKey);
  if (EFI_ERROR(Status))
    return Status;
  Status = gBS->CreateEvent(
      EVT_NOTIFY_WAIT, TPL_NOTIFY, NotifyKeyAvailable, NULL, &mTextInputEx.WaitForKeyEx);
  if (EFI_ERROR(Status))
    goto Fail;
  Status = gBS->CreateEvent(EVT_TIMER | EVT_NOTIFY_SIGNAL, TPL_CALLBACK, PollButtons, NULL, &Timer);
  if (EFI_ERROR(Status))
    goto Fail;
  Status = gBS->SetTimer(Timer, TimerPeriodic, 200000);
  if (EFI_ERROR(Status))
    goto Fail;
  Status = gBS->InstallMultipleProtocolInterfaces(
      &Handle, &gEfiDevicePathProtocolGuid, &KeypadDevicePath, &gEfiSimpleTextInProtocolGuid,
      &mTextInput, &gEfiSimpleTextInputExProtocolGuid, &mTextInputEx, NULL);
  if (!EFI_ERROR(Status))
    return Status;
Fail:
  if (Timer)
    gBS->CloseEvent(Timer);
  if (mTextInputEx.WaitForKeyEx)
    gBS->CloseEvent(mTextInputEx.WaitForKeyEx);
  gBS->CloseEvent(mTextInput.WaitForKey);
  return Status;
}
