From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] Add e4migrate
Date: Fri,  5 Sep 2008 15:41:46 +0530
Message-ID: <1220609506-2052-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:50889 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbYIEKNg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Sep 2008 06:13:36 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m85ACBN8004649
	for <linux-ext4@vger.kernel.org>; Fri, 5 Sep 2008 20:12:11 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m85ABsAr4419732
	for <linux-ext4@vger.kernel.org>; Fri, 5 Sep 2008 20:12:04 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m85ABsSn015650
	for <linux-ext4@vger.kernel.org>; Fri, 5 Sep 2008 20:11:54 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds new command e4migrate. This can be used
to convert ext3 file system to ext4 file system.
Once we have the e4defrag we may want to merge the
migrate with defrag. This will enables us to do a defrag
immediately after migrate resulting in better disk layout.
This will also enables us to defrag ext3 inodes

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 misc/Makefile.in    |   17 ++++++++++++--
 misc/e4migrate.8.in |   28 +++++++++++++++++++++++++
 misc/e4migrate.c    |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+), 3 deletions(-)

diff --git a/misc/Makefile.in b/misc/Makefile.in
index a81df8a..7ebeaf7 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -18,11 +18,12 @@ INSTALL = @INSTALL@
 @UUIDD_CMT@UUIDD_MAN= uuidd.8
 
 SPROGS=		mke2fs badblocks tune2fs dumpe2fs blkid logsave \
-			$(E2IMAGE_PROG) @FSCK_PROG@ e2undo
+			$(E2IMAGE_PROG) @FSCK_PROG@ e2undo e4migrate
 USPROGS=	mklost+found filefrag $(UUIDD_PROG)
 SMANPAGES=	tune2fs.8 mklost+found.8 mke2fs.8 dumpe2fs.8 badblocks.8 \
 			e2label.8 findfs.8 blkid.8 $(E2IMAGE_MAN) \
-			logsave.8 filefrag.8 e2undo.8 $(UUIDD_MAN) @FSCK_MAN@
+			logsave.8 filefrag.8 e2undo.8 e4migrate.8 \
+			$(UUIDD_MAN) @FSCK_MAN@
 FMANPAGES=	mke2fs.conf.5
 
 UPROGS=		chattr lsattr uuidgen
@@ -44,6 +45,7 @@ FSCK_OBJS=	fsck.o base_device.o ismounted.o
 BLKID_OBJS=	blkid.o
 FILEFRAG_OBJS=	filefrag.o
 E2UNDO_OBJS=  e2undo.o
+E4MIGRATE_OBJS = e4migrate.o
 
 XTRA_CFLAGS=	-I$(srcdir)/../e2fsck -I.
 
@@ -53,7 +55,7 @@ SRCS=	$(srcdir)/tune2fs.c $(srcdir)/mklost+found.c $(srcdir)/mke2fs.c \
 		$(srcdir)/uuidgen.c $(srcdir)/blkid.c $(srcdir)/logsave.c \
 		$(srcdir)/filefrag.c $(srcdir)/base_device.c \
 		$(srcdir)/ismounted.c $(srcdir)/../e2fsck/profile.c \
-		$(srcdir)/e2undo.c
+		$(srcdir)/e2undo.c $(srcdir)/e4migrate.c
 
 LIBS= $(LIBEXT2FS) $(LIBCOM_ERR) 
 DEPLIBS= $(LIBEXT2FS) $(LIBCOM_ERR) 
@@ -124,6 +126,10 @@ e2undo: $(E2UNDO_OBJS) $(DEPLIBS)
 	@echo "	LD $@"
 	@$(CC) $(ALL_LDFLAGS) -o e2undo $(E2UNDO_OBJS) $(LIBS) $(LIBINTL)
 
+e4migrate: $(E4MIGRATE_OBJS)
+	@echo "	LD $@"
+	@$(CC) $(ALL_LDFLAGS) -o e4migrate $(E4MIGRATE_OBJS) $(LIBINTL)
+
 base_device: base_device.c
 	@echo "	LD $@"
 	@$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) $(srcdir)/base_device.c \
@@ -213,6 +219,10 @@ e2undo.8: $(DEP_SUBSTITUTE) $(srcdir)/e2undo.8.in
 	@echo "	SUBST $@"
 	@$(SUBSTITUTE_UPTIME) $(srcdir)/e2undo.8.in e2undo.8
 
