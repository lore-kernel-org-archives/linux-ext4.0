From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-39.diff>
Date: Fri, 9 Feb 2007 18:11:34 -0800
Message-ID: <200702100211.l1A2BYgu007402@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:20101 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbXBJCOq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Lawrence Livermore National Labs recently ran the source code
analysis tool Coverity over the e2fsprogs-1.39 source to see 
if it would identify any significant bugs.  The analysis
turned up 38 mostly minor issues which are enumerated here
with patches.  We went through and resolved these issues
but would love to see these mostly minor changes reviewed
and commited upstream.

Thanks,
Brian Behlendorf <behlendorf1@llnl.gov>, and
Herb Wartens <wartens2@llnl.gov>

-----------------------------------------------------------------------------
Coverity ID: 39: Resource Leak

Real memory leaks. The fix applied to our tree adds an errout: label at the
end where the memory is freed. The early returns have been replaced with
goto's which jump to the label. It's 'safe' to not check the return code of
e2fsck_allocate_memory because if the memory allocations fails it will
internally call exit().

The fix applied also contrain some writespace cleanup

Index: e2fsprogs+chaos/e2fsck/pass5.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/pass5.c
+++ e2fsprogs+chaos/e2fsck/pass5.c
@@ -107,7 +107,7 @@ static void print_bitmap_problem(e2fsck_
 	pctx->blk = pctx->blk2 = NO_BLK;
 	pctx->ino = pctx->ino2 = 0;
 }
-	
+
 static void check_block_bitmaps(e2fsck_t ctx)
 {
 	ext2_filsys fs = ctx->fs;
@@ -123,7 +123,7 @@ static void check_block_bitmaps(e2fsck_t
 	errcode_t	retval;
 	int		lazy_bg = 0;
 	int		skip_group = 0;
-	
+
 	clear_problem_context(&pctx);
 	free_array = (int *) e2fsck_allocate_memory(ctx,
 	    fs->group_desc_count * sizeof(int), "free block count array");
@@ -140,9 +140,9 @@ static void check_block_bitmaps(e2fsck_t
 		fix_problem(ctx, PR_5_BMAP_ENDPOINTS, &pctx);
 
 		ctx->flags |= E2F_FLAG_ABORT; /* fatal */
-		return;
+		goto errout;
 	}
-		       
+
 	if ((fs->super->s_first_data_block <
 	     ext2fs_get_block_bitmap_start(fs->block_map)) ||
 	    (fs->super->s_blocks_count-1 >
@@ -155,11 +155,10 @@ static void check_block_bitmaps(e2fsck_t
 		fix_problem(ctx, PR_5_BMAP_ENDPOINTS, &pctx);
 
 		ctx->flags |= E2F_FLAG_ABORT; /* fatal */
-		return;
+		goto errout;
 	}
-		       
-	if (EXT2_HAS_COMPAT_FEATURE(fs->super, 
-				    EXT2_FEATURE_COMPAT_LAZY_BG))
+
+	if (EXT2_HAS_COMPAT_FEATURE(fs->super, EXT2_FEATURE_COMPAT_LAZY_BG))
 		lazy_bg++;
 
 redo_counts:
@@ -193,7 +192,7 @@ redo_counts:
 			actual = (actual != 0);
 		} else
 			bitmap = ext2fs_fast_test_block_bitmap(fs->block_map, i);
-		
+
 		if (actual == bitmap)
 			goto do_counts;
 
@@ -223,7 +222,7 @@ redo_counts:
 		}
 		ctx->flags |= E2F_FLAG_PROG_SUPPRESS;
 		had_problem++;
-		
+
 	do_counts:
 		if (!bitmap && !skip_group) {
 			group_free++;
@@ -241,7 +240,7 @@ redo_counts:
 			if (ctx->progress)
 				if ((ctx->progress)(ctx, 5, group,
 						    fs->group_desc_count*2))
-					return;
+					goto errout;
 			if (lazy_bg &&
 			    (i != fs->super->s_blocks_count-1) &&
 			    (fs->group_desc[group].bg_flags &
@@ -256,7 +255,7 @@ redo_counts:
 	else
 		fixit = -1;
 	ctx->flags &= ~E2F_FLAG_PROG_SUPPRESS;
-	
+
 	if (fixit == 1) {
 		ext2fs_free_block_bitmap(fs->block_map);
 		retval = ext2fs_copy_bitmap(ctx->block_found_map,
@@ -265,11 +264,11 @@ redo_counts:
 			clear_problem_context(&pctx);
 			fix_problem(ctx, PR_5_COPY_BBITMAP_ERROR, &pctx);
 			ctx->flags |= E2F_FLAG_ABORT;
-			return;
+			goto errout;
 		}
 		ext2fs_set_bitmap_padding(fs->block_map);
 		ext2fs_mark_bb_dirty(fs);
-		
+
 		/* Redo the counts */
 		blocks = 0; free_blocks = 0; group_free = 0; group = 0;
 		memset(free_array, 0, fs->group_desc_count * sizeof(int));
@@ -303,6 +302,7 @@ redo_counts:
 		} else
 			ext2fs_unmark_valid(fs);
 	}
+errout:
 	ext2fs_free_mem(&free_array);
 }
 			
