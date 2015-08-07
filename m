From: Jan Kara <jack@suse.com>
Subject: [PATCH 18/19] ext2fs: Move extent mapping test
Date: Fri,  7 Aug 2015 12:51:28 +0200
Message-ID: <1438944689-24562-19-git-send-email-jack@suse.com>
References: <1438944689-24562-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbbHGKvt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Aug 2015 06:51:49 -0400
In-Reply-To: <1438944689-24562-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Move test program for excercising extent mapping code from resize2fs
into libext2fs since the code is now generic.

Signed-off-by: Jan Kara <jack@suse.com>
---
 lib/ext2fs/Makefile.in       |  12 +++-
 lib/ext2fs/tst_extent_map.c  | 127 +++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/tst_extent_map_in |  64 ++++++++++++++++++++++
 resize/Makefile.in           |  21 +------
 resize/test_extent.c         | 126 ------------------------------------------
 resize/test_extent.in        |  64 ----------------------
 6 files changed, 203 insertions(+), 211 deletions(-)
 create mode 100644 lib/ext2fs/tst_extent_map.c
 create mode 100644 lib/ext2fs/tst_extent_map_in
 delete mode 100644 resize/test_extent.c
 delete mode 100644 resize/test_extent.in

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 02ede7bbf856..98d8d3764e05 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -488,6 +488,14 @@ tst_extents: $(srcdir)/extent.c $(DEBUG_OBJS) $(DEPSTATIC_LIBSS) libext2fs.a \
 		$(STATIC_LIBEXT2FS) $(LIBBLKID) $(LIBUUID) \
 		$(STATIC_LIBCOM_ERR) $(SYSLIBS) -I $(top_srcdir)/debugfs
 
