From: Jan Kara <jack@suse.cz>
Subject: [RFC] [PATCH] Inverse locking order of page_lock and transaction
	start
Date: Thu, 27 Mar 2008 17:27:42 +0100
Message-ID: <20080327162742.GC32534@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48530 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752238AbYC0Q1o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Mar 2008 12:27:44 -0400
Received: from duck.suse.cz (duck.suse.cz [10.20.1.74])
	by mail.suse.cz (Postfix) with ESMTP id 9B2C96280E4
	for <linux-ext4@vger.kernel.org>; Thu, 27 Mar 2008 17:27:42 +0100 (CET)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  below is the first version of the patch that reverses locking order of
page_lock and transaction start. I have tested it with fsx-linux, ltp DIO
tests etc. and lockdep didn't complain so hopefully I got it mostly right
but review is definitely needed. Especially I'd like to know what people
think about the way I've implemented ext3_page_mkwrite() - ext4 has
an incorrect code AFAICT because in ordered and journaled modes we should
write block of zeros and properly journal it (and no, block_page_mkwrite()
doesn't do it). We could implement ext3/4_page_mkwrite() in a similar way
we currently implement writepage calls but calling write_begin + write_end
does the job and should be only a tiny bit slower...
  If nobody finds a serious flaw in the approach, I'll rediff the patch
against ext4 (I'll also try to convert delayed-alloc path - from a quick
look converting da_writepages path is going to be interesting).
  I'm looking forward to your comments :)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

---

Reverse locking order of page lock and transaction start in ext3  (i.e., page
lock now comes after the transaction start). Needed changes are:
  1) Simply swap the order in ext3_write_begin() and ext3_..._write_end()
     (allows removal of ext3_generic_write_end())
  2) Implement ext3_page_mkwrite() to fill holes.
  3) Change ext3_writeback_writepage() not to start a transaction at all,
     ext3_ordered_writepage() starts a transaction only after unlocking
     the page in block_write_full_page() (to attach buffers to the transaction),
     ext3_journaled_writepage() gets references to buffers in the page, unlocks
     the page and then starts a transaction.

Signed-off-by: Jan Kara <jack@suse.cz>

