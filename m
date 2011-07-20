From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 1/2] ext4: get free blocks count of BLOCK_UNINIT groups from group desc directly
Date: Wed, 20 Jul 2011 21:32:53 +0800
Message-ID: <1311168774-26378-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1311168774-26378-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51641 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1GTNh2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jul 2011 09:37:28 -0400
Received: by mail-iw0-f174.google.com with SMTP id 6so190698iwn.19
        for <linux-ext4@vger.kernel.org>; Wed, 20 Jul 2011 06:37:27 -0700 (PDT)
In-Reply-To: <1311168774-26378-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch teaches ext4 to get free blocks count of BLOCK_UNINIT groups from
group desc directly.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ialloc.c  |    2 --
 fs/ext4/mballoc.c |   14 ++------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 21bb2f6..efdc605 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -954,9 +954,7 @@ got:
 		ext4_lock_group(sb, group);
 		/* recheck and clear flag under lock if we still need to */
 		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
-			free = ext4_free_blocks_after_init(sb, group, gdp);
 			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
-			ext4_free_blks_set(sb, gdp, free);
 			gdp->bg_checksum = ext4_group_desc_csum(sbi, group,
 								gdp);
 		}
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b97a2d2..f92826b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2248,13 +2248,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 	 * initialize bb_free to be able to skip
 	 * empty groups without initialization
 	 */
-	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
-		meta_group_info[i]->bb_free =
-			ext4_free_blocks_after_init(sb, group, desc);
-	} else {
-		meta_group_info[i]->bb_free =
-			ext4_free_blks_count(sb, desc);
-	}
+	meta_group_info[i]->bb_free = ext4_free_blks_count(sb, desc);
 
 	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
 	init_rwsem(&meta_group_info[i]->alloc_sem);
@@ -2802,12 +2796,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	}
 #endif
 	mb_set_bits(bitmap_bh->b_data, ac->ac_b_ex.fe_start,ac->ac_b_ex.fe_len);
-	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
+	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT))
 		gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
-		ext4_free_blks_set(sb, gdp,
-					ext4_free_blocks_after_init(sb,
-					ac->ac_b_ex.fe_group, gdp));
-	}
 	len = ext4_free_blks_count(sb, gdp) - ac->ac_b_ex.fe_len;
 	ext4_free_blks_set(sb, gdp, len);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
-- 
1.7.5.1

