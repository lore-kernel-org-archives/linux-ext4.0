From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext3: Change the default behaviour on error
Date: Thu, 25 Oct 2007 10:23:49 +0530
Message-ID: <1193288030-7775-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1193288030-7775-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193288030-7775-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:37593 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbXJYEyB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2007 00:54:01 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9P4sGFf010431
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 14:54:16 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9P4vYYm211384
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 14:57:34 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9P4rxhC003526
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 14:53:59 +1000
In-Reply-To: <1193288030-7775-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext3 file system was by default ignoring errors
and continuing. This is not a good default as
continuing on error could lead to file system
corruption. Change the default to mark the file
system readonly. Debian and ubuntu already does
this as the default in their fstab.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext3/super.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 0bfd3dc..6cfdd06 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -575,16 +575,16 @@ static int ext3_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	    le16_to_cpu(es->s_def_resgid) != EXT3_DEF_RESGID) {
 		seq_printf(seq, ",resgid=%u", sbi->s_resgid);
 	}
-	if (test_opt(sb, ERRORS_CONT)) {
+	if (test_opt(sb, ERRORS_RO)) {
 		int def_errors = le16_to_cpu(es->s_errors);
 
 		if (def_errors == EXT3_ERRORS_PANIC ||
-		    def_errors == EXT3_ERRORS_RO) {
-			seq_puts(seq, ",errors=continue");
+		    def_errors == EXT3_ERRORS_CONTINUE) {
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
@@ -1578,10 +1578,10 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 
 	if (le16_to_cpu(sbi->s_es->s_errors) == EXT3_ERRORS_PANIC)
 		set_opt(sbi->s_mount_opt, ERRORS_PANIC);
-	else if (le16_to_cpu(sbi->s_es->s_errors) == EXT3_ERRORS_RO)
-		set_opt(sbi->s_mount_opt, ERRORS_RO);
-	else
+	else if (le16_to_cpu(sbi->s_es->s_errors) == EXT3_ERRORS_CONTINUE)
 		set_opt(sbi->s_mount_opt, ERRORS_CONT);
+	else
+		set_opt(sbi->s_mount_opt, ERRORS_RO);
 
 	sbi->s_resuid = le16_to_cpu(es->s_def_resuid);
 	sbi->s_resgid = le16_to_cpu(es->s_def_resgid);
-- 
1.5.3.4.319.gdd817-dirty
