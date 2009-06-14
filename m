From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Fix 64-bit block type problem on 32-bit platforms
Date: Sun, 14 Jun 2009 17:30:02 -0400
Message-ID: <1245015002-16880-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59418 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755696AbZFNXLl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Jun 2009 19:11:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The function ext4_mb_free_blocks() was using an "unsigned long" to
pass a block number; this will cause 64-bit block numbers to get
truncated on x86 and other 32-bit platforms.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h    |    2 +-
 fs/ext4/mballoc.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 746cdcb..17b9998 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1341,7 +1341,7 @@ extern void ext4_discard_preallocations(struct inode *);
 extern int __init init_ext4_mballoc(void);
 extern void exit_ext4_mballoc(void);
 extern void ext4_mb_free_blocks(handle_t *, struct inode *,
-		unsigned long, unsigned long, int, unsigned long *);
+		ext4_fsblk_t, unsigned long, int, unsigned long *);
 extern int ext4_mb_add_groupinfo(struct super_block *sb,
 		ext4_group_t i, struct ext4_group_desc *desc);
 extern void ext4_mb_update_group_info(struct ext4_group_info *grp,
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8d98070..519a0a6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4689,7 +4689,7 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
  * Main entry point into mballoc to free blocks
  */
 void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
-			unsigned long block, unsigned long count,
+			ext4_fsblk_t block, unsigned long count,
 			int metadata, unsigned long *freed)
 {
 	struct buffer_head *bitmap_bh = NULL;
@@ -4715,11 +4715,11 @@ void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
 	    block + count > ext4_blocks_count(es)) {
 		ext4_error(sb, __func__,
 			    "Freeing blocks not in datazone - "
-			    "block = %lu, count = %lu", block, count);
+			    "block = %llu, count = %lu", block, count);
 		goto error_return;
 	}
 
-	ext4_debug("freeing block %lu\n", block);
+	ext4_debug("freeing block %llu\n", block);
 	trace_ext4_free_blocks(inode, block, count, metadata);
 
 	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
@@ -4761,7 +4761,7 @@ do_more:
 
 		ext4_error(sb, __func__,
 			   "Freeing blocks in system zone - "
-			   "Block = %lu, count = %lu", block, count);
+			   "Block = %llu, count = %lu", block, count);
 		/* err = 0. ext4_std_error should be a no op */
 		goto error_return;
 	}
-- 
1.6.3.2.1.gb9f7d.dirty

