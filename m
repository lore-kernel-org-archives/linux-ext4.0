From: Jan Kara <jack@suse.cz>
Subject: Ordered mode rewrite patch
Date: Tue, 8 Apr 2008 14:11:49 +0200
Message-ID: <20080408121149.GB6901@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qlTNgmc+xy1dBmNv"
Cc: linux-ext4@vger.kernel.org
To: Nathan Grennan <jack@cygnusx-1.org>,
	Marcelo Tosatti <mtosatti@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:56714 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751363AbYDHMLw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Apr 2008 08:11:52 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

  attached is a jumbo patch that reverses locking order of transaction
start and page lock in ext3 and rewrites handling of ordered data mode in
JBD and ext3. Note that the patch will break compilation of ext4 and OCFS2.
The patch survives LTP run on my test machine so it shouldn't eat your data
immediately but bugs are of course possible...
  I'm very interested in any results (both positive and negative) you could
get with it :). Thanks for testing it.

									Honza

PS: CCing also linux-ext4 list in case there are some other interested
testers. Next on my todo list is to port this for ext4...
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--qlTNgmc+xy1dBmNv
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="ext3+jbd-2.6.25-ordered_mode.diff"

diff --git a/fs/buffer.c b/fs/buffer.c
index 39ff144..90e38a6 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1688,7 +1688,8 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 			 */
 			clear_buffer_dirty(bh);
 			set_buffer_uptodate(bh);
-		} else if (!buffer_mapped(bh) && buffer_dirty(bh)) {
+		} else if (!buffer_mapped(bh) && buffer_dirty(bh)
+			   && !wbc->skip_unmapped) {
 			WARN_ON(bh->b_size != blocksize);
 			err = get_block(inode, block, bh, 1);
 			if (err)
diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index acc4913..29fbdb6 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -106,6 +106,23 @@ force_commit:
 	return ret;
 }
 
+static struct vm_operations_struct ext3_file_vm_ops = {
+	.fault		= filemap_fault,
+	.page_mkwrite	= ext3_page_mkwrite,
+};
+
+static int ext3_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct address_space *mapping = file->f_mapping;
+
+	if (!mapping->a_ops->readpage)
+		return -ENOEXEC;
+	file_accessed(file);
+	vma->vm_ops = &ext3_file_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
+	return 0;
+}
+
 const struct file_operations ext3_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
@@ -116,7 +133,7 @@ const struct file_operations ext3_file_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
-	.mmap		= generic_file_mmap,
+	.mmap		= ext3_file_mmap,
 	.open		= generic_file_open,
 	.release	= ext3_release_file,
 	.fsync		= ext3_sync_file,
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 4f4020c..8530e5d 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -588,6 +588,7 @@ got:
 	ei->i_extra_isize =
 		(EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) ?
 		sizeof(struct ext3_inode) - EXT3_GOOD_OLD_INODE_SIZE : 0;
+	journal_init_jbd_inode(&ei->jinode, inode);
 
 	ret = inode;
 	if(DQUOT_ALLOC_INODE(inode)) {
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index eb95670..6f2f123 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -40,6 +40,7 @@
 #include "acl.h"
 
 static int ext3_writepage_trans_blocks(struct inode *inode);
+static int ext3_begin_ordered_truncate(struct inode *inode, loff_t new_size);
 
 /*
  * Test whether an inode is a fast symlink.
@@ -183,6 +184,8 @@ void ext3_delete_inode (struct inode * inode)
 {
 	handle_t *handle;
 
+	if (ext3_should_order_data(inode))
+		ext3_begin_ordered_truncate(inode, 0);
 	truncate_inode_pages(&inode->i_data, 0);
 
 	if (is_bad_inode(inode))
@@ -1126,6 +1129,10 @@ static int walk_page_buffers(	handle_t *handle,
  * will _not_ run commit under these circumstances because handle->h_ref
  * is elevated.  We'll still have enough credits for the tiny quotafile
  * write.
+ *
+ * Note that ext3_page_mkwrite can run write_begin / write_end without
+ * holding i_mutex (but holding non-exclusive i_alloc_sem to protect
+ * against truncates).
  */
 static int do_journal_get_write_access(handle_t *handle,
 					struct buffer_head *bh)
@@ -1152,18 +1159,19 @@ static int ext3_write_begin(struct file *file, struct address_space *mapping,
 	to = from + len;
 
 retry:
-	page = __grab_cache_page(mapping, index);
-	if (!page)
-		return -ENOMEM;
-	*pagep = page;
-
 	handle = ext3_journal_start(inode, needed_blocks);
 	if (IS_ERR(handle)) {
-		unlock_page(page);
-		page_cache_release(page);
 		ret = PTR_ERR(handle);
 		goto out;
 	}
+	page = __grab_cache_page(mapping, index);
+	if (!page) {
+		ext3_journal_stop(handle);
+		ret = -ENOMEM;
+		goto out;
+	}
+	*pagep = page;
+
 	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
 							ext3_get_block);
 	if (ret)
@@ -1175,8 +1183,8 @@ retry:
 	}
 write_begin_failed:
 	if (ret) {
-		ext3_journal_stop(handle);
 		unlock_page(page);
+		ext3_journal_stop(handle);
 		page_cache_release(page);
 	}
 	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
@@ -1185,16 +1193,6 @@ out:
 	return ret;
 }
 
-
-int ext3_journal_dirty_data(handle_t *handle, struct buffer_head *bh)
-{
-	int err = journal_dirty_data(handle, bh);
-	if (err)
-		ext3_journal_abort_handle(__FUNCTION__, __FUNCTION__,
-						bh, handle, err);
-	return err;
-}
-
 /* For write_end() in data=journal mode */
 static int write_end_fn(handle_t *handle, struct buffer_head *bh)
 {
@@ -1205,29 +1203,6 @@ static int write_end_fn(handle_t *handle, struct buffer_head *bh)
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
-		mark_inode_dirty(inode);
-	}
-
-	return copied;
-}
-
-/*
  * We need to pick up the new inode size which generic_commit_write gave us
  * `file' can be NULL - eg, when called from page_symlink().
  *
@@ -1240,15 +1215,15 @@ static int ext3_ordered_write_end(struct file *file,
 				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = mapping->host;
 	unsigned from, to;
 	int ret = 0, ret2;
 
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
 
-	ret = walk_page_buffers(handle, page_buffers(page),
-		from, to, NULL, ext3_journal_dirty_data);
+	if (ext3_should_order_data(inode))
+		ret = ext3_jbd_file_inode(handle, inode);
 
 	if (ret == 0) {
 		/*
@@ -1261,7 +1236,7 @@ static int ext3_ordered_write_end(struct file *file,
 		new_i_size = pos + copied;
 		if (new_i_size > EXT3_I(inode)->i_disksize)
 			EXT3_I(inode)->i_disksize = new_i_size;
-		copied = ext3_generic_write_end(file, mapping, pos, len, copied,
+		copied = generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 		if (copied < 0)
 			ret = copied;
@@ -1269,8 +1244,6 @@ static int ext3_ordered_write_end(struct file *file,
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	unlock_page(page);
-	page_cache_release(page);
 
 	return ret ? ret : copied;
 }
@@ -1281,7 +1254,7 @@ static int ext3_writeback_write_end(struct file *file,
 				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = mapping->host;
 	int ret = 0, ret2;
 	loff_t new_i_size;
 
@@ -1289,7 +1262,7 @@ static int ext3_writeback_write_end(struct file *file,
 	if (new_i_size > EXT3_I(inode)->i_disksize)
 		EXT3_I(inode)->i_disksize = new_i_size;
 
-	copied = ext3_generic_write_end(file, mapping, pos, len, copied,
+	copied = generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 	if (copied < 0)
 		ret = copied;
@@ -1297,8 +1270,6 @@ static int ext3_writeback_write_end(struct file *file,
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	unlock_page(page);
-	page_cache_release(page);
 
 	return ret ? ret : copied;
 }
@@ -1337,10 +1308,10 @@ static int ext3_journalled_write_end(struct file *file,
 			ret = ret2;
 	}
 
+	unlock_page(page);
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	unlock_page(page);
 	page_cache_release(page);
 
 	return ret ? ret : copied;
@@ -1410,19 +1381,11 @@ static int bput_one(handle_t *handle, struct buffer_head *bh)
 	return 0;
 }
 
-static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
-{
-	if (buffer_mapped(bh))
-		return ext3_journal_dirty_data(handle, bh);
-	return 0;
-}
-
 /*
- * Note that we always start a transaction even if we're not journalling
- * data.  This is to preserve ordering: any hole instantiation within
- * __block_write_full_page -> ext3_get_block() should be journalled
- * along with the data so we don't crash and then get metadata which
- * refers to old data.
+ * Note that we don't need to start a transaction unless we're journaling
+ * data because we should have holes filled from ext3_page_mkwrite(). If
+ * we are journaling data, we cannot start transaction directly because
+ * transaction start ranks above page lock so we have to do some magic...
  *
  * In all journalling modes block_write_full_page() will start the I/O.
  *
@@ -1466,165 +1429,154 @@ static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
  * disastrous.  Any write() or metadata operation will sync the fs for
  * us.
  *
- * AKPM2: if all the page's buffers are mapped to disk and !data=journal,
- * we don't need to open a transaction here.
  */
