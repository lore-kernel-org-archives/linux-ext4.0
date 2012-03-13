From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v3 00/54] e2fsprogs: Add metadata checksumming
Date: Mon, 12 Mar 2012 17:41:17 -0700
Message-ID: <20120313004117.GV15164@tux1.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com> <20120309223728.GD5635@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36347 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601Ab2CMAlj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Mar 2012 20:41:39 -0400
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 12 Mar 2012 20:41:37 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 7F25E6E8051
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 20:41:19 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2D0fJBL241392
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 20:41:19 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2D0fITq007743
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 20:41:19 -0400
Content-Disposition: inline
In-Reply-To: <20120309223728.GD5635@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 09, 2012 at 05:37:28PM -0500, Ted Ts'o wrote:
> I've imported this patch set into a guilt patch series, which makes it
> easier for me to work on the patch series and make minor tweaks so
> that I can get interim e2fsprogs support up and going (and at least
> building and passing the regression test suite) so I can test and play
> with the kernel side patches.
> 
> People who want to follow along can look here:
> 
> 	https://github.com/tytso/e2fsprogs-cksum-patch-queue
> 
> ... or at the read-only git tree which you can find here:
> 
> 	git://github.com/tytso/e2fsprogs-cksum-patch-queue.git
> 
> With these large patch series it's easier for me to make blanket
> changes to fix minor annoyances (such as commit descriptions which are
> too wide and make "git log" displays hard to follow) or to merge
> patches that are too fine grained[1] together.
> 
> Open source project management theory says that it's better to ask the
> submitter to do all of this work, but given certain special
> circumstances in this particular case, I decided to make the cleanup
> work that I do publicly visible, as a compromise.  I'll also make some
> comments about some of the issues I find (and fix) by replying to the
> emails on this mail thread.
> 
> This patch series will be maintained so that it can be applied to the
> top-most "maint" branch of e2fsprogs.
> 
> Darrick, if you have time and would like to make further changes, ping
> me off-line and I would be happy to give you write access to the
> github tree.

Here's a copy of my testing script....

--D

#!/bin/bash -e

# ext4 metadata checksum test script
# licensed under gplv2
# copyright (c) 2011 ibm corporation.  all rights reserved.

function print_help {
	echo "Usage: $0 [-d device] [-m mountpoint] [-v verbs] [-o mkfs_opts] [-e mkfs_features] [-l] [-n] [-p e2fsprogs_path] [-z mount_opts] [-q]"
	echo "-l	Use valgrind"
	echo "-n	No checksumming"
	echo "-q	Enable MMP"
	echo "verbs is any combination of:"
	echo "${VERBS}"
	exit 1
}

type attr || (echo "Must install attr program."; exit 5)
type /usr/bin/time || (echo "Must install time program."; exit 5)

DEV=/dev/vda
MNT=/mnt
VALGRIND="valgrind" # --leak-check=full --show-reachable=yes"
VALGRIND=
MKFS_OPTS="64bit"
FUZZ="Fuzzy Wuzzy was a bear. Fuzzy Wuzzy had no hair. I guess he wasn't fuzzy, was he?"
VERBS="$(grep ^function $0 | grep '_test ' | awk '{print $2}')"
E2FSPROGS=/djwong/e2fsprogs-csum

while getopts "p:d:m:v:z:o:e:l" OPTION; do
	case "$OPTION" in
	"z")
		MOUNT_OPTS="${OPTARG}"
		;;
	"d")
		DEV="${OPTARG}"
		;;
	"m")
		MNT="${OPTARG}"
		;;
	"v")
		VERBS="${OPTARG}"
		;;
	"o")
		MKFS_OPTS="${OPTARG}"
		;;
	"q")
		MKFS_OPTS="${MKFS_OPTS},mmp"
		;;
	"e")
		MKFS_FEATURES="${OPTARG}"
		;;
	"l")
		VALGRIND=valgrind
		;;
	"n")
		NO_CSUM=1
		;;
	"p")
		E2FSPROGS="${OPTARG}"
		;;
	*)
		print_help
		exit 1
		;;
	esac
done
if [ ! -z "${MKFS_OPTS}" ]; then
	MKFS_OPTS="-O ${MKFS_OPTS}"
fi
if [ ! -z "${MKFS_FEATURES}" ]; then
	MKFS_FEATURES="-E ${MKFS_FEATURES}"
fi
if [ ! -z "${MOUNT_OPTS}" ]; then
	MOUNT_OPTS="-o ${MOUNT_OPTS}"
fi

function msg {
	if [ -x /usr/bin/figlet ]; then
		figlet -f mono9 -w 132 $*
		echo $* > /dev/ttyprintk
	else
		echo $* | tee /dev/ttyprintk
	fi
}

if [ ! -b "${DEV}" ]; then
	echo "${DEV} is not a block device?"
	exit 0
fi

umount $MNT || true
rmmod ext4 || true
rmmod jbd2 || true
rmmod crc32c || true
rmmod crc32c-intel || true

dmesg -c > /dev/null
trap 'echo "test ended" | tee /dev/ttyprintk; dmesg'  EXIT
msg "$0: Begin test @ $(date)"
set -x

