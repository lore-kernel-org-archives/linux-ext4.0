From: akpm@linux-foundation.org
Subject: - ext3-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:27:15 -0800
Message-ID: <200811262027.mAQKRFBN000395@imap1.linux-foundation.org>
To: jack@suse.cz, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502AbYKZU1s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Nov 2008 15:27:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext3: use sb_any_quota_loaded() instead of sb_any_quota_enabled()
has been removed from the -mm tree.  Its filename was
     ext3-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: use sb_any_quota_loaded() instead of sb_any_quota_enabled()
From: Jan Kara <jack@suse.cz>

Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN fs/ext3/super.c~ext3-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled
+++ a/fs/ext3/super.c
@@ -1035,8 +1035,7 @@ static int parse_options (char *options,
 		case Opt_grpjquota:
 			qtype = GRPQUOTA;
 set_qf_name:
-			if ((sb_any_quota_enabled(sb) ||
-			     sb_any_quota_suspended(sb)) &&
+			if (sb_any_quota_loaded(sb) &&
 			    !sbi->s_qf_names[qtype]) {
 				printk(KERN_ERR
 					"EXT3-fs: Cannot change journaled "
@@ -1075,8 +1074,7 @@ set_qf_name:
 		case Opt_offgrpjquota:
 			qtype = GRPQUOTA;
 clear_qf_name:
-			if ((sb_any_quota_enabled(sb) ||
-			     sb_any_quota_suspended(sb)) &&
+			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_qf_names[qtype]) {
 				printk(KERN_ERR "EXT3-fs: Cannot change "
 					"journaled quota options when "
@@ -1095,8 +1093,7 @@ clear_qf_name:
 		case Opt_jqfmt_vfsv0:
 			qfmt = QFMT_VFS_V0;
 set_qf_format:
-			if ((sb_any_quota_enabled(sb) ||
-			     sb_any_quota_suspended(sb)) &&
+			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_jquota_fmt != qfmt) {
 				printk(KERN_ERR "EXT3-fs: Cannot change "
 					"journaled quota options when "
@@ -1115,8 +1112,7 @@ set_qf_format:
 			set_opt(sbi->s_mount_opt, GRPQUOTA);
 			break;
 		case Opt_noquota:
-			if (sb_any_quota_enabled(sb) ||
-			    sb_any_quota_suspended(sb)) {
+			if (sb_any_quota_loaded(sb)) {
 				printk(KERN_ERR "EXT3-fs: Cannot change quota "
 					"options when quota turned on.\n");
 				return 0;
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
ext3-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
ext4-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
reiserfs-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
quota-remove-compatibility-function-sb_any_quota_enabled.patch
quota-introduce-dquot_quota_sys_file-flag.patch
quota-move-quotaio_vh-from-include-linux-to-fs.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-split-off-quota-tree-handling-into-a-separate-file.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch

