From: Waiman Long <Waiman.Long@hpe.com>
Subject: [PATCH v4 1/2] ext4: Add DIO_SKIP_DIO_COUNT flag to dax_do_io()
Date: Fri, 15 Apr 2016 15:03:11 -0400
Message-ID: <1460746992-1443-2-git-send-email-Waiman.Long@hpe.com>
References: <1460746992-1443-1-git-send-email-Waiman.Long@hpe.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
	Dave Chinner <david@fromorbit.com>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>,
	Waiman Long <Waiman.Long@hpe.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g2t4625.austin.hp.com ([15.73.212.76]:42487 "EHLO
	g2t4625.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbcDOTDg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Apr 2016 15:03:36 -0400
Received: from g2t4621.austin.hp.com (g2t4621.austin.hp.com [15.73.212.80])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t4625.austin.hp.com (Postfix) with ESMTPS id 720644DD7
	for <linux-ext4@vger.kernel.org>; Fri, 15 Apr 2016 19:03:34 +0000 (UTC)
In-Reply-To: <1460746992-1443-1-git-send-email-Waiman.Long@hpe.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When performing direct I/O on DAX, the current ext4 code does not pass
in the DIO_SKIP_DIO_COUNT flag to dax_do_io() when inode_dio_begin()
has, in fact, been called. This causes dax_do_io() to invoke the
inode_dio_begin()/inode_dio_end() pair internally.  This doubling of
inode_dio_begin()/inode_dio_end() calls are wasteful.

For __blockdev_direct_IO(), however, the inode_dio_end() call can be
deferred for AIO. So setting DIO_SKIP_DIO_COUNT may not be appropriate.

This patch removes the extra internal inode_dio_begin()/inode_dio_end()
calls for DAX when those calls are being issued by the caller
directly. For really fast storage systems like NVDIMM, the removal
of the extra inode_dio_begin()/inode_dio_end() can give a meaningful
boost to I/O performance.

On a 4-socket Haswell-EX system (72 cores) running 4.6-rc1 kernel,
fio with 38 threads doing parallel I/O on two shared files on an
NVDIMM with DAX gave the following aggregrate bandwidth with and
without the patch:

  Test          W/O patch       With patch      % change
  ----          ---------       ----------      --------
  Read-only      8688MB/s       10173MB/s        +17.1%
  Read-write     2687MB/s        2830MB/s         +5.3%

Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
---
 fs/ext4/indirect.c |    9 ++++++++-
 fs/ext4/inode.c    |   11 ++++++++---
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 3027fa6..1dfc280 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -706,9 +706,16 @@ retry:
 			inode_dio_end(inode);
 			goto locked;
 		}
+		/*
+		 * Need to pass in DIO_SKIP_DIO_COUNT to dax_do_io() to prevent
+		 * duplicated inode_dio_begin/inode_dio_end pair. The flag
+		 * isn't used in __blockdev_direct_IO() as the inode_dio_end()
+		 * call can be deferred for AIO.
+		 */
 		if (IS_DAX(inode))
 			ret = dax_do_io(iocb, inode, iter, offset,
-					ext4_dio_get_block, NULL, 0);
+					ext4_dio_get_block, NULL,
+					DIO_SKIP_DIO_COUNT);
 		else
 			ret = __blockdev_direct_IO(iocb, inode,
 						   inode->i_sb->s_bdev, iter,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dab84a2..b18ee2f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3358,9 +3358,14 @@ static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	 * Make all waiters for direct IO properly wait also for extent
 	 * conversion. This also disallows race between truncate() and
 	 * overwrite DIO as i_dio_count needs to be incremented under i_mutex.
+	 *
+	 * The dax_do_io() will unnecessarily call inode_dio_begin() &
+	 * inode_dio_end() again if the DIO_SKIP_DIO_COUNT flag is not set.
 	 */
-	if (iov_iter_rw(iter) == WRITE)
+	if (iov_iter_rw(iter) == WRITE) {
+		dio_flags = IS_DAX(inode) ? DIO_SKIP_DIO_COUNT : 0;
 		inode_dio_begin(inode);
+	}
 
 	/* If we do a overwrite dio, i_mutex locking can be released */
 	overwrite = *((int *)iocb->private);
@@ -3393,10 +3398,10 @@ static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 		get_block_func = ext4_dio_get_block_overwrite;
 	else if (is_sync_kiocb(iocb)) {
 		get_block_func = ext4_dio_get_block_unwritten_sync;
-		dio_flags = DIO_LOCKING;
+		dio_flags |= DIO_LOCKING;
 	} else {
 		get_block_func = ext4_dio_get_block_unwritten_async;
-		dio_flags = DIO_LOCKING;
+		dio_flags |= DIO_LOCKING;
 	}
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
 	BUG_ON(ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode));
-- 
1.7.1

