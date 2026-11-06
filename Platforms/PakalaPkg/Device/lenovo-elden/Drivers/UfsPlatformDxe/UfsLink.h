// SPDX-License-Identifier: BSD-2-Clause-Patent
#ifndef LENOVO_ELDEN_UFS_LINK_H_
#define LENOVO_ELDEN_UFS_LINK_H_
#include <Protocol/UfsHostControllerPlatform.h>

EFI_STATUS EldenUfsSaveLink(EDKII_UFS_HC_DRIVER_INTERFACE *Interface);
EFI_STATUS EldenUfsRestoreLink(EDKII_UFS_HC_DRIVER_INTERFACE *Interface);
#endif
