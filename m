From: Pu Hou <houpu.hp@alibaba-inc.com>
Subject: [PATCH] debugfs: Add inline data feature for symlink.
Date: Thu, 31 Jul 2014 14:58:52 +0800
Message-ID: <1406789932-13770-1-git-send-email-houpu.hp@alibaba-inc.com>
Cc: boyu.mt@taobao.com, wenqing.lz@taobao.com,
	Pu Hou <houpu.hp@alibaba-inc.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:58086 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbaGaG67 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jul 2014 02:58:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Symlink in debugfs can take advantage of inline data feature. The path name of the target of the symbol link which is longer than 60 byte and shorter than 132 byte can stay in inline data area.

Signed-off-by: Pu Hou <houpu.hp@alibaba-inc.com>
---
 lib/ext2fs/ext2fs.h      |  3 +++
 lib/ext2fs/inline_data.c | 26 +++++++++++++++++++++++
 lib/ext2fs/symlink.c     | 55 +++++++++++++++++++++++++++++++++++-------------
 3 files changed, 69 insertions(+), 15 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 7812956..8268d96 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1401,6 +1401,9 @@ extern errcode_t ext2fs_inline_data_get(ext2_filsys fs, ext2_ino_t ino,
 extern errcode_t ext2fs_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
 					struct ext2_inode *inode,
 					void *buf, size_t size);
+extern errcode_t ext2fs_symlink_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
+					struct ext2_inode *inode,
+					void *buf, size_t size);
 
 /* inode.c */
 extern errcode_t ext2fs_create_inode_cache(ext2_filsys fs,
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 19248a0..ed82a32 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -585,6 +585,32 @@ errcode_t ext2fs_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
 	return ext2fs_inline_data_ea_set(&data);
 }
 
+errcode_t ext2fs_symlink_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
+				 struct ext2_inode *inode,
+				 void *buf, size_t size)
+{
+	struct ext2_inode inode_buf;
+	struct ext2_inline_data data;
+	errcode_t retval;
+	size_t free_ea_size, existing_size, free_inode_size;
+
+	if (!inode) {
+		retval = ext2fs_read_inode(fs, ino, &inode_buf);
+		if (retval)
+			return retval;
+		inode = &inode_buf;
+	}
+	memcpy((void *)inode->i_block, buf, EXT4_MIN_INLINE_DATA_SIZE);
+	retval = ext2fs_write_inode(fs, ino, inode);
+	if (retval)
+		return retval;
+	data.fs = fs;
+	data.ino = ino;
+	data.ea_size = size - EXT4_MIN_INLINE_DATA_SIZE;
+	data.ea_data = buf + EXT4_MIN_INLINE_DATA_SIZE;
+	return ext2fs_inline_data_ea_set(&data);
+}
+
 #ifdef DEBUG
 #include "e2p/e2p.h"
 
diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
index ba8ed8e..a31912d 100644
--- a/lib/ext2fs/symlink.c
+++ b/lib/ext2fs/symlink.c
@@ -27,6 +27,7 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "ext2_ext_attr.h"
 
 errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 			 const char *name, char *target)
@@ -36,6 +37,8 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	ext2_ino_t		scratch_ino;
 	blk64_t			blk;
 	int			fastlink;
+	int                     inline_link = 0;
+	int                     max_inline;
 	unsigned int		target_len;
 	char			*block_buf = 0;
 
@@ -53,12 +56,27 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	 */
 	fastlink = (target_len < sizeof(inode.i_block));
 	if (!fastlink) {
-		retval = ext2fs_new_block2(fs, 0, 0, &blk);
-		if (retval)
-			goto cleanup;
-		retval = ext2fs_get_mem(fs->blocksize, &block_buf);
-		if (retval)
-			goto cleanup;
+		if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
+			/* whether target string can be stored
+			in inline data area */
+			max_inline = EXT2_INODE_SIZE(fs->super) -
+					sizeof(struct ext2_inode_large)-
+					sizeof(__u32)-
+					sizeof(struct ext2_ext_attr_entry)-
+					strlen("data")-
+					sizeof(__u32)+
+					EXT4_MIN_INLINE_DATA_SIZE;
+			inline_link = (target_len < max_inline);
+		}
+		if (!inline_link) {
+			retval = ext2fs_new_block2(fs, 0, 0, &blk);
+			if (retval)
+				goto cleanup;
+			retval = ext2fs_get_mem(fs->blocksize, &block_buf);
+			if (retval)
+				goto cleanup;
+		}
 	}
 
 	/*
@@ -77,7 +95,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	memset(&inode, 0, sizeof(struct ext2_inode));
 	inode.i_mode = LINUX_S_IFLNK | 0777;
 	inode.i_uid = inode.i_gid = 0;
-	ext2fs_iblk_set(fs, &inode, fastlink ? 0 : 1);
+	ext2fs_iblk_set(fs, &inode, (fastlink || inline_link) ? 0 : 1);
 	inode.i_links_count = 1;
 	ext2fs_inode_size_set(fs, &inode, target_len);
 	/* The time fields are set by ext2fs_write_new_inode() */
@@ -85,6 +103,8 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	if (fastlink) {
 		/* Fast symlinks, target stored in inode */
 		strcpy((char *)&inode.i_block, target);
+	} else if (inline_link) {
+		inode.i_flags |= EXT4_INLINE_DATA_FL;
 	} else {
 		/* Slow symlinks, target stored in the first block */
 		memset(block_buf, 0, fs->blocksize);
@@ -109,14 +129,19 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 		goto cleanup;
 
 	if (!fastlink) {
-		retval = ext2fs_bmap2(fs, ino, &inode, NULL, BMAP_SET, 0, NULL,
-				      &blk);
-		if (retval)
-			goto cleanup;
+		if (inline_link) {
+			retval = ext2fs_symlink_inline_data_set(fs, ino, 0,
+						target, target_len);
+		} else {
+			retval = ext2fs_bmap2(fs, ino, &inode, NULL,
+						BMAP_SET, 0, NULL, &blk);
+		  if (retval)
+		    goto cleanup;
 
-		retval = io_channel_write_blk64(fs->io, blk, 1, block_buf);
-		if (retval)
-			goto cleanup;
+		  retval = io_channel_write_blk64(fs->io, blk, 1, block_buf);
+		  if (retval)
+		    goto cleanup;
+		}
 	}
 
 	/*
@@ -139,7 +164,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	/*
 	 * Update accounting....
 	 */
-	if (!fastlink)
+	if ((!fastlink) && (!inline_link))
 		ext2fs_block_alloc_stats2(fs, blk, +1);
 	ext2fs_inode_alloc_stats2(fs, ino, +1, 0);
 
-- 
1.9.1


