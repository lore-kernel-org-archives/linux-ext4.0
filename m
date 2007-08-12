From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Remove PowerPC bitmap hackery since it's not been needed since Linux 2.1
Date: Sun, 12 Aug 2007 12:57:18 -0400
Message-ID: <11869378412289-git-send-email-tytso@mit.edu>
References: <20070809214254.GB5438@thunk.org>
 <1186937841369-git-send-email-tytso@mit.edu>
 <11869378411811-git-send-email-tytso@mit.edu>
 <11869378412404-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: jrs@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46670 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757973AbXHLQ6o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Aug 2007 12:58:44 -0400
In-Reply-To: <11869378412404-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/rw_bitmaps.c |   46 ----------------------------------------------
 1 files changed, 0 insertions(+), 46 deletions(-)

diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 603b590..1897ec3 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -27,30 +27,6 @@
 #include "ext2fs.h"
 #include "e2image.h"
 
-#if defined(__powerpc__) && defined(EXT2FS_ENABLE_SWAPFS)
-/*
- * On the PowerPC, the big-endian variant of the ext2 filesystem
- * has its bitmaps stored as 32-bit words with bit 0 as the LSB
- * of each word.  Thus a bitmap with only bit 0 set would be, as
- * a string of bytes, 00 00 00 01 00 ...
- * To cope with this, we byte-reverse each word of a bitmap if
- * we have a big-endian filesystem, that is, if we are *not*
- * byte-swapping other word-sized numbers.
- */
-#define EXT2_BIG_ENDIAN_BITMAPS
-#endif
-
-#ifdef EXT2_BIG_ENDIAN_BITMAPS
-static void ext2fs_swap_bitmap(ext2_filsys fs, char *bitmap, int nbytes)
-{
-	__u32 *p = (__u32 *) bitmap;
-	int n;
-		
-	for (n = nbytes / sizeof(__u32); n > 0; --n, ++p)
-		*p = ext2fs_swab32(*p);
-}
-#endif
-
 static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 {
 	dgrp_t 		i;
@@ -112,12 +88,6 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		}
 		blk = fs->group_desc[i].bg_block_bitmap;
 		if (blk) {
-#ifdef EXT2_BIG_ENDIAN_BITMAPS
-			if (!((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
-			      (fs->flags & EXT2_FLAG_SWAP_BYTES_WRITE)))
-				ext2fs_swap_bitmap(fs, block_buf, 
-						   block_nbytes);
-#endif
 			retval = io_channel_write_blk(fs->io, blk, 1,
 						      block_buf);
 			if (retval)
@@ -141,12 +111,6 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 
 		blk = fs->group_desc[i].bg_inode_bitmap;
 		if (blk) {
-#ifdef EXT2_BIG_ENDIAN_BITMAPS
-			if (!((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
-			      (fs->flags & EXT2_FLAG_SWAP_BYTES_WRITE)))
-				ext2fs_swap_bitmap(fs, inode_buf, 
-						   inode_nbytes);
-#endif
 			retval = io_channel_write_blk(fs->io, blk, 1,
 						      inode_buf);
 			if (retval)
@@ -278,11 +242,6 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 					retval = EXT2_ET_BLOCK_BITMAP_READ;
 					goto cleanup;
 				}
-#ifdef EXT2_BIG_ENDIAN_BITMAPS
-				if (!((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
-				      (fs->flags & EXT2_FLAG_SWAP_BYTES_READ)))
-					ext2fs_swap_bitmap(fs, block_bitmap, block_nbytes);
-#endif
 			} else
 				memset(block_bitmap, 0xff, block_nbytes);
 			cnt = block_nbytes << 3;
@@ -304,11 +263,6 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 					retval = EXT2_ET_INODE_BITMAP_READ;
 					goto cleanup;
 				}
-#ifdef EXT2_BIG_ENDIAN_BITMAPS
-				if (!((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
-				      (fs->flags & EXT2_FLAG_SWAP_BYTES_READ)))
-					ext2fs_swap_bitmap(fs, inode_bitmap, inode_nbytes);
-#endif
 			} else
 				memset(inode_bitmap, 0xff, inode_nbytes);
 			cnt = inode_nbytes << 3;
-- 
1.5.3.rc4.67.gf9286
