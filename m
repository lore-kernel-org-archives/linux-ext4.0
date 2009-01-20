From: Jan Kara <jack@suse.cz>
Subject: [RFC] [PATCH] vfs: Call filesystem callback when backing device
	caches should be flushed
Date: Tue, 20 Jan 2009 17:05:27 +0100
Message-ID: <20090120160527.GA17067@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@MIT.EDU>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

  we noted in our testing that ext2 (and it seems some other filesystems as
well) don't flush disk's write caches on cases like fsync() or changing
DIRSYNC directory. This is my attempt to solve the problem in a generic way
by calling a filesystem callback from VFS at appropriate place as Andrew
suggested. For ext2 what I did is enough (it just then fills in
block_flush_device() as .flush_device callback) and I think it could be
fine for other filesystems as well.
  There is one remaining issue though: Should we call .flush_device in
generic_sync_sb_inodes()? Generally places like __fsync_super() or
do_sync() seem more appropriate (although in do_sync() we'd have to
do one more traversal of superblocks) to me. But maybe question which
should be answered first is: Is it correct how we implement __fsync_super()
or do_sync()? E.g. in do_sync() we do:

        sync_inodes(0);         /* All mappings, inodes and their blockdevs */
        DQUOT_SYNC(NULL);
        sync_supers();          /* Write the superblocks */
        sync_filesystems(0);    /* Start syncing the filesystems */
        sync_filesystems(wait); /* Waitingly sync the filesystems */
        sync_inodes(wait);      /* Mappings, inodes and blockdevs, again.  */

  But sync_inodes(0) results in writeback done with WB_SYNC_NONE which does
not have to flush all the dirty data. So until last sync_inodes(wait) we
cannot be sure that all the dirty data has been submitted to disk. But such
writes could in theory dirty the superblock or similar structures again. So
shouldn't we rather do:
	...
        sync_inodes(wait);      /* Mappings, inodes and blockdevs, again.  */
        sync_filesystems(wait); /* Waitingly sync the filesystems */


  And one more question: Should we also call .flush_device after fsync?
Filesystems can already issue the flush in their .fsync callbacks so it's
not necessary. The question is what's easier to use...
  Thanks for comments.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

>From e2881e76d119e52c2fbc32663d9c1b70778fb946 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 19 Jan 2009 18:52:20 +0100
Subject: [RFC] [PATCH] vfs: Call filesystem callback when backing device caches should be flushed

This patch introduces a new callback flush_device() which is called when
writeback caches of underlying block device should be flushed. This is
generally after some syncing operation took place.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 |   11 +++++++++++
 fs/fs-writeback.c           |   16 ++++++++++++++++
 include/linux/buffer_head.h |    1 +
 include/linux/fs.h          |    1 +
 4 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b6e8b86..1be876c 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -165,6 +165,17 @@ void end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 	put_bh(bh);
 }
 
+/* Issue flush of write caches on the block device */
+int block_flush_device(struct super_block *sb)
+{
+	int ret = blkdev_issue_flush(sb->s_bdev, NULL);
+
+	if (ret == -EOPNOTSUPP)
+		return 0;
+	return ret;
+}
+EXPORT_SYMBOL(block_flush_device);
+
 /*
  * Write out and wait upon all the dirty data associated with a block
  * device via its mapping.  Does not take the superblock lock.
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e5eaa62..fcfacb2 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -412,6 +412,16 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 }
 
 /*
+ * Make filesystem flush backing device of the filesystem
+ */
+static int flush_backing_device(struct super_block *sb)
+{
+	if (sb->s_op->flush_device)
+		return sb->s_op->flush_device(sb);
+	return 0;
+}
+
+/*
  * Write out a superblock's list of dirty inodes.  A wait will be performed
  * upon no inodes, all inodes or the final one, depending upon sync_mode.
  *
@@ -557,6 +567,7 @@ void generic_sync_sb_inodes(struct super_block *sb,
 		}
 		spin_unlock(&inode_lock);
 		iput(old_inode);
+		flush_backing_device(sb);
 	} else
 		spin_unlock(&inode_lock);
 
@@ -752,6 +763,8 @@ int sync_inode(struct inode *inode, struct writeback_control *wbc)
 	spin_lock(&inode_lock);
 	ret = __writeback_single_inode(inode, wbc);
 	spin_unlock(&inode_lock);
+	if (!ret && wbc->sync_mode == WB_SYNC_ALL)
+		ret = flush_backing_device(inode->i_sb);
 	return ret;
 }
 EXPORT_SYMBOL(sync_inode);
@@ -806,6 +819,9 @@ int generic_osync_inode(struct inode *inode, struct address_space *mapping, int
 	else
 		inode_sync_wait(inode);
 
+	if (!err)
+		err = flush_backing_device(inode->i_sb);
+
 	return err;
 }
 EXPORT_SYMBOL(generic_osync_inode);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index bd7ac79..c154cfd 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -238,6 +238,7 @@ int nobh_write_end(struct file *, struct address_space *,
 int nobh_truncate_page(struct address_space *, loff_t, get_block_t *);
 int nobh_writepage(struct page *page, get_block_t *get_block,
                         struct writeback_control *wbc);
+int block_flush_device(struct super_block *sb);
 
 void buffer_init(void);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6022f44..c37f9f0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1390,6 +1390,7 @@ struct super_operations {
 	int (*remount_fs) (struct super_block *, int *, char *);
 	void (*clear_inode) (struct inode *);
 	void (*umount_begin) (struct super_block *);
+	int (*flush_device) (struct super_block *);
 
 	int (*show_options)(struct seq_file *, struct vfsmount *);
 	int (*show_stats)(struct seq_file *, struct vfsmount *);
-- 
1.6.0.2