+e4migrate.8: $(DEP_SUBSTITUTE) $(srcdir)/e4migrate.8.in
+	@echo "	SUBST $@"
+	@$(SUBSTITUTE_UPTIME) $(srcdir)/e4migrate.8.in e4migrate.8
+
 findfs.8: $(DEP_SUBSTITUTE) $(srcdir)/findfs.8.in
 	@echo "	SUBST $@"
 	@$(SUBSTITUTE_UPTIME) $(srcdir)/findfs.8.in findfs.8
@@ -505,3 +515,4 @@ ismounted.o: $(srcdir)/ismounted.c $(top_srcdir)/lib/et/com_err.h
 profile.o: $(srcdir)/../e2fsck/profile.c $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/../e2fsck/profile.h prof_err.h
 e2undo.o: $(srcdir)/e2undo.c $(top_srcdir)/lib/ext2fs/tdb.h
+e4migrate.o: $(srcdir)/e4migrate.c
diff --git a/misc/e4migrate.8.in b/misc/e4migrate.8.in
new file mode 100644
index 0000000..e9a0466
--- /dev/null
+++ b/misc/e4migrate.8.in
@@ -0,0 +1,28 @@
+.\" -*- nroff -*-
+.\" Copyright 2008 by Aneesh Kumar K.V.  All Rights Reserved.
+.\" This file may be copied under the terms of the GNU Public License.
+.\"
+.TH E4MIGRATE 8 "@E2FSPROGS_MONTH@ @E2FSPROGS_YEAR@" "E2fsprogs version @E2FSPROGS_VERSION@"
+.SH NAME
+e4migrate \- Migrate an ext3 inode to ext4 inode format
+.SH SYNOPSIS
+.B e4migrate
+.I filename
+.SH DESCRIPTION
+.B e4migrate
+will migrate
+.I  filename
+in ext3 inode format to ext4 inode format
+This can be
+used to migrate an ext3 file system to ext4 file system
+.SH AUTHOR
+.B e4migrate
+was written by Aneesh Kumar K.V. (aneesh.kumar@linux.vnet.ibm.com)
+.SH AVAILABILITY
+.B e2undo
+is part of the e2fsprogs package and is available from
+http://e2fsprogs.sourceforge.net.
+.SH SEE ALSO
+.BR mke2fs (8),
+.BR tune2fs (8)
+
diff --git a/misc/e4migrate.c b/misc/e4migrate.c
new file mode 100644
index 0000000..4948849
--- /dev/null
+++ b/misc/e4migrate.c
@@ -0,0 +1,57 @@
+#include <stdio.h>
+#include <fcntl.h>
+#if HAVE_SYS_IOCTL_H
+#include <sys/ioctl.h>
+#endif
+#if HAVE_GETOPT_H
+#include <getopt.h>
+#endif
+#if HAVE_ERRNO_H
+#include <errno.h>
+#endif
+#if HAVE_STRING_H
+#include <string.h>
+#endif
+#if HAVE_STDLIB_H
+#include <stdlib.h>
+#endif
+#include "nls-enable.h"
+
+
+
+#define EXT4_IOC_MIGRATE                _IO('f', 7)
+static void usage(char *prg_name)
+{
+	fprintf(stderr,
+		_("Usage: %s <filename>\n"), prg_name);
+	exit(1);
+}
+static void migrate(char *filename)
+{
+	int fd, retval;
+	fd = open(filename, O_RDWR);
+	if (fd < 0) {
+		fprintf(stderr, _("Failed to open the file %s\n"), filename);
+		exit(1);
+	}
+	retval = ioctl(fd, EXT4_IOC_MIGRATE, NULL);
+	if (retval) {
+		fprintf(stderr,
+			_("Migrate failed for file %s with error: %s\n"),
+			filename, strerror(errno));
+		exit(1);
+	} else
+		printf(_("Successfully migrated %s\n"), filename);
+}
+
+int main(int argc, char *argv[])
+{
+	if (argc != 2) {
+		usage(argv[0]);
+	}
+
+	migrate(argv[1]);
+	return 0;
+}
+
+
-- 
tg: (b55d739..) an/e4migrate (depends on: master)
