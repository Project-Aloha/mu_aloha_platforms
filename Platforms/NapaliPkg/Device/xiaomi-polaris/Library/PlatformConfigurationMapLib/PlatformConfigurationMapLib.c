#include <Library/BaseLib.h>
#include <Library/PlatformConfigurationMapLib.h>

static CONFIGURATION_DESCRIPTOR_EX gDeviceConfigurationDescriptorEx[] = {
    {"ConfigParameterCount", 60},
    {"NumCpusFuseAddr", 0x5C04C},
    {"EnableShell", 0x1},
    {"SharedIMEMBaseAddr   ", 0x146BF000},
    {"DloadCookieAddr", 0x01FD3000},
    {"DloadCookieValue", 0x10},
    {"NumCpus", 8},
    {"NumActiveCores", 8},
    {"UefiMemUseThreshold", 0x9D},
    {"USBHS1_Config", 0x0},
    {"UsbFnIoRevNum", 0x00010001},
    {"PwrBtnShutdownFlag", 0x0},
    {"Sdc1GpioConfigOn", 0x1E92},
    {"Sdc2GpioConfigOn", 0x1E92},
    {"Sdc1GpioConfigOff", 0xA00},
    {"Sdc2GpioConfigOff", 0xA00},
    {"EnableSDHCSwitch", 0x1},
    {"TzAppsRegnAddr", 0x86D00000},
    {"TzAppsRegnSize", 0x02200000},
    {"ImageFVFlashed   ", 0x0},
    {"EnableLogFsSyncInRetail", 0x0},
    {"EnableUefiSecAppDebugLogDump", 0x0},
    {"DumpUefiSecAppLogsToLogFs", 0x1},
    {"MemoryCaptureModeOffset", 0x1C},
    {"AbnormalResetOccurredOffset", 0x24},
    {"MaxLogFileSize", 0x800000},
    {"PSHoldOffset", 0xC000},
    {"PSHoldSHFT", 0x0},
    {"TzDiagOffset", 0x720},
    {"TzDiagSize", 0x2000},
    {"SecurityFlag", 0x47F},
    {"GccCe1ClkCntlReg", 0x00152004},
    {"GccCe1ClkCntlVal", 0x00000038},
    {"DetectRetailUserAttentionHotkey", 0x00},
    {"DetectRetailUserAttentionHotkeyCode", 0x17},
    {"EnableOEMSetupAppInRetail", 0x0},
    {"EnablePXE", 0x0},
    {"EnableACPIFallback", 0x0},
    {"ShmBridgememSize", 0xA00000},

    /* Terminator */
    {"Terminator", 0xFFFFFFFF}};

CONFIGURATION_DESCRIPTOR_EX *GetPlatformConfigurationMap()
{
  return gDeviceConfigurationDescriptorEx;
}
