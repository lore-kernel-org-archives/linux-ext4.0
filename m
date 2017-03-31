From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH 1/4] fs: new infrastructure for writeback error handling and reporting
Date: Fri, 31 Mar 2017 15:26:00 -0400
Message-ID: <20170331192603.16442-2-jlayton@redhat.com>
References: <20170331192603.16442-1-jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz,
        willy@infradead.org, neilb@suse.com
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170331192603.16442-1-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Most filesystems currently use mapping_set_error and
filemap_check_errors for setting and reporting/clearing writeback errors
at the mapping level. filemap_check_errors is indirectly called from
most of the filemap_fdatawait_* functions and from
filemap_write_and_wait*. These functions are called from all sorts of
contexts to wait on writeback to finish -- e.g. mostly in fsync, but
also in truncate calls, getattr, etc.

It's those non-fsync callers that are problematic. We should be
reporting writeback errors during fsync, but many places in the code
clear out errors before they can be properly reported, or report errors
at nonsensical times. If I get -EIO on a stat() call, how do I know that
was because writeback failed?

This patch adds a small bit of new infrastructure for setting and
reporting errors during pagecache writeback. While the above was my
original impetus for adding this, I think it's also the case that
current fsync semantics are just problematic for userland. Most
applications that call fsync do so to ensure that the data they wrote
has hit the backing store.

In the case where there are multiple writers to the file at the same
time, this is really hard to determine. The first one to call fsync will
see any stored error, and the rest get back 0. The processes with open
fd may not be associated with one another in any way. They could even be
in different containers, so ensuring coordination between all fsync
callers is not really an option.

One way to remedy this would be to track what file descriptor was used
to dirty the file, but that's rather cumbersome and would likely be
slow. However, there is a simpler way to improve the semantics here
without incurring too much overhead.

This set adds a wb_error field and a sequence counter to the
address_space, and a corresponding sequence counter in the struct file.
When errors are reported during writeback, we set the error field in the
mapping and increment the sequence counter.

When fsync or flush is called, we check the sequence in the file vs. the
one in the mapping. If the file's counter is behind the one in the
mapping, then we update the sequence counter in the file to the value of
the one in the mapping and report the error. If the file is "caught up"
then we just report 0.

This changes the semantics of fsync such that applications can now use
it to determine whether there were any writeback errors since fsync(fd)
was last called (or since the file was opened in the case of fsync
having never been called).

Note that those writeback errors may have occurred when writing data
that was dirtied via an entirely different fd, but that's the case now
with the current mapping_set_error/filemap_check_error infrastructure.
This will at least prevent you from getting a false report of success.

The basic idea here is for filesystems to use filemap_set_wb_error to
set the error in the mapping when there are writeback errors, and then
have the fsync and flush operations call filemap_report_wb_error just
before returning to ensure that those errors get reported properly.

Eventually, it may make sense to move the reporting into the generic
vfs_fsync_range helper, but doing it this way for now makes it simpler
to convert filesystems to the new API individually.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 Documentation/filesystems/vfs.txt | 14 +++++++--
 fs/open.c                         |  3 ++
 include/linux/fs.h                |  5 ++++
 mm/filemap.c                      | 61 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 569211703721..b2b5e411b340 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -577,6 +577,11 @@ should clear PG_Dirty and set PG_Writeback.  It can be actually
 written at any point after PG_Dirty is clear.  Once it is known to be
 safe, PG_Writeback is cleared.
 
+If there is an error during writeback, then the address_space should be
+marked with an error (typically using filemap_set_wb_error), in order to
+ensure that the error can later be reported to the application at fsync
+or close.
+
 Writeback makes use of a writeback_control structure...
 
 struct address_space_operations
@@ -885,11 +890,16 @@ otherwise noted.
 	"private_data" member in the file structure if you want to point
 	to a device structure
 
-  flush: called by the close(2) system call to flush a file
+  flush: called by the close(2) system call to flush a file. Writeback
+	errors not previously reported via fsync should be reported
+	here as you would for fsync.
 
   release: called when the last reference to an open file is closed
 
-  fsync: called by the fsync(2) system call
+  fsync: called by the fsync(2) system call. Filesystems that use the
+	pagecache should call filemap_report_wb_error before returning
+	to ensure that any errors that occurred during writeback are
+	reported and the file's error sequence advanced.
 
   fasync: called by the fcntl(2) system call when asynchronous
 	(non-blocking) mode is enabled for a file
