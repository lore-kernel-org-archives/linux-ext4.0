From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH 0/4] quota: add project quota support
Date: Fri, 1 Aug 2014 09:06:25 +0800
Message-ID: <CAPTn0cDvnmojeFeyAap2EuO4RR0+FBAf6tik7xMctYRriLv3jg@mail.gmail.com>
References: <CAPTn0cBJMx=s5YhKPEVgGa4xvxP1H9L=gJaK1iP4dkooHzr_FA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:40651 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaHABG0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2014 21:06:26 -0400
Received: by mail-ig0-f179.google.com with SMTP id h18so642459igc.12
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2014 18:06:26 -0700 (PDT)
In-Reply-To: <CAPTn0cBJMx=s5YhKPEVgGa4xvxP1H9L=gJaK1iP4dkooHzr_FA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PATCH 1/4] quota: add project quota support

Adds project identifier of inode.

Project identifier is saved as an internal attribute of inode.
This patch adds a new field in inode structure and inode attribute
structure for project ID.

Signed-off-by: Li Xi <lixi <at> ddn.com>
---
 /* First generic header */
Index: linux.git/include/linux/fs.h
===================================================================
--- linux.git.orig/include/linux/fs.h
+++ linux.git/include/linux/fs.h
@@ -26,6 +26,7 @@
 #include <linux/shrinker.h>
 #include <linux/migrate_mode.h>
 #include <linux/uidgid.h>
+#include <linux/projid.h>
 #include <linux/lockdep.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/blk_types.h>
@@ -223,6 +224,7 @@ typedef void (dio_iodone_t)(struct kiocb
 #define ATTR_KILL_PRIV    (1 << 14)
 #define ATTR_OPEN    (1 << 15) /* Truncating from open(O_TRUNC) */
 #define ATTR_TIMES_SET    (1 << 16)
+#define ATTR_PROJID    (1 << 17)

 /*
  * This is the Inode Attributes structure, used for notify_change().  It
@@ -238,6 +240,7 @@ struct iattr {
     umode_t        ia_mode;
     kuid_t        ia_uid;
     kgid_t        ia_gid;
+    kprojid_t    ia_projid;
     loff_t        ia_size;
     struct timespec    ia_atime;
     struct timespec    ia_mtime;
@@ -504,6 +507,7 @@ struct inode {
     unsigned short        i_opflags;
     kuid_t            i_uid;
     kgid_t            i_gid;
+    kprojid_t        i_projid;
     unsigned int        i_flags;

 #ifdef CONFIG_FS_POSIX_ACL
@@ -701,6 +705,11 @@ static inline void i_gid_write(struct in
     inode->i_gid = make_kgid(&init_user_ns, gid);
 }

+static inline void i_projid_write(struct inode *inode, projid_t projid)
+{
+    inode->i_projid = make_kprojid(&init_user_ns, projid);
+}
+
 static inline unsigned iminor(const struct inode *inode)
 {
     return MINOR(inode->i_rdev);
Index: linux.git/fs/attr.c
===================================================================
--- linux.git.orig/fs/attr.c
+++ linux.git/fs/attr.c
@@ -60,6 +60,11 @@ int inode_change_ok(const struct inode *
         !capable_wrt_inode_uidgid(inode, CAP_CHOWN))
         return -EPERM;

+    /* Make sure caller can change project. */
+    if ((ia_valid & ATTR_PROJID) &&
+        (!capable(CAP_SYS_ADMIN)))
+        return -EPERM;
+
     /* Make sure a caller can chmod. */
     if (ia_valid & ATTR_MODE) {
         if (!inode_owner_or_capable(inode))
@@ -147,6 +152,8 @@ void setattr_copy(struct inode *inode, c
         inode->i_uid = attr->ia_uid;
     if (ia_valid & ATTR_GID)
         inode->i_gid = attr->ia_gid;
+    if (ia_valid & ATTR_PROJID)
+        inode->i_projid = attr->ia_projid;
     if (ia_valid & ATTR_ATIME)
         inode->i_atime = timespec_trunc(attr->ia_atime,
                         inode->i_sb->s_time_gran);
@@ -197,7 +204,8 @@ int notify_change(struct dentry * dentry

     WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));

-    if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_TIMES_SET)) {
+    if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_PROJID |
+            ATTR_TIMES_SET)) {
         if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
             return -EPERM;
     }
Index: linux.git/fs/inode.c
===================================================================
--- linux.git.orig/fs/inode.c
+++ linux.git/fs/inode.c
@@ -138,6 +138,7 @@ int inode_init_always(struct super_block
     inode->i_opflags = 0;
     i_uid_write(inode, 0);
     i_gid_write(inode, 0);
+    i_projid_write(inode, 0);
     atomic_set(&inode->i_writecount, 0);
     inode->i_size = 0;
     inode->i_blocks = 0;
