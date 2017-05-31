From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v5 13/17] jbd2: conditionally handle errors using errseq_t based on FS_WB_ERRSEQ flag
Date: Wed, 31 May 2017 08:45:36 -0400
Message-ID: <20170531124540.8782-14-jlayton@redhat.com>
References: <20170531124540.8782-1-jlayton@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170531124540.8782-1-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Grab the current mapping->wb_err when linking a transaction to the list
and stash it in the journal inode. Then we can use that as a "since"
value when committing it to ensure that there were no writeback errors
since the transaction was started.

We do still need to perform old-style error handling too for now in
journal_finish_inode_data_buffers. jbd2 is shared infrastructure between
several filesystems. Eventually we should be able to remove the flag check
and simplify this function again.

For journal recovery, sample the wb_err early on and then pass that as
the since value to sync_blockdev_since.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/jbd2/commit.c      | 29 +++++++++++++++++++----------
 fs/jbd2/recovery.c    |  5 +++--
 fs/jbd2/transaction.c |  1 +
 include/linux/jbd2.h  |  3 +++
 4 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index b6b194ec1b4f..aea71e4bc9be 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -259,21 +259,30 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
 	/* For locking, see the comment in journal_submit_data_buffers() */
 	spin_lock(&journal->j_list_lock);
 	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
+		struct inode *inode = jinode->i_vfs_inode;
+
 		if (!(jinode->i_flags & JI_WAIT_DATA))
 			continue;
 		jinode->i_flags |= JI_COMMIT_RUNNING;
 		spin_unlock(&journal->j_list_lock);
-		err = filemap_fdatawait(jinode->i_vfs_inode->i_mapping);
-		if (err) {
-			/*
-			 * Because AS_EIO is cleared by
-			 * filemap_fdatawait_range(), set it again so
-			 * that user process can get -EIO from fsync().
-			 */
-			mapping_set_error(jinode->i_vfs_inode->i_mapping, -EIO);
-
-			if (!ret)
+		if (inode->i_sb->s_type->fs_flags & FS_WB_ERRSEQ) {
+			err = filemap_fdatawait_since(inode->i_mapping,
+					jinode->i_since);
+			if (err && !ret)
 				ret = err;
+		} else {
+			err = filemap_fdatawait(inode->i_mapping);
+			if (err) {
+				/*
+				 * Because AS_EIO is cleared by
+				 * filemap_fdatawait_range(), we must set it again so
+				 * that user process can get -EIO from fsync() if
+				 * non-errseq_t based error tracking is in play.
+				 */
+				mapping_set_error(inode->i_mapping, -EIO);
+				if (!ret)
+					ret = err;
+			}
 		}
 		spin_lock(&journal->j_list_lock);
 		jinode->i_flags &= ~JI_COMMIT_RUNNING;
diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 02dd3360cb20..06a8ee71848c 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -248,11 +248,12 @@ int jbd2_journal_recover(journal_t *journal)
 {
 	int			err, err2;
 	journal_superblock_t *	sb;
-
 	struct recovery_info	info;
+	errseq_t		since;
 
 	memset(&info, 0, sizeof(info));
 	sb = journal->j_superblock;
+	since = filemap_sample_wb_err(journal->j_fs_dev->bd_inode->i_mapping);
 
 	/*
 	 * The journal superblock's s_start field (the current log head)
@@ -284,7 +285,7 @@ int jbd2_journal_recover(journal_t *journal)
 	journal->j_transaction_sequence = ++info.end_transaction;
 
 	jbd2_journal_clear_revoke(journal);
-	err2 = sync_blockdev(journal->j_fs_dev);
+	err2 = sync_blockdev_since(journal->j_fs_dev, since);
 	if (!err)
 		err = err2;
 	/* Make sure all replayed data is on permanent storage */
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 9ee4832b6f8b..e9e6af20a087 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2535,6 +2535,7 @@ static int jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *jinode,
 	/* Not on any transaction list... */
 	J_ASSERT(!jinode->i_next_transaction);
 	jinode->i_transaction = transaction;
+	jinode->i_since = filemap_sample_wb_err(jinode->i_vfs_inode->i_mapping);
 	list_add(&jinode->i_list, &transaction->t_inode_list);
 done:
 	spin_unlock(&journal->j_list_lock);
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 606b6bce3a5b..b6901eac2d8e 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -439,6 +439,9 @@ struct jbd2_inode {
 
 	/* Flags of inode [j_list_lock] */
 	unsigned long i_flags;
+
+	/* Sampled writeback error at the time of transaction start */
+	errseq_t i_since;
 };
 
 struct jbd2_revoke_table_s;
-- 
2.9.4
