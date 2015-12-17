From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH v2] ext4: make sure to revoke all the freeable blocks in
 ext4_free_blocks
Date: Thu, 17 Dec 2015 11:42:11 +0900
Message-ID: <1450320131-10914-1-git-send-email-daeho.jeong@samsung.com>
Cc: Daeho Jeong <daeho.jeong@samsung.com>
To: tytso@mit.edu, jack@suse.cz, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:56613 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbbLQClH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Dec 2015 21:41:07 -0500
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NZH01OTUE4G0200@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Thu, 17 Dec 2015 11:41:04 +0900 (KST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now, ext4_free_blocks() doesn't revoke data blocks of per-file data
journalled inode and it can cause file data inconsistency problems.
Even though data blocks of per-file data journalled inode are already
forgotten by jbd2_journal_invalidatepage() in advance of invoking
ext4_free_blocks(), we still need to revoke the data blocks here.
Moreover some of the metadata blocks, which are not found by
sb_find_get_block(), are still needed to be revoked, but this is also
missing here.

Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/mballoc.c |   32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 61eaf74..26419d6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4695,16 +4695,6 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	}
 
 	/*
-	 * We need to make sure we don't reuse the freed block until
-	 * after the transaction is committed, which we can do by
-	 * treating the block as metadata, below.  We make an
-	 * exception if the inode is to be written in writeback mode
-	 * since writeback mode has weak data consistency guarantees.
-	 */
-	if (!ext4_should_writeback_data(inode))
-		flags |= EXT4_FREE_BLOCKS_METADATA;
-
-	/*
 	 * If the extent to be freed does not begin on a cluster
 	 * boundary, we need to deal with partial clusters at the
 	 * beginning and end of the extent.  Normally we will free
@@ -4738,14 +4728,13 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 
 	if (!bh && (flags & EXT4_FREE_BLOCKS_FORGET)) {
 		int i;
+		int is_metadata = flags & EXT4_FREE_BLOCKS_METADATA;
 
 		for (i = 0; i < count; i++) {
 			cond_resched();
-			bh = sb_find_get_block(inode->i_sb, block + i);
-			if (!bh)
-				continue;
-			ext4_forget(handle, flags & EXT4_FREE_BLOCKS_METADATA,
-				    inode, bh, block + i);
+			if (is_metadata)
+				bh = sb_find_get_block(inode->i_sb, block + i);
+			ext4_forget(handle, is_metadata, inode, bh, block + i);
 		}
 	}
 
@@ -4819,12 +4808,17 @@ do_more:
 	if (err)
 		goto error_return;
 
-	if ((flags & EXT4_FREE_BLOCKS_METADATA) && ext4_handle_valid(handle)) {
+	/*
+	 * We need to make sure we don't reuse the freed block until after the
+	 * transaction is committed. We make an exception if the inode is to be
+	 * written in writeback mode since writeback mode has weak data
+	 * consistency guarantees.
+	 */
+	if (ext4_handle_valid(handle) &&
+	    ((flags & EXT4_FREE_BLOCKS_METADATA) ||
+	     !ext4_should_writeback_data(inode))) {
 		struct ext4_free_data *new_entry;
 		/*
-		 * blocks being freed are metadata. these blocks shouldn't
-		 * be used until this transaction is committed
-		 *
 		 * We use __GFP_NOFAIL because ext4_free_blocks() is not allowed
 		 * to fail.
 		 */
-- 
1.7.9.5

