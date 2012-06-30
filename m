From: Tao Ma <tm@tao.ma>
Subject: [PATCH V5 11/23] ext4: let add_dir_entry handle inline data properly.
Date: Sat, 30 Jun 2012 23:45:12 +0800
Message-ID: <1341071124-4976-11-git-send-email-tm@tao.ma>
References: <1341070917-4889-1-git-send-email-tm@tao.ma>
 <1341071124-4976-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:50100 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754344Ab2F3Pt5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jun 2012 11:49:57 -0400
Received: from [221.217.40.18] (port=40170 helo=localhost.localdomain)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1Skzu0-0006eg-KF
	for linux-ext4@vger.kernel.org; Sat, 30 Jun 2012 09:48:05 -0600
In-Reply-To: <1341071124-4976-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

This patch let add_dir_entry handle the inline data case. So the
dir is initialized as inline dir first and then we can try to add
some files to it, when the inline space can't hold all the entries,
a dir block will be created and the dir entry will be moved to it.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h   |   12 ++
 fs/ext4/inline.c |  350 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/namei.c  |   34 ++++--
 fs/ext4/xattr.h  |   19 +++
 4 files changed, 405 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a7b1c30..6f1291a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1580,6 +1580,11 @@ struct ext4_dir_entry_tail {
 	__le32	det_checksum;		/* crc32c(uuid+inum+dirblock) */
 };
 
+#define EXT4_DIRENT_TAIL(block, blocksize) \
+	((struct ext4_dir_entry_tail *)(((void *)(block)) + \
+					((blocksize) - \
+					 sizeof(struct ext4_dir_entry_tail))))
+
 /*
  * Ext4 directory file types.  Only the low 3 bits are used.  The
  * other bits are reserved for now.
@@ -2387,6 +2392,8 @@ static inline void ext4_mark_super_dirty(struct super_block *sb)
 
 /* dir.c */
 extern const struct file_operations ext4_dir_operations;
+extern void ext4_show_inline_dir(struct inode *dir, struct buffer_head *bh,
+				 void *inline_start, int inline_size);
 
 /* file.c */
 extern const struct inode_operations ext4_file_inode_operations;
@@ -2400,6 +2407,11 @@ extern struct dentry *ext4_get_parent(struct dentry *child);
 extern void ext4_init_dot_dotdot(struct inode *parent, struct inode *inode,
 				 struct ext4_dir_entry_2 *de, int blocksize,
 				 int csum_size);
+extern void initialize_dirent_tail(struct ext4_dir_entry_tail *t,
+				   unsigned int blocksize);
+extern int ext4_handle_dirty_dirent_node(handle_t *handle,
+					 struct inode *inode,
+					 struct buffer_head *bh);
 
 /* symlink.c */
 extern const struct inode_operations ext4_symlink_inode_operations;
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index b0403c3..e02c0c2 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -943,6 +943,356 @@ int ext4_da_write_inline_data_end(struct inode *inode, loff_t pos,
 	return copied;
 }
 
