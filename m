From: Harry Papaxenopoulos <harry@cs.sunysb.edu>
Subject: [Resubmit][PATCH 3/5] Secure Deletion and Trash-Bin Support for Ext4
Date: Wed, 31 Jan 2007 09:54:11 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0701310953210.28263@compserv1>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ezk@cs.sunysb.edu, kolya@cs.sunysb.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sbcs.sunysb.edu ([130.245.1.15]:59775 "EHLO sbcs.cs.sunysb.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933314AbXAaOyP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Jan 2007 09:54:15 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Trash-Bin Functionality for the ext3 filesystem:

Signed-off-by: Harry Papaxenopoulos <harry@cs.sunysb.edu>
Signed-off-by: Nikolai Joukov <kolya@cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

Index: sdfs/src/linux-2.6.20-rc6-trashbin/fs/ext3/super.c
===================================================================
--- sdfs.orig/src/linux-2.6.20-rc6-trashbin/fs/ext3/super.c
+++ sdfs/src/linux-2.6.20-rc6-trashbin/fs/ext3/super.c
@@ -35,6 +35,7 @@
 #include <linux/namei.h>
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
+#include <linux/trashbin.h>

 #include <asm/uaccess.h>

@@ -1773,6 +1774,11 @@ static int ext3_fill_super (struct super
 		goto failed_mount4;
 	}

+#ifdef CONFIG_EXT3_FS_TRASHBIN
+	if ((sb->s_flags & MNT_TRASHBIN) && vfs_create_trash_bin(sb))
+		goto failed_mount4;
+#endif
+
 	ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
 	/*
 	 * akpm: core read_super() calls in here with the superblock locked.
Index: sdfs/src/linux-2.6.20-rc6-trashbin/fs/ext3/namei.c
===================================================================
--- sdfs.orig/src/linux-2.6.20-rc6-trashbin/fs/ext3/namei.c
+++ sdfs/src/linux-2.6.20-rc6-trashbin/fs/ext3/namei.c
@@ -37,6 +37,8 @@
 #include <linux/buffer_head.h>
 #include <linux/bio.h>
 #include <linux/smp_lock.h>
+#include <linux/mount.h>
+#include <linux/trashbin.h>

 #include "namei.h"
 #include "xattr.h"
@@ -2079,6 +2081,10 @@ static int ext3_unlink(struct inode * di
 	struct buffer_head * bh;
 	struct ext3_dir_entry_2 * de;
 	handle_t *handle;
+	int trashed = 0;
+#ifdef CONFIG_EXT3_FS_TRASHBIN
+	struct dentry *user_dentry = NULL;
+#endif

 	/* Initialize quotas before so that eventual writes go
 	 * in separate transaction */
@@ -2107,13 +2113,41 @@ static int ext3_unlink(struct inode * di
 			      inode->i_ino, inode->i_nlink);
 		inode->i_nlink = 1;
 	}
-	retval = ext3_delete_entry(handle, dir, de, bh);
+#ifdef CONFIG_EXT3_FS_TRASHBIN
+	if ((dentry->d_inode->i_sb->s_flags & MNT_TRASHBIN) &&
+			(EXT3_I(dentry->d_inode)->i_flags &
+			(EXT3_UNRM_FL | EXT3_SECRM_FL))) {
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
+		retval = ext3_delete_entry(handle, dir, de, bh);
 	if (retval)
 		goto end_unlink;
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
 	ext3_update_dx_flag(dir);
 	ext3_mark_inode_dirty(handle, dir);
-	drop_nlink(inode);
+	if (!trashed)
+		drop_nlink(inode);
 	if (!inode->i_nlink)
 		ext3_orphan_add(handle, inode);
 	inode->i_ctime = dir->i_ctime;
@@ -2122,6 +2156,10 @@ static int ext3_unlink(struct inode * di

 end_unlink:
 	ext3_journal_stop(handle);
+#ifdef CONFIG_EXT4DEV_FS_TRASHBIN
+	if (user_dentry)
+		dput(user_dentry);
+#endif
 	brelse (bh);
 	return retval;
 }
Index: sdfs/src/linux-2.6.20-rc6-trashbin/fs/Kconfig
===================================================================
--- sdfs.orig/src/linux-2.6.20-rc6-trashbin/fs/Kconfig
+++ sdfs/src/linux-2.6.20-rc6-trashbin/fs/Kconfig
@@ -153,6 +153,15 @@ config EXT3_FS_SECURITY
 	  If you are not using a security module that requires using
 	  extended attributes for file security labels, say N.

+config EXT3_FS_TRASHBIN
+	bool "Ext3 trashbin functionality"
+	depends on TRASHBIN
+	depends on EXT3_FS
+	help
+	  Trashbin functionality for the ext3 filesystem
+
+	  If unsure, say N.
+
 config EXT4DEV_FS
 	tristate "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
