From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 32/36 v4] libext2fs: add read/write inline data functions
Date: Tue, 31 Jul 2012 19:48:25 +0800
Message-ID: <1343735309-30579-33-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53943 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab2GaLkq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:40:46 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so11540999pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:40:45 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Add read/write inline data functions for pass2.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/dirblock.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2fs.h   |    7 +++++
 2 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/dirblock.c b/lib/ext2fs/dirblock.c
index 54b2777..77e8f39 100644
--- a/lib/ext2fs/dirblock.c
+++ b/lib/ext2fs/dirblock.c
@@ -62,6 +62,45 @@ errcode_t ext2fs_read_dir_block(ext2_filsys fs, blk_t block,
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
 
 errcode_t ext2fs_write_dir_block4(ext2_filsys fs, blk64_t block,
 				  void *inbuf, int flags EXT2FS_ATTR((unused)),
@@ -111,3 +150,26 @@ errcode_t ext2fs_write_dir_block(ext2_filsys fs, blk_t block,
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
index bacc14d..0bd5023 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1060,6 +1060,11 @@ extern errcode_t ext2fs_read_dir_block3(ext2_filsys fs, blk64_t block,
 					void *buf, int flags);
 extern errcode_t ext2fs_read_dir_block4(ext2_filsys fs, blk64_t block,
 					void *buf, int flags, ext2_ino_t ino);
+extern errcode_t ext2fs_read_dir_inline_data(ext2_filsys fs, ext2_ino_t ino,
+					     void *buf);
+extern errcode_t ext2fs_read_dir_inline_data_more(ext2_filsys fs,
+						  ext2_ino_t ino,
+						  void *buf);
 extern errcode_t ext2fs_write_dir_block(ext2_filsys fs, blk_t block,
 					void *buf);
 extern errcode_t ext2fs_write_dir_block2(ext2_filsys fs, blk_t block,
@@ -1068,6 +1073,8 @@ extern errcode_t ext2fs_write_dir_block3(ext2_filsys fs, blk64_t block,
 					 void *buf, int flags);
 extern errcode_t ext2fs_write_dir_block4(ext2_filsys fs, blk64_t block,
 					 void *buf, int flags, ext2_ino_t ino);
+extern errcode_t ext2fs_write_dir_inline_data(ext2_filsys fs, ext2_ino_t ino,
+					      void *buf);
 
 /* dirhash.c */
 extern errcode_t ext2fs_dirhash(int version, const char *name, int len,
-- 
1.7.4.1

