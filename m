From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/4] ext3: trivial quota cleanup
Date: Tue,  2 Feb 2010 16:05:53 +0300
Message-ID: <1265115954-2616-3-git-send-email-dmonakhov@openvz.org>
References: <1265115954-2616-1-git-send-email-dmonakhov@openvz.org>
 <1265115954-2616-2-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:31712 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab0BBNnB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Feb 2010 08:43:01 -0500
In-Reply-To: <1265115954-2616-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The patch is aimed to reorganize and simplify quota code a bit.
Quota code is itself complex enouth, but we can make it more readable
in some places:
- Move quota option parsing to separate functions.
- Simplify old-quota and journaled-quota mix check.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/super.c |  121 ++++++++++++++++++++++++++++++------------------------
 1 files changed, 67 insertions(+), 54 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 7950ff6..241c520 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -895,6 +895,63 @@ static ext3_fsblk_t get_sb_block(void **data, struct super_block *sb)
 	return sb_block;
 }
 
+#ifdef CONFIG_QUOTA
+static int set_qf_name(struct super_block *sb, int qtype, substring_t *args)
+{
+	struct ext3_sb_info *sbi = EXT3_SB(sb);
+	char *qname;
+
+	if (sb_any_quota_loaded(sb) &&
+		!sbi->s_qf_names[qtype]) {
+		ext3_msg(sb, KERN_ERR,
+			"Cannot change journaled "
+			"quota options when quota turned on");
+		return 0;
+	}
+	qname = match_strdup(args);
+	if (!qname) {
+		ext3_msg(sb, KERN_ERR,
+			"Not enough memory for storing quotafile name");
+		return 0;
+	}
+	if (sbi->s_qf_names[qtype] &&
+		strcmp(sbi->s_qf_names[qtype], qname)) {
+		ext3_msg(sb, KERN_ERR,
+			"%s quota file already specified", QTYPE2NAME(qtype));
+		kfree(qname);
+		return 0;
+	}
+	sbi->s_qf_names[qtype] = qname;
+	if (strchr(sbi->s_qf_names[qtype], '/')) {
+		ext3_msg(sb, KERN_ERR,
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
+	struct ext3_sb_info *sbi = EXT3_SB(sb);
+
+	if (sb_any_quota_loaded(sb) &&
+		sbi->s_qf_names[qtype]) {
+		ext3_msg(sb, KERN_ERR, "Cannot change journaled quota options"
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
 static int parse_options (char *options, struct super_block *sb,
 			  unsigned int *inum, unsigned long *journal_devnum,
 			  ext3_fsblk_t *n_blocks_count, int is_remount)
@@ -905,8 +962,7 @@ static int parse_options (char *options, struct super_block *sb,
 	int data_opt = 0;
 	int option;
 #ifdef CONFIG_QUOTA
-	int qtype, qfmt;
-	char *qname;
+	int qfmt;
 #endif
 
 	if (!options)
@@ -1088,62 +1144,20 @@ static int parse_options (char *options, struct super_block *sb,
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
-				ext3_msg(sb, KERN_ERR,
-					"error: cannot change journaled "
-					"quota options when quota turned on.");
+			if (!set_qf_name(sb, USRQUOTA, &args[0]))
 				return 0;
-			}
-			qname = match_strdup(&args[0]);
-			if (!qname) {
-				ext3_msg(sb, KERN_ERR,
-					"error: not enough memory for "
-					"storing quotafile name.");
-				return 0;
-			}
-			if (sbi->s_qf_names[qtype] &&
-			    strcmp(sbi->s_qf_names[qtype], qname)) {
-				ext3_msg(sb, KERN_ERR,
-					"error: %s quota file already "
-					"specified.", QTYPE2NAME(qtype));
-				kfree(qname);
-				return 0;
-			}
-			sbi->s_qf_names[qtype] = qname;
-			if (strchr(sbi->s_qf_names[qtype], '/')) {
-				ext3_msg(sb, KERN_ERR,
-					"error: quotafile must be on "
-					"filesystem root.");
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
-				ext3_msg(sb, KERN_ERR, "error: cannot change "
-					"journaled quota options when "
-					"quota turned on.");
+			if (!clear_qf_name(sb, GRPQUOTA))
 				return 0;
-			}
-			/*
-			 * The space will be released later when all options
-			 * are confirmed to be correct
-			 */
-			sbi->s_qf_names[qtype] = NULL;
 			break;
 		case Opt_jqfmt_vfsold:
 			qfmt = QFMT_VFS_OLD;
@@ -1247,8 +1261,7 @@ set_qf_format:
 		if (test_opt(sb, GRPQUOTA) && sbi->s_qf_names[GRPQUOTA])
 			clear_opt(sbi->s_mount_opt, GRPQUOTA);
 
-		if ((sbi->s_qf_names[USRQUOTA] && test_opt(sb, GRPQUOTA)) ||
-			(sbi->s_qf_names[GRPQUOTA] && test_opt(sb, USRQUOTA))) {
+		if (test_opt(sb, GRPQUOTA) || test_opt(sb, USRQUOTA)) {
 			ext3_msg(sb, KERN_ERR, "error: old and new quota "
 					"format mixing.");
 			return 0;
-- 
1.6.3.3

