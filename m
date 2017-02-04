From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] tune2fs: fix quota enablement regression
Date: Fri, 3 Feb 2017 22:23:34 -0500
Message-ID: <20170204032334.GA6952@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33031 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753393AbdBDDXd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Feb 2017 22:23:33 -0500
Received: by mail-qk0-f194.google.com with SMTP id 11so1301363qkl.0
        for <linux-ext4@vger.kernel.org>; Fri, 03 Feb 2017 19:23:33 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 5c2a665afa (Avoid dereferencing beyond allocated memory in quota
handling) induced a quota enablement regression in tune2fs.  Attempts
to enable a particular quota type (tune2fs -O project <dev>, for
example) set the appropriate feature flag in the superblock but the
quota file for the type is not initialized.

The regression prevents the current version of xfstests from running
generic/383, 384, 385, and 386 (all project quota tests) with e2fsprogs
1.43.4.  These tests exit with the message "Installed kernel does not
support project quotas", but the actual problem is that the project
quota file is not present.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 misc/tune2fs.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 6239577..f1bad60 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1483,7 +1483,7 @@ static void handle_quota_options(ext2_filsys fs)
 	quota_ctx_t qctx;
 	ext2_ino_t qf_ino;
 	enum quota_type qtype;
-	int enable = 0;
+	unsigned int qtype_bits = 0;
 
 	for (qtype = 0 ; qtype < MAXQUOTAS; qtype++)
 		if (quota_enable[qtype] != 0)
@@ -1492,19 +1492,19 @@ static void handle_quota_options(ext2_filsys fs)
 		/* Nothing to do. */
 		return;
 
-	retval = quota_init_context(&qctx, fs, 0);
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+		if (quota_enable[qtype] == QOPT_ENABLE)
+			qtype_bits |= 1 << qtype;
+	}
+
+	retval = quota_init_context(&qctx, fs, qtype_bits);
 	if (retval) {
 		com_err(program_name, retval,
 			_("while initializing quota context in support library"));
 		exit(1);
 	}
-	for (qtype = 0 ; qtype < MAXQUOTAS; qtype++) {
-		if (quota_enable[qtype] == QOPT_ENABLE) {
-			enable = 1;
-			break;
-		}
-	}
-	if (enable)
+
+	if (qtype_bits)
 		quota_compute_usage(qctx);
 
 	for (qtype = 0 ; qtype < MAXQUOTAS; qtype++) {
@@ -1540,7 +1540,7 @@ static void handle_quota_options(ext2_filsys fs)
 
 	quota_release_context(&qctx);
 
-	if (enable) {
+	if (qtype_bits) {
 		ext2fs_set_feature_quota(fs->super);
 		ext2fs_mark_super_dirty(fs);
 	} else {
-- 
2.1.4
