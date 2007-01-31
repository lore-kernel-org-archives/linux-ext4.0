From: Harry Papaxenopoulos <harry@cs.sunysb.edu>
Subject: [Resubmit][PATCH 2/5] Secure Deletion and Trash-Bin Support for Ext4
Date: Wed, 31 Jan 2007 09:53:16 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0701310951350.28263@compserv1>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ezk@cs.sunysb.edu, kolya@cs.sunysb.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sbcs.sunysb.edu ([130.245.1.15]:59752 "EHLO sbcs.cs.sunysb.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933309AbXAaOxS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Jan 2007 09:53:18 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Trash-Bin Functionality for the ext2 filesystem:

Signed-off-by: Harry Papaxenopoulos <harry@cs.sunysb.edu>
Signed-off-by: Nikolai Joukov <kolya@cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

Index: sdfs/src/linux-2.6.20-rc6-trashbin/fs/ext2/super.c
===================================================================
--- sdfs.orig/src/linux-2.6.20-rc6-trashbin/fs/ext2/super.c
+++ sdfs/src/linux-2.6.20-rc6-trashbin/fs/ext2/super.c
@@ -29,6 +29,7 @@
 #include <linux/vfs.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
+#include <linux/trashbin.h>
 #include <asm/uaccess.h>
 #include "ext2.h"
 #include "xattr.h"
@@ -934,6 +935,10 @@ static int ext2_fill_super(struct super_
 	if (EXT2_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_HAS_JOURNAL))
 		ext2_warning(sb, __FUNCTION__,
 			"mounting ext3 filesystem as ext2");
+#ifdef CONFIG_EXT2_FS_TRASHBIN
+	if ((sb->s_flags & MNT_TRASHBIN) && vfs_create_trash_bin(sb))
+		goto failed_mount3;
+#endif
 	ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY);
 	return 0;

Index: sdfs/src/linux-2.6.20-rc6-trashbin/fs/ext2/namei.c
===================================================================
--- sdfs.orig/src/linux-2.6.20-rc6-trashbin/fs/ext2/namei.c
+++ sdfs/src/linux-2.6.20-rc6-trashbin/fs/ext2/namei.c
@@ -31,6 +31,8 @@
  */

 #include <linux/pagemap.h>
+#include <linux/mount.h>
+#include <linux/trashbin.h>
 #include "ext2.h"
 #include "xattr.h"
 #include "acl.h"
@@ -256,19 +258,54 @@ static int ext2_unlink(struct inode * di
 	struct ext2_dir_entry_2 * de;
 	struct page * page;
 	int err = -ENOENT;
+	int trashed = 0;
+#ifdef CONFIG_EXT2_FS_TRASHBIN
+	struct dentry *user_dentry = NULL;
+#endif

 	de = ext2_find_entry (dir, dentry, &page);
 	if (!de)
 		goto out;
+#ifdef CONFIG_EXT2_FS_TRASHBIN
+	if ((dentry->d_inode->i_sb->s_flags & MNT_TRASHBIN) &&
+		(EXT2_I(dentry->d_inode)->i_flags &
+		 (EXT2_UNRM_FL | EXT2_SECRM_FL))) {
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
+			err = PTR_ERR(user_dentry);
+			user_dentry = NULL;
+			goto out;
+		}

-	err = ext2_delete_entry (de, page);
+		if (inode->i_nlink == 1 && user_dentry->d_inode &&
+			   	user_dentry->d_inode->i_ino != dir->i_ino) {
+			err = vfs_trash_entry(dir, dentry);
+			trashed = 1;
+		}
+	}
+#endif
+	if (!trashed)
+		err = ext2_delete_entry (de, page);
 	if (err)
 		goto out;

 	inode->i_ctime = dir->i_ctime;
-	inode_dec_link_count(inode);
+	if (!trashed)
+		inode_dec_link_count(inode);
 	err = 0;
 out:
+#ifdef CONFIG_EXT2_FS_TRASHBIN
+	if (user_dentry)
+		dput(user_dentry);
+#endif
 	return err;
 }

Index: sdfs/src/linux-2.6.20-rc6-trashbin/fs/Kconfig
===================================================================
--- sdfs.orig/src/linux-2.6.20-rc6-trashbin/fs/Kconfig
+++ sdfs/src/linux-2.6.20-rc6-trashbin/fs/Kconfig
@@ -76,6 +76,15 @@ config FS_XIP
 	depends on EXT2_FS_XIP
 	default y

+config EXT2_FS_TRASHBIN
+	bool "Ext2 trashbin functionality"
+	depends on TRASHBIN
+	depends on EXT2_FS
+	help
+	  Trashbin functionality for the ext2 filesystem
+
+	  If unsure, say N.
+
 config EXT3_FS
 	tristate "Ext3 journalling file system support"
 	select JBD
