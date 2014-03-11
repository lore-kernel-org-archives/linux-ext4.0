From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 42/49] libext2fs: implement fallocate
Date: Mon, 10 Mar 2014 23:58:29 -0700
Message-ID: <20140311065829.30585.56447.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33554 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaCKG6d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:58:33 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create a library function to perform fallocation on arbitrary files,
and wire up a few users for this function.  This is a bit more intense
than Ted's original mk_hugefiles implementation since we have to honor
any blocks that may already be allocated to the file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/Makefile.in |    8 
 lib/ext2fs/ext2fs.h    |   10 +
 lib/ext2fs/fallocate.c |  835 ++++++++++++++++++++++++++++++++++++++++++++++++
 misc/mk_hugefiles.c    |   84 +----
 4 files changed, 863 insertions(+), 74 deletions(-)
 create mode 100644 lib/ext2fs/fallocate.c


diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index e64342e..7ea0cd2 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -44,6 +44,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	expanddir.o \
 	ext_attr.o \
 	extent.o \
+	fallocate.o \
 	fileio.o \
 	finddev.o \
 	flushb.o \
@@ -684,6 +685,13 @@ extent.o: $(srcdir)/extent.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/ext2_ext_attr.h \
  $(srcdir)/bitops.h $(srcdir)/e2image.h
+fallocate.o: $(srcdir)/fallocate.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fsP.h \
+ $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/ext2_ext_attr.h \
+ $(srcdir)/bitops.h $(srcdir)/e2image.h
 fileio.o: $(srcdir)/fileio.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 1ae5295..9aaa54e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1222,6 +1222,16 @@ extern errcode_t ext2fs_extent_goto2(ext2_extent_handle_t handle,
 				     int leaf_level, blk64_t blk);
 extern errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle);
 
