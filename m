From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/8] fs: kill i_alloc_sem
Date: Mon, 20 Jun 2011 16:15:37 -0400
Message-ID: <20110620202031.175620498@bombadil.infradead.org>
References: <20110620201533.847236272@bombadil.infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org
To: viro@zeniv.linux.org.uk, tglx@linutronix.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52962
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296Ab1FTUUg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jun 2011 16:20:36 -0400
Content-Disposition: inline; filename=fs-kill-i_alloc_sem
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

i_alloc_sem is a rather special rw_semaphore.  It's the last one that may
be released by a non-owner, and it's write side is always mirrored by
real exclusion.  It's intended use it to wait for all pending direct I/O
requests to finish before starting a truncate.

Replace it with a hand-grown construct:

 - exclusion for truncates is already guaranteed by i_mutex, so it can
   simply fall way
 - the reader side is replaced by an i_dio_count member in struct inode
   that counts the number of pending direct I/O requests.  Truncate can't
   proceed as long as it's non-zero
 - when i_dio_count reaches non-zero we wake up a pending truncate using
   wake_up_bit on a new bit in i_flags
 - new references to i_dio_count can't appear while we are waiting for
   it to read zero because the direct I/O count always needs i_mutex
   (or an equivalent like XFS's i_iolock) for starting a new operation.

This scheme is much simpler, and saves the space of a spinlock_t and a
struct list_head in struct inode (typically 160 bytes on a non-debug 64-bit
system).

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/direct-io.c
===================================================================
--- linux-2.6.orig/fs/direct-io.c	2011-06-20 14:55:31.000000000 +0200
+++ linux-2.6/fs/direct-io.c	2011-06-20 14:55:34.602490284 +0200
@@ -136,6 +136,27 @@ struct dio {
 };
 
 /*
+ * Wait for outstanding DIO requests to finish.  Must be locked against
+ * increments of i_dio_count by i_mutex.
+ */
+void inode_dio_wait(struct inode *inode)
+{
+	might_sleep();
+	while (atomic_read(&inode->i_dio_count)) {
+		wait_on_bit(&inode->i_state, __I_DIO_WAKEUP, inode_wait,
+			    TASK_UNINTERRUPTIBLE);
+	}
+}
+EXPORT_SYMBOL_GPL(inode_dio_wait);
+
+void inode_dio_wake(struct inode *inode)
+{
+	if (atomic_dec_and_test(&inode->i_dio_count))
+		wake_up_bit(&inode->i_state, __I_DIO_WAKEUP);
+}
+EXPORT_SYMBOL_GPL(inode_dio_wake);
+
+/*
  * How many pages are in the queue?
  */
 static inline unsigned dio_pages_present(struct dio *dio)
@@ -254,9 +275,7 @@ static ssize_t dio_complete(struct dio *
 	}
 
 	if (dio->flags & DIO_LOCKING)
-		/* lockdep: non-owner release */
-		up_read_non_owner(&dio->inode->i_alloc_sem);
-
+		inode_dio_wake(dio->inode);
 	return ret;
 }
 
@@ -980,9 +999,6 @@ out:
 	return ret;
 }
 
-/*
- * Releases both i_mutex and i_alloc_sem
- */
 static ssize_t
 direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode, 
 	const struct iovec *iov, loff_t offset, unsigned long nr_segs, 
@@ -1146,15 +1162,14 @@ direct_io_worker(int rw, struct kiocb *i
  *    For writes this function is called under i_mutex and returns with
  *    i_mutex held, for reads, i_mutex is not held on entry, but it is
  *    taken and dropped again before returning.
- *    For reads and writes i_alloc_sem is taken in shared mode and released
- *    on I/O completion (which may happen asynchronously after returning to
- *    the caller).
+ *    The i_dio_count counter keeps track of the number of outstanding
+ *    direct I/O requests, and truncate waits for it to reach zero.
+ *    New references to i_dio_count must only be grabbed with i_mutex
+ *    held.
  *
  *  - if the flags value does NOT contain DIO_LOCKING we don't use any
  *    internal locking but rather rely on the filesystem to synchronize
  *    direct I/O reads/writes versus each other and truncate.
- *    For reads and writes both i_mutex and i_alloc_sem are not held on
- *    entry and are never taken.
  */
 ssize_t
 __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
@@ -1234,10 +1249,9 @@ __blockdev_direct_IO(int rw, struct kioc
 		}
 
 		/*
-		 * Will be released at I/O completion, possibly in a
-		 * different thread.
+		 * Will be decremented at I/O completion time.
 		 */
-		down_read_non_owner(&inode->i_alloc_sem);
+		atomic_inc(&inode->i_dio_count);
 	}
 
 	/*
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2011-06-20 14:19:27.019266696 +0200
+++ linux-2.6/mm/filemap.c	2011-06-20 14:55:34.605823617 +0200
@@ -78,9 +78,6 @@
  *  ->i_mutex			(generic_file_buffered_write)
  *    ->mmap_sem		(fault_in_pages_readable->do_page_fault)
  *
- *  ->i_mutex
- *    ->i_alloc_sem             (various)
- *
  *  inode_wb_list_lock
  *    sb_lock			(fs/fs-writeback.c)
  *    ->mapping->tree_lock	(__sync_single_inode)
Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c	2011-06-20 14:19:27.000000000 +0200
+++ linux-2.6/mm/rmap.c	2011-06-20 14:55:34.605823617 +0200
@@ -21,7 +21,6 @@
  * Lock ordering in mm:
  *
  * inode->i_mutex	(while writing or truncating, not reading or faulting)
- *   inode->i_alloc_sem (vmtruncate_range)
  *   mm->mmap_sem
  *     page->flags PG_locked (lock_page)
  *       mapping->i_mmap_mutex
Index: linux-2.6/fs/attr.c
===================================================================
--- linux-2.6.orig/fs/attr.c	2011-06-20 14:19:26.000000000 +0200
+++ linux-2.6/fs/attr.c	2011-06-20 14:55:34.609156951 +0200
@@ -233,16 +233,13 @@ int notify_change(struct dentry * dentry
 		return error;
 
 	if (ia_valid & ATTR_SIZE)
-		down_write(&dentry->d_inode->i_alloc_sem);
+		inode_dio_wait(inode);
 
 	if (inode->i_op->setattr)
 		error = inode->i_op->setattr(dentry, attr);
 	else
 		error = simple_setattr(dentry, attr);
 
-	if (ia_valid & ATTR_SIZE)
-		up_write(&dentry->d_inode->i_alloc_sem);
-
 	if (!error)
 		fsnotify_change(dentry, ia_valid);
 
Index: linux-2.6/fs/ntfs/file.c
===================================================================
--- linux-2.6.orig/fs/ntfs/file.c	2011-06-20 14:19:26.000000000 +0200
+++ linux-2.6/fs/ntfs/file.c	2011-06-20 14:55:34.609156951 +0200
@@ -1832,9 +1832,8 @@ static ssize_t ntfs_file_buffered_write(
 	 * fails again.
 	 */
 	if (unlikely(NInoTruncateFailed(ni))) {
-		down_write(&vi->i_alloc_sem);
+		inode_dio_wait(vi);
 		err = ntfs_truncate(vi);
-		up_write(&vi->i_alloc_sem);
 		if (err || NInoTruncateFailed(ni)) {
 			if (!err)
 				err = -EIO;
Index: linux-2.6/fs/reiserfs/xattr.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/xattr.c	2011-06-20 14:19:26.000000000 +0200
+++ linux-2.6/fs/reiserfs/xattr.c	2011-06-20 14:55:34.612490285 +0200
@@ -555,11 +555,10 @@ reiserfs_xattr_set_handle(struct reiserf
 
 		reiserfs_write_unlock(inode->i_sb);
 		mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_XATTR);
-		down_write(&dentry->d_inode->i_alloc_sem);
+		inode_dio_wait(dentry->d_inode);
 		reiserfs_write_lock(inode->i_sb);
 
 		err = reiserfs_setattr(dentry, &newattrs);
-		up_write(&dentry->d_inode->i_alloc_sem);
 		mutex_unlock(&dentry->d_inode->i_mutex);
 	} else
 		update_ctime(inode);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2011-06-20 14:19:27.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2011-06-20 14:55:34.615823619 +0200
@@ -776,7 +776,7 @@ struct inode {
 	struct timespec		i_ctime;
 	blkcnt_t		i_blocks;
 	unsigned short          i_bytes;
-	struct rw_semaphore	i_alloc_sem;
+	atomic_t		i_dio_count;
 	const struct file_operations	*i_fop;	/* former ->i_op->default_file_ops */
 	struct file_lock	*i_flock;
 	struct address_space	*i_mapping;
@@ -1692,6 +1692,10 @@ struct super_operations {
  *			set during data writeback, and cleared with a wakeup
  *			on the bit address once it is done.
  *
+ * I_REFERENCED		Marks the inode as recently references on the LRU list.
+ *
+ * I_DIO_WAKEUP		Never set.  Only used as a key for wait_on_bit().
+ *
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  */
 #define I_DIRTY_SYNC		(1 << 0)
@@ -1705,6 +1709,8 @@ struct super_operations {
 #define __I_SYNC		7
 #define I_SYNC			(1 << __I_SYNC)
 #define I_REFERENCED		(1 << 8)
+#define __I_DIO_WAKEUP		9
+#define I_DIO_WAKEUP		(1 << I_DIO_WAKEUP)
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 
@@ -1815,7 +1821,6 @@ struct file_system_type {
 	struct lock_class_key i_lock_key;
 	struct lock_class_key i_mutex_key;
 	struct lock_class_key i_mutex_dir_key;
-	struct lock_class_key i_alloc_sem_key;
 };
 
 extern struct dentry *mount_ns(struct file_system_type *fs_type, int flags,
@@ -2367,6 +2372,8 @@ enum {
 };
 
 void dio_end_io(struct bio *bio, int error);
+void inode_dio_wait(struct inode *inode);
+void inode_dio_wake(struct inode *inode);
 
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset,
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2011-06-20 14:19:27.000000000 +0200
+++ linux-2.6/mm/memory.c	2011-06-20 14:55:34.619156952 +0200
@@ -2811,12 +2811,11 @@ int vmtruncate_range(struct inode *inode
 		return -ENOSYS;
 
 	mutex_lock(&inode->i_mutex);
-	down_write(&inode->i_alloc_sem);
+	inode_dio_wait(inode);
 	unmap_mapping_range(mapping, offset, (end - offset), 1);
 	truncate_inode_pages_range(mapping, offset, end);
 	unmap_mapping_range(mapping, offset, (end - offset), 1);
 	inode->i_op->truncate_range(inode, offset, end);
-	up_write(&inode->i_alloc_sem);
 	mutex_unlock(&inode->i_mutex);
 
 	return 0;
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2011-06-20 14:19:26.000000000 +0200
+++ linux-2.6/fs/inode.c	2011-06-20 14:55:34.625823618 +0200
@@ -176,8 +176,7 @@ int inode_init_always(struct super_block
 	mutex_init(&inode->i_mutex);
 	lockdep_set_class(&inode->i_mutex, &sb->s_type->i_mutex_key);
 
-	init_rwsem(&inode->i_alloc_sem);
-	lockdep_set_class(&inode->i_alloc_sem, &sb->s_type->i_alloc_sem_key);
+	atomic_set(&inode->i_dio_count, 0);
 
 	mapping->a_ops = &empty_aops;
 	mapping->host = inode;
Index: linux-2.6/fs/ntfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ntfs/inode.c	2011-06-20 14:19:26.000000000 +0200
+++ linux-2.6/fs/ntfs/inode.c	2011-06-20 14:55:34.629156951 +0200
@@ -2357,12 +2357,7 @@ static const char *es = "  Leaving incon
  *
  * Returns 0 on success or -errno on error.
  *
- * Called with ->i_mutex held.  In all but one case ->i_alloc_sem is held for
- * writing.  The only case in the kernel where ->i_alloc_sem is not held is
- * mm/filemap.c::generic_file_buffered_write() where vmtruncate() is called
- * with the current i_size as the offset.  The analogous place in NTFS is in
- * fs/ntfs/file.c::ntfs_file_buffered_write() where we call vmtruncate() again
- * without holding ->i_alloc_sem.
+ * Called with ->i_mutex held.
  */
 int ntfs_truncate(struct inode *vi)
 {
@@ -2887,8 +2882,7 @@ void ntfs_truncate_vfs(struct inode *vi)
  * We also abort all changes of user, group, and mode as we do not implement
  * the NTFS ACLs yet.
  *
- * Called with ->i_mutex held.  For the ATTR_SIZE (i.e. ->truncate) case, also
- * called with ->i_alloc_sem held for writing.
+ * Called with ->i_mutex held.
  */
 int ntfs_setattr(struct dentry *dentry, struct iattr *attr)
 {
Index: linux-2.6/fs/ocfs2/aops.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/aops.c	2011-06-20 14:19:27.000000000 +0200
+++ linux-2.6/fs/ocfs2/aops.c	2011-06-20 14:55:34.629156951 +0200
@@ -551,9 +551,8 @@ bail:
 
 /*
  * ocfs2_dio_end_io is called by the dio core when a dio is finished.  We're
- * particularly interested in the aio/dio case.  Like the core uses
- * i_alloc_sem, we use the rw_lock DLM lock to protect io on one node from
- * truncation on another.
+ * particularly interested in the aio/dio case.  We use the rw_lock DLM lock
+ * to protect io on one node from truncation on another.
  */
 static void ocfs2_dio_end_io(struct kiocb *iocb,
 			     loff_t offset,
@@ -569,7 +568,7 @@ static void ocfs2_dio_end_io(struct kioc
 	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
 
 	if (ocfs2_iocb_is_sem_locked(iocb)) {
-		up_read(&inode->i_alloc_sem);
+		inode_dio_wake(inode);
 		ocfs2_iocb_clear_sem_locked(iocb);
 	}
 
Index: linux-2.6/fs/ocfs2/file.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/file.c	2011-06-20 14:19:27.000000000 +0200
+++ linux-2.6/fs/ocfs2/file.c	2011-06-20 14:55:34.635823617 +0200
@@ -2236,9 +2236,9 @@ static ssize_t ocfs2_file_aio_write(stru
 	ocfs2_iocb_clear_sem_locked(iocb);
 
 relock:
-	/* to match setattr's i_mutex -> i_alloc_sem -> rw_lock ordering */
+	/* to match setattr's i_mutex -> rw_lock ordering */
 	if (direct_io) {
-		down_read(&inode->i_alloc_sem);
+		atomic_inc(&inode->i_dio_count);
 		have_alloc_sem = 1;
 		/* communicate with ocfs2_dio_end_io */
 		ocfs2_iocb_set_sem_locked(iocb);
@@ -2290,7 +2290,7 @@ relock:
 	 */
 	if (direct_io && !can_do_direct) {
 		ocfs2_rw_unlock(inode, rw_level);
-		up_read(&inode->i_alloc_sem);
+		inode_dio_wake(inode);
 
 		have_alloc_sem = 0;
 		rw_level = -1;
@@ -2361,8 +2361,7 @@ out_dio:
 	/*
 	 * deep in g_f_a_w_n()->ocfs2_direct_IO we pass in a ocfs2_dio_end_io
 	 * function pointer which is called when o_direct io completes so that
-	 * it can unlock our rw lock.  (it's the clustered equivalent of
-	 * i_alloc_sem; protects truncate from racing with pending ios).
+	 * it can unlock our rw lock.
 	 * Unfortunately there are error cases which call end_io and others
 	 * that don't.  so we don't have to unlock the rw_lock if either an
 	 * async dio is going to do it in the future or an end_io after an
@@ -2379,7 +2378,7 @@ out:
 
 out_sems:
 	if (have_alloc_sem) {
-		up_read(&inode->i_alloc_sem);
+		inode_dio_wake(inode);
 		ocfs2_iocb_clear_sem_locked(iocb);
 	}
 
@@ -2531,8 +2530,8 @@ static ssize_t ocfs2_file_aio_read(struc
 	 * need locks to protect pending reads from racing with truncate.
 	 */
 	if (filp->f_flags & O_DIRECT) {
-		down_read(&inode->i_alloc_sem);
 		have_alloc_sem = 1;
+		atomic_inc(&inode->i_dio_count);
 		ocfs2_iocb_set_sem_locked(iocb);
 
 		ret = ocfs2_rw_lock(inode, 0);
@@ -2575,7 +2574,7 @@ static ssize_t ocfs2_file_aio_read(struc
 
 bail:
 	if (have_alloc_sem) {
-		up_read(&inode->i_alloc_sem);
+		inode_dio_wake(inode);
 		ocfs2_iocb_clear_sem_locked(iocb);
 	}
 	if (rw_level != -1)
Index: linux-2.6/mm/madvise.c
===================================================================
--- linux-2.6.orig/mm/madvise.c	2011-06-20 14:19:27.000000000 +0200
+++ linux-2.6/mm/madvise.c	2011-06-20 14:55:34.635823617 +0200
@@ -218,7 +218,7 @@ static long madvise_remove(struct vm_are
 	endoff = (loff_t)(end - vma->vm_start - 1)
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
 
-	/* vmtruncate_range needs to take i_mutex and i_alloc_sem */
+	/* vmtruncate_range needs to take i_mutex */
 	up_read(&current->mm->mmap_sem);
 	error = vmtruncate_range(mapping->host, offset, endoff);
 	down_read(&current->mm->mmap_sem);

