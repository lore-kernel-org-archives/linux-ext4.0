From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 1/5 bigalloc] e2fsprogs: add tool e2wreck to corrupt fs for e2fsck testing
Date: Fri, 18 Nov 2011 18:55:26 +0800
Message-ID: <1321613730-10600-2-git-send-email-hao.bigrat@gmail.com>
References: <1321613730-10600-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33147 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab1KRKzn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Nov 2011 05:55:43 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so3440789iag.19
        for <linux-ext4@vger.kernel.org>; Fri, 18 Nov 2011 02:55:43 -0800 (PST)
In-Reply-To: <1321613730-10600-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

We need a tool to wreck filesystem to test e2fsck

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 misc/Makefile.in |   10 +-
 misc/e2wreck.c   |  549 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 611 insertions(+), 2 deletions(-)
 create mode 100644 misc/e2wreck.c

diff --git a/misc/Makefile.in b/misc/Makefile.in
index cb3c6d9..c5597b4 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -26,7 +26,7 @@ INSTALL = @INSTALL@
 @BLKID_CMT@FINDFS_LINK= findfs
 @BLKID_CMT@FINDFS_MAN= findfs.8
 
-SPROGS=		mke2fs badblocks tune2fs dumpe2fs $(BLKID_PROG) logsave \
+SPROGS=		mke2fs badblocks tune2fs dumpe2fs e2wreck $(BLKID_PROG) logsave \
 			$(E2IMAGE_PROG) @FSCK_PROG@ e2undo
 USPROGS=	mklost+found filefrag e2freefrag $(UUIDD_PROG) $(E4DEFRAG_PROG)
 SMANPAGES=	tune2fs.8 mklost+found.8 mke2fs.8 dumpe2fs.8 badblocks.8 \
@@ -50,6 +50,7 @@ UUIDD_OBJS=	uuidd.o
 DUMPE2FS_OBJS=	dumpe2fs.o
 BADBLOCKS_OBJS=	badblocks.o
 E2IMAGE_OBJS=	e2image.o
+E2WRECK_OBJS=	e2wreck.o
 FSCK_OBJS=	fsck.o base_device.o ismounted.o
 BLKID_OBJS=	blkid.o
 FILEFRAG_OBJS=	filefrag.o
@@ -68,6 +69,7 @@ PROFILED_UUIDD_OBJS=	profiled/uuidd.o
 PROFILED_DUMPE2FS_OBJS=	profiled/dumpe2fs.o
 PROFILED_BADBLOCKS_OBJS=	profiled/badblocks.o
 PROFILED_E2IMAGE_OBJS=	profiled/e2image.o
+PROFILED_E2WRECK_OBJS=	profiled/e2wreck.o
 PROFILED_FSCK_OBJS=	profiled/fsck.o profiled/base_device.o \
 			profiled/ismounted.o
 PROFILED_BLKID_OBJS=	profiled/blkid.o
@@ -191,6 +193,10 @@ e2image.profiled: $(PROFILED_E2IMAGE_OBJS) $(PROFILED_DEPLIBS)
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o e2image.profiled \
 		$(PROFILED_E2IMAGE_OBJS) $(PROFILED_LIBS) $(LIBINTL)
 
+e2wreck: $(E2WRECK_OBJS) $(DEPLIBS)
+	$(E) "	LD $@"
+	$(Q) $(CC) $(ALL_LDFLAGS) -o e2wreck $(E2WRECK_OBJS) $(LIBS) $(LIBINTL)
+
 e2undo: $(E2UNDO_OBJS) $(DEPLIBS)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o e2undo $(E2UNDO_OBJS) $(LIBS) $(LIBINTL)
@@ -556,7 +562,7 @@ clean:
 		$(FMANPAGES) profile.h \
 		base_device base_device.out mke2fs.static filefrag e2freefrag \
 		e2initrd_helper partinfo prof_err.[ch] default_profile.c \
-		uuidd e2image tune2fs.static tst_ismounted fsck.profiled \
+		uuidd e2image e2wreck tune2fs.static tst_ismounted fsck.profiled \
 		blkid.profiled tune2fs.profiled e2image.profiled \
 		e2undo.profiled mke2fs.profiled dumpe2fs.profiled \
 		logsave.profiled filefrag.profiled uuidgen.profiled \
