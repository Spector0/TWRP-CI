mkdir work
cd work
repo init -u $MANIFEST --depth=1 --partial-clone --clone-filter=blob:limit=10M --groups=all,-notdefault,-device,-darwin,-x86,-mips
repo sync -j4
git clone https://github.com/Spector0/Device_Oneplus_Oscar_TWRP -b Test --depth=1 --single-branch device/oneplus/oscar
