From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: PATCH] ext4: Change error handling in ext4_defrag_alloc_blocks
Date: Thu, 12 Jun 2008 10:43:31 +0900
Message-ID: <48507F43.8080602@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	shen@cn.fujitsu.com
To: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:50525 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbYFLBp5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2008 21:45:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Change error handling in ext4_defrag_alloc_blocks,
since ext4_ext_journal_restart returns the error value.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/defrag.c  |    6 ++----
 fs/ext4/ext4.h    |    2 +-
 fs/ext4/extents.c |    2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)
diff --git a/fs/ext4/defrag.c b/fs/ext4/defrag.c
index cd8b151..5187681 100644
--- a/fs/ext4/defrag.c
+++ b/fs/ext4/defrag.c
@@ -1386,12 +1386,10 @@ ext4_defrag_alloc_blocks(handle_t *handle, struct inode *org_inode,
 	int err, i, credits = 0;

 	credits = ext4_ext_calc_credits_for_insert(dest_inode, dest_path);
-	handle = ext4_ext_journal_restart(handle,
+	err = ext4_ext_journal_restart(handle,
 				credits + EXT4_TRANS_META_BLOCKS);
-	if (IS_ERR(handle)) {
-		err = PTR_ERR(handle);
+	if (err)
 		return err;
-	}

 	*newblock = ext4_mb_new_blocks(handle, ar, &err);
 	if (err)
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index eec99be..202514e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1198,7 +1198,7 @@ extern void ext4_inode_bitmap_set(struct super_block *sb,
 extern void ext4_inode_table_set(struct super_block *sb,
 				 struct ext4_group_desc *bg, ext4_fsblk_t blk);
 /* extents.c */
-extern handle_t *ext4_ext_journal_restart(handle_t *handle, int needed);
+extern int ext4_ext_journal_restart(handle_t *handle, int needed);
 /* defrag.c */
 extern int ext4_defrag(struct file *filp, ext4_lblk_t block_start,
 			ext4_lblk_t defrag_size, ext4_fsblk_t goal,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8d47490..30e011b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -93,7 +93,7 @@ static void ext4_idx_store_pblock(struct ext4_extent_idx *ix, ext4_fsblk_t pb)
 	ix->ei_leaf_hi = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
 }

-handle_t *ext4_ext_journal_restart(handle_t *handle, int needed)
+int ext4_ext_journal_restart(handle_t *handle, int needed)
 {
 	int err;

