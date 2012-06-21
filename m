From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/5] ext4: add project quota support
Date: Thu, 21 Jun 2012 13:08:52 +0400
Message-ID: <1340269733-25922-5-git-send-email-dmonakhov@openvz.org>
References: <1340269733-25922-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1340269733-25922-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Both regular and journaled quota are supported.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/super.c |   48 ++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c0e33d7..940b41d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -955,6 +955,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_ERRORS_MASK		0x00070
 #define EXT4_MOUNT_MINIX_DF		0x00080	/* Mimics the Minix statfs */
 #define EXT4_MOUNT_NOLOAD		0x00100	/* Don't use existing journal*/
+#define EXT4_MOUNT_PRJQUOTA		0x00200 /* Project quota support */
 #define EXT4_MOUNT_DATA_FLAGS		0x00C00	/* Mode for data writes: */
 #define EXT4_MOUNT_JOURNAL_DATA		0x00400	/* Write data to journal */
 #define EXT4_MOUNT_ORDERED_DATA		0x00800	/* Flush data before commit */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bf6f4ba..b407ff2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1128,8 +1128,8 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
 }
 
 #ifdef CONFIG_QUOTA
-#define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
-#define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
+static char *quotatypes[] = INITQFNAMES;
+#define QTYPE2NAME(t) (quotatypes[t])
 
 static int ext4_write_dquot(struct dquot *dquot);
 static int ext4_acquire_dquot(struct dquot *dquot);
@@ -1229,10 +1229,11 @@ enum {
 	Opt_journal_dev, Opt_journal_checksum, Opt_journal_async_commit,
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
 	Opt_data_err_abort, Opt_data_err_ignore,
-	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
+	Opt_usrjquota, Opt_grpjquota, Opt_prjjquota,
+	Opt_offusrjquota, Opt_offgrpjquota, Opt_offprjjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
 	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
-	Opt_usrquota, Opt_grpquota, Opt_i_version,
+	Opt_usrquota, Opt_grpquota, Opt_prjquota, Opt_i_version,
 	Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_mblk_io_submit,
 	Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
@@ -1282,10 +1283,13 @@ static const match_table_t tokens = {
 	{Opt_usrjquota, "usrjquota=%s"},
 	{Opt_offgrpjquota, "grpjquota="},
 	{Opt_grpjquota, "grpjquota=%s"},
+	{Opt_offprjjquota, "prjjquota="},
+	{Opt_prjjquota, "prjjquota=%s"},
 	{Opt_jqfmt_vfsold, "jqfmt=vfsold"},
 	{Opt_jqfmt_vfsv0, "jqfmt=vfsv0"},
 	{Opt_jqfmt_vfsv1, "jqfmt=vfsv1"},
 	{Opt_grpquota, "grpquota"},
+	{Opt_prjquota, "prjquota"},
 	{Opt_noquota, "noquota"},
 	{Opt_quota, "quota"},
 	{Opt_usrquota, "usrquota"},
@@ -1488,15 +1492,20 @@ static const struct mount_opts {
 		       EXT4_MOUNT_GRPQUOTA), MOPT_CLEAR | MOPT_Q},
 	{Opt_usrjquota, 0, MOPT_Q},
 	{Opt_grpjquota, 0, MOPT_Q},
+	{Opt_prjjquota, 0, MOPT_Q},
 	{Opt_offusrjquota, 0, MOPT_Q},
 	{Opt_offgrpjquota, 0, MOPT_Q},
+	{Opt_offprjjquota, 0, MOPT_Q},
 	{Opt_jqfmt_vfsold, QFMT_VFS_OLD, MOPT_QFMT},
 	{Opt_jqfmt_vfsv0, QFMT_VFS_V0, MOPT_QFMT},
 	{Opt_jqfmt_vfsv1, QFMT_VFS_V1, MOPT_QFMT},
 #ifdef CONFIG_EXT4_PROJECT_ID
 	{Opt_project_id, EXT4_MOUNT_PROJECT_ID, MOPT_SET},
+	{Opt_prjquota, EXT4_MOUNT_PROJECT_ID | EXT4_MOUNT_QUOTA | EXT4_MOUNT_PRJQUOTA,
+							MOPT_SET | MOPT_Q},
 #else
 	{Opt_project_id, 0, MOPT_NOSUPPORT},
+	{Opt_prjquota, 0, MOPT_NOSUPPORT},
 #endif
 	{Opt_err, 0, 0}
 };
