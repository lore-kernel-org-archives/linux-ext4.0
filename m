From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/4] ext3: mount flags manipulation cleanup
Date: Tue,  2 Feb 2010 16:05:51 +0300
Message-ID: <1265115954-2616-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:31712 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab0BBNnG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Feb 2010 08:43:06 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Replace intermediate EXT3_MOUNT_XXX flags manipulation to
corresponding macro.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/super.c |   47 ++++++++++++++++++++---------------------------
 1 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index afa2b56..7950ff6 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -181,7 +181,7 @@ static void ext3_handle_error(struct super_block *sb)
 	if (!test_opt (sb, ERRORS_CONT)) {
 		journal_t *journal = EXT3_SB(sb)->s_journal;
 
-		EXT3_SB(sb)->s_mount_opt |= EXT3_MOUNT_ABORT;
+		set_opt(EXT3_SB(sb)->s_mount_opt, ABORT);
 		if (journal)
 			journal_abort(journal, -EIO);
 	}
@@ -296,7 +296,7 @@ void ext3_abort (struct super_block * sb, const char * function,
 		"error: remounting filesystem read-only");
 	EXT3_SB(sb)->s_mount_state |= EXT3_ERROR_FS;
 	sb->s_flags |= MS_RDONLY;
-	EXT3_SB(sb)->s_mount_opt |= EXT3_MOUNT_ABORT;
+	set_opt(EXT3_SB(sb)->s_mount_opt, ABORT);
 	if (EXT3_SB(sb)->s_journal)
 		journal_abort(EXT3_SB(sb)->s_journal, -EIO);
 }
@@ -562,10 +562,10 @@ static inline void ext3_show_quota_options(struct seq_file *seq, struct super_bl
 	if (sbi->s_qf_names[GRPQUOTA])
 		seq_printf(seq, ",grpjquota=%s", sbi->s_qf_names[GRPQUOTA]);
 
-	if (sbi->s_mount_opt & EXT3_MOUNT_USRQUOTA)
+	if (test_opt(sb, USRQUOTA))
 		seq_puts(seq, ",usrquota");
 
-	if (sbi->s_mount_opt & EXT3_MOUNT_GRPQUOTA)
+	if (test_opt(sb, GRPQUOTA))
 		seq_puts(seq, ",grpquota");
 #endif
 }
@@ -656,8 +656,7 @@ static int ext3_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (test_opt(sb, NOBH))
 		seq_puts(seq, ",nobh");
 
-	seq_printf(seq, ",data=%s", data_mode_string(sbi->s_mount_opt &
-						     EXT3_MOUNT_DATA_FLAGS));
+	seq_printf(seq, ",data=%s", data_mode_string(test_opt(sb, DATA_FLAGS)));
 	if (test_opt(sb, DATA_ERR_ABORT))
 		seq_puts(seq, ",data_err=abort");
 
@@ -1065,20 +1064,19 @@ static int parse_options (char *options, struct super_block *sb,
 			data_opt = EXT3_MOUNT_WRITEBACK_DATA;
 		datacheck:
 			if (is_remount) {
-				if ((sbi->s_mount_opt & EXT3_MOUNT_DATA_FLAGS)
-						== data_opt)
+				if (test_opt(sb, DATA_FLAGS) == data_opt)
 					break;
 				ext3_msg(sb, KERN_ERR,
 					"error: cannot change "
 					"data mode on remount. The filesystem "
 					"is mounted in data=%s mode and you "
 					"try to remount it in data=%s mode.",
-					data_mode_string(sbi->s_mount_opt &
-							EXT3_MOUNT_DATA_FLAGS),
+					data_mode_string(test_opt(sb,
+							DATA_FLAGS)),
 					data_mode_string(data_opt));
 				return 0;
 			} else {
-				sbi->s_mount_opt &= ~EXT3_MOUNT_DATA_FLAGS;
+				clear_opt(sbi->s_mount_opt, DATA_FLAGS);
 				sbi->s_mount_opt |= data_opt;
 			}
 			break;
@@ -1244,18 +1242,13 @@ set_qf_format:
 	}
 #ifdef CONFIG_QUOTA
 	if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
