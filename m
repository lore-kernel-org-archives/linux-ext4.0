From: Valerie Clement <Valerie.Clement@bull.net>
Subject: [RFC][PATCH 1/4] BIG_BG: rearrange some function calls.
Date: 24 Nov 2006 17:48:25 +0100
Message-ID: <1164386905.17961.73.camel@ckrm>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:22191 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S934974AbWKXQ6I
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Nov 2006 11:58:08 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id A8A8A19D934
	for <linux-ext4@vger.kernel.org>; Fri, 24 Nov 2006 17:58:03 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 21071-06 for <linux-ext4@vger.kernel.org>;
 Fri, 24 Nov 2006 17:57:58 +0100 (CET)
Received: from ckrm.frec.bull.fr (unknown [172.16.109.44])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 00BDB19D931
	for <linux-ext4@vger.kernel.org>; Fri, 24 Nov 2006 17:57:58 +0100 (CET)
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch is just a rewrite of code to change read_block_bitmap() call order.


Signed-off-by: Valerie Clement <valerie.clement@bull.net>

 balloc.c |   76 +++++++++++++++++++++++++++++++++------------------------------
 1 files changed, 41 insertions(+), 35 deletions(-)

Index: linux-2.6.19-rc6/fs/ext4/balloc.c
===================================================================
--- linux-2.6.19-rc6.orig/fs/ext4/balloc.c	2006-11-17 12:13:53.000000000 +0100
+++ linux-2.6.19-rc6/fs/ext4/balloc.c	2006-11-17 12:13:59.000000000 +0100
@@ -473,10 +473,6 @@ do_more:
 		overflow = bit + count - EXT4_BLOCKS_PER_GROUP(sb);
 		count -= overflow;
 	}
-	brelse(bitmap_bh);
-	bitmap_bh = read_block_bitmap(sb, block_group);
-	if (!bitmap_bh)
-		goto error_return;
 	desc = ext4_get_group_desc (sb, block_group, &gd_bh);
 	if (!desc)
 		goto error_return;
@@ -491,6 +487,10 @@ do_more:
 			    "Block = %llu, count = %lu",
 			    block, count);
 
