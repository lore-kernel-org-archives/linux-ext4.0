From: akpm@linux-foundation.org
Subject: [patch 038/166] ext3: avoid false EIO errors
Date: Thu, 02 Apr 2009 16:57:17 -0700
Message-ID: <200904022357.n32NvHD4021764@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jack@suse.cz,
	aneesh.kumar@linux.vnet.ibm.com, linux-ext4@vger.kernel.org,
	nickpiggin@yahoo.com.au
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756262AbZDCAAA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Apr 2009 20:00:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Sometimes block_write_begin() can map buffers in a page but later we
fail to copy data into those buffers (because the source page has been
paged out in the mean time).  We then end up with !uptodate mapped
buffers.  To add a bit more to the confusion, block_write_end() does
not commit any data (and thus does not any mark buffers as uptodate) if
we didn't succeed with copying all the data.

Commit f4fc66a894546bdc88a775d0e83ad20a65210bcb (ext3: convert to new
aops) missed these cases and thus we were inserting non-uptodate
buffers to transaction's list which confuses JBD code and it reports IO
errors, aborts a transaction and generally makes users afraid about
their data ;-P.

This patch fixes the problem by reorganizing ext3_..._write_end() code
to first call block_write_end() to mark buffers with valid data
uptodate and after that we file only uptodate buffers to transaction's
lists.

We also fix a problem where we could leave blocks allocated beyond i_size
(i_disksize in fact) because of failed write. We now add inode to orphan
list when write fails (to be safe in case we crash) and then truncate blocks
beyond i_size in a separate transaction.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |  143 ++++++++++++++++++++++++----------------------
 1 file changed, 76 insertions(+), 67 deletions(-)

diff -puN fs/ext3/inode.c~ext3-avoid-false-eio-errors-v4 fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-avoid-false-eio-errors-v4
+++ a/fs/ext3/inode.c
@@ -1149,12 +1149,15 @@ static int ext3_write_begin(struct file 
 				struct page **pagep, void **fsdata)
 {
 	struct inode *inode = mapping->host;
-	int ret, needed_blocks = ext3_writepage_trans_blocks(inode);
+	int ret;
 	handle_t *handle;
 	int retries = 0;
 	struct page *page;
 	pgoff_t index;
 	unsigned from, to;
+	/* Reserve one block more for addition to orphan list in case
+	 * we allocate blocks but write fails for some reason */
+	int needed_blocks = ext3_writepage_trans_blocks(inode) + 1;
 
 	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
@@ -1184,15 +1187,20 @@ retry:
 	}
 write_begin_failed:
 	if (ret) {
-		ext3_journal_stop(handle);
-		unlock_page(page);
-		page_cache_release(page);
 		/*
 		 * block_write_begin may have instantiated a few blocks
 		 * outside i_size.  Trim these off again. Don't need
 		 * i_size_read because we hold i_mutex.
+		 *
+		 * Add inode to orphan list in case we crash before truncate
+		 * finishes.
 		 */
 		if (pos + len > inode->i_size)
+			ext3_orphan_add(handle, inode);
+		ext3_journal_stop(handle);
+		unlock_page(page);
+		page_cache_release(page);
+		if (pos + len > inode->i_size)
 			vmtruncate(inode, inode->i_size);
 	}
 	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
@@ -1211,6 +1219,18 @@ int ext3_journal_dirty_data(handle_t *ha
 	return err;
 }
 
