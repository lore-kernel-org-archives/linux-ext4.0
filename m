From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH v2 2/3] ext4: add a new flag for ext4_map_blocks
Date: Thu, 14 Jun 2012 11:32:09 +0800
Message-ID: <1339644730-6204-3-git-send-email-wenqing.lz@taobao.com>
References: <1339644730-6204-1-git-send-email-wenqing.lz@taobao.com>
Cc: Tao Ma <tm@tao.ma>, Eric Sandeen <sandeen@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64546 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2FNDYc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jun 2012 23:24:32 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so1935499dad.19
        for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2012 20:24:32 -0700 (PDT)
In-Reply-To: <1339644730-6204-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

EXT4_GET_BLOCKS_NO_LOCK flag is added to indicate that we don't need to acquire
i_data_sem lock in ext4_map_blocks.  Meanwhile, it lets _ext4_get_block do not
start a new journal because when we do a overwrite dio, there is no any
metadata that needs to be modified.

We define a new function called ext4_get_block_write_nolock, which is used in
dio overwrite nolock.  In this function, it doesn't try to acquire i_data_sem
lock and doesn't start a new journal as it does a lookup.

CC: Tao Ma <tm@tao.ma>
CC: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/ext4.h  |    2 +
 fs/ext4/inode.c |   59 +++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index cfc4e01..d1a2b1e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -571,6 +571,8 @@ enum {
 #define EXT4_GET_BLOCKS_NO_NORMALIZE		0x0040
 	/* Request will not result in inode size update (user for fallocate) */
 #define EXT4_GET_BLOCKS_KEEP_SIZE		0x0080
+	/* Do not take i_data_sem locking in ext4_map_blocks */
+#define EXT4_GET_BLOCKS_NO_LOCK			0x0100
 
 /*
  * Flags used by ext4_free_blocks
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 02bc8cb..9a714ff 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -544,7 +544,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	 * Try to see if we can get the block without requesting a new
 	 * file system block.
 	 */
-	down_read((&EXT4_I(inode)->i_data_sem));
+	if (!(flags & EXT4_GET_BLOCKS_NO_LOCK))
+		down_read((&EXT4_I(inode)->i_data_sem));
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
 		retval = ext4_ext_map_blocks(handle, inode, map, flags &
 					     EXT4_GET_BLOCKS_KEEP_SIZE);
@@ -552,7 +553,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		retval = ext4_ind_map_blocks(handle, inode, map, flags &
 					     EXT4_GET_BLOCKS_KEEP_SIZE);
 	}
-	up_read((&EXT4_I(inode)->i_data_sem));
+	if (!(flags & EXT4_GET_BLOCKS_NO_LOCK))
+		up_read((&EXT4_I(inode)->i_data_sem));
 
 	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
 		int ret = check_block_validity(inode, map);
@@ -2818,6 +2820,32 @@ static int ext4_get_block_write(struct inode *inode, sector_t iblock,
 			       EXT4_GET_BLOCKS_IO_CREATE_EXT);
 }
 
+static int ext4_get_block_write_nolock(struct inode *inode, sector_t iblock,
+		   struct buffer_head *bh_result, int create)
+{
+	handle_t *handle = ext4_journal_current_handle();
+	struct ext4_map_blocks map;
+	int ret = 0;
+
+	ext4_debug("ext4_get_block_write_nolock: inode %lu, create flag %d\n",
+		   inode->i_ino, create);
+
+	create = EXT4_GET_BLOCKS_NO_LOCK;
+
+	map.m_lblk = iblock;
+	map.m_len = bh_result->b_size >> inode->i_blkbits;
+
+	ret = ext4_map_blocks(handle, inode, &map, create);
+	if (ret > 0) {
+		map_bh(bh_result, inode->i_sb, map.m_pblk);
+		bh_result->b_state = (bh_result->b_state & ~EXT4_MAP_FLAGS) |
+					map.m_flags;
+		bh_result->b_size = inode->i_sb->s_blocksize * map.m_len;
+		ret = 0;
+	}
+	return ret;
+}
+
 static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 			    ssize_t size, void *private, int ret,
 			    bool is_async)
@@ -2966,6 +2994,8 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 
 	loff_t final_size = offset + count;
 	if (rw == WRITE && final_size <= inode->i_size) {
+		int overwrite = 0;
+
 		/*
  		 * We could direct write to holes and fallocate.
 		 *
@@ -3005,13 +3035,22 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 			EXT4_I(inode)->cur_aio_dio = iocb->private;
 		}
 
-		ret = __blockdev_direct_IO(rw, iocb, inode,
-					 inode->i_sb->s_bdev, iov,
-					 offset, nr_segs,
-					 ext4_get_block_write,
-					 ext4_end_io_dio,
-					 NULL,
-					 DIO_LOCKING);
+		if (overwrite)
+			ret = __blockdev_direct_IO(rw, iocb, inode,
+						 inode->i_sb->s_bdev, iov,
+						 offset, nr_segs,
+						 ext4_get_block_write_nolock,
+						 ext4_end_io_dio,
+						 NULL,
+						 0);
+		else
+			ret = __blockdev_direct_IO(rw, iocb, inode,
+						 inode->i_sb->s_bdev, iov,
+						 offset, nr_segs,
+						 ext4_get_block_write,
+						 ext4_end_io_dio,
+						 NULL,
+						 DIO_LOCKING);
 		if (iocb->private)
 			EXT4_I(inode)->cur_aio_dio = NULL;
 		/*
@@ -3031,7 +3070,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 		if (ret != -EIOCBQUEUED && ret <= 0 && iocb->private) {
 			ext4_free_io_end(iocb->private);
 			iocb->private = NULL;
-		} else if (ret > 0 && ext4_test_inode_state(inode,
+		} else if (ret > 0 && !overwrite && ext4_test_inode_state(inode,
 						EXT4_STATE_DIO_UNWRITTEN)) {
 			int err;
 			/*
-- 
1.7.4.1