-static int ext3_ordered_writepage(struct page *page,
+static int __ext3_ordered_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
-	struct buffer_head *page_bufs;
 	handle_t *handle = NULL;
-	int ret = 0;
+	int ret;
 	int err;
 
+	ret = block_write_full_page(page, ext3_get_block, wbc);
+
+	/*
+	 * The page can become unlocked at any point now, and truncate can then
+	 * come in and change things.
+	 *
+	 * Attach inode to the current transaction.  But only if
+	 * block_write_full_page() succeeded and we aren't called from
+	 * transaction commit code.
+	 */
+	if (ret == 0 && !wbc->skip_unmapped) {
+		handle = ext3_journal_start(inode, 1);
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			goto out;
+		}
+		ret = ext3_jbd_file_inode(handle, inode);
+		err = ext3_journal_stop(handle);
+		if (!ret)
+			ret = err;
+	}
+out:
+	return ret;
+}
+
+static int ext3_ordered_writepage(struct page *page,
+				struct writeback_control *wbc)
+{
 	J_ASSERT(PageLocked(page));
 
 	/*
 	 * We give up here if we're reentered, because it might be for a
 	 * different filesystem.
 	 */
-	if (ext3_journal_current_handle())
-		goto out_fail;
-
-	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
+	if (!ext3_journal_current_handle())
+		return __ext3_ordered_writepage(page, wbc);
 
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		goto out_fail;
-	}
+	redirty_page_for_writepage(wbc, page);
+	unlock_page(page);
+	return 0;
+}
 
-	if (!page_has_buffers(page)) {
-		create_empty_buffers(page, inode->i_sb->s_blocksize,
-				(1 << BH_Dirty)|(1 << BH_Uptodate));
-	}
-	page_bufs = page_buffers(page);
-	walk_page_buffers(handle, page_bufs, 0,
-			PAGE_CACHE_SIZE, NULL, bget_one);
+static int __ext3_writeback_writepage(struct page *page,
+				struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
 
-	ret = block_write_full_page(page, ext3_get_block, wbc);
+	if (test_opt(inode->i_sb, NOBH))
+		return nobh_writepage(page, ext3_get_block, wbc);
+	else
+		return block_write_full_page(page, ext3_get_block, wbc);
+}
 
-	/*
-	 * The page can become unlocked at any point now, and
-	 * truncate can then come in and change things.  So we
-	 * can't touch *page from now on.  But *page_bufs is
-	 * safe due to elevated refcount.
-	 */
 
-	/*
-	 * And attach them to the current transaction.  But only if
-	 * block_write_full_page() succeeded.  Otherwise they are unmapped,
-	 * and generally junk.
-	 */
-	if (ret == 0) {
-		err = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
-					NULL, journal_dirty_data_fn);
-		if (!ret)
-			ret = err;
-	}
-	walk_page_buffers(handle, page_bufs, 0,
-			PAGE_CACHE_SIZE, NULL, bput_one);
-	err = ext3_journal_stop(handle);
-	if (!ret)
-		ret = err;
-	return ret;
+static int ext3_writeback_writepage(struct page *page,
+				struct writeback_control *wbc)
+{
+	if (!ext3_journal_current_handle())
+		return __ext3_writeback_writepage(page, wbc);
 
-out_fail:
 	redirty_page_for_writepage(wbc, page);
 	unlock_page(page);
-	return ret;
+	return 0;
 }
 
-static int ext3_writeback_writepage(struct page *page,
+static int __ext3_journalled_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
-	struct inode *inode = page->mapping->host;
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
+	struct buffer_head *page_bufs;
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
 
-	if (ext3_journal_current_handle())
-		goto out_fail;
+	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE, ext3_get_block);
+	if (ret != 0)
+		goto out_unlock;
+
+	page_bufs = page_buffers(page);
+	walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE, NULL,
+								bget_one);
+	/* As soon as we unlock the page, it can go away, but we have
+	 * references to buffers so we are safe */
+	unlock_page(page);
 
 	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
-		goto out_fail;
+		goto out;
 	}
 
-	if (test_opt(inode->i_sb, NOBH) && ext3_should_writeback_data(inode))
-		ret = nobh_writepage(page, ext3_get_block, wbc);
-	else
-		ret = block_write_full_page(page, ext3_get_block, wbc);
+	ret = walk_page_buffers(handle, page_bufs, 0,
+			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
 
+	err = walk_page_buffers(handle, page_bufs, 0,
+				PAGE_CACHE_SIZE, NULL, write_end_fn);
+	if (ret == 0)
+		ret = err;
 	err = ext3_journal_stop(handle);
 	if (!ret)
 		ret = err;
-	return ret;
 
-out_fail:
-	redirty_page_for_writepage(wbc, page);
+	walk_page_buffers(handle, page_bufs, 0,
+				PAGE_CACHE_SIZE, NULL, bput_one);
+	EXT3_I(inode)->i_state |= EXT3_STATE_JDATA;
+	goto out;
+
+out_unlock:
 	unlock_page(page);
+out:
 	return ret;
 }
 
 static int ext3_journalled_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
-	struct inode *inode = page->mapping->host;
-	handle_t *handle = NULL;
-	int ret = 0;
-	int err;
-
 	if (ext3_journal_current_handle())
 		goto no_write;
 
-	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		goto no_write;
-	}
-
 	if (!page_has_buffers(page) || PageChecked(page)) {
 		/*
 		 * It's mmapped pagecache.  Add buffers and journal it.  There
 		 * doesn't seem much point in redirtying the page here.
 		 */
 		ClearPageChecked(page);
-		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
-					ext3_get_block);
-		if (ret != 0) {
-			ext3_journal_stop(handle);
-			goto out_unlock;
-		}
-		ret = walk_page_buffers(handle, page_buffers(page), 0,
-			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
-
-		err = walk_page_buffers(handle, page_buffers(page), 0,
-				PAGE_CACHE_SIZE, NULL, write_end_fn);
-		if (ret == 0)
-			ret = err;
-		EXT3_I(inode)->i_state |= EXT3_STATE_JDATA;
-		unlock_page(page);
+		return __ext3_journalled_writepage(page, wbc);
 	} else {
 		/*
 		 * It may be a page full of checkpoint-mode buffers.  We don't
 		 * really know unless we go poke around in the buffer_heads.
 		 * But block_write_full_page will do the right thing.
 		 */
-		ret = block_write_full_page(page, ext3_get_block, wbc);
+		return block_write_full_page(page, ext3_get_block, wbc);
 	}
-	err = ext3_journal_stop(handle);
-	if (!ret)
-		ret = err;
-out:
-	return ret;
-
 no_write:
 	redirty_page_for_writepage(wbc, page);
