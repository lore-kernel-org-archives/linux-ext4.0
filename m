From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 15/28] ext4: mount flags manipulation cleanup
Date: Tue,  2 Mar 2010 13:18:32 -0500
Message-ID: <1267553925-6308-16-git-send-email-tytso@mit.edu>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43095 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab0CBSS7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 13:18:59 -0500
In-Reply-To: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

Replace intermediate EXT4_MOUNT_XXX flags manipulation to
corresponding macro.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1c85bb6..7e8b1b4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -796,10 +796,10 @@ static inline void ext4_show_quota_options(struct seq_file *seq,
 	if (sbi->s_qf_names[GRPQUOTA])
 		seq_printf(seq, ",grpjquota=%s", sbi->s_qf_names[GRPQUOTA]);
 
-	if (sbi->s_mount_opt & EXT4_MOUNT_USRQUOTA)
+	if (test_opt(sb, USRQUOTA))
 		seq_puts(seq, ",usrquota");
 
-	if (sbi->s_mount_opt & EXT4_MOUNT_GRPQUOTA)
+	if (test_opt(sb, GRPQUOTA))
 		seq_puts(seq, ",grpquota");
 #endif
 }
@@ -1383,14 +1383,13 @@ static int parse_options(char *options, struct super_block *sb,
 			data_opt = EXT4_MOUNT_WRITEBACK_DATA;
 		datacheck:
 			if (is_remount) {
-				if ((sbi->s_mount_opt & EXT4_MOUNT_DATA_FLAGS)
-						!= data_opt) {
+				if (test_opt(sb, DATA_FLAGS) != data_opt) {
 					ext4_msg(sb, KERN_ERR,
 						"Cannot change data mode on remount");
 					return 0;
 				}
 			} else {
-				sbi->s_mount_opt &= ~EXT4_MOUNT_DATA_FLAGS;
+				clear_opt(sbi->s_mount_opt, DATA_FLAGS);
 				sbi->s_mount_opt |= data_opt;
 			}
 			break;
@@ -1625,18 +1624,14 @@ set_qf_format:
 	}
 #ifdef CONFIG_QUOTA
 	if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
-		if ((sbi->s_mount_opt & EXT4_MOUNT_USRQUOTA) &&
-		     sbi->s_qf_names[USRQUOTA])
+		if (test_opt(sb, USRQUOTA) && sbi->s_qf_names[USRQUOTA])
 			clear_opt(sbi->s_mount_opt, USRQUOTA);
 
-		if ((sbi->s_mount_opt & EXT4_MOUNT_GRPQUOTA) &&
-		     sbi->s_qf_names[GRPQUOTA])
+		if (test_opt(sb, GRPQUOTA) && sbi->s_qf_names[GRPQUOTA])
 			clear_opt(sbi->s_mount_opt, GRPQUOTA);
 
-		if ((sbi->s_qf_names[USRQUOTA] &&
-				(sbi->s_mount_opt & EXT4_MOUNT_GRPQUOTA)) ||
-		    (sbi->s_qf_names[GRPQUOTA] &&
-				(sbi->s_mount_opt & EXT4_MOUNT_USRQUOTA))) {
+		if ((sbi->s_qf_names[USRQUOTA] && test_opt(sb, GRPQUOTA)) ||
+			(sbi->s_qf_names[GRPQUOTA] && test_opt(sb, USRQUOTA))) {
 			ext4_msg(sb, KERN_ERR, "old and new quota "
 					"format mixing");
 			return 0;
@@ -2452,11 +2447,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		set_opt(sbi->s_mount_opt, POSIX_ACL);
 #endif
 	if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_DATA)
-		sbi->s_mount_opt |= EXT4_MOUNT_JOURNAL_DATA;
+		set_opt(sbi->s_mount_opt, JOURNAL_DATA);
 	else if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_ORDERED)
-		sbi->s_mount_opt |= EXT4_MOUNT_ORDERED_DATA;
+		set_opt(sbi->s_mount_opt, ORDERED_DATA);
 	else if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_WBACK)
-		sbi->s_mount_opt |= EXT4_MOUNT_WRITEBACK_DATA;
+		set_opt(sbi->s_mount_opt, WRITEBACK_DATA);
 
 	if (le16_to_cpu(sbi->s_es->s_errors) == EXT4_ERRORS_PANIC)
 		set_opt(sbi->s_mount_opt, ERRORS_PANIC);
@@ -2484,7 +2479,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
-		((sbi->s_mount_opt & EXT4_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
+		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
 
 	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV &&
 	    (EXT4_HAS_COMPAT_FEATURE(sb, ~0U) ||
@@ -3520,7 +3515,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		ext4_abort(sb, __func__, "Abort forced by user");
 
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
-		((sbi->s_mount_opt & EXT4_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
+		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
 
 	es = sbi->s_es;
 
-- 
1.6.6.1.1.g974db.dirty

