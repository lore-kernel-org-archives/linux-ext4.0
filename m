From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH]ext4: online defrag: Enable to reuse blocks by multiple defrag
Date: Tue, 09 Dec 2008 11:26:37 +0900
Message-ID: <493DD75D.60504@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:52931 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYLIC1F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Dec 2008 21:27:05 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: online defrag: Enable to reuse blocks by multiple defrag.

From: Akira Fujita <a-fujita@rs.jp.nec.com>

This patch is for defrag ver0.97 in the ext4 patch queue.
If journal is not writeback mode, commit the transaction
before block allocation to reuse blocks which previous defrag released.

I'm redesigning ext4 online defrag based on the comments from Ted.
Probably defrag's block allocation method will be changed greatly.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
---
 defrag.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)
diff -Nrup -X linux-2.6.28-rc6-a/Documentation/dontdiff linux-2.6.28-rc6-a/fs/ext4/defrag.c linux-2.6.28-rc6-b/fs/ext4/defrag.c
--- linux-2.6.28-rc6-a/fs/ext4/defrag.c	2008-12-05 15:14:58.000000000 +0900
+++ linux-2.6.28-rc6-b/fs/ext4/defrag.c	2008-12-05 15:56:26.000000000 +0900
@@ -1279,7 +1279,6 @@ ext4_defrag_new_extent_tree(struct inode
 			ext4_fsblk_t goal, int phase)
 {
 	handle_t *handle;
-	struct ext4_sb_info *sbi = EXT4_SB(org_inode->i_sb);
 	struct ext4_extent_header *eh = NULL;
 	struct ext4_allocation_request ar;
 	struct ext4_ext_path *dest_path = NULL;
@@ -1287,7 +1286,7 @@ ext4_defrag_new_extent_tree(struct inode
 	ext4_fsblk_t alloc_total = 0;
 	ext4_fsblk_t newblock = 0;
 	ext4_lblk_t req_end = req_start + req_blocks - 1;
-	ext4_lblk_t rest_blocks = 0;
+	ext4_lblk_t rest_blocks = req_blocks;
 	ext4_group_t dest_group_no, goal_group_no;
 	ext4_grpblk_t dest_blk_off, goal_blk_off;
 	int sum_tmp = 0;
@@ -1308,6 +1307,17 @@ ext4_defrag_new_extent_tree(struct inode
 	ext4_defrag_fill_ar(org_inode, tmp_inode, &ar, org_path,
 				dest_path, req_blocks, iblock, goal, phase);

+	/*
+	 * If journal is not writeback mode,
+	 * commit the transaction to reuse the blocks
+	 * which previous defrag released.
+	 */
+	if (!ext4_should_writeback_data(org_inode)) {
+		ret = ext4_force_commit(org_inode->i_sb);
+		if (ret)
+			goto out2;
+	}
+
 	handle = ext4_journal_start(tmp_inode, 0);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
@@ -1323,8 +1333,6 @@ ext4_defrag_new_extent_tree(struct inode
 						&ar, dest_path, &newblock);
 		if (ret < 0)
 			goto out;
-		/* Claimed blocks are already reserved */
-		EXT4_I(ar.inode)->i_delalloc_reserved_flag = 1;

 		ext4_get_group_no_and_offset(tmp_inode->i_sb, newblock,
 					&dest_group_no, &dest_blk_off);
@@ -1362,12 +1370,6 @@ ext4_defrag_new_extent_tree(struct inode
 out:
 	if (ret < 0 && ar.len)
 		ext4_free_blocks(handle, tmp_inode, newblock, ar.len, metadata);
-	/*
-	 * Update dirty-blocks counter if we cannot allocate the all of
-	 * requested blocks.
-	 */
-	if (rest_blocks)
-		percpu_counter_sub(&sbi->s_dirtyblocks_counter, rest_blocks);

 	ext4_journal_stop(handle);
