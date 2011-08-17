From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH v2 01/12] libe2p: Add new function e2p_get_fragscore()
Date: Wed, 17 Aug 2011 16:46:52 +0900
Message-ID: <4E4B71EC.2020204@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34985 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1HQIAb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Aug 2011 04:00:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds e2p_get_fragscore() to libe2p. e2p_get_fragscore() returns
the fragmentation score. If the number of extents per specified blocks is
smaller than 1, the fragmentation score is set to zero that means the file has
no fragmentation. On the other hand, if it is bigger than 1,
the fragmentation score is set to more than 1 that means the file has
bad fragmentation. The higher fragmentation score means the worse fragmentation.

Fragmentation score treats extents, whose file offset continues and
whose status is the same, as one chunk. If the number of extents
in chunk is equal to the ideal number of extents, the chunk is not used for
the fragmentation score because there is no fragmentation in the chunk.
The ideal number of extents is calculated based on @max_chunk_blks.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 lib/e2p/Makefile.in      |    6 +-
 lib/e2p/e2p.h            |    3 +
 lib/e2p/fragment_score.c |  132 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 139 insertions(+), 2 deletions(-)
diff --git a/lib/e2p/Makefile.in b/lib/e2p/Makefile.in
index 9775a98..c62a81d 100644
--- a/lib/e2p/Makefile.in
+++ b/lib/e2p/Makefile.in
@@ -19,7 +19,7 @@ all::	e2p.pc
 OBJS=		feature.o fgetflags.o fsetflags.o fgetversion.o fsetversion.o \
 		getflags.o getversion.o hashstr.o iod.o ls.o mntopts.o \
 		parse_num.o pe.o pf.o ps.o setflags.o setversion.o uuid.o \
-		ostype.o percent.o
+		ostype.o percent.o fragment_score.o
 
 SRCS=		$(srcdir)/feature.c $(srcdir)/fgetflags.c \
 		$(srcdir)/fsetflags.c $(srcdir)/fgetversion.c \
@@ -28,7 +28,7 @@ SRCS=		$(srcdir)/feature.c $(srcdir)/fgetflags.c \
 		$(srcdir)/ls.c $(srcdir)/mntopts.c $(srcdir)/parse_num.c \
 		$(srcdir)/pe.c $(srcdir)/pf.c $(srcdir)/ps.c \
 		$(srcdir)/setflags.c $(srcdir)/setversion.c $(srcdir)/uuid.c \
-		$(srcdir)/ostype.c $(srcdir)/percent.c
+		$(srcdir)/ostype.c $(srcdir)/percent.c $(srcdir)/fragment_score.c
 HFILES= e2p.h
 
 LIBRARY= libe2p
@@ -162,3 +162,5 @@ ostype.o: $(srcdir)/ostype.c $(srcdir)/e2p.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h
 percent.o: $(srcdir)/percent.c $(srcdir)/e2p.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h
+fragment_score.o: $(srcdir)/fragment_score.c $(srcdir)/e2p.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h
diff --git a/lib/e2p/e2p.h b/lib/e2p/e2p.h
index 4a68dd9..5881256 100644
--- a/lib/e2p/e2p.h
+++ b/lib/e2p/e2p.h
@@ -72,3 +72,6 @@ char *e2p_os2string(int os_type);
 int e2p_string2os(char *str);
 
 unsigned int e2p_percent(int percent, unsigned int base);
