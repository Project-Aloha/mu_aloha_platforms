#!/bin/bash

maxmonthday=$(date -d "$(date --utc +%m)/1 + 1 month - 1 day" +%d) # 30 (for september)
currentmonthday=$(date --utc +%d)
perc=$((10#$currentmonthday * 100 / $maxmonthday))

vervalue1="0x$(date --utc +%Y%m%d) # $(date --utc +%Y-%m-%d)"       # 0x20250903
vervalue2="0x1$(date --utc +%y%m)$perc # 1.$(date --utc +%y.%m).${perc}"                              # 0x1250930
vervalue3="0x01$(date --utc +%y%m)$perc"                             # 0x01250930
vervalue4="L\"$(date --utc +%y%m).$perc\""                                # 2509.30

echo Version Component 1: $vervalue1
echo Version Component 2: $vervalue2
echo Version Component 3: $vervalue3
echo Version Component 4: $vervalue4

filetopatch=./Platforms/AndromedaPkg/Andromeda.dsc.inc

sed -i -E "s/(gEfiMdeModulePkgTokenSpaceGuid\.PcdFirmwareRevision\|).*/\1${vervalue3}/"       $filetopatch
sed -i -E "s/(gEfiMdeModulePkgTokenSpaceGuid\.PcdFirmwareVersionString\|).*/\1${vervalue4}/"  $filetopatch
sed -i -E "s/(gOemPkgTokenSpaceGuid\.PcdUefiVersionNumber\|).*/\1${vervalue2}/" $filetopatch
sed -i -E "s/(gOemPkgTokenSpaceGuid\.PcdUefiBuildDate\|).*/\1${vervalue1}/"     $filetopatch
