From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Correct mount option parsing to detect when quota options can be changed
Date: Wed, 30 Apr 2008 17:06:20 +0200
Message-ID: <12095679822135-git-send-email-jack@suse.cz>
References: y
 <12095679813226-git-send-email-jack@suse.cz>
 <12095679812375-git-send-email-jack@suse.cz>
 <12095679812452-git-send-email-jack@suse.cz>
 <1209567981639-git-send-email-jack@suse.cz>
 <1209567981323-git-send-email-jack@suse.cz>
 <12095679812717-git-send-email-jack@suse.cz>
 <12095679824183-git-send-email-jack@suse.cz>
 <12095679822696-git-send-email-jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36443 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762177AbYD3PGY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2008 11:06:24 -0400
In-Reply-To: <12095679822696-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should not allow user to change quota mount options when quota is just
suspended. I would make mount options and internal quota state inconsistent.
Also we should not allow user to change quota format when quota is turned on.
On the other hand we can just silently ignore when some option is set to the
value it already has (mount does this on remount).

Cc: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 49099e4..4f0588a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -979,7 +979,7 @@ static int parse_options (char *options, struct super_block *sb,
 	int data_opt = 0;
 	int option;
 #ifdef CONFIG_QUOTA
-	int qtype;
+	int qtype, qfmt;
 	char *qname;
 #endif
 
@@ -1162,7 +1162,9 @@ static int parse_options (char *options, struct super_block *sb,
 		case Opt_grpjquota:
 			qtype = GRPQUOTA;
 set_qf_name:
-			if (sb_any_quota_enabled(sb)) {
+			if ((sb_any_quota_enabled(sb) ||
+			     sb_any_quota_suspended(sb)) &&
+			    !sbi->s_qf_names[qtype]) {
 				printk(KERN_ERR
 					"EXT4-fs: Cannot change journaled "
 					"quota options when quota turned on.\n");
@@ -1200,7 +1202,9 @@ set_qf_name:
 		case Opt_offgrpjquota:
 			qtype = GRPQUOTA;
 clear_qf_name:
-			if (sb_any_quota_enabled(sb)) {
+			if ((sb_any_quota_enabled(sb) ||
+			     sb_any_quota_suspended(sb)) &&
+			    sbi->s_qf_names[qtype]) {
 				printk(KERN_ERR "EXT4-fs: Cannot change "
 					"journaled quota options when "
 					"quota turned on.\n");
@@ -1213,10 +1217,20 @@ clear_qf_name:
 			sbi->s_qf_names[qtype] = NULL;
 			break;
 		case Opt_jqfmt_vfsold:
-			sbi->s_jquota_fmt = QFMT_VFS_OLD;
-			break;
+			qfmt = QFMT_VFS_OLD;
+			goto set_qf_format;
 		case Opt_jqfmt_vfsv0:
-			sbi->s_jquota_fmt = QFMT_VFS_V0;
+			qfmt = QFMT_VFS_V0;
+set_qf_format:
+			if ((sb_any_quota_enabled(sb) ||
+			     sb_any_quota_suspended(sb)) &&
+			    sbi->s_jquota_fmt != qfmt) {
+				printk(KERN_ERR "EXT4-fs: Cannot change "
+					"journaled quota options when "
+					"quota turned on.\n");
+				return 0;
+			}
+			sbi->s_jquota_fmt = qfmt;
 			break;
 		case Opt_quota:
 		case Opt_usrquota:
-- 
1.5.2.4

