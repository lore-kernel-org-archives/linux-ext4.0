From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 6/7] libext2fs: Add new function ext2fs_file_get_inode()
Date: Thu, 22 Jul 2010 10:03:17 -0400
Message-ID: <1279807398-13680-7-git-send-email-tytso@mit.edu>
References: <1279807398-13680-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Renzo Davoli <renzo@cs.unibo.it>, Theodore Ts'o <tytso@mit.edu>
To: Renzo Davoli <renzo@cs.unibo.it>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34074 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759451Ab0GVODW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jul 2010 10:03:22 -0400
In-Reply-To: <1279807398-13680-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Renzo Davoli <renzo@cs.unibo.it>

This patch adds a very simple function:

	struct ext2_inode *ext2fs_file_get_inode(ext2_file_t file);

which is useful for fuse-ext2 when it needs to read the inode of an
open file.

Signed-off-by: renzo davoli <renzo@cs.unibo.it>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/ext2fs/ext2fs.h |    1 +
 lib/ext2fs/fileio.c |   10 ++++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index f3531c0..96dc54b 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1014,6 +1014,7 @@ extern errcode_t ext2fs_file_open2(ext2_filsys fs, ext2_ino_t ino,
 extern errcode_t ext2fs_file_open(ext2_filsys fs, ext2_ino_t ino,
 				  int flags, ext2_file_t *ret);
 extern ext2_filsys ext2fs_file_get_fs(ext2_file_t file);
+struct ext2_inode *ext2fs_file_get_inode(ext2_file_t file);
 extern errcode_t ext2fs_file_close(ext2_file_t file);
 extern errcode_t ext2fs_file_flush(ext2_file_t file);
 extern errcode_t ext2fs_file_read(ext2_file_t file, void *buf,
diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 2a80d16..f3a4d70 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -96,6 +96,16 @@ ext2_filsys ext2fs_file_get_fs(ext2_file_t file)
 }
 
 /*
+ * This function returns the pointer to the inode of a file from the structure
+ */
+struct ext2_inode *ext2fs_file_get_inode(ext2_file_t file)
+{
+	if (file->magic != EXT2_ET_MAGIC_EXT2_FILE)
+		return NULL;
+	return &file->inode;
+}
+
+/*
  * This function flushes the dirty block buffer out to disk if
  * necessary.
  */
-- 
1.7.0.4

