From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 0/2] e2fsprogs: update mkfs defaults
Date: Wed, 16 Feb 2011 15:12:50 -0700
Message-ID: <AC6734D9-917B-419C-9308-606C919D5F5D@dilger.ca>
References: <4D5C1380.2020602@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: multipart/mixed; boundary=Apple-Mail-108--387892788
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:63143 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab1BPWMw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Feb 2011 17:12:52 -0500
In-Reply-To: <4D5C1380.2020602@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail-108--387892788
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On 2011-02-16, at 11:12, Eric Sandeen wrote:
> Anaconda (the Fedora/RHEL installer) had been "fixing up" extN =
filesystems it created by setting the max mount count and check interval =
to 0, as well as adding user_xattr to filesystem mount options.
>=20
> As part of their efforts to stop special-casing around upstream =
defaults, they've removed these changes upstream.
>=20
> However, I'd like to at least propose that these changes be made =
default.

I'd really prefer instead that the "lvcheck" script be included into the =
distro, instead of changing mke2fs.  That achieves the same end result =
(periodic scrubbing of the filesystem to look for hidden errors), =
without introducing boot-time delays.  Given the size of disks today and =
the undetected bit-error-rate (somewhere around 1/10^15 bits or 12TB), I =
think it is important that there be automated scrubbing of the =
filesystem.

I think the best place to put that script would be in the lvm tools =
(since it is applicable to multiple filesystems), which I think Eric has =
the most leverage in getting accepted (I've been but I'd be OK including =
it with e2fsprogs if there is pushback on that.

> The forced fsck often comes at unexpected and inopportune moments, and =
even enterprise customers are often caught by surprise when this =
happens.  Because a filesystem with an error condition will be marked as =
requiring fsck anyway,

Any decent RAID array does background scrubbing for integrity =
verification, it doesn't just wait until there is an uncorrectable error =
detected in the block device.  If we can do something proactive to =
prevent this (i.e. lvcheck run by cron.weekly), it is worthwhile.

I think customers are equally surprised when their server fails =
(remount-ro/panic) due to the kernel detecting an error that might have =
been on disk for weeks or months.

> I submit that the time-based and mount-based checks are not =
particularly useful, and that administrators can schedule fscks on their =
own time, or tune2fs the enforced intervals if they so choose.

I think you are projecting your own self-enlightenment onto users ;-).  =
As we see on this list, there are many users that don't even back up =
their critical data, so IMHO taking out "safe by default" options is a =
step in the wrong direction.

Attached is my latest version of the lvcheck script, and a default =
/etc/lvcheck.conf script.  It's been enhanced to include a usage =
message, command-line option parsing to override default parameters, and =
the ability to check snapshots of ext3/4 filesystems with an external =
journal.


Cheers, Andreas




--Apple-Mail-108--387892788
Content-Disposition: attachment;
	filename=lvcheck
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="lvcheck"
Content-Transfer-Encoding: 7bit

#!/bin/bash
# lvcheck, version 1.1
# Maintainer: Bryan Kadzban <bryan.kadzban@is-a-geek.net>

# Other credits:
# Concept and original script by Theodore Tso <tyt...@mit.edu>
# on_ac_power is mostly from Debian's powermgmt-base package
# Lots of help (ideas, initial XFS/JFS support, etc.) from
# Andreas Dilger <adilger@sun.com>
# Better XFS support from Eric Sandeen <sandeen@redhat.com>

# Released under the GNU General Public License, either version 2 or
# (at your option) any later version.

# Overview:
# Run this from cron periodically (e.g. once per week). If the machine
# is on AC power, it will run the checks; otherwise they will all be
# skipped. (If the script can't tell whether the machine is on AC power,
# it will use a setting in the configuration file (/etc/lvcheck.conf) to
# decide whether to continue with the checks, or abort.)
#
# The script will then decide which logical volumes are active, and can
# therefore be checked via an LVM snapshot. Each of these LVs will be
# queried to find its last-check day, and if that was more than $INTERVAL
# days ago (where INTERVAL is set in the configuration file as well), or
# if the last-check day can't be determined, then the script will take an
# LVM snapshot of that LV and run fsck on the snapshot. The snapshot will
# be set to use 1/500 the space of the source LV. After fsck finishes,
# the snapshot is destroyed. (Snapshots are checked serially.)
#
# Any LV that passes fsck should have its last-check time updated (in
# the real superblock, not the snapshot's superblock); any LV whose
# fsck fails will send an email notification to a configurable user
# ($EMAIL). This $EMAIL setting is optional, but its use is highly
# recommended, since if any LV fails, it will need to be checked
# manually, offline. Relevant messages are also sent to syslog.

