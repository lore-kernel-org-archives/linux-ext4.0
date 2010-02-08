From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 02/11] ext4: trivial quota cleanup
Date: Mon, 08 Feb 2010 16:28:04 +0300
Message-ID: <1265635693-12182-3-git-send-email-dmonakhov@openvz.org>
References: <1265635693-12182-1-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-2-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:33218 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab0BHO20 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2010 09:28:26 -0500
Received: from localhost.localdomain ([unknown] [195.214.232.10])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KXI0097MZ0I9F10@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Mon, 08 Feb 2010 16:34:01 +0300 (MSK)
In-reply-to: <1265635693-12182-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The patch is aimed to reorganize and simplify quota code a bit.
Quota code is itself complex enouth, but we can make it more readable
in some places:
- Move quota option parsing to separate functions.
- Simplify old-quota and journaled-quota mix check.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/super.c |  122 ++++++++++++++++++++++++++++++------------------------
 1 files changed, 68 insertions(+), 54 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a247673..4fd8cfb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1213,6 +1213,63 @@ static ext4_fsblk_t get_sb_block(void **data)
 
 #define DEFAULT_JOURNAL_IOPRIO (IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 3))
 
+#ifdef CONFIG_QUOTA
+static int set_qf_name(struct super_block *sb, int qtype, substring_t *args)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	char *qname;
+
+	if (sb_any_quota_loaded(sb) &&
+		!sbi->s_qf_names[qtype]) {
+		ext4_msg(sb, KERN_ERR,
+			"Cannot change journaled "
+			"quota options when quota turned on");
+		return 0;
+	}
+	qname = match_strdup(args);
+	if (!qname) {
+		ext4_msg(sb, KERN_ERR,
+			"Not enough memory for storing quotafile name");
+		return 0;
+	}
+	if (sbi->s_qf_names[qtype] &&
+		strcmp(sbi->s_qf_names[qtype], qname)) {
+		ext4_msg(sb, KERN_ERR,
+			"%s quota file already specified", QTYPE2NAME(qtype));
+		kfree(qname);
+		return 0;
+	}
+	sbi->s_qf_names[qtype] = qname;
+	if (strchr(sbi->s_qf_names[qtype], '/')) {
+		ext4_msg(sb, KERN_ERR,
+			"quotafile must be on filesystem root");
+		kfree(sbi->s_qf_names[qtype]);
+		sbi->s_qf_names[qtype] = NULL;
+		return 0;
+	}
+	set_opt(sbi->s_mount_opt, QUOTA);
+	return 1;
+}
+
+static int clear_qf_name(struct super_block *sb, int qtype) {
+
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	if (sb_any_quota_loaded(sb) &&
+		sbi->s_qf_names[qtype]) {
+		ext4_msg(sb, KERN_ERR, "Cannot change journaled quota options"
+			" when quota turned on");
+		return 0;
+	}
+	/*
+	 * The space will be released later when all options are confirmed
+	 * to be correct
+	 */
+	sbi->s_qf_names[qtype] = NULL;
+	return 1;
+}
+#endif
+
 static int parse_options(char *options, struct super_block *sb,
 			 unsigned long *journal_devnum,
 			 unsigned int *journal_ioprio,
@@ -1224,8 +1281,7 @@ static int parse_options(char *options, struct super_block *sb,
 	int data_opt = 0;
 	int option;
 #ifdef CONFIG_QUOTA
-	int qtype, qfmt;
-	char *qname;
+	int qfmt;
 #endif
 
 	if (!options)
@@ -1403,63 +1459,22 @@ static int parse_options(char *options, struct super_block *sb,
 			break;
 #ifdef CONFIG_QUOTA
 		case Opt_usrjquota:
-			qtype = USRQUOTA;
-			goto set_qf_name;
-		case Opt_grpjquota:
-			qtype = GRPQUOTA;
-set_qf_name:
-			if (sb_any_quota_loaded(sb) &&
-			    !sbi->s_qf_names[qtype]) {
-				ext4_msg(sb, KERN_ERR,
-				       "Cannot change journaled "
-				       "quota options when quota turned on");
-				return 0;
-			}
-			qname = match_strdup(&args[0]);
-			if (!qname) {
-				ext4_msg(sb, KERN_ERR,
-					"Not enough memory for "
-					"storing quotafile name");
+			if (!set_qf_name(sb, USRQUOTA, &args[0]))
 				return 0;
-			}
-			if (sbi->s_qf_names[qtype] &&
-			    strcmp(sbi->s_qf_names[qtype], qname)) {
-				ext4_msg(sb, KERN_ERR,
-					"%s quota file already "
-					"specified", QTYPE2NAME(qtype));
-				kfree(qname);
-				return 0;
-			}
-			sbi->s_qf_names[qtype] = qname;
-			if (strchr(sbi->s_qf_names[qtype], '/')) {
-				ext4_msg(sb, KERN_ERR,
-					"quotafile must be on "
-					"filesystem root");
-				kfree(sbi->s_qf_names[qtype]);
-				sbi->s_qf_names[qtype] = NULL;
+			break;
+		case Opt_grpjquota:
+			if (!set_qf_name(sb, GRPQUOTA, &args[0]))
 				return 0;
-			}
-			set_opt(sbi->s_mount_opt, QUOTA);
 			break;
 		case Opt_offusrjquota:
-			qtype = USRQUOTA;
-			goto clear_qf_name;
+			if (!clear_qf_name(sb, USRQUOTA))
+				return 0;
+			break;
 		case Opt_offgrpjquota:
-			qtype = GRPQUOTA;
-clear_qf_name:
-			if (sb_any_quota_loaded(sb) &&
-			    sbi->s_qf_names[qtype]) {
-				ext4_msg(sb, KERN_ERR, "Cannot change "
-					"journaled quota options when "
-					"quota turned on");
+			if (!clear_qf_name(sb, GRPQUOTA))
 				return 0;
-			}
-			/*
-			 * The space will be released later when all options
-			 * are confirmed to be correct
-			 */
-			sbi->s_qf_names[qtype] = NULL;
 			break;
+
 		case Opt_jqfmt_vfsold:
 			qfmt = QFMT_VFS_OLD;
 			goto set_qf_format;
@@ -1636,8 +1651,7 @@ set_qf_format:
 		if (test_opt(sb, GRPQUOTA) && sbi->s_qf_names[GRPQUOTA])
 			clear_opt(sbi->s_mount_opt, GRPQUOTA);
 
-		if ((sbi->s_qf_names[USRQUOTA] && test_opt(sb, GRPQUOTA)) ||
-			(sbi->s_qf_names[GRPQUOTA] && test_opt(sb, USRQUOTA))) {
+		if (test_opt(sb, GRPQUOTA) || test_opt(sb, USRQUOTA)) {
 			ext4_msg(sb, KERN_ERR, "old and new quota "
 					"format mixing");
 			return 0;
-- 
1.6.3.3

