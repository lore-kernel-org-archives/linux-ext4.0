From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix ext4_show_options to show the correct mount options.
Date: Wed, 24 Oct 2007 22:17:21 +0530
Message-ID: <1193244441-10149-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1193244441-10149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:58240 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764648AbXJXQr5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2007 12:47:57 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9OGlsBi012643
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 02:47:54 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9OGlt3o1851592
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 02:47:55 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9OGld7O025835
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 02:47:39 +1000
In-Reply-To: <1193244441-10149-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We need to look at the default value and make sure
the mount options are not set via default value
before showing them via ext4_show_options

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f1f70ce..5300c17 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -668,18 +668,20 @@ static inline void ext4_show_quota_options(struct seq_file *seq, struct super_bl
  */
 static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 {
+	int def_errors;
+	unsigned long def_mount_opts;
 	struct super_block *sb = vfs->mnt_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
-	unsigned long def_mount_opts;
 
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
+	def_errors     = le16_to_cpu(es->s_errors);
 
 	if (sbi->s_sb_block != 1)
 		seq_printf(seq, ",sb=%llu", sbi->s_sb_block);
 	if (test_opt(sb, MINIX_DF))
 		seq_puts(seq, ",minixdf");
-	if (test_opt(sb, GRPID))
+	if (test_opt(sb, GRPID) && !(def_mount_opts & EXT4_DEFM_BSDGROUPS))
 		seq_puts(seq, ",grpid");
 	if (!test_opt(sb, GRPID) && (def_mount_opts & EXT4_DEFM_BSDGROUPS))
 		seq_puts(seq, ",nogrpid");
@@ -692,25 +694,24 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_printf(seq, ",resgid=%u", sbi->s_resgid);
 	}
 	if (test_opt(sb, ERRORS_RO)) {
-		int def_errors = le16_to_cpu(es->s_errors);
-
 		if (def_errors == EXT4_ERRORS_PANIC ||
 		    def_errors == EXT4_ERRORS_CONTINUE) {
 			seq_puts(seq, ",errors=remount-ro");
 		}
 	}
-	if (test_opt(sb, ERRORS_CONT))
+	if (test_opt(sb, ERRORS_CONT) && def_errors != EXT4_ERRORS_CONTINUE)
 		seq_puts(seq, ",errors=continue");
-	if (test_opt(sb, ERRORS_PANIC))
+	if (test_opt(sb, ERRORS_PANIC)&& def_errors != EXT4_ERRORS_PANIC)
 		seq_puts(seq, ",errors=panic");
-	if (test_opt(sb, NO_UID32))
+	if (test_opt(sb, NO_UID32) && !(def_mount_opts & EXT4_DEFM_UID16))
 		seq_puts(seq, ",nouid32");
-	if (test_opt(sb, DEBUG))
+	if (test_opt(sb, DEBUG) && !(def_mount_opts & EXT4_DEFM_DEBUG))
 		seq_puts(seq, ",debug");
 	if (test_opt(sb, OLDALLOC))
 		seq_puts(seq, ",oldalloc");
 #ifdef CONFIG_EXT4_FS_XATTR
-	if (test_opt(sb, XATTR_USER))
+	if (test_opt(sb, XATTR_USER) &&
+	    !(def_mount_opts & EXT4_DEFM_XATTR_USER)) {
 		seq_puts(seq, ",user_xattr");
 	if (!test_opt(sb, XATTR_USER) &&
 	    (def_mount_opts & EXT4_DEFM_XATTR_USER)) {
@@ -718,7 +719,7 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	}
 #endif
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
-	if (test_opt(sb, POSIX_ACL))
+	if (test_opt(sb, POSIX_ACL) && !(def_mount_opts & EXT4_DEFM_ACL))
 		seq_puts(seq, ",acl");
 	if (!test_opt(sb, POSIX_ACL) && (def_mount_opts & EXT4_DEFM_ACL))
 		seq_puts(seq, ",noacl");
@@ -742,6 +743,10 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (!test_opt(sb, DELALLOC))
 		seq_puts(seq, ",nodelalloc");
 
+	/*
+	 * journal mode get enabled in different ways
+	 * So just print the value even if we didn't specify it
+	 */
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
 		seq_puts(seq, ",data=journal");
 	else if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA)
@@ -750,7 +755,6 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",data=writeback");
 
 	ext4_show_quota_options(seq, sb);
-
 	return 0;
 }
 
@@ -1145,7 +1149,7 @@ static int parse_options (char *options, struct super_block *sb,
 					return 0;
 				}
 			} else {
-				sbi->s_mount_opt &= ~EXT4_MOUNT_DATA_FLAGS;
+				clear_opt(sbi->s_mount_opt, DATA_FLAGS);
 				sbi->s_mount_opt |= data_opt;
 			}
 			break;
-- 
1.5.3.4.319.gdd817-dirty
