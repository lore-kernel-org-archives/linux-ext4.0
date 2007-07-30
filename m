From: Jean noel Cordenner <jean-noel.cordenner@bull.net>
Subject: [patch] i_version mount option
Date: Mon, 30 Jul 2007 16:48:07 +0200
Message-ID: <46ADFA27.8080601@bull.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070208050502090206070309"
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46396 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbXG3O4E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jul 2007 10:56:04 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 8976519D912
	for <linux-ext4@vger.kernel.org>; Mon, 30 Jul 2007 16:56:11 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 17480-10 for <linux-ext4@vger.kernel.org>;
 Mon, 30 Jul 2007 16:56:08 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id B8F0D19D90C
	for <linux-ext4@vger.kernel.org>; Mon, 30 Jul 2007 16:56:08 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------070208050502090206070309
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

hi,

This patch apply on the top of the ext4 git tree.
It adds a mount option to enable i_version feature for ext4.

Signed-off-by: Jean noel Cordenner <jean-noel.cordenner@bull.net>


--------------070208050502090206070309
Content-Transfer-Encoding: 7bit
Content-Type: text/x-patch;
 name="ext4_version_mount_opt.patch"
Content-Disposition: inline;
 filename="ext4_version_mount_opt.patch"

Index: linux-2.6.22-ext4/fs/ext4/super.c
===================================================================
--- linux-2.6.22-ext4.orig/fs/ext4/super.c	2007-07-26 10:48:52.000000000 +0200
+++ linux-2.6.22-ext4/fs/ext4/super.c	2007-07-26 17:29:44.000000000 +0200
@@ -736,7 +736,7 @@
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
-	Opt_grpquota, Opt_extents, Opt_noextents,
+	Opt_grpquota, Opt_extents, Opt_noextents, Opt_i_version,
 	Opt_delayed_alloc, Opt_nodelayed_alloc,
 };
 
@@ -793,6 +793,7 @@
 	{Opt_noextents, "noextents"},
 	{Opt_delayed_alloc, "delalloc"},
 	{Opt_nodelayed_alloc, "nodelalloc"},
+	{Opt_i_version, "i_version"},
 	{Opt_err, NULL},
 	{Opt_resize, "resize"},
 };
@@ -1144,6 +1145,9 @@
 		case Opt_noextents:
 			clear_opt (sbi->s_mount_opt, EXTENTS);
 			break;
+		case Opt_i_version:
+			clear_opt (sbi->s_mount_opt, I_VERSION);
+			break;
 		default:
 			printk (KERN_ERR
 				"EXT4-fs: Unrecognized mount option \"%s\" "
Index: linux-2.6.22-ext4/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.22-ext4.orig/include/linux/ext4_fs.h	2007-07-26 10:48:52.000000000 +0200
+++ linux-2.6.22-ext4/include/linux/ext4_fs.h	2007-07-26 10:51:11.000000000 +0200
@@ -489,6 +489,7 @@
 #define EXT4_MOUNT_JOURNAL_CHECKSUM	0x800000 /* Journal checksums */
 #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
 #define EXT4_MOUNT_DELAYED_ALLOC	0x2000000/* Delayed allocation support*/
+#define EXT4_MOUNT_I_VERSION		0x4000000/* i_version support */
 
 /* Compatibility, for having both ext2_fs.h and ext4_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
Index: linux-2.6.22-ext4/fs/ext4/inode.c
===================================================================
--- linux-2.6.22-ext4.orig/fs/ext4/inode.c	2007-07-26 10:48:52.000000000 +0200
+++ linux-2.6.22-ext4/fs/ext4/inode.c	2007-07-30 16:08:19.000000000 +0200
@@ -3107,7 +3107,9 @@
 {
 	int err = 0;
 
-	inode->i_version++;
+	if (test_opt(inode->i_sb, I_VERSION))
+		inode->i_version++;
+
 	/* the do_update_inode consumes one bh->b_count */
 	get_bh(iloc->bh);
 


--------------070208050502090206070309--
