From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/21] e2fsck: convert 'delete files' warning to a proper
 fix_problem error
Date: Mon, 04 Aug 2014 18:05:10 -0700
Message-ID: <20140805010510.2611.45729.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44140 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbaHEBFQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:05:16 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In pass 3, convert the "delete files and re-run e2fsck" message to a
proper error code for more consistent error reporting and to make
translation easier.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass3.c                    |    4 ++--
 e2fsck/problem.c                  |    5 +++++
 e2fsck/problem.h                  |    3 +++
 tests/f_nospc_create_lnf/expect.1 |    3 ++-
 tests/f_nospc_create_lnf/expect.2 |    3 ++-
 5 files changed, 14 insertions(+), 4 deletions(-)


diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 0b02961..63b1d70 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -452,7 +452,7 @@ unlink:
 	retval = ext2fs_new_block2(fs, 0, ctx->block_found_map, &blk);
 	if (retval == EXT2_ET_BLOCK_ALLOC_FAIL &&
 	    fix_problem(ctx, PR_3_LPF_NO_SPACE, &pctx)) {
-		printf("Delete some files and re-run e2fsck.\n\n");
+		fix_problem(ctx, PR_3_NO_SPACE_TO_RECOVER, &pctx);
 		ctx->lost_and_found = EXT2_ROOT_INO;
 		return 0;
 	}
@@ -472,7 +472,7 @@ skip_new_block:
 				  ctx->inode_used_map, &ino);
 	if (retval == EXT2_ET_INODE_ALLOC_FAIL &&
 	    fix_problem(ctx, PR_3_LPF_NO_SPACE, &pctx)) {
-		printf("Delete some files and re-run e2fsck.\n\n");
+		fix_problem(ctx, PR_3_NO_SPACE_TO_RECOVER, &pctx);
 		ctx->lost_and_found = EXT2_ROOT_INO;
 		return 0;
 	}
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 452137a..2d29c35 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1619,6 +1619,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Cannot allocate space for /@l.\nPlace lost files in root directory instead"),
 	  PROMPT_NULL, 0 },
 
+	/* Delete some files and re-run e2fsck. */
+	{ PR_3_NO_SPACE_TO_RECOVER,
+	  N_("Insufficient space to recover lost files!\nMove data off the @f and re-run e2fsck.\n\n"),
+	  PROMPT_NONE, 0 },
+
 	/* Pass 3A Directory Optimization	*/
 
 	/* Pass 3A: Optimizing directories */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 72cfc4d..89146ec 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -967,6 +967,9 @@ struct problem_context {
 /* Cannot allocate lost+found */
 #define PR_3_LPF_NO_SPACE		0x030019
 
+/* Insufficient space to recover lost files */
+#define PR_3_NO_SPACE_TO_RECOVER	0x03001A
+
 /*
  * Pass 3a --- rehashing diretories
  */
diff --git a/tests/f_nospc_create_lnf/expect.1 b/tests/f_nospc_create_lnf/expect.1
index fc20628..986fe12 100644
--- a/tests/f_nospc_create_lnf/expect.1
+++ b/tests/f_nospc_create_lnf/expect.1
@@ -6,7 +6,8 @@ Pass 3: Checking directory connectivity
 Cannot allocate space for /lost+found.
 Place lost files in root directory instead? yes
 
-Delete some files and re-run e2fsck.
+Insufficient space to recover lost files!
+Move data off the filesystem and re-run e2fsck.
 
 Pass 3A: Optimizing directories
 Pass 4: Checking reference counts
diff --git a/tests/f_nospc_create_lnf/expect.2 b/tests/f_nospc_create_lnf/expect.2
index 5a44649..e9757f8 100644
--- a/tests/f_nospc_create_lnf/expect.2
+++ b/tests/f_nospc_create_lnf/expect.2
@@ -6,7 +6,8 @@ Pass 3: Checking directory connectivity
 Cannot allocate space for /lost+found.
 Place lost files in root directory instead? yes
 
-Delete some files and re-run e2fsck.
+Insufficient space to recover lost files!
+Move data off the filesystem and re-run e2fsck.
 
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information

