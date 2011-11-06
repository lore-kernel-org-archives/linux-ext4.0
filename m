From: Niu <niu@whamcloud.com>
Subject: [PATCH 2/3] tune2fs: preserve old limits when turn on quota feature
Date: Sun, 06 Nov 2011 21:39:04 +0800
Message-ID: <4EB68DF8.7030608@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: adityakali@google.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58336 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab1KFNj0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Nov 2011 08:39:26 -0500
Received: by iage36 with SMTP id e36so4761131iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 06 Nov 2011 05:39:25 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When turn on quota by tune2fs, if the old quota file exist, the quota
usage should be recomputed but the old limits should be preserved.

Signed-off-by: Niu Yawei <niu@whamcloud.com>
---
 misc/tune2fs.c |   31 ++++++++++++++++++++++++-------
 1 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 8bcf667..74a0489 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -700,7 +700,6 @@ err:
 void handle_quota_options(ext2_filsys fs)
 {
 	quota_ctx_t qctx;
-	errcode_t retval;
 	ext2_ino_t qf_ino;
 
 	if (!usrquota && !grpquota)
@@ -712,15 +711,33 @@ void handle_quota_options(ext2_filsys fs)
 	if (usrquota == QOPT_ENABLE || grpquota == QOPT_ENABLE)
 		quota_compute_usage(qctx);
 
-	if (usrquota == QOPT_ENABLE)
-		quota_write_inode(qctx, USRQUOTA);
-	else if (usrquota == QOPT_DISABLE)
+	if (usrquota == QOPT_ENABLE && !fs->super->s_usr_quota_inum) {
+		if ((qf_ino = quota_file_exists(fs, USRQUOTA,
+						QFMT_VFS_V1)) > 0) {
+			if (quota_update_inode(qctx, qf_ino, USRQUOTA) == 0)
+				quota_set_sb_inum(fs, qf_ino, USRQUOTA);
+			else
+				quota_write_inode(qctx, USRQUOTA);
+		} else {
+			quota_write_inode(qctx, USRQUOTA);
+		}
+	} else if (usrquota == QOPT_DISABLE) {
 		quota_remove_inode(fs, USRQUOTA);
+	}
 
-	if (grpquota == QOPT_ENABLE)
-		quota_write_inode(qctx, GRPQUOTA);
-	else if (grpquota == QOPT_DISABLE)
+	if (grpquota == QOPT_ENABLE && !fs->super->s_grp_quota_inum) {
+		if ((qf_ino = quota_file_exists(fs, GRPQUOTA,
+						QFMT_VFS_V1)) > 0) {
+			if (quota_update_inode(qctx, qf_ino, GRPQUOTA) == 0)
+				quota_set_sb_inum(fs, qf_ino, GRPQUOTA);
+			else
+				quota_write_inode(qctx, GRPQUOTA);
+		} else {
+			quota_write_inode(qctx, GRPQUOTA);
+		}
+	} else if (grpquota == QOPT_DISABLE) {
 		quota_remove_inode(fs, GRPQUOTA);
+	}
 
 	quota_release_context(&qctx);
 
-- 1.7.1

