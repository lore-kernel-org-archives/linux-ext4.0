From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 14/30] debugfs: make expand command support inline data
Date: Fri,  6 Dec 2013 17:58:01 +0800
Message-ID: <1386323897-2354-15-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52655 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757630Ab3LFJz5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:55:57 -0500
Received: by mail-pb0-f42.google.com with SMTP id uo5so788255pbc.15
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:55:56 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This commit defines a ext2fs_inline_data_expand() to expand an inode with
inline data.  In this commit this function only can expand a directory.
But later it will expand a file.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/expanddir.c   |    2 +
 lib/ext2fs/ext2fsP.h     |    1 +
 lib/ext2fs/inline_data.c |  187 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 190 insertions(+)

diff --git a/lib/ext2fs/expanddir.c b/lib/ext2fs/expanddir.c
index 22558d6..baad782 100644
--- a/lib/ext2fs/expanddir.c
+++ b/lib/ext2fs/expanddir.c
@@ -116,6 +116,8 @@ errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir)
 
 	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_APPEND,
 				       0, expand_dir_proc, &es);
+	if (retval == EXT2_ET_INLINE_DATA_CANT_ITERATE)
+		return ext2fs_inline_data_expand(fs, dir);
 
 	if (es.err)
 		return es.err;
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index aae55b9..4dfa983 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -90,6 +90,7 @@ extern int ext2fs_process_dir_block(ext2_filsys  	fs,
 
 extern errcode_t ext2fs_inline_data_size(ext2_filsys fs, ext2_ino_t ino,
 					 size_t *size);
+extern errcode_t ext2fs_inline_data_expand(ext2_filsys fs, ext2_ino_t ino);
 extern errcode_t ext2fs_inline_data_dir_iterate(ext2_filsys fs,
 				      ext2_ino_t ino,
 				      int (*func)(ext2_filsys fs,
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 151a9df..4294a5e 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -227,3 +227,190 @@ out:
 	retval &= ~(BLOCK_ABORT | BLOCK_INLINE_DATA_CHANGED);
 	return retval & BLOCK_ERROR ? ctx->errcode : retval;
 }
+
+static errcode_t ext2fs_inline_data_ea_remove(ext2_filsys fs, ext2_ino_t ino)
+{
+	struct ext2_xattr_handle *handle;
+	errcode_t retval;
+
+	retval = ext2fs_xattrs_open(fs, ino, &handle);
+	if (retval)
+		return retval;
+
+	retval = ext2fs_xattrs_read(handle);
+	if (retval)
+		goto err;
+
+	retval = ext2fs_xattr_remove(handle, "system.data");
+	if (retval)
+		goto err;
+
+	retval = ext2fs_xattrs_write(handle);
+
+err:
+	(void) ext2fs_xattrs_close(&handle);
+	return retval;
+}
+
+static errcode_t ext2fs_inline_data_convert_dir(ext2_filsys fs, ext2_ino_t ino,
+						char *bbuf, char *ibuf, int size)
+{
+	struct ext2_dir_entry *dir, *dir2;
+	struct ext2_dir_entry_tail *t;
+	errcode_t retval;
+	unsigned int offset;
+	int csum_size = 0;
+	int filetype = 0;
+	int rec_len;
+
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		csum_size = sizeof(struct ext2_dir_entry_tail);
+
+	/* Create '.' and '..' */
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				      EXT2_FEATURE_INCOMPAT_FILETYPE))
+		filetype = EXT2_FT_DIR;
+
+	/*
+	 * Set up entry for '.'
+	 */
+	dir = (struct ext2_dir_entry *) bbuf;
+	dir->inode = ino;
+	ext2fs_dirent_set_name_len(dir, 1);
+	ext2fs_dirent_set_file_type(dir, filetype);
+	dir->name[0] = '.';
+	rec_len = (fs->blocksize - csum_size) - EXT2_DIR_REC_LEN(1);
+	dir->rec_len = EXT2_DIR_REC_LEN(1);
+
+	/*
+	 * Set up entry for '..'
+	 */
+	dir = (struct ext2_dir_entry *) (bbuf + dir->rec_len);
+	dir->rec_len = EXT2_DIR_REC_LEN(2);
+	dir->inode = ext2fs_le32_to_cpu(((__u32 *)ibuf)[0]);
+	ext2fs_dirent_set_name_len(dir, 2);
+	ext2fs_dirent_set_file_type(dir, filetype);
+	dir->name[0] = '.';
+	dir->name[1] = '.';
+
+	/*
+	 * Ajust the last rec_len
+	 */
+	offset = EXT2_DIR_REC_LEN(1) + EXT2_DIR_REC_LEN(2);
+	dir = (struct ext2_dir_entry *) (bbuf + offset);
+	memcpy(bbuf + offset, ibuf + EXT4_INLINE_DATA_DOTDOT_SIZE,
+	       size - EXT4_INLINE_DATA_DOTDOT_SIZE);
+	size += EXT2_DIR_REC_LEN(1) + EXT2_DIR_REC_LEN(2) -
+		EXT4_INLINE_DATA_DOTDOT_SIZE;
+
+	do {
+		dir2 = dir;
+		retval = ext2fs_get_rec_len(fs, dir, &rec_len);
+		if (retval)
+			goto err;
+		offset += rec_len;
+		dir = (struct ext2_dir_entry *) (bbuf + offset);
+	} while (offset < size);
+	rec_len += fs->blocksize - csum_size - offset;
+	retval = ext2fs_set_rec_len(fs, rec_len, dir2);
+	if (retval)
+		goto err;
+
+	if (csum_size) {
+		t = EXT2_DIRENT_TAIL(bbuf, fs->blocksize);
+		ext2fs_initialize_dirent_tail(fs, t);
+	}
+
+err:
+	return retval;
+}
+
+errcode_t ext2fs_inline_data_expand(ext2_filsys fs, ext2_ino_t ino)
+{
+	struct ext2_inode inode;
+	struct ext2_inline_data data;
+	errcode_t retval;
+	blk64_t blk;
+	char *inline_buf = 0;
+	char *blk_buf = 0;
+
+	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
+
+	retval = ext2fs_read_inode(fs, ino, &inode);
+	if (retval)
+		return retval;
+
+	if (!(inode.i_flags & EXT4_INLINE_DATA_FL))
+		return EXT2_ET_NO_INLINE_DATA;
+
+	/* Get inline data first */
+	data.fs = fs;
+	data.ino = ino;
+	retval = ext2fs_inline_data_ea_get(&data);
+	if (retval)
+		return retval;
+	retval = ext2fs_get_mem(EXT4_MIN_INLINE_DATA_SIZE + data.ea_size,
+				&inline_buf);
+	if (retval)
+		goto errout;
+
+	memcpy(inline_buf, (void *)inode.i_block, EXT4_MIN_INLINE_DATA_SIZE);
+	if (data.ea_size > 0) {
+		memcpy(inline_buf + EXT4_MIN_INLINE_DATA_SIZE,
+		       data.ea_data, data.ea_size);
+	}
+
+#ifdef WORDS_BIGENDIAN
+	retval = ext2fs_dirent_swab_in2(fs, inline_buf,
+			data.ea_size + EXT4_MIN_INLINE_DATA_SIZE);
+	if (retval)
+		goto errout;
+#endif
+
+	memset((void *)inode.i_block, 0, EXT4_MIN_INLINE_DATA_SIZE);
+	retval = ext2fs_inline_data_ea_remove(fs, ino);
+	if (retval)
+		goto errout;
+
+	retval = ext2fs_get_mem(fs->blocksize, &blk_buf);
+	if (retval)
+		goto errout;
+
+	/* Adjust the rec_len */
+	retval = ext2fs_inline_data_convert_dir(fs, ino, blk_buf, inline_buf,
+						EXT4_MIN_INLINE_DATA_SIZE +
+							data.ea_size);
+	if (retval)
+		goto errout;
+
+	/* Allocate a new block */
+	retval = ext2fs_new_block2(fs, 0, 0, &blk);
+	if (retval)
+		goto errout;
+	retval = ext2fs_write_dir_block4(fs, blk, blk_buf, 0, ino);
+	if (retval)
+		goto errout;
+
+	/* Update inode */
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT3_FEATURE_INCOMPAT_EXTENTS))
+		inode.i_flags |= EXT4_EXTENTS_FL;
+	inode.i_flags &= ~EXT4_INLINE_DATA_FL;
+	ext2fs_iblk_set(fs, &inode, 1);
+	inode.i_size = fs->blocksize;
+	retval = ext2fs_bmap2(fs, ino, &inode, 0, BMAP_SET, 0, 0, &blk);
+	if (retval)
+		goto errout;
+	retval = ext2fs_write_inode(fs, ino, &inode);
+	if (retval)
+		goto errout;
+	ext2fs_block_alloc_stats2(fs, blk, +1);
+
+errout:
+	if (blk_buf)
+		ext2fs_free_mem(&blk_buf);
+	if (inline_buf)
+		ext2fs_free_mem(&inline_buf);
+	ext2fs_free_mem(&data.ea_data);
+	return retval;
+}
-- 
1.7.9.7

