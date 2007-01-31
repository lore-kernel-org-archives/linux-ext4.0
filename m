From: Harry Papaxenopoulos <harry@cs.sunysb.edu>
Subject: [Resubmit][PATCH 1/5] Secure Deletion and Trash-Bin Support for Ext4
Date: Wed, 31 Jan 2007 09:51:04 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0701301244200.20954@compserv1>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ezk@cs.sunysb.edu, kolya@cs.sunysb.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sbcs.cs.sunysb.edu ([130.245.1.15]:59715 "EHLO
	sbcs.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933310AbXAaOvH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Jan 2007 09:51:07 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Note:
-----
These patches are being resubmitted as part of the call for all ext4
patches.  It uses the 2.6.20-rc6 version as its base.  All the changes
that have been requested are completed.

Original patch description:
---------------------------
The patch moves the files marked with the -s (secure deletion) or the -u
(undelete) ext2/3/4 attributes to a .trash/<uid>/ directory.  It does so
reliably because it does it in the kernel upon every unlink operation.
User-mode tools can miss some unlinks, which is unacceptable for secure
deletion.  The per-user subdirectories allow us to solve the problem
with permissions.  The .trash directory is owned by root and has
drwxr-xr-x permissions.  The per-uid subdirectories are owned and only
accessible by their corresponding owners (drwx------) so users cannot
read each other's files in the trash.  Alternative solutions would
require changing a lot of ext3 code.

Right now we do not store the whole path to the file moved into the
trash-bin.  We keep the filenames or append them with numbers in case of
collisions.  In the future we may change it to store the whole path
information if necessary.

Later (e.g., when the system is idle) a user-mode daemon can just scan
.trash's subdirectories, overwrite the files marked with -s, and unlink
the files.  The purging and data overwriting is performed entirely in user
space.  It may or may not be necessary to add a mechanism for the file
system to initiate the user-mode deletion once the space becomes scarce.

The benefits of this secure deletion approach are obvious:
1) small kernel patch;
2) two solutions (trash-bin and secure deletion) in one;
3) the user-mode part can be made arbitrarily complex and overwrite with
  many patterns, many times, and at configurable times; and
4) most of the code can be reused for other file systems in the future.


Changes from the last submission:
---------------------------------
1. Since most of the code is done in the vfs layer, we decided - as
suggested - to hook the vfs layer so we get a universal undelete
implementation for all filesystems.  All that needs to be done by the
underlying filesystem is simply make the undelete call at the necessary
points.
2. Filenames have been renamed to: trashbin.c and trashbin.h as
requested.
3. We have added Trash-Bin functionality for the following filesystems:
ext2, ext3, ext4, jfs.

We will really appreciate any comments, help, and feedback.

Thank you,
Harry Papaxenopoulos, Nikolai Joukov, and Erez Zadok.
Filesystems and Storage Laboratory,
Stony Brook University

Signed-off-by: Harry Papaxenopoulos <harry@cs.sunysb.edu>
Signed-off-by: Nikolai Joukov <kolya@cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

