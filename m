From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 33/47] e2fsck: rebuild sparse extent trees/convert
 non-extent ext3 files
Date: Fri, 07 Nov 2014 13:54:20 -0800
Message-ID: <20141107215420.883.75094.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46331 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaKGVyZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:54:25 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Teach e2fsck to construct extent trees.  This enables us to do either
of the following: compress a highly sparse extent tree into fewer ETB
blocks; or convert a ext3-style block mapped file to an extent file.

For files that are already extent based, this algorithm will only run
if pass1 determines either (1) that a whole level of extent tree will
fit into a higher level of the tree; (2) that the size of any level
can be reduced by at least one ETB block; or (3) the extent tree is
unnecessarily deep.  It will not run at all if errors are found and
the user declines to fix the errors.

For block-mapped files, conversion only happens if the extent feature
is enabled and "-E bmap2extent" is passed to e2fsck.  It will not run
at all if errors are left unfixed.  After conversion, files larger
than 12 blocks should be defragmented to eliminate empty holes where a
block lives.

The extent tree constructor is pretty dumb -- it creates a list of
leaf extents (adjacent extents are collapsed), marks all indirect
blocks / ETB blocks free, installs a new extent tree root in the
inode, then loads the leaf extents into the tree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/Makefile.in                     |   16 +
 e2fsck/e2fsck.8.in                     |    3 
 e2fsck/e2fsck.c                        |    2 
 e2fsck/e2fsck.h                        |   11 +
 e2fsck/extents.c                       |  352 ++++++++++++++++++++++++++++++++
 e2fsck/pass1.c                         |   95 ++++++++-
 e2fsck/problem.c                       |   43 ++++
 e2fsck/problem.h                       |   28 +++
 e2fsck/super.c                         |    7 +
 e2fsck/unix.c                          |    4 
 tests/f_extent_bad_node/expect.1       |    9 +
 tests/f_extent_bad_node/expect.2       |    2 
 tests/f_extent_int_bad_magic/expect.1  |    3 
 tests/f_extent_leaf_bad_magic/expect.1 |    3 
 tests/f_extent_oobounds/expect.1       |    9 +
 tests/f_extent_oobounds/expect.2       |    2 
 tests/f_extents/expect.1               |    5 
 17 files changed, 577 insertions(+), 17 deletions(-)
 create mode 100644 e2fsck/extents.c


diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index e40e51b..a4413d9 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -62,7 +62,8 @@ OBJS= dict.o unix.o e2fsck.o super.o pass1.o pass1b.o pass2.o \
 	pass3.o pass4.o pass5.o journal.o badblocks.o util.o dirinfo.o \
 	dx_dirinfo.o ehandler.o problem.o message.o quota.o recovery.o \
 	region.o revoke.o ea_refcount.o rehash.o profile.o prof_err.o \
-	logfile.o sigcatcher.o $(MTRACE_OBJ) plausible.o readahead.o
+	logfile.o sigcatcher.o $(MTRACE_OBJ) plausible.o readahead.o \
+	extents.o
 
 PROFILED_OBJS= profiled/dict.o profiled/unix.o profiled/e2fsck.o \
 	profiled/super.o profiled/pass1.o profiled/pass1b.o \
@@ -74,7 +75,7 @@ PROFILED_OBJS= profiled/dict.o profiled/unix.o profiled/e2fsck.o \
 	profiled/ea_refcount.o profiled/rehash.o profiled/profile.o \
 	profiled/prof_err.o profiled/logfile.o \
 	profiled/sigcatcher.o profiled/plausible.o \
-	profiled/sigcatcher.o profiled/readahead.o
+	profiled/sigcatcher.o profiled/readahead.o profiled/extents.o
 
 SRCS= $(srcdir)/e2fsck.c \
 	$(srcdir)/dict.c \
@@ -106,6 +107,7 @@ SRCS= $(srcdir)/e2fsck.c \
 	prof_err.c \
 	$(srcdir)/quota.c \
 	$(srcdir)/../misc/plausible.c \
+	$(srcdir)/extents.c \
 	$(MTRACE_SRC)
 
 all:: profiled $(PROGS) e2fsck $(MANPAGES) $(FMANPAGES)
@@ -308,6 +310,16 @@ pass1.o: $(srcdir)/pass1.c $(top_builddir)/lib/config.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
  $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
  $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/problem.h
+extents.o: $(srcdir)/extents.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/et/com_err.h \
+ $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
+ $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/problem.h $(srcdir)/dict.h
 pass1b.o: $(srcdir)/pass1b.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
index 84ae50f..0c2725e 100644
--- a/e2fsck/e2fsck.8.in
+++ b/e2fsck/e2fsck.8.in
@@ -214,6 +214,9 @@ e2fsck runtime.  By default, this is set to the size of a block group's inode
 table (typically 2MiB on a regular ext4 filesystem); if this amount is more
 than 1/100 of total physical memory, readahead is disabled.  Set this to zero
 to disable readahead entirely.
+.TP
+.BI bmap2extent
+Convert block-mapped files to extent-mapped files.
 .RE
 .TP
 .B \-f
