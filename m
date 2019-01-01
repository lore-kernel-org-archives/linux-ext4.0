Return-Path: <SRS0=/7aD=PJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:53906 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfAAVIF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jan 2019 16:08:05 -0500
Received: by mail-it1-f194.google.com with SMTP id g85so38930567ita.3
        for <linux-ext4@vger.kernel.org>; Tue, 01 Jan 2019 13:08:04 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca
Subject: [PATCH v6 1/4] ext2fs: opening filesystem code refactoring
Date: Tue,  1 Jan 2019 22:07:34 +0100
Message-Id: <20190101210737.87248-2-c17828@cray.com>
In-Reply-To: <20190101210737.87248-1-c17828@cray.com>
References: <20190101210737.87248-1-c17828@cray.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are similar opening filesystem code in different utilities.

The patch moves improved handling from try_open_fs()
into ext2fs_open(). This function make one of the action
based on parameters:
1) open filesystem with given superblock, superblock size
2) open filesystem with given superblock, but try to
find right block size
3) open filesystem with default superblock and block size

Signed-off-by: Artem Blagodarenko <c17828@cray.com>
---
 e2fsck/unix.c       | 28 +++-------------------------
 lib/ext2fs/openfs.c | 41 +++++++++++++++++++++++++++++++++++++----
 misc/dumpe2fs.c     | 17 ++---------------
 3 files changed, 42 insertions(+), 44 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 5b3552ec..ddcf52a4 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1151,31 +1151,9 @@ static errcode_t try_open_fs(e2fsck_t ctx, int flags, io_manager io_ptr,
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
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 85d73e2a..7c16e386 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -114,10 +114,10 @@ static void block_sha_map_free_entry(void *data)
  *	EXT2_FLAG_64BITS - Allow 64-bit bitfields (needed for large
  *				filesystems)
  */
-errcode_t ext2fs_open2(const char *name, const char *io_options,
-		       int flags, int superblock,
-		       unsigned int block_size, io_manager manager,
-		       ext2_filsys *ret_fs)
+static errcode_t __ext2fs_open2(const char *name, const char *io_options,
+				int flags, int superblock,
+				unsigned int block_size, io_manager manager,
+				ext2_filsys *ret_fs)
 {
 	ext2_filsys	fs;
 	errcode_t	retval;
@@ -515,6 +515,39 @@ cleanup:
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
+			retval = __ext2fs_open2(name, io_options, flags,
+						superblock, block_size,
+						manager, ret_fs);
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
index 384ce925..183e2f6f 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -667,21 +667,8 @@ int main (int argc, char ** argv)
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
-	} else {
-		retval = ext2fs_open(device_name, flags, use_superblock,
-				     use_blocksize, unix_io_manager, &fs);
-	}
+	retval = ext2fs_open2(device_name, 0, flags, use_superblock,
+			      use_blocksize, unix_io_manager, &fs);
 	flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	if (retval && !retval_csum) {
 		retval_csum = retval;
-- 
2.14.3
