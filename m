From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 11/11] ext4: add subtree quota support
Date: Mon, 08 Feb 2010 16:28:13 +0300
Message-ID: <1265635693-12182-12-git-send-email-dmonakhov@openvz.org>
References: <1265635693-12182-1-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-2-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-3-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-4-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-5-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-6-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-7-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-8-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-9-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-10-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-11-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:33220 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab0BHO2e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2010 09:28:34 -0500
Received: from localhost.localdomain ([unknown] [195.214.232.10])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KXI0097MZ0I9F10@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Mon, 08 Feb 2010 16:34:02 +0300 (MSK)
In-reply-to: <1265635693-12182-11-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch add full subtree quota support to ext4
mount option: sbtrquota, sbtrjquota, nosbtrjquota

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/subtree.c |   15 ++++++++-
 fs/ext4/super.c   |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 92 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c707c7c..2799c6c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -766,6 +766,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000LL /* Block validity checking */
 #define EXT4_MOUNT_DISCARD		0x40000000LL /* Issue DISCARD requests */
 #define EXT4_MOUNT_SUBTREE		0x80000000LL /* Dedicated subtree */
+#define EXT4_MOUNT_SBTRQUOTA		0x100000000LL /* Subtree quota support */
 
 #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt
 #define set_opt(o, opt)			o |= EXT4_MOUNT_##opt
diff --git a/fs/ext4/subtree.c b/fs/ext4/subtree.c
index 40d3d85..a27c245 100644
--- a/fs/ext4/subtree.c
+++ b/fs/ext4/subtree.c
@@ -198,14 +198,25 @@ retry:
 	/*
 	 * Quota transfer only after xattr update. Because it may be
 	 * impossible to roll back quota changed due to -EDQUOT
-	 * TODO: add quota transfer here
 	 */
+	if (sb_any_quota_active(inode->i_sb) && !IS_NOQUOTA(inode)) {
+		unsigned msk = 1 << SBTRQUOTA;
+		qid_t new[MAXQUOTAS];
+		new[SBTRQUOTA] = subtree;
+		vfs_dq_init(inode);
+		ret = inode->i_sb->dq_op->transfer(inode, new, msk);
+		if (ret) {
+			ret = -EDQUOT;
+			goto err;
+		}
+	}
+
 	EXT4_I_SUBTREE(inode) = subtree;
 	ret2 = ext4_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
 	return ret;