diff --git a/e2fsck/e2fsck.c b/e2fsck/e2fsck.c
index fcda7d7..83506cb 100644
--- a/e2fsck/e2fsck.c
+++ b/e2fsck/e2fsck.c
@@ -204,7 +204,7 @@ void e2fsck_free_context(e2fsck_t ctx)
 typedef void (*pass_t)(e2fsck_t ctx);
 
 static pass_t e2fsck_passes[] = {
-	e2fsck_pass1, e2fsck_pass2, e2fsck_pass3, e2fsck_pass4,
+	e2fsck_pass1, e2fsck_pass1e, e2fsck_pass2, e2fsck_pass3, e2fsck_pass4,
 	e2fsck_pass5, 0 };
 
 #define E2F_FLAG_RUN_RETURN	(E2F_FLAG_SIGNAL_MASK|E2F_FLAG_RESTART)
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index e359515..66d71ee 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -167,6 +167,7 @@ struct resource_track {
 #define E2F_OPT_FRAGCHECK	0x0800
 #define E2F_OPT_JOURNAL_ONLY	0x1000 /* only replay the journal */
 #define E2F_OPT_DISCARD		0x2000
+#define E2F_OPT_CONVERT_BMAP	0x4000 /* convert blockmap to extent */
 
 /*
  * E2fsck flags
@@ -381,6 +382,11 @@ struct e2fsck_struct {
 
 	/* How much are we allowed to readahead? */
 	unsigned long long readahead_kb;
+
+	/*
+	 * Inodes to rebuild extent trees
+	 */
+	ext2fs_inode_bitmap inodes_to_rebuild;
 };
 
 /* Used by the region allocation code */
@@ -456,6 +462,11 @@ extern blk64_t ea_refcount_intr_next(ext2_refcount_t refcount, int *ret);
 extern const char *ehandler_operation(const char *op);
 extern void ehandler_init(io_channel channel);
 
+/* extents.c */
+void e2fsck_rebuild_extents_later(e2fsck_t ctx, ext2_ino_t ino);
+int e2fsck_ino_will_be_rebuilt(e2fsck_t ctx, ext2_ino_t ino);
+void e2fsck_pass1e(e2fsck_t ctx);
+
 /* journal.c */
 extern errcode_t e2fsck_check_ext3_journal(e2fsck_t ctx);
 extern errcode_t e2fsck_run_ext3_journal(e2fsck_t ctx);
