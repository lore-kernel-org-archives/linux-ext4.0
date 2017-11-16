From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v2 1/4] ext2fs: opening filesystem code refactoring
Date: Thu, 16 Nov 2017 16:55:43 +0300
Message-ID: <20171116135546.9991-2-artem.blagodarenko@gmail.com>
References: <20171116135546.9991-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:49545 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757682AbdKPNzy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Nov 2017 08:55:54 -0500
Received: by mail-lf0-f65.google.com with SMTP id w21so30225213lfc.6
        for <linux-ext4@vger.kernel.org>; Thu, 16 Nov 2017 05:55:53 -0800 (PST)
In-Reply-To: <20171116135546.9991-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Artem Blagodarenko <artem.blagodarenko@seagate.com>

There are similar opening filesystem code in different utilities.

The patch moves this code to ext2fs_try_open_fs().
This function make one of the action based on parameters:
1) open filesystem with given superblock, superblock size
2) open filesystem with given superblock, but try to
find right block size
3) open filesystem with default superblock and block size

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 e2fsck/unix.c       | 28 +++-------------------------
 lib/ext2fs/ext2fs.h |  4 ++++
 lib/ext2fs/openfs.c | 36 +++++++++++++++++++++++++++++++++++-
 misc/dumpe2fs.c     | 17 +++--------------
 4 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index b46dcb2d..2865f37a 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1134,31 +1134,9 @@ static errcode_t try_open_fs(e2fsck_t ctx, int flags, io_manager io_ptr,
 			     ext2_filsys *ret_fs)
 {
 	errcode_t retval;
-
-	*ret_fs = NULL;
-	if (ctx->superblock && ctx->blocksize) {
-		retval = ext2fs_open2(ctx->filesystem_name, ctx->io_options,
-				      flags, ctx->superblock, ctx->blocksize,
-				      io_ptr, ret_fs);
-	} else if (ctx->superblock) {
-		int blocksize;
-		for (blocksize = EXT2_MIN_BLOCK_SIZE;
-		     blocksize <= EXT2_MAX_BLOCK_SIZE; blocksize *= 2) {
-			if (*ret_fs) {
-				ext2fs_free(*ret_fs);
-				*ret_fs = NULL;
-			}
-			retval = ext2fs_open2(ctx->filesystem_name,
-					      ctx->io_options, flags,
-					      ctx->superblock, blocksize,
-					      io_ptr, ret_fs);
-			if (!retval)
-				break;
-		}
-	} else
-		retval = ext2fs_open2(ctx->filesystem_name, ctx->io_options,
-				      flags, 0, 0, io_ptr, ret_fs);
-
+	retval = ext2fs_open2(ctx->filesystem_name, ctx->io_options,
+			   flags, ctx->superblock, ctx->blocksize,
+			   io_ptr, ret_fs);
 	if (retval == 0) {
 		(*ret_fs)->priv_data = ctx;
 		e2fsck_set_bitmap_type(*ret_fs, EXT2FS_BMAP64_RBTREE,
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 6774e32c..c394ec80 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1588,6 +1588,10 @@ extern errcode_t ext2fs_open2(const char *name, const char *io_options,
 			      int flags, int superblock,
 			      unsigned int block_size, io_manager manager,
 			      ext2_filsys *ret_fs);
+extern errcode_t ext2fs_try_open_fs(char *filesystem_name, char *io_options,
+			     blk64_t superblock, int blocksize, int flags,
+			     io_manager io_ptr, ext2_filsys *ret_fs);
+
 /*
  * The dgrp_t argument to these two functions is not actually a group number
  * but a block number offset within a group table!  Convert with the formula
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index f74cd245..585ad766 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -108,7 +108,7 @@ errcode_t ext2fs_open(const char *name, int flags, int superblock,
  *	EXT2_FLAG_64BITS - Allow 64-bit bitfields (needed for large
  *				filesystems)
  */
-errcode_t ext2fs_open2(const char *name, const char *io_options,
+static errcode_t __ext2fs_open2(const char *name, const char *io_options,
 		       int flags, int superblock,
 		       unsigned int block_size, io_manager manager,
 		       ext2_filsys *ret_fs)
@@ -497,6 +497,40 @@ cleanup:
 	return retval;
 }
 
+errcode_t ext2fs_open2(const char *name, const char *io_options,
+		       int flags, int superblock,
+		       unsigned int block_size, io_manager manager,
+		       ext2_filsys *ret_fs)
+{
+	errcode_t retval;
+
+	*ret_fs = NULL;
+	if (superblock && block_size) {
+		retval = __ext2fs_open2(name, io_options,
+				      flags, superblock, block_size,
+				      manager, ret_fs);
+	} else if (superblock) {
+		int block_size;
+
+		for (block_size = EXT2_MIN_BLOCK_SIZE;
+		     block_size <= EXT2_MAX_BLOCK_SIZE; block_size *= 2) {
+			if (*ret_fs) {
+				ext2fs_free(*ret_fs);
+				*ret_fs = NULL;
+			}
+			retval = __ext2fs_open2(name,
+					      io_options, flags,
+					      superblock, block_size,
+					      manager, ret_fs);
+			if (!retval)
+				break;
+		}
+	} else
+		retval = __ext2fs_open2(name, io_options,
+				      flags, 0, 0, manager, ret_fs);
+	return retval;
+}
+
 /*
  * Set/get the filesystem data I/O channel.
  *
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 395ea9ee..6c4d7965 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -568,20 +568,9 @@ int main (int argc, char ** argv)
 	if (image_dump)
 		flags |= EXT2_FLAG_IMAGE_FILE;
 try_open_again:
-	if (use_superblock && !use_blocksize) {
-		for (use_blocksize = EXT2_MIN_BLOCK_SIZE;
-		     use_blocksize <= EXT2_MAX_BLOCK_SIZE;
-		     use_blocksize *= 2) {
-			retval = ext2fs_open (device_name, flags,
-					      use_superblock,
-					      use_blocksize, unix_io_manager,
-					      &fs);
-			if (!retval)
-				break;
-		}
-	} else
-		retval = ext2fs_open (device_name, flags, use_superblock,
-				      use_blocksize, unix_io_manager, &fs);
+	retval = ext2fs_open2(device_name, 0,
+				    flags, use_superblock, use_blocksize,
+				    unix_io_manager, &fs);
 	if (retval && !(flags & EXT2_FLAG_IGNORE_CSUM_ERRORS)) {
 		flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 		goto try_open_again;
-- 
2.13.6 (Apple Git-96)
