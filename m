From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix typos in messages and comments (journalled -> journaled)
Date: Wed, 30 Apr 2008 17:06:16 +0200
Message-ID: <1209567981323-git-send-email-jack@suse.cz>
References: y
 <12095679813226-git-send-email-jack@suse.cz>
 <12095679812375-git-send-email-jack@suse.cz>
 <12095679812452-git-send-email-jack@suse.cz>
 <1209567981639-git-send-email-jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36432 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762134AbYD3PGX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2008 11:06:23 -0400
In-Reply-To: <1209567981639-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Cc: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f6ab164..49099e4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1164,7 +1164,7 @@ static int parse_options (char *options, struct super_block *sb,
 set_qf_name:
 			if (sb_any_quota_enabled(sb)) {
 				printk(KERN_ERR
-					"EXT4-fs: Cannot change journalled "
+					"EXT4-fs: Cannot change journaled "
 					"quota options when quota turned on.\n");
 				return 0;
 			}
@@ -1202,7 +1202,7 @@ set_qf_name:
 clear_qf_name:
 			if (sb_any_quota_enabled(sb)) {
 				printk(KERN_ERR "EXT4-fs: Cannot change "
-					"journalled quota options when "
+					"journaled quota options when "
 					"quota turned on.\n");
 				return 0;
 			}
@@ -1248,7 +1248,7 @@ clear_qf_name:
 		case Opt_jqfmt_vfsold:
 		case Opt_jqfmt_vfsv0:
 			printk(KERN_ERR
-				"EXT4-fs: journalled quota options not "
+				"EXT4-fs: journaled quota options not "
 				"supported.\n");
 			break;
 		case Opt_noquota:
@@ -1333,14 +1333,14 @@ clear_qf_name:
 		}
 
 		if (!sbi->s_jquota_fmt) {
-			printk(KERN_ERR "EXT4-fs: journalled quota format "
+			printk(KERN_ERR "EXT4-fs: journaled quota format "
 					"not specified.\n");
 			return 0;
 		}
 	} else {
 		if (sbi->s_jquota_fmt) {
-			printk(KERN_ERR "EXT4-fs: journalled quota format "
-					"specified with no journalling "
+			printk(KERN_ERR "EXT4-fs: journaled quota format "
+					"specified with no journaling "
 					"enabled.\n");
 			return 0;
 		}
@@ -1581,7 +1581,7 @@ static void ext4_orphan_cleanup (struct super_block * sb,
 			int ret = ext4_quota_on_mount(sb, i);
 			if (ret < 0)
 				printk(KERN_ERR
-					"EXT4-fs: Cannot turn on journalled "
+					"EXT4-fs: Cannot turn on journaled "
 					"quota: error %d\n", ret);
 		}
 	}
@@ -3106,7 +3106,7 @@ static int ext4_release_dquot(struct dquot *dquot)
 
 static int ext4_mark_dquot_dirty(struct dquot *dquot)
 {
-	/* Are we journalling quotas? */
+	/* Are we journaling quotas? */
 	if (EXT4_SB(dquot->dq_sb)->s_qf_names[USRQUOTA] ||
 	    EXT4_SB(dquot->dq_sb)->s_qf_names[GRPQUOTA]) {
 		dquot_mark_dquot_dirty(dquot);
-- 
1.5.2.4

