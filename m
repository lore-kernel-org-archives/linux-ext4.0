From: akpm@linux-foundation.org
Subject: + ext3-fix-typos-in-messages-and-comments-journalled-journaled.patch added to -mm tree
Date: Wed, 30 Apr 2008 10:50:05 -0700
Message-ID: <200804301750.m3UHo53E026668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: fix typos in messages and comments (journalled -> journaled)
has been added to the -mm tree.  Its filename is
     ext3-fix-typos-in-messages-and-comments-journalled-journaled.patch

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
Subject: ext3: fix typos in messages and comments (journalled -> journaled)
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

