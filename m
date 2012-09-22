From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 07/21 v5] libext2fs: handle inline data when expanding directory
Date: Sat, 22 Sep 2012 12:00:55 +0800
Message-ID: <1348286469-31690-8-git-send-email-wenqing.lz@taobao.com>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45536 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab2IVDvM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 23:51:12 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3873803pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 20:51:11 -0700 (PDT)
In-Reply-To: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

When inline space is filled up, we need to allocate a new block for this inode.
So a new function called `ext2fs_convert_inline_data' is define to handle it.
`expand_dir_struct' is exported to libext2fs because we need to change its
status.  After adding it, the following commands in debugfs can handle
inline_data feature:
	- mkdir
	- expand_dir

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/expanddir.c   |   18 ++-
 lib/ext2fs/ext2fs.h      |    4 +
 lib/ext2fs/ext2fsP.h     |   11 ++
 lib/ext2fs/ext_attr.c    |    6 +-
 lib/ext2fs/inline_data.c |  337 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/mkdir.c       |   18 +++-
 6 files changed, 383 insertions(+), 11 deletions(-)

diff --git a/lib/ext2fs/expanddir.c b/lib/ext2fs/expanddir.c
index 22558d6..b5e790b 100644
--- a/lib/ext2fs/expanddir.c
+++ b/lib/ext2fs/expanddir.c
@@ -19,13 +19,7 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
-struct expand_dir_struct {
-	int		done;
-	int		newblocks;
-	blk64_t		goal;
-	errcode_t	err;
-	ext2_ino_t	dir;
-};
+#include "ext2fsP.h"
 
 static int expand_dir_proc(ext2_filsys	fs,
 			   blk64_t	*blocknr,
@@ -114,6 +108,16 @@ errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir)
 	es.newblocks = 0;
 	es.dir = dir;
 
+	if (ext2fs_inode_has_inline_data(fs, dir)) {
+		retval = ext2fs_convert_inline_data(fs, dir, &es);
+		if (retval)
+			return retval;
+		if (!es.done)
+			return EXT2_ET_EXPAND_DIR_ERR;
+
+		return 0;
+	}
+
 	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_APPEND,
 				       0, expand_dir_proc, &es);
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 6c2393e..91da02c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1347,6 +1347,10 @@ extern int ext2fs_inline_data_iterate(ext2_filsys fs,
 						  struct ext2_inode_large *inode,
 						  void *priv_data),
 				      void *priv_data);
