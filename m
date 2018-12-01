Return-Path: <SRS0=IALa=OK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:32966 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbeLALvR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 06:51:17 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v4 4/9] lib/ext2fs: Implement NLS support
Date: Fri, 30 Nov 2018 19:39:05 -0500
Message-Id: <20181201003910.18982-5-krisman@collabora.com>
In-Reply-To: <20181201003910.18982-1-krisman@collabora.com>
References: <20181201003910.18982-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

Basic NLS support is required in e2fsprogs because of fsck, which
needsto calculate dx hashes for encoding aware filesystems.  this patch
implements this infrastructure as well as ascii support.

We don't need to do all the dance of versioning as we do in the kernel,
because we know before-hand which encodings and versions we
support (those we know how to store in the sb), so it is simpler just to
create static tables.

Changes since v3:
  - Prevent buffer overflow during normalization/casefold.
  - Signal invalid sequences and let caller handle it.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 lib/ext2fs/Makefile.in | 10 ++++--
 lib/ext2fs/nls.h       | 70 ++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/nls_ascii.c | 68 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 146 insertions(+), 2 deletions(-)
 create mode 100644 lib/ext2fs/nls.h
 create mode 100644 lib/ext2fs/nls_ascii.c

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 4a197cdf4e4a..a2f07403c9ae 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -20,6 +20,9 @@ COMPILE_ET=	_ET_DIR_OVERRIDE=$(srcdir)/../et ../et/compile_et
 @TEST_IO_CMT@TEST_IO_LIB_OBJS = test_io.o
 @IMAGER_CMT@E2IMAGE_LIB_OBJS = imager.o
 
+NLS_OBJS=nls_ascii.o
+NLS_SRCS=nls_ascii.c
+
 DEBUG_OBJS= debug_cmds.o extent_cmds.o tst_cmds.o debugfs.o util.o \
 	ncheck.o icheck.o ls.o lsdel.o dump.o set_fields.o logdump.o \
 	htree.o unused.o e2freefrag.o filefrag.o extent_inode.o zap.o \
@@ -130,7 +133,8 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	unlink.o \
 	valid_blk.o \
 	version.o \
-	rbtree.o
+	rbtree.o \
+	$(NLS_OBJS)
 
 SRCS= ext2_err.c \
 	$(srcdir)/alloc.c \
@@ -222,7 +226,8 @@ SRCS= ext2_err.c \
 	$(srcdir)/write_bb_file.c \
 	$(srcdir)/rbtree.c \
 	$(srcdir)/tst_libext2fs.c \
-	$(DEBUG_SRCS)
+	$(DEBUG_SRCS) \
+	$(NLS_SRCS)
 
 HFILES= bitops.h ext2fs.h ext2_io.h ext2_fs.h ext2_ext_attr.h ext3_extents.h \
 	tdb.h qcow2.h hashmap.h
@@ -1412,3 +1417,4 @@ do_journal.o: $(top_srcdir)/debugfs/do_journal.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/support/quotaio_tree.h $(srcdir)/kernel-jbd.h \
  $(srcdir)/jfs_compat.h $(srcdir)/kernel-list.h \
  $(top_srcdir)/debugfs/journal.h $(srcdir)/../../e2fsck/jfs_user.h
+$(NLS_OBJS): $(srcdir)/nls.h
diff --git a/lib/ext2fs/nls.h b/lib/ext2fs/nls.h
new file mode 100644
index 000000000000..adfd92300688
--- /dev/null
+++ b/lib/ext2fs/nls.h
@@ -0,0 +1,70 @@
+/*
+ * nls.h - Header for encoding support functions
+ *
+ * Copyright (C) 2017 Collabora Ltd.
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 3 of the License, or (at
+ *  your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef EXT2FS_NLS_H
+#define EXT2FS_NLS_H
+
+#include <unistd.h>
+#include <string.h>
+#include <stdio.h>
+
+#include "ext2_fs.h"
+
+struct nls_table;
+
+#define ARRAY_SIZE(array)			\
+        (sizeof(array) / sizeof(array[0]))
+
+struct nls_ops {
+	int (*normalize)(const struct nls_table *charset,
+			 const unsigned char *str, size_t len,
+			 unsigned char *dest, size_t dlen);
+
+	int (*casefold)(const struct nls_table *charset,
+			const unsigned char *str, size_t len,
+			unsigned char *dest, size_t dlen);
+};
+
+struct nls_table {
+	int version;
+	const struct nls_ops *ops;
+};
+
+extern const struct nls_table nls_ascii;
+
+static const struct {
+	int encoding_magic;
+	const struct nls_table *tbl;
+} nls_map[] = {
+	{ EXT4_ENC_ASCII, &nls_ascii },
+};
+
+static const struct nls_table *nls_load_table(int encoding)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(nls_map); i++) {
+		if (encoding == nls_map[i].encoding_magic)
+			return nls_map[i].tbl;
+	}
+	return NULL;
+}
+
+#endif
diff --git a/lib/ext2fs/nls_ascii.c b/lib/ext2fs/nls_ascii.c
new file mode 100644
index 000000000000..5d513df404c1
--- /dev/null
+++ b/lib/ext2fs/nls_ascii.c
@@ -0,0 +1,68 @@
+#include "nls.h"
+
+#include <errno.h>
+#include <string.h>
+
+
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c)
+{
+	if (c >= 'A' && c <= 'Z')
+		return (c | 0x20);
+	return c;
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c)
+{
+	if (c >= 'a' && c <= 'z')
+		return (c & ~0x20);
+	return c;
+}
+
+static int ascii_casefold(const struct nls_table *table,
+			  const unsigned char *str, size_t len,
+			  unsigned char *dest, size_t dlen)
+{
+	int i;
+
+	if (dlen < len)
+		return -ENAMETOOLONG;
+
+	for (i = 0; i < len; i++) {
+		if (str[i] & 0x80)
+			return -EINVAL;
+
+		dest[i] = charset_toupper(table, str[i]);
+	}
+
+	return len;
+}
+
+static int ascii_normalize(const struct nls_table *table,
+			   const unsigned char *str, size_t len,
+			   unsigned char *dest, size_t dlen)
+{
+	int i;
+
+	if (dlen < len)
+		return -ENAMETOOLONG;
+
+	for (i = 0; i < len; i++) {
+		if (str[i] & 0x80)
+			return -EINVAL;
+
+		dest[i] = str[i];
+	}
+
+	return len;
+}
+
+const static struct nls_ops ascii_ops = {
+	.casefold = ascii_casefold,
+	.normalize = ascii_normalize,
+};
+
+const struct nls_table nls_ascii = {
+	.ops = &ascii_ops,
+};
-- 
2.20.0.rc1
