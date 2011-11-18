From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 4/5 bigalloc] e2fsck: support cluster unit of ee_block and ee_len
Date: Fri, 18 Nov 2011 18:55:29 +0800
Message-ID: <1321613730-10600-5-git-send-email-hao.bigrat@gmail.com>
References: <1321613730-10600-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33147 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab1KRKzv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Nov 2011 05:55:51 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so3440789iag.19
        for <linux-ext4@vger.kernel.org>; Fri, 18 Nov 2011 02:55:51 -0800 (PST)
In-Reply-To: <1321613730-10600-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 e2fsck/pass1.c |   63 +++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 532e132..70d26df 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1741,6 +1741,8 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 {
 	struct ext2fs_extent	extent;
 	blk64_t			blk;
+	blk64_t			elblk;
+	__u32			elen;
 	e2_blkcnt_t		blockcnt;
 	unsigned int		i;
 	int			is_dir, is_leaf;
@@ -1753,6 +1755,8 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 
 	pctx->errcode = ext2fs_extent_get(ehandle, EXT2_EXTENT_FIRST_SIB,
 					  &extent);
+	elblk = extent.e_lblk << ctx->fs->cluster_ratio_bits;
+	elen = extent.e_len << ctx->fs->cluster_ratio_bits;
 	while (!pctx->errcode && info.num_entries-- > 0) {
 		is_leaf = extent.e_flags & EXT2_EXTENT_FLAGS_LEAF;
 		is_dir = LINUX_S_ISDIR(pctx->inode->i_mode);
@@ -1762,18 +1766,18 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 		    extent.e_pblk < ctx->fs->super->s_first_data_block ||
 		    extent.e_pblk >= ext2fs_blocks_count(ctx->fs->super))
 			problem = PR_1_EXTENT_BAD_START_BLK;
-		else if (extent.e_lblk < start_block)
+		else if (elblk < start_block)
 			problem = PR_1_OUT_OF_ORDER_EXTENTS;
 		else if (is_leaf &&
-			 (extent.e_pblk + extent.e_len) >
+			 (extent.e_pblk + elen) >
 			 ext2fs_blocks_count(ctx->fs->super))
 			problem = PR_1_EXTENT_ENDS_BEYOND;
 
 		if (problem) {
 		report_problem:
 			pctx->blk = extent.e_pblk;
-			pctx->blk2 = extent.e_lblk;
-			pctx->num = extent.e_len;
+			pctx->blk2 = elblk;
+			pctx->num = elen;
 			if (fix_problem(ctx, problem, pctx)) {
 				e2fsck_read_bitmaps(ctx);
 				pctx->errcode =
@@ -1785,6 +1789,10 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 				pctx->errcode = ext2fs_extent_get(ehandle,
 								  EXT2_EXTENT_CURRENT,
 								  &extent);
+				elblk = extent.e_lblk <<
+					ctx->fs->cluster_ratio_bits;
+				elen = extent.e_len <<
+					ctx->fs->cluster_ratio_bits;
 				if (pctx->errcode == EXT2_ET_NO_CURRENT_NODE) {
 					pctx->errcode = 0;
 					break;
@@ -1805,11 +1813,13 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 					goto report_problem;
 				return;
 			}
-			scan_extent_node(ctx, pctx, pb, extent.e_lblk, ehandle);
+			scan_extent_node(ctx, pctx, pb, elblk, ehandle);
 			if (pctx->errcode)
 				return;
 			pctx->errcode = ext2fs_extent_get(ehandle,
 						  EXT2_EXTENT_UP, &extent);
+			elblk = extent.e_lblk << ctx->fs->cluster_ratio_bits;
+			elen = extent.e_len << ctx->fs->cluster_ratio_bits;
 			if (pctx->errcode) {
 				pctx->str = "EXT2_EXTENT_UP";
 				return;
@@ -1835,12 +1845,12 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 				       (unsigned long) pctx->ino, type,
 				       (unsigned long) pb->previous_block+1,
 				       (unsigned long) extent.e_pblk,
-				       (unsigned long) extent.e_lblk,
-				       (unsigned long) extent.e_len);
+				       (unsigned long) elblk,
+				       (unsigned long) elen);
 			}
 			pb->fragmented = 1;
 		}
