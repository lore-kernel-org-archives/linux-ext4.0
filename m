From: Tao Ma <tm@tao.ma>
Subject: [PATCH V6 18/23] ext4: let ext4_rename handle inline dir.
Date: Fri, 14 Sep 2012 19:25:06 +0800
Message-ID: <1347621911-4104-18-git-send-email-tm@tao.ma>
References: <1347621512-3660-1-git-send-email-tm@tao.ma>
 <1347621911-4104-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:52458 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751967Ab2INLeI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Sep 2012 07:34:08 -0400
Received: from [182.92.247.2] (port=60014 helo=tma-laptop1.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1TCU1h-0001sO-5P
	for linux-ext4@vger.kernel.org; Fri, 14 Sep 2012 05:25:37 -0600
In-Reply-To: <1347621911-4104-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In case of we rename a dir, ext4_rename has to read the dir block
and change its dotdot's information. The old ext4_rename encapsulated
the dir_block read into itself. So this patch try to add a new function
ext4_get_first_dir_block which get the dir buffer information so the
ext4_rename can handle it properly. As it will also change the parent
inode number, we return the parent_de and let ext4_rename handles it
more easily.

ext4_find_entry is also changed so that the caller(rename) can tell whether
the found entry is an inlined one or not and journaling the corresponding
buffer head.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inline.c |   15 ++++++++
 fs/ext4/namei.c  |   95 ++++++++++++++++++++++++++++++++++++++----------------
 fs/ext4/xattr.h  |   11 ++++++
 3 files changed, 93 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 5bf1326..e01533f 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1418,6 +1418,21 @@ out:
 	return ret;
 }
 
