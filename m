From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/3] ext4: Add generic writepage callback
Date: Wed, 27 May 2009 21:28:08 +0530
Message-ID: <1243439888-22680-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1243439888-22680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1243439888-22680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:60320 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbZE0P6a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 May 2009 11:58:30 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id n4RFwPk1009313
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2009 21:28:25 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4RFwPFq827564
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2009 21:28:25 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id n4RFwOis019735
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2009 01:58:25 +1000
In-Reply-To: <1243439888-22680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Even with changes to make pages writeprotect on truncate/i_size update we
can still see buffer_heads which are not mapped in the writepage
callback. Consider the below case.

1) truncate(f, 1024)
2) mmap(f, 0, 4096)
3) a[0] = 'a'
4) truncate(f, 4096)
5) writepage(...)

Now if we get a writepage callback immediately after (4) and before an
attempt to write at any other offset via mmap address (which implies we
are yet to get a pagefault and do a get_block) what we would have is the
page which is dirty have first block allocated and the other three
buffer_heads unmapped.

In the above case the writepage should go ahead and try to write
the first blocks and clear the page_dirty flag. Because the further
attempt to write to the page will again create a fault and result in
allocating blocks and marking page dirty. Also if we don't write
any other offset via mmap address we would still have written the first
block to the disk and rest of the space will be considered as a hole.

