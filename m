From: Tao Ma <tm@tao.ma>
Subject: [PATCH V5 18/23] ext4: let ext4_rename handle inline dir.
Date: Sat, 30 Jun 2012 23:45:19 +0800
Message-ID: <1341071124-4976-18-git-send-email-tm@tao.ma>
References: <1341070917-4889-1-git-send-email-tm@tao.ma>
 <1341071124-4976-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:37299 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755427Ab2F3Pt5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jun 2012 11:49:57 -0400
Received: from [221.217.40.18] (port=40170 helo=localhost.localdomain)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1SkzuH-0006eg-MD
	for linux-ext4@vger.kernel.org; Sat, 30 Jun 2012 09:48:23 -0600
In-Reply-To: <1341071124-4976-1-git-send-email-tm@tao.ma>
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
 fs/ext4/inline.c |   15 ++++++++
 fs/ext4/namei.c  |   95 ++++++++++++++++++++++++++++++++++++++---------------
 fs/ext4/xattr.h  |   12 +++++++
 3 files changed, 95 insertions(+), 27 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 025a9f3..bc30e21 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1403,6 +1403,21 @@ out:
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
 /*
  * Try to create the inline data for the new dir.
  * If it succeeds, return 0, otherwise return the error.
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 93dee3a..e3b5e08 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1126,7 +1126,8 @@ static inline int search_dirblock(struct buffer_head *bh,
  */
 static struct buffer_head * ext4_find_entry (struct inode *dir,
 					const struct qstr *d_name,
-					struct ext4_dir_entry_2 ** res_dir)
+					struct ext4_dir_entry_2 **res_dir,
+					int *inlined)
 {
 	struct super_block *sb;
 	struct buffer_head *bh_use[NAMEI_RA_SIZE];
@@ -1152,8 +1153,11 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 		int has_inline_data = 1;
 		ret = ext4_find_inline_entry(dir, d_name, res_dir,
 					     &has_inline_data);
-		if (has_inline_data)
+		if (has_inline_data) {
+			if (inlined)
+				*inlined = 1;
 			return ret;
+		}
 	}
 
 	if ((namelen <= 2) && (name[0] == '.') &&
@@ -1331,7 +1335,7 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, stru
 	if (dentry->d_name.len > EXT4_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	bh = ext4_find_entry(dir, &dentry->d_name, &de);
+	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
 	inode = NULL;
 	if (bh) {
 		__u32 ino = le32_to_cpu(de->inode);
@@ -1365,7 +1369,7 @@ struct dentry *ext4_get_parent(struct dentry *child)
 	struct ext4_dir_entry_2 * de;
 	struct buffer_head *bh;
 
-	bh = ext4_find_entry(child->d_inode, &dotdot, &de);
+	bh = ext4_find_entry(child->d_inode, &dotdot, &de, NULL);
 	if (!bh)
 		return ERR_PTR(-ENOENT);
 	ino = le32_to_cpu(de->inode);
@@ -2637,7 +2641,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 		return PTR_ERR(handle);
 
 	retval = -ENOENT;
-	bh = ext4_find_entry(dir, &dentry->d_name, &de);
+	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
 	if (!bh)
 		goto end_rmdir;
 
@@ -2702,7 +2706,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 		ext4_handle_sync(handle);
 
 	retval = -ENOENT;
-	bh = ext4_find_entry(dir, &dentry->d_name, &de);
+	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
 	if (!bh)
 		goto end_unlink;
 
@@ -2888,6 +2892,33 @@ retry:
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
+						    int *retval,
+						    int *inlined)
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
+	*inlined = 1;
+	return ext4_get_first_inline_block(inode, buf, buf_size, retval);
+}
+
+/*
  * Anybody can rename anything with this: the permission checks are left to the
  * higher-level routines.
  */
@@ -2898,7 +2929,9 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct inode *old_inode, *new_inode;
 	struct buffer_head *old_bh, *new_bh, *dir_bh;
 	struct ext4_dir_entry_2 *old_de, *new_de;
-	int retval, force_da_alloc = 0;
+	int buf_size, retval, force_da_alloc = 0;
+	int inlined = 0, new_inlined = 0;
+	void *dir_buf = NULL;
 
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
@@ -2918,7 +2951,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir))
 		ext4_handle_sync(handle);
 
