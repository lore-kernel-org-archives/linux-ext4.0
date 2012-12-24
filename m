From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] debugfs: add the ability to manipulate the extent tree directly
Date: Mon, 24 Dec 2012 11:06:24 -0500
Message-ID: <1356365185-4746-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40147 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab2LXQG0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Dec 2012 11:06:26 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit adds the functionality which had previously only been in
the tst_extents command to debugfs.  The debugfs command extent_open
will open extent tree of a particular inode, and enables a series of
commands which will allow the user to interact with the extent tree
directly.  Once the extent tree is closed via extent_open(), these
additional commands will be disabled again.

This commit exports two new functions from lib/ext2fs/extent.c which
had previously been statically defined: ext2fs_extent_node_split() and
ext2fs_extent_goto2().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/Makefile.in                                |  12 +-
 debugfs/debug_cmds.ct                              |   3 +
 debugfs/debugfs.c                                  |   5 +-
 debugfs/debugfs.h                                  |   3 +
 lib/ext2fs/extent_dbg.ct => debugfs/extent_cmds.ct |   6 +-
 debugfs/extent_inode.c                             | 547 +++++++++++++++++++++
 debugfs/ro_debug_cmds.ct                           |   3 +
 lib/ext2fs/Makefile.in                             |  18 +-
 lib/ext2fs/ext2fs.h                                |   3 +
 lib/ext2fs/extent.c                                | 489 +-----------------
 10 files changed, 595 insertions(+), 494 deletions(-)
 rename lib/ext2fs/extent_dbg.ct => debugfs/extent_cmds.ct (95%)
 create mode 100644 debugfs/extent_inode.c

diff --git a/debugfs/Makefile.in b/debugfs/Makefile.in
index 7e71c3f..42868a3 100644
--- a/debugfs/Makefile.in
+++ b/debugfs/Makefile.in
@@ -18,16 +18,16 @@ MK_CMDS=	_SS_DIR_OVERRIDE=../lib/ss ../lib/ss/mk_cmds
 
 DEBUG_OBJS= debug_cmds.o debugfs.o util.o ncheck.o icheck.o ls.o \
 	lsdel.o dump.o set_fields.o logdump.o htree.o unused.o e2freefrag.o \
-	filefrag.o
+	filefrag.o extent_cmds.o extent_inode.o
 
 RO_DEBUG_OBJS= ro_debug_cmds.o ro_debugfs.o util.o ncheck.o icheck.o ls.o \
-	lsdel.o logdump.o htree.o e2freefrag.o filefrag.o
+	lsdel.o logdump.o htree.o e2freefrag.o filefrag.o extent_inode.o
 
 SRCS= debug_cmds.c $(srcdir)/debugfs.c $(srcdir)/util.c $(srcdir)/ls.c \
 	$(srcdir)/ncheck.c $(srcdir)/icheck.c $(srcdir)/lsdel.c \
 	$(srcdir)/dump.c $(srcdir)/set_fields.c ${srcdir}/logdump.c \
 	$(srcdir)/htree.c $(srcdir)/unused.c ${srcdir}/../misc/e2freefrag.c \
-	$(srcdir)/filefrag.c
+	$(srcdir)/filefrag.c $(srcdir)/extent_inode.c
 
 LIBS= $(LIBEXT2FS) $(LIBE2P) $(LIBSS) $(LIBCOM_ERR) $(LIBBLKID) \
 	$(LIBUUID)
@@ -52,6 +52,10 @@ debug_cmds.c debug_cmds.h: debug_cmds.ct
 	$(E) "	MK_CMDS $@"
 	$(Q) $(MK_CMDS) $(srcdir)/debug_cmds.ct
 
+extent_cmds.c extent_cmds.h: extent_cmds.ct
+	$(E) "	MK_CMDS $@"
+	$(Q) $(MK_CMDS) $(srcdir)/extent_cmds.ct
+
 ro_debug_cmds.c ro_debug_cmds.h: ro_debug_cmds.ct
 	$(E) "	MK_CMDS $@"
 	$(Q) $(MK_CMDS) $(srcdir)/ro_debug_cmds.ct
@@ -102,7 +106,7 @@ uninstall:
 
 clean:
 	$(RM) -f $(PROGS) debugfs.8 \#* *.s *.o *.a *~ debug_cmds.c \
-		ro_debug_cmds.c core rdebugfs
+		extent_cmds.c ro_debug_cmds.c core rdebugfs
 
 mostlyclean: clean
 distclean: clean
diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index a799dd7..7767f8f 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -178,5 +178,8 @@ request do_dump_mmp, "Dump MMP information",
 request do_set_mmp_value, "Set MMP value",
 	set_mmp_value, smmp;
 
+request do_extent_open, "Open inode for extent manipulation",
+	extent_open, eo;
+
 end;
 
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index cf80bd0..9bcfd52 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -28,8 +28,6 @@ extern char *optarg;
 #include <sys/types.h>
 #include <sys/stat.h>
 
-#include "et/com_err.h"
-#include "ss/ss.h"
 #include "debugfs.h"
 #include "uuid/uuid.h"
 #include "e2p/e2p.h"
@@ -39,9 +37,9 @@ extern char *optarg;
 #include "../version.h"
 #include "jfs_user.h"
 
-extern ss_request_table debug_cmds;
 ss_request_table *extra_cmds;
 const char *debug_prog_name;
+int sci_idx;
 
 ext2_filsys	current_fs = NULL;
 ext2_ino_t	root, cwd;
