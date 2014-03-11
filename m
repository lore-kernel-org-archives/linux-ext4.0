From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 40/49] libext2fs: find a range of empty blocks
Date: Mon, 10 Mar 2014 23:58:16 -0700
Message-ID: <20140311065816.30585.80617.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33454 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710AbaCKG6V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:58:21 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Provide a function that, given a goal pblk and a range, will try to
find a run of free blocks to satisfy the allocation.  By default the
function will look anywhere in the filesystem for the run, though this
can be constrained with optional flags.  One flag indicates that the
range must start at the goal block; the other flag indicates that we
should not return a range shorter than len.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/alloc.c  |  105 +++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2fs.h |    6 +++
 2 files changed, 111 insertions(+)


diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index aa084ac..109a050 100644
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
@@ -303,3 +313,98 @@ blk64_t ext2fs_find_inode_goal(ext2_filsys fs, ext2_ino_t ino)
 		group = group & ~((1 << (log_flex)) - 1);
 	return ext2fs_group_first_block2(fs, group);
 }
+
+/*
+ * Starting at _goal_, scan around the filesystem to find a run of free blocks
+ * that's at least _len_ blocks long.  If EXT2_NEWRANGE_EXACT_GOAL is given,
+ * then the range of blocks must start at _goal_.  If
+ * EXT2_NEWRANGE_EXACT_LENGTH is given, do not return a allocation shorter than
+ * _len_.
+ *
+ * The starting block is returned in _pblk_ and the length is returned via
+ * _plen_.
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
+		retval = ext2fs_find_first_zero_block_bitmap2(fs->block_map,
+						start, max_blocks - 1, &start);
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
+		retval =  ext2fs_find_first_set_block_bitmap2(fs->block_map,
+						start, b, &end);
+		if (retval == ENOENT)
+			end = b + 1;
+		else if (retval)
+			goto errout;
+
+		if (!(flags & EXT2_NEWRANGE_EXACT_LENGTH) ||
+		    (end - start) >= len) {
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
+try_again:
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
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d3a7f04..7354e4d 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -691,6 +691,12 @@ extern void ext2fs_set_alloc_block_callback(ext2_filsys fs,
 							      blk64_t goal,
 							      blk64_t *ret));
 blk64_t ext2fs_find_inode_goal(ext2_filsys fs, ext2_ino_t ino);
+#define EXT2_NEWRANGE_FIXED_GOAL	(0x1)
+#define EXT2_NEWRANGE_EXACT_LENGTH	(0x2)
+#define EXT2_NEWRANGE_ALL_FLAGS		(0x3)
+errcode_t ext2fs_new_range(ext2_filsys fs, int flags, blk64_t goal,
+			   blk64_t len, ext2fs_block_bitmap map, blk64_t *pblk,
+			   blk64_t *plen);
 
 /* alloc_sb.c */
 extern int ext2fs_reserve_super_and_bgd(ext2_filsys fs,

