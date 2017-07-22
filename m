From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC 1/3] scripts to create and fsck a snapshot
Date: Fri, 21 Jul 2017 17:29:32 -0700
Message-ID: <20170722002932.GE4211@magnolia>
References: <20170722002643.GD4211@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29616 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753111AbdGVA3h (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Jul 2017 20:29:37 -0400
Content-Disposition: inline
In-Reply-To: <20170722002643.GD4211@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

/lib/udev/rules.d/96-online-fsck.rules:

# Try to hide our fsck snapshots from udev's /dev/disk linking...
ACTION=="add|change", ENV{DM_LV_NAME}=="*.fsck", OPTIONS="link_priority=-100"

/sbin/online-fsck:

#!/bin/bash

# Automatically check a LVM-managed filesystem online.
# We use lvm snapshots to do this, which means that we can only
# check filesystems in VGs that have at least 256mb (or so) of
# free space.
snap_size_mb=256
fstrim=0

print_help() {
	echo "Usage: $0 [-t] device"
	echo "-t: Run fstrim if successful."
}

exitcode() {
	ret="$1"
	if [ -n "${SERVICE_MODE}" ] && [ "${ret}" -ne 0 ]; then
		ret="$((ret + 150))"
	fi
	exit "${ret}"
}

while getopts "t" opt; do
	case "${opt}" in
	"t") fstrim=1;;
	*) print_help; exitcode 2;;
	esac
done
shift "$((OPTIND - 1))"

dev="$1"
if [ -z "${dev}" ]; then
	print_help
	exitcode 2
elif [ ! -b "${dev}" ]; then
	echo "${dev}: Not a block device?"
	print_help
	exitcode 2
fi

# Make sure this is an LVM device we can snapshot
lvs="$(lvs --noheadings -o vg_name,lv_name "${dev}" 2> /dev/null)"
if [ -z "${lvs}" ]; then
	echo "${dev}: Not a LVM device."
	exitcode 1
fi
vg="$(echo "${lvs}" | awk '{print $1}')"
lv="$(echo "${lvs}" | awk '{print $2}')"
start_time="$(date +'%Y%m%d%H%M%S')"
snap="${lv}.fsck"
snap_dev="/dev/${vg}/${snap}"
fstype="$(blkid -p -s TYPE "${dev}" | sed -e 's/^.*TYPE="\(.*\)".*$/\1/g')"

teardown() {
	lvremove -f "${vg}/${snap}" 3>&-
	while [ -b "${snap_dev}" ] && [ "$?" -eq "5" ]; do
		/bin/sleep 0.5
		lvremove -f "${vg}/${snap}" 3>&-
	done
}

check() {
	case "${fstype}" in
	"ext2"|"ext3"|"ext4")
		E2FSCK_FIXES_ONLY=1
		export E2FSCK_FIXES_ONLY
		opts="-vtt"
		${DBG} e2fsck -p ${opts} "${snap_dev}" || return 1
		${DBG} e2fsck -fy ${opts} "${snap_dev}" || return 1
		;;
	*)
		${DBG} fsck -n "${snap_dev}" || return 1
		;;
	esac
	return 0
}

mark_clean() {
	case "${fstype}" in
	"ext2"|"ext3"|"ext4")
		${DBG} tune2fs -C 0 -T "${start_time}" "${dev}"
		;;
	esac
}

mark_corrupt() {
	case "${fstype}" in
	"ext2"|"ext3"|"ext4")
		${DBG} tune2fs -C 16000 -T "19000101" "${dev}"
		;;
	esac
}

# Create the snapshot
echo "Scrubbing ${dev}."
teardown > /dev/null 2> /dev/null
trap "teardown" EXIT INT QUIT TERM
lvcreate -s -L "${snap_size_mb}m" -n "${snap}" "${vg}/${lv}" 3>&-
if [ $? -ne 0 ]; then
	echo "Snapshot of ${dev} FAILED, will not check!"
	exitcode 1
fi
udevadm settle

# Check and react
if check; then
	echo "Scrub of ${dev} succeeded."
	mark_clean

	if [ "${fstrim}" -eq 1 ]; then
		dir="$(lsblk -o MOUNTPOINT -n "${dev}")"
		if [ -d "${dir}" ]; then
			# NB: fstrim fails with snapshot present
			trap '' EXIT
			teardown
			fstrim -v "${dir}"
		fi
	fi

	ret=0
else
	echo "Scrub of ${dev} FAILED!  Reboot soon to fsck."
	mark_corrupt
	ret=2
fi

# Stupid journald bug where the process still has to exist for
# the last few messages to get tagged to the service...
if [ -n "${SERVICE_MODE}" ]; then
	sleep 2
fi

exitcode "${ret}"
