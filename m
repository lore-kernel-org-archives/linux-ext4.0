From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] ext3: Fix possible deadlock between ext3_truncate() and ext3_get_blocks()
Date: Fri, 14 Aug 2009 14:26:10 +0200
Message-ID: <1250252772-13302-3-git-send-email-jack@suse.cz>
References: <1250252772-13302-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49024 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756663AbZHNM0O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Aug 2009 08:26:14 -0400
In-Reply-To: <1250252772-13302-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

During truncate we are sometimes forced to start a new transaction as the
amount of blocks to be journaled is both quite large and hard to predict. So
far we restarted a transaction while holding truncate_mutex and that violates
lock ordering because truncate_mutex ranks below transaction start (and it
can lead to a real deadlock with ext3_get_blocks() allocating new blocks
from ext3_writepage()).

Luckily, the problem is easy to fix: We just drop the truncate_mutex before
restarting the transaction and acquire it afterwards. We are safe to do this as
by the time ext3_truncate() is called, all the page cache for the truncated
part of the file is dropped and so writepage() cannot come and allocate new
blocks in the part of the file we are truncating. The rest of writers is
stopped by us holding i_mutex.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index b49908a..eb0b4e0 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -172,10 +172,21 @@ static int try_to_extend_transaction(handle_t *handle, struct inode *inode)
  * so before we call here everything must be consistently dirtied against
  * this transaction.
  */
-static int ext3_journal_test_restart(handle_t *handle, struct inode *inode)
+static int truncate_restart_transaction(handle_t *handle, struct inode *inode)
 {
+	int ret;
+
 	jbd_debug(2, "restarting handle %p\n", handle);
-	return ext3_journal_restart(handle, blocks_for_truncate(inode));
+	/*
+	 * Drop truncate_mutex to avoid deadlock with ext3_get_blocks_handle
+	 * At this moment, get_block can be called only for blocks inside
+	 * i_size since page cache has been already dropped and writes are
+	 * blocked by i_mutex. So we can safely drop the truncate_mutex.
+	 */
+	mutex_unlock(&EXT3_I(inode)->truncate_mutex);
+	ret = ext3_journal_restart(handle, blocks_for_truncate(inode));
+	mutex_lock(&EXT3_I(inode)->truncate_mutex);
+	return ret;
 }
 
 /*
@@ -2072,7 +2083,7 @@ static void ext3_clear_blocks(handle_t *handle, struct inode *inode,
 			ext3_journal_dirty_metadata(handle, bh);
 		}
 		ext3_mark_inode_dirty(handle, inode);
-		ext3_journal_test_restart(handle, inode);
+		truncate_restart_transaction(handle, inode);
 		if (bh) {
 			BUFFER_TRACE(bh, "retaking write access");
 			ext3_journal_get_write_access(handle, bh);
@@ -2282,7 +2293,7 @@ static void ext3_free_branches(handle_t *handle, struct inode *inode,
 				return;
 			if (try_to_extend_transaction(handle, inode)) {
 				ext3_mark_inode_dirty(handle, inode);
-				ext3_journal_test_restart(handle, inode);
+				truncate_restart_transaction(handle, inode);
 			}
 
 			ext3_free_blocks(handle, inode, nr, 1);
-- 
1.6.0.2

