From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH 4/4] ext4: wire it up to the new writeback error reporting infrastructure
Date: Fri, 31 Mar 2017 15:26:03 -0400
Message-ID: <20170331192603.16442-5-jlayton@redhat.com>
References: <20170331192603.16442-1-jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz,
        willy@infradead.org, neilb@suse.com
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43542 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755448AbdCaT0J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 31 Mar 2017 15:26:09 -0400
In-Reply-To: <20170331192603.16442-1-jlayton@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Convert ext4 to use filemap_set_wb_error for reporting writeback errors
instead of mapping_set_error. Ensure that it calls filemap_report_wb_error
before returning from fsync, and add a new flush operation that ensures
that just calls filemap_report_wb_error before returning.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ext4/dir.c     |  1 +
 fs/ext4/ext4.h    |  1 +
 fs/ext4/file.c    |  1 +
 fs/ext4/fsync.c   | 15 +++++++++++----
 fs/ext4/inode.c   |  2 +-
 fs/ext4/page-io.c |  4 ++--
 6 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index e8b365000d73..c333b148b5fe 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -656,6 +656,7 @@ const struct file_operations ext4_dir_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext4_compat_ioctl,
 #endif
+	.flush		= ext4_flush_file,
 	.fsync		= ext4_sync_file,
 	.open		= ext4_dir_open,
 	.release	= ext4_release_dir,
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f493af666591..20437bedeed0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2382,6 +2382,7 @@ extern int ext4_check_all_de(struct inode *dir, struct buffer_head *bh,
 
 /* fsync.c */
 extern int ext4_sync_file(struct file *, loff_t, loff_t, int);
+extern int ext4_flush_file(struct file *, fl_owner_t);
 
 /* hash.c */
 extern int ext4fs_dirhash(const char *name, int len, struct
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 8210c1f43556..cc536a1aa731 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -735,6 +735,7 @@ const struct file_operations ext4_file_operations = {
 	.mmap		= ext4_file_mmap,
 	.open		= ext4_file_open,
 	.release	= ext4_release_file,
+	.flush		= ext4_flush_file,
 	.fsync		= ext4_sync_file,
 	.get_unmapped_area = thp_get_unmapped_area,
 	.splice_read	= generic_file_splice_read,
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 9d549608fd30..e381ab03f1cc 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -79,6 +79,11 @@ static int ext4_sync_parent(struct inode *inode)
 	return ret;
 }
 
+int ext4_flush_file(struct file *file, fl_owner_t id)
+{
+	return filemap_report_wb_error(file);
+}
+
 /*
  * akpm: A new design for ext4_sync_file().
  *
@@ -96,12 +101,12 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	struct inode *inode = file->f_mapping->host;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
-	int ret = 0, err;
+	int ret = -EIO, err;
 	tid_t commit_tid;
 	bool needs_barrier = false;
 
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
-		return -EIO;
+		goto out;
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
 
@@ -110,6 +115,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (inode->i_sb->s_flags & MS_RDONLY) {
 		/* Make sure that we read updated s_mount_flags value */
 		smp_rmb();
+		ret = 0;
 		if (EXT4_SB(inode->i_sb)->s_mount_flags & EXT4_MF_FS_ABORTED)
 			ret = -EROFS;
 		goto out;
@@ -126,7 +132,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (ret)
-		return ret;
+		goto out;
 	/*
 	 * data=writeback,ordered:
 	 *  The caller's filemap_fdatawrite()/wait will sync the data.
@@ -159,5 +165,6 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	}
 out:
 	trace_ext4_sync_file_exit(inode, ret);
-	return ret;
+	err = filemap_report_wb_error(file);
+	return ret ? : err;
 }
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4247d8d25687..b9c8a73c404b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2634,7 +2634,7 @@ static int __writepage(struct page *page, struct writeback_control *wbc,
 {
 	struct address_space *mapping = data;
 	int ret = ext4_writepage(page, wbc);
-	mapping_set_error(mapping, ret);
+	filemap_set_wb_error(mapping, ret);
 	return ret;
 }
 
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 208241b06662..5adcf5d0ee9a 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -87,7 +87,7 @@ static void ext4_finish_bio(struct bio *bio)
 
 		if (bio->bi_error) {
 			SetPageError(page);
-			mapping_set_error(page->mapping, -EIO);
+			filemap_set_wb_error(page->mapping, -EIO);
 		}
 		bh = head = page_buffers(page);
 		/*
@@ -311,7 +311,7 @@ static void ext4_end_bio(struct bio *bio)
 			     (long) io_end->size,
 			     (unsigned long long)
 			     bi_sector >> (inode->i_blkbits - 9));
-		mapping_set_error(inode->i_mapping, bio->bi_error);
+		filemap_set_wb_error(inode->i_mapping, bio->bi_error);
 	}
 
 	if (io_end->flag & EXT4_IO_END_UNWRITTEN) {
-- 
2.9.3
