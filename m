From: akpm@linux-foundation.org
Subject: [patch 061/283] ext3: fix typos in messages and comments (journalled -> journaled)
Date: Fri, 25 Jul 2008 00:01:55 -0700
Message-ID: <200807250701.m6P71tVA028418@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753AbYGYHCB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2008 03:02:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/ext3/super.c~ext3-fix-typos-in-messages-and-comments-journalled-journaled fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-fix-typos-in-messages-and-comments-journalled-journaled
+++ a/fs/ext3/super.c
@@ -1020,7 +1020,7 @@ static int parse_options (char *options,
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
@@ -1370,7 +1370,7 @@ static void ext3_orphan_cleanup (struct 
 			int ret = ext3_quota_on_mount(sb, i);
 			if (ret < 0)
 				printk(KERN_ERR
-					"EXT3-fs: Cannot turn on journalled "
+					"EXT3-fs: Cannot turn on journaled "
 					"quota: error %d\n", ret);
 		}
 	}
@@ -2712,7 +2712,7 @@ static int ext3_release_dquot(struct dqu
 
 static int ext3_mark_dquot_dirty(struct dquot *dquot)
 {
-	/* Are we journalling quotas? */
+	/* Are we journaling quotas? */
 	if (EXT3_SB(dquot->dq_sb)->s_qf_names[USRQUOTA] ||
 	    EXT3_SB(dquot->dq_sb)->s_qf_names[GRPQUOTA]) {
 		dquot_mark_dquot_dirty(dquot);
_
