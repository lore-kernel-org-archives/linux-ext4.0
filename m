From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/5] e2fsck: Fix block allocation for holes in extent-mapped directories
Date: Sun, 29 Nov 2009 15:33:27 -0500
Message-ID: <1259526809-23697-3-git-send-email-tytso@mit.edu>
References: <1259526809-23697-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35137 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbZK2UeG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Nov 2009 15:34:06 -0500
In-Reply-To: <1259526809-23697-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In pass 2, when allocating new blocks for holes in directories, use
ext2fs_set_bmap() instead of ext2fs_block_iterate2() with a helper
function so that the newly allocated directory blocks are correctly
assigned in extent-mapped directories.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass2.c |   30 ++----------------------------
 1 files changed, 2 insertions(+), 28 deletions(-)

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 889e39d..761c2f1 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -66,12 +66,6 @@ static int check_dir_block(ext2_filsys fs,
 static int allocate_dir_block(e2fsck_t ctx,
 			      struct ext2_db_entry *dir_blocks_info,
 			      char *buf, struct problem_context *pctx);
-static int update_dir_block(ext2_filsys fs,
-			    blk_t	*block_nr,
-			    e2_blkcnt_t blockcnt,
-			    blk_t	ref_block,
-			    int		ref_offset,
-			    void	*priv_data);
 static void clear_htree(e2fsck_t ctx, ext2_ino_t ino);
 static int htree_depth(struct dx_dir_info *dx_dir,
 		       struct dx_dirblock_info *dx_db);
@@ -1463,8 +1457,8 @@ static int allocate_dir_block(e2fsck_t ctx,
 	 * Finally, update the block pointers for the inode
 	 */
 	db->blk = blk;
-	pctx->errcode = ext2fs_block_iterate2(fs, db->ino, BLOCK_FLAG_HOLE,
-				      0, update_dir_block, db);
+	pctx->errcode = ext2fs_bmap(fs, db->ino, &inode, 0, BMAP_SET,
+				    db->blockcnt, &blk);
 	if (pctx->errcode) {
 		pctx->str = "ext2fs_block_iterate";
 		fix_problem(ctx, PR_2_ALLOC_DIRBOCK, pctx);
@@ -1473,23 +1467,3 @@ static int allocate_dir_block(e2fsck_t ctx,
 
 	return 0;
 }
-
-/*
- * This is a helper function for allocate_dir_block().
- */
-static int update_dir_block(ext2_filsys fs EXT2FS_ATTR((unused)),
-			    blk_t	*block_nr,
-			    e2_blkcnt_t blockcnt,
-			    blk_t ref_block EXT2FS_ATTR((unused)),
-			    int ref_offset EXT2FS_ATTR((unused)),
-			    void *priv_data)
-{
-	struct ext2_db_entry *db;
