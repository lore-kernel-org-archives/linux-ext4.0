From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Add blocks added during resize to bitmap
Date: Mon, 19 Jan 2009 17:09:29 +0530
Message-ID: <20090119113929.GI9482@skywalker>
References: <E1LOG9D-0006h4-7R@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:42634 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbZATI3d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jan 2009 03:29:33 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id n0JBwHZb111894
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 22:59:07 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0JBdgbC015116
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 22:39:42 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n0JBdfme011415
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 22:39:42 +1100
Content-Disposition: inline
In-Reply-To: <E1LOG9D-0006h4-7R@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Add blocks added during resize to bitmap

With this change new blocks added during resize
are marked as free in the block bitmap and the
group is flagged with EXT4_GROUP_INFO_NEED_INIT_BIT
flag. This make sure when mballoc tries to allocate
blocks from the new group we would reload the
buddy information using the bitmap present in the disk.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu> 

---
 fs/ext4/balloc.c |  126 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h   |    6 ++-
 fs/ext4/resize.c |   11 +----
 3 files changed, 132 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e9fa960..1b375bb 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -20,6 +20,7 @@
 #include "ext4.h"
 #include "ext4_jbd2.h"
 #include "group.h"
+#include "mballoc.h"
 
 /*
  * balloc.c contains the blocks allocation and deallocation routines
@@ -837,6 +838,131 @@ error_return:
 }
 
 /**
+ * ext4_add_groupblocks() -- Add given blocks to an existing group
+ * @handle:			handle to this transaction
+ * @sb:				super block
+ * @block:			start physcial block to add to the block group
+ * @count:			number of blocks to free
+ *
+ * This marks the blocks as free in the bitmap. We ask the
+ * mballoc to reload the buddy after this by setting group
+ * EXT4_GROUP_INFO_NEED_INIT_BIT flag
+ */
+void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
+			 ext4_fsblk_t block, unsigned long count)
+{
+	struct buffer_head *bitmap_bh = NULL;
+	struct buffer_head *gd_bh;
+	ext4_group_t block_group;
+	ext4_grpblk_t bit;
+	unsigned long i;
+	struct ext4_group_desc * desc;
+	struct ext4_super_block * es;
+	struct ext4_sb_info *sbi;
+	int err = 0, ret;
+	ext4_grpblk_t blocks_freed;
+	struct ext4_group_info *grp;
+
+	sbi = EXT4_SB(sb);
+	es = sbi->s_es;
+	ext4_debug("Adding block(s) %llu-%llu\n", block, block + count - 1);
+
+	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
+	/*
+	 * Check to see if we are freeing blocks across a group
+	 * boundary.
+	 */
+	if (bit + count > EXT4_BLOCKS_PER_GROUP(sb)) {
+		goto error_return;
+	}
+	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
+	if (!bitmap_bh)
+		goto error_return;
+	desc = ext4_get_group_desc (sb, block_group, &gd_bh);
+	if (!desc)
+		goto error_return;
+
+	if (in_range(ext4_block_bitmap(sb, desc), block, count) ||
+	    in_range(ext4_inode_bitmap(sb, desc), block, count) ||
+	    in_range(block, ext4_inode_table(sb, desc), sbi->s_itb_per_group) ||
+	    in_range(block + count - 1, ext4_inode_table(sb, desc),
+		     sbi->s_itb_per_group)) {
+		ext4_error(sb, __func__,
+			   "Adding blocks in system zones - "
+			    "Block = %llu, count = %lu",
+			    block, count);
+		goto error_return;
+	}
+
+	/*
+	 * We are about to add blocks to the bitmap,
+	 * so we need undo access.
+	 */
+	BUFFER_TRACE(bitmap_bh, "getting undo access");
+	err = ext4_journal_get_undo_access(handle, bitmap_bh);
+	if (err)
+		goto error_return;
+
+	/*
+	 * We are about to modify some metadata.  Call the journal APIs
+	 * to unshare ->b_data if a currently-committing transaction is
+	 * using it
+	 */
+	BUFFER_TRACE(gd_bh, "get_write_access");
+	err = ext4_journal_get_write_access(handle, gd_bh);
+	if (err)
+		goto error_return;
+
+	for (i = 0, blocks_freed = 0; i < count; i++) {
+		BUFFER_TRACE(bitmap_bh, "clear bit");
+		if (!ext4_clear_bit_atomic(sb_bgl_lock(sbi, block_group),
+						bit + i, bitmap_bh->b_data)) {
+			ext4_error(sb, __func__,
+				   "bit already cleared for block %llu",
+				   (ext4_fsblk_t)(block + i));
+			BUFFER_TRACE(bitmap_bh, "bit already cleared");
+		} else {
+			blocks_freed++;
+		}
+	}
+	spin_lock(sb_bgl_lock(sbi, block_group));
+	le16_add_cpu(&desc->bg_free_blocks_count, blocks_freed);
+	desc->bg_checksum = ext4_group_desc_csum(sbi, block_group, desc);
+	spin_unlock(sb_bgl_lock(sbi, block_group));
+	percpu_counter_add(&sbi->s_freeblocks_counter, blocks_freed);
+
+	if (sbi->s_log_groups_per_flex) {
+		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
+		spin_lock(sb_bgl_lock(sbi, flex_group));
+		sbi->s_flex_groups[flex_group].free_blocks += blocks_freed;
+		spin_unlock(sb_bgl_lock(sbi, flex_group));
+	}
+
+	/* We dirtied the bitmap block */
+	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
+	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
+
+	/* And the group descriptor block */
+	BUFFER_TRACE(gd_bh, "dirtied group descriptor block");
+	ret = ext4_journal_dirty_metadata(handle, gd_bh);
+	if (!err)
+		err = ret;
+	sb->s_dirt = 1;
+	/*
+	 * request to reload the buddy with the
+	 * new bitmap information
+	 */
+	grp = ext4_get_group_info(sb, block_group);
+	set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &(grp->bb_state));
+	ext4_mb_update_group_info(grp, blocks_freed);
+
+error_return:
+	brelse(bitmap_bh);
+	ext4_std_error(sb, err);
+	return;
+}
+
+/**
  * ext4_free_blocks() -- Free given blocks and update quota
  * @handle:		handle for this transaction
  * @inode:		inode
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b0483ce..98de963 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -992,8 +992,10 @@ extern ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t block, unsigned long count, int metadata);
 extern void ext4_free_blocks_sb (handle_t *handle, struct super_block *sb,
-				 ext4_fsblk_t block, unsigned long count,
-				unsigned long *pdquot_freed_blocks);
+		                               ext4_fsblk_t block, unsigned long count,
+		                               unsigned long *pdquot_freed_blocks);
+extern void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
+				ext4_fsblk_t block, unsigned long count);
 extern ext4_fsblk_t ext4_count_free_blocks (struct super_block *);
 extern void ext4_check_blocks_bitmap (struct super_block *);
 extern struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 5726c5e..d7e9761 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -974,9 +974,7 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	struct buffer_head * bh;
 	handle_t *handle;
 	int err;
-	unsigned long freed_blocks;
 	ext4_group_t group;
-	struct ext4_group_info *grp;
 
 	/* We don't need to worry about locking wrt other resizers just
 	 * yet: we're going to revalidate es->s_blocks_count after
@@ -1075,7 +1073,8 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	unlock_super(sb);
 	ext4_debug("freeing blocks %llu through %llu\n", o_blocks_count,
 		   o_blocks_count + add);
-	ext4_free_blocks_sb(handle, sb, o_blocks_count, add, &freed_blocks);
+	/* We add the blocks to the bitmap and set the group need init bit */
+	ext4_add_groupblocks(handle, sb, o_blocks_count, add);
 	ext4_debug("freed blocks %llu through %llu\n", o_blocks_count,
 		   o_blocks_count + add);
 	if ((err = ext4_journal_stop(handle)))
@@ -1111,12 +1110,6 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 			ClearPageUptodate(page);
 			page_cache_release(page);
 		}
-
-		/* Get the info on the last group */
-		grp = ext4_get_group_info(sb, group);
