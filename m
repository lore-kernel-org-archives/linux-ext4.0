From: Cordenner jean noel <jean-noel.cordenner@bull.net>
Subject: [RFC] [patch 2/2] i_version update - ext4 part
Date: Mon, 14 May 2007 13:05:01 +0200
Message-ID: <1179140701.7733.4.camel@frecb002711.frec.bull.fr>
Reply-To: jean-noel.cordenner@bull.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48488 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758659AbXENLKC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 May 2007 07:10:02 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 220DD19D929
	for <linux-ext4@vger.kernel.org>; Mon, 14 May 2007 13:10:04 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 04590-09 for <linux-ext4@vger.kernel.org>;
 Mon, 14 May 2007 13:10:00 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id EF56519D925
	for <linux-ext4@vger.kernel.org>; Mon, 14 May 2007 13:09:59 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In the ext4 part, the i_version counter is stored into 2 32bit fields in
the ext4_inode structure i_disk_version and i_disk_version_hi.

Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>

fs/ext4/ialloc.c        |    1 +
fs/ext4/inode.c         |    5 +++++
fs/ext4/super.c         |    2 +-
include/linux/ext4_fs.h |    5 +++--

Index: linux-2.6.21-rc4-i_version/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.21-rc4-i_version.orig/fs/ext4/ialloc.c	2007-05-10 17:22:23.000000000 +0200
+++ linux-2.6.21-rc4-i_version/fs/ext4/ialloc.c	2007-05-10 17:26:21.000000000 +0200
@@ -564,6 +564,7 @@
 	/* This is the optimal IO size (for stat), not the fs block size */
 	inode->i_blocks = 0;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_version = 1;
 
 	memset(ei->i_data, 0, sizeof(ei->i_data));
 	ei->i_dir_start_lookup = 0;
Index: linux-2.6.21-rc4-i_version/fs/ext4/inode.c
===================================================================
--- linux-2.6.21-rc4-i_version.orig/fs/ext4/inode.c	2007-05-10 17:22:23.000000000 +0200
+++ linux-2.6.21-rc4-i_version/fs/ext4/inode.c	2007-05-10 18:14:43.000000000 +0200
@@ -2680,6 +2680,8 @@
 	inode->i_ctime.tv_sec = le32_to_cpu(raw_inode->i_ctime);
 	inode->i_mtime.tv_sec = le32_to_cpu(raw_inode->i_mtime);
 	inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec = inode->i_mtime.tv_nsec = 0;
+	inode->i_version = (le32_to_cpu(raw_inode->i_disk_version_hi) << 32) +
+			    le32_to_cpu(raw_inode->i_disk_version);
 
 	ei->i_state = 0;
 	ei->i_dir_start_lookup = 0;
@@ -2838,6 +2840,8 @@
 	raw_inode->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
 	raw_inode->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
 	raw_inode->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
+	raw_inode->i_disk_version = cpu_to_le32(inode->i_version);
+	raw_inode->i_disk_version_hi = cpu_to_le32(inode->i_version >> 32);
 	raw_inode->i_blocks = cpu_to_le32(inode->i_blocks);
 	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
 	raw_inode->i_flags = cpu_to_le32(ei->i_flags);
@@ -3111,6 +3115,7 @@
 {
 	int err = 0;
 
+	inode->i_version++;
 	/* the do_update_inode consumes one bh->b_count */
 	get_bh(iloc->bh);
 
Index: linux-2.6.21-rc4-i_version/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.21-rc4-i_version.orig/include/linux/ext4_fs.h	2007-05-10 17:22:23.000000000 +0200
+++ linux-2.6.21-rc4-i_version/include/linux/ext4_fs.h	2007-05-10 17:26:21.000000000 +0200
@@ -291,7 +291,7 @@
 	__le32	i_flags;	/* File flags */
 	union {
 		struct {
-			__u32  l_i_reserved1;
+			__u32  l_i_disk_version;
 		} linux1;
 		struct {
 			__u32  h_i_translator;
@@ -331,12 +331,13 @@
 	} osd2;				/* OS dependent 2 */
 	__le16	i_extra_isize;
 	__le16	i_pad1;
+	__le32	i_disk_version_hi;
 };
 
 #define i_size_high	i_dir_acl
 
 #if defined(__KERNEL__) || defined(__linux__)
-#define i_reserved1	osd1.linux1.l_i_reserved1
+#define i_disk_version	osd1.linux1.l_i_disk_version
 #define i_frag		osd2.linux2.l_i_frag
 #define i_fsize		osd2.linux2.l_i_fsize
 #define i_file_acl_high	osd2.linux2.l_i_file_acl_high
Index: linux-2.6.21-rc4-i_version/fs/ext4/super.c
===================================================================
--- linux-2.6.21-rc4-i_version.orig/fs/ext4/super.c	2007-05-10 17:22:23.000000000 +0200
+++ linux-2.6.21-rc4-i_version/fs/ext4/super.c	2007-05-10 17:26:21.000000000 +0200
@@ -2804,8 +2804,8 @@
 		i_size_write(inode, off+len-towrite);
 		EXT4_I(inode)->i_disksize = inode->i_size;
 	}
-	inode->i_version++;
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_version = 1;
 	ext4_mark_inode_dirty(handle, inode);
 	mutex_unlock(&inode->i_mutex);
 	return len - towrite;
