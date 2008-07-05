From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 47/52] ext4: Add ordered mode support for delalloc
Date: Sat,  5 Jul 2008 13:36:13 -0400
Message-ID: <1215279378-30504-48-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
 <1215279378-30504-18-git-send-email-tytso@mit.edu>
 <1215279378-30504-19-git-send-email-tytso@mit.edu>
 <1215279378-30504-20-git-send-email-tytso@mit.edu>
 <1215279378-30504-21-git-send-email-tytso@mit.edu>
 <1215279378-30504-22-git-send-email-tytso@mit.edu>
 <1215279378-30504-23-git-send-email-tytso@mit.edu>
 <1215279378-30504-24-git-send-email-tytso@mit.edu>
 <1215279378-30504-25-git-send-email-tytso@mit.edu>
 <1215279378-30504-26-git-send-email-tytso@mit.edu>
 <1215279378-30504-27-git-send-email-tytso@mit.edu>
 <1215279378-30504-28-git-send-email-tytso@mit.edu>
 <1215279378-30504-29-git-send-email-tytso@mit.edu>
 <1215279378-30504-30-git-send-email-tytso@mit.edu>
 <1215279378-30504-31-git-send-email-tytso@mit.edu>
 <1215279378-30504-32-git-send-email-tytso@mit.edu>
 <1215279378-30504-33-git-send-email-tytso@mit.edu>
 <1215279378-30504-34-git-send-email-tytso@mit.edu>
 <1215279378-30504-35-git-send-email-tytso@mit.edu>
 <1215279378-30504-36-git-send-email-tytso@mit.edu>
 <1215279378-30504-37-git-send-email-tytso@mit.edu>
 <1215279378-30504-38-git-send-email-tytso@mit.edu>
 <1215279378-30504-39-git-send-email-tytso@mit.edu>
 <1215279378-30504-40-git-send-email-tytso@mit.edu>
 <1215279378-30504-41-git-send-email-tytso@mit.edu>
 <1215279378-30504-42-git-send-email-tytso@mit.edu>
 <1215279378-30504-43-git-send-email-tytso@mit.edu>
 <1215279378-30504-44-git-send-email-tytso@mit.edu>
 <1215279378-30504-45-git-send-email-tytso@mit.edu>
 <1215279378-30504-46-git-send-email-tytso@mit.edu>
 <1215279378-30504-47-git-send-email-tytso@mit.edu>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33051 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754757AbYGERga (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:30 -0400
In-Reply-To: <1215279378-30504-47-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

This provides a new ordered mode implementation which gets rid of using
buffer heads to enforce the ordering between metadata change with the
related data chage.  Instead, in the new ordering mode, it keeps track
of all of the inodes touched by each transaction on a list, and when
that transaction is committed, it flushes all of the dirty pages for
those inodes.  In addition, the new ordered mode reverses the lock
ordering of the page lock and transaction lock, which provides easier
support for delayed allocation.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c  |   30 +++++++++++++++++++++++++-----
 fs/jbd2/commit.c |   38 +++++++++++++++++++++++++++++++++-----
 2 files changed, 58 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index db5aee8..7d1171a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1636,11 +1636,12 @@ static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
 	return !buffer_mapped(bh) || buffer_delay(bh);
 }
 
-/* FIXME!! only support data=writeback mode */
 /*
  * get called vi ext4_da_writepages after taking page lock
  * We may end up doing block allocation here in case
  * mpage_da_map_blocks failed to allocate blocks.
+ *
+ * We also get called via journal_submit_inode_data_buffers
  */
 static int ext4_da_writepage(struct page *page,
 				struct writeback_control *wbc)
