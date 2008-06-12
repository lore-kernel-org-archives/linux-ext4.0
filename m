From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH] ext4: Add ordered mode support for delalloc
Date: Thu, 12 Jun 2008 20:55:16 +0530
Message-ID: <1213284316-22063-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:46340 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbYFLPZb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 11:25:31 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5CFOvmJ019737
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 01:24:57 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5CFP89L3682328
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 01:25:09 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5CFPRoo016635
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 01:25:28 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c  |  169 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/jbd2/commit.c |   41 ++++++++++++--
 2 files changed, 198 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 63355ab..7d87641 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1606,13 +1606,12 @@ static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
 	return !buffer_mapped(bh) || buffer_delay(bh);
 }
 
-/* FIXME!! only support data=writeback mode */
 /*
  * get called vi ext4_da_writepages after taking page lock
  * We may end up doing block allocation here in case
  * mpage_da_map_blocks failed to allocate blocks.
  */
-static int ext4_da_writepage(struct page *page,
+static int ext4_da_writeback_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
 	int ret = 0;
@@ -1660,6 +1659,61 @@ static int ext4_da_writepage(struct page *page,
 	return ret;
 }
 
+/*
+ * get called vi ext4_da_writepages after taking page lock
+ * We may end up doing block allocation here in case
+ * mpage_da_map_blocks failed to allocate blocks.
+ *
+ * We also get called via journal_submit_inode_data_buffers
+ */
+static int ext4_da_ordered_writepage(struct page *page,
+				struct writeback_control *wbc)
+{
+	int ret = 0;
+	loff_t size;
+	unsigned long len;
+	handle_t *handle = NULL;
+	struct buffer_head *page_bufs;
+	struct inode *inode = page->mapping->host;
+
+	handle = ext4_journal_current_handle();
+	if (!handle) {
+		/*
+		 * This can happen when we aren't called via
+		 * ext4_da_writepages() but directly (shrink_page_list).
+		 * We cannot easily start a transaction here so we just skip
+		 * writing the page in case we would have to do so.
+		 */
+		size = i_size_read(inode);
+
+		page_bufs = page_buffers(page);
+		if (page->index == size >> PAGE_CACHE_SHIFT)
+			len = size & ~PAGE_CACHE_MASK;
+		else
+			len = PAGE_CACHE_SIZE;
+
+		if (walk_page_buffers(NULL, page_bufs, 0,
+				len, NULL, ext4_bh_unmapped_or_delay)) {
+			/*
+			 * We can't do block allocation under
+			 * page lock without a handle . So redirty
+			 * the page and return.
+			 * We may reach here when we do a journal commit
+			 * via journal_submit_inode_data_buffers.
+			 * If we don't have mapping block we just ignore
+			 * them
+			 *
+			 */
+			redirty_page_for_writepage(wbc, page);
+			unlock_page(page);
+			return 0;
+		}
+	}
+
+	ret = block_write_full_page(page, ext4_da_get_block_write, wbc);
+
+	return ret;
+}
 
 /*
  * For now just follow the DIO way to estimate the max credits
@@ -1745,19 +1799,99 @@ static int ext4_da_writepages(struct address_space *mapping,
 	return ret;
 }
 
+static int ext4_da_ordered_writepages(struct address_space *mapping,
+				struct writeback_control *wbc)
+{
+	struct inode *inode = mapping->host;
+	handle_t *handle = NULL;
+	int needed_blocks;
+	int ret = 0;
+	long to_write;
+	loff_t range_start = 0;
+
+
+	/*
+	 * No pages to write? This is mainly a kludge to avoid starting
+	 * a transaction for special inodes like journal inode on last iput()
+	 * because that could violate lock ordering on umount
+	 */
+	if (!mapping->nrpages)
+		return 0;
+
+	/*
+	 *  Estimate the worse case needed credits to write out
+	 * EXT4_MAX_BUF_BLOCKS pages
+	 */
+	needed_blocks = EXT4_MAX_WRITEBACK_CREDITS;
+
+	to_write = wbc->nr_to_write;
+	if (!wbc->range_cyclic) {
+		/*
+		 * If range_cyclic is not set force range_cont
+		 * and save the old writeback_index
+		 */
+		wbc->range_cont = 1;
+		range_start =  wbc->range_start;
+	}
+
+	while (!ret && to_write) {
+		/* start a new transaction*/
+		handle = ext4_journal_start(inode, needed_blocks);
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			goto out_writepages;
+		}
+
+		ret = ext4_jbd2_file_inode(handle, inode);
+		if (ret) {
+			ext4_journal_stop(handle);
+			goto out_writepages;
+		}
+		/*
+		 * set the max dirty pages could be write at a time
+		 * to fit into the reserved transaction credits
+		 */
+		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
+			wbc->nr_to_write = EXT4_MAX_WRITEBACK_PAGES;
+
+		to_write -= wbc->nr_to_write;
+		ret = mpage_da_writepages(mapping, wbc,
+						ext4_da_get_block_write);
+		ext4_journal_stop(handle);
+		if (wbc->nr_to_write) {
+			/*
+			 * There is no more writeout needed
+			 * or we requested for a noblocking writeout
+			 * and we found the device congested
+			 */
+			to_write += wbc->nr_to_write;
+			break;
+		}
+		wbc->nr_to_write = to_write;
+	}
+
+out_writepages:
+	wbc->nr_to_write = to_write;
+	if (range_start)
+		wbc->range_start = range_start;
+	return ret;
+}
+
 static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata)
 {
-	int ret;
+	int ret, retries = 0;
 	struct page *page;
 	pgoff_t index;
 	unsigned from, to;
+	struct inode *inode = mapping->host;
 
 	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
 
+retry:
 	page = __grab_cache_page(mapping, index);
 	if (!page)
 		return -ENOMEM;
@@ -1770,6 +1904,9 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 		page_cache_release(page);
 	}
 
