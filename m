From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 19/25] libext2: Fix leaks in write_bitmaps on error returns
Date: Fri, 16 Sep 2011 15:49:34 -0500
Message-ID: <1316206180-6375-20-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46737 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab1IPUtq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:46 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

block_buf and/or inode_buf may not be properly freed on an error
return.

Create a new errout: target to free them as needed in error conditions.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/rw_bitmaps.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index f8c8a9f..fd8ac10 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -34,7 +34,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	int		block_nbytes, inode_nbytes;
 	unsigned int	nbits;
 	errcode_t	retval;
-	char 		*block_buf, *inode_buf;
+	char 		*block_buf = NULL, *inode_buf = NULL;
 	int		csum_flag = 0;
 	blk64_t		blk;
 	blk64_t		blk_itr = EXT2FS_B2C(fs, fs->super->s_first_data_block);
@@ -55,7 +55,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		retval = ext2fs_get_memalign(fs->blocksize, fs->blocksize,
 					     &block_buf);
 		if (retval)
-			return retval;
+			goto errout;
 		memset(block_buf, 0xff, fs->blocksize);
 	}
 	if (do_inode) {
@@ -64,7 +64,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		retval = ext2fs_get_memalign(fs->blocksize, fs->blocksize,
 					     &inode_buf);
 		if (retval)
-			return retval;
+			goto errout;
 		memset(inode_buf, 0xff, fs->blocksize);
 	}
 
@@ -79,7 +79,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		retval = ext2fs_get_block_bitmap_range2(fs->block_map,
 				blk_itr, block_nbytes << 3, block_buf);
 		if (retval)
-			return retval;
+			goto errout;
 
 		if (i == fs->group_desc_count - 1) {
 			/* Force bitmap padding for the last group */
@@ -95,8 +95,10 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		if (blk) {
 			retval = io_channel_write_blk64(fs->io, blk, 1,
 							block_buf);
-			if (retval)
-				return EXT2_ET_BLOCK_BITMAP_WRITE;
+			if (retval) {
+				retval = EXT2_ET_BLOCK_BITMAP_WRITE;
+				goto errout;
+			}
 		}
 	skip_this_block_bitmap:
 		blk_itr += block_nbytes << 3;
@@ -112,14 +114,16 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		retval = ext2fs_get_inode_bitmap_range2(fs->inode_map,
 				ino_itr, inode_nbytes << 3, inode_buf);
 		if (retval)
-			return retval;
+			goto errout;
 
 		blk = ext2fs_inode_bitmap_loc(fs, i);
 		if (blk) {
 			retval = io_channel_write_blk64(fs->io, blk, 1,
 						      inode_buf);
-			if (retval)
-				return EXT2_ET_INODE_BITMAP_WRITE;
+			if (retval) {
+				retval = EXT2_ET_INODE_BITMAP_WRITE;
+				goto errout;
+			}
 		}
 	skip_this_inode_bitmap:
 		ino_itr += inode_nbytes << 3;
@@ -134,6 +138,12 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		ext2fs_free_mem(&inode_buf);
 	}
 	return 0;
+errout:
+	if (inode_buf)
+		ext2fs_free_mem(&inode_buf);
+	if (block_buf)
+		ext2fs_free_mem(&block_buf);
+	return retval;
 }
 
 static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
-- 
1.7.4.1

