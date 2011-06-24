From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 8/9] fs: simplify the blockdev_direct_IO prototype
Date: Fri, 24 Jun 2011 14:29:47 -0400
Message-ID: <20110624183208.310463909@bombadil.infradead.org>
References: <20110624182939.401012221@bombadil.infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org
To: viro@zeniv.linux.org.uk, tglx@linutronix.de
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline; filename=fs-simplify-blockdev_direct_IO-prototype
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Simple filesystems always pass inode->i_sb_bdev as the block device
argument, and never need a end_io handler.  Let's simply things for
them and for my grepping activity by dropping these arguments.  The
only thing not falling into that scheme is ext4, which passes and
end_io handler without needing special flags (yet), but given how
messy the direct I/O code there is use of __blockdev_direct_IO
in one instead of two out of three cases isn't going to make a large
difference anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/ext2/inode.c
===================================================================
--- linux-2.6.orig/fs/ext2/inode.c	2011-06-24 15:27:33.131562166 +0200
+++ linux-2.6/fs/ext2/inode.c	2011-06-24 15:43:31.164846996 +0200
@@ -843,8 +843,8 @@ ext2_direct_IO(int rw, struct kiocb *ioc
 	struct inode *inode = mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
-				iov, offset, nr_segs, ext2_get_block, NULL);
+	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+				 ext2_get_block);
 	if (ret < 0 && (rw & WRITE))
 		ext2_write_failed(mapping, offset + iov_length(iov, nr_segs));
 	return ret;
Index: linux-2.6/fs/ext3/inode.c
===================================================================
--- linux-2.6.orig/fs/ext3/inode.c	2011-06-24 15:27:33.151562165 +0200
+++ linux-2.6/fs/ext3/inode.c	2011-06-24 15:28:09.048226915 +0200
@@ -1816,9 +1816,8 @@ static ssize_t ext3_direct_IO(int rw, st
 	}
 
 retry:
-	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				 offset, nr_segs,
-				 ext3_get_block, NULL);
+	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+				 ext3_get_block);
 	/*
 	 * In case of error extending write may have instantiated a few
 	 * blocks outside i_size. Trim these off again.
Index: linux-2.6/fs/ext4/inode.c
===================================================================
--- linux-2.6.orig/fs/ext4/inode.c	2011-06-24 15:27:33.171562165 +0200
+++ linux-2.6/fs/ext4/inode.c	2011-06-24 15:32:40.694879881 +0200
@@ -3501,10 +3501,8 @@ retry:
 				 offset, nr_segs,
 				 ext4_get_block, NULL, NULL, 0);
 	else {
-		ret = blockdev_direct_IO(rw, iocb, inode,
-				 inode->i_sb->s_bdev, iov,
-				 offset, nr_segs,
-				 ext4_get_block, NULL);
+		ret = blockdev_direct_IO(rw, iocb, inode, iov,
+				 offset, nr_segs, ext4_get_block);
 
 		if (unlikely((rw & WRITE) && ret < 0)) {
 			loff_t isize = i_size_read(inode);
@@ -3748,11 +3746,13 @@ static ssize_t ext4_ext_direct_IO(int rw
 			EXT4_I(inode)->cur_aio_dio = iocb->private;
 		}
 
-		ret = blockdev_direct_IO(rw, iocb, inode,
+		ret = __blockdev_direct_IO(rw, iocb, inode,
 					 inode->i_sb->s_bdev, iov,
 					 offset, nr_segs,
 					 ext4_get_block_write,
-					 ext4_end_io_dio);
+					 ext4_end_io_dio,
+					 NULL,
+					 DIO_LOCKING | DIO_SKIP_HOLES);
 		if (iocb->private)
 			EXT4_I(inode)->cur_aio_dio = NULL;
 		/*
Index: linux-2.6/fs/fat/inode.c
===================================================================
--- linux-2.6.orig/fs/fat/inode.c	2011-06-24 15:27:33.188228830 +0200
+++ linux-2.6/fs/fat/inode.c	2011-06-24 15:32:48.341546189 +0200
@@ -211,8 +211,8 @@ static ssize_t fat_direct_IO(int rw, str
 	 * FAT need to use the DIO_LOCKING for avoiding the race
 	 * condition of fat_get_block() and ->truncate().
 	 */
