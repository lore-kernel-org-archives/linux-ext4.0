From: Tao Ma <tm@tao.ma>
Subject: [PATCH V3 08/21] ext4: Create a new function ext4_init_new_dir.
Date: Sun, 18 Dec 2011 22:24:25 +0800
Message-ID: <1324218278-2460-8-git-send-email-tm@tao.ma>
References: <4EEDF6B1.7050206@tao.ma>
 <1324218278-2460-1-git-send-email-tm@tao.ma>
Cc: adilger@dilger.ca, tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1324218278-2460-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Currently, the initialization of dot and dotdot are encapsulated in
ext4_mkdir and also bond with dir_block. So create a new function
named ext4_init_new_dir and the initialization is moved to
ext4_init_dot_dotdot which only accepts a 'de'.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h  |    2 +
 fs/ext4/namei.c |   74 +++++++++++++++++++++++++++++++++---------------------
 2 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 33e7b06..274dec5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2256,6 +2256,8 @@ extern loff_t ext4_llseek(struct file *file, loff_t offset, int origin);
 extern const struct inode_operations ext4_dir_inode_operations;
 extern const struct inode_operations ext4_special_inode_operations;
 extern struct dentry *ext4_get_parent(struct dentry *child);
+void ext4_init_dot_dotdot(struct inode *parent, struct inode *inode,
+			  struct ext4_dir_entry_2 *de, int blocksize);
 
 /* symlink.c */
 extern const struct inode_operations ext4_symlink_inode_operations;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index aa4c782..14ecbd2 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1806,13 +1806,54 @@ retry:
 	return err;
 }
 
+void ext4_init_dot_dotdot(struct inode *parent, struct inode *inode,
+			  struct ext4_dir_entry_2 *de, int blocksize)
+{
+	de->inode = cpu_to_le32(inode->i_ino);
+	de->name_len = 1;
+	de->rec_len = ext4_rec_len_to_disk(EXT4_DIR_REC_LEN(de->name_len),
+					   blocksize);
+	strcpy(de->name, ".");
+	ext4_set_de_type(parent->i_sb, de, S_IFDIR);
+	de = ext4_next_entry(de, blocksize);
+	de->inode = cpu_to_le32(parent->i_ino);
+	de->rec_len = ext4_rec_len_to_disk(blocksize - EXT4_DIR_REC_LEN(1),
+					   blocksize);
+	de->name_len = 2;
+	strcpy(de->name, "..");
+	ext4_set_de_type(parent->i_sb, de, S_IFDIR);
+	set_nlink(inode, 2);
+}
+
+static int ext4_init_new_dir(handle_t *handle, struct inode *parent,
+			     struct inode *inode)
+{
+	struct buffer_head *dir_block = NULL;
+	struct ext4_dir_entry_2 *de;
+	int err;
+	int blocksize = inode->i_sb->s_blocksize;
+
+	inode->i_size = EXT4_I(inode)->i_disksize = blocksize;
+	dir_block = ext4_bread(handle, inode, 0, 1, &err);
+	if (!dir_block)
+		goto out;
+	BUFFER_TRACE(dir_block, "get_write_access");
+	err = ext4_journal_get_write_access(handle, dir_block);
+	if (err)
+		goto out;
+	de = (struct ext4_dir_entry_2 *)dir_block->b_data;
+	ext4_init_dot_dotdot(parent, inode, de, blocksize);
+	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
+	err = ext4_handle_dirty_metadata(handle, inode, dir_block);
+out:
+	brelse(dir_block);
+	return err;
+}
+
 static int ext4_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
 	handle_t *handle;
 	struct inode *inode;
-	struct buffer_head *dir_block = NULL;
-	struct ext4_dir_entry_2 *de;
-	unsigned int blocksize = dir->i_sb->s_blocksize;
 	int err, retries = 0;
 
 	if (EXT4_DIR_LINK_MAX(dir))
@@ -1838,31 +1879,7 @@ retry:
 
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
-	de->rec_len = ext4_rec_len_to_disk(blocksize - EXT4_DIR_REC_LEN(1),
-					   blocksize);
-	de->name_len = 2;
-	strcpy(de->name, "..");
-	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
-	set_nlink(inode, 2);
-	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
-	err = ext4_handle_dirty_metadata(handle, inode, dir_block);
+	err = ext4_init_new_dir(handle, dir, inode);
 	if (err)
 		goto out_clear_inode;
 	err = ext4_mark_inode_dirty(handle, inode);
@@ -1884,7 +1901,6 @@ out_clear_inode:
 	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
 out_stop:
-	brelse(dir_block);
 	ext4_journal_stop(handle);
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
-- 
1.7.0.4
