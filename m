From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] debugfs: add the commands "zap_block" and "block_dump"
Date: Mon, 24 Dec 2012 11:06:35 -0500
Message-ID: <1356365195-4804-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40149 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab2LXQGh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Dec 2012 11:06:37 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/Makefile.in   |   7 +-
 debugfs/debug_cmds.ct |   6 ++
 debugfs/zap.c         | 265 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 275 insertions(+), 3 deletions(-)
 create mode 100644 debugfs/zap.c

diff --git a/debugfs/Makefile.in b/debugfs/Makefile.in
index 4bb2d03..9a86dc6 100644
--- a/debugfs/Makefile.in
+++ b/debugfs/Makefile.in
@@ -18,16 +18,17 @@ MK_CMDS=	_SS_DIR_OVERRIDE=../lib/ss ../lib/ss/mk_cmds
 
 DEBUG_OBJS= debug_cmds.o debugfs.o util.o ncheck.o icheck.o ls.o \
 	lsdel.o dump.o set_fields.o logdump.o htree.o unused.o e2freefrag.o \
-	filefrag.o extent_cmds.o extent_inode.o
+	filefrag.o extent_cmds.o extent_inode.o zap.o
 
 RO_DEBUG_OBJS= ro_debug_cmds.o ro_debugfs.o util.o ncheck.o icheck.o ls.o \
-	lsdel.o logdump.o htree.o e2freefrag.o filefrag.o extent_inode.o
+	lsdel.o logdump.o htree.o e2freefrag.o filefrag.o extent_cmds.o \
+	extent_inode.o
 
 SRCS= debug_cmds.c $(srcdir)/debugfs.c $(srcdir)/util.c $(srcdir)/ls.c \
 	$(srcdir)/ncheck.c $(srcdir)/icheck.c $(srcdir)/lsdel.c \
 	$(srcdir)/dump.c $(srcdir)/set_fields.c ${srcdir}/logdump.c \
 	$(srcdir)/htree.c $(srcdir)/unused.c ${srcdir}/../misc/e2freefrag.c \
-	$(srcdir)/filefrag.c $(srcdir)/extent_inode.c
+	$(srcdir)/filefrag.c $(srcdir)/extent_inode.c $(srcdir)/zap.c
 
 LIBS= $(LIBEXT2FS) $(LIBE2P) $(LIBSS) $(LIBCOM_ERR) $(LIBBLKID) \
 	$(LIBUUID)
diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index 7767f8f..520933a 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -181,5 +181,11 @@ request do_set_mmp_value, "Set MMP value",
 request do_extent_open, "Open inode for extent manipulation",
 	extent_open, eo;
 
+request do_zap_block, "Zap block",
+	zap_block, zap;
+
+request do_dump_block, "Zap block",
+	block_dump, bp;
+
 end;
 
