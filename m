From: Tao Ma <tm@tao.ma>
Subject: [PATCH V2 18/19] ext4: let ext4_rename handle inline dir.
Date: Tue, 22 Nov 2011 00:39:56 +0800
Message-ID: <1321893597-11024-18-git-send-email-tm@tao.ma>
References: <4ECA7DB3.9040605@tao.ma>
 <1321893597-11024-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1321893597-11024-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In case of we rename a dir, ext4_rename has to read the dir block
and change its dotdot's information. The old ext4_rename encapsulated
the dir_block read into itself. So this patch try to add a new function
ext4_get_dir_block which get the dir buffer information so the
ext4_rename can handle it properly.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inline.c |   15 +++++++++++++++
 fs/ext4/namei.c  |   38 ++++++++++++++++++++++++++++++++------
 fs/ext4/xattr.h  |   12 ++++++++++++
 3 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 4930e2e..d73585e 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1476,6 +1476,21 @@ out:
 	return ret;
 }
 
+struct buffer_head *ext4_get_first_inline_block(struct inode *inode,
+				void **buf, int *buf_size, int *retval)
+{
+	struct ext4_iloc iloc;
+
+	*retval = ext4_get_inode_loc(inode, &iloc);
+	if (*retval)
+		return NULL;
+
+	*buf = ext4_raw_inode(&iloc)->i_block;
+	*buf_size = EXT4_MIN_INLINE_DATA_SIZE;
+
+	return iloc.bh;
+}
+
 int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
 {
 	int ret;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 24cdb61..cc4db68 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2507,6 +2507,31 @@ retry:
 	(ext4_next_entry((struct ext4_dir_entry_2 *)(buffer), size)->inode)
 
 /*
+ * Try to find buffer head where contains the parent block.
+ * It should be the inode block if it is inlined or the 1st block
+ * if it is a normal dir.
+ */
+static struct buffer_head *ext4_get_first_dir_block(handle_t *handle,
+						    struct inode *inode,
+						    void **buf,
+						    int *buf_size,
+						    int *retval)
+{
+	struct buffer_head *bh;
+
+	if (!ext4_has_inline_data(inode)) {
+		bh = ext4_bread(handle, inode, 0, 0, retval);
+		if (!bh)
+			return NULL;
+		*buf = bh->b_data;
+		*buf_size = inode->i_sb->s_blocksize;
+		return bh;
+	}
+
+	return ext4_get_first_inline_block(inode, buf, buf_size, retval);
+}
+
+/*
  * Anybody can rename anything with this: the permission checks are left to the
  * higher-level routines.
  */
@@ -2517,7 +2542,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct inode *old_inode, *new_inode;
 	struct buffer_head *old_bh, *new_bh, *dir_bh;
 	struct ext4_dir_entry_2 *old_de, *new_de;
-	int retval, force_da_alloc = 0;
+	int buf_size, retval, force_da_alloc = 0;
+	void *dir_buf = NULL;
 
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
@@ -2564,11 +2590,12 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 				goto end_rename;
 		}
 		retval = -EIO;
-		dir_bh = ext4_bread(handle, old_inode, 0, 0, &retval);
+		dir_bh = ext4_get_first_dir_block(handle, old_inode,
+						  &dir_buf, &buf_size, &retval);
 		if (!dir_bh)
 			goto end_rename;
-		if (le32_to_cpu(PARENT_INO(dir_bh->b_data,
-				old_dir->i_sb->s_blocksize)) != old_dir->i_ino)
+		if (le32_to_cpu(PARENT_INO(dir_buf,
+					   buf_size)) != old_dir->i_ino)
 			goto end_rename;
 		retval = -EMLINK;
 		if (!new_inode && new_dir != old_dir &&
@@ -2648,8 +2675,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old_dir->i_ctime = old_dir->i_mtime = ext4_current_time(old_dir);
 	ext4_update_dx_flag(old_dir);
 	if (dir_bh) {
-		PARENT_INO(dir_bh->b_data, new_dir->i_sb->s_blocksize) =
-						cpu_to_le32(new_dir->i_ino);
+		PARENT_INO(dir_buf, buf_size) = cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext4_handle_dirty_metadata");
 		retval = ext4_handle_dirty_metadata(handle, old_inode, dir_bh);
 		if (retval) {
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index d889582..5300206 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -179,6 +179,10 @@ extern int ext4_delete_inline_entry(handle_t *handle,
 				    struct ext4_dir_entry_2 *de_del,
 				    struct buffer_head *bh);
 extern int empty_inline_dir(struct inode *dir, int *has_inline_data);
+extern struct buffer_head *ext4_get_first_inline_block(struct inode *inode,
+						       void **buf,
+						       int *buf_size,
+						       int *retval);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -387,6 +391,14 @@ static inline int empty_inline_dir(struct inode *dir, int *has_inline_data)
 {
 	return 0;
 }
+
+static inline struct buffer_head *
+ext4_get_first_inline_block(struct inode *inode,
+			    void **buf, int *buf_size,
+			    int *retval)
+{
+	return NULL;
+}
 # endif  /* CONFIG_EXT4_FS_XATTR */
 
 #ifdef CONFIG_EXT4_FS_SECURITY
-- 
1.7.0.4