diff --git a/e2fsck/extents.c b/e2fsck/extents.c
new file mode 100644
index 0000000..91d36d2
--- /dev/null
+++ b/e2fsck/extents.c
@@ -0,0 +1,352 @@
+/*
+ * extents.c --- rebuild extent tree
+ *
+ * Copyright (C) 2014 Oracle.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include "config.h"
+#include <string.h>
+#include <ctype.h>
+#include <errno.h>
+#include "e2fsck.h"
+#include "problem.h"
+
+#undef DEBUG
+#undef DEBUG_SUMMARY
+#undef DEBUG_FREE
+
+#define NUM_EXTENTS	341	/* about one ETB' worth of extents */
+
+/* Schedule an inode to have its extent tree rebuilt during pass 1E. */
+void e2fsck_rebuild_extents_later(e2fsck_t ctx, ext2_ino_t ino)
+{
+	if (!EXT2_HAS_INCOMPAT_FEATURE(ctx->fs->super,
+				       EXT3_FEATURE_INCOMPAT_EXTENTS) ||
+	    (ctx->options & E2F_OPT_NO) ||
+	    (ino != EXT2_ROOT_INO && ino < ctx->fs->super->s_first_ino))
+		return;
+	if (!ctx->inodes_to_rebuild)
+		e2fsck_allocate_inode_bitmap(ctx->fs,
+					     _("extent rebuild inode map"),
+					     EXT2FS_BMAP64_AUTODIR,
+					     "inodes_to_rebuild",
+					     &ctx->inodes_to_rebuild);
+	if (ctx->inodes_to_rebuild)
+		ext2fs_mark_inode_bitmap2(ctx->inodes_to_rebuild, ino);
+}
+
+/* Ask if an inode will have its extents rebuilt during pass 1E. */
+int e2fsck_ino_will_be_rebuilt(e2fsck_t ctx, ext2_ino_t ino)
+{
+	if (!ctx->inodes_to_rebuild)
+		return 0;
+	return ext2fs_test_inode_bitmap2(ctx->inodes_to_rebuild, ino);
+}
+
+struct extent_list {
+	blk64_t blocks_freed;
+	struct ext2fs_extent *extents;
+	unsigned int count;
+	unsigned int size;
+	unsigned int ext_read;
+	errcode_t retval;
+	ext2_ino_t ino;
+};
+
+static errcode_t load_extents(e2fsck_t ctx, struct extent_list *list)
+{
+	ext2_filsys		fs = ctx->fs;
+	ext2_extent_handle_t	handle;
+	struct ext2fs_extent	extent;
+	errcode_t		retval;
+
+	retval = ext2fs_extent_open(fs, list->ino, &handle);
+	if (retval)
+		return retval;
+
+	retval = ext2fs_extent_get(handle, EXT2_EXTENT_ROOT, &extent);
+	if (retval)
+		goto out;
+
+	do {
+		if (extent.e_flags & EXT2_EXTENT_FLAGS_SECOND_VISIT)
+			goto next;
+
+		/* Internal node; free it and we'll re-allocate it later */
+		if (!(extent.e_flags & EXT2_EXTENT_FLAGS_LEAF)) {
+#if defined(DEBUG) || defined(DEBUG_FREE)
+			printf("ino=%d free=%llu bf=%llu\n", list->ino,
+					extent.e_pblk, list->blocks_freed + 1);
+#endif
+			list->blocks_freed++;
+			ext2fs_block_alloc_stats2(fs, extent.e_pblk, -1);
+			goto next;
+		}
+
+		list->ext_read++;
+		/* Can we attach it to the previous extent? */
+		if (list->count) {
+			struct ext2fs_extent *last = list->extents + 
+						     list->count - 1;
+			blk64_t end = last->e_len + extent.e_len;
+
+			if (last->e_pblk + last->e_len == extent.e_pblk &&
+			    last->e_lblk + last->e_len == extent.e_lblk &&
+			    (last->e_flags & EXT2_EXTENT_FLAGS_UNINIT) ==
+			    (extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT) &&
+			    end < (1ULL << 32)) {
+				last->e_len += extent.e_len;
+#ifdef DEBUG
+				printf("R: ino=%d len=%u\n", list->ino,
+						last->e_len);
+#endif
+				goto next;
+			}
+		}
+
+		/* Do we need to expand? */
+		if (list->count == list->size) {
+			unsigned int new_size = (list->size + NUM_EXTENTS) *
+						sizeof(struct ext2fs_extent);
+			retval = ext2fs_resize_mem(0, new_size, &list->extents);
+			if (retval)
+				goto out;
+			list->size += NUM_EXTENTS;
+		}
+
+		/* Add a new extent */
+		memcpy(list->extents + list->count, &extent, sizeof(extent));
+#ifdef DEBUG
+		printf("R: ino=%d pblk=%llu lblk=%llu len=%u\n", list->ino,
+				extent.e_pblk, extent.e_lblk, extent.e_len);
+#endif
+		list->count++;
+next:
+		retval = ext2fs_extent_get(handle, EXT2_EXTENT_NEXT, &extent);
+	} while (retval == 0);
+
+out:
+	/* Ok if we run off the end */
+	if (retval == EXT2_ET_EXTENT_NO_NEXT)
+		retval = 0;
+	ext2fs_extent_free(handle);
+	return retval;
+}
+
+static int find_blocks(ext2_filsys fs, blk64_t *blocknr, e2_blkcnt_t blockcnt,
+		       blk64_t ref_blk, int ref_offset, void *priv_data)
+{
+	struct extent_list *list = priv_data;
+
+	/* Internal node? */
+	if (blockcnt < 0) {
+#if defined(DEBUG) || defined(DEBUG_FREE)
+		printf("ino=%d free=%llu bf=%llu\n", list->ino, *blocknr,
+				list->blocks_freed + 1);
+#endif
+		list->blocks_freed++;
+		ext2fs_block_alloc_stats2(fs, *blocknr, -1);
+		return 0;
+	}
+
+	/* Can we attach it to the previous extent? */
+	if (list->count) {
+		struct ext2fs_extent *last = list->extents + 
+					     list->count - 1;
+		blk64_t end = last->e_len + 1;
+
+		if (last->e_pblk + last->e_len == *blocknr &&
+		    end < (1ULL << 32)) {
+			last->e_len++;
+#ifdef DEBUG
+			printf("R: ino=%d len=%u\n", list->ino, last->e_len);
+#endif
+			return 0;
+		}
+	}
+
+	/* Do we need to expand? */
+	if (list->count == list->size) {
+		unsigned int new_size = (list->size + NUM_EXTENTS) *
+					sizeof(struct ext2fs_extent);
+		list->retval = ext2fs_resize_mem(0, new_size, &list->extents);
+		if (list->retval)
+			return BLOCK_ABORT;
+		list->size += NUM_EXTENTS;
+	}
+
+	/* Add a new extent */
+	list->extents[list->count].e_pblk = *blocknr;
+	list->extents[list->count].e_lblk = blockcnt;
+	list->extents[list->count].e_len = 1;
+	list->extents[list->count].e_flags = 0;
+#ifdef DEBUG
+	printf("R: ino=%d pblk=%llu lblk=%llu len=%u\n", list->ino, *blocknr,
+			blockcnt, 1);
+#endif
+	list->count++;
+
+	return 0;
+}
+
+static errcode_t rebuild_extent_tree(e2fsck_t ctx, struct extent_list *list,
+				     ext2_ino_t ino)
+{
+	struct ext2_inode	inode;
+	errcode_t		retval;
+	ext2_extent_handle_t	handle;
+	unsigned int		i, ext_written;
+	struct ext2fs_extent	*ex, extent;
+
+	list->count = 0;
+	list->blocks_freed = 0;
+	list->ino = ino;
+	list->ext_read = 0;
+	e2fsck_read_inode(ctx, ino, &inode, "rebuild_extents");
+
+	/* Collect lblk->pblk mappings */
+	if (inode.i_flags & EXT4_EXTENTS_FL) {
+		retval = load_extents(ctx, list);
+		goto extents_loaded;
+	}
+
+	retval = ext2fs_block_iterate3(ctx->fs, ino, BLOCK_FLAG_READ_ONLY, 0,
+				       find_blocks, list);
+	if (retval)
+		goto err;
+	if (list->retval) {
+		retval = list->retval;
+		goto err;
+	}
+
+extents_loaded:
+	/* Reset extent tree */
+	inode.i_flags &= ~EXT4_EXTENTS_FL;
+	memset(inode.i_block, 0, sizeof(inode.i_block));
+
+	/* Make a note of freed blocks */
+	retval = ext2fs_iblk_sub_blocks(ctx->fs, &inode, list->blocks_freed);
+	if (retval)
+		goto err;
+
+	/* Now stuff extents into the file */
+	retval = ext2fs_extent_open2(ctx->fs, ino, &inode, &handle);
+	if (retval)
+		goto err;
+
+	ext_written = 0;
+	for (i = 0, ex = list->extents; i < list->count; i++, ex++) {
+		memcpy(&extent, ex, sizeof(struct ext2fs_extent));
+		extent.e_flags &= EXT2_EXTENT_FLAGS_UNINIT;
+		if (extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT) {
+			if (extent.e_len > EXT_UNINIT_MAX_LEN) {
+				extent.e_len = EXT_UNINIT_MAX_LEN;
+				ex->e_pblk += EXT_UNINIT_MAX_LEN;
+				ex->e_lblk += EXT_UNINIT_MAX_LEN;
+				ex->e_len -= EXT_UNINIT_MAX_LEN;
+				ex--;
+				i--;
+			}
+		} else {
+			if (extent.e_len > EXT_INIT_MAX_LEN) {
+				extent.e_len = EXT_INIT_MAX_LEN;
+				ex->e_pblk += EXT_INIT_MAX_LEN;
+				ex->e_lblk += EXT_INIT_MAX_LEN;
+				ex->e_len -= EXT_INIT_MAX_LEN;
+				ex--;
+				i--;
+			}
+		}
+
+#ifdef DEBUG
+		printf("W: ino=%d pblk=%llu lblk=%llu len=%u\n", ino,
+				extent.e_pblk, extent.e_lblk, extent.e_len);
+#endif
+		retval = ext2fs_extent_insert(handle, EXT2_EXTENT_INSERT_AFTER,
+					      &extent);
+		if (retval)
+			goto err2;
+		retval = ext2fs_extent_fix_parents(handle);
+		if (retval)
+			goto err2;
+		ext_written++;
+	}
+
+#if defined(DEBUG) || defined(DEBUG_SUMMARY)
+	printf("rebuild: ino=%d extents=%d->%d\n", ino, list->ext_read,
+	       ext_written);
+#endif
+	e2fsck_write_inode(ctx, ino, &inode, "rebuild_extents");
+
+err2:
+	ext2fs_extent_free(handle);
+err:
+	return retval;
+}
+
+void e2fsck_pass1e(e2fsck_t ctx)
+{
+	struct problem_context	pctx;
+#ifdef RESOURCE_TRACK
+	struct resource_track	rtrack;
+#endif
+	struct extent_list	list;
+	int			first = 1;
+	ext2_ino_t		ino = 0;
+	errcode_t		retval;
+
+	if (!EXT2_HAS_INCOMPAT_FEATURE(ctx->fs->super,
+				       EXT3_FEATURE_INCOMPAT_EXTENTS) ||
+	    !ext2fs_test_valid(ctx->fs) ||
+	    ctx->invalid_bitmaps) {
+		if (ctx->inodes_to_rebuild)
+			ext2fs_free_inode_bitmap(ctx->inodes_to_rebuild);
+		ctx->inodes_to_rebuild = NULL;
+	}
+
+	if (ctx->inodes_to_rebuild == NULL)
+		return;
+
+	init_resource_track(&rtrack, ctx->fs->io);
+	clear_problem_context(&pctx);
+	e2fsck_read_bitmaps(ctx);
+
+	memset(&list, 0, sizeof(list));
+	retval = ext2fs_get_mem(sizeof(struct ext2fs_extent) * NUM_EXTENTS,
+				&list.extents);
+	list.size = NUM_EXTENTS;
+	while (1) {
+		retval = ext2fs_find_first_set_inode_bitmap2(
+				ctx->inodes_to_rebuild, ino + 1,
+				ctx->fs->super->s_inodes_count, &ino);
+		if (retval)
+			break;
+		pctx.ino = ino;
+		if (first) {
+			fix_problem(ctx, PR_1E_PASS_HEADER, &pctx);
+			first = 0;
+		}
+		pctx.errcode = rebuild_extent_tree(ctx, &list, ino);
+		if (pctx.errcode) {
+			end_problem_latch(ctx, PR_LATCH_OPTIMIZE_EXT);
+			fix_problem(ctx, PR_1E_OPTIMIZE_EXT_ERR, &pctx);
+		}
+		if (ctx->progress && !ctx->progress_fd)
+			e2fsck_simple_progress(ctx, "Rebuilding extents",
+					100.0 * (float) ino /
+					(float) ctx->fs->super->s_inodes_count,
+					ino);
+	}
+	end_problem_latch(ctx, PR_LATCH_OPTIMIZE_EXT);
+
+	ext2fs_free_inode_bitmap(ctx->inodes_to_rebuild);
+	ctx->inodes_to_rebuild = NULL;
+	ext2fs_free_mem(&list.extents);
+
+	print_resource_track(ctx, "Pass 1E", &rtrack, ctx->fs->io);
+}
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index a963849..10008d9 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -56,6 +56,8 @@
 #define _INLINE_ inline
 #endif
 
