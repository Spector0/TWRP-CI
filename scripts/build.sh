#!/bin/bash

# Source Configs
source $CONFIG

# A Function to Send Posts to Telegram
telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
	-d chat_id="${TG_CHAT_ID}" \
	-d parse_mode="HTML" \
	-d text="$1"
}

# Change to the Source Directry
cd work

# Set-up ccache
if [ -z "$CCACHE_SIZE" ]; then
    ccache -M 10G
else
    ccache -M ${CCACHE_SIZE}
fi

# Send the Telegram Message

echo -e \
"
🙃 TWRP Recovery CI

✔️ The Build has been Triggered!

📱 Device: "${DEVICE}"
🖥 Build System: "${TWRP_BRANCH}"
🌲 Logs: <a href=\"https://cirrus-ci.com/build/${CIRRUS_BUILD_ID}\">Here</a>
" > tg.html

TG_TEXT=$(< tg.html)

telegram_message "${TG_TEXT}"
echo " "

# Prepare the Build Environment
source build/envsetup.sh

# Run the Extra Command
$EXTRA_CMD

# export some Basic Vars
#export ALLOW_MISSING_DEPENDENCIES=true
#export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
#export LC_ALL="C"

lunch twrp_$DEVICE-eng 
repopick 5405 5540 5445 5831
rm -rf .repo/
mka vendorbootimage
