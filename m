From: Theodore Ts'o <tytso@mit.edu>
Subject: [E2FSPROGS PATCH 1/4] e2fsck: Handle a pass 2 "should never happen" error gracefully
Date: Thu, 13 Mar 2008 01:12:24 -0400
Message-ID: <1205385147-12855-1-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: bas@dev.tetra.nl
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:38333 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751246AbYCMFMi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 01:12:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Turns out a "should never happen" error can indeed happen very easily
if a directory with an htree index has an incorrect, and too-large,
i_size field.  This patch fixes this so that we handle this situation
gracefully, allowing filesystems with this error to be fixed.

In another patch I will clean up the specific problem which caused the
internal "should never happen" error from happening at all, but patch
will prevent e2fsck from crashing, and prompt the user to remove the
htree index, so it can be rebuilt again after pass 3.

Thanks to Bas van Schaik at Tetra for giving me access to his system
so this problem could be debugged.

Addresses-Launchpad-Bug: #129395

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass2.c   |   11 +++++++++--
 e2fsck/problem.c |    4 ++++
 e2fsck/problem.h |    3 +++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 6fb2ed7..b79461d 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -783,8 +783,14 @@ static int check_dir_block(ext2_filsys fs,
 	dx_dir = e2fsck_get_dx_dir_info(ctx, ino);
 	if (dx_dir && dx_dir->numblocks) {
 		if (db->blockcnt >= dx_dir->numblocks) {
-			printf("XXX should never happen!!!\n");
-			abort();
+			if (fix_problem(ctx, PR_2_UNEXPECTED_HTREE_BLOCK, 
+					&pctx)) {
+				clear_htree(ctx, ino);
+				dx_dir->numblocks = 0;
+				dx_db = 0;
+				goto out_htree;
+			}
+			fatal_error(ctx, _("Can not continue."));
 		}
 		dx_db = &dx_dir->dx_block[db->blockcnt];
 		dx_db->type = DX_DIRBLOCK_LEAF;
@@ -819,6 +825,7 @@ static int check_dir_block(ext2_filsys fs,
 			     sizeof(struct ext2_dx_entry))))
 			dx_db->type = DX_DIRBLOCK_NODE;
 	}
+out_htree:
 #endif /* ENABLE_HTREE */
 
 	dict_init(&de_dict, DICTCOUNT_T_MAX, dict_de_cmp);
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 7c3ebea..418d83b 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1188,6 +1188,10 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("i_blocks_hi @F %N, @s zero.\n"),
 	  PROMPT_CLEAR, 0 },
 
+	/* Unexpected HTREE block */
+	{ PR_2_UNEXPECTED_HTREE_BLOCK,
+	  N_("Unexpected @b in @h %d (%q).\n"), PROMPT_CLEAR_HTREE, 0 },
+		  
 	/* Pass 3 errors */
 
 	/* Pass 3: Checking directory connectivity */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index f5f7212..91a6148 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -708,6 +708,9 @@ struct problem_context {
 /* i_blocks_hi should be zero */
 #define PR_2_BLOCKS_HI_ZERO	0x020044
 
+/* Unexpected HTREE block */
+#define PR_2_UNEXPECTED_HTREE_BLOCK	0x020045
+
 /*
  * Pass 3 errors
  */
-- 
1.5.4.1.144.gdfee-dirty

