#!/bin/env python3

# @file
# This script provideds android boot pack helper in PlatformBuild.py
#
# Copyright (c) DuoWoa Authors.
# SPDX-License-Identifier: BSD-2-Clause-Patent#
##

import logging
import gzip
import os
import json
import mkbootimg
import shlex


class Bootimg:
    # Configurations
    header_version: int = 0
    kernel_compressed: bool = False
    emptyramdisk: bool = False
    cmdline: str = ""
    pagesize: int = 4096
    base: int = 0
    os_version: str = "17.0.0"
    os_patch_level: str = "2026-06-18"
    second_offset: int = 0

    # Paths
    fd_path: str = ""           # UEFI FD path
    dtb_path: str = ""          # For passing abl dtbo overlay only
    bootshim_path: str = ""     # Copy fd to specific place in memory
    bootpayload_path: str = ""  # Fake kernel made from bootshim + uefi_fd
    device_name: str = ""

    def __init__(self, outputbin_dir,
                 output_dir, root_dir,
                 device_name, dtb_name, package_name, platform):

        # Parse configuration and fill attributes
        with open(os.path.join(root_dir, 'build_cfg', platform.lower()+'.json'), 'r') as cfg_file:
            cfg = json.load(cfg_file)
            self.parseConfiguration(cfg)

        # Fill paths and other vars
        self.device_name = device_name
        self.bootpayload_path = os.path.join(output_dir, 'bootpayload.bin')
        self.output_path = os.path.join(output_dir, device_name + '.img')
        self.fd_path = os.path.join(
            outputbin_dir, 'FV', platform.upper()+'_EFI.fd')
        self.bootshim_path = os.path.join(root_dir, 'BootShim', 'BootShim.bin')
        self.dtb_path = os.path.join(root_dir, "Platforms", package_name, "Device",
                                     device_name, 'DeviceTreeBlob', 'Android', 'android-' + dtb_name)

        # Process android boot cfg override
        override_cfg_path = os.path.join(root_dir, "Platforms", package_name, "Device",
                                         device_name, "bootpack.json")
        try:
            with open(override_cfg_path, 'r') as override_cfg_file:
                override_cfg = json.load(override_cfg_file)
                # Parse again
                self.parseConfiguration(override_cfg)
        except FileNotFoundError:
            logging.info("ABoot pack paras override isn't appointed.")

    def parseConfiguration(self, cfg):
        cfg = cfg.get("default_aboot_args", {})
        self.header_version = cfg.get(
            "header_version", self.header_version)
        self.cmdline = cfg.get("cmdline", self.cmdline)
        self.kernel_compressed = cfg.get(
            "kernel_compressed", self.kernel_compressed)
        self.emptyramdisk = cfg.get("emptyramdisk", self.emptyramdisk)
        self.pagesize = cfg.get("pagesize", self.pagesize)
        self.os_version = cfg.get("os_version", self.os_version)
        self.os_patch_level = cfg.get(
            "os_patch_level", self.os_patch_level)
        self.base = int(cfg.get("base", hex(self.base)), 16)
        self.second_offset = int(
            cfg.get("second_offset", hex(self.second_offset)), 16)

        # basic sanity checks
        if self.header_version > 4 or self.header_version < 0:
            raise ValueError(
                "Invalid header version: {}".format(self.header_version))

    def generateMkbootimgParameters(self):
        args = [
            "--header_version", str(self.header_version),
            "--kernel", self.bootpayload_path,
            "-o", self.output_path,
            "--pagesize", str(self.pagesize),
            "--cmdline", self.cmdline,
            "--base", hex(self.base),
            "--os_version", self.os_version,
            "--os_patch_level", self.os_patch_level
        ]
        if self.emptyramdisk:
            args.extend(["--ramdisk", "./PythonLibs/emptyramdisk"])
        if self.second_offset != 0:
            args.extend(["--second_offset", hex(self.second_offset)])
        if self.header_version == 2:
            # Need to pack dtb in boot in header version 2.
            args.extend(["--dtb", self.dtb_path])
        return args

    def makeAndroidImage(self):
        '''
        Boot Payload:
            | BootShim.bin | SMXXXX_EFI.fd |
        '''
        logging.info("Generating bootpayload.bin")
        with open(self.bootpayload_path, 'wb') as payload_file:
            payload_data = bytes()

            # Read bootshim
            with open(self.bootshim_path, 'rb') as bootshim_file:
                logging.info("Writing BootShim...")
                payload_data += bootshim_file.read()

            # Read UEFI FD
            with open(self.fd_path, 'rb') as fd_file:
                logging.info("Writing UEFI...")
                payload_data += fd_file.read()

            # Process kernel compress if asked
            if self.kernel_compressed:
                logging.info("Compressing kernel...")
                payload_data = gzip.compress(payload_data, 9)

            # If we are using v0/v1,
            # dtb should be attached after kernel.
            if self.header_version < 2:
                with open(self.dtb_path, 'rb') as dtb:
                    logging.info("Writing DTB...")
                    payload_data += dtb.read()

            # Write to payload.
            payload_file.write(payload_data)

            # Pack boot image.
            logging.info("Writing " + self.device_name + '.img')
            paras = self.generateMkbootimgParameters()
            logging.info(f"Packing boot with \"{shlex.join(paras)}\"")
            mkbootimg.main(paras)
