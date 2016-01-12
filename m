From: Li Xi <pkuelelixi@gmail.com>
Subject: [v16 1/4] ext4: adds project ID support
Date: Tue, 12 Jan 2016 17:56:07 +0900
Message-ID: <1452588970-18309-2-git-send-email-lixi@ddn.com>
References: <1452588970-18309-1-git-send-email-lixi@ddn.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org,
	dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35231 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934338AbcALI4V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2016 03:56:21 -0500
Received: by mail-pa0-f42.google.com with SMTP id ho8so75696593pac.2
        for <linux-ext4@vger.kernel.org>; Tue, 12 Jan 2016 00:56:21 -0800 (PST)
In-Reply-To: <1452588970-18309-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds project ID support for Ext4. ext4_get_projid()
is added as get_projid method of ext4. The behavior of inheriting
project ID is also added.

Signed-off-by: Li Xi <lixi@ddn.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h   |   17 +++++++++++++----
 fs/ext4/ialloc.c |    7 +++++++
 fs/ext4/inode.c  |   28 ++++++++++++++++++++++++++++
 fs/ext4/namei.c  |   19 +++++++++++++++++++
 fs/ext4/super.c  |    1 +
 5 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index cc7ca4e..c1bf4aa 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -378,14 +378,15 @@ struct flex_groups {
 #define EXT4_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
-#define EXT4_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
-#define EXT4_FL_USER_MODIFIABLE		0x004380FF /* User modifiable flags */
+#define EXT4_FL_USER_VISIBLE		0x304BDFFF /* User visible flags */
+#define EXT4_FL_USER_MODIFIABLE		0x204380FF /* User modifiable flags */
 
 /* Flags that should be inherited by new inodes from their parent. */
 #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
 			   EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
 			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
-			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL)
+			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL | \
+			   EXT4_PROJINHERIT_FL)
 
 /* Flags that are appropriate for regular files (all but dir-specific ones). */
 #define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
@@ -993,6 +994,7 @@ struct ext4_inode_info {
 	/* Encryption params */
 	struct ext4_crypt_info *i_crypt_info;
 #endif
+	kprojid_t i_projid;
 };
 
 /*
@@ -1754,7 +1756,8 @@ EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		ENCRYPT)
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC |\
 					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
-					 EXT4_FEATURE_RO_COMPAT_QUOTA)
+					 EXT4_FEATURE_RO_COMPAT_QUOTA |\
+					 EXT4_FEATURE_RO_COMPAT_PROJECT)
 
 #define EXTN_FEATURE_FUNCS(ver) \
 static inline bool ext4_has_unknown_ext##ver##_compat_features(struct super_block *sb) \
@@ -1796,6 +1799,11 @@ static inline bool ext4_has_incompat_features(struct super_block *sb)
 #define	EXT4_DEF_RESUID		0
 #define	EXT4_DEF_RESGID		0
 
+/*
+ * Default project ID
+ */
+#define	EXT4_DEF_PROJID		0
+
 #define EXT4_DEF_INODE_READAHEAD_BLKS	32
 
 /*
@@ -2485,6 +2493,7 @@ extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 			     loff_t lstart, loff_t lend);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
+extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
 extern void ext4_da_update_reserve_space(struct inode *inode,
 					int used, int quota_claim);
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 1b8024d..3fcfd50 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -799,6 +799,13 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 		inode->i_gid = dir->i_gid;
 	} else
 		inode_init_owner(inode, dir, mode);
+
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT) &&
+	    ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT))
+		ei->i_projid = EXT4_I(dir)->i_projid;
+	else
+		ei->i_projid = make_kprojid(&init_user_ns, EXT4_DEF_PROJID);
+
 	err = dquot_initialize(inode);
 	if (err)
 		goto out;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ea433a7..44a9d90 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4076,6 +4076,14 @@ static inline void ext4_iget_extra_inode(struct inode *inode,
 		EXT4_I(inode)->i_inline_off = 0;
 }
 
+int ext4_get_projid(struct inode *inode, kprojid_t *projid)
+{
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb, EXT4_FEATURE_RO_COMPAT_PROJECT))
+		return -EOPNOTSUPP;
+	*projid = EXT4_I(inode)->i_projid;
+	return 0;
+}
+
 struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 {
 	struct ext4_iloc iloc;
@@ -4087,6 +4095,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	int block;
 	uid_t i_uid;
 	gid_t i_gid;
+	projid_t i_projid;
 
 	inode = iget_locked(sb, ino);
 	if (!inode)
@@ -4136,12 +4145,20 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
 	i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
 	i_gid = (gid_t)le16_to_cpu(raw_inode->i_gid_low);
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT) &&
+	    EXT4_INODE_SIZE(sb) > EXT4_GOOD_OLD_INODE_SIZE &&
+	    EXT4_FITS_IN_INODE(raw_inode, ei, i_projid))
+		i_projid = (projid_t)le32_to_cpu(raw_inode->i_projid);
+	else
+		i_projid = EXT4_DEF_PROJID;
+
 	if (!(test_opt(inode->i_sb, NO_UID32))) {
 		i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
 		i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
 	}
 	i_uid_write(inode, i_uid);
 	i_gid_write(inode, i_gid);
+	ei->i_projid = make_kprojid(&init_user_ns, i_projid);
 	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 
 	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs */
