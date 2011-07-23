From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Fix data corruption in inodes with journalled data
Date: Sat, 23 Jul 2011 02:33:38 +0200
Message-ID: <1311381218-31021-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab1GWAdl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jul 2011 20:33:41 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 3CC59890B6
	for <linux-ext4@vger.kernel.org>; Sat, 23 Jul 2011 02:33:40 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When journalling data for an inode (either because it is a symlink or
because the filesystem is mounted in data=journal mode), ext3_evict_inode()
can discard unwritten data by calling truncate_inode_pages(). This is
because we don't mark the buffer / page dirty when journalling data but only
add the buffer to the running transaction and thus mm does not know there
are still unwritten data.

Fix the problem by carefully tracking transaction containing inode's data,
committing this transaction, and writing uncheckpointed buffers when inode
should be reaped.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |   40 +++++++++++++++++++++++++++++++++++-----
 1 files changed, 35 insertions(+), 5 deletions(-)

  This test is now undergoing some testing and if it passes I plan to push
it to Linus in this merge window.

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index d2e4547..f57c87b 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -197,6 +197,7 @@ static int truncate_restart_transaction(handle_t *handle, struct inode *inode)
  */
 void ext3_evict_inode (struct inode *inode)
 {
+	struct ext3_inode_info *ei = EXT3_I(inode);
 	struct ext3_block_alloc_info *rsv;
 	handle_t *handle;
 	int want_delete = 0;
@@ -207,11 +208,36 @@ void ext3_evict_inode (struct inode *inode)
 		want_delete = 1;
 	}
 
+	/*
+	 * When journalling data dirty buffers are tracked only in the journal.
+	 * So although mm thinks everything is clean and ready for reaping the
+	 * inode might still have some pages to write in the running
+	 * transaction or waiting to be checkpointed. Thus calling
+	 * journal_invalidatepage() (via truncate_inode_pages()) to discard
+	 * these buffers can cause data loss. Also even if we did not discard
+	 * these buffers, we would have no way to find them after the inode
+	 * is reaped and thus user could see stale data if he tries to read
+	 * them before the transaction is checkpointed. So be careful and
+	 * force everything to disk here... We use ei->i_datasync_tid to
+	 * store the newest transaction containing inode's data.
+	 *
+	 * Note that directories do not have this problem because they don't
+	 * use page cache.
+	 */
+	if (inode->i_nlink && ext3_should_journal_data(inode) &&
+	    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode))) {
+		tid_t commit_tid = atomic_read(&ei->i_datasync_tid);
+		journal_t *journal = EXT3_SB(inode->i_sb)->s_journal;
+
+		log_start_commit(journal, commit_tid);
+		log_wait_commit(journal, commit_tid);
+		filemap_write_and_wait(&inode->i_data);
+	}
 	truncate_inode_pages(&inode->i_data, 0);
 
 	ext3_discard_reservation(inode);
-	rsv = EXT3_I(inode)->i_block_alloc_info;
-	EXT3_I(inode)->i_block_alloc_info = NULL;
+	rsv = ei->i_block_alloc_info;
+	ei->i_block_alloc_info = NULL;
 	if (unlikely(rsv))
 		kfree(rsv);
 
@@ -241,7 +267,7 @@ void ext3_evict_inode (struct inode *inode)
 	 * have removed the record.
 	 */
 	ext3_orphan_del(handle, inode);
-	EXT3_I(inode)->i_dtime	= get_seconds();
+	ei->i_dtime = get_seconds();
 
 	/*
 	 * One subtle ordering requirement: if anything has gone wrong
@@ -1411,6 +1437,7 @@ static int ext3_journalled_write_end(struct file *file,
 {
 	handle_t *handle = ext3_journal_current_handle();
 	struct inode *inode = mapping->host;
+	struct ext3_inode_info *ei = EXT3_I(inode);
 	int ret = 0, ret2;
 	int partial = 0;
 	unsigned from, to;
@@ -1440,8 +1467,9 @@ static int ext3_journalled_write_end(struct file *file,
 	if (pos + len > inode->i_size && ext3_can_truncate(inode))
 		ext3_orphan_add(handle, inode);
 	ext3_set_inode_state(inode, EXT3_STATE_JDATA);
-	if (inode->i_size > EXT3_I(inode)->i_disksize) {
-		EXT3_I(inode)->i_disksize = inode->i_size;
+	atomic_set(&ei->i_datasync_tid, handle->h_transaction->t_tid);
+	if (inode->i_size > ei->i_disksize) {
+		ei->i_disksize = inode->i_size;
 		ret2 = ext3_mark_inode_dirty(handle, inode);
 		if (!ret)
 			ret = ret2;
@@ -1739,6 +1767,8 @@ static int ext3_journalled_writepage(struct page *page,
 		if (ret == 0)
 			ret = err;
 		ext3_set_inode_state(inode, EXT3_STATE_JDATA);
+		atomic_set(&EXT3_I(inode)->i_datasync_tid,
+			   handle->h_transaction->t_tid);
 		unlock_page(page);
 	} else {
 		/*
-- 
1.7.1

