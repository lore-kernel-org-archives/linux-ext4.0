From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 1/2] mksparse: build sparse file from compressed e2image file.
Date: Mon, 28 Feb 2011 10:35:13 +0800
Message-ID: <1298860514-615-1-git-send-email-hao.bigrat@gmail.com>
Cc: tytso@mit.edu, Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33309 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab1B1CfZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Feb 2011 21:35:25 -0500
Received: by iyb26 with SMTP id 26so2507379iyb.19
        for <linux-ext4@vger.kernel.org>; Sun, 27 Feb 2011 18:35:24 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

[Purpose]
After we make a image-file by e2image like:
#e2image -r /dev/hda1 - | bzip2 > hda1.bz2
we copy the bz2 file to remote host and extract it:
#bunzip2 hda1.bz2 
the unzipped hda1 file will not be a sparse file and the space occupied
by it is as large as the real /dev/hda1 filesystem.

Therefore a tool to transform a raw-file to a sparse-file is necessary.
This Patch is a first attempt to provide such a tool which is called
'mksparse' so far.

[Example]
Extract hda1.bz2 by:
#bunzip2 -c hda1.bz2 | mksparse hda1
the hda1 file will be a sparse file.

Reviewed-by: Coly Li <bosong.ly@taobao.com>
Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 misc/Makefile.in |   21 ++++-
 misc/mksparse.c  |  268 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 285 insertions(+), 4 deletions(-)
 create mode 100644 misc/mksparse.c

diff --git a/misc/Makefile.in b/misc/Makefile.in
index 86ee53f..fcd316e 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -17,6 +17,8 @@ INSTALL = @INSTALL@
 @IMAGER_CMT@E2IMAGE_PROG= e2image
 @IMAGER_CMT@E2IMAGE_MAN= e2image.8
 
+@IMAGER_CMT@MKSPARSE_PROG= mksparse
+
 @UUIDD_CMT@UUIDD_PROG= uuidd
 @UUIDD_CMT@UUIDD_MAN= uuidd.8
 
@@ -27,7 +29,7 @@ INSTALL = @INSTALL@
 @BLKID_CMT@FINDFS_MAN= findfs.8
 
 SPROGS=		mke2fs badblocks tune2fs dumpe2fs $(BLKID_PROG) logsave \
-			$(E2IMAGE_PROG) @FSCK_PROG@ e2undo
+			$(E2IMAGE_PROG) $(MKSPARSE_PROG) @FSCK_PROG@ e2undo
 USPROGS=	mklost+found filefrag e2freefrag $(UUIDD_PROG) $(E4DEFRAG_PROG)
 SMANPAGES=	tune2fs.8 mklost+found.8 mke2fs.8 dumpe2fs.8 badblocks.8 \
 			e2label.8 $(FINDFS_MAN) $(BLKID_MAN) $(E2IMAGE_MAN) \
@@ -50,6 +52,7 @@ UUIDD_OBJS=	uuidd.o
 DUMPE2FS_OBJS=	dumpe2fs.o
 BADBLOCKS_OBJS=	badblocks.o
 E2IMAGE_OBJS=	e2image.o
+MKSPARSE_OBJS=	mksparse.o
 FSCK_OBJS=	fsck.o base_device.o ismounted.o
 BLKID_OBJS=	blkid.o
 FILEFRAG_OBJS=	filefrag.o
@@ -68,6 +71,7 @@ PROFILED_UUIDD_OBJS=	profiled/uuidd.o
 PROFILED_DUMPE2FS_OBJS=	profiled/dumpe2fs.o
 PROFILED_BADBLOCKS_OBJS=	profiled/badblocks.o
 PROFILED_E2IMAGE_OBJS=	profiled/e2image.o
+PROFILED_MKSPARSE_OBJS=	profiled/mksparse.o
 PROFILED_FSCK_OBJS=	profiled/fsck.o profiled/base_device.o \
 			profiled/ismounted.o
 PROFILED_BLKID_OBJS=	profiled/blkid.o
@@ -109,7 +113,7 @@ all:: profiled $(SPROGS) $(UPROGS) $(USPROGS) $(SMANPAGES) $(UMANPAGES) \
 @PROFILE_CMT@all:: tune2fs.profiled blkid.profiled e2image.profiled \
 	e2undo.profiled mke2fs.profiled dumpe2fs.profiled fsck.profiled \
 	logsave.profiled filefrag.profiled uuidgen.profiled uuidd.profiled \
