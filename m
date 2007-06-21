From: Theodore Tso <tytso@MIT.EDU>
Subject: [PATCH 2 of 4] Recreate journal that had been removed previously due
	to corruption
Date: Thu, 21 Jun 2007 13:00:09 -0400
Message-ID: <8c5c3cc3fa06ab7791d1.1182445209@candygram.thunk.org>
References: <patchbomb.1182445207@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: kalpak@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55951 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037AbXFURBr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jun 2007 13:01:47 -0400
In-Reply-To: <patchbomb.1182445207@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

8 files changed, 69 insertions(+), 5 deletions(-)
e2fsck/journal.c              |    2 +-
e2fsck/problem.c              |    5 +++++
e2fsck/problem.h              |    7 +++++++
e2fsck/unix.c                 |   40 ++++++++++++++++++++++++++++++++++++++++
tests/f_badjourblks/expect.1  |    8 +++++++-
tests/f_badjourblks/expect.2  |    2 +-
tests/f_miss_journal/expect.1 |    8 +++++++-
tests/f_miss_journal/expect.2 |    2 +-


# HG changeset patch
# User tytso@mit.edu
# Date 1182441546 14400
# Node ID 8c5c3cc3fa06ab7791d1a55c3191a4e63a32c8a5
# Parent  5daddb24f35d514c4d21a7d79bd470439b74866e
Recreate journal that had been removed previously due to corruption

If the journal had been removed because it was corrupt, the
E2F_FLAG_JOURNAL_INODE flag will be set.  If this flag is set, then
recreate the filesystem after checking the filesystem.

Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

diff -r 5daddb24f35d -r 8c5c3cc3fa06 e2fsck/journal.c
--- a/e2fsck/journal.c	Thu Jun 21 11:59:06 2007 -0400
+++ b/e2fsck/journal.c	Thu Jun 21 11:59:06 2007 -0400
@@ -420,7 +420,7 @@ static errcode_t e2fsck_journal_fix_bad_
 				       "filesystem is now ext2 only ***\n\n");
 			sb->s_feature_compat &= ~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 			sb->s_journal_inum = 0;
-			ctx->flags |= E2F_FLAG_JOURNAL_INODE; /* FIXME: todo */
+			ctx->flags |= E2F_FLAG_JOURNAL_INODE;
 			e2fsck_clear_recover(ctx, 1);
 			return 0;
 		}
diff -r 5daddb24f35d -r 8c5c3cc3fa06 e2fsck/problem.c
--- a/e2fsck/problem.c	Thu Jun 21 11:59:06 2007 -0400
+++ b/e2fsck/problem.c	Thu Jun 21 11:59:06 2007 -0400
@@ -1493,6 +1493,11 @@ static struct e2fsck_problem problem_tab
 	{ PR_5_INODE_RANGE_USED,
 	  " +(%i--%j)",
 	  PROMPT_NONE, PR_LATCH_IBITMAP | PR_PREEN_OK | PR_PREEN_NOMSG },
+
+	/* Recreate journal if E2F_FLAG_JOURNAL_INODE flag is set */
+	{ PR_6_RECREATE_JOURNAL,
+	  N_("Recreate journal to make the filesystem ext3 again?\n"),
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
 
 	{ 0 }
 };
diff -r 5daddb24f35d -r 8c5c3cc3fa06 e2fsck/problem.h
--- a/e2fsck/problem.h	Thu Jun 21 11:59:06 2007 -0400
+++ b/e2fsck/problem.h	Thu Jun 21 11:59:06 2007 -0400
@@ -901,6 +901,13 @@ struct problem_context {
 #define PR_5_INODE_RANGE_USED		0x050017
 
 /*
+ * Post-Pass 5 errors
+ */
+
+/* Recreate the journal if E2F_FLAG_JOURNAL_INODE flag is set */
+#define PR_6_RECREATE_JOURNAL		0x060001
+
+/*
  * Function declarations
  */
 int fix_problem(e2fsck_t ctx, problem_t code, struct problem_context *pctx);
diff -r 5daddb24f35d -r 8c5c3cc3fa06 e2fsck/unix.c
--- a/e2fsck/unix.c	Thu Jun 21 11:59:06 2007 -0400
+++ b/e2fsck/unix.c	Thu Jun 21 11:59:06 2007 -0400
@@ -851,6 +851,7 @@ int main (int argc, char *argv[])
 	e2fsck_t	ctx;
 	struct problem_context pctx;
 	int flags, run_result;
+	int journal_size;
 	
 	clear_problem_context(&pctx);
 #ifdef MTRACE
@@ -1184,8 +1185,47 @@ restart:
 			 " but we'll try to go on...\n"));
 	}
 
