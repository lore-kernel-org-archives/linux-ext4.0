From: Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH] ext4: Avoid unnecessarily writing back dirty pages before hole punching
Date: Mon, 27 May 2013 22:25:36 +0800
Message-ID: <1369664736-9045-1-git-send-email-liwang@ubuntukylin.com>
References: <20130521092233.GA10180@quack.suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, Li Wang <liwang@ubuntukylin.com>,
	Yunchuan Wen <yunchuanwen@ubuntukylin.com>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130521092233.GA10180@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

For hole punching, currently ext4 will synchronously write back the
dirty pages fit into the hole, since the data on the disk responding
to those pages are to be deleted, it is benefical to directly release
those pages, no matter they are dirty or not, except the ordered case.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Jan Kara <jack@suse.cz>
---
Hi Zheng and Jan,
  Thanks for your comments.
  For data=ordered vs. data=writeback, my understanding is
that they both journal metadata, so metadata won't be corrupted
in both cases. And they both do not journal data, so data
may be lost under either case. So it is basically the same
under overwriting situation, that is, data may not be fully updated.
The difference lies in that for appending write, with data=writeback,
the commit of metadata is done asynchronously
with the write of data, so it may happen
that file size is increased, with data incompletely written,
leaves partly uninitialized data, as
pointed out by Jan, that results in security issues. For
data=ordered, metadata is committed after data are
written with slightly? lower performance, so reader won't read out
uninitialized data.
  We introduce the internal function jbd2_journal_begin_ordered_discard()
because it will be called by both jbd2_journal_begin_ordered_punch_hole()
and jbd2_journal_begin_ordered_truncate(),
and we want to leave the function prototype of jbd2_journal_begin_ordered_
truncate() unchanged, and it has less arguments than the punch hole
counterpart. The other way is we implement them independently without the
internal begin_ordered_discard() function, however, in that case,
the two functions will suffer from sharing a
big and almost the same body, that is not elegant.
  We have taken other suggestions from Jan.
---
 fs/ext4/inode.c       |   27 ++++++++++++++++-----------
 fs/jbd2/journal.c     |    2 +-
 fs/jbd2/transaction.c |   29 ++++++-----------------------
 include/linux/jbd2.h  |   41 +++++++++++++++++++++++++++++++++++++++--
 4 files changed, 62 insertions(+), 37 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d6382b8..6b0251e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3569,6 +3569,16 @@ int ext4_can_truncate(struct inode *inode)
 	return 0;
 }
 
