From: Mingming <cmm@us.ibm.com>
Subject: [RFC,PATCH 1/2] Direct IO for holes and fallocate
Date: Mon, 10 Aug 2009 08:00:27 -0700
Message-ID: <1249916427.4337.32.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Curt Wohlgemuth <curtw@google.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:50912 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbZHJPAm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Aug 2009 11:00:42 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7AEuovF022512
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 08:56:51 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7AF0bEf181154
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 09:00:37 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7AF0WWL012053
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 09:00:34 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently DIO VFS code passes create = 0 flag for write to the middle of
file. It does this to avoid block allocation for holes, to prevent
expose stale data out when there is parallel buffered read (which does
not hold the i_mutex lock) while direct IO write has not completed. DIO
request on holes finally falls back to buffered IO for this reason.

Since preallocated extents are treated as holes when do a get_block()
look up (buffer is not mapped), thus direct IO over fallocate also falls
back to buffered IO. Thus ext4 actually silently falls back to buffered
IO in above two cases.

The basic idea to fix the direct IO on fallocate issue is to map the
fallocated extents on direct IO write before submit the IO, but wait
until the direct IO complete then convert the unwritten extent to
written extent, using an end_io call back function. We will need to
split the unwritten extents before submit the IO to prevent later
ENOSPC, and when IO complete, just mark the written part initialized.

With the end_io call back function, now it's possible to do direct IO on
holes. For ext4 extent based file, since we support fallocate, we could
fallocate blocks for holes, mark it mapped but unwritten. This way
parallel buffered IO read returns zeros when parallel DIO write to the
hole has not completed. When direct IO write complete, using the same
end_io schemem to convert those fallocated hole to written extents.

For direct IO write to the end of file, we now also could get rid of
using orphan list to protect expose stale data out after crash, when
direct write to end of file isn't complete. We now fallocate blocks for
the direct IO write to the end of file as well, and convert those
fallocated blocks at the end of file to written when IO is complete. If
fs crashed before the IO complete, it will only seen the file tail has
been fallocated but won't get the stale data out.


1) Block allocation needed for DIO write are fallocated, including holes
and file tail write, marked as unwritten extents after block allocation.

2) those unwritten extents, and fallocate extents, will be converted to
written extents (and update disk size when write to end of file)when the
IO is complete. The conversion is triggered using end_io call back
function passing from ext4 fs to direct IO.

3) For already fallocated extent, at the time try to map the fallocated
extent, we will split the fallocated extent as necessary, mark the
to-write fallocated extent mapped but still remains unwritten,
insert the splitted extents, to prevent ENOSPC later.

This first patch does 1) and 2), the second patch does 3)

Patch against ext4 patch queue.

Comments? 

Singed-Off-By: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/ext4.h  |   18 ++++
 fs/ext4/inode.c |  211 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/super.c |   11 ++
 3 files changed, 237 insertions(+), 3 deletions(-)

Index: linux-2.6.31-rc4/fs/ext4/ext4.h
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/ext4.h	2009-08-09 14:46:10.000000000 -0700
+++ linux-2.6.31-rc4/fs/ext4/ext4.h	2009-08-09 23:13:15.000000000 -0700
@@ -111,6 +111,15 @@ struct ext4_allocation_request {
 	unsigned int flags;
 };
 
+typedef struct ext4_io_end{
+	struct inode		*inode;		/* file being written to */
+	unsigned int		type;		/* unwritten or written */
+	int			error;		/* I/O error code */
+	ext4_lblk_t		offset;		/* offset in the file */
+	size_t			size;		/* size of the extent */
+	struct work_struct	work;		/* data work queue */
+}ext4_io_end_t;
+
 /*
  * Special inodes numbers
  */
