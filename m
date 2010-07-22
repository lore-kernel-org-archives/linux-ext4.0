From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 7/7] libext2fs: Add ext2fs_file_size_size2() and truncate the file if necessary
Date: Thu, 22 Jul 2010 10:03:18 -0400
Message-ID: <1279807398-13680-8-git-send-email-tytso@mit.edu>
References: <1279807398-13680-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Renzo Davoli <renzo@cs.unibo.it>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34076 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759466Ab0GVODW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jul 2010 10:03:22 -0400
In-Reply-To: <1279807398-13680-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This adds a 64-bit interface for ext2fs_file_size_size() and enhances
it to trunate the file if necessary.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/ext2fs.h |    1 +
 lib/ext2fs/fileio.c |   18 ++++++++++--------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 96dc54b..f2f9ac8 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1028,6 +1028,7 @@ extern errcode_t ext2fs_file_lseek(ext2_file_t file, ext2_off_t offset,
 errcode_t ext2fs_file_get_lsize(ext2_file_t file, __u64 *ret_size);
 extern ext2_off_t ext2fs_file_get_size(ext2_file_t file);
 extern errcode_t ext2fs_file_set_size(ext2_file_t file, ext2_off_t size);
+extern errcode_t ext2fs_file_set_size2(ext2_file_t file, ext2_off64_t size);
 
 /* finddev.c */
 extern char *ext2fs_find_block_device(dev_t device);
diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index f3a4d70..ddb3bda 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -365,24 +365,26 @@ ext2_off_t ext2fs_file_get_size(ext2_file_t file)
 /*
  * This function sets the size of the file, truncating it if necessary
  *
- * XXX still need to call truncate
  */
-errcode_t ext2fs_file_set_size(ext2_file_t file, ext2_off_t size)
+errcode_t ext2fs_file_set_size2(ext2_file_t file, ext2_off64_t size)
 {
 	errcode_t	retval;
 	EXT2_CHECK_MAGIC(file, EXT2_ET_MAGIC_EXT2_FILE);
 
-	file->inode.i_size = size;
-	file->inode.i_size_high = 0;
+	file->inode.i_size = size & 0xffffffff;
+	file->inode.i_size_high = (size >> 32);
 	if (file->ino) {
 		retval = ext2fs_write_inode(file->fs, file->ino, &file->inode);
 		if (retval)
 			return retval;
 	}
 
-	/*
-	 * XXX truncate inode if necessary
-	 */
+	return ext2fs_punch(file->fs, file->ino, &file->inode, 0,
+			    (size + file->fs->blocksize - 1) >>
+			    EXT2_BLOCK_SIZE_BITS(file->fs->super), ~0ULL);
+}
 
-	return 0;
+errcode_t ext2fs_file_set_size(ext2_file_t file, ext2_off_t size)
+{
+	return ext2fs_file_set_size2(file, size);
 }
-- 
1.7.0.4

