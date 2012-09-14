From: Tao Ma <tm@tao.ma>
Subject: [PATCH V6 08/23] ext4: Make ext4_init_dot_dotdot for inline dir usage.
Date: Fri, 14 Sep 2012 19:24:56 +0800
Message-ID: <1347621911-4104-8-git-send-email-tm@tao.ma>
References: <1347621512-3660-1-git-send-email-tm@tao.ma>
 <1347621911-4104-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:47730 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758243Ab2INLZ1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Sep 2012 07:25:27 -0400
Received: from [182.92.247.2] (port=60014 helo=tma-laptop1.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1TCU1W-0001sO-Fi
	for linux-ext4@vger.kernel.org; Fri, 14 Sep 2012 05:25:26 -0600
In-Reply-To: <1347621911-4104-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Currently, the initialization of dot and dotdot are encapsulated in
ext4_mkdir and also bond with dir_block. So create a new function
named ext4_init_new_dir and the initialization is moved to
ext4_init_dot_dotdot. Now it will called either in the normal non-inline
case(rec_len of ".." will cover the whole block) or when we converting an
inline dir to a block(rec len of ".." will be the real length). The start
of the next entry is also returned for inline dir usage.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h  |    4 ++
 fs/ext4/namei.c |  106 ++++++++++++++++++++++++++++++++++---------------------
 2 files changed, 70 insertions(+), 40 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ea64a6c..1b93b1c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2379,6 +2379,10 @@ extern loff_t ext4_llseek(struct file *file, loff_t offset, int origin);
 extern const struct inode_operations ext4_dir_inode_operations;
 extern const struct inode_operations ext4_special_inode_operations;
 extern struct dentry *ext4_get_parent(struct dentry *child);
+extern struct ext4_dir_entry_2 *ext4_init_dot_dotdot(struct inode *inode,
+				 struct ext4_dir_entry_2 *de,
+				 int blocksize, int csum_size,
+				 unsigned int parent_ino, int dotdot_real_len);
 
 /* symlink.c */
 extern const struct inode_operations ext4_symlink_inode_operations;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2a42cc0..8f4ef4b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2160,21 +2160,80 @@ retry:
 	return err;
 }
 
-static int ext4_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
+struct ext4_dir_entry_2 *ext4_init_dot_dotdot(struct inode *inode,
+			  struct ext4_dir_entry_2 *de,
+			  int blocksize, int csum_size,
+			  unsigned int parent_ino, int dotdot_real_len)
+{
+	de->inode = cpu_to_le32(inode->i_ino);
+	de->name_len = 1;
+	de->rec_len = ext4_rec_len_to_disk(EXT4_DIR_REC_LEN(de->name_len),
+					   blocksize);
+	strcpy(de->name, ".");
+	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
+
+	de = ext4_next_entry(de, blocksize);
+	de->inode = cpu_to_le32(parent_ino);
+	de->name_len = 2;
+	if (!dotdot_real_len)
+		de->rec_len = ext4_rec_len_to_disk(blocksize -
+					(csum_size + EXT4_DIR_REC_LEN(1)),
+					blocksize);
+	else
+		de->rec_len = ext4_rec_len_to_disk(
+				EXT4_DIR_REC_LEN(de->name_len), blocksize);
+	strcpy(de->name, "..");
+	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
+
+	return ext4_next_entry(de, blocksize);
+}
+
+static int ext4_init_new_dir(handle_t *handle, struct inode *parent,
+			     struct inode *inode)
 {
-	handle_t *handle;
-	struct inode *inode;
 	struct buffer_head *dir_block = NULL;
 	struct ext4_dir_entry_2 *de;
+	int err;
+	int blocksize = inode->i_sb->s_blocksize;
 	struct ext4_dir_entry_tail *t;
-	unsigned int blocksize = dir->i_sb->s_blocksize;
 	int csum_size = 0;
-	int err, retries = 0;
 
-	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
+	if (EXT4_HAS_RO_COMPAT_FEATURE(parent->i_sb,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
+	inode->i_size = EXT4_I(inode)->i_disksize = blocksize;
+	dir_block = ext4_bread(handle, inode, 0, 1, &err);
+	if (!dir_block)
+		goto out;
+	BUFFER_TRACE(dir_block, "get_write_access");
+	err = ext4_journal_get_write_access(handle, dir_block);
+	if (err)
+		goto out;
+	de = (struct ext4_dir_entry_2 *)dir_block->b_data;
+	ext4_init_dot_dotdot(inode, de, blocksize, csum_size, parent->i_ino, 0);
+	set_nlink(inode, 2);
+	if (csum_size) {
+		t = EXT4_DIRENT_TAIL(dir_block->b_data, blocksize);
+		initialize_dirent_tail(t, blocksize);
+	}
+
+	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
+	err = ext4_handle_dirty_dirent_node(handle, inode, dir_block);
+	if (err)
+		goto out;
+	set_buffer_verified(dir_block);
+out:
+	brelse(dir_block);
+	return err;
+}
+
+static int ext4_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
+{
+	handle_t *handle;
+	struct inode *inode;
+	int err, retries = 0;
+
 	if (EXT4_DIR_LINK_MAX(dir))
 		return -EMLINK;
 
@@ -2198,41 +2257,9 @@ retry:
 
 	inode->i_op = &ext4_dir_inode_operations;
 	inode->i_fop = &ext4_dir_operations;
-	inode->i_size = EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
-	dir_block = ext4_bread(handle, inode, 0, 1, &err);
-	if (!dir_block)
-		goto out_clear_inode;
-	BUFFER_TRACE(dir_block, "get_write_access");
-	err = ext4_journal_get_write_access(handle, dir_block);
+	err = ext4_init_new_dir(handle, dir, inode);
 	if (err)
 		goto out_clear_inode;
-	de = (struct ext4_dir_entry_2 *) dir_block->b_data;
-	de->inode = cpu_to_le32(inode->i_ino);
-	de->name_len = 1;
-	de->rec_len = ext4_rec_len_to_disk(EXT4_DIR_REC_LEN(de->name_len),
-					   blocksize);
-	strcpy(de->name, ".");
-	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
-	de = ext4_next_entry(de, blocksize);
-	de->inode = cpu_to_le32(dir->i_ino);
-	de->rec_len = ext4_rec_len_to_disk(blocksize -
-					   (csum_size + EXT4_DIR_REC_LEN(1)),
-					   blocksize);
-	de->name_len = 2;
-	strcpy(de->name, "..");
-	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
-	set_nlink(inode, 2);
-
-	if (csum_size) {
-		t = EXT4_DIRENT_TAIL(dir_block->b_data, blocksize);
-		initialize_dirent_tail(t, blocksize);
-	}
