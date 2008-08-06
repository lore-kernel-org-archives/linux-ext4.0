From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/3][e2fsprogs] lsattr: list file creation time
Date: Wed, 06 Aug 2008 17:09:15 +0800
Message-ID: <48996A3B.2040501@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59035 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760263AbYHFJKl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Aug 2008 05:10:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add option '-c' to list files' creation time:

$ lsattr -c tmp
2008-08-06 15:36:24.762780702 +0800 -------------e- tmp

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 lib/e2p/Makefile.in  |    4 +-
 lib/e2p/e2p.h        |    2 +-
 lib/e2p/fgetcrtime.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_fs.h |    1 +
 misc/lsattr.1.in     |    3 ++
 misc/lsattr.c        |   24 +++++++++++++++++-
 6 files changed, 97 insertions(+), 4 deletions(-)
 create mode 100644 lib/e2p/fgetcrtime.c

diff --git a/lib/e2p/Makefile.in b/lib/e2p/Makefile.in
index 6557480..4df3b9a 100644
--- a/lib/e2p/Makefile.in
+++ b/lib/e2p/Makefile.in
@@ -19,7 +19,7 @@ all::	e2p.pc
 OBJS=		feature.o fgetflags.o fsetflags.o fgetversion.o fsetversion.o \
 		getflags.o getversion.o hashstr.o iod.o ls.o mntopts.o \
 		parse_num.o pe.o pf.o ps.o setflags.o setversion.o uuid.o \
-		ostype.o percent.o
+		ostype.o percent.o fgetcrtime.o
 
 SRCS=		$(srcdir)/feature.c $(srcdir)/fgetflags.c \
 		$(srcdir)/fsetflags.c $(srcdir)/fgetversion.c \
@@ -28,7 +28,7 @@ SRCS=		$(srcdir)/feature.c $(srcdir)/fgetflags.c \
 		$(srcdir)/ls.c $(srcdir)/mntopts.c $(srcdir)/parse_num.c \
 		$(srcdir)/pe.c $(srcdir)/pf.c $(srcdir)/ps.c \
 		$(srcdir)/setflags.c $(srcdir)/setversion.c $(srcdir)/uuid.c \
-		$(srcdir)/ostype.c $(srcdir)/percent.c
+		$(srcdir)/ostype.c $(srcdir)/percent.c $(srcdir)/fgetcrtime.c
 HFILES= e2p.h
 
 LIBRARY= libe2p
diff --git a/lib/e2p/e2p.h b/lib/e2p/e2p.h
index 06e2120..644248a 100644
--- a/lib/e2p/e2p.h
+++ b/lib/e2p/e2p.h
@@ -15,9 +15,9 @@
 
 #define PFOPT_LONG  1 /* Must be 1 for compatibility with `int long_format'. */
 
-
 int fgetflags (const char * name, unsigned long * flags);
 int fgetversion (const char * name, unsigned long * version);
+int fgetcrtime (const char * name, struct timespec * crtime);
 int fsetflags (const char * name, unsigned long flags);
 int fsetversion (const char * name, unsigned long version);
 int getflags (int fd, unsigned long * flags);
