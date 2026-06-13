/*
 * Copyright (C) 2016 The Android Open Source Project
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/* Copyright (c) 2017,2019, The Linux Foundation. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 * * Redistributions of source code must retain the above copyright
 *  notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above
 * copyright notice, this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided
 *  with the distribution.
 *   * Neither the name of The Linux Foundation nor the names of its
 * contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
#include "BootLinux.h"
#include "avb_util.h"
#include "avb_ops.h"
#include <stdarg.h>
#include <Protocol/EFIScm.h>
#include <Protocol/scm_sip_interface.h>
#include "PartitionTableUpdate.h"

#define SECBOOT_FUSE 0
#define SHK_FUSE 1
#define DEBUG_DISABLED_FUSE 2
#define ANTI_ROLLBACK_FUSE 3
#define FEC_ENABLED_FUSE 4
#define RPMB_ENABLED_FUSE 5
#define DEBUG_RE_ENABLED_FUSE 6
#define CHECK_BIT(var, pos) ((var) & (1 << (pos)))
#define TZ_FVER_QSEE 10

uint32_t avb_be32toh(uint32_t in) {
  uint8_t* d = (uint8_t*)&in;
  uint32_t ret;
  ret = ((uint32_t)d[0]) << 24;
  ret |= ((uint32_t)d[1]) << 16;
  ret |= ((uint32_t)d[2]) << 8;
  ret |= ((uint32_t)d[3]);
  return ret;
}

uint64_t avb_be64toh(uint64_t in) {
  uint8_t* d = (uint8_t*)&in;
  uint64_t ret;
  ret = ((uint64_t)d[0]) << 56;
  ret |= ((uint64_t)d[1]) << 48;
  ret |= ((uint64_t)d[2]) << 40;
  ret |= ((uint64_t)d[3]) << 32;
  ret |= ((uint64_t)d[4]) << 24;
  ret |= ((uint64_t)d[5]) << 16;
  ret |= ((uint64_t)d[6]) << 8;
  ret |= ((uint64_t)d[7]);
  return ret;
}

/* Converts a 32-bit unsigned integer from host to big-endian byte order. */
uint32_t avb_htobe32(uint32_t in) {
  union {
    uint32_t word;
    uint8_t bytes[4];
  } ret;
  ret.bytes[0] = (in >> 24) & 0xff;
  ret.bytes[1] = (in >> 16) & 0xff;
  ret.bytes[2] = (in >> 8) & 0xff;
  ret.bytes[3] = in & 0xff;
  return ret.word;
}

/* Converts a 64-bit unsigned integer from host to big-endian byte order. */
uint64_t avb_htobe64(uint64_t in) {
  union {
    uint64_t word;
    uint8_t bytes[8];
  } ret;
  ret.bytes[0] = (in >> 56) & 0xff;
  ret.bytes[1] = (in >> 48) & 0xff;
  ret.bytes[2] = (in >> 40) & 0xff;
  ret.bytes[3] = (in >> 32) & 0xff;
  ret.bytes[4] = (in >> 24) & 0xff;
  ret.bytes[5] = (in >> 16) & 0xff;
  ret.bytes[6] = (in >> 8) & 0xff;
  ret.bytes[7] = in & 0xff;
  return ret.word;
}

int avb_safe_memcmp(const void* s1, const void* s2, size_t n) {
  const unsigned char* us1 = s1;
  const unsigned char* us2 = s2;
  int result = 0;

  if (0 == n) {
    return 0;
  }

  /*
   * Code snippet without data-dependent branch due to Nate Lawson
   * (nate@root.org) of Root Labs.
   */
  while (n--) {
    result |= *us1++ ^ *us2++;
  }

  return result != 0;
}

bool avb_safe_add_to(uint64_t* value, uint64_t value_to_add) {
  uint64_t original_value;

  avb_assert(value != NULL);

  original_value = *value;

  *value += value_to_add;
  if (*value < original_value) {
    avb_error("Overflow when adding values.\n");
    return false;
  }

  return true;
}

