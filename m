From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/1] only check PR_1_EXTENT_ENDS_BEYOND for leaf nodes
Date: Tue,  1 Apr 2008 20:38:58 -0500
Message-ID: <1207100338-2308-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759030AbYDKSS2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2008 14:18:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

pass1 was checking that an "extent's" start+len did not extend
past the last filesystem block, but unless we are at a leaf
block, the physical block is that of a node in the tree, and
the length may include sparseness.  The test is only valid
for leaf blocks.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 e2fsck/pass1.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 67a8370..4f21c3f 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1593,7 +1593,8 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 		if (extent.e_pblk < ctx->fs->super->s_first_data_block ||
 		    extent.e_pblk >= ctx->fs->super->s_blocks_count)
 			problem = PR_1_EXTENT_BAD_START_BLK;
-		else if ((extent.e_pblk + extent.e_len) >
+		else if (is_leaf &&
+			 (extent.e_pblk + extent.e_len) >
 			 ctx->fs->super->s_blocks_count)
 			problem = PR_1_EXTENT_ENDS_BEYOND;
 
-- 
1.5.4.1

