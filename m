From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] resize2fs: Fix data corruption bug when shrinking the inode table for ext4
Date: Sat, 18 Apr 2009 23:03:47 -0400
Message-ID: <1240110228-22781-3-git-send-email-tytso@mit.edu>
References: <1240110228-22781-1-git-send-email-tytso@mit.edu>
 <1240110228-22781-2-git-send-email-tytso@mit.edu>
Cc: sandeen@redhat.com, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51486 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbZDSDDz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Apr 2009 23:03:55 -0400
In-Reply-To: <1240110228-22781-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we need to shrink the inode table, we need to make sure the inodes
contained in the part of the inode table we are vacating don't get
reused as part of the filesystem shrink operation.  This wasn't a
problem with ext3 filesystems, since the inode table was located in
the block group that was going away, so that location was not eligible
for reallocation.

However with ext4 filesystems with flex_bg enabled, it's possible for
a portion of the inode table in the last flex_bg group to be
deallocated, but in a part of the filesystem which could be used as
data blocks.  So we must mark those blocks as reserved to prevent
their reuse, and adjust the minimum filesystem size calculation to
assure that we don't shrink a filesystem too small for the resize
operation to succeed.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/online.c    |    2 +-
 resize/resize2fs.c |   56 +++++++++++++++++++++++++++++++++++++++-------------
 resize/resize2fs.h |    1 +
 3 files changed, 44 insertions(+), 15 deletions(-)

diff --git a/resize/online.c b/resize/online.c
index d581553..4bc5451 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -104,7 +104,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 	 * but at least it allows on-line resizing to function.
 	 */
 	new_fs->super->s_feature_incompat &= ~EXT4_FEATURE_INCOMPAT_FLEX_BG;
-	retval = adjust_fs_info(new_fs, fs, *new_size);
+	retval = adjust_fs_info(new_fs, fs, 0, *new_size);
 	if (retval)
 		return retval;
 
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 0c1549b..ac926ce 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -233,20 +233,29 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
 
 /*
  * If the group descriptor's bitmap and inode table blocks are valid,
- * release them in the specified filesystem data structure
+ * release them in the new filesystem data structure, and mark them as
+ * reserved so the old inode table blocks don't get overwritten.
  */
-static void free_gdp_blocks(ext2_filsys fs, struct ext2_group_desc *gdp)
+static void free_gdp_blocks(ext2_filsys fs,
+			    ext2fs_block_bitmap reserve_blocks,
+			    struct ext2_group_desc *gdp)
 {
 	blk_t	blk;
 	int	j;
 
 	if (gdp->bg_block_bitmap &&
-	    (gdp->bg_block_bitmap < fs->super->s_blocks_count))
+	    (gdp->bg_block_bitmap < fs->super->s_blocks_count)) {
 		ext2fs_block_alloc_stats(fs, gdp->bg_block_bitmap, -1);
+		ext2fs_mark_block_bitmap(reserve_blocks,
+					 gdp->bg_block_bitmap);
+	}
 
 	if (gdp->bg_inode_bitmap &&
-	    (gdp->bg_inode_bitmap < fs->super->s_blocks_count))
+	    (gdp->bg_inode_bitmap < fs->super->s_blocks_count)) {
 		ext2fs_block_alloc_stats(fs, gdp->bg_inode_bitmap, -1);
+		ext2fs_mark_block_bitmap(reserve_blocks,
+					 gdp->bg_inode_bitmap);
+	}
 
 	if (gdp->bg_inode_table == 0 ||
 	    (gdp->bg_inode_table >= fs->super->s_blocks_count))
@@ -257,14 +266,19 @@ static void free_gdp_blocks(ext2_filsys fs, struct ext2_group_desc *gdp)
 		if (blk >= fs->super->s_blocks_count)
 			break;
 		ext2fs_block_alloc_stats(fs, blk, -1);
+		ext2fs_mark_block_bitmap(reserve_blocks, blk);
 	}
 }
 
 /*
  * This routine is shared by the online and offline resize routines.
  * All of the information which is adjusted in memory is done here.
+ *
+ * The reserve_blocks parameter is only needed when shrinking the
+ * filesystem.
  */
-errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs, blk_t new_size)
+errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs,
+			 ext2fs_block_bitmap reserve_blocks, blk_t new_size)
 {
 	errcode_t	retval;
 	int		overhead = 0;
@@ -399,8 +413,8 @@ retry:
 	}
 
 	/*
-	 * If we are shrinking the number block groups, we're done and
-	 * can exit now.
+	 * If we are shrinking the number of block groups, we're done
+	 * and can exit now.
 	 */
 	if (old_fs->group_desc_count > fs->group_desc_count) {
 		/*
@@ -409,7 +423,8 @@ retry:
 		 */
 		for (i = fs->group_desc_count;
 		     i < old_fs->group_desc_count; i++) {
-			free_gdp_blocks(fs, &old_fs->group_desc[i]);
+			free_gdp_blocks(fs, reserve_blocks,
+					&old_fs->group_desc[i]);
 		}
 		retval = 0;
 		goto errout;
@@ -550,7 +565,12 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk_t new_size)
 	ext2fs_mark_bb_dirty(fs);
 	ext2fs_mark_ib_dirty(fs);
 
-	retval = adjust_fs_info(fs, rfs->old_fs, new_size);
+	retval = ext2fs_allocate_block_bitmap(fs, _("reserved blocks"),
+					      &rfs->reserve_blocks);
+	if (retval)
+		return retval;
+
+	retval = adjust_fs_info(fs, rfs->old_fs, rfs->reserve_blocks, new_size);
 	if (retval)
 		goto errout;
 
@@ -753,11 +773,6 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	if (old_fs->super->s_blocks_count > fs->super->s_blocks_count)
 		fs = rfs->old_fs;
 
-	retval = ext2fs_allocate_block_bitmap(fs, _("reserved blocks"),
-					      &rfs->reserve_blocks);
-	if (retval)
-		return retval;
-
 	retval = ext2fs_allocate_block_bitmap(fs, _("blocks to be moved"),
 					      &rfs->move_blocks);
 	if (retval)
@@ -1877,6 +1892,19 @@ blk_t calculate_minimum_resize_size(ext2_filsys fs)
 	data_needed -= SUPER_OVERHEAD(fs) * num_of_superblocks;
 	data_needed -= META_OVERHEAD(fs) * fs->group_desc_count;
 
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) {
+		/*
+		 * For ext4 we need to allow for up to a flex_bg worth
+		 * of inode tables of slack space so the resize
+		 * operation can be guaranteed to finish.
+		 */
+		int flexbg_size = 1 << fs->super->s_log_groups_per_flex;
+		int extra_groups;
+
+		extra_groups = flexbg_size - (groups & (flexbg_size - 1));
+		data_needed += META_OVERHEAD(fs) * extra_groups;
+	}
+
 	/*
 	 * figure out how many data blocks we have given the number of groups
 	 * we need for our inodes
diff --git a/resize/resize2fs.h b/resize/resize2fs.h
index ed25b06..fab7290 100644
--- a/resize/resize2fs.h
+++ b/resize/resize2fs.h
@@ -128,6 +128,7 @@ extern errcode_t resize_fs(ext2_filsys fs, blk_t *new_size, int flags,
 					    unsigned long max));
 
 extern errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs,
+				ext2fs_block_bitmap reserve_blocks,
 				blk_t new_size);
 extern blk_t calculate_minimum_resize_size(ext2_filsys fs);
 
-- 
1.5.6.3

