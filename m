From: akpm@linux-foundation.org
Subject: + ext2-change-the-default-behaviour-on-error.patch added to -mm tree
Date: Thu, 25 Oct 2007 14:33:48 -0700
Message-ID: <200710252133.l9PLXmUK025091@imap1.linux-foundation.org>
Cc: aneesh.kumar@linux.vnet.ibm.com, cebbert@redhat.com,
	davej@codemonkey.org.uk, jack@ucw.cz, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57046 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753331AbXJYVeP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2007 17:34:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext2: change the default behaviour on error
has been added to the -mm tree.  Its filename is
     ext2-change-the-default-behaviour-on-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext2: change the default behaviour on error
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

ext2 file system was by default ignoring errors and continuing.  This is
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

 fs/ext2/super.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/ext2/super.c~ext2-change-the-default-behaviour-on-error fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-change-the-default-behaviour-on-error
+++ a/fs/ext2/super.c
@@ -234,16 +234,16 @@ static int ext2_show_options(struct seq_
 	    le16_to_cpu(es->s_def_resgid) != EXT2_DEF_RESGID) {
 		seq_printf(seq, ",resgid=%u", sbi->s_resgid);
 	}
-	if (test_opt(sb, ERRORS_CONT)) {
+	if (test_opt(sb, ERRORS_RO)) {
 		int def_errors = le16_to_cpu(es->s_errors);
 
 		if (def_errors == EXT2_ERRORS_PANIC ||
-		    def_errors == EXT2_ERRORS_RO) {
-			seq_puts(seq, ",errors=continue");
+		    def_errors == EXT2_ERRORS_CONTINUE) {
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
@@ -796,10 +796,10 @@ static int ext2_fill_super(struct super_
 	
 	if (le16_to_cpu(sbi->s_es->s_errors) == EXT2_ERRORS_PANIC)
 		set_opt(sbi->s_mount_opt, ERRORS_PANIC);
-	else if (le16_to_cpu(sbi->s_es->s_errors) == EXT2_ERRORS_RO)
-		set_opt(sbi->s_mount_opt, ERRORS_RO);
-	else
+	else if (le16_to_cpu(sbi->s_es->s_errors) == EXT2_ERRORS_CONTINUE)
 		set_opt(sbi->s_mount_opt, ERRORS_CONT);
+	else
+		set_opt(sbi->s_mount_opt, ERRORS_RO);
 
 	sbi->s_resuid = le16_to_cpu(es->s_def_resuid);
 	sbi->s_resgid = le16_to_cpu(es->s_def_resgid);
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

ext2-return-after-ext2_error-in-case-of-failures.patch
ext2-change-the-default-behaviour-on-error.patch
ext4-return-after-ext4_error-in-case-of-failures.patch
ext3-return-after-ext3_error-in-case-of-failures.patch
ext3-change-the-default-behaviour-on-error.patch
ext2-fix-the-max-file-size-for-ext2-file-system.patch
ext3-fix-the-max-file-size-for-ext3-file-system.patch