@@ -2284,7 +2282,6 @@ static int source_file(const char *cmd_file, int sci_idx)
 int main(int argc, char **argv)
 {
 	int		retval;
-	int		sci_idx;
 	const char	*usage = 
 		"Usage: %s [-b blocksize] [-s superblock] [-f cmd_file] "
 		"[-R request] [-V] ["
diff --git a/debugfs/debugfs.h b/debugfs/debugfs.h
index 994577c..efd8d12 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -2,6 +2,7 @@
  * debugfs.h --- header file for the debugfs program
  */
 
+#include "ss/ss.h"
 #include "ext2fs/ext2_fs.h"
 #include "ext2fs/ext2fs.h"
 
@@ -21,6 +22,8 @@
 
 extern ext2_filsys current_fs;
 extern ext2_ino_t	root, cwd;
+extern int sci_idx;
+extern ss_request_table debug_cmds, extent_cmds;
 
 extern void reset_getopt(void);
 extern FILE *open_pager(void);
diff --git a/lib/ext2fs/extent_dbg.ct b/debugfs/extent_cmds.ct
similarity index 95%
rename from lib/ext2fs/extent_dbg.ct
rename to debugfs/extent_cmds.ct
index c1d8033..e1c4395 100644
--- a/lib/ext2fs/extent_dbg.ct
+++ b/debugfs/extent_cmds.ct
@@ -4,9 +4,6 @@
 #
 command_table extent_cmds;
 
-request do_inode, "Open an inode",
-	inode;
-
 request do_current_node, "Current extent node",
 	current_node, current;
 
@@ -73,5 +70,8 @@ request do_goto_block, "Goto extent containing specified block",
 request do_info, "Print extent info",
 	info;
 
+request do_extent_close, "Close extent handle",
+	extent_close, ec;
+
 end;
 
diff --git a/debugfs/extent_inode.c b/debugfs/extent_inode.c
new file mode 100644
index 0000000..69628a9
--- /dev/null
+++ b/debugfs/extent_inode.c
@@ -0,0 +1,547 @@
+/*
+ * extent_inode.c --- direct extent tree manipulation
+ *
+ * Copyright (C) 2012 Theodore Ts'o.  This file may be redistributed
+ * under the terms of the GNU Public License.
+ */
+
+#include "config.h"
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <ctype.h>
+#include <string.h>
+#include <time.h>
+#ifdef HAVE_ERRNO_H
+#include <errno.h>
+#endif
+#include <sys/types.h>
+#ifdef HAVE_GETOPT_H
+#include <getopt.h>
+#else
+extern int optind;
+extern char *optarg;
+#endif
+
+#include "debugfs.h"
+
+ext2_ino_t	current_ino;
+ext2_extent_handle_t current_handle;
+
+static void dbg_print_extent(char *desc, struct ext2fs_extent *extent)
+{
+	if (desc)
+		printf("%s: ", desc);
+	printf("extent: lblk %llu--%llu, len %u, pblk %llu, flags: ",
+	       extent->e_lblk, extent->e_lblk + extent->e_len - 1,
+	       extent->e_len, extent->e_pblk);
+	if (extent->e_flags & EXT2_EXTENT_FLAGS_LEAF)
+		fputs("LEAF ", stdout);
+	if (extent->e_flags & EXT2_EXTENT_FLAGS_UNINIT)
+		fputs("UNINIT ", stdout);
+	if (extent->e_flags & EXT2_EXTENT_FLAGS_SECOND_VISIT)
+		fputs("2ND_VISIT ", stdout);
+	if (!extent->e_flags)
+		fputs("(none)", stdout);
+	fputc('\n', stdout);
+
+}
+
+int common_extent_args_process(int argc, char *argv[], int min_argc,
+			       int max_argc, const char *cmd,
+			       const char *usage, int flags)
+{
+	if (common_args_process(argc, argv, min_argc, max_argc, cmd,
+				usage, flags))
+		return 1;
+
+	if (!current_handle) {
+		com_err(cmd, 0, "Extent handle not open");
+		return 1;
+	}
+	return 0;
+}
+
+static char *orig_prompt, *extent_prompt;
+
+void do_extent_open(int argc, char *argv[])
+{
+	struct ext3_extent_header *eh;
+	ext2_ino_t	inode;
+	int		i, ret;
+	errcode_t	retval;
+	char		*cp;
+
+	if (check_fs_open(argv[0]))
+		return;
+
+	if (argc == 1) {
+		if (current_ino)
+			printf("Current inode is %d\n", current_ino);
+		else
+			printf("No current inode\n");
+		return;
+	}
+
+	if (common_inode_args_process(argc, argv, &inode, 0))
+		return;
+
+	current_ino = 0;
+
+	retval = ext2fs_extent_open(current_fs, inode, &current_handle);
+	if (retval) {
+		com_err(argv[1], retval, "while opening extent handle");
+		return;
+	}
+
+	current_ino = inode;
+
+	orig_prompt = ss_get_prompt(sci_idx);
+	extent_prompt = malloc(strlen(orig_prompt) + 32);
+	strcpy(extent_prompt, orig_prompt);
+	cp = strchr(extent_prompt, ':');
+	if (cp)
+		*cp = 0;
+	sprintf(extent_prompt + strlen(extent_prompt), " (extent ino %d): ",
+		current_ino);
+	ss_add_request_table(sci_idx, &extent_cmds, 1, &ret);
+	ss_set_prompt(sci_idx, extent_prompt);
+	return;
+}
+
+void do_extent_close(int argc, char *argv[])
+{
+	int ret;
+
+	if (check_fs_open(argv[0]))
+		return;
+
+	if (!current_handle) {
+		com_err(argv[0], 0, "Extent handle not open");
+		return;
+	}
+
+	ext2fs_extent_free(current_handle);
+	current_handle = NULL;
+	current_ino = 0;
+	ss_delete_request_table(sci_idx, &extent_cmds, &ret);
+	ss_set_prompt(sci_idx, orig_prompt);
+	free(extent_prompt);
+	extent_prompt = NULL;
+}
+
+void generic_goto_node(char *cmd_name, int op)
+{
+	struct ext2fs_extent	extent;
+	errcode_t		retval;
+
+	if (check_fs_open(cmd_name))
+		return;
+
+	if (!current_handle) {
+		com_err(cmd_name, 0, "Extent handle not open");
+		return;
+	}
+
+	retval = ext2fs_extent_get(current_handle, op, &extent);
+	if (retval) {
+		com_err(cmd_name, retval, 0);
+		return;
+	}
+	dbg_print_extent(0, &extent);
+}
+
+void do_current_node(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_CURRENT);
+}
+
+void do_root_node(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_ROOT);
+}
+
+void do_last_leaf(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_LAST_LEAF);
+}
+
+void do_first_sib(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_FIRST_SIB);
+}
+
+void do_last_sib(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_LAST_SIB);
+}
+
+void do_next_sib(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_NEXT_SIB);
+}
+
+void do_prev_sib(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_PREV_SIB);
+}
+
+void do_next_leaf(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_NEXT_LEAF);
+}
+
+void do_prev_leaf(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_PREV_LEAF);
+}
+
+void do_next(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_NEXT);
+}
+
+void do_prev(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_PREV);
+}
+
+void do_up(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_UP);
+}
+
+void do_down(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_DOWN);
+}
+
+void do_delete_node(int argc, char *argv[])
+{
+	struct ext2fs_extent extent;
+	errcode_t	retval;
+	int		err;
+
+	if (common_extent_args_process(argc, argv, 1, 1, "delete_node",
+				       "", CHECK_FS_RW | CHECK_FS_BITMAPS))
+		return;
+
+	retval = ext2fs_extent_delete(current_handle, 0);
+	if (retval) {
+		com_err(argv[0], retval, 0);
+		return;
+	}
+
+	retval = ext2fs_extent_get(current_handle, EXT2_EXTENT_CURRENT,
+				   &extent);
+	if (retval)
+		return;
+	dbg_print_extent(0, &extent);
+}
+
+void do_replace_node(int argc, char *argv[])
+{
+	const char	*usage = "[--uninit] <lblk> <len> <pblk>";
+	errcode_t	retval;
+	struct ext2fs_extent extent;
+	int err;
+
+	if (common_extent_args_process(argc, argv, 3, 5, "replace_node",
+				       usage, CHECK_FS_RW | CHECK_FS_BITMAPS))
+		return;
+
+	extent.e_flags = 0;
+
+	if (!strcmp(argv[1], "--uninit")) {
+		argc--;
+		argv++;
+		extent.e_flags |= EXT2_EXTENT_FLAGS_UNINIT;
+	}
+
+	if (argc != 4) {
+		fprintf(stderr, "Usage: %s %s\n", argv[0], usage);
+		return;
+	}
+
+	extent.e_lblk = parse_ulong(argv[1], argv[0], "logical block", &err);
+	if (err)
+		return;
+
+	extent.e_len = parse_ulong(argv[2], argv[0], "logical block", &err);
+	if (err)
+		return;
+
+	extent.e_pblk = parse_ulong(argv[3], argv[0], "logical block", &err);
+	if (err)
+		return;
+
+	retval = ext2fs_extent_replace(current_handle, 0, &extent);
+	if (retval) {
+		com_err(argv[0], retval, 0);
+		return;
+	}
+	do_current_node(argc, argv);
+}
+
+void do_split_node(int argc, char *argv[])
+{
+	errcode_t	retval;
+	struct ext2fs_extent extent;
+	int err;
+
+	if (common_extent_args_process(argc, argv, 1, 1, "split_node",
+				       "", CHECK_FS_RW | CHECK_FS_BITMAPS))
+		return;
+
+	retval = ext2fs_extent_node_split(current_handle);
+	if (retval) {
+		com_err(argv[0], retval, 0);
+		return;
+	}
+	do_current_node(argc, argv);
+}
+
+void do_insert_node(int argc, char *argv[])
+{
+	const char	*usage = "[--after] [--uninit] <lblk> <len> <pblk>";
+	errcode_t	retval;
+	struct ext2fs_extent extent;
+	char *cmd;
+	int err;
+	int flags = 0;
+
+	if (common_extent_args_process(argc, argv, 3, 6, "insert_node",
+				       usage, CHECK_FS_RW | CHECK_FS_BITMAPS))
+		return;
+
+	cmd = argv[0];
+
+	extent.e_flags = 0;
+
+	while (argc > 2) {
+		if (!strcmp(argv[1], "--after")) {
+			argc--;
+			argv++;
+			flags |= EXT2_EXTENT_INSERT_AFTER;
+			continue;
+		}
+		if (!strcmp(argv[1], "--uninit")) {
+			argc--;
+			argv++;
+			extent.e_flags |= EXT2_EXTENT_FLAGS_UNINIT;
+			continue;
+		}
+		break;
+	}
+
+	if (argc != 4) {
+		fprintf(stderr, "usage: %s %s\n", cmd, usage);
+		return;
+	}
+
+	extent.e_lblk = parse_ulong(argv[1], cmd,
+				    "logical block", &err);
+	if (err)
+		return;
+
+	extent.e_len = parse_ulong(argv[2], cmd,
+				    "length", &err);
+	if (err)
+		return;
+
+	extent.e_pblk = parse_ulong(argv[3], cmd,
+				    "pysical block", &err);
+	if (err)
+		return;
+
+	retval = ext2fs_extent_insert(current_handle, flags, &extent);
+	if (retval) {
+		com_err(cmd, retval, 0);
+		return;
+	}
+	do_current_node(argc, argv);
+}
+
+void do_set_bmap(int argc, char **argv)
+{
+	const char	*usage = "[--uninit] <lblk> <pblk>";
+	struct ext2fs_extent extent;
+	errcode_t	retval;
+	blk_t		logical;
+	blk_t		physical;
+	char		*cmd = argv[0];
+	int		flags = 0;
+	int		err;
+
+	if (common_extent_args_process(argc, argv, 3, 5, "set_bmap",
+				       usage, CHECK_FS_RW | CHECK_FS_BITMAPS))
+		return;
+
+	if (argc > 2 && !strcmp(argv[1], "--uninit")) {
+		argc--;
+		argv++;
+		flags |= EXT2_EXTENT_SET_BMAP_UNINIT;
+	}
+
+	if (argc != 3) {
+		fprintf(stderr, "Usage: %s %s\n", cmd, usage);
+		return;
+	}
+
+	logical = parse_ulong(argv[1], cmd,
+				    "logical block", &err);
+	if (err)
+		return;
+
+	physical = parse_ulong(argv[2], cmd,
+				    "physical block", &err);
+	if (err)
+		return;
+
+	retval = ext2fs_extent_set_bmap(current_handle, logical,
+					(blk64_t) physical, flags);
+	if (retval) {
+		com_err(cmd, retval, 0);
+		return;
+	}
+
+	retval = ext2fs_extent_get(current_handle, EXT2_EXTENT_CURRENT,
+				   &extent);
+	if (retval)
+		return;
+	dbg_print_extent(0, &extent);
+}
+
+void do_print_all(int argc, char **argv)
+{
+	const char	*usage = "[--leaf-only|--reverse|--reverse-leaf]";
+	struct ext2fs_extent	extent;
+	errcode_t		retval;
+	errcode_t		end_err = EXT2_ET_EXTENT_NO_NEXT;
+	int			op = EXT2_EXTENT_NEXT;
+	int			first_op = EXT2_EXTENT_ROOT;
+
+
+	if (common_extent_args_process(argc, argv, 1, 2, "print_all",
+				       usage, 0))
+		return;
+
+	if (argc == 2) {
+		if (!strcmp(argv[1], "--leaf-only"))
+			op = EXT2_EXTENT_NEXT_LEAF;
+		else if (!strcmp(argv[1], "--reverse")) {
+			op = EXT2_EXTENT_PREV;
+			first_op = EXT2_EXTENT_LAST_LEAF;
+			end_err = EXT2_ET_EXTENT_NO_PREV;
+		} else if (!strcmp(argv[1], "--reverse-leaf")) {
+			op = EXT2_EXTENT_PREV_LEAF;
+			first_op = EXT2_EXTENT_LAST_LEAF;
+			end_err = EXT2_ET_EXTENT_NO_PREV;
+		} else {
+			fprintf(stderr, "Usage: %s %s\n", argv[0], usage);
+			return;
+		}
+	}
+
+	retval = ext2fs_extent_get(current_handle, first_op, &extent);
+	if (retval) {
+		com_err(argv[0], retval, 0);
+		return;
+	}
+	dbg_print_extent(0, &extent);
+
+	while (1) {
+		retval = ext2fs_extent_get(current_handle, op, &extent);
+		if (retval == end_err)
+			break;
+
+		if (retval) {
+			com_err(argv[0], retval, 0);
+			return;
+		}
+		dbg_print_extent(0, &extent);
+	}
+}
+
+void do_fix_parents(int argc, char **argv)
+{
+	struct ext2fs_extent	extent;
+	struct ext2_extent_info	info;
+	errcode_t		retval;
+
+	if (common_extent_args_process(argc, argv, 1, 1, "fix_parents", "",
+				       CHECK_FS_RW))
+		return;
+
+	retval = ext2fs_extent_fix_parents(current_handle);
+	if (retval) {
+		com_err(argv[0], retval, 0);
+		return;
+	}
+}
+
+void do_info(int argc, char **argv)
+{
+	struct ext2fs_extent	extent;
+	struct ext2_extent_info	info;
+	errcode_t		retval;
+
+	if (common_extent_args_process(argc, argv, 1, 1, "info", "", 0))
+		return;
+
+	retval = ext2fs_extent_get_info(current_handle, &info);
+	if (retval) {
+		com_err(argv[0], retval, 0);
+		return;
+	}
+
+	retval = ext2fs_extent_get(current_handle,
+				   EXT2_EXTENT_CURRENT, &extent);
+	if (retval) {
+		com_err(argv[0], retval, 0);
+		return;
+	}
+
+	dbg_print_extent(0, &extent);
+
+	printf("Current handle location: %d/%d (max: %d, bytes %d), level %d/%d\n",
+	       info.curr_entry, info.num_entries, info.max_entries,
+	       info.bytes_avail, info.curr_level, info.max_depth);
+	printf("\tmax lblk: %llu, max pblk: %llu\n", info.max_lblk,
+	       info.max_pblk);
+	printf("\tmax_len: %u, max_uninit_len: %u\n", info.max_len,
+	       info.max_uninit_len);
+}
+
+void do_goto_block(int argc, char **argv)
+{
+	struct ext2fs_extent	extent;
+	errcode_t		retval;
+	int			op = EXT2_EXTENT_NEXT_LEAF;
+	blk64_t			blk;
+	int			level = 0, err;
+
+	if (common_extent_args_process(argc, argv, 2, 3, "goto_block",
+				       "block [level]", 0))
+		return;
+
+	if (strtoblk(argv[0], argv[1], &blk))
+		return;
+
+	if (argc == 3) {
+		level = parse_ulong(argv[2], argv[0], "level", &err);
+		if (err)
+			return;
+	}
+
+	retval = ext2fs_extent_goto2(current_handle, level, (blk64_t) blk);
+
+	if (retval) {
+		com_err(argv[0], retval,
+			"while trying to go to block %llu, level %d",
+			(unsigned long long) blk, level);
+		return;
+	}
+
+	generic_goto_node(argv[0], EXT2_EXTENT_CURRENT);
+}
diff --git a/debugfs/ro_debug_cmds.ct b/debugfs/ro_debug_cmds.ct
index 4feb621..8226d1a 100644
--- a/debugfs/ro_debug_cmds.ct
+++ b/debugfs/ro_debug_cmds.ct
@@ -87,5 +87,8 @@ request do_supported_features, "Print features supported by this version of e2fs
 request do_dump_mmp, "Dump MMP information",
 	dump_mmp;
 
