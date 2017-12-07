From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 0/4] e2scrub: online fsck for ext4
Date: Thu, 7 Dec 2017 15:50:19 -0700
Message-ID: <C71C3D7D-1846-4CC1-9B3C-C479CE790E9C@dilger.ca>
References: <151267250365.1350.7799938074608034424.stgit@magnolia>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_469AA791-B39B-4E4C-AEA9-C77EF2ACF54E";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:38315 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752357AbdLGWuY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Dec 2017 17:50:24 -0500
Received: by mail-it0-f66.google.com with SMTP id r6so835900itr.3
        for <linux-ext4@vger.kernel.org>; Thu, 07 Dec 2017 14:50:24 -0800 (PST)
In-Reply-To: <151267250365.1350.7799938074608034424.stgit@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_469AA791-B39B-4E4C-AEA9-C77EF2ACF54E
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_3FEB7FD1-A254-4ECA-9CC9-A67C96852C0E"


--Apple-Mail=_3FEB7FD1-A254-4ECA-9CC9-A67C96852C0E
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Dec 7, 2017, at 11:48 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> Hi all,
> 
> This patch series develops more fully the e2croncheck contrib script.
> We start with a e2scrub command that, given an ext4 filesystem on a LVM
> volume, creates a snapshot if there's more than 256M free in the LVM
> group, runs e2fsck on the snapshot, and deletes the snapshot.  If the
> fsck ran cleanly, the fs last-check timestamp is updated and fstrim is
> run.  If corruption is found we mark the fs as needing a fsck and advise
> a reboot.  A udev rule file is used to prevent the creation of /dev/disk
> symlinks to the snapshot.
> 
> Next we create an e2scrub_all command that finds all ext4 filesystems
> living in LVM volumes and iteratively calls e2scrub on each of them.
> 
> The third patch creates a weekly cron job for automatic invocation as
> well as systemd service files so that we can (try to) sandbox the scrub
> process and run it with idle priority to reduce latency spikes in the
> main filesystem.

For reference, here is the lvcheck script that I've been using for the
past 10 years or so, occasionally sending it to the list (most recently
in July 2017).  To use it, just drop the script in /etc/cron.weekly,
or a simple wrapper like "exec /usr/local/sbin/lvcheck".

It automatically scans the LVs looking for filesystems it understands,
creates a snapshot, checks the snapshot, and updates the last check time
and mount count (for ext2/3/4) if the check is clean.

Caveat emptor, I have only used it with ext3/4, the XFS/JFS/Reiserfs
checking was contributed by others.  Might be good to get Btrfs in there...

Cheers, Andreas


--Apple-Mail=_3FEB7FD1-A254-4ECA-9CC9-A67C96852C0E
Content-Disposition: attachment;
	filename=lvcheck
Content-Type: application/octet-stream;
	x-unix-mode=0744;
	name="lvcheck"
Content-Transfer-Encoding: 7bit

#!/bin/bash
# lvcheck, version 1.3
# Maintainer: Andreas Dilger <adilger@dilger.ca>

# Other credits:
# Concept and original script by Theodore Tso <tytso@mit.edu>
# Ideas, initial XFS/JFS support: Andreas Dilger <adilger@dilger.ca>
# Better XFS support: Eric Sandeen <sandeen@redhat.com>
# Updated and polished: Bryan Kadzban <bryan.kadzban@is-a-geek.net>
# on_ac_power is mostly from Debian's powermgmt-base package

# Released under the GNU General Public License, either version 2 or
# (at your option) any later version.

