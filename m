From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/19] e2fsck: try to salvage extent blocks with bad
 checksums
Date: Fri, 01 Aug 2014 11:12:21 -0700
Message-ID: <20140801181221.12496.71818.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33147 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671AbaHASM0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:12:26 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the code that would zap an extent block immediately if the
checksum failed (i.e. strict_csums).  Instead, we'll only do that if
the extent block header shows obvious structural problems; if the
header checks out, then we'll iterate the block and see if we can
recover some extents.

Requires a minor modification to ext2fs_extent_get such that the
extent block will be returned in the buffer even if the return code
indicates a checksum error.  This brings its behavior in line with
the rest of libext2fs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c      |   45 +++++++++++++++++++--------------------------
 e2fsck/problem.c    |    6 ------
 e2fsck/problem.h    |    3 ---
 lib/ext2fs/extent.c |   10 ++++++----
 4 files changed, 25 insertions(+), 39 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 02683d3..283b0b1 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2001,7 +2001,10 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 	int			is_dir, is_leaf;
 	problem_t		problem;
 	struct ext2_extent_info	info;
-	int			failed_csum;
+	int			failed_csum = 0;
+
+	if (pctx->errcode == EXT2_ET_EXTENT_CSUM_INVALID)
+		failed_csum = 1;
 
 	pctx->errcode = ext2fs_extent_get_info(ehandle, &info);
 	if (pctx->errcode)
@@ -2012,7 +2015,6 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 	while ((pctx->errcode == 0 ||
 		pctx->errcode == EXT2_ET_EXTENT_CSUM_INVALID) &&
 	       info.num_entries-- > 0) {
-		failed_csum = 0;
 		is_leaf = extent.e_flags & EXT2_EXTENT_FLAGS_LEAF;
 		is_dir = LINUX_S_ISDIR(pctx->inode->i_mode);
 		last_lblk = extent.e_lblk + extent.e_len - 1;
@@ -2023,15 +2025,6 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 		pctx->num = extent.e_len;
 		pctx->blkcount = extent.e_lblk + extent.e_len;
 
-		/* Ask to clear a corrupt extent block */
-		if (try_repairs &&
-		    pctx->errcode == EXT2_ET_EXTENT_CSUM_INVALID) {
-			problem = PR_1_EXTENT_CSUM_INVALID;
-			if (fix_problem(ctx, problem, pctx))
-				goto fix_problem_now;
-			failed_csum = 1;
-		}
-
 		if (extent.e_pblk == 0 ||
 		    extent.e_pblk < ctx->fs->super->s_first_data_block ||
 		    extent.e_pblk >= ext2fs_blocks_count(ctx->fs->super))
@@ -2069,16 +2062,6 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			failed_csum = 0;
 		}
 
-		/* Failed csum but passes checks?  Ask to fix checksum. */
-		if (try_repairs && failed_csum && problem == 0 &&
-		    fix_problem(ctx, PR_1_EXTENT_ONLY_CSUM_INVALID, pctx)) {
-			pb->inode_modified = 1;
-			pctx->errcode = ext2fs_extent_replace(ehandle,
-							0, &extent);
-			if (pctx->errcode)
-				return;
-		}
-
 		if (try_repairs && problem) {
 report_problem:
 			if (fix_problem(ctx, problem, pctx)) {
@@ -2124,6 +2107,7 @@ fix_problem_now:
 					pctx->errcode = 0;
 					break;
 				}
+				failed_csum = 0;
 				continue;
 			}
 			goto next;
@@ -2152,15 +2136,13 @@ fix_problem_now:
 			}
 			pctx->errcode = ext2fs_extent_get(ehandle,
 						  EXT2_EXTENT_DOWN, &extent);
-			if (pctx->errcode) {
+			if (pctx->errcode &&
+			    pctx->errcode != EXT2_ET_EXTENT_CSUM_INVALID) {
 				pctx->str = "EXT2_EXTENT_DOWN";
 				problem = PR_1_EXTENT_HEADER_INVALID;
 				if (!next_try_repairs)
 					return;
-				if (pctx->errcode ==
-					EXT2_ET_EXTENT_HEADER_BAD ||
-				    pctx->errcode ==
-					EXT2_ET_EXTENT_CSUM_INVALID)
+				if (pctx->errcode == EXT2_ET_EXTENT_HEADER_BAD)
 					goto report_problem;
 				return;
 			}
@@ -2256,6 +2238,7 @@ fix_problem_now:
 				if (pctx->errcode)
 					goto failed_add_dir_block;
 				last_lblk = extent.e_lblk + extent.e_len - 1;
+				failed_csum = 0;
 			}
 		}
 alloc_later:
@@ -2323,6 +2306,16 @@ alloc_later:
 						  EXT2_EXTENT_NEXT_SIB,
 						  &extent);
 	}
+
+	/* Failed csum but passes checks?  Ask to fix checksum. */
+	if (failed_csum &&
+	    fix_problem(ctx, PR_1_EXTENT_ONLY_CSUM_INVALID, pctx)) {
+		pb->inode_modified = 1;
+		pctx->errcode = ext2fs_extent_replace(ehandle, 0, &extent);
+		if (pctx->errcode)
+			return;
+	}
+
 	if (pctx->errcode == EXT2_ET_EXTENT_NO_NEXT)
 		pctx->errcode = 0;
 }
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index dc094ed..1b6bdb0 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -977,12 +977,6 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i passes checks, but checksum does not match @i.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
-	/* Inode extent block checksum does not match extent */
-	{ PR_1_EXTENT_CSUM_INVALID,
-	  N_("@i %i extent block checksum does not match extent\n\t(logical @b "
-	     "%c, @n physical @b %b, len %N)\n"),
-	  PROMPT_CLEAR, 0 },
-
 	/*
 	 * Inode extent block passes checks, but checksum does not match
 	 * extent
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index af7a73e..89db5f3 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -577,9 +577,6 @@ struct problem_context {
 /* inode passes checks, but checksum does not match inode */
 #define PR_1_INODE_ONLY_CSUM_INVALID   0x010068
 
-/* extent block checksum does not match extent block */
-#define PR_1_EXTENT_CSUM_INVALID       0x010069
-
 /* extent block passes checks, but checksum does not match extent block */
 #define PR_1_EXTENT_ONLY_CSUM_INVALID  0x01006A
 
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 30673b5..32bc214 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -283,6 +283,7 @@ errcode_t ext2fs_extent_get(ext2_extent_handle_t handle,
 	blk64_t				blk;
 	blk64_t				end_blk;
 	int				orig_op, op;
+	int				failed_csum = 0;
 
 	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EXTENT_HANDLE);
 
@@ -457,10 +458,8 @@ retry:
 
 		if (!(handle->fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
 		    !ext2fs_extent_block_csum_verify(handle->fs, handle->ino,
-						     eh)) {
-			handle->level--;
-			return EXT2_ET_EXTENT_CSUM_INVALID;
-		}
+						     eh))
+			failed_csum = 1;
 
 		newpath->left = newpath->entries =
 			ext2fs_le16_to_cpu(eh->eh_entries);
@@ -540,6 +539,9 @@ retry:
 	     (path->left != 0)))
 		goto retry;
 
+	if (failed_csum)
+		return EXT2_ET_EXTENT_CSUM_INVALID;
+
 	return 0;
 }
 