+/* fallocate.c */
+#define EXT2_FALLOCATE_ZERO_BLOCKS	(0x1)
+#define EXT2_FALLOCATE_FORCE_INIT	(0x2)
+#define EXT2_FALLOCATE_FORCE_UNINIT	(0x4)
+#define EXT2_FALLOCATE_INIT_BEYOND_EOF	(0x8)
+#define EXT2_FALLOCATE_ALL_FLAGS	(0xF)
+errcode_t ext2fs_fallocate(ext2_filsys fs, int flags, ext2_ino_t ino,
+			   struct ext2_inode *inode,
+			   blk64_t start, blk64_t len);
+
 /* fileio.c */
 extern errcode_t ext2fs_file_open2(ext2_filsys fs, ext2_ino_t ino,
 				   struct ext2_inode *inode,
diff --git a/lib/ext2fs/fallocate.c b/lib/ext2fs/fallocate.c
new file mode 100644
index 0000000..5e91037
--- /dev/null
+++ b/lib/ext2fs/fallocate.c
@@ -0,0 +1,835 @@
+/*
+ * fallocate.c -- Allocate large chunks of file.
+ *
+ * Copyright (C) 2014 Oracle.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Library
+ * General Public License, version 2.
+ * %End-Header%
+ */
+
+#include "config.h"
+
+#include "ext2_fs.h"
+#include "ext2fs.h"
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
+/*
+ * Extent-based fallocate code.
+ *
+ * Find runs of unmapped logical blocks by starting at start and walking the
+ * extents until we reach the end of the range we want.
+ *
+ * For each run of unmapped blocks, try to find the extents on either side of
+ * the range.  If there's a left extent that can grow by at least a cluster and
+ * there are lblocks between start and the next lcluster after start, see if
+ * there's an implied cluster allocation; if so, zero the blocks (if the left
+ * extent is initialized) and adjust the extent.  Ditto for the blocks between
+ * the end of the last full lcluster and end, if there's a right extent.
+ *
+ * Try to attach as much as we can to the left extent, then try to attach as
+ * much as we can to the right extent.  For the remainder, try to allocate the
+ * whole range; map in whatever we get; and repeat until we're done.
+ *
+ * To attach to a left extent, figure out the maximum amount we can add to the
+ * extent and try to allocate that much, and append if successful.  To attach
+ * to a right extent, figure out the max we can add to the extent, try to
+ * allocate that much, and prepend if successful.
+ *
+ * We need an alloc_range function that tells us how much we can allocate given
+ * a maximum length and one of a suggested start, a fixed start, or a fixed end
+ * point.
+ *
+ * Every time we modify the extent tree we also need to update the block stats.
+ *
+ * At the end, update i_blocks and i_size appropriately.
+ */
+
+static void dbg_print_extent(char *desc, struct ext2fs_extent *extent)
+{
+#ifdef DEBUG
+	if (desc)
+		printf("%s: ", desc);
+	printf("extent: lblk %llu--%llu, len %u, pblk %llu, flags: ",
+	       extent->e_lblk, extent->e_lblk + extent->e_len - 1,
+	       extent->e_len, extent->e_pblk);
+	if (extent->e_flags & EXT2_EXTENT_FLAGS_LEAF)
+		fputs("LEAF ", stdout);
+	if (extent->e_flags & EXT2_EXTENT_FLAGS_UNINIT)
+		fputs("UNINIT ", stdout);
+	if (extent->e_flags & EXT2_EXTENT_FLAGS_SECOND_VISIT)
+		fputs("2ND_VISIT ", stdout);
+	if (!extent->e_flags)
+		fputs("(none)", stdout);
+	fputc('\n', stdout);
+	fflush(stdout);
+#endif
+}
+
+static errcode_t claim_range(ext2_filsys fs, struct ext2_inode *inode,
+			     blk64_t blk, blk64_t len)
+{
+	blk64_t	clusters;
+
+	clusters = (len + EXT2FS_CLUSTER_RATIO(fs) - 1) /
+		   EXT2FS_CLUSTER_RATIO(fs);
+	ext2fs_block_alloc_stats_range(fs, blk,
+			clusters * EXT2FS_CLUSTER_RATIO(fs), +1);
+	return ext2fs_iblk_add_blocks(fs, inode, clusters);
+}
+
+static errcode_t ext_falloc_helper(ext2_filsys fs,
+				   int flags,
+				   ext2_ino_t ino,
+				   struct ext2_inode *inode,
+				   ext2_extent_handle_t handle,
+				   struct ext2fs_extent *left_ext,
+				   struct ext2fs_extent *right_ext,
+				   blk64_t range_start, blk64_t range_len,
+				   blk64_t alloc_goal)
+{
+	struct ext2fs_extent	newex, ex;
+	int			op;
+	blk64_t			fillable, pblk, plen, x, cluster_fill, y;
+	blk64_t			eof_blk;
+	errcode_t		err;
+	blk_t			max_extent_len, max_uninit_len, max_init_len;
+
+#ifdef DEBUG
+	printf("%s: ", __func__);
+	if (left_ext)
+		printf("left_ext=%llu--%llu, ", left_ext->e_lblk,
+		       left_ext->e_lblk + left_ext->e_len - 1);
+	if (right_ext)
+		printf("right_ext=%llu--%llu, ", right_ext->e_lblk,
+		       right_ext->e_lblk + right_ext->e_len - 1);
+	printf("start=%llu len=%llu, goal=%llu\n", range_start, range_len,
+	       alloc_goal);
+	fflush(stdout);
+#endif
+	/* Can't create initialized extents past EOF? */
+	if (!(flags & EXT2_FALLOCATE_INIT_BEYOND_EOF))
+		eof_blk = EXT2_I_SIZE(inode) / fs->blocksize;
+
+	/* The allocation goal must be as far into a cluster as range_start. */
+	alloc_goal = (alloc_goal & ~EXT2FS_CLUSTER_MASK(fs)) |
+		     (range_start & EXT2FS_CLUSTER_MASK(fs));
+
+	max_uninit_len = EXT_UNINIT_MAX_LEN & ~EXT2FS_CLUSTER_MASK(fs);
+	max_init_len = EXT_INIT_MAX_LEN & ~EXT2FS_CLUSTER_MASK(fs);
+
+	/* We must lengthen the left extent to the end of the cluster */
+	if (left_ext && EXT2FS_CLUSTER_RATIO(fs) > 1) {
+		/* How many more blocks can be attached to left_ext? */
+		if (left_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT)
+			fillable = max_uninit_len - left_ext->e_len;
+		else
+			fillable = max_init_len - left_ext->e_len;
+
+		if (fillable > range_len)
+			fillable = range_len;
+		if (fillable == 0)
+			goto expand_right;
+
+		/*
+		 * If range_start isn't on a cluster boundary, try an
+		 * implied cluster allocation for left_ext.
+		 */
+		cluster_fill = EXT2FS_CLUSTER_RATIO(fs) -
+			       (range_start & EXT2FS_CLUSTER_MASK(fs));
+		cluster_fill &= EXT2FS_CLUSTER_MASK(fs);
+		if (cluster_fill == 0)
+			goto expand_right;
+
+		if (cluster_fill > fillable)
+			cluster_fill = fillable;
+
+		/* Don't expand an initialized left_ext beyond EOF */
+		if (!(flags & EXT2_FALLOCATE_INIT_BEYOND_EOF)) {
+			x = left_ext->e_lblk + left_ext->e_len - 1;
+			dbg_printf("%s: lend=%llu newlend=%llu eofblk=%llu\n",
+				   __func__, x, x + cluster_fill, eof_blk);
+			if (eof_blk >= x && eof_blk <= x + cluster_fill)
+				cluster_fill = eof_blk - x;
+			if (cluster_fill == 0)
+				goto expand_right;
+		}
+
+		err = ext2fs_extent_goto(handle, left_ext->e_lblk);
+		if (err)
+			goto expand_right;
+		left_ext->e_len += cluster_fill;
+		range_start += cluster_fill;
+		range_len -= cluster_fill;
+		alloc_goal += cluster_fill;
+
+		dbg_print_extent("ext_falloc clus left+", left_ext);
+		err = ext2fs_extent_replace(handle, 0, left_ext);
+		if (err)
+			goto out;
+		err = ext2fs_extent_fix_parents(handle);
+		if (err)
+			goto out;
+
+		/* Zero blocks */
+		if (!(left_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT)) {
+			err = ext2fs_zero_blocks2(fs, left_ext->e_pblk +
+						  left_ext->e_len -
+						  cluster_fill, cluster_fill,
+						  NULL, NULL);
+			if (err)
+				goto out;
+		}
+	}
+
+expand_right:
+	/* We must lengthen the right extent to the beginning of the cluster */
+	if (right_ext && EXT2FS_CLUSTER_RATIO(fs) > 1) {
+		/* How much can we attach to right_ext? */
+		if (right_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT)
+			fillable = max_uninit_len - right_ext->e_len;
+		else
+			fillable = max_init_len - right_ext->e_len;
+
+		if (fillable > range_len)
+			fillable = range_len;
+		if (fillable == 0)
+			goto try_merge;
+
+		/*
+		 * If range_end isn't on a cluster boundary, try an implied
+		 * cluster allocation for right_ext.
+		 */
+		cluster_fill = right_ext->e_lblk & EXT2FS_CLUSTER_MASK(fs);
+		if (cluster_fill == 0)
+			goto try_merge;
+
+		err = ext2fs_extent_goto(handle, right_ext->e_lblk);
+		if (err)
+			goto out;
+
+		if (cluster_fill > fillable)
+			cluster_fill = fillable;
+		right_ext->e_lblk -= cluster_fill;
+		right_ext->e_pblk -= cluster_fill;
+		right_ext->e_len += cluster_fill;
+		range_len -= cluster_fill;
+
+		dbg_print_extent("ext_falloc clus right+", right_ext);
+		err = ext2fs_extent_replace(handle, 0, right_ext);
+		if (err)
+			goto out;
+		err = ext2fs_extent_fix_parents(handle);
+		if (err)
+			goto out;
+
+		/* Zero blocks if necessary */
+		if (!(right_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT)) {
+			err = ext2fs_zero_blocks2(fs, right_ext->e_pblk,
+						  cluster_fill, NULL, NULL);
+			if (err)
+				goto out;
+		}
+	}
+
+try_merge:
+	/* Merge both extents together, perhaps? */
+	if (left_ext && right_ext) {
+		/* Are the two extents mergeable? */
+		if ((left_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT) !=
+		    (right_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT))
+			goto try_left;
+
+		/* User requires init/uninit but extent is uninit/init. */
+		if (((flags & EXT2_FALLOCATE_FORCE_INIT) &&
+		     (left_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT)) ||
+		    ((flags & EXT2_FALLOCATE_FORCE_UNINIT) &&
+		     !(left_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT)))
+			goto try_left;
+
+		/*
+		 * Skip initialized extent unless user wants to zero blocks
+		 * or requires init extent.
+		 */
+		if (!(left_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT) &&
+		    (!(flags & EXT2_FALLOCATE_ZERO_BLOCKS) ||
+		     !(flags & EXT2_FALLOCATE_FORCE_INIT)))
+			goto try_left;
+
+		/* Will it even fit? */
+		x = left_ext->e_len + range_len + right_ext->e_len;
+		if (x > (left_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT ?
+				max_uninit_len : max_init_len))
+			goto try_left;
+
+		err = ext2fs_extent_goto(handle, left_ext->e_lblk);
+		if (err)
+			goto try_left;
+
+		/* Allocate blocks */
+		y = left_ext->e_pblk + left_ext->e_len;
+		err = ext2fs_new_range(fs, EXT2_NEWRANGE_FIXED_GOAL |
+				       EXT2_NEWRANGE_EXACT_LENGTH, y,
+				       right_ext->e_pblk - y + 1, NULL,
+				       &pblk, &plen);
+		if (err)
+			goto try_left;
+		if (pblk + plen != right_ext->e_pblk)
+			goto try_left;
+		err = claim_range(fs, inode, pblk, plen);
+		if (err)
+			goto out;
+
+		/* Modify extents */
+		left_ext->e_len = x;
+		dbg_print_extent("ext_falloc merge", left_ext);
+		err = ext2fs_extent_replace(handle, 0, left_ext);
+		if (err)
+			goto out;
+		err = ext2fs_extent_fix_parents(handle);
+		if (err)
+			goto out;
+		err = ext2fs_extent_get(handle, EXT2_EXTENT_NEXT_LEAF, &newex);
+		if (err)
+			goto out;
+		err = ext2fs_extent_delete(handle, 0);
+		if (err)
+			goto out;
+		err = ext2fs_extent_fix_parents(handle);
+		if (err)
+			goto out;
+		*right_ext = *left_ext;
+
+		/* Zero blocks */
+		if (!(left_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT) &&
+		    (flags & EXT2_FALLOCATE_ZERO_BLOCKS)) {
+			err = ext2fs_zero_blocks2(fs, range_start, range_len,
+						  NULL, NULL);
+			if (err)
+				goto out;
+		}
+
+		return 0;
+	}
+
+try_left:
+	/* Extend the left extent */
+	if (left_ext) {
+		/* How many more blocks can be attached to left_ext? */
+		if (left_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT)
+			fillable = max_uninit_len - left_ext->e_len;
+		else if (flags & EXT2_FALLOCATE_ZERO_BLOCKS)
+			fillable = max_init_len - left_ext->e_len;
+		else
+			fillable = 0;
+
+		/* User requires init/uninit but extent is uninit/init. */
+		if (((flags & EXT2_FALLOCATE_FORCE_INIT) &&
+		     (left_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT)) ||
+		    ((flags & EXT2_FALLOCATE_FORCE_UNINIT) &&
+		     !(left_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT)))
+			goto try_right;
+
+		if (fillable > range_len)
+			fillable = range_len;
+
+		/* Don't expand an initialized left_ext beyond EOF */
+		x = left_ext->e_lblk + left_ext->e_len - 1;
+		if (!(flags & EXT2_FALLOCATE_INIT_BEYOND_EOF)) {
+			dbg_printf("%s: lend=%llu newlend=%llu eofblk=%llu\n",
+				   __func__, x, x + fillable, eof_blk);
+			if (eof_blk >= x && eof_blk <= x + fillable)
+				fillable = eof_blk - x;
+		}
+
+		if (fillable == 0)
+			goto try_right;
+
+		/* Test if the right edge of the range is already mapped? */
+		if (EXT2FS_CLUSTER_RATIO(fs) > 1) {
+			err = ext2fs_map_cluster_block(fs, ino, inode,
+					x + fillable, &pblk);
+			if (err)
+				goto out;
+			if (pblk)
+				fillable -= 1 + ((x + fillable)
+						 & EXT2FS_CLUSTER_MASK(fs));
+			if (fillable == 0)
+				goto try_right;
+		}
+
+		/* Allocate range of blocks */
+		x = left_ext->e_pblk + left_ext->e_len;
+		err = ext2fs_new_range(fs, EXT2_NEWRANGE_FIXED_GOAL |
+				EXT2_NEWRANGE_EXACT_LENGTH,
+				x, fillable, NULL, &pblk, &plen);
+		if (err)
+			goto try_right;
+		err = claim_range(fs, inode, pblk, plen);
+		if (err)
+			goto out;
+
+		/* Modify left_ext */
+		err = ext2fs_extent_goto(handle, left_ext->e_lblk);
+		if (err)
+			goto out;
+		range_start += plen;
+		range_len -= plen;
+		left_ext->e_len += plen;
+		dbg_print_extent("ext_falloc left+", left_ext);
+		err = ext2fs_extent_replace(handle, 0, left_ext);
+		if (err)
+			goto out;
+		err = ext2fs_extent_fix_parents(handle);
+		if (err)
+			goto out;
+
+		/* Zero blocks if necessary */
+		if (!(left_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT) &&
+		    (flags & EXT2_FALLOCATE_ZERO_BLOCKS)) {
+			err = ext2fs_zero_blocks2(fs, pblk, plen, NULL, NULL);
+			if (err)
+				goto out;
+		}
+	}
+
+try_right:
+	/* Extend the right extent */
+	if (right_ext) {
+		/* How much can we attach to right_ext? */
+		if (right_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT)
+			fillable = max_uninit_len - right_ext->e_len;
+		else if (flags & EXT2_FALLOCATE_ZERO_BLOCKS)
+			fillable = max_init_len - right_ext->e_len;
+		else
+			fillable = 0;
+
+		/* User requires init/uninit but extent is uninit/init. */
+		if (((flags & EXT2_FALLOCATE_FORCE_INIT) &&
+		     (right_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT)) ||
+		    ((flags & EXT2_FALLOCATE_FORCE_UNINIT) &&
+		     !(right_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT)))
+			goto try_anywhere;
+
+		if (fillable > range_len)
+			fillable = range_len;
+		if (fillable == 0)
+			goto try_anywhere;
+
+		/* Test if the left edge of the range is already mapped? */
+		if (EXT2FS_CLUSTER_RATIO(fs) > 1) {
+			err = ext2fs_map_cluster_block(fs, ino, inode,
+					right_ext->e_lblk - fillable, &pblk);
+			if (err)
+				goto out;
+			if (pblk)
+				fillable -= EXT2FS_CLUSTER_RATIO(fs) -
+						((right_ext->e_lblk - fillable)
+						 & EXT2FS_CLUSTER_MASK(fs));
+			if (fillable == 0)
+				goto try_anywhere;
+		}
+
+		/*
+		 * FIXME: It would be nice if we could handle allocating a
+		 * variable range from a fixed end point instead of just
+		 * skipping to the general allocator if the whole range is
+		 * unavailable.
+		 */
+		err = ext2fs_new_range(fs, EXT2_NEWRANGE_FIXED_GOAL |
+				EXT2_NEWRANGE_EXACT_LENGTH,
+				right_ext->e_pblk - fillable,
+				fillable, NULL, &pblk, &plen);
+		if (err)
+			goto try_anywhere;
+		err = claim_range(fs, inode,
+			      pblk & ~EXT2FS_CLUSTER_MASK(fs),
+			      plen + (pblk & EXT2FS_CLUSTER_MASK(fs)));
+		if (err)
+			goto out;
+
+		/* Modify right_ext */
+		err = ext2fs_extent_goto(handle, right_ext->e_lblk);
+		if (err)
+			goto out;
+		range_len -= plen;
+		right_ext->e_lblk -= plen;
+		right_ext->e_pblk -= plen;
+		right_ext->e_len += plen;
+		dbg_print_extent("ext_falloc right+", right_ext);
+		err = ext2fs_extent_replace(handle, 0, right_ext);
+		if (err)
+			goto out;
+		err = ext2fs_extent_fix_parents(handle);
+		if (err)
+			goto out;
+
+		/* Zero blocks if necessary */
+		if (!(right_ext->e_flags & EXT2_EXTENT_FLAGS_UNINIT) &&
+		    (flags & EXT2_FALLOCATE_ZERO_BLOCKS)) {
+			err = ext2fs_zero_blocks2(fs, pblk,
+					plen + cluster_fill, NULL, NULL);
+			if (err)
+				goto out;
+		}
+	}
+
+try_anywhere:
+	/* Try implied cluster alloc on the left and right ends */
+	if (range_len > 0 && (range_start & EXT2FS_CLUSTER_MASK(fs))) {
+		cluster_fill = EXT2FS_CLUSTER_RATIO(fs) -
+			       (range_start & EXT2FS_CLUSTER_MASK(fs));
+		cluster_fill &= EXT2FS_CLUSTER_MASK(fs);
+		if (cluster_fill > range_len)
+			cluster_fill = range_len;
+		newex.e_lblk = range_start;
+		err = ext2fs_map_cluster_block(fs, ino, inode, newex.e_lblk,
+					       &pblk);
+		if (err)
+			goto out;
+		if (pblk == 0)
+			goto try_right_implied;
+		newex.e_pblk = pblk;
+		newex.e_len = cluster_fill;
+		newex.e_flags = (flags & EXT2_FALLOCATE_FORCE_INIT ? 0 :
+				 EXT2_EXTENT_FLAGS_UNINIT);
+		dbg_print_extent("ext_falloc iclus left+", &newex);
+		ext2fs_extent_goto(handle, newex.e_lblk);
+		err = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT,
+					&ex);
+		if (err == EXT2_ET_NO_CURRENT_NODE)
+			ex.e_lblk = 0;
+		else if (err)
+			goto out;
+
+		if (ex.e_lblk > newex.e_lblk)
+			op = 0; /* insert before */
+		else
+			op = EXT2_EXTENT_INSERT_AFTER;
+		dbg_printf("%s: inserting %s lblk %llu newex=%llu\n",
+			   __func__, op ? "after" : "before", ex.e_lblk,
+			   newex.e_lblk);
+		err = ext2fs_extent_insert(handle, op, &newex);
+		if (err)
+			goto out;
+		err = ext2fs_extent_fix_parents(handle);
+		if (err)
+			goto out;
+
+		if (!(newex.e_flags & EXT2_EXTENT_FLAGS_UNINIT) &&
+		    (flags & EXT2_FALLOCATE_ZERO_BLOCKS)) {
+			err = ext2fs_zero_blocks2(fs, newex.e_pblk,
+						  newex.e_len, NULL, NULL);
+			if (err)
+				goto out;
+		}
+
+		range_start += cluster_fill;
+		range_len -= cluster_fill;
+	}
+
+try_right_implied:
+	y = range_start + range_len;
+	if (range_len > 0 && (y & EXT2FS_CLUSTER_MASK(fs))) {
+		cluster_fill = y & EXT2FS_CLUSTER_MASK(fs);
+		if (cluster_fill > range_len)
+			cluster_fill = range_len;
+		newex.e_lblk = y & ~EXT2FS_CLUSTER_MASK(fs);
+		err = ext2fs_map_cluster_block(fs, ino, inode, newex.e_lblk,
+					       &pblk);
+		if (err)
+			goto out;
+		if (pblk == 0)
+			goto no_implied;
+		newex.e_pblk = pblk;
+		newex.e_len = cluster_fill;
+		newex.e_flags = (flags & EXT2_FALLOCATE_FORCE_INIT ? 0 :
+				 EXT2_EXTENT_FLAGS_UNINIT);
+		dbg_print_extent("ext_falloc iclus right+", &newex);
+		ext2fs_extent_goto(handle, newex.e_lblk);
+		err = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT,
+					&ex);
+		if (err == EXT2_ET_NO_CURRENT_NODE)
+			ex.e_lblk = 0;
+		else if (err)
+			goto out;
+
+		if (ex.e_lblk > newex.e_lblk)
+			op = 0; /* insert before */
+		else
+			op = EXT2_EXTENT_INSERT_AFTER;
+		dbg_printf("%s: inserting %s lblk %llu newex=%llu\n",
+			   __func__, op ? "after" : "before", ex.e_lblk,
+			   newex.e_lblk);
+		err = ext2fs_extent_insert(handle, op, &newex);
+		if (err)
+			goto out;
+		err = ext2fs_extent_fix_parents(handle);
+		if (err)
+			goto out;
+
+		if (!(newex.e_flags & EXT2_EXTENT_FLAGS_UNINIT) &&
+		    (flags & EXT2_FALLOCATE_ZERO_BLOCKS)) {
+			err = ext2fs_zero_blocks2(fs, newex.e_pblk,
+						  newex.e_len, NULL, NULL);
+			if (err)
+				goto out;
+		}
+
+		range_len -= cluster_fill;
+	}
+
+no_implied:
+	if (range_len == 0)
+		return 0;
+
+	newex.e_lblk = range_start;
+	if (flags & EXT2_FALLOCATE_FORCE_INIT) {
+		max_extent_len = max_init_len;
+		newex.e_flags = 0;
+	} else {
+		max_extent_len = max_uninit_len;
+		newex.e_flags = EXT2_EXTENT_FLAGS_UNINIT;
+	}
+	pblk = alloc_goal;
+	y = range_len;
+	for (x = 0; x < y;) {
+		cluster_fill = newex.e_lblk & EXT2FS_CLUSTER_MASK(fs);
+		fillable = min(range_len + cluster_fill, max_extent_len);
+		err = ext2fs_new_range(fs, 0, pblk & ~EXT2FS_CLUSTER_MASK(fs),
+				       fillable,
+				       NULL, &pblk, &plen);
+		if (err)
+			goto out;
+		err = claim_range(fs, inode, pblk, plen);
+		if (err)
+			goto out;
+
+		/* Create extent */
+		newex.e_pblk = pblk + cluster_fill;
+		newex.e_len = plen - cluster_fill;
+		dbg_print_extent("ext_falloc create", &newex);
+		ext2fs_extent_goto(handle, newex.e_lblk);
+		err = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT,
+					&ex);
+		if (err == EXT2_ET_NO_CURRENT_NODE)
+			ex.e_lblk = 0;
+		else if (err)
+			goto out;
+
+		if (ex.e_lblk > newex.e_lblk)
+			op = 0; /* insert before */
+		else
+			op = EXT2_EXTENT_INSERT_AFTER;
+		dbg_printf("%s: inserting %s lblk %llu newex=%llu\n",
+			   __func__, op ? "after" : "before", ex.e_lblk,
+			   newex.e_lblk);
+		err = ext2fs_extent_insert(handle, op, &newex);
+		if (err)
+			goto out;
+		err = ext2fs_extent_fix_parents(handle);
+		if (err)
+			goto out;
+
+		if (!(newex.e_flags & EXT2_EXTENT_FLAGS_UNINIT) &&
+		    (flags & EXT2_FALLOCATE_ZERO_BLOCKS)) {
+			err = ext2fs_zero_blocks2(fs, pblk, plen, NULL, NULL);
+			if (err)
+				goto out;
+		}
+
+		/* Update variables at end of loop */
+		x += plen - cluster_fill;
+		range_len -= plen - cluster_fill;
+		newex.e_lblk += plen - cluster_fill;
+		pblk += plen - cluster_fill;
+		if (pblk >= ext2fs_blocks_count(fs->super))
+			pblk = fs->super->s_first_data_block;
+	}
+
+out:
+	return err;
+}
+
+static errcode_t extent_fallocate(ext2_filsys fs, int flags, ext2_ino_t ino,
+				      struct ext2_inode *inode,
+				      blk64_t start, blk64_t len)
+{
+	ext2_extent_handle_t	handle;
+	struct ext2fs_extent	left_extent, right_extent;
+	struct ext2fs_extent	*left_adjacent, *right_adjacent;
+	errcode_t		err;
+	blk64_t			range_start, range_end = 0, end, next;
+	blk64_t			count, goal, goal_distance;
+
+	end = start + len - 1;
+	err = ext2fs_extent_open2(fs, ino, inode, &handle);
+	if (err)
+		return err;
+
+	/*
+	 * Find the extent closest to the start of the alloc range.  We don't
+	 * check the return value because _goto() sets the current node to the
+	 * next-lowest extent if 'start' is in a hole; or the next-highest
+	 * extent if there aren't any lower ones; or doesn't set a current node
+	 * if there was a real error reading the extent tree.  In that case,
+	 * _get() will error out.
+	 */
+start_again:
+	ext2fs_extent_goto(handle, start);
+	err = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT, &left_extent);
+	if (err == EXT2_ET_NO_CURRENT_NODE) {
+		blk64_t max_blocks = ext2fs_blocks_count(fs->super);
+		goal = ext2fs_find_inode_goal(fs, ino);
+		err = ext2fs_find_first_zero_block_bitmap2(fs->block_map,
+						goal, max_blocks - 1, &goal);
+		goal += start;
+		err = ext_falloc_helper(fs, flags, ino, inode, handle, NULL,
+					NULL, start, len, goal);
+		goto errout;
+	} else if (err)
+		goto errout;
+
+	dbg_print_extent("ext_falloc initial", &left_extent);
+	next = left_extent.e_lblk + left_extent.e_len;
+	if (left_extent.e_lblk > start) {
+		/* The nearest extent we found was beyond start??? */
+		goal = left_extent.e_pblk - (left_extent.e_lblk - start);
+		err = ext_falloc_helper(fs, flags, ino, inode, handle, NULL,
+					&left_extent, start,
+					left_extent.e_lblk - start, goal);
+		if (err)
+			goto errout;
+
+		goto start_again;
+	} else if (next >= start) {
+		range_start = next;
+		left_adjacent = &left_extent;
+	} else {
+		range_start = start;
+		left_adjacent = NULL;
+	}
+	goal = left_extent.e_pblk + (range_start - left_extent.e_lblk);
+	goal_distance = range_start - next;
+
+	do {
+		err = ext2fs_extent_get(handle, EXT2_EXTENT_NEXT_LEAF,
+					   &right_extent);
+		dbg_printf("%s: ino=%d get next =%d\n", __func__, ino,
+			   (int)err);
+		dbg_print_extent("ext_falloc next", &right_extent);
+		/* Stop if we've seen this extent before */
+		if (!err && right_extent.e_lblk <= left_extent.e_lblk)
+			err = EXT2_ET_EXTENT_NO_NEXT;
+
+		if (err && err != EXT2_ET_EXTENT_NO_NEXT)
+			goto errout;
+		if (err == EXT2_ET_EXTENT_NO_NEXT ||
+		    right_extent.e_lblk > end + 1) {
+			range_end = end;
+			right_adjacent = NULL;
+		} else {
+			/* Handle right_extent.e_lblk <= end */
+			range_end = right_extent.e_lblk - 1;
+			right_adjacent = &right_extent;
+		}
+		if (err != EXT2_ET_EXTENT_NO_NEXT &&
+		    goal_distance > (range_end - right_extent.e_lblk)) {
+			goal = right_extent.e_pblk -
+					(right_extent.e_lblk - range_start);
+			goal_distance = range_end - right_extent.e_lblk;
+		}
+
+		dbg_printf("%s: ino=%d rstart=%llu rend=%llu\n", __func__, ino,
+			   range_start, range_end);
+		err = 0;
+		if (range_start <= range_end) {
+			count = range_end - range_start + 1;
+			err = ext_falloc_helper(fs, flags, ino, inode, handle,
+						left_adjacent, right_adjacent,
+						range_start, count, goal);
+			if (err)
+				goto errout;
+		}
+
+		if (range_end == end)
+			break;
+
+		err = ext2fs_extent_goto(handle, right_extent.e_lblk);
+		if (err)
+			goto errout;
+		next = right_extent.e_lblk + right_extent.e_len;
+		left_extent = right_extent;
+		left_adjacent = &left_extent;
+		range_start = next;
+		goal = left_extent.e_pblk + (range_start - left_extent.e_lblk);
+		goal_distance = range_start - next;
+	} while (range_end < end);
+
+errout:
+	ext2fs_zero_blocks2(NULL, 0, 0, NULL, NULL);
+	ext2fs_extent_free(handle);
+	return err;
+}
+
+errcode_t ext2fs_fallocate(ext2_filsys fs, int flags, ext2_ino_t ino,
+			   struct ext2_inode *inode,
+			   blk64_t start, blk64_t len)
+{
+	struct ext2_inode	inode_buf;
+	blk64_t			blk, x;
+	errcode_t		err;
+
+	if (((flags & EXT2_FALLOCATE_FORCE_INIT) &&
+	    (flags & EXT2_FALLOCATE_FORCE_UNINIT)) ||
+	   (flags & ~EXT2_FALLOCATE_ALL_FLAGS))
+		return EXT2_ET_INVALID_ARGUMENT;
+
+	if (len > ext2fs_blocks_count(fs->super))
+		return EXT2_ET_BLOCK_ALLOC_FAIL;
+	else if (len == 0)
+		return 0;
+
+	/* Read inode structure if necessary */
+	if (!inode) {
+		err = ext2fs_read_inode(fs, ino, &inode_buf);
+		if (err)
+			return err;
+		inode = &inode_buf;
+	}
+	dbg_printf("%s: ino=%d start=%llu len=%llu\n", __func__, ino, start,
+		   len);
+
+	if (inode->i_flags & EXT4_EXTENTS_FL) {
+		err = extent_fallocate(fs, flags, ino, inode, start, len);
+		goto out;
+	}
+
+	/* XXX: Allocate a bunch of blocks the slow way */
+	for (blk = start; blk <= start + len; blk++) {
+		err = ext2fs_bmap2(fs, ino, inode, NULL, 0, blk, 0, &x);
+		if (err)
+			return err;
+		if (x)
+			continue;
+
+		err = ext2fs_bmap2(fs, ino, inode, NULL,
+				   BMAP_ALLOC | BMAP_UNINIT, blk, 0, &x);
+		if (err)
+			return err;
+	}
+
+out:
+	if (inode == &inode_buf)
+		ext2fs_write_inode(fs, ino, inode);
+	return err;
+}
diff --git a/misc/mk_hugefiles.c b/misc/mk_hugefiles.c
index d4dadc4..19892c5 100644
--- a/misc/mk_hugefiles.c
+++ b/misc/mk_hugefiles.c
@@ -144,84 +144,20 @@ static errcode_t mk_hugefile(ext2_filsys fs, blk64_t num,
 
 	ext2fs_inode_alloc_stats2(fs, *ino, +1, 0);
 
-	retval = ext2fs_extent_open2(fs, *ino, &inode, &handle);
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				      EXT3_FEATURE_INCOMPAT_EXTENTS))
+		inode.i_flags |= EXT4_EXTENTS_FL;
+	retval = ext2fs_fallocate(fs,
+				  EXT2_FALLOCATE_FORCE_INIT |
+				  EXT2_FALLOCATE_ZERO_BLOCKS,
+				  *ino, &inode, 0, num);
 	if (retval)
 		return retval;
