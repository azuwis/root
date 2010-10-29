#!/bin/sh
. $(dirname $0)/config.sh

umount $root/mnt/data
umount $root/dev/pts
umount $root/dev
umount $root/sys
umount $root/proc
