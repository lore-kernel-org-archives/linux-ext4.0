From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 9/9] quota: remove warning message that we have fixed the nasty quota bugs
Date: Sun, 11 May 2014 00:32:53 -0400
Message-ID: <1399782773-20029-10-git-send-email-tytso@mit.edu>
References: <1399782773-20029-1-git-send-email-tytso@mit.edu>
Cc: adityakali@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60803 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbaEKEdK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 May 2014 00:33:10 -0400
In-Reply-To: <1399782773-20029-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We no longer need to reference https://ext4.wiki.kernel.org/index.php/Quota
since we've fixed the nasty bugs associated with e2fsck and the quota
feature.  The wiki page will be updated once we've done a release that
includes these fixes indicated the verison which these problems have
been fixed.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: adityakali@google.com
---
 misc/ext4.5.in         | 7 -------
 misc/mke2fs.c          | 7 -------
 misc/tune2fs.c         | 4 ----
 tests/m_quota/expect.1 | 4 ----
 4 files changed, 22 deletions(-)

diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index 5ec39f5..134c19f 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -210,13 +210,6 @@ shared storage environments.
 @QUOTA_MAN_COMMENT@Causes the quota files (i.e., user.quota and
 @QUOTA_MAN_COMMENT@group.quota which existed
 @QUOTA_MAN_COMMENT@in the older quota design) to be hidden inodes.
-@QUOTA_MAN_COMMENT@.IP
-@QUOTA_MAN_COMMENT@.B Warning:
-@QUOTA_MAN_COMMENT@The quota feature is still under development,
-@QUOTA_MAN_COMMENT@and may not be fully supported with your kernel
-@QUOTA_MAN_COMMENT@or may have various bugs.  Please
-@QUOTA_MAN_COMMENT@see https://ext4.wiki.kernel.org/index.php/Quota
-@QUOTA_MAN_COMMENT@for more details.
 .TP
 .B resize_inode
 .br
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index e1fd40e..9c4b0b2 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2162,13 +2162,6 @@ profile_error:
 				  "See https://ext4.wiki.kernel.org/"
 				  "index.php/Bigalloc for more information\n\n"));
 
-	if (!quiet &&
-	    (fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA))
-		fprintf(stderr, "%s", _("\nWarning: the quota feature is "
-				  "still under development\n"
-				  "See https://ext4.wiki.kernel.org/"
-				  "index.php/Quota for more information\n\n"));
-
 	/* Since sparse_super is the default, we would only have a problem
 	 * here if it was explicitly disabled.
 	 */
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 37f0b56..9ba32a1 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -776,10 +776,6 @@ static void handle_quota_options(ext2_filsys fs)
 	quota_release_context(&qctx);
 
 	if ((usrquota == QOPT_ENABLE) || (grpquota == QOPT_ENABLE)) {
-		fprintf(stderr, "%s", _("\nWarning: the quota feature is still "
-				  "under development\n"
-				  "See https://ext4.wiki.kernel.org/"
-				  "index.php/Quota for more information\n\n"));
 		fs->super->s_feature_ro_compat |= EXT4_FEATURE_RO_COMPAT_QUOTA;
 		ext2fs_mark_super_dirty(fs);
 	} else if (!fs->super->s_usr_quota_inum &&
diff --git a/tests/m_quota/expect.1 b/tests/m_quota/expect.1
index a0f6501..787871c 100644
--- a/tests/m_quota/expect.1
+++ b/tests/m_quota/expect.1
@@ -1,7 +1,3 @@
-
-Warning: the quota feature is still under development
-See https://ext4.wiki.kernel.org/index.php/Quota for more information
