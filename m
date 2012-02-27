From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 20/22] ext4: add support for read_iter, write_iter, and direct_IO_bvec
Date: Mon, 27 Feb 2012 15:19:34 -0600
Message-ID: <1330377576-3659-21-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Some helpers were broken out of ext4_ind_direct_IO() and
ext4_ext_direct_IO() in order to avoid code duplication in new
bio_vec-based functions.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/ext4.h     |    3 +
 fs/ext4/file.c     |    2 +
 fs/ext4/indirect.c |  169 +++++++++++++++++++++++++++++++-----------
 fs/ext4/inode.c    |  206 +++++++++++++++++++++++++++++++++++-----------------
 4 files changed, 268 insertions(+), 112 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 513004f..6426d43 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1905,6 +1905,9 @@ extern int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 extern ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 				const struct iovec *iov, loff_t offset,
 				unsigned long nr_segs);
+extern ssize_t ext4_ind_direct_IO_bvec(int rw, struct kiocb *iocb,
+				struct bio_vec *bvec, loff_t offset,
+				unsigned long bvec_len);
 extern int ext4_ind_calc_metadata_amount(struct inode *inode, sector_t lblock);
 extern int ext4_ind_trans_blocks(struct inode *inode, int nrblocks, int chunk);
 extern void ext4_ind_truncate(struct inode *inode);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index cb70f18..ce76745 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -234,6 +234,8 @@ const struct file_operations ext4_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= ext4_file_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.unlocked_ioctl = ext4_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext4_compat_ioctl,
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 830e1b2..e8ca3b9 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -760,6 +760,72 @@ out:
 	return err;
 }
 
+static ssize_t ext4_journal_orphan_add(struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	handle_t *handle;
+	ssize_t ret;
+
+	/* Credits for sb + inode write */
+	handle = ext4_journal_start(inode, 2);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out;
+	}
+	ret = ext4_orphan_add(handle, inode);
+	if (ret) {
+		ext4_journal_stop(handle);
+		goto out;
+	}
+	ei->i_disksize = inode->i_size;
+	ext4_journal_stop(handle);
+out:
+	return ret;
+}
+
+static ssize_t ext4_journal_orphan_del(struct inode *inode, ssize_t ret,
+				       loff_t offset)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	handle_t *handle;
+	int err;
+
+	/* Credits for sb + inode write */
+	handle = ext4_journal_start(inode, 2);
+	if (IS_ERR(handle)) {
+		/* This is really bad luck. We've written the data
+		 * but cannot extend i_size. Bail out and pretend
+		 * the write failed... */
+		ret = PTR_ERR(handle);
+		if (inode->i_nlink)
+			ext4_orphan_del(NULL, inode);
+
+		goto out;
+	}
+	if (inode->i_nlink)
+		ext4_orphan_del(handle, inode);
+	if (ret > 0) {
+		loff_t end = offset + ret;
+		if (end > inode->i_size) {
+			ei->i_disksize = end;
+			i_size_write(inode, end);
+			/*
+			 * We're going to return a positive `ret'
+			 * here due to non-zero-length I/O, so there's
+			 * no way of reporting error returns from
+			 * ext4_mark_inode_dirty() to userspace.  So
+			 * ignore it.
+			 */
+			ext4_mark_inode_dirty(handle, inode);
+		}
+	}
+	err = ext4_journal_stop(handle);
+	if (ret == 0)
+		ret = err;
+out:
+	return ret;
+}
+
 /*
  * O_DIRECT for ext3 (or indirect map) based files
  *
@@ -778,7 +844,6 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	handle_t *handle;
 	ssize_t ret;
 	int orphan = 0;
 	size_t count = iov_length(iov, nr_segs);
@@ -788,20 +853,10 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 		loff_t final_size = offset + count;
 
 		if (final_size > inode->i_size) {
-			/* Credits for sb + inode write */
-			handle = ext4_journal_start(inode, 2);
-			if (IS_ERR(handle)) {
-				ret = PTR_ERR(handle);
-				goto out;
-			}
-			ret = ext4_orphan_add(handle, inode);
-			if (ret) {
-				ext4_journal_stop(handle);
+			ret =  ext4_journal_orphan_add(inode);
+			if (ret)
 				goto out;
-			}
 			orphan = 1;
-			ei->i_disksize = inode->i_size;
-			ext4_journal_stop(handle);
 		}
 	}
 
@@ -831,42 +886,68 @@ retry:
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 
-	if (orphan) {
-		int err;
+	if (orphan)
+		ret = ext4_journal_orphan_del(inode, ret, offset);
+out:
+	return ret;
+}
 
