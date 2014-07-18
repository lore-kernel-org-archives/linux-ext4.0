From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/24] e2fsck: fix inode coherency issue when iterating an
 inode's blocks
Date: Fri, 18 Jul 2014 15:53:11 -0700
Message-ID: <20140718225311.31374.34009.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35524 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762695AbaGRWxS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:53:18 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're about to iterate the blocks of a block-map file, we need to
write the inode out to disk if it's dirty because block_iterate3()
will re-read the inode from disk.  (In practice this won't happen
because nothing dirties block-mapped inodes before the iterate call,
but we can program defensively).

More importantly, we need to re-read the inode after the iterate()
operation because it's possible that mappings were changed (or erased)
during the iteration.  If we then dirty or clear the inode, we'll
mistakenly write the old inode values back out to disk!

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 5c628a3..b696d02 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -80,7 +80,8 @@ static void adjust_extattr_refcount(e2fsck_t ctx, ext2_refcount_t refcount,
 struct process_block_struct {
 	ext2_ino_t	ino;
 	unsigned	is_dir:1, is_reg:1, clear:1, suppress:1,
-				fragmented:1, compressed:1, bbcheck:1;
+				fragmented:1, compressed:1, bbcheck:1,
+				inode_modified:1;
 	blk64_t		num_blocks;
 	blk64_t		max_blocks;
 	e2_blkcnt_t	last_block;
@@ -1968,8 +1969,10 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			pctx->num = extent.e_len;
 			problem = 0;
 			if (fix_problem(ctx, PR_1_EXTENT_ONLY_CSUM_INVALID,
-					pctx))
+					pctx)) {
+				pb->inode_modified = 1;
 				ext2fs_extent_replace(ehandle, 0, &extent);
+			}
 		}
 
 		if (problem) {
@@ -2001,6 +2004,7 @@ fix_problem_now:
 					continue;
 				}
 				e2fsck_read_bitmaps(ctx);
+				pb->inode_modified = 1;
 				pctx->errcode =
 					ext2fs_extent_delete(ehandle, 0);
 				if (pctx->errcode) {
@@ -2046,6 +2050,7 @@ fix_problem_now:
 				pctx->num = e_info.curr_level - 1;
 				problem = PR_1_EXTENT_INDEX_START_INVALID;
 				if (fix_problem(ctx, problem, pctx)) {
+					pb->inode_modified = 1;
 					pctx->errcode =
 						ext2fs_extent_fix_parents(ehandle);
 					if (pctx->errcode)
@@ -2243,6 +2248,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	pb.inode = inode;
 	pb.pctx = pctx;
 	pb.ctx = ctx;
+	pb.inode_modified = 0;
 	pctx->ino = ino;
 	pctx->errcode = 0;
 
@@ -2274,6 +2280,16 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL))
 			check_blocks_extents(ctx, pctx, &pb);
 		else {
+			/*
+			 * If we've modified the inode, write it out before
+			 * iterate() tries to use it.
+			 */
+			if (dirty_inode) {
+				e2fsck_write_inode(ctx, ino, inode,
+						   "check_blocks");
+				dirty_inode = 0;
+			}
+			fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 			pctx->errcode = ext2fs_block_iterate3(fs, ino,
 						pb.is_dir ? BLOCK_FLAG_HOLE : 0,
 						block_buf, process_block, &pb);
@@ -2282,6 +2298,16 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 			 * files.
 			 */
 			pb.last_init_lblock = pb.last_block;
+			/*
+			 * If iterate() changed a block mapping, we have to
+			 * re-read the inode.  If we decide to clear the
+			 * inode after clearing some stuff, we'll re-write the
+			 * bad mappings into the inode!
+			 */
+			if (pb.inode_modified)
+				e2fsck_read_inode(ctx, ino, inode,
+						  "check_blocks");
+			fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 		}
 	} else {
 		/* check inline data */
@@ -2581,6 +2607,7 @@ static int process_block(ext2_filsys fs,
 		if (fix_problem(ctx, problem, pctx)) {
 			blk = *block_nr = 0;
 			ret_code = BLOCK_CHANGED;
+			p->inode_modified = 1;
 			goto mark_dir;
 		} else
 			return 0;

