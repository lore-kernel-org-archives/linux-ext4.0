From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 05/15][e2fsprogs] Add 64-bit dirblock interface.
Date: Tue, 15 Jul 2008 11:50:33 -0500
Message-ID: <20080715165032.28567.30413.stgit@ichigo>
References: <20080715164332.28567.27913.stgit@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34595 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555AbYGOQvv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 12:51:51 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6FGpoJ9011986
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:51:50 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6FGoYT7134916
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:50:34 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6FGoXgp020760
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:50:34 -0400
In-Reply-To: <20080715164332.28567.27913.stgit@ichigo>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add 64-bit dirblock interface.

Add new ext2fs_(read|write)_dir_block3() routines that take blk64_t as
an input.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/dirblock.c |   23 +++++++++++++++++------
 lib/ext2fs/ext2fs.h   |    4 ++++
 2 files changed, 21 insertions(+), 6 deletions(-)
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
--

 lib/ext2fs/dirblock.c |   23 +++++++++++++++++------
 lib/ext2fs/ext2fs.h   |    4 ++++
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/lib/ext2fs/dirblock.c b/lib/ext2fs/dirblock.c
index fb20fa0..c45c6ce 100644
--- a/lib/ext2fs/dirblock.c
+++ b/lib/ext2fs/dirblock.c
@@ -19,7 +19,7 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
-errcode_t ext2fs_read_dir_block2(ext2_filsys fs, blk_t block,
+errcode_t ext2fs_read_dir_block3(ext2_filsys fs, blk64_t block,
 				 void *buf, int flags EXT2FS_ATTR((unused)))
 {
 	errcode_t	retval;
@@ -28,7 +28,7 @@ errcode_t ext2fs_read_dir_block2(ext2_filsys fs, blk_t block,
 	unsigned int	name_len, rec_len;
 	
 
- 	retval = io_channel_read_blk(fs->io, block, 1, buf);
+	retval = io_channel_read_blk64(fs->io, block, 1, buf);
 	if (retval)
 		return retval;
 
@@ -58,14 +58,20 @@ errcode_t ext2fs_read_dir_block2(ext2_filsys fs, blk_t block,
 	return retval;
 }
 
+errcode_t ext2fs_read_dir_block2(ext2_filsys fs, blk_t block,
+				 void *buf, int flags EXT2FS_ATTR((unused)))
+{
+	return ext2fs_read_dir_block3(fs, block, buf, flags);
+}
+
 errcode_t ext2fs_read_dir_block(ext2_filsys fs, blk_t block,
 				 void *buf)
 {
-	return ext2fs_read_dir_block2(fs, block, buf, 0);
+	return ext2fs_read_dir_block3(fs, block, buf, 0);
 }
 
 
-errcode_t ext2fs_write_dir_block2(ext2_filsys fs, blk_t block,
+errcode_t ext2fs_write_dir_block3(ext2_filsys fs, blk64_t block,
 				  void *inbuf, int flags EXT2FS_ATTR((unused)))
 {
 #ifdef WORDS_BIGENDIAN
@@ -95,7 +101,7 @@ errcode_t ext2fs_write_dir_block2(ext2_filsys fs, blk_t block,
 		if (flags & EXT2_DIRBLOCK_V2_STRUCT)
 			dirent->name_len = ext2fs_swab16(dirent->name_len);
 	}
- 	retval = io_channel_write_blk(fs->io, block, 1, buf);
+	retval = io_channel_write_blk64(fs->io, block, 1, buf);
 	ext2fs_free_mem(&buf);
 	return retval;
 #else
@@ -103,10 +109,15 @@ errcode_t ext2fs_write_dir_block2(ext2_filsys fs, blk_t block,
 #endif
 }
 
+errcode_t ext2fs_write_dir_block2(ext2_filsys fs, blk_t block,
+				 void *inbuf, int flags EXT2FS_ATTR((unused)))
+{
+	return ext2fs_write_dir_block3(fs, block, inbuf, flags);
+}
 
 errcode_t ext2fs_write_dir_block(ext2_filsys fs, blk_t block,
 				 void *inbuf)
 {
-	return ext2fs_write_dir_block2(fs, block, inbuf, 0);
+	return ext2fs_write_dir_block3(fs, block, inbuf, 0);
 }
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 35cf0a3..a643aa1 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -808,10 +808,14 @@ extern errcode_t ext2fs_read_dir_block(ext2_filsys fs, blk_t block,
 				       void *buf);
 extern errcode_t ext2fs_read_dir_block2(ext2_filsys fs, blk_t block,
 					void *buf, int flags);
+extern errcode_t ext2fs_read_dir_block3(ext2_filsys fs, blk64_t block,
+					void *buf, int flags);
 extern errcode_t ext2fs_write_dir_block(ext2_filsys fs, blk_t block,
 					void *buf);
 extern errcode_t ext2fs_write_dir_block2(ext2_filsys fs, blk_t block,
 					 void *buf, int flags);
+extern errcode_t ext2fs_write_dir_block3(ext2_filsys fs, blk64_t block,
+					 void *buf, int flags);
 
 /* dirhash.c */
 extern errcode_t ext2fs_dirhash(int version, const char *name, int len,

