From: Nikolai Joukov <kolya@cs.sunysb.edu>
Subject: [RFC][PATCH] Secure Deletion and Trash-Bin Support for Ext4
Date: Mon, 4 Dec 2006 13:33:55 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0612041256180.15321@compserv1>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sbcs.cs.sunysb.edu ([130.245.1.15]:47350 "EHLO
	sbcs.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937246AbWLDSd6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Dec 2006 13:33:58 -0500
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

As we promised on the linux-ext4 list on October 31, here is the patch
that adds secure deletion via a trash-bin functionality for ext4.  It is a
compromise solution that combines secure deletion with the trash-bin support
(the latter had been requested by even more people than the former :-).

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

We will really appreciate any comments, help, and feedback.

Thank you,
Nikolai Joukov, Harry Papaxenopoulos, and Erez Zadok.
Filesystems and Storage Laboratory,
Stony Brook University

Signed-off-by: Nikolai Joukov <kolya@cs.sunysb.edu>
Signed-off-by: Harry Papaxenopoulos <harry@cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/ext4/Makefile    |    1 +
 fs/ext4/namei.c     |   40 ++++++-
 fs/ext4/super.c     |    6 +
 fs/ext4/tb.c        |  237 +++++++++++++++++++++++++++++++++++++++
 fs/ext4/tb.h        |   18 +++
 fs/Kconfig          |    9 +
 6 files changed, 309 insertions(+), 2 deletions(-)

diff -Naur 2.6.19/fs/ext4/Makefile 2.6.19tb/fs/ext4/Makefile
--- 2.6.19/fs/ext4/Makefile	2006-12-02 19:49:53.000000000 -0500
+++ 2.6.19tb/fs/ext4/Makefile	2006-12-02 19:46:13.000000000 -0500
@@ -10,3 +10,4 @@
 ext4dev-$(CONFIG_EXT4DEV_FS_XATTR)	+= xattr.o xattr_user.o xattr_trusted.o
 ext4dev-$(CONFIG_EXT4DEV_FS_POSIX_ACL)	+= acl.o
 ext4dev-$(CONFIG_EXT4DEV_FS_SECURITY)	+= xattr_security.o
+ext4dev-$(CONFIG_EXT4DEV_FS_TRASH_BIN)	+= tb.o
diff -Naur 2.6.19/fs/ext4/namei.c 2.6.19tb/fs/ext4/namei.c
--- 2.6.19/fs/ext4/namei.c	2006-12-02 19:49:49.000000000 -0500
+++ 2.6.19tb/fs/ext4/namei.c	2006-12-04 13:03:35.000000000 -0500
@@ -41,6 +41,7 @@
 #include "namei.h"
 #include "xattr.h"
 #include "acl.h"
+#include "tb.h"

 /*
  * define how far ahead to read directories while searching them.
@@ -2067,6 +2068,10 @@
 	struct inode * inode;
 	struct buffer_head * bh;
 	struct ext4_dir_entry_2 * de;
+	int trashed = 0;
+#ifdef CONFIG_EXT4DEV_FS_TRASH_BIN
+	struct dentry *user_dentry = NULL;
+#endif
 	handle_t *handle;

 	/* Initialize quotas before so that eventual writes go
@@ -2096,13 +2101,40 @@
 			      inode->i_ino, inode->i_nlink);
 		inode->i_nlink = 1;
 	}
-	retval = ext4_delete_entry(handle, dir, de, bh);
+#ifdef CONFIG_EXT4DEV_FS_TRASH_BIN
+	if (EXT4_I(dentry->d_inode)->i_flags &
+					(EXT4_UNRM_FL | EXT4_SECRM_FL)) {
+
+		/*
+		 * We put this code here to optimize the common case. Since
+		 * lookups are expensive, we try to reserve from making any,
+		 * unless one of the trash-bin flags are set. The cleanest
+		 * way though is to probably move this code outside the
+		 * above if statement.
+		 */
+		user_dentry = ext4_get_user_dentry(dir, 1);
+		if (IS_ERR(user_dentry)) {
+			retval = PTR_ERR(user_dentry);
+			user_dentry = NULL;
+			goto end_unlink;
+		}
+
+		if (inode->i_nlink == 1 && user_dentry->d_inode &&
+			   	user_dentry->d_inode->i_ino != dir->i_ino) {
+			retval = ext4_trash_entry(dir, dentry);
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
@@ -2112,6 +2144,10 @@
 end_unlink:
 	ext4_journal_stop(handle);
 	brelse (bh);
+#ifdef CONFIG_EXT4DEV_FS_TRASH_BIN
+	if (user_dentry)
+		dput(user_dentry);
+#endif
 	return retval;
 }

diff -Naur 2.6.19/fs/ext4/super.c 2.6.19tb/fs/ext4/super.c
--- 2.6.19/fs/ext4/super.c	2006-12-02 19:49:49.000000000 -0500
+++ 2.6.19tb/fs/ext4/super.c	2006-12-03 21:09:05.000000000 -0500
@@ -41,6 +41,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "namei.h"
+#include "tb.h"

 static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
 			     unsigned long journal_devnum);
