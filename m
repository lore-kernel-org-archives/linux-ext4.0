From: Jean-Noel Cordenner <jean-noel.cordenner@bull.net>
Subject: [RFC] [patch 1/3] change attribute for ext4: change attribute in
 the VFS
Date: Wed, 29 Nov 2006 19:54:12 +0100
Message-ID: <456DD754.3060803@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:63878 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S967536AbWK2SxH
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Nov 2006 13:53:07 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id D5FA519D924
	for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2006 19:53:01 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 21654-01 for <linux-ext4@vger.kernel.org>;
 Wed, 29 Nov 2006 19:52:57 +0100 (CET)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 0CC3719D920
	for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2006 19:52:57 +0100 (CET)
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This part of the patch concerns the change attribute in the VFS layer. The 
definition of the change_attribute field in the inode and its update.



Signed-off-by: Celine Bourde
Signed-off-by: Alexandre Ratchov
Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>



Index: linux-2.6.19-rc2-mm2-CA/fs/attr.c
===================================================================
--- linux-2.6.19-rc2-mm2-CA.orig/fs/attr.c      2006-11-13 16:49:14.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/fs/attr.c   2006-11-29 15:06:56.000000000 +0100
@@ -88,6 +88,9 @@
         if (ia_valid & ATTR_CTIME)
                 inode->i_ctime = timespec_trunc(attr->ia_ctime,
                                                 inode->i_sb->s_time_gran);
+       if (ia_valid & ATTR_CHANGE_ATTRIBUTE)
+               inode->i_change_attribute = attr->ia_change_attribute;
+
         if (ia_valid & ATTR_MODE) {
                 umode_t mode = attr->ia_mode;

@@ -112,6 +115,7 @@
         mode = inode->i_mode;
         now = current_fs_time(inode->i_sb);

+       inode->i_change_attribute++;
         attr->ia_ctime = now;
         if (!(ia_valid & ATTR_ATIME_SET))
                 attr->ia_atime = now;
Index: linux-2.6.19-rc2-mm2-CA/fs/bad_inode.c
===================================================================
--- linux-2.6.19-rc2-mm2-CA.orig/fs/bad_inode.c 2006-11-09 17:20:55.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/fs/bad_inode.c      2006-11-29 15:06:13.000000000 +0100
@@ -95,6 +95,7 @@
         inode->i_mode = S_IFREG;
         inode->i_atime = inode->i_mtime = inode->i_ctime =
                 current_fs_time(inode->i_sb);
+       inode->i_change_attribute++;
         inode->i_op = &bad_inode_ops;
         inode->i_fop = &bad_file_ops;
  }
Index: linux-2.6.19-rc2-mm2-CA/fs/binfmt_misc.c
===================================================================
--- linux-2.6.19-rc2-mm2-CA.orig/fs/binfmt_misc.c       2006-11-09 
17:20:53.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/fs/binfmt_misc.c    2006-11-29 15:05:57.000000000 +0100
@@ -508,6 +508,7 @@
                 inode->i_blocks = 0;
                 inode->i_atime = inode->i_mtime = inode->i_ctime =
                         current_fs_time(inode->i_sb);
+               inode->i_change_attribute = 1;
         }
         return inode;
  }
Index: linux-2.6.19-rc2-mm2-CA/fs/inode.c
===================================================================
--- linux-2.6.19-rc2-mm2-CA.orig/fs/inode.c     2006-11-09 17:20:59.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/fs/inode.c  2006-11-29 15:29:51.000000000 +0100
@@ -1217,18 +1217,11 @@
                 return;

         now = current_fs_time(inode->i_sb);
-       if (!timespec_equal(&inode->i_mtime, &now)) {
-               inode->i_mtime = now;
-               sync_it = 1;
-       }
-
-       if (!timespec_equal(&inode->i_ctime, &now)) {
-               inode->i_ctime = now;
-               sync_it = 1;
-       }
+       inode->i_mtime = now;
+       inode->i_ctime = now;

