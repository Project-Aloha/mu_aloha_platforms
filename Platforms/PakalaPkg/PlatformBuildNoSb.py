# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: BSD-2-Clause-Patent
"""Stuart entry point for Pakala; build policy is defined in PakalaBuild.py."""
from pathlib import Path
import importlib.util

# Resolve the shared settings independently of the caller's working directory.
_spec = importlib.util.spec_from_file_location("PakalaBuild", Path(__file__).resolve().with_name("PakalaBuild.py"))
_build = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_build)
SettingsManager = _build.SettingsManager
PlatformBuilder = _build.PlatformBuilder

if __name__ == "__main__":
    _build.run_stuart(__file__)
