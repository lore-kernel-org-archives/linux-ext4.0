From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 26/54] e2fsck: track directories to be rehashed with a bitmap
Date: Mon, 26 Jan 2015 23:38:23 -0800
Message-ID: <20150127073823.13308.32139.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34284 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbbA0Hi1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:38:27 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use a bitmap to track which directories we want to rehash, since
bitmaps will use less memory.  This enables us to clean up the
rehash-all case to use inode_dir_map, and we can free the dirinfo
memory sooner.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/e2fsck.c |    4 ++--
 e2fsck/e2fsck.h |    2 +-
 e2fsck/pass1.c  |    8 ++++++-
 e2fsck/pass2.c  |    4 ++--
 e2fsck/pass3.c  |    4 ++++
 e2fsck/rehash.c |   60 ++++++++++++++++++-------------------------------------
 6 files changed, 35 insertions(+), 47 deletions(-)


diff --git a/e2fsck/e2fsck.c b/e2fsck/e2fsck.c
index fcda7d7..7483072 100644
--- a/e2fsck/e2fsck.c
+++ b/e2fsck/e2fsck.c
@@ -125,8 +125,8 @@ errcode_t e2fsck_reset_context(e2fsck_t ctx)
 		ctx->inode_imagic_map = 0;
 	}
 	if (ctx->dirs_to_hash) {
-		ext2fs_u32_list_free(ctx->dirs_to_hash);
-		ctx->dirs_to_hash = 0;
+		ext2fs_free_inode_bitmap(ctx->dirs_to_hash);
+		ctx->dirs_to_hash = NULL;
 	}
 
 	/*
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index e359515..33dbcad 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -304,7 +304,7 @@ struct e2fsck_struct {
 	/*
 	 * Directories to hash
 	 */
-	ext2_u32_list	dirs_to_hash;
+	ext2fs_inode_bitmap dirs_to_hash;
 
 	/*
 	 * Tuning parameters
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 3ac3dfe..da4d3cf 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -985,8 +985,12 @@ void e2fsck_pass1(e2fsck_t ctx)
 
 	if ((fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX) &&
 	    !(ctx->options & E2F_OPT_NO)) {
-		if (ext2fs_u32_list_create(&ctx->dirs_to_hash, 50))
-			ctx->dirs_to_hash = 0;
+		if (e2fsck_allocate_inode_bitmap(fs,
+						 _("directories to rehash"),
+						 EXT2FS_BMAP64_AUTODIR,
+						 "dirs_to_hash",
+						 &ctx->dirs_to_hash))
+			ctx->dirs_to_hash = NULL;
 	}
 
 #ifdef MTRACE
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 768e5cd..661260c 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -965,7 +965,7 @@ static int check_dir_block(ext2_filsys fs,
 		dot_state = 0;
 
 	if (ctx->dirs_to_hash &&
-	    ext2fs_u32_list_test(ctx->dirs_to_hash, ino))
+	    ext2fs_fast_test_block_bitmap2(ctx->dirs_to_hash, ino))
 		dups_found++;
 
 #if 0
@@ -1684,7 +1684,7 @@ static void clear_htree(e2fsck_t ctx, ext2_ino_t ino)
 	inode.i_flags = inode.i_flags & ~EXT2_INDEX_FL;
 	e2fsck_write_inode(ctx, ino, &inode, "clear_htree");
 	if (ctx->dirs_to_hash)
-		ext2fs_u32_list_add(ctx->dirs_to_hash, ino);
+		ext2fs_mark_inode_bitmap2(ctx->dirs_to_hash, ino);
 }
 
 
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 1d5255f..c331b98 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -119,6 +119,10 @@ void e2fsck_pass3(e2fsck_t ctx)
 	 * If there are any directories that need to be indexed or
 	 * optimized, do it here.
 	 */
+	if (iter)
+		e2fsck_dir_info_iter_end(ctx, iter);
+	iter = NULL;
+	e2fsck_free_dir_info(ctx);
 	e2fsck_rehash_directories(ctx);
 
 abort_exit:
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index e37e871..348923e 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -56,9 +56,13 @@
 void e2fsck_rehash_dir_later(e2fsck_t ctx, ext2_ino_t ino)
 {
 	if (!ctx->dirs_to_hash)
-		ext2fs_u32_list_create(&ctx->dirs_to_hash, 50);
+		e2fsck_allocate_inode_bitmap(ctx->fs,
+					     _("directories to rehash"),
+					     EXT2FS_BMAP64_AUTODIR,
+					     "dirs_to_hash",
+					     &ctx->dirs_to_hash);
 	if (ctx->dirs_to_hash)
-		ext2fs_u32_list_add(ctx->dirs_to_hash, ino);
+		ext2fs_mark_inode_bitmap2(ctx->dirs_to_hash, ino);
 }
 
 /* Ask if a dir will be rebuilt during pass 3A. */
@@ -68,7 +72,7 @@ int e2fsck_dir_will_be_rehashed(e2fsck_t ctx, ext2_ino_t ino)
 		return 1;
 	if (!ctx->dirs_to_hash)
 		return 0;
-	return ext2fs_u32_list_test(ctx->dirs_to_hash, ino);
+	return ext2fs_test_inode_bitmap2(ctx->dirs_to_hash, ino);
 }
 
 struct fill_dir_struct {
@@ -911,12 +915,9 @@ void e2fsck_rehash_directories(e2fsck_t ctx)
 #ifdef RESOURCE_TRACK
 	struct resource_track	rtrack;
 #endif
-	struct dir_info		*dir;
-	ext2_u32_iterate 	iter;
-	struct dir_info_iter *	dirinfo_iter = 0;
-	ext2_ino_t		ino;
-	errcode_t		retval;
-	int			cur, max, all_dirs, first = 1;
+	ext2_ino_t		ino = 0;
+	int			all_dirs, first = 1;
+	ext2fs_inode_bitmap	hmap;
 
 	init_resource_track(&rtrack, ctx->fs->io);
 	all_dirs = ctx->options & E2F_OPT_COMPRESS_DIRS;
@@ -928,30 +929,12 @@ void e2fsck_rehash_directories(e2fsck_t ctx)
 
 	clear_problem_context(&pctx);
 
-	cur = 0;
-	if (all_dirs) {
-		dirinfo_iter = e2fsck_dir_info_iter_begin(ctx);
-		max = e2fsck_get_num_dirinfo(ctx);
-	} else {
-		retval = ext2fs_u32_list_iterate_begin(ctx->dirs_to_hash,
-						       &iter);
-		if (retval) {
-			pctx.errcode = retval;
-			fix_problem(ctx, PR_3A_OPTIMIZE_ITER, &pctx);
-			return;
-		}
-		max = ext2fs_u32_list_count(ctx->dirs_to_hash);
-	}
+	hmap = (all_dirs ? ctx->inode_dir_map : ctx->dirs_to_hash);
 	while (1) {
-		if (all_dirs) {
-			if ((dir = e2fsck_dir_info_iter(ctx,
-							dirinfo_iter)) == 0)
-				break;
-			ino = dir->ino;
-		} else {
-			if (!ext2fs_u32_list_iterate(iter, &ino))
-				break;
-		}
+		if (ext2fs_find_first_set_inode_bitmap2(
+				hmap, ino + 1,
+				ctx->fs->super->s_inodes_count, &ino))
+			break;
 
 		pctx.dir = ino;
 		if (first) {
@@ -968,17 +951,14 @@ void e2fsck_rehash_directories(e2fsck_t ctx)
 		}
 		if (ctx->progress && !ctx->progress_fd)
 			e2fsck_simple_progress(ctx, "Rebuilding directory",
-			       100.0 * (float) (++cur) / (float) max, ino);
+					100.0 * (float) ino /
+					(float) ctx->fs->super->s_inodes_count,
+					ino);
 	}
 	end_problem_latch(ctx, PR_LATCH_OPTIMIZE_DIR);
-	if (all_dirs)
-		e2fsck_dir_info_iter_end(ctx, dirinfo_iter);
-	else
-		ext2fs_u32_list_iterate_end(iter);