@@ -330,8 +339,8 @@ struct ext4_new_group_data {
 	/* Call ext4_da_update_reserve_space() after successfully 
 	   allocating the blocks */
 #define EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE	0x0008
-
-
+#define EXT4_GET_BLOCKS_DIO_CREATE_EXT		0x0011
+#define EXT4_GET_BLOCKS_DIO_CONVERT_EXT		0x0021
 /*
  * ioctl commands
  */
@@ -960,6 +969,9 @@ struct ext4_sb_info {
 
 	unsigned int s_log_groups_per_flex;
 	struct flex_groups *s_flex_groups;
+
+	/* workqueue for dio unwritten */
+	struct workqueue_struct *dio_unwritten_wq;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
@@ -1650,6 +1662,8 @@ extern void ext4_ext_init(struct super_b
 extern void ext4_ext_release(struct super_block *);
 extern long ext4_fallocate(struct inode *inode, int mode, loff_t offset,
 			  loff_t len);
+extern int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
+			  loff_t len);
 extern int ext4_get_blocks(handle_t *handle, struct inode *inode,
 			   sector_t block, unsigned int max_blocks,
 			   struct buffer_head *bh, int flags);
Index: linux-2.6.31-rc4/fs/ext4/super.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/super.c	2009-08-09 14:51:08.000000000 -0700
+++ linux-2.6.31-rc4/fs/ext4/super.c	2009-08-09 14:51:14.000000000 -0700
@@ -578,6 +578,9 @@ static void ext4_put_super(struct super_
 	struct ext4_super_block *es = sbi->s_es;
 	int i, err;
 
+	flush_workqueue(sbi->dio_unwritten_wq);
+	destroy_workqueue(sbi->dio_unwritten_wq);
+
 	lock_super(sb);
 	lock_kernel();
 	if (sb->s_dirt)
@@ -2781,6 +2784,12 @@ no_journal:
 			clear_opt(sbi->s_mount_opt, NOBH);
 		}
 	}
+	EXT4_SB(sb)->dio_unwritten_wq = create_workqueue("ext4-dio-unwritten");
+	if (!EXT4_SB(sb)->dio_unwritten_wq) {
+		printk(KERN_ERR "EXT4-fs: failed to create DIO workqueue\n");
+		goto failed_mount_wq;
+	}
+
 	/*
 	 * The jbd2_journal_load will have done any necessary log recovery,
 	 * so we can safely mount the rest of the filesystem now.
@@ -2893,6 +2902,8 @@ cantfind_ext4:
 
 failed_mount4:
 	ext4_msg(sb, KERN_ERR, "mount failed");
+	destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
+failed_mount_wq:
 	ext4_release_system_zone(sb);
 	if (sbi->s_journal) {
 		jbd2_journal_destroy(sbi->s_journal);
Index: linux-2.6.31-rc4/fs/ext4/inode.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/inode.c	2009-08-09 14:46:32.000000000 -0700
+++ linux-2.6.31-rc4/fs/ext4/inode.c	2009-08-09 14:56:40.000000000 -0700
@@ -37,6 +37,7 @@
 #include <linux/namei.h>
 #include <linux/uio.h>
 #include <linux/bio.h>
+#include <linux/workqueue.h>
 
 #include "ext4_jbd2.h"
 #include "xattr.h"
@@ -3279,6 +3280,8 @@ static int ext4_releasepage(struct page 
 }
 
 /*
+ * O_DIRECT for ext3 (or indirect map) based files
+ *
  * If the O_DIRECT write will extend the file then add this inode to the
  * orphan list.  So recovery will truncate it back to the original size
  * if the machine crashes during the write.
@@ -3287,7 +3290,7 @@ static int ext4_releasepage(struct page 
  * crashes then stale disk data _may_ be exposed inside the file. But current
  * VFS code falls back into buffered path in that case so we are safe.
  */
-static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
+static ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 			      const struct iovec *iov, loff_t offset,
 			      unsigned long nr_segs)
 {
@@ -3361,6 +3364,212 @@ out:
 	return ret;
 }
 