bool avb_safe_add(uint64_t* out_result, uint64_t a, uint64_t b) {
  uint64_t dummy;
  if (out_result == NULL) {
    out_result = &dummy;
  }
  *out_result = a;
  return avb_safe_add_to(out_result, b);
}

bool avb_validate_utf8(const uint8_t* data, size_t num_bytes) {
  size_t n;
  unsigned int num_cc;

  for (n = 0, num_cc = 0; n < num_bytes; n++) {
    uint8_t c = data[n];

    if (num_cc > 0) {
      if ((c & (0x80 | 0x40)) == 0x80) {
        /* 10xx xxxx */
      } else {
        goto fail;
      }
      num_cc--;
    } else {
      if (c < 0x80) {
        num_cc = 0;
      } else if ((c & (0x80 | 0x40 | 0x20)) == (0x80 | 0x40)) {
        /* 110x xxxx */
        num_cc = 1;
      } else if ((c & (0x80 | 0x40 | 0x20 | 0x10)) == (0x80 | 0x40 | 0x20)) {
        /* 1110 xxxx */
        num_cc = 2;
      } else if ((c & (0x80 | 0x40 | 0x20 | 0x10 | 0x08)) ==
                 (0x80 | 0x40 | 0x20 | 0x10)) {
        /* 1111 0xxx */
        num_cc = 3;
      } else {
        goto fail;
      }
    }
  }

  if (num_cc != 0) {
    goto fail;
  }

  return true;

fail:
  return false;
}

bool avb_str_concat(char* buf,
                    size_t buf_size,
                    const char* str1,
                    size_t str1_len,
                    const char* str2,
                    size_t str2_len) {
  uint64_t combined_len;

  if (!avb_safe_add(&combined_len, str1_len, str2_len)) {
    avb_error("Overflow when adding string sizes.\n");
    return false;
  }

  if (combined_len > buf_size - 1) {
    avb_error("Insufficient buffer space.\n");
    return false;
  }

  avb_memcpy(buf, str1, str1_len);
  avb_memcpy(buf + str1_len, str2, str2_len);
  buf[combined_len] = '\0';

  return true;
}

void* avb_malloc(size_t size) {
  void* ret = avb_malloc_(size);
  if (ret == NULL) {
    avb_error("Failed to allocate memory.\n");
    return NULL;
  }
  return ret;
}

void* avb_calloc(size_t size) {
  void* ret = avb_malloc(size);
  if (ret == NULL) {
    return NULL;
  }

  avb_memset(ret, '\0', size);
  return ret;
}

char* avb_strdup(const char* str) {
  size_t len = avb_strlen(str);
  char* ret = avb_malloc(len + 1);
  if (ret == NULL) {
    return NULL;
  }

  avb_memcpy(ret, str, len);
  ret[len] = '\0';

  return ret;
}

const char* avb_strstr(const char* haystack, const char* needle) {
  size_t n, m;

  /* Look through |haystack| and check if the first character of
   * |needle| matches. If so, check the rest of |needle|.
   */
  for (n = 0; haystack[n] != '\0'; n++) {
    if (haystack[n] != needle[0]) {
      continue;
    }

    for (m = 1;; m++) {
      if (needle[m] == '\0') {
        return haystack + n;
      }

      if (haystack[n + m] != needle[m]) {
        break;
      }
    }
  }

  return NULL;
}

const char* avb_strv_find_str(const char* const* strings,
                              const char* str,
                              size_t str_size) {
  size_t n;
  for (n = 0; strings[n] != NULL; n++) {
    if (avb_strlen(strings[n]) == str_size &&
        avb_memcmp(strings[n], str, str_size) == 0) {
      return strings[n];
    }
  }
  return NULL;
}

