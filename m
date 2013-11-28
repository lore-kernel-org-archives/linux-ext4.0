From: "Akira Fujita" <a-fujita@rs.jp.nec.com>
Subject: RE: [PATCH] mke2fs: Fix block bitmaps initalization with -O ^resize_inode
Date: Thu, 28 Nov 2013 17:50:19 +0900
Message-ID: <00d301ceec16$de11fec0$9a35fc40$@rs.jp.nec.com>
References: <52662BBA.70503@rs.jp.nec.com> <20131123013336.GD10269@birch.djwong.org> <20131126012706.GF10269@birch.djwong.org> <003101ceea7f$08d3fda0$1a7bf8e0$@rs.jp.nec.com> <20131127005505.GG10269@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Theodore Tso'" <tytso@mit.edu>,
	"'ext4 development'" <linux-ext4@vger.kernel.org>
To: "'Darrick J. Wong'" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:34435 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab3K1I44 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Nov 2013 03:56:56 -0500
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id rAS8uthm026242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 28 Nov 2013 17:56:55 +0900 (JST)
In-Reply-To: <20131127005505.GG10269@birch.djwong.org>
Content-Language: ja
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>On Tue, Nov 26, 2013 at 05:10:56PM +0900, Akira Fujita wrote:
>> Hi Darrick,
>>
>> With your patch, e2fsck can't fix the filesystem created with existing
>> mke2fs without resize_inode.
>> Because "fs->block_map == bmap" condition is in ext2fs_reserve_super_and_bgd().
>
>Hmm, I think I see what's going on here.
>
>First, I think you're arguing that BLOCK_UNINIT should only be set on a group if it's
completely
>empty.  I think you're also arguing that even if the group contains only its own superblocks,
group
>descriptors, bitmaps, or inode tables, BLOCK_UNINIT should not be set.  Let's call that
condition
>(block group contains only group data, but BLOCK_UNINIT is set) "(1)".
>
>Note: If a group contains some other group's metadata, BLOCK_UNINIT should not (and does not
seem
>to) be set.
>
>(If I'm wrong, please let me know.)

Yes. Current ext4, it seems to me that BLOCK_UNINIT is set under the following rules:

1 sb(backup sb)/gdt/bitmap/itable exist  (e.g. #BG0)   -> BLOCK_UNINIT off
2 backup sb/gdt exist                    (e.g. #BG5)   -> BLOCK_UNINIT off
3 bitmap/itable exist                    (e.g. #BG16)   -> BLOCK_UNINIT off
4 Completely empty                       (e.g. #BG6)   -> BLOCK_UNINIT on
                            Note: #BGN is in ext4 created by default option

And there is a bug that block group which has backup super block
and group descriptor block are not write out to device in wrtie_bitmaps()
when BLOCK_UNINIT is set.
So at this time, I attempted to fix this by cleaning BLOCK_UNIIT.


>The kernel, when it needs to load a bitmap, checks for BLOCK_UNINIT; if set, it calls
>ext4_init_block_bitmap() to zero the bitmap and mark the relevant sb/gdt/bmap/table bits, if
>necessary.  That takes care of (1) in the kernel.
>
>e2fsck pass5 also checks for BLOCK_UNINIT; if it's set, then it first compares block_found_map
>against a zeroed bitmap (which falls back to no_optimize mode), and then it secondly compares
each
>block individually against the ranges that ext2fs_super_and_bgd_loc2(), ext2fs_*_bitmap_loc(),
and
>ext2fs_inode_table_loc() return.  That takes care of (1) in e2fsck.
>
>libext2fs, however, checks for BLOCK_UNINIT; if it's set, it zeroes that part of the bitmap
and
>moves on without bothering to mark the sb/gdt/bmap/table bits.  This does NOT take care of
(1),
>and opens a window where callers can allocate blocks that already hold group metadata!  (Let's
call
>this (2).)
>
>The fuse2fs bug that I was seeing was that if (2) happens, then fuse2fs sees a zero bitmap and
blindly
>hands away group metadata, which is broken.  With yesterday's patch, (1) doesn't happen and
all
>seems ok.
>
>I think in your e2fsck test, e2fsck tests block_found_map against a correctly constructed
bitmap
>(with ext2fs_super_and_bgd_loc2) if BLOCK_UNINIT is set, which is why it can't fix (1) unless
e2fsck
>is fed a backup superblock (or there's a corrupt a group descriptor checksum), either of which
clears
>BLOCK_UNINIT before pass5).
>
>So I'm wondering, is there more to the bug report than just "I ran mkfs and prodded e2fsck
into
>reporting errors"?

I guess there is another bug.

>Given that both the kernel and e2fsck know how to calculate the proper block bitmap when
BLOCK_UNINIT
>is set, it doesn't seem to be an error case if BLOCK_UNINIT is set on a group that contains
superblocks,
>group descriptors, bitmaps, or inode tables.  It seems to me that if we can calculate a
bitmap,
>then there's no need to record it, and we can use BLOCK_UNINIT.
>
>What do you think of this solution: Change read_bitmaps to mark the location of
sb/gdt/bmap/inode
>blocks in the in-core block bitmap for BLOCK_UNINIT groups.
>This fixes the problem that fs->block_bitmap doesn't accurately reflect the real state of the
>filesystem (as evidenced by dumpe2fs/debugfs reporting more free blocks than the summar.  I
think
>we can also eliminate the skip_group code from the block bitmap check in pass5.  That should
speed
>up pass5 since we can also use the fast bitmap compare.

Speeding up bitmap check in pass5 sounds nice,
but setting BLOCK_UNINIT for block groups which have metadata means
we'll change the definition of BLOCK_UNIIT... :s

Regards,
Akira Fujita

>I'll send out a test patch.
>
>Of course, the tests seem coded to pass things like:
>
>> Group 2: (Blocks 16385-24576) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
>>   Block bitmap at 16385 (+0), Inode bitmap at 16386 (+1)
>                    ^^^^^                       ^^^^^
>>   Inode table at 16387-16642 (+2)
>                   ^^^^^^^^^^^
>>   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
>>   Free blocks: 16385-24576
>                 ^^^^^
>>   Free inodes: 4097-6144
>
><grumble>
>
>--D
>
>> But if the condition removed (like my previous patch) we can detect
>> and fix filesystem inconsistency as follows.
>>
>> 1.Create filesystem with existing mke2fs command # mke2fs -t ext4 -O
>> ^resize_inode DEVICE
>>
>> 2. (With my patch) e2fsck removes uninit_bg flag then fixes metadata
>> inconsistency # ./e2fsck/e2fsck -f DEVICE e2fsck 1.43-WIP (8-Jul-2013)
>> One or more block group descriptor checksums are invalid.  Fix<y>? yes
>> Group descriptor 1 checksum is 0x0343, should be 0xc4ba.  FIXED.
>> Group descriptor 3 checksum is 0x17f2, should be 0xd00b.  FIXED.
>> Group descriptor 5 checksum is 0xf36c, should be 0x3495.  FIXED.
>> Group descriptor 7 checksum is 0x3e90, should be 0xf969.  FIXED.
>> Group descriptor 9 checksum is 0xa31e, should be 0x64e7.  FIXED.
>> Group descriptor 25 checksum is 0x165a, should be 0xd1a3.  FIXED.
>> Group descriptor 27 checksum is 0xce4c, should be 0x09b5.  FIXED.
>> Group descriptor 49 checksum is 0x502b, should be 0x97d2.  FIXED.
>> Pass 1: Checking inodes, blocks, and sizes Pass 2: Checking directory
>> structure Pass 3: Checking directory connectivity Pass 4: Checking
>> reference counts Pass 5: Checking group summary information Block
>> bitmap differences:  +(32768--32769) +(98304--98305) +(163840--163841)
>> +(229376--229377)
>> +(294912--294913) +(819200--819201) +(884736--884737)
>> ++(1605632--1605633)
>> Fix<y>? yes
>>
>> /dev/loop0: ***** FILE SYSTEM WAS MODIFIED *****
>> /dev/loop0: 11/656640 files (0.0% non-contiguous), 73991/2621440
>> blocks
>>
>> Regards,
>> Akira Fujita
>>
>> >-----Original Message-----
>> >From: Darrick J. Wong [mailto:darrick.wong@oracle.com]
>> >Sent: Tuesday, November 26, 2013 10:27 AM
>> >To: Akira Fujita
>> >Cc: Theodore Tso; ext4 development
>> >Subject: Re: [PATCH] mke2fs: Fix block bitmaps initalization with -O
>> >^resize_inode
>> >
>> >Does the following patch fix your error?  I think I've started to hit
>> >it too, now that I added ^resize_inode,^meta_bg to the mix.
>> >
>> >--D
>> >
>> >libext2fs: clear BLOCK_UNINIT any time a group has metadata blocks
>> >
>> >If ext2fs_reserve_super_and_bgd() is called with the filesystem's
>> >block bitmap, we clear the
>> group's
>> >BLOCK_UNINIT flag if the group has an old-style (pre-metabg) group
>> >descriptor block with
>> reserved
>> >descriptor blocks prior to marking the old-style descriptor blocks in use.
>> >
>> >Unfortunately, this is not sufficient -- if the group has no reserved
>> >blocks yet isn't a
>> meta_bg
>> >filesystem (^resize_inode,^meta_bg), we forget to clear the flag, so
>> >the filesystem thinks all blocks are free, which is disastrous.
>> >
>> >Therefore, if we know that we're going to mark any of the bitmaps,
>> >make sure that we clear BLOCK_UNINIT.
>> >
>> >This is based on an earlier patch by Akira Fujita.
>> >
>> >> Steps to reproduce:
>> >> 1. mke2fs -t ext4 -b 4096 -O ^resize_inode device 2. e2fsck -b
>> >> 32768 DEV
>> >>   <snip>
>> >>   Pass 1: Checking inodes, blocks, and sizes
>> >>   Pass 2: Checking directory structure
>> >>   Pass 3: Checking directory connectivity
>> >>   Pass 4: Checking reference counts
>> >>   Pass 5: Checking group summary information
>> >>   Block bitmap differences:  +(32768--32769) +(98304--98305) +(163840--163841)
>> >>   Fix<y>?
>> >
>> >Reported-by: Akira Fujita <a-fujita@rs.jp.nec.com>
>> >Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> >---
>> > lib/ext2fs/alloc_sb.c |   11 +++++++++--
>> > 1 file changed, 9 insertions(+), 2 deletions(-)
>> >
>> >diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c index
>> >223ec51..f1898df 100644
>> >--- a/lib/ext2fs/alloc_sb.c
>> >+++ b/lib/ext2fs/alloc_sb.c
>> >@@ -52,6 +52,15 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
>> > 	ext2fs_super_and_bgd_loc2(fs, group, &super_blk,
>> > 				  &old_desc_blk, &new_desc_blk, &used_blks);
>> >
>> >+	/*
>> >+	 * If we're marking blocks in the main block bitmap, be sure that we
>> >+	 * clear the group's BLOCK_UNINIT flag if this group has metadata
>> >+	 * blocks allocated.
>> >+	 */
>> >+	if (fs->block_map == bmap &&
>> >+	    (new_desc_blk || old_desc_blk || super_blk || (group == 0)))
>> >+		ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
>> >+
>> > 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
>> > 		old_desc_blocks = fs->super->s_first_meta_bg;
>> > 	else
>> >@@ -65,8 +74,6 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
>> > 		ext2fs_mark_block_bitmap2(bmap, 0);
>> >
>> > 	if (old_desc_blk) {
>> >-		if (fs->super->s_reserved_gdt_blocks && fs->block_map == bmap)
>> >-			ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
>> > 		num_blocks = old_desc_blocks;
>> > 		if (old_desc_blk + num_blocks >= ext2fs_blocks_count(fs->super))
>> > 			num_blocks = ext2fs_blocks_count(fs->super) -
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4"
>> in the body of a message to majordomo@vger.kernel.org More majordomo
>> info at  http://vger.kernel.org/majordomo-info.html
>--
>To unsubscribe from this list: send the line "unsubscribe linux-ext4" in the body of a message
to
>majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