# Set default values for configuration params. Changes to these values will
# be overwritten on an upgrade! To change these values, edit /etc/lvcheck.conf.
EMAIL='root'
INTERVAL=30
AC_UNKNOWN="CONTINUE"
LOGDIR="/var/log/lvcheck"
MINSNAP=256
MINFREE=0

usage() {
	cat <<- USAGE
usage: lvcheck [-hn] [-e:email] [-i interval] [-l logdir]
               [-m minfree] [device ...]
Check integrity of filesystems using temporary snapshots of logical volumes.
Defaults can be set in /etc/lvcheck.conf, or overridden on command line.

	-e: email address to send error messages to (default $EMAIL)
	-h: print this help message
	-i: interval after which a check is done (default $INTERVAL days)
	-l: directory in which logs should be stored (default $LOGDIR)
	-m: minimum free space to leave in volume group (default $MINFREE MB)
	-n: do not actually perform a check, just print what would be done 
	device: one or more LVs to check (default: all LVs with filesystems)
USAGE
}

while getopts "e:hi:l:m:n" opt $*; do
	case $opt in
		e) EMAIL=$OPTARG;;
		h) usage; exit 0;;
		i) INTERVAL=$OPTARG;;
		l) LOGDIR=$OPTARG;;
		m) MINFREE=$OPTARG;;
		n) NOCHECK="echo";;
		\?) usage; exit 1;;
	esac
done
shift $((OPTIND - 1))

# pull in configuration -- overwrite the defaults above if the file exists
[ -r /etc/lvcheck.conf ] && . /etc/lvcheck.conf
CHECKPATH=$(dirname "$0" | sed -e 's:/s*bin::')
[ -r $CHECKPATH/etc/lvcheck.conf ] && . $CHECKPATH/etc/lvcheck.conf

[ -d "$LOGDIR" ] || mkdir -p "$LOGDIR"
if [ ! -d "$LOGDIR" ]; then
	LOGDIR=${tmp:-/tmp}
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
		:
		;;
	*)
		echo "error: unknown log severity '$sev'"
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
		MAX=$(dumpe2fs -h 2>&1 "$dev"|grep "Maximum mount"|cut -d: -f2)
		# If the user has mount-count dependent checking disabled,
		# we have to overwrite the last checked time.  Otherwise,
		# it is preferable to preserve this for debugging and we
		# force the mount count high to force the check.
		if [ $MAX -lt 1 ]; then
			$NOCHECK tune2fs -T 19700201 "$dev"
		else
			$NOCHECK tune2fs -C 16000 "$dev"
		fi
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
		log debug "skip $dev: is an external journal."
		return 1
		;;
	swap)
		log debug "skip $dev: is a swap device."
		return 1
		;;
	*)
		log warning "skip $dev: can't check $fstype passively: assuming OK."
		;;
	esac

	return 0
}

