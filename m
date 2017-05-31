From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v5 14/17] ext4: convert to errseq_t based error tracking
Date: Wed, 31 May 2017 08:45:37 -0400
Message-ID: <20170531124540.8782-15-jlayton@redhat.com>
References: <20170531124540.8782-1-jlayton@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170531124540.8782-1-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Sample the block device inode's errseq_t when opening a file, so we can
catch metadata writeback errors at fsync time. Change ext4_sync_file to
check for data errors first, and then check the blockdev for metadata
errors afterward.

There are also several internal callers of filemap_write_and_wait_* that
check the error code afterward. Convert them to the "_since" variants,
using the file->f_wb_err value as the "since" value. This means passing
file pointers to several functions instead of inode pointers.

Note that because metadata writeback errors are only tracked on a
per-device level, this does mean that we'll end up reporting an error on
all open file descriptors when there is a metadata writeback failure.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ext4/dir.c     |  8 ++++++--
 fs/ext4/ext4.h    |  8 ++++----
 fs/ext4/extents.c | 24 ++++++++++++++----------
 fs/ext4/file.c    |  5 ++++-
 fs/ext4/fsync.c   | 23 ++++++++++++++++++-----
 fs/ext4/inode.c   | 19 ++++++++++++-------
 fs/ext4/ioctl.c   |  9 +++++----
 fs/ext4/super.c   |  9 +++++----
 8 files changed, 68 insertions(+), 37 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index e8b365000d73..6bbb19510f74 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -611,9 +611,13 @@ static int ext4_dx_readdir(struct file *file, struct dir_context *ctx)
 
 static int ext4_dir_open(struct inode * inode, struct file * filp)
 {
+	int ret = 0;
+
 	if (ext4_encrypted_inode(inode))
-		return fscrypt_get_encryption_info(inode) ? -EACCES : 0;
-	return 0;
+		ret = fscrypt_get_encryption_info(inode) ? -EACCES : 0;
+	if (!ret)
+		filp->f_md_wb_err = filemap_sample_wb_err(inode->i_sb->s_bdev->bd_inode->i_mapping);
+	return ret;
 }
 
 static int ext4_release_dir(struct inode *inode, struct file *filp)
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8e8046104f4d..e3ab27db43d0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2468,12 +2468,12 @@ extern void ext4_clear_inode(struct inode *);
 extern int  ext4_file_getattr(const struct path *, struct kstat *, u32, unsigned int);
 extern int  ext4_sync_inode(handle_t *, struct inode *);
 extern void ext4_dirty_inode(struct inode *, int);
-extern int ext4_change_inode_journal_flag(struct inode *, int);
+extern int ext4_change_inode_journal_flag(struct file *, int);
 extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
 extern int ext4_inode_attach_jinode(struct inode *inode);
 extern int ext4_can_truncate(struct inode *inode);
 extern int ext4_truncate(struct inode *);
-extern int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length);
+extern int ext4_punch_hole(struct file *file, loff_t offset, loff_t length);
 extern int ext4_truncate_restart_trans(handle_t *, struct inode *, int nblocks);
 extern void ext4_set_inode_flags(struct inode *);
 extern int ext4_alloc_da_blocks(struct inode *inode);
@@ -3143,8 +3143,8 @@ extern ext4_lblk_t ext4_ext_next_allocated_block(struct ext4_ext_path *path);
 extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			__u64 start, __u64 len);
 extern int ext4_ext_precache(struct inode *inode);
