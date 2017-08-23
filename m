From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/5] tune2fs: do not enable project feature or quota if inode size is 128 bytes
Date: Wed, 23 Aug 2017 11:42:08 -0400
Message-ID: <20170823154210.8756-3-tytso@mit.edu>
References: <20170823154210.8756-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45878 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754139AbdHWPmS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Aug 2017 11:42:18 -0400
In-Reply-To: <20170823154210.8756-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't allow the user to enable the project feature (or project quota)
if the inode size is 128 bytes.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 misc/tune2fs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 85435674d..99c17cc47 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1310,6 +1310,11 @@ mmp_error:
 
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 		       EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+		if (fs->super->s_inode_size == EXT2_GOOD_OLD_INODE_SIZE) {
+			fprintf(stderr, _("Cannot enable project feature; "
+					  "inode size too small.\n"));
+			exit(1);
+		}
 		Q_flag = 1;
 		quota_enable[PRJQUOTA] = QOPT_ENABLE;
 	}
@@ -1497,6 +1502,13 @@ static void handle_quota_options(ext2_filsys fs)
 		/* Nothing to do. */
 		return;
 
+	if (quota_enable[PRJQUOTA] == QOPT_ENABLE &&
+	    fs->super->s_inode_size == EXT2_GOOD_OLD_INODE_SIZE) {
+		fprintf(stderr, _("Cannot enable project quota; "
+				  "inode size too small.\n"));
+		exit(1);
+	}
+
 	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
 		if (quota_enable[qtype] == QOPT_ENABLE)
 			qtype_bits |= 1 << qtype;
-- 
2.11.0.rc0.7.gbe5a750
