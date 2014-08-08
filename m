From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH v2 2/4] quota: add project quota support
Date: Sat, 9 Aug 2014 00:43:27 +0800
Message-ID: <CAPTn0cDUkdwKXFVQ+i7DbR-e1rPfpvEH+Vchb4QWb=9V8tjzjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@zeniv.linux.org.uk, hch@infradead.org, Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Adds project ID support for ext4

This patch adds a new internal field of ext4 inode to save project
identifier.

Signed-off-by: Li Xi <lixi <at> ddn.com>
---
Index: linux.git/fs/ext4/ialloc.c
===================================================================
--- linux.git.orig/fs/ext4/ialloc.c
+++ linux.git/fs/ext4/ialloc.c
@@ -756,6 +756,10 @@ struct inode *__ext4_new_inode(handle_t
         inode->i_gid = dir->i_gid;
     } else
         inode_init_owner(inode, dir, mode);
+#ifdef CONFIG_QUOTA_PROJECT
+    if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT))
+        ei->i_projid = EXT4_I(dir)->i_projid;
+#endif
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
@@ -943,6 +944,9 @@ struct ext4_inode_info {

     /* Precomputed uuid+inum+igen checksum for seeding inode checksums */
     __u32 i_csum_seed;
+#ifdef CONFIG_QUOTA_PROJECT
+    kprojid_t i_projid;
+#endif
 };

 /*
@@ -1525,6 +1529,7 @@ static inline void ext4_clear_state_flag
  * GDT_CSUM bits are mutually exclusive.
  */
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM    0x0400
+#define EXT4_FEATURE_RO_COMPAT_PROJECT        0x1000 /* Project quota */

 #define EXT4_FEATURE_INCOMPAT_COMPRESSION    0x0001
 #define EXT4_FEATURE_INCOMPAT_FILETYPE        0x0002
@@ -1574,7 +1579,8 @@ static inline void ext4_clear_state_flag
                      EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
                      EXT4_FEATURE_RO_COMPAT_BIGALLOC |\
                      EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
-                     EXT4_FEATURE_RO_COMPAT_QUOTA)
+                     EXT4_FEATURE_RO_COMPAT_QUOTA |\
+                     EXT4_FEATURE_RO_COMPAT_PROJECT)

 /*
  * Default values for user and/or group using reserved blocks
@@ -2133,6 +2139,9 @@ extern int ext4_zero_partial_blocks(hand
                  loff_t lstart, loff_t lend);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
+#ifdef CONFIG_QUOTA_PROJECT
+extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
+#endif
 extern void ext4_da_update_reserve_space(struct inode *inode,
                     int used, int quota_claim);

Index: linux.git/fs/ext4/inode.c
===================================================================
--- linux.git.orig/fs/ext4/inode.c
+++ linux.git/fs/ext4/inode.c
@@ -4026,6 +4026,47 @@ static inline void ext4_iget_extra_inode
         EXT4_I(inode)->i_inline_off = 0;
 }

+#ifdef CONFIG_QUOTA_PROJECT
+static int ext4_inode_projid_get(struct inode *inode, struct ext4_inode *raw,
+                 struct ext4_inode_info *ei, projid_t *projid)
+{
+    BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+            EXT4_FEATURE_RO_COMPAT_PROJECT));
+
+    if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
+        EXT4_FITS_IN_INODE(raw, ei, i_projid)) {
+        *projid = (projid_t)le32_to_cpu(raw->i_projid);
+        return 0;
+    }
+    return -EFBIG;
+}
+
+static int ext4_inode_projid_set(struct inode *inode, struct ext4_inode *raw,
+                 struct ext4_inode_info *ei, projid_t projid)
+{
+    BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+            EXT4_FEATURE_RO_COMPAT_PROJECT));
+
+    if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
+        EXT4_FITS_IN_INODE(raw, ei, i_projid)) {
+        raw->i_projid = cpu_to_le32(projid);
+        return 0;
+    }
+    return -EFBIG;
+}
+
+int ext4_get_projid(struct inode *inode, kprojid_t *projid)
+{
+    if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+            EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+        return -ENOTSUPP;
+    }
+
+    *projid = EXT4_I(inode)->i_projid;
+    return 0;
+}
+#endif
+
 struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 {
     struct ext4_iloc iloc;
@@ -4037,6 +4078,9 @@ struct inode *ext4_iget(struct super_blo
     int block;
     uid_t i_uid;
     gid_t i_gid;
+#ifdef CONFIG_QUOTA_PROJECT
+    projid_t i_projid = 0;
+#endif

     inode = iget_locked(sb, ino);
     if (!inode)
@@ -4087,12 +4131,26 @@ struct inode *ext4_iget(struct super_blo
     inode->i_mode = le16_to_cpu(raw_inode->i_mode);
     i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
     i_gid = (gid_t)le16_to_cpu(raw_inode->i_gid_low);
+#ifdef CONFIG_QUOTA_PROJECT
+    if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+        ret = ext4_inode_projid_get(inode, raw_inode, ei, &i_projid);
+        if (ret) {
+            EXT4_ERROR_INODE(inode, "failed to get project ID");
+            goto bad_inode;
+        }
+    }
+#endif
+
     if (!(test_opt(inode->i_sb, NO_UID32))) {
         i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
         i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
     }
     i_uid_write(inode, i_uid);
     i_gid_write(inode, i_gid);
+#ifdef CONFIG_QUOTA_PROJECT
+    if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT))
+        ei->i_projid = make_kprojid(&init_user_ns, i_projid);;
+#endif
     set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));

     ext4_clear_state_flags(ei);    /* Only relevant on 32-bit archs */
