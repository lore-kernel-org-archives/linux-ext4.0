From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/7] libext2fs: move ext2fs_get_num_dirs to its own file
Date: Mon, 30 Jul 2012 17:47:39 -0400
Message-ID: <1343684862-13181-4-git-send-email-tytso@mit.edu>
References: <20120628024356.GB17989@thor.bakeyournoodle.com>
 <1343684862-13181-1-git-send-email-tytso@mit.edu>
Cc: tony@bakeyournoodle.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42142 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887Ab2G3Vro (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 17:47:44 -0400
In-Reply-To: <1343684862-13181-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This reduces the number of C library symbols needed by boot loader
systems such as yaboot.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/Makefile.in    |  9 +++++++++
 lib/ext2fs/dblist.c       | 28 --------------------------
 lib/ext2fs/ext2fs.h       |  5 +++--
 lib/ext2fs/get_num_dirs.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 62 insertions(+), 30 deletions(-)
 create mode 100644 lib/ext2fs/get_num_dirs.c

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 0d9ac21..c6835fe 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -50,6 +50,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	freefs.o \
 	gen_bitmap.o \
 	gen_bitmap64.o \
+	get_num_dirs.o \
 	get_pathname.o \
 	getsize.o \
 	getsectsize.o \
@@ -122,6 +123,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/freefs.c \
 	$(srcdir)/gen_bitmap.c \
 	$(srcdir)/gen_bitmap64.c \
+	$(srcdir)/get_num_dirs.c \
 	$(srcdir)/get_pathname.c \
 	$(srcdir)/getsize.c \
 	$(srcdir)/getsectsize.c \
@@ -686,6 +688,13 @@ gen_bitmap64.o: $(srcdir)/gen_bitmap64.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/ext2_ext_attr.h \
  $(srcdir)/bitops.h $(srcdir)/bmap64.h
+get_num_dirs.o: $(srcdir)/get_num_dirs.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fsP.h \
+ $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/ext2_ext_attr.h \
+ $(srcdir)/bitops.h
 get_pathname.o: $(srcdir)/get_pathname.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
diff --git a/lib/ext2fs/dblist.c b/lib/ext2fs/dblist.c
index ca1446b..ceaae8f 100644
--- a/lib/ext2fs/dblist.c
+++ b/lib/ext2fs/dblist.c
@@ -25,34 +25,6 @@ static EXT2_QSORT_TYPE dir_block_cmp2(const void *a, const void *b);
 static EXT2_QSORT_TYPE (*sortfunc32)(const void *a, const void *b);
 
 /*
- * Returns the number of directories in the filesystem as reported by
- * the group descriptors.  Of course, the group descriptors could be
- * wrong!
- */
-errcode_t ext2fs_get_num_dirs(ext2_filsys fs, ext2_ino_t *ret_num_dirs)
-{
-	dgrp_t	i;
-	ext2_ino_t	num_dirs, max_dirs;
-
-	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
-
-	num_dirs = 0;
-	max_dirs = fs->super->s_inodes_per_group;
-	for (i = 0; i < fs->group_desc_count; i++) {
-		if (ext2fs_bg_used_dirs_count(fs, i) > max_dirs)
-			num_dirs += max_dirs / 8;
-		else
-			num_dirs += ext2fs_bg_used_dirs_count(fs, i);
-	}
-	if (num_dirs > fs->super->s_inodes_count)
-		num_dirs = fs->super->s_inodes_count;
-
-	*ret_num_dirs = num_dirs;
-
-	return 0;
-}
-
-/*
  * helper function for making a new directory block list (for
  * initialize and copy).
  */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 6b9a577..62282b1 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -938,8 +938,6 @@ extern errcode_t ext2fs_set_gdt_csum(ext2_filsys fs);
 extern __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group);
 
 /* dblist.c */
-
-extern errcode_t ext2fs_get_num_dirs(ext2_filsys fs, ext2_ino_t *ret_num_dirs);
 extern errcode_t ext2fs_init_dblist(ext2_filsys fs, ext2_dblist *ret_dblist);
 extern errcode_t ext2fs_add_dir_block(ext2_dblist dblist, ext2_ino_t ino,
 				      blk_t blk, int blockcnt);
@@ -1189,6 +1187,9 @@ errcode_t ext2fs_set_generic_bmap_range(ext2fs_generic_bitmap bmap,
 errcode_t ext2fs_convert_subcluster_bitmap(ext2_filsys fs,
 					   ext2fs_block_bitmap *bitmap);
 
+/* get_num_dirs.c */
+extern errcode_t ext2fs_get_num_dirs(ext2_filsys fs, ext2_ino_t *ret_num_dirs);
+
 /* getsize.c */
 extern errcode_t ext2fs_get_device_size(const char *file, int blocksize,
 					blk_t *retblocks);
diff --git a/lib/ext2fs/get_num_dirs.c b/lib/ext2fs/get_num_dirs.c
new file mode 100644
index 0000000..f5644f8
--- /dev/null
+++ b/lib/ext2fs/get_num_dirs.c
@@ -0,0 +1,50 @@
+/*
+ * get_num_dirs.c -- calculate number of directories
+ *
+ * Copyright 1997 by Theodore Ts'o
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Library
+ * General Public License, version 2.
+ * %End-Header%
+ */
+
+#include "config.h"
+#include <stdio.h>
+#if HAVE_UNISTD_H
+#include <unistd.h>
+#endif
+#include <string.h>
+#include <time.h>
+
+#include "ext2_fs.h"
+#include "ext2fsP.h"
+
+/*
+ * Returns the number of directories in the filesystem as reported by
+ * the group descriptors.  Of course, the group descriptors could be
+ * wrong!
+ */
+errcode_t ext2fs_get_num_dirs(ext2_filsys fs, ext2_ino_t *ret_num_dirs)
+{
+	dgrp_t	i;
+	ext2_ino_t	num_dirs, max_dirs;
+
+	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
+
+	num_dirs = 0;
+	max_dirs = fs->super->s_inodes_per_group;
+	for (i = 0; i < fs->group_desc_count; i++) {
+		if (ext2fs_bg_used_dirs_count(fs, i) > max_dirs)
+			num_dirs += max_dirs / 8;
+		else
+			num_dirs += ext2fs_bg_used_dirs_count(fs, i);
+	}
+	if (num_dirs > fs->super->s_inodes_count)
+		num_dirs = fs->super->s_inodes_count;
+
+	*ret_num_dirs = num_dirs;
+
+	return 0;
+}
+
-- 
1.7.12.rc0.22.gcdd159b

