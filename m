From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] ext4: Wait for proper transaction commit on fsync
Date: Tue, 20 Oct 2009 09:24:38 +0200
Message-ID: <1256023478-746-5-git-send-email-jack@suse.cz>
References: <1256023478-746-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu, chris.mason@oracle.com, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47528 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbZJTH0K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Oct 2009 03:26:10 -0400
In-Reply-To: <1256023478-746-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We cannot rely on buffer dirty bits during fsync because pdflush can come
before fsync is called and clear dirty bits without forcing a transaction
commit. What we do is that we track which transaction has last changed
the inode and which transaction last changed allocation and force it to
disk on fsync.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h    |    7 +++++++
 fs/ext4/extents.c |    5 +++++
 fs/ext4/fsync.c   |   40 +++++++++++++++++-----------------------
 fs/ext4/inode.c   |   34 ++++++++++++++++++++++++++++++++++
 4 files changed, 63 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 984ca0c..5639f30 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -702,6 +702,13 @@ struct ext4_inode_info {
 	struct list_head i_aio_dio_complete_list;
 	/* current io_end structure for async DIO write*/
 	ext4_io_end_t *cur_aio_dio;
+
+	/*
+	 * Transactions that contain inode's metadata needed to complete
+	 * fsync and fdatasync, respectively.
+	 */
+	atomic_t i_sync_tid;
+	atomic_t i_datasync_tid;
 };
 
 /*
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 10539e3..3e167f6 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3315,6 +3315,11 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	newblock = ext_pblock(&newex);
 	allocated = ext4_ext_get_actual_len(&newex);
 	set_buffer_new(bh_result);
+	
+	atomic_set(&EXT4_I(inode)->i_sync_tid, handle->h_transaction->t_tid);
+	atomic_set(&EXT4_I(inode)->i_datasync_tid,
+		   handle->h_transaction->t_tid);
+	printk("Datasync tid %u\n", handle->h_transaction->t_tid);
 
 	/* Cache only when it is _not_ an uninitialized extent */
 	if ((flags & EXT4_GET_BLOCKS_UNINIT_EXT) == 0)
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 2bf9413..03e0fe9 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -51,25 +51,26 @@
 int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 {
 	struct inode *inode = dentry->d_inode;
+	struct ext4_inode_info *ei = EXT4_I(inode);
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
-	int err, ret = 0;
+	int ret = 0;
+	tid_t commit_tid;
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
 
 	trace_ext4_sync_file(file, dentry, datasync);
 
+	if (inode->i_sb->s_flags & MS_RDONLY)
+		goto out;
+
 	ret = flush_aio_dio_completed_IO(inode);
 	if (ret < 0)
 		goto out;
 	/*
-	 * data=writeback:
+	 * data=writeback,ordered:
 	 *  The caller's filemap_fdatawrite()/wait will sync the data.
-	 *  sync_inode() will sync the metadata
-	 *
-	 * data=ordered:
-	 *  The caller's filemap_fdatawrite() will write the data and
-	 *  sync_inode() will write the inode if it is dirty.  Then the caller's
-	 *  filemap_fdatawait() will wait on the pages.
+	 *  Metadata is in the journal, we wait for proper transaction to
+	 *  commit here.
 	 *
 	 * data=journal:
 	 *  filemap_fdatawrite won't do anything (the buffers are clean).
@@ -87,23 +88,16 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 	if (!journal)
 		ret = sync_mapping_buffers(inode->i_mapping);
 
-	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
-		goto flush;
+	if (datasync)
+		commit_tid = atomic_read(&ei->i_datasync_tid);
+	else
+		commit_tid = atomic_read(&ei->i_sync_tid);
 
-	/*
-	 * The VFS has written the file data.  If the inode is unaltered
-	 * then we need not start a commit.
-	 */
-	if (inode->i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC)) {
-		struct writeback_control wbc = {
-			.sync_mode = WB_SYNC_ALL,
-			.nr_to_write = 0, /* sys_fsync did this */
-		};
-		err = sync_inode(inode, &wbc);
-		if (ret == 0)
-			ret = err;
+	if (jbd2_log_start_commit(journal, commit_tid)) {
+		jbd2_log_wait_commit(journal, commit_tid);
+		goto out;
 	}
-flush:
+
 	if (journal && (journal->j_flags & JBD2_BARRIER))
 		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 out:
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9105f40..412de4e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1024,6 +1024,10 @@ static int ext4_ind_get_blocks(handle_t *handle, struct inode *inode,
 		goto cleanup;
 
 	set_buffer_new(bh_result);
+
+	atomic_set(&EXT4_I(inode)->i_sync_tid, handle->h_transaction->t_tid);
+	atomic_set(&EXT4_I(inode)->i_datasync_tid,
+		   handle->h_transaction->t_tid);
 got_it:
 	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
 	if (count > blocks_to_boundary)
@@ -4777,6 +4781,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	struct ext4_inode_info *ei;
 	struct buffer_head *bh;
 	struct inode *inode;
+	journal_t *journal = EXT4_SB(sb)->s_journal;
 	long ret;
 	int block;
 
@@ -4842,6 +4847,34 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		ei->i_data[block] = raw_inode->i_block[block];
 	INIT_LIST_HEAD(&ei->i_orphan);
 
+	/*
+	 * Set transaction id's of transactions that have to be committed
+	 * to finish f[data]sync. We set them to currently running transaction
+	 * as we cannot be sure that the inode or some of its metadata isn't
+	 * part of the transaction - the inode could have been reclaimed and
+	 * now it is reread from disk.
+	 */
+	if (journal) {
+		transaction_t *transaction;
+		tid_t tid;
+
+		spin_lock(&journal->j_state_lock);
+		if (journal->j_running_transaction)
+			transaction = journal->j_running_transaction;
+		else
+			transaction = journal->j_committing_transaction;
+		if (transaction)
+			tid = transaction->t_tid;
+		else
+			tid = journal->j_commit_sequence;
+		spin_unlock(&journal->j_state_lock);
+		atomic_set(&ei->i_sync_tid, tid);
+		atomic_set(&ei->i_datasync_tid, tid);
+	} else {
+		atomic_set(&ei->i_sync_tid, 0);
+		atomic_set(&ei->i_datasync_tid, 0);
+	}
+
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
 		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
 		if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
@@ -5102,6 +5135,7 @@ static int ext4_do_update_inode(handle_t *handle,
 		err = rc;
 	ei->i_state &= ~EXT4_STATE_NEW;
 
+	atomic_set(&ei->i_sync_tid, handle->h_transaction->t_tid);
 out_brelse:
 	brelse(bh);
 	ext4_std_error(inode->i_sb, err);
-- 
1.6.0.2

