From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v2 03/11] ext4: rename ext4_add_groupblocks() to ext4_group_add_blocks()
Date: Tue, 19 Jul 2011 12:02:09 +0800
Message-ID: <1311048137-16400-4-git-send-email-xiaoqiangnk@gmail.com>
References: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: adilger@dilger.ca, amir73il@gmail.com, tm@tao.ma,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49578 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1GSEGb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jul 2011 00:06:31 -0400
Received: by mail-iw0-f174.google.com with SMTP id 6so3703318iwn.19
        for <linux-ext4@vger.kernel.org>; Mon, 18 Jul 2011 21:06:30 -0700 (PDT)
In-Reply-To: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch renamed ext4_add_groupblocks() to ext4_group_add_blocks().

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h    |    2 +-
 fs/ext4/mballoc.c |    4 ++--
 fs/ext4/resize.c  |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

 v1->v2:
   nothing changed.
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bb0f776..bbe81db 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1799,7 +1799,7 @@ extern void ext4_free_blocks(handle_t *handle, struct inode *inode,
 			     unsigned long count, int flags);
 extern int ext4_mb_add_groupinfo(struct super_block *sb,
 		ext4_group_t i, struct ext4_group_desc *desc);
-extern void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
+extern void ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 				ext4_fsblk_t block, unsigned long count);
 extern int ext4_trim_fs(struct super_block *, struct fstrim_range *);
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b97a2d2..ea80c0b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4656,7 +4656,7 @@ error_return:
 }
 
 /**
- * ext4_add_groupblocks() -- Add given blocks to an existing group
+ * ext4_group_add_blocks() -- Add given blocks to an existing group
  * @handle:			handle to this transaction
  * @sb:				super block
  * @block:			start physcial block to add to the block group
@@ -4664,7 +4664,7 @@ error_return:
  *
  * This marks the blocks as free in the bitmap and buddy.
  */
-void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
+void ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 			 ext4_fsblk_t block, unsigned long count)
 {
 	struct buffer_head *bitmap_bh = NULL;
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 53d9795..d241ecb 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1056,7 +1056,7 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	ext4_debug("freeing blocks %llu through %llu\n", o_blocks_count,
 		   o_blocks_count + add);
 	/* We add the blocks to the bitmap and set the group need init bit */
-	ext4_add_groupblocks(handle, sb, o_blocks_count, add);
+	ext4_group_add_blocks(handle, sb, o_blocks_count, add);
 	ext4_handle_dirty_super(handle, sb);
 	ext4_debug("freed blocks %llu through %llu\n", o_blocks_count,
 		   o_blocks_count + add);
-- 
1.7.5.1