+request do_extent_open, "Open inode for extent manipulation",
+	extent_open, eo;
+
 end;
 
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 0aaa6d6..8eb2f7c 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -292,17 +292,25 @@ extent_dbg.c: $(srcdir)/extent_dbg.ct
 	$(Q) $(MK_CMDS) $(srcdir)/extent_dbg.ct
 
 debug_cmds.c debug_cmds.h: $(top_srcdir)/debugfs/debug_cmds.ct
-	$(E) "	MK_CMDS $<@"
+	$(E) "	MK_CMDS $<"
 	$(Q) $(MK_CMDS) $(top_srcdir)/debugfs/debug_cmds.ct
 
+extent_cmds.c extent_cmds.h: $(top_srcdir)/debugfs/extent_cmds.ct
+	$(E) "	MK_CMDS $<"
+	$(Q) $(MK_CMDS) $(top_srcdir)/debugfs/extent_cmds.ct
+
 DEBUG_OBJS= debug_cmds.o debugfs.o util.o ncheck.o icheck.o ls.o \
 	lsdel.o dump.o set_fields.o logdump.o htree.o unused.o \
-	e2freefrag.o filefrag.o
+	e2freefrag.o filefrag.o extent_inode.o extent_cmds.o
 
 debugfs.o: $(top_srcdir)/debugfs/debugfs.c
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
 