+#undef DEBUG
+
 static int process_block(ext2_filsys fs, blk64_t	*blocknr,
 			 e2_blkcnt_t blockcnt, blk64_t ref_blk,
 			 int ref_offset, void *priv_data);
@@ -77,11 +79,16 @@ static void adjust_extattr_refcount(e2fsck_t ctx, ext2_refcount_t refcount,
 				    char *block_buf, int adjust_sign);
 /* static char *describe_illegal_block(ext2_filsys fs, blk64_t block); */
 
+struct extent_info {
+	unsigned int	num_extents;
+	unsigned int	max_extents;
+};
+
 struct process_block_struct {
 	ext2_ino_t	ino;
 	unsigned	is_dir:1, is_reg:1, clear:1, suppress:1,
 				fragmented:1, compressed:1, bbcheck:1,
-				inode_modified:1;
+				inode_modified:1, extent_rebuild:1;
 	blk64_t		num_blocks;
 	blk64_t		max_blocks;
 	e2_blkcnt_t	last_block;
@@ -95,6 +102,7 @@ struct process_block_struct {
 	e2fsck_t	ctx;
 	blk64_t		bad_ref;
 	region_t	region;
+	struct extent_info	ext_info[MAX_EXTENT_DEPTH_COUNT];
 };
 
 struct process_inode_block {
@@ -2402,6 +2410,53 @@ static int has_unaligned_cluster_map(e2fsck_t ctx,
 	return 0;
 }
 
+static void should_rebuild_extents(e2fsck_t ctx,
+				   struct problem_context *pctx,
+				   struct process_block_struct *pb,
+				   struct ext2_extent_info *info)
+{
+	struct extent_info *ei;
+	int i, j;
+	unsigned int extents_per_block;
+
+	if (pb->extent_rebuild)
+		goto rebuild;
+
+	extents_per_block = (ctx->fs->blocksize -
+			     sizeof(struct ext3_extent_header)) /
+			    sizeof(struct ext3_extent);
+	/*
+	 * If we can consolidate a level or shorten the tree, schedule the
+	 * extent tree to be rebuilt.
+	 */
+	for (i = 0, ei = pb->ext_info; i < info->max_depth + 1; i++, ei++) {
+		if (ei->max_extents - ei->num_extents > extents_per_block) {
+#ifdef DEBUG
+			printf("rebuild extents, ino=%d level=%d slack=%d epb=%d\n",
+					pb->ino, i,
+					ei->max_extents - ei->num_extents,
+					extents_per_block);
+#endif
+			goto rebuild;
+		}
+		for (j = 0; j < i; j++) {
+			if (ei->num_extents < pb->ext_info[j].max_extents) {
+#ifdef DEBUG
+				printf("rebuild extents, ino=%d level=%d num=%d level=%d\n",
+					pb->ino, i, ei->num_extents, j);
+#endif
+				goto rebuild;
+			}
+		}
+	}
+	return;
+
+rebuild:
+	if (pb->extent_rebuild ||
+	    fix_problem(ctx, PR_1E_CAN_COMPRESS_EXTENT_TREE, pctx))
+		e2fsck_rebuild_extents_later(ctx, pb->ino);
+}
+
 static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			     struct process_block_struct *pb,
 			     blk64_t start_block, blk64_t end_block,
@@ -2424,6 +2479,10 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 	pctx->errcode = ext2fs_extent_get_info(ehandle, &info);
 	if (pctx->errcode)
 		return;
+	if (!pb->extent_rebuild) {
+		pb->ext_info[info.curr_level].num_extents += info.num_entries;
+		pb->ext_info[info.curr_level].max_extents += info.max_entries;
+	}
 
 	pctx->errcode = ext2fs_extent_get(ehandle, EXT2_EXTENT_FIRST_SIB,
 					  &extent);
@@ -2760,17 +2819,31 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 
 	retval = ext2fs_extent_get_info(ehandle, &info);
 	if (retval == 0) {
-		if (info.max_depth >= MAX_EXTENT_DEPTH_COUNT)
-			info.max_depth = MAX_EXTENT_DEPTH_COUNT-1;
-		ctx->extent_depth_count[info.max_depth]++;
+		int max_depth = info.max_depth;
+
+		if (max_depth >= MAX_EXTENT_DEPTH_COUNT)
+			max_depth = MAX_EXTENT_DEPTH_COUNT-1;
+		ctx->extent_depth_count[max_depth]++;
 	}
 
+	/* Check maximum extent depth */
+	pctx->blk = info.max_depth;
+	pctx->blk2 = ext2fs_max_extent_depth(ehandle);
+	if (pctx->blk2 < pctx->blk &&
+	    fix_problem(ctx, PR_1_EXTENT_BAD_MAX_DEPTH, pctx))
+		pb->extent_rebuild = 1;
+
+	/* Can we collect extent tree level stats? */
+	pctx->blk = MAX_EXTENT_DEPTH_COUNT;
+	if (pctx->blk2 > pctx->blk)
+		fix_problem(ctx, PR_1E_MAX_EXTENT_TREE_DEPTH, pctx);
+	memset(pb->ext_info, 0, sizeof(pb->ext_info));
+
 	pb->region = region_create(0, info.max_lblk);
 	if (!pb->region) {
-		ext2fs_extent_free(ehandle);
 		fix_problem(ctx, PR_1_EXTENT_ALLOC_REGION_ABORT, pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
-		return;
+		goto out;
 	}
 
 	eof_lblk = ((EXT2_I_SIZE(inode) + fs->blocksize - 1) >>
@@ -2786,7 +2859,9 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 	}
 	region_free(pb->region);
 	pb->region = NULL;
+out:
 	ext2fs_extent_free(ehandle);
+	should_rebuild_extents(ctx, pctx, pb, &info);
 }
 
 /*
@@ -2846,6 +2921,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	pb.ctx = ctx;
 	pb.inode_modified = 0;
 	pb.bad_ref = 0;
+	pb.extent_rebuild = 0;
 	pctx->ino = ino;
 	pctx->errcode = 0;
 
@@ -2909,6 +2985,13 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 						  "check_blocks");
 			fs->flags = (flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) |
 				    (fs->flags & ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
+
+			if (ctx->options & E2F_OPT_CONVERT_BMAP) {
+#ifdef DEBUG
+				printf("bmap rebuild ino=%d\n", ino);
+#endif
+				e2fsck_rebuild_extents_later(ctx, ino);
+			}
 		}
 	}
 	end_problem_latch(ctx, PR_LATCH_BLOCK);
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index a4da64b..75e0305 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1101,6 +1101,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i has a duplicate @x mapping\n\t(logical @b %c, @n physical @b %b, len %N)\n"),
 	  PROMPT_CLEAR, 0 },
 
+	/* Inode extent tree could be more shallow */
+	{ PR_1_EXTENT_BAD_MAX_DEPTH,
+	  N_("@i %i @x tree could be more shallow (%b; could be <= %c)\n"),
+	  PROMPT_FIX, PR_NO_OK | PR_PREEN_NO | PR_PREEN_OK },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
@@ -1198,6 +1203,43 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_1D_CLONE_ERROR,
 	  N_("Couldn't clone file: %m\n"), PROMPT_NONE, 0 },
 
+	/* Pass 1E Extent tree Optimization	*/
+
+	/* Pass 1E: Optimizing extent trees */
+	{ PR_1E_PASS_HEADER,
+	  N_("Pass 1E: Optimizing @x trees\n"),
+	  PROMPT_NONE, PR_PREEN_NOMSG },
+
+	/* Failed to optimize extent tree */
+	{ PR_1E_OPTIMIZE_EXT_ERR,
+	  N_("Failed to optimize @x tree %p (%i): %m\n"),
+	  PROMPT_NONE, 0 },
+
+	/* Rebuilding extent trees */
+	{ PR_1E_OPTIMIZE_EXT_HEADER,
+	  N_("Optimizing @x trees: "),
+	  PROMPT_NONE, PR_MSG_ONLY },
+
+	/* Rebuilding extent tree %d */
+	{ PR_1E_OPTIMIZE_EXT,
+	  " %i",
+	  PROMPT_NONE, PR_LATCH_OPTIMIZE_EXT | PR_PREEN_NOHDR},
+
+	/* Rebuilding extent tree end */
+	{ PR_1E_OPTIMIZE_EXT_END,
+	  "\n",
+	  PROMPT_NONE, PR_PREEN_NOHDR },
+
+	/* Internal error: extent tree depth too large */
+	{ PR_1E_MAX_EXTENT_TREE_DEPTH,
+	  N_("Internal error: max extent tree depth too large (%b; expected=%c).\n"),
+	  PROMPT_NONE, PR_FATAL },
+
+	/* Inode extent tree could be more compact */
+	{ PR_1E_CAN_COMPRESS_EXTENT_TREE,
+	  N_("@i %i @x tree could be more compact.  "),
+	  PROMPT_FIX, PR_NO_OK | PR_PREEN_NO | PR_PREEN_OK },
+
 	/* Pass 2 errors */
 
 	/* Pass 2: Checking directory structure */
@@ -1946,6 +1988,7 @@ static struct latch_descr pr_latch_info[] = {
 	{ PR_LATCH_TOOBIG, PR_1_INODE_TOOBIG, 0 },
 	{ PR_LATCH_OPTIMIZE_DIR, PR_3A_OPTIMIZE_DIR_HEADER, PR_3A_OPTIMIZE_DIR_END },
 	{ PR_LATCH_BG_CHECKSUM, PR_0_GDT_CSUM_LATCH, 0 },
+	{ PR_LATCH_OPTIMIZE_EXT, PR_1E_OPTIMIZE_EXT_HEADER, PR_1E_OPTIMIZE_EXT_END },
 	{ -1, 0, 0 },
 };
 
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 3c28166..d3dcc9e 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -40,6 +40,7 @@ struct problem_context {
 #define PR_LATCH_TOOBIG	0x0080	/* Latch for file to big errors */
 #define PR_LATCH_OPTIMIZE_DIR 0x0090 /* Latch for optimize directories */
 #define PR_LATCH_BG_CHECKSUM 0x00A0  /* Latch for block group checksums */
+#define PR_LATCH_OPTIMIZE_EXT 0x00B0  /* Latch for rebuild extents */
 
 #define PR_LATCH(x)	((((x) & PR_LATCH_MASK) >> 4) - 1)
 
@@ -641,6 +642,9 @@ struct problem_context {
 /* leaf extent collision */
 #define PR_1_EXTENT_COLLISION			0x01007D
 
+/* extent tree max depth too big */
+#define PR_1_EXTENT_BAD_MAX_DEPTH		0x01007E
+
 /*
  * Pass 1b errors
  */
@@ -704,6 +708,30 @@ struct problem_context {
 #define PR_1D_CLONE_ERROR	0x013008
 
 /*
+ * Pass 1e --- rebuilding extent trees
+ */
+/* Pass 1e: Rebuilding extent trees */
+#define PR_1E_PASS_HEADER		0x014000
+
+/* Error rehash directory */
+#define PR_1E_OPTIMIZE_EXT_ERR		0x014001
+
+/* Rebuilding extent trees */
+#define PR_1E_OPTIMIZE_EXT_HEADER	0x014002
+
+/* Rebuilding extent %d */
+#define PR_1E_OPTIMIZE_EXT		0x014003
+
+/* Rebuilding extent tree end */
+#define PR_1E_OPTIMIZE_EXT_END		0x014004
+
+/* Internal error: extent tree depth too large */
+#define PR_1E_MAX_EXTENT_TREE_DEPTH	0x014005
+
+/* Inode extent tree could be more compact */
+#define PR_1E_CAN_COMPRESS_EXTENT_TREE	0x014006
+
+/*
  * Pass 2 errors
  */
 
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 1e7e749..e64262a 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -606,6 +606,13 @@ void check_super_block(e2fsck_t ctx)
 		ext2fs_mark_super_dirty(fs);
 	}
 
+	/* Did user ask us to convert files to extents? */
+	if (ctx->options & E2F_OPT_CONVERT_BMAP) {
+		fs->super->s_feature_incompat |=
+			EXT3_FEATURE_INCOMPAT_EXTENTS;
+		ext2fs_mark_super_dirty(fs);
+	}
+
 	if ((fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) &&
 	    (fs->super->s_first_meta_bg > fs->desc_blocks)) {
 		pctx.group = fs->desc_blocks;
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index f3672c0..fe5127a 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -709,6 +709,9 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 			else
 				ctx->log_fn = string_copy(ctx, arg, 0);
 			continue;
+		} else if (strcmp(token, "bmap2extent") == 0) {
+			ctx->options |= E2F_OPT_CONVERT_BMAP;
+			continue;
 		} else {
 			fprintf(stderr, _("Unknown extended option: %s\n"),
 				token);
@@ -728,6 +731,7 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 		fputs(("\tdiscard\n"), stderr);
 		fputs(("\tnodiscard\n"), stderr);
 		fputs(("\treadahead_kb=<buffer size>\n"), stderr);
+		fputs(("\tbmap2extent\n"), stderr);
 		fputc('\n', stderr);
 		exit(1);
 	}
diff --git a/tests/f_extent_bad_node/expect.1 b/tests/f_extent_bad_node/expect.1
index 0c0bc28..c13ad39 100644
--- a/tests/f_extent_bad_node/expect.1
+++ b/tests/f_extent_bad_node/expect.1
@@ -2,8 +2,11 @@ Pass 1: Checking inodes, blocks, and sizes
 Inode 12 has an invalid extent node (blk 22, lblk 0)
 Clear? yes
 
+Inode 12 extent tree could be more compact.  Fix? yes
+
 Inode 12, i_blocks is 16, should be 8.  Fix? yes
 
+Pass 1E: Optimizing extent trees
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
@@ -11,13 +14,13 @@ Pass 5: Checking group summary information
 Block bitmap differences:  -(21--23) -25
 Fix? yes
 
-Free blocks count wrong for group #0 (71, counted=75).
+Free blocks count wrong for group #0 (73, counted=77).
 Fix? yes
 
-Free blocks count wrong (71, counted=75).
+Free blocks count wrong (73, counted=77).
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 12/16 files (0.0% non-contiguous), 25/100 blocks
+test_filesys: 12/16 files (0.0% non-contiguous), 23/100 blocks
 Exit status is 1
diff --git a/tests/f_extent_bad_node/expect.2 b/tests/f_extent_bad_node/expect.2
index 568c792..b78b193 100644
--- a/tests/f_extent_bad_node/expect.2
+++ b/tests/f_extent_bad_node/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 12/16 files (0.0% non-contiguous), 25/100 blocks
+test_filesys: 12/16 files (0.0% non-contiguous), 23/100 blocks
 Exit status is 0
diff --git a/tests/f_extent_int_bad_magic/expect.1 b/tests/f_extent_int_bad_magic/expect.1
index 0e82e2b..0bd163f 100644
--- a/tests/f_extent_int_bad_magic/expect.1
+++ b/tests/f_extent_int_bad_magic/expect.1
@@ -2,8 +2,11 @@ Pass 1: Checking inodes, blocks, and sizes
 Inode 12 has an invalid extent node (blk 1295, lblk 0)
 Clear? yes
 
+Inode 12 extent tree could be more compact.  Fix? yes
+
 Inode 12, i_blocks is 712, should be 0.  Fix? yes
 
+Pass 1E: Optimizing extent trees
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
diff --git a/tests/f_extent_leaf_bad_magic/expect.1 b/tests/f_extent_leaf_bad_magic/expect.1
index 7b6dbf1..c31a309 100644
--- a/tests/f_extent_leaf_bad_magic/expect.1
+++ b/tests/f_extent_leaf_bad_magic/expect.1
@@ -2,8 +2,11 @@ Pass 1: Checking inodes, blocks, and sizes
 Inode 12 has an invalid extent node (blk 1604, lblk 0)
 Clear? yes
 
+Inode 12 extent tree could be more compact.  Fix? yes
+
 Inode 12, i_blocks is 18, should be 0.  Fix? yes
 
+Pass 1E: Optimizing extent trees
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
diff --git a/tests/f_extent_oobounds/expect.1 b/tests/f_extent_oobounds/expect.1
index 3164ea0..237829a 100644
--- a/tests/f_extent_oobounds/expect.1
+++ b/tests/f_extent_oobounds/expect.1
@@ -3,8 +3,11 @@ Inode 12, end of extent exceeds allowed value
 	(logical block 15, physical block 200, len 30)
 Clear? yes
 
+Inode 12 extent tree could be more compact.  Fix? yes
+
 Inode 12, i_blocks is 154, should be 94.  Fix? yes
 
+Pass 1E: Optimizing extent trees
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
@@ -12,13 +15,13 @@ Pass 5: Checking group summary information
 Block bitmap differences:  -(200--229)
 Fix? yes
 
-Free blocks count wrong for group #0 (156, counted=186).
+Free blocks count wrong for group #0 (158, counted=188).
 Fix? yes
 
-Free blocks count wrong (156, counted=186).
+Free blocks count wrong (158, counted=188).
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 12/32 files (8.3% non-contiguous), 70/256 blocks
+test_filesys: 12/32 files (8.3% non-contiguous), 68/256 blocks
 Exit status is 1
diff --git a/tests/f_extent_oobounds/expect.2 b/tests/f_extent_oobounds/expect.2
index 22c4f2c..0729283 100644
--- a/tests/f_extent_oobounds/expect.2
+++ b/tests/f_extent_oobounds/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 12/32 files (8.3% non-contiguous), 70/256 blocks
+test_filesys: 12/32 files (8.3% non-contiguous), 68/256 blocks
 Exit status is 0
diff --git a/tests/f_extents/expect.1 b/tests/f_extents/expect.1
index aeebc7b..d682929 100644
--- a/tests/f_extents/expect.1
+++ b/tests/f_extents/expect.1
@@ -6,6 +6,8 @@ Inode 12 has an invalid extent
 	(logical block 0, invalid physical block 21994527527949, len 17)
 Clear? yes
 
+Inode 12 extent tree could be more compact.  Fix? yes
+
 Inode 12, i_blocks is 34, should be 0.  Fix? yes
 
 Inode 13 missing EXTENT_FL, but is in extents format
@@ -21,6 +23,8 @@ Inode 17 has an invalid extent
 	(logical block 0, invalid physical block 22011707397135, len 15)
 Clear? yes
 
+Inode 17 extent tree could be more compact.  Fix? yes
+
 Inode 17, i_blocks is 32, should be 0.  Fix? yes
 
 Error while reading over extent tree in inode 18: Corrupt extent header
@@ -31,6 +35,7 @@ Inode 18, i_blocks is 2, should be 0.  Fix? yes
 Special (device/socket/fifo) file (inode 19) has extents
 or inline-data flag set.  Clear? yes
 
+Pass 1E: Optimizing extent trees
 Pass 2: Checking directory structure
 Entry 'fbad-flag' in / (2) has deleted/unused inode 18.  Clear? yes
 

