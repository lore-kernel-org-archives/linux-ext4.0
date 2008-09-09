From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] Add extent conversion support to chattr
Date: Tue,  9 Sep 2008 14:42:22 +0530
Message-ID: <1220951542-1451-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.ed, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:53872 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbYIIJOA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 05:14:00 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m899CmfD017244
	for <linux-ext4@vger.kernel.org>; Tue, 9 Sep 2008 19:12:48 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m899DRCf4419676
	for <linux-ext4@vger.kernel.org>; Tue, 9 Sep 2008 19:13:57 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m899DRlf009374
	for <linux-ext4@vger.kernel.org>; Tue, 9 Sep 2008 19:13:27 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds new option, -E to chattr. The -E option
is used to convert the ext3 format (non extent) file
to ext4 (extent) format. This can be used to migrate
the ext3 file system to ext4 file system.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 lib/e2p/Makefile.in  |    6 +++-
 lib/e2p/e2p.h        |    1 +
 lib/e2p/migrate.c    |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_fs.h |    1 +
 misc/chattr.1.in     |    5 +++-
 misc/chattr.c        |   20 +++++++++++++++++-
 6 files changed, 80 insertions(+), 5 deletions(-)

diff --git a/lib/e2p/Makefile.in b/lib/e2p/Makefile.in
index c1a45f5..56b6a3a 100644
--- a/lib/e2p/Makefile.in
+++ b/lib/e2p/Makefile.in
@@ -19,7 +19,7 @@ all::	e2p.pc
 OBJS=		feature.o fgetflags.o fsetflags.o fgetversion.o fsetversion.o \
 		getflags.o getversion.o hashstr.o iod.o ls.o mntopts.o \
 		parse_num.o pe.o pf.o ps.o setflags.o setversion.o uuid.o \
-		ostype.o percent.o
+		ostype.o percent.o migrate.o
 
 SRCS=		$(srcdir)/feature.c $(srcdir)/fgetflags.c \
 		$(srcdir)/fsetflags.c $(srcdir)/fgetversion.c \
@@ -28,7 +28,7 @@ SRCS=		$(srcdir)/feature.c $(srcdir)/fgetflags.c \
 		$(srcdir)/ls.c $(srcdir)/mntopts.c $(srcdir)/parse_num.c \
 		$(srcdir)/pe.c $(srcdir)/pf.c $(srcdir)/ps.c \
 		$(srcdir)/setflags.c $(srcdir)/setversion.c $(srcdir)/uuid.c \
-		$(srcdir)/ostype.c $(srcdir)/percent.c
+		$(srcdir)/ostype.c $(srcdir)/percent.c $(srcdir)/migrate.c
 HFILES= e2p.h
 
 LIBRARY= libe2p
@@ -162,3 +162,5 @@ ostype.o: $(srcdir)/ostype.c $(srcdir)/e2p.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h
 percent.o: $(srcdir)/percent.c $(srcdir)/e2p.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h
+migrate.o: $(srcdir)/migrate.c $(srcdir)/e2p.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h
diff --git a/lib/e2p/e2p.h b/lib/e2p/e2p.h
index 98c97db..8cbf360 100644
--- a/lib/e2p/e2p.h
+++ b/lib/e2p/e2p.h
@@ -60,3 +60,4 @@ char *e2p_os2string(int os_type);
 int e2p_string2os(char *str);
 
 unsigned int e2p_percent(int percent, unsigned int base);