-out_unlock:
 	unlock_page(page);
-	goto out;
+	return 0;
 }
 
 static int ext3_readpage(struct file *file, struct page *page)
@@ -1821,7 +1773,7 @@ void ext3_set_aops(struct inode *inode)
  * This required during truncate. We need to physically zero the tail end
  * of that block so it doesn't yield old data if the file is later grown.
  */
-static int ext3_block_truncate_page(handle_t *handle, struct page *page,
+static int ext3_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from)
 {
 	ext3_fsblk_t index = from >> PAGE_CACHE_SHIFT;
@@ -1829,8 +1781,13 @@ static int ext3_block_truncate_page(handle_t *handle, struct page *page,
 	unsigned blocksize, iblock, length, pos;
 	struct inode *inode = mapping->host;
 	struct buffer_head *bh;
+	struct page *page;
 	int err = 0;
 
+	page = grab_cache_page(mapping, from >> PAGE_CACHE_SHIFT);
+	if (!page)
+		return -EINVAL;
+
 	blocksize = inode->i_sb->s_blocksize;
 	length = blocksize - (offset & (blocksize - 1));
 	iblock = index << (PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits);
@@ -1902,7 +1859,7 @@ static int ext3_block_truncate_page(handle_t *handle, struct page *page,
 		err = ext3_journal_dirty_metadata(handle, bh);
 	} else {
 		if (ext3_should_order_data(inode))
-			err = ext3_journal_dirty_data(handle, bh);
+			err = ext3_jbd_file_inode(handle, inode);
 		mark_buffer_dirty(bh);
 	}
 
@@ -2293,7 +2250,6 @@ void ext3_truncate(struct inode *inode)
 	int n;
 	long last_block;
 	unsigned blocksize = inode->i_sb->s_blocksize;
-	struct page *page;
 
 	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
 	    S_ISLNK(inode->i_mode)))
@@ -2303,36 +2259,16 @@ void ext3_truncate(struct inode *inode)
 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
 		return;
 
-	/*
-	 * We have to lock the EOF page here, because lock_page() nests
-	 * outside journal_start().
-	 */
-	if ((inode->i_size & (blocksize - 1)) == 0) {
-		/* Block boundary? Nothing to do */
-		page = NULL;
-	} else {
-		page = grab_cache_page(mapping,
-				inode->i_size >> PAGE_CACHE_SHIFT);
-		if (!page)
-			return;
-	}
-
 	handle = start_transaction(inode);
-	if (IS_ERR(handle)) {
-		if (page) {
-			clear_highpage(page);
-			flush_dcache_page(page);
-			unlock_page(page);
-			page_cache_release(page);
-		}
+	if (IS_ERR(handle))
 		return;		/* AKPM: return what? */
-	}
 
 	last_block = (inode->i_size + blocksize-1)
 					>> EXT3_BLOCK_SIZE_BITS(inode->i_sb);
 
-	if (page)
-		ext3_block_truncate_page(handle, page, mapping, inode->i_size);
+	if (inode->i_size & (blocksize - 1))
+		if (ext3_block_truncate_page(handle, mapping, inode->i_size))
+			goto out_stop;
 
 	n = ext3_block_to_path(inode, last_block, offsets, NULL);
 	if (n == 0)
@@ -2676,6 +2612,7 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 	ei->i_default_acl = EXT3_ACL_NOT_CACHED;
 #endif
 	ei->i_block_alloc_info = NULL;
+	journal_init_jbd_inode(&ei->jinode, inode);
 
 	ret = __ext3_get_inode_loc(inode, &iloc, 0);
 	if (ret < 0)
@@ -2974,6 +2911,11 @@ int ext3_write_inode(struct inode *inode, int wait)
 	return ext3_force_commit(inode->i_sb);
 }
 
+static int ext3_begin_ordered_truncate(struct inode *inode, loff_t new_size)
+{
+	return journal_begin_ordered_truncate(&EXT3_I(inode)->jinode, new_size);
+}
+
 /*
  * ext3_setattr()
  *
@@ -2989,7 +2931,14 @@ int ext3_write_inode(struct inode *inode, int wait)
  * be freed, so we have a strong guarantee that no future commit will
  * leave these blocks visible to the user.)
  *
- * Called with inode->sem down.
+ * Another thing we have to asure is that if we are in ordered mode
+ * and inode is still attached to the committing transaction, we must
+ * we start writeout of all the dirty buffers which are being truncated.
+ * This way we are sure that all the data written in the previous
+ * transaction are already on disk (truncate waits for pages under
+ * writeback).
+ *
+ * Called with inode->i_mutex down.
  */
 int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 {
@@ -3032,6 +2981,13 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 	    attr->ia_valid & ATTR_SIZE && attr->ia_size < inode->i_size) {
 		handle_t *handle;
 
+		if (ext3_should_order_data(inode)) {
+			error = ext3_begin_ordered_truncate(inode,
+					attr->ia_size);
+			if (error)
+				goto err_out;
+		}
+
 		handle = ext3_journal_start(inode, 3);
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
@@ -3306,3 +3262,77 @@ int ext3_change_inode_journal_flag(struct inode *inode, int val)
 
 	return err;
 }
+
+static int ext3_bh_mapped(handle_t *handle, struct buffer_head *bh)
+{
+	return !buffer_mapped(bh);
+}
+
+int ext3_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	struct file *file = vma->vm_file;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct address_space *mapping = inode->i_mapping;
+	unsigned long len;
+	loff_t size;
+	int ret = -EINVAL, err;
+	handle_t *handle;
+	struct writeback_control wbc = { .sync_mode = WB_SYNC_NONE,
+					 .nr_to_write = 1 };
+
+	/*
+	 * Get i_alloc_sem to stop truncates messing with the inode. We cannot
+	 * get i_mutex because we are already holding mmap_sem. We could
+	 * as well just lock the page but we need to start a transaction
+	 * before locking the page and don't want to unnecessarity start
+	 * the transaction if we don't need to write the page.
+	 */
+	down_read(&inode->i_alloc_sem);
+	size = i_size_read(inode);
+	if (page->mapping != mapping || size <= page_offset(page)
+	    || !PageUptodate(page)) {
+		/* page got truncated from under us? */
+		goto out_unlock;
+	}
+	ret = 0;
+	if (PageMappedToDisk(page))
+		goto out_unlock;
+
+	if (page->index == size >> PAGE_CACHE_SHIFT)
+		len = size & ~PAGE_CACHE_MASK;
+	else
+		len = PAGE_CACHE_SIZE;
+
+	if (page_has_buffers(page)) {
+		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
+				       ext3_bh_mapped))
+			goto out_unlock;
+	}
+
+	/*
+	 * OK, we need to fill the hole... Start a transaction, lock the
+	 * page and do writepage
+	 */
+	
+	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out_unlock;
+	}
+	lock_page(page);
+	wbc.range_start = page_offset(page);
+	wbc.range_end = page_offset(page) + PAGE_CACHE_SIZE;
+	if (ext3_should_writeback_data(inode))
+		ret = __ext3_writeback_writepage(page, &wbc);
+	else if (ext3_should_order_data(inode))
+		ret = __ext3_ordered_writepage(page, &wbc);
+	else
+		ret = __ext3_journalled_writepage(page, &wbc);
+	/* Page got unlocked in writepage */
+	err = journal_stop(handle);
+	if (!ret)
+		ret = err;
+out_unlock:
+	up_read(&inode->i_alloc_sem);
+	return ret;
+}
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 77e9702..0a8eb98 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -520,6 +520,8 @@ static void ext3_clear_inode(struct inode *inode)
 	EXT3_I(inode)->i_block_alloc_info = NULL;
 	if (unlikely(rsv))
 		kfree(rsv);
+	journal_release_jbd_inode(EXT3_SB(inode->i_sb)->s_journal,
+		&EXT3_I(inode)->jinode);
 }
 
 static inline void ext3_show_quota_options(struct seq_file *seq, struct super_block *sb)
