is_chrooted() {
	if [ x"$debian_chroot" = "x" ]; then
		return 1
	else
		return 0
	fi
}
is_chrooted || exec chroot-debian "${0#/mnt/debian}" "$@"