@@ -4439,6 +4456,7 @@ static int ext4_do_update_inode(handle_t *handle,
 	int need_datasync = 0, set_large_file = 0;
 	uid_t i_uid;
 	gid_t i_gid;
+	projid_t i_projid;
 
 	spin_lock(&ei->i_raw_lock);
 
@@ -4451,6 +4469,7 @@ static int ext4_do_update_inode(handle_t *handle,
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
 	i_uid = i_uid_read(inode);
 	i_gid = i_gid_read(inode);
+	i_projid = from_kprojid(&init_user_ns, ei->i_projid);
 	if (!(test_opt(inode->i_sb, NO_UID32))) {
 		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(i_uid));
 		raw_inode->i_gid_low = cpu_to_le16(low_16_bits(i_gid));
@@ -4528,6 +4547,15 @@ static int ext4_do_update_inode(handle_t *handle,
 				cpu_to_le16(ei->i_extra_isize);
 		}
 	}
+
+	BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+			EXT4_FEATURE_RO_COMPAT_PROJECT) &&
+	       i_projid != EXT4_DEF_PROJID);
+
+	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
+	    EXT4_FITS_IN_INODE(raw_inode, ei, i_projid))
+		raw_inode->i_projid = cpu_to_le32(i_projid);
+
 	ext4_inode_csum_set(inode, raw_inode, ei);
 	spin_unlock(&ei->i_raw_lock);
 	if (inode->i_sb->s_flags & MS_LAZYTIME)
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a969ab3..21e8741 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3211,6 +3211,12 @@ static int ext4_link(struct dentry *old_dentry,
 	if (ext4_encrypted_inode(dir) &&
 	    !ext4_is_child_context_consistent_with_parent(dir, inode))
 		return -EPERM;
+
+       if ((ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) &&
+	   (!projid_eq(EXT4_I(dir)->i_projid,
+		       EXT4_I(old_dentry->d_inode)->i_projid)))
+		return -EXDEV;
+
 	err = dquot_initialize(dir);
 	if (err)
 		return err;
@@ -3491,6 +3497,11 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	int credits;
 	u8 old_file_type;
 
+	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT)) &&
+	    (!projid_eq(EXT4_I(new_dir)->i_projid,
+			EXT4_I(old_dentry->d_inode)->i_projid)))
+		return -EXDEV;
+
 	retval = dquot_initialize(old.dir);
 	if (retval)
 		return retval;
@@ -3700,6 +3711,14 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 							   new.inode)))
 		return -EPERM;
 
+	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT) &&
+	     !projid_eq(EXT4_I(new_dir)->i_projid,
+			EXT4_I(old_dentry->d_inode)->i_projid)) ||
+	    (ext4_test_inode_flag(old_dir, EXT4_INODE_PROJINHERIT) &&
+	     !projid_eq(EXT4_I(old_dir)->i_projid,
+			EXT4_I(new_dentry->d_inode)->i_projid)))
+		return -EXDEV;
+
 	retval = dquot_initialize(old.dir);
 	if (retval)
 		return retval;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c9ab67d..3bacbc3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1100,6 +1100,7 @@ static const struct dquot_operations ext4_quota_operations = {
 	.write_info	= ext4_write_info,
 	.alloc_dquot	= dquot_alloc,
 	.destroy_dquot	= dquot_destroy,
+	.get_projid	= ext4_get_projid,
 };
 
 static const struct quotactl_ops ext4_qctl_operations = {
-- 
1.7.1

