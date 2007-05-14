From: npiggin@suse.de
Subject: [patch 18/41] ext3 convert to new aops.
Date: Mon, 14 May 2007 16:06:37 +1000
Message-ID: <20070514060652.729084000@wotan.suse.de>
References: <20070514060619.689648000@wotan.suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Badari Pulavarty <pbadari@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761514AbXENIX4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 May 2007 04:23:56 -0400
Content-Disposition: inline; filename=fs-ext3-aops.patch
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Cc: linux-ext4@vger.kernel.org
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>
Signed-off-by: Nick Piggin <npiggin@suse.de>


Various fixes and improvements

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>

 fs/ext3/inode.c |  136 ++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 88 insertions(+), 48 deletions(-)

Index: linux-2.6/fs/ext3/inode.c
===================================================================
--- linux-2.6.orig/fs/ext3/inode.c
+++ linux-2.6/fs/ext3/inode.c
@@ -1147,51 +1147,68 @@ static int do_journal_get_write_access(h
 	return ext3_journal_get_write_access(handle, bh);
 }
 
-static int ext3_prepare_write(struct file *file, struct page *page,
-			      unsigned from, unsigned to)
+static int ext3_write_begin(struct file *file, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned flags,
+				struct page **pagep, void **fsdata)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = mapping->host;
 	int ret, needed_blocks = ext3_writepage_trans_blocks(inode);
 	handle_t *handle;
 	int retries = 0;
+	struct page *page;
+	pgoff_t index;
+	unsigned from, to;
+
+	index = pos >> PAGE_CACHE_SHIFT;
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + len;
 
 retry:
+	page = __grab_cache_page(mapping, index);
+	if (!page)
+		return -ENOMEM;
+	*pagep = page;
+
 	handle = ext3_journal_start(inode, needed_blocks);
 	if (IS_ERR(handle)) {
+		unlock_page(page);
+		page_cache_release(page);
 		ret = PTR_ERR(handle);
 		goto out;
 	}
-	if (test_opt(inode->i_sb, NOBH) && ext3_should_writeback_data(inode))
-		ret = nobh_prepare_write(page, from, to, ext3_get_block);
-	else
-		ret = block_prepare_write(page, from, to, ext3_get_block);
+	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+							ext3_get_block);
 	if (ret)
-		goto prepare_write_failed;
+		goto write_begin_failed;
 
 	if (ext3_should_journal_data(inode)) {
 		ret = walk_page_buffers(handle, page_buffers(page),
 				from, to, NULL, do_journal_get_write_access);
 	}
-prepare_write_failed:
-	if (ret)
+write_begin_failed:
+	if (ret) {
 		ext3_journal_stop(handle);
+		unlock_page(page);
+		page_cache_release(page);
+	}
 	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 out:
 	return ret;
 }
 
+
 int ext3_journal_dirty_data(handle_t *handle, struct buffer_head *bh)
 {
 	int err = journal_dirty_data(handle, bh);
 	if (err)
 		ext3_journal_abort_handle(__FUNCTION__, __FUNCTION__,
-						bh, handle,err);
+						bh, handle, err);
 	return err;
 }
 
