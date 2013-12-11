From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 38/74] libext2fs: mark group data blocks when loading block
 bitmap
Date: Tue, 10 Dec 2013 17:22:33 -0800
Message-ID: <20131211012233.30655.1041.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43147 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3LKBWj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:22:39 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The kernel[1] and e2fsck[2] both react to a BLOCK_UNINIT group by
calculating the block bitmap that's needed to show all the group
blocks for that group (if any) and using that.  However, when reading
bitmaps from disk, libext2fs simply imports a block of zeroes into the
bitmap, without bothering to check for group blocks.  This erroneous
behavior results in the filesystem having a block bitmap that does not
accurately reflect disk contents, and worse yet makes it seem as
though superblocks, group descriptors, bitmaps, and inode tables are
"free" space on disk.

So, fix the block bitmap loading routines to calculate the correct
block bitmap for all groups and load it into the main fs block bitmap.

This also fixes bogus debugfs output such as:

Group 1: (Blocks 8193-16384) [INODE_UNINIT, BLOCK_UNINIT]
  Checksum 0x1310, unused inodes 512
  Backup superblock at 8193, Group descriptors at 8194-8217
  Reserved GDT blocks at 8218-8473
  Block bitmap at 283 (bg #0 + 282), Inode bitmap at 299 (bg #0 + 298)
  Inode table at 442-569 (bg #0 + 441)
  7911 free blocks, 512 free inodes, 0 directories, 512 unused inodes
  Free blocks: 8193-16384
  Free inodes: 513-1024

Notice how the "free blocks" range includes the backup sb & GDT area
and doesn't match the free block count.

Worse yet, debugfs' testb command will report those group descriptor
blocks as not being in use unless the user also instructs debugfs to
find a free block first.  That is a rather surprising result:

debugfs:  testb 8194
Block 8194 not in use
debugfs:  ffb 1 16380
Free blocks found: 16380
debugfs:  testb 8194
Block 8194 marked in use

Also, remove the part of check_block_uninit() that "fixes" the bitmap
since we're doing that at bitmap load time now.

[1] kernel git 717d50e4971b81b96c0199c91cdf0039a8cb181a
    "Ext4: Uninitialized Block Groups"
[2] e2fsprogs git f5fa20078bfc05b554294fe9c5505375d7913e8c
    "Add support for EXT2_FEATURE_COMPAT_LAZY_BG"

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/alloc.c      |   17 +----------------
 lib/ext2fs/rw_bitmaps.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 16 deletions(-)


diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index ce72ffe..39ef24f 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -51,23 +51,8 @@ static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
 	else
 		old_desc_blocks = fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
 
-	for (i=0; i < fs->super->s_blocks_per_group; i++, blk++)
-		ext2fs_fast_unmark_block_bitmap2(map, blk);
+	/* uninit block bitmaps are now initialized in read_bitmaps() */
 
-	blk = ext2fs_group_first_block2(fs, group);
-	for (i=0; i < fs->super->s_blocks_per_group; i++, blk++) {
-		if ((blk == super_blk) ||
-		    (old_desc_blk && old_desc_blocks &&
-		     (blk >= old_desc_blk) &&
-		     (blk < old_desc_blk + old_desc_blocks)) ||
-		    (new_desc_blk && (blk == new_desc_blk)) ||
-		    (blk == ext2fs_block_bitmap_loc(fs, group)) ||
-		    (blk == ext2fs_inode_bitmap_loc(fs, group)) ||
-		    (blk >= ext2fs_inode_table_loc(fs, group) &&
-		     (blk < ext2fs_inode_table_loc(fs, group)
-		      + fs->inode_blocks_per_group)))
-			ext2fs_fast_mark_block_bitmap2(map, blk);
-	}
 	ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
 	ext2fs_group_desc_csum_set(fs, group);
 	ext2fs_mark_super_dirty(fs);
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 386cbeb..ad6cfc1 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -156,6 +156,43 @@ errout:
 	return retval;
 }
 
+static errcode_t mark_uninit_bg_group_blocks(ext2_filsys fs)
+{
+	dgrp_t			i;
+	blk64_t			blk;
+	ext2fs_block_bitmap	bmap = fs->block_map;
+
+	for (i = 0; i < fs->group_desc_count; i++) {
+		if (!ext2fs_bg_flags_test(fs, i, EXT2_BG_BLOCK_UNINIT))
+			continue;
+
+		ext2fs_reserve_super_and_bgd(fs, i, bmap);
+
+		/*
+		 * Mark the blocks used for the inode table
+		 */
+		blk = ext2fs_inode_table_loc(fs, i);
+		if (blk)
+			ext2fs_mark_block_bitmap_range2(bmap, blk,
+						fs->inode_blocks_per_group);
+
+		/*
+		 * Mark block used for the block bitmap
+		 */
+		blk = ext2fs_block_bitmap_loc(fs, i);
+		if (blk)
+			ext2fs_mark_block_bitmap2(bmap, blk);
+
+		/*
+		 * Mark block used for the inode bitmap
+		 */
+		blk = ext2fs_inode_bitmap_loc(fs, i);
+		if (blk)
+			ext2fs_mark_block_bitmap2(bmap, blk);
+	}
+	return 0;
+}
+
 static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 {
 	dgrp_t i;
@@ -320,6 +357,14 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 			ino_itr += inode_nbytes << 3;
 		}
 	}
+
+	/* Mark group blocks for any BLOCK_UNINIT groups */
+	if (do_block) {
+		retval = mark_uninit_bg_group_blocks(fs);
+		if (retval)
+			goto cleanup;
+	}
+
 success_cleanup:
 	if (inode_bitmap)
 		ext2fs_free_mem(&inode_bitmap);

