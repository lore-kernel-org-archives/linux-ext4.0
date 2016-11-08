From: Jan Kara <jack@suse.cz>
Subject: [PATCH 09/11] ext4: Rip out DAX handling from direct IO path
Date: Tue,  8 Nov 2016 12:08:15 +0100
Message-ID: <1478603297-11793-10-git-send-email-jack@suse.cz>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34647 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933062AbcKHLKk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 8 Nov 2016 06:10:40 -0500
In-Reply-To: <1478603297-11793-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Reads and writes for DAX inodes should no longer end up in direct IO
code. Rip out the support and add a warning.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 49 +++++++++++++++----------------------------------
 1 file changed, 15 insertions(+), 34 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4d71c7bc3524..72886e3bf0d3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3594,19 +3594,7 @@ static ssize_t ext4_direct_IO_write(struct kiocb *iocb, struct iov_iter *iter)
 	iocb->private = NULL;
 	if (overwrite)
 		get_block_func = ext4_dio_get_block_overwrite;
-	else if (IS_DAX(inode)) {
-		/*
-		 * We can avoid zeroing for aligned DAX writes beyond EOF. Other
-		 * writes need zeroing either because they can race with page
-		 * faults or because they use partial blocks.
-		 */
-		if (round_down(offset, 1<<inode->i_blkbits) >= inode->i_size &&
-		    ext4_aligned_io(inode, offset, count))
-			get_block_func = ext4_dio_get_block;
-		else
-			get_block_func = ext4_dax_get_block;
-		dio_flags = DIO_LOCKING;
-	} else if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) ||
+	else if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) ||
 		   round_down(offset, 1 << inode->i_blkbits) >= inode->i_size) {
 		get_block_func = ext4_dio_get_block;
 		dio_flags = DIO_LOCKING | DIO_SKIP_HOLES;
@@ -3620,14 +3608,9 @@ static ssize_t ext4_direct_IO_write(struct kiocb *iocb, struct iov_iter *iter)
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
 	BUG_ON(ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode));
 #endif
-	if (IS_DAX(inode)) {
-		ret = dax_do_io(iocb, inode, iter, get_block_func,
-				ext4_end_io_dio, dio_flags);
-	} else
-		ret = __blockdev_direct_IO(iocb, inode,
-					   inode->i_sb->s_bdev, iter,
-					   get_block_func,
-					   ext4_end_io_dio, NULL, dio_flags);
+	ret = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, iter,
+				   get_block_func, ext4_end_io_dio, NULL,
+				   dio_flags);
 
 	if (ret > 0 && !overwrite && ext4_test_inode_state(inode,
 						EXT4_STATE_DIO_UNWRITTEN)) {
@@ -3696,6 +3679,7 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct address_space *mapping = iocb->ki_filp->f_mapping;
 	struct inode *inode = mapping->host;
+	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
 	/*
@@ -3704,19 +3688,12 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
 	 * we are protected against page writeback as well.
 	 */
 	inode_lock_shared(inode);
-	if (IS_DAX(inode)) {
-		ret = dax_do_io(iocb, inode, iter, ext4_dio_get_block, NULL, 0);
-	} else {
-		size_t count = iov_iter_count(iter);
-
-		ret = filemap_write_and_wait_range(mapping, iocb->ki_pos,
-						   iocb->ki_pos + count);
-		if (ret)
-			goto out_unlock;
-		ret = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
-					   iter, ext4_dio_get_block,
-					   NULL, NULL, 0);
-	}
+	ret = filemap_write_and_wait_range(mapping, iocb->ki_pos,
+					   iocb->ki_pos + count);
+	if (ret)
+		goto out_unlock;
+	ret = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
+				   iter, ext4_dio_get_block, NULL, NULL, 0);
 out_unlock:
 	inode_unlock_shared(inode);
 	return ret;
@@ -3745,6 +3722,10 @@ static ssize_t ext4_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	if (ext4_has_inline_data(inode))
 		return 0;
 
+	/* DAX uses iomap path now */
+	if (WARN_ON_ONCE(IS_DAX(inode)))
+		return 0;
+
 	trace_ext4_direct_IO_enter(inode, offset, count, iov_iter_rw(iter));
 	if (iov_iter_rw(iter) == READ)
 		ret = ext4_direct_IO_read(iocb, iter);
-- 
2.6.6

