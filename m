From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: remove unused function __ext4_write_dirty_metadata
Date: Mon, 25 May 2009 12:33:47 -0400
Message-ID: <1243269227-1799-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Frank Mayhar <fmayhar@google.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39302 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbZEYQd5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 May 2009 12:33:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The __ext4_write_dirty_metadata() function was introduced by commit
0390131b, "ext4: Allow ext4 to run without a journal", but nothing
ever used the function, either then or since.  So let's remove it and
save a bit of space.

Cc: Frank Mayhar <fmayhar@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dadd3f9..14c00ff 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4790,25 +4790,6 @@ int ext4_write_inode(struct inode *inode, int wait)
 	return ext4_force_commit(inode->i_sb);
 }
 
-int __ext4_write_dirty_metadata(struct inode *inode, struct buffer_head *bh)
-{
-	int err = 0;
-
-	mark_buffer_dirty(bh);
-	if (inode && inode_needs_sync(inode)) {
-		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh)) {
-			ext4_error(inode->i_sb, __func__,
-				   "IO error syncing inode, "
-				   "inode=%lu, block=%llu",
-				   inode->i_ino,
-				   (unsigned long long)bh->b_blocknr);
-			err = -EIO;
-		}
-	}
-	return err;
-}
