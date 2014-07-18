From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/24] e2fsck: don't clobber critical metadata during
 check_blocks
Date: Fri, 18 Jul 2014 15:53:28 -0700
Message-ID: <20140718225328.31374.71677.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33105 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945991AbaGRWxd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:53:33 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we encounter an inode with IND/DIND/TIND blocks or internal extent
tree blocks that point into critical FS metadata such as the
superblock, the group descriptors, the bitmaps, or the inode table,
it's quite possible that the validation code for those blocks is not
going to like what it finds, and it'll ask to try to fix the block.
Unfortunately, this happens before duplicate block processing (pass
1b), which means that we can end up doing stupid things like writing
extent blocks into the inode table, which multiplies e2fsck'
destructive effect and can render a filesystem unfixable.

To solve this, create a bitmap of all the critical FS metadata.  If
before pass1b runs (basically check_blocks) we find a metadata block
that points into these critical regions, continue processing that
block, but avoid making any modifications, because we could be
misinterpreting inodes as block maps.  Pass 1b will find the
multiply-owned blocks and fix that situation, which means that we can
then restart e2fsck from the beginning and actually fix whatever
problems we find.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/e2fsck.c                   |    4 +
 e2fsck/e2fsck.h                   |    1 
 e2fsck/pass1.c                    |   86 ++++++++++++++++++++++++++++----
 e2fsck/pass1b.c                   |    2 -
 e2fsck/pass5.c                    |    2 +
 e2fsck/problem.c                  |    8 +++
 e2fsck/problem.h                  |    3 +
 tests/f_itable_collision/expect.1 |  101 +++++++++++++++++++++++++++++++++++++
 tests/f_itable_collision/expect.2 |    7 +++
 tests/f_itable_collision/image.gz |  Bin
 tests/f_itable_collision/name     |    1 
 tests/f_itable_collision/script   |   38 ++++++++++++++
 12 files changed, 242 insertions(+), 11 deletions(-)
 create mode 100644 tests/f_itable_collision/expect.1
 create mode 100644 tests/f_itable_collision/expect.2
 create mode 100644 tests/f_itable_collision/image.gz
 create mode 100644 tests/f_itable_collision/name
 create mode 100755 tests/f_itable_collision/script


diff --git a/e2fsck/e2fsck.c b/e2fsck/e2fsck.c
index 0ec1540..fcda7d7 100644
--- a/e2fsck/e2fsck.c
+++ b/e2fsck/e2fsck.c
@@ -108,6 +108,10 @@ errcode_t e2fsck_reset_context(e2fsck_t ctx)
 		ext2fs_free_block_bitmap(ctx->block_ea_map);
 		ctx->block_ea_map = 0;
 	}
