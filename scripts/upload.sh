#!/bin/bash

# Source Vars
source $CONFIG

# A Function to Send Posts to Telegram
telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
	-d chat_id="${TG_CHAT_ID}" \
	-d parse_mode="HTML" \
	-d text="$1"
}
# Color
ORANGE='\033[0;33m'

# Display a message
echo "============================"
echo "Uploading the Build..."
echo "============================"

# Change to the Output Directory
cd work/out/target/product/oscar

# Set FILENAME var
FILENAME=$(echo $OUTPUT)
ZIP_NAME= TWRP_OSCAR_A12.1-ALPAHA.zip
# Upload to oshi.at
if [ -z "$TIMEOUT" ];then
    TIMEOUT=20160
fi

# Upload to WeTransfer
# NOTE: the current Docker Image, "registry.gitlab.com/sushrut1101/docker:latest", includes the 'transfer' binary by Default
#transfer wet $FILENAME > link.txt || { echo "ERROR: Failed to Upload the Build!" && exit 1; }
sudo zip -r9 $ZIP_NAME boot.img
curl -F chat_id=$CHAT_ID -F document=@$ZIP_NAME https://api.telegram.org/bot$BOT_TOKEN/sendDocument -F caption="Alpha build"
curl -sL https://git.io/file-transfer | sh
transfer wet $ZIP_NAME > link.txt
transfer wet vendor_boot.img > boot.txt
transfer wet recovery-installer.zip > installer.txt

Footer
© 2022 GitHub, Inc.
Footer navigation
Terms
Privacy
Security
Status
Docs

# Mirror to oshi.at
#curl -T boot.img https://oshi.at/${FILENAME}/${OUTPUT} > mirror.txt || { echo "WARNING: Failed to Mirror the Build!"; }

DL_LINK1=$(cat link.txt | grep Download | cut -d\  -f3)
DL_LINK2=$(cat boot.txt | grep Download | cut -d\  -f3)
DL_LINK3=$(cat installer.txt | grep Download| cut -d\ -f3)
# Show the Download Link
echo "=============================================="
echo "Recovery installer: ${DL_LINK3}" || { echo "ERROR: Failed to Upload the Build!"; }
echo "Bootimg: ${DL_LINK2}" || { echo "WARNING: Failed to Mirror the Build!"; }
echo "zipfile: ${DL_LINK1}" || { echo "WARNING: Failed to Mirror the Build!"; }
echo "=============================================="

DATE_L=$(date +%d\ %B\ %Y)
DATE_S=$(date +"%T")

# Send the Message on Telegram
echo -e \
"
🙃 TWRP Recovery ci

✅ Build Completed Successfully!

📱 Device: "${DEVICE}"
🖥 Build System: "${TWRP_BRANCH}"
💿 Boot image: <a href=\"${DL_LINK2}\">Here</a>
📅 Date: "$(date +%d\ %B\ %Y)"
⏱ Time: "$(date +%T)"
" > tg.html

TG_TEXT=$(< tg.html)

telegram_message "$TG_TEXT"

echo " "

# Exit
exit 0
