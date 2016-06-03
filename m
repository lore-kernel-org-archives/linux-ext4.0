From: Waiman Long <Waiman.Long@hpe.com>
Subject: [PATCH 3/3] ext4: Pass DIO_SKIP_DIO_COUNT to dax_do_io
Date: Fri,  3 Jun 2016 18:28:17 -0400
Message-ID: <1464992897-34063-4-git-send-email-Waiman.Long@hpe.com>
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

Since all the DAX I/Os are synchronous, there is no need to update
the DIO count in dax_do_io() when the count has already been updated
or the i_rwsem lock (read or write) has or will be taken.

This patch passes in the DIO_SKIP_DIO_COUNT flag to dax_do_io() to
disable two unneeded atomic operations that can slow thing down in
fast storages like NVDIMM.

With a 38-threads fio I/O test with 2 shared files (on DAX-mount ext4
formatted NVDIMM) running on a 4-socket Haswell-EX server with 4.6-rc1
kernel, the aggregated bandwidths before and after the patch were:

  Test          W/O patch       With patch      % change
  ----          ---------       ----------      --------
  Read-only     16663MB/s       17615MB/s        +5.7%
  Read-write     1077MB/s        1167MB/s        +8.4%

Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
---
 fs/ext4/inode.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f7140ca..05cd8ea 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3341,6 +3341,7 @@ static ssize_t ext4_direct_IO_write(struct kiocb *iocb, struct iov_iter *iter)
 	loff_t final_size = offset + count;
 	int orphan = 0;
 	handle_t *handle;
+	bool is_dax = IS_DAX(inode);
 
 	if (final_size > inode->i_size) {
 		/* Credits for sb + inode write */
@@ -3364,11 +3365,11 @@ static ssize_t ext4_direct_IO_write(struct kiocb *iocb, struct iov_iter *iter)
 	/*
 	 * Make all waiters for direct IO properly wait also for extent
 	 * conversion. This also disallows race between truncate() and
-	 * overwrite DIO as i_dio_count needs to be incremented under i_mutex.
+	 * overwrite DIO as i_dio_count needs to be incremented under i_rwsem.
 	 */
 	inode_dio_begin(inode);
 
-	/* If we do a overwrite dio, i_mutex locking can be released */
+	/* If we do a overwrite dio, i_rwsem locking can be released */
 	overwrite = *((int *)iocb->private);
 
 	if (overwrite)
@@ -3397,7 +3398,7 @@ static ssize_t ext4_direct_IO_write(struct kiocb *iocb, struct iov_iter *iter)
 	iocb->private = NULL;
 	if (overwrite)
 		get_block_func = ext4_dio_get_block_overwrite;
-	else if (IS_DAX(inode)) {
+	else if (is_dax) {
 		/*
 		 * We can avoid zeroing for aligned DAX writes beyond EOF. Other
 		 * writes need zeroing either because they can race with page
@@ -3423,7 +3424,12 @@ static ssize_t ext4_direct_IO_write(struct kiocb *iocb, struct iov_iter *iter)
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
 	BUG_ON(ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode));
 #endif
-	if (IS_DAX(inode)) {
+	if (is_dax) {
+		/*
+		 * All DAX I/Os are synchronous, so we can skip updating
+		 * DIO count in dax_do_io.
+		 */
+		dio_flags |= DIO_SKIP_DIO_COUNT;
 		ret = dax_do_io(iocb, inode, iter, get_block_func,
 				ext4_end_io_dio, dio_flags);
 	} else
@@ -3447,7 +3453,7 @@ static ssize_t ext4_direct_IO_write(struct kiocb *iocb, struct iov_iter *iter)
 	}
 
 	inode_dio_end(inode);
-	/* take i_mutex locking again if we do a ovewrite dio */
+	/* take i_rwsem locking again if we do a ovewrite dio */
 	if (overwrite)
 		inode_lock(inode);
 
@@ -3516,8 +3522,14 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
 			unlocked = 1;
 	}
 	if (IS_DAX(inode)) {
+		/*
+		 * All DAX I/Os are synchronous, so we can skip updating
+		 * DIO count if inode_dio_begin() has been called before
+		 * or DIO_LOCKING is enabled.
+		 */
 		ret = dax_do_io(iocb, inode, iter, ext4_dio_get_block,
-				NULL, unlocked ? 0 : DIO_LOCKING);
+				NULL, DIO_SKIP_DIO_COUNT |
+				(unlocked ? 0 : DIO_LOCKING));
 	} else {
 		ret = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
 					   iter, ext4_dio_get_block,
-- 
1.7.1
