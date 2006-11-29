From: Jean-Noel Cordenner <jean-noel.cordenner@bull.net>
Subject: [RFC] [patch 2/3] change attribute for ext4: ext4 specific code
Date: Wed, 29 Nov 2006 19:54:18 +0100
Message-ID: <456DD75A.2010700@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:1415 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S967539AbWK2SxN
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Nov 2006 13:53:13 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id DDB9D19D926
	for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2006 19:53:07 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 21645-02 for <linux-ext4@vger.kernel.org>;
 Wed, 29 Nov 2006 19:53:03 +0100 (CET)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 216E819D920
	for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2006 19:53:03 +0100 (CET)
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This part of the patch concerns the ext4 code.



Signed-off-by: Celine Bourde
Signed-off-by: Alexandre Ratchov
Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>


--- linux-2.6.19-rc2-mm2-CA.orig/fs/ext4/ialloc.c       2006-11-09 
17:20:57.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/fs/ext4/ialloc.c    2006-11-29 15:34:35.000000000 +0100
@@ -564,6 +564,7 @@
         /* This is the optimal IO size (for stat), not the fs block size */
         inode->i_blocks = 0;
         inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
+       inode->i_change_attribute = 1;

         memset(ei->i_data, 0, sizeof(ei->i_data));
         ei->i_dir_start_lookup = 0;
Index: linux-2.6.19-rc2-mm2-CA/fs/ext4/inode.c
===================================================================
--- linux-2.6.19-rc2-mm2-CA.orig/fs/ext4/inode.c        2006-11-09 
17:20:57.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/fs/ext4/inode.c     2006-11-29 15:38:39.000000000 +0100
@@ -728,6 +728,7 @@
         /* We are done with atomic stuff, now do the rest of housekeeping */

         inode->i_ctime = CURRENT_TIME_SEC;
+       inode->i_change_attribute++;
         ext4_mark_inode_dirty(handle, inode);

         /* had we spliced it onto indirect block? */
@@ -2377,6 +2378,7 @@

         mutex_unlock(&ei->truncate_mutex);
         inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
+       inode->i_change_attribute++;
         ext4_mark_inode_dirty(handle, inode);

         /*
@@ -2615,6 +2617,7 @@
         inode->i_ctime.tv_sec = le32_to_cpu(raw_inode->i_ctime);
         inode->i_mtime.tv_sec = le32_to_cpu(raw_inode->i_mtime);
         inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec = 
inode->i_mtime.tv_nsec = 0;
+       inode->i_change_attribute = le32_to_cpu(raw_inode->i_chattr);

         ei->i_state = 0;
         ei->i_dir_start_lookup = 0;
@@ -2773,6 +2776,7 @@
         raw_inode->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
         raw_inode->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
         raw_inode->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
+       raw_inode->i_chattr = cpu_to_le32(inode->i_change_attribute);
         raw_inode->i_blocks = cpu_to_le32(inode->i_blocks);
         raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
         raw_inode->i_flags = cpu_to_le32(ei->i_flags);
Index: linux-2.6.19-rc2-mm2-CA/fs/ext4/ioctl.c
===================================================================
--- linux-2.6.19-rc2-mm2-CA.orig/fs/ext4/ioctl.c        2006-11-29 
15:41:28.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/fs/ext4/ioctl.c     2006-11-29 15:42:21.000000000 +0100
@@ -97,6 +97,7 @@

                 ext4_set_inode_flags(inode);
                 inode->i_ctime = CURRENT_TIME_SEC;
+               inode->i_change_attribute++;

                 err = ext4_mark_iloc_dirty(handle, inode, &iloc);
  flags_err:
@@ -134,6 +135,7 @@
                 err = ext4_reserve_inode_write(handle, inode, &iloc);
                 if (err == 0) {
                         inode->i_ctime = CURRENT_TIME_SEC;
+                       inode->i_change_attribute++;
                         inode->i_generation = generation;
                         err = ext4_mark_iloc_dirty(handle, inode, &iloc);
                 }
Index: linux-2.6.19-rc2-mm2-CA/fs/ext4/namei.c
===================================================================
--- linux-2.6.19-rc2-mm2-CA.orig/fs/ext4/namei.c        2006-11-09 
17:20:57.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/fs/ext4/namei.c     2006-11-29 15:53:06.000000000 +0100
@@ -1274,6 +1274,7 @@
          * and/or different from the directory change time.
          */
         dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+       dir->i_change_attribute++;
         ext4_update_dx_flag(dir);
         dir->i_version++;
         ext4_mark_inode_dirty(handle, dir);
