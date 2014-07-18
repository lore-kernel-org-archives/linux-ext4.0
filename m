From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/24] e2fsck: force all block allocations to use
 block_found_map
Date: Fri, 18 Jul 2014 15:53:41 -0700
Message-ID: <20140718225341.31374.29415.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33154 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945991AbaGRWxr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:53:47 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

During the later passes of efsck, we sometimes need to allocate and
map blocks into a file.  This can happen either by fsck directly
calling new_block() or indirectly by the library calling new_block
because it needs to allocate a block for lower level metadata (bmap2()
with BMAP_SET; block_iterate3() with BLOCK_CHANGED).

We need to force new_block to allocate blocks from the found block
map, because the FS block map could be inaccurate for various reasons:
the map is wrong, there are missing blocks, the checksum failed, etc.

Therefore, any time fsck does something that could to allocate blocks,
we need to intercept allocation requests so that they're sourced from
the found block map.  Remove the previous code that swapped bitmap
pointers as this is now unneeded.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/e2fsck.h |    1 +
 e2fsck/pass1.c  |   18 ++++++++----------
 e2fsck/pass1b.c |    1 -
 e2fsck/pass2.c  |    3 ---
 e2fsck/pass3.c  |   37 -------------------------------------
 e2fsck/rehash.c |    2 --
 6 files changed, 9 insertions(+), 53 deletions(-)


diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 53f10b1..d6d0ba9 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -473,6 +473,7 @@ extern int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
 extern void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino,
 			       struct ext2_inode *inode, int restart_flag,
 			       const char *source);
+extern void e2fsck_intercept_block_allocations(e2fsck_t ctx);
 
 /* pass2.c */
 extern int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 37b05ff..5ad7fe5 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -764,6 +764,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 						    "block interate buffer");
 	if (EXT2_INODE_SIZE(fs->super) == EXT2_GOOD_OLD_INODE_SIZE)
 		e2fsck_use_inode_shortcuts(ctx, 1);
+	e2fsck_intercept_block_allocations(ctx);
 	old_op = ehandler_operation(_("opening inode scan"));
 	pctx.errcode = ext2fs_open_inode_scan(fs, ctx->inode_buffer_blocks,
 					      &scan);
@@ -1306,10 +1307,6 @@ void e2fsck_pass1(e2fsck_t ctx)
 	}
 
 	if (ctx->flags & E2F_FLAG_RESIZE_INODE) {
-		ext2fs_block_bitmap save_bmap;
-
-		save_bmap = fs->block_map;
-		fs->block_map = ctx->block_found_map;
 		clear_problem_context(&pctx);
 		pctx.errcode = ext2fs_create_resize_inode(fs);
 		if (pctx.errcode) {
@@ -1327,7 +1324,6 @@ void e2fsck_pass1(e2fsck_t ctx)
 			e2fsck_write_inode(ctx, EXT2_RESIZE_INO, inode,
 					   "recreate inode");
 		}
-		fs->block_map = save_bmap;
 		ctx->flags &= ~E2F_FLAG_RESIZE_INODE;
 	}
 
@@ -3206,11 +3202,6 @@ void e2fsck_use_inode_shortcuts(e2fsck_t ctx, int use_shortcuts)
 		fs->read_inode = pass1_read_inode;
 		fs->write_inode = pass1_write_inode;
 		ctx->stashed_ino = 0;
-		ext2fs_set_alloc_block_callback(fs, e2fsck_get_alloc_block,
-						0);
-		ext2fs_set_block_alloc_stats_callback(fs,
-						      e2fsck_block_alloc_stats,
-						      0);
 	} else {
 		fs->get_blocks = 0;
 		fs->check_directory = 0;
@@ -3218,3 +3209,10 @@ void e2fsck_use_inode_shortcuts(e2fsck_t ctx, int use_shortcuts)
 		fs->write_inode = 0;
 	}
 }
+
+void e2fsck_intercept_block_allocations(e2fsck_t ctx)
+{
+	ext2fs_set_alloc_block_callback(ctx->fs, e2fsck_get_alloc_block, 0);
+	ext2fs_set_block_alloc_stats_callback(ctx->fs,
+						e2fsck_block_alloc_stats, 0);
+}
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index c2a3cf3..8d42d10 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -630,7 +630,6 @@ static int delete_file_block(ext2_filsys fs,
 			    _("internal error: can't find dup_blk for %llu\n"),
 				*block_nr);
 	} else {
-		ext2fs_unmark_block_bitmap2(ctx->block_found_map, *block_nr);
 		ext2fs_block_alloc_stats2(fs, *block_nr, -1);
 		pb->dup_blocks++;
 	}
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 5488c73..0ef9637 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1336,7 +1336,6 @@ static int deallocate_inode_block(ext2_filsys fs,
 	if ((*block_nr < fs->super->s_first_data_block) ||
 	    (*block_nr >= ext2fs_blocks_count(fs->super)))
 		return 0;
-	ext2fs_unmark_block_bitmap2(p->ctx->block_found_map, *block_nr);
 	ext2fs_block_alloc_stats2(fs, *block_nr, -1);
 	p->num++;
 	return 0;
@@ -1379,8 +1378,6 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 			return;
 		}
 		if (count == 0) {
-			ext2fs_unmark_block_bitmap2(ctx->block_found_map,
-					ext2fs_file_acl_block(fs, &inode));
 			ext2fs_block_alloc_stats2(fs,
 				  ext2fs_file_acl_block(fs, &inode), -1);
 		}
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 6f7f855..4fc390a 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -779,27 +779,6 @@ static int expand_dir_proc(ext2_filsys fs,
 		return BLOCK_CHANGED;
 }
 
-/*
- * Ensure that all blocks are marked in the block_found_map, since it's
- * possible that the library allocated an extent node block or a block map
- * block during the directory rebuilding; these new allocations are not
- * captured in block_found_map.  This is bad since we could later use
- * block_found_map to allocate more blocks.
- */
-static int find_new_blocks_proc(ext2_filsys fs,
-				blk64_t	*blocknr,
-				e2_blkcnt_t	blockcnt,
-				blk64_t ref_block EXT2FS_ATTR((unused)),
-				int ref_offset EXT2FS_ATTR((unused)),
-				void	*priv_data)
-{
-	struct expand_dir_struct *es = (struct expand_dir_struct *) priv_data;
-	e2fsck_t	ctx = es->ctx;
-
-	ext2fs_mark_block_bitmap2(ctx->block_found_map, *blocknr);
-	return 0;
-}
-
 errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
 				  int num, int guaranteed_size)
 {
@@ -830,27 +809,11 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
 	es.ctx = ctx;
 	es.dir = dir;
 
-	before = ext2fs_free_blocks_count(fs->super);
 	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_APPEND,
 				       0, expand_dir_proc, &es);
 
 	if (es.err)
 		return es.err;
-	after = ext2fs_free_blocks_count(fs->super);
-
-	/*
-	 * If the free block count has dropped by more than the blocks we
-	 * allocated ourselves, then we must've allocated some extent/map
-	 * blocks.  Therefore, we must iterate this dir's blocks again to
-	 * ensure that all newly allocated blocks are captured in
-	 * block_found_map.
-	 */
-	if ((before - after) > es.newblocks) {
-		retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_READ_ONLY,
-					       0, find_new_blocks_proc, &es);
-		if (es.err)
-			return es.err;
-	}
 
 	/*
 	 * Update the size and block count fields in the inode.
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 3b05715..f75479a 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -725,8 +725,6 @@ static int write_dir_block(ext2_filsys fs,
 		 * once.
 		 */
 		if (blk % EXT2FS_CLUSTER_RATIO(fs) == 0) {
-			ext2fs_unmark_block_bitmap2(wd->ctx->block_found_map,
-						    blk);
 			ext2fs_block_alloc_stats2(fs, blk, -1);
 			wd->cleared++;
 		}

