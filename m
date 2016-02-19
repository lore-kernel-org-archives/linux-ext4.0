From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/6] ext4: Move trans handling and completion deferal out of _ext4_get_block
Date: Fri, 19 Feb 2016 16:59:40 +0100
Message-ID: <1455897582-13292-5-git-send-email-jack@suse.cz>
References: <1455897582-13292-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1948334AbcBSP72 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Feb 2016 10:59:28 -0500
In-Reply-To: <1455897582-13292-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is no need to handle starting of a transaction and deferal of DIO
completion in _ext4_get_block() function. We can move this out to get
block functions for direct IO that need it. That way we can add stricter
checks verifying things work as we expect.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 92 ++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 59 insertions(+), 33 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 47b11fbd1417..506180729faf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -686,50 +686,25 @@ out_sem:
 	return retval;
 }
 
-/* Maximum number of blocks we map for direct IO at once. */
-#define DIO_MAX_BLOCKS 4096
-
 static int _ext4_get_block(struct inode *inode, sector_t iblock,
 			   struct buffer_head *bh, int flags)
 {
-	handle_t *handle = ext4_journal_current_handle();
 	struct ext4_map_blocks map;
-	int ret = 0, started = 0;
-	int dio_credits;
+	int ret = 0;
 
 	if (ext4_has_inline_data(inode))
 		return -ERANGE;
 
 	map.m_lblk = iblock;
 	map.m_len = bh->b_size >> inode->i_blkbits;
-
-	if (flags && !handle) {
-		/* Direct IO write... */
-		if (map.m_len > DIO_MAX_BLOCKS)
-			map.m_len = DIO_MAX_BLOCKS;
-		dio_credits = ext4_chunk_trans_blocks(inode, map.m_len);
-		handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
-					    dio_credits);
-		if (IS_ERR(handle)) {
-			ret = PTR_ERR(handle);
-			return ret;
-		}
-		started = 1;
-	}
-
-	ret = ext4_map_blocks(handle, inode, &map, flags);
+	ret = ext4_map_blocks(ext4_journal_current_handle(), inode, &map,
+			      flags);
 	if (ret > 0) {
-		ext4_io_end_t *io_end = ext4_inode_aio(inode);
-
 		map_bh(bh, inode->i_sb, map.m_pblk);
 		bh->b_state = (bh->b_state & ~EXT4_MAP_FLAGS) | map.m_flags;
-		if (io_end && io_end->flag & EXT4_IO_END_UNWRITTEN)
-			set_buffer_defer_completion(bh);
 		bh->b_size = inode->i_sb->s_blocksize * map.m_len;
 		ret = 0;
 	}
-	if (started)
-		ext4_journal_stop(handle);
 	return ret;
 }
 
@@ -754,12 +729,42 @@ int ext4_get_block_unwritten(struct inode *inode, sector_t iblock,
 			       EXT4_GET_BLOCKS_IO_CREATE_EXT);
 }
 
+/* Maximum number of blocks we map for direct IO at once. */
+#define DIO_MAX_BLOCKS 4096
+
+static handle_t *start_dio_trans(struct inode *inode,
+				 struct buffer_head *bh_result)
+{
+	int dio_credits;
+
+	/* Trim mapping request to maximum we can map at once for DIO */
+	if (bh_result->b_size >> inode->i_blkbits > DIO_MAX_BLOCKS)
+		bh_result->b_size = DIO_MAX_BLOCKS << inode->i_blkbits;
+	dio_credits = ext4_chunk_trans_blocks(inode,
+				      bh_result->b_size >> inode->i_blkbits);
+	return ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS, dio_credits);
+}
+
 /* Get block function for DIO reads and writes to inodes without extents */
 int ext4_dio_get_block(struct inode *inode, sector_t iblock,
 		       struct buffer_head *bh, int create)
 {
-	return _ext4_get_block(inode, iblock, bh,
-			       create ? EXT4_GET_BLOCKS_CREATE : 0);
+	handle_t *handle;
+	int ret;
+
+	/* We don't expect handle for direct IO */
+	WARN_ON_ONCE(ext4_journal_current_handle());
+
+	if (create) {
+		handle = start_dio_trans(inode, bh);
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+	}
+	ret = _ext4_get_block(inode, iblock, bh,
+			      create ? EXT4_GET_BLOCKS_CREATE : 0);
+	if (create)
+		ext4_journal_stop(handle);
+	return ret;
 }
 
 /*
@@ -770,10 +775,28 @@ int ext4_dio_get_block(struct inode *inode, sector_t iblock,
 static int ext4_dio_get_block_unwritten(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
+	handle_t *handle;
+	int ret;
+
 	ext4_debug("ext4_dio_get_block_unwritten: inode %lu, create flag %d\n",
 		   inode->i_ino, create);
-	return _ext4_get_block(inode, iblock, bh_result,
-			       EXT4_GET_BLOCKS_IO_CREATE_EXT);
+	/* We don't expect handle for direct IO */
+	WARN_ON_ONCE(ext4_journal_current_handle());
+
+	handle = start_dio_trans(inode, bh_result);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+	ret = _ext4_get_block(inode, iblock, bh_result,
+			      EXT4_GET_BLOCKS_IO_CREATE_EXT);
+	ext4_journal_stop(handle);
+	if (!ret && buffer_unwritten(bh_result)) {
+		ext4_io_end_t *io_end = ext4_inode_aio(inode);
+
+		set_buffer_defer_completion(bh_result);
+		WARN_ON_ONCE(io_end && !(io_end->flag & EXT4_IO_END_UNWRITTEN));
+	}
+
+	return ret;
 }
 
 static int ext4_dio_get_block_overwrite(struct inode *inode, sector_t iblock,
@@ -783,12 +806,15 @@ static int ext4_dio_get_block_overwrite(struct inode *inode, sector_t iblock,
 
 	ext4_debug("ext4_dio_get_block_overwrite: inode %lu, create flag %d\n",
 		   inode->i_ino, create);
+	/* We don't expect handle for direct IO */
+	WARN_ON_ONCE(ext4_journal_current_handle());
+
 	ret = _ext4_get_block(inode, iblock, bh_result, 0);
 	/*
 	 * Blocks should have been preallocated! ext4_file_write_iter() checks
 	 * that.
 	 */
-	WARN_ON_ONCE(!buffer_mapped(bh_result));
+	WARN_ON_ONCE(!buffer_mapped(bh_result) || buffer_unwritten(bh_result));
 
 	return ret;
 }
-- 
2.6.2

