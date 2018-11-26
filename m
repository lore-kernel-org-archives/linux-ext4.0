Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44530 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbeK0JPe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Nov 2018 04:15:34 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v3 01/12] libe2p: Helpers for configuring the encoding superblock fields
Date: Mon, 26 Nov 2018 17:19:38 -0500
Message-Id: <20181126221949.12172-2-krisman@collabora.com>
In-Reply-To: <20181126221949.12172-1-krisman@collabora.com>
References: <20181126221949.12172-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

Implement helper functions to convert the encoding name and specific
parameters requested by the user on the command line into the format
that is written to disk.

Changes since v2:
  - Rename defines to add EXT4_ prefix
  - Use unicode X.Y versioning scheme

Changes since v1:
  - Drop struct ext4_encoding_map name.
  - remove question mark in comment.
  - Reword 0x0 -> NULL
  - Prevent out of bound array access if requested invalid encoding

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 lib/e2p/Makefile.in  |  8 +++-
 lib/e2p/e2p.h        |  5 +++
 lib/e2p/encoding.c   | 97 ++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_fs.h |  5 +++
 4 files changed, 113 insertions(+), 2 deletions(-)
 create mode 100644 lib/e2p/encoding.c

diff --git a/lib/e2p/Makefile.in b/lib/e2p/Makefile.in
index 2b0aa1915130..68d534cdaf11 100644
--- a/lib/e2p/Makefile.in
+++ b/lib/e2p/Makefile.in
@@ -19,7 +19,8 @@ all::	e2p.pc
 OBJS=		feature.o fgetflags.o fsetflags.o fgetversion.o fsetversion.o \
 		getflags.o getversion.o hashstr.o iod.o ls.o ljs.o mntopts.o \
 		parse_num.o pe.o pf.o ps.o setflags.o setversion.o uuid.o \
-		ostype.o percent.o crypto_mode.o fgetproject.o fsetproject.o
+		ostype.o percent.o crypto_mode.o fgetproject.o fsetproject.o \
+		encoding.o
 
 SRCS=		$(srcdir)/feature.c $(srcdir)/fgetflags.c \
 		$(srcdir)/fsetflags.c $(srcdir)/fgetversion.c \
@@ -29,7 +30,7 @@ SRCS=		$(srcdir)/feature.c $(srcdir)/fgetflags.c \
 		$(srcdir)/pe.c $(srcdir)/pf.c $(srcdir)/ps.c \
 		$(srcdir)/setflags.c $(srcdir)/setversion.c $(srcdir)/uuid.c \
 		$(srcdir)/ostype.c $(srcdir)/percent.c $(srcdir)/crypto_mode.c \
-		$(srcdir)/fgetproject.c $(srcdir)/fsetproject.c
+		$(srcdir)/fgetproject.c $(srcdir)/fsetproject.c $(srcdir)/encoding.c
 HFILES= e2p.h
 
 LIBRARY= libe2p
@@ -147,6 +148,9 @@ getversion.o: $(srcdir)/getversion.c $(top_builddir)/lib/config.h \
 hashstr.o: $(srcdir)/hashstr.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2p.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h
+encoding.o: $(srcdir)/encoding.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2p.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h
 iod.o: $(srcdir)/iod.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2p.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h
diff --git a/lib/e2p/e2p.h b/lib/e2p/e2p.h
index d70b59a5d358..c3a6b2587bf6 100644
--- a/lib/e2p/e2p.h
+++ b/lib/e2p/e2p.h
@@ -80,3 +80,8 @@ unsigned int e2p_percent(int percent, unsigned int base);
 
 const char *e2p_encmode2string(int num);
 int e2p_string2encmode(char *string);
