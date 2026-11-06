// SPDX-License-Identifier: BSD-2-Clause-Patent
// Integer configuration used by the retained vendor services and protocol finder.
// Values originate from xbl_config FDT /soc/uefi/int_param, with policy below.
#include <Library/PlatformConfigurationMapLib.h>

STATIC CONFIGURATION_DESCRIPTOR_EX mConfiguration[] = {
  // ULog allocates its log buffer using this limit.
  { "MaxLogFileSize", 0x400000 },
  // Do not persist vendor logs to the Android logfs partition.
  { "EnableLogFsSyncInRetail", 0x0 },
  // Keep PrePi on the current CPU without starting the stock scheduler.
  { "EnableMultiThreading", 0x0 },
  // EnvDxe must not register the stock DDR information notification flow.
  { "DDRInfoNotifyFlag", 0x0 },
  { "Terminator", 0xFFFFFFFF }
};

CONFIGURATION_DESCRIPTOR_EX *GetPlatformConfigurationMap (VOID)
{
  return mConfiguration;
}
