From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 18/22] ext3: add support for .read_iter and .write_iter
Date: Mon, 27 Feb 2012 15:19:32 -0600
Message-ID: <1330377576-3659-19-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zach Brown <zab@zabbo.net>

ext3 uses the generic .read_iter and .write_iter functions.

ext3_direct_IO() is refactored in to helpers which are called by the
.direct_IO{,bvec}() methods which call __blockdev_direct_IO{,_bvec}().

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 drivers/block/loop.c |   55 ++++++++++++++++++-
 fs/ext3/file.c       |    2 +
 fs/ext3/inode.c      |  149 ++++++++++++++++++++++++++++++++++----------------
 include/linux/loop.h |    1 +
 4 files changed, 160 insertions(+), 47 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index cd50435..cdc34e1 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -76,6 +76,7 @@
 #include <linux/sysfs.h>
 #include <linux/miscdevice.h>
 #include <linux/falloc.h>
+#include <linux/aio.h>
 
 #include <asm/uaccess.h>
 
@@ -213,6 +214,46 @@ lo_do_transfer(struct loop_device *lo, int cmd,
 	return lo->transfer(lo, cmd, rpage, roffs, lpage, loffs, size, rblock);
 }
 
+void lo_rw_aio_complete(u64 data, long res)
+{
+	struct bio *bio = (struct bio *)data;
+
+	if (res > 0)
+		res = 0;
+	else if (res < 0)
+		res = -EIO;
+
+	bio_endio(bio, res);
+}
+
+static int lo_rw_aio(struct loop_device *lo, struct bio *bio)
+{
+	struct file *file = lo->lo_backing_file;
+	struct kiocb *iocb;
+	unsigned short op;
+	struct iov_iter iter;
+	struct bio_vec *bvec;
+	size_t nr_segs;
+	loff_t pos = ((loff_t) bio->bi_sector << 9) + lo->lo_offset;
+
+	iocb = aio_kernel_alloc(GFP_NOIO);
+	if (!iocb)
+		return -ENOMEM;
+
+	if (bio_rw(bio) & WRITE)
+		op = IOCB_CMD_WRITE_ITER;
+	else
+		op = IOCB_CMD_READ_ITER;
+
+	bvec = bio_iovec_idx(bio, bio->bi_idx);
+	nr_segs = bio_segments(bio);
+	iov_iter_init_bvec(&iter, bvec, nr_segs, bvec_length(bvec, nr_segs), 0);
+	aio_kernel_init_iter(iocb, file, op, &iter, pos);
+	aio_kernel_init_callback(iocb, lo_rw_aio_complete, (u64)bio);
+
+	return aio_kernel_submit(iocb);
+}
+
 /**
  * __do_lo_send_write - helper for writing data to a loop device
  *
@@ -512,7 +553,14 @@ static inline void loop_handle_bio(struct loop_device *lo, struct bio *bio)
 		do_loop_switch(lo, bio->bi_private);
 		bio_put(bio);
 	} else {
-		int ret = do_bio_filebacked(lo, bio);
+		int ret;
+		if (lo->lo_flags & LO_FLAGS_USE_AIO &&
+		    lo->transfer == transfer_none) {
+			ret = lo_rw_aio(lo, bio);
+			if (ret == 0)
+				return;
+		} else
+			ret = do_bio_filebacked(lo, bio);
 		bio_endio(bio, ret);
 	}
 }
@@ -854,6 +902,11 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	    !file->f_op->write)
 		lo_flags |= LO_FLAGS_READ_ONLY;
 
+	if (file->f_op->write_iter && file->f_op->read_iter) {
+		file->f_flags |= O_DIRECT;
+		lo_flags |= LO_FLAGS_USE_AIO;
+	}
+
 	lo_blocksize = S_ISBLK(inode->i_mode) ?
 		inode->i_bdev->bd_block_size : PAGE_SIZE;
 
diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index 724df69..30447a5 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -58,6 +58,8 @@ const struct file_operations ext3_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.unlocked_ioctl	= ext3_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 2d0afec..ea414f0 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1853,6 +1853,70 @@ static int ext3_releasepage(struct page *page, gfp_t wait)
 	return journal_try_to_free_buffers(journal, page, wait);
 }
 
+static ssize_t ext3_journal_orphan_add(struct inode *inode)
+{
+	struct ext3_inode_info *ei = EXT3_I(inode);
+	handle_t *handle;
+	ssize_t ret;
+
+	/* Credits for sb + inode write */
+	handle = ext3_journal_start(inode, 2);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out;
+	}
+	ret = ext3_orphan_add(handle, inode);
+	if (ret) {
+		ext3_journal_stop(handle);
+		goto out;
+	}
+	ei->i_disksize = inode->i_size;
+	ext3_journal_stop(handle);
+out:
+	return ret;
+}
+
+static ssize_t ext3_journal_orphan_del(struct inode *inode, ssize_t ret,
+				       loff_t offset)
+{
+	struct ext3_inode_info *ei = EXT3_I(inode);
+	handle_t *handle;
+	int err;
+
+	/* Credits for sb + inode write */
+	handle = ext3_journal_start(inode, 2);
+	if (IS_ERR(handle)) {
+		/* This is really bad luck. We've written the data
+		 * but cannot extend i_size. Truncate allocated blocks
+		 * and pretend the write failed... */
+		ext3_truncate_failed_direct_write(inode);
+		ret = PTR_ERR(handle);
+		goto out;
+	}
+	if (inode->i_nlink)
+		ext3_orphan_del(handle, inode);
+	if (ret > 0) {
+		loff_t end = offset + ret;
+		if (end > inode->i_size) {
+			ei->i_disksize = end;
+			i_size_write(inode, end);
+			/*
+			 * We're going to return a positive `ret'
+			 * here due to non-zero-length I/O, so there's
+			 * no way of reporting error returns from
+			 * ext3_mark_inode_dirty() to userspace.  So
+			 * ignore it.
+			 */
+			ext3_mark_inode_dirty(handle, inode);
+		}
+	}
+	err = ext3_journal_stop(handle);
+	if (ret == 0)
+		ret = err;
+out:
+	return ret;
+}
+
 /*
  * If the O_DIRECT write will extend the file then add this inode to the
  * orphan list.  So recovery will truncate it back to the original size
@@ -1868,8 +1932,6 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
-	struct ext3_inode_info *ei = EXT3_I(inode);
-	handle_t *handle;
 	ssize_t ret;
 	int orphan = 0;
 	size_t count = iov_length(iov, nr_segs);
@@ -1881,20 +1943,10 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 		loff_t final_size = offset + count;
 
 		if (final_size > inode->i_size) {
-			/* Credits for sb + inode write */
-			handle = ext3_journal_start(inode, 2);
-			if (IS_ERR(handle)) {
-				ret = PTR_ERR(handle);
+			ret = ext3_journal_orphan_add(inode);
+			if (ret)
 				goto out;
-			}
-			ret = ext3_orphan_add(handle, inode);
-			if (ret) {
-				ext3_journal_stop(handle);
-				goto out;
-			}
 			orphan = 1;
