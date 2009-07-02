From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH] e2fsck: Improve consistency check of uninit block group and
 some cleanup
Date: Thu, 02 Jul 2009 14:26:36 +0900
Message-ID: <4A4C450C.6060808@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:56614 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbZGBF14 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jul 2009 01:27:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

e2fsck_pass5() checks whether inode/block is consistency each. However, if
EXT2_BG_[INODE/BLOCK]_BITMAP is set to a ext4's block group, most of its bitmap
is uninitialized (0). In that case, e2fsck pass 5 becomes faster if it checks
consistency of uninitialized block group all at once.

This patch cuts e2fsck pass 5 time by up to 80%. The following results show the
e2fsck time.

Comparison of e2fsck time on an ext4 500GB partition (20% blocks used)
-------------------------------------------------
|     |     old e2fsck     |     new e2fsck     |
|Pass |       time(s)      |       time(s)      |
|     | real | user |system| real | user |system|
-------------------------------------------------
|  1  |  5.70|  3.29|  0.50|  5.77|  3.40|  0.49|
|  2  |  3.33|  0.80|  0.19|  3.38|  0.86|  0.23|
|  3  |  0.01|  0.00|  0.00|  0.01|  0.00|  0.01|
|  4  |  1.04|  1.04|  0.00|  1.05|  1.05|  0.00|
|  5  | 19.60| 17.27|  0.06|  3.53|  1.19|  0.06|
-------------------------------------------------
|Total| 29.94| 22.57|  0.80| 14.00|  6.68|  0.81|
-------------------------------------------------

Machine environment:
CPU:       Intel(R) Xeon(TM) CPU 3.00GHz
Memory:    1GB
Kernel:    linux-2.6.29-git2
e2fsprogs: 1.41.6

In addition, this patch deletes unnecessary continue statement and fix loop
counter properly.

The following patch can be applied to e2fsprogs git tree (master branch).

Regards,
Kazuya Mio

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 e2fsck/pass2.c          |    2
 e2fsck/pass5.c          |  156 +++++++++++++++++++++++++++++++++++++-----------
 lib/ext2fs/ext2fs.h     |    3
 lib/ext2fs/gen_bitmap.c |   77 +++++++++++++++++++++++
 4 files changed, 201 insertions(+), 37 deletions(-)

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index bb3813c..889e39d 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -243,8 +243,6 @@ void e2fsck_pass2(e2fsck_t ctx)
 				fix_problem(ctx, code, &pctx);
 				bad_dir++;
 			}
