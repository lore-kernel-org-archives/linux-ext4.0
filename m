From: Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH] Avoid unnecessarily writing back dirty pages before hole punching
Date: Tue, 14 May 2013 15:44:54 +0800
Message-ID: <1368517494-12472-1-git-send-email-liwang@ubuntukylin.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Li Wang <liwang@ubuntukylin.com>,
	Yunchuan Wen <yunchuanwen@ubuntukylin.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from m53-178.qiye.163.com ([123.58.178.53]:60114 "EHLO
	m53-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab3ENHwc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 May 2013 03:52:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For hole punching, currently ext4 will synchronously write back the
dirty pages fit into the hole, since the data on the disk responding
to those pages are to be deleted, it is benefical to directly release
those pages, no matter they are dirty or not, except the ordered case.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c       |   21 ++++++++++-------
 fs/jbd2/transaction.c |   62 +++++++++++++++++++++++++++++++------------------
 include/linux/jbd2.h  |    2 ++
 3 files changed, 55 insertions(+), 30 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0723774..3e00360 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3578,6 +3578,16 @@ int ext4_can_truncate(struct inode *inode)
 	return 0;
 }
 
+static inline int ext4_begin_ordered_fallocate(struct inode *inode,
+					      loff_t start, loff_t length)
+{
+	if (!EXT4_I(inode)->jinode)
+		return 0;
+	return jbd2_journal_begin_ordered_fallocate(EXT4_JOURNAL(inode),
+						   EXT4_I(inode)->jinode,
+						   start, length);
+}
+
 /*
  * ext4_punch_hole: punches a hole in a file by releaseing the blocks
  * associated with the given offset and length
@@ -3611,17 +3621,12 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 
 	trace_ext4_punch_hole(inode, offset, length);
 
-	/*
-	 * Write out all dirty pages to avoid race conditions
-	 * Then release them.
-	 */
-	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
-		ret = filemap_write_and_wait_range(mapping, offset,
-						   offset + length - 1);
+	if (ext4_should_order_data(inode)) {
+		ret = ext4_begin_ordered_fallocate(inode, offset, length);
 		if (ret)
 			return ret;
 	}
-
+	
 	mutex_lock(&inode->i_mutex);
 	/* It's not possible punch hole on append only file */
 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode)) {
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 10f524c..1284e1b 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2305,6 +2305,36 @@ done:
 	return 0;
 }
 
+
+static int jbd2_journal_begin_ordered_discard(journal_t *journal,
+					struct jbd2_inode *jinode,
+					loff_t start, loff_t end)
+{
+	transaction_t *inode_trans, *commit_trans;
+	int ret = 0;
+
+	/* This is a quick check to avoid locking if not necessary */
+	if (!jinode->i_transaction)
+		goto out;
+	/* Locks are here just to force reading of recent values, it is
+	 * enough that the transaction was not committing before we started
+	 * a transaction adding the inode to orphan list */
+	read_lock(&journal->j_state_lock);
+	commit_trans = journal->j_committing_transaction;
+	read_unlock(&journal->j_state_lock);
+	spin_lock(&journal->j_list_lock);
+	inode_trans = jinode->i_transaction;
+	spin_unlock(&journal->j_list_lock);
+	if (inode_trans == commit_trans) {
+		ret = filemap_fdatawrite_range(jinode->i_vfs_inode->i_mapping,
+			start, end);
+		if (ret)
+			jbd2_journal_abort(journal, ret);
+	}
+out:
+	return ret;
+}
+
 /*
  * File truncate and transaction commit interact with each other in a
  * non-trivial way.  If a transaction writing data block A is
@@ -2329,27 +2359,15 @@ int jbd2_journal_begin_ordered_truncate(journal_t *journal,
 					struct jbd2_inode *jinode,
 					loff_t new_size)
 {
-	transaction_t *inode_trans, *commit_trans;
-	int ret = 0;
+	return jbd2_journal_begin_ordered_discard(journal, jinode, 
+												new_size, LLONG_MAX);
+}
 
-	/* This is a quick check to avoid locking if not necessary */
-	if (!jinode->i_transaction)
-		goto out;
-	/* Locks are here just to force reading of recent values, it is
-	 * enough that the transaction was not committing before we started
-	 * a transaction adding the inode to orphan list */
-	read_lock(&journal->j_state_lock);
-	commit_trans = journal->j_committing_transaction;
-	read_unlock(&journal->j_state_lock);
-	spin_lock(&journal->j_list_lock);
-	inode_trans = jinode->i_transaction;
-	spin_unlock(&journal->j_list_lock);
-	if (inode_trans == commit_trans) {
-		ret = filemap_fdatawrite_range(jinode->i_vfs_inode->i_mapping,
-			new_size, LLONG_MAX);
-		if (ret)
-			jbd2_journal_abort(journal, ret);
-	}
-out:
-	return ret;
+int jbd2_journal_begin_ordered_fallocate(journal_t *journal,
+					struct jbd2_inode *jinode,
+					loff_t start, loff_t length)
+{
+	return jbd2_journal_begin_ordered_discard(journal, jinode, 
+												start, start + length - 1);
 }
+
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 6e051f4..9940cfb 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1128,6 +1128,8 @@ extern int	   jbd2_journal_force_commit(journal_t *);
 extern int	   jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *inode);
 extern int	   jbd2_journal_begin_ordered_truncate(journal_t *journal,
 				struct jbd2_inode *inode, loff_t new_size);
+extern int	   jbd2_journal_begin_ordered_fallocate(journal_t *journal,
+				struct jbd2_inode *inode, loff_t start, loff_t length);
 extern void	   jbd2_journal_init_jbd_inode(struct jbd2_inode *jinode, struct inode *inode);
 extern void	   jbd2_journal_release_jbd_inode(journal_t *journal, struct jbd2_inode *jinode);
 
-- 
1.7.9.5


