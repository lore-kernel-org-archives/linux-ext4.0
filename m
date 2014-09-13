From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 24/34] libext2fs: add new hooks to support large allocations
Date: Sat, 13 Sep 2014 15:13:52 -0700
Message-ID: <20140913221352.13646.20199.stgit@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24557 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaIMWN6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2014 18:13:58 -0400
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a new get_alloc_blocks hook and a block_alloc_stats_range hook so
that e2fsck can capture allocation requests spanning more than a
block to its block_found_map.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c           |   45 +++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/alloc.c       |   37 ++++++++++++++++++++++++++++++++++++-
 lib/ext2fs/alloc_stats.c |   16 ++++++++++++++++
 lib/ext2fs/ext2fs.h      |   16 ++++++++++++++++
 4 files changed, 113 insertions(+), 1 deletion(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index a963849..2d59f63 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -3802,6 +3802,26 @@ static errcode_t e2fsck_get_alloc_block(ext2_filsys fs, blk64_t goal,
 	return (0);
 }
 
+static errcode_t e2fsck_new_range(ext2_filsys fs, int flags, blk64_t goal,
+				  blk64_t len, blk64_t *pblk, blk64_t *plen)
+{
+	e2fsck_t ctx = (e2fsck_t) fs->priv_data;
+	errcode_t	retval;
+
+	if (ctx->block_found_map)
+		return ext2fs_new_range(fs, flags, goal, len,
+					ctx->block_found_map, pblk, plen);
+
+	if (!fs->block_map) {
+		retval = ext2fs_read_block_bitmap(fs);
+		if (retval)
+			return retval;
+	}
+
+	return ext2fs_new_range(fs, flags, goal, len, fs->block_map,
+				pblk, plen);
+}
+
 static void e2fsck_block_alloc_stats(ext2_filsys fs, blk64_t blk, int inuse)
 {
 	e2fsck_t ctx = (e2fsck_t) fs->priv_data;
@@ -3821,6 +3841,28 @@ static void e2fsck_block_alloc_stats(ext2_filsys fs, blk64_t blk, int inuse)
 	}
 }
 