-	old_bh = ext4_find_entry(old_dir, &old_dentry->d_name, &old_de);
+	old_bh = ext4_find_entry(old_dir, &old_dentry->d_name, &old_de, NULL);
 	/*
 	 *  Check for inode number is _not_ due to possible IO errors.
 	 *  We might rmdir the source, keep it as pwd of some process
@@ -2931,7 +2964,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		goto end_rename;
 
 	new_inode = new_dentry->d_inode;
-	new_bh = ext4_find_entry(new_dir, &new_dentry->d_name, &new_de);
+	new_bh = ext4_find_entry(new_dir, &new_dentry->d_name,
+				 &new_de, &new_inlined);
 	if (new_bh) {
 		if (!new_inode) {
 			brelse(new_bh);
@@ -2945,16 +2979,18 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 				goto end_rename;
 		}
 		retval = -EIO;
-		dir_bh = ext4_bread(handle, old_inode, 0, 0, &retval);
+		dir_bh = ext4_get_first_dir_block(handle, old_inode,
+						  &dir_buf, &buf_size,
+						  &retval, &inlined);
 		if (!dir_bh)
 			goto end_rename;
-		if (!buffer_verified(dir_bh) &&
+		if (!inlined && !buffer_verified(dir_bh) &&
 		    !ext4_dirent_csum_verify(old_inode,
 				(struct ext4_dir_entry *)dir_bh->b_data))
 			goto end_rename;
 		set_buffer_verified(dir_bh);
-		if (le32_to_cpu(PARENT_INO(dir_bh->b_data,
-				old_dir->i_sb->s_blocksize)) != old_dir->i_ino)
+		if (le32_to_cpu(PARENT_INO(dir_buf,
+					   buf_size)) != old_dir->i_ino)
 			goto end_rename;
 		retval = -EMLINK;
 		if (!new_inode && new_dir != old_dir &&
@@ -2983,10 +3019,13 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 					ext4_current_time(new_dir);
 		ext4_mark_inode_dirty(handle, new_dir);
 		BUFFER_TRACE(new_bh, "call ext4_handle_dirty_metadata");
-		retval = ext4_handle_dirty_dirent_node(handle, new_dir, new_bh);
-		if (unlikely(retval)) {
-			ext4_std_error(new_dir->i_sb, retval);
-			goto end_rename;
+		if (!new_inlined) {
+			retval = ext4_handle_dirty_dirent_node(handle,
+							       new_dir, new_bh);
+			if (unlikely(retval)) {
+				ext4_std_error(new_dir->i_sb, retval);
+				goto end_rename;
+			}
 		}
 		brelse(new_bh);
 		new_bh = NULL;
@@ -3014,7 +3053,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		struct buffer_head *old_bh2;
 		struct ext4_dir_entry_2 *old_de2;
 
-		old_bh2 = ext4_find_entry(old_dir, &old_dentry->d_name, &old_de2);
+		old_bh2 = ext4_find_entry(old_dir, &old_dentry->d_name,
+					  &old_de2, NULL);
 		if (old_bh2) {
 			retval = ext4_delete_entry(handle, old_dir,
 						   old_de2, old_bh2);
@@ -3034,17 +3074,18 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old_dir->i_ctime = old_dir->i_mtime = ext4_current_time(old_dir);
 	ext4_update_dx_flag(old_dir);
 	if (dir_bh) {
-		PARENT_INO(dir_bh->b_data, new_dir->i_sb->s_blocksize) =
-						cpu_to_le32(new_dir->i_ino);
+		PARENT_INO(dir_buf, buf_size) = cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext4_handle_dirty_metadata");
-		if (is_dx(old_inode)) {
-			retval = ext4_handle_dirty_dx_node(handle,
-							   old_inode,
-							   dir_bh);
+		if (!inlined) {
+			if (is_dx(old_inode)) {
+				retval = ext4_handle_dirty_dx_node(handle,
+								   old_inode,
+								   dir_bh);
+			} else {
+				retval = ext4_handle_dirty_dirent_node(handle,
+							old_inode, dir_bh);
 		} else {
-			retval = ext4_handle_dirty_dirent_node(handle,
-							       old_inode,
-							       dir_bh);
+			retval = ext4_mark_inode_dirty(handle, old_inode);
 		}
 		if (retval) {
 			ext4_std_error(old_dir->i_sb, retval);
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 0063bee..82a70e4 100644
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
@@ -381,6 +385,14 @@ static inline int empty_inline_dir(struct inode *dir, int *has_inline_data)
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