# check the FS on $1 passively, saving output to $3.
function perform_check() {
	local dev="$1"
	local fstype="$2"
	local errlog="$3"

	case "$fstype" in
	ext2|ext3|ext4)
		if dumpe2fs -h "$dev" 2>&1| grep -q "Journal device"; then
			log debug "$dev: removing external journal"
			$NOCHECK tune2fs -U time $dev 2>&1 | tail -n +2
			$NOCHECK tune2fs -O has_journal $dev 2>&1 | tail -n +2
		fi

		# first clear the orphaned-inode list, to avoid unnecessary FS
		# changes in the next step (which would cause an "error" exit
		# from e2fsck). -C 0 is present for cases where the script is
		# run interactively (logsave -s strips out the progress bar).
		# ignore the return status of this e2fsck, as it doesn't matter.
		$NOCHECK nice logsave -as "$errlog" e2fsck -p -C 0 "$dev"

		# then do the real check; -y is here to give more info on any
		# errors that may be present on the FS, in the log file. the
		# snapshot is writable, so it shouldn't break anything if
		# e2fsck changes it.
		$NOCHECK nice logsave -as "$errlog" e2fsck -fy -C 0 "$dev"
		return $?
		;;
	reiserfs)
		echo Yes | $NOCHECK nice logsave -as "$errlog" fsck.reiserfs --check "$dev"
		# apparently can't fail? let's hope not...
		return 0
		;;
	xfs)
		$NOCHECK nice logsave -as "$errlog" xfs_repair -n "$dev"
		return $?
		;;
	jfs)
		$NOCHECK nice logsave -as "$errlog" fsck.jfs -fn "$dev"
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
	local snaplv="$snaplvbase-$(date +'%Y%m%d')"

	# clean up any left-over snapshot LVs
	for lvtemp in /dev/$vg/$snaplvbase*; do
		if [ -e "$lvtemp" ]; then
			# Assume script won't run more than one at a time?
			log warning "stale $lvtemp: trying to remove old snapshot."

			if ! lvremove "$lvtemp"; then
				log err "error $lvtemp: could not delete."
				return 1
			fi
		fi
	done

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

	# create new snapshot LV
	modprobe -q dm-snapshot
	$NOCHECK lvcreate -s -L "$snapsize"M -n "$snaplv" "$vg/$lv"
	if [ $? -ne 0 ]; then
		log err "error $lvdev: unable to create snapshot for check"
		continue
	fi

	if perform_check "/dev/$vg/$snaplv" "$fstype" "$errlog"; then
		log info "$lvdev: Background check succeeded."
		try_delay_checks "$lvdev" "$fstype"
		rm -f "$errlog"
	else
		log err "error $lvdev: Background check failed! Run offline!"
		try_force_check "$lvdev" "$fstype"

		if [ "$EMAIL" ]; then
			(
			cat <<- EMAIL
			The filesystem on $lvdev failed its periodic
			check (done on a filesystem snapshot, not the actual
			filesystem), and should be taken offline as soon as
			possible to be repaired.  Otherwise, the kernel may
			remount the filesystem read-only, or reboot, if it hits
			the detected corruption.
			
			A log of the failed check is shown below.

			EMAIL
			cat "$errlog"
			) | $NOCHECK mail -s "Fsck $lvdev failed" $EMAIL
		fi
	fi

	[ -z "$NOCHECK" ] && sync && sleep 5 && sync
	$NOCHECK lvremove -f "/dev/$vg/$snaplv"
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

	# get the FS type: blkid prints TYPE="blah"
	FSTYPE=$(blkid -s TYPE "$DEV" | cut -d'=' -f2 | tr -d \"\ )
	if [ -z "$FSTYPE" ]; then
		log info "skip $DEV: can't determine device type."
		continue
	fi

	# get the volume group and logical volume names
	VG=$(echo $(lvs --noheadings -o vg_name "$DEV"))
	LV=$(echo $(lvs --noheadings -o lv_name "$DEV"))

	# get the free space and LV size (in megs), guess at the snapshot size,
	# and see how much the admin will let us use (keeping MINFREE available)
	SPACE=$(lvs --noheadings --units M -o vg_free "$DEV"|cut -d. -f1)
	SIZE=$(lvs --noheadings --units M -o lv_size "$DEV"|cut -d.  -f1)
	SNAPSIZE=$(($SIZE / 500))
	AVAIL=$(($SPACE - $MINFREE))

	# if we don't even have MINSNAP space available, skip the LV
	if [ "$MINSNAP" -gt "$AVAIL" -o "$AVAIL" -le 0 ]; then
		log warning "skip $DEV: need ${MINSNAP}MB free in volume group."
		continue
	fi

	# make snapshot large enough to handle e.g. journal and other updates
	[ "$SNAPSIZE" -lt "$MINSNAP" ] && SNAPSIZE="$MINSNAP"

	# limit snapshot to available space (VG space minus min-free)
	[ "$SNAPSIZE" -gt "$AVAIL" ] && SNAPSIZE="$AVAIL"

	# don't need to check SNAPSIZE again: MINSNAP <= AVAIL, MINSNAP <= SNAPSIZE,
	# and SNAPSIZE <= AVAIL, combined, means SNAPSIZE must be between MINSNAP
	# and AVAIL, which is what we need -- assuming AVAIL > 0

	check_fs "$VG" "$LV" "$FSTYPE" "$SNAPSIZE"
done 

--Apple-Mail-108--387892788
Content-Disposition: attachment;
	filename=lvcheck.conf
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="lvcheck.conf"
Content-Transfer-Encoding: 7bit

#!/bin/sh
# lvcheck configuration file

# This file follows the pattern of sshd_config:
# default values are shown here, commented-out.

# EMAIL: Address to send failure notifications to. If empty, failure
# notifications will not be sent.
#EMAIL='root'

# INTERVAL: Days to wait between checks. All LVs use the same INTERVAL,
# but the "days since last check" value can be different per LV, since
# that value is stored in the filesystem superblock.
#INTERVAL=30

# AC_UNKNOWN: Whether to run the fsck.* checks if the script can't determine
# whether the machine is on AC power. Laptop users will want to set this to
# ABORT, while server and desktop users will probably want to set this to
# CONTINUE.  Those are the only two valid values.
#AC_UNKNOWN="CONTINUE"

# MINSNAP: Minimum snapshot size to take, in megabytes. The default size is
# 1/500 the size of the logical volume, but if that is less than MINSNAP, the
# script will use MINSNAP instead. This should be large enough to handle e.g.
# journal updates, and other disk changes that require (semi-)constant space.
#MINSNAP=256

# MINFREE: Minimum amount of space (in megabytes) to keep free in each volume
# group when creating snapshots.
#MINFREE=0

--Apple-Mail-108--387892788--