Index: sdfs/src/linux-2.6.20-rc6-trashbin/include/linux/trashbin.h
===================================================================
--- /dev/null
+++ sdfs/src/linux-2.6.20-rc6-trashbin/include/linux/trashbin.h
@@ -0,0 +1,16 @@
+/* include/linux/trashbin.h
+ *
+ * Copyright (C) 2007 Stony Brook University
+ * Harry Papaxenopoulos, Nikolai Joukov, and Erez Zadok
+ */
+
+#define TB_NAME ".trash"
+#define TB_NAME_LEN 6
+#define TB_MODE S_IRUGO | S_IXUGO | S_IRWXU | S_IFDIR
+#define TB_USER_MODE S_IRWXU | S_IFDIR
+#define TB_UID_MAX_LEN 6
+
+extern int vfs_create_trash_bin(struct super_block *);
+extern int vfs_trash_entry(struct inode *, struct dentry *);
+extern struct dentry *vfs_get_user_dentry(struct inode *old_dir, int create);
+
Index: sdfs/src/linux-2.6.20-rc6-trashbin/fs/trashbin.c
===================================================================
--- /dev/null
+++ sdfs/src/linux-2.6.20-rc6-trashbin/fs/trashbin.c
@@ -0,0 +1,241 @@
+/* fs/trashbin.c
+*
+* Copyright (C) 2007 Stony Brook University
+* Harry Papaxenopoulos, Nikolai Joukov, and Erez Zadok
+*/
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/trashbin.h>
+#include <asm/current.h>
+
+int vfs_create_trash_bin(struct super_block *sb)
+{
+       int err = 0;
+       struct dentry *dentry, *root_dentry;
+       struct inode *mnt_inode;
+
+       root_dentry = sb->s_root;
+       mnt_inode = root_dentry->d_inode;
+
+       dentry = lookup_one_len(TB_NAME, root_dentry, TB_NAME_LEN);
+
+       if (IS_ERR(dentry)) {
+	       err = PTR_ERR(dentry);
+	       goto out;
+       }
+
+       if (!dentry->d_inode && mnt_inode->i_op && mnt_inode->i_op->mkdir) {
+	       mutex_lock(&mnt_inode->i_mutex);
+	       err = mnt_inode->i_op->mkdir(mnt_inode, dentry, TB_MODE);
+	       mutex_unlock(&mnt_inode->i_mutex);
+	       if (err)
+		       goto release_out;
+       }
+
+       dentry->d_inode->i_mode = TB_MODE;
+       mark_inode_dirty(dentry->d_inode);
+release_out:
+       dput(dentry);
+out:
+       return err;
+}
+
+struct dentry *tb_sillyname(struct dentry *tb_dentry, struct dentry *dentry)
+{
+       unsigned sillycounter = 1;
+       char *silly = NULL;
+       char *tmp = NULL;
+       struct dentry *sdentry = NULL;
+
+       if (!tb_dentry || !tb_dentry->d_inode) {
+	       sdentry = ERR_PTR(-EIO);
+	       goto out;
+       }
+
+       silly = kmalloc(PATH_MAX, GFP_KERNEL);
+       if (!silly)
+	       goto out;
+
+       tmp = kmalloc(PATH_MAX, GFP_KERNEL);
+       if (!tmp)
+	       goto out;
+
+       sdentry = lookup_one_len(dentry->d_name.name, tb_dentry,
+				dentry->d_name.len);
+       if (IS_ERR(sdentry))
+	       goto out;
+
+       while (sdentry->d_inode != NULL) {
+	       if (PATH_MAX - 5 <= dentry->d_name.len)
+		       snprintf(tmp, PATH_MAX - 6, dentry->d_name.name);
+	       else
+		       sprintf(tmp, dentry->d_name.name);
+
+	       sprintf(silly, "%s_%u", dentry->d_name.name, sillycounter);
+	       dput(sdentry);
+	       sdentry = lookup_one_len(silly, tb_dentry, strlen(silly));
+	       if (IS_ERR(sdentry))
+		       goto out;
+	       sillycounter++;
+       }
+out:
+       kfree(silly);
+       kfree(tmp);
+       return sdentry;
+}
+
+struct dentry *vfs_get_user_dentry(struct inode *old_dir, int create)
+{
+       int err = 0;
+       struct dentry *user_dentry = NULL;
+       struct dentry *tb_dentry = NULL;
+       struct dentry *root_dentry = NULL;
+       char *name = NULL;
+       struct inode *tb_inode;
+
+       if (old_dir && old_dir->i_sb && old_dir->i_sb->s_root)
+	       root_dentry = old_dir->i_sb->s_root;
+       else {
+	       user_dentry = ERR_PTR(-EIO);
+	       goto out;
+       }
+
+       tb_dentry = lookup_one_len(TB_NAME, root_dentry, TB_NAME_LEN);
+       if (IS_ERR(tb_dentry)) {
+	       user_dentry = tb_dentry;
+	       tb_dentry = NULL;
+	       goto out;
+       }
+
+       tb_inode = tb_dentry->d_inode;
+       if (!tb_inode) {
+	       user_dentry = ERR_PTR(-EIO);
+	       goto out;
+       }
+
+       name = kmalloc(TB_UID_MAX_LEN, GFP_KERNEL);
+       if (!name)
+	       goto out;
+
+       sprintf(name, "%d", current->fsuid);
+
+       user_dentry = lookup_one_len(name, tb_dentry, strlen(name));
+       if (IS_ERR(user_dentry))
+	       goto out;
+
+       if (!user_dentry->d_inode & create) {
+       if (tb_inode && tb_inode->i_op && tb_inode->i_op->permission)
+		       err = tb_inode->i_op->permission(tb_inode,
+					       MAY_EXEC, NULL);
+	       else
+		       err = generic_permission(tb_inode,
+					       MAY_EXEC, NULL);
+	       if (err) {
+		       user_dentry = ERR_PTR(err);
+		       goto out;
+	       }
+
+	       mutex_lock(&tb_inode->i_mutex);
+	       err = tb_inode->i_op->mkdir(tb_inode, user_dentry, TB_USER_MODE);
+	       mutex_unlock(&tb_inode->i_mutex);
+	       if (err) {
+		       user_dentry = ERR_PTR(err);
+		       goto out;
+	       }
+       }
+
+out:
+       kfree(name);
+       if (tb_dentry)
+	       dput(tb_dentry);
+       return user_dentry;
+}
+
+int vfs_trash_entry(struct inode *old_dir, struct dentry *old_dentry)
+{
+       int err = 0;
+       struct dentry *new_dentry = NULL;
+       struct dentry *user_dentry = NULL;
+       struct dentry *tb_dentry = NULL;
+       struct dentry *root_dentry = NULL;
+       struct inode *user_inode;
+       struct inode *tb_inode;
+
+       if (old_dir && old_dir->i_sb && old_dir->i_sb->s_root)
+	       root_dentry = old_dir->i_sb->s_root;
+       else {
+	       err = -EIO;
+	       goto out;
+       }
+
+       tb_dentry = lookup_one_len(TB_NAME, root_dentry, TB_NAME_LEN);
+       if (IS_ERR(tb_dentry)) {
+	       err = PTR_ERR(tb_dentry);
+	       tb_dentry = NULL;
+	       goto out;
+       }
+
+       tb_inode = tb_dentry->d_inode;
+       if (!tb_inode) {
+	       err = -EIO;
+	       goto out;
+       }
+
+
+       user_dentry = vfs_get_user_dentry(old_dir, 1);
+       if (IS_ERR(user_dentry)) {
+	       err = PTR_ERR(user_dentry);
+	       user_dentry = NULL;
+	       goto out;
+       }
+
+       user_inode = user_dentry->d_inode;
+
+       new_dentry = tb_sillyname(user_dentry, old_dentry);
+       if (IS_ERR(new_dentry)) {
+	       err = PTR_ERR(new_dentry);
+	       new_dentry = NULL;
+	       goto out;
+       }
+
+       if (tb_inode && tb_inode->i_op && tb_inode->i_op->permission)
+	       err = tb_inode->i_op->permission(user_inode,
+					       MAY_WRITE | MAY_EXEC, NULL);
+       else
+	       err = generic_permission(user_inode, MAY_WRITE | MAY_EXEC,NULL);
+
+       if (err)
+	       goto out;
+
+       if (user_inode->i_op && user_inode->i_op->rename) {
+	       mutex_lock(&user_inode->i_mutex);
+	       err = user_inode->i_op->rename(old_dir, old_dentry,
+					       user_inode, new_dentry);
+	       mutex_unlock(&user_inode->i_mutex);
+	       if (!err)
+		       d_move(old_dentry, new_dentry);
+       } else {
+	       err = -ENOSYS;
+	       goto out;
+       }
+
+       if (!d_unhashed(old_dentry))
+	       d_drop(old_dentry);
+
+out:
+       if (new_dentry)
+	       dput(new_dentry);
+       if (user_dentry)
+	       dput(user_dentry);
+       if (tb_dentry)
+	       dput(tb_dentry);
+       return err;
+}
+
+
+EXPORT_SYMBOL(vfs_create_trash_bin);
+EXPORT_SYMBOL(vfs_trash_entry);
+EXPORT_SYMBOL(vfs_get_user_dentry);
+
Index: sdfs/src/linux-2.6.20-rc6-trashbin/include/linux/fs.h
===================================================================
--- sdfs.orig/src/linux-2.6.20-rc6-trashbin/include/linux/fs.h
+++ sdfs/src/linux-2.6.20-rc6-trashbin/include/linux/fs.h
@@ -121,6 +121,7 @@ extern int dir_notify_enable;
 #define MS_SLAVE	(1<<19)	/* change to slave */
 #define MS_SHARED	(1<<20)	/* change to shared */
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
+#define MS_TRASHBIN	(1<<22) /* VFS trashbin functionality */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)

