From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] xfs: fold xfs_vm_do_dio into xfs_vm_direct_IO
Date: Wed,  3 Feb 2016 19:40:16 +0100
Message-ID: <1454524816-11392-4-git-send-email-hch@lst.de>
References: <1454524816-11392-1-git-send-email-hch@lst.de>
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59980 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933852AbcBCSkX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Feb 2016 13:40:23 -0500
In-Reply-To: <1454524816-11392-1-git-send-email-hch@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_aops.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f008a4f..8163910 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1596,38 +1596,30 @@ xfs_end_io_direct_write(
 	return error;
 }
 
-static inline ssize_t
-xfs_vm_do_dio(
-	struct inode		*inode,
+STATIC ssize_t
+xfs_vm_direct_IO(
 	struct kiocb		*iocb,
 	struct iov_iter		*iter,
-	loff_t			offset,
-	dio_iodone_t		endio,
-	int			flags)
+	loff_t			offset)
 {
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	dio_iodone_t		*endio = NULL;
+	int			flags = 0;
 	struct block_device	*bdev;
 
-	if (IS_DAX(inode))
+	if (iov_iter_rw(iter) == WRITE) {
+		endio = xfs_end_io_direct_write;
+		flags = DIO_ASYNC_EXTEND;
+	}
+
+	if (IS_DAX(inode)) {
 		return dax_do_io(iocb, inode, iter, offset,
 				 xfs_get_blocks_direct, endio, 0);
+	}
 
 	bdev = xfs_find_bdev_for_inode(inode);
 	return  __blockdev_direct_IO(iocb, inode, bdev, iter, offset,
-				     xfs_get_blocks_direct, endio, NULL, flags);
-}
-
-STATIC ssize_t
-xfs_vm_direct_IO(
-	struct kiocb		*iocb,
-	struct iov_iter		*iter,
-	loff_t			offset)
-{
-	struct inode		*inode = iocb->ki_filp->f_mapping->host;
