From: Harry Papaxenopoulos <harry@cs.sunysb.edu>
Subject: [Resubmit][PATCH 4/5] Secure Deletion and Trash-Bin Support for Ext4
Date: Wed, 31 Jan 2007 09:55:08 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0701310954240.28263@compserv1>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ezk@cs.sunysb.edu, kolya@cs.sunysb.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sbcs.cs.sunysb.edu ([130.245.1.15]:59790 "EHLO
	sbcs.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933318AbXAaOzL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Jan 2007 09:55:11 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Trash-Bin Functionality for the ext4 filesystem:

Signed-off-by: Harry Papaxenopoulos <harry@cs.sunysb.edu>
Signed-off-by: Nikolai Joukov <kolya@cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

Index: sdfs/src/linux-2.6.20-rc6-trashbin/fs/ext4/super.c
===================================================================
--- sdfs.orig/src/linux-2.6.20-rc6-trashbin/fs/ext4/super.c
+++ sdfs/src/linux-2.6.20-rc6-trashbin/fs/ext4/super.c
@@ -35,6 +35,7 @@
 #include <linux/namei.h>
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
+#include <linux/trashbin.h>

 #include <asm/uaccess.h>

@@ -1846,6 +1847,11 @@ static int ext4_fill_super (struct super
 		goto failed_mount4;
 	}

+#ifdef CONFIG_EXT4DEV_FS_TRASHBIN
+	if ((sb->s_flags & MNT_TRASHBIN) && vfs_create_trash_bin(sb))
+		goto failed_mount4;
+#endif
+
 	ext4_setup_super (sb, es, sb->s_flags & MS_RDONLY);
 	/*
 	 * akpm: core read_super() calls in here with the superblock locked.
Index: sdfs/src/linux-2.6.20-rc6-trashbin/fs/ext4/namei.c
===================================================================
--- sdfs.orig/src/linux-2.6.20-rc6-trashbin/fs/ext4/namei.c
+++ sdfs/src/linux-2.6.20-rc6-trashbin/fs/ext4/namei.c
@@ -37,6 +37,8 @@
 #include <linux/buffer_head.h>
 #include <linux/bio.h>
 #include <linux/smp_lock.h>
+#include <linux/mount.h>
+#include <linux/trashbin.h>

 #include "namei.h"
 #include "xattr.h"
@@ -2077,6 +2079,10 @@ static int ext4_unlink(struct inode * di
 	struct buffer_head * bh;
 	struct ext4_dir_entry_2 * de;
 	handle_t *handle;
+	int trashed = 0;
+#ifdef CONFIG_EXT4DEV_FS_TRASHBIN
+	struct dentry *user_dentry = NULL;
+#endif

 	/* Initialize quotas before so that eventual writes go
 	 * in separate transaction */
@@ -2105,13 +2111,41 @@ static int ext4_unlink(struct inode * di
 			      inode->i_ino, inode->i_nlink);
 		inode->i_nlink = 1;
 	}
-	retval = ext4_delete_entry(handle, dir, de, bh);
+#ifdef CONFIG_EXT4DEV_FS_TRASHBIN
+	if ((dentry->d_inode->i_sb->s_flags & MNT_TRASHBIN) &&
+				(EXT4_I(dentry->d_inode)->i_flags &
+				(EXT4_UNRM_FL | EXT4_SECRM_FL))) {
+
+		/*
+		 * We put this code here to optimize the common case. Since
+		 * lookups are expensive, we try to reserve from making any,
+		 * unless one of the trash-bin flags are set. The cleanest
+		 * way though is to probably move this code outside the
+		 * above if statement.
+		 */
+		user_dentry = vfs_get_user_dentry(dir, 1);
+		if (IS_ERR(user_dentry)) {
+			retval = PTR_ERR(user_dentry);
+			user_dentry = NULL;
+			goto end_unlink;
+		}
+
+		if (inode->i_nlink == 1 && user_dentry->d_inode &&
+			   	user_dentry->d_inode->i_ino != dir->i_ino) {
+			retval = vfs_trash_entry(dir, dentry);
+			trashed = 1;
+		}
+	}
+#endif
+	if (!trashed)
+		retval = ext4_delete_entry(handle, dir, de, bh);
 	if (retval)
 		goto end_unlink;
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
 	ext4_update_dx_flag(dir);
 	ext4_mark_inode_dirty(handle, dir);
-	drop_nlink(inode);
+	if (!trashed)
+		drop_nlink(inode);
 	if (!inode->i_nlink)
 		ext4_orphan_add(handle, inode);
 	inode->i_ctime = dir->i_ctime;
@@ -2121,6 +2155,10 @@ static int ext4_unlink(struct inode * di
 end_unlink:
 	ext4_journal_stop(handle);
 	brelse (bh);
+#ifdef CONFIG_EXT4DEV_FS_TRASHBIN
+	if (user_dentry)
+		dput(user_dentry);
+#endif
 	return retval;
 }

Index: sdfs/src/linux-2.6.20-rc6-trashbin/fs/Kconfig
===================================================================
--- sdfs.orig/src/linux-2.6.20-rc6-trashbin/fs/Kconfig
+++ sdfs/src/linux-2.6.20-rc6-trashbin/fs/Kconfig
@@ -227,6 +227,15 @@ config EXT4DEV_FS_SECURITY
 	  If you are not using a security module that requires using
 	  extended attributes for file security labels, say N.

+config EXT4DEV_FS_TRASHBIN
+	bool "Ext4 trashbin functionality"
+	depends on TRASHBIN
+	depends on EXT4DEV_FS
+	help
+	  Trashbin functionality for the ext4 filesystem
+
+	  If unsure, say N.
+
 config JBD
 	tristate
 	help
