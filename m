From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/6] e2fsprogs: Add undoe2fs
Date: Mon, 13 Aug 2007 15:56:22 +0530
Message-ID: <11870007931987-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11870007861341-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11870007892653-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:64969 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S941253AbXHMK7t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Aug 2007 06:59:49 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l7DB1SJf318232
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 21:02:15 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7DAQa134161736
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 20:26:36 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7DBQZ6g006716
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 21:26:36 +1000
In-Reply-To: <11870007892653-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

undoe2fs can be used to replay the transaction saved
in the transaction file using undo I/O Manager

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 misc/Makefile.in |   10 ++-
 misc/undoe2fs.c  |  220 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 228 insertions(+), 2 deletions(-)
 create mode 100644 misc/undoe2fs.c

diff --git a/misc/Makefile.in b/misc/Makefile.in
index ccad78c..51bb17a 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -15,7 +15,7 @@ INSTALL = @INSTALL@
 @IMAGER_CMT@E2IMAGE_MAN= e2image.8
 
 SPROGS=		mke2fs badblocks tune2fs dumpe2fs blkid logsave \
-			$(E2IMAGE_PROG) @FSCK_PROG@ 
+			$(E2IMAGE_PROG) @FSCK_PROG@  undoe2fs
 USPROGS=	mklost+found filefrag
 SMANPAGES=	tune2fs.8 mklost+found.8 mke2fs.8 dumpe2fs.8 badblocks.8 \
 			e2label.8 findfs.8 blkid.8 $(E2IMAGE_MAN) \
@@ -39,6 +39,7 @@ E2IMAGE_OBJS=	e2image.o
 FSCK_OBJS=	fsck.o base_device.o
 BLKID_OBJS=	blkid.o
 FILEFRAG_OBJS=	filefrag.o
+UNDOE2FS_OBJS=  undoe2fs.o
 
 XTRA_CFLAGS=	-I$(srcdir)/../e2fsck -I.
 
@@ -47,7 +48,7 @@ SRCS=	$(srcdir)/tune2fs.c $(srcdir)/mklost+found.c $(srcdir)/mke2fs.c \
 		$(srcdir)/badblocks.c $(srcdir)/fsck.c $(srcdir)/util.c \
 		$(srcdir)/uuidgen.c $(srcdir)/blkid.c $(srcdir)/logsave.c \
 		$(srcdir)/filefrag.c $(srcdir)/base_device.c \
-		$(srcdir)/../e2fsck/profile.c
+		$(srcdir)/../e2fsck/profile.c $(srcdir)/undoe2fs.c
 
 LIBS= $(LIBEXT2FS) $(LIBCOM_ERR) 
 DEPLIBS= $(LIBEXT2FS) $(LIBCOM_ERR) 
@@ -108,6 +109,10 @@ e2image: $(E2IMAGE_OBJS) $(DEPLIBS)
 	@echo "	LD $@"
 	@$(CC) $(ALL_LDFLAGS) -o e2image $(E2IMAGE_OBJS) $(LIBS) $(LIBINTL)
 
+undoe2fs: $(UNDOE2FS_OBJS) $(DEPLIBS)
+	@echo "	LD $@"
+	@$(CC) $(ALL_LDFLAGS) -o undoe2fs $(UNDOE2FS_OBJS) $(LIBS)
+
 base_device: base_device.c
 	@echo "	LD $@"
 	@$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) $(srcdir)/base_device.c \
@@ -434,3 +439,4 @@ filefrag.o: $(srcdir)/filefrag.c
 base_device.o: $(srcdir)/base_device.c $(srcdir)/fsck.h
 profile.o: $(srcdir)/../e2fsck/profile.c $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/../e2fsck/profile.h prof_err.h
