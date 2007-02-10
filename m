From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-40.diff>
Date: Fri, 9 Feb 2007 18:11:36 -0800
Message-ID: <200702100211.l1A2BaPv007420@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-1.llnl.gov ([128.115.41.81]:40380 "EHLO
	nspiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbXBJCOm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:42 -0500
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
Coverity ID: 40: Resource Leak

Real memory leaks. The fix applied to our tree adds an errout: label at the
end where the memory is freed. The early returns have been replaced with
goto's which jump to the label. It's 'safe' to not check the return code of
e2fsck_allocate_memory because if the memory allocations fails it will
internally call exit().

The patch also performs some whitespace cleanup.

Index: e2fsprogs+chaos/e2fsck/pass5.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/pass5.c
+++ e2fsprogs+chaos/e2fsck/pass5.c
@@ -305,7 +305,7 @@ redo_counts:
 errout:
 	ext2fs_free_mem(&free_array);
 }
-			
+
 static void check_inode_bitmaps(e2fsck_t ctx)
 {
 	ext2_filsys fs = ctx->fs;
@@ -323,16 +323,16 @@ static void check_inode_bitmaps(e2fsck_t
 	int		problem, save_problem, fixit, had_problem;
 	int		lazy_bg = 0;
 	int		skip_group = 0;
-	
+
 	clear_problem_context(&pctx);
 	free_array = (int *) e2fsck_allocate_memory(ctx,
 	    fs->group_desc_count * sizeof(int), "free inode count array");
-				     
+
 	dir_array = (int *) e2fsck_allocate_memory(ctx,
 	   fs->group_desc_count * sizeof(int), "directory count array");
-				     
+
 	if ((1 < ext2fs_get_inode_bitmap_start(ctx->inode_used_map)) ||
-	    (fs->super->s_inodes_count > 
+	    (fs->super->s_inodes_count >
 	     ext2fs_get_inode_bitmap_end(ctx->inode_used_map))) {
 		pctx.num = 3;
 		pctx.blk = 1;
@@ -342,10 +342,10 @@ static void check_inode_bitmaps(e2fsck_t
 		fix_problem(ctx, PR_5_BMAP_ENDPOINTS, &pctx);
 
 		ctx->flags |= E2F_FLAG_ABORT; /* fatal */
-		return;
+		goto errout;
 	}
 	if ((1 < ext2fs_get_inode_bitmap_start(fs->inode_map)) ||
-	    (fs->super->s_inodes_count > 
+	    (fs->super->s_inodes_count >
 	     ext2fs_get_inode_bitmap_end(fs->inode_map))) {
 		pctx.num = 4;
 		pctx.blk = 1;
@@ -355,10 +355,10 @@ static void check_inode_bitmaps(e2fsck_t
 		fix_problem(ctx, PR_5_BMAP_ENDPOINTS, &pctx);
 
 		ctx->flags |= E2F_FLAG_ABORT; /* fatal */
-		return;
+		goto errout;
 	}
 
-	if (EXT2_HAS_COMPAT_FEATURE(fs->super, 
+	if (EXT2_HAS_COMPAT_FEATURE(fs->super,
 				    EXT2_FEATURE_COMPAT_LAZY_BG))
 		lazy_bg++;
 
@@ -372,13 +372,13 @@ redo_counts:
 
 	for (i = 1; i <= fs->super->s_inodes_count; i++) {
 		actual = ext2fs_fast_test_inode_bitmap(ctx->inode_used_map, i);
-		if (skip_group) 
+		if (skip_group)
 			bitmap = 0;
 		else
 			bitmap = ext2fs_fast_test_inode_bitmap(fs->inode_map, i);
 		if (actual == bitmap)
 			goto do_counts;
-		
+
 		if (!actual && bitmap) {
 			/*
 			 * Inode wasn't used, but marked in bitmap
@@ -405,7 +405,7 @@ redo_counts:
 		}
 		ctx->flags |= E2F_FLAG_PROG_SUPPRESS;
 		had_problem++;
-		
+
 do_counts:
 		if (bitmap) {
 			if (ext2fs_test_inode_bitmap(ctx->inode_dir_map, i))
@@ -428,7 +428,7 @@ do_counts:
 				if ((ctx->progress)(ctx, 5,
 					    group + fs->group_desc_count,
 					    fs->group_desc_count*2))
-					return;
+					goto errout;
 			if (lazy_bg &&
 			    (i != fs->super->s_inodes_count) &&
 			    (fs->group_desc[group].bg_flags &
@@ -438,13 +438,13 @@ do_counts:
 	}
 	if (pctx.ino)
 		print_bitmap_problem(ctx, save_problem, &pctx);
-	
+
 	if (had_problem)
 		fixit = end_problem_latch(ctx, PR_LATCH_IBITMAP);
 	else
 		fixit = -1;
 	ctx->flags &= ~E2F_FLAG_PROG_SUPPRESS;
-	
+
 	if (fixit == 1) {
 		ext2fs_free_inode_bitmap(fs->inode_map);
 		retval = ext2fs_copy_bitmap(ctx->inode_used_map,
@@ -453,7 +453,7 @@ do_counts:
 			clear_problem_context(&pctx);
 			fix_problem(ctx, PR_5_COPY_IBITMAP_ERROR, &pctx);
 			ctx->flags |= E2F_FLAG_ABORT;
-			return;
+			goto errout;
 		}
 		ext2fs_set_bitmap_padding(fs->inode_map);
 		ext2fs_mark_ib_dirty(fs);
@@ -466,7 +466,7 @@ do_counts:
 		goto redo_counts;
 	} else if (fixit == 0)
 		ext2fs_unmark_valid(fs);
-	
+
 	for (i = 0; i < fs->group_desc_count; i++) {
 		if (free_array[i] != fs->group_desc[i].bg_free_inodes_count) {
 			pctx.group = i;
@@ -505,6 +505,7 @@ do_counts:
 		} else
 			ext2fs_unmark_valid(fs);
 	}
+errout:
 	ext2fs_free_mem(&free_array);
 	ext2fs_free_mem(&dir_array);
 }
