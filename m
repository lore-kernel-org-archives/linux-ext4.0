From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] ext4: serialize unaligned asynchronous DIO
Date: Fri, 14 Jan 2011 11:28:46 -0600
Message-ID: <4D3087CE.2060200@redhat.com>
References: <4D2F7B52.1040209@redhat.com> <20110114041514.GI31800@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757647Ab1ANR2t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Jan 2011 12:28:49 -0500
In-Reply-To: <20110114041514.GI31800@thunk.org>
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

Mingming suggested that perhaps we can track outstanding
conversions, and wait on that instead so that non-sparse
files won't be affected, but I've had trouble making that
work so far, and would like to get the corruption hole
plugged ASAP.  Perhaps adding a prink_once() warning of
the perf degradation on this path would be useful?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Add comments and daily printk

Index: linux-2.6/fs/ext4/ext4.h
===================================================================
--- linux-2.6.orig/fs/ext4/ext4.h
+++ linux-2.6/fs/ext4/ext4.h
@@ -848,6 +848,7 @@ struct ext4_inode_info {
 	atomic_t i_ioend_count;	/* Number of outstanding io_end structs */
 	/* current io_end structure for async DIO write*/
 	ext4_io_end_t *cur_aio_dio;
+	struct mutex i_aio_mutex; /* big hammer for unaligned AIO */
 
 	spinlock_t i_block_reservation_lock;
 
Index: linux-2.6/fs/ext4/file.c
===================================================================
--- linux-2.6.orig/fs/ext4/file.c
+++ linux-2.6/fs/ext4/file.c
@@ -55,11 +55,42 @@ static int ext4_release_file(struct inod
 	return 0;
 }
 
+/*
+ * This tests whether the IO in question is block-aligned or
+ * not.  ext4 utilizes unwritten extents when hole-filling
+ * during direct IO, and they are converted to written only
+ * after the IO is complete.  Until they are mapped, these
+ * blocks appear as holes, so dio_zero_block() will assume
+ * that it needs to zero out portions of the start and/or
+ * end block.  If 2 AIO threads are at work on the same block,
+ * they must be synchronized or one thread will zero the others'
+ * data, causing corruption.
+ */
+static int
+ext4_unaligned_aio(struct inode *inode, const struct iovec *iov,
+		unsigned long nr_segs, loff_t pos)
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
@@ -78,9 +109,30 @@ ext4_file_write(struct kiocb *iocb, cons
 			nr_segs = iov_shorten((struct iovec *)iov, nr_segs,
 					      sbi->s_bitmap_maxbytes - pos);
 		}
+	} else if (unlikely((iocb->ki_filp->f_flags & O_DIRECT) &&
+		            !is_sync_kiocb(iocb)))
+		unaligned_aio = ext4_unaligned_aio(inode, iov, nr_segs, pos);
+
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
+		ext4_ioend_wait(inode);
 	}
 
-	return generic_file_aio_write(iocb, iov, nr_segs, pos);
+	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
+
+	if (unaligned_aio)
+		mutex_unlock(&EXT4_I(inode)->i_aio_mutex);
+
+	return ret;
 }
 
 static const struct vm_operations_struct ext4_file_vm_ops = {
Index: linux-2.6/fs/ext4/super.c
===================================================================
--- linux-2.6.orig/fs/ext4/super.c
+++ linux-2.6/fs/ext4/super.c
@@ -875,6 +875,7 @@ static void init_once(void *foo)
 	init_rwsem(&ei->xattr_sem);
 #endif
 	init_rwsem(&ei->i_data_sem);
+	mutex_init(&ei->i_aio_mutex);
 	inode_init_once(&ei->vfs_inode);
 }
 