+int ext4_migrate(const char * name);
diff --git a/lib/e2p/migrate.c b/lib/e2p/migrate.c
new file mode 100644
index 0000000..fa5b58c
--- /dev/null
+++ b/lib/e2p/migrate.c
@@ -0,0 +1,52 @@
+/*
+ * Convert a file to extent format
+ *
+ *  Copyright IBM Corporation, 2008
+ *  Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *
+ * This file can be redistributed under the terms of the GNU Library General
+ * Public License
+ */
+
+#define _LARGEFILE_SOURCE
+#define _LARGEFILE64_SOURCE
+
+#if HAVE_ERRNO_H
+#include <errno.h>
+#endif
+#if HAVE_UNISTD_H
+#include <unistd.h>
+#endif
+#include <fcntl.h>
+#if HAVE_SYS_IOCTL_H
+#include <sys/ioctl.h>
+#endif
+#include "e2p.h"
+
+#ifdef O_LARGEFILE
+#define OPEN_FLAGS (O_RDONLY|O_NONBLOCK|O_LARGEFILE)
+#else
+#define OPEN_FLAGS (O_RDONLY|O_NONBLOCK)
+#endif
+
+int ext4_migrate(const char * name)
+{
+#if HAVE_EXT2_IOCTLS
+	int fd, r, save_errno = 0;
+
+	fd = open (name, OPEN_FLAGS);
+	if (fd == -1)
+		return -1;
+	r = ioctl (fd, EXT4_IOC_MIGRATE, NULL);
+	if (r == -1)
+		save_errno = errno;
+	close (fd);
+	if (save_errno)
+		errno = save_errno;
+	return r;
+#else /* ! HAVE_EXT2_IOCTLS */
+	extern int errno;
+	errno = EOPNOTSUPP;
+	return -1;
+#endif /* ! HAVE_EXT2_IOCTLS */
+}
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index d7d7bdb..2fe6691 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -316,6 +316,7 @@ struct ext4_new_group_input {
 #define EXT2_IOC_GROUP_EXTEND		_IOW('f', 7, unsigned long)
 #define EXT2_IOC_GROUP_ADD		_IOW('f', 8,struct ext2_new_group_input)
 #define EXT4_IOC_GROUP_ADD		_IOW('f', 8,struct ext4_new_group_input)
+#define EXT4_IOC_MIGRATE                _IO('f', 7)
 
 /*
  * Structure of an inode on the disk
diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 960f058..7e7f62a 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -5,7 +5,7 @@ chattr \- change file attributes on a Linux second extended file system
 .SH SYNOPSIS
 .B chattr
 [
-.B \-RVf
+.B \-RVfE
 ]
 [
 .B \-v
@@ -41,6 +41,9 @@ Be verbose with chattr's output and print the program version.
 .B \-f
 Suppress most error messages.
 .TP
+.B \-E
+Convert the file to extent format
+.TP
 .BI \-v " version"
 Set the file's version/generation number.
 .SH ATTRIBUTES
diff --git a/misc/chattr.c b/misc/chattr.c
index 3d67519..95a3998 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -60,6 +60,7 @@ static int add;
 static int rem;
 static int set;
 static int set_version;
+static int conv_to_extents;
 
 static unsigned long version;
 
@@ -82,7 +83,7 @@ static unsigned long sf;
 static void usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-RVf] [-+=AacDdijsSu] [-v version] files...\n"),
+		_("Usage: %s [-RVfE] [-+=AacDdijsSu] [-v version] files...\n"),
 		program_name);
 	exit(1);
 }
@@ -156,6 +157,10 @@ static int decode_arg (int * i, int argc, char ** argv)
 				set_version = 1;
 				continue;
 			}
+			if (*p == 'E') {
+				conv_to_extents = 1;
+				continue;
+			}
 			if ((fl = get_flag(*p)) == 0)
 				usage();
 			rf |= fl;
@@ -245,6 +250,17 @@ static int change_attributes(const char * name)
 			return -1;
 		}
 	}
+	if (conv_to_extents) {
+		if (verbose)
+			printf (_("Converting %s to extent format\n"), name);
+		if (ext4_migrate(name) == -1) {
+			if (!silent)
+				com_err (program_name, errno,
+				 _("while converting %s to extent format"),
+				 name);
+			return -1;
+		}
+	}
 	if (S_ISDIR(st.st_mode) && recursive)
 		return iterate_on_dir (name, chattr_dir_proc, NULL);
 	return 0;
@@ -306,7 +322,7 @@ int main (int argc, char ** argv)
 		fputs("Can't both set and unset same flag.\n", stderr);
 		exit (1);
 	}
-	if (!(add || rem || set || set_version)) {
+	if (!(add || rem || set || set_version || conv_to_extents)) {
 		fputs(_("Must use '-v', =, - or +\n"), stderr);
 		exit (1);
 	}
-- 
tg: (5bf3f80..) an/chattr (depends on: master)
