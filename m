From: Waiman Long <Waiman.Long@hpe.com>
Subject: [PATCH v5 1/2] dax: Don't touch i_dio_count in dax_do_io()
Date: Fri, 29 Apr 2016 12:27:55 -0400
Message-ID: <1461947276-25988-2-git-send-email-Waiman.Long@hpe.com>
References: <1461947276-25988-1-git-send-email-Waiman.Long@hpe.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>,
	Waiman Long <Waiman.Long@hpe.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g2t4625.austin.hp.com ([15.73.212.76]:45578 "EHLO
	g2t4625.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbcD2Q2R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Apr 2016 12:28:17 -0400
Received: from g2t4623.austin.hp.com (g2t4623.austin.hp.com [15.73.212.78])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t4625.austin.hp.com (Postfix) with ESMTPS id 898DF56C3
	for <linux-ext4@vger.kernel.org>; Fri, 29 Apr 2016 16:28:16 +0000 (UTC)
In-Reply-To: <1461947276-25988-1-git-send-email-Waiman.Long@hpe.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The purpose of the i_dio_count is to protect against truncation while
the I/O operation is in progress. As dax_do_io() only does synchronous
I/O, the locking performed by the caller or within dax_do_io() for
read should be enough to protect it against truncation. There is no
need to touch the i_dio_count.

Eliminating two atomic operations can sometimes give a noticeable
improvement in I/O performance as NVDIMM is much faster than other
disk devices.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
---
 fs/dax.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 90322eb..1b4b500 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -253,8 +253,12 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
  * If @flags has DIO_LOCKING set, we assume that the i_mutex is held by the
  * caller for writes.  For reads, we take and release the i_mutex ourselves.
  * If DIO_LOCKING is not set, the filesystem takes care of its own locking.
- * As with do_blockdev_direct_IO(), we increment i_dio_count while the I/O
- * is in progress.
+ *
+ * The do_blockdev_direct_IO() function increment i_dio_count while the I/O
+ * is in progress. However, the dax_do_io() always does synchronous I/O. The
+ * locking done by the caller or within dax_do_io() for read (DIO_LOCKING)
+ * should be enough to protect against concurrent truncation. We don't really
+ * need to touch i_dio_count here.
  */
 ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
 		  struct iov_iter *iter, loff_t pos, get_block_t get_block,
@@ -277,10 +281,6 @@ ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
 		}
 	}
 
-	/* Protects against truncate */
-	if (!(flags & DIO_SKIP_DIO_COUNT))
-		inode_dio_begin(inode);
