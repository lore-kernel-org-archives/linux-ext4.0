From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC v2 4/6] ext4: support project id and project quota
Date: Tue, 10 Mar 2015 20:22:09 +0300
Message-ID: <20150310172209.23081.53905.stgit@buzz>
References: <20150310171133.23081.49616.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Andy Lutomirski <luto@amacapital.net>,
	linux-kernel@vger.kernel.org, Li Xi <pkuelelixi@gmail.com>
To: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150310171133.23081.49616.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch implements project quota feature.

If EXT4_FEATURE_RO_COMPAT_PROJECT is set then inode field i_faddr contains
project id (otherwise all project id are set to invalid: -1).
I_faddr is obsolete for a long time, it seems linux never used it.

New files always inherit project id from directory where they are created.

Link/rename works only if projects of inode and target directory are matched,
or if project id of directory is mapped to zero. Otherwise -EXDEV is returned.
User-space tool 'mv' handles EXDEV as cross-filesystem move: it makes a copy of
files and unlinks source, this files will be transferred into target project.
(next patch adds optimization for that)

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 fs/ext4/ext4.h   |   15 ++++++++++----
 fs/ext4/ialloc.c |    3 +++
 fs/ext4/inode.c  |   15 ++++++++++++++
 fs/ext4/namei.c  |   25 +++++++++++++++++++++++
 fs/ext4/super.c  |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 5 files changed, 109 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f63c3d5805c4..8ba523ff5f84 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -212,6 +212,8 @@ struct ext4_io_submit {
 /* First non-reserved inode for old ext4 filesystems */
 #define EXT4_GOOD_OLD_FIRST_INO	11
 
+#define EXT4_PRJ_QUOTA_INO	11	/* Project quota inode */
+
 /*
  * Maximal count of links to a file
  */
@@ -653,7 +655,7 @@ struct ext4_inode {
 	__le32	i_generation;	/* File version (for NFS) */
 	__le32	i_file_acl_lo;	/* File ACL */
 	__le32	i_size_high;
-	__le32	i_obso_faddr;	/* Obsoleted fragment address */
+	__le32	i_project;	/* Formerly i_faddr, fragment address */
 	union {
 		struct {
 			__le16	l_i_blocks_high; /* were l_i_reserved1 */
@@ -939,6 +941,7 @@ struct ext4_inode_info {
 
 	/* Precomputed uuid+inum+igen checksum for seeding inode checksums */
 	__u32 i_csum_seed;
+	kprojid_t i_project;
 };
 
 /*
@@ -1169,7 +1172,8 @@ struct ext4_super_block {
 	__le32	s_overhead_clusters;	/* overhead blocks/clusters in fs */
 	__le32	s_backup_bgs[2];	/* groups with sparse_super2 SBs */
 	__u8	s_encrypt_algos[4];	/* Encryption algorithms in use  */
-	__le32	s_reserved[105];	/* Padding to the end of the block */
+	__le32	s_prj_quota_inum;	/* inode for tracking project quota */
+	__le32	s_reserved[104];	/* Padding to the end of the block */
 	__le32	s_checksum;		/* crc32c(superblock) */
 };
 
@@ -1184,7 +1188,7 @@ struct ext4_super_block {
 #define EXT4_MF_FS_ABORTED	0x0002	/* Fatal error detected */
 
 /* Number of quota types we support */
-#define EXT4_MAXQUOTAS 2
+#define EXT4_MAXQUOTAS 3
 
 /*
  * fourth extended-fs super-block data in memory
@@ -1373,6 +1377,7 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
 	return ino == EXT4_ROOT_INO ||
 		ino == EXT4_USR_QUOTA_INO ||
 		ino == EXT4_GRP_QUOTA_INO ||
+		ino == EXT4_PRJ_QUOTA_INO ||
 		ino == EXT4_BOOT_LOADER_INO ||
 		ino == EXT4_JOURNAL_INO ||
 		ino == EXT4_RESIZE_INO ||
@@ -1536,6 +1541,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
  */
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
 #define EXT4_FEATURE_RO_COMPAT_READONLY		0x1000
+#define EXT4_FEATURE_RO_COMPAT_PROJECT		0x2000
 
 #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
@@ -1586,7 +1592,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC |\
 					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
-					 EXT4_FEATURE_RO_COMPAT_QUOTA)
+					 EXT4_FEATURE_RO_COMPAT_QUOTA |\
+					 EXT4_FEATURE_RO_COMPAT_PROJECT)
 
 /*
  * Default values for user and/or group using reserved blocks
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index ac644c31ca67..5d812caf4bef 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -756,6 +756,9 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 		inode->i_gid = dir->i_gid;
 	} else
 		inode_init_owner(inode, dir, mode);
+
+	ei->i_project = EXT4_I(dir)->i_project;
+
 	dquot_initialize(inode);
 
 	if (!goal)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5cb9a212b86f..fc55590437af 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3968,6 +3968,14 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	}
 	i_uid_write(inode, i_uid);
 	i_gid_write(inode, i_gid);
+
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+		projid_t project = le32_to_cpu(raw_inode->i_project);
+
+		ei->i_project = make_kprojid(&init_user_ns, project);
+	} else
+		ei->i_project = INVALID_PROJID;
+
 	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 
 	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs */
@@ -4293,6 +4301,13 @@ static int ext4_do_update_inode(handle_t *handle,
 		raw_inode->i_uid_high = 0;
 		raw_inode->i_gid_high = 0;
 	}
+
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+		projid_t i_project = from_kprojid(&init_user_ns, ei->i_project);
+
+		raw_inode->i_project = cpu_to_le32(i_project);
+	}
+
 	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
 
 	EXT4_INODE_SET_XTIME(i_ctime, inode, raw_inode);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 8110dd20ad3f..094f7096a41c 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2934,6 +2934,17 @@ err_drop_inode:
 	return err;
 }
 
