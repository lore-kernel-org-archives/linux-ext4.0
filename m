From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 02/21 v5] libext2fs: add function to check inline_data flag for an inode
Date: Sat, 22 Sep 2012 12:00:50 +0800
Message-ID: <1348286469-31690-3-git-send-email-wenqing.lz@taobao.com>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45480 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab2IVDvC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 23:51:02 -0400
Received: by pbbrr4 with SMTP id rr4so3873835pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 20:51:01 -0700 (PDT)
In-Reply-To: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

A new file called `inline_data.c' is created, and a function called
`ext2fs_inode_has_inline_data' is defined to check whether an inode
has inline data or not.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/Makefile.in   |    8 ++++++++
 lib/ext2fs/Makefile.pq   |    1 +
 lib/ext2fs/ext2fs.h      |    3 +++
 lib/ext2fs/inline_data.c |   30 ++++++++++++++++++++++++++++++
 4 files changed, 42 insertions(+), 0 deletions(-)
 create mode 100644 lib/ext2fs/inline_data.c

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 8930fdb..7201fa2 100644
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
@@ -132,6 +133,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/ind_block.c \
 	$(srcdir)/initialize.c \
 	$(srcdir)/inline.c \
+	$(srcdir)/inline_data.c	\
 	$(srcdir)/inode.c \
 	$(srcdir)/inode_io.c \
 	$(srcdir)/imager.c \
@@ -743,6 +745,12 @@ inline.o: $(srcdir)/inline.c $(top_builddir)/lib/config.h \
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
index 1cd53f0..8714f58 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1320,6 +1320,9 @@ extern errcode_t ext2fs_icount_store(ext2_icount_t icount, ext2_ino_t ino,
 extern ext2_ino_t ext2fs_get_icount_size(ext2_icount_t icount);
 errcode_t ext2fs_icount_validate(ext2_icount_t icount, FILE *);
 
+/* inline_data.c */
+extern int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino);
+
 /* inode.c */
 extern errcode_t ext2fs_flush_icache(ext2_filsys fs);
 extern errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan,
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
new file mode 100644
index 0000000..0341ee3
--- /dev/null
+++ b/lib/ext2fs/inline_data.c
@@ -0,0 +1,30 @@
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
1.7.4.1