@@ -1840,6 +1841,11 @@
 		goto failed_mount4;
 	}

+#ifdef CONFIG_EXT4DEV_FS_TRASH_BIN
+        if (ext4_create_tb(sb))
+                goto failed_mount4;
+#endif
+
 	ext4_setup_super (sb, es, sb->s_flags & MS_RDONLY);
 	/*
 	 * akpm: core read_super() calls in here with the superblock locked.
diff -Naur 2.6.19/fs/ext4/tb.c 2.6.19tb/fs/ext4/tb.c
--- 2.6.19/fs/ext4/tb.c	1969-12-31 19:00:00.000000000 -0500
+++ 2.6.19tb/fs/ext4/tb.c	2006-12-04 13:03:35.000000000 -0500
@@ -0,0 +1,237 @@
+/*  linux/fs/ext4/tb.c
+ *
+ * Copyright (C) 2006 Stony Brook University
+ * Nikolai Joukov, Harry Papaxenopoulos, and Erez Zadok
+ */
+#include <linux/fs.h>
+#include <linux/jbd.h>
+#include <linux/ext3_fs.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <asm/current.h>
+#include "tb.h"
+
+int ext4_create_tb(struct super_block *sb)
+{
+	int err = 0;
+	struct dentry *dentry, *root_dentry;
+	struct inode *mnt_inode;
+
+	root_dentry = sb->s_root;
+	mnt_inode = root_dentry->d_inode;
+
+	dentry = lookup_one_len(TB_NAME, root_dentry, TB_NAME_LEN);
+
+	if (IS_ERR(dentry)) {
+		err = PTR_ERR(dentry);
+		goto out;
+	}
+
+	if (!dentry->d_inode && mnt_inode->i_op && mnt_inode->i_op->mkdir)
{
+		mutex_lock(&mnt_inode->i_mutex);
+		err = mnt_inode->i_op->mkdir(mnt_inode, dentry, TB_MODE);
+		mutex_unlock(&mnt_inode->i_mutex);
+		if (err)
+			goto release_out;
+	}
+
+	dentry->d_inode->i_mode = TB_MODE;
+	mark_inode_dirty(dentry->d_inode);
+release_out:
+	dput(dentry);
+out:
+	return err;
+}
+
+struct dentry *tb_sillyname(struct dentry *tb_dentry, struct dentry
*dentry)
+{
+	unsigned sillycounter = 1;
+	char *silly = NULL;
+	char *tmp = NULL;
+	struct dentry *sdentry = NULL;
+
+	if (!tb_dentry || !tb_dentry->d_inode) {
+		sdentry = ERR_PTR(-EIO);
+		goto out;
+	}
+
+	silly = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!silly)
+		goto out;
+
+	tmp = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!tmp)
+		goto out;
+
+	sdentry = lookup_one_len(dentry->d_name.name, tb_dentry,
+				 dentry->d_name.len);
+	if (IS_ERR(sdentry))
+		goto out;
+
+	while (sdentry->d_inode != NULL) {
+		if (PATH_MAX - 5 <= dentry->d_name.len)
+			snprintf(tmp, PATH_MAX - 6, dentry->d_name.name);
+		else
+			sprintf(tmp, dentry->d_name.name);
+
+		sprintf(silly, "%s_%u", dentry->d_name.name, sillycounter);
+		dput(sdentry);
+		sdentry = lookup_one_len(silly, tb_dentry, strlen(silly));
+		if (IS_ERR(sdentry))
+			goto out;
+		sillycounter++;
+	}
+out:
+	kfree(silly);
+	kfree(tmp);
+	return sdentry;
+}
+
+struct dentry *ext4_get_user_dentry(struct inode *old_dir, int create)
+{
+	int err = 0;
+	struct dentry *user_dentry = NULL;
+	struct dentry *tb_dentry = NULL;
+	struct dentry *root_dentry = NULL;
+	char *name = NULL;
+	struct inode *tb_inode;
+
+	if (old_dir && old_dir->i_sb && old_dir->i_sb->s_root)
+		root_dentry = old_dir->i_sb->s_root;
+	else {
+		user_dentry = ERR_PTR(-EIO);
+		goto out;
+	}
+
+	tb_dentry = lookup_one_len(TB_NAME, root_dentry, TB_NAME_LEN);
+	if (IS_ERR(tb_dentry)) {
+		user_dentry = tb_dentry;
+		tb_dentry = NULL;
+		goto out;
+	}
+
+	tb_inode = tb_dentry->d_inode;
+	if (!tb_inode) {
+		user_dentry = ERR_PTR(-EIO);
+		goto out;
+	}
+
+	name = kmalloc(UID_MAX_LEN, GFP_KERNEL);
+	if (!name)
+		goto out;
+
+	sprintf(name, "%d", current->fsuid);
+
+	user_dentry = lookup_one_len(name, tb_dentry, strlen(name));
+	if (IS_ERR(user_dentry))
+		goto out;
+
+	if (!user_dentry->d_inode & create) {
+ 		if (tb_inode && tb_inode->i_op && tb_inode->i_op->permission)
+			err = tb_inode->i_op->permission(tb_inode,
+						MAY_EXEC, NULL);
+		else
+			err = generic_permission(tb_inode,
+						MAY_EXEC, NULL);
+		if (err) {
+			user_dentry = ERR_PTR(err);
+			goto out;
+		}
+
+		mutex_lock(&tb_inode->i_mutex);
+		err = tb_inode->i_op->mkdir(tb_inode, user_dentry, USER_MODE);
+		mutex_unlock(&tb_inode->i_mutex);
+		if (err) {
+			user_dentry = ERR_PTR(err);
+			goto out;
+		}
+	}
+
+out:
+	kfree(name);
+	if (tb_dentry)
+		dput(tb_dentry);
+	return user_dentry;
+}
+
+int ext4_trash_entry(struct inode *old_dir, struct dentry *old_dentry)
+{
+	int err = 0;
+	struct dentry *new_dentry = NULL;
+	struct dentry *user_dentry = NULL;
+	struct dentry *tb_dentry = NULL;
+	struct dentry *root_dentry = NULL;
+	struct inode *user_inode;
+	struct inode *tb_inode;
+
+	if (old_dir && old_dir->i_sb && old_dir->i_sb->s_root)
+		root_dentry = old_dir->i_sb->s_root;
+	else {
+		err = -EIO;
+		goto out;
+	}
+
+	tb_dentry = lookup_one_len(TB_NAME, root_dentry, TB_NAME_LEN);
+	if (IS_ERR(tb_dentry)) {
+		err = PTR_ERR(tb_dentry);
+		tb_dentry = NULL;
+		goto out;
+	}
+
+	tb_inode = tb_dentry->d_inode;
+	if (!tb_inode) {
+		err = -EIO;
+		goto out;
+	}
+
+
+	user_dentry = ext4_get_user_dentry(old_dir, 1);
+	if (IS_ERR(user_dentry)) {
+		err = PTR_ERR(user_dentry);
+		user_dentry = NULL;
+		goto out;
+	}
+
+	user_inode = user_dentry->d_inode;
+
+	new_dentry = tb_sillyname(user_dentry, old_dentry);
+	if (IS_ERR(new_dentry)) {
+		err = PTR_ERR(new_dentry);
+		new_dentry = NULL;
+		goto out;
+	}
+
+	if (tb_inode && tb_inode->i_op && tb_inode->i_op->permission)
+		err = tb_inode->i_op->permission(user_inode,
+						MAY_WRITE | MAY_EXEC, NULL);
+	else
+		err = generic_permission(user_inode, MAY_WRITE | MAY_EXEC, NULL);
+
+	if (err)
+		goto out;
+
+	if (user_inode->i_op && user_inode->i_op->rename) {
+		mutex_lock(&user_inode->i_mutex);
+		err = user_inode->i_op->rename(old_dir, old_dentry,
+						user_inode, new_dentry);
+		mutex_unlock(&user_inode->i_mutex);
+		if (!err)
+			d_move(old_dentry, new_dentry);
+	} else {
+		err = -ENOSYS;
+		goto out;
+	}
+
+	if (!d_unhashed(old_dentry))
+		d_drop(old_dentry);
+
+out:
+	if (new_dentry)
+		dput(new_dentry);
+	if (user_dentry)
+		dput(user_dentry);
+	if (tb_dentry)
+		dput(tb_dentry);
+	return err;
+}
+
diff -Naur 2.6.19/fs/ext4/tb.h 2.6.19tb/fs/ext4/tb.h
--- 2.6.19/fs/ext4/tb.h	1969-12-31 19:00:00.000000000 -0500
+++ 2.6.19tb/fs/ext4/tb.h	2006-12-03 21:09:05.000000000 -0500
@@ -0,0 +1,18 @@
+/*  linux/fs/ext4/tb.h
+ *
+ * Copyright (C) 2006 Stony Brook University
+ * Nikolai Joukov, Harry Papaxenopoulos, and Erez Zadok
+ */
+#ifdef CONFIG_EXT4DEV_FS_TRASH_BIN
+
+#define TB_NAME ".trash"
+#define TB_NAME_LEN 6
+#define TB_MODE S_IRUGO | S_IXUGO | S_IRWXU | S_IFDIR
+#define USER_MODE S_IRWXU | S_IFDIR
+#define UID_MAX_LEN 6
+#define TB_DEBUG 1
+
+extern int ext4_create_tb(struct super_block *);
+extern int ext4_trash_entry(struct inode *, struct dentry *);
+extern struct dentry *ext4_get_user_dentry(struct inode *old_dir, int create);
+#endif /*CONFIG_EXT4_FS_TRASH_BIN*/
diff -Naur 2.6.19/fs/Kconfig 2.6.19tb/fs/Kconfig
--- 2.6.19/fs/Kconfig	2006-12-02 19:49:39.000000000 -0500
+++ 2.6.19tb/fs/Kconfig	2006-12-02 20:04:18.000000000 -0500
@@ -207,6 +207,15 @@
 	  If you are not using a security module that requires using
 	  extended attributes for file security labels, say N.

+config EXT4DEV_FS_TRASH_BIN
+	bool "Trash bin"
+	depends on EXT4DEV_FS
+	help
+	  Trash bin functionality enables users to easily recover
+	  previously deleted files.
+
+	  If you do not know what trash bin does, say N.
+
 config JBD
 	tristate
 	help
