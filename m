From: Andreas Dilger <adilger@clusterfs.com>
Subject: [PATCH] (unfinished) don't alloc/free in system zones
Date: Fri, 3 Aug 2007 17:50:13 -0600
Message-ID: <20070803235013.GA6142@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:42721 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758807AbXHCXuQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 19:50:16 -0400
Received: from localhost.adilger.int (S01060004e23cfc51.ek.shawcable.net [24.66.76.119])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.clusterfs.com (Postfix) with ESMTP id C35284E4567
	for <linux-ext4@vger.kernel.org>; Fri,  3 Aug 2007 17:50:14 -0600 (MDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

It seems there is a long-standing defect in ext2/ext3/ext4 in the 2.6
kernels that hasn't been fixed, even though I thought it was.

There are checks in ext[234]_{new,free}_blocks() to see if the block(s)
being allocated or freed overlap with the bitmaps or inode tables, but
if the filesystem is mounted with "errors=continue" (the default), then
even though an error is printed the allocation or free will succeed and
this will lead to filesystem corruption.

There was a patch posted in
http://marc.info/?l=linux-ext4&m=116360109620982&w=2
that should be added to the ext[234] patch queue that fixes this problem.

We might also consider making "errors=remount-ro" the default for ext4,
this has long been the default for Debian users of ext[23].


Signed-Off-By: Andreas Dilger <adilger@clusterfs.com>
Signed-Off-By: Andre Noll <maan@systemlinux.org>
---
 fs/ext3/balloc.c |  102 +++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 75 insertions(+), 27 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 063d994..763b7a0 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -359,17 +359,6 @@ do_more:
 	if (!desc)
 		goto error_return;
 
-	if (in_range (le32_to_cpu(desc->bg_block_bitmap), block, count) ||
-	    in_range (le32_to_cpu(desc->bg_inode_bitmap), block, count) ||
-	    in_range (block, le32_to_cpu(desc->bg_inode_table),
-		      sbi->s_itb_per_group) ||
-	    in_range (block + count - 1, le32_to_cpu(desc->bg_inode_table),
-		      sbi->s_itb_per_group))
-		ext3_error (sb, "ext3_free_blocks",
-			    "Freeing blocks in system zones - "
-			    "Block = "E3FSBLK", count = %lu",
-			    block, count);
-
 	/*
 	 * We are about to start releasing blocks in the bitmap,
 	 * so we need undo access.
@@ -392,7 +381,17 @@ do_more:
 
 	jbd_lock_bh_state(bitmap_bh);
 
-	for (i = 0, group_freed = 0; i < count; i++) {
+	for (i = 0, group_freed = 0; i < count; i++, block++) {
+		struct ext3_group_desc *gdp = ext3_get_group_desc(sb, i, NULL);
+		if (block == le32_to_cpu(gdp->bg_block_bitmap) ||
+			block == le32_to_cpu(gdp->bg_inode_bitmap) ||
+			in_range(block, le32_to_cpu(gdp->bg_inode_table),
+				EXT3_SB(sb)->s_itb_per_group)) {
+			ext3_error(sb, __FUNCTION__,
+				"Freeing block in system zone - block = %lu",
+				block);
+			continue;
+		}
 		/*
 		 * An HJ special.  This is expensive...
 		 */
@@ -400,7 +399,7 @@ do_more:
 		jbd_unlock_bh_state(bitmap_bh);
 		{
 			struct buffer_head *debug_bh;
-			debug_bh = sb_find_get_block(sb, block + i);
+			debug_bh = sb_find_get_block(sb, block);
 			if (debug_bh) {
 				BUFFER_TRACE(debug_bh, "Deleted!");
 				if (!bh2jh(bitmap_bh)->b_committed_data)
@@ -452,7 +451,7 @@ do_more:
 			jbd_unlock_bh_state(bitmap_bh);
 			ext3_error(sb, __FUNCTION__,
 				"bit already cleared for block "E3FSBLK,
-				 block + i);
+				block);
 			jbd_lock_bh_state(bitmap_bh);
 			BUFFER_TRACE(bitmap_bh, "bit already cleared");
 		} else {
@@ -479,7 +478,6 @@ do_more:
 	*pdquot_freed_blocks += group_freed;
 
 	if (overflow && !err) {
-		block += count;
 		count = overflow;
 		goto do_more;
 	}
@@ -1192,6 +1190,63 @@ int ext3_should_retry_alloc(struct super
 }
 
 /*
+ * Check if given blocks are metadata blocks.
+ *
+ * We should also check the backup group descriptors and the superblock,
+ * but it is too expensive to do so for each allocated/freed block. So,
+ * let's defer that check until we have per-group data structs.
+ */
+static inline int ext3_blocks_are_metadata(ext3_fsblk_t block,
+		unsigned long num,
+		struct ext3_group_desc *gdp,
+		struct super_block *sb)
+{
+	if (in_range(le32_to_cpu(gdp->bg_block_bitmap), block, num))
+		return 1;
+	if (in_range(le32_to_cpu(gdp->bg_inode_bitmap), block, num))
+		return 1;
+	if (in_range(block, le32_to_cpu(gdp->bg_inode_table),
+			EXT3_SB(sb)->s_itb_per_group))
+		return 1;
+	if (in_range(block + num - 1, le32_to_cpu(gdp->bg_inode_table),
+			EXT3_SB(sb)->s_itb_per_group))
+		return 1;
+	return 0;
+}
+
+/*
+ *
+ * set the bits for all of the metadata blocks in the group
+ *
+ * Note: This will potentially use up some of the handle's buffer credits.
+ * Normally we have way too many credits, so that is OK. In _very_ rare cases it
+ * might not be OK.  We will trigger an assertion if we run out of credits, and we
+ * will have to do a full fsck of the filesystem - better than randomly corrupting
+ * filesystem metadata.
+ */
+static void fix_group(int group, struct super_block *sb)
+{
+	int i;
+	ext3_fsblk_t bit;
+	unsigned long gdblocks;
+	struct buffer_head *gdp_bh;
+	struct ext3_group_desc *gdp = ext3_get_group_desc(sb, group, &gdp_bh);
+
+	if (ext3_bg_has_super(sb, group))
+		ext3_set_bit(0, gdp_bh->b_data);
+	gdblocks = ext3_bg_num_gdb(sb, group);
+	for (i = 0, bit = 1; i < gdblocks; i++, bit++)
+		ext3_set_bit(i, gdp_bh->b_data);
+	ext3_set_bit(gdp->bg_inode_bitmap % EXT3_BLOCKS_PER_GROUP(sb),
+		gdp_bh->b_data);
+	ext3_set_bit(gdp->bg_block_bitmap % EXT3_BLOCKS_PER_GROUP(sb),
+		gdp_bh->b_data);
+	for (i = 0, bit = gdp->bg_inode_table % EXT3_BLOCKS_PER_GROUP(sb);
+			i < EXT3_SB(sb)->s_itb_per_group; i++, bit++)
+		ext3_set_bit(i, gdp_bh->b_data);
+}
+
+/*
  * ext3_new_block uses a goal block to assist allocation.  If the goal is
  * free, or there is a free block within 32 blocks of the goal, that block
  * is allocated.  Otherwise a forward search is made for a free block; within 
@@ -1260,7 +1315,7 @@ ext3_fsblk_t ext3_new_blocks(handle_t *h
 		*errp = -ENOSPC;
 		goto out;
 	}
-
+repeat:
 	/*
 	 * First, test whether the goal block is free.
 	 */
@@ -1367,17 +1422,10 @@ allocated:
 
 	ret_block = grp_alloc_blk + ext3_group_first_block_no(sb, group_no);
 
-	if (in_range(le32_to_cpu(gdp->bg_block_bitmap), ret_block, num) ||
-	    in_range(le32_to_cpu(gdp->bg_inode_bitmap), ret_block, num) ||
-	    in_range(ret_block, le32_to_cpu(gdp->bg_inode_table),
-		      EXT3_SB(sb)->s_itb_per_group) ||
-	    in_range(ret_block + num - 1, le32_to_cpu(gdp->bg_inode_table),
-		      EXT3_SB(sb)->s_itb_per_group))
-		ext3_error(sb, "ext3_new_block",
-			    "Allocating block in system zone - "
-			    "blocks from "E3FSBLK", length %lu",
-			     ret_block, num);
-
+	if (ext3_blocks_are_metadata(ret_block, num, gdp, sb)) {
+		fix_group(group_no, sb);
+		goto repeat;
+	}
 	performed_allocation = 1;
 
 #ifdef CONFIG_JBD_DEBUG

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
