From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext3: remove the BKL in ext3/ioctl.c
Date: Tue, 13 Jan 2009 00:03:59 -0800
Message-ID: <20090113000359.60109e46.akpm@linux-foundation.org>
References: <496605AF.7020002@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@sun.com,
	Jan Kara <jack@ucw.cz>
To: Cyrus Massoumi <cyrusm@gmx.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbZAMIEj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Jan 2009 03:04:39 -0500
In-Reply-To: <496605AF.7020002@gmx.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 08 Jan 2009 14:54:55 +0100 Cyrus Massoumi <cyrusm@gmx.net> wrote:

> Reformat ext3/ioctl.c to make it look more like ext4/ioctl.c and remove the BKL around ext3_ioctl().
> Patch is against 2.6.28. Compile tested only.

Looks OK to me.

Jan, it affects quota a little bit: lost bkl coverage around quota
operations.  Does it look OK?

(patch reworked to apply to 2.6.29-rc1):



From: Cyrus Massoumi <cyrusm@gmx.net>

Reformat ext3/ioctl.c to make it look more like ext4/ioctl.c and remove
the BKL around ext3_ioctl().

Signed-off-by: Cyrus Massoumi <cyrusm@gmx.net>
Cc: <linux-ext4@vger.kernel.org>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/dir.c           |    2 -
 fs/ext3/file.c          |    2 -
 fs/ext3/ioctl.c         |   59 ++++++++++++--------------------------
 include/linux/ext3_fs.h |    5 +--
 4 files changed, 24 insertions(+), 44 deletions(-)

diff -puN fs/ext3/dir.c~ext3-remove-the-bkl-in-ext3-ioctlc fs/ext3/dir.c
--- a/fs/ext3/dir.c~ext3-remove-the-bkl-in-ext3-ioctlc
+++ a/fs/ext3/dir.c
@@ -42,7 +42,7 @@ const struct file_operations ext3_dir_op
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= ext3_readdir,		/* we take BKL. needed?*/
-	.ioctl		= ext3_ioctl,		/* BKL held */
+	.unlocked_ioctl	= ext3_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
diff -puN fs/ext3/file.c~ext3-remove-the-bkl-in-ext3-ioctlc fs/ext3/file.c
--- a/fs/ext3/file.c~ext3-remove-the-bkl-in-ext3-ioctlc
+++ a/fs/ext3/file.c
@@ -112,7 +112,7 @@ const struct file_operations ext3_file_o
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= ext3_file_write,
-	.ioctl		= ext3_ioctl,
+	.unlocked_ioctl	= ext3_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
diff -puN fs/ext3/ioctl.c~ext3-remove-the-bkl-in-ext3-ioctlc fs/ext3/ioctl.c
--- a/fs/ext3/ioctl.c~ext3-remove-the-bkl-in-ext3-ioctlc
+++ a/fs/ext3/ioctl.c
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
@@ -39,29 +38,25 @@ int ext3_ioctl (struct inode * inode, st
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
 		flags = ext3_mask_flags(inode->i_mode, flags);
 
 		mutex_lock(&inode->i_mutex);
+
 		/* Is it quota file? Do not allow user to mess with it */
-		if (IS_NOQUOTA(inode)) {
-			mutex_unlock(&inode->i_mutex);
-			err = -EPERM;
+		err = -EPERM;
+		if (IS_NOQUOTA(inode))
 			goto flags_out;
-		}
+
 		oldflags = ei->i_flags;
 
 		/* The JOURNAL_DATA flag is modifiable only by root */
@@ -74,11 +69,8 @@ int ext3_ioctl (struct inode * inode, st
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
@@ -86,17 +78,12 @@ int ext3_ioctl (struct inode * inode, st
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
@@ -116,15 +103,13 @@ int ext3_ioctl (struct inode * inode, st
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
@@ -140,6 +125,7 @@ flags_out:
 
 		if (!is_owner_or_cap(inode))
 			return -EPERM;
+
 		err = mnt_want_write(filp->f_path.mnt);
 		if (err)
 			return err;
@@ -147,6 +133,7 @@ flags_out:
 			err = -EFAULT;
 			goto setversion_out;
 		}
+
 		handle = ext3_journal_start(inode, 1);
 		if (IS_ERR(handle)) {
 			err = PTR_ERR(handle);
@@ -299,9 +286,6 @@ group_add_out:
 #ifdef CONFIG_COMPAT
 long ext3_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int ret;
-
 	/* These are just misnamed, they actually get/put from/to user an int */
 	switch (cmd) {
 	case EXT3_IOC32_GETFLAGS:
@@ -341,9 +325,6 @@ long ext3_compat_ioctl(struct file *file
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
diff -puN include/linux/ext3_fs.h~ext3-remove-the-bkl-in-ext3-ioctlc include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~ext3-remove-the-bkl-in-ext3-ioctlc
+++ a/include/linux/ext3_fs.h
@@ -893,9 +893,8 @@ extern int ext3_fiemap(struct inode *ino
 		       u64 start, u64 len);
 
 /* ioctl.c */
-extern int ext3_ioctl (struct inode *, struct file *, unsigned int,
-		       unsigned long);
-extern long ext3_compat_ioctl (struct file *, unsigned int, unsigned long);
+extern long ext3_ioctl(struct file *, unsigned int, unsigned long);
+extern long ext3_compat_ioctl(struct file *, unsigned int, unsigned long);
 
 /* namei.c */
 extern int ext3_orphan_add(handle_t *, struct inode *);
_

