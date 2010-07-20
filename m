From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 08/12] e2fsprogs: Check Next3 snapshot list on fsck
Date: Tue, 20 Jul 2010 18:16:09 +0300
Message-ID: <1279638973-14561-9-git-send-email-amir73il@users.sf.net>
References: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: tytso@mit.edu, andreas.dilger@oracle.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42770 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab0GTPRh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jul 2010 11:17:37 -0400
Received: by mail-ww0-f44.google.com with SMTP id 40so968910wwj.1
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jul 2010 08:17:36 -0700 (PDT)
In-Reply-To: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check that all inodes on snapshot list are valid snapshots and
prompt to terminate list when bad inode is found.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 e2fsck/problem.c |   11 ++++++-
 e2fsck/problem.h |    3 ++
 e2fsck/super.c   |   73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 0a2d31d..0b6b892 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -40,7 +40,8 @@
 #define PROMPT_UNLINK	17
 #define PROMPT_CLEAR_HTREE 18
 #define PROMPT_RECREATE 19
-#define PROMPT_NULL	20
+#define PROMPT_TERMINATE_LIST 20
+#define PROMPT_NULL	22
 
 /*
  * These are the prompts which are used to ask the user if they want
@@ -67,7 +68,8 @@ static const char *prompt[] = {
 	N_("Unlink"),		/* 17 */
 	N_("Clear HTree index"),/* 18 */
 	N_("Recreate"),		/* 19 */
-	"",			/* 20 */
+	N_("Terminate list"),	/* 20 */
+	"",			/* 22 */
 };
 
 /*
@@ -342,6 +344,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Exclude @i not valid.  "),
 	  PROMPT_RECREATE, 0 },
 
+	/* Bad snapshot on list */
+	{ PR_0_BAD_SNAPSHOT,
+	  N_("Bad @i found on snapshot list.  "),
+	  PROMPT_TERMINATE_LIST, PR_PREEN_OK },
+
 	/* Last mount time is in the future */
 	{ PR_0_FUTURE_SB_LAST_MOUNT,
 	  N_("@S last mount time (%t,\n\tnow = %T) is in the future.\n"),
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index da52597..1e63b52 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -234,6 +234,9 @@ struct problem_context {
 /* Exclude inode invalid */
 #define PR_0_EXCLUDE_INODE_INVALID		0x000101
 
+/* Bas snapshot on list */
+#define PR_0_BAD_SNAPSHOT			0x000102
+
 
 /*
  * Pass 1 errors
diff --git a/e2fsck/super.c b/e2fsck/super.c
index a9cf0d9..8e24c18 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -516,6 +516,75 @@ void check_exclude_inode(e2fsck_t ctx)
 }
 
 /*
+ * Check that snapshot list contains valid snapshot files.
+ * Returns the number of valid snapshots on list.
+ *
+ * TODO: cleanup orphan snapshot files (not found on list)
+ */
+static int check_snapshot_list(e2fsck_t ctx)
+{
+	ext2_filsys fs = ctx->fs;
+	struct ext2_super_block *sb = fs->super;
+	struct ext2_inode	inode;
+	struct ext2_inode	inode_prev;
+	ext2_ino_t		ino = sb->s_snapshot_list;
+	ext2_ino_t		ino_prev = 0;
+	errcode_t		retval = 0;
+	struct problem_context	pctx;
+	int i = 0;
+	
+	if (!ino && sb->s_snapshot_inum) {
+		/* reset snapshot list head to active snapshot */
+		ino = sb->s_snapshot_list = sb->s_snapshot_inum;
+		ext2fs_mark_super_dirty(fs);
+	}
+	if (ino)
+		fputs(_("Checking snapshots: "), stderr);
+
+	while (ino) {
+		retval = ext2fs_read_inode(fs, ino,  &inode);
+		if (retval || !(inode.i_flags & EXT4_SNAPFILE_FL) ||
+				!LINUX_S_ISREG(inode.i_mode) || 
+				inode.i_dtime) {
+			if (ino == sb->s_snapshot_list) {
+				/* reset list head */
+				sb->s_snapshot_list = 0;
+				ext2fs_mark_super_dirty(fs);
+				ino = sb->s_snapshot_inum;
+				continue;
+			}
+			clear_problem_context(&pctx);
+			if (!fix_problem(ctx, PR_0_BAD_SNAPSHOT, &pctx))
+				break;
+
+			/* disconnect inode from snapshot list */
+			if (ino == sb->s_snapshot_inum) {
+				/* reset active snapshot */
+				sb->s_snapshot_inum = 0;
+				ext2fs_mark_super_dirty(fs);
+			}
+			if (ino_prev) {
+				/* terminate list at prev inode */
+				inode_prev.i_next_snapshot = 0;
+				e2fsck_write_inode(ctx, ino_prev, &inode_prev,
+						"terminate snapshot list");
+			}
+			break;
+		}
+
+		fprintf(stderr, _("%u,"), inode.i_generation);
+		inode_prev = inode;
+		ino_prev = ino;
+		ino = inode.i_next_snapshot;
+		i++;
+	}
+	
+	if (ino_prev && !ino)
+		fputs(_("done\n"), stderr);
+	return i;
+}
+
+/*
  * This function checks if the file system has snapshots
  */
 void check_snapshots(e2fsck_t ctx)
@@ -528,6 +597,10 @@ void check_snapshots(e2fsck_t ctx)
 		/* no snapshots */
 		return;
 
+	if (!check_snapshot_list(ctx))
+		/* no valid snapshots on list */
+		return;
+
 	if (!sb->s_snapshot_inum)
 		/* no active snapshot */
 		return;
-- 
1.6.6