@@ -1516,10 +1525,21 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		return set_qf_name(sb, USRQUOTA, &args[0]);
 	else if (token == Opt_grpjquota)
 		return set_qf_name(sb, GRPQUOTA, &args[0]);
-	else if (token == Opt_offusrjquota)
+        else if (token == Opt_offusrjquota)
 		return clear_qf_name(sb, USRQUOTA);
 	else if (token == Opt_offgrpjquota)
 		return clear_qf_name(sb, GRPQUOTA);
+#ifdef CONFIG_PROJECT_ID
+	else if (token == Opt_prjjquota)
+		return set_qf_name(sb, PRJQUOTA, &args[0]);
+	else if (token == Opt_offprjjquota)
+		return clear_qf_name(sb, PRJQUOTA);
+#else
+	else if (token == Opt_prjjquota || token == Opt_offprjjquota) {
+		ext4_msg(sb, KERN_ERR, "project quota options not supported");
+		return 0;
+	}
+#endif
 #endif
 	if (args->from && match_int(args, &arg))
 		return -1;
@@ -1692,13 +1712,17 @@ static int parse_options(char *options, struct super_block *sb,
 			return 0;
 	}
 #ifdef CONFIG_QUOTA
-	if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
+	if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA] ||
+		sbi->s_qf_names[PRJQUOTA]) {
 		if (test_opt(sb, USRQUOTA) && sbi->s_qf_names[USRQUOTA])
 			clear_opt(sb, USRQUOTA);
 
 		if (test_opt(sb, GRPQUOTA) && sbi->s_qf_names[GRPQUOTA])
 			clear_opt(sb, GRPQUOTA);
 
+		if (test_opt(sb, PRJQUOTA) && sbi->s_qf_names[PRJQUOTA])
+			clear_opt(sb, PRJQUOTA);
+
 		if (test_opt(sb, GRPQUOTA) || test_opt(sb, USRQUOTA)) {
 			ext4_msg(sb, KERN_ERR, "old and new quota "
 					"format mixing");
@@ -1750,12 +1774,19 @@ static inline void ext4_show_quota_options(struct seq_file *seq,
 
 	if (sbi->s_qf_names[GRPQUOTA])
 		seq_printf(seq, ",grpjquota=%s", sbi->s_qf_names[GRPQUOTA]);
-
+#ifdef CONFIG_EXT4_PROJECT_ID
+	if (sbi->s_qf_names[PRJQUOTA])
+		seq_printf(seq, ",prjjquota=%s", sbi->s_qf_names[PRJQUOTA]);
+#endif
 	if (test_opt(sb, USRQUOTA))
 		seq_puts(seq, ",usrquota");
 
 	if (test_opt(sb, GRPQUOTA))
 		seq_puts(seq, ",grpquota");
+
+	if (test_opt(sb, PRJQUOTA))
+		seq_puts(seq, ",prjquota");
+
 #endif
 }
 
@@ -4769,7 +4800,8 @@ static int ext4_mark_dquot_dirty(struct dquot *dquot)
 {
 	/* Are we journaling quotas? */
 	if (EXT4_SB(dquot->dq_sb)->s_qf_names[USRQUOTA] ||
-	    EXT4_SB(dquot->dq_sb)->s_qf_names[GRPQUOTA]) {
+	    EXT4_SB(dquot->dq_sb)->s_qf_names[GRPQUOTA] ||
+	    EXT4_SB(dquot->dq_sb)->s_qf_names[PRJQUOTA]) {
 		dquot_mark_dquot_dirty(dquot);
 		return ext4_write_dquot(dquot);
 	} else {
-- 
1.7.1