char* avb_replace(const char* str, const char* search, const char* replace) {
  char* ret = NULL;
  size_t ret_len = 0;
  size_t search_len, replace_len;
  const char* str_after_last_replace;

  search_len = avb_strlen(search);
  replace_len = avb_strlen(replace);

  str_after_last_replace = str;
  while (*str != '\0') {
    const char* s;
    size_t num_before;
    size_t num_new;

    s = avb_strstr(str, search);
    if (s == NULL) {
      break;
    }

    num_before = s - str;

    if (ret == NULL) {
      num_new = num_before + replace_len + 1;
      ret = avb_malloc(num_new);
      if (ret == NULL) {
        goto out;
      }
      avb_memcpy(ret, str, num_before);
      avb_memcpy(ret + num_before, replace, replace_len);
      ret[num_new - 1] = '\0';
      ret_len = num_new - 1;
    } else {
      char* new_str;
      num_new = ret_len + num_before + replace_len + 1;
      new_str = avb_malloc(num_new);
      if (new_str == NULL) {
        goto out;
      }
      avb_memcpy(new_str, ret, ret_len);
      avb_memcpy(new_str + ret_len, str, num_before);
      avb_memcpy(new_str + ret_len + num_before, replace, replace_len);
      new_str[num_new - 1] = '\0';
      avb_free(ret);
      ret = new_str;
      ret_len = num_new - 1;
    }

    str = s + search_len;
    str_after_last_replace = str;
  }

  if (ret == NULL) {
    ret = avb_strdup(str_after_last_replace);
    if (ret == NULL) {
      goto out;
    }
  } else {
    size_t num_remaining = avb_strlen(str_after_last_replace);
    size_t num_new = ret_len + num_remaining + 1;
    char* new_str = avb_malloc(num_new);
    if (new_str == NULL) {
      goto out;
    }
    avb_memcpy(new_str, ret, ret_len);
    avb_memcpy(new_str + ret_len, str_after_last_replace, num_remaining);
    new_str[num_new - 1] = '\0';
    avb_free(ret);
    ret = new_str;
  }

out:
  return ret;
}

/* We only support a limited amount of strings in avb_strdupv(). */
#define AVB_STRDUPV_MAX_NUM_STRINGS 32

char* avb_strdupv(const char* str, ...) {
  va_list ap;
  const char* strings[AVB_STRDUPV_MAX_NUM_STRINGS];
  size_t lengths[AVB_STRDUPV_MAX_NUM_STRINGS];
  size_t num_strings, n;
  uint64_t total_length;
  char *ret = NULL, *dest;

  num_strings = 0;
  total_length = 0;
  va_start(ap, str);
  do {
    size_t str_len = avb_strlen(str);
    strings[num_strings] = str;
    lengths[num_strings] = str_len;
    if (!avb_safe_add_to(&total_length, str_len)) {
      avb_fatal("Overflow while determining total length.\n");
      break;
    }
    num_strings++;
    if (num_strings == AVB_STRDUPV_MAX_NUM_STRINGS) {
      avb_fatal("Too many strings passed.\n");
      break;
    }
    str = va_arg(ap, const char*);
  } while (str != NULL);
  va_end(ap);

  ret = avb_malloc(total_length + 1);
  if (ret == NULL) {
    goto out;
  }

  dest = ret;
  for (n = 0; n < num_strings; n++) {
    avb_memcpy(dest, strings[n], lengths[n]);
    dest += lengths[n];
  }
  *dest = '\0';
  avb_assert(dest == ret + total_length);

out:
  return ret;
}

const char* avb_basename(const char* str) {
  int64_t n;
  size_t len;

  len = avb_strlen(str);
  if (len >= 2) {
    for (n = len - 2; n >= 0; n--) {
      if (str[n] == '/') {
        return str + n + 1;
      }
    }
  }
  return str;
}

