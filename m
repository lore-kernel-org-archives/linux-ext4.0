From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH] ext4: mballoc avoid use root reserved blocks for non root
	allocation
Date: Sun, 01 Jun 2008 14:06:53 -0700
Message-ID: <1212354413.4368.7.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58543 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbYFAVHD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Jun 2008 17:07:03 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m51L6wf8027128
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 17:06:58 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m51L6wBg154444
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 17:06:58 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m51L6wHo013702
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 17:06:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: mballoc avoid use root reserved blocks for non root allocation

From: Mingming Cao <cmm@us.ibm.com>

mballoc allocation missed check for blocks reserved for root users. Add
ext4_has_free_blocks() check before allocation. Also modified
ext4_has_free_blocks() to support multiple block allocation request.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/balloc.c  |   50 ++++++++++++++++++++++++++++++++------------------
 fs/ext4/ext4.h    |    2 ++
 fs/ext4/mballoc.c |    7 ++++++-
 3 files changed, 40 insertions(+), 19 deletions(-)

Index: linux-2.6.26-rc4/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.26-rc4.orig/fs/ext4/mballoc.c	2008-06-01 13:13:53.000000000 -0700
+++ linux-2.6.26-rc4/fs/ext4/mballoc.c	2008-06-01 13:30:21.000000000 -0700
@@ -4038,6 +4038,12 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 					    &(ar->len), errp);
 		return block;
 	}
+	ar->len = ext4_has_free_blocks(sbi, ar->len);
+
+	if (ar->len == 0) {
+		*errp = -ENOSPC;
+		return 0;
+	}
 
 	while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
 		ar->flags |= EXT4_MB_HINT_NOPREALLOC;
@@ -4066,7 +4072,6 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 
 	ac->ac_op = EXT4_MB_HISTORY_PREALLOC;
 	if (!ext4_mb_use_preallocated(ac)) {
-
 		ac->ac_op = EXT4_MB_HISTORY_ALLOC;
 		ext4_mb_normalize_request(ac, ar);
 repeat:
Index: linux-2.6.26-rc4/fs/ext4/balloc.c
===================================================================
--- linux-2.6.26-rc4.orig/fs/ext4/balloc.c	2008-06-01 13:07:44.000000000 -0700
+++ linux-2.6.26-rc4/fs/ext4/balloc.c	2008-06-01 13:30:21.000000000 -0700
@@ -1604,23 +1604,34 @@ out:
 
 /**
  * ext4_has_free_blocks()
- * @sbi:		in-core super block structure.
+ * @sbi:	in-core super block structure.
+ * @nblocks:	number of neeed blocks
  *
- * Check if filesystem has at least 1 free block available for allocation.
+ * Check if filesystem has free blocks available for allocation.
+ * Return the number of blocks avaible for allocation for this request
+ * On success, return nblocks
  */
-static int ext4_has_free_blocks(struct ext4_sb_info *sbi)
+ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
+						ext4_fsblk_t nblocks)
 {
-	ext4_fsblk_t free_blocks, root_blocks;
+	ext4_fsblk_t free_blocks;
+	ext4_fsblk_t root_blocks = 0;
 
 	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
-	root_blocks = ext4_r_blocks_count(sbi->s_es);
-	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
+
+	if (!capable(CAP_SYS_RESOURCE) &&
 		sbi->s_resuid != current->fsuid &&
-		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
-		return 0;
-	}
-	return 1;
-}
+		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid)))
+		root_blocks = ext4_r_blocks_count(sbi->s_es);
+
+	if (free_blocks - root_blocks < FBC_BATCH)
+		free_blocks =
+			percpu_counter_sum_positive(&sbi->s_freeblocks_counter);
+	if (free_blocks - root_blocks < nblocks )
+		return free_blocks -root_blocks;
+	return nblocks;
+ }
+
 
 /**
  * ext4_should_retry_alloc()
@@ -1636,7 +1647,7 @@ static int ext4_has_free_blocks(struct e
  */
 int ext4_should_retry_alloc(struct super_block *sb, int *retries)
 {
-	if (!ext4_has_free_blocks(EXT4_SB(sb)) || (*retries)++ > 3)
+	if (!ext4_has_free_blocks(EXT4_SB(sb), 1) || (*retries)++ > 3)
 		return 0;
 
 	jbd_debug(1, "%s: retrying operation after ENOSPC\n", sb->s_id);
@@ -1682,13 +1693,21 @@ ext4_fsblk_t ext4_new_blocks_old(handle_
 	ext4_group_t ngroups;
 	unsigned long num = *count;
 
-	*errp = -ENOSPC;
 	sb = inode->i_sb;
 	if (!sb) {
+		*errp = -ENODEV;
 		printk("ext4_new_block: nonexistent device");
 		return 0;
 	}
 
+	sbi = EXT4_SB(sb);
+	*count = ext4_has_free_blocks(sbi, *count);
+	if (*count == 0) {
+		*errp = -ENOSPC;
+		return 0;	/*return with ENOSPC error */
+	}
+	num = *count;
+
 	/*
 	 * Check quota for allocation of this block.
 	 */
@@ -1712,11 +1731,6 @@ ext4_fsblk_t ext4_new_blocks_old(handle_
 	if (block_i && ((windowsz = block_i->rsv_window_node.rsv_goal_size) > 0))
 		my_rsv = &block_i->rsv_window_node;
 
-	if (!ext4_has_free_blocks(sbi)) {
-		*errp = -ENOSPC;
-		goto out;
-	}