diff --git a/fs/open.c b/fs/open.c
index 949cef29c3bb..26a1483bcad6 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -709,6 +709,9 @@ static int do_dentry_open(struct file *f,
 	f->f_inode = inode;
 	f->f_mapping = inode->i_mapping;
 
+	/* Don't need the i_lock since we're only interested in sequence */
+	f->f_wb_err_seq = inode->i_mapping->wb_err_seq;
+
 	if (unlikely(f->f_flags & O_PATH)) {
 		f->f_mode = FMODE_PATH;
 		f->f_op = &empty_fops;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7251f7bb45e8..88d4577d761a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -394,6 +394,8 @@ struct address_space {
 	gfp_t			gfp_mask;	/* implicit gfp mask for allocations */
 	struct list_head	private_list;	/* ditto */
 	void			*private_data;	/* ditto */
+	u64			wb_err_seq;
+	int			wb_err;
 } __attribute__((aligned(sizeof(long))));
 	/*
 	 * On most architectures that alignment is already the case; but
@@ -868,6 +870,7 @@ struct file {
 	struct list_head	f_tfile_llink;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
+	u64			f_wb_err_seq;
 } __attribute__((aligned(4)));	/* lest something weird decides that 2 is OK */
 
 struct file_handle {
@@ -2521,6 +2524,8 @@ extern int __filemap_fdatawrite_range(struct address_space *mapping,
 extern int filemap_fdatawrite_range(struct address_space *mapping,
 				loff_t start, loff_t end);
 extern int filemap_check_errors(struct address_space *mapping);
+extern void filemap_set_wb_error(struct address_space *mapping, int err);
+extern int filemap_report_wb_error(struct file *file);
 
 extern int vfs_fsync_range(struct file *file, loff_t start, loff_t end,
 			   int datasync);
diff --git a/mm/filemap.c b/mm/filemap.c
index 1694623a6289..703f069b9812 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -546,6 +546,67 @@ int filemap_write_and_wait_range(struct address_space *mapping,
 EXPORT_SYMBOL(filemap_write_and_wait_range);
 
 /**
+ * filemap_set_wb_error - set the wb error in the mapping for later reporting
+ * @mapping: mapping in which the error should be set
+ * @err: error to set
+ *
+ * When an error occurs during writeback of inode data, we must report that
+ * error during fsync. This function sets the writeback error field in the
+ * mapping, and increments the sequence counter. When fsync or close is later
+ * performed, the caller can then check the sequence in the mapping against
+ * the one in the file to determine whether the error should be reported.
+ *
+ * Note that we always use the latest writeback error, under the assumption
+ * that it doesn't really matter which one gets reported in the case where we
+ * have multiple errors (e.g. -EIO followed by -ENOSPC).
+ */
+void filemap_set_wb_error(struct address_space *mapping, int err)
+{
+	struct inode *inode = mapping->host;
+
+	/*
+	 * This should be called with the error code that we want to return
+	 * on fsync. Thus, it should always be <= 0.
+	 */
+	WARN_ON(err > 0);
+
+	spin_lock(&inode->i_lock);
+	mapping->wb_err_seq++;
+	mapping->wb_err = err;
+	spin_unlock(&inode->i_lock);
+}
+EXPORT_SYMBOL(filemap_set_wb_error);
+
+/**
+ * filemap_report_wb_error - report wb error (if any) that was previously set
+ * @file: struct file on which the error is being reported
+ *
+ * When userland calls fsync or close (or something like nfsd does the
+ * equivalent), we want to report any writeback errors that occurred since
+ * the last fsync (or since the file was opened if there haven't been any).
+ *
+ * Check the sequence counter in the file and see if it lags the one in the
+ * mapping. If it does, then return whatever error is in the mapping and
+ * set the sequence counter to the value of the one in the mapping. Otherwise,
+ * return 0.
+ */
+int filemap_report_wb_error(struct file *file)
+{
+	int err = 0;
+	struct inode *inode = file_inode(file);
+	struct address_space *mapping = file->f_mapping;
+
+	spin_lock(&inode->i_lock);
+	if (file->f_wb_err_seq < mapping->wb_err_seq) {
+		err = mapping->wb_err;
+		file->f_wb_err_seq = mapping->wb_err_seq;
+	}
+	spin_unlock(&inode->i_lock);
+	return err;
+}
+EXPORT_SYMBOL(filemap_report_wb_error);
+
+/**
  * replace_page_cache_page - replace a pagecache page with a new one
  * @old:	page to be replaced
  * @new:	page to replace with
-- 
2.9.3