/**
  Read security state.
  @retval  Status  Secure state or error code in case of failure.
**/
UINT32 ReadSecurityState ()
{
  EFI_STATUS Status = EFI_SUCCESS;
  QCOM_SCM_PROTOCOL *pQcomScmProtocol = NULL;
  UINT64 Parameters[SCM_MAX_NUM_PARAMETERS] = {0};
  UINT64 Results[SCM_MAX_NUM_RESULTS] = {0};
  tz_get_secure_state_rsp_t *SysCallRsp = (tz_get_secure_state_rsp_t *)Results;
  UINT32 SecurityStateReturn = 0x0;

  // Locate QCOM_SCM_PROTOCOL.
  Status = gBS->LocateProtocol (&gQcomScmProtocolGuid, NULL,
                               (VOID **)&pQcomScmProtocol);
  if (Status != EFI_SUCCESS ||
     (pQcomScmProtocol == NULL)) {
    DEBUG ((EFI_D_ERROR, "ReadSecurityState: Locate SCM Status: (0x%x)\r\n",
           Status));
    Status = ERROR_SECURITY_STATE;
    return Status;
  }
  // Make ScmSipSysCall
  Status = pQcomScmProtocol->ScmSipSysCall (
      pQcomScmProtocol, TZ_INFO_GET_SECURE_STATE,
      TZ_INFO_GET_SECURE_STATE_PARAM_ID, Parameters, Results);
  if (Status != EFI_SUCCESS) {
    DEBUG ((EFI_D_ERROR, "ReadSecurityState: ScmSipSysCall Status: (0x%x)\r\n",
           Status));
    Status = ERROR_SECURITY_STATE;
    return Status;
  }

  if (SysCallRsp->common_rsp.status != 1) {
    DEBUG ((EFI_D_WARN,
          "ReadSecurityState: ScmSysCall failed: Status = (0x%x)\r\n",
           SysCallRsp->common_rsp.status));
    Status = ERROR_SECURITY_STATE;
    return Status;
  }
  // Parse the return value and assign
  SecurityStateReturn = SysCallRsp->status_0;
  return SecurityStateReturn;
}

/**
  Determine whether the devcie is secure or not.
  @param[out]  *is_secure  indicates whether the device is secure or not
  @retval  status  Indicates whether reading the security state was successful
**/

EFI_STATUS IsSecureDevice (bool *is_secure)
{
  EFI_STATUS Status = EFI_SUCCESS;
  bool secure_value= false;

  if (is_secure == NULL) {
    DEBUG ((EFI_D_ERROR, "Invalid parameter is_secure\n"));
    Status = EFI_INVALID_PARAMETER;
    return Status;
  }
  UINT32 SecureState = ReadSecurityState ();
  if (SecureState == ERROR_SECURITY_STATE) {
    DEBUG ((EFI_D_ERROR, "ReadSecurityState failed!\n"));
    Status = EFI_LOAD_ERROR;
    return Status;
  }
  *is_secure = false;

  secure_value = !CHECK_BIT (SecureState, SECBOOT_FUSE) &&
                 !CHECK_BIT (SecureState, SHK_FUSE) &&
                 !CHECK_BIT (SecureState, DEBUG_DISABLED_FUSE) &&
                 CHECK_BIT (SecureState, DEBUG_RE_ENABLED_FUSE);

  if (!(CheckRootDeviceType () == NAND)) {
    secure_value = secure_value && !CHECK_BIT (SecureState, RPMB_ENABLED_FUSE);
  }

  if (secure_value) {
    *is_secure = true;
  }

  return Status;
}

EFI_STATUS SetFuse (uint32_t FuseId)
{
  EFI_STATUS Status = EFI_SUCCESS;
  QCOM_SCM_PROTOCOL *test_scm_protocol = 0;
  uint64_t Param[SCM_MAX_NUM_PARAMETERS] = {0};
  uint64_t Results[SCM_MAX_NUM_RESULTS] = {0};

  Status = gBS->LocateProtocol (&gQcomScmProtocolGuid, NULL,
                                (VOID **)&test_scm_protocol);
  if (Status != EFI_SUCCESS ||
      test_scm_protocol == NULL) {
    DEBUG ((EFI_D_ERROR, "LocateProtocol failed for SetFuse!\n"));
    Status = EFI_LOAD_ERROR;
    return Status;
  }

  Param[0] = FuseId;

  Status = test_scm_protocol->ScmSipSysCall (
      test_scm_protocol, TZ_BLOW_SW_FUSE_ID,
      TZ_BLOW_SW_FUSE_ID_PARAM_ID, Param, Results);
  if (Status != EFI_SUCCESS) {
    DEBUG ((EFI_D_ERROR, "ScmSipSysCall failed for SetFuse!\n"));
    return Status;
  }
  return Status;
}