+tst_extent_map: $(srcdir)/extent_map.c $(DEPSTATIC_LIBSS) \
+		$(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
+	$(E) "	LD $@"
+	$(Q) $(CC) -o tst_extent_map $(srcdir)/tst_extent_map.c \
+		$(ALL_CFLAGS) $(ALL_LDFLAGS) -DDEBUG \
+		$(STATIC_LIBSS) $(STATIC_LIBEXT2FS) \
+		$(STATIC_LIBCOM_ERR) $(SYSLIBS)
+
 tst_libext2fs: $(DEBUG_OBJS) \
 	$(DEPSTATIC_LIBSS) $(STATIC_LIBE2P) $(DEPLIBUUID) libext2fs.a \
 	$(DEPLIBBLKID) $(DEPSTATIC_LIBCOM_ERR) $(DEPLIBQUOTA)
@@ -528,7 +536,7 @@ mkjournal: mkjournal.c $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
 check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount \
     tst_super_size tst_types tst_inode_size tst_csum tst_crc32c tst_bitmaps \
     tst_inline tst_inline_data tst_libext2fs tst_sha256 tst_sha512 \
-    tst_digest_encode
+    tst_digest_encode tst_extent_map
 	$(TESTENV) ./tst_bitops
 	$(TESTENV) ./tst_badblocks
 	$(TESTENV) ./tst_iscan
@@ -537,6 +545,8 @@ check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount \
 	$(TESTENV) ./tst_super_size
 	$(TESTENV) ./tst_inode_size
 	$(TESTENV) ./tst_csum
+	$(TESTENV) ./tst_extent_map <tst_extent_map_in >tst_extent_map_out
+	diff $(srcdir)/tst_extent_map_in tst_extent_map_out
 	$(TESTENV) ./tst_inline
 	$(TESTENV) ./tst_inline_data
 	$(TESTENV) ./tst_crc32c
diff --git a/lib/ext2fs/tst_extent_map.c b/lib/ext2fs/tst_extent_map.c
new file mode 100644
index 000000000000..a00dedb2932b
--- /dev/null
+++ b/lib/ext2fs/tst_extent_map.c
@@ -0,0 +1,127 @@
+/*
+ * test_extent.c --- tester for the extent abstraction
+ *
+ * Copyright (C) 1997, 1998 by Theodore Ts'o and
+ * 	PowerQuest, Inc.
+ *
+ * Copyright (C) 1999, 2000 by Theosore Ts'o
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include "config.h"
+
+#include "move.h"
+
+void do_test(FILE *in, FILE *out);
+
+void do_test(FILE *in, FILE *out)
+{
+	char		buf[128];
+	char		*cp, *cmd, *arg1, *arg2;
+	__u64		num1, num2;
+	__u64		size;
+	errcode_t	retval;
+	ext2_map_extent	extent = 0;
+	const char	*no_table = "# No extent table\n";
+
+	while (!feof(in)) {
+		if (!fgets(buf, sizeof(buf), in))
+			break;
+		/*
+		 * Ignore comments
+		 */
+		if (buf[0] =='#')
+			continue;
+
+		/*
+		 * Echo command
+		 */
+		fputs(buf, out);
+
+		cp = strchr(buf, '\n');
+		if (cp)
+			*cp = '\0';
+
+		/*
+		 * Parse command line; simple, at most two arguments
+		 */
+		cmd = buf;
+		num1 = num2 = 0;
+		arg1 = arg2 = 0;
+		cp = strchr(buf, ' ');
+		if (cp) {
+			*cp++ = '\0';
+			arg1 = cp;
+			num1 = strtoul(arg1, 0, 0);
+
+			cp = strchr(cp, ' ');
+		}
+		if (cp) {
+			*cp++ = '\0';
+			arg2 = cp;
+			num2 = strtoul(arg2, 0, 0);
+		}
+
+		if (!strcmp(cmd, "create")) {
+			retval = ext2fs_create_extent_table(&extent, num1);
+			if (retval) {
+			handle_error:
+				fprintf(out, "# Error: %s\n",
+					error_message(retval));
+				continue;
+			}
+			continue;
+		}
+		if (!extent) {
+			fputs(no_table, out);
+			continue;
+		}
+		if (!strcmp(cmd, "free")) {
+			ext2fs_free_extent_table(extent);
+			extent = 0;
+		} else if (!strcmp(cmd, "add")) {
+			retval = ext2fs_add_extent_entry(extent, num1, num2);
+			if (retval)
+				goto handle_error;
+		} else if (!strcmp(cmd, "lookup")) {
+			num2 = ext2fs_extent_translate(extent, num1);
+			fprintf(out, "# Answer: %llu%s\n", num2,
+				num2 ? "" : " (not found)");
+		} else if (!strcmp(cmd, "dump")) {
+			ext2fs_extent_dump(extent, out);
+		} else if (!strcmp(cmd, "iter_test")) {
+			retval = ext2fs_iterate_extent(extent, 0, 0, 0);
+			if (retval)
+				goto handle_error;
+			while (1) {
+				retval = ext2fs_iterate_extent(extent,
+					       &num1, &num2, &size);
+				if (retval)
+					goto handle_error;
+				if (!size)
+					break;
+				fprintf(out, "# %llu -> %llu (%llu)\n",
+					num1, num2, size);
+			}
+		} else
+			fputs("# Syntax error\n", out);
+	}
+	if (extent)
+		ext2fs_free_extent_table(extent);
+}
+
+#ifdef __GNUC__
+#define ATTR(x) __attribute__(x)
+#else
+#define ATTR(x)
+#endif
+
+int main(int argc ATTR((unused)), char **argv ATTR((unused)))
+{
+	do_test(stdin, stdout);
+	exit(0);
+}
diff --git a/lib/ext2fs/tst_extent_map_in b/lib/ext2fs/tst_extent_map_in
new file mode 100644
index 000000000000..7edcc41898a6
--- /dev/null
+++ b/lib/ext2fs/tst_extent_map_in
@@ -0,0 +1,64 @@
+create 10
+add 10 20
+add 11 21
+add 12 22
+add 14 45
+add 16 50
+add 17 51
+dump
+# Extent dump:
+#	Num=3, Size=10, Cursor=0, Sorted=1
+#		 10 -> 20 (3)
+#		 14 -> 45 (1)
+#		 16 -> 50 (2)
+add 18 52
+dump
+# Extent dump:
+#	Num=3, Size=10, Cursor=0, Sorted=1
+#		 10 -> 20 (3)
+#		 14 -> 45 (1)
+#		 16 -> 50 (3)
+lookup 10
+# Answer: 20
+lookup 11
+# Answer: 21
+lookup 12
+# Answer: 22
+lookup 13
+# Answer: 0 (not found)
+lookup 14
+# Answer: 45
+lookup 15
+# Answer: 0 (not found)
+lookup 16
+# Answer: 50
+lookup 1
+# Answer: 0 (not found)
+lookup 50
+# Answer: 0 (not found)
+add 19 100
+add 13 5
+lookup 18
+# Answer: 52
+lookup 19
+# Answer: 100
+lookup 20
+# Answer: 0 (not found)
+lookup 12
+# Answer: 22
+lookup 13
+# Answer: 5
+dump
+# Extent dump:
+#	Num=5, Size=10, Cursor=0, Sorted=1
+#		 10 -> 20 (3)
+#		 13 -> 5 (1)
+#		 14 -> 45 (1)
+#		 16 -> 50 (3)
+#		 19 -> 100 (1)
+iter_test
+# 10 -> 20 (3)
+# 13 -> 5 (1)
+# 14 -> 45 (1)
+# 16 -> 50 (3)
+# 19 -> 100 (1)
diff --git a/resize/Makefile.in b/resize/Makefile.in
index 82ae57adc4c5..f67188dcfd42 100644
--- a/resize/Makefile.in
+++ b/resize/Makefile.in
@@ -13,13 +13,10 @@ LDFLAG_STATIC = @LDFLAG_STATIC@
 @MCONFIG@
 
 PROGS=		resize2fs
