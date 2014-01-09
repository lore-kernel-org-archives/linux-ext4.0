From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] tune2fs: allow removal of dirty journal with two "-f" options
Date: Thu, 09 Jan 2014 14:08:11 -0600
Message-ID: <52CF01AB.7030704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: james.faulkner@yale.edu
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135AbaAIUIM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Jan 2014 15:08:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jim pointed out that "tune2fs -f -O ^has_journal" won't remove the
journal if the needs_recovery flag is set; the manpage seems to indicate
that it should.  And if you've lost an external journal and can no longer
replay it, how should one proceed?

Change tune2fs so that two "-f" options will allow removal of a dirty
journal from a filesystem, even if the filesystem needs recovery.

e2fsck can then do its best to pick up the pieces.

Reported-by: Jim Faulkner <james.faulkner@yale.edu>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index da21080..e07da28 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -248,7 +248,10 @@ option is useful when removing the
 filesystem feature from a filesystem which has 
 an external journal (or is corrupted
 such that it appears to have an external journal), but that 
-external journal is not available.   
+external journal is not available.   If the filesystem appears to require
+journal replay, the
+.B \-f
+flag must be specified twice to proceed.
 .sp
 .B WARNING:
 Removing an external journal from a filesystem which was not cleanly unmounted
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 0eddf6d..2318dbb 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -903,8 +903,9 @@ static int update_feature_set(ext2_filsys fs, char *features)
 				"read-only.\n"), stderr);
 			return 1;
 		}
-		if (sb->s_feature_incompat &
-		    EXT3_FEATURE_INCOMPAT_RECOVER) {
+		if ((sb->s_feature_incompat &
+		    EXT3_FEATURE_INCOMPAT_RECOVER) && 
+		    f_flag < 2) {
 			fputs(_("The needs_recovery flag is set.  "
 				"Please run e2fsck before clearing\n"
 				"the has_journal flag.\n"), stderr);
@@ -1428,7 +1429,7 @@ static void parse_tune2fs_options(int argc, char **argv)
 			open_flag |= EXT2_FLAG_RW;
 			break;
 		case 'f': /* Force */
-			f_flag = 1;
+			f_flag++;
 			break;
 		case 'g':
 			resgid = strtoul(optarg, &tmp, 0);

