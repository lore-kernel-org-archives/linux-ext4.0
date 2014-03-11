From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/49] debugfs: create commands to edit extended attributes
Date: Mon, 10 Mar 2014 23:54:43 -0700
Message-ID: <20140311065443.30585.57456.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32180 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbaCKGyr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:54:47 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Enhance debugfs to be able to display and modify extended attributes, and
create some simple tests for the extended attribute editing functions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/Makefile.in        |   14 ++
 debugfs/debug_cmds.ct      |   12 ++
 debugfs/debugfs.c          |   62 ---------
 debugfs/debugfs.h          |    3 
 debugfs/xattrs.c           |  297 ++++++++++++++++++++++++++++++++++++++++++++
 tests/d_xattr_edits/expect |   51 ++++++++
 tests/d_xattr_edits/name   |    1 
 tests/d_xattr_edits/script |  135 ++++++++++++++++++++
 8 files changed, 510 insertions(+), 65 deletions(-)
 create mode 100644 debugfs/xattrs.c
 create mode 100644 tests/d_xattr_edits/expect
 create mode 100644 tests/d_xattr_edits/name
 create mode 100644 tests/d_xattr_edits/script


diff --git a/debugfs/Makefile.in b/debugfs/Makefile.in
index e0c5597..16d6aa7 100644
--- a/debugfs/Makefile.in
+++ b/debugfs/Makefile.in
@@ -18,18 +18,18 @@ MK_CMDS=	_SS_DIR_OVERRIDE=../lib/ss ../lib/ss/mk_cmds
 
 DEBUG_OBJS= debug_cmds.o debugfs.o util.o ncheck.o icheck.o ls.o \
 	lsdel.o dump.o set_fields.o logdump.o htree.o unused.o e2freefrag.o \
-	filefrag.o extent_cmds.o extent_inode.o zap.o create_inode.o
+	filefrag.o extent_cmds.o extent_inode.o zap.o create_inode.o xattrs.o
 
 RO_DEBUG_OBJS= ro_debug_cmds.o ro_debugfs.o util.o ncheck.o icheck.o ls.o \
 	lsdel.o logdump.o htree.o e2freefrag.o filefrag.o extent_cmds.o \
-	extent_inode.o
+	extent_inode.o xattrs.o
 
 SRCS= debug_cmds.c $(srcdir)/debugfs.c $(srcdir)/util.c $(srcdir)/ls.c \
 	$(srcdir)/ncheck.c $(srcdir)/icheck.c $(srcdir)/lsdel.c \
 	$(srcdir)/dump.c $(srcdir)/set_fields.c ${srcdir}/logdump.c \
 	$(srcdir)/htree.c $(srcdir)/unused.c ${srcdir}/../misc/e2freefrag.c \
 	$(srcdir)/filefrag.c $(srcdir)/extent_inode.c $(srcdir)/zap.c \
-	$(srcdir)/../misc/create_inode.c
+	$(srcdir)/../misc/create_inode.c $(srcdir)/xattrs.c
 
 LIBS= $(LIBEXT2FS) $(LIBE2P) $(LIBSS) $(LIBCOM_ERR) $(LIBBLKID) \
 	$(LIBUUID) $(SYSLIBS)
@@ -285,3 +285,11 @@ create_inode.o: $(srcdir)/../misc/create_inode.c \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/../misc/nls-enable.h
+xattrs.o: $(srcdir)/xattrs.c $(srcdir)/debugfs.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(srcdir)/jfs_user.h $(top_srcdir)/lib/ext2fs/kernel-jbd.h \
+ $(top_srcdir)/lib/ext2fs/jfs_compat.h $(top_srcdir)/lib/ext2fs/kernel-list.h
diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index 96ff00f..666032b 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -190,5 +190,17 @@ request do_zap_block, "Zap block: fill with 0, pattern, flip bits etc.",
 request do_block_dump, "Dump contents of a block",
 	block_dump, bd;
 
+request do_list_xattr, "List extended attributes of an inode",
+	ea_list;
+
+request do_get_xattr, "Get an extended attribute of an inode",
+	ea_get;
+
+request do_set_xattr, "Set an extended attribute of an inode",
+	ea_set;
+
+request do_rm_xattr, "Remove an extended attribute of an inode",
+	ea_rm;
+
 end;
 
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index d50bb42..a5cd007 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -492,27 +492,6 @@ static int list_blocks_proc(ext2_filsys fs EXT2FS_ATTR((unused)),
 	return 0;
 }
 
