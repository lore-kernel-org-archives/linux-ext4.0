From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 15/30] debugfs: make mkdir command support inline data
Date: Fri,  6 Dec 2013 17:58:02 +0800
Message-ID: <1386323897-2354-16-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:39242 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625Ab3LFJz7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:55:59 -0500
Received: by mail-pb0-f42.google.com with SMTP id uo5so798094pbc.1
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:55:58 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This commit tries to make mkdir command in debugfs support inline data.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/ext2fs.h      |    2 ++
 lib/ext2fs/ext2fsP.h     |    1 +
 lib/ext2fs/inline_data.c |   10 ++++++
 lib/ext2fs/mkdir.c       |   77 +++++++++++++++++++++++++++++++++-------------
 lib/ext2fs/newdir.c      |   25 +++++++++++++++
 5 files changed, 93 insertions(+), 22 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 1a267e2..322c39d 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1445,6 +1445,8 @@ int ext2fs_native_flag(void);
 /* newdir.c */
 extern errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
 				ext2_ino_t parent_ino, char **block);
+extern errcode_t ext2fs_new_dir_inline_data(ext2_filsys fs, ext2_ino_t dir_ino,
+				ext2_ino_t parent_ino, __u32 *iblock);
 
 /* mkdir.c */
 extern errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index 4dfa983..b2da21a 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -88,6 +88,7 @@ extern int ext2fs_process_dir_block(ext2_filsys  	fs,
 				    int			ref_offset,
 				    void		*priv_data);
 
+extern errcode_t ext2fs_inline_data_init(ext2_filsys fs, ext2_ino_t ino);
 extern errcode_t ext2fs_inline_data_size(ext2_filsys fs, ext2_ino_t ino,
 					 size_t *size);
 extern errcode_t ext2fs_inline_data_expand(ext2_filsys fs, ext2_ino_t ino);
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 4294a5e..3144427 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -77,6 +77,16 @@ err:
 	return retval;
 }
 
+errcode_t ext2fs_inline_data_init(ext2_filsys fs, ext2_ino_t ino)
+{
+	struct ext2_inline_data data;
+
+	data.fs = fs;
+	data.ino = ino;
+	data.ea_size = 0;
+	data.ea_data = "";
+	return ext2fs_inline_data_ea_set(&data);
+}
 
 errcode_t ext2fs_inline_data_size(ext2_filsys fs, ext2_ino_t ino, size_t *size)
 {
diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index 4a85439..06c2c7e 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -41,10 +41,20 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	ext2_ino_t		scratch_ino;
 	blk64_t			blk;
 	char			*block = 0;
+	int			inline_data = 0;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
 	/*
+	 * Create a new dir with inline data iff this feature is enabled
+	 * and ino >= EXT2_FIRST_INO.
+	 */
+	if ((!ino || ino >= EXT2_FIRST_INO(fs->super)) &&
+	    EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				      EXT4_FEATURE_INCOMPAT_INLINE_DATA))
+		inline_data = 1;
+
+	/*
 	 * Allocate an inode, if necessary
 	 */
 	if (!ino) {
@@ -57,14 +67,21 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	/*
 	 * Allocate a data block for the directory
 	 */
-	retval = ext2fs_new_block2(fs, 0, 0, &blk);
-	if (retval)
-		goto cleanup;
+	if (!inline_data) {
+		retval = ext2fs_new_block2(fs, 0, 0, &blk);
+		if (retval)
+			goto cleanup;
+	}
 
 	/*
 	 * Create a scratch template for the directory
 	 */
-	retval = ext2fs_new_dir_block(fs, ino, parent, &block);
+	memset(&inode, 0, sizeof(struct ext2_inode));
+	if (inline_data)
+		retval = ext2fs_new_dir_inline_data(fs, ino, parent,
+						    inode.i_block);
+	else
+		retval = ext2fs_new_dir_block(fs, ino, parent, &block);
 	if (retval)
 		goto cleanup;
 
@@ -81,16 +98,21 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	/*
 	 * Create the inode structure....
 	 */
-	memset(&inode, 0, sizeof(struct ext2_inode));
 	inode.i_mode = LINUX_S_IFDIR | (0777 & ~fs->umask);
 	inode.i_uid = inode.i_gid = 0;
-	ext2fs_iblk_set(fs, &inode, 1);
-	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS)
-		inode.i_flags |= EXT4_EXTENTS_FL;
-	else
-		inode.i_block[0] = blk;
+	if (inline_data) {
+		inode.i_flags |= EXT4_INLINE_DATA_FL;
+		inode.i_size = EXT4_MIN_INLINE_DATA_SIZE;
+	} else {
+		if (fs->super->s_feature_incompat &
+		    EXT3_FEATURE_INCOMPAT_EXTENTS)
+			inode.i_flags |= EXT4_EXTENTS_FL;
+		else
+			inode.i_block[0] = blk;
+		inode.i_size = fs->blocksize;
+		ext2fs_iblk_set(fs, &inode, 1);
+	}
 	inode.i_links_count = 2;
