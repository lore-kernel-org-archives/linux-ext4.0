From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 13369] kernel BUG at fs/ext4/inode.c:3123
Date: Tue, 26 May 2009 18:46:14 +0530
Message-ID: <20090526131614.GA17880@skywalker>
References: <bug-13369-13602@http.bugzilla.kernel.org/> <200905241920.n4OJKZRG029532@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="V0207lvV8h4k8FAm"
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:53584 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZEZNQ1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 May 2009 09:16:27 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id n4QDGO1G003939
	for <linux-ext4@vger.kernel.org>; Tue, 26 May 2009 18:46:24 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4QDGO8P1769652
	for <linux-ext4@vger.kernel.org>; Tue, 26 May 2009 18:46:24 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id n4QDGNA7004216
	for <linux-ext4@vger.kernel.org>; Tue, 26 May 2009 23:16:24 +1000
Content-Disposition: inline
In-Reply-To: <200905241920.n4OJKZRG029532@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Will you be able to try these patches. They are on top
of stable patch from the ext4 patch queue found at 

http://repo.or.cz/w/ext4-patch-queue.git

Apply the patches upto stable-boundary-undo.patch

Then apply the below five patches. Apply them in the below order.

page_cache_size.patch
1.patch
2.patch
unmap_or_unwritten
ext4_writepage

-aneesh

--V0207lvV8h4k8FAm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="page_cache_size.patch"

