From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 36/49] libext2fs: allow clients to read-ahead metadata
Date: Mon, 10 Mar 2014 23:57:50 -0700
Message-ID: <20140311065750.30585.71404.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22194 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbaCKG5z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:57:55 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds to libext2fs the ability to pre-fetch metadata
into the page cache in the hopes of speeding up libext2fs' clients.
There are two new library functions -- the first allows a client to
readahead a list of blocks, and the second is a helper function that
uses that first mechanism to load group data (bitmaps, inode tables).

e2fsck will employ both of these methods to speed itself up.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/Makefile.in |    4 +
 lib/ext2fs/ext2fs.h    |   13 +++
 lib/ext2fs/readahead.c |  188 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 205 insertions(+)
 create mode 100644 lib/ext2fs/readahead.c


diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 0c880c7..e64342e 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -78,6 +78,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	qcow2.o \
 	read_bb.o \
 	read_bb_file.o \
+	readahead.o \
 	res_gdt.o \
 	rw_bitmaps.o \
 	swapfs.o \
@@ -155,6 +156,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/qcow2.c \
 	$(srcdir)/read_bb.c \
 	$(srcdir)/read_bb_file.c \
+	$(srcdir)/readahead.c \
 	$(srcdir)/res_gdt.c \
 	$(srcdir)/rw_bitmaps.c \
 	$(srcdir)/swapfs.c \
@@ -903,6 +905,8 @@ read_bb_file.o: $(srcdir)/read_bb_file.c $(top_builddir)/lib/config.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h
+readahead.o: $(srcdir)/readahead.c $(top_builddir)/lib/config.h \
+ $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_err.h
 res_gdt.o: $(srcdir)/res_gdt.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 819a14a..933a14d 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1563,6 +1563,19 @@ extern errcode_t ext2fs_read_bb_FILE(ext2_filsys fs, FILE *f,
 				     void (*invalid)(ext2_filsys fs,
 						     blk_t blk));
 
+/* readahead.c */
+#define EXT2_READA_SUPER	(0x01)
+#define EXT2_READA_GDT		(0x02)
+#define EXT2_READA_BBITMAP	(0x04)
+#define EXT2_READA_IBITMAP	(0x08)
+#define EXT2_READA_ITABLE	(0x10)
+#define EXT2_READA_ALL_FLAGS	(0x1F)
+errcode_t ext2fs_readahead(ext2_filsys fs, int flags, dgrp_t start,
+			   dgrp_t ngroups);
+errcode_t ext2fs_readahead_dblist(ext2_filsys fs, int flags,
+				  ext2_dblist dblist);
+int ext2fs_can_readahead(ext2_filsys fs);
+
 /* res_gdt.c */
 extern errcode_t ext2fs_create_resize_inode(ext2_filsys fs);
 
