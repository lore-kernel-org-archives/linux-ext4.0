Return-Path: <SRS0=/GAa=M3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37488 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbeJPE7f (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Oct 2018 00:59:35 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH e2fsprogs 3/9] libe2p: Helpers for configuring the encoding superblock fields
Date: Mon, 15 Oct 2018 17:12:14 -0400
Message-Id: <20181015211220.27370-4-krisman@collabora.co.uk>
In-Reply-To: <20181015211220.27370-1-krisman@collabora.co.uk>
References: <20181015211220.27370-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Implement helper functions to convert the encoding name and specific
parameters requested by the user on the command line into the format
that is written to disk.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 lib/e2p/Makefile.in  |  8 +++--
 lib/e2p/e2p.h        |  4 +++
 lib/e2p/encoding.c   | 76 ++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_fs.h | 13 ++++++++
 4 files changed, 99 insertions(+), 2 deletions(-)
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
index d70b59a5d358..c39074abe8eb 100644
--- a/lib/e2p/e2p.h
+++ b/lib/e2p/e2p.h
@@ -80,3 +80,7 @@ unsigned int e2p_percent(int percent, unsigned int base);
 
 const char *e2p_encmode2string(int num);
 int e2p_string2encmode(char *string);
+
+int e2p_str2encoding(const char *string);
+const char *e2p_encoding2str(int encoding);
+int e2p_str2encoding_flags(int encoding, char *param, __u16 *flags);
diff --git a/lib/e2p/encoding.c b/lib/e2p/encoding.c
new file mode 100644
index 000000000000..6904db73b94c
--- /dev/null
+++ b/lib/e2p/encoding.c
@@ -0,0 +1,76 @@
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
+static const struct enc_flags {
+	__u16 flag;
+	char *param;
+} encoding_flags[] = {
+	{ EXT4_ENC_STRICT_MODE_FL, "strict" },
+	{0, NULL},
+};
+
+/* Return a positive number < 0xff indicating the encoding magic number
+ * or a negative value indicating error. */
+int e2p_str2encoding(const char *string)
+{
+	int i;
+
+	for (i = 0 ; ext4_encoding_map[i].name; i++)
+		if (!strcmp(string, ext4_encoding_map[i].name))
+			return i;
+
+	return -EINVAL;
+}
+
+const char *e2p_encoding2str(int encoding)
+{
+	return ext4_encoding_map[encoding].name;
+}
+
+int e2p_str2encoding_flags(int encoding, char *param, __u16 *flags)
+{
+	char *f = strtok(param, "-");
+	const struct enc_flags *fl;
+	int neg = 0;
+
+	while (f) {
+		neg = 0;
+		if (!strncmp ("no", f, 2)) {
+			neg = 1;
+			f += 2;
+		}
+
+		for (fl = encoding_flags; fl->param; fl++) {
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
index f1c405b76339..df8ced088f38 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -1127,4 +1127,17 @@ struct mmp_struct {
  */
 #define EXT4_INLINE_DATA_DOTDOT_SIZE	(4)
 
+#define EXT4_ENC_STRICT_MODE_FL		(1 << 0) /* Reject invalid sequences? */
+#define UTF8_NORMALIZATION_TYPE_NFKD	(1 << 1)
+#define UTF8_CASEFOLD_TYPE_NFKDCF	(1 << 4)
+
+static const struct ext4_sb_encoding_map {
+	char *name;
+	__u16 default_flags;
+} ext4_encoding_map[] = {
+	/* 0x0 */ { "ascii", 0x0},
+	/* 0x1 */ {"utf8-10.0.0", UTF8_NORMALIZATION_TYPE_NFKD|UTF8_CASEFOLD_TYPE_NFKDCF},
+	{0x0, 0x0},
+};
+
 #endif	/* _LINUX_EXT2_FS_H */
-- 
2.19.1
