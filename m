From: Tao Ma <tm@tao.ma>
Subject: [PATCH V1 10/17] ext4: let add_dir_entry handle inline data properly.
Date: Wed, 26 Oct 2011 15:34:21 +0800
Message-ID: <1319614468-11227-10-git-send-email-tm@tao.ma>
References: <4EA7B788.3040503@tao.ma>
 <1319614468-11227-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1319614468-11227-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

This patch let add_dir_entry handle the inline data case. So the
dir is initialized as inline dir first and then we can try to add
some files to it, when the inline space can't hold all the entries,
a dir block will be created and the dir entry will be moved to it.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h  |    2 +
 fs/ext4/namei.c |  193 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 195 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 585ccca..4319c95 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2178,6 +2178,8 @@ static inline void ext4_mark_super_dirty(struct super_block *sb)
 
 /* dir.c */
 extern const struct file_operations ext4_dir_operations;
+extern void ext4_show_inline_dir(struct inode *dir, struct buffer_head *bh,
+				 void *inline_start, int inline_size);
 
 /* file.c */
 extern const struct inode_operations ext4_file_inode_operations;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2e83b92..4f36137 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -23,6 +23,7 @@
  *  Hash Tree Directory indexing cleanup
  *	Theodore Ts'o, 2002
  */
+#define INLINE_DIR_DEBUG
 
 #include <linux/fs.h>
 #include <linux/pagemap.h>
@@ -1467,6 +1468,147 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	return retval;
 }
 
+void ext4_show_inline_dir(struct inode *dir, struct buffer_head *bh,
+			  void *inline_start, int inline_size)
+{
+	int offset;
+	unsigned short de_len;
+	struct ext4_dir_entry_2 *de = inline_start;
+	void *dlimit = inline_start + inline_size;
+
+	trace_printk("inode %lu %u\n", dir->i_ino, EXT4_I(dir)->i_inline_off);
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
+	err = __ext4_find_dest_de(dir, inode, iloc->bh,
+				  inline_start, inline_size,
+				  name, namelen, &de);
+	if (err)
+		return err;
+
+	err = ext4_journal_get_write_access(handle, iloc->bh);
+	if (err)
+		return err;
+	__ext4_insert_dentry(inode, de, inline_size, name, namelen);
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
+/*
+ * Try to add the new entry to the inline data.
+ * If succeeds, return 0. If not, extended the inline dir and copied data to
+ * the new created block.
+ */
+static int ext4_try_add_inline_entry(handle_t *handle, struct dentry *dentry,
+				     struct inode *inode)
+{
+	int ret, inline_size, de_len;
+	void *inline_start, *limit, *de_buf;
+	struct buffer_head *dir_block;
+	struct ext4_dir_entry_2 *de, *prev_de;
+	struct ext4_iloc iloc;
+	int blocksize = inode->i_sb->s_blocksize;
+	struct inode *dir = dentry->d_parent->d_inode;
+
+	ret = ext4_get_inode_loc(dir, &iloc);
+	if (ret)
+		return ret;
+
+	inline_start = ext4_get_inline_data_pos(dir, &iloc);
+	inline_size = ext4_get_max_inline_size(dir);
+
+	ret = ext4_add_dirent_to_inline(handle, dentry, inode, &iloc,
+					inline_start, inline_size);
+	if (ret != -ENOSPC)
+		goto out;
+
+	/* The inline space is filled up, so create a new block for it. */
+	dir->i_size = EXT4_I(dir)->i_disksize = blocksize;
+	dir_block = ext4_bread(handle, dir, 0, 1, &ret);
+	if (!dir_block)
+		goto out;
+
+	BUFFER_TRACE(dir_block, "get_write_access");
+	ret = ext4_journal_get_write_access(handle, dir_block);
+	if (ret)
+		goto out;
+	memcpy(dir_block->b_data, inline_start, inline_size);
+
+	/* Set the final de to cover the whole block. */
+	de_buf = dir_block->b_data;
+	de = (struct ext4_dir_entry_2 *)de_buf;
+	limit = de_buf + inline_size;
+	do {
+		prev_de = de;
+		de_len = ext4_rec_len_from_disk(de->rec_len, inline_size);
+		de_buf += de_len;
+		de = (struct ext4_dir_entry_2 *)de_buf;
+	} while (de_buf < limit);
+
+	prev_de->rec_len = ext4_rec_len_to_disk(de_len + blocksize -
+						inline_size, blocksize);
+
+	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
+	ret = ext4_handle_dirty_metadata(handle, dir, dir_block);
+
+	/* clear the entry and the flag in inode now. */
+	ret = ext4_destroy_inline_data(handle, dir);
+out:
+	brelse(dir_block);
+	ext4_mark_inode_dirty(handle, dir);
+	brelse(iloc.bh);
+	return ret;
+}
+
 /*
  *	ext4_add_entry()
  *
@@ -1493,6 +1635,17 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
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
@@ -1862,6 +2015,38 @@ static void ext4_init_dot_dotdot(struct inode *parent, struct inode *inode,
 	inode->i_nlink = 2;
 }
 
+/*
+ * Try to create the inline data for the new dir.
+ * If it succeeds, return 0, otherwise return the error.
+ * In case of ENOSPC, the caller should create the normal disk layout dir.
+ */
+static int ext4_try_create_inline_dir(handle_t *handle, struct inode *parent,
+				      struct inode *inode)
+{
+	int ret, inline_size;
+	struct ext4_iloc iloc;
+	void *inline_pos;
+	struct ext4_dir_entry_2 *de;
+
+	ret = ext4_get_inode_loc(inode, &iloc);
+	if (ret)
+		return ret;
+
+	ret = ext4_init_inline_data(handle, inode, &iloc);
+	if (ret)
+		goto out;
+
+	inline_pos = ext4_get_inline_data_pos(inode, &iloc);
+	inline_size = ext4_get_max_inline_size(inode);
+
+	de = (struct ext4_dir_entry_2 *)inline_pos;
+	ext4_init_dot_dotdot(parent, inode, de, inline_size);
+	inode->i_size = EXT4_I(inode)->i_disksize = inline_size;
+out:
+	brelse(iloc.bh);
+	return ret;
+}
+
 static int ext4_init_new_dir(handle_t *handle, struct inode *parent,
 			     struct inode *inode)
 {
@@ -1870,6 +2055,14 @@ static int ext4_init_new_dir(handle_t *handle, struct inode *parent,
 	int err;
 	int blocksize = inode->i_sb->s_blocksize;
 
+	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+		err = ext4_try_create_inline_dir(handle, parent, inode);
+		if (err < 0 && err != ENOSPC)
+			goto out;
+		if (!err)
+			goto out;
+	}
+
 	inode->i_size = EXT4_I(inode)->i_disksize = blocksize;
 	dir_block = ext4_bread(handle, inode, 0, 1, &err);
 	if (!dir_block)
-- 
1.7.0.4
