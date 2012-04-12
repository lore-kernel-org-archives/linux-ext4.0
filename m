From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] e2fsck: quiet harmless inode/blocks errors
Date: Thu, 12 Apr 2012 15:53:57 -0600
Message-ID: <1334267637-25977-1-git-send-email-adilger@whamcloud.com>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:15464 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934815Ab2DLVx7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Apr 2012 17:53:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't consider only an error in the superblock summary as incorrect.
The kernel does not update this field except at unmount time, so
don't print errors during a "-n" run if there is nothing else wrong.
Any other unfixed errors will themselves mark the filesystem invalid.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 e2fsck/pass5.c   |    6 ++----
 e2fsck/problem.c |    4 ++--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 8ebddf8..8312fe0 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -471,8 +471,7 @@ redo_counts:
 		if (fix_problem(ctx, PR_5_FREE_BLOCK_COUNT, &pctx)) {
 			ext2fs_free_blocks_count_set(fs->super, free_blocks);
 			ext2fs_mark_super_dirty(fs);
-		} else
-			ext2fs_unmark_valid(fs);
+		}
 	}
 errout:
 	ext2fs_free_mem(&free_array);
@@ -746,8 +745,7 @@ do_counts:
 		if (fix_problem(ctx, PR_5_FREE_INODE_COUNT, &pctx)) {
 			fs->super->s_free_inodes_count = free_inodes;
 			ext2fs_mark_super_dirty(fs);
-		} else
-			ext2fs_unmark_valid(fs);
+		}
 	}
 errout:
 	ext2fs_free_mem(&free_array);
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index d51a408..b60cf79 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1621,7 +1621,7 @@ static struct e2fsck_problem problem_table[] = {
 	/* Free inodes count wrong */
 	{ PR_5_FREE_INODE_COUNT,
 	  N_("Free @is count wrong (%i, counted=%j).\n"),
-	  PROMPT_FIX, PR_PREEN_OK | PR_PREEN_NOMSG },
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK | PR_PREEN_NOMSG },
 
 	/* Free blocks count for group wrong */
 	{ PR_5_FREE_BLOCK_COUNT_GROUP,
@@ -1631,7 +1631,7 @@ static struct e2fsck_problem problem_table[] = {
 	/* Free blocks count wrong */
 	{ PR_5_FREE_BLOCK_COUNT,
 	  N_("Free @bs count wrong (%b, counted=%c).\n"),
-	  PROMPT_FIX, PR_PREEN_OK | PR_PREEN_NOMSG },
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK | PR_PREEN_NOMSG },
 
 	/* Programming error: bitmap endpoints don't match */
 	{ PR_5_BMAP_ENDPOINTS,
-- 
1.7.3.4