+/* For ordered writepage and write_end functions */
+static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
+{
+	/*
+	 * Write could have mapped the buffer but it didn't copy the data in
+	 * yet. So avoid filing such buffer into a transaction.
+	 */
+	if (buffer_mapped(bh) && buffer_uptodate(bh))
+		return ext3_journal_dirty_data(handle, bh);
+	return 0;
+}
+
 /* For write_end() in data=journal mode */
 static int write_end_fn(handle_t *handle, struct buffer_head *bh)
 {
@@ -1221,26 +1241,20 @@ static int write_end_fn(handle_t *handle
 }
 
 /*
- * Generic write_end handler for ordered and writeback ext3 journal modes.
- * We can't use generic_write_end, because that unlocks the page and we need to
- * unlock the page after ext3_journal_stop, but ext3_journal_stop must run
- * after block_write_end.
- */
-static int ext3_generic_write_end(struct file *file,
-				struct address_space *mapping,
-				loff_t pos, unsigned len, unsigned copied,
-				struct page *page, void *fsdata)
-{
-	struct inode *inode = file->f_mapping->host;
-
-	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
-
-	if (pos+copied > inode->i_size) {
-		i_size_write(inode, pos+copied);
+ * This is nasty and subtle: ext3_write_begin() could have allocated blocks
+ * for the whole page but later we failed to copy the data in. Update inode
+ * size according to what we managed to copy. The rest is going to be
+ * truncated in write_end function.
+ */
+static void update_file_sizes(struct inode *inode, loff_t pos, unsigned copied)
+{
+	/* What matters to us is i_disksize. We don't write i_size anywhere */
+	if (pos + copied > inode->i_size)
+		i_size_write(inode, pos + copied);
+	if (pos + copied > EXT3_I(inode)->i_disksize) {
+		EXT3_I(inode)->i_disksize = pos + copied;
 		mark_inode_dirty(inode);
 	}
-
-	return copied;
 }
 
 /*
@@ -1260,35 +1274,29 @@ static int ext3_ordered_write_end(struct
 	unsigned from, to;
 	int ret = 0, ret2;
 
-	from = pos & (PAGE_CACHE_SIZE - 1);
-	to = from + len;
+	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
 
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + copied;
 	ret = walk_page_buffers(handle, page_buffers(page),
-		from, to, NULL, ext3_journal_dirty_data);
-
-	if (ret == 0) {
-		/*
-		 * generic_write_end() will run mark_inode_dirty() if i_size
-		 * changes.  So let's piggyback the i_disksize mark_inode_dirty
-		 * into that.
-		 */
-		loff_t new_i_size;
+		from, to, NULL, journal_dirty_data_fn);
 
-		new_i_size = pos + copied;
-		if (new_i_size > EXT3_I(inode)->i_disksize)
-			EXT3_I(inode)->i_disksize = new_i_size;
-		ret2 = ext3_generic_write_end(file, mapping, pos, len, copied,
-							page, fsdata);
-		copied = ret2;
-		if (ret2 < 0)
-			ret = ret2;
-	}
+	if (ret == 0)
+		update_file_sizes(inode, pos, copied);
+	/*
+	 * There may be allocated blocks outside of i_size because
+	 * we failed to copy some data. Prepare for truncate.
+	 */
+	if (pos + len > inode->i_size)
+		ext3_orphan_add(handle, inode);
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
 	unlock_page(page);
 	page_cache_release(page);
 
+	if (pos + len > inode->i_size)
+		vmtruncate(inode, inode->i_size);
 	return ret ? ret : copied;
 }
 
@@ -1299,25 +1307,22 @@ static int ext3_writeback_write_end(stru
 {
 	handle_t *handle = ext3_journal_current_handle();
 	struct inode *inode = file->f_mapping->host;
-	int ret = 0, ret2;
-	loff_t new_i_size;
-
-	new_i_size = pos + copied;
-	if (new_i_size > EXT3_I(inode)->i_disksize)
-		EXT3_I(inode)->i_disksize = new_i_size;
-
-	ret2 = ext3_generic_write_end(file, mapping, pos, len, copied,
-							page, fsdata);
-	copied = ret2;
-	if (ret2 < 0)
-		ret = ret2;
+	int ret;
 
-	ret2 = ext3_journal_stop(handle);
-	if (!ret)
-		ret = ret2;
+	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
+	update_file_sizes(inode, pos, copied);
+	/*
+	 * There may be allocated blocks outside of i_size because
+	 * we failed to copy some data. Prepare for truncate.
+	 */
+	if (pos + len > inode->i_size)
+		ext3_orphan_add(handle, inode);
+	ret = ext3_journal_stop(handle);
 	unlock_page(page);
 	page_cache_release(page);
 
+	if (pos + len > inode->i_size)
+		vmtruncate(inode, inode->i_size);
 	return ret ? ret : copied;
 }
 
@@ -1338,15 +1343,23 @@ static int ext3_journalled_write_end(str
 	if (copied < len) {
 		if (!PageUptodate(page))
 			copied = 0;
-		page_zero_new_buffers(page, from+copied, to);
+		page_zero_new_buffers(page, from + copied, to);
+		to = from + copied;
 	}
 
 	ret = walk_page_buffers(handle, page_buffers(page), from,
 				to, &partial, write_end_fn);
 	if (!partial)
 		SetPageUptodate(page);
-	if (pos+copied > inode->i_size)
-		i_size_write(inode, pos+copied);
+
+	if (pos + copied > inode->i_size)
+		i_size_write(inode, pos + copied);
+	/*
+	 * There may be allocated blocks outside of i_size because
+	 * we failed to copy some data. Prepare for truncate.
+	 */
+	if (pos + len > inode->i_size)
+		ext3_orphan_add(handle, inode);
 	EXT3_I(inode)->i_state |= EXT3_STATE_JDATA;
 	if (inode->i_size > EXT3_I(inode)->i_disksize) {
 		EXT3_I(inode)->i_disksize = inode->i_size;
@@ -1361,6 +1374,8 @@ static int ext3_journalled_write_end(str
 	unlock_page(page);
 	page_cache_release(page);
 
+	if (pos + len > inode->i_size)
+		vmtruncate(inode, inode->i_size);
 	return ret ? ret : copied;
 }
 
@@ -1428,17 +1443,11 @@ static int bput_one(handle_t *handle, st
 	return 0;
 }
 
-static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
-{
-	if (buffer_mapped(bh))
-		return ext3_journal_dirty_data(handle, bh);
-	return 0;
-}
