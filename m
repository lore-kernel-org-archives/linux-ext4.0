From: Aditya Kali <adityakali@google.com>
Subject: [PATCH 2/3] tune2fs: Compute quota usage when turning on the 'quota' feature
Date: Thu,  3 Nov 2011 17:18:32 -0700
Message-ID: <1320365913-25857-2-git-send-email-adityakali@google.com>
References: <1320365913-25857-1-git-send-email-adityakali@google.com>
Cc: Aditya Kali <adityakali@google.com>
To: adilger@dilger.ca, tytso.mit.edu@google.com, niu@whamcloud.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:43144 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab1KDASs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Nov 2011 20:18:48 -0400
In-Reply-To: <1320365913-25857-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When turning on the quota feature, tune2fs would create empty quota inodes and
set their inode numbers in superblock. This required e2fsck to be ran before
using the quota feature. This patch adds adds call to compute_quota() and make
sure that we write correct quota information in the quota files at tune2fs time
itself. This gets rid of the necessity for running e2fsck after setting the
quota feature. Also, tune2fs now does not use existing old quota files
(aquota.user and aquota.group) even if they exist.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 misc/tune2fs.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 112b258..8bcf667 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -709,23 +709,18 @@ void handle_quota_options(ext2_filsys fs)
 
 	quota_init_context(&qctx, fs, -1);
 
-	if (usrquota == QOPT_ENABLE && !fs->super->s_usr_quota_inum) {
-		if ((qf_ino = quota_file_exists(fs, USRQUOTA, QFMT_VFS_V1)) > 0)
-			quota_set_sb_inum(fs, qf_ino, USRQUOTA);
-		else
-			quota_write_inode(qctx, USRQUOTA);
-	} else if (usrquota == QOPT_DISABLE) {
+	if (usrquota == QOPT_ENABLE || grpquota == QOPT_ENABLE)
+		quota_compute_usage(qctx);
+
+	if (usrquota == QOPT_ENABLE)
+		quota_write_inode(qctx, USRQUOTA);
+	else if (usrquota == QOPT_DISABLE)
 		quota_remove_inode(fs, USRQUOTA);
-	}
 
-	if (grpquota == QOPT_ENABLE && !fs->super->s_grp_quota_inum) {
-		if ((qf_ino = quota_file_exists(fs, GRPQUOTA, QFMT_VFS_V1)) > 0)
-			quota_set_sb_inum(fs, qf_ino, GRPQUOTA);
-		else
-			quota_write_inode(qctx, GRPQUOTA);
-	} else if (grpquota == QOPT_DISABLE) {
+	if (grpquota == QOPT_ENABLE)
+		quota_write_inode(qctx, GRPQUOTA);
+	else if (grpquota == QOPT_DISABLE)
 		quota_remove_inode(fs, GRPQUOTA);
-	}
 
 	quota_release_context(&qctx);
 
-- 
1.7.3.1