+	/*
+	 * Save the journal size in megabytes.
+	 * Try and use the journal size from the backup else let e2fsck
+	 * find the default journal size.
+	 */
+	if (sb->s_jnl_backup_type == EXT3_JNL_BACKUP_BLOCKS)
+		journal_size = sb->s_jnl_blocks[16] >> 20;
+	else
+		journal_size = -1;
+
 	run_result = e2fsck_run(ctx);
 	e2fsck_clear_progbar(ctx);
+
+	if (ctx->flags & E2F_FLAG_JOURNAL_INODE) {
+		if (fix_problem(ctx, PR_6_RECREATE_JOURNAL, &pctx)) {
+			if (journal_size < 1024)
+				journal_size = ext2fs_default_journal_size(fs->super->s_blocks_count);
+			if (journal_size < 0) {
+				fs->super->s_feature_compat &=
+					~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
+				com_err(ctx->program_name, 0, 
+					_("Couldn't determine journal size"));
+				goto no_journal;
+			}
+			printf(_("Creating journal (%d blocks): "),
+			       journal_size);
+			fflush(stdout);
+			retval = ext2fs_add_journal_inode(fs,
+							  journal_size, 0);
+			if (retval) {
+				com_err("Error ", retval,
+					_("\n\twhile trying to create journal"));
+				goto no_journal;
+			}
+			printf(_(" Done.\n"));
+			printf(_("\n*** journal has been re-created - "
+				       "filesystem is now ext3 again ***\n"));
+		}
+	}
+no_journal:
+
 	if (run_result == E2F_FLAG_RESTART) {
 		printf(_("Restarting e2fsck from the beginning...\n"));
 		retval = e2fsck_reset_context(ctx);
diff -r 5daddb24f35d -r 8c5c3cc3fa06 tests/f_badjourblks/expect.1
--- a/tests/f_badjourblks/expect.1	Thu Jun 21 11:59:06 2007 -0400
+++ b/tests/f_badjourblks/expect.1	Thu Jun 21 11:59:06 2007 -0400
@@ -19,7 +19,13 @@ Free blocks count wrong (7112, counted=8
 Free blocks count wrong (7112, counted=8142).
 Fix? yes
 
+Recreate journal to make the filesystem ext3 again?
+Fix? yes
+
+Creating journal (1024 blocks):  Done.
+
+*** journal has been re-created - filesystem is now ext3 again ***
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/256 files (0.0% non-contiguous), 50/8192 blocks
+test_filesys: 11/256 files (0.0% non-contiguous), 1080/8192 blocks
 Exit status is 1
diff -r 5daddb24f35d -r 8c5c3cc3fa06 tests/f_badjourblks/expect.2
--- a/tests/f_badjourblks/expect.2	Thu Jun 21 11:59:06 2007 -0400
+++ b/tests/f_badjourblks/expect.2	Thu Jun 21 11:59:06 2007 -0400
@@ -3,5 +3,5 @@ Pass 3: Checking directory connectivity
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/256 files (0.0% non-contiguous), 50/8192 blocks
+test_filesys: 11/256 files (0.0% non-contiguous), 1080/8192 blocks
 Exit status is 0
diff -r 5daddb24f35d -r 8c5c3cc3fa06 tests/f_miss_journal/expect.1
--- a/tests/f_miss_journal/expect.1	Thu Jun 21 11:59:06 2007 -0400
+++ b/tests/f_miss_journal/expect.1	Thu Jun 21 11:59:06 2007 -0400
@@ -17,7 +17,13 @@ Free blocks count wrong (968, counted=19
 Free blocks count wrong (968, counted=1998).
 Fix? yes
 
+Recreate journal to make the filesystem ext3 again?
+Fix? yes
+
+Creating journal (1024 blocks):  Done.
+
+*** journal has been re-created - filesystem is now ext3 again ***
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/256 files (0.0% non-contiguous), 50/2048 blocks
+test_filesys: 11/256 files (0.0% non-contiguous), 1080/2048 blocks
 Exit status is 1
diff -r 5daddb24f35d -r 8c5c3cc3fa06 tests/f_miss_journal/expect.2
--- a/tests/f_miss_journal/expect.2	Thu Jun 21 11:59:06 2007 -0400
+++ b/tests/f_miss_journal/expect.2	Thu Jun 21 11:59:06 2007 -0400
@@ -3,5 +3,5 @@ Pass 3: Checking directory connectivity
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/256 files (0.0% non-contiguous), 50/2048 blocks
+test_filesys: 11/256 files (0.0% non-contiguous), 1080/2048 blocks
 Exit status is 0
