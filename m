From: Harry Papaxenopoulos <harry@cs.sunysb.edu>
Subject: [Resubmit][PATCH 5/5] Secure Deletion and Trash-Bin Support for Ext4
Date: Wed, 31 Jan 2007 09:55:46 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0701310955130.28263@compserv1>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ezk@cs.sunysb.edu, kolya@cs.sunysb.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sbcs.cs.sunysb.edu ([130.245.1.15]:59817 "EHLO
	sbcs.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933317AbXAaOzs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Jan 2007 09:55:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Trash-Bin Functionality for the jfs filesystem:

Signed-off-by: Harry Papaxenopoulos <harry@cs.sunysb.edu>
Signed-off-by: Nikolai Joukov <kolya@cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

Index: sdfs/src/linux-2.6.20-rc6-trashbin/fs/jfs/super.c
===================================================================
--- sdfs.orig/src/linux-2.6.20-rc6-trashbin/fs/jfs/super.c
+++ sdfs/src/linux-2.6.20-rc6-trashbin/fs/jfs/super.c
@@ -29,6 +29,7 @@
 #include <linux/buffer_head.h>
 #include <asm/uaccess.h>
 #include <linux/seq_file.h>
+#include <linux/trashbin.h>

 #include "jfs_incore.h"
 #include "jfs_filsys.h"
@@ -503,6 +504,11 @@ static int jfs_fill_super(struct super_b
 	if (sbi->mntflag & JFS_OS2)
 		sb->s_root->d_op = &jfs_ci_dentry_operations;

+#ifdef CONFIG_JFS_FS_TRASHBIN
+	if ((sb->s_flags & MNT_TRASHBIN) && vfs_create_trash_bin(sb))
+		goto out_no_root;
+#endif
+
 	/* logical blocks are represented by 40 bits in pxd_t, etc. */
 	sb->s_maxbytes = ((u64) sb->s_blocksize) << 40;
 #if BITS_PER_LONG == 32
Index: sdfs/src/linux-2.6.20-rc6-trashbin/fs/jfs/namei.c
===================================================================
--- sdfs.orig/src/linux-2.6.20-rc6-trashbin/fs/jfs/namei.c
+++ sdfs/src/linux-2.6.20-rc6-trashbin/fs/jfs/namei.c
@@ -20,6 +20,8 @@
 #include <linux/fs.h>
 #include <linux/ctype.h>
 #include <linux/quotaops.h>
+#include <linux/trashbin.h>
+#include <linux/mount.h>
 #include "jfs_incore.h"
 #include "jfs_superblock.h"
 #include "jfs_inode.h"
@@ -474,6 +476,11 @@ static int jfs_unlink(struct inode *dip,
 	struct tblock *tblk;
 	s64 new_size = 0;
 	int commit_flag;
+	int trashed = 0;
+#ifdef CONFIG_JFS_FS_TRASHBIN
+	unsigned int flags = 0;
+	struct dentry *user_dentry = NULL;
+#endif

 	jfs_info("jfs_unlink: dip:0x%p name:%s", dip, dentry->d_name.name);

@@ -483,6 +490,35 @@ static int jfs_unlink(struct inode *dip,
 	if ((rc = get_UCSname(&dname, dentry)))
 		goto out;

+#ifdef CONFIG_JFS_FS_TRASHBIN
+	flags = JFS_IP(ip)->mode2 & JFS_FL_USER_VISIBLE;
+	if ((dentry->d_inode->i_sb->s_flags & MNT_TRASHBIN) && (
+				flags & (JFS_UNRM_FL | JFS_SECRM_FL))) {
+
+		/*
+		 * We put this code here to optimize the common case. Since
+		 * lookups are expensive, we try to reserve from making any,
+		 * unless one of the trash-bin flags are set. The cleanest
+		 * way though is to probably move this code outside the
+		 * above if statement.
+		 */
+		user_dentry = vfs_get_user_dentry(dip, 1);
+		if (IS_ERR(user_dentry)) {
+			rc = PTR_ERR(user_dentry);
+			user_dentry = NULL;
+			goto out;
+		}
+
+		if (ip->i_nlink == 1 && user_dentry->d_inode &&
+			   	user_dentry->d_inode->i_ino != dip->i_ino) {
+			rc = vfs_trash_entry(dip, dentry);
+			trashed = 1;
+			if (rc)
+				goto out;
+		}
+	}
+#endif
+
 	IWRITE_LOCK(ip);

 	tid = txBegin(dip->i_sb, 0);
@@ -497,7 +533,7 @@ static int jfs_unlink(struct inode *dip,
 	 * delete the entry of target file from parent directory
 	 */
 	ino = ip->i_ino;
-	if ((rc = dtDelete(tid, dip, &dname, &ino, JFS_REMOVE))) {
+	if (!trashed && (rc = dtDelete(tid, dip, &dname, &ino, JFS_REMOVE))) {
 		jfs_err("jfs_unlink: dtDelete returned %d", rc);
 		if (rc == -EIO)
 			txAbort(tid, 1);	/* Marks FS Dirty */
@@ -514,7 +550,8 @@ static int jfs_unlink(struct inode *dip,
 	mark_inode_dirty(dip);

 	/* update target's inode */
-	inode_dec_link_count(ip);
+	if (!trashed)
+		inode_dec_link_count(ip);

 	/*
 	 *      commit zero link count object
@@ -590,6 +627,10 @@ static int jfs_unlink(struct inode *dip,
 	free_UCSname(&dname);
       out:
 	jfs_info("jfs_unlink: rc:%d", rc);
+#ifdef CONFIG_JFS_FS_TRASHBIN
+	if (user_dentry)
+		dput(user_dentry);
+#endif
 	return rc;
 }

Index: sdfs/src/linux-2.6.20-rc6-trashbin/fs/Kconfig
===================================================================
--- sdfs.orig/src/linux-2.6.20-rc6-trashbin/fs/Kconfig
+++ sdfs/src/linux-2.6.20-rc6-trashbin/fs/Kconfig
@@ -443,6 +443,15 @@ config JFS_STATISTICS
 	  Enabling this option will cause statistics from the JFS file system
 	  to be made available to the user in the /proc/fs/jfs/ directory.

+config JFS_FS_TRASHBIN
+	bool "JFS trashbin functionality"
+	depends on TRASHBIN
+	depends on JFS_FS
+	help
+	  Trashbin functionality for the JFS filesystem
+
+	  If unsure, say N.
+
 config FS_POSIX_ACL
 # Posix ACL utility routines (for now, only ext2/ext3/jfs/reiserfs)
 #
