From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH 1/4] ext2fs: opening filesystem code refactoring
Date: Mon, 26 Jun 2017 19:58:43 +0300
Message-ID: <1498496326-76684-2-git-send-email-artem.blagodarenko@gmail.com>
References: <1498496326-76684-1-git-send-email-artem.blagodarenko@gmail.com>
Cc: alexey.lyashkov@gmail.com, artem.blagodarenko@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35315 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752184AbdGDM2M (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Jul 2017 08:28:12 -0400
Received: by mail-lf0-f68.google.com with SMTP id z78so5355282lff.2
        for <linux-ext4@vger.kernel.org>; Tue, 04 Jul 2017 05:28:11 -0700 (PDT)
In-Reply-To: <1498496326-76684-1-git-send-email-artem.blagodarenko@gmail.com>
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

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
---
 e2fsck/unix.c       |   28 +++-------------------------
 lib/ext2fs/ext2fs.h |    4 ++++
 lib/ext2fs/openfs.c |   32 ++++++++++++++++++++++++++++++++
 misc/dumpe2fs.c     |   17 +++--------------
 4 files changed, 42 insertions(+), 39 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index ff96148..76f984b 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1116,31 +1116,9 @@ static errcode_t try_open_fs(e2fsck_t ctx, int flags, io_manager io_ptr,
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
+	retval = ext2fs_try_open_fs(ctx->filesystem_name, ctx->io_options,
+			   ctx->superblock, ctx->blocksize, flags,
+			   io_ptr, ret_fs);
 	if (retval == 0) {
 		(*ret_fs)->priv_data = ctx;
 		e2fsck_set_bitmap_type(*ret_fs, EXT2FS_BMAP64_RBTREE,
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index c18ea5f..1163ab6 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1577,6 +1577,10 @@ extern errcode_t ext2fs_open2(const char *name, const char *io_options,
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
index 93b02ed..a236b40 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -487,6 +487,38 @@ cleanup:
 	return retval;
 }
 
+errcode_t ext2fs_try_open_fs(char *filesystem_name, char *io_options,
+			     blk64_t superblock, int blocksize, int flags,
+			     io_manager io_ptr, ext2_filsys *ret_fs)
+{
+	errcode_t retval;
+
+	*ret_fs = NULL;
+	if (superblock && blocksize) {
+		retval = ext2fs_open2(filesystem_name, io_options,
+				      flags, superblock, blocksize,
+				      io_ptr, ret_fs);
+	} else if (superblock) {
+		int blocksize;
+		for (blocksize = EXT2_MIN_BLOCK_SIZE;
+		     blocksize <= EXT2_MAX_BLOCK_SIZE; blocksize *= 2) {
+			if (*ret_fs) {
+				ext2fs_free(*ret_fs);
+				*ret_fs = NULL;
+			}
+			retval = ext2fs_open2(filesystem_name,
+					      io_options, flags,
+					      superblock, blocksize,
+					      io_ptr, ret_fs);
+			if (!retval)
+				break;
+		}
+	} else
+		retval = ext2fs_open2(filesystem_name, io_options,
+				      flags, 0, 0, io_ptr, ret_fs);
+	return retval;
+}
+
 /*
  * Set/get the filesystem data I/O channel.
  *
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 395ea9e..0f55cfb 100644
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
+	retval = ext2fs_try_open_fs(device_name, 0,
+				    use_superblock, use_blocksize, flags,
+				    unix_io_manager, &fs);
 	if (retval && !(flags & EXT2_FLAG_IGNORE_CSUM_ERRORS)) {
 		flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 		goto try_open_again;
-- 
1.7.1
