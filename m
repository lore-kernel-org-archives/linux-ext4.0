From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH V3 14/15] ext4: let ext4_group_extend() use common code
Date: Tue,  8 Nov 2011 07:13:27 +0800
Message-ID: <1320707608-14246-15-git-send-email-xiaoqiangnk@gmail.com>
References: <1320707608-14246-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65327 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab1KHB2q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Nov 2011 20:28:46 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so6468027iag.19
        for <linux-ext4@vger.kernel.org>; Mon, 07 Nov 2011 17:28:46 -0800 (PST)
In-Reply-To: <1320707608-14246-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

__ext4_group_extend() is moved out from ext4_group_extend(), this patch
lets ext4_group_extend() call __ext4_group_extentd() instead.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |   41 ++---------------------------------------
 1 files changed, 2 insertions(+), 39 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index ebffc55..a43dcb0 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1804,8 +1804,7 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	ext4_grpblk_t last;
 	ext4_grpblk_t add;
 	struct buffer_head *bh;
-	handle_t *handle;
-	int err, err2;
+	int err;
 	ext4_group_t group;
 
 	o_blocks_count = ext4_blocks_count(es);
@@ -1861,43 +1860,7 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	}
 	brelse(bh);
 
-	/* We will update the superblock, one block bitmap, and
-	 * one group descriptor via ext4_free_blocks().
-	 */
-	handle = ext4_journal_start_sb(sb, 3);
-	if (IS_ERR(handle)) {
-		err = PTR_ERR(handle);
-		ext4_warning(sb, "error %d on journal start", err);
-		goto exit_put;
-	}
-
-	if ((err = ext4_journal_get_write_access(handle,
-						 EXT4_SB(sb)->s_sbh))) {
-		ext4_warning(sb, "error %d on journal write access", err);
-		ext4_journal_stop(handle);
-		goto exit_put;
-	}
-	ext4_blocks_count_set(es, o_blocks_count + add);
-	ext4_debug("freeing blocks %llu through %llu\n", o_blocks_count,
-		   o_blocks_count + add);
-	/* We add the blocks to the bitmap and set the group need init bit */
-	err = ext4_group_add_blocks(handle, sb, o_blocks_count, add);
-	ext4_handle_dirty_super(handle, sb);
-	ext4_debug("freed blocks %llu through %llu\n", o_blocks_count,
-		   o_blocks_count + add);
-	err2 = ext4_journal_stop(handle);
-	if (!err && err2)
-		err = err2;
-
-	if (err)
-		goto exit_put;