-	e2image.profiled e4defrag.profiled
+	e2image.profiled mksparse.profiled e4defrag.profiled
 
 profiled:
 @PROFILE_CMT@	$(E) "	MKDIR $@"
@@ -187,6 +191,15 @@ e2image.profiled: $(PROFILED_E2IMAGE_OBJS) $(PROFILED_DEPLIBS)
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o e2image.profiled \
 		$(PROFILED_E2IMAGE_OBJS) $(PROFILED_LIBS) $(LIBINTL)
 
+mksparse: $(MKSPARSE_OBJS) $(DEPLIBS)
+	$(E) "	LD $@"
+	$(Q) $(CC) $(ALL_LDFLAGS) -o mksparse $(MKSPARSE_OBJS) $(LIBS) $(LIBINTL)
+
+mksparse.profiled: $(PROFILED_MKSPARSE_OBJS) $(PROFILED_DEPLIBS)
+	$(E) "	LD $@"
+	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o mksparse.profiled \
+		$(PROFILED_MKSPARSE_OBJS) $(PROFILED_LIBS) $(LIBINTL)
+
 e2undo: $(E2UNDO_OBJS) $(DEPLIBS)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o e2undo $(E2UNDO_OBJS) $(LIBS) $(LIBINTL)
@@ -550,8 +563,8 @@ clean:
 		$(FMANPAGES) \
 		base_device base_device.out mke2fs.static filefrag e2freefrag \
 		e2initrd_helper partinfo prof_err.[ch] default_profile.c \
-		uuidd e2image tune2fs.static tst_ismounted fsck.profiled \
-		blkid.profiled tune2fs.profiled e2image.profiled \
+		uuidd e2image mksparse tune2fs.static tst_ismounted fsck.profiled \
+		blkid.profiled tune2fs.profiled e2image.profiled mksparse.profiled\
 		e2undo.profiled mke2fs.profiled dumpe2fs.profiled \
 		logsave.profiled filefrag.profiled uuidgen.profiled \
 		uuidd.profiled e2image.profiled \