-		if ((sbi->s_mount_opt & EXT3_MOUNT_USRQUOTA) &&
-		     sbi->s_qf_names[USRQUOTA])
+		if (test_opt(sb, USRQUOTA) && sbi->s_qf_names[USRQUOTA])
 			clear_opt(sbi->s_mount_opt, USRQUOTA);
-
-		if ((sbi->s_mount_opt & EXT3_MOUNT_GRPQUOTA) &&
-		     sbi->s_qf_names[GRPQUOTA])
+		if (test_opt(sb, GRPQUOTA) && sbi->s_qf_names[GRPQUOTA])
 			clear_opt(sbi->s_mount_opt, GRPQUOTA);
 
-		if ((sbi->s_qf_names[USRQUOTA] &&
-				(sbi->s_mount_opt & EXT3_MOUNT_GRPQUOTA)) ||
-		    (sbi->s_qf_names[GRPQUOTA] &&
-				(sbi->s_mount_opt & EXT3_MOUNT_USRQUOTA))) {
+		if ((sbi->s_qf_names[USRQUOTA] && test_opt(sb, GRPQUOTA)) ||
+			(sbi->s_qf_names[GRPQUOTA] && test_opt(sb, USRQUOTA))) {
 			ext3_msg(sb, KERN_ERR, "error: old and new quota "
 					"format mixing.");
 			return 0;
@@ -1671,11 +1664,11 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		set_opt(sbi->s_mount_opt, POSIX_ACL);
 #endif
 	if ((def_mount_opts & EXT3_DEFM_JMODE) == EXT3_DEFM_JMODE_DATA)
-		sbi->s_mount_opt |= EXT3_MOUNT_JOURNAL_DATA;
+		set_opt(sbi->s_mount_opt, JOURNAL_DATA);
 	else if ((def_mount_opts & EXT3_DEFM_JMODE) == EXT3_DEFM_JMODE_ORDERED)
-		sbi->s_mount_opt |= EXT3_MOUNT_ORDERED_DATA;
+		set_opt(sbi->s_mount_opt, ORDERED_DATA);
 	else if ((def_mount_opts & EXT3_DEFM_JMODE) == EXT3_DEFM_JMODE_WBACK)
-		sbi->s_mount_opt |= EXT3_MOUNT_WRITEBACK_DATA;
+		set_opt(sbi->s_mount_opt, WRITEBACK_DATA);
 
 	if (le16_to_cpu(sbi->s_es->s_errors) == EXT3_ERRORS_PANIC)
 		set_opt(sbi->s_mount_opt, ERRORS_PANIC);
@@ -1694,7 +1687,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
-		((sbi->s_mount_opt & EXT3_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
+		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
 
 	if (le32_to_cpu(es->s_rev_level) == EXT3_GOOD_OLD_REV &&
 	    (EXT3_HAS_COMPAT_FEATURE(sb, ~0U) ||
@@ -2561,11 +2554,11 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 		goto restore_opts;
 	}
 
-	if (sbi->s_mount_opt & EXT3_MOUNT_ABORT)
+	if (test_opt(sb, ABORT))
 		ext3_abort(sb, __func__, "Abort forced by user");
 
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
-		((sbi->s_mount_opt & EXT3_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
+		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
 
 	es = sbi->s_es;
 
@@ -2573,7 +2566,7 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 
 	if ((*flags & MS_RDONLY) != (sb->s_flags & MS_RDONLY) ||
 		n_blocks_count > le32_to_cpu(es->s_blocks_count)) {
-		if (sbi->s_mount_opt & EXT3_MOUNT_ABORT) {
+		if (test_opt(sb, ABORT)) {
 			err = -EROFS;
 			goto restore_opts;
 		}
-- 
1.6.3.3