@@ -2860,7 +2862,7 @@ static ssize_t ext3_quota_write(struct super_block *sb, int type,
 			err = ext3_journal_dirty_metadata(handle, bh);
 		else {
 			/* Always do at least ordered writes for quotas */
-			err = ext3_journal_dirty_data(handle, bh);
+			err = ext3_jbd_file_inode(handle, inode);
 			mark_buffer_dirty(bh);
 		}
 		brelse(bh);
diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index a5432bb..9ef048a 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -682,7 +682,6 @@ void __journal_drop_transaction(journal_t *journal, transaction_t *transaction)
 
 	J_ASSERT(transaction->t_state == T_FINISHED);
 	J_ASSERT(transaction->t_buffers == NULL);
-	J_ASSERT(transaction->t_sync_datalist == NULL);
 	J_ASSERT(transaction->t_forget == NULL);
 	J_ASSERT(transaction->t_iobuf_list == NULL);
 	J_ASSERT(transaction->t_shadow_list == NULL);
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index a38c718..0553df2 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -20,6 +20,8 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
+#include <linux/writeback.h>
+#include <linux/backing-dev.h>
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
@@ -35,8 +37,8 @@ static void journal_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
 }
 
 /*
- * When an ext3-ordered file is truncated, it is possible that many pages are
- * not sucessfully freed, because they are attached to a committing transaction.
+ * When an ext3 file is truncated, it is possible that some pages are not
+ * sucessfully freed, because they are attached to a committing transaction.
  * After the transaction commits, these pages are left on the LRU, with no
  * ->mapping, and with attached buffers.  These pages are trivially reclaimable
  * by the VM, but their apparent absence upsets the VM accounting, and it makes
@@ -77,21 +79,6 @@ nope:
 	__brelse(bh);
 }
 
-/*
- * Try to acquire jbd_lock_bh_state() against the buffer, when j_list_lock is
- * held.  For ranking reasons we must trylock.  If we lose, schedule away and
- * return 0.  j_list_lock is dropped in this case.
- */
-static int inverted_lock(journal_t *journal, struct buffer_head *bh)
-{
-	if (!jbd_trylock_bh_state(bh)) {
-		spin_unlock(&journal->j_list_lock);
-		schedule();
-		return 0;
-	}
-	return 1;
-}
-
 /* Done it all: now write the commit record.  We should have
  * cleaned up our previous buffers by now, so if we are in abort
  * mode we can now just skip the rest of the journal write
@@ -158,119 +145,88 @@ static int journal_write_commit_record(journal_t *journal,
 	return (ret == -EIO);
 }
 
-static void journal_do_submit_data(struct buffer_head **wbuf, int bufs)
+/*
+ * Submit all the data buffers of inode associated with the
+ * transaction to disk.
+ */
+static int journal_submit_data_buffers(journal_t *journal,
+		transaction_t *commit_transaction)
 {
-	int i;
+	struct jbd_inode *jinode;
+	int err, ret = 0;
+	struct address_space *mapping;
+	struct writeback_control wbc = {
+		.range_start = 0,
+		.range_end = LLONG_MAX,
+		.sync_mode = WB_SYNC_NONE,
+		.skip_unmapped = 1,
+	};
 
-	for (i = 0; i < bufs; i++) {
-		wbuf[i]->b_end_io = end_buffer_write_sync;
-		/* We use-up our safety reference in submit_bh() */
-		submit_bh(WRITE, wbuf[i]);
+	/*
+	 * We are in a committing transaction. Therefore no new inode
+	 * can be added to our inode list. We use JI_COMMIT_RUNNING
+	 * flag to protect inode we currently operate on from being
+	 * released while we write out pages.
+	 */
+	spin_lock(&journal->j_list_lock);
+	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
+		mapping = jinode->i_vfs_inode->i_mapping;
+		if (!mapping_cap_writeback_dirty(mapping))
+			continue;
+		wbc.nr_to_write = mapping->nrpages * 2;
+		jinode->i_flags |= JI_COMMIT_RUNNING;
+		spin_unlock(&journal->j_list_lock);
+		err = do_writepages(jinode->i_vfs_inode->i_mapping, &wbc);
+		if (!ret)
+			ret = err;
+		spin_lock(&journal->j_list_lock);
+		jinode->i_flags &= ~JI_COMMIT_RUNNING;
+		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
 	}
+	spin_unlock(&journal->j_list_lock);
+	return ret;
 }
 
 /*
- *  Submit all the data buffers to disk
+ * Wait for data submitted for writeout, refile inodes to proper
+ * transaction if needed.
+ *
  */
-static void journal_submit_data_buffers(journal_t *journal,
-				transaction_t *commit_transaction)
+static int journal_finish_data_buffers(journal_t *journal,
+		transaction_t *commit_transaction)
 {
-	struct journal_head *jh;
-	struct buffer_head *bh;
-	int locked;
-	int bufs = 0;
-	struct buffer_head **wbuf = journal->j_wbuf;
+	struct jbd_inode *jinode, *next_i;
+	int err, ret = 0;
 
-	/*
-	 * Whenever we unlock the journal and sleep, things can get added
-	 * onto ->t_sync_datalist, so we have to keep looping back to
-	 * write_out_data until we *know* that the list is empty.
-	 *
-	 * Cleanup any flushed data buffers from the data list.  Even in
-	 * abort mode, we want to flush this out as soon as possible.
-	 */
-write_out_data:
-	cond_resched();
+	/* For locking, see the comment in journal_submit_data_buffers() */
 	spin_lock(&journal->j_list_lock);
+	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
+		jinode->i_flags |= JI_COMMIT_RUNNING;
+		spin_unlock(&journal->j_list_lock);
+		err = filemap_fdatawait(jinode->i_vfs_inode->i_mapping);
+		if (!ret)
+			ret = err;
+		spin_lock(&journal->j_list_lock);
+		jinode->i_flags &= ~JI_COMMIT_RUNNING;
+		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
+	}
 
