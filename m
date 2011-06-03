From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Query about DIO/AIO WRITE throttling and ext4 serialization
Date: Thu, 2 Jun 2011 21:02:33 -0400
Message-ID: <20110603010233.GA17726@infradead.org>
References: <20110601215049.GC17449@redhat.com>
 <20110602012209.GQ561@dastard>
 <20110602141716.GD18712@redhat.com>
 <20110602143633.GE18712@redhat.com>
 <20110602155610.GF18712@redhat.com>
 <20110602235153.GV561@dastard>
 <20110603002714.GA27129@redhat.com>
 <20110603004300.GE16306@thunk.org>
 <20110603005403.GB27129@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
	linux-ext4@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50213
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753634Ab1FCBCj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jun 2011 21:02:39 -0400
Content-Disposition: inline
In-Reply-To: <20110603005403.GB27129@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 02, 2011 at 08:54:03PM -0400, Vivek Goyal wrote:
> Just wondering why ext4 and XFS behavior are different and which is a
> more appropriate behavior. ext4 does not seem to be waiting for all
> pending AIO/DIO to finish while XFS does.

They're both wrong.  Ext4 completely misses support in fsync or sync
to catch pending unwrittent extent conversions, and thus fails to obey
the data integrity guarante.  XFS is beeing rather stupid about the
amount of synchronization it requires.  The untested patch below
should help with avoiding the synchronization if you're purely doing
overwrites:


Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2011-06-03 09:54:52.964337556 +0900
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2011-06-03 09:57:06.877674259 +0900
@@ -270,7 +270,7 @@ xfs_finish_ioend_sync(
  * (vs. incore size).
  */
 STATIC xfs_ioend_t *
-xfs_alloc_ioend(
+__xfs_alloc_ioend(
 	struct inode		*inode,
 	unsigned int		type)
 {
@@ -290,7 +290,6 @@ xfs_alloc_ioend(
 	ioend->io_inode = inode;
 	ioend->io_buffer_head = NULL;
 	ioend->io_buffer_tail = NULL;
-	atomic_inc(&XFS_I(ioend->io_inode)->i_iocount);
 	ioend->io_offset = 0;
 	ioend->io_size = 0;
 	ioend->io_iocb = NULL;
@@ -300,6 +299,18 @@ xfs_alloc_ioend(
 	return ioend;
 }
 
+STATIC xfs_ioend_t *
+xfs_alloc_ioend(
+	struct inode		*inode,
+	unsigned int		type)
+{
+	struct xfs_ioend	*ioend;
+
+	ioend = __xfs_alloc_ioend(inode, type);
+	atomic_inc(&XFS_I(ioend->io_inode)->i_iocount);
+	return ioend;
+}
+
 STATIC int
 xfs_map_blocks(
 	struct inode		*inode,
@@ -1318,6 +1329,7 @@ xfs_end_io_direct_write(
 	 */
 	iocb->private = NULL;
 
+	atomic_inc(&XFS_I(ioend->io_inode)->i_iocount);
 	ioend->io_offset = offset;
 	ioend->io_size = size;
 	if (private && size > 0)
@@ -1354,7 +1366,7 @@ xfs_vm_direct_IO(
 	ssize_t			ret;
 
 	if (rw & WRITE) {
-		iocb->private = xfs_alloc_ioend(inode, IO_DIRECT);
+		iocb->private = __xfs_alloc_ioend(inode, IO_DIRECT);
 
 		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
 					    offset, nr_segs,
