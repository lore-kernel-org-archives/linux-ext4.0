From: Li Xi <pkuelelixi@gmail.com>
Subject: [v16 2/4] ext4: adds project quota support
Date: Tue, 12 Jan 2016 17:56:08 +0900
Message-ID: <1452588970-18309-3-git-send-email-lixi@ddn.com>
References: <1452588970-18309-1-git-send-email-lixi@ddn.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org,
	dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34548 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934338AbcALI4Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2016 03:56:24 -0500
Received: by mail-pf0-f170.google.com with SMTP id q63so61387449pfb.1
        for <linux-ext4@vger.kernel.org>; Tue, 12 Jan 2016 00:56:24 -0800 (PST)
In-Reply-To: <1452588970-18309-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds mount options for enabling/disabling project quota
accounting and enforcement. A new specific inode is also used for
project quota accounting.

Signed-off-by: Li Xi <lixi@ddn.com>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  |    2 +-
 fs/ext4/super.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c1bf4aa..db39c85 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1250,7 +1250,7 @@ struct ext4_super_block {
 #endif
 
 /* Number of quota types we support */
-#define EXT4_MAXQUOTAS 2
+#define EXT4_MAXQUOTAS 3
 
 /*
  * fourth extended-fs super-block data in memory
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3bacbc3..d348767 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1066,8 +1066,8 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
 }
 
 #ifdef CONFIG_QUOTA
-#define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
-#define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
+static char *quotatypes[] = INITQFNAMES;
+#define QTYPE2NAME(t) (quotatypes[t])
 
 static int ext4_write_dquot(struct dquot *dquot);
 static int ext4_acquire_dquot(struct dquot *dquot);
@@ -3655,7 +3655,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		sb->s_qcop = &dquot_quotactl_sysfile_ops;
 	else
 		sb->s_qcop = &ext4_qctl_operations;
-	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
+	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
 #endif
 	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 
@@ -4791,6 +4791,46 @@ restore_opts:
 	return err;
 }
 
+static int ext4_statfs_project(struct super_block *sb,
+			       kprojid_t projid, struct kstatfs *buf)
+{
+	struct kqid qid;
+	struct dquot *dquot;
+	u64 limit;
+	u64 curblock;
+
+	qid = make_kqid_projid(projid);
+	dquot = dqget(sb, qid);
+	if (!dquot)
+		return -ESRCH;
+	spin_lock(&dq_data_lock);
+
+	limit = dquot->dq_dqb.dqb_bsoftlimit ?
+		dquot->dq_dqb.dqb_bsoftlimit :
+		dquot->dq_dqb.dqb_bhardlimit;
+	if (limit && buf->f_blocks * buf->f_bsize > limit) {
+		curblock = dquot->dq_dqb.dqb_curspace / buf->f_bsize;
+		buf->f_blocks = limit / buf->f_bsize;
+		buf->f_bfree = buf->f_bavail =
+			(buf->f_blocks > curblock) ?
+			 (buf->f_blocks - curblock) : 0;
+	}
+
+	limit = dquot->dq_dqb.dqb_isoftlimit ?
+		dquot->dq_dqb.dqb_isoftlimit :
+		dquot->dq_dqb.dqb_ihardlimit;
+	if (limit && buf->f_files > limit) {
+		buf->f_files = limit;
+		buf->f_ffree =
+			(buf->f_files > dquot->dq_dqb.dqb_curinodes) ?
+			 (buf->f_files - dquot->dq_dqb.dqb_curinodes) : 0;
+	}
+
+	spin_unlock(&dq_data_lock);
+	dqput(dquot);
+	return 0;
+}
+
 static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
@@ -4799,6 +4839,7 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	ext4_fsblk_t overhead = 0, resv_blocks;
 	u64 fsid;
 	s64 bfree;
+	struct inode *inode = dentry->d_inode;
 	resv_blocks = EXT4_C2B(sbi, atomic64_read(&sbi->s_resv_clusters));
 
 	if (!test_opt(sb, MINIX_DF))
@@ -4823,6 +4864,9 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
 	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
 
+	if (ext4_test_inode_flag(inode, EXT4_INODE_PROJINHERIT) &&
+	    sb_has_quota_limits_enabled(sb, PRJQUOTA))
+		ext4_statfs_project(sb, EXT4_I(inode)->i_projid, buf);
 	return 0;
 }
 
@@ -4987,7 +5031,8 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 	struct inode *qf_inode;
 	unsigned long qf_inums[EXT4_MAXQUOTAS] = {
 		le32_to_cpu(EXT4_SB(sb)->s_es->s_usr_quota_inum),
-		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum)
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum),
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_prj_quota_inum)
 	};
 
 	BUG_ON(!ext4_has_feature_quota(sb));
@@ -5015,7 +5060,8 @@ static int ext4_enable_quotas(struct super_block *sb)
 	int type, err = 0;
 	unsigned long qf_inums[EXT4_MAXQUOTAS] = {
 		le32_to_cpu(EXT4_SB(sb)->s_es->s_usr_quota_inum),
-		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum)
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum),
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_prj_quota_inum)
 	};
 
 	sb_dqopt(sb)->flags |= DQUOT_QUOTA_SYS_FILE;
-- 
1.7.1

