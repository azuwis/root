#!/bin/sh
if [ x"$debian_chroot" != "x" ]; then
	echo "inside chroot, not running"
	exit
fi

. $(dirname $0)/config.sh

mount_bind() {
	if ! mount | grep " $root$1 " >&/dev/null; then
		if [ x"$2" = x ]; then
			mount -o bind $1 $root$1
		else
			mount -o bind $1 $2
		fi
	fi
}
mount_bind /proc
mount_bind /sys
mount_bind /dev
mount_bind /dev/pts
mount_bind /mnt/data


cron_add() {
	if ! cat /var/spool/cron/crontabs/root | grep " #$1#$" >&/dev/null; then
		cru a "$1" "$2"
	fi
}
cron_add rtorrent '1 9 * * 0,6 chroot-debian sh -c "xmlrpc http://127.0.0.1:8081/RPC2 set_download_rate 185k;xmlrpc http://127.0.0.1:8081/RPC2 set_upload_rate 18k"'

cat /etc/mtab | grep $root | sed -e "s!$root!/!" -e 's!//!/!' > $root/etc/mtab
cp /etc/resolv.conf $root/etc/

if [ $(cat /proc/swaps | wc -l) -lt 2 ]; then
	swapon LABEL=swap
fi

#rm -rf $root/tmp/*

if lsmod | grep ext2 >&/dev/null; then
	rmmod ext2
fi