-TEST_PROGS=	test_extent
 MANPAGES=	resize2fs.8
 
 RESIZE_OBJS= resize2fs.o main.o online.o resource_track.o sim_progress.o
 
-TEST_EXTENT_OBJS= test_extent.o
-
 SRCS= $(srcdir)/resize2fs.c \
 	$(srcdir)/main.c \
 	$(srcdir)/online.c \
@@ -54,10 +51,6 @@ resize2fs.8: $(DEP_SUBSTITUTE) $(srcdir)/resize2fs.8.in
 	$(E) "	SUBST $@"
 	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/resize2fs.8.in resize2fs.8
 
-test_extent: $(TEST_EXTENT_OBJS)
-	$(E) "	LD $@"
-	$(Q) $(CC) $(ALL_LDFLAGS) -o test_extent $(TEST_EXTENT_OBJS) $(LIBS) 
-
 installdirs:
 	$(E) "	MKINSTALLDIRS $(root_sbindir) $(man8dir)"
 	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(root_sbindir) \
@@ -90,21 +83,9 @@ uninstall:
 		$(RM) -f $(DESTDIR)$(man8dir)/$$i; \
 	done
 
-test_extent.out: test_extent $(srcdir)/test_extent.in
-	$(TESTENV) ./test_extent < $(srcdir)/test_extent.in > test_extent.out
-
-check:: test_extent.out
-	$(Q) if cmp -s test_extent.out $(srcdir)/test_extent.in ; then \
-		echo "Test succeeded." ; \
-	else \
-		echo "Test failed!" ; \
-		diff test_extent.out $(srcdir)/test_extent.in ; \
-		exit 1 ; \
-	fi
-
 clean::
 	$(RM) -f $(PROGS) $(TEST_PROGS) $(MANPAGES) \#* *.s *.o *.a *~ core \
-		resize2fs.static test_extent.out
+		resize2fs.static
 
 mostlyclean: clean
 
