From: Cordenner jean noel <jean-noel.cordenner@bull.net>
Subject: [RFC] [patch 2/3] i_version update for ext4: ext4 specific code
Date: Tue, 23 Jan 2007 18:24:16 +0100
Message-ID: <45B644C0.50503@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: nfsv4@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49063 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965135AbXAWRY5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jan 2007 12:24:57 -0500
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This part of the patch contains the definition of the on-disk i_version 
field and its update

Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>

Index: linux-2.6.20-rc5/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.20-rc5.orig/fs/ext4/ialloc.c      2006-11-29 
22:57:37.000000000 +0100
+++ linux-2.6.20-rc5/fs/ext4/ialloc.c   2007-01-23 13:48:20.000000000 +0100
@@ -564,6 +564,7 @@
         /* This is the optimal IO size (for stat), not the fs block size */
         inode->i_blocks = 0;
         inode->i_mtime = inode->i_atime = inode->i_ctime = 
CURRENT_TIME_SEC;
+       inode->i_version = 1;

         memset(ei->i_data, 0, sizeof(ei->i_data));
         ei->i_dir_start_lookup = 0;
Index: linux-2.6.20-rc5/fs/ext4/inode.c
===================================================================
--- linux-2.6.20-rc5.orig/fs/ext4/inode.c       2007-01-19 
16:59:14.000000000 +0100
+++ linux-2.6.20-rc5/fs/ext4/inode.c    2007-01-23 13:45:02.000000000 +0100
@@ -728,6 +728,7 @@
         /* We are done with atomic stuff, now do the rest of 
housekeeping */

         inode->i_ctime = CURRENT_TIME_SEC;
+       inode->i_version++;
         ext4_mark_inode_dirty(handle, inode);

         /* had we spliced it onto indirect block? */
@@ -2442,6 +2443,7 @@

         mutex_unlock(&ei->truncate_mutex);
         inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