+extent_inode.o: $(top_srcdir)/debugfs/extent_inode.c
+	$(E) "	CC $<"
+	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+
 util.o: $(top_srcdir)/debugfs/util.c
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
@@ -361,10 +369,10 @@ tst_bitmaps: tst_bitmaps.o tst_bitmaps_cmd.o $(STATIC_LIBEXT2FS) $(DEPLIBSS) \
 	$(Q) $(CC) -o $@ tst_bitmaps.o tst_bitmaps_cmd.o $(ALL_CFLAGS) \
 		$(STATIC_LIBEXT2FS) $(LIBSS) $(STATIC_LIBCOM_ERR)
 
-tst_extents: $(srcdir)/extent.c extent_dbg.c $(DEBUG_OBJS) $(DEPLIBSS) \
+tst_extents: $(srcdir)/extent.c $(DEBUG_OBJS) $(DEPLIBSS) \
 	$(LIBE2P) $(DEPLIBUUID) $(DEPLIBBLKID) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
-	$(Q) $(CC) -o tst_extents $(srcdir)/extent.c extent_dbg.c \
+	$(Q) $(CC) -o tst_extents $(srcdir)/extent.c \
 		$(ALL_CFLAGS) -DDEBUG $(DEBUG_OBJS) $(LIBSS) $(LIBE2P) \
 		$(STATIC_LIBEXT2FS) $(LIBBLKID) $(LIBUUID) $(STATIC_LIBCOM_ERR) \
 		-I $(top_srcdir)/debugfs
