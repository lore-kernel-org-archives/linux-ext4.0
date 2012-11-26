From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/6 -v2] e2fsck: optimize pass1 for CPU time
Date: Mon, 26 Nov 2012 11:39:36 -0500
Message-ID: <1353947981-15219-3-git-send-email-tytso@mit.edu>
References: <1353947981-15219-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34886 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab2KZQjs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 11:39:48 -0500
In-Reply-To: <1353947981-15219-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Optimize e2fsck pass 1 by marking entire extents as being in use at a
time, instead of block by block.  This optimization only works for
non-bigalloc file systems for now (it's tricky to handle bigalloc file
systems since this code is also responsible for dealing with blocks
that are not correctly aligned within a cluster).  When the
optimization works, the CPU savings can be significant: ove a full CPU
minute for a mostly full 4T disk.

Addresses-Google-Bug: #7534813

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
---
 e2fsck/pass1.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 78fbe8d..cc00e0f 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1432,6 +1432,16 @@ static _INLINE_ void mark_block_used(e2fsck_t ctx, blk64_t block)
 	}
 }
 
+static _INLINE_ void mark_blocks_used(e2fsck_t ctx, blk64_t block,
+				      unsigned int num)
+{
+	if (ext2fs_test_block_bitmap_range2(ctx->block_found_map, block, num))
+		ext2fs_mark_block_bitmap_range2(ctx->block_found_map, block, num);
+	else
+		while (num--)
+			mark_block_used(ctx, block++);
+}
+
 /*
  * Adjust the extended attribute block's reference counts at the end
  * of pass 1, either by subtracting out references for EA blocks that
@@ -1867,11 +1877,15 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 				goto failed_add_dir_block;
 			}
 		}
+		if (!ctx->fs->cluster_ratio_bits) {
+			mark_blocks_used(ctx, extent.e_pblk, extent.e_len);
+			pb->num_blocks += extent.e_len;
+		}
 		for (blk = extent.e_pblk, blockcnt = extent.e_lblk, i = 0;
 		     i < extent.e_len;
 		     blk++, blockcnt++, i++) {
-			if (!(ctx->fs->cluster_ratio_bits &&
-			      pb->previous_block &&
+			if (ctx->fs->cluster_ratio_bits &&
+			    !(pb->previous_block &&
 			      (EXT2FS_B2C(ctx->fs, blk) ==
 			       EXT2FS_B2C(ctx->fs, pb->previous_block)) &&
 			      (blk & EXT2FS_CLUSTER_MASK(ctx->fs)) ==
-- 
1.7.12.rc0.22.gcdd159b

