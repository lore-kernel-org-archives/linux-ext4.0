From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 19/28] ext4: deprecate obsoleted mount options
Date: Tue,  2 Mar 2010 13:18:36 -0500
Message-ID: <1267553925-6308-20-git-send-email-tytso@mit.edu>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43066 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab0CBSS4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 13:18:56 -0500
In-Reply-To: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

Declare following list of mount options as deprecated:
 - bsddf, miniddf
 - grpid, bsdgroups, nogrpid, sysvgroups

Declare following list of default mount options as deprecated:
 - bsdgroups

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 79937e9..c832508 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1205,6 +1205,8 @@ static ext4_fsblk_t get_sb_block(void **data)
 }
 
 #define DEFAULT_JOURNAL_IOPRIO (IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 3))
+static char deprecated_msg[] = "Mount option \"%s\" will be removed by %s\n"
+	"Contact linux-ext4@vger.kernel.org if you think we should keep it.\n";
 
 #ifdef CONFIG_QUOTA
 static int set_qf_name(struct super_block *sb, int qtype, substring_t *args)
@@ -1294,16 +1296,23 @@ static int parse_options(char *options, struct super_block *sb,
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_bsd_df:
+			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.38");
 			clear_opt(sbi->s_mount_opt, MINIX_DF);
 			break;
 		case Opt_minix_df:
+			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.38");
 			set_opt(sbi->s_mount_opt, MINIX_DF);
+
 			break;
 		case Opt_grpid:
+			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.38");
 			set_opt(sbi->s_mount_opt, GRPID);
+
 			break;
 		case Opt_nogrpid:
+			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.38");
 			clear_opt(sbi->s_mount_opt, GRPID);
+
 			break;
 		case Opt_resuid:
 			if (match_int(&args[0], &option))
@@ -2449,8 +2458,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
 	if (def_mount_opts & EXT4_DEFM_DEBUG)
 		set_opt(sbi->s_mount_opt, DEBUG);
-	if (def_mount_opts & EXT4_DEFM_BSDGROUPS)
+	if (def_mount_opts & EXT4_DEFM_BSDGROUPS) {
+		ext4_msg(sb, KERN_WARNING, deprecated_msg, "bsdgroups",
+			"2.6.38");
 		set_opt(sbi->s_mount_opt, GRPID);
+	}
 	if (def_mount_opts & EXT4_DEFM_UID16)
 		set_opt(sbi->s_mount_opt, NO_UID32);
 #ifdef CONFIG_EXT4_FS_XATTR
-- 
1.6.6.1.1.g974db.dirty