EFI_STATUS GetFuse (uint32_t FuseId, bool *get_fuse_id)
{
  EFI_STATUS Status = EFI_SUCCESS;
  QCOM_SCM_PROTOCOL *test_scm_protocol = 0;
  uint64_t Param[SCM_MAX_NUM_PARAMETERS] = {0};
  uint64_t Results[SCM_MAX_NUM_RESULTS] = {0};

  if (get_fuse_id == NULL) {
    return Status;
  }
  Status = gBS->LocateProtocol (&gQcomScmProtocolGuid, NULL,
                                (VOID **)&test_scm_protocol);
  if (Status != EFI_SUCCESS ||
      test_scm_protocol == NULL) {
    DEBUG ((EFI_D_ERROR, "LocateProtocol failed for GetFuse!\n"));
    Status = EFI_LOAD_ERROR;
    return Status;
  }

  Param[0] = FuseId;

  Status = test_scm_protocol->ScmSipSysCall (
      test_scm_protocol, TZ_IS_SW_FUSE_BLOWN_ID,
      TZ_IS_SW_FUSE_BLOWN_ID_PARAM_ID, Param, Results);
  if (Status != EFI_SUCCESS) {
    DEBUG ((EFI_D_ERROR, "ScmSipSysCall failed for GetFuse!\n"));
    return Status;
  }
  /*Results[0] is Status, Results[1] is output value*/
  if (Results[1] == 1) {
    *get_fuse_id = true;
  } else {
    *get_fuse_id = false;
  }
  return Status;
}

STATIC EFI_STATUS ScmGetFeatureVersion (uint32_t FeatureId, uint32_t *Version)
{
  EFI_STATUS Status = EFI_SUCCESS;
  QCOM_SCM_PROTOCOL *test_scm_protocol = 0;
  uint64_t Parameters[SCM_MAX_NUM_PARAMETERS] = {0};
  uint64_t Results[SCM_MAX_NUM_RESULTS] = {0};
  tz_feature_version_req_t *SysCallReq = (tz_feature_version_req_t *)Parameters;
  tz_feature_version_rsp_t *SysCallRsp = (tz_feature_version_rsp_t *)Results;

  if (Version == NULL) {
    DEBUG ((EFI_D_ERROR, "Invalid parameter Version\n"));
    Status = EFI_INVALID_PARAMETER;
    return Status;
  }

  Status = gBS->LocateProtocol (&gQcomScmProtocolGuid, NULL,
                                (VOID **)&test_scm_protocol);
  if (Status != EFI_SUCCESS ||
      !test_scm_protocol) {
    DEBUG ((EFI_D_ERROR, "LocateProtocol failed for ScmGetFeatureVersion!\n"));
    return Status;
  }

  SysCallReq->feature_id = FeatureId;

  Status = test_scm_protocol->ScmSipSysCall (
      test_scm_protocol, TZ_INFO_GET_FEATURE_VERSION_ID,
      TZ_INFO_GET_FEATURE_VERSION_ID_PARAM_ID, Parameters, Results);
  if (Status != EFI_SUCCESS) {
    DEBUG ((EFI_D_ERROR, "ScmSipSysCall failed for ScmGetFeatureVersion!\n"));
    return Status;
  }
  if (SysCallRsp->common_rsp.status != 1) {
    Status = EFI_DEVICE_ERROR;
    DEBUG ((EFI_D_ERROR,
            "TZ_INFO_GET_FEATURE_VERSION_ID failed, Status = (0x%x)\r\n",
            SysCallRsp->common_rsp.status));
    return Status;
  }

  *Version = SysCallRsp->version;
  return Status;
}