@@ -4315,6 +4373,9 @@ static int ext4_do_update_inode(handle_t
     int need_datasync = 0, set_large_file = 0;
     uid_t i_uid;
     gid_t i_gid;
+#ifdef CONFIG_QUOTA_PROJECT
+    projid_t i_projid = 0;
+#endif

     spin_lock(&ei->i_raw_lock);

@@ -4327,6 +4388,10 @@ static int ext4_do_update_inode(handle_t
     raw_inode->i_mode = cpu_to_le16(inode->i_mode);
     i_uid = i_uid_read(inode);
     i_gid = i_gid_read(inode);
+#ifdef CONFIG_QUOTA_PROJECT
+    if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT))
+        i_projid = from_kprojid(&init_user_ns, ei->i_projid);
+#endif
     if (!(test_opt(inode->i_sb, NO_UID32))) {
         raw_inode->i_uid_low = cpu_to_le16(low_16_bits(i_uid));
         raw_inode->i_gid_low = cpu_to_le16(low_16_bits(i_gid));
@@ -4356,7 +4421,8 @@ static int ext4_do_update_inode(handle_t
     EXT4_INODE_SET_XTIME(i_atime, inode, raw_inode);
     EXT4_EINODE_SET_XTIME(i_crtime, ei, raw_inode);

-    if (ext4_inode_blocks_set(handle, raw_inode, ei)) {
+    err = ext4_inode_blocks_set(handle, raw_inode, ei);
+    if (err) {
         spin_unlock(&ei->i_raw_lock);
         goto out_brelse;
     }
@@ -4407,6 +4473,16 @@ static int ext4_do_update_inode(handle_t

     ext4_inode_csum_set(inode, raw_inode, ei);

+#ifdef CONFIG_QUOTA_PROJECT
+    if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+        err = ext4_inode_projid_set(inode, raw_inode, ei, i_projid);
+        if (err) {
+            spin_unlock(&ei->i_raw_lock);
+            goto out_brelse;
+        }
+    }
+#endif
+
     spin_unlock(&ei->i_raw_lock);

     BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
Index: linux.git/fs/ext4/super.c
===================================================================
--- linux.git.orig/fs/ext4/super.c
+++ linux.git/fs/ext4/super.c
@@ -1080,6 +1080,9 @@ static const struct dquot_operations ext
     .write_info    = ext4_write_info,
     .alloc_dquot    = dquot_alloc,
     .destroy_dquot    = dquot_destroy,
+#ifdef CONFIG_QUOTA_PROJECT
+    .get_projid    = ext4_get_projid,
+#endif
 };

 static const struct quotactl_ops ext4_qctl_operations = {
