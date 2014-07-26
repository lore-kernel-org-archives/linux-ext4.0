From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/18] e2fsck: perform implied cluster allocations when
 filling a directory hole
Date: Fri, 25 Jul 2014 17:33:57 -0700
Message-ID: <20140726003357.28334.84385.stgit@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31751 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaGZAeC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 20:34:02 -0400
In-Reply-To: <20140726003339.28334.54447.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we're filling a directory hole, we need to perform an implied
cluster allocation to satisfy the bigalloc rule of mapping only one
pblk to a logical cluster.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass2.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 0ef9637..e2bed2f 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1577,7 +1577,7 @@ static int allocate_dir_block(e2fsck_t ctx,
 			      struct problem_context *pctx)
 {
 	ext2_filsys fs = ctx->fs;
-	blk64_t			blk;
+	blk64_t			blk = 0;
 	char			*block;
 	struct ext2_inode	inode;
 
@@ -1593,11 +1593,17 @@ static int allocate_dir_block(e2fsck_t ctx,
 	/*
 	 * First, find a free block
 	 */
-	pctx->errcode = ext2fs_new_block2(fs, 0, ctx->block_found_map, &blk);
-	if (pctx->errcode) {
-		pctx->str = "ext2fs_new_block";
-		fix_problem(ctx, PR_2_ALLOC_DIRBOCK, pctx);
-		return 1;
+	e2fsck_read_inode(ctx, db->ino, &inode, "allocate_dir_block");
+	pctx->errcode = ext2fs_map_cluster_block(fs, db->ino, &inode,
+						 db->blockcnt, &blk);
+	if (pctx->errcode || blk == 0) {
+		pctx->errcode = ext2fs_new_block2(fs, 0,
+						  ctx->block_found_map, &blk);
+		if (pctx->errcode) {
+			pctx->str = "ext2fs_new_block";
+			fix_problem(ctx, PR_2_ALLOC_DIRBOCK, pctx);
+			return 1;
+		}
 	}
 	ext2fs_mark_block_bitmap2(ctx->block_found_map, blk);
 	ext2fs_mark_block_bitmap2(fs->block_map, blk);
@@ -1629,7 +1635,6 @@ static int allocate_dir_block(e2fsck_t ctx,
 	/*
 	 * Update the inode block count
 	 */
-	e2fsck_read_inode(ctx, db->ino, &inode, "allocate_dir_block");
 	ext2fs_iblk_add_blocks(fs, &inode, 1);
 	if (inode.i_size < (db->blockcnt+1) * fs->blocksize)
 		inode.i_size = (db->blockcnt+1) * fs->blocksize;

