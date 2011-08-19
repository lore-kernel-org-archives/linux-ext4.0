From: Aditya Kali <adityakali@google.com>
Subject: [PATCH v2] ext4: make quota as first class supported feature
Date: Fri, 19 Aug 2011 12:06:09 -0700
Message-ID: <1313780769-21713-1-git-send-email-adityakali@google.com>
Cc: Aditya Kali <adityakali@google.com>
To: adilger@dilger.ca, tytso@mit.edu, jack@suse.cz,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:13325 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab1HSTHD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Aug 2011 15:07:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch is an attempt towards supporting quotas as first class
feature in ext4. It is based on the proposal at:
https://ext4.wiki.kernel.org/index.php/Design_For_1st_Class_Quota_in_Ext4
This patch introduces a new feature - EXT4_FEATURE_RO_COMPAT_QUOTA which, when
turned on, enables quota accounting at mount time iteself. Also, the
quota inodes are stored in two additional superblock fields.
Some changes introduced by this patch that should be pointed out are:
1) Two new ext4-superblock fields - s_usr_quota_inum and s_grp_quota_inum
   for storing the quota inodes in use.
2) If the QUOTA feature and corresponding quota inodes are set in superblock,
   Quotas are turned on at mount time irrespective of the quota mount options.
   Thus the mount options 'quota', 'usrquota' and 'grpquota' are completely
   ignored with the new QUOTA feature flag.
3) Default quota inodes are: inode#3 for tracking userquota and inode#4 for
   tracking group quota. The superblock fields can be set to use other inodes
   as well.
4) mke2fs or tune2fs will initialize these inodes when quota feature is
   being set. The default reserved inodes will not be visible to user as
   regular files.
5) Once quotas are turned on, they cannot be turned off while the FS is
   mounted. This is because we do not want to let the quota get inconsistent.
6) With the QUOTA feature set, since the quota inodes are hidden, some of the
   utilities from quota-tools will no longer work correctly. Instead, e2fsprogs
   will include support for fixing the quota files.
7) Support is only for the new V2 quota file format.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 fs/ext4/ext4.h      |   10 ++++-
 fs/ext4/ext4_jbd2.h |   18 +++++++---
 fs/ext4/super.c     |   89 +++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 106 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e717dfd..5b57bc2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1065,7 +1065,9 @@ struct ext4_super_block {
 	__u8	s_last_error_func[32];	/* function where the error happened */
 #define EXT4_S_ERR_END offsetof(struct ext4_super_block, s_mount_opts)
 	__u8	s_mount_opts[64];
-	__le32	s_reserved[112];        /* Padding to the end of the block */
+	__le32	s_usr_quota_inum;	/* inode for tracking user quota */
+	__le32	s_grp_quota_inum;	/* inode for tracking group quota */
+	__le32	s_reserved[110];        /* Padding to the end of the block */
 };
 
 #define EXT4_S_ERR_LEN (EXT4_S_ERR_END - EXT4_S_ERR_START)
@@ -1142,6 +1144,7 @@ struct ext4_sb_info {
 #ifdef CONFIG_QUOTA
 	char *s_qf_names[MAXQUOTAS];		/* Names of quota files with journalled quota */
 	int s_jquota_fmt;			/* Format of quota to use */
+	unsigned long s_qf_inums[MAXQUOTAS];	/* Quota file inodes */
 #endif
 	unsigned int s_want_extra_isize; /* New inodes should reserve # bytes */
 	struct rb_root system_blks;
@@ -1241,6 +1244,8 @@ static inline struct timespec ext4_current_time(struct inode *inode)
 static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
 {
 	return ino == EXT4_ROOT_INO ||
+		ino == EXT4_USR_QUOTA_INO ||
+		ino == EXT4_GRP_QUOTA_INO ||
 		ino == EXT4_JOURNAL_INO ||
 		ino == EXT4_RESIZE_INO ||
 		(ino >= EXT4_FIRST_INO(sb) &&
@@ -1401,7 +1406,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK | \
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE | \
 					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR |\
-					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE)
+					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE| \
+					 EXT4_FEATURE_RO_COMPAT_QUOTA)
 
 /*
  * Default values for user and/or group using reserved blocks
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index bb85757..0f097ed 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -87,14 +87,20 @@
 #ifdef CONFIG_QUOTA
 /* Amount of blocks needed for quota update - we know that the structure was
  * allocated so we need to update only data block */
-#define EXT4_QUOTA_TRANS_BLOCKS(sb) (test_opt(sb, QUOTA) ? 1 : 0)
+#define EXT4_QUOTA_TRANS_BLOCKS(sb) ((test_opt(sb, QUOTA) ||\
+		EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA)) ?\
+		1 : 0)
 /* Amount of blocks needed for quota insert/delete - we do some block writes
  * but inode, sb and group updates are done only once */
