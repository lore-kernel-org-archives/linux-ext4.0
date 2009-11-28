From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] e2fsck: Fix directory with holes even when i_size is wrong
Date: Sat, 28 Nov 2009 10:30:31 -0500
Message-ID: <1259422233-14024-1-git-send-email-tytso@mit.edu>
References: <20091128152750.GD6763@thunk.org>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48021 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbZK1Pau (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Nov 2009 10:30:50 -0500
In-Reply-To: <20091128152750.GD6763@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The old method for detecting directories with holes depended on i_size
being correct, even though the correct value of i_size hadn't been
calculated yet.  Hence, a directory inode with holes and an i_size of
0 would require two e2fsck passes to fix completely.

The replacement method for determining whether or not
ext2fs_add_dir_block() should be called is more reliable, and reduces
the size of e2fsck and makes the code more readable as a bonus.

Thanks to Mikulas Patocka for providing a sample file system which
demonstrated this problem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass1.c |   61 ++++++++++++++-----------------------------------------
 1 files changed, 16 insertions(+), 45 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 2531e57..f87d3ed 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -83,6 +83,7 @@ struct process_block_struct {
 	blk_t		num_blocks;
 	blk_t		max_blocks;
 	e2_blkcnt_t	last_block;
+	e2_blkcnt_t	last_db_block;
 	int		num_illegal_blocks;
 	blk_t		previous_block;
 	struct ext2_inode *inode;
@@ -767,6 +768,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 			}
 			pb.ino = EXT2_BAD_INO;
 			pb.num_blocks = pb.last_block = 0;
+			pb.last_db_block = -1;
 			pb.num_illegal_blocks = 0;
 			pb.suppress = 0; pb.clear = 0; pb.is_dir = 0;
 			pb.is_reg = 0; pb.fragmented = 0; pb.bbcheck = 0;
@@ -1820,6 +1822,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	pb.ino = ino;
 	pb.num_blocks = 0;
 	pb.last_block = -1;
+	pb.last_db_block = -1;
 	pb.num_illegal_blocks = 0;
 	pb.suppress = 0; pb.clear = 0;
 	pb.fragmented = 0;
@@ -1883,26 +1886,6 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		return;
 	}
 
-	if (pb.is_dir) {
-		while (1) {
-			struct ext2_db_entry *entry;
-
-			if (ext2fs_dblist_get_last(fs->dblist, &entry) ||
-			    (entry->ino != ino) ||
-			    (entry->blk != 0) ||
-			    (entry->blockcnt == 0))
-				break;
-			/* printf("Dropping ino %lu blk %lu blockcnt %d\n",
-				  entry->ino, entry->blk, entry->blockcnt); */
-			ext2fs_dblist_drop_last(fs->dblist);
-			if (ext2fs_dblist_get_last(fs->dblist, &entry) ||
-			    (entry->ino != ino))
-				pb.last_block--;
-			else
-				pb.last_block = entry->blockcnt;
-		}
-	}
-
 	if (inode->i_flags & EXT2_INDEX_FL) {
 		if (handle_htree(ctx, pctx, ino, inode, block_buf)) {
 			inode->i_flags &= ~EXT2_INDEX_FL;
@@ -2094,31 +2077,8 @@ static int process_block(ext2_filsys fs,
 		return 0;
 	}
 
-	if (blk == 0) {
-		if (p->is_dir == 0) {
-			/*
-			 * Should never happen, since only directories
-			 * get called with BLOCK_FLAG_HOLE
-			 */
-#if DEBUG_E2FSCK
-			printf("process_block() called with blk == 0, "
-			       "blockcnt=%d, inode %lu???\n",
-			       blockcnt, p->ino);
-#endif
-			return 0;
-		}
-		if (blockcnt < 0)
-			return 0;
-		if (blockcnt * fs->blocksize < p->inode->i_size) {
-#if 0
-			printf("Missing block (#%d) in directory inode %lu!\n",
-			       blockcnt, p->ino);
-#endif
-			p->last_block = blockcnt;
-			goto mark_dir;
-		}
-		return 0;
-	}
+	if (blk == 0)
+		return;
 
 #if 0
 	printf("Process_block, inode %lu, block %u, #%d\n", p->ino, blk,
@@ -2203,11 +2163,22 @@ static int process_block(ext2_filsys fs,
 		p->last_block = blockcnt;
 mark_dir:
 	if (p->is_dir && (blockcnt >= 0)) {
+		while (++p->last_db_block < blockcnt) {
+			pctx->errcode = ext2fs_add_dir_block(fs->dblist,
+							     p->ino, 0,
+							     p->last_db_block);
+			if (pctx->errcode) {
+				pctx->blk = 0;
+				pctx->num = p->last_db_block;
+				goto failed_add_dir_block;
+			}
+		}
 		pctx->errcode = ext2fs_add_dir_block(fs->dblist, p->ino,
 						    blk, blockcnt);
 		if (pctx->errcode) {
 			pctx->blk = blk;
 			pctx->num = blockcnt;
+		failed_add_dir_block:
 			fix_problem(ctx, PR_1_ADD_DBLOCK, pctx);
 			/* Should never get here */
 			ctx->flags |= E2F_FLAG_ABORT;
-- 
1.6.5.216.g5288a.dirty