@@ -446,7 +454,7 @@ clean::
 		tst_byteswap tst_ismounted tst_getsize tst_sectgetsize \
 		tst_bitops tst_types tst_icount tst_super_size tst_csum \
 		tst_bitmaps tst_bitmaps_out tst_bitmaps_cmd.c \
-		ext2_tdbtool mkjournal debug_cmds.c \
+		ext2_tdbtool mkjournal debug_cmds.c extent_cmds.c \
 		../libext2fs.a ../libext2fs_p.a ../libext2fs_chk.a \
 		crc32c_table.h gen_crc32ctable tst_crc32c
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 1b35ff7..a06f57e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1070,6 +1070,7 @@ extern errcode_t ext2fs_extent_open2(ext2_filsys fs, ext2_ino_t ino,
 extern void ext2fs_extent_free(ext2_extent_handle_t handle);
 extern errcode_t ext2fs_extent_get(ext2_extent_handle_t handle,
 				   int flags, struct ext2fs_extent *extent);
+extern errcode_t ext2fs_extent_node_split(ext2_extent_handle_t handle);
 extern errcode_t ext2fs_extent_replace(ext2_extent_handle_t handle, int flags,
 				       struct ext2fs_extent *extent);
 extern errcode_t ext2fs_extent_insert(ext2_extent_handle_t handle, int flags,
@@ -1082,6 +1083,8 @@ extern errcode_t ext2fs_extent_get_info(ext2_extent_handle_t handle,
 					struct ext2_extent_info *info);
 extern errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
 				    blk64_t blk);
+extern errcode_t ext2fs_extent_goto2(ext2_extent_handle_t handle,
+				     int leaf_level, blk64_t blk);
 extern errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle);
 
 /* fileio.c */
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index c6716bc..4d6af88 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -604,8 +604,8 @@ errcode_t ext2fs_extent_free_path(ext2_extent_path_t path)
  * If "blk" has no mapping (hole) then handle is left at last
  * extent before blk.
  */