-#define EXT4_QUOTA_INIT_BLOCKS(sb) (test_opt(sb, QUOTA) ? (DQUOT_INIT_ALLOC*\
-		(EXT4_SINGLEDATA_TRANS_BLOCKS(sb)-3)+3+DQUOT_INIT_REWRITE) : 0)
-
-#define EXT4_QUOTA_DEL_BLOCKS(sb) (test_opt(sb, QUOTA) ? (DQUOT_DEL_ALLOC*\
-		(EXT4_SINGLEDATA_TRANS_BLOCKS(sb)-3)+3+DQUOT_DEL_REWRITE) : 0)
+#define EXT4_QUOTA_INIT_BLOCKS(sb) ((test_opt(sb, QUOTA) ||\
+		EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA)) ?\
+		(DQUOT_INIT_ALLOC*(EXT4_SINGLEDATA_TRANS_BLOCKS(sb)-3)\
+		 +3+DQUOT_INIT_REWRITE) : 0)
+
+#define EXT4_QUOTA_DEL_BLOCKS(sb) ((test_opt(sb, QUOTA) ||\
+		EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA)) ?\
+		(DQUOT_DEL_ALLOC*(EXT4_SINGLEDATA_TRANS_BLOCKS(sb)-3)\
+		 +3+DQUOT_DEL_REWRITE) : 0)
 #else
 #define EXT4_QUOTA_TRANS_BLOCKS(sb) 0
 #define EXT4_QUOTA_INIT_BLOCKS(sb) 0
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4687fea..3f3d87e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1225,6 +1225,7 @@ static int ext4_mark_dquot_dirty(struct dquot *dquot);
 static int ext4_write_info(struct super_block *sb, int type);
 static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 			 struct path *path);
+static int ext4_quota_on_meta(struct super_block *sb, int type, int format_id);
 static int ext4_quota_off(struct super_block *sb, int type);
 static int ext4_quota_on_mount(struct super_block *sb, int type);
 static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
@@ -1252,6 +1253,16 @@ static const struct quotactl_ops ext4_qctl_operations = {
 	.get_dqblk	= dquot_get_dqblk,
 	.set_dqblk	= dquot_set_dqblk
 };
+
+static const struct quotactl_ops ext4_new_qctl_operations = {
+	.quota_on_meta	= ext4_quota_on_meta,
+	.quota_off	= ext4_quota_off,
+	.quota_sync	= dquot_quota_sync,
+	.get_info	= dquot_get_dqinfo,
+	.set_info	= dquot_set_dqinfo,
+	.get_dqblk	= dquot_get_dqblk,
+	.set_dqblk	= dquot_set_dqblk
+};
 #endif
 
 static const struct super_operations ext4_sops = {
@@ -3518,6 +3529,15 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_QUOTA
 	sb->s_qcop = &ext4_qctl_operations;
 	sb->dq_op = &ext4_quota_operations;
+
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA)) {
+		/* Use new qctl operations with quota on function that does not
+		 * require user specified quota file path. */
+		sb->s_qcop = &ext4_new_qctl_operations;
+
+		sbi->s_qf_inums[USRQUOTA] = es->s_usr_quota_inum;
+		sbi->s_qf_inums[GRPQUOTA] = es->s_grp_quota_inum;
+	}
 #endif
 	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 
