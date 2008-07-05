From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 27/52] ext4: mballoc avoid use root reserved blocks for non root allocation
Date: Sat,  5 Jul 2008 13:35:53 -0400
Message-ID: <1215279378-30504-28-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
 <1215279378-30504-18-git-send-email-tytso@mit.edu>
 <1215279378-30504-19-git-send-email-tytso@mit.edu>
 <1215279378-30504-20-git-send-email-tytso@mit.edu>
 <1215279378-30504-21-git-send-email-tytso@mit.edu>
 <1215279378-30504-22-git-send-email-tytso@mit.edu>
 <1215279378-30504-23-git-send-email-tytso@mit.edu>
 <1215279378-30504-24-git-send-email-tytso@mit.edu>
 <1215279378-30504-25-git-send-email-tytso@mit.edu>
 <1215279378-30504-26-git-send-email-tytso@mit.edu>
 <1215279378-30504-27-git-send-email-tytso@mit.edu>
Cc: Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33060 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753891AbYGERgb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:31 -0400
In-Reply-To: <1215279378-30504-27-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Mingming Cao <cmm@us.ibm.com>

mballoc allocation missed check for blocks reserved for root users. Add
ext4_has_free_blocks() check before allocation. Also modified
ext4_has_free_blocks() to support multiple block allocation request.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/balloc.c  |   51 +++++++++++++++++++++++++++++++++------------------
 fs/ext4/ext4.h    |    2 ++
 fs/ext4/mballoc.c |    7 ++++++-
 3 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 48787e8..25f63d8 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1599,23 +1599,35 @@ out:
 
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
+		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
+		root_blocks = ext4_r_blocks_count(sbi->s_es);
+#ifdef CONFIG_SMP
+	if (free_blocks - root_blocks < FBC_BATCH)
+		free_blocks =
+			percpu_counter_sum_positive(&sbi->s_freeblocks_counter);
+#endif
+	if (free_blocks - root_blocks < nblocks)
+		return free_blocks - root_blocks;
+	return nblocks;
+ }
+
 
 /**
  * ext4_should_retry_alloc()
@@ -1631,7 +1643,7 @@ static int ext4_has_free_blocks(struct ext4_sb_info *sbi)
  */
 int ext4_should_retry_alloc(struct super_block *sb, int *retries)
 {
-	if (!ext4_has_free_blocks(EXT4_SB(sb)) || (*retries)++ > 3)
+	if (!ext4_has_free_blocks(EXT4_SB(sb), 1) || (*retries)++ > 3)
 		return 0;
 
 	jbd_debug(1, "%s: retrying operation after ENOSPC\n", sb->s_id);
@@ -1681,13 +1693,21 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
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
@@ -1711,11 +1731,6 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 	if (block_i && ((windowsz = block_i->rsv_window_node.rsv_goal_size) > 0))
 		my_rsv = &block_i->rsv_window_node;
 
-	if (!ext4_has_free_blocks(sbi)) {
-		*errp = -ENOSPC;
-		goto out;
-	}
-
 	/*
 	 * First, test whether the goal block is free.
 	 */
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ed04642..37ce906 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -979,6 +979,8 @@ extern ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 					unsigned long *count, int *errp);
 extern ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
+extern ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
+						ext4_fsblk_t nblocks);
 extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t block, unsigned long count, int metadata);
 extern void ext4_free_blocks_sb (handle_t *handle, struct super_block *sb,
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 007b97b..9ffad23 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4039,6 +4039,12 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
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
@@ -4067,7 +4073,6 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 
 	ac->ac_op = EXT4_MB_HISTORY_PREALLOC;
 	if (!ext4_mb_use_preallocated(ac)) {
