From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck, libext2fs: add checks for insanely large file systems
Date: Mon,  4 Sep 2017 20:34:07 -0400
Message-ID: <20170905003407.8766-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56278 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754045AbdIEAeP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 4 Sep 2017 20:34:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the blocks count field is too large, this can cause numberic
overflows which can result in buffer overflows.

Addresses-Debian-Bug: #873757

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reported-by: Jakub Wilk <jwilk@jwilk.net>
---
 e2fsck/super.c      | 31 +++++++++++++++++++++++++++++--
 lib/ext2fs/openfs.c | 12 +++++++++---
 2 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/e2fsck/super.c b/e2fsck/super.c
index 8153f2bfe..47c89c56f 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -41,6 +41,23 @@ static void check_super_value(e2fsck_t ctx, const char *descr,
 	}
 }
 
+static void check_super_value64(e2fsck_t ctx, const char *descr,
+				__u64 value, int flags,
+				__u64 min_val, __u64 max_val)
+{
+	struct		problem_context pctx;
+
+	if ((flags & MIN_CHECK && value < min_val) ||
+	    (flags & MAX_CHECK && value > max_val) ||
+	    (flags & LOG2_CHECK && (value & (value - 1)) != 0)) {
+		clear_problem_context(&pctx);
+		pctx.num = value;
+		pctx.str = descr;
+		fix_problem(ctx, PR_0_MISC_CORRUPT_SUPER, &pctx);
+		ctx->flags |= E2F_FLAG_ABORT; /* never get here! */
+	}
+}
+
 /*
  * helper function to release an inode
  */
@@ -468,6 +485,7 @@ void check_super_block(e2fsck_t ctx)
 	problem_t	problem;
 	blk64_t	blocks_per_group = fs->super->s_blocks_per_group;
 	__u32	bpg_max, cpg_max;
+	__u64	blks_max;
 	int	inodes_per_block;
 	int	inode_size;
 	int	accept_time_fudge;
@@ -497,6 +515,15 @@ void check_super_block(e2fsck_t ctx)
 	ctx->invalid_inode_table_flag = (int *) e2fsck_allocate_memory(ctx,
 		sizeof(int) * fs->group_desc_count, "invalid_inode_table");
 
+	blks_max = (1ULL << 32) * EXT2_MAX_BLOCKS_PER_GROUP(fs->super);
+	if (ext2fs_has_feature_64bit(fs->super)) {
+		if (blks_max > ((1ULL << 48) - 1))
+			blks_max = (1ULL << 48) - 1;
+	} else {
+		if (blks_max > ((1ULL << 32) - 1))
+			blks_max = (1ULL << 32) - 1;
+	}
+
 	clear_problem_context(&pctx);
 
 	/*
@@ -504,8 +531,8 @@ void check_super_block(e2fsck_t ctx)
 	 */
 	check_super_value(ctx, "inodes_count", sb->s_inodes_count,
 			  MIN_CHECK, 1, 0);
-	check_super_value(ctx, "blocks_count", ext2fs_blocks_count(sb),
-			  MIN_CHECK, 1, 0);
+	check_super_value64(ctx, "blocks_count", ext2fs_blocks_count(sb),
+			    MIN_CHECK | MAX_CHECK, 1, blks_max);
 	check_super_value(ctx, "first_data_block", sb->s_first_data_block,
 			  MAX_CHECK, 0, ext2fs_blocks_count(sb));
 	check_super_value(ctx, "log_block_size", sb->s_log_block_size,
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index da03bc147..f74cd2458 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -122,6 +122,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	char		*dest, *cp;
 	int		group_zero_adjust = 0;
 	int		inode_size;
+	__u64		groups_cnt;
 #ifdef WORDS_BIGENDIAN
 	unsigned int	groups_per_block;
 	struct ext2_group_desc *gdp;
@@ -371,9 +372,14 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
 	}
-	fs->group_desc_count = ext2fs_div64_ceil(ext2fs_blocks_count(fs->super) -
-						 fs->super->s_first_data_block,
-						 blocks_per_group);
+	groups_cnt = ext2fs_div64_ceil(ext2fs_blocks_count(fs->super) -
+				       fs->super->s_first_data_block,
+				       blocks_per_group);
+	if (groups_cnt >> 32) {
+		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
+		goto cleanup;
+	}
+	fs->group_desc_count = 	groups_cnt;
 	if (fs->group_desc_count * EXT2_INODES_PER_GROUP(fs->super) !=
 	    fs->super->s_inodes_count) {
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
-- 
2.11.0.rc0.7.gbe5a750
