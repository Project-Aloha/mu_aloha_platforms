#!/bin/env python3

# @file
# This script help you build any devices in any platforms in this repo.
#
# Copyright (c) DuoWoa Authors.
# SPDX-License-Identifier: BSD-2-Clause-Patent#
##

# TODO Port to windows if possible.
import argparse
import os,sys
import shutil
import json
import Levenshtein


class Target:
    def __init__(self, device, platform, package, bootshim_uefi_base, bootshim_uefi_size, secureboot, buildtype):
        self.device = device
        self.platform = platform
        self.package = package
        self.bootshim_uefi_base = bootshim_uefi_base
        self.bootshim_uefi_size = bootshim_uefi_size
        self.secureboot = secureboot
        self.buildtype = buildtype

        if self.secureboot is None:
            self.secureboot = 0;

        if self.buildtype is None:
            self.buildtype = "RELEASE";

        if self.buildtype != "RELEASE" and self.buildtype != "DEBUG":
            print(f"Unknown build type \"{self.buildtype}\", change to RELEASE by default.")
            self.buildtype = "RELEASE"


    def merge(self, target_b):
        if self.device is None:
            self.device = target_b.device

        if self.platform is None:
            self.platform = target_b.platform

        if self.package is None:
            self.package = target_b.package

        if self.bootshim_uefi_base is None:
            self.bootshim_uefi_base = target_b.bootshim_uefi_base

        if self.bootshim_uefi_size is None:
            self.bootshim_uefi_size = target_b.bootshim_uefi_size


    def print_content(self):
        print("Target Info: ")
        print("device", self.device)
        print("platform", self.platform)
        print("package", self.package)
        print("bootshim_uefi_base", self.bootshim_uefi_base)
        print("bootshim_uefi_size", self.bootshim_uefi_size)


def is_system_supported():
    return os.name == "posix"


def build_bootshim(this_target):
    bootshim_cmd = os.path.abspath("build_boot_shim.sh") + " -b " + str(this_target.bootshim_uefi_base) + " -s " + str(
        this_target.bootshim_uefi_size)
    return os.system(bootshim_cmd)


def prepare_build(buildtype, package_name):
    stuart_setup_cmd = "python3 " + os.path.join("Platforms", package_name,
                                                         "PlatformBuild.py") + " --setup -t " + buildtype
    stuart_update_cmd = "python3 " + os.path.join("Platforms", package_name,
                                                          "PlatformBuild.py") + " --update -t " + buildtype
    os.system(stuart_setup_cmd)
    os.system(stuart_update_cmd)


def get_devices_list(package_name):
    return os.listdir(os.path.join("Platforms", package_name, "Device"))


def get_platforms_list():
    return os.listdir("Silicon/QC")


# Check is args provided by you available.
def check_args(this_target):
    usage = "Usage: build_uefi.py -d <target_device> [-psth]\n"
    available_devices_msg = "Available devices:"
    available_platforms_msg = "Available platforms:"
    available_platforms_list = get_platforms_list()
    link_msg = "See \033[32mhttps://github.com/project-aloha/mu_aloha_platforms#target-list\033[0m for all available devices."

    if this_target.platform is not None and this_target.package is not None:
        current_platform_msg = "\033[33mCurrent platform: " + this_target.platform + "\033[0m"
        available_devices_list = get_devices_list(this_target.package)

        # check if target_device illegal
        device_available = False
        for this_device in available_devices_list:
            if this_device == this_target.device or this_target.device == "all":
                device_available = True
                return device_available

        # if illegal, print all supported devices.
        if not device_available:
            print(usage)
            print(available_devices_msg)
            print(current_platform_msg)
            for this_device in available_devices_list:
                print("\t" + this_device)
            if this_target.device is None:
                print("\nPlease provide target device.")
            else:
                print("\nThe target device \033[1;33;41m" + this_target.device + "\033[0m is not supported.")
            exit(link_msg)

    elif this_target.package is None:  # if package == None, that means parse failed before,
        #   which means platform provided is unsupported.
        print(usage)
        print(available_platforms_msg)
        for this_platform in available_platforms_list:
            print("\t" + this_platform)
        exit(link_msg)
    print()


def device_error_exit(device_name, possible_devices_list):
    usage = "Usage: build_uefi.py -d <target_device> [-psth]\n"
    help_msg = "Use \033[33mbuild_uefi.py --help\033[0m for details"
    not_found_msg = "Target device not found."
    link_msg = "See \033[32mhttps://github.com/Project-Aloha/mu_aloha_platforms#target-list\033[0m for all devices available."
    print(usage)
    if not possible_devices_list:
        print(help_msg)
        print(not_found_msg)
    else:
        possible_devices_msg = "Target device \033[31m" + device_name + "\033[0m not found, did you mean: "
        print(possible_devices_msg)
        for dev_name in possible_devices_list:
            print('\t' + dev_name)
    print()
    print(link_msg)
    exit()


