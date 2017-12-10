From: seongbaeSon <seongbae.son@gmail.com>
Subject: [PATCH] ext4: delayed inode update for the consistency of file size
 after a crash
Date: Sun, 10 Dec 2017 21:12:57 +0900
Message-ID: <20171210121257.GA1588@son-VirtualBox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

For one write() system call, the file size in the ext4_inode can be updated
twice; at the write() system call and when dirty pages of the file are written
to storage (i.g. fsync() or kworker thread). The write() system call that
appends data to a file but does not need to allocate a block updates
the page cache entry and marks the page as dirty. Then, the write() system
call updates the file size in ext4_inode to the size of appended data and
inserts the ext4_inode into a running transaction. After that, if the
application calls an fsync(), the application thread dispatches the dirty
page of the file and wakes up the JBD2. Once the JBD2 is wakened up,
the JBD2 commits a running transaction. When the JBD2 commits the running
transaction, it is possible that there are some ext4_inodes which file size is
updated even though the dirty pages are not written to storage in the running
transaction. If an unexpected power failure occurs after the fsync(),
the EXT4 recovery module recovers the ext4_inodes in the journal area, but
without the appropriate data blocks on disk.

Consider the following scenario. There are the two files, namely, fileA and
fileB. The sizes of these two files are 14 KB. Mount options of EXT4 include
the delayed allocation and the ordered mode journaling.

1. Current file offset of fileA is 14 KB. An application appends 2 KB data to
fileA by executing a write() system call. At this time, the file size in 
the ext4_inode of fileA is updated to 16 KB by ext4_da_write_end().
2. Current file offset of fileB is 14 KB. An application appends 2 KB data to
fileB by executing a write() system call. At this time, the file size in
the ext4_inode of fileB is updated to 16 KB by ext4_da_write_end().
3. A fsync(fileB) is called before the kworker thread runs. At this time,
the application thread transfers the data block of fileB to storage and
wakes up the JBD2. Then, JBD2 writes the ext4_inodes of fileA and fileB in
the running transaction to the journal area. The ext4_inode of fileA in 
the journal area has the file size, 16 KB, even though the data block of
fileA has not been written to storage.
4. Assume that a system crash occurs. The EXT4 recovery module recovers
the inodes of fileA and fileB. The recovered inode of fileA has the updated
file size, 16 KB, even though the data of fileA has not been made durable.
The data block of fileA between 14 KB and 16 KB is seen as zeros.

EXT4 updates the file size of the ext4_inode at ext4_da_write_end() so that
both the time stamps and the file size of the ext4_inode get updated at
the write() system call. This saves EXT4 from having to journal the ext4_inode
again when dirty pages of the file are written to storage. If the file size in
the ext4_inode is updated again when dirty pages of the file are written
to storage, the ext4_inode can be inserted into two different transactions
by the update of time stamps and the update of the file size respectively.
This causes the amount of blocks written to the journal area to get increased.
In order to address the problem that the ext4_inode has a wrong file size
after an unexpected power failure, this commit does not update the file size
in the ext4_inode at the write() system call, but delays the update of
the file size in the ext4_inode until dirty pages of the file are written
to storage (i.g. fsync() or kworker thread). So, ext4_inode can be inserted
into two different transactions in this technique that this commit suggests.
In order to keep the above EXT4 optimization, our technique delays journaling
the ext4_inode in which the time stamps are updated until dirty pages of
the file are written to storage. Therefore, the time stamps and the file size
of the ext4_inode get updated at the same time in our technique as well.

Additionally, we should consider the kswapd behavior for this commit.
When there is a memory pressure, the kswapd cleans dirty pages in the page
cache. Consider that all dirty pages of a file are written to storage by
the kswapd. The ext4_inode of the file is not journaled due to this commit.
After the fsync() system call or the kswapd writes the dirty page to storage,
the state of the page is changed to clean or writeback and the ext4_inode
associated with the page is still not in the journal transaction and
will not be inserted to the transaction ever after. In order to update and
insert the ext4_inode into a running transaction in the above situation,
I make the kswapd be re-dirty the last selected victim page among the dirty
pages of a file.

This commit is applied to kernel 4.15-rc2.

Details can be found as follows.

Son et al. "Guaranteeing the Metadata Update Atomicity in EXT4 Filesystem”,
In Proc. of APSYS 2017, Mumbai, India

