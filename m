From: akpm@linux-foundation.org
Subject: + ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch added to -mm tree
Date: Wed, 30 Apr 2008 10:50:13 -0700
Message-ID: <200804301750.m3UHoDa8026682@imap1.linux-foundation.org>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763534AbYD3Rur (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2008 13:50:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext3: correct mount option parsing to detect when quota options can be changed
has been added to the -mm tree.  Its filename is
     ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch

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
Subject: ext3: correct mount option parsing to detect when quota options can be changed
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

