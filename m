From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] xfs: move aio completion after unwritten extent conversion
Date: Tue, 22 Jun 2010 08:21:46 -0400
Message-ID: <20100622123113.205150586@bombadil.infradead.org>
References: <20100622122144.302857146@bombadil.infradead.org>
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46253 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab0FVMbN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jun 2010 08:31:13 -0400
Content-Disposition: inline; filename=xfs-unwritten-fix
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we write into an unwritten extent using AIO we need to complete the AIO
request after the extent conversion has finished.  Without that a read could
race to see see the extent still unwritten and return zeros.   For synchronous
I/O we already take care of that by flushing the xfsconvertd workqueue (which
might be a bit of overkill).

To do that add iocb and result fields to struct xfs_ioend, so that we can
call aio_complete from xfs_end_io after the extent conversion has happened.
Note that we need a new result field as io_error is used for positive errno
values, while the AIO code can return negative error values and positive
transfer sizes.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-06-22 14:05:02.522005722 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2010-06-22 14:08:30.065006205 +0200
@@ -275,8 +275,11 @@ xfs_end_io(
 		xfs_finish_ioend(ioend, 0);
 		/* ensure we don't spin on blocked ioends */
 		delay(1);
-	} else
+	} else {
+		if (ioend->io_iocb)
+			aio_complete(ioend->io_iocb, ioend->io_result, 0);
 		xfs_destroy_ioend(ioend);
+	}
 }
 
 /*
@@ -309,6 +312,8 @@ xfs_alloc_ioend(
 	atomic_inc(&XFS_I(ioend->io_inode)->i_iocount);
 	ioend->io_offset = 0;
 	ioend->io_size = 0;
+	ioend->io_iocb = NULL;
+	ioend->io_result = 0;
 
 	INIT_WORK(&ioend->io_work, xfs_end_io);
 	return ioend;
@@ -1604,6 +1609,7 @@ xfs_end_io_direct(
 	bool		is_async)
 {
 	xfs_ioend_t	*ioend = iocb->private;
+	bool		complete_aio = is_async;
 
 	/*
 	 * Non-NULL private data means we need to issue a transaction to
@@ -1629,7 +1635,14 @@ xfs_end_io_direct(
 	if (ioend->io_type == IO_READ) {
 		xfs_finish_ioend(ioend, 0);
 	} else if (private && size > 0) {
-		xfs_finish_ioend(ioend, is_sync_kiocb(iocb));
+		if (is_async) {
+			ioend->io_iocb = iocb;
+			ioend->io_result = ret;
+			complete_aio = false;
+			xfs_finish_ioend(ioend, 0);
+		} else {
+			xfs_finish_ioend(ioend, 1);
+		}
 	} else {
 		/*
 		 * A direct I/O write ioend starts it's life in unwritten
@@ -1648,7 +1661,7 @@ xfs_end_io_direct(
 	 */
 	iocb->private = NULL;
 
-	if (is_async)
+	if (complete_aio)
 		aio_complete(iocb, ret, 0);
 }
 