-	while (commit_transaction->t_sync_datalist) {
-		jh = commit_transaction->t_sync_datalist;
-		bh = jh2bh(jh);
-		locked = 0;
-
-		/* Get reference just to make sure buffer does not disappear
-		 * when we are forced to drop various locks */
-		get_bh(bh);
-		/* If the buffer is dirty, we need to submit IO and hence
-		 * we need the buffer lock. We try to lock the buffer without
-		 * blocking. If we fail, we need to drop j_list_lock and do
-		 * blocking lock_buffer().
-		 */
-		if (buffer_dirty(bh)) {
-			if (test_set_buffer_locked(bh)) {
-				BUFFER_TRACE(bh, "needs blocking lock");
-				spin_unlock(&journal->j_list_lock);
-				/* Write out all data to prevent deadlocks */
-				journal_do_submit_data(wbuf, bufs);
-				bufs = 0;
-				lock_buffer(bh);
-				spin_lock(&journal->j_list_lock);
-			}
-			locked = 1;
-		}
-		/* We have to get bh_state lock. Again out of order, sigh. */
-		if (!inverted_lock(journal, bh)) {
-			jbd_lock_bh_state(bh);
-			spin_lock(&journal->j_list_lock);
-		}
-		/* Someone already cleaned up the buffer? */
-		if (!buffer_jbd(bh)
-			|| jh->b_transaction != commit_transaction
-			|| jh->b_jlist != BJ_SyncData) {
-			jbd_unlock_bh_state(bh);
-			if (locked)
-				unlock_buffer(bh);
-			BUFFER_TRACE(bh, "already cleaned up");
-			put_bh(bh);
-			continue;
-		}
-		if (locked && test_clear_buffer_dirty(bh)) {
-			BUFFER_TRACE(bh, "needs writeout, adding to array");
-			wbuf[bufs++] = bh;
-			__journal_file_buffer(jh, commit_transaction,
-						BJ_Locked);
-			jbd_unlock_bh_state(bh);
-			if (bufs == journal->j_wbufsize) {
-				spin_unlock(&journal->j_list_lock);
-				journal_do_submit_data(wbuf, bufs);
-				bufs = 0;
-				goto write_out_data;
-			}
-		} else if (!locked && buffer_locked(bh)) {
-			__journal_file_buffer(jh, commit_transaction,
-						BJ_Locked);
-			jbd_unlock_bh_state(bh);
-			put_bh(bh);
-		} else {
-			BUFFER_TRACE(bh, "writeout complete: unfile");
-			__journal_unfile_buffer(jh);
-			jbd_unlock_bh_state(bh);
-			if (locked)
-				unlock_buffer(bh);
-			journal_remove_journal_head(bh);
-			/* Once for our safety reference, once for
-			 * journal_remove_journal_head() */
-			put_bh(bh);
-			put_bh(bh);
-		}
-
-		if (need_resched() || spin_needbreak(&journal->j_list_lock)) {
-			spin_unlock(&journal->j_list_lock);
-			goto write_out_data;
+	/* Now refile inode to proper lists */
+	list_for_each_entry_safe(jinode, next_i,
+			&commit_transaction->t_inode_list, i_list) {
+		list_del(&jinode->i_list);
+		if (jinode->i_next_transaction) {
+			jinode->i_transaction = jinode->i_next_transaction;
+			jinode->i_next_transaction = NULL;
+			list_add(&jinode->i_list,
+				&jinode->i_transaction->t_inode_list);
 		}
+		else
+			jinode->i_transaction = NULL;
 	}
 	spin_unlock(&journal->j_list_lock);
-	journal_do_submit_data(wbuf, bufs);
+
+	return ret;
 }
 
 /*
@@ -426,44 +382,7 @@ void journal_commit_transaction(journal_t *journal)
 	 * Now start flushing things to disk, in the order they appear
 	 * on the transaction lists.  Data blocks go first.
 	 */
-	err = 0;
-	journal_submit_data_buffers(journal, commit_transaction);
-
-	/*
-	 * Wait for all previously submitted IO to complete.
-	 */
-	spin_lock(&journal->j_list_lock);
-	while (commit_transaction->t_locked_list) {
-		struct buffer_head *bh;
-
-		jh = commit_transaction->t_locked_list->b_tprev;
-		bh = jh2bh(jh);
-		get_bh(bh);
-		if (buffer_locked(bh)) {
-			spin_unlock(&journal->j_list_lock);
-			wait_on_buffer(bh);
-			if (unlikely(!buffer_uptodate(bh)))
-				err = -EIO;
-			spin_lock(&journal->j_list_lock);
-		}
-		if (!inverted_lock(journal, bh)) {
-			put_bh(bh);
-			spin_lock(&journal->j_list_lock);
-			continue;
-		}
-		if (buffer_jbd(bh) && jh->b_jlist == BJ_Locked) {
-			__journal_unfile_buffer(jh);
-			jbd_unlock_bh_state(bh);
-			journal_remove_journal_head(bh);
-			put_bh(bh);
-		} else {
-			jbd_unlock_bh_state(bh);
-		}
-		put_bh(bh);
-		cond_resched_lock(&journal->j_list_lock);
-	}
-	spin_unlock(&journal->j_list_lock);
-
+	err = journal_submit_data_buffers(journal, commit_transaction);
 	if (err)
 		journal_abort(journal, err);
 
@@ -472,22 +391,13 @@ void journal_commit_transaction(journal_t *journal)
 	jbd_debug(3, "JBD: commit phase 2\n");
 
 	/*
-	 * If we found any dirty or locked buffers, then we should have
-	 * looped back up to the write_out_data label.  If there weren't
-	 * any then journal_clean_data_list should have wiped the list
-	 * clean by now, so check that it is in fact empty.
-	 */
-	J_ASSERT (commit_transaction->t_sync_datalist == NULL);
-
-	jbd_debug (3, "JBD: commit phase 3\n");
-
-	/*
 	 * Way to go: we have now written out all of the data for a
 	 * transaction!  Now comes the tricky part: we need to write out
 	 * metadata.  Loop over the transaction's entire buffer list:
 	 */
 	commit_transaction->t_state = T_COMMIT;
 
+	err = 0;
 	descriptor = NULL;
 	bufs = 0;
 	while (commit_transaction->t_buffers) {
@@ -655,7 +565,14 @@ start_journal_io:
 	   so we incur less scheduling load.
 	*/
 
-	jbd_debug(3, "JBD: commit phase 4\n");
+	jbd_debug(3, "JBD: commit phase 3\n");
+
+	/*
+	 * First wait for data buffers.
+	 */
+	err = journal_finish_data_buffers(journal, commit_transaction);
+	if (err)
+		journal_abort(journal, err);
 
 	/*
 	 * akpm: these are BJ_IO, and j_list_lock is not needed.
@@ -714,7 +631,7 @@ wait_for_iobuf:
 
 	J_ASSERT (commit_transaction->t_shadow_list == NULL);
 
-	jbd_debug(3, "JBD: commit phase 5\n");
+	jbd_debug(3, "JBD: commit phase 4\n");
 
 	/* Here we wait for the revoke record and descriptor record buffers */
  wait_for_ctlbuf:
@@ -741,7 +658,7 @@ wait_for_iobuf:
 		/* AKPM: bforget here */
 	}
 
-	jbd_debug(3, "JBD: commit phase 6\n");
+	jbd_debug(3, "JBD: commit phase 5\n");
 
 	if (journal_write_commit_record(journal, commit_transaction))
 		err = -EIO;
@@ -754,9 +671,9 @@ wait_for_iobuf:
            transaction can be removed from any checkpoint list it was on
            before. */
 
-	jbd_debug(3, "JBD: commit phase 7\n");
+	jbd_debug(3, "JBD: commit phase 6\n");
 
-	J_ASSERT(commit_transaction->t_sync_datalist == NULL);
+	J_ASSERT(list_empty(&commit_transaction->t_inode_list));
 	J_ASSERT(commit_transaction->t_buffers == NULL);
 	J_ASSERT(commit_transaction->t_checkpoint_list == NULL);
 	J_ASSERT(commit_transaction->t_iobuf_list == NULL);
@@ -876,7 +793,7 @@ restart_loop:
 
 	/* Done with this transaction! */
 
-	jbd_debug(3, "JBD: commit phase 8\n");
+	jbd_debug(3, "JBD: commit phase 7\n");
 
 	J_ASSERT(commit_transaction->t_state == T_COMMIT);
 
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 0e081d5..9a76fde 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -49,7 +49,6 @@ EXPORT_SYMBOL(journal_unlock_updates);
 EXPORT_SYMBOL(journal_get_write_access);
 EXPORT_SYMBOL(journal_get_create_access);
 EXPORT_SYMBOL(journal_get_undo_access);
-EXPORT_SYMBOL(journal_dirty_data);
 EXPORT_SYMBOL(journal_dirty_metadata);
 EXPORT_SYMBOL(journal_release_buffer);
 EXPORT_SYMBOL(journal_forget);
@@ -1853,6 +1852,51 @@ void journal_put_journal_head(struct journal_head *jh)
 }
 
 /*
+ * Initialize jbd inode head
+ */
+void journal_init_jbd_inode(struct jbd_inode *jinode, struct inode *inode)
+{
+	jinode->i_transaction = NULL;
+	jinode->i_next_transaction = NULL;
+	jinode->i_vfs_inode = inode;
+	jinode->i_flags = 0;
+	INIT_LIST_HEAD(&jinode->i_list);
+}
+
+/*
+ * Function to be called before we start removing inode from memory (i.e.,
+ * clear_inode() is a fine place to be called from). It removes inode from
+ * transaction's lists.
+ */
+void journal_release_jbd_inode(journal_t *journal, struct jbd_inode *jinode)
+{
+	int writeout = 0;
+
+restart:
+	spin_lock(&journal->j_list_lock);
+	/* Is commit writing out inode - we have to wait */
+	if (jinode->i_flags & JI_COMMIT_RUNNING) {
+		wait_queue_head_t *wq;
+		DEFINE_WAIT_BIT(wait, &jinode->i_flags, __JI_COMMIT_RUNNING);
+		wq = bit_waitqueue(&jinode->i_flags, __JI_COMMIT_RUNNING);
+		prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
+		spin_unlock(&journal->j_list_lock);
+		schedule();
+		finish_wait(wq, &wait.wait);
+		goto restart;
+	}
+
+	/* Do we need to wait for data writeback? */
+	if (journal->j_committing_transaction == jinode->i_transaction)
+		writeout = 1;
+	if (jinode->i_transaction) {
+		list_del(&jinode->i_list);
+		jinode->i_transaction = NULL;
+	}
+	spin_unlock(&journal->j_list_lock);
+}
+
+/*
  * debugfs tunables
  */
 #ifdef CONFIG_JBD_DEBUG
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 2c9e8f5..1b0bf0e 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -25,6 +25,7 @@
 #include <linux/timer.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/writeback.h> /* For WB_SYNC_ALL :( */
 
 static void __journal_temp_unlink_buffer(struct journal_head *jh);
 