+
+unsigned int e2p_get_fragscore(int fd, unsigned int threshold,
+			unsigned int max_chunk_blks, int *errp);
diff --git a/lib/e2p/fragment_score.c b/lib/e2p/fragment_score.c
new file mode 100644
index 0000000..03778c7
--- /dev/null
+++ b/lib/e2p/fragment_score.c
@@ -0,0 +1,132 @@
+/*
+ * fragment_score.c --- Get file fragmentation score.
+ *
+ * Copyright (C) 2011	Kazuya Mio <k-mio@sx.jp.nec.com>
+ *			NEC Software Tohoku, Ltd.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Library
+ * General Public License, version 2.
+ * %End-Header%
+ */
+
+#if HAVE_ERRNO_H
+#include <errno.h>
+#endif
+#include <string.h>
+#include <sys/ioctl.h>
+#include <ext2fs/ext2_types.h>
+#include <ext2fs/fiemap.h>
+#include "e2p.h"
+
+#define FIGETBSZ	_IO(0x00, 2)
+
+#define bad_contiguous_exts(max, cnt, len) \
+	((!max && cnt > 1) || len <= (__u64)max * (cnt - 1))
+
+static int is_extent_continued(struct fiemap_extent *prev_fm_ext,
+			     struct fiemap_extent *cur_fm_ext)
+{
+	/* Check a hole between the extent */
+	if ((prev_fm_ext->fe_logical + prev_fm_ext->fe_length)
+		< cur_fm_ext->fe_logical)
+		return 0;
+
+	/* Check a defference of unwritten flag */
+	if ((prev_fm_ext->fe_flags & FIEMAP_EXTENT_UNWRITTEN)
+		!= (cur_fm_ext->fe_flags & FIEMAP_EXTENT_UNWRITTEN))
+		return 0;
+
+	/* Two extents are continued */
+	return 1;
+}
+
+/*
+ * This function returns the fragmentation score that shows how badly fragmented
+ * the file might be. The score is extents per @threshold, so the higher score
+ * means the worse fragmentation.
+ *
+ * Fragmentation score treats extents, whose file offset continues and
+ * whose status is the same, as one chunk. If the number of extents
+ * in chunk is equal to the ideal number of extents, the chunk is not used for
+ * the fragmentation score because there is no fragment in the chunk.
+ * The ideal number of extents is calculated based on @max_chunk_blks.
+ */
+unsigned int  e2p_get_fragscore(int fd, unsigned int threshold,
+					unsigned int max_chunk_blks, int *errp)
+{
+	char buf[4096] = "";
+	struct fiemap *fiemap = (struct fiemap *)buf;
+	struct fiemap_extent *fm_ext = &fiemap->fm_extents[0];
+	struct fiemap_extent prev_fm_ext;
+	unsigned int count = (sizeof(buf) - sizeof(*fiemap)) /
+				sizeof(struct fiemap_extent);
+	unsigned int total_cnt = 0, total_len = 0;
+	unsigned int ext_cnt = 0, ext_len = 0;
+	unsigned int i;
+	int bs, last = 0;
+
+	if (!threshold) {
+		*errp = EINVAL;
+		return 0;
+	}
+
+	/* Get the block size */
+	if (ioctl(fd, FIGETBSZ, &bs) < 0) {
+		*errp = errno;
+		return 0;
+	}
+
+	memset(fiemap, 0, sizeof(struct fiemap));
+	fiemap->fm_length = ~0ULL;
+	fiemap->fm_extent_count = count;
+
+	do {
+		if (ioctl(fd, FS_IOC_FIEMAP, (unsigned long) fiemap) < 0) {
+			*errp = errno;
+			return 0;
+		}
+
+		/* If 0 extents are returned, then more ioctls are not needed */
+		if (fiemap->fm_mapped_extents == 0)
+			break;
+
+		for (i = 0; i < fiemap->fm_mapped_extents; i++) {
+			if (ext_cnt && !is_extent_continued(&prev_fm_ext,
+								&fm_ext[i])) {
+				if (bad_contiguous_exts(max_chunk_blks,
+							ext_cnt, ext_len)) {
+					total_cnt += ext_cnt;
+					total_len += ext_len;
+				}
+				ext_cnt = 0;
+				ext_len = 0;
+			}
+			ext_cnt++;
+			ext_len += fm_ext[i].fe_length / bs;
+
+			memcpy(&prev_fm_ext, &fm_ext[i],
+					sizeof(struct fiemap_extent));
+
+			if (fm_ext[i].fe_flags & FIEMAP_EXTENT_LAST)
+				last = 1;
+		}
+
+		fiemap->fm_start = (fm_ext[i-1].fe_logical +
+				    fm_ext[i-1].fe_length);
+	} while (last == 0);
+
+	/* Check the tail contiguous extent */
+	if (ext_cnt) {
+		if (bad_contiguous_exts(max_chunk_blks, ext_cnt, ext_len)) {
+			total_cnt += ext_cnt;
+			total_len += ext_len;
+		}
+	}
+
+	/* Return 0 if there is no valid contiguous extent */
+	if (!total_len)
+		return 0;
+
+	return (unsigned int)(total_cnt / ((double)total_len / threshold));
+}
