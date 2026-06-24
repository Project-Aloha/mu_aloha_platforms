# Aarch64 Secure Boot Defaults
 Secure Boot Defaults

This external dependency contains the default values suggested by microsoft the KEK, DB, and DBX UEFI variables.

Additionally, it contains an optional shared PK certificate that may be used as the root of trust for the system.
The shared PK certificate is an offering from Microsoft. Instead of a original equipment manufacturer (OEM)
managed PK, an OEM may choose to use the shared PK certificate managed by Microsoft. Practically, this may be
useful as default on non production code provided to an OEM by an independent vendor (IV).

1. The PK (Platform Key) is a single certificate that is the root of trust for the system. This certificate is used
    to verify the KEK.
2. The KEK (Key Exchange Key) is a list of certificates that verify the signature of other keys attempting to update
   the DB and DBX.
3. The DB (Signature Database) is a list of certificates that verify the signature of a binary attempting to execute
   on the system.
4. The DBX (Forbidden Signature Database) is a list of signatures that are forbidden from executing on the system.

Please review [Microsoft's documentation](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-secure-boot-key-creation-and-management-guidance?view=windows-11#15-keys-required-for-secure-boot-on-all-pcs)
for more information on key requirements if appending to the defaults provided in this external dependency.

## Folder Layout

### Artifacts

This folder contains the defaults in a EFI Signature List Format broken up by architecture. This format is used by the
UEFI firmware to initialize the secure boot variables. These files are in the format described by
[EFI_SIGNATURE_DATA](https://uefi.org/specs/UEFI/2.10/32_Secure_Boot_and_Driver_Signing.html?highlight=authenticated%20variable#efi-signature-data)

## DefaultPk

Contains the OEMA0 PK to enable signature database updates and binary execution.

Files Included:

* keystore/OEMA0-PK.der
* keystore/WOAMSMNILE-PK.der

## DefaultKek

Contains the Microsoft KEKs and OEMA0 KEK to enable signature database updates and binary execution.

Files Included:

* keystore/KEK/Certificates/MicCorKEKCA2011_2011-06-24.der
  * <https://go.microsoft.com/fwlink/?LinkId=321185>
* keystore/KEK/Certificates/microsoft_corporation_kek_2k_ca_2023.der
  * <https://go.microsoft.com/fwlink/?linkid=2239775>
* keystore/OEMA0-KEK.der
  * <https://github.com/WOA-Project/mu_andromeda_platforms>
* keystore/WOAMSMNILE-KEK.der
  * <https://github.com/Project-Aloha/mu_aloha_platforms>

## DefaultDb

Contains only Microsoft certificates to verify binaries before execution. More secure than Default3PDb.

Files Included:

* keystore/DB/Certificates/MicWinProPCA2011_2011-10-19.der
  * <https://go.microsoft.com/fwlink/p/?linkid=321192>
* keystore/DB/Certificates/windows_uefi_ca_2023.der
  * <https://go.microsoft.com/fwlink/?linkid=2239776>

## Default3PDb

Contains Microsoft and UEFI third party certificates to verify binaries before execution. More compatible than
DefaultDb.

Files Included:

* keystore/DB/Certificates/MicWinProPCA2011_2011-10-19.der
  * <https://go.microsoft.com/fwlink/p/?linkid=321192>
* keystore/DB/Certificates/windows_uefi_ca_2023.der
  * <https://go.microsoft.com/fwlink/?linkid=2239776>
* keystore/DB/Certificates/MicCorUEFCA2011_2011-06-27.der
  * <https://go.microsoft.com/fwlink/p/?linkid=321194>
* keystore/DB/Certificates/microsoft_uefi_ca_2023.der
  * <https://go.microsoft.com/fwlink/?linkid=2239872>
* keystore/DB/Certificates/microsoft_option_rom_uefi_ca_2023.der
  * <http://www.microsoft.com/pkiops/certs/microsoft%20option%20rom%20uefi%20ca%202023.crt>

## DefaultDbx

Contains a list of revoked certificates that will not execute on this system. Filtered per Architecture (ARM, Intel).

Files Included:

* keystore/DBX/Hashes/dbx_info_msft_4_09_24.csv
  * <https://uefi.org/sites/default/files/resources/dbx_info.csv>

---

Secure Boot Objects

Copyright (C) Microsoft Corporation. All rights reserved.

SPDX-License-Identifier: BSD-2-Clause-Patent

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following
   disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following
   disclaimer in the documentation and/or other materials provided with the distribution.

Subject to the terms and conditions of this license, each copyright holder and contributor hereby grants to those
receiving rights under this license a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable
(except for failure to satisfy the conditions of this license) patent license to make, have made, use, offer to sell,
sell, import, and otherwise transfer this software, where such license applies only to those patent claims, already
acquired or hereafter acquired, licensable by such copyright holder or contributor that are necessarily infringed by:

(a) their Contribution(s) (the licensed copyrights of copyright holders and non-copyrightable additions of
    contributors, in source or binary form) alone; or

(b) combination of their Contribution(s) with the work of authorship to which such Contribution(s) was added by such
    copyright holder or contributor, if, at the time the Contribution is added, such addition causes such combination
    to be necessarily infringed. The patent license shall not apply to any other combinations which include the
    Contribution.

Except as expressly stated above, no rights or licenses from any copyright holder or contributor is granted under this
license, whether expressly, by implication, estoppel or otherwise.

DISCLAIMER

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
