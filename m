From: Cyrus Massoumi <cyrusm@gmx.net>
Subject: [PATCH] ext3: remove the BKL in ext3/ioctl.c
Date: Thu, 08 Jan 2009 14:54:55 +0100
Message-ID: <496605AF.7020002@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, akpm@linux-foundation.org, adilger@sun.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59154 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755439AbZAHNzA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Jan 2009 08:55:00 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(Please CC me on all replies)

Reformat ext3/ioctl.c to make it look more like ext4/ioctl.c and remove the BKL around ext3_ioctl().
Patch is against 2.6.28. Compile tested only.

Please review and consider applying!

Signed-off-by: Cyrus Massoumi <cyrusm@gmx.net>
---

diff -uNr linux-2.6.28/fs/ext3/dir.c linux-2.6.28-old/fs/ext3/dir.c
--- linux-2.6.28/fs/ext3/dir.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28-old/fs/ext3/dir.c	2009-01-07 21:15:41.000000000 +0100
@@ -42,7 +42,7 @@
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= ext3_readdir,		/* we take BKL. needed?*/
-	.ioctl		= ext3_ioctl,		/* BKL held */
+	.unlocked_ioctl	= ext3_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
diff -uNr linux-2.6.28/fs/ext3/file.c linux-2.6.28-old/fs/ext3/file.c
--- linux-2.6.28/fs/ext3/file.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28-old/fs/ext3/file.c	2009-01-07 21:15:42.000000000 +0100
@@ -112,7 +112,7 @@
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= ext3_file_write,
-	.ioctl		= ext3_ioctl,
+	.unlocked_ioctl	= ext3_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
diff -uNr linux-2.6.28/fs/ext3/ioctl.c linux-2.6.28-old/fs/ext3/ioctl.c
--- linux-2.6.28/fs/ext3/ioctl.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28-old/fs/ext3/ioctl.c	2009-01-07 22:01:56.000000000 +0100
@@ -15,12 +15,11 @@
 #include <linux/mount.h>
 #include <linux/time.h>
 #include <linux/compat.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 
-int ext3_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
-		unsigned long arg)
+long ext3_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_dentry->d_inode;
 	struct ext3_inode_info *ei = EXT3_I(inode);
 	unsigned int flags;
 	unsigned short rsv_window_size;
@@ -39,30 +38,25 @@
 		unsigned int oldflags;
 		unsigned int jflag;
 
+		if (!is_owner_or_cap(inode))
+			return -EACCES;
+
+		if (get_user(flags, (int __user *) arg))
+			return -EFAULT;
+
 		err = mnt_want_write(filp->f_path.mnt);
 		if (err)
 			return err;
 
-		if (!is_owner_or_cap(inode)) {
-			err = -EACCES;
-			goto flags_out;
-		}
-
-		if (get_user(flags, (int __user *) arg)) {
-			err = -EFAULT;
-			goto flags_out;
-		}
-
 		if (!S_ISDIR(inode->i_mode))
 			flags &= ~EXT3_DIRSYNC_FL;
 
+		err = -EPERM;
 		mutex_lock(&inode->i_mutex);
 		/* Is it quota file? Do not allow user to mess with it */
-		if (IS_NOQUOTA(inode)) {
-			mutex_unlock(&inode->i_mutex);
-			err = -EPERM;
+		if (IS_NOQUOTA(inode))
 			goto flags_out;
-		}
+		
 		oldflags = ei->i_flags;
 
 		/* The JOURNAL_DATA flag is modifiable only by root */
@@ -75,11 +69,8 @@
 		 * This test looks nicer. Thanks to Pauline Middelink
 		 */
 		if ((flags ^ oldflags) & (EXT3_APPEND_FL | EXT3_IMMUTABLE_FL)) {
-			if (!capable(CAP_LINUX_IMMUTABLE)) {
-				mutex_unlock(&inode->i_mutex);
-				err = -EPERM;
+			if (!capable(CAP_LINUX_IMMUTABLE))
 				goto flags_out;
-			}
 		}
 
 		/*
@@ -87,17 +78,12 @@
 		 * the relevant capability.
 		 */
 		if ((jflag ^ oldflags) & (EXT3_JOURNAL_DATA_FL)) {
-			if (!capable(CAP_SYS_RESOURCE)) {
-				mutex_unlock(&inode->i_mutex);
-				err = -EPERM;
+			if (!capable(CAP_SYS_RESOURCE))
 				goto flags_out;
-			}
 		}
 
-
 		handle = ext3_journal_start(inode, 1);
 		if (IS_ERR(handle)) {
-			mutex_unlock(&inode->i_mutex);
 			err = PTR_ERR(handle);
 			goto flags_out;
 		}
@@ -117,15 +103,13 @@
 		err = ext3_mark_iloc_dirty(handle, inode, &iloc);
 flags_err:
 		ext3_journal_stop(handle);
-		if (err) {
-			mutex_unlock(&inode->i_mutex);
-			return err;
-		}
+		if (err)
+			goto flags_out;
 
 		if ((jflag ^ oldflags) & (EXT3_JOURNAL_DATA_FL))
 			err = ext3_change_inode_journal_flag(inode, jflag);
-		mutex_unlock(&inode->i_mutex);
 flags_out:
+		mutex_unlock(&inode->i_mutex);
 		mnt_drop_write(filp->f_path.mnt);
 		return err;
 	}
@@ -141,6 +125,7 @@
 
 		if (!is_owner_or_cap(inode))
 			return -EPERM;
+
 		err = mnt_want_write(filp->f_path.mnt);
 		if (err)
 			return err;
@@ -148,6 +133,7 @@
 			err = -EFAULT;
 			goto setversion_out;
 		}
+
 		handle = ext3_journal_start(inode, 1);
 		if (IS_ERR(handle)) {
 			err = PTR_ERR(handle);
@@ -300,9 +286,6 @@
 #ifdef CONFIG_COMPAT
 long ext3_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int ret;
-
 	/* These are just misnamed, they actually get/put from/to user an int */
 	switch (cmd) {
 	case EXT3_IOC32_GETFLAGS:
@@ -342,9 +325,6 @@
 	default:
 		return -ENOIOCTLCMD;
 	}
-	lock_kernel();
-	ret = ext3_ioctl(inode, file, cmd, (unsigned long) compat_ptr(arg));
-	unlock_kernel();
-	return ret;
+	return ext3_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
 }
 #endif
diff -uNr linux-2.6.28/include/linux/ext3_fs.h linux-2.6.28-old/include/linux/ext3_fs.h
--- linux-2.6.28/include/linux/ext3_fs.h	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28-old/include/linux/ext3_fs.h	2009-01-07 21:15:42.000000000 +0100
@@ -843,9 +843,8 @@
 		       u64 start, u64 len);
 
 /* ioctl.c */
-extern int ext3_ioctl (struct inode *, struct file *, unsigned int,
-		       unsigned long);
-extern long ext3_compat_ioctl (struct file *, unsigned int, unsigned long);
+extern long ext3_ioctl(struct file *, unsigned int, unsigned long);
+extern long ext3_compat_ioctl(struct file *, unsigned int, unsigned long);
 
 /* namei.c */
 extern int ext3_orphan_add(handle_t *, struct inode *);
