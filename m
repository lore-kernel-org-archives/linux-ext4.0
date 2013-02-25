From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext4: Don't allow quota mount options when quota feature enabled
Date: Tue, 26 Feb 2013 00:36:08 +0100
Message-ID: <1361835369-19850-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759683Ab3BYXgS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2013 18:36:18 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So far we silently ignored when quota mount options were set while quota
feature was enabled. But this can create confusion in userspace when
mount options are set but silently ignored and also creates opportunities
for bugs when we don't properly test all quota types. Actually
ext4_mark_dquot_dirty() forgets to test for quota feature so it was
dependent on journaled quota options being set. OTOH ext4_orphan_cleanup()
tries to enable journaled quota when quota options are specified which is
wrong when quota feature is enabled.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |   33 ++++++++++++++++++++++++++-------
 1 files changed, 26 insertions(+), 7 deletions(-)

I've spotted two issues with quota feature in kernel when reviewing Jeff's
patch. So here are the fixes.

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 161f043..1746a6e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1345,6 +1345,11 @@ static int set_qf_name(struct super_block *sb, int qtype, substring_t *args)
 			"quota options when quota turned on");
 		return -1;
 	}
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA)) {
+		ext4_msg(sb, KERN_ERR, "Cannot set journaled quota options "
+			 "when QUOTA feature is enabled");
+		return -1;
+	}
 	qname = match_strdup(args);
 	if (!qname) {
 		ext4_msg(sb, KERN_ERR,
@@ -1615,6 +1620,13 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 					 "when quota turned on");
 				return -1;
 			}
+			if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
+						EXT4_FEATURE_RO_COMPAT_QUOTA)) {
+				ext4_msg(sb, KERN_ERR,
+					 "Cannot set journaled quota options "
+					 "when QUOTA feature is enabled");
+				return -1;
+			}
 			sbi->s_jquota_fmt = m->mount_opt;
 #endif
 		} else {
@@ -1667,6 +1679,12 @@ static int parse_options(char *options, struct super_block *sb,
 			return 0;
 	}
 #ifdef CONFIG_QUOTA
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
+	    (test_opt(sb, USRQUOTA) || test_opt(sb, GRPQUOTA))) {
+		ext4_msg(sb, KERN_ERR, "Cannot set quota options when QUOTA "
+			 "feature is enabled");
+		return 0;
+	}
 	if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
 		if (test_opt(sb, USRQUOTA) && sbi->s_qf_names[USRQUOTA])
 			clear_opt(sb, USRQUOTA);
@@ -3783,13 +3801,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_export_op = &ext4_export_ops;
 	sb->s_xattr = ext4_xattr_handlers;
 #ifdef CONFIG_QUOTA
-	sb->s_qcop = &ext4_qctl_operations;
 	sb->dq_op = &ext4_quota_operations;
-
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA)) {
-		/* Use qctl operations for hidden quota files. */
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA))
 		sb->s_qcop = &ext4_qctl_sysfile_operations;
-	}
+	else
+		sb->s_qcop = &ext4_qctl_operations;
 #endif
 	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 
@@ -4887,9 +4903,12 @@ static int ext4_release_dquot(struct dquot *dquot)
 
 static int ext4_mark_dquot_dirty(struct dquot *dquot)
 {
+	struct super_block *sb = dquot->dq_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
 	/* Are we journaling quotas? */
-	if (EXT4_SB(dquot->dq_sb)->s_qf_names[USRQUOTA] ||
-	    EXT4_SB(dquot->dq_sb)->s_qf_names[GRPQUOTA]) {
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) ||
+	    sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
 		dquot_mark_dquot_dirty(dquot);
 		return ext4_write_dquot(dquot);
 	} else {
-- 
1.7.1