diff --git a/debugfs/zap.c b/debugfs/zap.c
new file mode 100644
index 0000000..3f3620b
--- /dev/null
+++ b/debugfs/zap.c
@@ -0,0 +1,265 @@
+/*
+ * zap.c --- zap block
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
+void do_zap_block(int argc, char *argv[])
+{
+	unsigned long	pattern = 0;
+	unsigned char	*buf;
+	ext2_ino_t	inode;
+	errcode_t	errcode;
+	blk64_t		block;
+	int		retval;
+	char		*file = NULL;
+	char		*in_file = NULL;
+	int		c, err;
+	int		offset = -1;
+	int		length = -1;
+	int		bit = -1;
+
+	if (check_fs_open(argv[0]))
+		return;
+	if (check_fs_read_write(argv[0]))
+		return;
+
+	reset_getopt();
+	while ((c = getopt (argc, argv, "b:f:l:o:p:")) != EOF) {
+		switch (c) {
+		case 'f':
+			file = optarg;
+			break;
+		case 'b':
+			bit = parse_ulong(optarg, argv[0],
+					  "bit", &err);
+			if (err)
+				return;
+			if (bit >= current_fs->blocksize * 8) {
+				com_err(argv[0], 0, "The bit to flip "
+					"must be within a %d block\n",
+					current_fs->blocksize);
+				return;
+			}
+			break;
+		case 'p':
+			pattern = parse_ulong(optarg, argv[0],
+					      "pattern", &err);
+			if (err)
+				return;
+			if (pattern >= 256) {
+				com_err(argv[0], 0, "The fill pattern must "
+					"be an 8-bit value\n");
+				return;
+			}
+			break;
+		case 'o':
+			offset = parse_ulong(optarg, argv[0],
+					     "offset", &err);
+			if (err)
+				return;
+			if (offset >= current_fs->blocksize) {
+				com_err(argv[0], 0, "The offset must be "
+					"within a %d block\n",
+					current_fs->blocksize);
+				return;
+			}
+			break;
+
+			break;
+		case 'l':
+			length = parse_ulong(optarg, argv[0],
+					     "length", &err);
+			if (err)
+				return;
+			break;
+		default:
+			goto print_usage;
+		}
+	}
+
+	if (bit > 0 && offset > 0) {
+		com_err(argv[0], 0, "The -o and -b options can not be mixed.");
+		return;
+	}
+
+	if (offset < 0)
+		offset = 0;
+	if (length < 0)
+		length = current_fs->blocksize - offset;
+	if ((offset + length) > current_fs->blocksize) {
+		com_err(argv[0], 0, "The specified length is too bug\n");
+		return;
+	}
+
+	if (argc != optind+1) {
+	print_usage:
+		com_err(0, 0, "Usage:\tzap_block [-f file] [-o offset] "
+			"[-l length] [-p pattern] block_num");
+		com_err(0, 0, "\tzap_block [-f file] [-b bit] "
+			"block_num");
+		return;
+	}
+
+	block = parse_ulonglong(argv[optind], argv[0], "block", &err);
+	if (err)
+		return;
+
+	if (file) {
+		inode = string_to_inode(file);
+		if (!inode)
+			return;
+		errcode = ext2fs_bmap2(current_fs, inode, 0, 0, 0,
+				       block, 0, &block);
+		if (errcode) {
+			com_err(argv[0], errcode,
+				"while mapping logical block %llu\n", block);
+			return;
+		}
+	}
+
+	buf = malloc(current_fs->blocksize);
+	if (!buf) {
+		com_err(argv[0], 0, "Couldn't allocate block buffer");
+		return;
+	}
+
+	errcode = io_channel_read_blk64(current_fs->io, block, 1, buf);
+	if (errcode) {
+		com_err(argv[0], errcode,
+			"while reading block %llu\n", block);
+		goto errout;
+	}
+
+	if (bit >= 0)
+		buf[bit >> 3] ^= 1 << (bit & 7);
+	else
+		memset(buf+offset, pattern, length);
+
+	errcode = io_channel_write_blk64(current_fs->io, block, 1, buf);
+	if (errcode) {
+		com_err(argv[0], errcode,
+			"while write block %llu\n", block);
+		goto errout;
+	}
+
+errout:
+	free(buf);
+	return;
+}
+
+void do_dump_block(int argc, char *argv[])
+{
+	unsigned long	pattern = 0;
+	unsigned char	*buf;
+	ext2_ino_t	inode;
+	errcode_t	errcode;
+	blk64_t		block;
+	int		retval;
+	char		*file = NULL;
+	char		*in_file = NULL;
+	int		c, err, i, j;
+	int		suppress = -1;
+
+	if (check_fs_open(argv[0]))
+		return;
+
+	reset_getopt();
+	while ((c = getopt (argc, argv, "f:")) != EOF) {
+		switch (c) {
+		case 'f':
+			file = optarg;
+			break;
+
+		default:
+			goto print_usage;
+		}
+	}
+
+	if (argc != optind+1) {
+	print_usage:
+		com_err(0, 0, "Usage: dump_block [-f file] "
+			" block_num");
+		return;
+	}
+
+	block = parse_ulonglong(argv[optind], argv[0], "block", &err);
+	if (err)
+		return;
+
+	if (file) {
+		inode = string_to_inode(file);
+		if (!inode)
+			return;
+		errcode = ext2fs_bmap2(current_fs, inode, 0, 0, 0,
+				       block, 0, &block);
+		if (errcode) {
+			com_err(argv[0], errcode,
+				"while mapping logical block %llu\n", block);
+			return;
+		}
+	}
+
+	buf = malloc(current_fs->blocksize);
+	if (!buf) {
+		com_err(argv[0], 0, "Couldn't allocate block buffer");
+		return;
+	}
+
+	errcode = io_channel_read_blk64(current_fs->io, block, 1, buf);
+	if (errcode) {
+		com_err(argv[0], errcode,
+			"while reading block %llu\n", block);
+		goto errout;
+	}
+
+	for (i=0; i < current_fs->blocksize; i += 16) {
+		if (suppress < 0) {
+			if (i && memcmp(buf + i, buf + i - 16, 16) == 0) {
+				suppress = i;
+				printf("*\n");
+				continue;
+			}
+		} else {
+			if (memcmp(buf + i, buf + suppress, 16) == 0)
+				continue;
+			suppress = -1;
+		}
+		printf("%04o  ", i);
+		for (j = 0; j < 16; j++) {
+			printf("%02x", buf[i+j]);
+			if ((j % 2) == 1)
+				putchar(' ');
+		}
+		putchar(' ');
+		for (j = 0; j < 16; j++)
+			printf("%c", isprint(buf[i+j]) ? buf[i+j] : '.');
+		putchar('\n');
+	}
+	putchar('\n');
+
+errout:
+	free(buf);
+	return;
+}
-- 
1.7.12.rc0.22.gcdd159b

