From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 09/12] e2fsprogs: Delete all snapshots on fsck -x
Date: Tue, 20 Jul 2010 18:16:10 +0300
Message-ID: <1279638973-14561-10-git-send-email-amir73il@users.sf.net>
References: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: tytso@mit.edu, andreas.dilger@oracle.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54962 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab0GTPRk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jul 2010 11:17:40 -0400
Received: by wwj40 with SMTP id 40so969294wwj.1
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jul 2010 08:17:38 -0700 (PDT)
In-Reply-To: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On fsck -x or if the 'fix_snapshot' flag is set, prompt to delete
all snapshot inodes and reset exclude bitmap.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 e2fsck/e2fsck.h  |    2 ++
 e2fsck/pass1.c   |    7 +++++++
 e2fsck/problem.c |    8 ++++++++
 e2fsck/problem.h |    3 +++
 e2fsck/super.c   |   24 ++++++++++++++++++++++++
 e2fsck/unix.c    |    8 ++++++--
 6 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index bc938e0..19a39fd 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -155,6 +155,7 @@ struct resource_track {
 #define E2F_OPT_WRITECHECK	0x0200
 #define E2F_OPT_COMPRESS_DIRS	0x0400
 #define E2F_OPT_FRAGCHECK	0x0800
+#define E2F_OPT_FIX_SNAPSHOT	0x1000
 
 /*
  * E2fsck flags
@@ -178,6 +179,7 @@ struct resource_track {
 #define E2F_FLAG_EXITING	0x1000 /* E2fsck exiting due to errors */
 #define E2F_FLAG_TIME_INSANE	0x2000 /* Time is insane */
 #define E2F_FLAG_EXCLUDE_INODE	0x4000 /* Request to recreate exclude inode */
+#define E2F_FLAG_CLEAR_SNAPSHOTS	0x8000 /* Clear all snapshot inodes */
 
 #define E2F_RESET_FLAGS (E2F_FLAG_TIME_INSANE)
 
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index d7d51c1..daecce6 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1931,6 +1931,13 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	pctx->ino = ino;
 	pctx->errcode = 0;
 
+	if (pb.snapfile && (ctx->flags & E2F_FLAG_CLEAR_SNAPSHOTS)) {
+		/* discarding all snapshot files */
+		e2fsck_clear_inode(ctx, ino, inode, E2F_FLAG_RESTART,
+				   "check_blocks");
+		return;
+	}
+
 	extent_fs = (ctx->fs->super->s_feature_incompat &
                      EXT3_FEATURE_INCOMPAT_EXTENTS);
 
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 0b6b892..647075b 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -41,6 +41,7 @@
 #define PROMPT_CLEAR_HTREE 18
 #define PROMPT_RECREATE 19
 #define PROMPT_TERMINATE_LIST 20
+#define PROMPT_DISCARD_SNAPSHOTS 21
 #define PROMPT_NULL	22
 
 /*
@@ -69,6 +70,7 @@ static const char *prompt[] = {
 	N_("Clear HTree index"),/* 18 */
 	N_("Recreate"),		/* 19 */
 	N_("Terminate list"),	/* 20 */
+	N_("Discard snapshots"),/* 21 */
 	"",			/* 22 */
 };
 
@@ -349,6 +351,12 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Bad @i found on snapshot list.  "),
 	  PROMPT_TERMINATE_LIST, PR_PREEN_OK },
 
+	/* Corrupted snapshot */
+	{ PR_0_FIX_SNAPSHOT,
+	  N_("@f may contain corrupted snapshots.\n"
+	     "This version of e2fsck does not support fixing snapshots.\n"),
+	  PROMPT_DISCARD_SNAPSHOTS, 0 },
+
 	/* Last mount time is in the future */
 	{ PR_0_FUTURE_SB_LAST_MOUNT,
 	  N_("@S last mount time (%t,\n\tnow = %T) is in the future.\n"),
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 1e63b52..43c3376 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -237,6 +237,9 @@ struct problem_context {
 /* Bas snapshot on list */
 #define PR_0_BAD_SNAPSHOT			0x000102
 
+/* Corrupted snapshot */
+#define PR_0_FIX_SNAPSHOT			0x000103
+
 
 /*
  * Pass 1 errors
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 8e24c18..8cc6584 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -597,6 +597,30 @@ void check_snapshots(e2fsck_t ctx)
 		/* no snapshots */
 		return;
 
+	if ((ctx->options & E2F_OPT_FIX_SNAPSHOT) ||
+			(sb->s_flags & EXT2_FLAGS_FIX_SNAPSHOT)) {
+		/* corrupted snapshot need to be fixed */
+		clear_problem_context(&pctx);
+		if (fix_problem(ctx, PR_0_FIX_SNAPSHOT, &pctx)) {
+			if ((sb->s_flags & EXT2_FLAGS_FIX_SNAPSHOT) ||
+				(sb->s_snapshot_list || sb->s_snapshot_inum)) {
+				/* reset snapshot list head */
+				sb->s_snapshot_list = sb->s_snapshot_inum = 0;
+				sb->s_flags &= ~EXT2_FLAGS_FIX_SNAPSHOT;
+				ext2fs_mark_super_dirty(ctx->fs);
+			}
+			/* don't ask again after pass1 */
+			ctx->options &= ~E2F_OPT_FIX_SNAPSHOT;
+			/* clear all snapshot inodes (in pass1) */
+			ctx->flags |= E2F_FLAG_CLEAR_SNAPSHOTS;
+			if (sb->s_feature_compat &
+					EXT2_FEATURE_COMPAT_EXCLUDE_INODE)
+				/* and reset exclude bitmap */
+				ctx->flags |= E2F_FLAG_EXCLUDE_INODE;
+			return;
+		}
+	}
+
 	if (!check_snapshot_list(ctx))
 		/* no valid snapshots on list */
 		return;
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 43b0197..ec00800 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -73,7 +73,7 @@ int journal_enable_debug = -1;
 static void usage(e2fsck_t ctx)
 {
 	fprintf(stderr,
-		_("Usage: %s [-panyrcdfvtDFV] [-b superblock] [-B blocksize]\n"
+		_("Usage: %s [-panyrcdfvtxDFV] [-b superblock] [-B blocksize]\n"
 		"\t\t[-I inode_buffer_blocks] [-P process_inode_size]\n"
 		"\t\t[-l|-L bad_blocks_file] [-C fd] [-j external_journal]\n"
 		"\t\t[-E extended-options] device\n"),
@@ -92,6 +92,7 @@ static void usage(e2fsck_t ctx)
 		" -j external_journal  Set location of the external journal\n"
 		" -l bad_blocks_file   Add to badblocks list\n"
 		" -L bad_blocks_file   Set badblocks list\n"
+		" -x                   Fix or discard snapshots\n"
 		));
 
 	exit(FSCK_USAGE);
@@ -667,7 +668,7 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 		ctx->program_name = *argv;
 	else
 		ctx->program_name = "e2fsck";
-	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDk")) != EOF)
+	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDkx")) != EOF)
 		switch (c) {
 		case 'C':
 			ctx->progress = e2fsck_update_progress;
@@ -790,6 +791,9 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 		case 'k':
 			keep_bad_blocks++;
 			break;
+		case 'x':
+			ctx->options |= E2F_OPT_FIX_SNAPSHOT;
+			break;
 		default:
 			usage(ctx);
 		}
-- 
1.6.6

