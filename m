From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC] ext4: remove do_blk_alloc()
Date: Sun,  7 Dec 2008 14:33:54 -0500
Message-ID: <1228678434-14707-3-git-send-email-tytso@mit.edu>
References: <1228678434-14707-1-git-send-email-tytso@mit.edu>
 <1228678434-14707-2-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41269 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752202AbYLGUbv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Dec 2008 15:31:51 -0500
In-Reply-To: <1228678434-14707-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The convenience function do_blk_alloc() is a static function with
only one caller, so fold it into its caller to simplify the code and
to make it easier to understand.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/balloc.c |   44 ++++++++++++--------------------------------
 1 files changed, 12 insertions(+), 32 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 47cf25d..6294d60 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -666,35 +666,6 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
 	return jbd2_journal_force_commit_nested(EXT4_SB(sb)->s_journal);
 }
 
-#define EXT4_META_BLOCK 0x1
-
-static ext4_fsblk_t do_blk_alloc(handle_t *handle, struct inode *inode,
-				ext4_lblk_t iblock, ext4_fsblk_t goal,
-				unsigned long *count, int *errp, int flags)
-{
-	struct ext4_allocation_request ar;
-	ext4_fsblk_t ret;
-
-	memset(&ar, 0, sizeof(ar));
-	/* Fill with neighbour allocated blocks */
-
-	ar.inode = inode;
-	ar.goal = goal;
-	ar.len = *count;
-	ar.logical = iblock;
-
-	if (S_ISREG(inode->i_mode) && !(flags & EXT4_META_BLOCK))
-		/* enable in-core preallocation for data block allocation */
-		ar.flags = EXT4_MB_HINT_DATA;
-	else
-		/* disable in-core preallocation for non-regular files */
-		ar.flags = 0;
-
-	ret = ext4_mb_new_blocks(handle, &ar, errp);
-	*count = ar.len;
-	return ret;
-}
-
 /*
  * ext4_new_meta_blocks() -- allocate block for meta data (indexing) blocks
  *
@@ -704,15 +675,24 @@ static ext4_fsblk_t do_blk_alloc(handle_t *handle, struct inode *inode,
  * @count:		total number of blocks need
  * @errp:               error code
  *
- * Return 1st allocated block numberon success, *count stores total account
+ * Return 1st allocated block number on success, *count stores total account
  * error stores in errp pointer
  */
 ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 		ext4_fsblk_t goal, unsigned long *count, int *errp)
 {
+	struct ext4_allocation_request ar;
 	ext4_fsblk_t ret;
-	ret = do_blk_alloc(handle, inode, 0, goal,
-				count, errp, EXT4_META_BLOCK);
+
+	memset(&ar, 0, sizeof(ar));
+	/* Fill with neighbour allocated blocks */
+	ar.inode = inode;
+	ar.goal = goal;
+	ar.len = *count;
+
+	ret = ext4_mb_new_blocks(handle, &ar, errp);
+	*count = ar.len;
+
 	/*
 	 * Account for the allocated meta blocks
 	 */
-- 
1.6.0.4.8.g36f27.dirty