+	brelse(bitmap_bh);
+	bitmap_bh = read_block_bitmap(sb, block_group);
+	if (!bitmap_bh)
+		goto error_return;
 	/*
 	 * We are about to start releasing blocks in the bitmap,
 	 * so we need undo access.
@@ -1225,7 +1225,6 @@ static void try_to_extend_reservation(st
  * @sb:			superblock
  * @handle:		handle to this transaction
  * @group:		given allocation block group
- * @bitmap_bh:		bufferhead holds the block bitmap
  * @grp_goal:		given target block within the group
  * @count:		target number of blocks to allocate
  * @my_rsv:		reservation window
@@ -1251,11 +1250,12 @@ static void try_to_extend_reservation(st
  */
 static ext4_grpblk_t
 ext4_try_to_allocate_with_rsv(struct super_block *sb, handle_t *handle,
-			unsigned int group, struct buffer_head *bitmap_bh,
+			unsigned int group,
 			ext4_grpblk_t grp_goal,
 			struct ext4_reserve_window_node * my_rsv,
 			unsigned long *count, int *errp)
 {
+	struct buffer_head *bitmap_bh = NULL;
 	ext4_fsblk_t group_first_block, group_last_block;
 	ext4_grpblk_t ret = 0;
 	int fatal;
@@ -1268,6 +1268,11 @@ ext4_try_to_allocate_with_rsv(struct sup
 	 * that we do the frozen_data COW on bitmap buffers in all cases even
 	 * if the buffer is in BJ_Forget state in the committing transaction.
 	 */
+	bitmap_bh = read_block_bitmap(sb, group);
+	if (!bitmap_bh) {
+		*errp = -EIO;
+		return -1;
+	}
 	BUFFER_TRACE(bitmap_bh, "get undo access for new block");
 	fatal = ext4_journal_get_undo_access(handle, bitmap_bh);
 	if (fatal) {
@@ -1345,9 +1350,36 @@ ext4_try_to_allocate_with_rsv(struct sup
 	}
 out:
 	if (ret >= 0) {
+#ifdef CONFIG_JBD_DEBUG
+#if 0
+		struct ext4_sb_info *sbi;
+
+		sbi = EXT4_SB(sb);
+		jbd_lock_bh_state(bitmap_bh);
+		spin_lock(sb_bgl_lock(sbi, group));
+		if (buffer_jbd(bitmap_bh) &&
+				bh2jh(bitmap_bh)->b_committed_data) {
+			int i;
+
+			for (i = 0; i < num; i++) {
+				if (ext4_test_bit(ret+i,
+					bh2jh(bitmap_bh)->b_committed_data)) {
+					printk("%s: block was unexpectedly set"
+						"in b_committed_data\n",
+						__FUNCTION__);
+				}
+			}
+		}
+		ext4_debug("found bit %d\n", ret);
+		spin_unlock(sb_bgl_lock(sbi, group));
+		jbd_unlock_bh_state(bitmap_bh);
+#endif
+#endif
+
 		BUFFER_TRACE(bitmap_bh, "journal_dirty_metadata for "
 					"bitmap block");
 		fatal = ext4_journal_dirty_metadata(handle, bitmap_bh);
+		brelse(bitmap_bh);
 		if (fatal) {
 			*errp = fatal;
 			return -1;
@@ -1357,6 +1389,7 @@ out:
 
 	BUFFER_TRACE(bitmap_bh, "journal_release_buffer");
 	ext4_journal_release_buffer(handle, bitmap_bh);
+	brelse(bitmap_bh);
 	return ret;
 }
 
@@ -1419,7 +1452,6 @@ int ext4_should_retry_alloc(struct super
 ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp)
 {
-	struct buffer_head *bitmap_bh = NULL;
 	struct buffer_head *gdp_bh;
 	unsigned long group_no;
 	int goal_group;
@@ -1501,11 +1533,8 @@ retry_alloc:
 		my_rsv = NULL;
 
 	if (free_blocks > 0) {
-		bitmap_bh = read_block_bitmap(sb, group_no);
-		if (!bitmap_bh)
-			goto io_error;
 		grp_alloc_blk = ext4_try_to_allocate_with_rsv(sb, handle,
-					group_no, bitmap_bh, grp_target_blk,
+					group_no, grp_target_blk,
 					my_rsv,	&num, &fatal);
 		if (fatal)
 			goto out;
@@ -1538,15 +1567,11 @@ retry_alloc:
 		if (free_blocks <= (windowsz/2))
 			continue;
 
-		brelse(bitmap_bh);
-		bitmap_bh = read_block_bitmap(sb, group_no);
-		if (!bitmap_bh)
-			goto io_error;
 		/*
 		 * try to allocate block(s) from this group, without a goal(-1).
 		 */
 		grp_alloc_blk = ext4_try_to_allocate_with_rsv(sb, handle,
-					group_no, bitmap_bh, -1, my_rsv,
+					group_no, -1, my_rsv,
 					&num, &fatal);
 		if (fatal)
 			goto out;
@@ -1602,26 +1627,9 @@ allocated:
 		debug_bh = sb_find_get_block(sb, ret_block);
 		if (debug_bh) {
 			BUFFER_TRACE(debug_bh, "state when allocated");
-			BUFFER_TRACE2(debug_bh, bitmap_bh, "bitmap state");
 			brelse(debug_bh);
 		}
 	}
-	jbd_lock_bh_state(bitmap_bh);
-	spin_lock(sb_bgl_lock(sbi, group_no));
-	if (buffer_jbd(bitmap_bh) && bh2jh(bitmap_bh)->b_committed_data) {
-		int i;
-
-		for (i = 0; i < num; i++) {
-			if (ext4_test_bit(grp_alloc_blk+i,
-					bh2jh(bitmap_bh)->b_committed_data)) {
-				printk("%s: block was unexpectedly set in "
-					"b_committed_data\n", __FUNCTION__);
-			}
-		}
-	}
-	ext4_debug("found bit %d\n", grp_alloc_blk);
-	spin_unlock(sb_bgl_lock(sbi, group_no));
-	jbd_unlock_bh_state(bitmap_bh);
 #endif
 
 	if (ret_block + num - 1 >= ext4_blocks_count(es)) {
@@ -1656,7 +1664,6 @@ allocated:
 		goto out;
 
 	*errp = 0;
-	brelse(bitmap_bh);
 	DQUOT_FREE_BLOCK(inode, *count-num);
 	*count = num;
 	return ret_block;
@@ -1673,7 +1680,6 @@ out:
 	 */
 	if (!performed_allocation)
 		DQUOT_FREE_BLOCK(inode, *count);
-	brelse(bitmap_bh);
 	return 0;
 }
 
