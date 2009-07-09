From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH V2] e2fsck: Improve consistency check of uninit block group
Date: Thu, 09 Jul 2009 13:56:06 +0900
Message-ID: <4A557866.20604@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:61051 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZGIE5F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Jul 2009 00:57:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have addressed Ted's comments.
(http://kerneltrap.org/mailarchive/linux-ext4/2009/7/3/6132903)

e2fsck_pass5() checks whether inode/block is consistency each. However, if
EXT2_BG_[INODE/BLOCK]_BITMAP is set to a ext4's block group, most of its bitmap
is uninitialized (0). In that case, e2fsck pass 5 becomes faster if it checks
consistency of uninitialized block group each 256 bytes.

This patch cuts e2fsck pass 5 time by up to 80%. The following results show the
e2fsck time.

Comparison of e2fsck time on an ext4 500GB partition (20% blocks used)
-------------------------------------------------
|     |     old e2fsck     |     new e2fsck     |
|Pass |       time(s)      |       time(s)      |
|     | real | user |system| real | user |system|
-------------------------------------------------
|  1  |  5.70|  3.29|  0.50|  5.66|  3.21|  0.54|
|  2  |  3.33|  0.80|  0.19|  3.40|  0.82|  0.23|
|  3  |  0.01|  0.00|  0.00|  0.01|  0.00|  0.00|
|  4  |  1.04|  1.04|  0.00|  1.05|  1.04|  0.00|
|  5  | 19.60| 17.27|  0.06|  3.53|  1.21|  0.05|
-------------------------------------------------
|Total| 29.94| 22.57|  0.80| 13.90|  6.47|  0.86|
-------------------------------------------------

Machine environment:
CPU:       Intel(R) Xeon(TM) CPU 3.00GHz
Memory:    1GB
Kernel:    linux-2.6.29-git2
e2fsprogs: 1.41.6

The following patch can be applied to e2fsprogs git tree (master branch).

Regards,
Kazuya Mio

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 e2fsck/pass5.c          |  135 +++++++++++++++++++++++++++++++++++++-----------
 lib/ext2fs/ext2fs.h     |    2
 lib/ext2fs/gen_bitmap.c |   94 +++++++++++++++++++++++++++++++++
 3 files changed, 201 insertions(+), 30 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index e660386..7c872d6 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -115,6 +115,11 @@ static void check_block_bitmaps(e2fsck_t ctx)
 	errcode_t	retval;
 	int		csum_flag;
 	int		skip_group = 0;
+	int	old_desc_blocks = 0;
+	int	count = 0;
+	int	cmp_block = 0;
+	int	redo_flag = 0;
+	blk_t	super_blk, old_desc_blk, new_desc_blk;

 	clear_problem_context(&pctx);
 	free_array = (int *) e2fsck_allocate_memory(ctx,
@@ -166,39 +171,82 @@ redo_counts:
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
+				if (ext2fs_test_zero_range(i, cmp_block,
+					(ext2fs_generic_bitmap)
+					ctx->block_found_map)) {
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
@@ -291,6 +339,7 @@ redo_counts:
 		/* Redo the counts */
 		blocks = 0; free_blocks = 0; group_free = 0; group = 0;
 		memset(free_array, 0, fs->group_desc_count * sizeof(int));
+		redo_flag++;
 		goto redo_counts;
 	} else if (fixit == 0)
 		ext2fs_unmark_valid(fs);
@@ -342,6 +391,7 @@ static void check_inode_bitmaps(e2fsck_t ctx)
 	int		problem, save_problem, fixit, had_problem;
 	int		csum_flag;
 	int		skip_group = 0;
+	int		redo_flag = 0;

 	clear_problem_context(&pctx);
 	free_array = (int *) e2fsck_allocate_memory(ctx,
@@ -389,10 +439,34 @@ redo_counts:

 	/* Protect loop from wrap-around if inodes_count is maxed */
 	for (i = 1; i <= fs->super->s_inodes_count && i > 0; i++) {
+		bitmap = 0;
+		if (skip_group &&
+			i % fs->super->s_inodes_per_group == 1) {
+			/*
+			 * Current inode is the first inode
+			 * in the current block group.
+			 */
+			if (ext2fs_test_zero_range(i,
+				fs->super->s_inodes_per_group,
+				(ext2fs_generic_bitmap)(ctx->inode_used_map))) {
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
 		if (actual == bitmap)
 			goto do_counts;
@@ -496,6 +570,7 @@ do_counts:
 		dirs_count = 0; group = 0;
 		memset(free_array, 0, fs->group_desc_count * sizeof(int));
 		memset(dir_array, 0, fs->group_desc_count * sizeof(int));
+		redo_flag++;
 		goto redo_counts;
 	} else if (fixit == 0)
 		ext2fs_unmark_valid(fs);
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 234fbdd..b011fb6 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -933,6 +933,8 @@ extern errcode_t
ext2fs_set_generic_bitmap_range(ext2fs_generic_bitmap bmap,
 						 errcode_t magic,
 						 __u32 start, __u32 num,
 						 void *in);
+extern int ext2fs_test_zero_range(unsigned int start, unsigned int len,
+						ext2fs_generic_bitmap bitmap);

 /* getsize.c */
 extern errcode_t ext2fs_get_device_size(const char *file, int blocksize,
diff --git a/lib/ext2fs/gen_bitmap.c b/lib/ext2fs/gen_bitmap.c
index a1b1d8f..d699713 100644
--- a/lib/ext2fs/gen_bitmap.c
+++ b/lib/ext2fs/gen_bitmap.c
@@ -165,6 +165,100 @@ int ext2fs_test_generic_bitmap(ext2fs_generic_bitmap bitmap,
 	return ext2fs_test_bit(bitno - bitmap->start, bitmap->bitmap);
 }

+/*
+ * Compare @mem to zero buffer by 256 bytes.
+ * Return 1 if @mem is zeroed memory, otherwise return 0.
+ */
+static int mem_is_zero(const char *mem, size_t len)
+{
+	static const char zero_buf[256];
+
+	while (len >= sizeof(zero_buf)) {
+		if (memcmp(mem, zero_buf, sizeof(zero_buf)))
+			return 0;
+		len -= sizeof(zero_buf);
+		mem += sizeof(zero_buf);
+	}
+	/* Deal with leftover bytes. */
+	if (len)
+		return !memcmp(mem, zero_buf, len);
+	return 1;
+}
+
+/*
+ * A specified district is checked in block bitmap or in inode bitmap.
+ */
+int ext2fs_test_zero_range(unsigned int start, unsigned int len,
+				ext2fs_generic_bitmap bitmap)
+{
+	size_t start_byte, len_byte = len >> 3;
+	int start_bit, len_bit = len % 8;
+	int first_bit = 0;
+	int last_bit  = 0;
+	int mark_count = 0;
+	int mark_bit = 0;
+	int i;
+	const char *ADDR = bitmap->bitmap;
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
+		 * Compare blocks or inodes in the first byte.
+		 * If there is any marked bit, this function returns 0.
+		 */
+		if (first_bit & ADDR[start_byte])
+			return 0;
+		else if (len <= 8 - start_bit)
+			return 1;
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
+		 * Compare blocks or inodes in the last byte.
+		 * If there is any marked bit, this function returns 0.
+		 */
+		if (last_bit & ADDR[start_byte + len_byte])
+			return 0;
+		else if (len_byte == 0)
+			return 1;
+	}
+
+	/* Check whether all bytes are 0 */
+	return mem_is_zero(ADDR + start_byte, len_byte);
+}
+
 int ext2fs_mark_generic_bitmap(ext2fs_generic_bitmap bitmap,
 					 __u32 bitno)
 {
