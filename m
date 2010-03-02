From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 16/28] ext4: trivial quota cleanup
Date: Tue,  2 Mar 2010 13:18:33 -0500
Message-ID: <1267553925-6308-17-git-send-email-tytso@mit.edu>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43080 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab0CBSS6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 13:18:58 -0500
In-Reply-To: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

The patch is aimed to reorganize and simplify quota code a bit.
Quota code is itself complex enough, but we can make it more readable
in some places:
- Move quota option parsing to separate functions.
- Simplify old-quota and journaled-quota mix check.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |  123 +++++++++++++++++++++++++++++++------------------------
 1 files changed, 69 insertions(+), 54 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7e8b1b4..79937e9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1206,6 +1206,64 @@ static ext4_fsblk_t get_sb_block(void **data)
 
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
+static int clear_qf_name(struct super_block *sb, int qtype)
+{
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
@@ -1217,8 +1275,7 @@ static int parse_options(char *options, struct super_block *sb,
 	int data_opt = 0;
 	int option;
 #ifdef CONFIG_QUOTA
-	int qtype, qfmt;
-	char *qname;
+	int qfmt;
 #endif
 
 	if (!options)
@@ -1401,63 +1458,22 @@ static int parse_options(char *options, struct super_block *sb,
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
+			if (!set_qf_name(sb, USRQUOTA, &args[0]))
 				return 0;
-			}
-			qname = match_strdup(&args[0]);
-			if (!qname) {
-				ext4_msg(sb, KERN_ERR,
-					"Not enough memory for "
-					"storing quotafile name");
-				return 0;
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
@@ -1630,8 +1646,7 @@ set_qf_format:
 		if (test_opt(sb, GRPQUOTA) && sbi->s_qf_names[GRPQUOTA])
 			clear_opt(sbi->s_mount_opt, GRPQUOTA);
 
-		if ((sbi->s_qf_names[USRQUOTA] && test_opt(sb, GRPQUOTA)) ||
-			(sbi->s_qf_names[GRPQUOTA] && test_opt(sb, USRQUOTA))) {
+		if (test_opt(sb, GRPQUOTA) || test_opt(sb, USRQUOTA)) {
 			ext4_msg(sb, KERN_ERR, "old and new quota "
 					"format mixing");
 			return 0;
-- 
1.6.6.1.1.g974db.dirty

