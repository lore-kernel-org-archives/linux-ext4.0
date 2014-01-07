From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 01/10] e2fsck: release allocated memory on error or abort in e2fsck_pass1()
Date: Tue,  7 Jan 2014 09:53:05 -0500
Message-ID: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46593 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbaAGOxW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 09:53:22 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Addresses-Coverity-Id: #1148450

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass1.c | 50 ++++++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 71b3000..38b221c 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -546,9 +546,9 @@ void e2fsck_pass1(e2fsck_t ctx)
 	__u64	max_sizes;
 	ext2_filsys fs = ctx->fs;
 	ext2_ino_t	ino = 0;
-	struct ext2_inode *inode;
-	ext2_inode_scan	scan;
-	char		*block_buf;
+	struct ext2_inode *inode = NULL;
+	ext2_inode_scan	scan = NULL;
+	char		*block_buf = NULL;
 #ifdef RESOURCE_TRACK
 	struct resource_track	rtrack;
 #endif
@@ -662,8 +662,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	if (pctx.errcode) {
 		fix_problem(ctx, PR_1_ALLOCATE_DBCOUNT, &pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
-		ext2fs_free_mem(&inode);
-		return;
+		goto endit;
 	}
 
 	/*
@@ -686,8 +685,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	if (pctx.errcode) {
 		fix_problem(ctx, PR_1_CONVERT_SUBCLUSTER, &pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
-		ext2fs_free_mem(&inode);
-		return;
+		goto endit;
 	}
 	block_buf = (char *) e2fsck_allocate_memory(ctx, fs->blocksize * 3,
 						    "block interate buffer");
@@ -699,18 +697,16 @@ void e2fsck_pass1(e2fsck_t ctx)
 	if (pctx.errcode) {
 		fix_problem(ctx, PR_1_ISCAN_ERROR, &pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
-		ext2fs_free_mem(&block_buf);
-		ext2fs_free_mem(&inode);
-		return;
+		goto endit;
 	}
 	ext2fs_inode_scan_flags(scan, EXT2_SF_SKIP_MISSING_ITABLE, 0);
 	ctx->stashed_inode = inode;
 	scan_struct.ctx = ctx;
 	scan_struct.block_buf = block_buf;
 	ext2fs_set_inode_callback(scan, scan_callback, &scan_struct);
-	if (ctx->progress)
-		if ((ctx->progress)(ctx, 1, 0, ctx->fs->group_desc_count))
-			return;
+	if (ctx->progress && ((ctx->progress)(ctx, 1, 0,
+					      ctx->fs->group_desc_count)))
+		goto endit;
 	if ((fs->super->s_wtime < fs->super->s_inodes_count) ||
 	    (fs->super->s_mtime < fs->super->s_inodes_count))
 		busted_fs_time = 1;
@@ -742,7 +738,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 		if (pctx.errcode) {
 			fix_problem(ctx, PR_1_ISCAN_ERROR, &pctx);
 			ctx->flags |= E2F_FLAG_ABORT;
-			return;
+			goto endit;
 		}
 		if (!ino)
 			break;
@@ -756,7 +752,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 				pctx.num = inode->i_links_count;
 				fix_problem(ctx, PR_1_ICOUNT_STORE, &pctx);
 				ctx->flags |= E2F_FLAG_ABORT;
-				return;
+				goto endit;
 			}
 		}
 
@@ -846,7 +842,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 				pctx.num = 4;
 				fix_problem(ctx, PR_1_ALLOCATE_BBITMAP_ERROR, &pctx);
 				ctx->flags |= E2F_FLAG_ABORT;
-				return;
+				goto endit;
 			}
 			pb.ino = EXT2_BAD_INO;
 			pb.num_blocks = pb.last_block = 0;
@@ -863,12 +859,12 @@ void e2fsck_pass1(e2fsck_t ctx)
 			if (pctx.errcode) {
 				fix_problem(ctx, PR_1_BLOCK_ITERATE, &pctx);
 				ctx->flags |= E2F_FLAG_ABORT;
-				return;
+				goto endit;
 			}
 			if (pb.bbcheck)
 				if (!fix_problem(ctx, PR_1_BBINODE_BAD_METABLOCK_PROMPT, &pctx)) {
 				ctx->flags |= E2F_FLAG_ABORT;
-				return;
+				goto endit;
 			}
 			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
 			clear_problem_context(&pctx);
@@ -1146,17 +1142,18 @@ void e2fsck_pass1(e2fsck_t ctx)
 			check_blocks(ctx, &pctx, block_buf);
 
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
-			return;
+			goto endit;
 
 		if (process_inode_count >= ctx->process_inode_size) {
 			process_inodes(ctx, block_buf);
 
 			if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
-				return;
+				goto endit;
 		}
 	}
 	process_inodes(ctx, block_buf);
 	ext2fs_close_inode_scan(scan);
+	scan = NULL;
 
 	/*
 	 * If any extended attribute blocks' reference counts need to
@@ -1195,7 +1192,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 			if (!fix_problem(ctx, PR_1_RESIZE_INODE_CREATE,
 					 &pctx)) {
 				ctx->flags |= E2F_FLAG_ABORT;
-				return;
+				goto endit;
 			}
 			pctx.errcode = 0;
 		}
@@ -1233,10 +1230,15 @@ void e2fsck_pass1(e2fsck_t ctx)
 endit:
 	e2fsck_use_inode_shortcuts(ctx, 0);
 
-	ext2fs_free_mem(&block_buf);
-	ext2fs_free_mem(&inode);
+	if (scan)
+		ext2fs_close_inode_scan(scan);
+	if (block_buf)
+		ext2fs_free_mem(&block_buf);
+	if (inode)
+		ext2fs_free_mem(&inode);
 
-	print_resource_track(ctx, _("Pass 1"), &rtrack, ctx->fs->io);
+	if ((ctx->flags & E2F_FLAG_SIGNAL_MASK) == 0)
+		print_resource_track(ctx, _("Pass 1"), &rtrack, ctx->fs->io);
 }
 
 /*
-- 
1.8.5.rc3.362.gdf10213

