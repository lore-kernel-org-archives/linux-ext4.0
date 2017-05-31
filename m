From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v5 16/17] ext2: convert to errseq_t based writeback error tracking
Date: Wed, 31 May 2017 08:45:39 -0400
Message-ID: <20170531124540.8782-17-jlayton@redhat.com>
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

Set the flag to indicate that we want new-style data writeback error
handling.

This means that we need to override the open routines for files and
directories so that we can sample the bdev wb_err at open.

XXX: doesn't quite pass the xfstest for this currently, as ext2_error
     resets the error on the device inode on every call.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ext2/dir.c   |  8 ++++++++
 fs/ext2/file.c  | 29 +++++++++++++++++++++++------
 fs/ext2/super.c |  2 +-
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index e2709695b177..6e476c9929f8 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -713,6 +713,13 @@ int ext2_empty_dir (struct inode * inode)
 	return 0;
 }
 
+static int ext2_dir_open(struct inode *inode, struct file *file)
+{
+	/* Sample blockdev mapping errseq_t for metadata writeback */
+	file->f_md_wb_err = filemap_sample_wb_err(inode->i_sb->s_bdev->bd_inode->i_mapping);
+	return 0;
+}
+
 const struct file_operations ext2_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
@@ -721,5 +728,6 @@ const struct file_operations ext2_dir_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
+	.open		= ext2_dir_open,
 	.fsync		= ext2_fsync,
 };
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index ed00e7ae0ef3..6f3cd7bc3fb3 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -172,16 +172,23 @@ static int ext2_release_file (struct inode * inode, struct file * filp)
 
 int ext2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	int ret;
+	int ret, ret2;
 	struct super_block *sb = file->f_mapping->host->i_sb;
 	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
 
 	ret = generic_file_fsync(file, start, end, datasync);
-	if (ret == -EIO) {
-		/* We don't really know where the IO error happened... */
-		ext2_error(sb, __func__,
+
+	ret2 = filemap_report_wb_err(file);
+	if (ret == 0)
+		ret = ret2;
+
+	ret2 = filemap_report_md_wb_err(file, mapping);
+	if (ret2) {
+		if (ret == 0)
+			ret = ret2;
+		if (ret == -EIO)
+			ext2_error(sb, __func__,
 			   "detected IO error when writing metadata buffers");
-		ret = -EIO;
 	}
 	return ret;
 }
@@ -204,6 +211,16 @@ static ssize_t ext2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	return generic_file_write_iter(iocb, from);
 }
 
+static int ext2_file_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	ret = dquot_file_open(inode, file);
+	if (likely(ret == 0))
+		file->f_md_wb_err = filemap_sample_wb_err(inode->i_sb->s_bdev->bd_inode->i_mapping);
+	return ret;
+}
+
 const struct file_operations ext2_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read_iter	= ext2_file_read_iter,
@@ -213,7 +230,7 @@ const struct file_operations ext2_file_operations = {
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
 	.mmap		= ext2_file_mmap,
-	.open		= dquot_file_open,
+	.open		= ext2_file_open,
 	.release	= ext2_release_file,
 	.fsync		= ext2_fsync,
 	.get_unmapped_area = thp_get_unmapped_area,
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 9c2028b50e5c..dd37d7f955bf 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1629,7 +1629,7 @@ static struct file_system_type ext2_fs_type = {
 	.name		= "ext2",
 	.mount		= ext2_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV|FS_WB_ERRSEQ,
 };
 MODULE_ALIAS_FS("ext2");
 
-- 
2.9.4