-		while (is_dir && ++pb->last_db_block < extent.e_lblk) {
+		while (is_dir && ++pb->last_db_block < elblk) {
 			pctx->errcode = ext2fs_add_dir_block2(ctx->fs->dblist,
 							      pb->ino, 0,
 							      pb->last_db_block);
@@ -1850,8 +1860,7 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 				goto failed_add_dir_block;
 			}
 		}
-		for (blk = extent.e_pblk, blockcnt = extent.e_lblk, i = 0;
-		     i < extent.e_len;
+		for (blk = extent.e_pblk, blockcnt = elblk, i = 0; i < elen;
 		     blk++, blockcnt++, i++) {
 			if (!(ctx->fs->cluster_ratio_bits &&
 			      pb->previous_block &&
@@ -1865,7 +1874,8 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 
 			pb->previous_block = blk;
 
-			if (is_dir) {
+			if (is_dir && i < (pctx->inode->i_size /
+						ctx->fs->blocksize)) {
 				pctx->errcode = ext2fs_add_dir_block2(ctx->fs->dblist, pctx->ino, blk, blockcnt);
 				if (pctx->errcode) {
 					pctx->blk = blk;
@@ -1878,14 +1888,16 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 				}
 			}
 		}
-		if (is_dir && extent.e_len > 0)
+		if (is_dir && elen > 0)
 			pb->last_db_block = blockcnt - 1;
-		pb->previous_block = extent.e_pblk + extent.e_len - 1;
-		start_block = pb->last_block = extent.e_lblk + extent.e_len - 1;
+		pb->previous_block = extent.e_pblk + elen - 1;
+		start_block = pb->last_block = elblk + elen - 1;
 	next:
 		pctx->errcode = ext2fs_extent_get(ehandle,
 						  EXT2_EXTENT_NEXT_SIB,
 						  &extent);
+		elblk = extent.e_lblk << ctx->fs->cluster_ratio_bits;
+		elen = extent.e_len << ctx->fs->cluster_ratio_bits;
 	}
 	if (pctx->errcode == EXT2_ET_EXTENT_NO_NEXT)
 		pctx->errcode = 0;
@@ -1944,6 +1956,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	int		dirty_inode = 0;
 	int		extent_fs;
 	__u64		size;
+	__u32		last_cluster;
 
 	pb.ino = ino;
 	pb.num_blocks = 0;
@@ -2055,9 +2068,15 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		else if (nblock > (pb.last_block + 1))
 			bad_size = 1;
 		else if (nblock < (pb.last_block + 1)) {
-			if (((pb.last_block + 1) - nblock) >
-			    fs->super->s_prealloc_dir_blocks)
-				bad_size = 2;
+			if (fs->cluster_ratio_bits > 0) {
+				if ((EXT2FS_B2C(fs, pb.last_block) -
+						EXT2FS_B2C(fs, nblock)) > 1)
+					bad_size = 2;
+			} else {
+				if (((pb.last_block + 1) - nblock) >
+				    fs->super->s_prealloc_dir_blocks)
+					bad_size = 2;
+			}
 		}
 	} else {
 		e2_blkcnt_t blkpg = ctx->blocks_per_page;
@@ -2068,8 +2087,14 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		    (size < (__u64)pb.last_block * fs->blocksize) &&
 		    (pb.last_block / blkpg * blkpg != pb.last_block ||
 		     size < (__u64)(pb.last_block & ~(blkpg-1)) *fs->blocksize) &&
-		    !(inode->i_flags & EXT4_EOFBLOCKS_FL))
-			bad_size = 3;
+		    !(inode->i_flags & EXT4_EOFBLOCKS_FL)) {
+			last_cluster = EXT2FS_NUM_B2C(fs, (size + fs->blocksize
+						- 1) / fs->blocksize);
+			if (fs->cluster_ratio_bits <= 0 ||
+					last_cluster < ((pb.last_block + 1) >>
+						fs->cluster_ratio_bits))
+				bad_size = 3;
+		}
 		else if (!(extent_fs && (inode->i_flags & EXT4_EXTENTS_FL)) &&
 			 size > ext2_max_sizes[fs->super->s_log_block_size])
 			/* too big for a direct/indirect-mapped file */
-- 
1.7.3.2

