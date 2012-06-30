From: Tao Ma <tm@tao.ma>
Subject: [PATCH V5 08/23] ext4: Create a new function ext4_init_new_dir.
Date: Sat, 30 Jun 2012 23:45:09 +0800
Message-ID: <1341071124-4976-8-git-send-email-tm@tao.ma>
References: <1341070917-4889-1-git-send-email-tm@tao.ma>
 <1341071124-4976-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:40387 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755427Ab2F3Pr7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jun 2012 11:47:59 -0400
Received: from [221.217.40.18] (port=40170 helo=localhost.localdomain)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1Skztt-0006eg-Oq
	for linux-ext4@vger.kernel.org; Sat, 30 Jun 2012 09:47:58 -0600
In-Reply-To: <1341071124-4976-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Currently, the initialization of dot and dotdot are encapsulated in
ext4_mkdir and also bond with dir_block. So create a new function
named ext4_init_new_dir and the initialization is moved to
ext4_init_dot_dotdot which only accepts a 'de'.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h  |    3 ++
 fs/ext4/namei.c |   98 ++++++++++++++++++++++++++++++++----------------------
 2 files changed, 61 insertions(+), 40 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a8ea596..7edcd79 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2381,6 +2381,9 @@ extern loff_t ext4_llseek(struct file *file, loff_t offset, int origin);
 extern const struct inode_operations ext4_dir_inode_operations;
 extern const struct inode_operations ext4_special_inode_operations;
 extern struct dentry *ext4_get_parent(struct dentry *child);
+extern void ext4_init_dot_dotdot(struct inode *parent, struct inode *inode,
+				 struct ext4_dir_entry_2 *de, int blocksize,
+				 int csum_size);
 
 /* symlink.c */
 extern const struct inode_operations ext4_symlink_inode_operations;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 0edaf18..84f0c78 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2160,21 +2160,72 @@ retry:
 	return err;
 }
 
-static int ext4_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
+void ext4_init_dot_dotdot(struct inode *parent, struct inode *inode,
+			  struct ext4_dir_entry_2 *de, int blocksize,
+			  int csum_size)
+{
+	de->inode = cpu_to_le32(inode->i_ino);
+	de->name_len = 1;
+	de->rec_len = ext4_rec_len_to_disk(EXT4_DIR_REC_LEN(de->name_len),
+					   blocksize);
+	strcpy(de->name, ".");
+	ext4_set_de_type(parent->i_sb, de, S_IFDIR);
+	de = ext4_next_entry(de, blocksize);
+	de->inode = cpu_to_le32(parent->i_ino);
+	de->rec_len = ext4_rec_len_to_disk(blocksize -
+					   (csum_size + EXT4_DIR_REC_LEN(1)),
+					   blocksize);
+	de->name_len = 2;
+	strcpy(de->name, "..");
+	ext4_set_de_type(parent->i_sb, de, S_IFDIR);
+	set_nlink(inode, 2);
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
+	ext4_init_dot_dotdot(parent, inode, de, blocksize, csum_size);
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
 
@@ -2198,41 +2249,9 @@ retry:
 
 	inode->i_op = &ext4_dir_inode_operations;
 	inode->i_fop = &ext4_dir_operations;
-	inode->i_size = EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
-	dir_block = ext4_bread(handle, inode, 0, 1, &err);
-	if (!dir_block)
-		goto out_clear_inode;
-	BUFFER_TRACE(dir_block, "get_write_access");
-	err = ext4_journal_get_write_access(handle, dir_block);
-	if (err)
-		goto out_clear_inode;
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