-extern int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len);
-extern int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len);
+extern int ext4_collapse_range(struct file *file, loff_t offset, loff_t len);
+extern int ext4_insert_range(struct file *file, loff_t offset, loff_t len);
 extern int ext4_swap_extents(handle_t *handle, struct inode *inode1,
 				struct inode *inode2, ext4_lblk_t lblk1,
 			     ext4_lblk_t lblk2,  ext4_lblk_t count,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 2a97dff87b96..7e108fda9ae9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4934,17 +4934,17 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EOPNOTSUPP;
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
-		return ext4_punch_hole(inode, offset, len);
+		return ext4_punch_hole(file, offset, len);
 
 	ret = ext4_convert_inline_data(inode);
 	if (ret)
 		return ret;
 
 	if (mode & FALLOC_FL_COLLAPSE_RANGE)
-		return ext4_collapse_range(inode, offset, len);
+		return ext4_collapse_range(file, offset, len);
 
 	if (mode & FALLOC_FL_INSERT_RANGE)
-		return ext4_insert_range(inode, offset, len);
+		return ext4_insert_range(file, offset, len);
 
 	if (mode & FALLOC_FL_ZERO_RANGE)
 		return ext4_zero_range(file, offset, len, mode);
@@ -5444,14 +5444,16 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
  * This implements the fallocate's collapse range functionality for ext4
  * Returns: 0 and non-zero on error.
  */
-int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
+int ext4_collapse_range(struct file *file, loff_t offset, loff_t len)
 {
+	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	ext4_lblk_t punch_start, punch_stop;
 	handle_t *handle;
 	unsigned int credits;
 	loff_t new_size, ioffset;
 	int ret;
+	errseq_t since = READ_ONCE(file->f_wb_err);
 
 	/*
 	 * We need to test this early because xfstests assumes that a
@@ -5515,7 +5517,7 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	 * Write tail of the last page before removed range since it will get
 	 * removed from the page cache below.
 	 */
-	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset, offset);
+	ret = filemap_write_and_wait_range_since(inode->i_mapping, ioffset, offset, since);
 	if (ret)
 		goto out_mmap;
 	/*
@@ -5523,8 +5525,8 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	 * page cache below. We are also protected from pages becoming dirty
 	 * by i_mmap_sem.
 	 */
-	ret = filemap_write_and_wait_range(inode->i_mapping, offset + len,
-					   LLONG_MAX);
+	ret = filemap_write_and_wait_range_since(inode->i_mapping, offset + len,
+					   LLONG_MAX, since);
 	if (ret)
 		goto out_mmap;
 	truncate_pagecache(inode, ioffset);
@@ -5588,8 +5590,9 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
  * by len bytes.
  * Returns 0 on success, error otherwise.
  */
-int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
+int ext4_insert_range(struct file *file, loff_t offset, loff_t len)
 {
+	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	handle_t *handle;
 	struct ext4_ext_path *path;
@@ -5598,6 +5601,7 @@ int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
 	unsigned int credits, ee_len;
 	int ret = 0, depth, split_flag = 0;
 	loff_t ioffset;
+	errseq_t since = READ_ONCE(file->f_wb_err);
 
 	/*
 	 * We need to test this early because xfstests assumes that an
@@ -5661,8 +5665,8 @@ int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
 	 */
 	ioffset = round_down(offset, PAGE_SIZE);
 	/* Write out all dirty pages */
-	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
-			LLONG_MAX);
+	ret = filemap_write_and_wait_range_since(inode->i_mapping, ioffset,
+			LLONG_MAX, since);
 	if (ret)
 		goto out_mmap;
 	truncate_pagecache(inode, ioffset);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 831fd6beebf0..fe0d6e01c4b7 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -435,7 +435,10 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 		if (ret < 0)
 			return ret;
 	}
-	return dquot_file_open(inode, filp);
+	ret = dquot_file_open(inode, filp);
+	if (!ret)
+		filp->f_md_wb_err = filemap_sample_wb_err(sb->s_bdev->bd_inode->i_mapping);
+	return ret;
 }
 
 /*
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 9d549608fd30..ba474de2dadb 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -99,9 +99,12 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	int ret = 0, err;
 	tid_t commit_tid;
 	bool needs_barrier = false;
+	errseq_t since = READ_ONCE(file->f_wb_err);
 
-	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
-		return -EIO;
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb)))) {
+		ret = -EIO;
+		goto out;
+	}
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
 
@@ -124,9 +127,11 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		goto out;
 	}
 
-	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	ret = filemap_write_and_wait_range_since(inode->i_mapping, start,
+						 end, since);
 	if (ret)
-		return ret;
+		goto out;
+
 	/*
 	 * data=writeback,ordered:
 	 *  The caller's filemap_fdatawrite()/wait will sync the data.
@@ -152,12 +157,20 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		needs_barrier = true;
 	ret = jbd2_complete_transaction(journal, commit_tid);
 	if (needs_barrier) {
-	issue_flush:
+issue_flush:
 		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
 		if (!ret)
 			ret = err;
 	}
 out:
+	err = filemap_report_wb_err(file);
+	if (!ret)
+		ret = err;
+
+	err = filemap_report_md_wb_err(file,
+				inode->i_sb->s_bdev->bd_inode->i_mapping);
+	if (!ret)
+		ret = err;
 	trace_ext4_sync_file_exit(inode, ret);
 	return ret;
 }
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1bd0bfa547f6..df3b6f62dcbb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3705,6 +3705,7 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
 	struct inode *inode = mapping->host;
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
+	errseq_t since = READ_ONCE(iocb->ki_filp->f_wb_err);
 
 	/*
 	 * Shared inode_lock is enough for us - it protects against concurrent
@@ -3712,8 +3713,8 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
 	 * we are protected against page writeback as well.
 	 */
 	inode_lock_shared(inode);
-	ret = filemap_write_and_wait_range(mapping, iocb->ki_pos,
-					   iocb->ki_pos + count);
+	ret = filemap_write_and_wait_range_since(mapping, iocb->ki_pos,
+					   iocb->ki_pos + count, since);
 	if (ret)
 		goto out_unlock;
 	ret = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
