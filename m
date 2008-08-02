From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH v2] ext4: Fix lack of credits BUG() when deleting a badly fragmented inode
Date: Sat, 02 Aug 2008 01:25:04 -0400
Message-ID: <E1KP9c0-0002T5-Mq@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51118 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751496AbYHBFZM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Aug 2008 01:25:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Theodore Ts'o <tytso@mit.edu>

The extents codepath for ext4_truncate() requests journal transaction
credits in very small chunks, requesting only what is needed.  This
means there may not be enough credits left on the transaction handle
after ext4_truncate() returns and then when ext4_delete_inode() tries
finish up its work, it may not have enough transaction credits,
causing a BUG() oops in the jbd2 core.

Also, reserve an extra 2 blocks when starting an ext4_delete_inode()
since we need to update the inode bitmap, as well as update the
orphaned inode linked list.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
This new version of the patch reserves a few extra credits to make sure
we have enough for the inode bitmap and the orphaned inode list.  We
keep the call to ext4_ext_journal_restart() because the extents truncate
code doesn't allocate any extra slop.

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 59f3f54..685ed20 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -199,8 +199,9 @@ void ext4_delete_inode (struct inode * inode)
 	if (is_bad_inode(inode))
 		goto no_delete;
 
-	handle = start_transaction(inode);
+	handle = ext4_journal_start(inode, blocks_for_truncate(inode)+3);
 	if (IS_ERR(handle)) {
+		ext4_std_error(inode->i_sb, PTR_ERR(handle));
 		/*
 		 * If we're going to skip the normal cleanup, we still need to
 		 * make sure that the in-core orphan linked list is properly
@@ -213,8 +214,23 @@ void ext4_delete_inode (struct inode * inode)
 	if (IS_SYNC(inode))
 		handle->h_sync = 1;
 	inode->i_size = 0;
+	if (ext4_mark_inode_dirty(handle, inode))
+		goto stop_handle;
 	if (inode->i_blocks)
 		ext4_truncate(inode);
+
+	/*
+	 * ext4_ext_truncate() doesn't reserve any slop when it
+	 * restarts journal transactions; therefore there may not be
+	 * enough credits left in the handle to remove the inode from
+	 * the orphan list and set the dtime field.
+	 */
+	if (ext4_ext_journal_restart(handle, 3)) {
+	stop_handle:
+		ext4_journal_stop(handle);
+		goto no_delete;
+	}
+
 	/*
 	 * Kill off the orphan record which ext4_truncate created.
 	 * AKPM: I think this can be inside the above `if'.
