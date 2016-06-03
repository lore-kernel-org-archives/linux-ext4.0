From: Waiman Long <Waiman.Long@hpe.com>
Subject: [PATCH 1/3] dax: Take shared lock in dax_do_io()
Date: Fri,  3 Jun 2016 18:28:15 -0400
Message-ID: <1464992897-34063-2-git-send-email-Waiman.Long@hpe.com>
References: <1464992897-34063-1-git-send-email-Waiman.Long@hpe.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>,
	Waiman Long <Waiman.Long@hpe.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464992897-34063-1-git-send-email-Waiman.Long@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

With the change from i_mutex to i_rwsem in 4.7 kernel, the locking
scheme in dax_do_io() can now be changed to take a shared lock for
read so that multiple readers can access the same file concurrently.

With a 38-threads fio I/O test with 2 shared files (on DAX-mount, ext4
formatted NVDIMM) running on a 4-socket Haswell-EX server with 4.7-rc1
kernel, the aggregated bandwidths before and after the patch were:

  Test          W/O patch       With patch      % change
  ----          ---------       ----------      --------
  Read-only      4711MB/s       16031MB/s        +240%
  Read-write     1932MB/s        1040MB/s         -46%

There was a big increase in parallel read performance. However,
parallel read-write test showed a regression because a mix of readers
and writers will largely disable optimistic spinning.

Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
---
 fs/dax.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 761495b..ff57d88 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -247,8 +247,8 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
  * @flags: See below
  *
  * This function uses the same locking scheme as do_blockdev_direct_IO:
- * If @flags has DIO_LOCKING set, we assume that the i_mutex is held by the
- * caller for writes.  For reads, we take and release the i_mutex ourselves.
+ * If @flags has DIO_LOCKING set, we assume that the i_rwsem is held by the
+ * caller for writes.  For reads, we take and release the i_rwsem ourselves.
  * If DIO_LOCKING is not set, the filesystem takes care of its own locking.
  * As with do_blockdev_direct_IO(), we increment i_dio_count while the I/O
  * is in progress.
@@ -265,8 +265,9 @@ ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
 	memset(&bh, 0, sizeof(bh));
 	bh.b_bdev = inode->i_sb->s_bdev;
 
+	/* Take the shared lock for read */
 	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ)
-		inode_lock(inode);
+		inode_lock_shared(inode);
 
 	/* Protects against truncate */
 	if (!(flags & DIO_SKIP_DIO_COUNT))
@@ -275,7 +276,7 @@ ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
 	retval = dax_io(inode, iter, pos, end, get_block, &bh);
 
 	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ)
-		inode_unlock(inode);
+		inode_unlock_shared(inode);
 
 	if (end_io) {
 		int err;
-- 
1.7.1
