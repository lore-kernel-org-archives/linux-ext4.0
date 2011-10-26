From: Tao Ma <tm@tao.ma>
Subject: [PATCH V1 16/17] ext4: let ext4_rename handle inline dir.
Date: Wed, 26 Oct 2011 15:34:27 +0800
Message-ID: <1319614468-11227-16-git-send-email-tm@tao.ma>
References: <4EA7B788.3040503@tao.ma>
 <1319614468-11227-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1319614468-11227-1-git-send-email-tm@tao.ma>
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
 fs/ext4/namei.c |   50 ++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 343af6c..cb1b396 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2777,6 +2777,43 @@ retry:
 	(ext4_next_entry((struct ext4_dir_entry_2 *)(buffer), size)->inode)
 
 /*
+ * Try to find buffer head where contains the parent block.
+ * It should be the inode block if it is inlined or the 1st block
+ * if it is a normal dir.
+ */
+static struct buffer_head *ext4_get_dir_block(handle_t *handle,
+					      struct inode *inode,
+					      void **buf,
+					      int *buf_size,
+					      int *retval)
+{
+	struct buffer_head *bh;
+	void *inline_start;
+	int inline_size;
+	struct ext4_iloc iloc;
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
+	*retval = ext4_get_inode_loc(inode, &iloc);
+	if (*retval)
+		return NULL;
+
+	inline_start = ext4_get_inline_data_pos(inode, &iloc);
+	inline_size = ext4_get_max_inline_size(inode);
+
+	*buf = inline_start;
+	*buf_size = inline_size;
+	return iloc.bh;
+}
+
+/*
  * Anybody can rename anything with this: the permission checks are left to the
  * higher-level routines.
  */
@@ -2787,7 +2824,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct inode *old_inode, *new_inode;
 	struct buffer_head *old_bh, *new_bh, *dir_bh;
 	struct ext4_dir_entry_2 *old_de, *new_de;
-	int retval, force_da_alloc = 0;
+	int buf_size, retval, force_da_alloc = 0;
+	void *dir_buf = NULL;
 
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
@@ -2834,11 +2872,12 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 				goto end_rename;
 		}
 		retval = -EIO;
-		dir_bh = ext4_bread(handle, old_inode, 0, 0, &retval);
+		dir_bh = ext4_get_dir_block(handle, old_inode,
+					    &dir_buf, &buf_size, &retval);
 		if (!dir_bh)
 			goto end_rename;
-		if (le32_to_cpu(PARENT_INO(dir_bh->b_data,
-				old_dir->i_sb->s_blocksize)) != old_dir->i_ino)
+		if (le32_to_cpu(PARENT_INO(dir_buf,
+					   buf_size)) != old_dir->i_ino)
 			goto end_rename;
 		retval = -EMLINK;
 		if (!new_inode && new_dir != old_dir &&
@@ -2918,8 +2957,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old_dir->i_ctime = old_dir->i_mtime = ext4_current_time(old_dir);
 	ext4_update_dx_flag(old_dir);
 	if (dir_bh) {
-		PARENT_INO(dir_bh->b_data, new_dir->i_sb->s_blocksize) =
-						cpu_to_le32(new_dir->i_ino);
+		PARENT_INO(dir_buf, buf_size) = cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext4_handle_dirty_metadata");
 		retval = ext4_handle_dirty_metadata(handle, old_inode, dir_bh);
 		if (retval) {
-- 
1.7.0.4
