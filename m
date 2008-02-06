From: akpm@linux-foundation.org
Subject: [patch 251/260] ext3: change the default behaviour on error
Date: Wed, 06 Feb 2008 01:40:14 -0800
Message-ID: <200802060939.m169dttJ004791@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com,
	cebbert@redhat.com, davej@codemonkey.org.uk, jack@ucw.cz,
	linux-ext4@vger.kernel.org, sandeen@redhat.com
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51662 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762421AbYBFJvn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2008 04:51:43 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

ext3 file system was by default ignoring errors and continuing.  This is
not a good default as continuing on error could lead to file system
corruption.  Change the default to mark the file system readonly.  Debian
and ubuntu already does this as the default in their fstab.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Jan Kara <jack@ucw.cz>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/ext3/super.c~ext3-change-the-default-behaviour-on-error fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-change-the-default-behaviour-on-error
+++ a/fs/ext3/super.c
@@ -575,16 +575,16 @@ static int ext3_show_options(struct seq_
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
@@ -1583,10 +1583,10 @@ static int ext3_fill_super (struct super
 
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
_