+undoe2fs.o: $(srcdir)/undoe2fs.c $(top_srcdir)/lib/ext2fs/tdb.h
diff --git a/misc/undoe2fs.c b/misc/undoe2fs.c
new file mode 100644
index 0000000..d675424
--- /dev/null
+++ b/misc/undoe2fs.c
@@ -0,0 +1,220 @@
+/*
+ * Copyright IBM Corporation, 2007
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#ifdef HAVE_GETOPT_H
+#include <getopt.h>
+#endif
+#include <fcntl.h>
+#if HAVE_ERRNO_H
+#include <errno.h>
+#endif
+#include "ext2fs/tdb.h"
+#include "ext2fs/ext2fs.h"
+#include "nls-enable.h"
+
+
+
+static void usage(char *prg_name)
+{
+	fprintf(stderr,
+		_("Usage: %s <transaction file> <filesystem>\n"), prg_name);
+	exit(1);
+
+}
+static int check_filesystem(TDB_CONTEXT *tdb, io_channel channel)
+{
+	__u32   s_mtime;
+	__u8    s_uuid[16];
+	errcode_t retval;
+	TDB_DATA tdb_key, tdb_data;
+	struct ext2_super_block super;
+
+	io_channel_set_blksize(channel, SUPERBLOCK_OFFSET);
+	retval = io_channel_read_blk(channel, 1, -SUPERBLOCK_SIZE, &super);
+	if (retval) {
+		com_err(__FUNCTION__,
+			retval, _("Failed to read the file system data \n"));
+		return retval;
+	}
+
+	tdb_key.dptr = "filesystem MTIME";
+	tdb_key.dsize = sizeof("filesystem MTIME");
+	tdb_data = tdb_fetch(tdb, tdb_key);
+	if (!tdb_data.dptr) {
+		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
+		com_err(__FUNCTION__, retval,
+			_("Failed tdb_fetch %s\n"), tdb_errorstr(tdb));
+		return retval;
+	}
+
+	s_mtime = *(__u32 *)tdb_data.dptr;
+	if (super.s_mtime != s_mtime) {
+
+		com_err(__FUNCTION__, 0,
+			_("The file system Mount time didn't match %u\n"),
+			s_mtime);
+
+		return  -1;
+	}
+
+
+	tdb_key.dptr = "filesystem UUID";
+	tdb_key.dsize = sizeof("filesystem UUID");
+	tdb_data = tdb_fetch(tdb, tdb_key);
+	if (!tdb_data.dptr) {
+		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
+		com_err(__FUNCTION__, retval,
+			_("Failed tdb_fetch %s\n"), tdb_errorstr(tdb));
+		return retval;
+	}
+	memcpy(s_uuid, tdb_data.dptr, sizeof(s_uuid));
+	if (memcmp(s_uuid, super.s_uuid, sizeof(s_uuid))) {
+		com_err(__FUNCTION__, 0,
+			_("The file system UUID didn't match \n"));
+		return -1;
+	}
+
+	return 0;
+}
+
+static int set_blk_size(TDB_CONTEXT *tdb, io_channel channel)
+{
+	int block_size;
+	errcode_t retval;
+	TDB_DATA tdb_key, tdb_data;
+
+	tdb_key.dptr = "filesystem BLKSIZE";
+	tdb_key.dsize = sizeof("filesystem BLKSIZE");
+	tdb_data = tdb_fetch(tdb, tdb_key);
+	if (!tdb_data.dptr) {
+		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
+		com_err(__FUNCTION__, retval,
+			_("Failed tdb_fetch %s\n"), tdb_errorstr(tdb));
+		return retval;
+	}
+
+	block_size = *(int *)tdb_data.dptr;
+#ifdef DEBUG
+	printf("Block size %d\n", block_size);
+#endif
+	io_channel_set_blksize(channel, block_size);
+
+	return 0;
+}
+
+main(int argc, char *argv[])
+{
+	int c,force = 0;
+	TDB_CONTEXT *tdb;
+	TDB_DATA key, data;
+	io_channel channel;
+	errcode_t retval;
+	int  mount_flags;
+	unsigned long  blk_num;
+	char *device_name, *tdb_file, *prg_name;
+	unsigned long long int location;
+	io_manager manager = unix_io_manager;
+
+	static struct option long_opt[] = {
+		{"force", 0, 0, 'f'},
+		{0, 0, 0, 0}
+	};
+
+
+
+	prg_name = argv[0];
+	while((c = getopt_long(argc, argv, "f",
+					long_opt, NULL)) != EOF) {
+		switch (c) {
+
+			case 'f':
+				force = 1;
+				break;
+			default:
+				usage(prg_name);
+		}
+	}
+
+	if (argc != optind+2)
+		usage(prg_name);
+
+	tdb_file = argv[optind];
+	device_name = argv[optind+1];
+
+	tdb = tdb_open(tdb_file, 0, 0, O_RDONLY, 0600);
+
+	if (!tdb) {
+		com_err(prg_name, retval,
+				_("Failed tdb_open %s\n"),  strerror(errno));
+		exit(1);
+	}
+
+	retval = ext2fs_check_if_mounted(device_name, &mount_flags);
+	if (retval) {
+		com_err(prg_name, retval, _("Error while determining whether "
+				"%s is mounted.\n"), device_name);
+		exit(1);
+	}
+
+	if (mount_flags & EXT2_MF_MOUNTED) {
+		com_err(prg_name, retval, _("undoe2fs should only be run on "
+				"unmounted file system\n"));
+		exit(1);
+	}
+
+	retval = manager->open(device_name,
+				IO_FLAG_EXCLUSIVE | IO_FLAG_RW,  &channel);
+	if (retval) {
+		com_err(prg_name, retval,
+				_("Failed to open %s\n"), device_name);
+		exit(1);
+	}
+
+	if (!force && check_filesystem(tdb, channel)) {
+		exit(1);
+	}
+
+	if (set_blk_size(tdb, channel)) {
+		exit(1);
+	}
+
+	for (key = tdb_firstkey(tdb); key.dptr; key = tdb_nextkey(tdb, key)) {
+
+		if (!strcmp(key.dptr, "filesystem MTIME") ||
+				!strcmp(key.dptr, "filesystem UUID") ||
+				!strcmp(key.dptr, "filesystem BLKSIZE")) {
+			continue;
+		}
+
+
+		data = tdb_fetch(tdb, key);
+		if (!data.dptr) {
+			com_err(prg_name, 0,
+				_("Failed tdb_fetch %s\n"), tdb_errorstr(tdb));
+			exit(1);
+		}
+		blk_num = *(unsigned long *)key.dptr;
+		printf(_("Replayed transaction of size %d at location %ld\n"),
+							data.dsize, blk_num);
+		retval = io_channel_write_blk(channel, blk_num,
+						-data.dsize, data.dptr);
+		if (retval == -1) {
+			com_err(prg_name, retval,
+					_("Failed write %s\n"),
+					strerror(errno));
+			exit(1);
+		}
+	}
+	io_channel_close(channel);
+	tdb_close(tdb);
+
+}
-- 
1.5.3.rc4.67.gf9286-dirty
