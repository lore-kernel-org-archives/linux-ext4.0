From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 9/9] fs: move inode_dio_done to the end_io handler
Date: Fri, 24 Jun 2011 14:29:48 -0400
Message-ID: <20110624183208.499610831@bombadil.infradead.org>
References: <20110624182939.401012221@bombadil.infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org
To: viro@zeniv.linux.org.uk, tglx@linutronix.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56821
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453Ab1FXScO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Jun 2011 14:32:14 -0400
Content-Disposition: inline; filename=fs-move-inode_dio_done-to-end_io
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For filesystems that delay their end_io processing we should keep our
i_dio_count until the the processing is done.  Enable this by moving
the inode_dio_done call to the end_io handler if one exist.  Note that
the actual move to the workqueue for ext4 and XFS is not done in
this patch yet, but left to the filesystem maintainers.  At least
for XFS it's not needed yet either as XFS has an internal equivalent
to i_dio_count.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/direct-io.c
===================================================================
--- linux-2.6.orig/fs/direct-io.c	2011-06-24 15:27:14.124896461 +0200
+++ linux-2.6/fs/direct-io.c	2011-06-24 15:47:03.358169584 +0200
@@ -293,11 +293,12 @@ static ssize_t dio_complete(struct dio *
 	if (dio->end_io && dio->result) {
 		dio->end_io(dio->iocb, offset, transferred,
 			    dio->map_bh.b_private, ret, is_async);
-	} else if (is_async) {
-		aio_complete(dio->iocb, ret, 0);
+	} else {
+		if (is_async)
+			aio_complete(dio->iocb, ret, 0);
+		inode_dio_done(dio->inode);
 	}
 
-	inode_dio_done(dio->inode);
 	return ret;
 }
 
Index: linux-2.6/fs/ext4/inode.c
===================================================================
--- linux-2.6.orig/fs/ext4/inode.c	2011-06-24 15:47:13.111502423 +0200
+++ linux-2.6/fs/ext4/inode.c	2011-06-24 15:50:13.471493302 +0200
@@ -3573,6 +3573,7 @@ static void ext4_end_io_dio(struct kiocb
 			    ssize_t size, void *private, int ret,
 			    bool is_async)
 {
+	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
         ext4_io_end_t *io_end = iocb->private;
 	struct workqueue_struct *wq;
 	unsigned long flags;
@@ -3594,6 +3595,7 @@ static void ext4_end_io_dio(struct kiocb
 out:
 		if (is_async)
 			aio_complete(iocb, ret, 0);
+		inode_dio_done(inode);
 		return;
 	}
 
@@ -3614,6 +3616,9 @@ out:
 	/* queue the work to convert unwritten extents to written */
 	queue_work(wq, &io_end->work);
 	iocb->private = NULL;
+
+	/* XXX: probably should move into the real I/O completion handler */
+	inode_dio_done(inode);
 }
 
 static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
Index: linux-2.6/fs/ocfs2/aops.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/aops.c	2011-06-24 15:49:26.731495659 +0200
+++ linux-2.6/fs/ocfs2/aops.c	2011-06-24 15:49:48.324827901 +0200
@@ -577,6 +577,7 @@ static void ocfs2_dio_end_io(struct kioc
 
 	if (is_async)
 		aio_complete(iocb, ret, 0);
+	inode_dio_done(inode);
 }
 
 /*
Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2011-06-24 15:48:25.581498754 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2011-06-24 15:51:00.874824252 +0200
@@ -1339,6 +1339,9 @@ xfs_end_io_direct_write(
 	} else {
 		xfs_finish_ioend_sync(ioend);
 	}
+
+	/* XXX: probably should move into the real I/O completion handler */
+	inode_dio_done(ioend->io_inode);
 }
 
 STATIC ssize_t

