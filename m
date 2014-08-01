From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH 3/4] quota: add project quota support
Date: Fri, 1 Aug 2014 09:07:50 +0800
Message-ID: <CAPTn0cCRzZSKhaqnuGGDJ2tVwC-=NX2TkNfOVd-sYGfBZ1vBPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:49472 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbaHABHv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2014 21:07:51 -0400
Received: by mail-ig0-f175.google.com with SMTP id uq10so645538igb.8
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2014 18:07:50 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adds project ID support for ext4

This patch adds a new internal field of ext4 inode to save project
identifier.

Signed-off-by: Li Xi <lixi <at> ddn.com>
---
Index: linux.git/fs/ext4/ialloc.c
===================================================================
--- linux.git.orig/fs/ext4/ialloc.c
+++ linux.git/fs/ext4/ialloc.c
@@ -756,6 +756,7 @@ struct inode *__ext4_new_inode(handle_t
         inode->i_gid = dir->i_gid;
     } else
         inode_init_owner(inode, dir, mode);
+    inode->i_projid = dir->i_projid;
     dquot_initialize(inode);

     if (!goal)
Index: linux.git/fs/ext4/ext4.h
===================================================================
--- linux.git.orig/fs/ext4/ext4.h
+++ linux.git/fs/ext4/ext4.h
@@ -695,6 +695,7 @@ struct ext4_inode {
     __le32  i_crtime;       /* File Creation time */
     __le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
     __le32  i_version_hi;    /* high 32 bits for 64-bit version */
+    __le32  i_projid;    /* Project ID */
 };

 struct move_extent {
@@ -2108,6 +2109,8 @@ int do_journal_get_write_access(handle_t
 #define CONVERT_INLINE_DATA     2

 extern struct inode *ext4_iget(struct super_block *, unsigned long);
+extern projid_t ext4_inode_projid_get(struct inode *, struct ext4_inode *,
+                      struct ext4_inode_info *);
 extern int  ext4_write_inode(struct inode *, struct writeback_control *);
 extern int  ext4_setattr(struct dentry *, struct iattr *);
 extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
Index: linux.git/fs/ext4/inode.c
===================================================================
--- linux.git.orig/fs/ext4/inode.c
+++ linux.git/fs/ext4/inode.c
@@ -4026,6 +4026,28 @@ static inline void ext4_iget_extra_inode
         EXT4_I(inode)->i_inline_off = 0;
 }

+projid_t ext4_inode_projid_get(struct inode *inode, struct ext4_inode *raw,
+                   struct ext4_inode_info *ei)
+{
+    projid_t projid = 0;
+
+    if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
+        EXT4_FITS_IN_INODE(raw, ei, i_projid))
+        projid = (projid_t)le32_to_cpu(raw->i_projid);
+    return projid;
+}
+
+static void ext4_inode_projid_set(struct inode *inode, struct ext4_inode *raw,
+                  struct ext4_inode_info *ei)
+{
+    __u32 projid;
+
+    projid = __kprojid_val(inode->i_projid);
+    if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
+        EXT4_FITS_IN_INODE(raw, ei, i_projid))
+        raw->i_projid = cpu_to_le32(projid);
+}
+
 struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 {
     struct ext4_iloc iloc;
@@ -4037,6 +4059,7 @@ struct inode *ext4_iget(struct super_blo
     int block;
     uid_t i_uid;
     gid_t i_gid;
+    projid_t i_projid;

     inode = iget_locked(sb, ino);
     if (!inode)
@@ -4087,12 +4110,14 @@ struct inode *ext4_iget(struct super_blo
     inode->i_mode = le16_to_cpu(raw_inode->i_mode);
     i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
     i_gid = (gid_t)le16_to_cpu(raw_inode->i_gid_low);
+    i_projid = ext4_inode_projid_get(inode, raw_inode, ei);
     if (!(test_opt(inode->i_sb, NO_UID32))) {
         i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
         i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
     }
     i_uid_write(inode, i_uid);
     i_gid_write(inode, i_gid);
+    i_projid_write(inode, i_projid);
     set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));

     ext4_clear_state_flags(ei);    /* Only relevant on 32-bit archs */
@@ -4407,6 +4432,8 @@ static int ext4_do_update_inode(handle_t

     ext4_inode_csum_set(inode, raw_inode, ei);

+    ext4_inode_projid_set(inode, raw_inode, ei);
+
     spin_unlock(&ei->i_raw_lock);

     BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
@@ -4591,7 +4618,8 @@ int ext4_setattr(struct dentry *dentry,
     if (is_quota_modification(inode, attr))
         dquot_initialize(inode);
     if ((ia_valid & ATTR_UID && !uid_eq(attr->ia_uid, inode->i_uid)) ||
-        (ia_valid & ATTR_GID && !gid_eq(attr->ia_gid, inode->i_gid))) {
+        (ia_valid & ATTR_GID && !gid_eq(attr->ia_gid, inode->i_gid)) ||
+        (ia_valid & ATTR_PROJID && !projid_eq(attr->ia_projid,
inode->i_projid))) {
         handle_t *handle;

         /* (user+group)*(old+new) structure, inode write (sb,
@@ -4614,6 +4642,8 @@ int ext4_setattr(struct dentry *dentry,
             inode->i_uid = attr->ia_uid;
         if (attr->ia_valid & ATTR_GID)
             inode->i_gid = attr->ia_gid;
+        if (attr->ia_valid & ATTR_PROJID)
+            inode->i_projid = attr->ia_projid;
         error = ext4_mark_inode_dirty(handle, inode);
         ext4_journal_stop(handle);
     }