diff --git a/misc/e2wreck.c b/misc/e2wreck.c
new file mode 100644
index 0000000..2d7194b
--- /dev/null
+++ b/misc/e2wreck.c
@@ -0,0 +1,549 @@
+/*
+ * e2wreck.c --- Program which writes an image file backing up
+ * critical metadata for the filesystem.
+ *
+ * Copyright 2000, 2001 by Theodore Ts'o.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#define _LARGEFILE_SOURCE
+#define _LARGEFILE64_SOURCE
+
+#include <fcntl.h>
+#include <grp.h>
+#ifdef HAVE_GETOPT_H
+#include <getopt.h>
+#else
+#endif
+#include <pwd.h>
+#include <stdio.h>
+#ifdef HAVE_STDLIB_H
+#include <stdlib.h>
+#endif
+#include <string.h>
+#include <time.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <assert.h>
+
+#include "ext2fs/ext2_fs.h"
+#include "ext2fs/ext2fs.h"
+#include "et/com_err.h"
+#include "uuid/uuid.h"
+#include "e2p/e2p.h"
+
+#include "../version.h"
+#include "nls-enable.h"
+
+#define QCOW_OFLAG_COPIED     (1LL << 63)
+
+const char *program_name = "e2wreck";
+
+static void wreck_file_block_bitmap(ext2_filsys fs, const char *name, int flag);
+static void wreck_dirent(ext2_filsys fs, const char *name, int flag);
+static void wreck_zero_inode(ext2_filsys fs, const char *name, int flag);
+static void wreck_inode_field(ext2_filsys fs, const char *name, int flag);
+
+#define DIRENT_ZERO_DIR		1
+#define DIRENT_DUP_DOT		2
+#define DIRENT_INVALID_DOTDOT	3
+#define DIRENT_INVALID_RECLEN	4
+
+#define INODE_GENERATION	1
+#define INODE_MODE		2
+#define INODE_LINKS		3
+#define INODE_DTIME		4
+#define INODE_BLOCK		5
+#define INODE_BLOCKS		6
+#define INODE_SIZE		7
+#define EXTENT_BLOCK		8
+#define EXTENT_LEN		9
+
+struct command {
+	char name[256];
+	void (*func) (ext2_filsys fs, const char *name, int flag);
+	int flag;
+};
+
+struct command cmd_table[] = { {
+		.name = "ZERO_INODE",
+		.func = wreck_zero_inode,
+		.flag = 0,
+	}, {
+		.name = "CLEAR_BITMAP",
+		.func = wreck_file_block_bitmap,
+		.flag = 0,
+	}, {
+		.name = "INODE_GENERATION",
+		.func = wreck_inode_field,
+		.flag = INODE_GENERATION,
+	}, {
+		.name = "INODE_MODE",
+		.func = wreck_inode_field,
+		.flag = INODE_MODE,
+	}, {
+		.name = "INODE_SIZE",
+		.func = wreck_inode_field,
+		.flag = INODE_SIZE,
+	}, {
+		.name = "INODE_LINKS",
+		.func = wreck_inode_field,
+		.flag = INODE_LINKS,
+	}, {
+		.name = "INODE_DTIME",
+		.func = wreck_inode_field,
+		.flag = INODE_DTIME,
+	}, {
+		.name = "INODE_BLOCK",
+		.func = wreck_inode_field,
+		.flag = INODE_BLOCK,
+	}, {
+		.name = "INODE_BLOCKS",
+		.func = wreck_inode_field,
+		.flag = INODE_BLOCKS,
+	}, {
+		.name = "EXTENT_BLOCK",
+		.func = wreck_inode_field,
+		.flag = EXTENT_BLOCK,
+	}, {
+		.name = "EXTENT_LEN",
+		.func = wreck_inode_field,
+		.flag = EXTENT_LEN,
+	}, {
+		.name = "DIRENT_ZERO_DIR",
+		.func = wreck_dirent,
+		.flag = DIRENT_ZERO_DIR,
+	}, {
+		.name = "DIRENT_DUP_DOT",
+		.func = wreck_dirent,
+		.flag = DIRENT_DUP_DOT,
+	}, {
+		.name = "DIRENT_INVALID_DOTDOT",
+		.func = wreck_dirent,
+		.flag = DIRENT_INVALID_DOTDOT,
+	}, {
+		.name = "DIRENT_INVALID_RECLEN",
+		.func = wreck_dirent,
+		.flag = DIRENT_INVALID_RECLEN,
+	}
+};
+
+struct link_struct  {
+	const char	*name;
+	int		namelen;
+	ext2_ino_t	inode;
+	int		flags;
+	struct ext2_dir_entry *prev;
+	int		done;
+};
+
+static void usage(void)
+{
+	int i;
+	fprintf(stderr, _("Usage: %s OPTION file_name device_name\n"),
+		program_name);
+	fprintf(stderr, _("	option:\n"));
+	for (i = 0; i < sizeof(cmd_table) / sizeof(struct command); i++)
+		fprintf(stderr, _("\t%s\n"), cmd_table[i].name);
+	exit(1);
+}
+
+/*
+ * This routine is used whenever a command needs to turn a string into
+ * an inode.
+ */
+static ext2_ino_t string_to_inode(ext2_filsys fs, const char *str)
+{
+	ext2_ino_t	ino;
+	int		len = strlen(str);
+	char		*end;
+	int		retval;
+
+	/*
+	 * If the string is of the form <ino>, then treat it as an
+	 * inode number.
+	 */
+	if ((len > 2) && (str[0] == '<') && (str[len-1] == '>')) {
+		ino = strtoul(str+1, &end, 0);
+		if (*end == '>')
+			return ino;
+	}
+
+	retval = ext2fs_namei(fs, 2, 2, str, &ino);
+	if (retval) {
+		com_err(str, retval, 0);
+		return 0;
+	}
+	return ino;
+}
+
+#define DUMP_LEAF_EXTENTS	0x01
+#define DUMP_NODE_EXTENTS	0x02
+#define DUMP_EXTENT_TABLE	0x04
+
+static void dump_extents(ext2_filsys fs, FILE *f, const char *prefix,
+		ext2_ino_t ino, int flags,
+		int logical_width, int physical_width)
+{
+	ext2_extent_handle_t	handle;
+	struct ext2fs_extent	extent;
+	struct ext2_extent_info info;
+	int			op = EXT2_EXTENT_ROOT;
+	errcode_t		errcode;
+	blk64_t			i;
+
+	errcode = ext2fs_extent_open(fs, ino, &handle);
+	if (errcode)
+		return;
+
+	while (1) {
+		errcode = ext2fs_extent_get(handle, op, &extent);
+
+		if (errcode)
+			break;
+
+		op = EXT2_EXTENT_NEXT;
+
+		if (extent.e_flags & EXT2_EXTENT_FLAGS_SECOND_VISIT)
+			continue;
+
+		if (extent.e_flags & EXT2_EXTENT_FLAGS_LEAF) {
+			if ((flags & DUMP_LEAF_EXTENTS) == 0)
+				continue;
+		} else {
+			if ((flags & DUMP_NODE_EXTENTS) == 0)
+				continue;
+		}
+
+		errcode = ext2fs_extent_get_info(handle, &info);
+		if (errcode)
+			continue;
+
+		if (!(extent.e_flags & EXT2_EXTENT_FLAGS_LEAF)) {
+			if (extent.e_flags & EXT2_EXTENT_FLAGS_SECOND_VISIT)
+				continue;
+
+			continue;
+		}
+
+		if (extent.e_len == 0)
+			continue;
+
+		for (i = extent.e_lblk; i < extent.e_lblk + extent.e_len; i++) {
+			blk64_t b;
+			b = extent.e_pblk + i;
+			ext2fs_unmark_block_bitmap2(fs->block_map, b);
+		}
+	}
+}
+
+static void wreck_file_block_bitmap(ext2_filsys fs, const char *name, int flag)
+{
+	ext2_ino_t ino;
+	struct ext2_inode *inode_buf;
+	__u32 inode_size = EXT2_INODE_SIZE(fs->super);
+
+	inode_buf = (struct ext2_inode *) malloc(inode_size);
+	if (!inode_buf) {
+		printf("malloc inode_buf fail\n");
+		return;
+	}
+
+	ino = string_to_inode(fs, name);
+	if (!ino) {
+		printf("fetch inode fail\n");
+		return;
+	}
+
+	if (ext2fs_read_inode_full(fs, ino, inode_buf, inode_size)) {
+		printf("read inode fail\n");
+		goto out;
+	}
+
+	if (ext2fs_read_bitmaps(fs)) {
+		printf("read bitmap fail\n");
+		return;
+	}
+
+	dump_extents(fs, stdout, "{", ino, DUMP_LEAF_EXTENTS, 0, 0);
+	ext2fs_mark_bb_dirty(fs);
+
+	if (ext2fs_write_bitmaps(fs))
+		printf("write bitmap fail\n");
+
+out:
+	free(inode_buf);
+}
+
+static int clear_proc(struct ext2_dir_entry *dirent,
+		     int	offset,
+		     int	blocksize EXT2FS_ATTR((unused)),
+		     char	*buf EXT2FS_ATTR((unused)),
+		     void	*priv_data)
+{
+	dirent->inode = 0;
+
+	return DIRENT_CHANGED;
+}
+
+static int dup_proc(struct ext2_dir_entry *dirent,
+		     int	offset,
+		     int	blocksize EXT2FS_ATTR((unused)),
+		     char	*buf EXT2FS_ATTR((unused)),
+		     void	*priv_data)
+{
+	struct link_struct *ls = (struct link_struct *) priv_data;
+	struct ext2_dir_entry *prev;
+
+	prev = ls->prev;
+	ls->prev = dirent;
+
+	if ((dirent->name_len & 0xFF) == 2 &&
+			dirent->name[0] == '.' &&
+			dirent->name[1] == '.') {
+		dirent->name_len = 1;
+		return DIRENT_ABORT|DIRENT_CHANGED;
+	}
+	return 0;
+}
+
+static int invalid_dotdot_proc(struct ext2_dir_entry *dirent,
+		     int	offset,
+		     int	blocksize EXT2FS_ATTR((unused)),
+		     char	*buf EXT2FS_ATTR((unused)),
+		     void	*priv_data)
+{
+	struct link_struct *ls = (struct link_struct *) priv_data;
+	struct ext2_dir_entry *prev;
+
+	prev = ls->prev;
+	ls->prev = dirent;
+
+	if ((dirent->name_len & 0xFF) == 2 &&
+			dirent->name[0] == '.' &&
+			dirent->name[1] == '.') {
+		dirent->name[0] = 'a';
+		dirent->name[1] = 'b';
+		return DIRENT_ABORT|DIRENT_CHANGED;
+	}
+	return 0;
+}
+
+static int invalid_reclen_proc(struct ext2_dir_entry *dirent,
+		     int	offset,
+		     int	blocksize EXT2FS_ATTR((unused)),
+		     char	*buf EXT2FS_ATTR((unused)),
+		     void	*priv_data)
+{
+	struct link_struct *ls = (struct link_struct *) priv_data;
+	struct ext2_dir_entry *prev;
+
+	prev = ls->prev;
+	ls->prev = dirent;
+
+	if ((dirent->name_len & 0xFF) == 2 &&
+			dirent->name[0] == '1' &&
+			dirent->name[1] == '9') {
+		dirent->rec_len = 25;
+		return DIRENT_ABORT|DIRENT_CHANGED;
+	}
+	return 0;
+}
+
+static void wreck_dirent(ext2_filsys fs, const char *name, int flag)
+{
+	ext2_ino_t ino;
+	__u32 inode_size = EXT2_INODE_SIZE(fs->super);
+	struct link_struct ls;
+	int retval;
+
+	ino = string_to_inode(fs, name);
+	if (!ino) {
+		printf("fetch inode fail\n");
+		goto out;
+	}
+
+	switch (flag) {
+	case DIRENT_ZERO_DIR:
+		retval = ext2fs_dir_iterate(fs, ino,
+			DIRENT_FLAG_INCLUDE_EMPTY, 0, clear_proc, &ls);
+	case DIRENT_DUP_DOT:
+		retval = ext2fs_dir_iterate(fs, ino,
+			DIRENT_FLAG_INCLUDE_EMPTY, 0, dup_proc, &ls);
+		break;
+	case DIRENT_INVALID_DOTDOT:
+		retval = ext2fs_dir_iterate(fs, ino,
+			DIRENT_FLAG_INCLUDE_EMPTY, 0,
+			invalid_dotdot_proc, &ls);
+		break;
+	case DIRENT_INVALID_RECLEN:
+		retval = ext2fs_dir_iterate(fs, ino,
+			DIRENT_FLAG_INCLUDE_EMPTY, 0,
+			invalid_reclen_proc, &ls);
+		break;
+	default:
+		goto out;
+	}
+
+	if (retval) {
+		printf("iterate dir fail\n");
+		goto out;
+	}
+
+out:
+	return;
+}
+
+static void wreck_zero_inode(ext2_filsys fs, const char *name, int flag)
+{
+	ext2_ino_t ino;
+	struct ext2_inode *inode_buf;
+	__u32 inode_size = EXT2_INODE_SIZE(fs->super);
+
+	inode_buf = (struct ext2_inode *) malloc(inode_size);
+	if (!inode_buf) {
+		printf("malloc inode_buf fail\n");
+		return;
+	}
+
+	ino = string_to_inode(fs, name);
+	if (!ino) {
+		printf("fetch inode fail\n");
+		return;
+	}
+
+	memset(inode_buf, 0, inode_size);
+	if (ext2fs_write_inode_full(fs, ino, inode_buf, inode_size)) {
+		printf("write inode fail\n");
+		goto out;
+	}
+out:
+	free(inode_buf);
+}
+
+static void wreck_inode_field(ext2_filsys fs, const char *name, int field)
+{
+	ext2_ino_t ino;
+	struct ext2_inode *inode_buf;
+	struct ext3_extent *ex;
+	struct ext3_extent_header *eh;
+	__u32 inode_size = EXT2_INODE_SIZE(fs->super);
+	int i;
+
+	inode_buf = (struct ext2_inode *) malloc(inode_size);
+	if (!inode_buf) {
+		printf("malloc inode_buf fail\n");
+		return;
+	}
+
+	ino = string_to_inode(fs, name);
+	if (!ino) {
+		printf("fetch inode fail\n");
+		return;
+	}
+
+	if (ext2fs_read_inode_full(fs, ino, inode_buf,
+				sizeof(struct ext2_inode))) {
+		printf("read inode fail\n");
+		goto out;
+	}
+
+	switch (field) {
+	case INODE_GENERATION:
+		inode_buf->i_generation = 0;
+		break;
+	case INODE_MODE:
+		inode_buf->i_mode = 0;
+		break;
+	case INODE_LINKS:
+		inode_buf->i_links_count = 0;
+		break;
+	case INODE_DTIME:
+		inode_buf->i_dtime = 0;
+		break;
+	case INODE_BLOCK:
+		for (i = 0; i < EXT2_N_BLOCKS; i++)
+			inode_buf->i_block[i] = 0;
+		break;
+	case INODE_BLOCKS:
+		inode_buf->i_blocks = 0;
+		break;
+	case INODE_SIZE:
+		inode_buf->i_size = 0;
+		break;
+	case EXTENT_BLOCK:
+		eh = (struct ext3_extent_header *)(inode_buf->i_block);
+		ex = EXT_FIRST_EXTENT(eh);
+		ex->ee_block = 60;
+		break;
+	case EXTENT_LEN:
+		eh = (struct ext3_extent_header *)(inode_buf->i_block);
+		ex = EXT_FIRST_EXTENT(eh);
+		ex->ee_len = 60;
+		break;
+	default:
+		goto out;
+	}
+
+	if (ext2fs_write_inode_full(fs, ino, inode_buf, inode_size)) {
+		printf("write inode fail\n");
+		goto out;
+	}
+out:
+	free(inode_buf);
+}
+
+int main(int argc, char **argv)
+{
+	errcode_t retval;
+	ext2_filsys fs;
+	int open_flag = EXT2_FLAG_64BITS | EXT2_FLAG_RW | EXT2_FLAG_BB_DIRTY;
+	int ret = 0;
+	unsigned int i;
+
+#ifdef ENABLE_NLS
+	setlocale(LC_MESSAGES, "");
+	setlocale(LC_CTYPE, "");
+	bindtextdomain(NLS_CAT_NAME, LOCALEDIR);
+	textdomain(NLS_CAT_NAME);
+#endif
+	fprintf(stderr, "e2wreck %s (%s)\n", E2FSPROGS_VERSION,
+		 E2FSPROGS_DATE);
+	if (argc < 4) {
+		usage();
+		goto out;
+	}
+
+	if (argc && *argv)
+		program_name = *argv;
+
+	add_error_table(&et_ext2_error_table);
+
+	device_name = argv[3];
+
+	retval = ext2fs_open(device_name, open_flag, 0, 0,
+			      unix_io_manager, &fs);
+	if (retval) {
+		com_err(program_name, retval, _("while trying to open %s"),
+			 device_name);
+		fputs(_("Couldn't find valid filesystem superblock.\n"),
+				stdout);
+		exit(1);
+	}
+
+	for (i = 0; i < sizeof(cmd_table) / sizeof(struct command); i++)
+		if (!strcmp(cmd_table[i].name, argv[1]))
+			cmd_table[i].func(fs, argv[2], cmd_table[i].flag);
+
+	ext2fs_close(fs);
+out:
+	remove_error_table(&et_ext2_error_table);
+	return ret;
+}
-- 
1.7.3.2

