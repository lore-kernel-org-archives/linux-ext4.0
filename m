From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH 0/6][64-bit] Overview
Date: Fri, 01 May 2009 04:46:00 -0400
Message-ID: <15543.1241167560@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, Theodore Ts'o <tytso@mit.edu>,
	Valerie Aurora <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:36117 "EHLO
	QMTA06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbZEAIpr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 May 2009 04:45:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With this set of patches, I can go through a mkfs/fsck cycle with a
32TiB filesystem in four different configurations:

   o flex_bg off, no raid parameters
   o flex_bg off, raid parameters
   o flex_bg on, no raid parameters
   o flex_bg on, raid parameters

There are no errors and the layouts seem reasonable - in the first two
cases, I've checked the block and inode bitmaps of the four groups that
are not marked BG_BLOCK_UNINIT and they look correct.  I'm spot checking
some bitmaps in the last two cases but that's a longer process.

The fs is built on an LVM volume that consists of 16 physical volumes,
with a stripe size of 128 KiB. Each physical volume is a striped LUN
(also with a 128KiB stripe size) exported by an MSA1000 RAID
controller. There are 4 controllers, each with 28 300GiB, 15Krpm SCSI
disks. Each controller exports 4 LUNs. Each LUN is 2TiB (that's
a limitation of the hardware). So each controller exports 8TiB and
four of them provide the 32TiB for the filesystem.

The machine is a DL585g5: 4 slots, each with a quad core AMD cpu
(/proc/cpuinfo says:

vendor_id	: AuthenticAMD
cpu family	: 16
model		: 2
model name	: Quad-Core AMD Opteron(tm) Processor 8356
stepping	: 3
cpu MHz		: 2310.961
cache size	: 512 KB
)

Even though I thought I had done this before (with the third
configuration), I could not replicate it: when running e2fsck, I
started getting checksum errors before the first pass and block
conflicts in pass 1. See the patch entitled "Eliminate erroneous blk_t
casts in ext2fs_get_free_blocks2()" for more details.

Even after these fixes, dumpe2fs and e2fsck were complaining that the
last group (group #250337) had block bitmap differences. It turned out
that the bitmaps were being written to the wrong place because of 32-bit
truncation. The patch entitled "write_bitmaps(): blk_t -> blk64_t" fixes
that.

mke2fs is supposed to zero out the last 16 blocks of the volume to make
sure that any old MD RAID metadata at the end of the device are wiped
out, but it was zeroing out the wrong blocks. The patch entitled
"mke2fs 64-bit miscellaneous fixes" fixes that, as well as a
few display issues.

dumpe2fs needed the EXT2_FLAG_NEW_BITMAPS flag and had a few display
problems of its own. These are fixed in the patch entitled
"enable dumpe2fs 64-bitness and fix printf formats."

There are two patches for problems found by visual inspection:
"(blk_t) cast in ext2fs_new_block2()" and "__u32 -> __u64 in
ba_resize_bmap() and blk_t -> blk64_t in ext2fs_check_desc()"

Thanks,
Nick