+extern errcode_t ext2fs_inline_data_mkdir(ext2_filsys fs, ext2_ino_t parent,
+					  ext2_ino_t ino, const char *name);
+extern errcode_t ext2fs_convert_inline_data(ext2_filsys fs, ext2_ino_t ino,
+					    void *priv_data);
 
 /* inode.c */
 extern errcode_t ext2fs_flush_icache(ext2_filsys fs);
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index 742ddf6..503ebbf 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -62,6 +62,17 @@ struct dir_context {
 };
 
 /*
+ * For expanding directory
+ */
+struct expand_dir_struct {
+	int		done;
+	int		newblocks;
+	blk64_t		goal;
+	errcode_t	err;
+	ext2_ino_t	dir;
+};
+
+/*
  * Inode cache structure
  */
 struct ext2_inode_cache {
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index c663f31..5a8d1ca 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -267,7 +267,8 @@ errcode_t ext2fs_set_entry_ext_attr(struct ext2_ext_attr_info *i,
 				    struct ext2_ext_attr_search *s)
 {
 	struct ext2_ext_attr_entry *last;
-	size_t free, min_offs = s->end - s->base, name_len = strlen(i->name);
+	size_t free, min_offs = s->end - s->base;
+	size_t name_len = strlen(i->name);
 
 	last = s->first;
 	for (; !EXT2_EXT_IS_LAST_ENTRY(last); last = EXT2_EXT_ATTR_NEXT(last)) {
@@ -298,8 +299,7 @@ errcode_t ext2fs_set_entry_ext_attr(struct ext2_ext_attr_info *i,
 		memset(s->here, 0, size);
 		s->here->e_name_index = i->name_index;
 		s->here->e_name_len = name_len;
-		memcpy(EXT2_EXT_ATTR_NAME(s->here),
-		       EXT2_EXT_ATTR_NAME(i), name_len);
+		memcpy(EXT2_EXT_ATTR_NAME(s->here), i->name, name_len);
 	} else {
 		if (!s->here->e_value_block && s->here->e_value_size) {
 			void *first_val = s->base + min_offs;
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 3bfe49d..85cfeac 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -24,6 +24,17 @@ static int ext2fs_iget_extra_inode(ext2_filsys fs, struct ext2_inode_large *inod
 				    struct inline_data *data);
 static void *ext2fs_get_inline_xattr_pos(struct ext2_inode_large *inode,
 					 struct inline_data *data);
+static void ext2fs_inline_data_finish_convert(ext2_filsys fs, ext2_ino_t ino,
+					      char *target, void *buf,
+					      int inline_size);
+static void ext2fs_update_final_de(ext2_filsys fs, void *de_buf,
+				   int old_size, int new_size);
+static errcode_t ext2fs_inline_data_destory_data(ext2_filsys fs, ext2_ino_t ino,
+					   struct ext2_inode_large *inode,
+					   struct inline_data *data);
+static errcode_t ext2fs_create_inline_data(ext2_filsys fs,
+					   struct ext2_inode_large *inode,
+					   int len);
 
 static int ext2fs_iget_extra_inode(ext2_filsys fs, struct ext2_inode_large *inode,
 				    struct inline_data *data)
@@ -67,6 +78,46 @@ static void *ext2fs_get_inline_xattr_pos(struct ext2_inode_large *inode,
 	return (void *)IFIRST(header) + entry->e_value_offs;
 }
 
+static errcode_t ext2fs_inline_data_destory_data(ext2_filsys fs, ext2_ino_t ino,
+						 struct ext2_inode_large *inode,
+						 struct inline_data *data)
+{
+	struct ext2_ext_attr_ibody_header *header;
+	struct ext2_ext_attr_search s = {
+		.not_found = -1,
+	};
+	struct ext2_ext_attr_info i = {
+		.name_index = EXT4_EXT_ATTR_INDEX_SYSTEM,
+		.name = EXT4_EXT_ATTR_SYSTEM_DATA,
+		.value = "",
+		.value_len = 0,
+	};
+	errcode_t retval;
+
+	if (!data->inline_off)
+		return 0;
+
+	if (inode->i_extra_isize > (EXT2_INODE_SIZE(fs->super) -
+				    EXT2_GOOD_OLD_INODE_SIZE))
+		return EXT2_ET_BAD_EXTRA_SIZE;
+
+	header = IHDR(inode);
+	if (header->h_magic != EXT2_EXT_ATTR_MAGIC)
+		return EXT2_ET_BAD_EXT_ATTR_MAGIC;
+
+	(void)ext2fs_ibody_find_ext_attr(fs, inode, &i, &s);
+
+	if (!s.not_found) {
+		retval = ext2fs_set_entry_ext_attr(&i, &s);
+		if (retval)
+			return retval;
+	}
+
+	memset((void *)inode->i_block, 0, EXT4_MIN_INLINE_DATA_SIZE);
+
+	return 0;
+}
+
 int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino)
 {
 	struct ext2_inode inode;
@@ -109,6 +160,83 @@ out:
 	return inline_size;
 }
 
+static void ext2fs_update_final_de(ext2_filsys fs, void *de_buf,
+				   int old_size, int new_size)
+{
+	struct ext2_dir_entry *de, *prev_de;
+	void *limit;
+	int de_len;
+
+	de = (struct ext2_dir_entry *)de_buf;
+	if (old_size) {
+		limit = de_buf + old_size;
+		do {
+			prev_de = de;
+			ext2fs_get_rec_len(fs, de, &de_len);
+			de_buf += de_len;
+			de = (struct ext2_dir_entry *)de_buf;
+		} while (de_buf < limit);
+
+		ext2fs_set_rec_len(fs, de_len + new_size - old_size,
+				   prev_de);
+	} else {
+		de->inode = 0;
+		ext2fs_set_rec_len(fs, new_size, de);
+	}
+}
+
+static void ext2fs_inline_data_finish_convert(ext2_filsys fs, ext2_ino_t ino,
+					      char *target, void *buf,
+					      int inline_size)
+{
+	struct ext2_dir_entry *de;
+	struct ext2_dir_entry_tail *t;
+	int header_size = 0;
+	int csum_size = 0;
+	int filetype = 0;
+
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		csum_size = sizeof(struct ext2_dir_entry_tail);
+
+	/* First create '.' and '..' */
+	if (fs->super->s_feature_incompat &
+	    EXT2_FEATURE_INCOMPAT_FILETYPE)
+		filetype = EXT2_FT_DIR << 8;
+
+	de = (struct ext2_dir_entry *)target;
+	de->inode = ino;
+	de->name_len = 1 | filetype;
+	de->name[0] = '.';
+	de->name[1] = '\0';
+	de->rec_len = EXT2_DIR_REC_LEN(1);
+
+	de = (struct ext2_dir_entry *)(target + de->rec_len);
+	de->rec_len = EXT2_DIR_REC_LEN(2);
+	de->inode = ((struct ext2_dir_entry *)buf)->inode;
+	de->name_len = 2 | filetype;
+	de->name[0] = '.';
+	de->name[1] = '.';
+	de->name[2] = '\0';
+
+	de = (struct ext2_dir_entry *)(target +
+				       EXT2_DIR_REC_LEN(1) +
+				       EXT2_DIR_REC_LEN(2));
+	header_size = (void *)de - (void *)target;
+
+	memcpy((void *)de, buf + EXT4_INLINE_DATA_DOTDOT_SIZE,
+		inline_size - EXT4_INLINE_DATA_DOTDOT_SIZE);
+
+	ext2fs_update_final_de(fs, target,
+		inline_size - EXT4_INLINE_DATA_DOTDOT_SIZE + header_size,
+		fs->blocksize - csum_size);
+
+	if (csum_size) {
+		t = EXT2_DIRENT_TAIL(target, fs->blocksize);
+		ext2fs_initialize_dirent_tail(fs, t);
+	}
+}
+
 int ext2fs_inline_data_iterate(ext2_filsys fs,
 			       ext2_ino_t ino,
 			       int flags,
@@ -190,3 +318,212 @@ out:
 	ext2fs_free_mem(&inode);
 	return retval & BLOCK_ERROR ? ctx->errcode : 0;
 }
+
+errcode_t ext2fs_convert_inline_data(ext2_filsys fs,
+				     ext2_ino_t  ino,
+				     void *priv_data)
+{
+	struct expand_dir_struct *es;
+	struct ext2_inode_large *inode;
+	struct inline_data data;
+	ext2_extent_handle_t handle;
+	errcode_t retval;
+	blk64_t blk;
+	void *inline_start;
+	char *backup_buf;
+	char *blk_buf;
+	int inline_size;
+	int i, limit, r;
+
+	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
+
+	es = (struct expand_dir_struct *)priv_data;
+	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
+	if (retval)
+		return retval;
+
+	retval = ext2fs_read_inode_full(fs, ino, (void *)inode,
+					EXT2_INODE_SIZE(fs->super));
+	if (retval)
+		goto out;
+
+	retval = ext2fs_iget_extra_inode(fs, inode, &data);
+	if (retval)
+		goto out;
+
+	inline_size = data.inline_size;
+	retval = ext2fs_get_mem(inline_size, &backup_buf);
+	if (retval)
+		goto out;
+
+	memcpy(backup_buf, (void *)inode->i_block, EXT4_MIN_INLINE_DATA_SIZE);
+	if (inline_size > EXT4_MIN_INLINE_DATA_SIZE)
+		memcpy(backup_buf + EXT4_MIN_INLINE_DATA_SIZE,
+		       ext2fs_get_inline_xattr_pos(inode, &data),
+		       inline_size - EXT4_MIN_INLINE_DATA_SIZE);
+
+	/* clear the entry and the flag in dir now */
+	retval = ext2fs_inline_data_destory_data(fs, ino, inode, &data);
+	if (retval)
+		goto out1;
+
+	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {
+		if (LINUX_S_ISDIR(inode->i_mode) ||
+		    LINUX_S_ISREG(inode->i_mode) ||
+		    LINUX_S_ISLNK(inode->i_mode))
+			inode->i_flags |= EXT4_EXTENTS_FL;
+	}
+
+	inode->i_flags &= ~EXT4_INLINE_DATA_FL;
+
+	retval = ext2fs_new_block2(fs, 0, 0, &blk);
+	if (retval)
+		goto out1;
+
+	ext2fs_iblk_set(fs, (void*)inode, 1);
+	if (!(fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS))
+		inode->i_block[0] = blk;
+	inode->i_size = fs->blocksize;
+
+	retval = ext2fs_get_mem(fs->blocksize, &blk_buf);
+	if (retval)
+		goto out1;
+
+	memset(blk_buf, 0, sizeof(fs->blocksize));
+	if (LINUX_S_ISDIR(inode->i_mode)) {
+		/* set the final dir entry to cover the whole block */
+		ext2fs_inline_data_finish_convert(fs, ino, blk_buf, backup_buf,
+						  inline_size);
+	} else {
+		memcpy(blk_buf, backup_buf, inline_size);
+	}
+
+	retval = ext2fs_write_dir_block4(fs, blk, blk_buf, 0, ino);
+	if (retval)
+		goto out2;
+	retval = ext2fs_write_inode_full(fs, ino, (void *)inode,
+					 EXT2_INODE_SIZE(fs->super));
+	if (retval)
+		goto out2;
+
+	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {
+		retval = ext2fs_extent_open2(fs, ino, (void *)inode, &handle);
+		if (retval)
+			goto out2;
+		retval = ext2fs_extent_set_bmap(handle, 0, blk, 0);
+		ext2fs_extent_free(handle);
+		if (retval)
+			goto out2;
+	}
+
+	ext2fs_block_alloc_stats2(fs, blk, +1);
+
+out2:
+	ext2fs_free_mem(&blk_buf);
+out1:
+	ext2fs_free_mem(&backup_buf);
+out:
+	ext2fs_free_mem(&inode);
+
+	if (retval) {
+		es->err = retval;
+	} else {
+		es->done = 1;
+		es->newblocks++;
+		es->goal = blk;
+	}
+	return retval;
+}
+
+static errcode_t ext2fs_create_inline_data(ext2_filsys fs,
+					   struct ext2_inode_large *inode,
+					   int len)
+{
+	struct ext2_ext_attr_ibody_header *header;
+	struct ext2_ext_attr_search s = {
+		.not_found = -1,
+	};
+	struct ext2_ext_attr_info i = {
+		.name_index = EXT4_EXT_ATTR_INDEX_SYSTEM,
+		.name = EXT4_EXT_ATTR_SYSTEM_DATA,
+	};
+	void *buf;
+	errcode_t ret;
+
+	if (len > EXT4_MIN_INLINE_DATA_SIZE) {
+		i.value_len = len - EXT4_MIN_INLINE_DATA_SIZE;
+		ret = ext2fs_get_mem(i.value_len, &buf);
+		if (ret)
+			return ret;
+		memset(buf, 0, i.value_len);
+		i.value = buf;
+	} else {
+		i.value = "";
+		i.value_len = 0;
+	}
+
+	(void) ext2fs_ibody_find_ext_attr(fs, inode, &i, &s);
+	ret = ext2fs_set_entry_ext_attr(&i, &s);
+	if (ret)
+		return -1;
+
+	header = IHDR(inode);
+	if (!EXT2_EXT_IS_LAST_ENTRY(s.first))
+		header->h_magic = ext2fs_cpu_to_le32(EXT2_EXT_ATTR_MAGIC);
+	else
+		header->h_magic = ext2fs_cpu_to_le32(0);
+
+	return 0;
+}
+
+errcode_t ext2fs_inline_data_mkdir(ext2_filsys fs, ext2_ino_t parent,
+				   ext2_ino_t ino, const char *name)
+{
+	struct ext2_inode_large *inode;
+	struct ext2_dir_entry *de;
+	errcode_t retval = 0;
+	char *buf;
+	int inline_size = EXT4_MIN_INLINE_DATA_SIZE;
+	__u32 t = fs->now ? fs->now : time(NULL);
+
+	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
+	if (retval)
+		return retval;
+	memset(inode, 0, EXT2_INODE_SIZE(fs->super));
+
+	inode->i_extra_isize = sizeof(struct ext2_inode_large) -
+		EXT2_GOOD_OLD_INODE_SIZE;
+	/* prepare inline data*/
+	retval = ext2fs_create_inline_data(fs, inode, inline_size);
+	if (retval)
+		goto out;
+
+	de = (struct ext2_dir_entry *)inode->i_block;
+	de->inode = parent;
+
+	de = (struct ext2_dir_entry *)((void *)de + EXT4_INLINE_DATA_DOTDOT_SIZE);
+	de->inode = 0;
+	de->rec_len = inline_size - EXT4_INLINE_DATA_DOTDOT_SIZE;
+
+	inode->i_mode = LINUX_S_IFDIR | (0777 & ~fs->umask);
+	inode->i_uid = inode->i_gid = 0;
+	inode->i_links_count = 2;
+	inode->i_size = inline_size;
+	inode->i_flags &= ~EXT4_EXTENTS_FL;
+	inode->i_flags |= EXT4_INLINE_DATA_FL;
+	if (!inode->i_ctime)
+		inode->i_ctime = t;
+	if (!inode->i_mtime)
+		inode->i_mtime = t;
+	if (!inode->i_atime)
+		inode->i_atime = t;
+	if (!inode->i_crtime)
+		inode->i_crtime = t;
+
+	retval = ext2fs_write_inode_full(fs, ino, (void *)inode,
+					 EXT2_INODE_SIZE(fs->super));
+
+out:
+	ext2fs_free_mem(&inode);
+	return retval;
+}
diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index 4a85439..3bbe808 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -41,6 +41,7 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	ext2_ino_t		scratch_ino;
 	blk64_t			blk;
 	char			*block = 0;
+	int			inline_data = 0;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -54,6 +55,15 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 			goto cleanup;
 	}
 
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_INLINE_DATA &&
+	    ino > EXT2_FIRST_INO(fs->super) && strcmp("lost+found", name) != 0) {
+		retval = ext2fs_inline_data_mkdir(fs, parent, ino, name);
+		if (retval)
+			goto cleanup;
+		inline_data = 1;
+		goto make_link;
+	}
+
 	/*
 	 * Allocate a data block for the directory
 	 */
@@ -114,6 +124,7 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 			goto cleanup;
 	}
 
+make_link:
 	/*
 	 * Link the directory into the filesystem hierarchy
 	 */
@@ -136,6 +147,10 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	 * Update parent inode's counts
 	 */
 	if (parent != ino) {
+		/* Reload parent inode due to inline data */
+		retval = ext2fs_read_inode(fs, parent, &parent_inode);
+		if (retval)
+			goto cleanup;
 		parent_inode.i_links_count++;
 		retval = ext2fs_write_inode(fs, parent, &parent_inode);
 		if (retval)
@@ -145,7 +160,8 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	/*
 	 * Update accounting....
 	 */
-	ext2fs_block_alloc_stats2(fs, blk, +1);
+	if (!inline_data)
+		ext2fs_block_alloc_stats2(fs, blk, +1);
 	ext2fs_inode_alloc_stats2(fs, ino, +1, 1);
 
 cleanup:
-- 
1.7.4.1