+#ifdef INLINE_DIR_DEBUG
+void ext4_show_inline_dir(struct inode *dir, struct buffer_head *bh,
+			  void *inline_start, int inline_size)
+{
+	int offset;
+	unsigned short de_len;
+	struct ext4_dir_entry_2 *de = inline_start;
+	void *dlimit = inline_start + inline_size;
+
+	trace_printk("inode %lu\n", dir->i_ino);
+	offset = 0;
+	while ((void *)de < dlimit) {
+		de_len = ext4_rec_len_from_disk(de->rec_len, inline_size);
+		trace_printk("de: offset %u reclen %u name %*.s "
+			     "namelen %u ino %u\n",
+			     offset, de_len, de->name_len, de->name,
+			     de->name_len, le32_to_cpu(de->inode));
+		if (ext4_check_dir_entry(dir, NULL, de, bh,
+					 inline_start, inline_size, offset))
+			BUG();
+
+		offset += de_len;
+		de = (struct ext4_dir_entry_2 *) ((char *) de + de_len);
+	}
+}
+#else
+#define ext4_show_inline_dir(dir, bh, inline_start, inline_size)
+#endif
+
+/*
+ * Add a new entry into a inline dir.
+ * It will return -ENOSPC if no space is available, and -EIO
+ * and -EEXIST if directory entry already exists.
+ */
+static int ext4_add_dirent_to_inline(handle_t *handle,
+				     struct dentry *dentry,
+				     struct inode *inode,
+				     struct ext4_iloc *iloc,
+				     void *inline_start, int inline_size)
+{
+	struct inode	*dir = dentry->d_parent->d_inode;
+	const char	*name = dentry->d_name.name;
+	int		namelen = dentry->d_name.len;
+	unsigned short	reclen;
+	int		err;
+	struct ext4_dir_entry_2 *de;
+
+	reclen = EXT4_DIR_REC_LEN(namelen);
+	err = ext4_find_dest_de(dir, inode, iloc->bh,
+				inline_start, inline_size,
+				name, namelen, &de);
+	if (err)
+		return err;
+
+	err = ext4_journal_get_write_access(handle, iloc->bh);
+	if (err)
+		return err;
+	ext4_insert_dentry(inode, de, inline_size, name, namelen);
+
+	ext4_show_inline_dir(dir, iloc->bh, inline_start, inline_size);
+
+	/*
+	 * XXX shouldn't update any times until successful
+	 * completion of syscall, but too many callers depend
+	 * on this.
+	 *
+	 * XXX similarly, too many callers depend on
+	 * ext4_new_inode() setting the times, but error
+	 * recovery deletes the inode, so the worst that can
+	 * happen is that the times are slightly out of date
+	 * and/or different from the directory change time.
+	 */
+	dir->i_mtime = dir->i_ctime = ext4_current_time(dir);
+	ext4_update_dx_flag(dir);
+	dir->i_version++;
+	ext4_mark_inode_dirty(handle, dir);
+	return 1;
+}
+
+void *ext4_get_inline_xattr_pos(struct inode *inode, struct ext4_iloc *iloc)
+{
+	struct ext4_xattr_entry *entry;
+	struct ext4_xattr_ibody_header *header;
+
+	BUG_ON(!EXT4_I(inode)->i_inline_off);
+
+	header = IHDR(inode, ext4_raw_inode(iloc));
+	entry = (struct ext4_xattr_entry *)((void *)ext4_raw_inode(iloc) +
+					    EXT4_I(inode)->i_inline_off);
+
+	return (void *)IFIRST(header) + le16_to_cpu(entry->e_value_offs);
+}
+
+/* Set the final de to cover the whole block. */
+static void ext4_update_final_de(void *de_buf, int old_size, int new_size)
+{
+	struct ext4_dir_entry_2 *de, *prev_de;
+	void *limit;
+	int de_len;
+
+	de = (struct ext4_dir_entry_2 *)de_buf;
+	if (old_size) {
+		limit = de_buf + old_size;
+		do {
+			prev_de = de;
+			de_len = ext4_rec_len_from_disk(de->rec_len, old_size);
+			de_buf += de_len;
+			de = (struct ext4_dir_entry_2 *)de_buf;
+		} while (de_buf < limit);
+
+		prev_de->rec_len = ext4_rec_len_to_disk(de_len + new_size -
+							old_size, new_size);
+	} else {
+		/* this is just created, so create an empty entry. */
+		de->inode = 0;
+		de->rec_len = ext4_rec_len_to_disk(new_size, new_size);
+	}
+}
+
+static int ext4_update_inline_dir(handle_t *handle, struct inode *dir,
+				  struct ext4_iloc *iloc)
+{
+	int ret;
+	int old_size = EXT4_I(dir)->i_inline_size - EXT4_MIN_INLINE_DATA_SIZE;
+	int new_size = get_max_inline_xattr_value_size(dir, iloc);
+
+	if (new_size - old_size <= EXT4_DIR_REC_LEN(1))
+		return -ENOSPC;
+
+	ret = ext4_update_inline_data(handle, dir,
+				      new_size + EXT4_MIN_INLINE_DATA_SIZE);
+	if (ret)
+		return ret;
+
+	ext4_update_final_de(ext4_get_inline_xattr_pos(dir, iloc), old_size,
+			     EXT4_I(dir)->i_inline_size -
+						EXT4_MIN_INLINE_DATA_SIZE);
+	dir->i_size = EXT4_I(dir)->i_disksize = EXT4_I(dir)->i_inline_size;
+	return 0;
+}
+
+static void ext4_restore_inline_data(handle_t *handle, struct inode *inode,
+				     struct ext4_iloc *iloc,
+				     void *buf, int inline_size)
+{
+	ext4_create_inline_data(handle, inode, inline_size);
+	ext4_write_inline_data(inode, iloc, buf, 0, inline_size);
+	ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+}
+
+static int ext4_finish_convert_inline_dir(handle_t *handle,
+					  struct inode *inode,
+					  struct buffer_head *dir_block,
+					  int inline_size)
+{
+	int err, csum_size = 0;
+	struct ext4_dir_entry_tail *t;
+
+	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		csum_size = sizeof(struct ext4_dir_entry_tail);
+
+	inode->i_size = inode->i_sb->s_blocksize;
+	i_size_write(inode, inode->i_sb->s_blocksize);
+	EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
+	ext4_update_final_de(dir_block->b_data, inline_size,
+			     inode->i_sb->s_blocksize - csum_size);
+
+	if (csum_size) {
+		t = EXT4_DIRENT_TAIL(dir_block->b_data,
+				     inode->i_sb->s_blocksize);
+		initialize_dirent_tail(t, inode->i_sb->s_blocksize);
+	}
+	set_buffer_uptodate(dir_block);
+	err = ext4_handle_dirty_dirent_node(handle, inode, dir_block);
+	if (err)
+		goto out;
+	set_buffer_verified(dir_block);
+out:
+	return err;
+}
+
+static int ext4_convert_inline_data_nolock(handle_t *handle,
+					   struct inode *inode,
+					   struct ext4_iloc *iloc)
+{
+	int error;
+	void *buf = NULL;
+	struct buffer_head *data_bh = NULL;
+	struct ext4_map_blocks map;
+	int inline_size;
+
+	inline_size = ext4_get_inline_size(inode);
+	buf = kmalloc(inline_size, GFP_NOFS);
+	if (!buf) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	error = ext4_read_inline_data(inode, buf, inline_size, iloc);
+	if (error < 0)
+		goto out;
+
+	error = ext4_destroy_inline_data_nolock(handle, inode);
+	if (error)
+		goto out;
+
+	map.m_lblk = 0;
+	map.m_len = 1;
+	map.m_flags = 0;
+	error = ext4_map_blocks(handle, inode, &map, EXT4_GET_BLOCKS_CREATE);
+	if (error < 0)
+		goto out_restore;
+	if (!(map.m_flags & EXT4_MAP_MAPPED)) {
+		error = -EIO;
+		goto out_restore;
+	}
+
+	data_bh = sb_getblk(inode->i_sb, map.m_pblk);
+	if (!data_bh) {
+		error = -EIO;
+		goto out_restore;
+	}
+
+	lock_buffer(data_bh);
+	error = ext4_journal_get_create_access(handle, data_bh);
+	if (error) {
+		unlock_buffer(data_bh);
+		error = -EIO;
+		goto out_restore;
+	}
+	memcpy(data_bh->b_data, buf, data_bh->b_size);
+
+	if (S_ISDIR(inode->i_mode))
+		error = ext4_finish_convert_inline_dir(handle, inode,
+						       data_bh, inline_size);
+	else {
+		set_buffer_uptodate(data_bh);
+		error = ext4_handle_dirty_metadata(handle,
+						   inode, data_bh);
+	}
+
+	unlock_buffer(data_bh);
+out_restore:
+	if (error)
+		ext4_restore_inline_data(handle, inode, iloc, buf, inline_size);
+
+out:
+	brelse(data_bh);
+	kfree(buf);
+	return error;
+}
+
+/*
+ * Try to add the new entry to the inline data.
+ * If succeeds, return 0. If not, extended the inline dir and copied data to
+ * the new created block.
+ */
+int ext4_try_add_inline_entry(handle_t *handle, struct dentry *dentry,
+			      struct inode *inode)
+{
+	int ret, inline_size;
+	void *inline_start, *backup_buf = NULL;
+	struct buffer_head *dir_block = NULL;
+	struct ext4_iloc iloc;
+	struct inode *dir = dentry->d_parent->d_inode;
+
+	ret = ext4_get_inode_loc(dir, &iloc);
+	if (ret)
+		return ret;
+
+	down_write(&EXT4_I(dir)->xattr_sem);
+	if (!ext4_has_inline_data(dir))
+		goto out;
+
+	inline_start = ext4_raw_inode(&iloc)->i_block;
+	inline_size = EXT4_MIN_INLINE_DATA_SIZE;
+
+	ret = ext4_add_dirent_to_inline(handle, dentry, inode, &iloc,
+					inline_start, inline_size);
+	if (ret != -ENOSPC)
+		goto out;
+
+	/* check whether it can be inserted to inline xattr space. */
+	inline_size = EXT4_I(dir)->i_inline_size -
+			EXT4_MIN_INLINE_DATA_SIZE;
+	if (!inline_size) {
+		/* Try to use the xattr space.*/
+		ret = ext4_update_inline_dir(handle, dir, &iloc);
+		if (ret && ret != -ENOSPC)
+			goto out;
+
+		inline_size = EXT4_I(dir)->i_inline_size -
+				EXT4_MIN_INLINE_DATA_SIZE;
+	}
+
+	if (inline_size) {
+		inline_start = ext4_get_inline_xattr_pos(dir, &iloc);
+
+		ret = ext4_add_dirent_to_inline(handle, dentry, inode, &iloc,
+						inline_start, inline_size);
+
+		if (ret != -ENOSPC)
+			goto out;
+	}
+
+	/*
+	 * The inline space is filled up, so create a new block for it.
+	 * As the extent tree will be created, we have to save the inline
+	 * dir first.
+	 */
+	ret = ext4_convert_inline_data_nolock(handle, dir, &iloc);
+
+out:
+	kfree(backup_buf);
+	brelse(dir_block);
+	ext4_mark_inode_dirty(handle, dir);
+	up_write(&EXT4_I(dir)->xattr_sem);
+	brelse(iloc.bh);
+	return ret;
+}
+
+/*
+ * Try to create the inline data for the new dir.
+ * If it succeeds, return 0, otherwise return the error.
+ * In case of ENOSPC, the caller should create the normal disk layout dir.
+ */
+int ext4_try_create_inline_dir(handle_t *handle, struct inode *parent,
+			       struct inode *inode)
+{
+	int ret, inline_size = EXT4_MIN_INLINE_DATA_SIZE;
+	struct ext4_iloc iloc;
+	struct ext4_dir_entry_2 *de;
+
+	ret = ext4_get_inode_loc(inode, &iloc);
+	if (ret)
+		return ret;
+
+	ret = ext4_prepare_inline_data(handle, inode, inline_size);
+	if (ret)
+		goto out;
+
+	de = (struct ext4_dir_entry_2 *)ext4_raw_inode(&iloc)->i_block;
+	ext4_init_dot_dotdot(parent, inode, de, inline_size, 0);
+	inode->i_size = EXT4_I(inode)->i_disksize = inline_size;
+out:
+	brelse(iloc.bh);
+	return ret;
+}
+
 int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
 {
 	int ret;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 7bcf0d7..7f7e999 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -189,13 +189,8 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			     struct inode *inode);
 
 /* checksumming functions */
-#define EXT4_DIRENT_TAIL(block, blocksize) \
-	((struct ext4_dir_entry_tail *)(((void *)(block)) + \
-					((blocksize) - \
-					 sizeof(struct ext4_dir_entry_tail))))
-
-static void initialize_dirent_tail(struct ext4_dir_entry_tail *t,
-				   unsigned int blocksize)
+void initialize_dirent_tail(struct ext4_dir_entry_tail *t,
+			    unsigned int blocksize)
 {
 	memset(t, 0, sizeof(struct ext4_dir_entry_tail));
 	t->det_rec_len = ext4_rec_len_to_disk(
@@ -290,9 +285,9 @@ static void ext4_dirent_csum_set(struct inode *inode,
 					   (void *)t - (void *)dirent);
 }
 
-static inline int ext4_handle_dirty_dirent_node(handle_t *handle,
-						struct inode *inode,
-						struct buffer_head *bh)
+int ext4_handle_dirty_dirent_node(handle_t *handle,
+				  struct inode *inode,
+				  struct buffer_head *bh)
 {
 	ext4_dirent_csum_set(inode, (struct ext4_dir_entry *)bh->b_data);
 	return ext4_handle_dirty_metadata(handle, inode, bh);
@@ -1819,6 +1814,17 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 	blocksize = sb->s_blocksize;
 	if (!dentry->d_name.len)
 		return -EINVAL;
+
+	if (ext4_has_inline_data(dir)) {
+		retval = ext4_try_add_inline_entry(handle, dentry, inode);
+		if (retval < 0)
+			return retval;
+		if (retval == 1) {
+			retval = 0;
+			return retval;
+		}
+	}
+
 	if (is_dx(dir)) {
 		retval = ext4_dx_add_entry(handle, dentry, inode);
 		if (!retval || (retval != ERR_BAD_DX_DIR))
@@ -2224,6 +2230,14 @@ static int ext4_init_new_dir(handle_t *handle, struct inode *parent,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
+	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+		err = ext4_try_create_inline_dir(handle, parent, inode);
+		if (err < 0 && err != -ENOSPC)
+			goto out;
+		if (!err)
+			goto out;
+	}
+
 	inode->i_size = EXT4_I(inode)->i_disksize = blocksize;
 	dir_block = ext4_bread(handle, inode, 0, 1, &err);
 	if (!dir_block)
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 24c6289..6fecf7b 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -163,6 +163,11 @@ extern int ext4_da_write_inline_data_begin(struct address_space *mapping,
 extern int ext4_da_write_inline_data_end(struct inode *inode, loff_t pos,
 					 unsigned len, unsigned copied,
 					 struct page *page);
+extern int ext4_try_add_inline_entry(handle_t *handle, struct dentry *dentry,
+				     struct inode *inode);
+extern int ext4_try_create_inline_dir(handle_t *handle,
+				      struct inode *parent,
+				      struct inode *inode);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -326,6 +331,20 @@ static inline int ext4_da_write_inline_data_end(struct inode *inode, loff_t pos,
 {
 	return 0;
 }
+
+static inline int ext4_try_add_inline_entry(handle_t *handle,
+					    struct dentry *dentry,
+					    struct inode *inode)
+{
+	return 0;
+}
+
+static inline int ext4_try_create_inline_dir(handle_t *handle,
+					     struct inode *parent,
+					     struct inode *inode)
+{
+	return 0;
+}
 # endif  /* CONFIG_EXT4_FS_XATTR */
 
 #ifdef CONFIG_EXT4_FS_SECURITY
-- 
1.7.0.4