-
+err:
 	/*
 	 * Restore xattr to previous value. Xattr is already allocated, so
 	 * operation may fail only due to some serious error.
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2684453..7efa7c6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -798,11 +798,17 @@ static inline void ext4_show_quota_options(struct seq_file *seq,
 	if (sbi->s_qf_names[GRPQUOTA])
 		seq_printf(seq, ",grpjquota=%s", sbi->s_qf_names[GRPQUOTA]);
 
+	if (sbi->s_qf_names[SBTRQUOTA])
+		seq_printf(seq, ",trjquota=%s", sbi->s_qf_names[SBTRQUOTA]);
+
 	if (test_opt(sb, USRQUOTA))
 		seq_puts(seq, ",usrquota");
 
 	if (test_opt(sb, GRPQUOTA))
 		seq_puts(seq, ",grpquota");
+
+	if (test_opt(sb, SBTRQUOTA))
+		seq_puts(seq, ",trquota");
 #endif
 }
 
@@ -1017,7 +1023,7 @@ static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
 			       size_t len, loff_t off);
 static ssize_t ext4_quota_write(struct super_block *sb, int type,
 				const char *data, size_t len, loff_t off);
-
+static qid_t ext4_get_quotid(struct inode *inode, int type, qid_t *new);
 static const struct dquot_operations ext4_quota_operations = {
 	.initialize	= dquot_initialize,
 	.drop		= dquot_drop,
@@ -1032,7 +1038,7 @@ static const struct dquot_operations ext4_quota_operations = {
 	.free_space	= dquot_free_space,
 	.free_inode	= dquot_free_inode,
 	.transfer	= dquot_transfer,
-	.get_id		= dquot_get_id,
+	.get_id		= ext4_get_quotid,
 	.write_dquot	= ext4_write_dquot,
 	.acquire_dquot	= ext4_acquire_dquot,
 	.release_dquot	= ext4_release_dquot,
@@ -1111,6 +1117,7 @@ enum {
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
 	Opt_data_err_abort, Opt_data_err_ignore,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
+	Opt_sbtrquota, Opt_sbtrjquota, Opt_offtsbrquota, Opt_offsbtrjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
 	Opt_noquota, Opt_ignore, Opt_barrier, Opt_nobarrier, Opt_err,
 	Opt_resize, Opt_usrquota, Opt_grpquota, Opt_i_version,
@@ -1163,6 +1170,8 @@ static const match_table_t tokens = {
 	{Opt_usrjquota, "usrjquota=%s"},
 	{Opt_offgrpjquota, "grpjquota="},
 	{Opt_grpjquota, "grpjquota=%s"},
+	{Opt_offsbtrjquota, "sbtrjquota="},
+	{Opt_sbtrjquota, "sbtrjquota=%s"},
 	{Opt_jqfmt_vfsold, "jqfmt=vfsold"},
 	{Opt_jqfmt_vfsv0, "jqfmt=vfsv0"},
 	{Opt_jqfmt_vfsv1, "jqfmt=vfsv1"},
@@ -1170,6 +1179,7 @@ static const match_table_t tokens = {
 	{Opt_noquota, "noquota"},
 	{Opt_quota, "quota"},
 	{Opt_usrquota, "usrquota"},
+	{Opt_sbtrquota, "sbtrquota"},
 	{Opt_barrier, "barrier=%u"},
 	{Opt_barrier, "barrier"},
 	{Opt_nobarrier, "nobarrier"},
@@ -1472,6 +1482,37 @@ static int parse_options(char *options, struct super_block *sb,
 			if (!set_qf_name(sb, GRPQUOTA, &args[0]))
 				return 0;
 			break;
+#ifdef CONFIG_EXT4_SUBTREE
+		case Opt_sbtrjquota:
+			if (!test_opt(sb, SUBTREE)) {
+				ext4_msg(sb, KERN_ERR, "Cannot use subtree_"
+					"quota without subtree support");
+				return 0;
+			}
+			if (!set_qf_name(sb, SBTRQUOTA, &args[0]))
+ 				return 0;
+ 			break;
+		case Opt_offsbtrjquota:
+			if (!clear_qf_name(sb, SBTRQUOTA))
+				return 0;
+			break;
+		case Opt_sbtrquota:
+			if (!test_opt(sb, SUBTREE)) {
+				ext4_msg(sb, KERN_ERR, "Cannot use subtree_"
+					"quota without subtree support");
+				return 0;
+			}
+			set_opt(sbi->s_mount_opt, QUOTA);
+			set_opt(sbi->s_mount_opt, SBTRQUOTA);
+			break;
+#else
+		case Opt_sbtrjquota:
+		case Opt_offsbtrjquota:
+		case Opt_sbtrquota:
+			ext4_msg(sb, KERN_ERR,
+				"subtree quota options not supported");
+			break;
+#endif
 		case Opt_offusrjquota:
 			if (!clear_qf_name(sb, USRQUOTA))
 				return 0;
@@ -1517,18 +1558,22 @@ set_qf_format:
 			clear_opt(sbi->s_mount_opt, QUOTA);
 			clear_opt(sbi->s_mount_opt, USRQUOTA);
 			clear_opt(sbi->s_mount_opt, GRPQUOTA);
+			clear_opt(sbi->s_mount_opt, SBTRQUOTA);
 			break;
 #else
 		case Opt_quota:
 		case Opt_usrquota:
 		case Opt_grpquota:
+		case Opt_sbtrquota:
 			ext4_msg(sb, KERN_ERR,
 				"quota options not supported");
 			break;
 		case Opt_usrjquota:
 		case Opt_grpjquota:
+		case Opt_sbtrjquota:
 		case Opt_offusrjquota:
 		case Opt_offgrpjquota:
+		case Opt_offsbtrjquota:
 		case Opt_jqfmt_vfsold:
 		case Opt_jqfmt_vfsv0:
 		case Opt_jqfmt_vfsv1:
@@ -1661,14 +1706,19 @@ set_qf_format:
 		}
 	}
 #ifdef CONFIG_QUOTA
-	if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
+	if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA] ||
+		sbi->s_qf_names[SBTRQUOTA]) {
 		if (test_opt(sb, USRQUOTA) && sbi->s_qf_names[USRQUOTA])
 			clear_opt(sbi->s_mount_opt, USRQUOTA);
 
 		if (test_opt(sb, GRPQUOTA) && sbi->s_qf_names[GRPQUOTA])
 			clear_opt(sbi->s_mount_opt, GRPQUOTA);
 
-		if (test_opt(sb, GRPQUOTA) || test_opt(sb, USRQUOTA)) {
+		if (test_opt(sb, SBTRQUOTA) && sbi->s_qf_names[SBTRQUOTA])
+			clear_opt(sbi->s_mount_opt, SBTRQUOTA);
+
+		if (test_opt(sb, GRPQUOTA) || test_opt(sb, USRQUOTA) ||
+				test_opt(sb, SBTRQUOTA)) {
 			ext4_msg(sb, KERN_ERR, "old and new quota "
 					"format mixing");
 			return 0;
@@ -3769,6 +3819,30 @@ static inline struct inode *dquot_to_inode(struct dquot *dquot)
 	return sb_dqopt(dquot->dq_sb)->files[dquot->dq_type];
 }
 
+static qid_t ext4_get_quotid(struct inode *inode, int type, qid_t *new)
+{
+	switch (type) {
+	case USRQUOTA:
+		if (new)
+			return new[USRQUOTA];
+		else
+			return inode->i_uid;
+	case GRPQUOTA:
+		if (new)
+			return new[GRPQUOTA];
+		else
+			return inode->i_gid;
+	case SBTRQUOTA:
+		BUG_ON(!test_opt(inode->i_sb, SBTRQUOTA) &&
+			!(EXT4_SB(inode->i_sb)->s_qf_names[SBTRQUOTA]));
+		if (new)
+			return new[SBTRQUOTA];
+		else
+			return EXT4_I(inode)->i_subtree;
+	default:
+		BUG();
+	}
+}
 static int ext4_write_dquot(struct dquot *dquot)
 {
 	int ret, err;
-- 
1.6.3.3