-	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
-				 iov, offset, nr_segs, fat_get_block, NULL);
+	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+				 fat_get_block);
 	if (ret < 0 && (rw & WRITE))
 		fat_write_failed(mapping, offset + iov_length(iov, nr_segs));
 
Index: linux-2.6/fs/hfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hfs/inode.c	2011-06-24 15:27:33.228228829 +0200
+++ linux-2.6/fs/hfs/inode.c	2011-06-24 15:29:45.218222143 +0200
@@ -123,8 +123,8 @@ static ssize_t hfs_direct_IO(int rw, str
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				  offset, nr_segs, hfs_get_block, NULL);
+	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+				 hfs_get_block);
 
 	/*
 	 * In case of error extending write may have instantiated a few
Index: linux-2.6/fs/hfsplus/inode.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/inode.c	2011-06-24 15:27:33.244895494 +0200
+++ linux-2.6/fs/hfsplus/inode.c	2011-06-24 15:29:59.911554734 +0200
@@ -119,8 +119,8 @@ static ssize_t hfsplus_direct_IO(int rw,
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				  offset, nr_segs, hfsplus_get_block, NULL);
+	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+				 hfsplus_get_block);
 
 	/*
 	 * In case of error extending write may have instantiated a few
Index: linux-2.6/fs/jfs/inode.c
===================================================================
--- linux-2.6.orig/fs/jfs/inode.c	2011-06-24 15:27:33.264895492 +0200
+++ linux-2.6/fs/jfs/inode.c	2011-06-24 15:30:11.701554144 +0200
@@ -329,8 +329,8 @@ static ssize_t jfs_direct_IO(int rw, str
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				offset, nr_segs, jfs_get_block, NULL);
+	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+				 jfs_get_block);
 
 	/*
 	 * In case of error extending write may have instantiated a few
Index: linux-2.6/fs/nilfs2/inode.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/inode.c	2011-06-24 15:27:33.284895493 +0200
+++ linux-2.6/fs/nilfs2/inode.c	2011-06-24 15:30:24.968220135 +0200
@@ -259,8 +259,8 @@ nilfs_direct_IO(int rw, struct kiocb *io
 		return 0;
 
 	/* Needs synchronization with the cleaner */
-	size = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				  offset, nr_segs, nilfs_get_block, NULL);
+	size = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+				  nilfs_get_block);
 
 	/*
 	 * In case of error extending write may have instantiated a few
Index: linux-2.6/fs/reiserfs/inode.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/inode.c	2011-06-24 15:27:33.324895489 +0200
+++ linux-2.6/fs/reiserfs/inode.c	2011-06-24 15:30:38.311552796 +0200
@@ -3068,9 +3068,8 @@ static ssize_t reiserfs_direct_IO(int rw
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				  offset, nr_segs,
-				  reiserfs_get_blocks_direct_io, NULL);
+	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+				  reiserfs_get_blocks_direct_io);
 
 	/*
 	 * In case of error extending write may have instantiated a few
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2011-06-24 15:27:33.361562155 +0200
+++ linux-2.6/include/linux/fs.h	2011-06-24 15:46:57.914836526 +0200
@@ -2381,12 +2381,11 @@ ssize_t __blockdev_direct_IO(int rw, str
 	dio_submit_t submit_io,	int flags);
 
 static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
-	struct inode *inode, struct block_device *bdev, const struct iovec *iov,
-	loff_t offset, unsigned long nr_segs, get_block_t get_block,
-	dio_iodone_t end_io)
+		struct inode *inode, const struct iovec *iov, loff_t offset,
+		unsigned long nr_segs, get_block_t get_block)
 {
-	return __blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
-				    nr_segs, get_block, end_io, NULL,
+	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
+				    offset, nr_segs, get_block, NULL, NULL,
 				    DIO_LOCKING | DIO_SKIP_HOLES);
 }
 #endif

