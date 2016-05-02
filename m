From: Waiman Long <Waiman.Long@hpe.com>
Subject: [RFC PATCH] ext4: Don't release mutex for DAX write
Date: Mon,  2 May 2016 15:58:58 -0400
Message-ID: <1462219138-44089-1-git-send-email-Waiman.Long@hpe.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Waiman Long <Waiman.Long@hpe.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The ext4 DIO code releases the mutex for overwrite before
the actual write I/O. This doesn't work well for DAX as the
filemap_write_and_wait_range() function can't prevent the overwrites
from stepping on each other. This is due to the fact that DAX I/Os
are synchronous and no filemap information on which I/O operations
are pending is stored.

This patch prevents the ext4 DIO code from releasing the i_mutex when
in DAX mode. It also disable updating the i_dio_count as the i_mutex
will be hold for the entire duration of the write.

Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
---
 fs/ext4/inode.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dab84a2..252731e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3347,6 +3347,7 @@ static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	get_block_t *get_block_func = NULL;
 	int dio_flags = 0;
 	loff_t final_size = offset + count;
+	bool update_dio_count, is_dax = IS_DAX(inode);
 
 	/* Use the old path for reads and writes beyond i_size. */
 	if (iov_iter_rw(iter) != WRITE || final_size > inode->i_size)
@@ -3355,17 +3356,25 @@ static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	BUG_ON(iocb->private == NULL);
 
 	/*
+	 * If we do a overwrite dio, i_mutex locking can be released.
+	 * For DAX, however, we shouldn't release the lock as the
+	 * filemap_write_and_wait_range() function can't protect the
+	 * overwrite from stepping on each other.
+	 */
+	overwrite = *((int *)iocb->private);
+
+	/*
 	 * Make all waiters for direct IO properly wait also for extent
 	 * conversion. This also disallows race between truncate() and
 	 * overwrite DIO as i_dio_count needs to be incremented under i_mutex.
+	 * For DAX, we don't need to update the i_dio_count as we will keep
+	 * the i_mutex for the duration of the I/O operation.
 	 */
-	if (iov_iter_rw(iter) == WRITE)
+	update_dio_count = (iov_iter_rw(iter) == WRITE) && !is_dax;
+	if (update_dio_count)
 		inode_dio_begin(inode);
 
-	/* If we do a overwrite dio, i_mutex locking can be released */
-	overwrite = *((int *)iocb->private);
-
-	if (overwrite)
+	if (overwrite && !is_dax)
 		inode_unlock(inode);
 
 	/*
@@ -3401,7 +3410,7 @@ static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
 	BUG_ON(ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode));
 #endif
-	if (IS_DAX(inode))
+	if (is_dax)
 		ret = dax_do_io(iocb, inode, iter, offset, get_block_func,
 				ext4_end_io_dio, dio_flags);
 	else
@@ -3424,10 +3433,10 @@ static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 		ext4_clear_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN);
 	}
 
-	if (iov_iter_rw(iter) == WRITE)
+	if (update_dio_count)
 		inode_dio_end(inode);
-	/* take i_mutex locking again if we do a ovewrite dio */
-	if (overwrite)
+	/* take i_mutex locking again if we do a non-DAX ovewrite dio */
+	if (overwrite && !is_dax)
 		inode_lock(inode);
 
 	return ret;
-- 
1.7.1
