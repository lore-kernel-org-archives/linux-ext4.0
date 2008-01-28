From: Andi Kleen <ak@suse.de>
Subject: [PATCH] [6/7] Convert ext4 to use unlocked_ioctl v2
Date: Mon, 28 Jan 2008 11:16:15 +0100 (CET)
Message-ID: <20080128101615.B3E3D15308@wotan.suse.de>
References: <200801281116.315497000@suse.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:33330 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbYA1KQQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 05:16:16 -0500
Received: from Relay1.suse.de (relay-ext.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id DBF1326F26
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jan 2008 11:16:15 +0100 (CET)
In-Reply-To: <200801281116.315497000@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I checked ext4_ioctl and it looked largely safe to not be used
without BKL.  So convert it over to unlocked_ioctl.

Signed-off-by: Andi Kleen <ak@suse.de>

v1->v2: drop BKL for online grow. resize.c seems to do enough locking

---
 fs/ext4/dir.c           |    2 +-
 fs/ext4/file.c          |    2 +-
 fs/ext4/ioctl.c         |   20 +++++++++++---------
 include/linux/ext4_fs.h |    3 +--
 4 files changed, 14 insertions(+), 13 deletions(-)

Index: linux/fs/ext4/dir.c
===================================================================
--- linux.orig/fs/ext4/dir.c
+++ linux/fs/ext4/dir.c
@@ -42,7 +42,7 @@ const struct file_operations ext4_dir_op
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= ext4_readdir,		/* we take BKL. needed?*/
-	.ioctl		= ext4_ioctl,		/* BKL held */
+	.unlocked_ioctl = ext4_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext4_compat_ioctl,
 #endif
Index: linux/fs/ext4/file.c
===================================================================
--- linux.orig/fs/ext4/file.c
+++ linux/fs/ext4/file.c
@@ -112,7 +112,7 @@ const struct file_operations ext4_file_o
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= ext4_file_write,
-	.ioctl		= ext4_ioctl,
+	.unlocked_ioctl = ext4_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext4_compat_ioctl,
 #endif
Index: linux/fs/ext4/ioctl.c
===================================================================
--- linux.orig/fs/ext4/ioctl.c
+++ linux/fs/ext4/ioctl.c
@@ -17,9 +17,9 @@
 #include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 
-int ext4_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
-		unsigned long arg)
+long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_dentry->d_inode;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int flags;
 	unsigned short rsv_window_size;
@@ -262,9 +270,6 @@ flags_err:
 #ifdef CONFIG_COMPAT
 long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int ret;
-
 	/* These are just misnamed, they actually get/put from/to user an int */
 	switch (cmd) {
 	case EXT4_IOC32_GETFLAGS:
@@ -304,9 +309,6 @@ long ext4_compat_ioctl(struct file *file
 	default:
 		return -ENOIOCTLCMD;
 	}
-	lock_kernel();
-	ret = ext4_ioctl(inode, file, cmd, (unsigned long) compat_ptr(arg));
-	unlock_kernel();
-	return ret;
+	return ext4_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
 }
 #endif
Index: linux/include/linux/ext4_fs.h
===================================================================
--- linux.orig/include/linux/ext4_fs.h
+++ linux/include/linux/ext4_fs.h
@@ -939,8 +939,7 @@ extern int ext4_block_truncate_page(hand
 		struct address_space *mapping, loff_t from);
 
 /* ioctl.c */
-extern int ext4_ioctl (struct inode *, struct file *, unsigned int,
-		       unsigned long);
+extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext4_compat_ioctl (struct file *, unsigned int, unsigned long);
 
 /* namei.c */
