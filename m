From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V3 RESEND 2] ext4: serialize unaligned asynchronous DIO
Date: Fri, 21 Jan 2011 12:26:54 -0600
Message-ID: <4D39CFEE.6070403@redhat.com>
References: <4D2F7B52.1040209@redhat.com> <20110114041514.GI31800@thunk.org> <4D3087CE.2060200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab1AUS05 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jan 2011 13:26:57 -0500
In-Reply-To: <4D3087CE.2060200@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4 has a data corruption case when doing non-block-aligned
asynchronous direct IO into a sparse file, as demonstrated
by xfstest 240.

The root cause is that while ext4 preallocates space in the
hole, mappings of that space still look "new" and 
dio_zero_block() will zero out the unwritten portions.  When
more than one AIO thread is going, they both find this "new"
block and race to zero out their portion; this is uncoordinated
and causes data corruption.

Dave Chinner fixed this for xfs by simply serializing all
unaligned asynchronous direct IO.  I've done the same here.
The difference is that we only wait on conversions, not all IO.
This is a very big hammer, and I'm not very pleased with
stuffing this into ext4_file_write().  But since ext4 is
DIO_LOCKING, we need to serialize it at this high level.

I tried to move this into ext4_ext_direct_IO, but by then
we have the i_mutex already, and we will wait on the
work queue to do conversions - which must also take the
i_mutex.  So that won't work.

This was originally exposed by qemu-kvm installing to
a raw disk image with a normal sector-63 alignment.  I've
tested a backport of this patch with qemu, and it does
avoid the corruption.  It is also quite a lot slower
(14 min for package installs, vs. 8 min for well-aligned)
but I'll take slow correctness over fast corruption any day.

Mingming suggested that we can track outstanding
conversions, and wait on those so that non-sparse
files won't be affected, and I've implemented that here;
unaligned AIO to nonsparse files won't take a perf hit.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Add comments and daily printk
V3: Only do serialization when there are outstanding conversions