# Overview:
# Run this from cron periodically (e.g. once per week by adding a
# symlink from /etc/cron.daily/ to this script). If the machine is on
# AC power, it will run the checks; otherwise they will all be skipped
# If the script can't tell whether the machine is on AC power, it
# will use a setting in the configuration file (/etc/lvcheck.conf) to
# decide whether to continue with the checks, or abort.
#
# The script will then decide which logical volumes are active, and can
# therefore be checked via an LVM snapshot. Each of these LVs will be
# queried to find its last-check day, and if that was more than $INTERVAL
# days ago (where INTERVAL is set in the configuration file as well), or
# if the last-check day can't be determined, then the script will take an
# LVM snapshot of that LV and run fsck on the snapshot. The snapshot will
# use 1/500th of the space of the source LV. After fsck finishes, the
# snapshot is destroyed. (Snapshots are checked serially to reduce load.)
#
# Any LV that passes fsck should have its last-check time updated (in
# the real superblock, not the snapshot's superblock); any LV whose
# fsck fails will send an email notification to a configurable user
# ($EMAIL). This $EMAIL setting is optional, but its use is highly
# recommended, since if any LV fails, it will need to be checked
# manually, offline. Relevant messages are also sent to syslog.

# Set default values for configuration params. Changes to these values
# will be overwritten on an upgrade! To change these values locally
# edit /etc/lvcheck.conf.
EMAIL='root'
INTERVAL=30
AC_UNKNOWN="CONTINUE"
LOGDIR="/var/log/lvcheck"
MINSNAP=256
MINFREE=0
VERBOSE=:

usage() {
	cat <<- USAGE
usage: lvcheck [-hnv] [-e:email] [-i interval] [-l logdir]
               [-m minfree] [device ...]
Check integrity of filesystems using temporary snapshots of logical volumes.
Defaults can be set in /etc/lvcheck.conf, or overridden on command line.

	-e: email address to send error messages to (default $EMAIL)
	-h: print this help message
	-i: interval after which a check is done (default $INTERVAL days)
	-l: directory in which logs should be stored (default $LOGDIR)
	-m: minimum free space to leave in volume group (default $MINFREE MB)
	-n: do not actually perform a check, just print what would be done
	-v: run verbosely
	device: one or more LVs to check (default: all LVs with filesystems)
	USAGE
}

# pull in configuration -- overwrite the defaults above if the file exists
# in either the system-wide /etc/lvcheck.conf or /usr/local/etc/lvcheck.conf
[ -r /etc/lvcheck.conf ] && . /etc/lvcheck.conf
CHECKPATH=$(dirname "$0" | sed -e 's:/s*bin::')
[ -r $CHECKPATH/etc/lvcheck.conf ] && . $CHECKPATH/etc/lvcheck.conf

# command-line options override config file options
while getopts "e:hi:l:m:nv" opt $*; do
	case $opt in
		e) EMAIL=$OPTARG;;
		h) usage; exit 0;;
		i) INTERVAL=$OPTARG;;
		l) LOGDIR=$OPTARG;;
		m) MINFREE=$OPTARG;;
		n) NOCHECK="echo";;
		v) VERBOSE="echo";;
		\?) usage; exit 1;;
	esac
done
shift $((OPTIND - 1))

[ -d "$LOGDIR" ] || mkdir -p "$LOGDIR"
if [ ! -d "$LOGDIR" ]; then
	LOGDIR=${TMP:-/tmp}
	log err "$LOGDIR: no such directory, logging to $LOGDIR"
fi

# send $2 to syslog, with severity $1
# severities are emerg/alert/crit/err/warning/notice/info/debug
function log() {
	local sev="$1"
	local msg="$2"
	local arg=

	# log warning-or-higher messages to stderr as well
	case $sev in
	emerg|alert|crit|err|warning)
		arg=-s
		;;
	info|debug)
		$VERBOSE "$sev: $msg"
		;;
	*)
		echo "error: unknown log severity '$sev'"
		sev=warning
		;;
	esac

	[ "$NOCHECK" ] || logger -t lvcheck $arg -p user."$sev" -- "$msg"
}

