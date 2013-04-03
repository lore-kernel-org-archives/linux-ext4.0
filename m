From: David Jeffery <djeffery@redhat.com>
Subject: [PATCH] e2fsck: detect invalid extents at the end of an extent-block
Date: Wed, 3 Apr 2013 15:08:41 -0400
Message-ID: <20130403190841.GA16276@fury.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761020Ab3DCTJq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Apr 2013 15:09:46 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r33J9k4C030983
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 3 Apr 2013 15:09:46 -0400
Received: from fury.redhat.com (vpn-54-242.rdu2.redhat.com [10.10.54.242])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r33J9ivY015456
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 3 Apr 2013 15:09:46 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2fsck does not detect extents which are outside their location in the
extent tree.  This can result in a bad extent at the end of an extent-block
not being detected.
    
>From a part of a dump_extents output:
    
 1/ 2  37/ 68 143960 - 146679 123826181               2720
 2/ 2   1/  2 143960 - 146679 123785816 - 123788535   2720
 2/ 2   2/  2 146680 - 147583 123788536 - 123789439    904 Uninit <-bad extent
 1/ 2  38/ 68 146680 - 149391 123826182               2712
 2/ 2   1/  2 146680 - 147583     18486 -     19389    904
 2/ 2   2/  2 147584 - 149391 123789440 - 123791247   1808
    
e2fsck does not detect this bad extent which both overlaps another, valid
extent, and is invalid by being beyond the end of the extent above it in
the tree.
    
This patch modifies e2fsck to detect this invalid extent and remove it.

Signed-off-by: David Jeffery <djeffery@redhat.com>
---
 e2fsck/pass1.c   |   13 +++++++++----
 e2fsck/problem.c |    6 ++++++
 e2fsck/problem.h |    1 +
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index a20b57b..198e9a0 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1848,7 +1848,7 @@ void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino,
 
 static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			     struct process_block_struct *pb,
-			     blk64_t start_block,
+			     blk64_t start_block, blk64_t end_block,
 			     ext2_extent_handle_t ehandle)
 {
 	struct ext2fs_extent	extent;
@@ -1891,6 +1891,9 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			problem = PR_1_EXTENT_BAD_START_BLK;
 		else if (extent.e_lblk < start_block)
 			problem = PR_1_OUT_OF_ORDER_EXTENTS;
+		else if (end_block &&
+			 (extent.e_lblk + extent.e_len) > end_block)
+			problem = PR_1_EXTENT_END_OUT_OF_BOUNDS;
 		else if (is_leaf && extent.e_len == 0)
 			problem = PR_1_EXTENT_LENGTH_ZERO;
 		else if (is_leaf &&
@@ -1937,10 +1940,11 @@ fix_problem_now:
 		}
 
 		if (!is_leaf) {
-			blk64_t lblk;
+			blk64_t lblk, lblk_end;
 
 			blk = extent.e_pblk;
 			lblk = extent.e_lblk;
+			lblk_end = extent.e_lblk + extent.e_len;
 			pctx->errcode = ext2fs_extent_get(ehandle,
 						  EXT2_EXTENT_DOWN, &extent);
 			if (pctx->errcode) {
@@ -1965,7 +1969,8 @@ fix_problem_now:
 				if (fix_problem(ctx, problem, pctx))
 					ext2fs_extent_fix_parents(ehandle);
 			}
-			scan_extent_node(ctx, pctx, pb, extent.e_lblk, ehandle);
+			scan_extent_node(ctx, pctx, pb, extent.e_lblk,
+					 lblk_end, ehandle);
 			if (pctx->errcode)
 				return;
 			pctx->errcode = ext2fs_extent_get(ehandle,
@@ -2084,7 +2089,7 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 		ctx->extent_depth_count[info.max_depth]++;
 	}
 
-	scan_extent_node(ctx, pctx, pb, 0, ehandle);
+	scan_extent_node(ctx, pctx, pb, 0, 0, ehandle);
 	if (pctx->errcode &&
 	    fix_problem(ctx, PR_1_EXTENT_ITERATE_FAILURE, pctx)) {
 		pb->num_blocks = 0;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 76bc1d5..b0a6e19 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1008,6 +1008,12 @@ static struct e2fsck_problem problem_table[] = {
 	     "Logical start %b does not match logical start %c at next level.  "),
 	  PROMPT_FIX, 0 },
 
+	/* Extent end is out of bounds for the tree */
+	{ PR_1_EXTENT_END_OUT_OF_BOUNDS,
+	  N_("@i %i, end of extent exceeds allowed value\n\t(logical @b %c, physical @b %b, len %N)\n"),
+	  PROMPT_CLEAR, 0 },
+
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index d2b6df4..fcdc1a1 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -589,6 +589,7 @@ struct problem_context {
 /* Index start doesn't match start of next extent down */
 #define PR_1_EXTENT_INDEX_START_INVALID	0x01006D
 
+#define PR_1_EXTENT_END_OUT_OF_BOUNDS	0x01006E
 /*
  * Pass 1b errors
  */