bool AllowSetFuse ()
{
  EFI_STATUS Status = EFI_SUCCESS;
  UINT32 version = 0;

  Status = ScmGetFeatureVersion (TZ_FVER_QSEE, &version);
  if (Status != EFI_SUCCESS) {
    DEBUG ((EFI_D_ERROR,
        "KeyMasterSetRotAndBootState: ScmGetFeatureVersion fails!\n"));
    return false;
  }
  /*if((major > 4) || (major == 4 && minor > 0))*/
  if ((((version >> 22) & 0x3FF) > 4) ||
     (((version >> 22) & 0x3FF) == 4 &&
      ((version >> 12) & 0x3FF) > 0)) {
    return true;
  } else {
    DEBUG ((EFI_D_ERROR, "TZ didn't support this feature! "
            "Version: major = %d, minor = %d, patch = %d\n",
              (version >> 22) & 0x3FF, (version >> 12) & 0x3FF,
                version & 0x3FF));
    return false;
  }
}

bool avb_should_update_rollback(bool is_multi_slot) {
  bool update_rollback_index = FALSE;

  if (is_multi_slot) {
    /* Update rollback if the current slot is bootable */
    if (IsCurrentSlotBootable ()) {
      update_rollback_index = TRUE;
    } else {
      update_rollback_index = FALSE;
      DEBUG ((EFI_D_VERBOSE, "Not updating rollback"
                "index as current slot is unbootable\n"));
    }
  } else {
    /* When Multislot is disabled, always update*/
    update_rollback_index = TRUE;
  }

  return update_rollback_index;
}

EFI_STATUS UpdateRollbackSyscall ()
{
  EFI_STATUS Status = EFI_SUCCESS;
  QCOM_SCM_PROTOCOL *pQcomScmProtocol = NULL;
  UINT64 Parameters[SCM_MAX_NUM_PARAMETERS] = {0};
  UINT64 Results[SCM_MAX_NUM_RESULTS] = {0};
  UINT32 FeatureVersion = 0;
  UINT32 MajorVersion = 0;
  UINT32 MinorVersion = 0;
  tz_syscall_rsp_t *SysCallRsp = (tz_syscall_rsp_t*)Results;

  // Locate QCOM_SCM_PROTOCOL.
  Status = gBS->LocateProtocol (&gQcomScmProtocolGuid, NULL,
                               (VOID **)&pQcomScmProtocol);
  if (Status != EFI_SUCCESS || (pQcomScmProtocol == NULL)) {
    DEBUG ((EFI_D_ERROR, "UpdateRollbackSyscall: Locate SCM Status: (0x%x)\r\n",
             Status));
    Status = EFI_FAILURE;
    return Status;
  }

  Status = ScmGetFeatureVersion(TZ_FVER_QSEE, &FeatureVersion);
  if (Status != EFI_SUCCESS) {
    DEBUG ((EFI_D_ERROR, "UpdateRollbackSyscall: ScmGetFeatureVersion fails!"));
    Status = EFI_FAILURE;
    return Status;
  }

  MajorVersion = (FeatureVersion >> 22) & 0x3FF;
  MinorVersion = (FeatureVersion >> 12) & 0x3FF;
  if (MajorVersion > 5 || (MajorVersion == 5 && MinorVersion > 1)) {
    // Make ScmSipSysCall to update rollback
    Status = pQcomScmProtocol->ScmSipSysCall (
          pQcomScmProtocol, TZ_UPDATE_ROLLBACK_VERSION_ID,
          TZ_UPDATE_ROLLBACK_VERSION_ID_PARAM_ID, Parameters, Results);
    if (Status != EFI_SUCCESS) {
      DEBUG ((EFI_D_ERROR, "UpdateRollbackSyscall: ScmCall Status: (0x%x)\r\n",
               Status));
      Status = EFI_FAILURE;
      return Status;
    }
    if (SysCallRsp->status != 1) {
      Status = SysCallRsp->status;
      DEBUG(( EFI_D_ERROR, "TZ_UPDATE_ROLLBACK_VERSION_ID failed, "
                    "Status = (0x%x)\r\n", Status));
      return Status;
    }
  } else {
    DEBUG ((EFI_D_WARN, "UpdateRollbackSyscall: Older TZ, skipping update"));
  }
  return Status;
}