Index: sdfs/src/linux-2.6.20-rc6-trashbin/fs/Makefile
===================================================================
--- sdfs.orig/src/linux-2.6.20-rc6-trashbin/fs/Makefile
+++ sdfs/src/linux-2.6.20-rc6-trashbin/fs/Makefile
@@ -59,6 +59,8 @@ obj-y				+= devpts/

 obj-$(CONFIG_PROFILING)		+= dcookies.o
 obj-$(CONFIG_DLM)		+= dlm/
+
+obj-$(CONFIG_TRASHBIN)		+= trashbin.o

 # Do not add any filesystems before this line
 obj-$(CONFIG_REISERFS_FS)	+= reiserfs/
Index: sdfs/src/linux-2.6.20-rc6-trashbin/fs/Kconfig
===================================================================
--- sdfs.orig/src/linux-2.6.20-rc6-trashbin/fs/Kconfig
+++ sdfs/src/linux-2.6.20-rc6-trashbin/fs/Kconfig
@@ -6,6 +6,14 @@ menu "File systems"

 if BLOCK

+config TRASHBIN
+	bool "Trash-bin functionality"
+	help
+	  Trash bin functionality enables users to easily recover previously
+	  deleted files.
+
+	  If you are unsure, say N.
+
 config EXT2_FS
 	tristate "Second extended fs support"
 	help
Index: sdfs/src/linux-2.6.20-rc6-trashbin/include/linux/mount.h
===================================================================
--- sdfs.orig/src/linux-2.6.20-rc6-trashbin/include/linux/mount.h
+++ sdfs/src/linux-2.6.20-rc6-trashbin/include/linux/mount.h
@@ -28,6 +28,7 @@ struct mnt_namespace;
 #define MNT_NOATIME	0x08
 #define MNT_NODIRATIME	0x10
 #define MNT_RELATIME	0x20
+#define MNT_TRASHBIN	0x40

 #define MNT_SHRINKABLE	0x100