-			if (code == 0)
-				continue;
 		}
 		if (bad_dir && fix_problem(ctx, PR_2_HTREE_CLEAR, &pctx)) {
 			clear_htree(ctx, dx_dir->ino);
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index e660386..77c6653 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -103,7 +103,7 @@ static void print_bitmap_problem(e2fsck_t ctx, int problem,
 static void check_block_bitmaps(e2fsck_t ctx)
 {
 	ext2_filsys fs = ctx->fs;
-	blk_t	i, super;
+	blk_t	i;
 	int	*free_array;
 	int	group = 0;
 	blk_t	blocks = 0;
@@ -115,8 +115,18 @@ static void check_block_bitmaps(e2fsck_t ctx)
 	errcode_t	retval;
 	int		csum_flag;
 	int		skip_group = 0;
+	int	old_desc_blocks;
+	int	count = 0;
+	int	cmp_block = 0;
+	int	redo_flag = 0;
+	char	*init_zero_mem = NULL;
+	blk_t	super_blk, old_desc_blk, new_desc_blk;

 	clear_problem_context(&pctx);
+
+	init_zero_mem = (char *) e2fsck_allocate_memory(ctx,
+			(fs->super->s_blocks_per_group >> 3) *
+			sizeof(char), "block compare");
 	free_array = (int *) e2fsck_allocate_memory(ctx,
 	    fs->group_desc_count * sizeof(int), "free block count array");

@@ -159,46 +169,88 @@ redo_counts:
 	if (csum_flag &&
 	    (fs->group_desc[group].bg_flags & EXT2_BG_BLOCK_UNINIT))
 		skip_group++;
-	super = fs->super->s_first_data_block;
 	for (i = fs->super->s_first_data_block;
 	     i < fs->super->s_blocks_count;
 	     i++) {
 		actual = ext2fs_fast_test_block_bitmap(ctx->block_found_map, i);

 		if (skip_group) {
-			blk_t	super_blk, old_desc_blk, new_desc_blk;
-			int	old_desc_blocks;
-
-			ext2fs_super_and_bgd_loc(fs, group, &super_blk,
+			if ((i - fs->super->s_first_data_block) %
+					fs->super->s_blocks_per_group == 0) {
+				super_blk = 0;
+				old_desc_blk = 0;
+				new_desc_blk = 0;
+				ext2fs_super_and_bgd_loc(fs, group, &super_blk,
 					 &old_desc_blk, &new_desc_blk, 0);

-			if (fs->super->s_feature_incompat &
-			    EXT2_FEATURE_INCOMPAT_META_BG)
-				old_desc_blocks = fs->super->s_first_meta_bg;
-			else
-				old_desc_blocks = fs->desc_blocks +
+				if (fs->super->s_feature_incompat &
+						EXT2_FEATURE_INCOMPAT_META_BG)
+					old_desc_blocks =
+						fs->super->s_first_meta_bg;
+				else
+					old_desc_blocks = fs->desc_blocks +
 					fs->super->s_reserved_gdt_blocks;
+			}

 			bitmap = 0;
-			if (i == super_blk)
-				bitmap = 1;
-			if (old_desc_blk && old_desc_blocks &&
-			    (i >= old_desc_blk) &&
-			    (i < old_desc_blk + old_desc_blocks))
-				bitmap = 1;
-			if (new_desc_blk &&
-			    (i == new_desc_blk))
-				bitmap = 1;
-			if (i == fs->group_desc[group].bg_block_bitmap)
+			if ((i == super_blk) ||
+				(old_desc_blk && old_desc_blocks &&
+				(i >= old_desc_blk) &&
+				(i < old_desc_blk + old_desc_blocks)) ||
+				(new_desc_blk && (i == new_desc_blk)) ||
+				(i == fs->group_desc[group].bg_block_bitmap) ||
+				(i == fs->group_desc[group].bg_inode_bitmap) ||
+				(i >= fs->group_desc[group].bg_inode_table &&
+				(i < fs->group_desc[group].bg_inode_table +
+					fs->inode_blocks_per_group))) {
 				bitmap = 1;
-			else if (i == fs->group_desc[group].bg_inode_bitmap)
-				bitmap = 1;
-			else if (i >= fs->group_desc[group].bg_inode_table &&
-				 (i < fs->group_desc[group].bg_inode_table
-				  + fs->inode_blocks_per_group))
-				bitmap = 1;
-			actual = (actual != 0);
-		} else
+				actual = (actual != 0);
+				count++;
+			} else if ((i - count - fs->super->s_first_data_block) %
+					fs->super->s_blocks_per_group == 0) {
+				/*
+				 * Count the number of compare data blocks in
+				 * every block group.The last block group's
+				 * count is different, because that the last
+				 * blockgroup is not saturation is possible.
+				 */
+				if (group == (int)fs->group_desc_count - 1)
+					cmp_block = fs->super->s_blocks_count -
+						i +
+						fs->super->s_first_data_block;
+				else
+					cmp_block = fs->super->
+						s_blocks_per_group - count;
+
+				/*
+				 * When the compare data blocks in block bitmap
+				 * are 0, count the free block,
+				 * skip the current block group.
+				 */
+				if (!ext2fs_test_bits(i, cmp_block,
+					(ext2fs_generic_bitmap)
+					ctx->block_found_map, init_zero_mem)) {
+					/*
+					 * -1 means to skip the current block
+					 * group.
+					 */
+					blocks = fs->super->s_blocks_per_group
+									- 1;
+					group_free = cmp_block;
+					free_blocks += cmp_block;
+					/*
+					 * The current block group's last block
+					 * is set to i.
+					 */
+					i += cmp_block - 1;
+					count = 0;
+					bitmap = 1;
+					goto do_counts;
+				}
+			}
+		} else if (redo_flag)
+			bitmap = actual;
+		else
 			bitmap = ext2fs_fast_test_block_bitmap(fs->block_map, i);

 		if (actual == bitmap)
@@ -255,7 +307,6 @@ redo_counts:
 			blocks = 0;
 			group_free = 0;
 			skip_group = 0;
-			super += fs->super->s_blocks_per_group;
 			if (ctx->progress)
 				if ((ctx->progress)(ctx, 5, group,
 						    fs->group_desc_count*2))
@@ -291,6 +342,7 @@ redo_counts:
 		/* Redo the counts */
 		blocks = 0; free_blocks = 0; group_free = 0; group = 0;
 		memset(free_array, 0, fs->group_desc_count * sizeof(int));
+		redo_flag++;
 		goto redo_counts;
 	} else if (fixit == 0)
 		ext2fs_unmark_valid(fs);
@@ -323,6 +375,7 @@ redo_counts:
 	}
 errout:
 	ext2fs_free_mem(&free_array);
+	ext2fs_free_mem(&init_zero_mem);
 }

 static void check_inode_bitmaps(e2fsck_t ctx)
@@ -342,8 +395,14 @@ static void check_inode_bitmaps(e2fsck_t ctx)
 	int		problem, save_problem, fixit, had_problem;
 	int		csum_flag;
 	int		skip_group = 0;
+	int		redo_flag = 0;
+	char		*init_zero_mem = NULL;

 	clear_problem_context(&pctx);
+
+	init_zero_mem = (char *) e2fsck_allocate_memory(ctx,
+			(fs->super->s_inodes_per_group >> 3) * sizeof(char),
+			"inode compare");
 	free_array = (int *) e2fsck_allocate_memory(ctx,
 	    fs->group_desc_count * sizeof(int), "free inode count array");

@@ -389,11 +448,36 @@ redo_counts:

 	/* Protect loop from wrap-around if inodes_count is maxed */
 	for (i = 1; i <= fs->super->s_inodes_count && i > 0; i++) {
+		bitmap = 0;
+		if (skip_group &&
+			i % fs->super->s_inodes_per_group == 1) {
+			/*
+			 * Current inode is the first inode
+			 * in the current block group.
+			 */
+			if (!ext2fs_test_bits(i, fs->super->s_inodes_per_group,
+				(ext2fs_generic_bitmap)(ctx->inode_used_map),
+				init_zero_mem)) {
+				/*
+				 * When the compared inodes in inodes bitmap
+				 * are 0, count the free inode,
+				 * skip the current block group.
+				 */
+				inodes = fs->super->s_inodes_per_group - 1;
+				group_free = inodes;
+				free_inodes += inodes;
+				i += inodes;
+				skip_group = 0;
+				goto do_counts;
+			}
+		}
+
 		actual = ext2fs_fast_test_inode_bitmap(ctx->inode_used_map, i);
-		if (skip_group)
-			bitmap = 0;
-		else
+		if (redo_flag)
+			bitmap = actual;
+		else if (!skip_group)
 			bitmap = ext2fs_fast_test_inode_bitmap(fs->inode_map, i);
+
 		if (actual == bitmap)
 			goto do_counts;

@@ -496,6 +580,7 @@ do_counts:
 		dirs_count = 0; group = 0;
 		memset(free_array, 0, fs->group_desc_count * sizeof(int));
 		memset(dir_array, 0, fs->group_desc_count * sizeof(int));
+		redo_flag++;
 		goto redo_counts;
 	} else if (fixit == 0)
 		ext2fs_unmark_valid(fs);
@@ -541,6 +626,7 @@ do_counts:
 errout:
 	ext2fs_free_mem(&free_array);
 	ext2fs_free_mem(&dir_array);
+	ext2fs_free_mem(&init_zero_mem);
 }

 static void check_inode_end(e2fsck_t ctx)