diff --git a/lib/e2p/fgetcrtime.c b/lib/e2p/fgetcrtime.c
new file mode 100644
index 0000000..99bb9d5
--- /dev/null
+++ b/lib/e2p/fgetcrtime.c
@@ -0,0 +1,67 @@
+/*
+ * fgetversion.c	- Get the file creation time on an ext4 file system
+ *
+ * Copyright (C) 1993, 1994  Remy Card <card@masi.ibp.fr>
+ *                           Laboratoire MASI, Institut Blaise Pascal
+ *                           Universite Pierre et Marie Curie (Paris VI)
+ *
+ * Copyright (C) 2008        Li Zefan <lizf@cn.fujitsu.cn>
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
+#include <sys/ioctl.h>
+#include <time.h>
+
+#include "e2p.h"
+
+#ifdef O_LARGEFILE
+#define OPEN_FLAGS (O_RDONLY|O_NONBLOCK|O_LARGEFILE)
+#else
+#define OPEN_FLAGS (O_RDONLY|O_NONBLOCK)
+#endif
+
+int fgetcrtime (const char * name, struct timespec * crtime)
+{
+#if HAVE_EXT2_IOCTLS
+#if !APPLE_DARWIN
+	int fd, r, save_errno = 0;
+	struct timespec cr;
+
+	fd = open (name, OPEN_FLAGS);
+	if (fd == -1)
+		return -1;
+	r = ioctl (fd, EXT4_IOC_GETCRTIME, &cr);
+	if (r == -1)
+		save_errno = errno;
+	*crtime = cr;
+	close (fd);
+	if (save_errno)
+		errno = save_errno;
+	return r;
+#else
+	int ver=-1, err;
+	struct timespec cr;
+
+	err = syscall(SYS_fsctl, name, EXT4_IOC_GETCRTIME, &cr, 0);
+	*crtime = cr;
+	return(err);
+#endif
+#else /* ! HAVE_EXT2_IOCTLS */
+	extern int errno;
+	errno = EOPNOTSUPP;
+	return -1;
+#endif /* ! HAVE_EXT2_IOCTLS */
+}
+
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 554c708..55a56f6 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -316,6 +316,7 @@ struct ext4_new_group_input {
 #define EXT2_IOC_GROUP_EXTEND		_IOW('f', 7, unsigned long)
 #define EXT2_IOC_GROUP_ADD		_IOW('f', 8,struct ext2_new_group_input)
 #define EXT4_IOC_GROUP_ADD		_IOW('f', 8,struct ext4_new_group_input)
+#define EXT4_IOC_GETCRTIME		_IOR('f', 9, struct timespec)
 
 /*
  * Structure of an inode on the disk
diff --git a/misc/lsattr.1.in b/misc/lsattr.1.in
index 7798a34..e733b68 100644
--- a/misc/lsattr.1.in
+++ b/misc/lsattr.1.in
@@ -26,6 +26,9 @@ Display the program version.
 .B \-a
 List all files in directories, including files that start with `.'.
 .TP
+.B \-c
+List the file's creation time.
+.TP
 .B \-d
 List directories like other files, rather than listing their contents.
 .TP
diff --git a/misc/lsattr.c b/misc/lsattr.c
index 093f50f..63ce5c1 100644
--- a/misc/lsattr.c
+++ b/misc/lsattr.c
@@ -37,6 +37,7 @@ extern char *optarg;
 #include <string.h>
 #include <sys/param.h>
 #include <sys/stat.h>
+#include <time.h>
 
 #include "ext2fs/ext2_fs.h"
 #include "et/com_err.h"
@@ -59,6 +60,7 @@ static unsigned pf_options;
 static int recursive;
 static int verbose;
 static int generation_opt;
+static int crtime_opt;
 
 #ifdef _LFS64_LARGEFILE
 #define LSTAT		lstat64
@@ -78,12 +80,29 @@ static void list_attributes (const char * name)
 {
 	unsigned long flags;
 	unsigned long generation;
+	struct timespec crtime;
+	struct tm *tm;
+	char str[1024];
+	size_t p;
 
 	if (fgetflags (name, &flags) == -1) {
 		com_err (program_name, errno, _("While reading flags on %s"),
 			 name);
 		return;
 	}
+	if (crtime_opt) {
+		if (fgetcrtime (name, &crtime) == -1) {
+			com_err (program_name, errno,
+				 _("While reading creation time on %s"),
+				 name);
+			return;
+		}
+		tm = localtime (&crtime.tv_sec);
+		p = strftime (str, 1024, "%Y-%m-%d %H:%M:%S", tm);
+		p += sprintf (str+p, ".%ld", crtime.tv_nsec);
+		strftime (str+p, 1024-p, " %z", tm);
+		printf ("%s ", str);
+	}
 	if (generation_opt) {
 		if (fgetversion (name, &generation) == -1) {
 			com_err (program_name, errno,
@@ -164,7 +183,7 @@ int main (int argc, char ** argv)
 #endif
 	if (argc && *argv)
 		program_name = *argv;
-	while ((c = getopt (argc, argv, "RVadlv")) != EOF)
+	while ((c = getopt (argc, argv, "RVadlvc")) != EOF)
 		switch (c)
 		{
 			case 'R':
@@ -185,6 +204,9 @@ int main (int argc, char ** argv)
 			case 'v':
 				generation_opt = 1;
 				break;
+			case 'c':
+				crtime_opt = 1;
+				break;
 			default:
 				usage();
 		}
-- 
1.5.4.rc3