diff --git a/lib/ext2fs/readahead.c b/lib/ext2fs/readahead.c
new file mode 100644
index 0000000..ed6e555
--- /dev/null
+++ b/lib/ext2fs/readahead.c
@@ -0,0 +1,188 @@
+/*
+ * readahead.c -- Try to convince the OS to prefetch metadata.
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
+#include <string.h>
+
+#include "ext2_fs.h"
+#include "ext2fs.h"
+
+#undef DEBUG
+
+#ifdef DEBUG
+# define dbg_printf(f, a...)  do {printf(f, ## a); fflush(stdout); } while (0)
+#else
+# define dbg_printf(f, a...)
+#endif
+
+struct read_dblist {
+	errcode_t err;
+	blk64_t run_start;
+	blk64_t run_len;
+};
+
+static EXT2_QSORT_TYPE readahead_dir_block_cmp(const void *a, const void *b)
+{
+	const struct ext2_db_entry2 *db_a =
+		(const struct ext2_db_entry2 *) a;
+	const struct ext2_db_entry2 *db_b =
+		(const struct ext2_db_entry2 *) b;
+
+	return (int) (db_a->blk - db_b->blk);
+}
+
+static int readahead_dir_block(ext2_filsys fs, struct ext2_db_entry2 *db,
+			       void *priv_data)
+{
+	errcode_t err = 0;
+	struct read_dblist *pr = priv_data;
+
+	if (!pr->run_len || db->blk != pr->run_start + pr->run_len) {
+		if (pr->run_len) {
+			pr->err = io_channel_cache_readahead(fs->io,
+							     pr->run_start,
+							     pr->run_len);
+			dbg_printf("readahead start=%llu len=%llu err=%d\n",
+				   pr->run_start, pr->run_len,
+				   (int)pr->err);
+		}
+		pr->run_start = db->blk;
+		pr->run_len = 0;
+	}
+	pr->run_len += db->blockcnt;
+
+	return pr->err ? DBLIST_ABORT : 0;
+}
+
+errcode_t ext2fs_readahead_dblist(ext2_filsys fs, int flags,
+				  ext2_dblist dblist)
+{
+	errcode_t err;
+	struct read_dblist pr;
+
+	dbg_printf("%s: flags=0x%x\n", __func__, flags);
+	if (flags)
+		return EXT2_ET_INVALID_ARGUMENT;
+
+	ext2fs_dblist_sort2(dblist, readahead_dir_block_cmp);
+
+	memset(&pr, 0, sizeof(pr));
+	err = ext2fs_dblist_iterate2(dblist, readahead_dir_block, &pr);
+	if (pr.err)
+		return pr.err;
+	if (err)
+		return err;
+
+	if (pr.run_len)
+		err = io_channel_cache_readahead(fs->io, pr.run_start,
+						 pr.run_len);
+
+	return err;
+}
+
+errcode_t ext2fs_readahead(ext2_filsys fs, int flags, dgrp_t start,
+			   dgrp_t ngroups)
+{
+	blk64_t		super, old_gdt, new_gdt;
+	blk_t		blocks;
+	dgrp_t		i;
+	ext2_dblist	dblist;
+	dgrp_t		end = start + ngroups;
+	errcode_t	err = 0;
+
+	dbg_printf("%s: flags=0x%x start=%d groups=%d\n", __func__, flags,
+		   start, ngroups);
+	if (flags & ~EXT2_READA_ALL_FLAGS)
+		return EXT2_ET_INVALID_ARGUMENT;
+
+	if (end > fs->group_desc_count)
+		end = fs->group_desc_count;
+
+	if (flags == 0)
+		return 0;
+
+	err = ext2fs_init_dblist(fs, &dblist);
+	if (err)
+		return err;
+
+	for (i = start; i < end; i++) {
+		err = ext2fs_super_and_bgd_loc2(fs, i, &super, &old_gdt,
+						&new_gdt, &blocks);
+		if (err)
+			break;
+
+		if (flags & EXT2_READA_SUPER) {
+			err = ext2fs_add_dir_block2(dblist, 0, super, 0);
+			if (err)
+				break;
+		}
+
+		if (flags & EXT2_READA_GDT) {
+			if (old_gdt)
+				err = ext2fs_add_dir_block2(dblist, 0, old_gdt,
+							    blocks);
+			else if (new_gdt)
+				err = ext2fs_add_dir_block2(dblist, 0, new_gdt,
+							    blocks);
+			else
+				err = 0;
+			if (err)
+				break;
+		}
+
+		if ((flags & EXT2_READA_BBITMAP) &&
+		    !ext2fs_bg_flags_test(fs, i, EXT2_BG_BLOCK_UNINIT) &&
+		    ext2fs_bg_free_blocks_count(fs, i) <
+				fs->super->s_blocks_per_group) {
+			super = ext2fs_block_bitmap_loc(fs, i);
+			err = ext2fs_add_dir_block2(dblist, 0, super, 1);
+			if (err)
+				break;
+		}
+
+		if ((flags & EXT2_READA_IBITMAP) &&
+		    !ext2fs_bg_flags_test(fs, i, EXT2_BG_INODE_UNINIT) &&
+		    ext2fs_bg_free_inodes_count(fs, i) <
+				fs->super->s_inodes_per_group) {
+			super = ext2fs_inode_bitmap_loc(fs, i);
+			err = ext2fs_add_dir_block2(dblist, 0, super, 1);
+			if (err)
+				break;
+		}
+
+		if ((flags & EXT2_READA_ITABLE) &&
+		    ext2fs_bg_free_inodes_count(fs, i) <
+				fs->super->s_inodes_per_group) {
+			super = ext2fs_inode_table_loc(fs, i);
+			blocks = fs->inode_blocks_per_group -
+				 (ext2fs_bg_itable_unused(fs, i) *
+				  EXT2_INODE_SIZE(fs->super) / fs->blocksize);
+			err = ext2fs_add_dir_block2(dblist, 0, super, blocks);
+			if (err)
+				break;
+		}
+	}
+
+	if (!err)
+		err = ext2fs_readahead_dblist(fs, 0, dblist);
+
+	ext2fs_free_dblist(dblist);
+	return err;
+}
+
+int ext2fs_can_readahead(ext2_filsys fs)
+{
+	errcode_t err;
+
+	err = io_channel_cache_readahead(fs->io, 0, 1);
+	dbg_printf("%s: supp=%d\n", __func__, err != EXT2_ET_OP_NOT_SUPPORTED);
+	return err != EXT2_ET_OP_NOT_SUPPORTED;
+}