-
-	lblk = 0;
-	left = num ? num : 1;
-	while (left) {
-		blk64_t pblk, end;
-		blk64_t n = left;
-
-		retval =  ext2fs_find_first_zero_block_bitmap2(fs->block_map,
-			goal, ext2fs_blocks_count(fs->super) - 1, &end);
-		if (retval)
-			goto errout;
-		goal = end;
-
-		retval =  ext2fs_find_first_set_block_bitmap2(fs->block_map, goal,
-			       ext2fs_blocks_count(fs->super) - 1, &bend);
-		if (retval == ENOENT) {
-			bend = ext2fs_blocks_count(fs->super);
-			if (num == 0)
-				left = 0;
-		}
-		if (!num || bend - goal < left)
-			n = bend - goal;
-		pblk = goal;
-		if (num)
-			left -= n;
-		goal += n;
-		count += n;
-		ext2fs_block_alloc_stats_range(fs, pblk, n, +1);
-
-		if (zero_hugefile) {
-			blk64_t ret_blk;
-			retval = ext2fs_zero_blocks2(fs, pblk, n,
-						     &ret_blk, NULL);
-
-			if (retval)
-				com_err(program_name, retval,
-					_("while zeroing block %llu "
-					  "for hugefile"), ret_blk);
-		}
-
-		while (n) {
-			blk64_t l = n;
-			struct ext2fs_extent newextent;
-
-			if (l > EXT_INIT_MAX_LEN)
-				l = EXT_INIT_MAX_LEN;
-
-			newextent.e_len = l;
-			newextent.e_pblk = pblk;
-			newextent.e_lblk = lblk;
-			newextent.e_flags = 0;
-
-			retval = ext2fs_extent_insert(handle,
-					EXT2_EXTENT_INSERT_AFTER, &newextent);
-			if (retval)
-				return retval;
-			pblk += l;
-			lblk += l;
-			n -= l;
-		}
-	}
-
-	retval = ext2fs_read_inode(fs, *ino, &inode);
+	retval = ext2fs_inode_set_size(fs, &inode, num * fs->blocksize);
 	if (retval)
-		goto errout;