Signed-off-by: Seongbae Son, ESOSLab, Hanyang University <seongbae.son@gmail.com>
---
 fs/ext4/ext4.h     |   4 ++
 fs/ext4/file.c     |  10 +++-
 fs/ext4/inode.c    | 170 ++++++++++++++++++++++++++++++++++++++++++-----------
 include/linux/fs.h |   1 +
 mm/filemap.c       |  88 +++++++++++++++++++++++++++
 5 files changed, 238 insertions(+), 35 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4e091ea..31aba55 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1045,6 +1045,9 @@ struct ext4_inode_info {
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
 
+	/* Flag checking whether timestamps of ext4_inode is updated or not */
+	__u16 is_ts_updated;
+
 #ifdef CONFIG_QUOTA
 	struct dquot *i_dquot[MAXQUOTAS];
 #endif
@@ -2453,6 +2456,7 @@ extern void ext4_clear_inode(struct inode *);
 extern int  ext4_file_getattr(const struct path *, struct kstat *, u32, unsigned int);
 extern int  ext4_sync_inode(handle_t *, struct inode *);
 extern void ext4_dirty_inode(struct inode *, int);
+extern int ext4_update_time(struct inode *);
 extern int ext4_change_inode_journal_flag(struct inode *, int);
 extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
 extern int ext4_inode_attach_jinode(struct inode *inode);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index a0ae27b..d2ac76c 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -263,7 +263,15 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		}
 	}
 
-	ret = __generic_file_write_iter(iocb, from);
+	/*
+	 * Update timestamps of ext4_inode without inserting the updated inode
+	 * into a transaction.
+	 */
+	ret = ext4_update_time(inode);
+	if (ret)
+		goto out;
+
+	ret = _generic_file_write_iter(iocb, from);
 	inode_unlock(inode);
 
 	if (ret > 0)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7df2c56..d206a0c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2097,6 +2097,7 @@ static int ext4_writepage(struct page *page,
 	unsigned int len;
 	struct buffer_head *page_bufs = NULL;
 	struct inode *inode = page->mapping->host;
+	struct address_space *mapping = page->mapping;
 	struct ext4_io_submit io_submit;
 	bool keep_towrite = false;
 
@@ -2165,6 +2166,16 @@ static int ext4_writepage(struct page *page,
 	}
 	ret = ext4_bio_write_page(&io_submit, page, len, wbc, keep_towrite);
 	ext4_io_submit(&io_submit);
+
+	if (!(mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) &&
+		(current->flags & PF_KSWAPD))
+	/* This is the last dirty page in the file. So, we make it
+	 * redirty so that kworker or fsync() updates the inode (ie,
+	 * file size) and inserts the inode into a running transaction
+	 * at that time.
+	 */
+		redirty_page_for_writepage(wbc, page);
+
 	/* Drop io_end reference we got from init */
 	ext4_put_io_end_defer(io_submit.io_end);
 	return ret;
@@ -2287,9 +2298,12 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
 				   ext4_lblk_t lblk)
 {
 	struct inode *inode = mpd->inode;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	handle_t *handle = NULL;
 	int err;
-	ext4_lblk_t blocks = (i_size_read(inode) + i_blocksize(inode) - 1)
-							>> inode->i_blkbits;
+	loff_t i_size = i_size_read(inode);
+	ext4_lblk_t blocks = (i_size + i_blocksize(inode) - 1)
+						>> inode->i_blkbits;
 
 	do {
 		BUG_ON(buffer_locked(bh));
@@ -2310,6 +2324,25 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
 		err = mpage_submit_page(mpd, head->b_page);
 		if (err < 0)
 			return err;
+
+		/*
+		 * If updating i_disksize is delayed by ext4_da_write_end(), do
+		 * it here. Then, call ext4_mark_inode_dirty() in order to
+		 * insert the ext4_inode that file size and timestamps are
+		 * updated into a running transaction.
+		 */
+		if (EXT4_I(inode)->i_disksize < i_size || ei->is_ts_updated) {
+			down_write(&ei->i_data_sem);
+			if (EXT4_I(inode)->i_disksize < i_size)
+				ei->i_disksize = i_size;
+			if (ei->is_ts_updated)
+				ei->is_ts_updated = 0;
+			up_write(&ei->i_data_sem);
+
+			handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
+			ext4_mark_inode_dirty(handle, inode);
+			ext4_journal_stop(handle);
+		}
 	}
 	return lblk < blocks;
 }
@@ -3094,26 +3127,29 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 }
 
 /*
- * Check if we should update i_disksize
- * when write to the end of file but not require block allocation
+ * ext4_block_write_end() does not call mark_inode_dirty() unlike 
+ * generic_write_end() so that the inode is not journalled here.
  */