+static void e2fsck_block_alloc_stats_range(ext2_filsys fs, blk64_t blk,
+					   blk_t num, int inuse)
+{
+	e2fsck_t ctx = (e2fsck_t) fs->priv_data;
+
+	/* Never free a critical metadata block */
+	if (ctx->block_found_map &&
+	    ctx->block_metadata_map &&
+	    inuse < 0 &&
+	    ext2fs_test_block_bitmap_range2(ctx->block_metadata_map, blk, num))
+		return;
+
+	if (ctx->block_found_map) {
+		if (inuse > 0)
+			ext2fs_mark_block_bitmap_range2(ctx->block_found_map,
+							blk, num);
+		else
+			ext2fs_unmark_block_bitmap_range2(ctx->block_found_map,
+							blk, num);
+	}
+}
+
 void e2fsck_use_inode_shortcuts(e2fsck_t ctx, int use_shortcuts)
 {
 	ext2_filsys fs = ctx->fs;
@@ -3844,4 +3886,7 @@ void e2fsck_intercept_block_allocations(e2fsck_t ctx)
 	ext2fs_set_alloc_block_callback(ctx->fs, e2fsck_get_alloc_block, 0);
 	ext2fs_set_block_alloc_stats_callback(ctx->fs,
 						e2fsck_block_alloc_stats, 0);
+	ext2fs_set_new_range_callback(ctx->fs, e2fsck_new_range, NULL);
+	ext2fs_set_block_alloc_stats_range_callback(ctx->fs,
+					e2fsck_block_alloc_stats_range, NULL);
 }
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 7a5245e..3723b78 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -346,12 +346,32 @@ errcode_t ext2fs_new_range(ext2_filsys fs, int flags, blk64_t goal,
 	blk64_t start, end, b;
 	int looped = 0;
 	blk64_t max_blocks = ext2fs_blocks_count(fs->super);
+	errcode_t (*nrf)(ext2_filsys fs, int flags, blk64_t goal,
+			 blk64_t len, blk64_t *pblk, blk64_t *plen);
 
 	dbg_printf("%s: flags=0x%x goal=%llu len=%llu\n", __func__, flags,
 		   goal, len);
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 	if (len == 0 || (flags & ~EXT2_NEWRANGE_ALL_FLAGS))
 		return EXT2_ET_INVALID_ARGUMENT;
+
+	if (!map && fs->new_range) {
+		/*
+		 * In case there are clients out there whose new_range
+		 * handlers call ext2fs_new_range with a NULL block map,
+		 * temporarily swap out the function pointer so that we don't
+		 * end up in an infinite loop.
+		 */
+		nrf = fs->new_range;
+		fs->new_range = NULL;
+		retval = nrf(fs, flags, goal, len, pblk, plen);
+		fs->new_range = nrf;
+		if (retval)
+			return retval;
+		start = *pblk;
+		end = *pblk + *plen;
+		goto allocated;
+	}
 	if (!map)
 		map = fs->block_map;
 	if (!map)
@@ -399,7 +419,7 @@ errcode_t ext2fs_new_range(ext2_filsys fs, int flags, blk64_t goal,
 				   "blk=%llu--%llu %llu\n",
 				   __func__, goal, goal + len - 1,
 				   *pblk, *pblk + *plen - 1, *plen);
-
+allocated:
 			for (b = start; b < end;
 			     b += fs->super->s_blocks_per_group)
 				clear_block_uninit(fs,
@@ -424,6 +444,21 @@ errout:
 	return retval;
 }
 
+void ext2fs_set_new_range_callback(ext2_filsys fs,
+	errcode_t (*func)(ext2_filsys fs, int flags, blk64_t goal,
+			       blk64_t len, blk64_t *pblk, blk64_t *plen),
+	errcode_t (**old)(ext2_filsys fs, int flags, blk64_t goal,
+			       blk64_t len, blk64_t *pblk, blk64_t *plen))
+{
+	if (!fs || fs->magic != EXT2_ET_MAGIC_EXT2FS_FILSYS)
+		return;
+
+	if (old)
+		*old = fs->new_range;
+
+	fs->new_range = func;
+}
+
 errcode_t ext2fs_alloc_range(ext2_filsys fs, int flags, blk64_t goal,
 			     blk_t len, blk64_t *ret)
 {
diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index 3d3697c..5999082 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -145,4 +145,20 @@ void ext2fs_block_alloc_stats_range(ext2_filsys fs, blk64_t blk,
 	}
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
+	if (fs->block_alloc_stats_range)
+		(fs->block_alloc_stats_range)(fs, blk, num, inuse);
+}
+
+void ext2fs_set_block_alloc_stats_range_callback(ext2_filsys fs,
+	void (*func)(ext2_filsys fs, blk64_t blk,
+				    blk_t num, int inuse),
+	void (**old)(ext2_filsys fs, blk64_t blk,
+				    blk_t num, int inuse))
+{
+	if (!fs || fs->magic != EXT2_ET_MAGIC_EXT2FS_FILSYS)
+		return;
+	if (old)
+		*old = fs->block_alloc_stats_range;
+
+	fs->block_alloc_stats_range = func;
 }
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 8d3ade8..402a19b 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -285,6 +285,12 @@ struct struct_ext2_filsys {
 
 	io_channel			journal_io;
 	char				*journal_name;
+
+	/* New block range allocation hooks */
+	errcode_t (*new_range)(ext2_filsys fs, int flags, blk64_t goal,
+			       blk64_t len, blk64_t *pblk, blk64_t *plen);
+	void (*block_alloc_stats_range)(ext2_filsys fs, blk64_t blk, blk_t num,
+					int inuse);
 };
 
 #if EXT2_FLAT_INCLUDES
@@ -696,6 +702,16 @@ extern void ext2fs_set_alloc_block_callback(ext2_filsys fs,
 					    errcode_t (**old)(ext2_filsys fs,
 							      blk64_t goal,
 							      blk64_t *ret));
+extern void ext2fs_set_new_range_callback(ext2_filsys fs,
+	errcode_t (*func)(ext2_filsys fs, int flags, blk64_t goal,
+			       blk64_t len, blk64_t *pblk, blk64_t *plen),
+	errcode_t (**old)(ext2_filsys fs, int flags, blk64_t goal,
+			       blk64_t len, blk64_t *pblk, blk64_t *plen));
+extern void ext2fs_set_block_alloc_stats_range_callback(ext2_filsys fs,
+	void (*func)(ext2_filsys fs, blk64_t blk,
+				    blk_t num, int inuse),
+	void (**old)(ext2_filsys fs, blk64_t blk,
+				    blk_t num, int inuse));
 blk64_t ext2fs_find_inode_goal(ext2_filsys fs, ext2_ino_t ino);
 #define EXT2_NEWRANGE_FIXED_GOAL	(0x1)
 #define EXT2_NEWRANGE_MIN_LENGTH	(0x2)