@@ -52,6 +53,7 @@ get_transaction(journal_t *journal, transaction_t *transaction)
 	transaction->t_tid = journal->j_transaction_sequence++;
 	transaction->t_expires = jiffies + journal->j_commit_interval;
 	spin_lock_init(&transaction->t_handle_lock);
+	INIT_LIST_HEAD(&transaction->t_inode_list);
 
 	/* Set up the commit timer for the new transaction. */
 	journal->j_commit_timer.expires = round_jiffies(transaction->t_expires);
@@ -920,185 +922,6 @@ out:
 }
 
 /**
- * int journal_dirty_data() - mark a buffer as containing dirty data to be flushed
- * @handle: transaction
- * @bh: bufferhead to mark
- *
- * Description:
- * Mark a buffer as containing dirty data which needs to be flushed before
- * we can commit the current transaction.
- *
- * The buffer is placed on the transaction's data list and is marked as
- * belonging to the transaction.
- *
- * Returns error number or 0 on success.
- *
- * journal_dirty_data() can be called via page_launder->ext3_writepage
- * by kswapd.
- */
-int journal_dirty_data(handle_t *handle, struct buffer_head *bh)
-{
-	journal_t *journal = handle->h_transaction->t_journal;
-	int need_brelse = 0;
-	struct journal_head *jh;
-
-	if (is_handle_aborted(handle))
-		return 0;
-
-	jh = journal_add_journal_head(bh);
-	JBUFFER_TRACE(jh, "entry");
-
-	/*
-	 * The buffer could *already* be dirty.  Writeout can start
-	 * at any time.
-	 */
-	jbd_debug(4, "jh: %p, tid:%d\n", jh, handle->h_transaction->t_tid);
-
-	/*
-	 * What if the buffer is already part of a running transaction?
-	 *
-	 * There are two cases:
-	 * 1) It is part of the current running transaction.  Refile it,
-	 *    just in case we have allocated it as metadata, deallocated
-	 *    it, then reallocated it as data.
-	 * 2) It is part of the previous, still-committing transaction.
-	 *    If all we want to do is to guarantee that the buffer will be
-	 *    written to disk before this new transaction commits, then
-	 *    being sure that the *previous* transaction has this same
-	 *    property is sufficient for us!  Just leave it on its old
-	 *    transaction.
-	 *
-	 * In case (2), the buffer must not already exist as metadata
-	 * --- that would violate write ordering (a transaction is free
-	 * to write its data at any point, even before the previous
-	 * committing transaction has committed).  The caller must
-	 * never, ever allow this to happen: there's nothing we can do
-	 * about it in this layer.
-	 */
-	jbd_lock_bh_state(bh);
-	spin_lock(&journal->j_list_lock);
-
-	/* Now that we have bh_state locked, are we really still mapped? */
-	if (!buffer_mapped(bh)) {
-		JBUFFER_TRACE(jh, "unmapped buffer, bailing out");
-		goto no_journal;
-	}
-
-	if (jh->b_transaction) {
-		JBUFFER_TRACE(jh, "has transaction");
-		if (jh->b_transaction != handle->h_transaction) {
-			JBUFFER_TRACE(jh, "belongs to older transaction");
-			J_ASSERT_JH(jh, jh->b_transaction ==
-					journal->j_committing_transaction);
-
-			/* @@@ IS THIS TRUE  ? */
-			/*
-			 * Not any more.  Scenario: someone does a write()
-			 * in data=journal mode.  The buffer's transaction has
-			 * moved into commit.  Then someone does another
-			 * write() to the file.  We do the frozen data copyout
-			 * and set b_next_transaction to point to j_running_t.
-			 * And while we're in that state, someone does a
-			 * writepage() in an attempt to pageout the same area
-			 * of the file via a shared mapping.  At present that
-			 * calls journal_dirty_data(), and we get right here.
-			 * It may be too late to journal the data.  Simply
-			 * falling through to the next test will suffice: the
-			 * data will be dirty and wil be checkpointed.  The
-			 * ordering comments in the next comment block still
-			 * apply.
-			 */
-			//J_ASSERT_JH(jh, jh->b_next_transaction == NULL);
-
-			/*
-			 * If we're journalling data, and this buffer was
-			 * subject to a write(), it could be metadata, forget
-			 * or shadow against the committing transaction.  Now,
-			 * someone has dirtied the same darn page via a mapping
-			 * and it is being writepage()'d.
-			 * We *could* just steal the page from commit, with some
-			 * fancy locking there.  Instead, we just skip it -
-			 * don't tie the page's buffers to the new transaction
-			 * at all.
-			 * Implication: if we crash before the writepage() data
-			 * is written into the filesystem, recovery will replay
-			 * the write() data.
-			 */
-			if (jh->b_jlist != BJ_None &&
-					jh->b_jlist != BJ_SyncData &&
-					jh->b_jlist != BJ_Locked) {
-				JBUFFER_TRACE(jh, "Not stealing");
-				goto no_journal;
-			}
-
-			/*
-			 * This buffer may be undergoing writeout in commit.  We
-			 * can't return from here and let the caller dirty it
-			 * again because that can cause the write-out loop in
-			 * commit to never terminate.
-			 */
-			if (buffer_dirty(bh)) {
-				get_bh(bh);
-				spin_unlock(&journal->j_list_lock);
-				jbd_unlock_bh_state(bh);
-				need_brelse = 1;
-				sync_dirty_buffer(bh);
-				jbd_lock_bh_state(bh);
-				spin_lock(&journal->j_list_lock);
-				/* Since we dropped the lock... */
-				if (!buffer_mapped(bh)) {
-					JBUFFER_TRACE(jh, "buffer got unmapped");
-					goto no_journal;
-				}
-				/* The buffer may become locked again at any
-				   time if it is redirtied */
-			}
-
-			/* journal_clean_data_list() may have got there first */
-			if (jh->b_transaction != NULL) {
-				JBUFFER_TRACE(jh, "unfile from commit");
-				__journal_temp_unlink_buffer(jh);
-				/* It still points to the committing
-				 * transaction; move it to this one so
-				 * that the refile assert checks are
-				 * happy. */
-				jh->b_transaction = handle->h_transaction;
-			}
-			/* The buffer will be refiled below */
-
-		}
-		/*
-		 * Special case --- the buffer might actually have been
-		 * allocated and then immediately deallocated in the previous,
-		 * committing transaction, so might still be left on that
-		 * transaction's metadata lists.
-		 */
-		if (jh->b_jlist != BJ_SyncData && jh->b_jlist != BJ_Locked) {
-			JBUFFER_TRACE(jh, "not on correct data list: unfile");
-			J_ASSERT_JH(jh, jh->b_jlist != BJ_Shadow);
-			__journal_temp_unlink_buffer(jh);
-			jh->b_transaction = handle->h_transaction;
-			JBUFFER_TRACE(jh, "file as data");
-			__journal_file_buffer(jh, handle->h_transaction,
-						BJ_SyncData);
-		}
-	} else {
-		JBUFFER_TRACE(jh, "not on a transaction");
-		__journal_file_buffer(jh, handle->h_transaction, BJ_SyncData);
-	}
-no_journal:
-	spin_unlock(&journal->j_list_lock);
-	jbd_unlock_bh_state(bh);
-	if (need_brelse) {
-		BUFFER_TRACE(bh, "brelse");
-		__brelse(bh);
-	}
-	JBUFFER_TRACE(jh, "exit");
-	journal_put_journal_head(jh);
-	return 0;
-}
-
-/**
  * int journal_dirty_metadata() - mark a buffer as containing dirty metadata
  * @handle: transaction to add buffer to.
  * @bh: buffer to mark
@@ -1505,10 +1328,10 @@ __blist_del_buffer(struct journal_head **list, struct journal_head *jh)
  * Remove a buffer from the appropriate transaction list.
  *
  * Note that this function can *change* the value of
- * bh->b_transaction->t_sync_datalist, t_buffers, t_forget,
- * t_iobuf_list, t_shadow_list, t_log_list or t_reserved_list.  If the caller
- * is holding onto a copy of one of thee pointers, it could go bad.
- * Generally the caller needs to re-read the pointer from the transaction_t.
+ * bh->b_transaction->t_buffers, t_forget, t_iobuf_list, t_shadow_list,
+ * t_log_list or t_reserved_list.  If the caller is holding onto a copy of one
+ * of thee pointers, it could go bad.  Generally the caller needs to re-read
+ * the pointer from the transaction_t.
  *
  * Called under j_list_lock.  The journal may not be locked.
  */