@@ -2050,6 +2051,8 @@
         inode->i_size = 0;
         ext4_orphan_add(handle, inode);
         inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
+       inode->i_change_attribute++;
+       dir->i_change_attribute++;
         ext4_mark_inode_dirty(handle, inode);
         drop_nlink(dir);
         ext4_update_dx_flag(dir);
@@ -2100,12 +2103,14 @@
         if (retval)
                 goto end_unlink;
         dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
+       dir->i_change_attribute++;
         ext4_update_dx_flag(dir);
         ext4_mark_inode_dirty(handle, dir);
         drop_nlink(inode);
         if (!inode->i_nlink)
                 ext4_orphan_add(handle, inode);
         inode->i_ctime = dir->i_ctime;
+       inode->i_change_attribute++;
         ext4_mark_inode_dirty(handle, inode);
         retval = 0;

@@ -2191,6 +2196,7 @@
                 handle->h_sync = 1;

         inode->i_ctime = CURRENT_TIME_SEC;
+       inode->i_change_attribute++;
         ext4_inc_count(handle, inode);
         atomic_inc(&inode->i_count);

@@ -2293,6 +2299,7 @@
          * rename.
          */
         old_inode->i_ctime = CURRENT_TIME_SEC;
+       old_inode->i_change_attribute++;
         ext4_mark_inode_dirty(handle, old_inode);

         /*
@@ -2326,8 +2333,10 @@
         if (new_inode) {
                 drop_nlink(new_inode);
                 new_inode->i_ctime = CURRENT_TIME_SEC;
+               new_inode->i_change_attribute++;
         }
         old_dir->i_ctime = old_dir->i_mtime = CURRENT_TIME_SEC;
+       old_dir->i_change_attribute++;
         ext4_update_dx_flag(old_dir);
         if (dir_bh) {
                 BUFFER_TRACE(dir_bh, "get_write_access");
Index: linux-2.6.19-rc2-mm2-CA/fs/ext4/super.c
===================================================================
--- linux-2.6.19-rc2-mm2-CA.orig/fs/ext4/super.c        2006-11-09 
17:20:57.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/fs/ext4/super.c     2006-11-29 15:57:02.000000000 +0100
@@ -2780,6 +2780,7 @@
         }
         inode->i_version++;
         inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+       inode->i_change_attribute = 1;
         ext4_mark_inode_dirty(handle, inode);
         mutex_unlock(&inode->i_mutex);
         return len - towrite;
Index: linux-2.6.19-rc2-mm2-CA/fs/ext4/xattr.c
===================================================================
--- linux-2.6.19-rc2-mm2-CA.orig/fs/ext4/xattr.c        2006-11-09 
17:20:57.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/fs/ext4/xattr.c     2006-11-29 15:57:50.000000000 +0100
@@ -1005,6 +1005,7 @@
         if (!error) {
                 ext4_xattr_update_super_block(handle, inode->i_sb);
                 inode->i_ctime = CURRENT_TIME_SEC;
+               inode->i_change_attribute++;
                 error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
                 /*
                  * The bh is consumed by ext4_mark_iloc_dirty, even with
Index: linux-2.6.19-rc2-mm2-CA/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.19-rc2-mm2-CA.orig/include/linux/ext4_fs.h        2006-11-09 
17:21:48.000000000 +0100
+++ linux-2.6.19-rc2-mm2-CA/include/linux/ext4_fs.h     2006-11-29 
16:15:01.000000000 +0100
@@ -312,7 +312,7 @@
                         __le16  l_i_file_acl_high;
                         __le16  l_i_uid_high;   /* these 2 fields    */
                         __le16  l_i_gid_high;   /* were reserved2[0] */
-                       __u32   l_i_reserved2;
+                       __u32   l_i_change_attribute;
                 } linux2;
                 struct {
                         __u8    h_i_frag;       /* Fragment number */
@@ -344,7 +344,7 @@
  #define i_gid_low      i_gid
  #define i_uid_high     osd2.linux2.l_i_uid_high
  #define i_gid_high     osd2.linux2.l_i_gid_high
-#define i_reserved2    osd2.linux2.l_i_reserved2
+#define i_chattr       osd2.linux2.l_i_change_attribute

  #elif defined(__GNU__)