@@ -567,7 +653,7 @@ static void check_inode_end(e2fsck_t ctx)
 	for (i = save_inodes_count + 1; i <= end && i > save_inodes_count; i++) {
 		if (!ext2fs_test_inode_bitmap(fs->inode_map, i)) {
 			if (fix_problem(ctx, PR_5_INODE_BMAP_PADDING, &pctx)) {
-				for (i = save_inodes_count + 1; i <= end; i++)
+				for (; i <= end; i++)
 					ext2fs_mark_inode_bitmap(fs->inode_map,
 								 i);
 				ext2fs_mark_ib_dirty(fs);
@@ -612,7 +698,7 @@ static void check_block_end(e2fsck_t ctx)
 	for (i = save_blocks_count + 1; i <= end && i > save_blocks_count; i++) {
 		if (!ext2fs_test_block_bitmap(fs->block_map, i)) {
 			if (fix_problem(ctx, PR_5_BLOCK_BMAP_PADDING, &pctx)) {
-				for (i = save_blocks_count + 1; i <= end; i++)
+				for (; i <= end; i++)
 					ext2fs_mark_block_bitmap(fs->block_map,
 								 i);
 				ext2fs_mark_bb_dirty(fs);
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 234fbdd..b2325ac 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -933,6 +933,9 @@ extern errcode_t
ext2fs_set_generic_bitmap_range(ext2fs_generic_bitmap bmap,
 						 errcode_t magic,
 						 __u32 start, __u32 num,
 						 void *in);
+extern int ext2fs_test_bits(unsigned int start_num, unsigned int numbers,
+						ext2fs_generic_bitmap bitmap,
+						const char *init_zero_mem);

 /* getsize.c */
 extern errcode_t ext2fs_get_device_size(const char *file, int blocksize,
diff --git a/lib/ext2fs/gen_bitmap.c b/lib/ext2fs/gen_bitmap.c
index a1b1d8f..3d8c8f2 100644
--- a/lib/ext2fs/gen_bitmap.c
+++ b/lib/ext2fs/gen_bitmap.c
@@ -165,6 +165,83 @@ int ext2fs_test_generic_bitmap(ext2fs_generic_bitmap bitmap,
 	return ext2fs_test_bit(bitno - bitmap->start, bitmap->bitmap);
 }

+/*
+ * A specified district is checked in block bitmap or in inode bitmap.
+ */
+int ext2fs_test_bits(unsigned int start, unsigned int len,
+				ext2fs_generic_bitmap bitmap,
+				const char *init_zero_mem)
+{
+	int start_byte, start_bit;
+	int len_byte = len >> 3;
+	int len_bit = len % 8;
+	int first_bit = 0;
+	int last_bit  = 0;
+	int mark_count = 0;
+	int mark_bit = 0;
+	int i, ret = 0;
+	const unsigned char *ADDR = bitmap->bitmap;
+
+	start -= bitmap->start;
+	start_byte = start >> 3;
+	start_bit = start % 8;
+
+	if (start_bit != 0) {
+		/*
+		 * The compared start block number or start inode number
+		 * is not the first bit in a byte.
+		 */
+		mark_count = 8 - start_bit;
+		if (len < 8 - start_bit) {
+			mark_count = (int)len;
+			mark_bit = len + start_bit - 1;
+		} else
+			mark_bit = 7;
+
+		for (i = mark_count; i > 0; i--, mark_bit--)
+			first_bit |= 1 << mark_bit;
+
+		/*
+		 * Compare the blocks or inodes in the first byte,
+		 * 1 is return when 1 exists.
+		 */
+		if (first_bit & ADDR[start_byte])
+			return 1;
+		else if (len <= 8 - start_bit)
+			return 0;
+
+		start_byte++;
+		len_bit = (len - mark_count) % 8;
+		len_byte = (len - mark_count) >> 3;
+	}
+
+	/*
+	 * The compared start block number or start inode number is
+	 * the first bit in a byte.
+	 */
+	if (len_bit != 0) {
+		/*
+		 * The compared end block number or end inode number is
+		 * not the last bit in a byte.
+		 */
+		for (mark_bit = len_bit - 1; mark_bit >= 0; mark_bit--)
+			last_bit |= 1 << mark_bit;
+
+		/*
+		 * Compare the blocks or inodes in the last
+		 * byte, 1 is return when 1 exists.
+		 */
+		if (last_bit & ADDR[start_byte + len_byte])
+			return 1;
+		else if (len_byte == 0)
+			return 0;
+	}
+
+	/* Check whether all bytes are 0 */
+	ret = memcmp(ADDR + start_byte,	init_zero_mem, len_byte);
+	return ret;
+}
+
 int ext2fs_mark_generic_bitmap(ext2fs_generic_bitmap bitmap,
 					 __u32 bitno)
 {