-		/* Credits for sb + inode write */
-		handle = ext4_journal_start(inode, 2);
-		if (IS_ERR(handle)) {
-			/* This is really bad luck. We've written the data
-			 * but cannot extend i_size. Bail out and pretend
-			 * the write failed... */
-			ret = PTR_ERR(handle);
-			if (inode->i_nlink)
-				ext4_orphan_del(NULL, inode);
+/*
+ * Like ext4_ind_direct_IO, but operates on bio_vec instead of iovec
+ */
+ssize_t ext4_ind_direct_IO_bvec(int rw, struct kiocb *iocb,
+				struct bio_vec *bvec, loff_t offset,
+				unsigned long bvec_len)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	ssize_t ret;
+	int orphan = 0;
+	size_t count = bvec_length(bvec, bvec_len);
+	int retries = 0;
+
+	if (rw == WRITE) {
+		loff_t final_size = offset + count;
 
-			goto out;
+		if (final_size > inode->i_size) {
+			ret =  ext4_journal_orphan_add(inode);
+			if (ret)
+				goto out;
+			orphan = 1;
 		}
-		if (inode->i_nlink)
-			ext4_orphan_del(handle, inode);
-		if (ret > 0) {
-			loff_t end = offset + ret;
-			if (end > inode->i_size) {
-				ei->i_disksize = end;
-				i_size_write(inode, end);
-				/*
-				 * We're going to return a positive `ret'
-				 * here due to non-zero-length I/O, so there's
-				 * no way of reporting error returns from
-				 * ext4_mark_inode_dirty() to userspace.  So
-				 * ignore it.
-				 */
-				ext4_mark_inode_dirty(handle, inode);
-			}
+	}
+
+retry:
+	if (rw == READ && ext4_should_dioread_nolock(inode)) {
+		if (unlikely(!list_empty(&ei->i_completed_io_list))) {
+			mutex_lock(&inode->i_mutex);
+			ext4_flush_completed_IO(inode);
+			mutex_unlock(&inode->i_mutex);
+		}
+		ret = __blockdev_direct_IO_bvec(rw, iocb, inode,
+				 inode->i_sb->s_bdev, bvec,
+				 offset, bvec_len,
+				 ext4_get_block, NULL, NULL, 0);
+	} else {
+		ret = blockdev_direct_IO_bvec(rw, iocb, inode,
+				 inode->i_sb->s_bdev, bvec,
+				 offset, bvec_len,
+				 ext4_get_block, NULL);
+
+		if (unlikely((rw & WRITE) && ret < 0)) {
+			loff_t isize = i_size_read(inode);
+			loff_t end = offset + bvec_length(bvec, bvec_len);
+
+			if (end > isize)
+				ext4_truncate_failed_write(inode);
 		}
-		err = ext4_journal_stop(handle);
-		if (ret == 0)
-			ret = err;
 	}
+	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+		goto retry;
+
+	if (orphan)
+		ret = ext4_journal_orphan_del(inode, ret, offset);
 out:
 	return ret;
 }
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index feaa82f..922b26f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2764,7 +2764,7 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 
 	ext_debug("ext4_end_io_dio(): io_end 0x%p "
 		  "for inode %lu, iocb 0x%p, offset %llu, size %llu\n",
- 		  iocb->private, io_end->inode->i_ino, iocb, offset,
+		  iocb->private, io_end->inode->i_ino, iocb, offset,
 		  size);
 
 	iocb->private = NULL;
@@ -2868,6 +2868,85 @@ retry:
 	return 0;
 }
 