# determine whether the machine is on AC power
function on_ac_power() {
	local any_known=no

	# try sysfs power class first
	if [ -d /sys/class/power_supply ]; then
		for psu in /sys/class/power_supply/*; do
			if [ -r "$psu/type" ]; then
		       		type=$(cat "$psu/type")

				# ignore batteries
				[ "$type" = "Battery" ] && continue

				online=$(cat "$psu/online")

				[ "$online" = 1 ] && return 0
				[ "$online" = 0 ] && any_known=yes
			fi
		done

		[ "$any_known" = "yes" ] && return 1
	fi

	# else fall back to AC adapters in /proc
	if [ -d /proc/acpi/ac_adapter ]; then
		for ac in /proc/acpi/ac_adapter/*; do
			if [ -r "$ac/state" ]; then
				grep -q on-line "$ac/state" && return 0
				grep -q off-line "$ac/state" && any_known=yes
			elif [ -r "$ac/status" ]; then
				grep -q on-line "$ac/status" && return 0
				grep -q off-line "$ac/status" && any_known=yes
			fi
		done

		[ "$any_known" = "yes" ] && return 1
	fi

	if [ "$AC_UNKNOWN" == "CONTINUE" ]; then
		return 0	# assume on AC power
	elif [ "$AC_UNKNOWN" == "ABORT" ]; then
		return 1	# assume on battery
	else
		log err "Invalid value for AC_UNKNOWN in the config file"
		exit 1
	fi
}

# attempt to force a check of $1 on the next reboot
function try_force_check() {
	local dev="$1"
	local fstype="$2"

	case "$fstype" in
	ext2|ext3|ext4)
		MAX=$(dumpe2fs -h "$dev" 2>&1|awk '/Check interval/ {print $3}')
		# If the user has time dependent checking disabled, we
		# have to re-enable it.  This shouldn't be harmful, since
		# this script should be run periodically before boot and
		# reset the last-checked time each error-free run.
		if [ $MAX -lt 1 ]; then
			$NOCHECK tune2fs -i $((INTERVAL*6))d "$dev" 2> /dev/null
		fi
		$NOCHECK tune2fs -T 19700201 "$dev"
		;;
	xfs)
		# XFS does not enforce check intervals; let email suffice.
		;;
	*)
		log warning "$dev: don't know how to force a check on $fstype."
		;;
	esac
}

# attempt to set the last-check time on $1 to now, and the mount count to 0.
function try_delay_checks() {
	local dev="$1"
	local fstype="$2"

	case "$fstype" in
	ext2|ext3|ext4)
		$NOCHECK tune2fs -C 0 -T now "$dev"
		;;
	xfs)
		# XFS does not enforce check intervals; nothing to delay
		;;
	*)
		log info "$dev: don't know how to delay check on $fstype."
		;;
	esac
}

# print the date that $1 was last checked, in a format that date(1) will
# accept, or "Unknown" if we don't know how to find that date.
function try_get_check_date() {
	local dev="$1"
	local fstype="$2"

	case "$fstype" in
	ext2|ext3|ext4)
		dumpe2fs -h "$dev" 2>&1 | grep 'Last checked:' |
			sed -e 's/Last checked:[[:space:]]*//'
		;;
	zfs)
		# scan: scrub repaired 0 in 0h1m with 0 errors on \
		#     Fri Sep 16 01:27:18 2011
		zpool status $(echo $dev | cut -d/ -f1) |
			sed -e 's/scan:.*errors on //p; d'
		;;
	*)
		# XFS does not save the last-checked date 
		# TODO: add support for various other FSes
		echo "Unknown"
		;;
	esac
}

# do any extra checks for filesystem type $2, on device $1
function should_still_check() {
	local dev="$1"
	local fstype="$2"

	case "$fstype" in
	ext*)	;;
	jbd*)
		log debug "skip $dev: is an external journal"
		return 1
		;;
	swap)
		log debug "skip $dev: is a swap device"
		return 1
		;;
	zfs)
		log debug "skip $dev: is a ZFS device"
		return 1
		;;
	*)
		log warning "skip $dev: can't check $fstype passively: assume OK"
		;;
	esac

	return 0
}