+
+int e2p_str2encoding(const char *string);
+const char *e2p_encoding2str(int encoding);
+int e2p_get_encoding_flags(int encoding);
+int e2p_str2encoding_flags(int encoding, char *param, __u16 *flags);
diff --git a/lib/e2p/encoding.c b/lib/e2p/encoding.c
new file mode 100644
index 000000000000..a441647aaea3
--- /dev/null
+++ b/lib/e2p/encoding.c
@@ -0,0 +1,97 @@
+/*
+ * encoding.c --- convert between encoding magic numbers and strings
+ *
+ * Copyright (C) 2018  Collabora Ltd.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Library
+ * General Public License, version 2.
+ * %End-Header%
+ */
+
+#include "config.h"
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <ctype.h>
+#include <errno.h>
+#include <stdio.h>
+
+#include "e2p.h"
+
+#define ARRAY_SIZE(array)			\
+        (sizeof(array) / sizeof(array[0]))
+
+static const struct {
+	char *name;
+	__u16 default_flags;
+} ext4_encoding_map[] = {
+	/* 0x0 */ { "ascii", 0},
+	/* 0x1 */ {"utf8-10.0", (EXT4_UTF8_NORMALIZATION_TYPE_NFKD |
+				 EXT4_UTF8_CASEFOLD_TYPE_NFKDCF)},
+};
+
+static const struct enc_flags {
+	__u16 flag;
+	char *param;
+} encoding_flags[] = {
+	{ EXT4_ENC_STRICT_MODE_FL, "strict" },
+};
+
+/* Return a positive number < 0xff indicating the encoding magic number
+ * or a negative value indicating error. */
+int e2p_str2encoding(const char *string)
+{
+	int i;
+
+	for (i = 0 ; i < ARRAY_SIZE(ext4_encoding_map); i++)
+		if (!strcmp(string, ext4_encoding_map[i].name))
+			return i;
+
+	return -EINVAL;
+}
+
+const char *e2p_encoding2str(int encoding)
+{
+	if (encoding < ARRAY_SIZE(ext4_encoding_map))
+		return ext4_encoding_map[encoding].name;
+	return NULL;
+}
+
+int e2p_get_encoding_flags(int encoding)
+{
+	if (encoding < ARRAY_SIZE(ext4_encoding_map))
+		return ext4_encoding_map[encoding].default_flags;
+	return 0;
+}
+
+int e2p_str2encoding_flags(int encoding, char *param, __u16 *flags)
+{
+	char *f = strtok(param, "-");
+	const struct enc_flags *fl;
+	int i, neg = 0;
+
+	while (f) {
+		neg = 0;
+		if (!strncmp("no", f, 2)) {
+			neg = 1;
+			f += 2;
+		}
+
+		for (i = 0; i < ARRAY_SIZE(encoding_flags); i++) {
+			fl = &encoding_flags[i];
+			if (!strcmp(fl->param, f)) {
+				if (neg)
+					*flags &= ~fl->flag;
+				else
+					*flags |= fl->flag;
+
+				goto next_flag;
+			}
+		}
+		return -EINVAL;
+	next_flag:
+		f = strtok(NULL, "-");
+	}
+	return 0;
+}
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index f1c405b76339..36ae7ae41c47 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -16,6 +16,7 @@
 #ifndef _LINUX_EXT2_FS_H
 #define _LINUX_EXT2_FS_H
 
+#include <stddef.h>
 #include <ext2fs/ext2_types.h>		/* Changed from linux/types.h */
 
 #ifndef __GNUC_PREREQ
@@ -1127,4 +1128,8 @@ struct mmp_struct {
  */
 #define EXT4_INLINE_DATA_DOTDOT_SIZE	(4)
 
+#define EXT4_ENC_STRICT_MODE_FL			(1 << 0) /* Reject invalid sequences */
+#define EXT4_UTF8_NORMALIZATION_TYPE_NFKD	(1 << 1)
+#define EXT4_UTF8_CASEFOLD_TYPE_NFKDCF		(1 << 4)
+
 #endif	/* _LINUX_EXT2_FS_H */
-- 
2.19.2
