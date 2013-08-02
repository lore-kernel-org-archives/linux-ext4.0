From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v1 02/22] libext2fs: add function to check inline_data flag for an inode
Date: Fri,  2 Aug 2013 17:49:29 +0800
Message-ID: <1375436989-18948-3-git-send-email-wenqing.lz@taobao.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:36537 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199Ab3HBJuL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Aug 2013 05:50:11 -0400
Received: by mail-pb0-f42.google.com with SMTP id un15so504527pbc.1
        for <linux-ext4@vger.kernel.org>; Fri, 02 Aug 2013 02:50:10 -0700 (PDT)
In-Reply-To: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

A new file called `inline_data.c' is created, and a function called
`ext2fs_inode_has_inline_data' is defined to check whether an inode
has inline data or not.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/Makefile.in   |    8 ++++++++
 lib/ext2fs/Makefile.pq   |    1 +
 lib/ext2fs/ext2fs.h      |    3 +++
 lib/ext2fs/inline_data.c |   31 +++++++++++++++++++++++++++++++
 4 files changed, 43 insertions(+)
 create mode 100644 lib/ext2fs/inline_data.c

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index dc7b0d1..001c222 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -59,6 +59,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	ind_block.o \
 	initialize.o \
 	inline.o \
+	inline_data.o \
 	inode.o \
 	io_manager.o \
 	ismounted.o \
@@ -133,6 +134,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/ind_block.c \
 	$(srcdir)/initialize.c \
 	$(srcdir)/inline.c \
+	$(srcdir)/inline_data.c	\
 	$(srcdir)/inode.c \
 	$(srcdir)/inode_io.c \
 	$(srcdir)/imager.c \
@@ -757,6 +759,12 @@ inline.o: $(srcdir)/inline.c $(top_builddir)/lib/config.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h
+inline_data.o: $(srcdir)/inline_data.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
+ $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
+ $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h
 inode.o: $(srcdir)/inode.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fsP.h \
diff --git a/lib/ext2fs/Makefile.pq b/lib/ext2fs/Makefile.pq
index 2f7b654..89082a7 100644
--- a/lib/ext2fs/Makefile.pq
+++ b/lib/ext2fs/Makefile.pq
@@ -27,6 +27,7 @@ OBJS= 	alloc.obj \
 	icount.obj \
 	initialize.obj \
 	inline.obj \
+	inline_data.obj \
 	inode.obj \
 	ismounted.obj \
 	link.obj \
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 100270c..3346c00 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1333,6 +1333,9 @@ errcode_t ext2fs_icount_validate(ext2_icount_t icount, FILE *);
 extern errcode_t ext2fs_get_memalign(unsigned long size,
 				     unsigned long align, void *ptr);
 
+/* inline_data.c */
+extern int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino);
+
 /* inode.c */
 extern void ext2fs_free_inode_cache(struct ext2_inode_cache *icache);
 extern errcode_t ext2fs_flush_icache(ext2_filsys fs);
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
new file mode 100644
index 0000000..fcf82b5
--- /dev/null
+++ b/lib/ext2fs/inline_data.c
@@ -0,0 +1,31 @@
+/*
+ * inline_data.c --- data in inode
+ *
+ * Copyright (C) 2012 Zheng Liu <wenqing.lz@taobao.com>
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU library
+ * General Public License, version 2.
+ * %End-Header%
+ */
+
+#include "config.h"
+#include <stdio.h>
+#include <time.h>
+
+#include "ext2_fs.h"
+
+#include "ext2fs.h"
+#include "ext2fsP.h"
+
+int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino)
+{
+	struct ext2_inode inode;
+	errcode_t retval;
+
+	retval = ext2fs_read_inode(fs, ino, &inode);
+	if (retval)
+		return 0;
+
+	return (inode.i_flags & EXT4_INLINE_DATA_FL);
+}
-- 
1.7.9.7

