From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] ext4: remove unused ext4_error_file()
Date: Wed, 15 Sep 2010 13:27:58 -0500
Message-ID: <4C91102E.6020708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab0IOS2B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Sep 2010 14:28:01 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8FIS189017179
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 15 Sep 2010 14:28:01 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o8FIRwPP016958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 15 Sep 2010 14:28:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_error_file is not used, so nuke it for now.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 ext4.h  |    6 ------
 super.c |   27 ---------------------------
 2 files changed, 33 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index cb4d204..41dbcff 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -62,9 +62,6 @@
 #define EXT4_ERROR_INODE_BLOCK(inode, block, fmt, a...)			\
 	ext4_error_inode((inode), __func__, __LINE__, (block), (fmt), ## a)
 
-#define EXT4_ERROR_FILE(file, fmt, a...)	\
-	ext4_error_file(__func__, __LINE__, (file), (fmt), ## a)
-
 /* data type for block offset of block group */
 typedef int ext4_grpblk_t;
 
@@ -1686,9 +1683,6 @@ extern void __ext4_error(struct super_block *, const char *, unsigned int,
 extern void ext4_error_inode(struct inode *, const char *, unsigned int,
 			     ext4_fsblk_t, const char *, ...)
 	__attribute__ ((format (printf, 5, 6)));
-extern void ext4_error_file(struct file *, const char *, unsigned int,
-			    const char *, ...)
-	__attribute__ ((format (printf, 4, 5)));
 extern void __ext4_std_error(struct super_block *, const char *,
 			     unsigned int, int);
 extern void __ext4_abort(struct super_block *, const char *, unsigned int,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2614774..6c35f64 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -416,33 +416,6 @@ void ext4_error_inode(struct inode *inode, const char *function,
 	ext4_handle_error(inode->i_sb);
 }
 
-void ext4_error_file(struct file *file, const char *function,
-		     unsigned int line, const char *fmt, ...)
-{
-	va_list args;
-	struct ext4_super_block *es;
-	struct inode *inode = file->f_dentry->d_inode;
-	char pathname[80], *path;
-
-	es = EXT4_SB(inode->i_sb)->s_es;
-	es->s_last_error_ino = cpu_to_le32(inode->i_ino);
-	save_error_info(inode->i_sb, function, line);
-	va_start(args, fmt);
-	path = d_path(&(file->f_path), pathname, sizeof(pathname));
-	if (!path)
-		path = "(unknown)";
-	printk(KERN_CRIT
-	       "EXT4-fs error (device %s): %s:%d: inode #%lu "
-	       "(comm %s path %s): ",
-	       inode->i_sb->s_id, function, line, inode->i_ino,
-	       current->comm, path);
-	vprintk(fmt, args);
-	printk("\n");
-	va_end(args);
-
-	ext4_handle_error(inode->i_sb);
-}