# This function get a file object and return a target object.
# The file must be a json file.
def parse_cfg(pfile):
    this_target = Target(None, None, None, None, None, None, None)
    cfg_dict = json.load(pfile)
    this_target.platform = cfg_dict["platform"]
    this_target.package = cfg_dict["package"]
    this_target.bootshim_uefi_base = cfg_dict["bootshim"]["UEFI_BASE"]
    this_target.bootshim_uefi_size = cfg_dict["bootshim"]["UEFI_SIZE"]
    return this_target


# Build uefi for a device
def build_device(this_target):
    # Print args
    this_target.print_content()
    # Prepare Environment
    build_bootshim(this_target)

    # Check if build successfully
    # if CI mode enabled, copy .FD and .img into CI upload directory.
    if os.getenv("WM_CI_BUILD") == "true":
        print("Buiding in CI...")

        # In CI Environment, we build SB and NOSB at same time, build SB here.
        this_target.secureboot = 1
        os.system("python3 " + os.path.join("Platforms", this_target.package, "PlatformBuild.py")
              + " TARGET=" + this_target.buildtype + " TARGET_DEVICE=" + this_target.device)

        # Copy build SB output into ci upload dir.
        ci_copy_fd_after_single_device_building(this_target)

        # Move secureboot status back.
        this_target.secureboot = 0

        # Now build NOSB
        os.system("python3 " + os.path.join("Platforms", this_target.package, "PlatformBuildNoSb.py")
              + " TARGET=" + this_target.buildtype + " TARGET_DEVICE=" + this_target.device)
        
        # Copy build NOSB output into ci upload dir.
        ci_copy_fd_after_single_device_building(this_target)
    else:
        if this_target.secureboot == 1:
            # Start Actual Build
            os.system("python3 " + os.path.join("Platforms", this_target.package, "PlatformBuild.py")
              + " TARGET=" + this_target.buildtype + " TARGET_DEVICE=" + this_target.device)
        else:
            # Start Actual Build
            os.system("python3 " + os.path.join("Platforms", this_target.package, "PlatformBuildNoSb.py")
              + " TARGET=" + this_target.buildtype + " TARGET_DEVICE=" + this_target.device)


def ci_copy_fd_after_single_device_building(this_target):
    # Copy FD and image into artifacts directory
    # If build successfully, there should be XXXX.fd under <OutputDir>/<package>/<buildtype>_<TOOLCHAIN>/FV/<Platform>_EFI.fd
    secureboot_suffix = "SB" if this_target.secureboot != 0 else "NOSB"
    build_output_path = os.path.join("Build", this_target.package)

    # CI will compress this directory and upload after finishing all build tasks.
    ci_upload_dir = os.path.join(build_output_path, "ci_artifacts", this_target.device)
    os.makedirs(ci_upload_dir, exist_ok=True)

    # File paths, fd and img
    # Assumes common edk2/Project Mu paths: Build/<Package>/<BUILDTYPE>_CLANGPDB/FV/
    toolchain_dir = f"{this_target.buildtype}_CLANGPDB"
    fv_path = os.path.join(build_output_path, toolchain_dir, "FV")
    
    # Generic naming matching the target device payload or firmware volume image
    fd_filename = f"{this_target.platform}_EFI.fd"
    img_filename = f"{this_target.device}.img"

    src_fd = os.path.join(fv_path, fd_filename)
    src_img = os.path.join(build_output_path, img_filename)

    dest_fd = os.path.join(ci_upload_dir, f"{this_target.device}_{secureboot_suffix}.fd")
    dest_img = os.path.join(ci_upload_dir, f"{this_target.device}_{secureboot_suffix}.img")

    if os.path.exists(src_fd):
        shutil.copy2(src_fd, dest_fd)
        print(f"CI: Copied {src_fd} -> {dest_fd}")
    
    if os.path.exists(src_img):
        shutil.copy2(src_img, dest_img)
        print(f"CI: Copied {src_img} -> {dest_img}")


def main():
    parser = argparse.ArgumentParser(description="Build UEFI for devices.")
    parser.add_argument("-d", "--device", help="Target device name", required=True)
    parser.add_argument("-s", "--secureboot", type=int, choices=[0, 1], help="Secure boot status (0 or 1)")
    parser.add_argument("-t", "--buildtype", choices=["RELEASE", "DEBUG"], help="Build type (RELEASE or DEBUG)")
    parser.add_argument("-p", "--platform", help="Target platform")
    parser.add_argument("--init", action="store_true", help="Initialize or update build environment")
    
    args = parser.parse_args()

    if not is_system_supported():
        print("Error: Only POSIX systems (Linux/macOS) are currently supported.")
        sys.exit(1)

    # Resolve platform package configurations using your json cfg system
    cfg_file_path = os.path.join("build_cfg", f"{args.device}.json")
