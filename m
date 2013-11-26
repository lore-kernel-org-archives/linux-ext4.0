From: "Akira Fujita" <a-fujita@rs.jp.nec.com>
Subject: RE: [PATCH] mke2fs: Fix block bitmaps initalization with -O ^resize_inode
Date: Tue, 26 Nov 2013 17:10:56 +0900
Message-ID: <003101ceea7f$08d3fda0$1a7bf8e0$@rs.jp.nec.com>
References: <52662BBA.70503@rs.jp.nec.com> <20131123013336.GD10269@birch.djwong.org> <20131126012706.GF10269@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Theodore Tso'" <tytso@mit.edu>,
	"'ext4 development'" <linux-ext4@vger.kernel.org>
To: "'Darrick J. Wong'" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:61724 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3KZIRd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Nov 2013 03:17:33 -0500
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id rAQ8HVS0004758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 26 Nov 2013 17:17:31 +0900 (JST)
In-Reply-To: <20131126012706.GF10269@birch.djwong.org>
Content-Language: ja
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Darrick,

With your patch, e2fsck can't fix the filesystem created with existing mke2fs without
resize_inode.
Because "fs->block_map == bmap" condition is in ext2fs_reserve_super_and_bgd().

But if the condition removed (like my previous patch) we can detect and
fix filesystem inconsistency as follows.

1.Create filesystem with existing mke2fs command
# mke2fs -t ext4 -O ^resize_inode DEVICE

2. (With my patch) e2fsck removes uninit_bg flag then fixes metadata inconsistency
# ./e2fsck/e2fsck -f DEVICE
e2fsck 1.43-WIP (8-Jul-2013)
One or more block group descriptor checksums are invalid.  Fix<y>? yes
Group descriptor 1 checksum is 0x0343, should be 0xc4ba.  FIXED.
Group descriptor 3 checksum is 0x17f2, should be 0xd00b.  FIXED.
Group descriptor 5 checksum is 0xf36c, should be 0x3495.  FIXED.
Group descriptor 7 checksum is 0x3e90, should be 0xf969.  FIXED.
Group descriptor 9 checksum is 0xa31e, should be 0x64e7.  FIXED.
Group descriptor 25 checksum is 0x165a, should be 0xd1a3.  FIXED.
Group descriptor 27 checksum is 0xce4c, should be 0x09b5.  FIXED.
Group descriptor 49 checksum is 0x502b, should be 0x97d2.  FIXED.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  +(32768--32769) +(98304--98305) +(163840--163841) +(229376--229377)
+(294912--294913) +(819200--819201) +(884736--884737) +(1605632--1605633)
Fix<y>? yes

/dev/loop0: ***** FILE SYSTEM WAS MODIFIED *****
/dev/loop0: 11/656640 files (0.0% non-contiguous), 73991/2621440 blocks

Regards,
Akira Fujita

>-----Original Message-----
>From: Darrick J. Wong [mailto:darrick.wong@oracle.com]
>Sent: Tuesday, November 26, 2013 10:27 AM
>To: Akira Fujita
>Cc: Theodore Tso; ext4 development
>Subject: Re: [PATCH] mke2fs: Fix block bitmaps initalization with -O ^resize_inode
>
>Does the following patch fix your error?  I think I've started to hit it too, now that I added
>^resize_inode,^meta_bg to the mix.
>
>--D
>
>libext2fs: clear BLOCK_UNINIT any time a group has metadata blocks
>
>If ext2fs_reserve_super_and_bgd() is called with the filesystem's block bitmap, we clear the
group's
>BLOCK_UNINIT flag if the group has an old-style (pre-metabg) group descriptor block with
reserved
>descriptor blocks prior to marking the old-style descriptor blocks in use.
>
>Unfortunately, this is not sufficient -- if the group has no reserved blocks yet isn't a
meta_bg
>filesystem (^resize_inode,^meta_bg), we forget to clear the flag, so the filesystem thinks all
>blocks are free, which is disastrous.
>
>Therefore, if we know that we're going to mark any of the bitmaps, make sure that we clear
>BLOCK_UNINIT.
>
>This is based on an earlier patch by Akira Fujita.
>
>> Steps to reproduce:
>> 1. mke2fs -t ext4 -b 4096 -O ^resize_inode device 2. e2fsck -b 32768
>> DEV
>>   <snip>
>>   Pass 1: Checking inodes, blocks, and sizes
>>   Pass 2: Checking directory structure
>>   Pass 3: Checking directory connectivity
>>   Pass 4: Checking reference counts
>>   Pass 5: Checking group summary information
>>   Block bitmap differences:  +(32768--32769) +(98304--98305) +(163840--163841)
>>   Fix<y>?
>
>Reported-by: Akira Fujita <a-fujita@rs.jp.nec.com>
>Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>---
> lib/ext2fs/alloc_sb.c |   11 +++++++++--
> 1 file changed, 9 insertions(+), 2 deletions(-)
>
>diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c index 223ec51..f1898df 100644
>--- a/lib/ext2fs/alloc_sb.c
>+++ b/lib/ext2fs/alloc_sb.c
>@@ -52,6 +52,15 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
> 	ext2fs_super_and_bgd_loc2(fs, group, &super_blk,
> 				  &old_desc_blk, &new_desc_blk, &used_blks);
>
>+	/*
>+	 * If we're marking blocks in the main block bitmap, be sure that we
>+	 * clear the group's BLOCK_UNINIT flag if this group has metadata
>+	 * blocks allocated.
>+	 */
>+	if (fs->block_map == bmap &&
>+	    (new_desc_blk || old_desc_blk || super_blk || (group == 0)))
>+		ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
>+
> 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
> 		old_desc_blocks = fs->super->s_first_meta_bg;
> 	else
>@@ -65,8 +74,6 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
> 		ext2fs_mark_block_bitmap2(bmap, 0);
>
> 	if (old_desc_blk) {
>-		if (fs->super->s_reserved_gdt_blocks && fs->block_map == bmap)
>-			ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
> 		num_blocks = old_desc_blocks;
> 		if (old_desc_blk + num_blocks >= ext2fs_blocks_count(fs->super))
> 			num_blocks = ext2fs_blocks_count(fs->super) -