diff --git a/misc/mksparse.c b/misc/mksparse.c
new file mode 100644
index 0000000..9e62fcf
--- /dev/null
+++ b/misc/mksparse.c
@@ -0,0 +1,268 @@
+/*
+ * mksparse.c --- Program which transform stdin (or file) to
+ * be a new sparse file.
+ *
+ * Copyright 2011 by Taobao, all rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License, version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * Authors: Robin Dong <sanbai@taobao.com>
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
+extern char *optarg;
+extern int optind;
+#endif
+#include <stdio.h>
+#ifdef HAVE_STDLIB_H
+#include <stdlib.h>
+#endif
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <limits.h>
+
+#include "ext2fs/ext2fs.h"
+
+#include "../version.h"
+#include "nls-enable.h"
+
+#define KB_SIZE 1024
+#define MB_SIZE (1024*1024)
+#define MIN_BUFFER_SIZE 1024
+#define MAX_BUFFER_SIZE (64*1024*1024)
+#define DEFAULT_BUFFER_SIZE (4*1024)
+
+#define OPEN_SRC_FAIL		-1
+#define OPEN_TARGET_FAIL	-2
+#define MALLOC_FAIL			-3
+#define SEEK_FAIL			-4
+#define WRITE_FAIL			-5
+
+const char *program_name = "mksparse";
+
+static void usage(void)
+{
+	fprintf(stderr,
+		_("Usage: %s [-s buffer_size] [-i input_file] sparse_file\n"),
+		program_name);
+	exit (1);
+}
+
+static int get_buffer_size(const char *optarg)
+{
+	char *pos = NULL;
+	long val = strtol(optarg, &pos, 0);
+	if (pos == optarg || val == LONG_MAX)
+		return DEFAULT_BUFFER_SIZE;
+
+	switch (*pos) {
+	case 'k':
+	case 'K':
+		val *= KB_SIZE;
+		break;
+	case 'm':
+	case 'M':
+		val *= MB_SIZE;
+		break;
+	case 'b':
+	case 'B':
+	case '\0':
+		break;
+	default:
+		fprintf(stderr, _("Wrong buffer_size %s\n"), optarg);
+		val = -1;
+		goto out;
+		/*
+		 * never touch here
+		 */
+		break;
+	}
+
+	/*
+	 * the buffer_size must in thec range [1KB, 64MB]
+	 */
+	if (val > MAX_BUFFER_SIZE) {
+		fprintf(stderr,
+				_("Buffer_size is too large, "
+				  "change it to %d bytes\n"),
+				MAX_BUFFER_SIZE);
+		val = MAX_BUFFER_SIZE;
+	}
+
+	if (val < MIN_BUFFER_SIZE) {
+		fprintf(stderr,
+				_("Buffer_size is too small, "
+				  "change it to %d bytes\n"),
+				MIN_BUFFER_SIZE);
+		val = MIN_BUFFER_SIZE;
+	}
+
+	/*
+	 * up-align to MIN_BUFFER_SIZE
+	 */
+	val &= ~(MIN_BUFFER_SIZE - 1);
+
+out:
+	return val;
+}
+
+static int check_zero(const char *buffer, int buffer_size)
+{
+	long *wp = (long *)buffer;
+
+	while (*(wp++) == 0) {
+		if ((const char *)wp >= buffer + buffer_size)
+			break;
+	}
+
+	return (const char *)wp >= buffer + buffer_size;
+}
+
+int main (int argc, char **argv)
+{
+	int c;
+	char *buffer = NULL;
+	char *if_name = NULL;
+	char *of_name = NULL;
+	int buffer_size = DEFAULT_BUFFER_SIZE;
+	int source_fd = 0;
+	int target_fd = 0;
+	ssize_t ret = 0;
+	int need = 0;
+	int loop;
+	int err_num = 0;
+
+#ifdef ENABLE_NLS
+	setlocale(LC_MESSAGES, "");
+	setlocale(LC_CTYPE, "");
+	bindtextdomain(NLS_CAT_NAME, LOCALEDIR);
+	textdomain(NLS_CAT_NAME);
+#endif
+	fprintf (stderr, "mksparse %s (%s)\n", E2FSPROGS_VERSION,
+		 E2FSPROGS_DATE);
+	if (argc && *argv)
+		program_name = *argv;
+	while ((c = getopt (argc, argv, "s:i:")) != EOF)
+		switch (c) {
+		case 's':
+			buffer_size = get_buffer_size(optarg);
+			if (buffer_size < 0)
+				return -1;
+			break;
+		case 'i':
+			if_name = optarg;
+			break;
+		default:
+			usage();
+		}
+
+	if (optind != argc - 1)
+		usage();
+
+	add_error_table(&et_ext2_error_table);
+
+	of_name = argv[optind];
+
+	if (!if_name) {
+		source_fd = 0;
+	} else {
+		source_fd = open(if_name, O_RDONLY);
+		if (source_fd < 0) {
+			com_err (program_name, errno,
+					_("while trying to open %s"), if_name);
+			err_num = OPEN_SRC_FAIL;
+			goto out;
+		}
+	}
+
+	target_fd = open(of_name, O_CREAT|O_TRUNC|O_WRONLY, 0600);
+	if (target_fd < 0) {
+		com_err (program_name, errno,
+				_("while trying to open %s"), of_name);
+		err_num = OPEN_TARGET_FAIL;
+		goto out;
+	}
+
+	buffer = malloc(buffer_size);
+	if (!buffer) {
+		com_err (program_name, ENOMEM, _("while allocating buffer"));
+		err_num = MALLOC_FAIL;
+		goto out;
+	}
+
+	loop = 1;
+	do {
+		need = buffer_size;
+		while (need > 0) {
+			ret = read (source_fd,
+						buffer + (buffer_size - need),
+						need);
+			if (ret < 0) {
+				if (loop == 0)
+					break;
+				else {
+					loop = 0;
+					continue;
+				}
+			} else if (ret == 0) {
+				loop = 0;
+				break;
+			} else {
+				if (loop == 0)
+					loop = 1;
+				need -= ret;
+			}
+		}
+
+		if (need == 0 && check_zero(buffer, buffer_size)) {
+			ret = lseek(target_fd, buffer_size, SEEK_CUR);
+			if (ret == (off_t)(-1)) {
+				com_err (program_name, errno,
+						_("while lseeking %d"), ret);
+				err_num = SEEK_FAIL;
+				goto out;
+			}
+		} else if (need < buffer_size) {
+			ret = write(target_fd, buffer, buffer_size - need);
+			if (ret < 0) {
+				com_err (program_name,
+						 errno, _("while writeing"));
+				err_num = WRITE_FAIL;
+				goto out;
+			}
+		}
+	} while (loop);
+
+out:
+	if (buffer)
+		free(buffer);
+
+	if (target_fd > 0) {
+		fsync(target_fd);
+		close(target_fd);
+	}
+
+	if (source_fd > 0)
+		close(source_fd);
+
+	remove_error_table(&et_ext2_error_table);
+	return (!err_num) ? 0 : -1;
+}
-- 
1.7.3.5