+       inode->i_version++;
         ext4_mark_inode_dirty(handle, inode);

         /*
@@ -2680,6 +2682,7 @@
         inode->i_ctime.tv_sec = le32_to_cpu(raw_inode->i_ctime);
         inode->i_mtime.tv_sec = le32_to_cpu(raw_inode->i_mtime);
         inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec = 
inode->i_mtime.tv_nsec = 0;
+       inode->i_version = le32_to_cpu(raw_inode->ext4_i_version);

         ei->i_state = 0;
         ei->i_dir_start_lookup = 0;
@@ -2838,6 +2841,7 @@
         raw_inode->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
         raw_inode->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
         raw_inode->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
+       raw_inode->ext4_i_version = cpu_to_le32(inode->i_version);
         raw_inode->i_blocks = cpu_to_le32(inode->i_blocks);
         raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
         raw_inode->i_flags = cpu_to_le32(ei->i_flags);
Index: linux-2.6.20-rc5/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.20-rc5.orig/include/linux/ext4_fs.h       2006-11-29 
22:57:37.000000000 +0100
+++ linux-2.6.20-rc5/include/linux/ext4_fs.h    2007-01-23 
13:47:32.000000000 +0100
@@ -291,7 +291,7 @@
         __le32  i_flags;        /* File flags */
         union {
                 struct {
-                       __u32  l_i_reserved1;
+                       __u32  l_i_version;
                 } linux1;
                 struct {
                         __u32  h_i_translator;
@@ -336,7 +336,7 @@
  #define i_size_high    i_dir_acl

  #if defined(__KERNEL__) || defined(__linux__)
-#define i_reserved1    osd1.linux1.l_i_reserved1
+#define ext4_i_version  osd1.linux1.l_i_version
  #define i_frag         osd2.linux2.l_i_frag
  #define i_fsize                osd2.linux2.l_i_fsize
  #define i_file_acl_high        osd2.linux2.l_i_file_acl_high
Index: linux-2.6.20-rc5/fs/ext4/ioctl.c
===================================================================
--- linux-2.6.20-rc5.orig/fs/ext4/ioctl.c       2007-01-19 
16:59:14.000000000 +0100
+++ linux-2.6.20-rc5/fs/ext4/ioctl.c    2007-01-23 13:49:58.000000000 +0100
@@ -97,6 +97,7 @@

                 ext4_set_inode_flags(inode);
                 inode->i_ctime = CURRENT_TIME_SEC;
+               inode->i_version++;

                 err = ext4_mark_iloc_dirty(handle, inode, &iloc);
  flags_err:
@@ -134,6 +135,7 @@
                 err = ext4_reserve_inode_write(handle, inode, &iloc);
                 if (err == 0) {
                         inode->i_ctime = CURRENT_TIME_SEC;
+                       inode->i_version++;
                         inode->i_generation = generation;
                         err = ext4_mark_iloc_dirty(handle, inode, &iloc);
                 }
Index: linux-2.6.20-rc5/fs/ext4/namei.c
===================================================================
--- linux-2.6.20-rc5.orig/fs/ext4/namei.c       2007-01-19 
16:59:14.000000000 +0100
+++ linux-2.6.20-rc5/fs/ext4/namei.c    2007-01-23 15:10:19.000000000 +0100
@@ -2059,6 +2059,7 @@
         inode->i_size = 0;
         ext4_orphan_add(handle, inode);
         inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
+       inode->i_version++;
         ext4_mark_inode_dirty(handle, inode);
         drop_nlink(dir);
         ext4_update_dx_flag(dir);
@@ -2109,12 +2110,14 @@
         if (retval)
                 goto end_unlink;
         dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
+       dir->i_version++;
         ext4_update_dx_flag(dir);
         ext4_mark_inode_dirty(handle, dir);
         drop_nlink(inode);
         if (!inode->i_nlink)
                 ext4_orphan_add(handle, inode);
         inode->i_ctime = dir->i_ctime;
+       inode->i_version++;
         ext4_mark_inode_dirty(handle, inode);
         retval = 0;

@@ -2200,6 +2203,7 @@
                 handle->h_sync = 1;

         inode->i_ctime = CURRENT_TIME_SEC;
+       inode->i_version++;
         ext4_inc_count(handle, inode);
         atomic_inc(&inode->i_count);

@@ -2302,6 +2306,7 @@
          * rename.
          */
         old_inode->i_ctime = CURRENT_TIME_SEC;
+       old_inode->i_version++;
         ext4_mark_inode_dirty(handle, old_inode);

         /*
@@ -2335,8 +2340,10 @@
         if (new_inode) {
                 drop_nlink(new_inode);
                 new_inode->i_ctime = CURRENT_TIME_SEC;
+               new_inode->i_version++;
         }
         old_dir->i_ctime = old_dir->i_mtime = CURRENT_TIME_SEC;
+       old_dir->i_version++;
         ext4_update_dx_flag(old_dir);
         if (dir_bh) {
                 BUFFER_TRACE(dir_bh, "get_write_access");
Index: linux-2.6.20-rc5/fs/ext4/super.c
===================================================================
--- linux-2.6.20-rc5.orig/fs/ext4/super.c       2007-01-19 
16:59:14.000000000 +0100
+++ linux-2.6.20-rc5/fs/ext4/super.c    2007-01-23 15:35:11.000000000 +0100
@@ -2784,8 +2784,8 @@
                 i_size_write(inode, off+len-towrite);
                 EXT4_I(inode)->i_disksize = inode->i_size;
         }
-       inode->i_version++;
         inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+       inode->i_version = 1;
         ext4_mark_inode_dirty(handle, inode);
         mutex_unlock(&inode->i_mutex);
         return len - towrite;
Index: linux-2.6.20-rc5/fs/ext4/xattr.c
===================================================================
--- linux-2.6.20-rc5.orig/fs/ext4/xattr.c       2007-01-19 
16:59:14.000000000 +0100
+++ linux-2.6.20-rc5/fs/ext4/xattr.c    2007-01-23 15:36:20.000000000 +0100
@@ -1005,6 +1005,7 @@
         if (!error) {
                 ext4_xattr_update_super_block(handle, inode->i_sb);
                 inode->i_ctime = CURRENT_TIME_SEC;
+               inode->i_version++;
                 error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
                 /*
                  * The bh is consumed by ext4_mark_iloc_dirty, even with
