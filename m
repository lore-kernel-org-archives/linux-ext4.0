From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] add releasepage hooks to block devices which can be used by file systems
Date: Sat,  3 Jan 2009 10:09:16 -0500
Message-ID: <1230995358-24013-2-git-send-email-tytso@mit.edu>
References: <20081226050138.GU28946@ZenIV.linux.org.uk>
 <1230995358-24013-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	linux-fsdevel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37210 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758702AbZACPJy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Jan 2009 10:09:54 -0500
In-Reply-To: <1230995358-24013-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Implement blkdev_releasepage() to release the buffer_heads and pages
after we release private data belonging to a mounted filesystem.

Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/block_dev.c     |   15 +++++++++++++++
 fs/super.c         |    2 ++
 include/linux/fs.h |    2 ++
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 99e0ae1..ef7d795 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1219,6 +1219,20 @@ static long block_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	return blkdev_ioctl(bdev, mode, cmd, arg);
 }
 
+/*
+ * Try to release a page associated with block device when the system
+ * is under memory pressure.
+ */
+static int blkdev_releasepage(struct page *page, gfp_t wait)
+{
+	struct super_block *super = BDEV_I(page->mapping->host)->bdev.bd_super;
+
+	if (super && super->s_op->bdev_try_to_free_page)
+		return super->s_op->bdev_try_to_free_page(super, page, wait);
+
+	return try_to_free_buffers(page);
+}
+
 static const struct address_space_operations def_blk_aops = {
 	.readpage	= blkdev_readpage,
 	.writepage	= blkdev_writepage,
@@ -1226,6 +1240,7 @@ static const struct address_space_operations def_blk_aops = {
 	.write_begin	= blkdev_write_begin,
 	.write_end	= blkdev_write_end,
 	.writepages	= generic_writepages,
+	.releasepage	= blkdev_releasepage,
 	.direct_IO	= blkdev_direct_IO,
 };
 
diff --git a/fs/super.c b/fs/super.c
index 400a760..d7e200d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -800,6 +800,7 @@ int get_sb_bdev(struct file_system_type *fs_type,
 		}
 
 		s->s_flags |= MS_ACTIVE;
+		bdev->bd_super = s;
 	}
 
 	return simple_set_mnt(mnt, s);
@@ -819,6 +820,7 @@ void kill_block_super(struct super_block *sb)
 	struct block_device *bdev = sb->s_bdev;
 	fmode_t mode = sb->s_mode;
 
+	bdev->bd_super = 0;
 	generic_shutdown_super(sb);
 	sync_blockdev(bdev);
 	close_bdev_exclusive(bdev, mode);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4a853ef..911f812 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -553,6 +553,7 @@ struct address_space {
 struct block_device {
 	dev_t			bd_dev;  /* not a kdev_t - it's a search key */
 	struct inode *		bd_inode;	/* will die */
+	struct super_block *	bd_super;
 	int			bd_openers;
 	struct mutex		bd_mutex;	/* open/close mutex */
 	struct semaphore	bd_mount_sem;
@@ -1375,6 +1376,7 @@ struct super_operations {
 	ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t);
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
+	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
 };
 
 /*
-- 
1.6.0.4.8.g36f27.dirty

