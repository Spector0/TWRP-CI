#!/bin/bash

# Device
export TWRP_BRANCH="twrp-12.1"
export DT_LINK="https://github.com/Spector0/Device_Oneplus_Oscar_TWRP -b fox_11.0"

export DEVICE="oscar"
export OEM="oneplus"

# Build Target
## "recoveryimage" - for A-Only Devices without using Vendor Boot
## "bootimage" - for A/B devices without recovery partition (and without vendor boot)
## "vendorbootimage" - for devices Using vendor boot for the recovery ramdisk (Usually for devices shipped with Android 12 or higher)
export TARGET="bootimage"

export OUTPUT="TWRP*.zip"

# Not Recommended to Change
export SYNC_PATH="$HOME/work" # Full (absolute) path.
export USE_CCACHE=1
export CCACHE_SIZE="50G"
export CCACHE_DIR="$HOME/work/.ccache"
export J_VAL=16
