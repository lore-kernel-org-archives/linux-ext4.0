From: amir73il@users.sourceforge.net
Subject: [PATCH 2/5] ext4: implement ext4_add_groupblocks() by freeing blocks
Date: Sun, 20 Mar 2011 23:32:47 +0200
Message-ID: <1300656770-14994-3-git-send-email-amir73il@users.sourceforge.net>
References: <1300656770-14994-1-git-send-email-amir73il@users.sourceforge.net>
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39539 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab1CTVeT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Mar 2011 17:34:19 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so5008530fxm.19
        for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2011 14:34:18 -0700 (PDT)
In-Reply-To: <1300656770-14994-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

The old imlementation used to take grp->alloc_sem and set the
GROUP_NEED_INIT flag, so that the buddy cache would be reloaded.

The new implementation updates the buddy cache by freeing the added
blocks and making them available for use, so there is no need to
reload the buddy cache and there is no need to take grp->alloc_sem.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 fs/ext4/mballoc.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c15f667..c7c9288 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4724,6 +4724,7 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 	unsigned int i;
 	struct ext4_group_desc *desc;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_buddy e4b;
 	int err = 0, ret, blk_free_count;
 	ext4_grpblk_t blocks_freed;
 	struct ext4_group_info *grp;
@@ -4775,15 +4776,10 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 	err = ext4_journal_get_write_access(handle, gd_bh);
 	if (err)
 		goto error_return;
-	/*
-	 * make sure we don't allow a parallel init on other groups in the
-	 * same buddy cache
-	 */
-	down_write(&grp->alloc_sem);
+
 	for (i = 0, blocks_freed = 0; i < count; i++) {
 		BUFFER_TRACE(bitmap_bh, "clear bit");
-		if (!ext4_clear_bit_atomic(ext4_group_lock_ptr(sb, block_group),
-						bit + i, bitmap_bh->b_data)) {
+		if (!mb_test_bit(bit + i, bitmap_bh->b_data)) {
 			ext4_error(sb, "bit already cleared for block %llu",
 				   (ext4_fsblk_t)(block + i));
 			BUFFER_TRACE(bitmap_bh, "bit already cleared");
@@ -4791,7 +4787,19 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 			blocks_freed++;
 		}
 	}
+
+	err = ext4_mb_load_buddy(sb, block_group, &e4b);
+	if (err)
+		goto error_return;
+
+	/*
+	 * need to update group_info->bb_free and bitmap
+	 * with group lock held. generate_buddy look at
+	 * them with group lock_held
+	 */
 	ext4_lock_group(sb, block_group);
+	mb_clear_bits(bitmap_bh->b_data, bit, count);
+	mb_free_blocks(NULL, &e4b, bit, count);
 	blk_free_count = blocks_freed + ext4_free_blks_count(sb, desc);
 	ext4_free_blks_set(sb, desc, blk_free_count);
 	desc->bg_checksum = ext4_group_desc_csum(sbi, block_group, desc);
@@ -4803,13 +4811,8 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 		atomic_add(blocks_freed,
 			   &sbi->s_flex_groups[flex_group].free_blocks);
 	}
-	/*
-	 * request to reload the buddy with the
-	 * new bitmap information
-	 */
-	set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &(grp->bb_state));
-	grp->bb_free += blocks_freed;
-	up_write(&grp->alloc_sem);
+
+	ext4_mb_unload_buddy(&e4b);
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
-- 
1.7.0.4