-static errcode_t extent_goto(ext2_extent_handle_t handle,
-			     int leaf_level, blk64_t blk)
+errcode_t ext2fs_extent_goto2(ext2_extent_handle_t handle,
+			      int leaf_level, blk64_t blk)
 {
 	struct ext2fs_extent	extent;
 	errcode_t		retval;
@@ -694,7 +694,7 @@ static errcode_t extent_goto(ext2_extent_handle_t handle,
 errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
 			     blk64_t blk)
 {
-	return extent_goto(handle, 0, blk);
+	return ext2fs_extent_goto2(handle, 0, blk);
 }
 
 /*
@@ -756,7 +756,7 @@ errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle)
 	}
 
 	/* put handle back to where we started */
-	retval = extent_goto(handle, orig_height, start);
+	retval = ext2fs_extent_goto2(handle, orig_height, start);
 done:
 	return retval;
 }
@@ -819,7 +819,7 @@ errcode_t ext2fs_extent_replace(ext2_extent_handle_t handle,
  *
  * handle will be left pointing at original record.
  */
-static errcode_t extent_node_split(ext2_extent_handle_t handle)
+errcode_t ext2fs_extent_node_split(ext2_extent_handle_t handle)
 {
 	errcode_t			retval = 0;
 	blk64_t				new_node_pblk;
@@ -874,12 +874,12 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle)
 			goto done;
 		goal_blk = extent.e_pblk;
 
-		retval = extent_node_split(handle);
+		retval = ext2fs_extent_node_split(handle);
 		if (retval)
 			goto done;
 
 		/* get handle back to our original split position */
-		retval = extent_goto(handle, orig_height, orig_lblk);
+		retval = ext2fs_extent_goto2(handle, orig_height, orig_lblk);
 		if (retval)
 			goto done;
 	}
@@ -1028,7 +1028,7 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle)
 	}
 
 	/* get handle back to our original position */
-	retval = extent_goto(handle, orig_height, orig_lblk);
+	retval = ext2fs_extent_goto2(handle, orig_height, orig_lblk);
 	if (retval)
 		goto done;
 
@@ -1079,7 +1079,7 @@ errcode_t ext2fs_extent_insert(ext2_extent_handle_t handle, int flags,
 			printf("node full (level %d) - splitting\n",
 				   handle->level);
 #endif
-			retval = extent_node_split(handle);
+			retval = ext2fs_extent_node_split(handle);
 			if (retval)
 				return retval;
 			path = handle->path + handle->level;
@@ -1447,7 +1447,7 @@ done:
 	/* get handle back to its position */
 	if (orig_height > handle->max_depth)
 		orig_height = handle->max_depth; /* In case we shortened the tree */
-	extent_goto(handle, orig_height, orig_lblk);
+	ext2fs_extent_goto2(handle, orig_height, orig_lblk);
 	return retval;
 }
 
@@ -1559,477 +1559,10 @@ errcode_t ext2fs_extent_get_info(ext2_extent_handle_t handle,
 }
 
 #ifdef DEBUG
-
-#include "ss/ss.h"
-
-#include "debugfs.h"
-
 /*
- * Hook in new commands into debugfs
+ * Override debugfs's prompt
  */
 const char *debug_prog_name = "tst_extents";