+static inline int ext4_begin_ordered_punch_hole(struct inode *inode,
+					       loff_t start, loff_t length)
+{
+	if (!EXT4_I(inode)->jinode)
+		return 0;
+	return jbd2_journal_begin_ordered_punch_hole(EXT4_JOURNAL(inode),
+						    EXT4_I(inode)->jinode,
+						    start, length);
+}
+
 /*
  * ext4_punch_hole: punches a hole in a file by releaseing the blocks
  * associated with the given offset and length
@@ -3602,17 +3612,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 
 	trace_ext4_punch_hole(inode, offset, length);
 
-	/*
-	 * Write out all dirty pages to avoid race conditions
-	 * Then release them.
-	 */
-	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
-		ret = filemap_write_and_wait_range(mapping, offset,
-						   offset + length - 1);
-		if (ret)
-			return ret;
-	}
-
 	mutex_lock(&inode->i_mutex);
 	/* It's not possible punch hole on append only file */
 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode)) {
@@ -3644,6 +3643,12 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 	first_page_offset = first_page << PAGE_CACHE_SHIFT;
 	last_page_offset = last_page << PAGE_CACHE_SHIFT;
 
+	if (ext4_should_order_data(inode)) {
+		ret = ext4_begin_ordered_punch_hole(inode, offset, length);
+		if (ret)
+			return ret;
+	}
+
 	/* Now release the pages */
 	if (last_page_offset > first_page_offset) {
 		truncate_pagecache_range(inode, first_page_offset,
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 9545757..166ca5d 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -97,7 +97,7 @@ EXPORT_SYMBOL(jbd2_journal_force_commit);
 EXPORT_SYMBOL(jbd2_journal_file_inode);
 EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
 EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
-EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
+EXPORT_SYMBOL(jbd2_journal_begin_ordered_discard);
 EXPORT_SYMBOL(jbd2_inode_cache);
 
 static void __journal_abort_soft (journal_t *journal, int errno);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 10f524c..2d7a3bf 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2305,29 +2305,10 @@ done:
 	return 0;
 }
 
-/*
- * File truncate and transaction commit interact with each other in a
- * non-trivial way.  If a transaction writing data block A is
- * committing, we cannot discard the data by truncate until we have
- * written them.  Otherwise if we crashed after the transaction with
- * write has committed but before the transaction with truncate has
- * committed, we could see stale data in block A.  This function is a
- * helper to solve this problem.  It starts writeout of the truncated
- * part in case it is in the committing transaction.
- *
- * Filesystem code must call this function when inode is journaled in
- * ordered mode before truncation happens and after the inode has been
- * placed on orphan list with the new inode size. The second condition
- * avoids the race that someone writes new data and we start
- * committing the transaction after this function has been called but
- * before a transaction for truncate is started (and furthermore it
- * allows us to optimize the case where the addition to orphan list
- * happens in the same transaction as write --- we don't have to write
- * any data in such case).
- */
-int jbd2_journal_begin_ordered_truncate(journal_t *journal,
+
+int jbd2_journal_begin_ordered_discard(journal_t *journal,
 					struct jbd2_inode *jinode,
-					loff_t new_size)
+					loff_t start, loff_t end)
 {
 	transaction_t *inode_trans, *commit_trans;
 	int ret = 0;
@@ -2346,10 +2327,12 @@ int jbd2_journal_begin_ordered_truncate(journal_t *journal,
 	spin_unlock(&journal->j_list_lock);
 	if (inode_trans == commit_trans) {
 		ret = filemap_fdatawrite_range(jinode->i_vfs_inode->i_mapping,
-			new_size, LLONG_MAX);
+			start, end);
 		if (ret)
 			jbd2_journal_abort(journal, ret);
 	}
 out:
 	return ret;
 }
+
+
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 6e051f4..9543a5a 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1126,12 +1126,49 @@ extern int	   jbd2_journal_clear_err  (journal_t *);
 extern int	   jbd2_journal_bmap(journal_t *, unsigned long, unsigned long long *);
 extern int	   jbd2_journal_force_commit(journal_t *);
 extern int	   jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *inode);
-extern int	   jbd2_journal_begin_ordered_truncate(journal_t *journal,
-				struct jbd2_inode *inode, loff_t new_size);
+extern int	   jbd2_journal_begin_ordered_discard(journal_t *,
+					struct jbd2_inode *,
+					loff_t, loff_t);
 extern void	   jbd2_journal_init_jbd_inode(struct jbd2_inode *jinode, struct inode *inode);
 extern void	   jbd2_journal_release_jbd_inode(journal_t *journal, struct jbd2_inode *jinode);
 
 /*
+ * File truncate and transaction commit interact with each other in a
+ * non-trivial way.  If a transaction writing data block A is
+ * committing, we cannot discard the data by truncate until we have
+ * written them.  Otherwise if we crashed after the transaction with
+ * write has committed but before the transaction with truncate has
+ * committed, we could see stale data in block A.  This function is a
+ * helper to solve this problem.  It starts writeout of the truncated
+ * part in case it is in the committing transaction.
+ *
+ * Filesystem code must call this function when inode is journaled in
+ * ordered mode before truncation happens and after the inode has been
+ * placed on orphan list with the new inode size. The second condition
+ * avoids the race that someone writes new data and we start
+ * committing the transaction after this function has been called but
+ * before a transaction for truncate is started (and furthermore it
+ * allows us to optimize the case where the addition to orphan list
+ * happens in the same transaction as write --- we don't have to write
+ * any data in such case).
+ */
+static inline int jbd2_journal_begin_ordered_truncate(journal_t *journal,
+					struct jbd2_inode *jinode,
+					loff_t new_size)
+{
+	return jbd2_journal_begin_ordered_discard(journal, jinode,
+						  new_size, LLONG_MAX);
+}
+
+static inline int jbd2_journal_begin_ordered_punch_hole(journal_t *journal,
+					struct jbd2_inode *jinode,
+					loff_t start, loff_t length)
+{
+	return jbd2_journal_begin_ordered_discard(journal, jinode,
+						  start, start + length - 1);
+}
+
+/*
  * journal_head management
  */
 struct journal_head *jbd2_journal_add_journal_head(struct buffer_head *bh);
-- 
1.7.9.5