+struct buffer_head *ext4_get_first_inline_block(struct inode *inode,
+					struct ext4_dir_entry_2 **parent_de,
+					int *retval)
+{
+	struct ext4_iloc iloc;
+
+	*retval = ext4_get_inode_loc(inode, &iloc);
+	if (*retval)
+		return NULL;
+
+	*parent_de = (struct ext4_dir_entry_2 *)ext4_raw_inode(&iloc)->i_block;
+
+	return iloc.bh;
+}
+
 /*
  * Try to create the inline data for the new dir.
  * If it succeeds, return 0, otherwise return the error.
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index f2a4ba6..765ad72 100644
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
@@ -1331,7 +1335,7 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsi
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
@@ -2644,7 +2648,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 		return PTR_ERR(handle);
 
 	retval = -ENOENT;
-	bh = ext4_find_entry(dir, &dentry->d_name, &de);
+	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
 	if (!bh)
 		goto end_rmdir;
 
@@ -2709,7 +2713,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 		ext4_handle_sync(handle);
 
 	retval = -ENOENT;
-	bh = ext4_find_entry(dir, &dentry->d_name, &de);
+	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
 	if (!bh)
 		goto end_unlink;
 
@@ -2891,8 +2895,33 @@ retry:
 	return err;
 }
 
-#define PARENT_INO(buffer, size) \
-	(ext4_next_entry((struct ext4_dir_entry_2 *)(buffer), size)->inode)
+
+/*
+ * Try to find buffer head where contains the parent block.
+ * It should be the inode block if it is inlined or the 1st block
+ * if it is a normal dir.
+ */
+static struct buffer_head *ext4_get_first_dir_block(handle_t *handle,
+					struct inode *inode,
+					int *retval,
+					struct ext4_dir_entry_2 **parent_de,
+					int *inlined)
+{
+	struct buffer_head *bh;
+
+	if (!ext4_has_inline_data(inode)) {
+		bh = ext4_bread(handle, inode, 0, 0, retval);
+		if (!bh)
+			return NULL;
+		*parent_de = ext4_next_entry(
+					(struct ext4_dir_entry_2 *)bh->b_data,
+					inode->i_sb->s_blocksize);
+		return bh;
+	}
+
+	*inlined = 1;
+	return ext4_get_first_inline_block(inode, parent_de, retval);
+}
 
 /*
  * Anybody can rename anything with this: the permission checks are left to the
@@ -2906,6 +2935,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct buffer_head *old_bh, *new_bh, *dir_bh;
 	struct ext4_dir_entry_2 *old_de, *new_de;
 	int retval, force_da_alloc = 0;
+	int inlined = 0, new_inlined = 0;
+	struct ext4_dir_entry_2 *parent_de;
 
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
@@ -2925,7 +2956,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir))
 		ext4_handle_sync(handle);
 
-	old_bh = ext4_find_entry(old_dir, &old_dentry->d_name, &old_de);
+	old_bh = ext4_find_entry(old_dir, &old_dentry->d_name, &old_de, NULL);
 	/*
 	 *  Check for inode number is _not_ due to possible IO errors.
 	 *  We might rmdir the source, keep it as pwd of some process
@@ -2938,7 +2969,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		goto end_rename;
 
 	new_inode = new_dentry->d_inode;
-	new_bh = ext4_find_entry(new_dir, &new_dentry->d_name, &new_de);
+	new_bh = ext4_find_entry(new_dir, &new_dentry->d_name,
+				 &new_de, &new_inlined);
 	if (new_bh) {
 		if (!new_inode) {
 			brelse(new_bh);
@@ -2952,16 +2984,17 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 				goto end_rename;
 		}
 		retval = -EIO;
-		dir_bh = ext4_bread(handle, old_inode, 0, 0, &retval);
+		dir_bh = ext4_get_first_dir_block(handle, old_inode,
+						  &retval, &parent_de,
+						  &inlined);
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
+		if (le32_to_cpu(parent_de->inode) != old_dir->i_ino)
 			goto end_rename;
 		retval = -EMLINK;
 		if (!new_inode && new_dir != old_dir &&
@@ -2990,10 +3023,13 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
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
@@ -3021,7 +3057,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		struct buffer_head *old_bh2;
 		struct ext4_dir_entry_2 *old_de2;
 
-		old_bh2 = ext4_find_entry(old_dir, &old_dentry->d_name, &old_de2);
+		old_bh2 = ext4_find_entry(old_dir, &old_dentry->d_name,
+					  &old_de2, NULL);
 		if (old_bh2) {
 			retval = ext4_delete_entry(handle, old_dir,
 						   old_de2, old_bh2);
@@ -3041,17 +3078,19 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old_dir->i_ctime = old_dir->i_mtime = ext4_current_time(old_dir);
 	ext4_update_dx_flag(old_dir);
 	if (dir_bh) {
-		PARENT_INO(dir_bh->b_data, new_dir->i_sb->s_blocksize) =
-						cpu_to_le32(new_dir->i_ino);
+		parent_de->inode = cpu_to_le32(new_dir->i_ino);
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
+			}
 		} else {
-			retval = ext4_handle_dirty_dirent_node(handle,
-							       old_inode,
-							       dir_bh);
+			retval = ext4_mark_inode_dirty(handle, old_inode);
 		}
 		if (retval) {
 			ext4_std_error(old_dir->i_sb, retval);
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 2791d9a..dbc014f 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -181,6 +181,9 @@ extern int ext4_delete_inline_entry(handle_t *handle,
 				    struct buffer_head *bh,
 				    int *has_inline_data);
 extern int empty_inline_dir(struct inode *dir, int *has_inline_data);
+extern struct buffer_head *ext4_get_first_inline_block(struct inode *inode,
+					struct ext4_dir_entry_2 **parent_de,
+					int *retval);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -385,6 +388,14 @@ static inline int empty_inline_dir(struct inode *dir, int *has_inline_data)
 {
 	return 0;
 }
+
+static inline struct buffer_head *
+ext4_get_first_inline_block(struct inode *inode,
+			    struct ext4_dir_entry_2 **parent_de,
+			    int *retval)
+{
+	return NULL;
+}
 # endif  /* CONFIG_EXT4_FS_XATTR */
 
 #ifdef CONFIG_EXT4_FS_SECURITY
-- 
1.7.1

