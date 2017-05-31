From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v5 10/17] block: add sync_blockdev_since and sync_filesystem_since
Date: Wed, 31 May 2017 08:45:33 -0400
Message-ID: <20170531124540.8782-11-jlayton@redhat.com>
References: <20170531124540.8782-1-jlayton@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170531124540.8782-1-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

New variants of sync_filesystem and sync_blockdev.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/block_dev.c     | 15 +++++++++++++++
 fs/internal.h      |  8 ++++++++
 fs/sync.c          | 45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h | 13 ++++++++++++-
 4 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 0d5f849e2a18..9da613ec1665 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -452,6 +452,15 @@ int __sync_blockdev(struct block_device *bdev, int wait)
 	return filemap_write_and_wait(bdev->bd_inode->i_mapping);
 }
 
+int __sync_blockdev_since(struct block_device *bdev, int wait, errseq_t since)
+{
+	if (!bdev)
+		return 0;
+	if (!wait)
+		return filemap_flush(bdev->bd_inode->i_mapping);
+	return filemap_write_and_wait_since(bdev->bd_inode->i_mapping, since);
+}
+
 /*
  * Write out and wait upon all the dirty data associated with a block
  * device via its mapping.  Does not take the superblock lock.
@@ -462,6 +471,12 @@ int sync_blockdev(struct block_device *bdev)
 }
 EXPORT_SYMBOL(sync_blockdev);
 
+int sync_blockdev_since(struct block_device *bdev, errseq_t since)
+{
+	return __sync_blockdev_since(bdev, 1, since);
+}
+EXPORT_SYMBOL(sync_blockdev_since);
+
 /*
  * Write out and wait upon all dirty data associated with this
  * device.   Filesystem data as well as the underlying block
diff --git a/fs/internal.h b/fs/internal.h
index 9676fe11c093..234343ba8af7 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -25,6 +25,8 @@ struct shrink_control;
 extern void __init bdev_cache_init(void);
 
 extern int __sync_blockdev(struct block_device *bdev, int wait);
+extern int __sync_blockdev_since(struct block_device *bdev, int wait,
+					errseq_t since);
 
 #else
 static inline void bdev_cache_init(void)
@@ -35,6 +37,12 @@ static inline int __sync_blockdev(struct block_device *bdev, int wait)
 {
 	return 0;
 }
+
+static inline int __sync_blockdev_since(struct block_device *bdev, int wait,
+					errseq_t since)
+{
+	return 0;
+}
 #endif
 
 /*
diff --git a/fs/sync.c b/fs/sync.c
index 819a81526714..2a8202f9eb21 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -71,6 +71,51 @@ int sync_filesystem(struct super_block *sb)
 }
 EXPORT_SYMBOL(sync_filesystem);
 
+static int __sync_filesystem_since(struct super_block *sb, int wait,
+					errseq_t since)
+{
+	int fs_ret = 0, bd_ret;
+
+	if (wait)
+		sync_inodes_sb(sb);
+	else
+		writeback_inodes_sb(sb, WB_REASON_SYNC);
+
+	if (sb->s_op->sync_fs)
+		fs_ret = sb->s_op->sync_fs(sb, wait);
+	bd_ret = __sync_blockdev_since(sb->s_bdev, wait, since);
+
+	return fs_ret ? fs_ret : bd_ret;
+}
+
+/*
+ * Write out and wait upon all dirty data associated with this
+ * superblock.  Filesystem data as well as the underlying block
+ * device.  Takes the superblock lock.
+ */
+int sync_filesystem_since(struct super_block *sb, errseq_t since)
+{
+	int ret;
+
+	/*
+	 * We need to be protected against the filesystem going from
+	 * r/o to r/w or vice versa.
+	 */
+	WARN_ON(!rwsem_is_locked(&sb->s_umount));
+
+	/*
+	 * No point in syncing out anything if the filesystem is read-only.
+	 */
+	if (sb->s_flags & MS_RDONLY)
+		return 0;
+
+	ret = __sync_filesystem_since(sb, 0, since);
+	if (ret < 0)
+		return ret;
+	return __sync_filesystem_since(sb, 1, since);
+}
+EXPORT_SYMBOL(sync_filesystem_since);
+
 static void sync_inodes_one_sb(struct super_block *sb, void *arg)
 {
 	if (!(sb->s_flags & MS_RDONLY))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7d1bd3163d99..f483c23866c4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2376,6 +2376,7 @@ extern void bdput(struct block_device *);
 extern void invalidate_bdev(struct block_device *);
 extern void iterate_bdevs(void (*)(struct block_device *, void *), void *);
 extern int sync_blockdev(struct block_device *bdev);
+extern int sync_blockdev_since(struct block_device *bdev, errseq_t since);
 extern void kill_bdev(struct block_device *);
 extern struct super_block *freeze_bdev(struct block_device *);
 extern void emergency_thaw_all(void);
@@ -2390,7 +2391,16 @@ static inline bool sb_is_blkdev_sb(struct super_block *sb)
 }
 #else
 static inline void bd_forget(struct inode *inode) {}
-static inline int sync_blockdev(struct block_device *bdev) { return 0; }
+static inline int sync_blockdev(struct block_device *bdev)
+{
+	return 0;
+}
+
+static inline int sync_blockdev_since(struct block_device *bdev,
+							errseq_t since)
+{
+	return 0;
+}
 static inline void kill_bdev(struct block_device *bdev) {}
 static inline void invalidate_bdev(struct block_device *bdev) {}
 
@@ -2414,6 +2424,7 @@ static inline bool sb_is_blkdev_sb(struct super_block *sb)
 }
 #endif
 extern int sync_filesystem(struct super_block *);
+extern int sync_filesystem_since(struct super_block *, errseq_t);
 extern const struct file_operations def_blk_fops;
 extern const struct file_operations def_chr_fops;
 #ifdef CONFIG_BLOCK
-- 
2.9.4