@@ -4085,8 +4086,9 @@ int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
  * Returns: 0 on success or negative on failure
  */
 
-int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
+int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 {
+	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	ext4_lblk_t first_block, stop_block;
 	struct address_space *mapping = inode->i_mapping;
@@ -4094,6 +4096,7 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	handle_t *handle;
 	unsigned int credits;
 	int ret = 0;
+	errseq_t since = READ_ONCE(file->f_wb_err);
 
 	if (!S_ISREG(inode->i_mode))
 		return -EOPNOTSUPP;
@@ -4105,8 +4108,8 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	 * Then release them.
 	 */
 	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
-		ret = filemap_write_and_wait_range(mapping, offset,
-						   offset + length - 1);
+		ret = filemap_write_and_wait_range_since(mapping, offset,
+						   offset + length - 1, since);
 		if (ret)
 			return ret;
 	}
@@ -5771,12 +5774,14 @@ static int ext4_pin_inode(handle_t *handle, struct inode *inode)
 }
 #endif
 
-int ext4_change_inode_journal_flag(struct inode *inode, int val)
+int ext4_change_inode_journal_flag(struct file *file, int val)
 {
+	struct inode *inode = file_inode(file);
 	journal_t *journal;
 	handle_t *handle;
 	int err;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	errseq_t since = READ_ONCE(file->f_wb_err);
 
 	/*
 	 * We have to be very careful here: changing a data block's
@@ -5808,7 +5813,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	 */
 	if (val) {
 		down_write(&EXT4_I(inode)->i_mmap_sem);
-		err = filemap_write_and_wait(inode->i_mapping);
+		err = filemap_write_and_wait_since(inode->i_mapping, since);
 		if (err < 0) {
 			up_write(&EXT4_I(inode)->i_mmap_sem);
 			ext4_inode_resume_unlocked_dio(inode);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 0c21e22acd74..888a4533d078 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -207,9 +207,10 @@ static int uuid_is_zero(__u8 u[16])
 }
 #endif
 
-static int ext4_ioctl_setflags(struct inode *inode,
+static int ext4_ioctl_setflags(struct file *file,
 			       unsigned int flags)
 {
+	struct inode *inode = file_inode(file);
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	handle_t *handle = NULL;
 	int err = -EPERM, migrate = 0;
@@ -293,7 +294,7 @@ static int ext4_ioctl_setflags(struct inode *inode,
 		goto flags_out;
 
 	if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL))
-		err = ext4_change_inode_journal_flag(inode, jflag);
+		err = ext4_change_inode_journal_flag(file, jflag);
 	if (err)
 		goto flags_out;
 	if (migrate) {
@@ -617,7 +618,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			return err;
 
 		inode_lock(inode);
-		err = ext4_ioctl_setflags(inode, flags);
+		err = ext4_ioctl_setflags(filp, flags);
 		inode_unlock(inode);
 		mnt_drop_write_file(filp);
 		return err;
@@ -1015,7 +1016,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		inode_lock(inode);
 		flags = (ei->i_flags & ~EXT4_FL_XFLAG_VISIBLE) |
 			 (flags & EXT4_FL_XFLAG_VISIBLE);
-		err = ext4_ioctl_setflags(inode, flags);
+		err = ext4_ioctl_setflags(filp, flags);
 		inode_unlock(inode);
 		mnt_drop_write_file(filp);
 		if (err)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0b177da9ea82..9ce0b6e63abb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -119,7 +119,7 @@ static struct file_system_type ext2_fs_type = {
 	.name		= "ext2",
 	.mount		= ext4_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV|FS_WB_ERRSEQ,
 };
 MODULE_ALIAS_FS("ext2");
 MODULE_ALIAS("ext2");
@@ -134,7 +134,7 @@ static struct file_system_type ext3_fs_type = {
 	.name		= "ext3",
 	.mount		= ext4_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV|FS_WB_ERRSEQ,
 };
 MODULE_ALIAS_FS("ext3");
 MODULE_ALIAS("ext3");
@@ -4887,6 +4887,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	ext4_group_t g;
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 	int err = 0;
+	errseq_t since = filemap_sample_wb_err(sb->s_bdev->bd_inode->i_mapping);
 #ifdef CONFIG_QUOTA
 	int i, j;
 #endif
@@ -4988,7 +4989,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		}
 
 		if (*flags & MS_RDONLY) {
-			err = sync_filesystem(sb);
+			err = sync_filesystem_since(sb, since);
 			if (err < 0)
 				goto restore_opts;
 			err = dquot_suspend(sb, -1);
@@ -5690,7 +5691,7 @@ static struct file_system_type ext4_fs_type = {
 	.name		= "ext4",
 	.mount		= ext4_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV|FS_WB_ERRSEQ,
 };
 MODULE_ALIAS_FS("ext4");
 
-- 
2.9.4
