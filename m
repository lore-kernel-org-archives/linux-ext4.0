From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/4] e2fsprogs: Add undoe2fs
Date: Wed,  1 Aug 2007 07:34:07 +0530
Message-ID: <11859338581413-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11859338491592-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:53700 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbXHACEY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2007 22:04:24 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.18.232])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l71278Fm211068
	for <linux-ext4@vger.kernel.org>; Wed, 1 Aug 2007 12:07:08 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7123ZFw216878
	for <linux-ext4@vger.kernel.org>; Wed, 1 Aug 2007 12:03:35 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7124Lwp008642
	for <linux-ext4@vger.kernel.org>; Wed, 1 Aug 2007 12:04:22 +1000
In-Reply-To: <11859338491592-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <47f96570519d76b8d59f92b729a0a48c4a1b68d8.1185933778.git.aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <bee58d48110eee4d5cd133167245b99644148d96.1185933778.git.aneesh.kumar@linux.vnet.ibm.com>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185933778.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

undoe2fs can be used to replay the transaction saved
in the transaction file using undo I/O Manager

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 misc/Makefile.in |   10 +++++-
 misc/undoe2fs.c  |   77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 2 deletions(-)
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
index 0000000..d14d44a
--- /dev/null
+++ b/misc/undoe2fs.c
@@ -0,0 +1,77 @@
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
+#include <fcntl.h>
+#if HAVE_ERRNO_H
+#include <errno.h>
+#endif
+#include "ext2fs/tdb.h"
+
+void usage(char *prg_name)
+{
+	fprintf(stderr,
+		"Usage: %s <transaction file> <filesystem>\n", prg_name);
+	exit(1);
+
+}
+
+
+main(int argc, char *argv[])
+{
+	TDB_CONTEXT *tdb;
+	TDB_DATA key, data;
+	unsigned long  blk_num;
+	unsigned long long int location;
+	int fd, retval;
+
+	if (argc != 3)
+		usage(argv[0]);
+
+	tdb = tdb_open(argv[1], 0, 0, O_RDONLY, 0600);
+
+	if (!tdb) {
+		fprintf(stderr, "Failed tdb_open %s\n",  strerror(errno));
+		exit(1);
+	}
+
+	fd = open(argv[2], O_WRONLY);
+	if (fd  == -1) {
+		fprintf(stderr, "Failed open %s\n", strerror(errno));
+		exit(1);
+	}
+
+	for (key = tdb_firstkey(tdb); key.dptr; key = tdb_nextkey(tdb, key)) {
+		data = tdb_fetch(tdb, key);
+		if (!data.dptr) {
+			fprintf(stderr,
+				"Failed tdb_fetch %s\n", tdb_errorstr(tdb));
+			exit(1);
+		}
+		blk_num = *(unsigned long *)key.dptr;
+		location = blk_num * data.dsize;
+		printf("Replayed transaction of size %d at location %ld\n",
+							data.dsize, blk_num);
+		retval = lseek(fd, location, SEEK_SET);
+		if (retval == -1) {
+			fprintf(stderr, "Failed lseek %s\n", strerror(errno));
+			exit(1);
+		}
+		retval = write(fd, data.dptr, data.dsize);
+		if (retval == -1) {
+			fprintf(stderr, "Failed write %s\n", strerror(errno));
+			exit(1);
+		}
+	}
+	close(fd);
+	tdb_close(tdb);
+
+}
-- 
1.5.3.rc2.22.g69a9b-dirty