Delayed allocation writepage callback already did most of these. So
extend it to allow block_write_full_page on pages with unmapped buffer_heads.
We pass noalloc_get_block_write as the call back which ensures we don't
do any block allocation in writepage callback. That is need because of
the locking order between page lock and journal_start.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |  338 +++++++++++++++++--------------------------------------
 1 files changed, 104 insertions(+), 234 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1efb296..c1ddaaf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2326,7 +2326,7 @@ static int __mpage_da_writepage(struct page *page,
 			 * We need to try to allocate
 			 * unmapped blocks in the same page.
 			 * Otherwise we won't make progress
-			 * with the page in ext4_da_writepage
+			 * with the page in ext4_writepage
 			 */
 			if (ext4_bh_delay_or_unwritten(NULL, bh)) {
 				mpage_add_bh_to_extent(mpd, logical,
@@ -2452,14 +2452,102 @@ static int noalloc_get_block_write(struct inode *inode, sector_t iblock,
 	return ret;
 }
 
+static int bget_one(handle_t *handle, struct buffer_head *bh)
+{
+	get_bh(bh);
+	return 0;
+}
+
+static int bput_one(handle_t *handle, struct buffer_head *bh)
+{
+	put_bh(bh);
+	return 0;
+}
+
+static int __ext4_journalled_writepage(struct page *page,
+					struct writeback_control *wbc,
+					unsigned int len)
+{
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
+	struct buffer_head *page_bufs;
+	handle_t *handle = NULL;
+	int ret = 0;
+	int err;
+
+	page_bufs = page_buffers(page);
+	BUG_ON(!page_bufs);
+	walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
+	/* As soon as we unlock the page, it can go away, but we have
+	 * references to buffers so we are safe */
+	unlock_page(page);
+
+	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out;
+	}
+
+	ret = walk_page_buffers(handle, page_bufs, 0, len,
+				NULL, do_journal_get_write_access);
+
+	err = walk_page_buffers(handle, page_bufs, 0, len,
+				NULL, write_end_fn);
+	if (ret == 0)
+		ret = err;
+	err = ext4_journal_stop(handle);
+	if (!ret)
+		ret = err;
+
+	walk_page_buffers(handle, page_bufs, 0, len,
+				NULL, bput_one);
+	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
+out:
+	return ret;
+}
+
 /*
+ * Note that we don't need to start a transaction unless we're journaling data
+ * because we should have holes filled from ext4_page_mkwrite(). We even don't
+ * need to file the inode to the transaction's list in ordered mode because if
+ * we are writing back data added by write(), the inode is already there and if
+ * we are writing back data modified via mmap(), noone guarantees in which
+ * transaction the data will hit the disk. In case we are journaling data, we
+ * cannot start transaction directly because transaction start ranks above page
+ * lock so we have to do some magic.
+ *
  * This function can get called via...
  *   - ext4_da_writepages after taking page lock (have journal handle)
  *   - journal_submit_inode_data_buffers (no journal handle)
  *   - shrink_page_list via pdflush (no journal handle)
  *   - grab_page_cache when doing write_begin (have journal handle)
+ *
+ * We don't do any block allocation in this function. If we have page with
+ * multiple blocks we need to write those buffer_heads that are mapped. This
+ * is important for mmaped based write. So if we do with blocksize 1K
+ * truncate(f, 1024);
+ * a = mmap(f, 0, 4096);
+ * a[0] = 'a';
+ * truncate(f, 4096);
+ * we have in the page first buffer_head mapped via page_mkwrite call back
+ * but other bufer_heads would be unmapped but dirty(dirty done via the
+ * do_wp_page). So writepage should write the first block. If we modify
+ * the mmap area beyond 1024 we will again get a page_fault and the
+ * page_mkwrite callback will do the block allocation and mark the
+ * buffer_heads mapped.
+ *
+ * We redirty the page if we have any buffer_heads that is either delay or
+ * unwritten in the page.
+ *
+ * We can get recursively called as show below.
+ *
+ *	ext4_writepage() -> kmalloc() -> __alloc_pages() -> page_launder() ->
+ *		ext4_writepage()
+ *
+ * But since we don't do any block allocation we should not deadlock.
+ * Page also have the dirty flag cleared so we don't get recurive page_lock.
  */
-static int ext4_da_writepage(struct page *page,
+static int ext4_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
 	int ret = 0;
@@ -2468,7 +2556,7 @@ static int ext4_da_writepage(struct page *page,
 	struct buffer_head *page_bufs;
 	struct inode *inode = page->mapping->host;
 
-	trace_mark(ext4_da_writepage,
+	trace_mark(ext4_writepage,
 		   "dev %s ino %lu page_index %lu",
 		   inode->i_sb->s_id, inode->i_ino, page->index);
 	size = i_size_read(inode);
@@ -2532,6 +2620,15 @@ static int ext4_da_writepage(struct page *page,
 		block_commit_write(page, 0, len);
 	}
 
+	if (PageChecked(page) && ext4_should_journal_data(inode)) {
+		/*
+		 * It's mmapped pagecache.  Add buffers and journal it.  There
+		 * doesn't seem much point in redirtying the page here.
+		 */
+		ClearPageChecked(page);
+		return __ext4_journalled_writepage(page, wbc, len);
+	}
+
 	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
 		ret = nobh_writepage(page, noalloc_get_block_write, wbc);
 	else
@@ -3085,233 +3182,6 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 	return generic_block_bmap(mapping, block, ext4_get_block);
 }
 
-static int bget_one(handle_t *handle, struct buffer_head *bh)
-{
-	get_bh(bh);
-	return 0;
-}
-
-static int bput_one(handle_t *handle, struct buffer_head *bh)
-{
-	put_bh(bh);
-	return 0;
-}
-
-/*
- * Note that we don't need to start a transaction unless we're journaling data
- * because we should have holes filled from ext4_page_mkwrite(). We even don't
- * need to file the inode to the transaction's list in ordered mode because if
- * we are writing back data added by write(), the inode is already there and if
- * we are writing back data modified via mmap(), noone guarantees in which
- * transaction the data will hit the disk. In case we are journaling data, we
- * cannot start transaction directly because transaction start ranks above page
- * lock so we have to do some magic.
- *
- * In all journaling modes block_write_full_page() will start the I/O.
- *
- * Problem:
- *
- *	ext4_writepage() -> kmalloc() -> __alloc_pages() -> page_launder() ->
- *		ext4_writepage()
- *
- * Similar for:
- *
- *	ext4_file_write() -> generic_file_write() -> __alloc_pages() -> ...
- *
- * Same applies to ext4_get_block().  We will deadlock on various things like
- * lock_journal and i_data_sem
- *
- * Setting PF_MEMALLOC here doesn't work - too many internal memory
- * allocations fail.
- *
- * 16May01: If we're reentered then journal_current_handle() will be
- *	    non-zero. We simply *return*.
- *
- * 1 July 2001: @@@ FIXME:
- *   In journalled data mode, a data buffer may be metadata against the
- *   current transaction.  But the same file is part of a shared mapping
- *   and someone does a writepage() on it.
- *
- *   We will move the buffer onto the async_data list, but *after* it has
- *   been dirtied. So there's a small window where we have dirty data on
- *   BJ_Metadata.
- *
- *   Note that this only applies to the last partial page in the file.  The
- *   bit which block_write_full_page() uses prepare/commit for.  (That's
- *   broken code anyway: it's wrong for msync()).
- *
- *   It's a rare case: affects the final partial page, for journalled data
- *   where the file is subject to bith write() and writepage() in the same
- *   transction.  To fix it we'll need a custom block_write_full_page().
- *   We'll probably need that anyway for journalling writepage() output.
- *
- * We don't honour synchronous mounts for writepage().  That would be
- * disastrous.  Any write() or metadata operation will sync the fs for
- * us.
- *
- */
-static int __ext4_normal_writepage(struct page *page,
-				struct writeback_control *wbc)
-{
-	struct inode *inode = page->mapping->host;
-
-	if (test_opt(inode->i_sb, NOBH))
-		return nobh_writepage(page, noalloc_get_block_write, wbc);
-	else
-		return block_write_full_page(page, noalloc_get_block_write,
-					     wbc);
-}
-
-static int ext4_normal_writepage(struct page *page,
-				struct writeback_control *wbc)
-{
-	struct inode *inode = page->mapping->host;
-	loff_t size = i_size_read(inode);
-	loff_t len;
-
-	trace_mark(ext4_normal_writepage,
-		   "dev %s ino %lu page_index %lu",
-		   inode->i_sb->s_id, inode->i_ino, page->index);
-	J_ASSERT(PageLocked(page));
-	if (page->index == size >> PAGE_CACHE_SHIFT)
-		len = size & ~PAGE_CACHE_MASK;
-	else
-		len = PAGE_CACHE_SIZE;
-
-	if (page_has_buffers(page)) {
-		/* if page has buffers it should all be mapped
-		 * and allocated. If there are not buffers attached
-		 * to the page we know the page is dirty but it lost
-		 * buffers. That means that at some moment in time
-		 * after write_begin() / write_end() has been called
-		 * all buffers have been clean and thus they must have been
-		 * written at least once. So they are all mapped and we can
-		 * happily proceed with mapping them and writing the page.
-		 */
-		BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
-					ext4_bh_delay_or_unwritten));
-	}
-
-	if (!ext4_journal_current_handle())
-		return __ext4_normal_writepage(page, wbc);
-
-	redirty_page_for_writepage(wbc, page);
-	unlock_page(page);
-	return 0;
-}
-
-static int __ext4_journalled_writepage(struct page *page,
-				struct writeback_control *wbc)
-{
-	loff_t size;
-	unsigned int len;
-	struct address_space *mapping = page->mapping;
-	struct inode *inode = mapping->host;
-	struct buffer_head *page_bufs;
-	handle_t *handle = NULL;
-	int ret = 0;
-	int err;
-
-	size = i_size_read(inode);
-	if (page->index == size >> PAGE_CACHE_SHIFT)
-		len = size & ~PAGE_CACHE_MASK;
-	else
-		len = PAGE_CACHE_SIZE;
-
-	ret = block_prepare_write(page, 0, len,
-				  noalloc_get_block_write);
-	if (ret != 0)
-		goto out_unlock;
-
-	page_bufs = page_buffers(page);
-	walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
-	/* As soon as we unlock the page, it can go away, but we have
-	 * references to buffers so we are safe */
-	unlock_page(page);
-
-	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		goto out;
-	}
-
-	ret = walk_page_buffers(handle, page_bufs, 0, len,
-				NULL, do_journal_get_write_access);
-
-	err = walk_page_buffers(handle, page_bufs, 0, len,
-				NULL, write_end_fn);
-	if (ret == 0)
-		ret = err;
-	err = ext4_journal_stop(handle);
-	if (!ret)
-		ret = err;
-
-	walk_page_buffers(handle, page_bufs, 0, len,
-				NULL, bput_one);
-	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
-	goto out;
-
-out_unlock:
-	unlock_page(page);
-out:
-	return ret;
-}
-
-static int ext4_journalled_writepage(struct page *page,
-				struct writeback_control *wbc)
-{
-	struct inode *inode = page->mapping->host;
-	loff_t size = i_size_read(inode);
-	loff_t len;
-
-	trace_mark(ext4_journalled_writepage,
-		   "dev %s ino %lu page_index %lu",
-		   inode->i_sb->s_id, inode->i_ino, page->index);
-	J_ASSERT(PageLocked(page));
-	if (page->index == size >> PAGE_CACHE_SHIFT)
-		len = size & ~PAGE_CACHE_MASK;
-	else
-		len = PAGE_CACHE_SIZE;
-
-	if (page_has_buffers(page)) {
-		/* if page has buffers it should all be mapped
-		 * and allocated. If there are not buffers attached
-		 * to the page we know the page is dirty but it lost
-		 * buffers. That means that at some moment in time
-		 * after write_begin() / write_end() has been called
-		 * all buffers have been clean and thus they must have been
-		 * written at least once. So they are all mapped and we can
-		 * happily proceed with mapping them and writing the page.
-		 */
-		BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
-					ext4_bh_delay_or_unwritten));
-	}
-
-	if (ext4_journal_current_handle())
-		goto no_write;
-
-	if (PageChecked(page)) {
-		/*
-		 * It's mmapped pagecache.  Add buffers and journal it.  There
-		 * doesn't seem much point in redirtying the page here.
-		 */
-		ClearPageChecked(page);
-		return __ext4_journalled_writepage(page, wbc);
-	} else {
-		/*
-		 * It may be a page full of checkpoint-mode buffers.  We don't
-		 * really know unless we go poke around in the buffer_heads.
-		 * But block_write_full_page will do the right thing.
-		 */
-		return block_write_full_page(page, noalloc_get_block_write,
-					     wbc);
-	}
-no_write:
-	redirty_page_for_writepage(wbc, page);
-	unlock_page(page);
-	return 0;
-}
-
 static int ext4_readpage(struct file *file, struct page *page)
 {
 	return mpage_readpage(page, ext4_get_block);
@@ -3458,7 +3328,7 @@ static int ext4_journalled_set_page_dirty(struct page *page)
 static const struct address_space_operations ext4_ordered_aops = {
 	.readpage		= ext4_readpage,
 	.readpages		= ext4_readpages,
-	.writepage		= ext4_normal_writepage,
+	.writepage		= ext4_writepage,
 	.sync_page		= block_sync_page,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_ordered_write_end,
@@ -3474,7 +3344,7 @@ static int ext4_journalled_set_page_dirty(struct page *page)
 static const struct address_space_operations ext4_writeback_aops = {
 	.readpage		= ext4_readpage,
 	.readpages		= ext4_readpages,
-	.writepage		= ext4_normal_writepage,
+	.writepage		= ext4_writepage,
 	.sync_page		= block_sync_page,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_writeback_write_end,
@@ -3490,7 +3360,7 @@ static int ext4_journalled_set_page_dirty(struct page *page)
 static const struct address_space_operations ext4_journalled_aops = {
 	.readpage		= ext4_readpage,
 	.readpages		= ext4_readpages,
-	.writepage		= ext4_journalled_writepage,
+	.writepage		= ext4_writepage,
 	.sync_page		= block_sync_page,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_journalled_write_end,
@@ -3505,7 +3375,7 @@ static int ext4_journalled_set_page_dirty(struct page *page)
 static const struct address_space_operations ext4_da_aops = {
 	.readpage		= ext4_readpage,
 	.readpages		= ext4_readpages,
-	.writepage		= ext4_da_writepage,
+	.writepage		= ext4_writepage,
 	.writepages		= ext4_da_writepages,
 	.sync_page		= block_sync_page,
 	.write_begin		= ext4_da_write_begin,
-- 
1.6.3.1.145.gb74d77

