From: Gui Xiaohua <guixh@cn.fujitsu.com>
Subject: [PATCH]:resize2fs:adjust the inode before inode_tables were covered
Date: Thu, 12 Mar 2009 16:14:46 +0800
Message-ID: <49B8C476.1010003@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62043 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbZCLISI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2009 04:18:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted
There is a problem in your patch for resize2fs -M.
You unmark the inode_table block in new fs,the blocks 
which needed to be moved will cover the the inode_table
blocks with its content.In inode_scan_and_fix func, we will
scan the inode which in the old fs, but the inode table block
had been coverd,then error occurs.
I had fixed the problem through adjust the inode before blocks
be moved.

Signed-off-by: Gui Xiaohua <guixh@cn.fujitsu.com>
--- e2fsprogs_org/resize/resize2fs.c	2009-02-05 09:33:26.000000000 +0800
+++ e2fsprogs/resize/resize2fs.c	2009-02-05 19:17:34.000000000 +0800
@@ -49,6 +49,7 @@ static errcode_t inode_ref_fix(ext2_resi
 static errcode_t move_itables(ext2_resize_t rfs);
 static errcode_t fix_resize_inode(ext2_filsys fs);
 static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs);
+static errcode_t inode_swap(ext2_resize_t rfs);
 
 /*
  * Some helper CPP macros
@@ -235,18 +236,23 @@ static void fix_uninit_block_bitmaps(ext
  * If the group descriptor's bitmap and inode table blocks are valid,
  * release them in the specified filesystem data structure
  */
-static void free_gdp_blocks(ext2_filsys fs, struct ext2_group_desc *gdp)
+static void free_gdp_blocks(ext2_filsys old_fs, ext2_filsys fs,
+			    struct ext2_group_desc *gdp)
 {
 	blk_t	blk;
 	int	j;
 
 	if (gdp->bg_block_bitmap &&
-	    (gdp->bg_block_bitmap < fs->super->s_blocks_count))
+	    (gdp->bg_block_bitmap < fs->super->s_blocks_count)) {
 		ext2fs_block_alloc_stats(fs, gdp->bg_block_bitmap, -1);
+		ext2fs_block_alloc_stats(old_fs, gdp->bg_block_bitmap, -1);
+	}
 
 	if (gdp->bg_inode_bitmap &&
-	    (gdp->bg_inode_bitmap < fs->super->s_blocks_count))
+	    (gdp->bg_inode_bitmap < fs->super->s_blocks_count)) {
 		ext2fs_block_alloc_stats(fs, gdp->bg_inode_bitmap, -1);
+		ext2fs_block_alloc_stats(old_fs, gdp->bg_inode_bitmap, -1);
+	}
 
 	if (gdp->bg_inode_table == 0 ||
 	    (gdp->bg_inode_table >= fs->super->s_blocks_count))
@@ -257,6 +263,7 @@ static void free_gdp_blocks(ext2_filsys 
 		if (blk >= fs->super->s_blocks_count)
 			break;
 		ext2fs_block_alloc_stats(fs, blk, -1);
+		ext2fs_block_alloc_stats(old_fs, blk, -1);
 	}
 }
 
@@ -403,14 +410,6 @@ retry:
 	 * can exit now.
 	 */
 	if (old_fs->group_desc_count > fs->group_desc_count) {
-		/*
-		 * Check the block groups that we are chopping off
-		 * and free any blocks associated with their metadata
-		 */
-		for (i = fs->group_desc_count;
-		     i < old_fs->group_desc_count; i++) {
-			free_gdp_blocks(fs, &old_fs->group_desc[i]);
-		}
 		retval = 0;
 		goto errout;
 	}
@@ -554,6 +553,21 @@ static errcode_t adjust_superblock(ext2_
 	if (retval)
 		goto errout;
 
+	if (rfs->old_fs->group_desc_count > fs->group_desc_count) {
+		/*
+		 * Check the block groups that we are chopping off
+		 * and free any blocks associated with their metadata
+		 */
+		retval = inode_swap(rfs);
+		if (retval)
+			goto errout;
+		for (i = fs->group_desc_count;
+		     i < rfs->old_fs->group_desc_count; i++) {
+			free_gdp_blocks(rfs->old_fs, fs,
+					&rfs->old_fs->group_desc[i]);
+		}
+	}
+
 	/*
 	 * Check to make sure there are enough inodes
 	 */
@@ -1964,3 +1978,92 @@ blk_t calculate_minimum_resize_size(ext2
 
 	return blks_needed;
 }
+
+/*
+ * adjust the inodes info
+ */
+static errcode_t inode_swap(ext2_resize_t rfs)
+{
+	int		inode_size, i;
+	char		*block_buf = 0;
+	errcode_t	retval;
+	ext2_ino_t	ino, new_inode, start_to_move;
+	ext2_inode_scan scan = NULL;
+	struct ext2_inode *inode = NULL;
+
+	retval = ext2fs_open_inode_scan(rfs->old_fs, 0, &scan);
+	ext2fs_set_inode_callback(scan, progress_callback, (void *) rfs);
+	inode_size = EXT2_INODE_SIZE(rfs->new_fs->super);
+	inode = malloc(inode_size);
+	if (!inode) {
+		retval = ENOMEM;
+		goto errout;
+	}
+
+	start_to_move = (rfs->new_fs->group_desc_count *
+			 rfs->new_fs->super->s_inodes_per_group);
+	/*
+	 * First, copy all of the inodes that need to be moved
+	 * elsewhere in the inode table
+	 */
+	while (1) {
+		retval = ext2fs_get_next_inode_full(scan, &ino,
+						    inode, inode_size);
+		if (retval)
+			goto errout;
+
+		if (!ino)
+			break;
+		if (inode->i_links_count == 0 && ino != EXT2_RESIZE_INO)
+			continue; /* inode not in use */
+		if (ino <= start_to_move)
+			continue; /* Don't need to move it. */
+
+		/*
+		 * Find a new inode
+		 */
+		retval = ext2fs_new_inode(rfs->new_fs, 0, 0, 0,
+					  &new_inode);
+		if (retval)
+			goto errout;
+
+		ext2fs_inode_alloc_stats2(rfs->new_fs, new_inode, +1,
+					  LINUX_S_ISDIR(inode->i_mode));
+		ext2fs_inode_alloc_stats2(rfs->old_fs, new_inode, +1,
+					  LINUX_S_ISDIR(inode->i_mode));
+		ext2fs_inode_alloc_stats2(rfs->old_fs, ino, -1,
+					  LINUX_S_ISDIR(inode->i_mode));
+
+		inode->i_ctime = time(0);
+		retval = ext2fs_write_inode_full(rfs->old_fs, new_inode,
+						 inode, inode_size);
+		if (retval)
+			goto errout;
+
+		if (!rfs->imap) {
+			retval = ext2fs_create_extent_table(&rfs->imap, 0);
+			if (retval)
+				goto errout;
+		}
+		ext2fs_add_extent_entry(rfs->imap, ino, new_inode);
+	}
+
+	/*
+	 *reduce the count of circle and prevent read wrong blocks
+	 *while inode_scan_and_fix
+	 */
+	for (i = rfs->new_fs->group_desc_count;
+	     i < rfs->old_fs->group_desc_count; i++) {
+		rfs->old_fs->group_desc[i].bg_itable_unused =
+			EXT2_INODES_PER_GROUP(rfs->old_fs->super);
+	}
+
+errout:
+	if (scan)
+		ext2fs_close_inode_scan(scan);
+	if (block_buf)
+		ext2fs_free_mem(&block_buf);
+	if (inode)
+		free(inode);
+	return retval;
+}