@@ -1530,9 +1353,6 @@ static void __journal_temp_unlink_buffer(struct journal_head *jh)
 	switch (jh->b_jlist) {
 	case BJ_None:
 		return;
-	case BJ_SyncData:
-		list = &transaction->t_sync_datalist;
-		break;
 	case BJ_Metadata:
 		transaction->t_nr_buffers--;
 		J_ASSERT_JH(jh, transaction->t_nr_buffers >= 0);
@@ -1553,9 +1373,6 @@ static void __journal_temp_unlink_buffer(struct journal_head *jh)
 	case BJ_Reserved:
 		list = &transaction->t_reserved_list;
 		break;
-	case BJ_Locked:
-		list = &transaction->t_locked_list;
-		break;
 	}
 
 	__blist_del_buffer(list, jh);
@@ -1598,15 +1415,7 @@ __journal_try_to_free_buffer(journal_t *journal, struct buffer_head *bh)
 		goto out;
 
 	spin_lock(&journal->j_list_lock);
-	if (jh->b_transaction != NULL && jh->b_cp_transaction == NULL) {
-		if (jh->b_jlist == BJ_SyncData || jh->b_jlist == BJ_Locked) {
-			/* A written-back ordered data buffer */
-			JBUFFER_TRACE(jh, "release data");
-			__journal_unfile_buffer(jh);
-			journal_remove_journal_head(bh);
-			__brelse(bh);
-		}
-	} else if (jh->b_cp_transaction != NULL && jh->b_transaction == NULL) {
+	if (jh->b_cp_transaction != NULL && jh->b_transaction == NULL) {
 		/* written-back checkpointed metadata buffer */
 		if (jh->b_jlist == BJ_None) {
 			JBUFFER_TRACE(jh, "remove from checkpoint list");
@@ -1787,6 +1596,7 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 	if (!buffer_jbd(bh))
 		goto zap_buffer_unlocked;
 
+	/* OK, we have data buffer in journaled mode */
 	spin_lock(&journal->j_state_lock);
 	jbd_lock_bh_state(bh);
 	spin_lock(&journal->j_list_lock);
@@ -1850,15 +1660,6 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 		}
 	} else if (transaction == journal->j_committing_transaction) {
 		JBUFFER_TRACE(jh, "on committing transaction");
-		if (jh->b_jlist == BJ_Locked) {
-			/*
-			 * The buffer is on the committing transaction's locked
-			 * list.  We have the buffer locked, so I/O has
-			 * completed.  So we can nail the buffer now.
-			 */
-			may_free = __dispose_buffer(jh, transaction);
-			goto zap_buffer;
-		}
 		/*
 		 * If it is committing, we simply cannot touch it.  We
 		 * can remove it's next_transaction pointer from the
@@ -1990,9 +1791,6 @@ void __journal_file_buffer(struct journal_head *jh,
 		J_ASSERT_JH(jh, !jh->b_committed_data);
 		J_ASSERT_JH(jh, !jh->b_frozen_data);
 		return;
-	case BJ_SyncData:
-		list = &transaction->t_sync_datalist;
-		break;
 	case BJ_Metadata:
 		transaction->t_nr_buffers++;
 		list = &transaction->t_buffers;
@@ -2012,9 +1810,6 @@ void __journal_file_buffer(struct journal_head *jh,
 	case BJ_Reserved:
 		list = &transaction->t_reserved_list;
 		break;
-	case BJ_Locked:
-		list =  &transaction->t_locked_list;
-		break;
 	}
 
 	__blist_add_buffer(list, jh);
@@ -2104,3 +1899,70 @@ void journal_refile_buffer(journal_t *journal, struct journal_head *jh)
 	spin_unlock(&journal->j_list_lock);
 	__brelse(bh);
 }
+
+/*
+ * File inode in the inode list of the handle's transaction
+ */
+int journal_file_inode(handle_t *handle, struct jbd_inode *jinode)
+{
+	transaction_t *transaction = handle->h_transaction;
+	journal_t *journal = transaction->t_journal;
+
+	if (is_handle_aborted(handle))
+		return 0;
+
+	jbd_debug(4, "Adding inode %lu, tid:%d\n", jinode->i_vfs_inode->i_ino,
+			transaction->t_tid);
+
+	spin_lock(&journal->j_list_lock);
+
+	if (jinode->i_transaction == transaction ||
+	    jinode->i_next_transaction == transaction)
+		goto done;
+
+	/* On some different transaction's list - should be
+	 * the committing one */
+	if (jinode->i_transaction) {
+		J_ASSERT(jinode->i_next_transaction == NULL);
+		J_ASSERT(jinode->i_transaction ==
+					journal->j_committing_transaction);
+		jinode->i_next_transaction = transaction;
+		goto done;
+	}
+	/* Not on any transaction list... */
+	J_ASSERT(!jinode->i_next_transaction);
+	jinode->i_transaction = transaction;
+	list_add(&jinode->i_list, &transaction->t_inode_list);
+done:
+	spin_unlock(&journal->j_list_lock);
+
+	return 0;
+}
+
+/*
+ * This function must be called when inode is journaled in ordered mode
+ * before truncation happens. It starts writeout of truncated part in
+ * case it is in the committing transaction so that we stand to ordered
+ * mode consistency guarantees.
+ */
+int journal_begin_ordered_truncate(struct jbd_inode *inode, loff_t new_size)
+{
+	journal_t *journal;
+	transaction_t *commit_trans;
+	int ret = 0;
+
+	if (!inode->i_transaction && !inode->i_next_transaction)
+		goto out;
+	journal = inode->i_transaction->t_journal;
+	spin_lock(&journal->j_state_lock);
+	commit_trans = journal->j_committing_transaction;
+	spin_unlock(&journal->j_state_lock);
+	if (inode->i_transaction == commit_trans) {
+		ret = __filemap_fdatawrite_range(inode->i_vfs_inode->i_mapping,
+			new_size, LLONG_MAX, WB_SYNC_ALL);
+		if (ret)
+			journal_abort(journal, ret);
+	}
+out:
+	return ret;
+}
diff --git a/fs/mpage.c b/fs/mpage.c
index 235e4d3..4f66bae 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -527,7 +527,10 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 
 		map_bh.b_state = 0;
 		map_bh.b_size = 1 << blkbits;
-		if (mpd->get_block(inode, block_in_file, &map_bh, 1))
+		if (mpd->get_block(inode, block_in_file, &map_bh,
+				   !wbc->skip_unmapped))
+			goto confused;
+		if (!buffer_mapped(&map_bh))
 			goto confused;
 		if (buffer_new(&map_bh))
 			unmap_underlying_metadata(map_bh.b_bdev,
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 36c5403..715c35e 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -836,6 +836,7 @@ extern void ext3_truncate (struct inode *);
 extern void ext3_set_inode_flags(struct inode *);
 extern void ext3_get_inode_flags(struct ext3_inode_info *);
 extern void ext3_set_aops(struct inode *inode);
+extern int ext3_page_mkwrite(struct vm_area_struct *vma, struct page *page);
 
 /* ioctl.c */
 extern int ext3_ioctl (struct inode *, struct file *, unsigned int,
diff --git a/include/linux/ext3_fs_i.h b/include/linux/ext3_fs_i.h
index 7894dd0..afd77b0 100644
--- a/include/linux/ext3_fs_i.h
+++ b/include/linux/ext3_fs_i.h
@@ -142,6 +142,7 @@ struct ext3_inode_info {
 	 */
 	struct mutex truncate_mutex;
 	struct inode vfs_inode;
+	struct jbd_inode jinode;
 };
 
 #endif	/* _LINUX_EXT3_FS_I */
diff --git a/include/linux/ext3_jbd.h b/include/linux/ext3_jbd.h
index 8c43b13..2aae63f 100644
--- a/include/linux/ext3_jbd.h
+++ b/include/linux/ext3_jbd.h
@@ -149,8 +149,6 @@ int __ext3_journal_dirty_metadata(const char *where,
 #define ext3_journal_forget(handle, bh) \
 	__ext3_journal_forget(__FUNCTION__, (handle), (bh))
 
-int ext3_journal_dirty_data(handle_t *handle, struct buffer_head *bh);
-
 handle_t *ext3_journal_start_sb(struct super_block *sb, int nblocks);
 int __ext3_journal_stop(const char *where, handle_t *handle);
 
@@ -187,6 +185,11 @@ static inline int ext3_journal_force_commit(journal_t *journal)
 	return journal_force_commit(journal);
 }
 
+static inline int ext3_jbd_file_inode(handle_t *handle, struct inode *inode)
+{
+	return journal_file_inode(handle, &EXT3_I(inode)->jinode);
+}
+
 /* super.c */
 int ext3_force_commit(struct super_block *sb);
 
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 423f582..68188c8 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -345,6 +345,38 @@ static inline void jbd_unlock_bh_journal_head(struct buffer_head *bh)
 	bit_spin_unlock(BH_JournalHead, &bh->b_state);
 }
 
+/* Flags in jbd_inode->i_flags */
+#define __JI_COMMIT_RUNNING 0
+/* Commit of the inode data in progress. We use this flag to protect us from
+ * concurrent deletion of inode. We cannot use reference to inode for this
+ * since we cannot afford doing last iput() on behalf of kjournald
+ */
+#define JI_COMMIT_RUNNING (1 << __JI_COMMIT_RUNNING)
+
+/**
+ * struct jbd_inode is the structure linking inodes in ordered mode
+ *   present in a transaction so that we can sync them during commit.
+ */
+struct jbd_inode {
+	/* Which transaction does this inode belong to? Either the running
+	 * transaction or the committing one. [j_list_lock] */
+	transaction_t *i_transaction;
+
+	/* Pointer to the running transaction modifying inode's data in case
+	 * there is already a committing transaction touching it. [j_list_lock] */
+	transaction_t *i_next_transaction;
+
+	/* List of inodes in the i_transaction [j_list_lock] */
+	struct list_head i_list;
+
+	/* VFS inode this inode belongs to [constant during the lifetime
+	 * of the structure] */
+	struct inode *i_vfs_inode;
+
+	/* Flags of inode [j_list_lock] */
+	unsigned int i_flags;
+};
+
 struct jbd_revoke_table_s;
 
 /**
@@ -460,24 +492,12 @@ struct transaction_s
 	struct journal_head	*t_reserved_list;
 
 	/*
-	 * Doubly-linked circular list of all buffers under writeout during
-	 * commit [j_list_lock]
-	 */
-	struct journal_head	*t_locked_list;
-
-	/*
 	 * Doubly-linked circular list of all metadata buffers owned by this
 	 * transaction [j_list_lock]
 	 */
 	struct journal_head	*t_buffers;
 
 	/*
-	 * Doubly-linked circular list of all data buffers still to be
-	 * flushed before this transaction can be committed [j_list_lock]
-	 */
-	struct journal_head	*t_sync_datalist;
-
-	/*
 	 * Doubly-linked circular list of all forget buffers (superseded
 	 * buffers which we can un-checkpoint once this transaction commits)
 	 * [j_list_lock]
@@ -516,6 +536,12 @@ struct transaction_s
 	struct journal_head	*t_log_list;
 
 	/*
+	 * List of inodes whose data we've modified in data=ordered mode.
+	 * [j_list_lock]
+	 */
+	struct list_head	t_inode_list;
+
+	/*
 	 * Protects info related to handles
 	 */
 	spinlock_t		t_handle_lock;
@@ -884,7 +910,6 @@ extern int	 journal_extend (handle_t *, int nblocks);
 extern int	 journal_get_write_access(handle_t *, struct buffer_head *);
 extern int	 journal_get_create_access (handle_t *, struct buffer_head *);
 extern int	 journal_get_undo_access(handle_t *, struct buffer_head *);
-extern int	 journal_dirty_data (handle_t *, struct buffer_head *);
 extern int	 journal_dirty_metadata (handle_t *, struct buffer_head *);
 extern void	 journal_release_buffer (handle_t *, struct buffer_head *);
 extern int	 journal_forget (handle_t *, struct buffer_head *);
@@ -921,6 +946,10 @@ extern void	   journal_ack_err    (journal_t *);
 extern int	   journal_clear_err  (journal_t *);
 extern int	   journal_bmap(journal_t *, unsigned long, unsigned long *);
 extern int	   journal_force_commit(journal_t *);
+int journal_file_inode(handle_t *handle, struct jbd_inode *inode);
+int journal_begin_ordered_truncate(struct jbd_inode *inode, loff_t new_size);
+void journal_init_jbd_inode(struct jbd_inode *jinode, struct inode *inode);
+void journal_release_jbd_inode(journal_t *journal, struct jbd_inode *jinode);
 
 /*
  * journal_head management
@@ -1056,15 +1085,13 @@ static inline int jbd_space_needed(journal_t *journal)
 
 /* journaling buffer types */
 #define BJ_None		0	/* Not journaled */
-#define BJ_SyncData	1	/* Normal data: flush before commit */
-#define BJ_Metadata	2	/* Normal journaled metadata */
-#define BJ_Forget	3	/* Buffer superseded by this transaction */
-#define BJ_IO		4	/* Buffer is for temporary IO use */
-#define BJ_Shadow	5	/* Buffer contents being shadowed to the log */
-#define BJ_LogCtl	6	/* Buffer contains log descriptors */
-#define BJ_Reserved	7	/* Buffer is reserved for access by journal */
-#define BJ_Locked	8	/* Locked for I/O during commit */
-#define BJ_Types	9
+#define BJ_Metadata	1	/* Normal journaled metadata */
+#define BJ_Forget	2	/* Buffer superseded by this transaction */
+#define BJ_IO		3	/* Buffer is for temporary IO use */
+#define BJ_Shadow	4	/* Buffer contents being shadowed to the log */
+#define BJ_LogCtl	5	/* Buffer contains log descriptors */
+#define BJ_Reserved	6	/* Buffer is reserved for access by journal */
+#define BJ_Types	7
 
 extern int jbd_blocks_per_page(struct inode *inode);
 
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index b7b3362..2725e8b 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -63,6 +63,7 @@ struct writeback_control {
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
+	unsigned skip_unmapped:1;	/* A kjournald commit */
 };
 
 /*

--qlTNgmc+xy1dBmNv--