Index: linux-2.6-bisect/fs/ext4/ext4.h
===================================================================
--- linux-2.6-bisect.orig/fs/ext4/ext4.h
+++ linux-2.6-bisect/fs/ext4/ext4.h
@@ -859,6 +859,8 @@ struct ext4_inode_info {
 	/* current io_end structure for async DIO write*/
 	ext4_io_end_t *cur_aio_dio;
 	atomic_t i_ioend_count;	/* Number of outstanding io_end structs */
+	atomic_t i_aiodio_unwritten; /* Nr. of inflight conversions pending */
+	struct mutex i_aio_mutex; /* big hammer for unaligned AIO */
 
 	/*
 	 * Transactions that contain inode's metadata needed to complete
@@ -2100,6 +2102,11 @@ static inline void set_bitmap_uptodate(s
 
 #define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
 
+/* For ioend & aio unwritten conversion wait queues */
+#define WQ_HASH_SZ		37
+#define to_ioend_wq(v)	(&ioend_wq[((unsigned long)v) % WQ_HASH_SZ])
+extern wait_queue_head_t ioend_wq[WQ_HASH_SZ];
+
 #endif	/* __KERNEL__ */
 
 #endif	/* _EXT4_H */
Index: linux-2.6-bisect/fs/ext4/extents.c
===================================================================
--- linux-2.6-bisect.orig/fs/ext4/extents.c
+++ linux-2.6-bisect/fs/ext4/extents.c
@@ -3154,9 +3154,10 @@ ext4_ext_handle_uninitialized_extents(ha
 		 * that this IO needs to convertion to written when IO is
 		 * completed
 		 */
-		if (io)
+		if (io && !(io->flag & EXT4_IO_END_UNWRITTEN)) {
 			io->flag = EXT4_IO_END_UNWRITTEN;
-		else
+			atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
+		} else
 			ext4_set_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN);
 		if (ext4_should_dioread_nolock(inode))
 			map->m_flags |= EXT4_MAP_UNINIT;
@@ -3446,9 +3447,10 @@ int ext4_ext_map_blocks(handle_t *handle
 		 * that we need to perform convertion when IO is done.
 		 */
 		if ((flags & EXT4_GET_BLOCKS_PRE_IO)) {
-			if (io)
+			if (io && !(io->flag & EXT4_IO_END_UNWRITTEN)) {
 				io->flag = EXT4_IO_END_UNWRITTEN;
-			else
+				atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
+			} else
 				ext4_set_inode_state(inode,
 						     EXT4_STATE_DIO_UNWRITTEN);
 		}
Index: linux-2.6-bisect/fs/ext4/file.c
===================================================================
--- linux-2.6-bisect.orig/fs/ext4/file.c
+++ linux-2.6-bisect/fs/ext4/file.c
@@ -55,11 +55,47 @@ static int ext4_release_file(struct inod
 	return 0;
 }
 
+static void ext4_aiodio_wait(struct inode *inode)
+{
+	wait_queue_head_t *wq = to_ioend_wq(inode);
+
+	wait_event(*wq, (atomic_read(&EXT4_I(inode)->i_aiodio_unwritten) == 0));
+}
+
+/*
+ * This tests whether the IO in question is block-aligned or not.
+ * Ext4 utilizes unwritten extents when hole-filling during direct IO, and they
+ * are converted to written only after the IO is complete.  Until they are
+ * mapped, these blocks appear as holes, so dio_zero_block() will assume that
+ * it needs to zero out portions of the start and/or end block.  If 2 AIO
+ * threads are at work on the same unwritten block, they must be synchronized
+ * or one thread will zero the other's data, causing corruption.
+ */
+static int 
+ext4_unaligned_aio(struct inode *inode, const struct iovec *iov,
+		   unsigned long nr_segs, loff_t pos)
+{
+	struct super_block *sb = inode->i_sb;
+	int blockmask = sb->s_blocksize - 1;
+	size_t count = iov_length(iov, nr_segs);
+	loff_t final_size = pos + count;
+
+	if (pos >= inode->i_size)
+		return 0;
+
+	if ((pos & blockmask) || (final_size & blockmask))
+		return 1;
+
+	return 0;
+}
+
 static ssize_t
 ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 		unsigned long nr_segs, loff_t pos)
 {
 	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
+	int unaligned_aio = 0;
+	int ret;
 
 	/*
 	 * If we have encountered a bitmap-format file, the size limit
@@ -78,9 +114,31 @@ ext4_file_write(struct kiocb *iocb, cons
 			nr_segs = iov_shorten((struct iovec *)iov, nr_segs,
 					      sbi->s_bitmap_maxbytes - pos);
 		}
+	} else if (unlikely((iocb->ki_filp->f_flags & O_DIRECT) &&
+		   !is_sync_kiocb(iocb))) {
+		unaligned_aio = ext4_unaligned_aio(inode, iov, nr_segs, pos);
 	}
 
-	return generic_file_aio_write(iocb, iov, nr_segs, pos);
+	/* Unaligned direct AIO must be serialized; see comment above */
+	if (unaligned_aio) {
+		static unsigned long unaligned_warn_time;
+
+		/* Warn about this once per day */
+		if (printk_timed_ratelimit(&unaligned_warn_time, 60*60*24*HZ))
+			ext4_msg(inode->i_sb, KERN_WARNING,
+				 "Unaligned AIO/DIO on inode %ld by %s; "
+				 "performance will be poor.",
+				 inode->i_ino, current->comm);
+		mutex_lock(&EXT4_I(inode)->i_aio_mutex);
+		ext4_aiodio_wait(inode);
+ 	}
+
+	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
+
+	if (unaligned_aio)
+		mutex_unlock(&EXT4_I(inode)->i_aio_mutex);
+
+	return ret;
 }
 
 static const struct vm_operations_struct ext4_file_vm_ops = {
Index: linux-2.6-bisect/fs/ext4/page-io.c
===================================================================
--- linux-2.6-bisect.orig/fs/ext4/page-io.c
+++ linux-2.6-bisect/fs/ext4/page-io.c
@@ -32,9 +32,7 @@
 
 static struct kmem_cache *io_page_cachep, *io_end_cachep;
 
-#define WQ_HASH_SZ		37
-#define to_ioend_wq(v)	(&ioend_wq[((unsigned long)v) % WQ_HASH_SZ])
-static wait_queue_head_t ioend_wq[WQ_HASH_SZ];
+wait_queue_head_t ioend_wq[WQ_HASH_SZ];
 
 int __init ext4_init_pageio(void)
 {
@@ -102,6 +100,7 @@ int ext4_end_io_nolock(ext4_io_end_t *io
 	struct inode *inode = io->inode;
 	loff_t offset = io->offset;
 	ssize_t size = io->size;
+	wait_queue_head_t *wq;
 	int ret = 0;
 
 	ext4_debug("ext4_end_io_nolock: io 0x%p from inode %lu,list->next 0x%p,"
@@ -126,7 +125,16 @@ int ext4_end_io_nolock(ext4_io_end_t *io
 	if (io->iocb)
 		aio_complete(io->iocb, io->result, 0);
 	/* clear the DIO AIO unwritten flag */
-	io->flag &= ~EXT4_IO_END_UNWRITTEN;
+	if (io->flag & EXT4_IO_END_UNWRITTEN) {
+		io->flag &= ~EXT4_IO_END_UNWRITTEN;
+		/* Wake up anyone waiting on unwritten extent conversion */
+		wq = to_ioend_wq(io->inode);
+		if (atomic_dec_and_test(&EXT4_I(inode)->i_aiodio_unwritten) &&
+		    waitqueue_active(wq)) {
+			wake_up_all(wq);
+		}
+	}
+
 	return ret;
 }
 
Index: linux-2.6-bisect/fs/ext4/super.c
===================================================================
--- linux-2.6-bisect.orig/fs/ext4/super.c
+++ linux-2.6-bisect/fs/ext4/super.c
@@ -829,6 +829,7 @@ static struct inode *ext4_alloc_inode(st
 	ei->i_sync_tid = 0;
 	ei->i_datasync_tid = 0;
 	atomic_set(&ei->i_ioend_count, 0);
+	atomic_set(&ei->i_aiodio_unwritten, 0);
 
 	return &ei->vfs_inode;
 }
@@ -865,6 +866,7 @@ static void init_once(void *foo)
 	init_rwsem(&ei->xattr_sem);
 #endif
 	init_rwsem(&ei->i_data_sem);
+	mutex_init(&ei->i_aio_mutex);
 	inode_init_once(&ei->vfs_inode);
 }
 


