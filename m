From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH V7 11/12] ext4: let ext4_group_extend() use common code
Date: Wed,  4 Jan 2012 00:07:33 -0500
Message-ID: <1325653654-10478-12-git-send-email-tytso@mit.edu>
References: <1325653654-10478-1-git-send-email-tytso@mit.edu>
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50290 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab2ADFHf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 00:07:35 -0500
In-Reply-To: <1325653654-10478-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

ext4_group_extend_no_check() is moved out from ext4_group_extend(),
this patch lets ext4_group_extend() call ext4_group_extentd_no_check()
instead.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/resize.c |   41 ++---------------------------------------
 1 files changed, 2 insertions(+), 39 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 5fe2a01..eba706d 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1795,8 +1795,7 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	ext4_grpblk_t last;
 	ext4_grpblk_t add;
 	struct buffer_head *bh;
-	handle_t *handle;
-	int err, err2;
+	int err;
 	ext4_group_t group;
 
 	o_blocks_count = ext4_blocks_count(es);
@@ -1852,43 +1851,7 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
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
