From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 31/32] libext2fs: add read/write inline data functions
Date: Mon, 16 Apr 2012 19:40:06 +0800
Message-ID: <1334576407-4007-32-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43674 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab2DPLet (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:49 -0400
Received: by mail-pb0-f46.google.com with SMTP id un15so6233785pbc.19
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:48 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Add read/write inline data functions for pass2.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/dirblock.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2fs.h   |    6 ++++
 2 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/dirblock.c b/lib/ext2fs/dirblock.c
index cb3a104..8fdffe5 100644
--- a/lib/ext2fs/dirblock.c
+++ b/lib/ext2fs/dirblock.c
@@ -71,6 +71,45 @@ errcode_t ext2fs_read_dir_block(ext2_filsys fs, blk_t block,
 	return ext2fs_read_dir_block3(fs, block, buf, 0);
 }
 
+errcode_t ext2fs_read_dir_inline_data(ext2_filsys fs, ext2_ino_t ino, void *buf)
+{
+	struct ext2_inode_large *inode;
+	struct inline_data idata;
+
+	ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
+	ext2fs_read_inode_full(fs, ino, (void *)inode, EXT2_INODE_SIZE(fs->super));
+
+	if (!(inode->i_flags & EXT4_INLINE_DATA_FL))
+		return -1;
+
+	memcpy(buf, inode->i_block, EXT4_MIN_INLINE_DATA_SIZE);
+
+	ext2fs_free_mem(&inode);
+	return 0;
+}
+
+errcode_t ext2fs_read_dir_inline_data_more(ext2_filsys fs, ext2_ino_t ino, void *buf)
+{
+	struct ext2_inode_large *inode;
+	struct inline_data idata;
+
+	ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
+	ext2fs_read_inode_full(fs, ino, (void *)inode, EXT2_INODE_SIZE(fs->super));
+
+	if (!(inode->i_flags & EXT4_INLINE_DATA_FL))
+		return -1;
+
+	ext2fs_iget_extra_inode(fs, inode, &idata);
+	if (idata.inline_size == EXT4_MIN_INLINE_DATA_SIZE)
+		return 0;
+
+	memcpy(buf + EXT4_MIN_INLINE_DATA_SIZE,
+	       ext2fs_get_inline_xattr_pos(inode, &idata),
+	       idata.inline_size - EXT4_MIN_INLINE_DATA_SIZE);
+
+	ext2fs_free_mem(&inode);
+	return 0;
+}
 
 errcode_t ext2fs_write_dir_block3(ext2_filsys fs, blk64_t block,
 				  void *inbuf, int flags EXT2FS_ATTR((unused)))
@@ -125,3 +164,26 @@ errcode_t ext2fs_write_dir_block(ext2_filsys fs, blk_t block,
 	return ext2fs_write_dir_block3(fs, block, inbuf, 0);
 }
 
+errcode_t ext2fs_write_dir_inline_data(ext2_filsys fs, ext2_ino_t ino, void *buf)
+{
+	struct ext2_inode_large *inode;
+	struct inline_data idata;
+
+	ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
+	ext2fs_read_inode_full(fs, ino, (void *)inode, EXT2_INODE_SIZE(fs->super));
+
+	memcpy(inode->i_block, buf, EXT4_MIN_INLINE_DATA_SIZE);
+
+	ext2fs_iget_extra_inode(fs, inode, &idata);
+	if (idata.inline_size == EXT4_MIN_INLINE_DATA_SIZE)
+		goto out;
+
+	memcpy(ext2fs_get_inline_xattr_pos(inode, &idata),
+	       buf + EXT4_MIN_INLINE_DATA_SIZE,
+	       idata.inline_size - EXT4_MIN_INLINE_DATA_SIZE);
+
+out:
+	ext2fs_write_inode_full(fs, ino, (void *)inode, EXT2_INODE_SIZE(fs->super));
+	ext2fs_free_mem(&inode);
+	return 0;
+}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index cb1b58e..dcc9700 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1009,12 +1009,18 @@ extern errcode_t ext2fs_read_dir_block2(ext2_filsys fs, blk_t block,
 					void *buf, int flags);
 extern errcode_t ext2fs_read_dir_block3(ext2_filsys fs, blk64_t block,
 					void *buf, int flags);
+extern errcode_t ext2fs_read_dir_inline_data(ext2_filsys fs, ext2_ino_t ino,
+					     void *buf);
+extern errcode_t ext2fs_read_dir_inline_data_more(ext2_filsys fs, ext2_ino_t ino,
+						  void *buf);
 extern errcode_t ext2fs_write_dir_block(ext2_filsys fs, blk_t block,
 					void *buf);
 extern errcode_t ext2fs_write_dir_block2(ext2_filsys fs, blk_t block,
 					 void *buf, int flags);
 extern errcode_t ext2fs_write_dir_block3(ext2_filsys fs, blk64_t block,
 					 void *buf, int flags);
+extern errcode_t ext2fs_write_dir_inline_data(ext2_filsys fs, ext2_ino_t ino,
+					      void *buf);
 
 /* dirhash.c */
 extern errcode_t ext2fs_dirhash(int version, const char *name, int len,
-- 
1.7.4.1

