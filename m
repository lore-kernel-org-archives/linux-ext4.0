From: akpm@linux-foundation.org
Subject: [patch 062/283] ext3: correct mount option parsing to detect when quota options can be changed
Date: Fri, 25 Jul 2008 00:01:56 -0700
Message-ID: <200807250701.m6P71uXt028422@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbYGYHCB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2008 03:02:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

We should not allow user to change quota mount options when quota is just
suspended.  I would make mount options and internal quota state inconsistent. 
Also we should not allow user to change quota format when quota is turned on. 
On the other hand we can just silently ignore when some option is set to the
value it already has (mount does this on remount).

Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff -puN fs/ext3/super.c~ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed
+++ a/fs/ext3/super.c
@@ -842,7 +842,7 @@ static int parse_options (char *options,
 	int data_opt = 0;
 	int option;
 #ifdef CONFIG_QUOTA
-	int qtype;
+	int qtype, qfmt;
 	char *qname;
 #endif
 
@@ -1018,7 +1018,9 @@ static int parse_options (char *options,
 		case Opt_grpjquota:
 			qtype = GRPQUOTA;
 set_qf_name:
-			if (sb_any_quota_enabled(sb)) {
+			if ((sb_any_quota_enabled(sb) ||
+			     sb_any_quota_suspended(sb)) &&
+			    !sbi->s_qf_names[qtype]) {
 				printk(KERN_ERR
 					"EXT3-fs: Cannot change journaled "
 					"quota options when quota turned on.\n");
@@ -1056,7 +1058,9 @@ set_qf_name:
 		case Opt_offgrpjquota:
 			qtype = GRPQUOTA;
 clear_qf_name:
-			if (sb_any_quota_enabled(sb)) {
+			if ((sb_any_quota_enabled(sb) ||
+			     sb_any_quota_suspended(sb)) &&
+			    sbi->s_qf_names[qtype]) {
 				printk(KERN_ERR "EXT3-fs: Cannot change "
 					"journaled quota options when "
 					"quota turned on.\n");
@@ -1069,10 +1073,20 @@ clear_qf_name:
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
+				printk(KERN_ERR "EXT3-fs: Cannot change "
+					"journaled quota options when "
+					"quota turned on.\n");
+				return 0;
+			}
+			sbi->s_jquota_fmt = qfmt;
 			break;
 		case Opt_quota:
 		case Opt_usrquota:
@@ -1084,7 +1098,8 @@ clear_qf_name:
 			set_opt(sbi->s_mount_opt, GRPQUOTA);
 			break;
 		case Opt_noquota:
-			if (sb_any_quota_enabled(sb)) {
+			if (sb_any_quota_enabled(sb) ||
+			    sb_any_quota_suspended(sb)) {
 				printk(KERN_ERR "EXT3-fs: Cannot change quota "
 					"options when quota turned on.\n");
 				return 0;
_