@@ -3745,8 +3765,19 @@ no_journal:
 	} else
 		descr = "out journal";
 
-	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
-		 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
+#ifdef CONFIG_QUOTA
+	/* Enable quotas during mount. */
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
+	    !(sb->s_flags & MS_RDONLY)) {
+		ext4_quota_on_meta(sb, USRQUOTA, QFMT_VFS_V1);
+		ext4_quota_on_meta(sb, GRPQUOTA, QFMT_VFS_V1);
+	}
+#endif  /* CONFIG_QUOTA */
+
+	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. quota=%s. "
+		 "Opts: %s%s%s", descr,
+		 sb_any_quota_loaded(sb) ? "on" : "off",
+		 sbi->s_es->s_mount_opts,
 		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data);
 
 	if (es->s_error_count)
@@ -4106,6 +4137,12 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 	es->s_free_inodes_count =
 		cpu_to_le32(percpu_counter_sum_positive(
 				&EXT4_SB(sb)->s_freeinodes_counter));
+#ifdef CONFIG_QUOTA
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA)) {
+		es->s_usr_quota_inum = EXT4_SB(sb)->s_qf_inums[USRQUOTA];
+		es->s_grp_quota_inum = EXT4_SB(sb)->s_qf_inums[GRPQUOTA];
+	}
+#endif
 	sb->s_dirt = 0;
 	BUFFER_TRACE(sbh, "marking dirty");
 	mark_buffer_dirty(sbh);
@@ -4687,7 +4724,7 @@ static int ext4_quota_on_mount(struct super_block *sb, int type)
  * Standard function to be called on quota_on
  */
 static int ext4_quota_on(struct super_block *sb, int type, int format_id,
-			 struct path *path)
+			struct path *path)
 {
 	int err;
 
@@ -4726,11 +4763,57 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 	return dquot_quota_on(sb, type, format_id, path);
 }
 
+/*
+ * New quota_on function that is used when QUOTA feature is set.
+ */
+static int ext4_quota_on_meta(struct super_block *sb, int type, int format_id)
+{
+	int err;
+	struct inode *qf_inode;
+
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) ||
+	    !EXT4_SB(sb)->s_qf_inums[type])
+		return -EINVAL;
+
+	qf_inode = ext4_iget(sb, EXT4_SB(sb)->s_qf_inums[type]);
+	if (IS_ERR(qf_inode)) {
+		EXT4_SB(sb)->s_qf_inums[type] = 0;
+		return PTR_ERR(qf_inode);
+	}
+
+	/*
+	 * When we journal data on quota file, we have to flush journal to see
+	 * all updates to the file when we bypass pagecache...
+	 */
+	if (EXT4_SB(sb)->s_journal &&
+	    ext4_should_journal_data(qf_inode)) {
+		/*
+		 * We don't need to lock updates but journal_flush() could
+		 * otherwise be livelocked...
+		 */
+		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
+		err = jbd2_journal_flush(EXT4_SB(sb)->s_journal);
+		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+		if (err)
+			return err;
+	}
+
+	err = dquot_enable(qf_inode, type, format_id,
+			   DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
+	iput(qf_inode);
+
+	return err;
+}
+
 static int ext4_quota_off(struct super_block *sb, int type)
 {
 	struct inode *inode = sb_dqopt(sb)->files[type];
 	handle_t *handle;
 
+	/* Do not allow turning quotas off if QUOTA feature is set. */
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA))
+		return -EINVAL;
+
 	/* Force all delayed allocation blocks to be allocated.
 	 * Caller already holds s_umount sem */
 	if (test_opt(sb, DELALLOC))
-- 
1.7.3.1

