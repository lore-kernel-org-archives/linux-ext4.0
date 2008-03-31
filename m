From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH, E2FSPROGS] e2fsck: Add check to enforce a valid block bitmap in last block group
Date: Mon, 31 Mar 2008 19:36:30 -0400
Message-ID: <1207006592-13980-9-git-send-email-tytso@mit.edu>
References: <20080325084039.GA10804@webber.adilger.int>
 <1207006592-13980-1-git-send-email-tytso@mit.edu>
 <1207006592-13980-2-git-send-email-tytso@mit.edu>
 <1207006592-13980-3-git-send-email-tytso@mit.edu>
 <1207006592-13980-4-git-send-email-tytso@mit.edu>
 <1207006592-13980-5-git-send-email-tytso@mit.edu>
 <1207006592-13980-6-git-send-email-tytso@mit.edu>
 <1207006592-13980-7-git-send-email-tytso@mit.edu>
 <1207006592-13980-8-git-send-email-tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61458 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbYCaXjO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2008 19:39:14 -0400
In-Reply-To: <1207006592-13980-8-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andreas Dilger <adilger@dilger.ca>

Add a check for the UNINIT_BLOCKS flag set in the last group.  The kernel
patch doesn't handle this gracefully, because it assumes there are a full
set of blocks in each group marked UNINIT_BLOCKS.  The kernel should be
fixed up, but in the meantime this avoids hitting the problem, and is
more consistent with lazy_bg not marking the last group UNINIT.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/problem.c |    5 +++++
 e2fsck/problem.h |    3 +++
 e2fsck/super.c   |   25 +++++++++++++++++++++++--
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index b6a3a81..828be88 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -371,6 +371,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@g descriptor %g has invalid unused inodes count %b.  "),
 	     PROMPT_FIX, PR_PREEN_OK },
 
+	/* Last group block bitmap uninitialized. */
+	{ PR_0_BB_UNINIT_LAST,
+	  N_("Last @g @b @B uninitialized.  "),
+	     PROMPT_FIX, PR_PREEN_OK },
+
 	/* Pass 1 errors */
 
 	/* Pass 1: Checking inodes, blocks, and sizes */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index a2bd2b5..7993203 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -208,6 +208,9 @@ struct problem_context {
 /* Group descriptor N has invalid unused inodes count. */
 #define PR_0_GDT_ITABLE_UNUSED			0x000038
 
+/* Last group block bitmap is uninitialized. */
+#define PR_0_BB_UNINIT_LAST			0x000039
+
 /*
  * Pass 1 errors
  */
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 6753a14..87a0d78 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -631,11 +631,13 @@ void check_super_block(e2fsck_t ctx)
 		    (gd->bg_used_dirs_count > sb->s_inodes_per_group))
 			ext2fs_unmark_valid(fs);
 
+		should_be = 0;
 		if (!ext2fs_group_desc_csum_verify(fs, i)) {
 			if (fix_problem(ctx, PR_0_GDT_CSUM, &pctx)) {
 				gd->bg_flags &=	~(EXT2_BG_BLOCK_UNINIT |
 				                  EXT2_BG_INODE_UNINIT);
 				gd->bg_itable_unused = 0;
+				should_be = 1;
 			}
 			ext2fs_unmark_valid(fs);
 		}
@@ -647,23 +649,42 @@ void check_super_block(e2fsck_t ctx)
 				gd->bg_flags &= ~(EXT2_BG_BLOCK_UNINIT |
 						  EXT2_BG_INODE_UNINIT);
 				gd->bg_itable_unused = 0;
+				should_be = 1;
 			}
 			ext2fs_unmark_valid(fs);
 		}
+
+		if (i == fs->group_desc_count - 1 &&
+		    gd->bg_flags & EXT2_BG_BLOCK_UNINIT) {
+			if (fix_problem(ctx, PR_0_BB_UNINIT_LAST, &pctx)) {
+				gd->bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
+				should_be = 1;
+			}
+			ext2fs_unmark_valid(fs);
+		}
+
 		if (gd->bg_flags & EXT2_BG_BLOCK_UNINIT &&
 		    !(gd->bg_flags & EXT2_BG_INODE_UNINIT)) {
-			if (fix_problem(ctx, PR_0_BB_UNINIT_IB_INIT, &pctx))
+			if (fix_problem(ctx, PR_0_BB_UNINIT_IB_INIT, &pctx)) {
 				gd->bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
+				should_be = 1;
+			}
 			ext2fs_unmark_valid(fs);
 		}
+
 		if (csum_flag &&
 		    (gd->bg_itable_unused > gd->bg_free_inodes_count ||
 		     gd->bg_itable_unused > sb->s_inodes_per_group)) {
 			pctx.blk = gd->bg_itable_unused;
-			if (fix_problem(ctx, PR_0_GDT_ITABLE_UNUSED, &pctx))
+			if (fix_problem(ctx, PR_0_GDT_ITABLE_UNUSED, &pctx)) {
 				gd->bg_itable_unused = 0;
+				should_be = 1;
+			}
 			ext2fs_unmark_valid(fs);
 		}
+
+		if (should_be)
+			ext2fs_group_desc_csum_set(fs, i);
 	}
 
 	/*
-- 
1.5.4.1.144.gdfee-dirty

