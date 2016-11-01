From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 09/11] ext4: Rip out DAX handling from direct IO path
Date: Tue,  1 Nov 2016 22:06:19 +0100
Message-ID: <1478034381-19037-10-git-send-email-jack@suse.cz>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
 Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Ted Tso <tytso-3s7WtUTddSA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1478034381-19037-1-git-send-email-jack-AlSwsSmVLrQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

Reads and writes for DAX inodes should no longer end up in direct IO
code. Rip out the support and add a warning.

Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/ext4/inode.c | 49 +++++++++++++++----------------------------------
 1 file changed, 15 insertions(+), 34 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 001fef06ea97..e236b84fc079 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3571,19 +3571,7 @@ static ssize_t ext4_direct_IO_write(struct kiocb *iocb, struct iov_iter *iter)
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
@@ -3597,14 +3585,9 @@ static ssize_t ext4_direct_IO_write(struct kiocb *iocb, struct iov_iter *iter)
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
@@ -3673,6 +3656,7 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct address_space *mapping = iocb->ki_filp->f_mapping;
 	struct inode *inode = mapping->host;
+	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
 	/*
@@ -3681,19 +3665,12 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
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
@@ -3722,6 +3699,10 @@ static ssize_t ext4_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
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
