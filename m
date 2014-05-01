From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 23/37] e2fsck: provide routines to read-ahead metadata
Date: Thu, 01 May 2014 16:14:52 -0700
Message-ID: <20140501231452.31890.31652.stgit@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39306 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaEAXO5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:14:57 -0400
In-Reply-To: <20140501231222.31890.82860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds to e2fsck the ability to pre-fetch metadata into the
page cache in the hopes of speeding up fsck runs.  There are two new
functions -- the first allows a caller to readahead a list of blocks,
and the second is a helper function that uses that first mechanism to
load group data (bitmaps, inode tables).

e2fsck will employ both of these methods to speed itself up.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/Makefile.in |    8 ++
 e2fsck/e2fsck.h    |   12 +++
 e2fsck/readahead.c |  187 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 205 insertions(+), 2 deletions(-)
 create mode 100644 e2fsck/readahead.c


diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 5a6883a..2e08982 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -71,7 +71,7 @@ OBJS= dict.o unix.o e2fsck.o super.o pass1.o pass1b.o pass2.o \
 	pass3.o pass4.o pass5.o journal.o badblocks.o util.o dirinfo.o \
 	dx_dirinfo.o ehandler.o problem.o message.o quota.o recovery.o \
 	region.o revoke.o ea_refcount.o rehash.o profile.o prof_err.o \
-	logfile.o sigcatcher.o $(MTRACE_OBJ)
+	logfile.o sigcatcher.o readahead.o $(MTRACE_OBJ)
 
 PROFILED_OBJS= profiled/dict.o profiled/unix.o profiled/e2fsck.o \
 	profiled/super.o profiled/pass1.o profiled/pass1b.o \
@@ -82,7 +82,7 @@ PROFILED_OBJS= profiled/dict.o profiled/unix.o profiled/e2fsck.o \
 	profiled/recovery.o profiled/region.o profiled/revoke.o \
 	profiled/ea_refcount.o profiled/rehash.o profiled/profile.o \
 	profiled/prof_err.o profiled/logfile.o \
-	profiled/sigcatcher.o
+	profiled/sigcatcher.o profiled/readahead.o
 
 SRCS= $(srcdir)/e2fsck.c \
 	$(srcdir)/dict.c \
@@ -106,6 +106,7 @@ SRCS= $(srcdir)/e2fsck.c \
 	$(srcdir)/message.c \
 	$(srcdir)/ea_refcount.c \
 	$(srcdir)/rehash.c \
+	$(srcdir)/readahead.c \
 	$(srcdir)/region.c \
 	$(srcdir)/profile.c \
 	$(srcdir)/sigcatcher.c \
@@ -550,3 +551,6 @@ quota.o: $(srcdir)/quota.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
  $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(srcdir)/problem.h $(top_srcdir)/lib/quota/quotaio.h
+readahead.o: $(srcdir)/readahead.c $(top_builddir)/lib/config.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/e2fsck.h
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index d7a7be9..c739329 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -484,6 +484,18 @@ extern ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix);
 extern errcode_t e2fsck_adjust_inode_count(e2fsck_t ctx, ext2_ino_t ino,
 					   int adj);
 
+/* readahead.c */
+#define E2FSCK_READA_SUPER	(0x01)
+#define E2FSCK_READA_GDT	(0x02)
+#define E2FSCK_READA_BBITMAP	(0x04)
+#define E2FSCK_READA_IBITMAP	(0x08)
+#define E2FSCK_READA_ITABLE	(0x10)
+#define E2FSCK_READA_ALL_FLAGS	(0x1F)
+errcode_t e2fsck_readahead(ext2_filsys fs, int flags, dgrp_t start,
+			   dgrp_t ngroups);
+errcode_t e2fsck_readahead_dblist(ext2_filsys fs, int flags,
+				  ext2_dblist dblist);
+int e2fsck_can_readahead(ext2_filsys fs);
 
 /* region.c */
 extern region_t region_create(region_addr_t min, region_addr_t max);
diff --git a/e2fsck/readahead.c b/e2fsck/readahead.c
new file mode 100644
index 0000000..79608af
--- /dev/null
+++ b/e2fsck/readahead.c
@@ -0,0 +1,187 @@
+/*
+ * readahead.c -- Prefetch filesystem metadata to speed up fsck.
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
+#include "e2fsck.h"
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
+errcode_t e2fsck_readahead_dblist(ext2_filsys fs, int flags,
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
+errcode_t e2fsck_readahead(ext2_filsys fs, int flags, dgrp_t start,
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
+	if (flags & ~E2FSCK_READA_ALL_FLAGS)
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
+		if (flags & E2FSCK_READA_SUPER) {
+			err = ext2fs_add_dir_block2(dblist, 0, super, 0);
+			if (err)
+				break;
+		}
+
+		if (flags & E2FSCK_READA_GDT) {
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
+		if ((flags & E2FSCK_READA_BBITMAP) &&
+		    !ext2fs_bg_flags_test(fs, i, EXT2_BG_BLOCK_UNINIT) &&
+		    ext2fs_bg_free_blocks_count(fs, i) <
+				fs->super->s_blocks_per_group) {
+			super = ext2fs_block_bitmap_loc(fs, i);
+			err = ext2fs_add_dir_block2(dblist, 0, super, 1);
+			if (err)
+				break;
+		}
+
+		if ((flags & E2FSCK_READA_IBITMAP) &&
+		    !ext2fs_bg_flags_test(fs, i, EXT2_BG_INODE_UNINIT) &&
+		    ext2fs_bg_free_inodes_count(fs, i) <
+				fs->super->s_inodes_per_group) {
+			super = ext2fs_inode_bitmap_loc(fs, i);
+			err = ext2fs_add_dir_block2(dblist, 0, super, 1);
+			if (err)
+				break;
+		}
+
+		if ((flags & E2FSCK_READA_ITABLE) &&
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
+		err = e2fsck_readahead_dblist(fs, 0, dblist);
+
+	ext2fs_free_dblist(dblist);
+	return err;
+}
+
+int e2fsck_can_readahead(ext2_filsys fs)
+{
+	errcode_t err;
+
+	err = io_channel_cache_readahead(fs->io, 0, 1);
+	dbg_printf("%s: supp=%d\n", __func__, err != EXT2_ET_OP_NOT_SUPPORTED);
+	return err != EXT2_ET_OP_NOT_SUPPORTED;
+}

