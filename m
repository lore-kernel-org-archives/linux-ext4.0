From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Fix typos in messages and comments (journalled -> journaled)
Date: Wed, 30 Apr 2008 17:06:15 +0200
Message-ID: <1209567981639-git-send-email-jack@suse.cz>
References: y
 <12095679813226-git-send-email-jack@suse.cz>
 <12095679812375-git-send-email-jack@suse.cz>
 <12095679812452-git-send-email-jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36423 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762121AbYD3PGX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2008 11:06:23 -0400
In-Reply-To: <12095679812452-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Cc: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 1c7b0fc..890e72f 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1020,7 +1020,7 @@ static int parse_options (char *options, struct super_block *sb,
 set_qf_name:
 			if (sb_any_quota_enabled(sb)) {
 				printk(KERN_ERR
-					"EXT3-fs: Cannot change journalled "
+					"EXT3-fs: Cannot change journaled "
 					"quota options when quota turned on.\n");
 				return 0;
 			}
@@ -1058,7 +1058,7 @@ set_qf_name:
 clear_qf_name:
 			if (sb_any_quota_enabled(sb)) {
 				printk(KERN_ERR "EXT3-fs: Cannot change "
-					"journalled quota options when "
+					"journaled quota options when "
 					"quota turned on.\n");
 				return 0;
 			}
@@ -1169,14 +1169,14 @@ clear_qf_name:
 		}
 
 		if (!sbi->s_jquota_fmt) {
-			printk(KERN_ERR "EXT3-fs: journalled quota format "
+			printk(KERN_ERR "EXT3-fs: journaled quota format "
 					"not specified.\n");
 			return 0;
 		}
 	} else {
 		if (sbi->s_jquota_fmt) {
-			printk(KERN_ERR "EXT3-fs: journalled quota format "
-					"specified with no journalling "
+			printk(KERN_ERR "EXT3-fs: journaled quota format "
+					"specified with no journaling "
 					"enabled.\n");
 			return 0;
 		}
@@ -1370,7 +1370,7 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 			int ret = ext3_quota_on_mount(sb, i);
 			if (ret < 0)
 				printk(KERN_ERR
-					"EXT3-fs: Cannot turn on journalled "
+					"EXT3-fs: Cannot turn on journaled "
 					"quota: error %d\n", ret);
 		}
 	}
@@ -2712,7 +2712,7 @@ static int ext3_release_dquot(struct dquot *dquot)
 
 static int ext3_mark_dquot_dirty(struct dquot *dquot)
 {
-	/* Are we journalling quotas? */
+	/* Are we journaling quotas? */
 	if (EXT3_SB(dquot->dq_sb)->s_qf_names[USRQUOTA] ||
 	    EXT3_SB(dquot->dq_sb)->s_qf_names[GRPQUOTA]) {
 		dquot_mark_dquot_dirty(dquot);
-- 
1.5.2.4

