From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: allow the block bitmap to be uninit when the inode bitmap is in use
Date: Mon,  6 Feb 2012 14:55:15 -0500
Message-ID: <1328558115-19526-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34467 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab2BFTzQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Feb 2012 14:55:16 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Removing this check will allow us to eventually eliminate code from
the kernel which forcibly initialized the block bitmap when the inode
bitmap is first used.  This would eliminate a required journal credit
and extra disk write.

Addresses-Google-Bug: #5944440

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/problem.c |    5 -----
 e2fsck/problem.h |    4 ++--
 e2fsck/super.c   |    9 ---------
 3 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index f042b89..579c838 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -362,11 +362,6 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@g descriptor %g marked uninitialized without feature set.\n"),
 	     PROMPT_FIX, PR_PREEN_OK },
 
-	/* group N block bitmap uninitialized but inode bitmap in use. */
-	{ PR_0_BB_UNINIT_IB_INIT,
-	  N_("@g %g @b @B uninitialized but @i @B in use.\n"),
-	     PROMPT_FIX, PR_PREEN_OK },
-
 	/* Group descriptor N has invalid unused inodes count. */
 	{ PR_0_GDT_ITABLE_UNUSED,
 	  N_("@g descriptor %g has invalid unused inodes count %b.  "),
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 9db29d8..3fabc90 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -203,8 +203,8 @@ struct problem_context {
 /* Group descriptor N marked uninitialized without feature set. */
 #define PR_0_GDT_UNINIT				0x000036
 
-/* Block bitmap is not initialised and Inode bitmap is */
-#define PR_0_BB_UNINIT_IB_INIT			0x000037
+/* Block bitmap is not initialised and Inode bitmap is -- NO LONGER USED */
+/* #define PR_0_BB_UNINIT_IB_INIT			0x000037 */
 
 /* Group descriptor N has invalid unused inodes count. */
 #define PR_0_GDT_ITABLE_UNUSED			0x000038
diff --git a/e2fsck/super.c b/e2fsck/super.c
index afec4b4..3397d77 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -666,15 +666,6 @@ void check_super_block(e2fsck_t ctx)
 			ext2fs_unmark_valid(fs);
 		}
 
-		if (ext2fs_bg_flags_test(fs, i, EXT2_BG_BLOCK_UNINIT) &&
-		    !ext2fs_bg_flags_test(fs, i, EXT2_BG_INODE_UNINIT)) {
-			if (fix_problem(ctx, PR_0_BB_UNINIT_IB_INIT, &pctx)) {
-				ext2fs_bg_flags_clear(fs, i, EXT2_BG_BLOCK_UNINIT);
-				should_be = 1;
-			}
-			ext2fs_unmark_valid(fs);
-		}
