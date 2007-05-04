From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 4/4] Add ext4replay tool.
Date: Fri,  4 May 2007 14:43:24 +0530
Message-ID: <11782700142251-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11782700042368-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11782700081019-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11782700102643-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11782700113984-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:33090 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767772AbXEDJNi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 May 2007 05:13:38 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id l449FCNj4399212
	for <linux-ext4@vger.kernel.org>; Fri, 4 May 2007 19:15:12 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l449H7Zw174128
	for <linux-ext4@vger.kernel.org>; Fri, 4 May 2007 19:17:07 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l449DZjU009201
	for <linux-ext4@vger.kernel.org>; Fri, 4 May 2007 19:13:35 +1000
In-Reply-To: <11782700113984-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <69f2894044fa7c5ad14a59c22e603bc5529dce2a.1178262586.git.aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <eb16ba5f2c6f399ea747169097434ae84443728f.1178262585.git.aneesh.kumar@linux.vnet.ibm.com>
References: <eb16ba5f2c6f399ea747169097434ae84443728f.1178262585.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

This tool can be used to replay the transactions stored in the database
during ext4migrate.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 ext4migrate/Makefile.in |    7 ++++++-
 ext4migrate/replay.c    |   45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletions(-)
 create mode 100644 ext4migrate/replay.c

diff --git a/ext4migrate/Makefile.in b/ext4migrate/Makefile.in
index b000ae7..8fe6291 100644
--- a/ext4migrate/Makefile.in
+++ b/ext4migrate/Makefile.in
@@ -21,7 +21,7 @@ DEPLIBS= $(LIBEXT2FS)  $(LIBCOM_ERR)
 	@#cc -g -I../lib/  -Wunreachable-code -Wunused -Wunused-function
 	@#-Wunused-label  -Wunused-parameter -Wunused-value  -Wunused-variable  -c migrate.c
 
-PROGS= ext4migrate
+PROGS= ext4migrate ext4replay
 
 all:: $(PROGS)
 
@@ -29,6 +29,10 @@ ext4migrate: migrate.o  extents.o $(DEPLIBS)
 	@echo "	LD $@"
 	@$(CC) $(ALL_LDFLAGS) -o ext4migrate migrate.o extents.o $(LIBS)
 
+ext4replay: replay.o
+	@echo "	LD $@"
+	@$(CC) $(ALL_LDFLAGS) -o ext4replay replay.o  -ltdb
+
 installdirs:
 	@echo "	MKINSTALLDIRS $(root_sbindir)"
 	@$(MKINSTALLDIRS) $(DESTDIR)$(root_sbindir)
@@ -64,3 +68,4 @@ distclean: clean
 #
 migrate.o: $(srcdir)/migrate.c
 extents.o: $(srcdir)/extents.c
+replay.o:  $(srcdir)/replay.c
diff --git a/ext4migrate/replay.c b/ext4migrate/replay.c
new file mode 100644
index 0000000..8476416
--- /dev/null
+++ b/ext4migrate/replay.c
@@ -0,0 +1,45 @@
+#include <stdio.h>
+#include <tdb.h>
+#include <fcntl.h>
+#include <string.h>
+#include <errno.h>
+#include <stdlib.h>
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
+	long long int location;
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
+		location = *(long long int *)key.dptr;
+		printf("Replayed transaction of size %d at location %lld\n", data.dsize, location);
+		lseek(fd, location, SEEK_SET);
+		write(fd, data.dptr, data.dsize);
+	}
+	close(fd);
+	tdb_close(tdb);
+
+}
-- 
1.5.2.rc0.71.g4342-dirty