+struct workqueue_struct *ext4_unwritten_queue;
+
+/* Maximum number of blocks we map for direct IO at once. */
+
+static int ext4_get_block_dio_write(struct inode *inode, sector_t iblock,
+		   struct buffer_head *bh_result, int create)
+{
+	handle_t *handle = NULL;
+	int ret = 0;
+	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
+	int dio_credits;
+
+	/*
+	 * DIO VFS code passes create = 0 flag for write to
+	 * the middle of file. It does this to avoid block
+	 * allocation for holes, to prevent expose stale data
+	 * out when there is parallel buffered read (which does
+	 * not hold the i_mutex lock) while direct IO write has
+	 * not completed. DIO request on holes finally falls back
+	 * to buffered IO for this reason.
+	 *
+	 * For ext4 extent based file, since we support fallocate,
+	 * new allocated extent as uninitialized, for holes, we
+	 * could fallocate blocks for holes, thus parallel
+	 * buffered IO read will zero out the page when read on
+	 * a hole while parallel DIO write to the hole has not completed.
+	 *
+	 * when we come here, we know it's a direct IO write,
+	 * so it's safe to override the create flag from VFS.
+	 */
+	create = EXT4_GET_BLOCKS_DIO_CREATE_EXT;
+
+	if (max_blocks > DIO_MAX_BLOCKS)
+		max_blocks = DIO_MAX_BLOCKS;
+	dio_credits = ext4_chunk_trans_blocks(inode, max_blocks);
+	handle = ext4_journal_start(inode, dio_credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out;
+	}
+	ret = ext4_get_blocks(handle, inode, iblock, max_blocks, bh_result,
+			      create);
+	if (ret > 0) {
+		bh_result->b_size = (ret << inode->i_blkbits);
+		ret = 0;
+	}
+	ext4_journal_stop(handle);
+out:
+	return ret;
+}
+
+static int ext4_get_block_dio_read(struct inode *inode, sector_t iblock,
+		   struct buffer_head *bh_result, int create)
+{
+	int ret = 0;
+	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
+	handle_t *handle = NULL;
+
+	ret = ext4_get_blocks(handle, inode, iblock, max_blocks, bh_result,
+			      create);
+	if (ret > 0) {
+		bh_result->b_size = (ret << inode->i_blkbits);
+		ret = 0;
+	}
+	return ret;
+}
+
+
+#define		DIO_UNWRITTEN	0x1
+
+/*
+ * IO write completion for unwritten extents.
+ *
+ * check a range of space and convert unwritten extents to written.
+ */
+static void ext4_end_dio_unwritten(struct work_struct *work)
+{
+	ext4_io_end_t *io = container_of(work, ext4_io_end_t, work);
+	struct inode *inode = io->inode;
+	loff_t offset = io->offset;
+	size_t size = io->size;
+	int ret = 0;
+
+	ret = ext4_convert_unwritten_extents(inode, offset, size);
+
+	if (ret < 0)
+		printk(KERN_EMERG "%s: failed to convert unwritten"
+			"extents to written extents, error is %d\n",
+                       __func__, ret);
+	kfree(io);
+}
+
+static ext4_io_end_t *ext4_init_io_end (struct inode *inode, unsigned int type)
+{
+	ext4_io_end_t *io = NULL;
+
+	io = kmalloc(sizeof(*io), GFP_NOFS);
+
+	if (io) {
+		io->inode = inode;
+		io->type = type;
+		io->offset = 0;
+		io->size = 0;
+		io->error = 0;
+		INIT_WORK(&io->work, ext4_end_dio_unwritten);
+	}
+
+	return io;
+}
+
+static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
+			    ssize_t size, void *private)
+{
+        ext4_io_end_t *io_end = iocb->private;
+	struct workqueue_struct *wq;
+
+	/* if not hole or unwritten extents, just simple return */
+	if (!io_end || !size)
+		return;
+	io_end->offset = offset;
+	io_end->size = size;
+	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
+
+	/* We need to convert unwritten extents to written */
+	queue_work(wq, &io_end->work);
+
+        if (is_sync_kiocb(iocb))
+		flush_workqueue(wq);
+
+	iocb->private = NULL;
+}
+/*
+ * For ext4 extent files, ext4 will do direct-io write to holes,
+ * preallocated extents, and those write extend the file, no need to
+ * fall back to buffered IO.
+ *
+ * If there is block allocation needed(holes, EOF write), we fallocate
+ * those blocks, mark them as unintialized
+ * If those blocks were preallocated, we mark sure they are splited, but
+ * still keep the range to write as unintialized.
+ *
+ * When end_io call back function called at the last IO complete time,
+ * those extents will be converted to written extents.
+ *
+ */
+static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
+			      const struct iovec *iov, loff_t offset,
+			      unsigned long nr_segs)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	ssize_t ret;
+
+	if (rw == WRITE) {
+		/*
+ 		 * For DIO we fallocate blocks for holes and end of file
+ 		 * write. Those fallocated extents are marked as uninitialized
+ 		 * to prevent paralel buffered read to expose the stale data
+ 		 * before DIO complete the data IO.
+ 		 * as for previously fallocated extents, ext4 get_block
+ 		 * will just simply mark the buffer mapped but still
+ 		 * keep the extents uninitialized.
+ 		 *
+ 		 * At the end of IO, the ext4 end_io callback function
+ 		 * will convert those unwritten extents to written,
+ 		 * and update on disk file size if the DIO expands the file.
+ 		 *
+ 		 */
+		iocb->private = ext4_init_io_end(inode, DIO_UNWRITTEN);
+		if (!iocb->private)
+			return -ENOMEM;
+
+		ret = blockdev_direct_IO(rw, iocb, inode,
+					 inode->i_sb->s_bdev, iov,
+					 offset, nr_segs,
+					 ext4_get_block_dio_write,
+					 ext4_end_io_dio);
+	} else
+		ret = blockdev_direct_IO(rw, iocb, inode,
+					 inode->i_sb->s_bdev, iov,
+					 offset, nr_segs,
+					 ext4_get_block_dio_read, NULL);
+
+ 	/*
+	 * In the case of AIO DIO, VFS dio submitted the IO, but it
+ 	 * does not wait for io complete. To prevent expose stale
+ 	 * data after crash before IO complete,
+ 	 * i_disksize needs to be updated at the
+ 	 * time all the IO is completed, not here
+ 	 */
+	return ret;
+}
+
+static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
+			      const struct iovec *iov, loff_t offset,
+			      unsigned long nr_segs)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+
+	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
+		return ext4_ext_direct_IO(rw, iocb, iov, offset, nr_segs);
+
+	return ext4_ind_direct_IO(rw, iocb, iov, offset, nr_segs);
+}
+
 /*
  * Pages can be marked dirty completely asynchronously from ext4's journalling
  * activity.  By filemap_sync_pte(), try_to_unmap_one(), etc.  We cannot do


