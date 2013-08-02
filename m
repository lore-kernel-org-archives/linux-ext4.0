From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v1 09/22] libext2fs: handle inline data in read/write function
Date: Fri,  2 Aug 2013 17:49:36 +0800
Message-ID: <1375436989-18948-10-git-send-email-wenqing.lz@taobao.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54176 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758392Ab3HBJur (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Aug 2013 05:50:47 -0400
Received: by mail-pd0-f175.google.com with SMTP id 5so482577pdd.34
        for <linux-ext4@vger.kernel.org>; Fri, 02 Aug 2013 02:50:46 -0700 (PDT)
In-Reply-To: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Ext2fs_read/write_inline_data functions copy inline_data from/to
user's buffer directly.  When we want to write some data to a file
with inline_data, ext2fs_try_to_write_inline_data is called.  In this
function, it firstly check the length of data.  If the data can be
saved in inode, this function will create a new extend attribute to
record information of inline_data, and copy all data into this inode.

The following commands in debugfs can handle inline_data feature after
applying this patch:
	- dump
	- cat
	- rdump
	- write

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/ext2_err.et.in |    3 +
 lib/ext2fs/ext2fs.h       |    7 ++
 lib/ext2fs/fileio.c       |   19 ++++-
 lib/ext2fs/inline_data.c  |  179 ++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 206 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 8a19cab..9252692 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -485,4 +485,7 @@ ec	EXT2_ET_EXT_ATTR_CURRUPTED,
 ec	EXT2_ET_BAD_EXTRA_SIZE,
 	"Bad inode extra isizevalue"
 
+ec	EXT2_ET_INLINE_DATA_NO_SPACE,
+	"No free space in inline data"
+
 	end
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 934dbd0..2804748 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1359,6 +1359,13 @@ extern errcode_t ext2fs_inline_data_iterate(ext2_filsys fs,
 extern errcode_t ext2fs_inline_data_create(ext2_filsys fs,
 					   struct ext2_inode_large *inode,
 					   unsigned int len);
+extern errcode_t ext2fs_read_inline_data(ext2_filsys fs, ext2_ino_t ino,
+					 char *buf);
+extern errcode_t ext2fs_write_inline_data(ext2_filsys fs, ext2_ino_t ino,
+					  char *buf);
+extern errcode_t ext2fs_try_to_write_inline_data(ext2_filsys fs, ext2_ino_t ino,
+						 const void *buf, unsigned int nbytes,
+						 unsigned int *written);
 
 /* inode.c */
 extern void ext2fs_free_inode_cache(struct ext2_inode_cache *icache);
diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 1f7002c..89c8ea6 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -163,7 +163,8 @@ static errcode_t sync_buffer_position(ext2_file_t file)
 
 	b = file->pos / file->fs->blocksize;
 	if (b != file->blockno) {
-		retval = ext2fs_file_flush(file);
+		if (!(file->inode.i_flags & EXT4_INLINE_DATA_FL))
+			retval = ext2fs_file_flush(file);
 		if (retval)
 			return retval;
 		file->flags &= ~EXT2_FILE_BUF_VALID;
@@ -186,6 +187,12 @@ static errcode_t load_buffer(ext2_file_t file, int dontfill)
 	ext2_filsys	fs = file->fs;
 	errcode_t	retval;
 
+	/* We first handle inline_data */
+	if (file->inode.i_flags & EXT4_INLINE_DATA_FL) {
+		retval = ext2fs_read_inline_data(fs, file->ino, file->buf);
+		return retval;
+	}
+
 	if (!(file->flags & EXT2_FILE_BUF_VALID)) {
 		retval = ext2fs_bmap2(fs, file->ino, &file->inode,
 				     BMAP_BUFFER, 0, file->blockno, 0,
@@ -280,6 +287,16 @@ errcode_t ext2fs_file_write(ext2_file_t file, const void *buf,
 	if (!(file->flags & EXT2_FILE_WRITE))
 		return EXT2_ET_FILE_RO;
 
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_INLINE_DATA) {
+		retval = ext2fs_try_to_write_inline_data(fs, file->ino, buf,
+							 nbytes, written);
+		if (!retval)
+			return retval;
+		if (retval != EXT2_ET_INLINE_DATA_NO_SPACE)
+			return retval;
+		retval = 0;
+	}
+
 	while (nbytes > 0) {
 		retval = sync_buffer_position(file);
 		if (retval)
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index c936e28..5ca95ee 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -21,6 +21,8 @@
 
 static void *ext2fs_get_inline_xattr_pos(struct ext2_inode_large *inode,
 					 struct inline_data *data);
+static unsigned int ext2fs_get_max_inline_size(ext2_filsys fs,
+					       struct ext2_inode_large *inode);
 static void ext2fs_inline_data_finish_convert(ext2_filsys fs, ext2_ino_t ino,
 					      char *target, char *buf,
 					      int inline_size);
@@ -316,6 +318,74 @@ out:
 	return retval & BLOCK_ERROR ? ctx->errcode : 0;
 }
 
+errcode_t ext2fs_read_inline_data(ext2_filsys fs, ext2_ino_t ino, char *buf)
+{
+	struct ext2_inode_large *inode;
+	struct inline_data data;
+	errcode_t retval = 0;
+	unsigned int inline_size;
+
+	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
+	if (retval)
+		return retval;
+
+	retval = ext2fs_read_inode_full(fs, ino, (void *)inode,
+					EXT2_INODE_SIZE(fs->super));
+	if (retval)
+		goto err;
+
+	retval = ext2fs_inline_data_find(fs, inode, &data);
+	if (retval)
+		goto err;
+
+	inline_size = data.inline_size;
+
+	memcpy(buf, (void *)inode->i_block, EXT4_MIN_INLINE_DATA_SIZE);
+	if (inline_size > EXT4_MIN_INLINE_DATA_SIZE)
+		memcpy(buf + EXT4_MIN_INLINE_DATA_SIZE,
+		       ext2fs_get_inline_xattr_pos(inode, &data),
+		       inline_size - EXT4_MIN_INLINE_DATA_SIZE);
+
+err:
+	ext2fs_free_mem(&inode);
+	return retval;
+}
+
+errcode_t ext2fs_write_inline_data(ext2_filsys fs, ext2_ino_t ino, char *buf)
+{
+	struct ext2_inode_large *inode;
+	struct inline_data data;
+	errcode_t retval = 0;
+	unsigned int inline_size;
+
+	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
+	if (retval)
+		return retval;
+
+	retval = ext2fs_read_inode_full(fs, ino, (void *)inode,
+					EXT2_INODE_SIZE(fs->super));
+	if (retval)
+		goto err;
+
+	retval = ext2fs_inline_data_find(fs, inode, &data);
+	if (retval)
+		goto err;
+
+	inline_size = data.inline_size;
+
+	memcpy((void *)inode->i_block, buf, EXT4_MIN_INLINE_DATA_SIZE);
+	if (inline_size > EXT4_MIN_INLINE_DATA_SIZE)
+		memcpy(ext2fs_get_inline_xattr_pos(inode, &data),
+		       buf + EXT4_MIN_INLINE_DATA_SIZE,
+		       inline_size - EXT4_MIN_INLINE_DATA_SIZE);
+
+	retval = ext2fs_write_inode_full(fs, ino, (void *)inode,
+					 EXT2_INODE_SIZE(fs->super));
+err:
+	ext2fs_free_mem(&inode);
+	return retval;
+}
+
 errcode_t ext2fs_inline_data_convert(ext2_filsys fs,
 				     ext2_ino_t  ino,
 				     void *priv_data)
@@ -430,6 +500,114 @@ out:
 	return retval;
 }
 
+static unsigned int ext2fs_get_max_inline_size(ext2_filsys fs,
+					       struct ext2_inode_large *inode)
+{
+	struct ext2_ext_attr_entry *entry;
+	struct ext2_ext_attr_ibody_header *header;
+	struct inline_data data;
+	errcode_t retval = 0;
+	size_t freesize, min_offs;
+
+	min_offs = EXT2_INODE_SIZE(fs->super) -
+		   EXT2_GOOD_OLD_INODE_SIZE -
+		   inode->i_extra_isize -
+		   sizeof(struct ext2_ext_attr_ibody_header);
+
+	header = IHDR(inode);
+	entry = IFIRST(header);
+
+	for (; !EXT2_EXT_IS_LAST_ENTRY(entry);
+	     entry = EXT2_EXT_ATTR_NEXT(entry)) {
+		if (!entry->e_value_block && entry->e_value_size) {
+			size_t offs = entry->e_value_offs;
+			if (offs < min_offs)
+				min_offs = offs;
+		}
+	}
+	freesize = min_offs -
+		((char *)entry - (char *)IFIRST(header)) - sizeof(__u32);
+
+	/*
+	 * We try to get inline data offset, but maybe it doesn't be
+	 * created.  So we ignore this error.
+	 */
+	retval = ext2fs_inline_data_find(fs, inode, &data);
+	if (retval && retval != EXT2_ET_BAD_EXT_ATTR_MAGIC)
+		return 0;
+
+	if (data.inline_off) {
+		entry = (struct ext2_ext_attr_entry *)
+			((char *)inode + data.inline_off);
+		freesize += entry->e_value_size;
+		goto out;
+	}
+
+	freesize -= EXT2_EXT_ATTR_LEN(strlen(EXT4_EXT_ATTR_SYSTEM_DATA));
+
+	if (freesize > EXT2_EXT_ATTR_ROUND)
+		freesize = EXT2_EXT_ATTR_SIZE(freesize - EXT2_EXT_ATTR_ROUND);
+	else
+		freesize = 0;
+
+out:
+	return freesize + EXT4_MIN_INLINE_DATA_SIZE;
+}
+
+errcode_t ext2fs_try_to_write_inline_data(ext2_filsys fs, ext2_ino_t ino,
+					  const void *buf, unsigned int nbytes,
+					  unsigned int *written)
+{
+	struct ext2_inode_large *inode;
+	struct inline_data data;
+	errcode_t retval = 0;
+	unsigned int inline_size = 0;
+
+	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
+	if (retval)
+		return retval;
+	retval = ext2fs_read_inode_full(fs, ino, (void *)inode,
+					EXT2_INODE_SIZE(fs->super));
+	if (retval)
+		goto out;
+
+	if (nbytes > ext2fs_get_max_inline_size(fs, inode)) {
+		retval = EXT2_ET_INLINE_DATA_NO_SPACE;
+		goto out;
+	}
+
+	retval = ext2fs_inline_data_create(fs, inode, nbytes);
+	if (retval)
+		goto out;
+
+	retval = ext2fs_inline_data_find(fs, inode, &data);
+	if (retval)
+		goto out;
+
+	inline_size = data.inline_size;
+
+	memcpy((void *)inode->i_block, buf, EXT4_MIN_INLINE_DATA_SIZE);
+	if (inline_size > EXT4_MIN_INLINE_DATA_SIZE)
+		memcpy(ext2fs_get_inline_xattr_pos(inode, &data),
+		       (const char *) buf + EXT4_MIN_INLINE_DATA_SIZE,
+		       inline_size - EXT4_MIN_INLINE_DATA_SIZE);
+
+	inode->i_flags &= ~EXT4_EXTENTS_FL;
+	inode->i_flags |= EXT4_INLINE_DATA_FL;
+
+	retval = ext2fs_write_inode_full(fs, ino, (void *)inode,
+					 EXT2_INODE_SIZE(fs->super));
+
+	if (!retval)
+		*written = nbytes;
+	else
+		*written = 0;
+
+out:
+	ext2fs_free_mem(&inode);
+	return retval;
+}
+
 errcode_t ext2fs_inline_data_create(ext2_filsys fs,
 				    struct ext2_inode_large *inode,
 				    unsigned int len)
@@ -442,7 +620,6 @@ errcode_t ext2fs_inline_data_create(ext2_filsys fs,
 		.name_index = EXT4_EXT_ATTR_INDEX_SYSTEM,
 		.name = EXT4_EXT_ATTR_SYSTEM_DATA,
 	};
-	void *buf;
 	errcode_t retval;
 
 	if (len > EXT4_MIN_INLINE_DATA_SIZE) {
-- 
1.7.9.7

