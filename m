From: "Pu Hou" <houpu.hp@alibaba-inc.com>
Subject: [PATCH v2] debugfs: add inline data feature for symlink
Date: Fri, 08 Aug 2014 14:34:52 +0800
Message-ID: <1407479692-29026-1-git-send-email-houpu.hp@alibaba-inc.com>
Cc: <darrick.wong@oracle.com>, "Pu Hou" <houpu.hp@alibaba-inc.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out11.biz.mail.alibaba.com ([205.204.114.131]:41426 "EHLO
	out11.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752831AbaHHGlT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Aug 2014 02:41:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Symlink in debugfs can take advantage of inline data feature.
The target string of the symbol link whose length is shorter
than the available size of the inline data of the inode
can be stored in the inline data area.

Signed-off-by: Pu Hou <houpu.hp@alibaba-inc.com>
---
 lib/ext2fs/ext2fs.h      |  3 ++
 lib/ext2fs/inline_data.c | 39 +++++++++++++++++++++++
 lib/ext2fs/symlink.c     | 81 +++++++++++++++++++++++++++++-------------------
 3 files changed, 91 insertions(+), 32 deletions(-)

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
index 19248a0..1cc7331 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -585,6 +585,45 @@ errcode_t ext2fs_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
 	return ext2fs_inline_data_ea_set(&data);
 }
 
+errcode_t ext2fs_symlink_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
+				 struct ext2_inode *inode,
+				 void *buf, size_t size)
+{
+	struct ext2_inode inode_buf;
+	struct ext2_inline_data data;
+	errcode_t retval;
+	size_t free_ea_size;
+
+	if (!inode) {
+		retval = ext2fs_read_inode(fs, ino, &inode_buf);
+		if (retval)
+			return retval;
+		inode = &inode_buf;
+	}
+
+	if (size <= EXT4_MIN_INLINE_DATA_SIZE) {
+		memcpy((void *)inode->i_block, buf, size);
+		return ext2fs_write_inode(fs, ino, inode);
+	}
+
+	retval = ext2fs_xattr_inode_max_size(fs, ino, &free_ea_size);
+	if (retval)
+		return retval;
+
+	if (size > EXT4_MIN_INLINE_DATA_SIZE + free_ea_size)
+		return EXT2_ET_INLINE_DATA_NO_SPACE;
+
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
index ba8ed8e..c6993ac 100644
--- a/lib/ext2fs/symlink.c
+++ b/lib/ext2fs/symlink.c
@@ -36,6 +36,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	ext2_ino_t		scratch_ino;
 	blk64_t			blk;
 	int			fastlink;
+	int			inline_link = 0;
 	unsigned int		target_len;
 	char			*block_buf = 0;
 
@@ -48,18 +49,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 		goto cleanup;
 	}
 
-	/*
-	 * Allocate a data block for slow links
-	 */
 	fastlink = (target_len < sizeof(inode.i_block));
-	if (!fastlink) {
-		retval = ext2fs_new_block2(fs, 0, 0, &blk);
-		if (retval)
-			goto cleanup;
-		retval = ext2fs_get_mem(fs->blocksize, &block_buf);
-		if (retval)
-			goto cleanup;
-	}
 
 	/*
 	 * Allocate an inode, if necessary
@@ -77,7 +67,6 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	memset(&inode, 0, sizeof(struct ext2_inode));
 	inode.i_mode = LINUX_S_IFLNK | 0777;
 	inode.i_uid = inode.i_gid = 0;
-	ext2fs_iblk_set(fs, &inode, fastlink ? 0 : 1);
 	inode.i_links_count = 1;
 	ext2fs_inode_size_set(fs, &inode, target_len);
 	/* The time fields are set by ext2fs_write_new_inode() */
@@ -85,18 +74,6 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	if (fastlink) {
 		/* Fast symlinks, target stored in inode */
 		strcpy((char *)&inode.i_block, target);
-	} else {
-		/* Slow symlinks, target stored in the first block */
-		memset(block_buf, 0, fs->blocksize);
-		strcpy(block_buf, target);
-		if (fs->super->s_feature_incompat &
-		    EXT3_FEATURE_INCOMPAT_EXTENTS) {
-			/*
-			 * The extent bmap is setup after the inode and block
-			 * have been written out below.
-			 */
-			inode.i_flags |= EXT4_EXTENTS_FL;
-		}
 	}
 
 	/*
@@ -109,14 +86,54 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 		goto cleanup;
 
 	if (!fastlink) {
-		retval = ext2fs_bmap2(fs, ino, &inode, NULL, BMAP_SET, 0, NULL,
-				      &blk);
-		if (retval)
-			goto cleanup;
+		/*Try to store symbol link in inline data area*/
+		if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
+			retval = ext2fs_symlink_inline_data_set(fs, ino,
+						0, target, target_len);
+			if (retval == EXT2_ET_INLINE_DATA_NO_SPACE) {
+				inline_link = 0;
+			} else if (retval) {
+				goto cleanup;
+			} else {
+				inline_link = 1;
+				ext2fs_read_inode(fs, ino, &inode);
+				inode.i_flags |= EXT4_INLINE_DATA_FL;
+				ext2fs_write_inode(fs, ino, &inode);
+			}
+		}
+		if (!inline_link) {
+			/* Store the symlink in a block */
+			retval = ext2fs_new_block2(fs, 0, 0, &blk);
+			if (retval)
+				goto cleanup;
+			retval = ext2fs_get_mem(fs->blocksize, &block_buf);
+			if (retval)
+				goto cleanup;
+			memset(block_buf, 0, fs->blocksize);
+			strcpy(block_buf, target);
+			ext2fs_read_inode(fs, ino, &inode);
+			ext2fs_iblk_set(fs, &inode, 1);
+			if (fs->super->s_feature_incompat &
+					EXT3_FEATURE_INCOMPAT_EXTENTS) {
+				/*
+				 * The extent bmap is setup after the inode and
+				 * block have been written out below.
+				 */
+				inode.i_flags |= EXT4_EXTENTS_FL;
+			}
+			ext2fs_write_inode(fs, ino, &inode);
 
-		retval = io_channel_write_blk64(fs->io, blk, 1, block_buf);
-		if (retval)
-			goto cleanup;
+			retval = ext2fs_bmap2(fs, ino, &inode, NULL,
+						BMAP_SET, 0, NULL, &blk);
+			if (retval)
+				goto cleanup;
+
+			retval = io_channel_write_blk64(fs->io, blk, 1,
+							block_buf);
+			if (retval)
+				goto cleanup;
+		}
 	}
 
 	/*
@@ -139,7 +156,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	/*
 	 * Update accounting....
 	 */
-	if (!fastlink)
+	if (!fastlink && !inline_link)
 		ext2fs_block_alloc_stats2(fs, blk, +1);
 	ext2fs_inode_alloc_stats2(fs, ino, +1, 0);
 
-- 
1.9.1

