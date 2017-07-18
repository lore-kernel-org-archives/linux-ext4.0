From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] tune2fs: remove dire warning about check intervals
Date: Tue, 18 Jul 2017 16:28:16 -0600
Message-ID: <CD3439EC-F272-4172-8C7F-229C6DAE06EC@dilger.ca>
References: <ce6bff3e-49f4-2bed-67ce-a7be604ce1cf@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_6533059E-B781-4DED-9437-B04FB1D738F6";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        =?utf-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35626 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751962AbdGRW2Y (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Jul 2017 18:28:24 -0400
Received: by mail-it0-f67.google.com with SMTP id v193so3320154itc.2
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 15:28:23 -0700 (PDT)
In-Reply-To: <ce6bff3e-49f4-2bed-67ce-a7be604ce1cf@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_6533059E-B781-4DED-9437-B04FB1D738F6
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_5BE604A2-4AEB-436E-8EB7-54E4D6C2BD71"


--Apple-Mail=_5BE604A2-4AEB-436E-8EB7-54E4D6C2BD71
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 18, 2017, at 3:10 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>=20
> Time & mount-count based checks have been off by default for quite =
some
> time now, but the dire warning about disabling them remains in the
> tune2fs manpage, which is confusing.  We did "strongly consider
> the consequences" and disabled it by default, no need to scare the
> user about it now.

Sigh, I still think this is going in the wrong direction.  I'm happily
running a weekly e2fsck on a snapshot of the filesystem, and then reset
the time and mount-count fields in the superblock with tune2fs.  That
way I never see any warnings, or have slow boots because of a scan, but
I'm also notified if there are ever problems on the filesystem (which
happens occasionally, since I'm sometimes running experimental code).

Since virtually everyone is using MD/LVM devices these days, I don't
think that is hard to do.  I offered up my "lvcheck" script a few times,
but nobody at RH or on the DM team seemed interested at the time...
I'd also be happy if there was some other similar mechanism included =
with
the distro to do periodic background checks of the filesystem, rather
than letting them find any problem at some random time.  This is pretty
standard for RAID systems, I think it makes sense for the filesystem =
too.

Cheers, Andreas

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>=20
> diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
> index 5c885f9..a8cacc7 100644
> --- a/misc/tune2fs.8.in
> +++ b/misc/tune2fs.8.in
> @@ -134,17 +134,6 @@ Staggering the mount-counts at which filesystems =
are forcibly
> checked will avoid all filesystems being checked at one time
> when using journaled filesystems.
> .sp
> -You should strongly consider the consequences of disabling
> -mount-count-dependent checking entirely.  Bad disk drives, cables,
> -memory, and kernel bugs could all corrupt a filesystem without
> -marking the filesystem dirty or in error.  If you are using
> -journaling on your filesystem, your filesystem will
> -.B never
> -be marked dirty, so it will not normally be checked.  A
> -filesystem error detected by the kernel will still force
> -an fsck on the next reboot, but it may already be too late
> -to prevent data loss at that point.
> -.sp
> See also the
> .B \-i
> option for time-dependent checking.
>=20


Cheers, Andreas





--Apple-Mail=_5BE604A2-4AEB-436E-8EB7-54E4D6C2BD71
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
# Ideas, initial XFS/JFS/ZFS support: Andreas Dilger <adilger@dilger.ca>
# Better XFS support: Eric Sandeen <sandeen@redhat.com>
# Updated and polished: Bryan Kadzban <bryan.kadzban@is-a-geek.net>
# on_ac_power is mostly from Debian's powermgmt-base package

# Released under the GNU General Public License, either version 2 or
# (at your option) any later version.

# Overview:
# Run this from cron periodically (e.g. link to /etc/cron.weekly/lvcheck).
# If the machine is on AC power, it will run the checks; otherwise they will
# all be skipped. If the script can't tell whether the machine is on AC power,
# it will use $AC_UNKNOWN in the configuration file /etc/lvcheck.conf to
# decide whether to continue with the checks, or abort.
#
# The script will then decide which logical volumes are active, and can
# therefore be checked via an LVM snapshot. Each of these LVs will be
# queried to find its last-check day, and if that was more than $INTERVAL
# days ago (where $INTERVAL is set in the configuration file as well), or
# if the last-check day can't be determined, then the script will take an
# LVM snapshot of that LV and run fsck on the snapshot. The snapshot will
# be set to use 1/500 the space of the source LV. After fsck finishes,
# the snapshot is destroyed. (Snapshots are checked serially.)
#
# Any LV that passes fsck should have its last-check time updated (in the
# real superblock, not the snapshot's superblock); any LV whose fsck fails
# will send an email notification to a configurable user ($EMAIL). This $EMAIL
# setting is optional, but its use is highly recommended, since if any LV
# fails, it will need to be checked manually, offline. Relevant messages are
# also sent to syslog.

# Set default values for configuration params. Changes to these values will be
# overwritten on an upgrade!  To change these values, edit /etc/lvcheck.conf.
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
	zfs)
		#log info "$dev: starting full scrub"
		#$NOCHECK zpool scrub $(echo $dev | cut -d/ -f1)
		#return $?
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

	# don't need to check SNAPSIZE again: MINSNAP <= AVAIL, MINSNAP <= SNAPSIZE,
	# and SNAPSIZE <= AVAIL, combined, means SNAPSIZE must be between MINSNAP
	# and AVAIL, which is what we need -- assuming AVAIL > 0

	check_fs "$VG" "$LV" "$FSTYPE" "$SNAPSIZE"
done

--Apple-Mail=_5BE604A2-4AEB-436E-8EB7-54E4D6C2BD71--

--Apple-Mail=_6533059E-B781-4DED-9437-B04FB1D738F6
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZbouBpIg59Q01vtYRApX4AJ4zJrLGpv2itWROZAywwwN+3WmEzgCfbQ47
Asm6V8IeEA5fZXcIsvwNtf4=
=y3/N
-----END PGP SIGNATURE-----

--Apple-Mail=_6533059E-B781-4DED-9437-B04FB1D738F6--
