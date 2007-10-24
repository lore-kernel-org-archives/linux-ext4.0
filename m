From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Change the default behaviour on error
Date: Wed, 24 Oct 2007 22:17:17 +0530
Message-ID: <1193244441-10149-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1193244441-10149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:58197 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764642AbXJXQrv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2007 12:47:51 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9OGln4G012591
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 02:47:49 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9OGloKJ2347032
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 02:47:50 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9OGlXwr025661
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 02:47:33 +1000
In-Reply-To: <1193244441-10149-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4 file system was by default ignoring errors
and continuing. This is not a good default as
continuing on error could lead to file system
corruption. Change the default to mark the file
system readonly. Debian and ubuntu already does
this as the default in their fstab.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 10feae6..62d7ec8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -691,16 +691,16 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	    le16_to_cpu(es->s_def_resgid) != EXT4_DEF_RESGID) {
 		seq_printf(seq, ",resgid=%u", sbi->s_resgid);
 	}
-	if (test_opt(sb, ERRORS_CONT)) {
+	if (test_opt(sb, ERRORS_RO)) {
 		int def_errors = le16_to_cpu(es->s_errors);
 
 		if (def_errors == EXT4_ERRORS_PANIC ||
-		    def_errors == EXT4_ERRORS_RO) {
-			seq_puts(seq, ",errors=continue");
+		    def_errors == EXT4_ERRORS_CONTINUE) {
+			seq_puts(seq, ",errors=remount-ro");
 		}
 	}
-	if (test_opt(sb, ERRORS_RO))
-		seq_puts(seq, ",errors=remount-ro");
+	if (test_opt(sb, ERRORS_CONT))
+		seq_puts(seq, ",errors=continue");
 	if (test_opt(sb, ERRORS_PANIC))
 		seq_puts(seq, ",errors=panic");
 	if (test_opt(sb, NO_UID32))
@@ -1809,10 +1809,10 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 
 	if (le16_to_cpu(sbi->s_es->s_errors) == EXT4_ERRORS_PANIC)
 		set_opt(sbi->s_mount_opt, ERRORS_PANIC);
-	else if (le16_to_cpu(sbi->s_es->s_errors) == EXT4_ERRORS_RO)
-		set_opt(sbi->s_mount_opt, ERRORS_RO);
-	else
+	else if (le16_to_cpu(sbi->s_es->s_errors) == EXT4_ERRORS_CONTINUE)
 		set_opt(sbi->s_mount_opt, ERRORS_CONT);
+	else
+		set_opt(sbi->s_mount_opt, ERRORS_RO);
 
 	sbi->s_resuid = le16_to_cpu(es->s_def_resuid);
 	sbi->s_resgid = le16_to_cpu(es->s_def_resgid);
-- 
1.5.3.4.319.gdd817-dirty