+	if (ctx->block_metadata_map) {
+		ext2fs_free_block_bitmap(ctx->block_metadata_map);
+		ctx->block_metadata_map = 0;
+	}
 	if (ctx->inode_bb_map) {
 		ext2fs_free_inode_bitmap(ctx->inode_bb_map);
 		ctx->inode_bb_map = 0;
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 80ab18a..53f10b1 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -374,6 +374,7 @@ struct e2fsck_struct {
 	 * e2fsck functions themselves.
 	 */
 	void *priv_data;
+	ext2fs_block_bitmap block_metadata_map; /* Metadata blocks */
 };
 
 /* Used by the region allocation code */
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 18980f1..37b05ff 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -93,6 +93,7 @@ struct process_block_struct {
 	struct problem_context *pctx;
 	ext2fs_block_bitmap fs_meta_blocks;
 	e2fsck_t	ctx;
+	blk64_t		bad_ref;
 };
 
 struct process_inode_block {
@@ -696,6 +697,15 @@ void e2fsck_pass1(e2fsck_t ctx)
 		ctx->flags |= E2F_FLAG_ABORT;
 		return;
 	}
+	pctx.errcode = e2fsck_allocate_block_bitmap(fs,
+			_("metadata block map"), EXT2FS_BMAP64_RBTREE,
+			"block_metadata_map", &ctx->block_metadata_map);
+	if (pctx.errcode) {
+		pctx.num = 1;
+		fix_problem(ctx, PR_1_ALLOCATE_BBITMAP_ERROR, &pctx);
+		ctx->flags |= E2F_FLAG_ABORT;
+		return;
+	}
 	e2fsck_setup_tdb_icount(ctx, 0, &ctx->inode_link_info);
 	if (!ctx->inode_link_info) {
 		e2fsck_set_bitmap_type(fs, EXT2FS_BMAP64_RBTREE,
@@ -1904,7 +1914,8 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			     struct process_block_struct *pb,
 			     blk64_t start_block, blk64_t end_block,
 			     blk64_t eof_block,
-			     ext2_extent_handle_t ehandle)
+			     ext2_extent_handle_t ehandle,
+			     int try_repairs)
 {
 	struct ext2fs_extent	extent;
 	blk64_t			blk, last_lblk;
@@ -1931,7 +1942,8 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 
 		problem = 0;
 		/* Ask to clear a corrupt extent block */
-		if (pctx->errcode == EXT2_ET_EXTENT_CSUM_INVALID) {
+		if (try_repairs &&
+		    pctx->errcode == EXT2_ET_EXTENT_CSUM_INVALID) {
 			pctx->blk = extent.e_pblk;
 			pctx->blk2 = extent.e_lblk;
 			pctx->num = extent.e_len;
@@ -1963,7 +1975,7 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			problem = PR_1_TOOBIG_DIR;
 
 		/* Corrupt but passes checks?  Ask to fix checksum. */
-		if (failed_csum) {
+		if (try_repairs && failed_csum) {
 			pctx->blk = extent.e_pblk;
 			pctx->blk2 = extent.e_lblk;
 			pctx->num = extent.e_len;
@@ -1975,7 +1987,7 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			}
 		}
 
-		if (problem) {
+		if (try_repairs && problem) {
 report_problem:
 			pctx->blk = extent.e_pblk;
 			pctx->blk2 = extent.e_lblk;
@@ -2026,13 +2038,32 @@ fix_problem_now:
 
 		if (!is_leaf) {
 			blk64_t lblk = extent.e_lblk;
+			int next_try_repairs = 1;
 
 			blk = extent.e_pblk;
+
+			/*
+			 * If this lower extent block collides with critical
+			 * metadata, don't try to repair the damage.  Pass 1b
+			 * will reallocate the block; then we can try again.
+			 */
+			if (pb->ino != EXT2_RESIZE_INO &&
+			    ext2fs_test_block_bitmap2(ctx->block_metadata_map,
+						      extent.e_pblk)) {
+				next_try_repairs = 0;
+				pctx->blk = blk;
+				fix_problem(ctx,
+					    PR_1_CRITICAL_METADATA_COLLISION,
+					    pctx);
+				ctx->flags |= E2F_FLAG_RESTART_LATER;
+			}
 			pctx->errcode = ext2fs_extent_get(ehandle,
 						  EXT2_EXTENT_DOWN, &extent);
 			if (pctx->errcode) {
 				pctx->str = "EXT2_EXTENT_DOWN";
 				problem = PR_1_EXTENT_HEADER_INVALID;
+				if (!next_try_repairs)
+					return;
 				if (pctx->errcode ==
 					EXT2_ET_EXTENT_HEADER_BAD ||
 				    pctx->errcode ==
@@ -2058,7 +2089,8 @@ fix_problem_now:
 				}
 			}
 			scan_extent_node(ctx, pctx, pb, extent.e_lblk,
-					 last_lblk, eof_block, ehandle);
+					 last_lblk, eof_block, ehandle,
+					 next_try_repairs);
 			if (pctx->errcode)
 				return;
 			pctx->errcode = ext2fs_extent_get(ehandle,
@@ -2181,7 +2213,7 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 
 	eof_lblk = ((EXT2_I_SIZE(inode) + fs->blocksize - 1) >>
 		EXT2_BLOCK_SIZE_BITS(fs->super)) - 1;
-	scan_extent_node(ctx, pctx, pb, 0, 0, eof_lblk, ehandle);
+	scan_extent_node(ctx, pctx, pb, 0, 0, eof_lblk, ehandle, 1);
 	if (pctx->errcode &&
 	    fix_problem(ctx, PR_1_EXTENT_ITERATE_FAILURE, pctx)) {
 		pb->num_blocks = 0;
@@ -2249,6 +2281,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	pb.pctx = pctx;
 	pb.ctx = ctx;
 	pb.inode_modified = 0;
+	pb.bad_ref = 0;
 	pctx->ino = ino;
 	pctx->errcode = 0;
 
@@ -2590,8 +2623,35 @@ static int process_block(ext2_filsys fs,
 	    blk >= ext2fs_blocks_count(fs->super))
 		problem = PR_1_ILLEGAL_BLOCK_NUM;
 
+	/*
+	 * If this IND/DIND/TIND block is squatting atop some critical metadata
+	 * (group descriptors, superblock, bitmap, inode table), any write to
+	 * "fix" mapping problems will destroy the metadata.  We'll let pass 1b
+	 * fix that and restart fsck.
+	 */
+	if (blockcnt < 0 &&
+	    p->ino != EXT2_RESIZE_INO &&
+	    ext2fs_test_block_bitmap2(ctx->block_metadata_map, blk)) {
+		p->bad_ref = blk;
+		pctx->blk = blk;
+		fix_problem(ctx, PR_1_CRITICAL_METADATA_COLLISION, pctx);
+		ctx->flags |= E2F_FLAG_RESTART_LATER;
+	}
+
 	if (problem) {
 		p->num_illegal_blocks++;
+		/*
+		 * A bit of subterfuge here -- we're trying to fix a block
+		 * mapping, but know that the IND/DIND/TIND block has collided
+		 * with some critical metadata.  So, fix the in-core mapping so
+		 * iterate won't go insane, but return 0 instead of
+		 * BLOCK_CHANGED so that it won't write the remapping out to
+		 * our multiply linked block.
+		 */
+		if (p->bad_ref && ref_block == p->bad_ref) {
+			*block_nr = 0;
+			return 0;
+		}
 		if (!p->suppress && (p->num_illegal_blocks % 12) == 0) {
 			if (fix_problem(ctx, PR_1_TOO_MANY_BAD_BLOCKS, pctx)) {
 				p->clear = 1;
@@ -2972,6 +3032,7 @@ static void mark_table_blocks(e2fsck_t ctx)
 		pctx.group = i;
 
 		ext2fs_reserve_super_and_bgd(fs, i, ctx->block_found_map);
+		ext2fs_reserve_super_and_bgd(fs, i, ctx->block_metadata_map);
 
 		/*
 		 * Mark the blocks used for the inode table
@@ -2990,8 +3051,10 @@ static void mark_table_blocks(e2fsck_t ctx)
 						ctx->invalid_bitmaps++;
 					}
 				} else {
-				    ext2fs_mark_block_bitmap2(ctx->block_found_map,
-							     b);
+				    ext2fs_mark_block_bitmap2(
+						ctx->block_found_map, b);
+				    ext2fs_mark_block_bitmap2(
+						ctx->block_metadata_map, b);
 			    	}
 			}
 		}
@@ -3010,8 +3073,9 @@ static void mark_table_blocks(e2fsck_t ctx)
 			} else {
 			    ext2fs_mark_block_bitmap2(ctx->block_found_map,
 				     ext2fs_block_bitmap_loc(fs, i));
-		    }
-
+			    ext2fs_mark_block_bitmap2(ctx->block_metadata_map,
+				     ext2fs_block_bitmap_loc(fs, i));
+			}
 		}
 		/*
 		 * Mark block used for the inode bitmap
@@ -3025,6 +3089,8 @@ static void mark_table_blocks(e2fsck_t ctx)
 					ctx->invalid_bitmaps++;
 				}
 			} else {
+			    ext2fs_mark_block_bitmap2(ctx->block_metadata_map,
+				     ext2fs_inode_bitmap_loc(fs, i));
 			    ext2fs_mark_block_bitmap2(ctx->block_found_map,
 				     ext2fs_inode_bitmap_loc(fs, i));
 			}
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index b4041d1..c2a3cf3 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -389,7 +389,7 @@ static int process_pass1b_block(ext2_filsys fs EXT2FS_ATTR((unused)),
 	p->dup_blocks++;
 	ext2fs_mark_inode_bitmap2(inode_dup_map, p->ino);
 
-	if (lc != p->cur_cluster)
+	if (blockcnt < 0 || lc != p->cur_cluster)
 		add_dupe(ctx, p->ino, EXT2FS_B2C(fs, *block_nr), p->inode);
 
 finish:
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index e23680a..eeb16c3 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -75,6 +75,8 @@ void e2fsck_pass5(e2fsck_t ctx)
 	ctx->inode_dir_map = 0;
 	ext2fs_free_block_bitmap(ctx->block_found_map);
 	ctx->block_found_map = 0;
+	ext2fs_free_block_bitmap(ctx->block_metadata_map);
+	ctx->block_metadata_map = 0;
 
 	print_resource_track(ctx, _("Pass 5"), &rtrack, ctx->fs->io);
 }
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index cb7c700..18d8025 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1030,6 +1030,14 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i has INLINE_DATA_FL flag on @f without inline data support.\n"),
 	  PROMPT_CLEAR, 0 },
 
+	/*
+	 * Inode block conflicts with critical metadata, skipping
+	 * block checks
+	 */
+	{ PR_1_CRITICAL_METADATA_COLLISION,
+	  N_("@i %i block %b conflicts with critical metadata, skipping block checks.\n"),
+	  PROMPT_NONE, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index bc9fa9c..9001ef4 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -600,6 +600,9 @@ struct problem_context {
 /* INLINE_DATA feature is set in a non-inline-data filesystem */
 #define PR_1_INLINE_DATA_SET	       0x010070
 
+/* file metadata collides with critical metadata */
+#define PR_1_CRITICAL_METADATA_COLLISION	0x010071
+
 /*
  * Pass 1b errors
  */
diff --git a/tests/f_itable_collision/expect.1 b/tests/f_itable_collision/expect.1
new file mode 100644
index 0000000..00cdced
--- /dev/null
+++ b/tests/f_itable_collision/expect.1
@@ -0,0 +1,101 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 block 37 conflicts with critical metadata, skipping block checks.
+Illegal block number passed to ext2fs_test_block_bitmap #268435455 for in-use block map
+Illegal block number passed to ext2fs_mark_block_bitmap #268435455 for in-use block map
+Inode 12, i_blocks is 48, should be 56.  Fix? yes
+
+Inode 13 has a bad extended attribute block 34.  Clear? yes
+
+Deleted inode 33 has zero dtime.  Fix? yes
+
+Inodes that were part of a corrupted orphan linked list found.  Fix? yes
+
+Inode 49 was part of the orphaned inode list.  FIXED.
+Inode 14 block 36 conflicts with critical metadata, skipping block checks.
+Illegal block number passed to ext2fs_test_block_bitmap #4294967295 for metadata block map
+Inode 14 has illegal block(s).  Clear? yes
+
+Illegal indirect block (4294967295) in inode 14.  CLEARED.
+Illegal block number passed to ext2fs_test_block_bitmap #4294967295 for metadata block map
+Illegal indirect block (4294967295) in inode 14.  CLEARED.
+Illegal block number passed to ext2fs_test_block_bitmap #4294967295 for metadata block map
+Illegal indirect block (4294967295) in inode 14.  CLEARED.
+Illegal block number passed to ext2fs_test_block_bitmap #4294967295 for metadata block map
+Illegal indirect block (4294967295) in inode 14.  CLEARED.
+Illegal block number passed to ext2fs_test_block_bitmap #4294967295 for metadata block map
+Illegal indirect block (4294967295) in inode 14.  CLEARED.
+Illegal block number passed to ext2fs_test_block_bitmap #4294967295 for metadata block map
+Illegal indirect block (4294967295) in inode 14.  CLEARED.
+Illegal block number passed to ext2fs_test_block_bitmap #4294967295 for metadata block map
+Illegal indirect block (4294967295) in inode 14.  CLEARED.
+Illegal block number passed to ext2fs_test_block_bitmap #4294967295 for metadata block map
+Too many illegal blocks in inode 14.
+Clear inode? yes
+
+Restarting e2fsck from the beginning...
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 block 37 conflicts with critical metadata, skipping block checks.
+Illegal block number passed to ext2fs_test_block_bitmap #4294967294 for in-use block map
+Illegal block number passed to ext2fs_mark_block_bitmap #4294967294 for in-use block map
+Illegal block number passed to ext2fs_test_block_bitmap #268435455 for in-use block map
+Illegal block number passed to ext2fs_mark_block_bitmap #268435455 for in-use block map
+
+Running additional passes to resolve blocks claimed by more than one inode...
+Pass 1B: Rescanning for multiply-claimed blocks
+Illegal block number passed to ext2fs_test_block_bitmap #4294967294 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #268435455 for multiply claimed block map
+Multiply-claimed block(s) in inode 12: 37
+Pass 1C: Scanning directories for inodes with multiply-claimed blocks
+Pass 1D: Reconciling multiply-claimed blocks
+(There are 1 inodes containing multiply-claimed blocks.)
+
+File /a (inode #12, mod time Fri Jun 27 18:34:44 2014) 
+  has 1 multiply-claimed block(s), shared with 1 file(s):
+	<filesystem metadata>
+Clone multiply-claimed blocks? yes
+
+Illegal block number passed to ext2fs_test_block_bitmap #4294967294 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #268435455 for multiply claimed block map
+Pass 2: Checking directory structure
+Setting filetype for entry 'bad1' in / (2) to 1.
+Setting filetype for entry 'bad2' in / (2) to 1.
+Restarting e2fsck from the beginning...
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has an invalid extent
+	(logical block 0, invalid physical block 4294967294, len 1)
+Clear? yes
+
+Inode 12 has an invalid extent
+	(logical block 5, invalid physical block 268435455, len 1)
+Clear? yes
+
+Inode 12, i_blocks is 56, should be 40.  Fix? yes
+
+Pass 2: Checking directory structure
+Entry 'b' in / (2) has deleted/unused inode 14.  Clear? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  -9 -13 -42
+Fix? yes
+
+Free blocks count wrong for group #0 (485, counted=488).
+Fix? yes
+
+Free blocks count wrong (485, counted=488).
+Fix? yes
+
+Inode bitmap differences:  -14 +34 +50
+Fix? yes
+
+Free inodes count wrong for group #0 (114, counted=113).
+Fix? yes
+
+Free inodes count wrong (114, counted=113).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 15/128 files (6.7% non-contiguous), 24/512 blocks
+Exit status is 0
diff --git a/tests/f_itable_collision/expect.2 b/tests/f_itable_collision/expect.2
new file mode 100644
index 0000000..4abc600
--- /dev/null
+++ b/tests/f_itable_collision/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 15/128 files (6.7% non-contiguous), 24/512 blocks
+Exit status is 0
diff --git a/tests/f_itable_collision/image.gz b/tests/f_itable_collision/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..6218b1464a9fa9d6a714dfa64e1c67398734a9aa
GIT binary patch
literal 2817
zcmb2|=3tl|xjC4L`R!fbj2KrLh7Xmqdv#~~uT^s5Ul=ikD>KNo>JkU*#{j`?;`+R~
zb{n!b1t@bQd47Ge@KK<kjq5FMKS7l$gAVnN4?<ls`IlB{L<N0N+H>yBK9y{rq%E0t
z_4_~6f4*OvUsnE1b@OL4XCbBy;l9g!HCx=13T?R`))dyS?D)kvx%W}geV?xfxQ(ys
zJgNNpeVPD2KYy)hY;47vH5#|Oq>m?m^sSk&J^AOW7cbB6-(UFX+tTlR_LX0s_t(Y#
zv+C>X^}q9aTiwUoZ<caj_qY4|QN8$lP4(-${+kU1Zh80C{@v{T_J#)g<M3^V{yvpZ
zzrJGntC-H(yZ1`&pNJOr=RJ1z!3Aw)=k>hvq}TKIn_S;HP50`~X>0e(F)&nn&-!O4
z@Hn9MU%lNuJ^gpphF|_HY-eC#NO*qw^R*Ax_w8QE59H;Pzx@9Ht)lkVwqsEZ-vYG0
zelxrF!A?SJ>GkY<9~;A{>f#!Ux2xr6&+SZ2pE$oa)qNuW(N7V!`t6(3+kRi3)wFV5
zRoxkNU7$%DN^ebz{eS;mR?L59Aa}RVc0C})aQ#1!Xn0)@BonMxpV{6P?E7EeYN>md
zk?XIF1tCwSO6a=I`zMyL^MrM&GEh-Yw(Kq-#Zb1F8BBxN$l%@1jZteCi9>}F(oZu2
zjlcUoay~my=s;dND+{t}650P<|Gz0IRs0sTJKs*+{H|im%h@aa#4p~sEcEUA>A#8b
zcfy`+4#-<I{c8V?YWCzWbF8Zt%Wa>xf5Y`(@;9s|i$6}wOKAOQuYGL)|Mj^y-{wsH
znE&(lgw0H|ll9KlvxUw2Kh??K@IR;anfg<%IY<7aYuEo<e(A^epf^oF_NaG7NUZ(U
z^)0>oZM@V$KJ(tp$cx@fmDY<CAD*)P_>Tu0<?Ulu|Gis#Jbs<~`QP)GUY~gCY)-vZ
z|K<NP{-<?+zMnJoXa04o`Hvs2erzurb^edJTh+giyjMT}E4Hjp-d|pGv!hk4Z2iZ5
zU-RX93+pG=e}DePI(zQ_<L>p6o`&UBuZpT<SDF|B1CwEc;3u2=m*4KMEZk~4GoKGA
zQr3IwPwm5yZ{JtnQ%=l`4US^od~4UTqKW0lGIT%LoZnp*^g9+D>1e^dLGoDE)~+}-
l(NXSb2#kinXb6mkz-S1Jh5#ucaHH}a!^Um<yBQc17y!{Atk?hm

literal 0
HcmV?d00001

diff --git a/tests/f_itable_collision/name b/tests/f_itable_collision/name
new file mode 100644
index 0000000..dab3d45
--- /dev/null
+++ b/tests/f_itable_collision/name
@@ -0,0 +1 @@
+collision between IND/extent tree blocks and inode table
diff --git a/tests/f_itable_collision/script b/tests/f_itable_collision/script
new file mode 100755
index 0000000..7eedfd3
--- /dev/null
+++ b/tests/f_itable_collision/script
@@ -0,0 +1,38 @@
+#!/bin/bash
+
+# Run this test with a specific time, because we're crosslinking an extent tree
+# block with the inode table.  When fsck sets dtime to now, we want "now" to be
+# our preprogrammed value.
+
+FSCK_OPT=-fy
+IMAGE=$test_dir/image.gz
+E2FSCK_TIME=4294967294
+export E2FSCK_TIME
+
+gzip -d < $IMAGE > $TMPFILE
+e2label $TMPFILE test_filesys
+
+# Run fsck to fix things?
+EXP1=$test_dir/expect.1
+OUT1=$test_name.1.log
+rm -rf $test_name.failed $test_name.ok
+
+$FSCK $FSCK_OPT $TMPFILE 2>&1 | tail -n +2 > $OUT1
+echo "Exit status is $?" >> $OUT1
+
+# Run a second time
+EXP2=$test_dir/expect.2
+OUT2=$test_name.2.log
+
+$FSCK $FSCK_OPT $TMPFILE 2>&1 | tail -n +2 > $OUT2
+echo "Exit status is $?" >> $OUT2
+
+# Figure out what happened
+if cmp -s $EXP1 $OUT1 && cmp -s $EXP2 $OUT2; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff -u $EXP1 $OUT1 >> $test_name.failed
+	diff -u $EXP2 $OUT2 >> $test_name.failed
+fi

