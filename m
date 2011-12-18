From: Tao Ma <tm@tao.ma>
Subject: [PATCH V3 18/21] ext4: let ext4_rename handle inline dir.
Date: Sun, 18 Dec 2011 22:24:35 +0800
Message-ID: <1324218278-2460-18-git-send-email-tm@tao.ma>
References: <4EEDF6B1.7050206@tao.ma>
 <1324218278-2460-1-git-send-email-tm@tao.ma>
Cc: adilger@dilger.ca, tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:39464 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751933Ab1LROgk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Dec 2011 09:36:40 -0500
In-Reply-To: <1324218278-2460-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
index 1872532..3159f32 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1327,6 +1327,21 @@ out:
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
 struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 					const struct qstr *d_name,
 					struct ext4_dir_entry_2 **res_dir,
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
index ed707df..55bb2fc 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -177,6 +177,10 @@ extern int ext4_delete_inline_entry(handle_t *handle,
 				    struct ext4_dir_entry_2 *de_del,
 				    struct buffer_head *bh);
 extern int empty_inline_dir(struct inode *dir, int *has_inline_data);
+extern struct buffer_head *ext4_get_first_inline_block(struct inode *inode,
+						       void **buf,
+						       int *buf_size,
+						       int *retval);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -379,6 +383,14 @@ static inline int empty_inline_dir(struct inode *dir, int *has_inline_data)
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

