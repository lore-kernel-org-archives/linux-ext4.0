From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [Ext4 Secure Delete 5/7v4] ext4: Secure Delete: Secure delete directory entry
Date: Fri,  7 Oct 2011 00:11:03 -0700
Message-ID: <1317971465-8517-6-git-send-email-achender@linux.vnet.ibm.com>
References: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch zeros or randomizes a files directory entry when a file
with the EXT4_SECRM_FL attribute flag is deleted or renamed.  A new
flag parameter has been added to the ext4_delete_entry routine,
that will cause the entry to be securely zeroed or randomized and
then flushed to the disk.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
v1->v2
Removed new inode parameter in ext4_delete_entry and replaced
with a new flag for ext4_delete_entry

:100644 100644 34f82a1... 0cba63b... M	fs/ext4/ext4.h
:100644 100644 f8068c7... b3479c6... M	fs/ext4/namei.c
 fs/ext4/ext4.h  |    6 +++++
 fs/ext4/namei.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 62 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 34f82a1..0cba63b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -532,6 +532,12 @@ struct ext4_new_group_data {
 #define EXT4_FREE_BLOCKS_NO_QUOT_UPDATE	0x0008
 
 /*
+ * Flags used by ext4_delete_entry
+ */
+#define EXT4_DEL_ENTRY_ZERO		0x0001
+#define EXT4_DEL_ENTRY_RAND             0x0002
+
+/*
  * ioctl commands
  */
 #define	EXT4_IOC_GETFLAGS		FS_IOC_GETFLAGS
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index f8068c7..b3479c6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -34,6 +34,7 @@
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
 #include <linux/bio.h>
+#include <linux/random.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
 
@@ -1639,9 +1640,11 @@ cleanup:
 static int ext4_delete_entry(handle_t *handle,
 			     struct inode *dir,
 			     struct ext4_dir_entry_2 *de_del,
-			     struct buffer_head *bh)
+			     struct buffer_head *bh,
+			     int flags)
 {
 	struct ext4_dir_entry_2 *de, *pde;
+	struct ext4_super_block *es = EXT4_SB(dir->i_sb)->s_es;
 	unsigned int blocksize = dir->i_sb->s_blocksize;
 	int i, err;
 
@@ -1669,7 +1672,38 @@ static int ext4_delete_entry(handle_t *handle,
 				de->inode = 0;
 			dir->i_version++;
 			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
-			err = ext4_handle_dirty_metadata(handle, dir, bh);
+
+			/*
+			 * If the secure remove flag is on, zero
+			 * or randomize the entry and write it out
+			 * to the disk
+			 */
+			if (flags & EXT4_DEL_ENTRY_ZERO) {
+				memset(de->name, 0x00, de->name_len);
+				de->file_type = 0;
+			} else if (flags & EXT4_DEL_ENTRY_RAND) {
+				get_random_bytes(de->name, de->name_len);
+				get_random_bytes(&(de->file_type),
+					sizeof(de->file_type));
+			}
+
+			if (flags & EXT4_DEL_ENTRY_ZERO ||
+				flags & EXT4_DEL_ENTRY_RAND) {
+
+				set_buffer_dirty(bh);
+				sync_dirty_buffer(bh);
+				if (buffer_req(bh) && !buffer_uptodate(bh)) {
+					es->s_last_error_block =
+						cpu_to_le64(bh->b_blocknr);
+					ext4_error_inode(dir, __func__,
+					   __LINE__, bh->b_blocknr,
+					   "IO error syncing itable block");
+					err = -EIO;
+				}
+			} else
+				err = ext4_handle_dirty_metadata(handle,
+					dir, bh);
+
 			if (unlikely(err)) {
 				ext4_std_error(dir->i_sb, err);
 				return err;
@@ -2151,7 +2185,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	if (!empty_dir(inode))
 		goto end_rmdir;
 
-	retval = ext4_delete_entry(handle, dir, de, bh);
+	retval = ext4_delete_entry(handle, dir, de, bh, 0);
 	if (retval)
 		goto end_rmdir;
 	if (!EXT4_DIR_LINK_EMPTY(inode))
@@ -2179,7 +2213,7 @@ end_rmdir:
 
 static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 {
-	int retval;
+	int retval, del_entry_flags;
 	struct inode *inode;
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de;
@@ -2204,6 +2238,13 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 		goto end_unlink;
 
 	inode = dentry->d_inode;
+	del_entry_flags = 0;
+	if (EXT4_I(inode)->i_flags & EXT4_SECRM_FL) {
+		if (EXT4_I(inode)->i_flags & EXT4_SECRM_RANDOM_FL)
+			del_entry_flags = EXT4_DEL_ENTRY_RAND;
+		else
+			del_entry_flags = EXT4_DEL_ENTRY_ZERO;
+	}
 
 	retval = -EIO;
 	if (le32_to_cpu(de->inode) != inode->i_ino)
@@ -2215,7 +2256,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 			     inode->i_ino, inode->i_nlink);
 		inode->i_nlink = 1;
 	}
-	retval = ext4_delete_entry(handle, dir, de, bh);
+	retval = ext4_delete_entry(handle, dir, de, bh, del_entry_flags);
 	if (retval)
 		goto end_unlink;
 	dir->i_ctime = dir->i_mtime = ext4_current_time(dir);
@@ -2395,7 +2436,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct inode *old_inode, *new_inode;
 	struct buffer_head *old_bh, *new_bh, *dir_bh;
 	struct ext4_dir_entry_2 *old_de, *new_de;
-	int retval, force_da_alloc = 0;
+	int retval, del_entry_flags, force_da_alloc = 0;
 
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
@@ -2494,11 +2535,18 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	/*
 	 * ok, that's it
 	 */
+	del_entry_flags = 0;
+	if (EXT4_I(old_inode)->i_flags & EXT4_SECRM_FL) {
+		if (EXT4_I(old_inode)->i_flags & EXT4_SECRM_RANDOM_FL)
+			del_entry_flags = EXT4_DEL_ENTRY_RAND;
+		else
+			del_entry_flags = EXT4_DEL_ENTRY_ZERO;
+	}
 	if (le32_to_cpu(old_de->inode) != old_inode->i_ino ||
 	    old_de->name_len != old_dentry->d_name.len ||
 	    strncmp(old_de->name, old_dentry->d_name.name, old_de->name_len) ||
 	    (retval = ext4_delete_entry(handle, old_dir,
-					old_de, old_bh)) == -ENOENT) {
+			old_de, old_bh, del_entry_flags)) == -ENOENT) {
 		/* old_de could have moved from under us during htree split, so
 		 * make sure that we are deleting the right entry.  We might
 		 * also be pointing to a stale entry in the unused part of
@@ -2509,7 +2557,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
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

