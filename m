From: Tao Ma <tm@tao.ma>
Subject: [PATCH V3 12/21] ext4: Let ext4_readdir handle inline data.
Date: Sun, 18 Dec 2011 22:24:29 +0800
Message-ID: <1324218278-2460-12-git-send-email-tm@tao.ma>
References: <4EEDF6B1.7050206@tao.ma>
 <1324218278-2460-1-git-send-email-tm@tao.ma>
Cc: adilger@dilger.ca, tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1324218278-2460-1-git-send-email-tm@tao.ma>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/dir.c    |   23 ++++------
 fs/ext4/ext4.h   |   12 +++++
 fs/ext4/inline.c |  124 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/xattr.h  |    7 +++
 4 files changed, 153 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 6c2199e..691548c 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -27,10 +27,7 @@
 #include <linux/slab.h>
 #include <linux/rbtree.h>
 #include "ext4.h"
-
-static unsigned char ext4_filetype_table[] = {
-	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
-};
+#include "xattr.h"
 
 static int ext4_readdir(struct file *, void *, filldir_t);
 static int ext4_dx_readdir(struct file *filp,
@@ -51,19 +48,13 @@ const struct file_operations ext4_dir_operations = {
 };
 
 
-static unsigned char get_dtype(struct super_block *sb, int filetype)
-{
-	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FILETYPE) ||
-	    (filetype >= EXT4_FT_MAX))
-		return DT_UNKNOWN;
-
-	return (ext4_filetype_table[filetype]);
-}
-
 /*
  * Return 0 if the directory entry is OK, and 1 if there is a problem
  *
  * Note: this is the opposite of what ext2 and ext3 historically returned...
+ *
+ * bh passed here can be an inode block or a dir data block, depending
+ * on the inode inline data flag.
  */
 int __ext4_check_dir_entry(const char *function, unsigned int line,
 			   struct inode *dir, struct file *filp,
@@ -122,6 +113,12 @@ static int ext4_readdir(struct file *filp,
 
 	sb = inode->i_sb;
 
+	if (ext4_has_inline_data(inode)) {
+		ret = ext4_read_inline_dir(filp, dirent, filldir);
+		if (ret > 0 || ret < 0)
+			return ret;
+	}
+
 	if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb,
 				    EXT4_FEATURE_COMPAT_DIR_INDEX) &&
 	    ((ext4_test_inode_flag(inode, EXT4_INODE_INDEX)) ||
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e61c967..25d6e58 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1832,6 +1832,18 @@ static inline void ext4_update_dx_flag(struct inode *inode)
 				     EXT4_FEATURE_COMPAT_DIR_INDEX))
 		ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);
 }