-static int ext4_da_should_update_i_disksize(struct page *page,
-					    unsigned long offset)
+int ext4_block_write_end(struct file *file, struct address_space *mapping,
+			 loff_t pos, unsigned len, unsigned copied,
+			 struct page *page, void *fsdata)
 {
-	struct buffer_head *bh;
-	struct inode *inode = page->mapping->host;
-	unsigned int idx;
-	int i;
+	struct inode *inode = mapping->host;
+	loff_t old_size = inode->i_size;
 
-	bh = page_buffers(page);
-	idx = offset >> inode->i_blkbits;
+	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
 
-	for (i = 0; i < idx; i++)
-		bh = bh->b_this_page;
+	if (pos+copied > inode->i_size) {
+		i_size_write(inode, pos+copied);
+	}
 
-	if (!buffer_mapped(bh) || (buffer_delay(bh)) || buffer_unwritten(bh))
-		return 0;
-	return 1;
+	unlock_page(page);
+	put_page(page);
+
+	if (old_size < pos)
+		pagecache_isize_extended(inode, old_size, pos);
+
+	return copied;
 }
 
 static int ext4_da_write_end(struct file *file,
@@ -3136,29 +3172,15 @@ static int ext4_da_write_end(struct file *file,
 	start = pos & (PAGE_SIZE - 1);
 	end = start + copied - 1;
 
-	/*
-	 * generic_write_end() will run mark_inode_dirty() if i_size
-	 * changes.  So let's piggyback the i_disksize mark_inode_dirty
-	 * into that.
-	 */
 	new_i_size = pos + copied;
-	if (copied && new_i_size > EXT4_I(inode)->i_disksize) {
-		if (ext4_has_inline_data(inode) ||
-		    ext4_da_should_update_i_disksize(page, end)) {
-			ext4_update_i_disksize(inode, new_i_size);
-			/* We need to mark inode dirty even if
-			 * new_i_size is less that inode->i_size
-			 * bu greater than i_disksize.(hint delalloc)
-			 */
-			ext4_mark_inode_dirty(handle, inode);
-		}
-	}
-
 	if (write_mode != CONVERT_INLINE_DATA &&
 	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA) &&
 	    ext4_has_inline_data(inode))
 		ret2 = ext4_da_write_inline_data_end(inode, pos, len, copied,
 						     page);
+	else if (copied && new_i_size > EXT4_I(inode)->i_disksize)
+		ret2 = ext4_block_write_end(file, mapping, pos, len, copied,
+							page, fsdata);
 	else
 		ret2 = generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
@@ -5856,6 +5878,86 @@ int ext4_expand_extra_isize(struct inode *inode,
 	return error;
 }
 
+void  __ext4_update_time(struct inode *inode,
+			 struct ext4_iloc *iloc)
+{
+	struct ext4_inode *raw_inode = ext4_raw_inode(iloc);
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct buffer_head *bh = iloc->bh;
+
+	get_bh(iloc->bh);
+	spin_lock(&ei->i_raw_lock);
+
+	EXT4_INODE_SET_XTIME(i_ctime, inode, raw_inode);
+	EXT4_INODE_SET_XTIME(i_mtime, inode, raw_inode);
+	EXT4_INODE_SET_XTIME(i_atime, inode, raw_inode);
+	EXT4_EINODE_SET_XTIME(i_crtime, ei, raw_inode);
+
+	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
+	raw_inode->i_flags = cpu_to_le32(ei->i_flags & 0xFFFFFFFF);
+
+	ext4_inode_csum_set(inode, raw_inode, ei);
+	spin_unlock(&ei->i_raw_lock);
+	if (inode->i_sb->s_flags & MS_LAZYTIME)
+		ext4_update_other_inodes_time(inode->i_sb, inode->i_ino,
+					      bh->b_data);
+	ext4_clear_inode_state(inode, EXT4_STATE_NEW);
+
+	brelse(bh);
+	put_bh(iloc->bh);
+}
+
+/*
+ * ext4_update_time() is called from ext4_file_write_iter()
+ *
+ * This function updates the timestamps of ext4_inode without inserting the
+ * updated inode into a transaction so that the inode can be journaled after
+ * dirty pages of the file are dispatched to storage.
+ */
+int ext4_update_time(struct inode *inode)
+{
+	struct timespec now;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_iloc iloc;
+	int sync_it = 0;
+	int err;
+
+	/* First try to exhaust all avenues to not sync */
+	if (IS_NOCMTIME(inode))
+		return 0;
+
+	now = current_time(inode);
+	if (!timespec_equal(&inode->i_mtime, &now)) {
+		sync_it = S_MTIME;
+		inode->i_mtime = now;
+	}
+
+	if (!timespec_equal(&inode->i_ctime, &now)) {
+		sync_it |= S_CTIME;
+		inode->i_ctime = now;
+	}
+
+	if (IS_I_VERSION(inode)) {
+		sync_it |= S_VERSION;
+		inode_inc_iversion(inode);
+	}
+
+	if (!sync_it)
+		return 0;
+
+	might_sleep();
+	err = ext4_get_inode_loc(inode, &iloc);
+	if (err)
+		return err;
+
+	__ext4_update_time(inode, &iloc);
+	down_write(&ei->i_data_sem);
+	ei->is_ts_updated = 1;
+	up_write(&ei->i_data_sem);
+
+	return err;
+}
+
 /*
  * What we do here is to mark the in-core inode as clean with respect to inode
  * dirtiness (it may still be data-dirty).
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 511fbaa..b001f65 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2931,6 +2931,7 @@ extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
 extern ssize_t generic_write_checks(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
+extern ssize_t _generic_file_write_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_direct_write(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_perform_write(struct file *, struct iov_iter *, loff_t);
diff --git a/mm/filemap.c b/mm/filemap.c
index ee83baa..f033c1b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3272,6 +3272,94 @@ ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 EXPORT_SYMBOL(__generic_file_write_iter);
 
 /**
+ * _generic_file_write_iter - write data to a file without timestamp update
+ * @iocb:	IO state structure (file, offset, etc.)
+ * @from:	iov_iter with data to write
+ *
+ * This function does all the work needed for actually writing data to a
+ * file. It does all basic checks, removes SUID from the file, updates
+ * modification times and calls proper subroutines depending on whether we
+ * do direct IO or a standard buffered write.
+ *
+ * It expects i_mutex to be grabbed unless we work on a block device or similar
+ * object which does not need locking at all.
+ *
+ * This function does *not* take care of syncing data in case of O_SYNC write.
+ * A caller has to handle it. This is mainly due to the fact that we want to
+ * avoid syncing under i_mutex.
+ */
+ssize_t _generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct address_space * mapping = file->f_mapping;
+	struct inode 	*inode = mapping->host;
+	ssize_t		written = 0;
+	ssize_t		err;
+	ssize_t		status;
+
+	/* We can write back this queue in page reclaim */
+	current->backing_dev_info = inode_to_bdi(inode);
+	err = file_remove_privs(file);
+	if (err)
+		goto out;
+
+	if (iocb->ki_flags & IOCB_DIRECT) {
+		loff_t pos, endbyte;
+
+		written = generic_file_direct_write(iocb, from);
+		/*
+		 * If the write stopped short of completing, fall back to
+		 * buffered writes.  Some filesystems do this for writes to
+		 * holes, for example.  For DAX files, a buffered write will
+		 * not succeed (even if it did, DAX does not handle dirty
+		 * page-cache pages correctly).
+		 */
+		if (written < 0 || !iov_iter_count(from) || IS_DAX(inode))
+			goto out;
+
+		status = generic_perform_write(file, from, pos = iocb->ki_pos);
+		/*
+		 * If generic_perform_write() returned a synchronous error
+		 * then we want to return the number of bytes which were
+		 * direct-written, or the error code if that was zero.  Note
+		 * that this differs from normal direct-io semantics, which
+		 * will return -EFOO even if some bytes were written.
+		 */
+		if (unlikely(status < 0)) {
+			err = status;
+			goto out;
+		}
+		/*
+		 * We need to ensure that the page cache pages are written to
+		 * disk and invalidated to preserve the expected O_DIRECT
+		 * semantics.
+		 */
+		endbyte = pos + status - 1;
+		err = filemap_write_and_wait_range(mapping, pos, endbyte);
+		if (err == 0) {
+			iocb->ki_pos = endbyte + 1;
+			written += status;
+			invalidate_mapping_pages(mapping,
+						 pos >> PAGE_SHIFT,
+						 endbyte >> PAGE_SHIFT);
+		} else {
+			/*
+			 * We don't know how much we wrote, so just return
+			 * the number of bytes which were direct-written
+			 */
+		}
+	} else {
+		written = generic_perform_write(file, from, iocb->ki_pos);
+		if (likely(written > 0))
+			iocb->ki_pos += written;
+	}
+out:
+	current->backing_dev_info = NULL;
+	return written ? written : err;
+}
+EXPORT_SYMBOL(_generic_file_write_iter);
+
+/**
  * generic_file_write_iter - write data to a file
  * @iocb:	IO state structure
  * @from:	iov_iter with data to write
-- 
2.7.4
