From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/2] e2fsprogs: Add undoe2fs
Date: Wed, 11 Jul 2007 16:30:59 +0530
Message-ID: <11841516682413-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11841516593232-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11841516661516-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: tytso@mit.edu, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:58690 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760721AbXGKLBT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 07:01:19 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l6BB2X0g4673690
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jul 2007 21:02:33 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.250.243])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6BB4hIe077644
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jul 2007 21:04:45 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6BB1ApS023242
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jul 2007 21:01:10 +1000
In-Reply-To: <11841516661516-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <7bda5b7be5247e02efe87ba887f28e141d96d1fd.1184151488.git.aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <3552edc8ff6130d0687083e7462144c308fd2a14.1184151488.git.aneesh.kumar@linux.vnet.ibm.com>
References: <3552edc8ff6130d0687083e7462144c308fd2a14.1184151488.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

undoe2fs can be used to replay the transaction saved
in the transaction file using undo I/O Manager

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 misc/Makefile.in |   10 ++++++++--
 misc/undoe2fs.c  |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 2 deletions(-)
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
index 0000000..c209878
--- /dev/null
+++ b/misc/undoe2fs.c
@@ -0,0 +1,48 @@
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
+	fprintf(stderr, "Usage: %s <transaction file> <filesystem>\n", prg_name);
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
+	int fd;
+
+	if (argc != 3)
+		usage(argv[0]);
+
+	tdb = tdb_open(argv[1], 0, 0, O_RDONLY, 0600);
+
+	if (!tdb) {
+		printf("Failed tdb_open %s\n",  strerror(errno));
+		exit(1);
+	}
+
+	fd = open(argv[2], O_WRONLY);
+
+	for (key = tdb_firstkey(tdb); key.dptr; key = tdb_nextkey(tdb, key)) {
+		data = tdb_fetch(tdb, key);
+		blk_num = *(unsigned long *)key.dptr;
+		location = blk_num * data.dsize;
+		printf("Replayed transaction of size %d at location %ld\n", data.dsize, blk_num);
+		lseek(fd, location, SEEK_SET);
+		write(fd, data.dptr, data.dsize);
+	}
+	close(fd);
+	tdb_close(tdb);
+
+}
-- 
1.5.3.rc0.63.gc956-dirty