+static ssize_t ext4_ext_direct_IO_pre_write(struct kiocb *iocb,
+					    struct inode *inode)
+{
+	/*
+	 * We could direct write to holes and fallocate.
+	 *
+	 * Allocated blocks to fill the hole are marked as uninitialized
+	 * to prevent parallel buffered read to expose the stale data
+	 * before DIO complete the data IO.
+	 *
+	 * As to previously fallocated extents, ext4 get_block
+	 * will just simply mark the buffer mapped but still
+	 * keep the extents uninitialized.
+	 *
+	 * for non AIO case, we will convert those unwritten extents
+	 * to written after return back from blockdev_direct_IO.
+	 *
+	 * for async DIO, the conversion needs to be defered when
+	 * the IO is completed. The ext4 end_io callback function
+	 * will be called to take care of the conversion work.
+	 * Here for async case, we allocate an io_end structure to
+	 * hook to the iocb.
+	 */
+	iocb->private = NULL;
+	EXT4_I(inode)->cur_aio_dio = NULL;
+	if (!is_sync_kiocb(iocb)) {
+		iocb->private = ext4_init_io_end(inode, GFP_NOFS);
+		if (!iocb->private)
+			return -ENOMEM;
+		/*
+		 * we save the io structure for current async
+		 * direct IO, so that later ext4_map_blocks()
+		 * could flag the io structure whether there
+		 * is a unwritten extents needs to be converted
+		 * when IO is completed.
+		 */
+		EXT4_I(inode)->cur_aio_dio = iocb->private;
+	}
+	return 0;
+}
+
+static ssize_t ext4_ext_direct_IO_post_write(struct kiocb *iocb,
+					     struct inode *inode,
+					     loff_t offset, ssize_t ret)
+{
+	if (iocb->private)
+			EXT4_I(inode)->cur_aio_dio = NULL;
+	/*
+	 * The io_end structure takes a reference to the inode,
+	 * that structure needs to be destroyed and the
+	 * reference to the inode need to be dropped, when IO is
+	 * complete, even with 0 byte write, or failed.
+	 *
+	 * In the successful AIO DIO case, the io_end structure will be
+	 * desctroyed and the reference to the inode will be dropped
+	 * after the end_io call back function is called.
+	 *
+	 * In the case there is 0 byte write, or error case, since
+	 * VFS direct IO won't invoke the end_io call back function,
+	 * we need to free the end_io structure here.
+	 */
+	if (ret != -EIOCBQUEUED && ret <= 0 && iocb->private) {
+		ext4_free_io_end(iocb->private);
+		iocb->private = NULL;
+	} else if (ret > 0 &&
+		   ext4_test_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN)) {
+		int err;
+		/*
+		 * for non AIO case, since the IO is already
+		 * completed, we could do the conversion right here
+		 */
+		err = ext4_convert_unwritten_extents(inode, offset, ret);
+		if (err < 0)
+			ret = err;
+		ext4_clear_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN);
+	}
+	return ret;
+}
+
 /*
  * For ext4 extent files, ext4 will do direct-io write to holes,
  * preallocated extents, and those write extend the file, no need to
@@ -2898,41 +2977,9 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 
 	loff_t final_size = offset + count;
 	if (rw == WRITE && final_size <= inode->i_size) {
-		/*
- 		 * We could direct write to holes and fallocate.
-		 *
- 		 * Allocated blocks to fill the hole are marked as uninitialized
- 		 * to prevent parallel buffered read to expose the stale data
- 		 * before DIO complete the data IO.
-		 *
- 		 * As to previously fallocated extents, ext4 get_block
- 		 * will just simply mark the buffer mapped but still
- 		 * keep the extents uninitialized.
- 		 *
-		 * for non AIO case, we will convert those unwritten extents
-		 * to written after return back from blockdev_direct_IO.
-		 *
-		 * for async DIO, the conversion needs to be defered when
-		 * the IO is completed. The ext4 end_io callback function
-		 * will be called to take care of the conversion work.
-		 * Here for async case, we allocate an io_end structure to
-		 * hook to the iocb.
- 		 */
-		iocb->private = NULL;
-		EXT4_I(inode)->cur_aio_dio = NULL;
-		if (!is_sync_kiocb(iocb)) {
-			iocb->private = ext4_init_io_end(inode, GFP_NOFS);
-			if (!iocb->private)
-				return -ENOMEM;
-			/*
-			 * we save the io structure for current async
-			 * direct IO, so that later ext4_map_blocks()
-			 * could flag the io structure whether there
-			 * is a unwritten extents needs to be converted
-			 * when IO is completed.
-			 */
-			EXT4_I(inode)->cur_aio_dio = iocb->private;
-		}
+		ret = ext4_ext_direct_IO_pre_write(iocb, inode);
+		if (ret)
+			return ret;
 
 		ret = __blockdev_direct_IO(rw, iocb, inode,
 					 inode->i_sb->s_bdev, iov,
@@ -2941,38 +2988,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 					 ext4_end_io_dio,
 					 NULL,
 					 DIO_LOCKING | DIO_SKIP_HOLES);