+static bool ext4_check_project(struct inode *dir, struct inode *inode)
+{
+	/*
+	 * Allow link/rename only into directory with matched project or
+	 * if direcorty belongs to default 'zero' project. Without feature
+	 * RO_COMPAT_PROJECT all i_project are 'invalid' thus always equal.
+	 */
+	return projid_eq(EXT4_I(dir)->i_project, EXT4_I(inode)->i_project) ||
+	       from_kprojid(current_user_ns(), EXT4_I(dir)->i_project) == 0;
+}
+
 static int ext4_link(struct dentry *old_dentry,
 		     struct inode *dir, struct dentry *dentry)
 {
@@ -2944,6 +2955,9 @@ static int ext4_link(struct dentry *old_dentry,
 	if (inode->i_nlink >= EXT4_LINK_MAX)
 		return -EMLINK;
 
+	if (!ext4_check_project(dir, inode))
+		return -EXDEV;
+
 	dquot_initialize(dir);
 
 retry:
@@ -3260,6 +3274,11 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (new.inode && !test_opt(new.dir->i_sb, NO_AUTO_DA_ALLOC))
 		ext4_alloc_da_blocks(old.inode);
 
+	if (!ext4_check_project(new.dir, old.inode)) {
+		retval = -EXDEV;
+		goto end_rename;
+	}
+
 	credits = (2 * EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
 		   EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
 	if (!(flags & RENAME_WHITEOUT)) {
@@ -3436,6 +3455,12 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (!new.bh || le32_to_cpu(new.de->inode) != new.inode->i_ino)
 		goto end_rename;
 
+	if (!ext4_check_project(new.dir, old.inode) ||
+	    !ext4_check_project(old.dir, new.inode)) {
+		retval = -EXDEV;
+		goto end_rename;
+	}
+
 	handle = ext4_journal_start(old.dir, EXT4_HT_DIR,
 		(2 * EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
 		 2 * EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2));
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e061e66c8280..c62ed5b554ae 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1035,9 +1035,54 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
 	return try_to_free_buffers(page);
 }
 
+static kprojid_t ext4_get_project(struct inode *inode)
+{
+	/* Without feature RO_COMPAT_PROJECT all i_project are set to invalid */
+	return EXT4_I(inode)->i_project;
+}
+
+static int ext4_set_project(struct inode *inode, kprojid_t project)
+{
+	struct super_block *sb = inode->i_sb;
+	struct ext4_iloc iloc;
+	handle_t *handle;
+	int ret;
+
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT))
+		return -EOPNOTSUPP;
+
+	if (projid_eq(EXT4_I(inode)->i_project, project))
+		return 0;
+
+	dquot_initialize(inode);
+
+	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1 +
+					EXT4_QUOTA_INIT_BLOCKS(sb) +
+					EXT4_QUOTA_DEL_BLOCKS(sb));
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	ret = dquot_transfer_project(inode, project);
+	if (ret)
+		goto out;
+
+	ret = ext4_reserve_inode_write(handle, inode, &iloc);
+	if (!ret) {
+		inode->i_ctime = ext4_current_time(inode);
+		EXT4_I(inode)->i_project = project;
+		ret = ext4_mark_iloc_dirty(handle, inode, &iloc);
+	}
+	if (IS_SYNC(inode))
+		ext4_handle_sync(handle);
+out:
+	ext4_journal_stop(handle);
+
+	return ret;
+}
+
 #ifdef CONFIG_QUOTA
-#define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
-#define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
+static char *quotatypes[] = INITQFNAMES;
+#define QTYPE2NAME(t) (quotatypes[t])
 
 static int ext4_write_dquot(struct dquot *dquot);
 static int ext4_acquire_dquot(struct dquot *dquot);
@@ -1103,6 +1148,8 @@ static const struct super_operations ext4_sops = {
 	.get_dquots	= ext4_get_dquots,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
+	.get_project	= ext4_get_project,
+	.set_project	= ext4_set_project,
 };
 
 static const struct export_operations ext4_export_ops = {
@@ -3965,6 +4012,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	else
 		sb->s_qcop = &ext4_qctl_operations;
 	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT))
+		sb->s_quota_types |= QTYPE_MASK_PRJ;
 #endif
 	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 
@@ -5269,7 +5318,8 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 	struct inode *qf_inode;
 	unsigned long qf_inums[EXT4_MAXQUOTAS] = {
 		le32_to_cpu(EXT4_SB(sb)->s_es->s_usr_quota_inum),
-		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum)
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum),
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_prj_quota_inum),
 	};
 
 	BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA));
@@ -5297,7 +5347,8 @@ static int ext4_enable_quotas(struct super_block *sb)
 	int type, err = 0;
 	unsigned long qf_inums[EXT4_MAXQUOTAS] = {
 		le32_to_cpu(EXT4_SB(sb)->s_es->s_usr_quota_inum),
-		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum)
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum),
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_prj_quota_inum),
 	};
 
 	sb_dqopt(sb)->flags |= DQUOT_QUOTA_SYS_FILE;
