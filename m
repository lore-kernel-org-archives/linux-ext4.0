From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 6/6] ext4: add project quota support
Date: Sun,  2 Oct 2011 23:44:41 +0400
Message-ID: <1317584681-29967-6-git-send-email-dmonakhov@openvz.org>
References: <1317584681-29967-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, viro@ZenIV.linux.org.uk,
	adityakali@google.com, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64605 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab1JBTlW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Oct 2011 15:41:22 -0400
In-Reply-To: <1317584681-29967-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Both regular and journaled quota are supported.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/super.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 93151e7..b32aaca 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -897,6 +897,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_ERRORS_PANIC		0x00040	/* Panic on errors */
 #define EXT4_MOUNT_MINIX_DF		0x00080	/* Mimics the Minix statfs */
 #define EXT4_MOUNT_NOLOAD		0x00100	/* Don't use existing journal*/
+#define EXT4_MOUNT_PRJQUOTA		0x00200 /* Project quota support */
 #define EXT4_MOUNT_DATA_FLAGS		0x00C00	/* Mode for data writes: */
 #define EXT4_MOUNT_JOURNAL_DATA		0x00400	/* Write data to journal */
 #define EXT4_MOUNT_ORDERED_DATA		0x00800	/* Flush data before commit */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fefc007..85eda58 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1004,11 +1004,18 @@ static inline void ext4_show_quota_options(struct seq_file *seq,
 	if (sbi->s_qf_names[GRPQUOTA])
 		seq_printf(seq, ",grpjquota=%s", sbi->s_qf_names[GRPQUOTA]);
 
+	if (sbi->s_qf_names[PRJQUOTA])
+		seq_printf(seq, ",prjjquota=%s", sbi->s_qf_names[PRJQUOTA]);
+
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
 
@@ -1218,8 +1225,8 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
 }
 
 #ifdef CONFIG_QUOTA
-#define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
-#define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
+static char *quotatypes[] = INITQFNAMES;
+#define QTYPE2NAME(t) (quotatypes[t])
 
 static int ext4_write_dquot(struct dquot *dquot);
 static int ext4_acquire_dquot(struct dquot *dquot);
@@ -1320,10 +1327,11 @@ enum {
 	Opt_journal_checksum, Opt_journal_async_commit,
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
 	Opt_data_err_abort, Opt_data_err_ignore,
-	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
+	Opt_usrjquota, Opt_grpjquota, Opt_prjjquota, Opt_offusrjquota,
+	Opt_offgrpjquota, Opt_offprjjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
 	Opt_noquota, Opt_ignore, Opt_barrier, Opt_nobarrier, Opt_err,
-	Opt_resize, Opt_usrquota, Opt_grpquota, Opt_i_version,
+	Opt_resize, Opt_usrquota, Opt_grpquota, Opt_prjquota, Opt_i_version,
 	Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_mblk_io_submit,
 	Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
@@ -1374,10 +1382,13 @@ static const match_table_t tokens = {
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
@@ -1701,6 +1712,16 @@ static int parse_options(char *options, struct super_block *sb,
 			if (!set_qf_name(sb, GRPQUOTA, &args[0]))
 				return 0;
 			break;
+
+		case Opt_prjjquota:
+#ifdef CONFIG_PROJECT_ID
+			if (!set_qf_name(sb, PRJQUOTA, &args[0]))
+				return 0;
+#else
+			ext4_msg(sb, KERN_ERR,
+				"project quota options not supported");
+#endif
+			break;
 		case Opt_offusrjquota:
 			if (!clear_qf_name(sb, USRQUOTA))
 				return 0;
@@ -1711,7 +1732,15 @@ static int parse_options(char *options, struct super_block *sb,
 				return 0;
 			clear_opt(sb, USRQUOTA);
 			break;
-
+		case Opt_offprjjquota:
+#ifdef CONFIG_PROJECT_ID
+			if (!clear_qf_name(sb, PRJQUOTA))
+				return 0;
+#else
+			ext4_msg(sb, KERN_ERR,
+				"project quota options not supported");
+#endif
+			break;
 		case Opt_jqfmt_vfsold:
 			qfmt = QFMT_VFS_OLD;
 			goto set_qf_format;
@@ -1737,6 +1766,15 @@ set_qf_format:
 		case Opt_grpquota:
 			set_opt(sb, GRPQUOTA);
 			break;
+		case Opt_prjquota:
+#ifdef CONFIG_PROJECT_ID
+			set_opt(sb, PROJECT_ID);
+			set_opt(sb, PRJQUOTA);
+#else
+			ext4_msg(sb, KERN_ERR,
+				"project quota options not supported");
+#endif
+			break;
 		case Opt_noquota:
 			if (sb_any_quota_loaded(sb)) {
 				ext4_msg(sb, KERN_ERR, "Cannot change quota "
@@ -1749,13 +1787,16 @@ set_qf_format:
 		case Opt_quota:
 		case Opt_usrquota:
 		case Opt_grpquota:
+		case Opt_prjquota:
 			ext4_msg(sb, KERN_ERR,
 				"quota options not supported");
 			break;
 		case Opt_usrjquota:
 		case Opt_grpjquota:
+		case Opt_prjquota:
 		case Opt_offusrjquota:
 		case Opt_offgrpjquota:
+		case Opt_offprjquota:
 		case Opt_jqfmt_vfsold:
 		case Opt_jqfmt_vfsv0:
 		case Opt_jqfmt_vfsv1:
@@ -1894,7 +1935,7 @@ set_qf_format:
 			clear_opt(sb, INIT_INODE_TABLE);
 			break;
 		case Opt_project_id:
-			set_opt(sbi->s_mount_opt, PROJECT_ID);
+			set_opt(sb, PROJECT_ID);
 			break;
 		default:
 			ext4_msg(sb, KERN_ERR,
@@ -1904,7 +1945,8 @@ set_qf_format:
 		}
 	}
 #ifdef CONFIG_QUOTA
-	if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
+	if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA] ||
+		sbi->s_qf_names[PRJQUOTA]) {
 		int jquota = 0;
 		if (test_opt(sb, USRQUOTA) && sbi->s_qf_names[USRQUOTA])
 			jquota |= EXT4_MOUNT_USRQUOTA;
@@ -1912,6 +1954,9 @@ set_qf_format:
 		if (test_opt(sb, GRPQUOTA) && sbi->s_qf_names[GRPQUOTA])
 			jquota |= EXT4_MOUNT_GRPQUOTA;
 
+		if (test_opt(sb, PRJQUOTA) && sbi->s_qf_names[PRJQUOTA])
+			jquota |= EXT4_MOUNT_PRJQUOTA;
+
 		if (test_opt(sb, QUOTA) != jquota) {
 			ext4_msg(sb, KERN_ERR, "old and new quota "
 					"format mixing");
@@ -4660,7 +4705,8 @@ static int ext4_mark_dquot_dirty(struct dquot *dquot)
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