-       if (sync_it)
-               mark_inode_dirty_sync(inode);
+       inode->i_change_attribute++;
+       mark_inode_dirty_sync(inode);
  }

  EXPORT_SYMBOL(file_update_time);
Index: linux-2.6.19-rc2-mm2-CA/fs/libfs.c
===================================================================
--- linux-2.6.19-rc2-mm2-CA.orig/fs/libfs.c     2006-11-09 17:20:56.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/fs/libfs.c  2006-11-29 15:05:31.000000000 +0100
@@ -220,6 +220,7 @@
         root->i_mode = S_IFDIR | S_IRUSR | S_IWUSR;
         root->i_uid = root->i_gid = 0;
         root->i_atime = root->i_mtime = root->i_ctime = CURRENT_TIME;
+       root->i_change_attribute = 1;
         dentry = d_alloc(NULL, &d_name);
         if (!dentry) {
                 iput(root);
@@ -242,6 +243,8 @@
  {
         struct inode *inode = old_dentry->d_inode;

+       inode->i_change_attribute++;
+       dir->i_change_attribute++;
         inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
         inc_nlink(inode);
         atomic_inc(&inode->i_count);
@@ -274,6 +277,8 @@
  {
         struct inode *inode = dentry->d_inode;

+       inode->i_change_attribute++;
+       dir->i_change_attribute++;
         inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
         drop_nlink(inode);
         dput(dentry);
@@ -312,6 +317,8 @@
         old_dir->i_ctime = old_dir->i_mtime = new_dir->i_ctime =
                 new_dir->i_mtime = inode->i_ctime = CURRENT_TIME;

+       old_dir->i_change_attribute++;
+       new_dir->i_change_attribute++;
         return 0;
  }

@@ -380,6 +387,7 @@
         inode->i_uid = inode->i_gid = 0;
         inode->i_blocks = 0;
         inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+       inode->i_change_attribute = 1;
         inode->i_op = &simple_dir_inode_operations;
         inode->i_fop = &simple_dir_operations;
         inode->i_nlink = 2;
@@ -401,6 +409,7 @@
                 inode->i_uid = inode->i_gid = 0;
                 inode->i_blocks = 0;
                 inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+               inode->i_change_attribute = 1;
                 inode->i_fop = files->ops;
                 inode->i_ino = i;
                 d_add(dentry, inode);
Index: linux-2.6.19-rc2-mm2-CA/fs/pipe.c
===================================================================
--- linux-2.6.19-rc2-mm2-CA.orig/fs/pipe.c      2006-11-09 17:20:58.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/fs/pipe.c   2006-11-29 15:04:19.000000000 +0100
@@ -864,6 +864,7 @@
         inode->i_uid = current->fsuid;
         inode->i_gid = current->fsgid;
         inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+       inode->i_change_attribute = 1;

         return inode;

Index: linux-2.6.19-rc2-mm2-CA/include/linux/fs.h
===================================================================
--- linux-2.6.19-rc2-mm2-CA.orig/include/linux/fs.h     2006-11-09 
17:21:55.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/include/linux/fs.h  2006-11-29 15:04:05.000000000 +0100
@@ -323,6 +323,7 @@
  #define ATTR_KILL_SUID 2048
  #define ATTR_KILL_SGID 4096
  #define ATTR_FILE      8192
+#define ATTR_CHANGE_ATTRIBUTE  16384

  /*
   * This is the Inode Attributes structure, used for notify_change().  It
@@ -342,6 +343,7 @@
         struct timespec ia_atime;
         struct timespec ia_mtime;
         struct timespec ia_ctime;
+       unsigned long   ia_change_attribute;

         /*
          * Not an attribute, but an auxilary info for filesystems wanting to
@@ -538,6 +540,7 @@
         struct timespec         i_atime;
         struct timespec         i_mtime;
         struct timespec         i_ctime;
+       unsigned long           i_change_attribute;
         unsigned int            i_blkbits;
         unsigned long           i_version;
         blkcnt_t                i_blocks;
