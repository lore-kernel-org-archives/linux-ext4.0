From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fix up lazy_bg bitmap initialization at mkfs time
Date: Thu, 19 Apr 2007 16:07:45 -0500
Message-ID: <4627DA21.7050002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965164AbXDSVLw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Apr 2007 17:11:52 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l3JLBl1Z013634
	for <linux-ext4@vger.kernel.org>; Thu, 19 Apr 2007 17:11:48 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l3JLBlwV023685
	for <linux-ext4@vger.kernel.org>; Thu, 19 Apr 2007 17:11:47 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l3JLBkWR004162
	for <linux-ext4@vger.kernel.org>; Thu, 19 Apr 2007 17:11:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

While trying out the -O lazy_bg option, I ran into some trouble on my
big filesystem.  The journal size was > free blocks in the first block group,
so it spilled into the next bg with available blocks.  Since we are using
lazy_bg here, that -should- have been the last block group.  But, when
setup_lazy_bg() marks block groups as UNINIT, it doesn't do anything with
the bitmaps (as designed).  However, the block allocation routine simply
searches the bitmap for next available blocks, and finds them in the 2nd
bg, despite it being marked UNINIT - the summaries aren't checked during
allocation.  This also caused the 1st group free block numbers to get
out of whack, as we start subtracting from zero:

Group  0: block bitmap at 1025, inode bitmap at 1026, inode table at 1027
          0 free blocks, 16373 free inodes, 2 used directories
Group  1: block bitmap at 33793, inode bitmap at 33794, inode table at 33795
          63957 free blocks, 0 free inodes, 0 used directories
          [Inode not init, Block not init]
Group  2: block bitmap at 65536, inode bitmap at 65537, inode table at 65538
          0 free blocks, 0 free inodes, 0 used directories
          [Inode not init, Block not init]

The following patch seems to fix this up for me; just mark the in-memory
bitmaps as full for any bg's we flag as UNINIT.  The bitmaps aren't marked
as dirty, so they won't be written out.  When bitmaps are re-read on the next
invocation of debugfs, etc, the UNINIT flag will be found, and again
the in-memory bitmaps will be marked as full.

This has the somewhat interesting, but correct, result of making the
journal blocks land in both the first and last bgs of a 16T filesystem:  :)

BLOCKS:
(0-11):1520-1531, (IND):1532, (12-1035):1533-2556, <...> 
(IND):4194272286, (31756-32768):4194272287-419427329

Unfortunately it also increases mkfs time a bit, as it must search
a huge string of unavailable blocks if it has to allocate in the 
last bg.  Ah well...

Thanks,
-Eric

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-1.39_ext4_hg/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.39_ext4_hg.orig/misc/mke2fs.c
+++ e2fsprogs-1.39_ext4_hg/misc/mke2fs.c
@@ -450,16 +450,22 @@ static void setup_lazy_bg(ext2_filsys fs
 	int blks;
 	struct ext2_super_block *sb = fs->super;
 	struct ext2_group_desc *bg = fs->group_desc;
+	char *block_bitmap = fs->block_map->bitmap;
+	char *inode_bitmap = fs->inode_map->bitmap;
+	int block_nbytes = (int) EXT2_BLOCKS_PER_GROUP(fs->super) / 8;
+	int inode_nbytes = (int) EXT2_INODES_PER_GROUP(fs->super) / 8;
 
 	if (EXT2_HAS_COMPAT_FEATURE(fs->super, 
 				    EXT2_FEATURE_COMPAT_LAZY_BG)) {
 		for (i = 0; i < fs->group_desc_count; i++, bg++) {
 			if ((i == 0) ||
 			    (i == fs->group_desc_count-1))
-				continue;
+				goto skip;
 			if (bg->bg_free_inodes_count ==
 			    sb->s_inodes_per_group) {
 				bg->bg_free_inodes_count = 0;
+				/* NB: set in mem only, see also read_bitmaps */
+				memset(inode_bitmap, 0xff, inode_nbytes);
 				bg->bg_flags |= EXT2_BG_INODE_UNINIT;
 				sb->s_free_inodes_count -= 
 					sb->s_inodes_per_group;
@@ -467,9 +473,13 @@ static void setup_lazy_bg(ext2_filsys fs
 			blks = ext2fs_super_and_bgd_loc(fs, i, 0, 0, 0, 0);
 			if (bg->bg_free_blocks_count == blks) {
 				bg->bg_free_blocks_count = 0;
+				memset(block_bitmap, 0xff, block_nbytes);
 				bg->bg_flags |= EXT2_BG_BLOCK_UNINIT;
 				sb->s_free_blocks_count -= blks;
 			}
+skip:
+			block_bitmap += block_nbytes;
+			inode_bitmap += inode_nbytes;
 		}
 	}
 }