# check the FS on $1 passively, saving output to $3.
function perform_check() {
	local dev="$1"
	local fstype="$2"
	local errlog="$3"
	local cons=""

	case "$fstype" in
	ext2|ext3|ext4)
		if dumpe2fs -h "$dev" 2>&1| grep -q "Journal device"; then
			log debug "$dev: removing external journal"
			$NOCHECK tune2fs -U time $dev 2>&1 | tail -n +2
			$NOCHECK tune2fs -O has_journal $dev 2>&1 | tail -n +2
		fi

		tty -s && cons="-C 0"
		# first clear the orphaned-inode list, to avoid unnecessary FS
		# changes in the next step (which would cause an "error" exit
		# from e2fsck). -C 0 is present for cases where the script is
		# run interactively (logsave -s strips out the progress bar).
		# ignore the return status of this e2fsck, as it doesn't matter.
		log info "$dev: cleaning orphan inode list"
		$NOCHECK nice logsave -as "$errlog" e2fsck -p $cons "$dev"

		# then do the real check; -y is here to give more info on any
		# errors that may be present on the FS, in the log file. the
		# snapshot is writable, so it shouldn't break anything if
		# e2fsck changes it.
		log info "$dev: running full fsck"
		$NOCHECK nice logsave -as "$errlog" e2fsck -fyvtt $cons "$dev"
		return $?
		;;
	jfs)
		log info "$dev: running full fsck"
		$NOCHECK nice logsave -as "$errlog" fsck.jfs -fn "$dev"
		return $?
		;;
	reiserfs)
		log info "$dev: running full fsck"
		echo Yes | $NOCHECK nice logsave -as "$errlog" \
			fsck.reiserfs --check "$dev"
		# apparently can't fail? let's hope not...
		return $?
		;;
	xfs)
		log info "$dev: running full fsck"
		$NOCHECK nice logsave -as "$errlog" xfs_repair -n "$dev"
		return $?
		;;
	esac
}

# do everything needed to check and reset dates and counters on /dev/$1/$2.
function check_fs() {
	local vg="$1"
	local lv="$2"
	local fstype="$3"
	local snapsize="$4" # in units of MB

	local lvdev="/dev/$vg/$lv"
	local errlog="$LOGDIR/$vg-$lv-$(date +%Y%m%d)"
	local snaplvbase="$lv-lvcheck-temp"

	# try to remove old lvcheck snapshots, and skip in any case
	if [[ "$lv" =~ "lvcheck-temp" ]]; then
		# Assume script won't run more than one at a time?
		log warning "stale $lv: trying to remove old snapshot."

		$NOCHECK lvremove -f "$lv" ||
			log err "error $lv: could not delete"

		return 0
	fi

	# see whether FS needs any extra checks that might disqualify it
	should_still_check "$lvdev" "$fstype" || return 0

	# get the last check time
	check_date=$(try_get_check_date "$lvdev" "$fstype")

	# if the date is unknown, run fsck every time the script runs. sigh.
	if [ "$check_date" != "Unknown" ]; then
		# add $INTERVAL days, and throw away the time portion
		check_day=$(date --date="$check_date $INTERVAL days" +'%Y%m%d')

		# get today's date, and skip the check if it's not within the interval
		today=$(date +'%Y%m%d')
		if [ $check_day -gt $today ]; then
			log debug "skip $lvdev: just checked on $check_date."
			return 0
		fi
	fi

	snaplv=""
	# create new snapshot LV
	if [ "$fstype" = "zfs" ]; then
		#checkdev="$(echo $lvdev | cut -d/ -f 1)"
		:
	else
		modprobe -q dm-snapshot
		snaplv="$snaplvbase-$(date +'%Y%m%d')"
		$NOCHECK lvcreate -s -L "$snapsize"M -n "$snaplv" "$vg/$lv"
		if [ $? -ne 0 ]; then
			log err "error $lvdev: cannot create snapshot for check"
			continue
		fi
		checkdev="/dev/$vg/$snaplv"
	fi

	if perform_check "$checkdev" "$fstype" "$errlog"; then
		log info "$lvdev: Background check succeeded."
		try_delay_checks "$lvdev" "$fstype"
		rm -f "$errlog"
	else
		log err "error $lvdev: Background check failed! Run offline!"
		log err "error $lvdev: full log of check saved in $errlog"
		try_force_check "$lvdev" "$fstype"

		if [ "$EMAIL" ]; then
			(
			cat <<- EMAIL
			The filesystem on $lvdev failed its periodic check
			(done on a snapshot, not the actual filesystem), and
			should be taken offline as soon as possible to be
			repaired.  Otherwise, the kernel may remount the
			filesystem read-only, or reboot, if it hits the
			detected corruption.
			
			A log of the failed check is shown below.

			EMAIL
			cat "$errlog"
			) | $NOCHECK mail -s "Fsck $lvdev failed" $EMAIL
		fi
	fi

	[ -z "$NOCHECK" ] && sync && sleep 5 && sync
	[ -n "$snaplv" ] && $NOCHECK lvremove -f "/dev/$vg/$snaplv"
}