-	inode.i_size = fs->blocksize;
 
 	/*
 	 * Write out the inode and inode data block.  The inode generation
@@ -100,18 +122,24 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	retval = ext2fs_write_new_inode(fs, ino, &inode);
 	if (retval)
 		goto cleanup;
-	retval = ext2fs_write_dir_block4(fs, blk, block, 0, ino);
-	if (retval)
-		goto cleanup;
-
-	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {
-		retval = ext2fs_extent_open2(fs, ino, &inode, &handle);
-		if (retval)
-			goto cleanup;
-		retval = ext2fs_extent_set_bmap(handle, 0, blk, 0);
-		ext2fs_extent_free(handle);
+	if (inline_data) {
+		/* init "system.data" for new dir */
+		retval = ext2fs_inline_data_init(fs, ino);
+	} else {
+		retval = ext2fs_write_dir_block4(fs, blk, block, 0, ino);
 		if (retval)
 			goto cleanup;
+
+		if (fs->super->s_feature_incompat &
+		    EXT3_FEATURE_INCOMPAT_EXTENTS) {
+			retval = ext2fs_extent_open2(fs, ino, &inode, &handle);
+			if (retval)
+				goto cleanup;
+			retval = ext2fs_extent_set_bmap(handle, 0, blk, 0);
+			ext2fs_extent_free(handle);
+			if (retval)
+				goto cleanup;
+		}
 	}
 
 	/*
@@ -136,6 +164,10 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	 * Update parent inode's counts
 	 */
 	if (parent != ino) {
+		/* reload parent inode due to inline data */
+		retval = ext2fs_read_inode(fs, parent, &parent_inode);
+		if (retval)
+			goto cleanup;
 		parent_inode.i_links_count++;
 		retval = ext2fs_write_inode(fs, parent, &parent_inode);
 		if (retval)
@@ -145,7 +177,8 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	/*
 	 * Update accounting....
 	 */
-	ext2fs_block_alloc_stats2(fs, blk, +1);
+	if (!inline_data)
+		ext2fs_block_alloc_stats2(fs, blk, +1);
 	ext2fs_inode_alloc_stats2(fs, ino, +1, 1);
 
 cleanup:
diff --git a/lib/ext2fs/newdir.c b/lib/ext2fs/newdir.c
index d134bdf..5358c74 100644
--- a/lib/ext2fs/newdir.c
+++ b/lib/ext2fs/newdir.c
@@ -89,3 +89,28 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
 	*block = buf;
 	return 0;
 }
+
+/*
+ * Create new directory on inline data
+ */
+errcode_t ext2fs_new_dir_inline_data(ext2_filsys fs, ext2_ino_t dir_ino,
+				     ext2_ino_t parent_ino, __u32 *iblock)
+{
+	struct ext2_dir_entry 	*dir = NULL;
+	errcode_t		retval;
+	char			*buf;
+	int			rec_len;
+	int			filetype = 0;
+
+	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
+
+	iblock[0] = ext2fs_cpu_to_le32(parent_ino);
+
+	dir = (struct ext2_dir_entry *)((char *)iblock +
+					EXT4_INLINE_DATA_DOTDOT_SIZE);
+	dir->inode = 0;
+	rec_len = EXT4_MIN_INLINE_DATA_SIZE - EXT4_INLINE_DATA_DOTDOT_SIZE;
+	retval = ext2fs_set_rec_len(fs, rec_len, dir);
+
+	return retval;
+}
-- 
1.7.9.7

