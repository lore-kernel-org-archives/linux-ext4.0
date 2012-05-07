From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/5] libext2fs: make read_bitmaps() more efficient when using direct I/O
Date: Mon,  7 May 2012 14:56:23 -0400
Message-ID: <1336416985-24605-4-git-send-email-tytso@mit.edu>
References: <1336416985-24605-1-git-send-email-tytso@mit.edu>
Cc: ksumrall@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38761 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab2EGS42 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 May 2012 14:56:28 -0400
In-Reply-To: <1336416985-24605-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Read in a full block for each allocation bitmap, to avoid using a
kernel bounce buffer when using direct I/O.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/rw_bitmaps.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 1d5f7b2..81e09c0 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -166,6 +166,9 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
+	if ((block_nbytes > fs->blocksize) || (inode_nbytes > fs->blocksize))
+		return EXT2_ET_CORRUPT_SUPERBLOCK;
+
 	fs->write_bitmaps = ext2fs_write_bitmaps;
 
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
@@ -186,7 +189,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		if (do_image)
 			retval = ext2fs_get_mem(fs->blocksize, &block_bitmap);
 		else
-			retval = ext2fs_get_memalign((unsigned) block_nbytes,
+			retval = ext2fs_get_memalign(fs->blocksize,
 						     fs->blocksize,
 						     &block_bitmap);
 			
@@ -202,8 +205,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		retval = ext2fs_allocate_inode_bitmap(fs, buf, &fs->inode_map);
 		if (retval)
 			goto cleanup;
-		retval = ext2fs_get_mem(do_image ? fs->blocksize :
-					(unsigned) inode_nbytes, &inode_bitmap);
+		retval = ext2fs_get_mem(fs->blocksize, &inode_bitmap);
 		if (retval)
 			goto cleanup;
 	} else
@@ -261,7 +263,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 				blk = 0;
 			if (blk) {
 				retval = io_channel_read_blk64(fs->io, blk,
-					     -block_nbytes, block_bitmap);
+							       1, block_bitmap);
 				if (retval) {
 					retval = EXT2_ET_BLOCK_BITMAP_READ;
 					goto cleanup;
@@ -283,7 +285,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 				blk = 0;
 			if (blk) {
 				retval = io_channel_read_blk64(fs->io, blk,
-					     -inode_nbytes, inode_bitmap);
+							       1, inode_bitmap);
 				if (retval) {
 					retval = EXT2_ET_INODE_BITMAP_READ;
 					goto cleanup;
-- 
1.7.10.rc3

