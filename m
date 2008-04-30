From: akpm@linux-foundation.org
Subject: + ext4-fix-typos-in-messages-and-comments-journalled-journaled.patch added to -mm tree
Date: Wed, 30 Apr 2008 10:50:07 -0700
Message-ID: <200804301750.m3UHo7vd026671@imap1.linux-foundation.org>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763450AbYD3Run (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2008 13:50:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext4: fix typos in messages and comments (journalled -> journaled)
has been added to the -mm tree.  Its filename is
     ext4-fix-typos-in-messages-and-comments-journalled-journaled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: fix typos in messages and comments (journalled -> journaled)
From: Jan Kara <jack@suse.cz>

Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/ext4/super.c~ext4-fix-typos-in-messages-and-comments-journalled-journaled fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-fix-typos-in-messages-and-comments-journalled-journaled
+++ a/fs/ext4/super.c
@@ -1167,7 +1167,7 @@ static int parse_options (char *options,
 set_qf_name:
 			if (sb_any_quota_enabled(sb)) {
 				printk(KERN_ERR
-					"EXT4-fs: Cannot change journalled "
+					"EXT4-fs: Cannot change journaled "
 					"quota options when quota turned on.\n");
 				return 0;
 			}
@@ -1205,7 +1205,7 @@ set_qf_name:
 clear_qf_name:
 			if (sb_any_quota_enabled(sb)) {
 				printk(KERN_ERR "EXT4-fs: Cannot change "
-					"journalled quota options when "
+					"journaled quota options when "
 					"quota turned on.\n");
 				return 0;
 			}
@@ -1339,14 +1339,14 @@ clear_qf_name:
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
@@ -1587,7 +1587,7 @@ static void ext4_orphan_cleanup (struct 
 			int ret = ext4_quota_on_mount(sb, i);
 			if (ret < 0)
 				printk(KERN_ERR
-					"EXT4-fs: Cannot turn on journalled "
+					"EXT4-fs: Cannot turn on journaled "
 					"quota: error %d\n", ret);
 		}
 	}
@@ -3112,7 +3112,7 @@ static int ext4_release_dquot(struct dqu
 
 static int ext4_mark_dquot_dirty(struct dquot *dquot)
 {
-	/* Are we journalling quotas? */
+	/* Are we journaling quotas? */
 	if (EXT4_SB(dquot->dq_sb)->s_qf_names[USRQUOTA] ||
 	    EXT4_SB(dquot->dq_sb)->s_qf_names[GRPQUOTA]) {
 		dquot_mark_dquot_dirty(dquot);
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
isofs-fix-access-to-unallocated-memory-when-reading-corrupted-filesystem.patch
quota-le_add_cpu-conversion.patch
ext4-fix-mount-messages-when-quota-disabled.patch
ext3-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext4-fix-synchronization-of-quota-files-in-journal=data-mode.patch
reiserfs-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext3-fix-typos-in-messages-and-comments-journalled-journaled.patch
ext4-fix-typos-in-messages-and-comments-journalled-journaled.patch
reiserfs-fix-typos-in-messages-and-comments-journalled-journaled.patch
quota-add-a-convenience-macro-for-filesystems.patch
ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
ext4-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
reiserfs-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch

