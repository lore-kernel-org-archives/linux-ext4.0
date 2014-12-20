From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 25/31] libext2fs: find/alloc a range of empty blocks
Date: Sat, 20 Dec 2014 13:19:36 -0800
Message-ID: <20141220211936.25563.24584.stgit@birch.djwong.org>
References: <20141220211640.25563.80596.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40780 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbaLTVTl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Dec 2014 16:19:41 -0500
In-Reply-To: <20141220211640.25563.80596.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Provide a function that, given a goal pblk and a range, will try to
find a run of free blocks to satisfy the allocation.  By default the
function will look anywhere in the filesystem for the run, though this
can be constrained with optional flags.  One flag indicates that the
range must start at the goal block; the other flag indicates that we
should not return a range shorter than len.

v2: Add a second function to allocate a range of blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/alloc.c  |  141 +++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2fs.h |   11 ++++
 2 files changed, 152 insertions(+)


diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 9901ca5..4c3b620 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -26,6 +26,16 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
+#define min(a, b) ((a) < (b) ? (a) : (b))
+
+#undef DEBUG
+
+#ifdef DEBUG
+# define dbg_printf(f, a...)  do {printf(f, ## a); fflush(stdout); } while (0)
+#else
+# define dbg_printf(f, a...)
+#endif
+
 /*
  * Clear the uninit block bitmap flag if necessary
  */
@@ -346,3 +356,134 @@ no_blocks:
 		group = group & ~((1 << (log_flex)) - 1);
 	return ext2fs_group_first_block2(fs, group);
 }
+
+/*
+ * Starting at _goal_, scan around the filesystem to find a run of free blocks
+ * that's at least _len_ blocks long.  Possible flags:
+ * - EXT2_NEWRANGE_EXACT_GOAL: The range of blocks must start at _goal_.
+ * - EXT2_NEWRANGE_MIN_LENGTH: do not return a allocation shorter than _len_.
+ * - EXT2_NEWRANGE_ZERO_BLOCKS: Zero blocks pblk to pblk+plen before returning.
+ *
+ * The starting block is returned in _pblk_ and the length is returned via
+ * _plen_.  The blocks are not marked in the bitmap; the caller must mark
+ * however much of the returned run they actually use, hopefully via
+ * ext2fs_block_alloc_stats_range().
+ *
+ * This function can return a range that is longer than what was requested.
+ */
+errcode_t ext2fs_new_range(ext2_filsys fs, int flags, blk64_t goal,
+			   blk64_t len, ext2fs_block_bitmap map, blk64_t *pblk,
+			   blk64_t *plen)
+{
+	errcode_t retval;
+	blk64_t start, end, b;
+	int looped = 0;
+	blk64_t max_blocks = ext2fs_blocks_count(fs->super);
+
+	dbg_printf("%s: flags=0x%x goal=%llu len=%llu\n", __func__, flags,
+		   goal, len);
+	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
+	if (len == 0 || (flags & ~EXT2_NEWRANGE_ALL_FLAGS))
+		return EXT2_ET_INVALID_ARGUMENT;
+	if (!map)
+		map = fs->block_map;
+	if (!map)
+		return EXT2_ET_NO_BLOCK_BITMAP;
+	if (!goal || goal >= ext2fs_blocks_count(fs->super))
+		goal = fs->super->s_first_data_block;
+
+	start = goal;
+	while (!looped || start <= goal) {
+		retval = ext2fs_find_first_zero_block_bitmap2(map, start,
+							      max_blocks - 1,
+							      &start);
+		if (retval == ENOENT) {
+			/*
+			 * If there are no free blocks beyond the starting
+			 * point, try scanning the whole filesystem, unless the
+			 * user told us only to allocate from _goal_, or if
+			 * we're already scanning the whole filesystem.
+			 */
+			if (flags & EXT2_NEWRANGE_FIXED_GOAL ||
+			    start == fs->super->s_first_data_block)
+				goto fail;
+			start = fs->super->s_first_data_block;
+			continue;
+		} else if (retval)
+			goto errout;
+
+		if (flags & EXT2_NEWRANGE_FIXED_GOAL && start != goal)
+			goto fail;
+
+		b = min(start + len - 1, max_blocks - 1);
+		retval =  ext2fs_find_first_set_block_bitmap2(map, start, b,
+							      &end);
+		if (retval == ENOENT)
+			end = b + 1;
+		else if (retval)
+			goto errout;
+
+		if (!(flags & EXT2_NEWRANGE_MIN_LENGTH) ||
+		    (end - start) >= len) {
+			/* Success! */
+			*pblk = start;
+			*plen = end - start;
+			dbg_printf("%s: new_range goal=%llu--%llu "
+				   "blk=%llu--%llu %llu\n",
+				   __func__, goal, goal + len - 1,
+				   *pblk, *pblk + *plen - 1, *plen);
+
+			for (b = start; b < end;
+			     b += fs->super->s_blocks_per_group)
+				clear_block_uninit(fs,
+						ext2fs_group_of_blk2(fs, b));
+			return 0;
+		}
+
+		if (flags & EXT2_NEWRANGE_FIXED_GOAL)
+			goto fail;
+		start = end;
+		if (start >= max_blocks) {
+			if (looped)
+				goto fail;
+			looped = 1;
+			start = fs->super->s_first_data_block;
+		}
+	}
+
+fail:
+	retval = EXT2_ET_BLOCK_ALLOC_FAIL;
+errout:
+	return retval;
+}
+
+errcode_t ext2fs_alloc_range(ext2_filsys fs, int flags, blk64_t goal,
+			     blk_t len, blk64_t *ret)
+{
+	int newr_flags = EXT2_NEWRANGE_MIN_LENGTH;
+	errcode_t retval;
+	blk64_t plen;
+
+	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
+	if (len == 0 || (flags & ~EXT2_ALLOCRANGE_ALL_FLAGS))
+		return EXT2_ET_INVALID_ARGUMENT;
+
+	if (flags & EXT2_ALLOCRANGE_FIXED_GOAL)
+		newr_flags |= EXT2_NEWRANGE_FIXED_GOAL;
+
+	retval = ext2fs_new_range(fs, newr_flags, goal, len, NULL, ret, &plen);
+	if (retval)
+		return retval;
+
+	if (plen < len)
+		return EXT2_ET_BLOCK_ALLOC_FAIL;
+
+	if (flags & EXT2_ALLOCRANGE_ZERO_BLOCKS) {
+		retval = ext2fs_zero_blocks2(fs, *ret, len, NULL, NULL);
+		if (retval)
+			return retval;
+	}
+
+	ext2fs_block_alloc_stats_range(fs, *ret, len, +1);
+	return retval;
+}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index e117441..bfe0ecf 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -693,6 +693,17 @@ extern void ext2fs_set_alloc_block_callback(ext2_filsys fs,
 							      blk64_t *ret));
 blk64_t ext2fs_find_inode_goal(ext2_filsys fs, ext2_ino_t ino,
 			       struct ext2_inode *inode, blk64_t lblk);
+#define EXT2_NEWRANGE_FIXED_GOAL	(0x1)
+#define EXT2_NEWRANGE_MIN_LENGTH	(0x2)
+#define EXT2_NEWRANGE_ALL_FLAGS		(0x3)
+errcode_t ext2fs_new_range(ext2_filsys fs, int flags, blk64_t goal,
+			   blk64_t len, ext2fs_block_bitmap map, blk64_t *pblk,
+			   blk64_t *plen);
+#define EXT2_ALLOCRANGE_FIXED_GOAL	(0x1)
+#define EXT2_ALLOCRANGE_ZERO_BLOCKS	(0x2)
+#define EXT2_ALLOCRANGE_ALL_FLAGS	(0x3)
+errcode_t ext2fs_alloc_range(ext2_filsys fs, int flags, blk64_t goal,
+			     blk_t len, blk64_t *ret);
 
 /* alloc_sb.c */
 extern int ext2fs_reserve_super_and_bgd(ext2_filsys fs,