# check whether the machine is on AC power: if not, skip fsck
on_ac_power || exit 0

# parse lvscan output, removing single quotes around  LV names
([ -n "$*" ] && echo "$@" || ( lvscan 2>&1 | awk -F "'" '/ACTIVE/ { print $2 }' )) | while read DEV; do
	if [ ! -b "$DEV" ]; then
		if [ ! -e "$DEV" ]; then
			log info "skip $DEV: no longer exists."
		else
			log info "skip $DEV: not a block device."
		fi
		continue
	fi

	# get the FS type: blkid prints TYPE="blah" unless -o value is used
	FSTYPE=$(blkid -s TYPE -o value "$DEV")
	if [ -z "$FSTYPE" ]; then
		log info "skip $DEV: can't determine device type."
		continue
	fi

	# get the volume group and logical volume names
	VG=$(echo $(lvs --noheadings -o vg_name "$DEV"))
	LV=$(echo $(lvs --noheadings -o lv_name "$DEV"))

	# get the free space and LV size (in megs), guess at the snapshot size,
	# and see how much the admin will let us use (keeping MINFREE available)
	SPACE=$(lvs --noheadings --nosuffix --units M -o vg_free "$DEV" |
		cut -d. -f1)
	SIZE=$(lvs --noheadings --nosuffix --units M -o lv_size "$DEV" |
		cut -d.  -f1)
	SNAPSIZE=$((SIZE / 500))
	AVAIL=$((SPACE - MINFREE))

	# if we don't even have MINSNAP space available, skip the LV
	if [ "$MINSNAP" -gt "$AVAIL" -o "$AVAIL" -le 0 ]; then
		log warning "skip $DEV: need ${MINSNAP}MB free in volume group."
		continue
	fi

	# make snapshot large enough to handle e.g. journal and other updates
	[ "$SNAPSIZE" -lt "$MINSNAP" ] && SNAPSIZE="$MINSNAP"

	# limit snapshot to available space (VG space minus min-free)
	[ "$SNAPSIZE" -gt "$AVAIL" ] && SNAPSIZE="$AVAIL"

	# don't need to check SNAPSIZE: MINSNAP <= AVAIL, MINSNAP <= SNAPSIZE,
	# SNAPSIZE <= AVAIL, combined, means SNAPSIZE must be between MINSNAP
	# and AVAIL, which is what we need -- assuming AVAIL > 0
	check_fs "$VG" "$LV" "$FSTYPE" "$SNAPSIZE"
done

--Apple-Mail=_3FEB7FD1-A254-4ECA-9CC9-A67C96852C0E--

--Apple-Mail=_469AA791-B39B-4E4C-AEA9-C77EF2ACF54E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaKcWrpIg59Q01vtYRAp2+AJ9mScvz6gzNwABryFZhE+o5658TRgCfcGYv
JqUGD/xgarjawD4Ujky5M58=
=QSEn
-----END PGP SIGNATURE-----

--Apple-Mail=_469AA791-B39B-4E4C-AEA9-C77EF2ACF54E--