-			ei->i_disksize = inode->i_size;
-			ext3_journal_stop(handle);
 		}
 	}
 
@@ -1915,43 +1967,46 @@ retry:
 	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 
-	if (orphan) {
-		int err;
+	if (orphan)
+		ret = ext3_journal_orphan_del(inode, ret, offset);
+out:
+	return ret;
+}
 
-		/* Credits for sb + inode write */
-		handle = ext3_journal_start(inode, 2);
-		if (IS_ERR(handle)) {
-			/* This is really bad luck. We've written the data
-			 * but cannot extend i_size. Truncate allocated blocks
-			 * and pretend the write failed... */
-			ext3_truncate_failed_direct_write(inode);
-			ret = PTR_ERR(handle);
-			goto out;
-		}
-		if (inode->i_nlink)
-			ext3_orphan_del(handle, inode);
-		if (ret > 0) {
-			loff_t end = offset + ret;
-			if (end > inode->i_size) {
-				ei->i_disksize = end;
-				i_size_write(inode, end);
-				/*
-				 * We're going to return a positive `ret'
-				 * here due to non-zero-length I/O, so there's
-				 * no way of reporting error returns from
-				 * ext3_mark_inode_dirty() to userspace.  So
-				 * ignore it.
-				 */
-				ext3_mark_inode_dirty(handle, inode);
-			}
+static ssize_t ext3_direct_IO_bvec(int rw, struct kiocb *iocb,
+				   struct bio_vec *bvec, loff_t offset,
+				   unsigned long bvec_len)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	ssize_t ret;
+	int orphan = 0;
+	size_t count = bvec_length(bvec, bvec_len);
+	int retries = 0;
+
+	if (rw == WRITE) {
+		loff_t final_size = offset + count;
+
+		if (final_size > inode->i_size) {
+			ret = ext3_journal_orphan_add(inode);
+			if (ret)
+				goto out;
+			orphan = 1;
 		}
-		err = ext3_journal_stop(handle);
-		if (ret == 0)
-			ret = err;
 	}
+
+retry:
+	ret = blockdev_direct_IO_bvec(rw, iocb, inode, inode->i_sb->s_bdev,
+				      bvec, offset, bvec_len, ext3_get_block,
+				      NULL);
+	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
+		goto retry;
+
+	if (orphan)
+		ret = ext3_journal_orphan_del(inode, ret, offset);
 out:
 	trace_ext3_direct_IO_exit(inode, offset,
-				iov_length(iov, nr_segs), rw, ret);
+				bvec_length(bvec, bvec_len), rw, ret);
 	return ret;
 }
 
@@ -1984,6 +2039,7 @@ static const struct address_space_operations ext3_ordered_aops = {
 	.invalidatepage		= ext3_invalidatepage,
 	.releasepage		= ext3_releasepage,
 	.direct_IO		= ext3_direct_IO,
+	.direct_IO_bvec		= ext3_direct_IO_bvec,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
@@ -1999,6 +2055,7 @@ static const struct address_space_operations ext3_writeback_aops = {
 	.invalidatepage		= ext3_invalidatepage,
 	.releasepage		= ext3_releasepage,
 	.direct_IO		= ext3_direct_IO,
+	.direct_IO_bvec		= ext3_direct_IO_bvec,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 11a41a8..5163fd3 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -75,6 +75,7 @@ enum {
 	LO_FLAGS_READ_ONLY	= 1,
 	LO_FLAGS_AUTOCLEAR	= 4,
 	LO_FLAGS_PARTSCAN	= 8,
+	LO_FLAGS_USE_AIO	= 16,
 };
 
 #include <asm/posix_types.h>	/* for __kernel_old_dev_t */
-- 
1.7.9.2
