From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH] ext4: make sure to revoke all the freeable blocks in
 ext4_free_blocks
Date: Wed, 16 Dec 2015 09:20:43 +0900
Message-ID: <1450225243-9085-1-git-send-email-daeho.jeong@samsung.com>
To: tytso@mit.edu, jack@suse.cz, daeho.jeong@samsung.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:37256 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbbLPATg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Dec 2015 19:19:36 -0500
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NZF01NPKCWMUQ80@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 16 Dec 2015 09:19:34 +0900 (KST)
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
---
 fs/ext4/mballoc.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 61eaf74..e40a2df 100644
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
@@ -4738,17 +4728,26 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 
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
 
+	/*
+	 * We need to make sure we don't reuse the freed block until
+	 * after the transaction is committed, which we can do by
+	 * treating the block as metadata, below.  We make an
+	 * exception if the inode is to be written in writeback mode
+	 * since writeback mode has weak data consistency guarantees.
+	 */
+	if (!ext4_should_writeback_data(inode))
+		flags |= EXT4_FREE_BLOCKS_METADATA;
+
 do_more:
 	overflow = 0;
 	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
-- 
1.7.9.5

