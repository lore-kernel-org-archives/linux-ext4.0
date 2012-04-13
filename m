From: Aditya Kali <adityakali@google.com>
Subject: [PATCH] e2fsck: Fix check for hidden quota files
Date: Fri, 13 Apr 2012 13:11:02 -0700
Message-ID: <1334347864-12662-1-git-send-email-adityakali@google.com>
Cc: Aditya Kali <adityakali@google.com>
To: tytso@mit.edu, niu@whamcloud.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:62700 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab2DMULO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Apr 2012 16:11:14 -0400
Received: by yhgm50 with SMTP id m50so407731yhg.1
        for <linux-ext4@vger.kernel.org>; Fri, 13 Apr 2012 13:11:13 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently e2fsck always incorrectly detects that quota inodes
need to be hidden (even if they are already hidden) and
modifies the superblock unnecessarily. This patch fixes the
check for hidden quota files and avoids modifying the
filesystem if quota inodes are already hidden.
Also, zero-out the old quota inode so that next fsck scan
doesn't complain.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 e2fsck/problem.c |    2 +-
 e2fsck/quota.c   |   31 +++++++++++++------------------
 2 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index d51a408..7293819 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -410,7 +410,7 @@ static struct e2fsck_problem problem_table[] = {
 
 	/* Making quota file hidden */
 	{ PR_0_HIDE_QUOTA,
-	  N_("Making @q @is hidden.\n\n"),
+	  N_("Making @q @i %i (%Q) hidden.\n"),
 	  PROMPT_NONE, PR_PREEN_OK },
 
 	/* Superblock has invalid MMP block. */
diff --git a/e2fsck/quota.c b/e2fsck/quota.c
index a5bce98..7a1476e 100644
--- a/e2fsck/quota.c
+++ b/e2fsck/quota.c
@@ -24,6 +24,10 @@ static void move_quota_inode(ext2_filsys fs, ext2_ino_t from_ino,
 	struct ext2_inode	inode;
 	char			qf_name[QUOTA_NAME_LEN];
 
+	/* We need the inode bitmap to be loaded */
+	if (ext2fs_read_bitmaps(fs))
+		return;
+
 	if (ext2fs_read_inode(fs, from_ino, &inode))
 		return;
 
@@ -39,6 +43,9 @@ static void move_quota_inode(ext2_filsys fs, ext2_ino_t from_ino,
 	quota_get_qf_name(qtype, QFMT_VFS_V1, qf_name);
 	ext2fs_unlink(fs, EXT2_ROOT_INO, qf_name, from_ino, 0);
 	ext2fs_inode_alloc_stats(fs, from_ino, -1);
+	/* Clear out the original inode in the inode-table block. */
+	memset(&inode, 0, sizeof(struct ext2_inode));
+	ext2fs_write_inode(fs, from_ino, &inode);
 }
 
 void e2fsck_hide_quota(e2fsck_t ctx)
@@ -53,31 +60,19 @@ void e2fsck_hide_quota(e2fsck_t ctx)
 	    !(sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA))
 		return;
 
-	/* We need the inode bitmap to be loaded */
-	if (ext2fs_read_bitmaps(fs))
-		return;
-
-	if (!sb->s_usr_quota_inum && !sb->s_grp_quota_inum)
-		/* nothing to do */
-		return;
-
-	if (sb->s_usr_quota_inum == EXT4_USR_QUOTA_INO &&
-	    sb->s_grp_quota_inum == EXT4_GRP_QUOTA_INO)
-		/* nothing to do */
-		return;
-
-	if (!fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx))
-		return;
