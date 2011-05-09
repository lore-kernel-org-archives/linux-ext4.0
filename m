From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 07/30] ext4: snapshot hooks - direct I/O
Date: Mon,  9 May 2011 19:41:25 +0300
Message-ID: <1304959308-11122-8-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33538 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1EIQnU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:43:20 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so4026020wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:43:19 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

With indirect mapped files, direct I/O write is not allowed to
initialize holes, so stale data won't be exposed.
With snapshots, direct I/O write is not allowed to do move-on-write,
for the exact same reason.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3ed64bb..476606b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1370,6 +1370,16 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 			return ret;
 	}
 
+	if (retval > 0 && (map->m_flags & EXT4_MAP_REMAP) &&
+	    (flags & EXT4_GET_BLOCKS_PRE_IO)) {
+		/*
+		 * If mow is needed on the requested block and
+		 * request comes from async-direct-io-write path,
+		 * we return an unmapped buffer to fall back to buffered I/O.
+		 */
+		map->m_flags &= ~EXT4_MAP_MAPPED;
+		return 0;
+	}
 	/* If it is only a block(s) look up */
 	if ((flags & EXT4_GET_BLOCKS_CREATE) == 0)
 		return retval;
@@ -3678,6 +3688,29 @@ static int ext4_releasepage(struct page *page, gfp_t wait)
 }
 
 /*
+ * ext4_get_block_dio used when preparing for a DIO write
+ * to indirect mapped files with snapshots.
+ */
+int ext4_get_block_dio_write(struct inode *inode, sector_t iblock,
+		   struct buffer_head *bh, int create)
+{
+	int flags = EXT4_GET_BLOCKS_CREATE;
+
+	/*
+	 * DIO_SKIP_HOLES may ask to map direct I/O write with create=0,
+	 * but we know this is a write, so we need to check if block
+	 * needs to be moved to snapshot and fall back to buffered I/O.
+	 * ext4_map_blocks() will return an unmapped buffer if block
+	 * is not allocated or if it needs to be moved to snapshot.
+	 */
+	if (ext4_snapshot_should_move_data(inode))
+		flags |= EXT4_GET_BLOCKS_MOVE_ON_WRITE|
+			EXT4_GET_BLOCKS_PRE_IO;
+
+	return _ext4_get_block(inode, iblock, bh, flags);
+}
+
+/*
  * O_DIRECT for ext3 (or indirect map) based files
  *
  * If the O_DIRECT write will extend the file then add this inode to the
@@ -3732,6 +3765,16 @@ retry:
 		ret = blockdev_direct_IO(rw, iocb, inode,
 				 inode->i_sb->s_bdev, iov,
 				 offset, nr_segs,
+				 /*
+				  * snapshots code gets here for DIO write
+				  * to ind mapped files or outside i_size
+				  * of extent mapped files and for DIO read
+				  * to all files.
+				  * XXX: isn't it possible to expose stale data
+				  *      on DIO read to newly allocated ind map
+				  *      blocks or newly MOWed blocks?
+				  */
+				 (rw == WRITE) ? ext4_get_block_dio_write :
 				 ext4_get_block, NULL);
 
 		if (unlikely((rw & WRITE) && ret < 0)) {
@@ -3793,10 +3836,13 @@ out:
 static int ext4_get_block_write(struct inode *inode, sector_t iblock,
 		   struct buffer_head *bh_result, int create)
 {
+	int flags = EXT4_GET_BLOCKS_IO_CREATE_EXT;
+
 	ext4_debug("ext4_get_block_write: inode %lu, create flag %d\n",
 		   inode->i_ino, create);
-	return _ext4_get_block(inode, iblock, bh_result,
-			       EXT4_GET_BLOCKS_IO_CREATE_EXT);
+	if (ext4_snapshot_should_move_data(inode))
+		flags |= EXT4_GET_BLOCKS_MOVE_ON_WRITE;
+	return _ext4_get_block(inode, iblock, bh_result, flags);
 }
 
 static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
-- 
1.7.0.4

