From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/8] ext4 crypto: encrypt tmpfile located in encryption protected directory
Date: Thu, 28 May 2015 19:47:43 -0400
Message-ID: <1432856867-5710-4-git-send-email-tytso@mit.edu>
References: <1432856867-5710-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35457 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794AbbE1Xr5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2015 19:47:57 -0400
In-Reply-To: <1432856867-5710-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Factor out calls to ext4_inherit_context() and move them to
__ext4_new_inode(); this fixes a problem where ext4_tmpfile() wasn't
calling calling ext4_inherit_context(), so the temporary file wasn't
getting protected.  Since the blocks for the tmpfile could end up on
disk, they really should be protected if the tmpfile is created within
the context of an encrypted directory.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h   |  9 +++++++++
 fs/ext4/ialloc.c | 26 ++++++++++++++++++++------
 fs/ext4/namei.c  | 29 +----------------------------
 3 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7435ff2..bd8d32d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2149,6 +2149,11 @@ static inline int ext4_get_encryption_info(struct inode *inode)
 	return 0;
 }
 
+static inline struct ext4_crypt_info *ext4_encryption_info(struct inode *inode)
+{
+	return EXT4_I(inode)->i_crypt_info;
+}
+
 #else
 static inline int ext4_has_encryption_key(struct inode *inode)
 {
@@ -2158,6 +2163,10 @@ static inline int ext4_get_encryption_info(struct inode *inode)
 {
 	return 0;
 }
+static inline struct ext4_crypt_info *ext4_encryption_info(struct inode *inode)
+{
+	return NULL;
+}
 #endif
 
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index ddca169..173c1ae 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -726,11 +726,25 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 	ext4_group_t i;
 	ext4_group_t flex_group;
 	struct ext4_group_info *grp;
+	int encrypt = 0;
 
 	/* Cannot create files in a deleted directory */
 	if (!dir || !dir->i_nlink)
 		return ERR_PTR(-EPERM);
 
+	if ((ext4_encrypted_inode(dir) ||
+	     DUMMY_ENCRYPTION_ENABLED(EXT4_SB(dir->i_sb))) &&
+	    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))) {
+		err = ext4_get_encryption_info(dir);
+		if (err)
+			return ERR_PTR(err);
+		if (ext4_encryption_info(dir) == NULL)
+			return ERR_PTR(-EPERM);
+		if (!handle)
+			nblocks += EXT4_DATA_TRANS_BLOCKS(dir->i_sb);
+		encrypt = 1;
+	}
+
 	sb = dir->i_sb;
 	ngroups = ext4_get_groups_count(sb);
 	trace_ext4_request_inode(dir, mode);
@@ -996,12 +1010,6 @@ got:
 	ei->i_block_group = group;
 	ei->i_last_alloc_group = ~0;
 
-	/* If the directory encrypted, then we should encrypt the inode. */
-	if ((S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode)) &&
-	    (ext4_encrypted_inode(dir) ||
-	     DUMMY_ENCRYPTION_ENABLED(sbi)))
-		ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
-
 	ext4_set_inode_flags(inode);
 	if (IS_DIRSYNC(inode))
 		ext4_handle_sync(handle);
@@ -1063,6 +1071,12 @@ got:
 		ei->i_datasync_tid = handle->h_transaction->t_tid;
 	}
 
+	if (encrypt) {
+		err = ext4_inherit_context(dir, inode);
+		if (err)
+			goto fail_free_drop;
+	}
+
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err) {
 		ext4_std_error(sb, err);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 6ab50f8..1e7d65d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2437,20 +2437,7 @@ retry:
 		inode->i_op = &ext4_file_inode_operations;
 		inode->i_fop = &ext4_file_operations;
 		ext4_set_aops(inode);
-		err = 0;
-#ifdef CONFIG_EXT4_FS_ENCRYPTION
-		if (!err && (ext4_encrypted_inode(dir) ||
-			     DUMMY_ENCRYPTION_ENABLED(EXT4_SB(dir->i_sb)))) {
-			err = ext4_inherit_context(dir, inode);
-			if (err) {
-				clear_nlink(inode);
-				unlock_new_inode(inode);
-				iput(inode);
-			}
-		}
-#endif
-		if (!err)
-			err = ext4_add_nondir(handle, dentry, inode);
+		err = ext4_add_nondir(handle, dentry, inode);
 		if (!err && IS_DIRSYNC(dir))
 			ext4_handle_sync(handle);
 	}
@@ -2631,14 +2618,6 @@ retry:
 	err = ext4_init_new_dir(handle, dir, inode);
 	if (err)
 		goto out_clear_inode;
-#ifdef CONFIG_EXT4_FS_ENCRYPTION
-	if (ext4_encrypted_inode(dir) ||
-	    DUMMY_ENCRYPTION_ENABLED(EXT4_SB(dir->i_sb))) {
-		err = ext4_inherit_context(dir, inode);
-		if (err)
-			goto out_clear_inode;
-	}
-#endif
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (!err)
 		err = ext4_add_entry(handle, dentry, inode);
@@ -3106,12 +3085,6 @@ static int ext4_symlink(struct inode *dir,
 			err = -ENOMEM;
 			goto err_drop_inode;
 		}
-		err = ext4_inherit_context(dir, inode);
-		if (err)
-			goto err_drop_inode;
-		err = ext4_get_encryption_info(inode);
-		if (err)
-			goto err_drop_inode;
 		istr.name = (const unsigned char *) symname;
 		istr.len = len;
 		ostr.name = sd->encrypted_path;
-- 
2.3.0