@@ -1659,6 +1660,7 @@ static int ext4_da_writepage(struct page *page,
 		 * ext4_da_writepages() but directly (shrink_page_list).
 		 * We cannot easily start a transaction here so we just skip
 		 * writing the page in case we would have to do so.
+		 * We reach here also via journal_submit_inode_data_buffers
 		 */
 		size = i_size_read(inode);
 
@@ -1674,8 +1676,11 @@ static int ext4_da_writepage(struct page *page,
 			 * We can't do block allocation under
 			 * page lock without a handle . So redirty
 			 * the page and return
+			 * We may reach here when we do a journal commit
+			 * via journal_submit_inode_data_buffers.
+			 * If we don't have mapping block we just ignore
+			 * them
 			 */
-			BUG_ON(wbc->sync_mode != WB_SYNC_NONE);
 			redirty_page_for_writepage(wbc, page);
 			unlock_page(page);
 			return 0;
@@ -1690,7 +1695,6 @@ static int ext4_da_writepage(struct page *page,
 	return ret;
 }
 
-
 /*
  * For now just follow the DIO way to estimate the max credits
  * needed to write out EXT4_MAX_WRITEBACK_PAGES.
@@ -1723,7 +1727,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 		return 0;
 
 	/*
-	 *  Estimate the worse case needed credits to write out
+	 * Estimate the worse case needed credits to write out
 	 * EXT4_MAX_BUF_BLOCKS pages
 	 */
 	needed_blocks = EXT4_MAX_WRITEBACK_CREDITS;
@@ -1745,6 +1749,19 @@ static int ext4_da_writepages(struct address_space *mapping,
 			ret = PTR_ERR(handle);
 			goto out_writepages;
 		}
+		if (ext4_should_order_data(inode)) {
+			/*
+			 * With ordered mode we need to add
+			 * the inode to the journal handle
+			 * when we do block allocation.
+			 */
+			ret = ext4_jbd2_file_inode(handle, inode);
+			if (ret) {
+				ext4_journal_stop(handle);
+				goto out_writepages;
+			}
+
+		}
 		/*
 		 * set the max dirty pages could be write at a time
 		 * to fit into the reserved transaction credits
@@ -2328,7 +2345,10 @@ static const struct address_space_operations ext4_da_aops = {
 
 void ext4_set_aops(struct inode *inode)
 {
-	if (ext4_should_order_data(inode))
+	if (ext4_should_order_data(inode) &&
+		test_opt(inode->i_sb, DELALLOC))
+		inode->i_mapping->a_ops = &ext4_da_aops;
+	else if (ext4_should_order_data(inode))
 		inode->i_mapping->a_ops = &ext4_ordered_aops;
 	else if (ext4_should_writeback_data(inode) &&
 		 test_opt(inode->i_sb, DELALLOC))
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 483183d..f8b3be8 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -22,6 +22,8 @@
 #include <linux/pagemap.h>
 #include <linux/jiffies.h>
 #include <linux/crc32.h>
+#include <linux/writeback.h>
+#include <linux/backing-dev.h>
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
@@ -185,6 +187,27 @@ static int journal_wait_on_commit_record(struct buffer_head *bh)
 }
 
 /*
+ * write the filemap data using writepage() address_space_operations.
+ * We don't do block allocation here even for delalloc. We don't
+ * use writepages() because with dealyed allocation we may be doing
+ * block allocation in writepages().
+ */
+static int journal_submit_inode_data_buffers(struct address_space *mapping)
+{
+	int ret;
+	struct writeback_control wbc = {
+		.sync_mode =  WB_SYNC_ALL,
+		.nr_to_write = mapping->nrpages * 2,
+		.range_start = 0,
+		.range_end = i_size_read(mapping->host),
+		.for_writepages = 1,
+	};
+
+	ret = generic_writepages(mapping, &wbc);
+	return ret;
+}
+
+/*
  * Submit all the data buffers of inode associated with the transaction to
  * disk.
  *
@@ -192,7 +215,7 @@ static int journal_wait_on_commit_record(struct buffer_head *bh)
  * our inode list. We use JI_COMMIT_RUNNING flag to protect inode we currently
  * operate on from being released while we write out pages.
  */
-static int journal_submit_inode_data_buffers(journal_t *journal,
+static int journal_submit_data_buffers(journal_t *journal,
 		transaction_t *commit_transaction)
 {
 	struct jbd2_inode *jinode;
@@ -204,8 +227,13 @@ static int journal_submit_inode_data_buffers(journal_t *journal,
 		mapping = jinode->i_vfs_inode->i_mapping;
 		jinode->i_flags |= JI_COMMIT_RUNNING;
 		spin_unlock(&journal->j_list_lock);
-		err = filemap_fdatawrite_range(mapping, 0,
-					i_size_read(jinode->i_vfs_inode));
+		/*
+		 * submit the inode data buffers. We use writepage
+		 * instead of writepages. Because writepages can do
+		 * block allocation  with delalloc. We need to write
+		 * only allocated blocks here.
+		 */
+		err = journal_submit_inode_data_buffers(mapping);
 		if (!ret)
 			ret = err;
 		spin_lock(&journal->j_list_lock);
@@ -228,7 +256,7 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
 	struct jbd2_inode *jinode, *next_i;
 	int err, ret = 0;
 
-	/* For locking, see the comment in journal_submit_inode_data_buffers() */
+	/* For locking, see the comment in journal_submit_data_buffers() */
 	spin_lock(&journal->j_list_lock);
 	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
 		jinode->i_flags |= JI_COMMIT_RUNNING;
@@ -431,7 +459,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	 * Now start flushing things to disk, in the order they appear
 	 * on the transaction lists.  Data blocks go first.
 	 */
-	err = journal_submit_inode_data_buffers(journal, commit_transaction);
+	err = journal_submit_data_buffers(journal, commit_transaction);
 	if (err)
 		jbd2_journal_abort(journal, err);
 
-- 
1.5.6.rc3.1.g36b7.dirty