-static void dump_xattr_string(FILE *out, const char *str, int len)
-{
-	int printable = 0;
-	int i;
-
-	/* check: is string "printable enough?" */
-	for (i = 0; i < len; i++)
-		if (isprint(str[i]))
-			printable++;
-
-	if (printable <= len*7/8)
-		printable = 0;
-
-	for (i = 0; i < len; i++)
-		if (printable)
-			fprintf(out, isprint(str[i]) ? "%c" : "\\%03o",
-				(unsigned char)str[i]);
-		else
-			fprintf(out, "%02x ", (unsigned char)str[i]);
-}
-
 static void internal_dump_inode_extra(FILE *out,
 				      const char *prefix EXT2FS_ATTR((unused)),
 				      ext2_ino_t inode_num EXT2FS_ATTR((unused)),
@@ -532,47 +511,6 @@ static void internal_dump_inode_extra(FILE *out,
 	}
 }
 
-/* Dump extended attributes */
-static int dump_attr(char *name, char *value, size_t value_len, void *data)
-{
-	FILE *out = data;
-
-	fprintf(out, "  ");
-	dump_xattr_string(out, name, strlen(name));
-	fprintf(out, " = \"");
-	dump_xattr_string(out, value, value_len);
-	fprintf(out, "\" (%zu)\n", value_len);
-
-	return 0;
-}
-
-static void dump_inode_attributes(FILE *out, ext2_ino_t ino)
-{
-	struct ext2_xattr_handle *h;
-	size_t sz;
-	errcode_t err;
-
-	err = ext2fs_xattrs_open(current_fs, ino, &h);
-	if (err)
-		return;
-
-	err = ext2fs_xattrs_read(h);
-	if (err)
-		goto out;
-
-	err = ext2fs_xattrs_count(h, &sz);
-	if (err || sz == 0)
-		goto out;
-
-	fprintf(out, "Extended attributes:\n");
-	err = ext2fs_xattrs_iterate(h, dump_attr, out);
-	if (err)
-		goto out;
-
-out:
-	err = ext2fs_xattrs_close(&h);
-}
-
 static void dump_blocks(FILE *f, const char *prefix, ext2_ino_t inode)
 {
 	struct list_blocks_struct lb;
diff --git a/debugfs/debugfs.h b/debugfs/debugfs.h
index 5e3b256..3c27f82 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -175,6 +175,9 @@ extern void do_filefrag(int argc, char *argv[]);
 /* util.c */
 extern time_t string_to_time(const char *arg);
 
+/* xattrs.c */
+void dump_inode_attributes(FILE *out, ext2_ino_t ino);
+
 /* zap.c */
 extern void do_zap_block(int argc, char **argv);
 extern void do_block_dump(int argc, char **argv);
diff --git a/debugfs/xattrs.c b/debugfs/xattrs.c
new file mode 100644
index 0000000..0a29521
--- /dev/null
+++ b/debugfs/xattrs.c
@@ -0,0 +1,297 @@
+/*
+ * xattrs.c --- Modify extended attributes via debugfs.
+ *
+ * Copyright (C) 2014 Oracle.  This file may be redistributed
+ * under the terms of the GNU Public License.
+ */
+
+#include "config.h"
+#include <stdio.h>
+#ifdef HAVE_GETOPT_H
+#include <getopt.h>
+#else
+extern int optind;
+extern char *optarg;
+#endif
+#include <ctype.h>
+
+#include "debugfs.h"
+
+/* Dump extended attributes */
+static void dump_xattr_string(FILE *out, const char *str, int len)
+{
+	int printable = 0;
+	int i;
+
+	/* check: is string "printable enough?" */
+	for (i = 0; i < len; i++)
+		if (isprint(str[i]))
+			printable++;
+
+	if (printable <= len*7/8)
+		printable = 0;
+
+	for (i = 0; i < len; i++)
+		if (printable)
+			fprintf(out, isprint(str[i]) ? "%c" : "\\%03o",
+				(unsigned char)str[i]);
+		else
+			fprintf(out, "%02x ", (unsigned char)str[i]);
+}
+
+static int dump_attr(char *name, char *value, size_t value_len, void *data)
+{
+	FILE *out = data;
+
+	fprintf(out, "  ");
+	dump_xattr_string(out, name, strlen(name));
+	fprintf(out, " = \"");
+	dump_xattr_string(out, value, value_len);
+	fprintf(out, "\" (%zu)\n", value_len);
+
+	return 0;
+}
+
+void dump_inode_attributes(FILE *out, ext2_ino_t ino)
+{
+	struct ext2_xattr_handle *h;
+	size_t sz;
+	errcode_t err;
+
+	err = ext2fs_xattrs_open(current_fs, ino, &h);
+	if (err)
+		return;
+
+	err = ext2fs_xattrs_read(h);
+	if (err)
+		goto out;
+
+	err = ext2fs_xattrs_count(h, &sz);
+	if (err || sz == 0)
+		goto out;
+
+	fprintf(out, "Extended attributes:\n");
+	err = ext2fs_xattrs_iterate(h, dump_attr, out);
+	if (err)
+		goto out;
+
+out:
+	err = ext2fs_xattrs_close(&h);
+}
+
+void do_list_xattr(int argc, char **argv)
+{
+	ext2_ino_t ino;
+
+	if (argc != 2) {
+		printf("%s: Usage: %s <file>\n", argv[0],
+		       argv[0]);
+		return;
+	}
+
+	if (check_fs_open(argv[0]))
+		return;
+
+	ino = string_to_inode(argv[1]);
+	if (!ino)
+		return;
+
+	dump_inode_attributes(stdout, ino);
+}
+
+void do_get_xattr(int argc, char **argv)
+{
+	ext2_ino_t ino;
+	struct ext2_xattr_handle *h;
+	FILE *fp = NULL;
+	char *buf = NULL;
+	size_t buflen;
+	int i;
+	errcode_t err;
+
+	reset_getopt();
+	while ((i = getopt(argc, argv, "f:")) != -1) {
+		switch (i) {
+		case 'f':
+			fp = fopen(optarg, "w");
+			if (fp == NULL) {
+				perror(optarg);
+				return;
+			}
+			break;
+		default:
+			printf("%s: Usage: %s <file> <attr> [-f outfile]\n",
+			       argv[0], argv[0]);
+			return;
+		}
+	}
+
+	if (optind != argc - 2) {
+		printf("%s: Usage: %s <file> <attr> [-f outfile]\n", argv[0],
+		       argv[0]);
+		return;
+	}
+
+	if (check_fs_open(argv[0]))
+		return;
+
+	ino = string_to_inode(argv[optind]);
+	if (!ino)
+		return;
+
+	err = ext2fs_xattrs_open(current_fs, ino, &h);
+	if (err)
+		return;
+
+	err = ext2fs_xattrs_read(h);
+	if (err)
+		goto out;
+
+	err = ext2fs_xattr_get(h, argv[optind + 1], (void **)&buf, &buflen);
+	if (err)
+		goto out;
+
+	if (fp) {
+		fwrite(buf, buflen, 1, fp);
+		fclose(fp);
+	} else {
+		dump_xattr_string(stdout, buf, buflen);
+		printf("\n");
+	}
+
+	if (buf)
+		ext2fs_free_mem(&buf);
+out:
+	ext2fs_xattrs_close(&h);
+	if (err)
+		com_err(argv[0], err, "while getting extended attribute");
+}
+
+void do_set_xattr(int argc, char **argv)
+{
+	ext2_ino_t ino;
+	struct ext2_xattr_handle *h;
+	FILE *fp = NULL;
+	char *buf = NULL;
+	size_t buflen;
+	int i;
+	errcode_t err;
+
+	reset_getopt();
+	while ((i = getopt(argc, argv, "f:")) != -1) {
+		switch (i) {
+		case 'f':
+			fp = fopen(optarg, "r");
+			if (fp == NULL) {
+				perror(optarg);
+				return;
+			}
+			break;
+		default:
+			printf("%s: Usage: %s <file> <attr> [-f infile | "
+			       "value]\n", argv[0], argv[0]);
+			return;
+		}
+	}
+
+	if (optind != argc - 2 && optind != argc - 3) {
+		printf("%s: Usage: %s <file> <attr> [-f infile | value>]\n",
+		       argv[0], argv[0]);
+		return;
+	}
+
+	if (check_fs_open(argv[0]))
+		return;
+	if (check_fs_read_write(argv[0]))
+		return;
+	if (check_fs_bitmaps(argv[0]))
+		return;
+
+	ino = string_to_inode(argv[optind]);
+	if (!ino)
+		return;
+
+	err = ext2fs_xattrs_open(current_fs, ino, &h);
+	if (err)
+		return;
+
+	err = ext2fs_xattrs_read(h);
+	if (err)
+		goto out;
+
+	if (fp) {
+		err = ext2fs_get_mem(current_fs->blocksize, &buf);
+		if (err)
+			goto out;
+		buflen = fread(buf, 1, current_fs->blocksize, fp);
+	} else {
+		buf = argv[optind + 2];
+		buflen = strlen(argv[optind + 2]);
+	}
+
+	err = ext2fs_xattr_set(h, argv[optind + 1], buf, buflen);
+	if (err)
+		goto out;
+
+	err = ext2fs_xattrs_write(h);
+	if (err)
+		goto out;
+
+out:
+	if (fp) {
+		fclose(fp);
+		ext2fs_free_mem(&buf);
+	}
+	ext2fs_xattrs_close(&h);
+	if (err)
+		com_err(argv[0], err, "while setting extended attribute");
+}
+
+void do_rm_xattr(int argc, char **argv)
+{
+	ext2_ino_t ino;
+	struct ext2_xattr_handle *h;
+	int i;
+	errcode_t err;
+
+	if (argc < 3) {
+		printf("%s: Usage: %s <file> <attrs>...\n", argv[0], argv[0]);
+		return;
+	}
+
+	if (check_fs_open(argv[0]))
+		return;
+	if (check_fs_read_write(argv[0]))
+		return;
+	if (check_fs_bitmaps(argv[0]))
+		return;
+
+	ino = string_to_inode(argv[1]);
+	if (!ino)
+		return;
+
+	err = ext2fs_xattrs_open(current_fs, ino, &h);
+	if (err)
+		return;
+
+	err = ext2fs_xattrs_read(h);
+	if (err)
+		goto out;
+
+	for (i = 2; i < argc; i++) {
+		size_t buflen;
+		char *buf;
+
+		err = ext2fs_xattr_remove(h, argv[i]);
+		if (err)
+			goto out;
+	}
+
+	err = ext2fs_xattrs_write(h);
+	if (err)
+		goto out;
+out:
+	ext2fs_xattrs_close(&h);
+	if (err)
+		com_err(argv[0], err, "while removing extended attribute");
+}
diff --git a/tests/d_xattr_edits/expect b/tests/d_xattr_edits/expect
new file mode 100644
index 0000000..10e30c1
--- /dev/null
+++ b/tests/d_xattr_edits/expect
@@ -0,0 +1,51 @@
+debugfs edit extended attributes
+mke2fs -Fq -b 1024 test.img 512
+Exit status is 0
+ea_set / user.joe smith
+Exit status is 0
+ea_set / user.moo FEE_FIE_FOE_FUMMMMMM
+Exit status is 0
+ea_list /
+Extended attributes:
+  user.joe = "smith" (5)
+  user.moo = "FEE_FIE_FOE_FUMMMMMM" (20)
+Exit status is 0
+ea_get / user.moo
+FEE_FIE_FOE_FUMMMMMM
+Exit status is 0
+ea_get / nosuchea
+ea_get: Extended attribute key not found while getting extended attribute
+Exit status is 0
+ea_rm / user.moo
+Exit status is 0
+ea_rm / nosuchea
+ea_rm: Extended attribute key not found while removing extended attribute
+Exit status is 0
+ea_list /
+Extended attributes:
+  user.joe = "smith" (5)
+Exit status is 0
+ea_get / user.moo
+ea_get: Extended attribute key not found while getting extended attribute
+Exit status is 0
+ea_rm / user.joe
+Exit status is 0
+ea_list /
+Exit status is 0
+ea_set / user.file_based_xattr -f d_xattr_edits.tmp
+Exit status is 0
+ea_list /
+Extended attributes:
+  user.file_based_xattr = "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567\012" (108)
+Exit status is 0
+ea_get / user.file_based_xattr -f d_xattr_edits.ver.tmp
+Exit status is 0
+Compare big attribute
+e2fsck -yf -N test_filesys
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/64 files (0.0% non-contiguous), 29/512 blocks
+Exit status is 0
diff --git a/tests/d_xattr_edits/name b/tests/d_xattr_edits/name
new file mode 100644
index 0000000..c0c428c
--- /dev/null
+++ b/tests/d_xattr_edits/name
@@ -0,0 +1 @@
+edit extended attributes in debugfs
diff --git a/tests/d_xattr_edits/script b/tests/d_xattr_edits/script
new file mode 100644
index 0000000..1e33716
--- /dev/null
+++ b/tests/d_xattr_edits/script
@@ -0,0 +1,135 @@
+if test -x $DEBUGFS_EXE; then
+
+OUT=$test_name.log
+EXP=$test_dir/expect
+VERIFY_FSCK_OPT=-yf
+
+TEST_DATA=$test_name.tmp
+VERIFY_DATA=$test_name.ver.tmp
+
+echo "debugfs edit extended attributes" > $OUT
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo "mke2fs -Fq -b 1024 test.img 512" >> $OUT
+
+$MKE2FS -Fq $TMPFILE 512 > /dev/null 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+echo "ea_set / user.joe smith" > $OUT.new
+$DEBUGFS -w $TMPFILE -R "ea_set / user.joe smith" >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+
+echo "ea_set / user.moo FEE_FIE_FOE_FUMMMMMM" > $OUT.new
+$DEBUGFS -w $TMPFILE -R "ea_set / user.moo FEE_FIE_FOE_FUMMMMMM" >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+
+echo "ea_list /" > $OUT.new
+$DEBUGFS -w $TMPFILE -R "ea_list /" >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+
+echo "ea_get / user.moo" > $OUT.new
+$DEBUGFS -w $TMPFILE -R "ea_get / user.moo" >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+
+echo "ea_get / nosuchea" > $OUT.new
+$DEBUGFS -w $TMPFILE -R "ea_get / nosuchea" >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+
+echo "ea_rm / user.moo" > $OUT.new
+$DEBUGFS -w $TMPFILE -R "ea_rm / user.moo" >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+
+echo "ea_rm / nosuchea" > $OUT.new
+$DEBUGFS -w $TMPFILE -R "ea_rm / nosuchea" >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+
+echo "ea_list /" > $OUT.new
+$DEBUGFS -w $TMPFILE -R "ea_list /" >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+
+echo "ea_get / user.moo" > $OUT.new
+$DEBUGFS -w $TMPFILE -R "ea_get / user.moo" >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+
+echo "ea_rm / user.joe" > $OUT.new
+$DEBUGFS -w $TMPFILE -R "ea_rm / user.joe" >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+
+echo "ea_list /" > $OUT.new
+$DEBUGFS -w $TMPFILE -R "ea_list /" >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+
+echo "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567" > $TEST_DATA
+echo "ea_set / user.file_based_xattr -f $TEST_DATA" > $OUT.new
+$DEBUGFS -w $TMPFILE -R "ea_set / user.file_based_xattr -f $TEST_DATA" >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+
+echo "ea_list /" > $OUT.new
+$DEBUGFS -w $TMPFILE -R "ea_list /" >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+
+echo "ea_get / user.file_based_xattr -f $VERIFY_DATA" > $OUT.new
+$DEBUGFS -w $TMPFILE -R "ea_get / user.file_based_xattr -f $VERIFY_DATA" >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+
+echo "Compare big attribute" > $OUT.new
+diff -u $TEST_DATA $VERIFY_DATA >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+
+echo e2fsck $VERIFY_FSCK_OPT -N test_filesys > $OUT.new
+$FSCK $VERIFY_FSCK_OPT -N test_filesys $TMPFILE >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+
+#
+# Do the verification
+#
+
+rm -f $TMPFILE $OUT.new
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+fi
+
+unset VERIFY_FSCK_OPT NATIVE_FSCK_OPT OUT EXP TEST_DATA VERIFY_DATA
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi

