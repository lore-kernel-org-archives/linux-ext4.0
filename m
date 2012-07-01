From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 17/35 v3] debugfs: make mkdir cmd support inline data
Date: Sun,  1 Jul 2012 21:48:40 +0800
Message-ID: <1341150538-32047-18-git-send-email-wenqing.lz@taobao.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49296 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428Ab2GANlV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:41:21 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so6469492pbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:41:20 -0700 (PDT)
In-Reply-To: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

We need to reload inode in ext2fs_mkdir because inode with inline itself
data is modified in ext2fs_link.

Now we cannot create an empty dir with inline data because we need to do
a lot of works for maniluating xattr, and it brings a huge impacts for
e2fsprogs.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/mkdir.c |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index 4a85439..3c226f3 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -41,6 +41,7 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	ext2_ino_t		scratch_ino;
 	blk64_t			blk;
 	char			*block = 0;
+	int			unmark_blk = 0;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -115,6 +116,14 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	}
 
 	/*
+	 * XXX: We need to update accouting before we mkdir successful because
+	 * in ext2fs_link it could allocate a new block when there is no space
+	 * to store a new dir entry in inline data.  If ext2fs_link failed, we
+	 * need to unmark this block.
+	 */
+	ext2fs_block_alloc_stats2(fs, blk, +1);
+
+	/*
 	 * Link the directory into the filesystem hierarchy
 	 */
 	if (name) {
@@ -123,32 +132,48 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 		if (!retval) {
 			retval = EXT2_ET_DIR_EXISTS;
 			name = 0;
+			unmark_blk = 1;
 			goto cleanup;
 		}
-		if (retval != EXT2_ET_FILE_NOT_FOUND)
+		if (retval != EXT2_ET_FILE_NOT_FOUND) {
+			unmark_blk = 1;
 			goto cleanup;
+		}
 		retval = ext2fs_link(fs, parent, name, ino, EXT2_FT_DIR);
-		if (retval)
+		if (retval) {
+			unmark_blk = 1;
 			goto cleanup;
+		}
 	}
 
 	/*
 	 * Update parent inode's counts
 	 */
 	if (parent != ino) {
+		/* Reload parent inode */
+		retval = ext2fs_read_inode(fs, parent, &parent_inode);
+		if (retval) {
+			unmark_blk = 1;
+			goto cleanup;
+		}
 		parent_inode.i_links_count++;
 		retval = ext2fs_write_inode(fs, parent, &parent_inode);
-		if (retval)
+		if (retval) {
+			unmark_blk = 1;
 			goto cleanup;
+		}
 	}
 
 	/*
 	 * Update accounting....
 	 */
-	ext2fs_block_alloc_stats2(fs, blk, +1);
 	ext2fs_inode_alloc_stats2(fs, ino, +1, 1);
 
 cleanup:
+	/* Unmark block because mkdir failed */
+	if (unmark_blk)
+		ext2fs_block_alloc_stats2(fs, blk, -1);
+
 	if (block)
 		ext2fs_free_mem(&block);
 	return retval;
-- 
1.7.4.1

