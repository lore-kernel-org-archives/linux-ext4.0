From: Andi Kleen <ak@suse.de>
Subject: [PATCH] [1/7] Convert ext2 over to use unlocked_ioctl
Date: Mon, 28 Jan 2008 11:16:10 +0100 (CET)
Message-ID: <20080128101610.6C123152DF@wotan.suse.de>
References: <200801281116.315497000@suse.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:33310 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbYA1KQL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 05:16:11 -0500
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 94A982704A
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jan 2008 11:16:10 +0100 (CET)
In-Reply-To: <200801281116.315497000@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I checked ext2_ioctl and could not find anything in there that would
need the BKL. So convert it over to use unlocked_ioctl

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/ext2/dir.c   |    2 +-
 fs/ext2/ext2.h  |    3 +--
 fs/ext2/file.c  |    4 ++--
 fs/ext2/ioctl.c |   12 +++---------
 4 files changed, 7 insertions(+), 14 deletions(-)

Index: linux/fs/ext2/dir.c
===================================================================
--- linux.orig/fs/ext2/dir.c
+++ linux/fs/ext2/dir.c
@@ -703,7 +703,7 @@ const struct file_operations ext2_dir_op
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= ext2_readdir,
-	.ioctl		= ext2_ioctl,
+	.unlocked_ioctl = ext2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
Index: linux/fs/ext2/ext2.h
===================================================================
--- linux.orig/fs/ext2/ext2.h
+++ linux/fs/ext2/ext2.h
@@ -139,8 +139,7 @@ int __ext2_write_begin(struct file *file
 		struct page **pagep, void **fsdata);
 
 /* ioctl.c */
-extern int ext2_ioctl (struct inode *, struct file *, unsigned int,
-		       unsigned long);
+extern long ext2_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext2_compat_ioctl(struct file *, unsigned int, unsigned long);
 
 /* namei.c */
Index: linux/fs/ext2/file.c
===================================================================
--- linux.orig/fs/ext2/file.c
+++ linux/fs/ext2/file.c
@@ -48,7 +48,7 @@ const struct file_operations ext2_file_o
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
-	.ioctl		= ext2_ioctl,
+	.unlocked_ioctl = ext2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
@@ -65,7 +65,7 @@ const struct file_operations ext2_xip_fi
 	.llseek		= generic_file_llseek,
 	.read		= xip_file_read,
 	.write		= xip_file_write,
-	.ioctl		= ext2_ioctl,
+	.unlocked_ioctl = ext2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
Index: linux/fs/ext2/ioctl.c
===================================================================
--- linux.orig/fs/ext2/ioctl.c
+++ linux/fs/ext2/ioctl.c
@@ -17,9 +17,9 @@
 #include <asm/uaccess.h>
 
 
-int ext2_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
-		unsigned long arg)
+long ext2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_dentry->d_inode;
 	struct ext2_inode_info *ei = EXT2_I(inode);
 	unsigned int flags;
 	unsigned short rsv_window_size;
@@ -141,9 +141,6 @@ int ext2_ioctl (struct inode * inode, st
 #ifdef CONFIG_COMPAT
 long ext2_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int ret;
-
 	/* These are just misnamed, they actually get/put from/to user an int */
 	switch (cmd) {
 	case EXT2_IOC32_GETFLAGS:
@@ -161,9 +158,6 @@ long ext2_compat_ioctl(struct file *file
 	default:
 		return -ENOIOCTLCMD;
 	}
-	lock_kernel();
-	ret = ext2_ioctl(inode, file, cmd, (unsigned long) compat_ptr(arg));
-	unlock_kernel();
-	return ret;
+	return ext2_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
 }
 #endif