#####################################
function simple_test {
msg "Create fs with files, no checksums"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 $MKFS_OPTS $MKFS_FEATURES

mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
cp -pRd /etc/ $MNT/
mkdir -p $MNT/fragged
dd if=/dev/zero bs=4k count=1 of=$MNT/fragged/fragfile
sync
set +x
echo + frag
for i in `seq 1 8`; do
	echo moo > $MNT/fragged/a$i
	sync
	dd if=/dev/zero bs=4k count=1 >> $MNT/fragged/fragfile
	sync
done
set -x
echo moo > $MNT/ea_file
set +x
echo + set_ea
for i in `seq -w 1 100`; do
	attr -s $i -V $i $MNT/ea_file
done
set -x
umount $MNT

#########################################
msg "Enable checksums"
test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

# Walk fs looking for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT -type f -o -type d -print0 | xargs -0 touch
attr -l $MNT/ea_file
umount $MNT

# Copy stuff into fs to create inodes w/ checksums
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
mkdir $MNT/moo
cp -pRd /etc/ $MNT/moo/
umount $MNT

# Create htree dir
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
mkdir -p $MNT/bigdir2
set +x
echo + htree2
for i in `seq 1 256`; do
	echo moo > "$MNT/bigdir2/$(echo "$(date)_$i" | md5sum)"
done
set -x
umount $MNT

########################################
msg "Mess with extent tree"
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
set +x
echo + frag
for i in `seq 9 18`; do
	echo moo > $MNT/fragged/a$i
	sync
	dd if=/dev/zero bs=4k count=1 >> $MNT/fragged/fragfile
	sync
done
set -x
umount $MNT

# Keep rewriting the extent tree just to drive it crazy
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
set +x
echo + frag
for i in `seq 19 28`; do
	echo moo > $MNT/fragged/a$i
	sync
	dd if=/dev/zero bs=4k count=1 >> $MNT/fragged/fragfile
	sync
done
set -x
umount $MNT

# Truncate the file
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
truncate -s -64k $MNT/fragged/fragfile
umount $MNT

# Keep rewriting the extent tree just to drive it crazy
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
set +x
echo + frag
for i in `seq 29 38`; do
	echo moo > $MNT/fragged/a$i
	sync
	dd if=/dev/zero bs=4k count=1 >> $MNT/fragged/fragfile
	sync
done
set -x
umount $MNT

# Re-walk fs looking for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT -type f -print0 | xargs -0 cat > /dev/null
umount $MNT/

# Check fs again
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

##################################################
msg "Disable checksums"
${E2FSPROGS}/misc/dumpe2fs $DEV > /root/before
test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O ^metadata_csum $DEV
${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
${E2FSPROGS}/misc/dumpe2fs $DEV > /root/after

# Walk fs looking for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT -type f -o -type d -print0 | xargs -0 touch
umount $MNT

# Copy stuff into fs to create inodes w/o checksums
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
mkdir $MNT/oom
cp -pRd /etc/ $MNT/oom/
umount $MNT

# Re-walk fs looking for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT -type f -print0 | xargs -0 cat > /dev/null
umount $MNT/

# Check fs again
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

####################################
msg "Re-enable checksums"
test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true

# Walk fs looking for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT -type f -o -type d -print0 | xargs -0 touch
umount $MNT

# Remove file
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
dd if=/dev/zero of=$MNT/bigfile bs=1024k count=16
umount $MNT
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
rm -rf $MNT/bigfile
umount $MNT

#############################
# create xattrs
msg "mess with xattrs"
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
echo attrs > $MNT/attrfile
set +x
echo + set_xattrs
for i in `seq -w 1 100`; do
	attr -s $i -V $i $MNT/attrfile
done
set -x
attr -l $MNT/attrfile
umount $MNT

# Check fs one last time
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
}

#################################
function corrupt_inode_csum_test {
msg "Deliberately corrupt inode checksum"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 $MKFS_OPTS $MKFS_FEATURES -b 4096 -I 4096 -E lazy_itable_init=1
test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true

$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
mkdir $MNT/filldir
set +x
echo + filldir
for i in `seq 1 10000`; do
	echo moo > $MNT/filldir/$i
done
set -x
cp -pRd /etc/ $MNT/
cp -pRd /etc/ $MNT/moo
umount $MNT

$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
set +x
echo + corrupt_inode_csum
FIRST_GROUP=1
$VALGRIND ${E2FSPROGS}/misc/dumpe2fs $DEV | grep 'Inode table' | sed -e 's/^.*at \([0-9]*\)-\([0-9]*\).*$/\1 \2/g' | while read start end; do
	if [ $FIRST_GROUP -gt 0 ]; then
		FIRST_GROUP=0
		continue
	fi
	echo -en " $start"
	if [ $((end - start)) -gt 4 ]; then
		end=$((start + 4))
	fi
	seq $start $end | while read block; do
		offset=$(( (start * (4096 / 4)) + 31 ))
		yes "${FUZZ}" | dd of=$DEV bs=4 seek=$offset count=1 > /dev/null 2> /dev/null
	done
done
echo
set -x

# Walk fs looking for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
(find $MNT -type f -o -type d -print0 | xargs -0 touch) || true
umount $MNT

# Repair fs
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -y $DEV || true

# Walk fs looking for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT -type f -o -type d -print0 | xargs -0 touch
umount $MNT

# Check fs one last time
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
}

#################################
function corrupt_inode_test {
msg "Deliberately corrupt inode table"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 $MKFS_OPTS $MKFS_FEATURES
test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true

$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
mkdir $MNT/filldir
set +x
echo + filldir
for i in `seq 1 10000`; do
	echo moo > $MNT/filldir/$i
done
set -x
cp -pRd /etc/ $MNT/
cp -pRd /etc/ $MNT/moo
umount $MNT

$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

set +x
echo + corrupt_inode_table
BLOCKSIZE=$(${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep 'Block size:' | sed -e 's/^.* \([0-9]*\)$/\1/g')
BLOCKS=$(${E2FSPROGS}/misc/dumpe2fs $DEV -h | grep 'Inode blocks per group:' | sed -e 's/^.* \([0-9]*\)$/\1/g')
FIRST_GROUP=1
$VALGRIND ${E2FSPROGS}/misc/dumpe2fs $DEV | grep 'Inode table' | sed -e 's/^.*at \([0-9]*\)-.*$/\1/g' | while read f; do
	if [ $FIRST_GROUP -gt 0 ]; then
		FIRST_GROUP=0
		continue
	fi
	echo -en " $f"
	yes "${FUZZ}" | dd of=$DEV bs=$BLOCKSIZE seek=$f count=$BLOCKS > /dev/null 2> /dev/null
done
echo
set -x

# Walk fs looking for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
(find $MNT -type f -o -type d -print0 | xargs -0 touch) || true
umount $MNT

# Repair fs
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -y $DEV || true

# Walk fs looking for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT -type f -o -type d -print0 | xargs -0 touch
umount $MNT

# Check fs one last time
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
}

#################################
function corrupt_ibitmap_test {
msg "Deliberately corrupt inode bitmap"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 $MKFS_OPTS $MKFS_FEATURES
test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true

mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
cp -pRd /etc/ $MNT/
cp -pRd /etc/ $MNT/moo
umount $MNT

set +x
echo + corrupt_inode_bitmap
BLOCKSIZE=$(${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep 'Block size:' | sed -e 's/^.* \([0-9]*\)$/\1/g')
FIRST_GROUP=1
$VALGRIND ${E2FSPROGS}/misc/dumpe2fs $DEV | grep 'Inode bitmap at' | sed -e 's/^.*Inode bitmap at //g' -e 's/ .*$//g' | while read f; do
	if [ $FIRST_GROUP -gt 0 ]; then
		FIRST_GROUP=0
		continue
	fi
	echo -en " $f"
	yes "${FUZZ}" | dd of=$DEV bs=$BLOCKSIZE seek=$f count=1 > /dev/null 2> /dev/null
done
echo
set -x

# Walk fs looking for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
(find $MNT -type d | while read dir; do
	echo "${dir}/file1.$$"
	echo test > "${dir}/file1.$$"
	if [ ! -e "${dir}/file1.$$" ]; then
		# Beat on it a few more times just for good measure
		for i in `seq 1 8`; do
			echo test > "${dir}/file1.$$"
		done
		break
	fi
done) || true
umount $MNT

# Repair fs
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -y $DEV || true
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fy $DEV || true

# Walk fs looking for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
ITER=0
find $MNT -type d | while read dir; do echo "${dir}/file2.$$"; echo test > "${dir}/file2.$$"; if [ $ITER -gt 20 ]; then break; fi; ITER=$((ITER + 1)); done
umount $MNT

# Check fs one last time
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
}

#################################
function corrupt_bbitmap_test {
msg "Deliberately corrupt block bitmap"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 $MKFS_OPTS $MKFS_FEATURES
test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true

mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
cp -pRd /etc/ $MNT/
cp -pRd /etc/ $MNT/moo
umount $MNT

set +x
echo + corrupt_block_bitmap
BLOCKSIZE=$(${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep 'Block size:' | sed -e 's/^.* \([0-9]*\)$/\1/g')
FIRST_GROUP=1
$VALGRIND ${E2FSPROGS}/misc/dumpe2fs $DEV | grep 'Block bitmap at' | sed -e 's/^.*Block bitmap at //g' -e 's/ .*$//g' | while read f; do
	if [ $FIRST_GROUP -gt 0 ]; then
		FIRST_GROUP=0
		continue
	fi
	echo -en " $f"
	yes "${FUZZ}" | dd of=$DEV bs=$BLOCKSIZE seek=$f count=1 > /dev/null 2> /dev/null
done
echo
set -x

# Walk fs looking for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
(find $MNT -type d | while read dir; do echo "${dir}/file1.$$"; echo test > "${dir}/file1.$$"; if [ ! -e "${dir}/file1.$$" ]; then break; fi; done) || true
umount $MNT

# Repair fs
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -y $DEV || true
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -y $DEV || true

# Walk fs looking for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
ITER=0
find $MNT -type d | while read dir; do echo "${dir}/file2.$$"; echo test > "${dir}/file2.$$"; if [ $ITER -gt 20 ]; then break; fi; ITER=$((ITER + 1)); done
umount $MNT

# Check fs one last time
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
}

#######################
function corrupt_extent_head_test {
msg "Corrupt an extent header"
BLK_SZ=2048
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,mmp,metadata_csum -b $BLK_SZ
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
SZ=$(df -k $MNT | awk '{print $4}' | tail -1)
fallocate -l $((SZ * 9 / 10))k $MNT/ouch
umount $MNT

set +x
echo + corrupt_extent_tree
echo 'ex /ouch' | ${E2FSPROGS}/debugfs/debugfs $DEV | grep -v -- '-.*-' | grep "^[ 0-9]" | awk '{print $8}' | while read block; do
	yes "${FUZZ}" | dd of=$DEV bs=$BLK_SZ seek=$block count=1 > /dev/null 2> /dev/null
done
set -x

# Look for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
echo moo >> $MNT/ouch || true
umount $MNT

# Repair
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -y $DEV || true

# Look for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
echo oom >> $MNT/ouch
umount $MNT

# Check fs one last time
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
}

#######################
function corrupt_extent_test {
msg "Destroy an extent entry"
BLK_SZ=2048
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,mmp,metadata_csum -b $BLK_SZ
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
SZ=$(df -k $MNT | awk '{print $4}' | tail -1)
fallocate -l $((SZ * 9 / 10))k $MNT/ouch
umount $MNT

echo 'stat /ouch' | ${E2FSPROGS}/debugfs/debugfs $DEV -n | cat -
set +x
echo + corrupt_extent_tree
echo 'ex /ouch' | ${E2FSPROGS}/debugfs/debugfs $DEV | grep -v -- '-.*-' | grep "^[ 0-9]" | awk '{print $8}' | while read block; do
	real_block=$(((block * (BLK_SZ / 16)) + 1))
	yes "${FUZZ}" | dd of=$DEV bs=16 seek=$real_block count=1 > /dev/null 2> /dev/null
done
set -x
echo 'stat /ouch' | ${E2FSPROGS}/debugfs/debugfs $DEV -n | cat -

# Look for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
echo moo >> $MNT/ouch || true
umount $MNT

# Repair
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -y $DEV || true

echo 'stat /ouch' | ${E2FSPROGS}/debugfs/debugfs $DEV -n | cat -

# Look for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
echo oom >> $MNT/ouch
umount $MNT

# Check fs one last time
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
}

#######################
function corrupt_extent_csum_test {
msg "Destroy an extent block csum"
BLK_SZ=2048
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,mmp,metadata_csum -b $BLK_SZ
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
SZ=$(df -k $MNT | awk '{print $4}' | tail -1)
fallocate -l $((SZ * 9 / 10))k $MNT/ouch
umount $MNT

echo 'ex /ouch' | ${E2FSPROGS}/debugfs/debugfs $DEV -n | cat -
set +x
echo + corrupt_extent_block_csum
echo 'ex /ouch' | ${E2FSPROGS}/debugfs/debugfs $DEV | grep -v -- '-.*-' | grep "^[ 0-9]" | awk '{print $8}' | while read block; do
	real_block=$((((block + 1) * (BLK_SZ / 16)) - 1))
	yes "${FUZZ}" | dd of=$DEV bs=16 seek=$real_block count=1 > /dev/null 2> /dev/null
done
set -x
echo 'ex /ouch' | ${E2FSPROGS}/debugfs/debugfs $DEV -n | cat -

# Look for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
echo moo >> $MNT/ouch || true
umount $MNT

# Repair
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -y $DEV || true

echo 'stat /ouch' | ${E2FSPROGS}/debugfs/debugfs $DEV -n | cat -

# Look for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
echo oom >> $MNT/ouch
umount $MNT

# Check fs one last time
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
}

#######################
function htree_test {
msg "Simple htree test"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,mmp,metadata_csum
msg "htree1"
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
set +x
echo + htree1
for i in 1; do
	for j in 1 2 3 4; do
		mkdir -p $MNT/$i/$j
		for k in `seq 1 24`; do
			FNAME=$(perl -e "printf(\"%.250s\\n\", \"_$k\" x 256);")
			echo moo > "$MNT/$i/$j/$FNAME"
		done
	done
	for k in `seq 1 32`; do
		FNAME=$(perl -e "printf(\"%.250s\\n\", \"_$k\" x 256);")
		echo moo > "$MNT/$i/$FNAME"
	done
done
set -x
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV

msg "htree2"
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT/1 > /dev/null
set +x
echo + htree2
for i in 2; do
	for j in 1 2 3 4; do
		mkdir -p $MNT/$i/$j
		for k in `seq 1 24`; do
			FNAME=$(perl -e "printf(\"%.250s\\n\", \"_$k\" x 256);")
			echo moo > "$MNT/$i/$j/$FNAME"
		done
	done
	for k in `seq 1 32`; do
		FNAME=$(perl -e "printf(\"%.250s\\n\", \"_$k\" x 256);")
		echo moo > "$MNT/$i/$FNAME"
	done
done
set -x
umount $MNT

$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV

msg "htree_del"
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
rm -rf $MNT/1 $MNT/2
umount $MNT

msg "multi level htree"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,mmp,metadata_csum -b 2048
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
mkdir $MNT/3
echo moo > $MNT/3/base.txt
set +x
echo + mltree
seq 1 5000 | while read f; do
	if [ $((f % 71)) -eq 0 ]; then
		echo -n "$f..."
	fi
	FNAME=$(perl -e "printf(\"%.250s\\n\", \"_$f\" x 256);")
	ln $MNT/3/base.txt $MNT/3/$FNAME
done
echo 
set -x
umount $MNT

$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV

msg "mlhtree delete"
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
rm -rf $MNT/3
umount $MNT

$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV
}

#########################
function corrupt_htree_test {
msg "corrupt htree"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,mmp,metadata_csum -b 2048
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
mkdir $MNT/3
echo moo > $MNT/3/base.txt
set +x
echo + htree
seq 1 10 | while read f; do
	FNAME=$(perl -e "printf(\"%.250s\\n\", \"_$f\" x 256);")
	ln $MNT/3/base.txt $MNT/3/$FNAME
done
set -x
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV || true

# now blast the root block
ROOT_BLK=$(echo 'stat /3' | ${E2FSPROGS}/debugfs/debugfs $DEV | grep EXTENTS -A1 | tail -1 | sed -e 's/^.*://g' -e 's/-.*$//g')
yes "${FUZZ}" | dd of=$DEV bs=8 seek=$(( ( (ROOT_BLK + 1) * 256) - 1 )) count=1 > /dev/null 2> /dev/null
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV || true

# walk looking for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT/3 > /dev/null || true
umount $MNT
# WARNING: The htree flag is now off!

# fix
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true

# rescan
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT/3 > /dev/null || true
umount $MNT

# check once more
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV

# inflate directory some more
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
mkdir -p $MNT/3
echo moo > $MNT/3/base.txt
set +x
echo + mltree_fuzz
seq 11 2000 | while read f; do
	if [ $((f % 71)) -eq 0 ]; then
		echo -n "$f..."
	fi
	FNAME=$(perl -e "printf(\"%.250s\\n\", \"_$f\" x 256);")
	ln $MNT/3/base.txt $MNT/3/$FNAME
done
set -x
umount $MNT

# now corrupt the secondary blocks
echo 'htree /3' | ${E2FSPROGS}/debugfs/debugfs $DEV | grep 'Number of entries' -B1 | grep block | sed -e 's/^.*block //g' | while read blocknr; do
	PBLK=$(echo "bmap /3 ${blocknr}" | ${E2FSPROGS}/debugfs/debugfs $DEV -f - | grep '^[0-9]')
	PBLK=$(( ($PBLK * 256) + 2))
	yes "${FUZZ}" | dd of=$DEV bs=8 seek=${PBLK} count=1  > /dev/null 2> /dev/null
done
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV || true

# walk looking for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT/3 > /dev/null || true
umount $MNT

# fix
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV || true
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true

# rescan
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT/3 > /dev/null || true
umount $MNT

# check once more
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV
}

#########################
function flat_dir_test {
msg "flat dir test"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,mmp,metadata_csum,^dir_index -b 2048
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
cp -pRdu /etc $MNT/a
cp -pRl $MNT/a $MNT/b
cp -pRl $MNT/a $MNT/c
cp -pRl $MNT/a $MNT/d
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV

msg "cat files"
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT/b -type f -print0 | xargs -0 cat > /dev/null
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV

msg "enlarge direntry"
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
set +x
echo + enbiggen dirents
# You need depth-first traversal here
find $MNT/b -depth | while read f; do
	mv $f $f.longer
done
set -x
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV

msg "rm file"
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT/b -type f -print0 | xargs -0 rm -rf
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV

msg "rm dir"
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
rm -rf $MNT/b
umount $MNT

$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV
}

#########################
function corrupt_flat_dir_test {
msg "corrupt flat dir test"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,mmp,metadata_csum,^dir_index -b 2048
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
mkdir $MNT/a/
cp -pRdu /etc/init* $MNT/a/
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV

echo 'ex /a' | ${E2FSPROGS}/debugfs/debugfs $DEV | awk '{if (($8 * 1) == $8) {print $8}}' | while read blk; do
	yes "${FUZZ}" | dd of=$DEV bs=4 count=1 seek=$(( (blk * 512) + 511 ))
done
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV || true

msg "cat files (brokeN)"
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT/a -type f -print0 | xargs -0 cat > /dev/null
echo moo | tee $MNT/a/test0 || true
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fy $DEV || true

msg "cat files again"
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT/a -type f -print0 | xargs -0 cat > /dev/null
echo moo | tee $MNT/a/test0
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV

msg "blast flat dir test"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,mmp,metadata_csum,^dir_index -b 2048
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
cp -pRdu /etc $MNT/a
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV

echo 'ex /a' | ${E2FSPROGS}/debugfs/debugfs $DEV | awk '{if (($8 * 1) == $8) {print $8}}' | while read blk; do
	yes "${FUZZ}" | dd of=$DEV bs=2048 count=1 seek=$blk
done
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV || true

msg "cat files (brokeN)"
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT/a -type f -print0 | xargs -0 cat > /dev/null
echo moo | tee $MNT/a/test0 || true
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fy $DEV || true
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV

msg "cat files again"
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT/a -type f -print0 | xargs -0 cat > /dev/null
echo moo | tee $MNT/a/test1
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV
}

####################
function ignore_fsck_d_test {
msg "ignore_fsck_d_test"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
cp -pRdu /etc $MNT/
umount $MNT

$VALGRIND ${E2FSPROGS}/misc/tune2fs $DEV -O metadata_csum
echo "Find all possible damage."
${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true

echo "Actually repair damage. 0"
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fy $DEV || true
echo "Test run 0."
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV

mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT -type f -print0 | xargs -0 cat > /dev/null
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV

# do it again, but wiht -D
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
cp -pRdu /etc $MNT/
umount $MNT

$VALGRIND ${E2FSPROGS}/misc/tune2fs $DEV -O metadata_csum
echo "Actually repair damage. 1"
${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true

echo "Test run. 1"
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV

mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT -type f -print0 | xargs -0 cat > /dev/null
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fn $DEV
}

############################
function xattr_test {
#############################
# create xattrs
msg "xattr_test"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 $MKFS_OPTS $MKFS_FEATURES
test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true

# create a bunch of xattrs
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
echo attrs | tee $MNT/attr1 $MNT/attr2 $MNT/noattr
set +x
echo + set_xattrs
for i in `seq -w 1 100`; do
	attr -s $i -V $i $MNT/attr1 > /dev/null
done
attr -s XXX -V XXX $MNT/attr2 > /dev/null
set -x
umount $MNT

# reload and reread
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
attr -l $MNT/attr1
attr -l $MNT/attr2
attr -l $MNT/noattr
umount $MNT

# Check fs one last time
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
}

#############################
function corrupt_xattr_test {
msg "corrupt_xattr_test"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,mmp,metadata_csum -b 4096

mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
echo attrs | tee $MNT/attr1 $MNT/attr2 $MNT/noattr
set +x
echo + set_xattrs
for i in `seq -w 1 100`; do
        attr -s $i -V $i $MNT/attr1 > /dev/null
done
attr -s XXX -V XXX $MNT/attr2 > /dev/null
set -x
umount $MNT

# gibberise the xattr block
XATTR_BLOCK=$(echo 'stat /attr1' | ${E2FSPROGS}/debugfs/debugfs $DEV | grep 'File ACL' | awk '{print $3}')
if [ -z "${XATTR_BLOCK}" -o "0${XATTR_BLOCK}" -lt 1 ]; then
	echo "Uh... no ACL block?"
	exit 50
fi
yes "${FUZZ}" | dd of=$DEV bs=4096 seek=$XATTR_BLOCK count=1 > /dev/null 2> /dev/null

# reload and reread
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV || true
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
attr -l $MNT/attr1 || true
attr -l $MNT/attr1 || true
attr -l $MNT/attr2
attr -l $MNT/noattr
umount $MNT

# fix
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -y $DEV || true

# reread, but this time fixed
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
attr -l $MNT/attr1
attr -l $MNT/attr2
attr -l $MNT/noattr
umount $MNT

# once more
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
}

####################################
function simple_sb_test {
msg "simple_sb_test"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 $MKFS_OPTS $MKFS_FEATURES
test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true

${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep Checksum
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

# write stuff
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
echo moo > $MNT/moo
umount $MNT
${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep Checksum
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

# change label
$VALGRIND ${E2FSPROGS}/misc/tune2fs -L moocow $DEV
${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep Checksum
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

# quick check kernel
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
echo moo > $MNT/cow
umount $MNT
${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep Checksum
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

# change label again
$VALGRIND ${E2FSPROGS}/misc/tune2fs -L cowmoo $DEV
${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep Checksum
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

# quick check kernel
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
echo moo > $MNT/cow
umount $MNT
${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep Checksum
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

# change uuid
$VALGRIND ${E2FSPROGS}/misc/tune2fs -U random $DEV
${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true

mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
echo moo > $MNT/post-uuid
umount $MNT

$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
}

##########################
function prep_speed_test {
VER=3.2.8
if [ ! -r /tmp/linux-${VER}.tar.bz2 ]; then
	cp /home/djwong/linux-${VER}.tar.bz2 /tmp/
	#scp elm3c44:/home/djwong/kern*/linux-${VER}.tar.bz2 /tmp/
fi
if [ ! -r /tmp/tarfiles ]; then
	tar tvf /tmp/linux-${VER}.tar.bz2 > /tmp/tarfiles
fi
if [ ! -r /tmp/dirs -o ! -r /tmp/files -o ! -r /tmp/topdirs ]; then
	rm -rf /tmp/dirs /tmp/files /tmp/topdirs
	for i in a1 a2 a3 a4 a5 a6 a7 a8 a9 aA aB aC aD aE aF; do
		cat /tmp/tarfiles | grep ^d | awk "{printf(\"$i/%s\n\", \$6);}" >> /tmp/dirs
		cat /tmp/tarfiles | grep -v ^d | awk "{printf(\"%s $i/%s\n\", \$3, \$6);}" >> /tmp/files
		echo "$i" >> /tmp/topdirs
	done
fi
if [ ! -x /tmp/fab ]; then
	cat > /tmp/fab.c << ENDL
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char *argv[])
{
	FILE *fp;
	int fd;
	size_t size;
	char *space;
	char buf[1024];

	if (argc < 2) {
		printf("Usage: %s file_containing_sz_name_pairs\n", argv[0]);
		return 4;
	}

	fp = fopen(argv[1], "r");
	if (!fp) {
		perror(argv[1]);
		return 5;
	}

	while (fgets(buf, 1024, fp)) {
		buf[strlen(buf) - 1] = 0;
		space = strchr(buf, ' ');
		if (!space) {
			fprintf(stderr, "space not found at line \"%s\"!\n", buf);
			break;
		}
		*space = 0;
		space++;
		fd = open(space, O_WRONLY | O_CREAT, 0644);
		if (fd < 0) {
			perror(space);
			break;
		}
		size = strtoul(buf, NULL, 0);
		posix_fallocate(fd, 0, size);
		close(fd);
	}

	fclose(fp);
	return 0;
}
ENDL
	gcc -o /tmp/fab /tmp/fab.c
fi
}

function tune2fs_speed_test {
msg "tune2fs_speed_test"
prep_speed_test
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
cd $MNT
set +x
echo + mkdirs
mkdir -p $(cat /tmp/dirs)
set -x
/tmp/fab /tmp/files
cd -
umount $MNT

/usr/bin/time $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
/usr/bin/time $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -y -D $DEV || true
}

function all_speed_test {
msg "all_speed_test"
prep_speed_test

msg "All checksums including journal and data=journal"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,metadata_csum,mmp
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum,data=journal,nodelalloc
cd $MNT
/usr/bin/time bash -c "mkdir -p \$(cat /tmp/dirs); /tmp/fab /tmp/files; sync"
/usr/bin/time bash -c "rm -rf \$(cat /tmp/topdirs); sync"
cd -
umount $MNT
}

function most_speed_test {
msg "most_speed_test"
prep_speed_test

msg "All checksums including journal and data=ordered"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,metadata_csum,mmp
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
cd $MNT
/usr/bin/time bash -c "mkdir -p \$(cat /tmp/dirs); /tmp/fab /tmp/files; sync"
/usr/bin/time bash -c "rm -rf \$(cat /tmp/topdirs); sync"
cd -
umount $MNT
}

function none_speed_test {
msg "none_speed_test"
prep_speed_test

msg "No checksums at all"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit
mount ${MOUNT_OPTS} $DEV $MNT -t ext4
cd $MNT
/usr/bin/time bash -c "mkdir -p \$(cat /tmp/dirs); /tmp/fab /tmp/files; sync"
/usr/bin/time bash -c "rm -rf \$(cat /tmp/topdirs); sync"
cd -
umount $MNT
}

######################
function ext_speed_test {
msg "ext_speed_test"
prep_speed_test
msg "All ext4 checksums, no journal checksum"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,mmp,metadata_csum
mount ${MOUNT_OPTS} $DEV $MNT -t ext4
cd $MNT
/usr/bin/time bash -c "mkdir -p \$(cat /tmp/dirs); /tmp/fab /tmp/files; sync"
/usr/bin/time bash -c "rm -rf \$(cat /tmp/topdirs); sync"
cd -
umount $MNT

msg "All ext4 checksums except use old bg method, no journal checksum"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,metadata_csum
mount ${MOUNT_OPTS} $DEV $MNT -t ext4
cd $MNT
/usr/bin/time bash -c "mkdir -p \$(cat /tmp/dirs); /tmp/fab /tmp/files; sync"
/usr/bin/time bash -c "rm -rf \$(cat /tmp/topdirs); sync"
cd -
umount $MNT
}

########################
function dir_rewrite_test {
msg "dir_rewrite_test"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
cp -pRdu /etc $MNT/a
set +x
echo + htree1
for i in 1; do
	for j in 1 2 3 4; do
		mkdir -p $MNT/$i/$j
		for k in `seq 1 24`; do
			FNAME=$(perl -e "printf(\"%.250s\\n\", \"_$k\" x 256);")
			echo moo > "$MNT/$i/$j/$FNAME"
		done
	done
	for k in `seq 1 32`; do
		FNAME=$(perl -e "printf(\"%.250s\\n\", \"_$k\" x 256);")
		echo moo > "$MNT/$i/$FNAME"
	done
done
mkdir -p $MNT/full
for k in `seq 1 32`; do
	FNAME=$(perl -e "printf(\"%.248s\\n\", \"_$k\" x 256);")
	echo moo > "$MNT/full/$FNAME"
done
set -x
umount $MNT

# enable checksums
test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

# run it by the kernel
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT -type f -print0 | xargs -0 cat > /dev/null
umount $MNT

# one last check
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
}

##################
function uuid_change_test {
msg "uuid_change_test"
UUID1=deadbeef-cafe-babe-dead-beefcafebabe
UUID2=d15ea5ed-dead-beef-face-feeddefec8ed

# Try to change UUID w/o checksums
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -U $UUID1
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
cp -pRdu /etc $MNT/a
umount $MNT
UUID=$($VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep 'Filesystem UUID' | sed -e 's/^.*:[ ]*//g')
if [ "${UUID}" != "${UUID1}" ]; then
	echo "Bad UUID ${UUID}"
	exit 1
fi
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

msg "offline change nocsum"
$VALGRIND ${E2FSPROGS}/misc/tune2fs -U $UUID2 $DEV
UUID=$($VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep 'Filesystem UUID' | sed -e 's/^.*:[ ]*//g')
if [ "${UUID}" != "${UUID2}" -o "${UUID}" = "${UUID1}" ]; then
	echo "UUID change fail?"
	exit 2
fi
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT -type f -print0 | xargs -0 cat > /dev/null
umount $MNT

msg "online change nocsum"
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
echo moo > $MNT/badfile
$VALGRIND ${E2FSPROGS}/misc/tune2fs -U $UUID1 $DEV
sync
find $MNT -type f -print0 | xargs -0 cat > /dev/null
umount $MNT
UUID=$($VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep 'Filesystem UUID' | sed -e 's/^.*:[ ]*//g')
if [ "${UUID}" != "${UUID1}" -o "${UUID}" = "${UUID2}" ]; then
	echo "UUID should have changed"
	exit 3
fi
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

# Try to change UUID with chekcsums
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O mmp,metadata_csum -U $UUID1
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
cp -pRdu /etc $MNT/a
umount $MNT
UUID=$($VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep 'Filesystem UUID' | sed -e 's/^.*:[ ]*//g')
if [ "${UUID}" != "${UUID1}" ]; then
	echo "Bad UUID ${UUID}"
	exit 1
fi
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

msg "offline change"
$VALGRIND ${E2FSPROGS}/misc/tune2fs -U $UUID2 $DEV
UUID=$($VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep 'Filesystem UUID' | sed -e 's/^.*:[ ]*//g')
if [ "${UUID}" != "${UUID2}" -o "${UUID}" = "${UUID1}" ]; then
	echo "UUID change fail?"
	exit 2
fi
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT -type f -print0 | xargs -0 cat > /dev/null
umount $MNT

msg "online nochange"
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
echo moo > $MNT/badfile
$VALGRIND ${E2FSPROGS}/misc/tune2fs -U $UUID1 $DEV || true
sync
find $MNT -type f -print0 | xargs -0 cat > /dev/null
umount $MNT
UUID=$($VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep 'Filesystem UUID' | sed -e 's/^.*:[ ]*//g')
if [ "${UUID}" != "${UUID2}" -o "${UUID}" = "${UUID1}" ]; then
	echo "UUID should not have changed"
	exit 3
fi
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

}

################################
function bg_meta_use_csum_test {
msg "bg_meta_use_csum_test"
# write junk into last error field
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,mmp,^uninit_bg,^metadata_csum -b 4096
mount $DEV $MNT -t ext4 -o journal_checksum
cp -pRdu /etc $MNT/etc
umount $MNT

for bg_checksum in 0 1; do
	for metadata_csum in 0 1; do
		opts=""
		if [ $metadata_csum -eq 1 ]; then
			opts="metadata_csum,${opts}"
		else
			opts="^metadata_csum,${opts}"
		fi
		if [ $bg_checksum -eq 1 ]; then
			opts="uninit_bg,${opts}"
		else
			opts="^uninit_bg,${opts}"
		fi
		$VALGRIND ${E2FSPROGS}/misc/tune2fs -O $opts $DEV
		$VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep 'Filesystem features:'
		mount $DEV $MNT -t ext4
		find $MNT -type f -print0 | xargs -0 cat > /dev/null
		date > "${MNT}/${bg_checksum}_${metadata_csum}"
		umount $MNT
		$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
	done
done
}

############################
function mmp_test {
msg "mmp_test"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,metadata_csum,mmp -E mmp_update_interval=5
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
mount $DEV $MNT -t ext4 -o journal_checksum
cp -pRdu /etc $MNT/a
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

# Can't fsck while mounted
mount $DEV $MNT -t ext4 -o journal_checksum
yes | script -f /tmp/mmp.$$ -c "$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -y $DEV; echo \"RETURN: \$?\""
RET=$(grep 'RETURN:' /tmp/mmp.$$ | awk '{print $2}')
if [ $RET -eq 0 ]; then
	echo "Should not be able to fsck while mounted"
	exit 50
fi
set -e
umount $MNT
}

#####################
function corrupt_mmp_test {
msg "corrupt_mmp_test"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,metadata_csum,mmp -E mmp_update_interval=5 -b 4096
mount $DEV $MNT -t ext4 -o journal_checksum
echo moo > $MNT/moofile
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

MMP_BLOCK=$(${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep 'MMP block number:' | awk '{print $4}')
MMP_SECTOR=$(((MMP_BLOCK * 8) + 1))
yes "${FUZZ}" | dd of=$DEV bs=512 seek=${MMP_SECTOR} count=1 > /dev/null 2> /dev/null
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV || true
set +e
mount $DEV $MNT -t ext4 -o journal_checksum
if [ $? -eq 0 ]; then
	echo "Should not be able to mount with corrupt MMP"
	exit 50
fi
set -e

$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fy $DEV || true
mount $DEV $MNT -t ext4 -o journal_checksum
echo $MNT/moofile > /dev/null
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
}

##############################
function journal_sb_test {
msg "journal_sb_test"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,metadata_csum
mount $DEV $MNT -t ext4 -o journal_checksum,data=journal,nodelalloc
cp -pRdu /etc $MNT/etc
sync
rm -rf $MNT/etc/init*
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
$VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep ^Journal

# Make the kernel run through again
mount $DEV $MNT -t ext4 -o journal_checksum,data=journal,nodelalloc
cp -pRdu /etc $MNT/blob
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
$VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep ^Journal

# What happens if we don't specify any options?
mount $DEV $MNT -t ext4
#set +x
#mkdir $MNT/fragged/
#for i in `seq 1 1000`; do
#	echo moo > $MNT/fragged/a$i
#	sync
#	dd if=/dev/zero bs=4k count=1 >> $MNT/fragged/fragfile 2> /dev/null > /dev/null
#	sync
#done
#set -x
#truncate -s -2000k $MNT/fragged/fragfile
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
$VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep ^Journal
}

##############################
function corrupt_journal_sb_test {
msg "corrupt_journal_sb_test"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,metadata_csum -b 4096
mount $DEV $MNT -t ext4 -o journal_checksum
cp -pRdu /etc $MNT/etc
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
$VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep ^Journal

# Fuzz part of the superblock
JSB_BLOCK=$(echo 'ex <8>' | ${E2FSPROGS}/debugfs/debugfs -n $DEV | grep '0 - 3276' | awk '{print $8}')
JSB_SECTOR=$(((JSB_BLOCK * 8) + 1))
yes "${FUZZ}" | dd of=$DEV bs=512 seek=${JSB_SECTOR} count=1 > /dev/null 2> /dev/null
dd if=$DEV bs=4096 skip=${JSB_BLOCK} count=1 | od -tx1 -Ad -c
$VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep ^Journal

# Make the kernel run through again
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV || true
set +e
mount $DEV $MNT -t ext4 -o journal_checksum
if [ $? -eq 0 ]; then
	echo "Should not be able to mount with corrupt journal."
	exit 50
fi
set -e
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -y $DEV || true
$VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep ^Journal

# Mount, copy more files
mount $DEV $MNT -t ext4 -o journal_checksum
cp -pRdu /etc $MNT/next
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
$VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep ^Journal
}

# Leave this at the end
################################
function corrupt_sb_test {
msg "corrupt_sb_test"
# write junk into last error field
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,mmp,metadata_csum -b 4096 -i 524288
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep UUID
yes "${FUZZ}" | dd of=$DEV bs=32 seek=47 count=1 > /dev/null 2> /dev/null
# fsck -n will modify the fs due to backup sb being used !  DO NOT RUN THIS: $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum && echo should not get here && exit 50
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -y -D $DEV || true
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
echo moo > $MNT/file
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

# totally destroy sb
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O 64bit,mmp,metadata_csum -b 4096 -i 524288
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep UUID
yes "${FUZZ}" | dd of=$DEV bs=4096 seek=0 count=1 > /dev/null 2> /dev/null
# fsck -n will modify the fs due to backup sb being used !  DO NOT RUN THIS: $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum && echo should not get here && exit 50
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -y -D $DEV || true
echo "beat on it a second time"
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -y -D $DEV || true
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
echo moo > $MNT/file
umount $MNT
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
}

#####################################
function mkfs_flag_collision_test_helper {
	if [ ! -z "$1" ]; then
		FEATURES="-O $1,^has_journal"
	else
		FEATURES="-O ^has_journal"
	fi
	FEATURE_STRING="$2"
	if [ ! -z "$3" ]; then
		ERROR_MSG="$3"
	else
		ERROR_MSG="$1"
	fi

	$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 $FEATURES
	set +e
	MCSUM=$($VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep -c metadata_csum)
	GCSUM=$($VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep -c uninit_bg)
	set -e
	$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
	if [ "${MCSUM},${GCSUM}" != "${FEATURE_STRING}" ]; then
		msg "FAIL ${ERROR_MSG}"
		return 1
	fi
	msg "PASS ${ERROR_MSG}"
	return 0
}

function mkfs_flag_collision_test {
msg "mkfs_flag_collision_test"
mkfs_flag_collision_test_helper "" "0,1" "no flags"
mkfs_flag_collision_test_helper "metadata_csum" "1,0"
# The following are actually tested in the tune2fs flag collision test
#mkfs_flag_collision_test_helper "metadata_csum,^uninit_bg" "1,0"
#mkfs_flag_collision_test_helper "^metadata_csum,uninit_bg" "0,1"
#mkfs_flag_collision_test_helper "metadata_csum,uninit_bg" "1,0"
#mkfs_flag_collision_test_helper "^metadata_csum,^uninit_bg" "0,0"
}

#####################################
function tune2fs_flag_collision_test_helper {
	if [ ! -z "$1" ]; then
		FEATURES="-O $1"
	fi
	FEATURE_STRING="$2"
	ERROR_MSG="$1"

	$VALGRIND ${E2FSPROGS}/misc/tune2fs $DEV $FEATURES
	${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true
	if [ -z "${FEATURE_STRING}" ]; then
		return 0
	fi
	set +e
	MCSUM=$($VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep -c metadata_csum)
	GCSUM=$($VALGRIND ${E2FSPROGS}/misc/dumpe2fs -h $DEV | grep -c uninit_bg)
	set -e
	$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
	if [ "${MCSUM},${GCSUM}" != "${FEATURE_STRING}" ]; then
		msg "FAIL ${ERROR_MSG}"
		return 1
	fi
	msg "PASS ${ERROR_MSG}"
	return 0
}

function tune2fs_flag_collision_test {
msg "tune2fs_flag_collision_test"
declare -A COMBOS
COMBOS[0]="^metadata_csum,^uninit_bg"
COMBOS[1]="metadata_csum,^uninit_bg"
COMBOS[2]="^metadata_csum,uninit_bg"
COMBOS[3]="metadata_csum,uninit_bg"

declare -A RESULTS
RESULTS[0]="0,0"
RESULTS[1]="1,0"
RESULTS[2]="0,1"
RESULTS[3]="1,0"

for i in ${!COMBOS[@]}; do
	for j in ${!COMBOS[@]}; do
		mkfs_flag_collision_test_helper "${COMBOS[$i]}" "${RESULTS[$i]}"
		mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
		cp -pRd /etc/ $MNT/etc_a
		umount $MNT
		tune2fs_flag_collision_test_helper "${COMBOS[$j]}" "${RESULTS[$j]}"
	done
done
}

#####################################
function remove_checksum_test {
msg "remove_checksum_test"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O ^has_journal,metadata_csum

# Dump in some files
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
cp -pRd /etc/ $MNT/etc_a
umount $MNT

tune2fs_flag_collision_test_helper "^metadata_csum,uninit_bg" "0,1" "remove only metadata_csum"
tune2fs_flag_collision_test_helper "^uninit_bg" "0,0" "remove uninit_bg"

msg "fast disable"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O ^has_journal,metadata_csum

# Dump in some files
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
cp -pRd /etc/ $MNT/etc_a
umount $MNT

tune2fs_flag_collision_test_helper "^metadata_csum,^uninit_bg" "0,0" "remove metadata_csum and uninit_bg"
}

#####################################
function shrink_uninit_test {
msg "shrink_uninit_test"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O ^has_journal,metadata_csum,64bit -b 4096 -N 192 393216
mount ${MOUNT_OPTS} $DEV $MNT -t ext4
mkdir -p $MNT/dirX/
j=0
touch $MNT/bigfile
while true; do
	touch $MNT/dirX/file_${i}_${j} || break
	j=$((j + 1))
done
dd if=/dev/zero of=$MNT/bigfile conv=notrunc oflag=append || true
umount $MNT
mount ${MOUNT_OPTS} $DEV $MNT -t ext4
rm -rf $MNT/dirX $MNT/bigfile
umount $MNT

for i in `seq 1 16`; do
	$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fy $DEV || true
	$VALGRIND ${E2FSPROGS}/resize/resize2fs $DEV $((393216 - ($i * 16384)))
	$VALGRIND ${E2FSPROGS}/misc/dumpe2fs $DEV
	$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
	mount ${MOUNT_OPTS} $DEV $MNT -t ext4
	dd if=/dev/zero of=$MNT/bigfile conv=notrunc oflag=append || true
	sync
	rm -rf $MNT/bigfile
	umount $MNT
done
}

#####################################
function resize_uninit_test {
msg "resize_test: uninit_bg"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O ^has_journal,metadata_csum,64bit -b 4096 -N 64 131072

for i in `seq 1 16`; do
	$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fy $DEV || true
	$VALGRIND ${E2FSPROGS}/resize/resize2fs $DEV $((131072 + ($i * 16384)))
	$VALGRIND ${E2FSPROGS}/misc/dumpe2fs $DEV
	$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
	mount ${MOUNT_OPTS} $DEV $MNT -t ext4
	mkdir -p $MNT/dirX/
	j=0
	touch $MNT/bigfile
	while true; do
		touch $MNT/dirX/file_${i}_${j} || break
		j=$((j + 1))
	done
	dd if=/dev/zero of=$MNT/bigfile conv=notrunc oflag=append || true
	umount $MNT
	$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
done
}

######################################
function resize_init_test {
msg "resize_init_test"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O ^has_journal,^uninit_bg,64bit -b 4096 -N 64 131072
$VALGRIND ${E2FSPROGS}/misc/tune2fs $DEV -O metadata_csum
${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true

for i in `seq 1 16`; do
	$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fy $DEV || true
	$VALGRIND ${E2FSPROGS}/resize/resize2fs $DEV $((131072 + ($i * 16384)))
	$VALGRIND ${E2FSPROGS}/misc/dumpe2fs $DEV
	$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
	mount ${MOUNT_OPTS} $DEV $MNT -t ext4
	mkdir -p $MNT/dirY/
	j=0
	touch $MNT/bigfile
	while true; do
		touch $MNT/dirY/file_${i}_${j} || break
		j=$((j+1))
	done
	dd if=/dev/zero of=$MNT/bigfile conv=notrunc oflag=append || true
	umount $MNT
	$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
done
}

#####################################
function online_resize_uninit_test {
msg "online_resize_test: uninit_bg"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O ^has_journal,metadata_csum,64bit -b 4096 -N 64 131072

for i in `seq 1 16`; do
	$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fy $DEV || true
	mount ${MOUNT_OPTS} $DEV $MNT -t ext4
	$VALGRIND ${E2FSPROGS}/misc/dumpe2fs $DEV
	$VALGRIND ${E2FSPROGS}/resize/resize2fs $DEV $((131072 + ($i * 16384)))
	$VALGRIND ${E2FSPROGS}/misc/dumpe2fs $DEV
	$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
	mkdir -p $MNT/dirX/
	j=0
	touch $MNT/bigfile
	while true; do
		touch $MNT/dirX/file_${i}_${j} || break
		j=$((j + 1))
	done
	dd if=/dev/zero of=$MNT/bigfile conv=notrunc oflag=append || true
	umount $MNT
	# XXX: this is broken, even before metadata_csum came about
	$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
done
}

######################################
function online_resize_init_test {
msg "online_resize_init_test"
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 -O ^has_journal,^uninit_bg,64bit -b 4096 -N 64 131072
$VALGRIND ${E2FSPROGS}/misc/tune2fs $DEV -O metadata_csum
${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true

for i in `seq 1 16`; do
	$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fy $DEV || true
	mount ${MOUNT_OPTS} $DEV $MNT -t ext4
	$VALGRIND ${E2FSPROGS}/resize/resize2fs $DEV $((131072 + ($i * 16384)))
	mkdir -p $MNT/dirY/
	j=0
	touch $MNT/bigfile
	while true; do
		touch $MNT/dirY/file_${i}_${j} || break
		j=$((j+1))
	done
	dd if=/dev/zero of=$MNT/bigfile conv=notrunc oflag=append || true
	umount $MNT
	$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV
done
}

#####################################
function simple_prep_fs {
msg "Create fs with files, dirs, EAs, htree dirs, etc."
$VALGRIND ${E2FSPROGS}/misc/mke2fs -F $DEV -T ext4 $MKFS_OPTS $MKFS_FEATURES
test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || $VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -fDy $DEV || true

# Dump in some files
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
cp -pRd /etc/ $MNT/etc_a
mkdir -p $MNT/fragged
dd if=/dev/zero bs=4k count=1 of=$MNT/fragged/fragfile
sync
set +x
echo + frag
for i in `seq 1 8`; do
	echo moo > $MNT/fragged/a$i
	sync
	dd if=/dev/zero bs=4k count=1 >> $MNT/fragged/fragfile
	sync
done
set -x
echo moo > $MNT/ea_file
set +x
echo + set_ea
for i in `seq -w 1 100`; do
	attr -s $i -V $i $MNT/ea_file
done

# add some random files
cp -pRd /etc/ $MNT/etc_b

# create htree
mkdir -p $MNT/bigdir2
set +x
echo + htree2
for i in `seq 1 256`; do
	echo moo > "$MNT/bigdir2/$(echo "$(date)_$i" | md5sum)"
done
set -x

# Fragment a file
set +x
echo + frag
for i in `seq 9 18`; do
	echo moo > $MNT/fragged/a$i
	sync
	dd if=/dev/zero bs=4k count=1 >> $MNT/fragged/fragfile
	sync
done
set -x

# Rewrite extent tree
set +x
echo + frag
for i in `seq 19 28`; do
	echo moo > $MNT/fragged/a$i
	sync
	dd if=/dev/zero bs=4k count=1 >> $MNT/fragged/fragfile
	sync
done
set -x

# Truncate
truncate -s -64k $MNT/fragged/fragfile

# More rewrites
set +x
echo + frag
for i in `seq 29 38`; do
	echo moo > $MNT/fragged/a$i
	sync
	dd if=/dev/zero bs=4k count=1 >> $MNT/fragged/fragfile
	sync
done
set -x

# multi-level htree
mkdir $MNT/3
echo moo > $MNT/3/base.txt
set +x
echo + mltree
seq 1 5000 | while read f; do
	if [ $((f % 71)) -eq 0 ]; then
		echo -n "$f..."
	fi
	FNAME=$(perl -e "printf(\"%.250s\\n\", \"_$f\" x 256);")
	ln $MNT/3/base.txt $MNT/3/$FNAME
done
echo 
set -x
umount $MNT

# Re-walk fs looking for errors
mount ${MOUNT_OPTS} $DEV $MNT -t ext4 -o journal_checksum
find $MNT -type f -print0 | xargs -0 cat > /dev/null
attr -l $MNT/ea_file > /dev/null
umount $MNT/

# Check fs again
$VALGRIND ${E2FSPROGS}/e2fsck/e2fsck -f -n $DEV

echo 'Filesystem created; please mount with -o journal_checksum'
}

#####################
for verb in $(echo "${VERBS}" | tr ':,' '  '); do
	$verb
done

####################################
msg "Finished successfully, ENJOY."