---
 fs/ext3/file.c          |   19 ++++-
 fs/ext3/inode.c         |  236 +++++++++++++++++++++++++----------------------
 include/linux/ext3_fs.h |    1 +
 3 files changed, 145 insertions(+), 111 deletions(-)

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
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index eb95670..210b886 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1126,6 +1126,10 @@ static int walk_page_buffers(	handle_t *handle,
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
@@ -1152,18 +1156,19 @@ static int ext3_write_begin(struct file *file, struct address_space *mapping,
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
@@ -1175,8 +1180,8 @@ retry:
 	}
 write_begin_failed:
 	if (ret) {
-		ext3_journal_stop(handle);
 		unlock_page(page);
+		ext3_journal_stop(handle);
 		page_cache_release(page);
 	}
 	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
@@ -1205,29 +1210,6 @@ static int write_end_fn(handle_t *handle, struct buffer_head *bh)
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
@@ -1240,7 +1222,7 @@ static int ext3_ordered_write_end(struct file *file,
 				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = mapping->host;
 	unsigned from, to;
 	int ret = 0, ret2;
 
@@ -1261,7 +1243,7 @@ static int ext3_ordered_write_end(struct file *file,
 		new_i_size = pos + copied;
 		if (new_i_size > EXT3_I(inode)->i_disksize)
 			EXT3_I(inode)->i_disksize = new_i_size;
-		copied = ext3_generic_write_end(file, mapping, pos, len, copied,
+		copied = generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 		if (copied < 0)
 			ret = copied;
@@ -1269,8 +1251,6 @@ static int ext3_ordered_write_end(struct file *file,
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	unlock_page(page);
-	page_cache_release(page);
 
 	return ret ? ret : copied;
 }
@@ -1281,7 +1261,7 @@ static int ext3_writeback_write_end(struct file *file,
 				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = mapping->host;
 	int ret = 0, ret2;
 	loff_t new_i_size;
 
@@ -1289,7 +1269,7 @@ static int ext3_writeback_write_end(struct file *file,
 	if (new_i_size > EXT3_I(inode)->i_disksize)
 		EXT3_I(inode)->i_disksize = new_i_size;
 
-	copied = ext3_generic_write_end(file, mapping, pos, len, copied,
+	copied = generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 	if (copied < 0)
 		ret = copied;
@@ -1297,8 +1277,6 @@ static int ext3_writeback_write_end(struct file *file,
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	unlock_page(page);
-	page_cache_release(page);
 
 	return ret ? ret : copied;
 }
@@ -1337,10 +1315,10 @@ static int ext3_journalled_write_end(struct file *file,
 			ret = ret2;
 	}
 
+	unlock_page(page);
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	unlock_page(page);
 	page_cache_release(page);
 
 	return ret ? ret : copied;
@@ -1418,11 +1396,10 @@ static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
 }
 
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
@@ -1466,8 +1443,6 @@ static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
  * disastrous.  Any write() or metadata operation will sync the fs for
  * us.
  *
- * AKPM2: if all the page's buffers are mapped to disk and !data=journal,
- * we don't need to open a transaction here.
  */
 static int ext3_ordered_writepage(struct page *page,
 				struct writeback_control *wbc)
@@ -1487,13 +1462,6 @@ static int ext3_ordered_writepage(struct page *page,
 	if (ext3_journal_current_handle())
 		goto out_fail;
 
-	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
-
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		goto out_fail;
-	}
-
 	if (!page_has_buffers(page)) {
 		create_empty_buffers(page, inode->i_sb->s_blocksize,
 				(1 << BH_Dirty)|(1 << BH_Uptodate));
@@ -1517,16 +1485,21 @@ static int ext3_ordered_writepage(struct page *page,
 	 * and generally junk.
 	 */
 	if (ret == 0) {
-		err = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
+		handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			goto out_put;
+		}
+
+		ret = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
 					NULL, journal_dirty_data_fn);
+		err = ext3_journal_stop(handle);
 		if (!ret)
 			ret = err;
 	}
+out_put:
 	walk_page_buffers(handle, page_bufs, 0,
 			PAGE_CACHE_SIZE, NULL, bput_one);
-	err = ext3_journal_stop(handle);
-	if (!ret)
-		ret = err;
 	return ret;
 
 out_fail:
@@ -1539,27 +1512,16 @@ static int ext3_writeback_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
-	handle_t *handle = NULL;
 	int ret = 0;
-	int err;
 
 	if (ext3_journal_current_handle())
 		goto out_fail;
 
-	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		goto out_fail;
-	}
-
 	if (test_opt(inode->i_sb, NOBH) && ext3_should_writeback_data(inode))
 		ret = nobh_writepage(page, ext3_get_block, wbc);
 	else
 		ret = block_write_full_page(page, ext3_get_block, wbc);
 
-	err = ext3_journal_stop(handle);
-	if (!ret)
-		ret = err;
 	return ret;
 
 out_fail:
@@ -1571,7 +1533,9 @@ out_fail:
 static int ext3_journalled_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
-	struct inode *inode = page->mapping->host;
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
+	struct buffer_head *page_bufs;
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
@@ -1579,12 +1543,6 @@ static int ext3_journalled_writepage(struct page *page,
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
@@ -1593,19 +1551,37 @@ static int ext3_journalled_writepage(struct page *page,
 		ClearPageChecked(page);
 		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
 					ext3_get_block);
-		if (ret != 0) {
-			ext3_journal_stop(handle);
+		if (ret != 0)
 			goto out_unlock;
+
+		page_bufs = page_buffers(page);
+		walk_page_buffers(handle, page_bufs, 0,
+				PAGE_CACHE_SIZE, NULL, bget_one);
+		/* As soon as we unlock the page, it can go away, but we have
+		 * references to buffers so we are safe */
+		unlock_page(page);
+
+		handle = ext3_journal_start(inode,
+					ext3_writepage_trans_blocks(inode));
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			goto out;
 		}
-		ret = walk_page_buffers(handle, page_buffers(page), 0,
+
+		ret = walk_page_buffers(handle, page_bufs, 0,
 			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
 
-		err = walk_page_buffers(handle, page_buffers(page), 0,
+		err = walk_page_buffers(handle, page_bufs, 0,
 				PAGE_CACHE_SIZE, NULL, write_end_fn);
 		if (ret == 0)
 			ret = err;
+		err = ext3_journal_stop(handle);
+		if (!ret)
+			ret = err;
+
+		walk_page_buffers(handle, page_bufs, 0,
+				PAGE_CACHE_SIZE, NULL, bput_one);
 		EXT3_I(inode)->i_state |= EXT3_STATE_JDATA;
-		unlock_page(page);
 	} else {
 		/*
 		 * It may be a page full of checkpoint-mode buffers.  We don't
@@ -1614,9 +1590,6 @@ static int ext3_journalled_writepage(struct page *page,
 		 */
 		ret = block_write_full_page(page, ext3_get_block, wbc);
 	}
-	err = ext3_journal_stop(handle);
-	if (!ret)
-		ret = err;
 out:
 	return ret;
 
@@ -1821,7 +1794,7 @@ void ext3_set_aops(struct inode *inode)
  * This required during truncate. We need to physically zero the tail end
  * of that block so it doesn't yield old data if the file is later grown.
  */
-static int ext3_block_truncate_page(handle_t *handle, struct page *page,
+static int ext3_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from)
 {
 	ext3_fsblk_t index = from >> PAGE_CACHE_SHIFT;
@@ -1829,8 +1802,13 @@ static int ext3_block_truncate_page(handle_t *handle, struct page *page,
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
@@ -2293,7 +2271,6 @@ void ext3_truncate(struct inode *inode)
 	int n;
 	long last_block;
 	unsigned blocksize = inode->i_sb->s_blocksize;
-	struct page *page;
 
 	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
 	    S_ISLNK(inode->i_mode)))
@@ -2303,36 +2280,16 @@ void ext3_truncate(struct inode *inode)
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
@@ -3306,3 +3263,62 @@ int ext3_change_inode_journal_flag(struct inode *inode, int val)
 
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
+	int ret = -EINVAL;
+
+	/*
+	 * Get i_alloc_sem to stop truncates messing with the inode. We cannot
+	 * get i_mutex because we are already holding mmap_sem. This makes
+	 * it possible for write_begin and write_end to run concurrently
+	 * on a single file (not on a single page because of page_lock).
+	 * We seem to handle this just fine...
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
+	/* OK, we need to fill the hole... We simply write the page. */
+	printk(KERN_INFO "Writing page %lu of ino %lu\n", page->index, inode->i_ino);
+	ret = mapping->a_ops->write_begin(file, mapping, page_offset(page),
+		len, AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
+	if (ret < 0)
+		goto out_unlock;
+	ret = mapping->a_ops->write_end(file, mapping, page_offset(page), len,
+		len, page, NULL);
+	if (ret < 0)
+		goto out_unlock;
+	ret = 0;
+out_unlock:
+	up_read(&inode->i_alloc_sem);
+	return ret;
+}
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
-- 
1.5.2.4

