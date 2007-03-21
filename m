From: Kalpak Shah <kalpak@clusterfs.com>
Subject: [PATCH 0/2] ext4: allow more than 32000 subdirectories
Date: Wed, 21 Mar 2007 19:42:30 +0530
Message-ID: <1174486350.11843.11.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>, tytso <tytso@mit.edu>,
	sct <sct@redhat.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:56326 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbXCUOK4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Mar 2007 10:10:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

This patch adds support to ext4 for allowing more than 65000 subdirectories. Currently the maximum number of subdirectories is capped at 32000.

If we exceed 65000 subdirectories in an htree directory it sets the inode link count to 1 and no longer counts subdirectories.  The directory link count is not actually used when determining if a directory is empty, as that only counts subdirectories and not regular files that might be in there. 

A EXT4_FEATURE_RO_COMPAT_DIR_NLINK flag has been added and it is set if the subdir count for any directory crosses 65000.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>

Index: linux-2.6.20/fs/ext4/namei.c
===================================================================
--- linux-2.6.20.orig/fs/ext4/namei.c
+++ linux-2.6.20/fs/ext4/namei.c
@@ -1624,11 +1624,21 @@ static int ext4_delete_entry (handle_t *
 static inline void ext4_inc_count(handle_t *handle, struct inode *inode)
 {
 	inc_nlink(inode);
+	if (is_dx(inode) && inode->i_nlink > 1) {
+		/* limit is 16-bit i_links_count */
+        	if (inode->i_nlink >= EXT4_LINK_MAX || inode->i_nlink == 2) {
+                	inode->i_nlink = 1;
+			EXT4_SET_RO_COMPAT_FEATURE(inode->i_sb,
+					      EXT4_FEATURE_RO_COMPAT_DIR_NLINK);
+		}
+	}
 }
 
 static inline void ext4_dec_count(handle_t *handle, struct inode *inode)
 {
 	drop_nlink(inode);
+	if (S_ISDIR(inode->i_mode) && inode->i_nlink == 0)
+		inc_nlink(inode);
 }
 
 static int ext4_add_nondir(handle_t *handle,
@@ -1727,7 +1737,7 @@ static int ext4_mkdir(struct inode * dir
 	struct ext4_dir_entry_2 * de;
 	int err, retries = 0;
 
-	if (dir->i_nlink >= EXT4_LINK_MAX)
+	if (EXT4_DIR_LINK_MAX(dir))
 		return -EMLINK;
 
 retry:
@@ -1750,7 +1760,7 @@ retry:
 	inode->i_size = EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
 	dir_block = ext4_bread (handle, inode, 0, 1, &err);
 	if (!dir_block) {
-		drop_nlink(inode); /* is this nlink == 0? */
+		ext4_dec_count(handle, inode); /* is this nlink == 0? */
 		ext4_mark_inode_dirty(handle, inode);
 		iput (inode);
 		goto out_stop;
@@ -1782,7 +1792,7 @@ retry:
 		iput (inode);
 		goto out_stop;
 	}
-	inc_nlink(dir);
+	ext4_inc_count(handle, dir);
 	ext4_update_dx_flag(dir);
 	ext4_mark_inode_dirty(handle, dir);
 	d_instantiate(dentry, inode);
@@ -2047,10 +2057,10 @@ static int ext4_rmdir (struct inode * di
 	retval = ext4_delete_entry(handle, dir, de, bh);
 	if (retval)
 		goto end_rmdir;
-	if (inode->i_nlink != 2)
-		ext4_warning (inode->i_sb, "ext4_rmdir",
-			      "empty directory has nlink!=2 (%d)",
-			      inode->i_nlink);
+	if (!EXT4_DIR_LINK_EMPTY(inode))
+		ext4_warning(inode->i_sb, "ext3_rmdir",
+			     "empty directory has too many links (%d)",
+			     inode->i_nlink);
 	inode->i_version++;
 	clear_nlink(inode);
 	/* There's no need to set i_disksize: the fact that i_nlink is
@@ -2060,7 +2070,7 @@ static int ext4_rmdir (struct inode * di
 	ext4_orphan_add(handle, inode);
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
 	ext4_mark_inode_dirty(handle, inode);
-	drop_nlink(dir);
+	ext4_dec_count(handle, dir);
 	ext4_update_dx_flag(dir);
 	ext4_mark_inode_dirty(handle, dir);
 
@@ -2111,7 +2121,7 @@ static int ext4_unlink(struct inode * di
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
 	ext4_update_dx_flag(dir);
 	ext4_mark_inode_dirty(handle, dir);
-	drop_nlink(inode);
+	ext4_dec_count(handle, inode);
 	if (!inode->i_nlink)
 		ext4_orphan_add(handle, inode);
 	inode->i_ctime = dir->i_ctime;
@@ -2187,7 +2197,7 @@ static int ext4_link (struct dentry * ol
 	struct inode *inode = old_dentry->d_inode;
 	int err, retries = 0;
 
-	if (inode->i_nlink >= EXT4_LINK_MAX)
+	if (EXT4_DIR_LINK_MAX(inode))
 		return -EMLINK;
 
 retry:
@@ -2333,7 +2343,7 @@ static int ext4_rename (struct inode * o
 	}
 
 	if (new_inode) {
-		drop_nlink(new_inode);
+		ext4_dec_count(handle, new_inode);
 		new_inode->i_ctime = CURRENT_TIME_SEC;
 	}
 	old_dir->i_ctime = old_dir->i_mtime = CURRENT_TIME_SEC;
@@ -2344,11 +2354,13 @@ static int ext4_rename (struct inode * o
 		PARENT_INO(dir_bh->b_data) = cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext4_journal_dirty_metadata");
 		ext4_journal_dirty_metadata(handle, dir_bh);
-		drop_nlink(old_dir);
+		ext4_dec_count(handle, old_dir);
 		if (new_inode) {
-			drop_nlink(new_inode);
+			/* checked empty_dir above, can't have another parent,
+			 * ext3_dec_count() won't work for many-linked dirs */
+			new_inode->i_nlink = 0;
 		} else {
-			inc_nlink(new_dir);
+			ext4_inc_count(handle, new_dir);
 			ext4_update_dx_flag(new_dir);
 			ext4_mark_inode_dirty(handle, new_dir);
 		}
Index: linux-2.6.20/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.20.orig/include/linux/ext4_fs.h
+++ linux-2.6.20/include/linux/ext4_fs.h
@@ -71,7 +71,7 @@
 /*
  * Maximal count of links to a file
  */
-#define EXT4_LINK_MAX		32000
+#define EXT4_LINK_MAX		65000
 
 /*
  * Macro-instructions used to manage several block sizes
@@ -596,6 +596,7 @@ static inline int ext4_valid_inum(struct
 #define EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT4_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
 #define EXT4_FEATURE_RO_COMPAT_BTREE_DIR	0x0004
+#define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
 
 #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
@@ -613,6 +614,7 @@ static inline int ext4_valid_inum(struct
 					 EXT4_FEATURE_INCOMPAT_64BIT)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
+					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
 					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR)
 
 /*


Thanks,
Kalpak Shah.
