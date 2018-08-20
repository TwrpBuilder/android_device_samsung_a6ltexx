#!/sbin/sh

relink()
{
	fname=$(basename "$1")
	target="/sbin/$fname"
	sed 's|/system/bin/linker|///////sbin/linker|' "$1" > "$target"
	chmod 755 $target
}

finish()
{
	umount /v
	umount /s
	rmdir /v
	rmdir /s
	setprop crypto.ready 1
	exit 0
}


venpath="/dev/block/bootdevice/by-name/vendor"
mkdir /v
mount -t ext4 -o ro "$venpath" /v
syspath="/dev/block/bootdevice/by-name/system"
mkdir /s
mount -t ext4 -o ro "$syspath" /s

mkdir -p /vendor/lib/hw/

cp /s/system/lib/android.hidl.base@1.0.so /sbin/

cp /v/lib/libkeymaster2_mdfpp.so /vendor/lib/
cp /v/lib/libkeymaster_helper.so /vendor/lib/
cp /v/lib/libkeystore-engine-wifi-hidl.so /vendor/lib/
cp /v/lib/libkeystore-wifi-hidl.so /vendor/lib/
cp /v/lib/hw/android.hardware.boot@1.0-impl.so /vendor/lib/hw/
cp /v/lib/hw/android.hardware.gatekeeper@1.0-impl.so /vendor/lib/hw/
cp /v/lib/hw/android.hardware.keymaster@3.0-impl.so /vendor/lib/hw/

cp /v/manifest.xml /vendor/
cp /v/compatibility_matrix.xml /vendor/

relink /v/bin/hw/android.hardware.boot@1.0-service
relink /v/bin/hw/android.hardware.keymaster@3.0-service
relink /v/bin/hw/android.hardware.gatekeeper@1.0-service

finish
exit 0
