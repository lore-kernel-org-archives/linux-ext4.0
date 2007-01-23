From: Cordenner jean noel <jean-noel.cordenner@bull.net>
Subject: [RFC] [patch 1/3] i_version update for ext4: VFS layer
Date: Tue, 23 Jan 2007 18:24:13 +0100
Message-ID: <45B644BD.7020506@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: nfsv4@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49058 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965120AbXAWRYx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jan 2007 12:24:53 -0500
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This part of the patch concerns the update of the i_version in the VFS 
layer.

Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>

Index: linux-2.6.20-rc5/fs/attr.c
===================================================================
--- linux-2.6.20-rc5.orig/fs/attr.c     2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6.20-rc5/fs/attr.c  2007-01-22 17:03:41.000000000 +0100
@@ -113,6 +113,7 @@
         now = current_fs_time(inode->i_sb);

         attr->ia_ctime = now;
+       inode->i_version++;
         if (!(ia_valid & ATTR_ATIME_SET))
                 attr->ia_atime = now;
         if (!(ia_valid & ATTR_MTIME_SET))
Index: linux-2.6.20-rc5/fs/bad_inode.c
===================================================================
--- linux-2.6.20-rc5.orig/fs/bad_inode.c        2007-01-19 
16:59:14.000000000 +0100
+++ linux-2.6.20-rc5/fs/bad_inode.c     2007-01-22 17:04:58.000000000 +0100
@@ -343,6 +343,7 @@
         inode->i_mode = S_IFREG;
         inode->i_atime = inode->i_mtime = inode->i_ctime =
                 current_fs_time(inode->i_sb);
+       inode->i_version++;
         inode->i_op = &bad_inode_ops;
         inode->i_fop = &bad_file_ops;
  }
Index: linux-2.6.20-rc5/fs/binfmt_misc.c
===================================================================
--- linux-2.6.20-rc5.orig/fs/binfmt_misc.c      2007-01-19 
16:59:14.000000000 +0100
+++ linux-2.6.20-rc5/fs/binfmt_misc.c   2007-01-22 17:05:54.000000000 +0100
@@ -508,6 +508,7 @@
                 inode->i_blocks = 0;
                 inode->i_atime = inode->i_mtime = inode->i_ctime =
                         current_fs_time(inode->i_sb);
+               inode->i_version = 1;
         }
         return inode;
  }
Index: linux-2.6.20-rc5/fs/inode.c
===================================================================
--- linux-2.6.20-rc5.orig/fs/inode.c    2007-01-19 16:59:15.000000000 +0100
+++ linux-2.6.20-rc5/fs/inode.c 2007-01-22 17:18:28.000000000 +0100
@@ -1225,18 +1225,11 @@
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
+       inode->i_version++;

-       if (sync_it)
-               mark_inode_dirty_sync(inode);
+       mark_inode_dirty_sync(inode);
  }

  EXPORT_SYMBOL(file_update_time);
Index: linux-2.6.20-rc5/fs/libfs.c
===================================================================
--- linux-2.6.20-rc5.orig/fs/libfs.c    2007-01-19 16:59:15.000000000 +0100
+++ linux-2.6.20-rc5/fs/libfs.c 2007-01-22 17:23:13.000000000 +0100
@@ -220,6 +220,7 @@
         root->i_mode = S_IFDIR | S_IRUSR | S_IWUSR;
         root->i_uid = root->i_gid = 0;
         root->i_atime = root->i_mtime = root->i_ctime = CURRENT_TIME;
+       root->i_version = 1;
         dentry = d_alloc(NULL, &d_name);
         if (!dentry) {
                 iput(root);
@@ -243,6 +244,8 @@
         struct inode *inode = old_dentry->d_inode;

         inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+       inode->i_version++;
+       dir->i_version++;
         inc_nlink(inode);
         atomic_inc(&inode->i_count);
         dget(dentry);
@@ -275,6 +278,8 @@
         struct inode *inode = dentry->d_inode;

         inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+       inode->i_version++;
+       dir->i_version++;
         drop_nlink(inode);
         dput(dentry);
         return 0;
@@ -312,6 +317,8 @@
         old_dir->i_ctime = old_dir->i_mtime = new_dir->i_ctime =
                 new_dir->i_mtime = inode->i_ctime = CURRENT_TIME;

+       old_dir->i_version++;
+       new_dir->i_version++;
         return 0;
  }

@@ -377,6 +384,7 @@
         inode->i_uid = inode->i_gid = 0;
         inode->i_blocks = 0;
         inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+       inode->i_version = 1;
         inode->i_op = &simple_dir_inode_operations;
         inode->i_fop = &simple_dir_operations;
         inode->i_nlink = 2;
@@ -398,6 +406,7 @@
                 inode->i_uid = inode->i_gid = 0;
                 inode->i_blocks = 0;
                 inode->i_atime = inode->i_mtime = inode->i_ctime = 
CURRENT_TIME;
+               inode->i_version = 1;
                 inode->i_fop = files->ops;
                 inode->i_ino = i;
                 d_add(dentry, inode);
Index: linux-2.6.20-rc5/fs/pipe.c
===================================================================
--- linux-2.6.20-rc5.orig/fs/pipe.c     2007-01-19 16:59:15.000000000 +0100
+++ linux-2.6.20-rc5/fs/pipe.c  2007-01-22 17:24:46.000000000 +0100
@@ -871,6 +871,7 @@
         inode->i_uid = current->fsuid;
         inode->i_gid = current->fsgid;
         inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+       inode->i_version = 1;

         return inode;
