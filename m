From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/4] ext4: mount flags manipulation cleanup
Date: Tue,  2 Feb 2010 16:05:52 +0300
Message-ID: <1265115954-2616-2-git-send-email-dmonakhov@openvz.org>
References: <1265115954-2616-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:31712 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab0BBNnA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Feb 2010 08:43:00 -0500
In-Reply-To: <1265115954-2616-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Replace intermediate EXT4_MOUNT_XXX flags manipulation to
corresponding macro.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/super.c |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 735c20d..e768a2c 100644
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
@@ -1378,14 +1378,13 @@ static int parse_options(char *options, struct super_block *sb,
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
@@ -1618,18 +1617,14 @@ set_qf_format:
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
@@ -2445,11 +2440,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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
@@ -2477,7 +2472,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
-		((sbi->s_mount_opt & EXT4_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
+		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
 
 	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV &&
 	    (EXT4_HAS_COMPAT_FEATURE(sb, ~0U) ||
@@ -3514,7 +3509,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		ext4_abort(sb, __func__, "Abort forced by user");
 
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
-		((sbi->s_mount_opt & EXT4_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
+		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
 
 	es = sbi->s_es;
 
-- 
1.6.3.3

