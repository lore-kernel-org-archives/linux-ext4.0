From: akpm@linux-foundation.org
Subject: + ext4-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch added to -mm tree
Date: Wed, 30 Apr 2008 10:50:15 -0700
Message-ID: <200804301750.m3UHoFj1026688@imap1.linux-foundation.org>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762411AbYD3R7Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2008 13:59:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext4: correct mount option parsing to detect when quota options can be changed
has been added to the -mm tree.  Its filename is
     ext4-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch

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
Subject: ext4: correct mount option parsing to detect when quota options can be changed
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

 fs/ext4/super.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff -puN fs/ext4/super.c~ext4-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed
+++ a/fs/ext4/super.c
@@ -982,7 +982,7 @@ static int parse_options (char *options,
 	int data_opt = 0;
 	int option;
 #ifdef CONFIG_QUOTA
-	int qtype;
+	int qtype, qfmt;
 	char *qname;
 #endif
 
@@ -1165,7 +1165,9 @@ static int parse_options (char *options,
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
@@ -1203,7 +1205,9 @@ set_qf_name:
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
@@ -1216,10 +1220,20 @@ clear_qf_name:
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