+static unsigned char ext4_filetype_table[] = {
+	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
+};
+
+static inline  unsigned char get_dtype(struct super_block *sb, int filetype)
+{
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FILETYPE) ||
+	    (filetype >= EXT4_FT_MAX))
+		return DT_UNKNOWN;
+
+	return ext4_filetype_table[filetype];
+}
 
 /* fsync.c */
 extern int ext4_sync_file(struct file *, loff_t, loff_t, int);
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index db70d3e..0a41d64 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1176,6 +1176,130 @@ out:
 }
 
 /*
+ * Get the inline dentry at offset.
+ */
+static inline struct ext4_dir_entry_2 *
+ext4_get_inline_entry(struct inode *inode,
+		      struct ext4_iloc *iloc,
+		      unsigned int offset,
+		      void **inline_start,
+		      int *inline_size)
+{
+	void *inline_pos;
+
+	BUG_ON(offset > ext4_get_inline_size(inode));
+
+	if (offset < EXT4_MIN_INLINE_DATA_SIZE) {
+		inline_pos = ext4_raw_inode(iloc)->i_block;
+		*inline_size = EXT4_MIN_INLINE_DATA_SIZE;
+	} else {
+		inline_pos = ext4_get_inline_xattr_pos(inode, iloc);
+		offset -= EXT4_MIN_INLINE_DATA_SIZE;
+		*inline_size = ext4_get_inline_size(inode) -
+				EXT4_MIN_INLINE_DATA_SIZE;
+	}
+
+	if (inline_start)
+		*inline_start = inline_pos;
+	return (struct ext4_dir_entry_2 *)(inline_pos + offset);
+}
+
+int ext4_read_inline_dir(struct file *filp,
+			 void *dirent, filldir_t filldir)
+{
+	int error = 0;
+	unsigned int offset;
+	int i, stored;
+	void *inline_pos;
+	struct ext4_dir_entry_2 *de;
+	struct super_block *sb;
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	int ret, inline_size = 0;
+	struct ext4_iloc iloc;
+
+	ret = ext4_get_inode_loc(inode, &iloc);
+	if (ret)
+		return ret;
+
+	down_read(&EXT4_I(inode)->xattr_sem);
+	if (!ext4_has_inline_data(inode))
+		goto out;
+
+	sb = inode->i_sb;
+	stored = 0;
+	offset = filp->f_pos & (sb->s_blocksize - 1);
+
+	while (!error && !stored && filp->f_pos < inode->i_size) {
+revalidate:
+		/* If the version has changed since the last call to
+		 * readdir(2), then we might be pointing to an invalid
+		 * dirent right now.  Scan from the start of the block
+		 * to make sure. */
+		if (filp->f_version != inode->i_version) {
+			for (i = 0; i < inode->i_size && i < offset; ) {
+				de = ext4_get_inline_entry(inode, &iloc, i,
+							   NULL, &inline_size);
+				/* It's too expensive to do a full
+				 * dirent test each time round this
+				 * loop, but we do have to test at
+				 * least that it is non-zero.  A
+				 * failure will be detected in the
+				 * dirent test below. */
+				if (ext4_rec_len_from_disk(de->rec_len,
+					inline_size) < EXT4_DIR_REC_LEN(1))
+					break;
+				i += ext4_rec_len_from_disk(de->rec_len,
+							    inline_size);
+			}
+			offset = i;
+			filp->f_pos = offset;
+			filp->f_version = inode->i_version;
+		}
+
+		while (!error && filp->f_pos < inode->i_size) {
+			de = ext4_get_inline_entry(inode, &iloc, offset,
+						   &inline_pos, &inline_size);
+			if (ext4_check_dir_entry(inode, filp, de,
+						 iloc.bh, inline_pos,
+						 inline_size, offset)) {
+				ret = stored;
+				goto out;
+			}
+			offset += ext4_rec_len_from_disk(de->rec_len,
+							 inline_size);
+			if (le32_to_cpu(de->inode)) {
+				/* We might block in the next section
+				 * if the data destination is
+				 * currently swapped out.  So, use a
+				 * version stamp to detect whether or
+				 * not the directory has been modified
+				 * during the copy operation.
+				 */
+				u64 version = filp->f_version;
+
+				error = filldir(dirent, de->name,
+						de->name_len,
+						filp->f_pos,
+						le32_to_cpu(de->inode),
+						get_dtype(sb, de->file_type));
+				if (error)
+					break;
+				if (version != filp->f_version)
+					goto revalidate;
+				stored++;
+			}
+			filp->f_pos += ext4_rec_len_from_disk(de->rec_len,
+							      inline_size);
+		}
+		offset = 0;
+	}
+out:
+	up_read(&EXT4_I(inode)->xattr_sem);
+	brelse(iloc.bh);
+	return ret;
+}
+
+/*
  * Try to create the inline data for the new dir.
  * If it succeeds, return 0, otherwise return the error.
  * In case of ENOSPC, the caller should create the normal disk layout dir.
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 0229a78..e9e23ba 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -166,6 +166,8 @@ extern int ext4_try_add_inline_entry(handle_t *handle, struct dentry *dentry,
 extern int ext4_try_create_inline_dir(handle_t *handle,
 				      struct inode *parent,
 				      struct inode *inode);
+extern int ext4_read_inline_dir(struct file *filp,
+				void *dirent, filldir_t filldir);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -343,6 +345,11 @@ static inline int ext4_try_create_inline_dir(handle_t *handle,
 {
 	return 0;
 }
+static inline int ext4_read_inline_dir(struct file *filp,
+				       void *dirent, filldir_t filldir)
+{
+	return 0;
+}
 # endif  /* CONFIG_EXT4_FS_XATTR */
 
 #ifdef CONFIG_EXT4_FS_SECURITY
-- 
1.7.0.4

