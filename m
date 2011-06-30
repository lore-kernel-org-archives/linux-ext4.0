From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 2/2 v3] EXT4: Secure Delete: Zero out files directory entry
Date: Thu, 30 Jun 2011 14:22:03 -0700
Message-ID: <1309468923-5677-3-git-send-email-achender@linux.vnet.ibm.com>
References: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36657 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab1F3VT7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jun 2011 17:19:59 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5UKuxVs016332
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jun 2011 16:56:59 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p5ULJgG3437714
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jun 2011 17:19:43 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p5ULJgmd010066
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jun 2011 17:19:42 -0400
In-Reply-To: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch zeros out a files directory entry when a file
with the EXT4_SECRM_FL attribute flag is deleted.  A new flag
parameter has been added to the ext4_delete_entry routine,
that will force the entry to be zeroed out and flushed to the disk.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
v1->v2
Removed new inode parameter in ext4_delete_entry and replaced
with a new flag for ext4_delete_entry

:100644 100644 38a4d75... 1e50f78... M	fs/ext4/ext4.h
:100644 100644 b754b77... 9af19f4... M	fs/ext4/namei.c
 fs/ext4/ext4.h  |    5 +++++
 fs/ext4/namei.c |   52 +++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 38a4d75..1e50f78 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -529,6 +529,11 @@ struct ext4_new_group_data {
 #define EXT4_FREE_BLOCKS_ZERO		0x0008
 
 /*
+ * Flags used by ext4_delete_entry
+ */
+#define EXT4_DEL_ENTRY_ZERO		0x0001
+
+/*
  * ioctl commands
  */
 #define	EXT4_IOC_GETFLAGS		FS_IOC_GETFLAGS
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b754b77..9af19f4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1643,10 +1643,12 @@ cleanup:
 static int ext4_delete_entry(handle_t *handle,
 			     struct inode *dir,
 			     struct ext4_dir_entry_2 *de_del,
-			     struct buffer_head *bh)
+			     struct buffer_head *bh,
+			     int flags)
 {
 	struct ext4_dir_entry_2 *de, *pde;
 	unsigned int blocksize = dir->i_sb->s_blocksize;
+	struct ext4_super_block *es = EXT4_SB(dir->i_sb)->s_es;
 	int i, err;
 
 	i = 0;
@@ -1673,10 +1675,34 @@ static int ext4_delete_entry(handle_t *handle,
 				de->inode = 0;
 			dir->i_version++;
 			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
-			err = ext4_handle_dirty_metadata(handle, dir, bh);
-			if (unlikely(err)) {
-				ext4_std_error(dir->i_sb, err);
-				return err;
+
+			/*
+			 * If the secure remove flag is on, zero
+			 * out the entry and write it out to the
+			 * disk
+			 */
+			if (flags & EXT4_DEL_ENTRY_ZERO) {
+				memset(de->name, 0x00, de->name_len);
+				de->file_type = 0;
+
+				set_buffer_dirty(bh);
+				sync_dirty_buffer(bh);
+				if (buffer_req(bh) && !buffer_uptodate(bh)) {
+					es->s_last_error_block =
+						cpu_to_le64(bh->b_blocknr);
+					ext4_error_inode(dir,
+					__func__, __LINE__, bh->b_blocknr,
+					"IO error syncing itable block");
+					return -EIO;
+				}
+			} else {
+				err = ext4_handle_dirty_metadata(handle,
+					dir, bh);
+
+				if (unlikely(err)) {
+					ext4_std_error(dir->i_sb, err);
+					return err;
+				}
 			}
 			return 0;
 		}
@@ -2162,7 +2188,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	if (!empty_dir(inode))
 		goto end_rmdir;
 
-	retval = ext4_delete_entry(handle, dir, de, bh);
+	retval = ext4_delete_entry(handle, dir, de, bh, 0);
 	if (retval)
 		goto end_rmdir;
 	if (!EXT4_DIR_LINK_EMPTY(inode))
@@ -2190,7 +2216,7 @@ end_rmdir:
 
 static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 {
-	int retval;
+	int retval, del_entry_flags;
 	struct inode *inode;
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de;
@@ -2215,6 +2241,8 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 		goto end_unlink;
 
 	inode = dentry->d_inode;
+	del_entry_flags = EXT4_I(inode)->i_flags & EXT4_SECRM_FL ?
+		EXT4_DEL_ENTRY_ZERO : 0;
 
 	retval = -EIO;
 	if (le32_to_cpu(de->inode) != inode->i_ino)
@@ -2226,7 +2254,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 			     inode->i_ino, inode->i_nlink);
 		inode->i_nlink = 1;
 	}
-	retval = ext4_delete_entry(handle, dir, de, bh);
+	retval = ext4_delete_entry(handle, dir, de, bh, del_entry_flags);
 	if (retval)
 		goto end_unlink;
 	dir->i_ctime = dir->i_mtime = ext4_current_time(dir);
@@ -2404,7 +2432,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct inode *old_inode, *new_inode;
 	struct buffer_head *old_bh, *new_bh, *dir_bh;
 	struct ext4_dir_entry_2 *old_de, *new_de;
-	int retval, force_da_alloc = 0;
+	int retval, del_entry_flags, force_da_alloc = 0;
 
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
@@ -2503,11 +2531,13 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	/*
 	 * ok, that's it
 	 */
+	del_entry_flags = EXT4_I(old_inode)->i_flags & EXT4_SECRM_FL ?
+			EXT4_DEL_ENTRY_ZERO : 0;
 	if (le32_to_cpu(old_de->inode) != old_inode->i_ino ||
 	    old_de->name_len != old_dentry->d_name.len ||
 	    strncmp(old_de->name, old_dentry->d_name.name, old_de->name_len) ||
 	    (retval = ext4_delete_entry(handle, old_dir,
-					old_de, old_bh)) == -ENOENT) {
+			old_de, old_bh, del_entry_flags)) == -ENOENT) {
 		/* old_de could have moved from under us during htree split, so
 		 * make sure that we are deleting the right entry.  We might
 		 * also be pointing to a stale entry in the unused part of
@@ -2518,7 +2548,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		old_bh2 = ext4_find_entry(old_dir, &old_dentry->d_name, &old_de2);
 		if (old_bh2) {
 			retval = ext4_delete_entry(handle, old_dir,
-						   old_de2, old_bh2);
+				old_de2, old_bh2, del_entry_flags);
 			brelse(old_bh2);
 		}
 	}
-- 
1.7.1