-extern ss_request_table extent_cmds;
-ss_request_table *extra_cmds = &extent_cmds;
-
-ext2_ino_t	current_ino = 0;
-ext2_extent_handle_t current_handle;
-
-int common_extent_args_process(int argc, char *argv[], int min_argc,
-			       int max_argc, const char *cmd,
-			       const char *usage, int flags)
-{
-	if (common_args_process(argc, argv, min_argc, max_argc, cmd,
-				usage, flags))
-		return 1;
-
-	if (!current_handle) {
-		com_err(cmd, 0, "Extent handle not open");
-		return 1;
-	}
-	return 0;
-}
-
-void do_inode(int argc, char *argv[])
-{
-	ext2_ino_t	inode;
-	int		i;
-	struct ext3_extent_header *eh;
-	errcode_t retval;
-
-	if (check_fs_open(argv[0]))
-		return;
-
-	if (argc == 1) {
-		if (current_ino)
-			printf("Current inode is %d\n", current_ino);
-		else
-			printf("No current inode\n");
-		return;
-	}
-
-	if (common_inode_args_process(argc, argv, &inode, 0)) {
-		return;
-	}
-
-	current_ino = 0;
-
-	retval = ext2fs_extent_open(current_fs, inode, &current_handle);
-	if (retval) {
-		com_err(argv[1], retval, "while opening extent handle");
-		return;
-	}
-
-	current_ino = inode;
-
-	printf("Loaded inode %d\n", current_ino);
-
-	return;
-}
-
-void generic_goto_node(char *cmd_name, int op)
-{
-	struct ext2fs_extent	extent;
-	errcode_t		retval;
-
-	if (check_fs_open(cmd_name))
-		return;
-
-	if (!current_handle) {
-		com_err(cmd_name, 0, "Extent handle not open");
-		return;
-	}
-
-	retval = ext2fs_extent_get(current_handle, op, &extent);
-	if (retval) {
-		com_err(cmd_name, retval, 0);
-		return;
-	}
-	dbg_print_extent(0, &extent);
-}
-
-void do_current_node(int argc, char *argv[])
-{
-	generic_goto_node(argv[0], EXT2_EXTENT_CURRENT);
-}
-
-void do_root_node(int argc, char *argv[])
-{
-	generic_goto_node(argv[0], EXT2_EXTENT_ROOT);
-}
-
-void do_last_leaf(int argc, char *argv[])
-{
-	generic_goto_node(argv[0], EXT2_EXTENT_LAST_LEAF);
-}
-
-void do_first_sib(int argc, char *argv[])
-{
-	generic_goto_node(argv[0], EXT2_EXTENT_FIRST_SIB);
-}
-
-void do_last_sib(int argc, char *argv[])
-{
-	generic_goto_node(argv[0], EXT2_EXTENT_LAST_SIB);
-}
-
-void do_next_sib(int argc, char *argv[])
-{
-	generic_goto_node(argv[0], EXT2_EXTENT_NEXT_SIB);
-}
-
-void do_prev_sib(int argc, char *argv[])
-{
-	generic_goto_node(argv[0], EXT2_EXTENT_PREV_SIB);
-}
-
-void do_next_leaf(int argc, char *argv[])
-{
-	generic_goto_node(argv[0], EXT2_EXTENT_NEXT_LEAF);
-}
-
-void do_prev_leaf(int argc, char *argv[])
-{
-	generic_goto_node(argv[0], EXT2_EXTENT_PREV_LEAF);
-}
-
-void do_next(int argc, char *argv[])
-{
-	generic_goto_node(argv[0], EXT2_EXTENT_NEXT);
-}
-
-void do_prev(int argc, char *argv[])
-{
-	generic_goto_node(argv[0], EXT2_EXTENT_PREV);
-}
-
-void do_up(int argc, char *argv[])
-{
-	generic_goto_node(argv[0], EXT2_EXTENT_UP);
-}
-
-void do_down(int argc, char *argv[])
-{
-	generic_goto_node(argv[0], EXT2_EXTENT_DOWN);
-}
-
-void do_delete_node(int argc, char *argv[])
-{
-	errcode_t	retval;
-	int		err;
-
-	if (common_extent_args_process(argc, argv, 1, 1, "delete_node",
-				       "", CHECK_FS_RW | CHECK_FS_BITMAPS))
-		return;
-
-	retval = ext2fs_extent_delete(current_handle, 0);
-	if (retval) {
-		com_err(argv[0], retval, 0);
-		return;
-	}
-	if (current_handle->path && current_handle->path[0].curr)
-		do_current_node(argc, argv);
-}
-
-void do_replace_node(int argc, char *argv[])
-{
-	const char	*usage = "[--uninit] <lblk> <len> <pblk>";
-	errcode_t	retval;
-	struct ext2fs_extent extent;
-	int err;
-
-	if (common_extent_args_process(argc, argv, 3, 5, "replace_node",
-				       usage, CHECK_FS_RW | CHECK_FS_BITMAPS))
-		return;
-
-	extent.e_flags = 0;
-
-	if (!strcmp(argv[1], "--uninit")) {
-		argc--;
-		argv++;
-		extent.e_flags |= EXT2_EXTENT_FLAGS_UNINIT;
-	}
-
-	if (argc != 4) {
-		fprintf(stderr, "Usage: %s %s\n", argv[0], usage);
-		return;
-	}
-
-	extent.e_lblk = parse_ulong(argv[1], argv[0], "logical block", &err);
-	if (err)
-		return;
-
-	extent.e_len = parse_ulong(argv[2], argv[0], "logical block", &err);
-	if (err)
-		return;
-
-	extent.e_pblk = parse_ulong(argv[3], argv[0], "logical block", &err);
-	if (err)
-		return;
-
-	retval = ext2fs_extent_replace(current_handle, 0, &extent);
-	if (retval) {
-		com_err(argv[0], retval, 0);
-		return;
-	}
-	do_current_node(argc, argv);
-}
-
-void do_split_node(int argc, char *argv[])
-{
-	errcode_t	retval;
-	struct ext2fs_extent extent;
-	int err;
-
-	if (common_extent_args_process(argc, argv, 1, 1, "split_node",
-				       "", CHECK_FS_RW | CHECK_FS_BITMAPS))
-		return;
 
-	retval = extent_node_split(current_handle);
-	if (retval) {
-		com_err(argv[0], retval, 0);
-		return;
-	}
-	do_current_node(argc, argv);
-}
-
-void do_insert_node(int argc, char *argv[])
-{
-	const char	*usage = "[--after] [--uninit] <lblk> <len> <pblk>";
-	errcode_t	retval;
-	struct ext2fs_extent extent;
-	char *cmd;
-	int err;
-	int flags = 0;
-
-	if (common_extent_args_process(argc, argv, 3, 6, "insert_node",
-				       usage, CHECK_FS_RW | CHECK_FS_BITMAPS))
-		return;
-
-	cmd = argv[0];
-
-	extent.e_flags = 0;
-
-	while (argc > 2) {
-		if (!strcmp(argv[1], "--after")) {
-			argc--;
-			argv++;
-			flags |= EXT2_EXTENT_INSERT_AFTER;
-			continue;
-		}
-		if (!strcmp(argv[1], "--uninit")) {
-			argc--;
-			argv++;
-			extent.e_flags |= EXT2_EXTENT_FLAGS_UNINIT;
-			continue;
-		}
-		break;
-	}
-
-	if (argc != 4) {
-		fprintf(stderr, "usage: %s %s\n", cmd, usage);
-		return;
-	}
-
-	extent.e_lblk = parse_ulong(argv[1], cmd,
-				    "logical block", &err);
-	if (err)
-		return;
-
-	extent.e_len = parse_ulong(argv[2], cmd,
-				    "length", &err);
-	if (err)
-		return;
-
-	extent.e_pblk = parse_ulong(argv[3], cmd,
-				    "pysical block", &err);
-	if (err)
-		return;
-
-	retval = ext2fs_extent_insert(current_handle, flags, &extent);
-	if (retval) {
-		com_err(cmd, retval, 0);
-		return;
-	}
-	do_current_node(argc, argv);
-}
-
-void do_set_bmap(int argc, char **argv)
-{
-	const char	*usage = "[--uninit] <lblk> <pblk>";
-	errcode_t	retval;
-	blk_t		logical;
-	blk_t		physical;
-	char		*cmd = argv[0];
-	int		flags = 0;
-	int		err;
-
-	if (common_extent_args_process(argc, argv, 3, 5, "set_bmap",
-				       usage, CHECK_FS_RW | CHECK_FS_BITMAPS))
-		return;
-
-	if (argc > 2 && !strcmp(argv[1], "--uninit")) {
-		argc--;
-		argv++;
-		flags |= EXT2_EXTENT_SET_BMAP_UNINIT;
-	}
-
-	if (argc != 3) {
-		fprintf(stderr, "Usage: %s %s\n", cmd, usage);
-		return;
-	}
-
-	logical = parse_ulong(argv[1], cmd,
-				    "logical block", &err);
-	if (err)
-		return;
-
-	physical = parse_ulong(argv[2], cmd,
-				    "physical block", &err);
-	if (err)
-		return;
-
-	retval = ext2fs_extent_set_bmap(current_handle, logical,
-					(blk64_t) physical, flags);
-	if (retval) {
-		com_err(cmd, retval, 0);
-		return;
-	}
-	if (current_handle->path && current_handle->path[0].curr)
-		do_current_node(argc, argv);
-}
-
-void do_print_all(int argc, char **argv)
-{
-	const char	*usage = "[--leaf-only|--reverse|--reverse-leaf]";
-	struct ext2fs_extent	extent;
-	errcode_t		retval;
-	errcode_t		end_err = EXT2_ET_EXTENT_NO_NEXT;
-	int			op = EXT2_EXTENT_NEXT;
-	int			first_op = EXT2_EXTENT_ROOT;
-
-
-	if (common_extent_args_process(argc, argv, 1, 2, "print_all",
-				       usage, 0))
-		return;
-
-	if (argc == 2) {
-		if (!strcmp(argv[1], "--leaf-only"))
-			op = EXT2_EXTENT_NEXT_LEAF;
-		else if (!strcmp(argv[1], "--reverse")) {
-			op = EXT2_EXTENT_PREV;
-			first_op = EXT2_EXTENT_LAST_LEAF;
-			end_err = EXT2_ET_EXTENT_NO_PREV;
-		} else if (!strcmp(argv[1], "--reverse-leaf")) {
-			op = EXT2_EXTENT_PREV_LEAF;
-			first_op = EXT2_EXTENT_LAST_LEAF;
-			end_err = EXT2_ET_EXTENT_NO_PREV;
-		} else {
-			fprintf(stderr, "Usage: %s %s\n", argv[0], usage);
-			return;
-		}
-	}
-
-	retval = ext2fs_extent_get(current_handle, first_op, &extent);
-	if (retval) {
-		com_err(argv[0], retval, 0);
-		return;
-	}
-	dbg_print_extent(0, &extent);
-
-	while (1) {
-		retval = ext2fs_extent_get(current_handle, op, &extent);
-		if (retval == end_err)
-			break;
-
-		if (retval) {
-			com_err(argv[0], retval, 0);
-			return;
-		}
-		dbg_print_extent(0, &extent);
-	}
-}
-
-void do_fix_parents(int argc, char **argv)
-{
-	struct ext2fs_extent	extent;
-	struct ext2_extent_info	info;
-	errcode_t		retval;
-
-	if (common_extent_args_process(argc, argv, 1, 1, "fix_parents", "",
-				       CHECK_FS_RW))
-		return;
-
-	retval = ext2fs_extent_fix_parents(current_handle);
-	if (retval) {
-		com_err(argv[0], retval, 0);
-		return;
-	}
-}
-
-void do_info(int argc, char **argv)
-{
-	struct ext2fs_extent	extent;
-	struct ext2_extent_info	info;
-	errcode_t		retval;
-
-	if (common_extent_args_process(argc, argv, 1, 1, "info", "", 0))
-		return;
-
-	retval = ext2fs_extent_get_info(current_handle, &info);
-	if (retval) {
-		com_err(argv[0], retval, 0);
-		return;
-	}
-
-	retval = ext2fs_extent_get(current_handle,
-				   EXT2_EXTENT_CURRENT, &extent);
-	if (retval) {
-		com_err(argv[0], retval, 0);
-		return;
-	}
-
-	dbg_print_extent(0, &extent);
-
-	printf("Current handle location: %d/%d (max: %d, bytes %d), level %d/%d\n",
-	       info.curr_entry, info.num_entries, info.max_entries,
-	       info.bytes_avail, info.curr_level, info.max_depth);
-	printf("\tmax lblk: %llu, max pblk: %llu\n", info.max_lblk,
-	       info.max_pblk);
-	printf("\tmax_len: %u, max_uninit_len: %u\n", info.max_len,
-	       info.max_uninit_len);
-}
-
-void do_goto_block(int argc, char **argv)
-{
-	struct ext2fs_extent	extent;
-	errcode_t		retval;
-	int			op = EXT2_EXTENT_NEXT_LEAF;
-	blk64_t			blk;
-	int			level = 0, err;
-
-	if (common_extent_args_process(argc, argv, 2, 3, "goto_block",
-				       "block [level]", 0))
-		return;
-
-	if (strtoblk(argv[0], argv[1], &blk))
-		return;
-
-	if (argc == 3) {
-		level = parse_ulong(argv[2], argv[0], "level", &err);
-		if (err)
-			return;
-	}
-
-	retval = extent_goto(current_handle, level, (blk64_t) blk);
-
-	if (retval) {
-		com_err(argv[0], retval,
-			"while trying to go to block %llu, level %d",
-			(unsigned long long) blk, level);
-		return;
-	}
