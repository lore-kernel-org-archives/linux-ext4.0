From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/8] fs: always maintain i_dio_count
Date: Mon, 20 Jun 2011 16:15:39 -0400
Message-ID: <20110620202031.567119520@bombadil.infradead.org>
References: <20110620201533.847236272@bombadil.infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org
To: viro@zeniv.linux.org.uk, tglx@linutronix.de
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline; filename=fs-generalize-dio_count
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Maintain i_dio_count for all filesystems, not just those using DIO_LOCKING.
This these filesystems to also protect truncate against direct I/O requests
by using common code.  Right now the only non-DIO_LOCKING filesystem that
appears to do so is XFS, which uses an opencoded variant of the i_dio_count
scheme.

Behaviour doesn't change for filesystems never calling inode_dio_wait,
which are all that never use DIO_LOCKING.

For ext4 behaviour changes with the dioread_nonlock option, which previous
was missing any protection between truncate and direct I/O reads.

For ocfs2 that handcrafted i_dio_count manipulations are replaced with
the common code noew available.

As a result inode_dio_wake can now be made static in direct-io.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/direct-io.c
===================================================================
--- linux-2.6.orig/fs/direct-io.c	2011-06-20 14:55:34.602490284 +0200
+++ linux-2.6/fs/direct-io.c	2011-06-20 14:57:24.575818051 +0200
@@ -149,12 +149,11 @@ void inode_dio_wait(struct inode *inode)
 }
 EXPORT_SYMBOL_GPL(inode_dio_wait);
 
-void inode_dio_wake(struct inode *inode)
+static inline void inode_dio_wake(struct inode *inode)
 {
 	if (atomic_dec_and_test(&inode->i_dio_count))
 		wake_up_bit(&inode->i_state, __I_DIO_WAKEUP);
 }
-EXPORT_SYMBOL_GPL(inode_dio_wake);
 
 /*
  * How many pages are in the queue?
@@ -274,8 +273,7 @@ static ssize_t dio_complete(struct dio *
 		aio_complete(dio->iocb, ret, 0);
 	}
 
-	if (dio->flags & DIO_LOCKING)
-		inode_dio_wake(dio->inode);
+	inode_dio_wake(dio->inode);
 	return ret;
 }
 
@@ -1162,14 +1160,16 @@ direct_io_worker(int rw, struct kiocb *i
  *    For writes this function is called under i_mutex and returns with
  *    i_mutex held, for reads, i_mutex is not held on entry, but it is
  *    taken and dropped again before returning.
- *    The i_dio_count counter keeps track of the number of outstanding
- *    direct I/O requests, and truncate waits for it to reach zero.
- *    New references to i_dio_count must only be grabbed with i_mutex
- *    held.
- *
  *  - if the flags value does NOT contain DIO_LOCKING we don't use any
  *    internal locking but rather rely on the filesystem to synchronize
  *    direct I/O reads/writes versus each other and truncate.
+ *
+ * To help with locking against truncate we incremented the i_dio_count
+ * counter before starting direct I/O, and decrement it once we are done.
+ * Truncate can wait for it to reach zero to provide exclusion.  It is
+ * expected that filesystem provide exclusion between new direct I/O
+ * and truncates.  For DIO_LOCKING filesystems this is done by i_mutex,
+ * but other filesystems need to take care of this on their own.
  */
 ssize_t
 __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
@@ -1247,14 +1247,14 @@ __blockdev_direct_IO(int rw, struct kioc
 				goto out;
 			}
 		}
-
-		/*
-		 * Will be decremented at I/O completion time.
-		 */
-		atomic_inc(&inode->i_dio_count);
 	}
 
 	/*
+	 * Will be decremented at I/O completion time.
+	 */
+	atomic_inc(&inode->i_dio_count);
+
+	/*
 	 * For file extending writes updating i_size before data
 	 * writeouts complete can expose uninitialized blocks. So
 	 * even for AIO, we need to wait for i/o to complete before
Index: linux-2.6/fs/ocfs2/aops.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/aops.c	2011-06-20 14:55:34.629156951 +0200
+++ linux-2.6/fs/ocfs2/aops.c	2011-06-20 14:56:59.259152666 +0200
@@ -567,10 +567,8 @@ static void ocfs2_dio_end_io(struct kioc
 	/* this io's submitter should not have unlocked this before we could */
 	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
 
-	if (ocfs2_iocb_is_sem_locked(iocb)) {
-		inode_dio_wake(inode);
+	if (ocfs2_iocb_is_sem_locked(iocb))
 		ocfs2_iocb_clear_sem_locked(iocb);
-	}
 
 	ocfs2_iocb_clear_rw_locked(iocb);
 
Index: linux-2.6/fs/ocfs2/file.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/file.c	2011-06-20 14:56:55.375819530 +0200
+++ linux-2.6/fs/ocfs2/file.c	2011-06-20 14:56:59.262485999 +0200
@@ -2240,7 +2240,6 @@ static ssize_t ocfs2_file_aio_write(stru
 relock:
 	/* to match setattr's i_mutex -> rw_lock ordering */
 	if (direct_io) {
-		atomic_inc(&inode->i_dio_count);
 		have_alloc_sem = 1;
 		/* communicate with ocfs2_dio_end_io */
 		ocfs2_iocb_set_sem_locked(iocb);
@@ -2292,7 +2291,6 @@ relock:
 	 */
 	if (direct_io && !can_do_direct) {
 		ocfs2_rw_unlock(inode, rw_level);
-		inode_dio_wake(inode);
 
 		have_alloc_sem = 0;
 		rw_level = -1;
@@ -2379,10 +2377,8 @@ out:
 		ocfs2_rw_unlock(inode, rw_level);
 
 out_sems:
-	if (have_alloc_sem) {
-		inode_dio_wake(inode);
+	if (have_alloc_sem)
 		ocfs2_iocb_clear_sem_locked(iocb);
-	}
 
 	mutex_unlock(&inode->i_mutex);
 
@@ -2533,7 +2529,6 @@ static ssize_t ocfs2_file_aio_read(struc
 	 */
 	if (filp->f_flags & O_DIRECT) {
 		have_alloc_sem = 1;
-		atomic_inc(&inode->i_dio_count);
 		ocfs2_iocb_set_sem_locked(iocb);
 
 		ret = ocfs2_rw_lock(inode, 0);
@@ -2575,10 +2570,9 @@ static ssize_t ocfs2_file_aio_read(struc
 	}
 
 bail:
-	if (have_alloc_sem) {
-		inode_dio_wake(inode);
+	if (have_alloc_sem)
 		ocfs2_iocb_clear_sem_locked(iocb);
-	}
+
 	if (rw_level != -1)
 		ocfs2_rw_unlock(inode, rw_level);
 
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2011-06-20 14:57:08.582485528 +0200
+++ linux-2.6/include/linux/fs.h	2011-06-20 14:57:10.099152117 +0200
@@ -2373,7 +2373,6 @@ enum {
 
 void dio_end_io(struct bio *bio, int error);
 void inode_dio_wait(struct inode *inode);
-void inode_dio_wake(struct inode *inode);
 
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset,