-/* For commit_write() in data=journal mode */
-static int commit_write_fn(handle_t *handle, struct buffer_head *bh)
+/* For write_end() in data=journal mode */
+static int write_end_fn(handle_t *handle, struct buffer_head *bh)
 {
 	if (!buffer_mapped(bh) || buffer_freed(bh))
 		return 0;
@@ -1206,78 +1223,100 @@ static int commit_write_fn(handle_t *han
  * ext3 never places buffers on inode->i_mapping->private_list.  metadata
  * buffers are managed internally.
  */
-static int ext3_ordered_commit_write(struct file *file, struct page *page,
-			     unsigned from, unsigned to)
+static int ext3_ordered_write_end(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = file->f_mapping->host;
+	unsigned from, to;
 	int ret = 0, ret2;
 
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + len;
+
 	ret = walk_page_buffers(handle, page_buffers(page),
 		from, to, NULL, ext3_journal_dirty_data);
 
 	if (ret == 0) {
 		/*
-		 * generic_commit_write() will run mark_inode_dirty() if i_size
+		 * generic_write_end() will run mark_inode_dirty() if i_size
 		 * changes.  So let's piggyback the i_disksize mark_inode_dirty
 		 * into that.
 		 */
 		loff_t new_i_size;
 
-		new_i_size = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+		new_i_size = pos + copied;
 		if (new_i_size > EXT3_I(inode)->i_disksize)
 			EXT3_I(inode)->i_disksize = new_i_size;
-		ret = generic_commit_write(file, page, from, to);
+		copied = generic_write_end(file, mapping, pos, len, copied,
+							page, fsdata);
+		if (copied < 0)
+			ret = copied;
+	} else {
+		unlock_page(page);
+		page_cache_release(page);
 	}
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	return ret;
+	return ret ? ret : copied;
 }
 
-static int ext3_writeback_commit_write(struct file *file, struct page *page,
-			     unsigned from, unsigned to)
+static int ext3_writeback_write_end(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = file->f_mapping->host;
 	int ret = 0, ret2;
 	loff_t new_i_size;
 
-	new_i_size = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	new_i_size = pos + copied;
 	if (new_i_size > EXT3_I(inode)->i_disksize)
 		EXT3_I(inode)->i_disksize = new_i_size;
 
-	if (test_opt(inode->i_sb, NOBH) && ext3_should_writeback_data(inode))
-		ret = nobh_commit_write(file, page, from, to);
-	else
-		ret = generic_commit_write(file, page, from, to);
+	copied = generic_write_end(file, mapping, pos, len, copied,
+							page, fsdata);
+	if (copied < 0)
+		ret = copied;
 
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	return ret;
+	return ret ? ret : copied;
 }
 
-static int ext3_journalled_commit_write(struct file *file,
-			struct page *page, unsigned from, unsigned to)
+static int ext3_journalled_write_end(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = mapping->host;
 	int ret = 0, ret2;
 	int partial = 0;
-	loff_t pos;
+	unsigned from, to;
 
-	/*
-	 * Here we duplicate the generic_commit_write() functionality
-	 */
-	pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + len;
+
+	if (copied < len) {
+		if (!PageUptodate(page))
+			copied = 0;
+		page_zero_new_buffers(page, from+copied, to);
+	}
 
 	ret = walk_page_buffers(handle, page_buffers(page), from,
-				to, &partial, commit_write_fn);
+				to, &partial, write_end_fn);
 	if (!partial)
 		SetPageUptodate(page);
-	if (pos > inode->i_size)
-		i_size_write(inode, pos);
+	unlock_page(page);
+	page_cache_release(page);
+	if (pos+copied > inode->i_size)
+		i_size_write(inode, pos+copied);
 	EXT3_I(inode)->i_state |= EXT3_STATE_JDATA;
 	if (inode->i_size > EXT3_I(inode)->i_disksize) {
 		EXT3_I(inode)->i_disksize = inode->i_size;
@@ -1285,10 +1324,11 @@ static int ext3_journalled_commit_write(
 		if (!ret)
 			ret = ret2;
 	}
+
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	return ret;
+	return ret ? ret : copied;
 }
 
 /*
@@ -1546,7 +1586,7 @@ static int ext3_journalled_writepage(str
 			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
 
 		err = walk_page_buffers(handle, page_buffers(page), 0,
-				PAGE_CACHE_SIZE, NULL, commit_write_fn);
+				PAGE_CACHE_SIZE, NULL, write_end_fn);
 		if (ret == 0)
 			ret = err;
 		EXT3_I(inode)->i_state |= EXT3_STATE_JDATA;
@@ -1706,8 +1746,8 @@ static const struct address_space_operat
 	.readpages	= ext3_readpages,
 	.writepage	= ext3_ordered_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= ext3_prepare_write,
-	.commit_write	= ext3_ordered_commit_write,
+	.write_begin	= ext3_write_begin,
+	.write_end	= ext3_ordered_write_end,
 	.bmap		= ext3_bmap,
 	.invalidatepage	= ext3_invalidatepage,
 	.releasepage	= ext3_releasepage,
@@ -1720,8 +1760,8 @@ static const struct address_space_operat
 	.readpages	= ext3_readpages,
 	.writepage	= ext3_writeback_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= ext3_prepare_write,
-	.commit_write	= ext3_writeback_commit_write,
+	.write_begin	= ext3_write_begin,
+	.write_end	= ext3_writeback_write_end,
 	.bmap		= ext3_bmap,
 	.invalidatepage	= ext3_invalidatepage,
 	.releasepage	= ext3_releasepage,
@@ -1734,8 +1774,8 @@ static const struct address_space_operat
 	.readpages	= ext3_readpages,
 	.writepage	= ext3_journalled_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= ext3_prepare_write,
-	.commit_write	= ext3_journalled_commit_write,
+	.write_begin	= ext3_write_begin,
+	.write_end	= ext3_journalled_write_end,
 	.set_page_dirty	= ext3_journalled_set_page_dirty,
 	.bmap		= ext3_bmap,
 	.invalidatepage	= ext3_invalidatepage,

-- 
