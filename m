From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] ext3: Wait for proper transaction commit on fsync
Date: Tue, 27 Oct 2009 13:48:46 +0100
Message-ID: <1256647729-29834-2-git-send-email-jack@suse.cz>
References: <1256647729-29834-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbZJ0Msq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Oct 2009 08:48:46 -0400
In-Reply-To: <1256647729-29834-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We cannot rely on buffer dirty bits during fsync because pdflush can come
before fsync is called and clear dirty bits without forcing a transaction
commit. What we do is that we track which transaction has last changed
the inode and which transaction last changed allocation and force it to
disk on fsync.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/fsync.c           |   36 ++++++++++++++++--------------------
 fs/ext3/inode.c           |   32 +++++++++++++++++++++++++++++++-
 fs/ext3/super.c           |    2 ++
 include/linux/ext3_fs_i.h |    8 ++++++++
 4 files changed, 57 insertions(+), 21 deletions(-)

diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
index 451d166..8209f26 100644
--- a/fs/ext3/fsync.c
+++ b/fs/ext3/fsync.c
@@ -46,19 +46,21 @@
 int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
 {
 	struct inode *inode = dentry->d_inode;
+	struct ext3_inode_info *ei = EXT3_I(inode);
+	journal_t *journal = EXT3_SB(inode->i_sb)->s_journal;
 	int ret = 0;
+	tid_t commit_tid;
+
+	if (inode->i_sb->s_flags & MS_RDONLY)
+		return 0;
 
 	J_ASSERT(ext3_journal_current_handle() == NULL);
 
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
+	 *  Metadata is in the journal, we wait for a proper transaction
+	 *  to commit here.
 	 *
 	 * data=journal:
 	 *  filemap_fdatawrite won't do anything (the buffers are clean).
@@ -73,22 +75,16 @@ int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
 		goto out;
 	}
 
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
-		ret = sync_inode(inode, &wbc);
+	if (log_start_commit(journal, commit_tid)) {
+		log_wait_commit(journal, commit_tid);
 		goto out;
 	}
-flush:
+
 	/*
 	 * In case we didn't commit a transaction, we have to flush
 	 * disk caches manually so that data really is on persistent
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index acf1b14..74b6146 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -699,8 +699,9 @@ static int ext3_splice_branch(handle_t *handle, struct inode *inode,
 	int err = 0;
 	struct ext3_block_alloc_info *block_i;
 	ext3_fsblk_t current_block;
+	struct ext3_inode_info *ei = EXT3_I(inode);
 
-	block_i = EXT3_I(inode)->i_block_alloc_info;
+	block_i = ei->i_block_alloc_info;
 	/*
 	 * If we're splicing into a [td]indirect block (as opposed to the
 	 * inode) then we need to get write access to the [td]indirect block
@@ -741,6 +742,8 @@ static int ext3_splice_branch(handle_t *handle, struct inode *inode,
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	ext3_mark_inode_dirty(handle, inode);
+	/* ext3_mark_inode_dirty already updated i_sync_tid */
+	atomic_set(&ei->i_datasync_tid, handle->h_transaction->t_tid);
 
 	/* had we spliced it onto indirect block? */
 	if (where->bh) {
@@ -2750,6 +2753,8 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 	struct ext3_inode_info *ei;
 	struct buffer_head *bh;
 	struct inode *inode;
+	journal_t *journal = EXT3_SB(sb)->s_journal;
+	transaction_t *transaction;
 	long ret;
 	int block;
 
@@ -2827,6 +2832,30 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
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
+	}
+
 	if (inode->i_ino >= EXT3_FIRST_INO(inode->i_sb) + 1 &&
 	    EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) {
 		/*
@@ -3011,6 +3040,7 @@ again:
 		err = rc;
 	ei->i_state &= ~EXT3_STATE_NEW;
 
+	atomic_set(&ei->i_sync_tid, handle->h_transaction->t_tid);
 out_brelse:
 	brelse (bh);
 	ext3_std_error(inode->i_sb, err);
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 7a520a8..427496c 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -466,6 +466,8 @@ static struct inode *ext3_alloc_inode(struct super_block *sb)
 		return NULL;
 	ei->i_block_alloc_info = NULL;
 	ei->vfs_inode.i_version = 1;
+	atomic_set(&ei->i_datasync_tid, 0);
+	atomic_set(&ei->i_sync_tid, 0);
 	return &ei->vfs_inode;
 }
 
diff --git a/include/linux/ext3_fs_i.h b/include/linux/ext3_fs_i.h
index ca1bfe9..93e7428 100644
--- a/include/linux/ext3_fs_i.h
+++ b/include/linux/ext3_fs_i.h
@@ -137,6 +137,14 @@ struct ext3_inode_info {
 	 * by other means, so we have truncate_mutex.
 	 */
 	struct mutex truncate_mutex;
+
+	/*
+	 * Transactions that contain inode's metadata needed to complete
+	 * fsync and fdatasync, respectively.
+	 */
+	atomic_t i_sync_tid;
+	atomic_t i_datasync_tid;
+
 	struct inode vfs_inode;
 };
 
-- 
1.6.0.2