-		if (iocb->private)
-			EXT4_I(inode)->cur_aio_dio = NULL;
-		/*
-		 * The io_end structure takes a reference to the inode,
-		 * that structure needs to be destroyed and the
-		 * reference to the inode need to be dropped, when IO is
-		 * complete, even with 0 byte write, or failed.
-		 *
-		 * In the successful AIO DIO case, the io_end structure will be
-		 * desctroyed and the reference to the inode will be dropped
-		 * after the end_io call back function is called.
-		 *
-		 * In the case there is 0 byte write, or error case, since
-		 * VFS direct IO won't invoke the end_io call back function,
-		 * we need to free the end_io structure here.
-		 */
-		if (ret != -EIOCBQUEUED && ret <= 0 && iocb->private) {
-			ext4_free_io_end(iocb->private);
-			iocb->private = NULL;
-		} else if (ret > 0 && ext4_test_inode_state(inode,
-						EXT4_STATE_DIO_UNWRITTEN)) {
-			int err;
-			/*
-			 * for non AIO case, since the IO is already
-			 * completed, we could do the conversion right here
-			 */
-			err = ext4_convert_unwritten_extents(inode,
-							     offset, ret);
-			if (err < 0)
-				ret = err;
-			ext4_clear_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN);
-		}
+		ret = ext4_ext_direct_IO_post_write(iocb, inode, offset, ret);
 		return ret;
 	}
 
@@ -2980,6 +2996,37 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 	return ext4_ind_direct_IO(rw, iocb, iov, offset, nr_segs);
 }
 
+/*
+ * Like ext4_ext_direct_IO, but operates on a bio_vec rather than iovec.
+ */
+static ssize_t ext4_ext_direct_IO_bvec(int rw, struct kiocb *iocb,
+			      struct bio_vec *bvec, loff_t offset,
+			      unsigned long bvec_len)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	ssize_t ret;
+	size_t count = bvec_length(bvec, bvec_len);
+
+	loff_t final_size = offset + count;
+	if (rw == WRITE && final_size <= inode->i_size) {
+		ret = ext4_ext_direct_IO_pre_write(iocb, inode);
+		if (ret)
+			return ret;
+
+		ret = blockdev_direct_IO_bvec(rw, iocb, inode,
+					 inode->i_sb->s_bdev, bvec,
+					 offset, bvec_len,
+					 ext4_get_block_write,
+					 ext4_end_io_dio);
+		ret = ext4_ext_direct_IO_post_write(iocb, inode, offset, ret);
+		return ret;
+	}
+
+	/* for write the the end of file case, we fall back to old way */
+	return ext4_ind_direct_IO_bvec(rw, iocb, bvec, offset, bvec_len);
+}
+
 static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 			      const struct iovec *iov, loff_t offset,
 			      unsigned long nr_segs)
@@ -3004,6 +3051,25 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 	return ret;
 }
 
+static ssize_t ext4_direct_IO_bvec(int rw, struct kiocb *iocb,
+			      struct bio_vec *bvec, loff_t offset,
+			      unsigned long bvec_len)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	ssize_t ret;
+
+	trace_ext4_direct_IO_enter(inode, offset, bvec_length(bvec, bvec_len),
+				   rw);
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
+		ret = ext4_ext_direct_IO_bvec(rw, iocb, bvec, offset, bvec_len);
+	else
+		ret = ext4_ind_direct_IO_bvec(rw, iocb, bvec, offset, bvec_len);
+	trace_ext4_direct_IO_exit(inode, offset, bvec_length(bvec, bvec_len),
+				  rw, ret);
+	return ret;
+}
+
 /*
  * Pages can be marked dirty completely asynchronously from ext4's journalling
  * activity.  By filemap_sync_pte(), try_to_unmap_one(), etc.  We cannot do
@@ -3033,6 +3099,7 @@ static const struct address_space_operations ext4_ordered_aops = {
 	.invalidatepage		= ext4_invalidatepage,
 	.releasepage		= ext4_releasepage,
 	.direct_IO		= ext4_direct_IO,
+	.direct_IO_bvec		= ext4_direct_IO_bvec,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
@@ -3048,6 +3115,7 @@ static const struct address_space_operations ext4_writeback_aops = {
 	.invalidatepage		= ext4_invalidatepage,
 	.releasepage		= ext4_releasepage,
 	.direct_IO		= ext4_direct_IO,
+	.direct_IO_bvec		= ext4_direct_IO_bvec,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
@@ -3064,6 +3132,7 @@ static const struct address_space_operations ext4_journalled_aops = {
 	.invalidatepage		= ext4_invalidatepage,
 	.releasepage		= ext4_releasepage,
 	.direct_IO		= ext4_direct_IO,
+	.direct_IO_bvec		= ext4_direct_IO_bvec,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
 };
@@ -3079,6 +3148,7 @@ static const struct address_space_operations ext4_da_aops = {
 	.invalidatepage		= ext4_da_invalidatepage,
 	.releasepage		= ext4_releasepage,
 	.direct_IO		= ext4_direct_IO,
+	.direct_IO_bvec		= ext4_direct_IO_bvec,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
-- 
1.7.9.2

