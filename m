From: Andi Kleen <ak@suse.de>
Subject: [PATCH] [3/7] Convert ext3 to use unlocked_ioctl v2
Date: Mon, 28 Jan 2008 11:16:12 +0100 (CET)
Message-ID: <20080128101612.8616E152E1@wotan.suse.de>
References: <200801281116.315497000@suse.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:33322 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbYA1KQN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 05:16:13 -0500
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id D1C222703D
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jan 2008 11:16:12 +0100 (CET)
In-Reply-To: <200801281116.315497000@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I checked ext3_ioctl and it looked largely safe to not be used
without BKL.  So convert it over to unlocked_ioctl.

Signed-off-by: Andi Kleen <ak@suse.de>

v1->v2: drop lock kernel for online growth. resize.c seems to do enough
locking

---
 fs/ext3/dir.c           |    2 +-
 fs/ext3/file.c          |    2 +-
 fs/ext3/ioctl.c         |   21 +++++++++++----------
 include/linux/ext3_fs.h |    3 +--
 4 files changed, 14 insertions(+), 14 deletions(-)

Index: linux/fs/ext3/dir.c
===================================================================
--- linux.orig/fs/ext3/dir.c
+++ linux/fs/ext3/dir.c
@@ -42,7 +42,7 @@ const struct file_operations ext3_dir_op
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= ext3_readdir,		/* we take BKL. needed?*/
-	.ioctl		= ext3_ioctl,		/* BKL held */
+	.unlocked_ioctl = ext3_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
Index: linux/fs/ext3/file.c
===================================================================
--- linux.orig/fs/ext3/file.c
+++ linux/fs/ext3/file.c
@@ -112,7 +112,7 @@ const struct file_operations ext3_file_o
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= ext3_file_write,
-	.ioctl		= ext3_ioctl,
+	.unlocked_ioctl = ext3_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
Index: linux/fs/ext3/ioctl.c
===================================================================
--- linux.orig/fs/ext3/ioctl.c
+++ linux/fs/ext3/ioctl.c
@@ -17,9 +17,9 @@
 #include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 
-int ext3_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
-		unsigned long arg)
+long ext3_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_dentry->d_inode;
 	struct ext3_inode_info *ei = EXT3_I(inode);
 	unsigned int flags;
 	unsigned short rsv_window_size;
@@ -263,9 +270,6 @@ flags_err:
 #ifdef CONFIG_COMPAT
 long ext3_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int ret;
-
 	/* These are just misnamed, they actually get/put from/to user an int */
 	switch (cmd) {
 	case EXT3_IOC32_GETFLAGS:
@@ -305,9 +309,6 @@ long ext3_compat_ioctl(struct file *file
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
Index: linux/include/linux/ext3_fs.h
===================================================================
--- linux.orig/include/linux/ext3_fs.h
+++ linux/include/linux/ext3_fs.h
@@ -838,8 +838,7 @@ extern void ext3_get_inode_flags(struct 
 extern void ext3_set_aops(struct inode *inode);
 
 /* ioctl.c */
-extern int ext3_ioctl (struct inode *, struct file *, unsigned int,
-		       unsigned long);
+extern long ext3_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext3_compat_ioctl (struct file *, unsigned int, unsigned long);
 
 /* namei.c */