+	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+		goto retry;
+
 	return ret;
 }
 
@@ -2224,10 +2361,10 @@ static int ext4_journalled_set_page_dirty(struct page *page)
 	.releasepage	= ext4_releasepage,
 };
 
-static const struct address_space_operations ext4_da_aops = {
+static const struct address_space_operations ext4_da_writeback_aops = {
 	.readpage	= ext4_readpage,
 	.readpages	= ext4_readpages,
-	.writepage	= ext4_da_writepage,
+	.writepage	= ext4_da_writeback_writepage,
 	.writepages	= ext4_da_writepages,
 	.sync_page	= block_sync_page,
 	.write_begin	= ext4_da_write_begin,
@@ -2239,13 +2376,31 @@ static int ext4_journalled_set_page_dirty(struct page *page)
 	.migratepage	= buffer_migrate_page,
 };
 
+static const struct address_space_operations ext4_da_ordered_aops = {
+	.readpage	= ext4_readpage,
+	.readpages	= ext4_readpages,
+	.writepage	= ext4_da_ordered_writepage,
+	.writepages	= ext4_da_ordered_writepages,
+	.sync_page	= block_sync_page,
+	.write_begin	= ext4_da_write_begin,
+	.write_end	= generic_write_end,
+	.bmap		= ext4_bmap,
+	.invalidatepage	= ext4_da_invalidatepage,
+	.releasepage	= ext4_releasepage,
+	.direct_IO	= ext4_direct_IO,
+	.migratepage	= buffer_migrate_page,
+};
+
 void ext4_set_aops(struct inode *inode)
 {
-	if (ext4_should_order_data(inode))
+	if (ext4_should_order_data(inode) &&
+		test_opt(inode->i_sb, DELALLOC))
+		inode->i_mapping->a_ops = &ext4_da_ordered_aops;
+	else if (ext4_should_order_data(inode))
 		inode->i_mapping->a_ops = &ext4_ordered_aops;
 	else if (ext4_should_writeback_data(inode) &&
 		 test_opt(inode->i_sb, DELALLOC))
-		inode->i_mapping->a_ops = &ext4_da_aops;
+		inode->i_mapping->a_ops = &ext4_da_writeback_aops;
 	else if (ext4_should_writeback_data(inode))
 		inode->i_mapping->a_ops = &ext4_writeback_aops;
 	else
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 483183d..32ca3c3 100644
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
@@ -185,6 +187,30 @@ static int journal_wait_on_commit_record(struct buffer_head *bh)
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
+	if (!mapping_cap_writeback_dirty(mapping))
+		return 0;
+
+	ret = generic_writepages(mapping, &wbc);
+	return ret;
+}
+
+/*
  * Submit all the data buffers of inode associated with the transaction to
  * disk.
  *
@@ -192,7 +218,7 @@ static int journal_wait_on_commit_record(struct buffer_head *bh)
  * our inode list. We use JI_COMMIT_RUNNING flag to protect inode we currently
  * operate on from being released while we write out pages.
  */
-static int journal_submit_inode_data_buffers(journal_t *journal,
+static int journal_submit_data_buffers(journal_t *journal,
 		transaction_t *commit_transaction)
 {
 	struct jbd2_inode *jinode;
@@ -204,8 +230,13 @@ static int journal_submit_inode_data_buffers(journal_t *journal,
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
@@ -228,7 +259,7 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
 	struct jbd2_inode *jinode, *next_i;
 	int err, ret = 0;
 
-	/* For locking, see the comment in journal_submit_inode_data_buffers() */
+	/* For locking, see the comment in journal_submit_data_buffers() */
 	spin_lock(&journal->j_list_lock);
 	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
 		jinode->i_flags |= JI_COMMIT_RUNNING;
@@ -431,7 +462,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	 * Now start flushing things to disk, in the order they appear
 	 * on the transaction lists.  Data blocks go first.
 	 */
-	err = journal_submit_inode_data_buffers(journal, commit_transaction);
+	err = journal_submit_data_buffers(journal, commit_transaction);
 	if (err)
 		jbd2_journal_abort(journal, err);
 
-- 
1.5.6.rc2.15.g457bb.dirty