diff --git a/resize/test_extent.c b/resize/test_extent.c
deleted file mode 100644
index 60aa08f3577e..000000000000
--- a/resize/test_extent.c
+++ /dev/null
@@ -1,126 +0,0 @@
-/*
- * test_extent.c --- tester for the extent abstraction
- *
- * Copyright (C) 1997, 1998 by Theodore Ts'o and
- * 	PowerQuest, Inc.
- *
- * Copyright (C) 1999, 2000 by Theosore Ts'o
- *
- * %Begin-Header%
- * This file may be redistributed under the terms of the GNU Public
- * License.
- * %End-Header%
- */
-
-#include "config.h"
-#include "resize2fs.h"
-
-void do_test(FILE *in, FILE *out);
-
-void do_test(FILE *in, FILE *out)
-{
-	char		buf[128];
-	char		*cp, *cmd, *arg1, *arg2;
-	__u64		num1, num2;
-	__u64		size;
-	errcode_t	retval;
-	ext2_extent	extent = 0;
-	const char	*no_table = "# No extent table\n";
-
-	while (!feof(in)) {
-		if (!fgets(buf, sizeof(buf), in))
-			break;
-		/*
-		 * Ignore comments
-		 */
-		if (buf[0] =='#')
-			continue;
-
-		/*
-		 * Echo command
-		 */
-		fputs(buf, out);
-
-		cp = strchr(buf, '\n');
-		if (cp)
-			*cp = '\0';
-
-		/*
-		 * Parse command line; simple, at most two arguments
-		 */
-		cmd = buf;
-		num1 = num2 = 0;
-		arg1 = arg2 = 0;
-		cp = strchr(buf, ' ');
-		if (cp) {
-			*cp++ = '\0';
-			arg1 = cp;
-			num1 = strtoul(arg1, 0, 0);
-
-			cp = strchr(cp, ' ');
-		}
-		if (cp) {
-			*cp++ = '\0';
-			arg2 = cp;
-			num2 = strtoul(arg2, 0, 0);
-		}
-
-		if (!strcmp(cmd, "create")) {
-			retval = ext2fs_create_extent_table(&extent, num1);
-			if (retval) {
-			handle_error:
-				fprintf(out, "# Error: %s\n",
-					error_message(retval));
-				continue;
-			}
-			continue;
-		}
-		if (!extent) {
-			fputs(no_table, out);
-			continue;
-		}
-		if (!strcmp(cmd, "free")) {
-			ext2fs_free_extent_table(extent);
-			extent = 0;
-		} else if (!strcmp(cmd, "add")) {
-			retval = ext2fs_add_extent_entry(extent, num1, num2);
-			if (retval)
-				goto handle_error;
-		} else if (!strcmp(cmd, "lookup")) {
-			num2 = ext2fs_extent_translate(extent, num1);
-			fprintf(out, "# Answer: %llu%s\n", num2,
-				num2 ? "" : " (not found)");
-		} else if (!strcmp(cmd, "dump")) {
-			ext2fs_extent_dump(extent, out);
-		} else if (!strcmp(cmd, "iter_test")) {
-			retval = ext2fs_iterate_extent(extent, 0, 0, 0);
-			if (retval)
-				goto handle_error;
-			while (1) {
-				retval = ext2fs_iterate_extent(extent,
-					       &num1, &num2, &size);
-				if (retval)
-					goto handle_error;
-				if (!size)
-					break;
-				fprintf(out, "# %llu -> %llu (%llu)\n",
-					num1, num2, size);
-			}
-		} else
-			fputs("# Syntax error\n", out);
-	}
-	if (extent)
-		ext2fs_free_extent_table(extent);
-}
-
-#ifdef __GNUC__
-#define ATTR(x) __attribute__(x)
-#else
-#define ATTR(x)
-#endif
-
-int main(int argc ATTR((unused)), char **argv ATTR((unused)))
-{
-	do_test(stdin, stdout);
-	exit(0);
-}
diff --git a/resize/test_extent.in b/resize/test_extent.in
deleted file mode 100644
index 7edcc41898a6..000000000000
--- a/resize/test_extent.in
+++ /dev/null
@@ -1,64 +0,0 @@
-create 10
-add 10 20
-add 11 21
-add 12 22
-add 14 45
-add 16 50
-add 17 51
-dump
-# Extent dump:
-#	Num=3, Size=10, Cursor=0, Sorted=1
-#		 10 -> 20 (3)
-#		 14 -> 45 (1)
-#		 16 -> 50 (2)
-add 18 52
-dump
-# Extent dump:
-#	Num=3, Size=10, Cursor=0, Sorted=1
-#		 10 -> 20 (3)
-#		 14 -> 45 (1)
-#		 16 -> 50 (3)
-lookup 10
-# Answer: 20
-lookup 11
-# Answer: 21
-lookup 12
-# Answer: 22
-lookup 13
-# Answer: 0 (not found)
-lookup 14
-# Answer: 45
-lookup 15
-# Answer: 0 (not found)
-lookup 16
-# Answer: 50
-lookup 1
-# Answer: 0 (not found)
-lookup 50
-# Answer: 0 (not found)
-add 19 100
-add 13 5
-lookup 18
-# Answer: 52
-lookup 19
-# Answer: 100
-lookup 20
-# Answer: 0 (not found)
-lookup 12
-# Answer: 22
-lookup 13
-# Answer: 5
-dump
-# Extent dump:
-#	Num=5, Size=10, Cursor=0, Sorted=1
-#		 10 -> 20 (3)
-#		 13 -> 5 (1)
-#		 14 -> 45 (1)
-#		 16 -> 50 (3)
-#		 19 -> 100 (1)
-iter_test
-# 10 -> 20 (3)
-# 13 -> 5 (1)
-# 14 -> 45 (1)
-# 16 -> 50 (3)
-# 19 -> 100 (1)
-- 
2.1.4