ext4: Don't look at buffer_heads outside i_size.

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Buffer heads outside i_size will be unmapped. So when we
are doing "walk_page_buffers" limit ourself to i_size.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6e5caa7..ebf7bb3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2514,7 +2514,7 @@ static int ext4_da_writepage(struct page *page,
 		 * all are mapped and non delay. We don't want to
 		 * do block allocation here.
 		 */
-		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
+		ret = block_prepare_write(page, 0, len,
 					  noalloc_get_block_write);
 		if (!ret) {
 			page_bufs = page_buffers(page);
@@ -2536,7 +2536,7 @@ static int ext4_da_writepage(struct page *page,
 			return 0;
 		}
 		/* now mark the buffer_heads as dirty and uptodate */
-		block_commit_write(page, 0, PAGE_CACHE_SIZE);
+		block_commit_write(page, 0, len);
 	}
 
 	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
@@ -3210,6 +3210,8 @@ static int ext4_normal_writepage(struct page *page,
 static int __ext4_journalled_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
+	loff_t size;
+	unsigned int len;
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
 	struct buffer_head *page_bufs;
@@ -3217,14 +3219,19 @@ static int __ext4_journalled_writepage(struct page *page,
 	int ret = 0;
 	int err;
 
-	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
+	size = i_size_read(inode);
+	if (page->index == size >> PAGE_CACHE_SHIFT)
+		len = size & ~PAGE_CACHE_MASK;
+	else
+		len = PAGE_CACHE_SIZE;
+
+	ret = block_prepare_write(page, 0, len,
 				  noalloc_get_block_write);
 	if (ret != 0)
 		goto out_unlock;
 
 	page_bufs = page_buffers(page);
-	walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE, NULL,
-								bget_one);
+	walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
 	/* As soon as we unlock the page, it can go away, but we have
 	 * references to buffers so we are safe */
 	unlock_page(page);
@@ -3235,19 +3242,19 @@ static int __ext4_journalled_writepage(struct page *page,
 		goto out;
 	}
 
-	ret = walk_page_buffers(handle, page_bufs, 0,
-			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
+	ret = walk_page_buffers(handle, page_bufs, 0, len,
+				NULL, do_journal_get_write_access);
 
-	err = walk_page_buffers(handle, page_bufs, 0,
-				PAGE_CACHE_SIZE, NULL, write_end_fn);
+	err = walk_page_buffers(handle, page_bufs, 0, len,
+				NULL, write_end_fn);
 	if (ret == 0)
 		ret = err;
 	err = ext4_journal_stop(handle);
 	if (!ret)
 		ret = err;
 
-	walk_page_buffers(handle, page_bufs, 0,
-				PAGE_CACHE_SIZE, NULL, bput_one);
+	walk_page_buffers(handle, page_bufs, 0, len,
+				NULL, bput_one);
 	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
 	goto out;
 

--V0207lvV8h4k8FAm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="1.patch"

page_mkwrite() is meant to be used by filesystems to allocate blocks under a

From: Jan Kara <jack@suse.cz>

page which is becoming writeably mmapped in some process address space. This
allows a filesystem to return a page fault if there is not enough space
available, user exceeds quota or similar problem happens, rather than silently
discarding data later when writepage is called.

On filesystems where blocksize < pagesize the situation is more complicated.
Think for example that blocksize = 1024, pagesize = 4096 and a process does:
  ftruncate(fd, 0);
  pwrite(fd, buf, 1024, 0);
  map = mmap(NULL, 4096, PROT_WRITE, MAP_SHARED, fd, 0);
  map[0] = 'a';  ----> page_mkwrite() for index 0 is called
  ftruncate(fd, 10000); /* or even pwrite(fd, buf, 1, 10000) */
  fsync(fd); ----> writepage() for index 0 is called

At the moment page_mkwrite() is called, filesystem can allocate only one block
for the page because i_size == 1024. Otherwise it would create blocks beyond
i_size which is generally undesirable. But later at writepage() time, we would
like to have blocks allocated for the whole page (and in principle we have to
allocate them because user could have filled the page with data after the
second ftruncate()). This patch introduces a framework which allows filesystems
to handle this with a reasonable effort.

The idea is following: Before we extend i_size, we obtain a special lock blocking
page_mkwrite() on the page straddling i_size. Then we writeprotect the page,
change i_size and unlock the special lock. This way, page_mkwrite() is called for
a page each time a number of blocks needed to be allocated for a page increases.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 |  130 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/buffer_head.h |    4 +
 include/linux/fs.h          |   11 +++-
 mm/filemap.c                |   10 +++
 mm/memory.c                 |    2 -
 5 files changed, 153 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index ad01129..2e52b29 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -40,6 +40,7 @@
 #include <linux/cpu.h>
 #include <linux/bitops.h>
 #include <linux/mpage.h>
+#include <linux/rmap.h>
 #include <linux/bit_spinlock.h>
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
@@ -1970,9 +1971,11 @@ int block_write_begin(struct file *file, struct address_space *mapping,
 	page = *pagep;
 	if (page == NULL) {
 		ownpage = 1;
+		block_lock_hole_extend(inode, pos);
 		page = grab_cache_page_write_begin(mapping, index, flags);
 		if (!page) {
 			status = -ENOMEM;
+			block_unlock_hole_extend(inode);
 			goto out;
 		}
 		*pagep = page;
@@ -1987,6 +1990,7 @@ int block_write_begin(struct file *file, struct address_space *mapping,
 			unlock_page(page);
 			page_cache_release(page);
 			*pagep = NULL;
+			block_unlock_hole_extend(inode);
 
 			/*
 			 * prepare_write() may have instantiated a few blocks
@@ -2062,6 +2066,7 @@ int generic_write_end(struct file *file, struct address_space *mapping,
 
 	unlock_page(page);
 	page_cache_release(page);
+	block_unlock_hole_extend(inode);
 
 	/*
 	 * Don't mark the inode dirty under page lock. First, it unnecessarily
@@ -2368,6 +2373,124 @@ int block_commit_write(struct page *page, unsigned from, unsigned to)
 }
 
 /*
+ * Lock inode with I_HOLE_EXTEND if the write is going to create a hole
+ * under a mmapped page. Also mark the page RO so that page_mkwrite()
+ * is called on the nearest write access to the page.
+ *
+ * @pos is offset to which write/truncate is happenning.
+ *
+ * Returns 1 if the lock has been acquired.
+ */
+int block_lock_hole_extend(struct inode *inode, loff_t pos)
+{
+	int bsize = 1 << inode->i_blkbits;
+	loff_t rounded_i_size;
+	struct page *page;
+	pgoff_t index;
+
+	/* Optimize for common case */
+	if (PAGE_CACHE_SIZE == bsize)
+		return 0;
+	/* Currently last page will not have any hole block created? */
+	rounded_i_size = (inode->i_size + bsize - 1) & ~bsize;
+	pos = pos & ~bsize;
+	if (pos <= rounded_i_size || !(rounded_i_size & (PAGE_CACHE_SIZE - 1)))
+		return 0;
+	/*
+	 * Check the mutex here so that we don't warn on things like blockdev
+	 * writes which have different locking rules...
+	 */
+	WARN_ON(!mutex_is_locked(&inode->i_mutex));
+	spin_lock(&inode_lock);
+	/*
+	 * From now on, block_page_mkwrite() will block on the page straddling
+	 * i_size. Note that the page on which it blocks changes with the
+	 * change of i_size but that is fine since when new i_size is written
+	 * blocks for the hole will be allocated.
+	 */
+	inode->i_state |= I_HOLE_EXTEND;
+	spin_unlock(&inode_lock);
+
+	/*
+	 * Make sure page_mkwrite() is called on this page before
+	 * user is able to write any data beyond current i_size via
+	 * mmap.
+	 *
+	 * See clear_page_dirty_for_io() for details why set_page_dirty()
+	 * is needed.
+	 */
+	index = inode->i_size >> PAGE_CACHE_SHIFT;
+	page = find_lock_page(inode->i_mapping, index);
+	if (!page)
+		return 1;
+	if (page_mkclean(page))
+		set_page_dirty(page);
+	unlock_page(page);
+	page_cache_release(page);
+	return 1;
+}
+EXPORT_SYMBOL(block_lock_hole_extend);
+
+/* New i_size creating hole has been written, unlock the inode */
+void block_unlock_hole_extend(struct inode *inode)
+{
+	/*
+	 * We want to clear the flag we could have set previously. Noone else
+	 * can change the flag so lockless read is reliable.
+	 */
+	if (inode->i_state & I_HOLE_EXTEND) {
+		spin_lock(&inode_lock);
+		inode->i_state &= ~I_HOLE_EXTEND;
+		spin_unlock(&inode_lock);
+		/* Prevent speculative execution through spin_unlock */
+		smp_mb();
+		wake_up_bit(&inode->i_state, __I_HOLE_EXTEND);
+	}
+}
+EXPORT_SYMBOL(block_unlock_hole_extend);
+
+void block_extend_i_size(struct inode *inode, loff_t pos, loff_t len)
+{
+	int locked;
+
+	locked = block_lock_hole_extend(inode, pos);
+	i_size_write(inode, pos + len);
+	if (locked)
+		block_unlock_hole_extend(inode);
+}
+EXPORT_SYMBOL(block_extend_i_size);
+
+int block_wait_on_hole_extend(struct inode *inode, loff_t pos)
+{
+	loff_t size;
+	int ret = 0;
+
+restart:
+	size = i_size_read(inode);
+	if (pos > size)
+		return -EINVAL;
+	if (pos + PAGE_CACHE_SIZE < size)
+		return ret;
+	/*
+	 * This page contains EOF; make sure we see i_state from the moment
+	 * after page table modification
+	 */
+	smp_rmb();
+	if (inode->i_state & I_HOLE_EXTEND) {
+		wait_queue_head_t *wqh;
+		DEFINE_WAIT_BIT(wqb, &inode->i_state, __I_HOLE_EXTEND);
+
+		printk("Waiting for extend to finish (%lu).\n", (unsigned long)pos);
+		wqh = bit_waitqueue(&inode->i_state, __I_HOLE_EXTEND);
+		__wait_on_bit(wqh, &wqb, inode_wait, TASK_UNINTERRUPTIBLE);
+		ret = 1;
+		goto restart;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(block_wait_on_hole_extend);
+
+/*
  * block_page_mkwrite() is not allowed to change the file size as it gets
  * called from a page fault handler when a page is first dirtied. Hence we must
  * be careful to check for EOF conditions here. We set the page up correctly
@@ -2392,6 +2515,13 @@ block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	loff_t size;
 	int ret = VM_FAULT_NOPAGE; /* make the VM retry the fault */
 
+	block_wait_on_hole_extend(inode, page_offset(page));
+	/*
+	 * From this moment on a write creating a hole can happen
+	 * without us waiting for it. But because it writeprotects
+	 * the page, user cannot really write to the page until next
+	 * page_mkwrite() is called. And that one will wait.
+	 */
 	lock_page(page);
 	size = i_size_read(inode);
 	if ((page->mapping != inode->i_mapping) ||
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 16ed028..56a0162 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -219,6 +219,10 @@ int cont_write_begin(struct file *, struct address_space *, loff_t,
 			get_block_t *, loff_t *);
 int generic_cont_expand_simple(struct inode *inode, loff_t size);
 int block_commit_write(struct page *page, unsigned from, unsigned to);
+int block_lock_hole_extend(struct inode *inode, loff_t pos);
+void block_unlock_hole_extend(struct inode *inode);
+int block_wait_on_hole_extend(struct inode *inode, loff_t pos);
+void block_extend_i_size(struct inode *inode, loff_t pos, loff_t len);
 int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 				get_block_t get_block);
 void block_sync_page(struct page *);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3b534e5..7cbb0c2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -580,7 +580,7 @@ struct address_space_operations {
 	int (*write_end)(struct file *, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned copied,
 				struct page *page, void *fsdata);
-
+	void (*extend_i_size)(struct inode *, loff_t pos, loff_t len);
 	/* Unfortunately this kludge is needed for FIBMAP. Don't use it */
 	sector_t (*bmap)(struct address_space *, sector_t);
 	void (*invalidatepage) (struct page *, unsigned long);
@@ -597,6 +597,8 @@ struct address_space_operations {
 					unsigned long);
 };
 
+void do_extend_i_size(struct inode *inode, loff_t pos, loff_t len);
+
 /*
  * pagecache_write_begin/pagecache_write_end must be used by general code
  * to write into the pagecache.
@@ -1590,7 +1592,8 @@ struct super_operations {
  * until that flag is cleared.  I_WILL_FREE, I_FREEING and I_CLEAR are set at
  * various stages of removing an inode.
  *
- * Two bits are used for locking and completion notification, I_LOCK and I_SYNC.
+ * Three bits are used for locking and completion notification, I_LOCK,
+ * I_HOLE_EXTEND and I_SYNC.
  *
  * I_DIRTY_SYNC		Inode is dirty, but doesn't have to be written on
  *			fdatasync().  i_atime is the usual cause.
@@ -1628,6 +1631,8 @@ struct super_operations {
  *			of inode dirty data.  Having a separate lock for this
  *			purpose reduces latency and prevents some filesystem-
  *			specific deadlocks.
+ * I_HOLE_EXTEND	A lock synchronizing extension of a file which creates
+ *			a hole under a mmapped page with page_mkwrite().
  *
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  * Q: igrab() only checks on (I_FREEING|I_WILL_FREE).  Should it also check on
@@ -1644,6 +1649,8 @@ struct super_operations {
 #define I_LOCK			(1 << __I_LOCK)
 #define __I_SYNC		8
 #define I_SYNC			(1 << __I_SYNC)
+#define __I_HOLE_EXTEND		9
+#define I_HOLE_EXTEND		(1 << __I_HOLE_EXTEND)
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 379ff0b..a227174 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2079,6 +2079,14 @@ int pagecache_write_end(struct file *file, struct address_space *mapping,
 }
 EXPORT_SYMBOL(pagecache_write_end);
 
+void do_extend_i_size(struct inode *inode, loff_t pos, loff_t len)
+{
+	if (inode->i_mapping->a_ops->extend_i_size)
+		inode->i_mapping->a_ops->extend_i_size(inode, pos, len);
+	else
+		i_size_write(inode, pos + len);
+}
+
 ssize_t
 generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 		unsigned long *nr_segs, loff_t pos, loff_t *ppos,
@@ -2139,7 +2147,7 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 	if (written > 0) {
 		loff_t end = pos + written;
 		if (end > i_size_read(inode) && !S_ISBLK(inode->i_mode)) {
-			i_size_write(inode,  end);
+			do_extend_i_size(inode, pos, written);
 			mark_inode_dirty(inode);
 		}
 		*ppos = end;
diff --git a/mm/memory.c b/mm/memory.c
index 4126dd1..535183d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2377,7 +2377,7 @@ int vmtruncate(struct inode * inode, loff_t offset)
 			goto out_sig;
 		if (offset > inode->i_sb->s_maxbytes)
 			goto out_big;
-		i_size_write(inode, offset);
+		do_extend_i_size(inode, offset, 0);
 	} else {
 		struct address_space *mapping = inode->i_mapping;
 

--V0207lvV8h4k8FAm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="2.patch"

In a situation like:

From: Jan Kara <jack@suse.cz>

truncate(f, 1024);
  a = mmap(f, 0, 4096);
  a[0] = 'a';
  truncate(f, 4096);

we end up with a dirty page which does not have all blocks allocated /
reserved.  Fix the problem by using new VFS infrastructure.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ebf7bb3..f0f0065 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3469,6 +3469,7 @@ static int ext4_journalled_set_page_dirty(struct page *page)
 	.sync_page		= block_sync_page,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_ordered_write_end,
+	.extend_i_size		= block_extend_i_size,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_invalidatepage,
 	.releasepage		= ext4_releasepage,
@@ -3484,6 +3485,7 @@ static int ext4_journalled_set_page_dirty(struct page *page)
 	.sync_page		= block_sync_page,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_writeback_write_end,
+	.extend_i_size		= block_extend_i_size,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_invalidatepage,
 	.releasepage		= ext4_releasepage,
@@ -3499,6 +3501,7 @@ static int ext4_journalled_set_page_dirty(struct page *page)
 	.sync_page		= block_sync_page,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_journalled_write_end,
+	.extend_i_size		= block_extend_i_size,
 	.set_page_dirty		= ext4_journalled_set_page_dirty,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_invalidatepage,
@@ -3514,6 +3517,7 @@ static int ext4_journalled_set_page_dirty(struct page *page)
 	.sync_page		= block_sync_page,
 	.write_begin		= ext4_da_write_begin,
 	.write_end		= ext4_da_write_end,
+	.extend_i_size		= block_extend_i_size,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_da_invalidatepage,
 	.releasepage		= ext4_releasepage,
@@ -5379,6 +5383,12 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct address_space *mapping = inode->i_mapping;
 
 	/*
+	 * Wait for extending of i_size, after this moment, next truncate /
+	 * write can create holes under us but they writeprotect our page so
+	 * we'll be called again to fill the hole.
+	 */
+	block_wait_on_hole_extend(inode, page_offset(page));
+	/*
 	 * Get i_alloc_sem to stop truncates messing with the inode. We cannot
 	 * get i_mutex because we are already holding mmap_sem.
 	 */

--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=unmap_or_unwritten

ext4: Check for only delay or unwritten buffer_heads

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f0f0065..1efb296 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2239,15 +2239,9 @@ static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
 	return;
 }
 
-static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
+static int ext4_bh_delay_or_unwritten(handle_t *handle, struct buffer_head *bh)
 {
-	/*
-	 * unmapped buffer is possible for holes.
-	 * delay buffer is possible with delayed allocation.
-	 * We also need to consider unwritten buffer as unmapped.
-	 */
-	return (!buffer_mapped(bh) || buffer_delay(bh) ||
-				buffer_unwritten(bh)) && buffer_dirty(bh);
+	return (buffer_delay(bh) || buffer_unwritten(bh)) && buffer_dirty(bh);
 }
 
 /*
@@ -2334,7 +2328,7 @@ static int __mpage_da_writepage(struct page *page,
 			 * Otherwise we won't make progress
 			 * with the page in ext4_da_writepage
 			 */
-			if (ext4_bh_unmapped_or_delay(NULL, bh)) {
+			if (ext4_bh_delay_or_unwritten(NULL, bh)) {
 				mpage_add_bh_to_extent(mpd, logical,
 						       bh->b_size,
 						       bh->b_state);
@@ -2451,7 +2445,6 @@ static int noalloc_get_block_write(struct inode *inode, sector_t iblock,
 	 * so call get_block_wrap with create = 0
 	 */
 	ret = ext4_get_blocks(NULL, inode, iblock, max_blocks, bh_result, 0);
-	BUG_ON(create && ret == 0);
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 		ret = 0;
@@ -2487,7 +2480,7 @@ static int ext4_da_writepage(struct page *page,
 	if (page_has_buffers(page)) {
 		page_bufs = page_buffers(page);
 		if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
-					ext4_bh_unmapped_or_delay)) {
+					ext4_bh_delay_or_unwritten)) {
 			/*
 			 * We don't want to do  block allocation
 			 * So redirty the page and return
@@ -2520,7 +2513,7 @@ static int ext4_da_writepage(struct page *page,
 			page_bufs = page_buffers(page);
 			/* check whether all are mapped and non delay */
 			if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
-						ext4_bh_unmapped_or_delay)) {
+						ext4_bh_delay_or_unwritten)) {
 				redirty_page_for_writepage(wbc, page);
 				unlock_page(page);
 				return 0;
@@ -3196,7 +3189,7 @@ static int ext4_normal_writepage(struct page *page,
 		 * happily proceed with mapping them and writing the page.
 		 */
 		BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
-					ext4_bh_unmapped_or_delay));
+					ext4_bh_delay_or_unwritten));
 	}
 
 	if (!ext4_journal_current_handle())
@@ -3291,7 +3284,7 @@ static int ext4_journalled_writepage(struct page *page,
 		 * happily proceed with mapping them and writing the page.
 		 */
 		BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
-					ext4_bh_unmapped_or_delay));
+					ext4_bh_delay_or_unwritten));
 	}
 
 	if (ext4_journal_current_handle())

--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=ext4_writepage

ext4: Add generic writepage callback

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

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

--V0207lvV8h4k8FAm--
