From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC v1 4/4] e2fsprogs: add project id into lsattr and chattr
Date: Fri, 13 Mar 2015 19:00:11 +0300
Message-ID: <20150313160011.14281.31752.stgit@buzz>
References: <20150313155012.14281.80292.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Li Xi <pkuelelixi@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:44491 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755866AbbCMQAP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Mar 2015 12:00:15 -0400
In-Reply-To: <20150313155012.14281.80292.stgit@buzz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Kernel will provide generic vfs ioctls for project id: FS_IOC_GET/SETPROJECT.
This patch adds option '-p' to lsattr and chattr for getting/setting project id.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 lib/e2p/Makefile.in  |    5 +++--
 lib/e2p/e2p.h        |    2 ++
 lib/e2p/project.c    |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_fs.h |    5 +++++
 misc/chattr.1.in     |    7 ++++++
 misc/chattr.c        |   34 ++++++++++++++++++++++++++++---
 misc/lsattr.1.in     |    5 ++++-
 misc/lsattr.c        |   19 +++++++++++++++--
 8 files changed, 124 insertions(+), 8 deletions(-)
 create mode 100644 lib/e2p/project.c

diff --git a/lib/e2p/Makefile.in b/lib/e2p/Makefile.in
index e9a635143184..2b7a5e0bb2c5 100644
--- a/lib/e2p/Makefile.in
+++ b/lib/e2p/Makefile.in
@@ -19,7 +19,7 @@ all::	e2p.pc
 OBJS=		feature.o fgetflags.o fsetflags.o fgetversion.o fsetversion.o \
 		getflags.o getversion.o hashstr.o iod.o ls.o mntopts.o \
 		parse_num.o pe.o pf.o ps.o setflags.o setversion.o uuid.o \
-		ostype.o percent.o crypto_mode.o
+		ostype.o percent.o crypto_mode.o project.o
 
 SRCS=		$(srcdir)/feature.c $(srcdir)/fgetflags.c \
 		$(srcdir)/fsetflags.c $(srcdir)/fgetversion.c \
@@ -28,7 +28,8 @@ SRCS=		$(srcdir)/feature.c $(srcdir)/fgetflags.c \
 		$(srcdir)/ls.c $(srcdir)/mntopts.c $(srcdir)/parse_num.c \
 		$(srcdir)/pe.c $(srcdir)/pf.c $(srcdir)/ps.c \
 		$(srcdir)/setflags.c $(srcdir)/setversion.c $(srcdir)/uuid.c \
-		$(srcdir)/ostype.c $(srcdir)/percent.c $(srcdir)/crypto_mode.c
+		$(srcdir)/ostype.c $(srcdir)/percent.c $(srcdir)/crypto_mode.c \
+		$(srcdir)/project.c
 HFILES= e2p.h
 
 LIBRARY= libe2p
diff --git a/lib/e2p/e2p.h b/lib/e2p/e2p.h
index 5fa41f46c627..fda72c6adcea 100644
--- a/lib/e2p/e2p.h
+++ b/lib/e2p/e2p.h
@@ -44,6 +44,8 @@ void print_flags (FILE * f, unsigned long flags, unsigned options);
 void print_fs_state (FILE * f, unsigned short state);
 int setflags (int fd, unsigned long flags);
 int setversion (int fd, unsigned long version);
+int fgetproject(const char *name, unsigned *project);
+int fsetproject(const char *name, unsigned project);
 
 const char *e2p_feature2string(int compat, unsigned int mask);
 const char *e2p_jrnl_feature2string(int compat, unsigned int mask);
diff --git a/lib/e2p/project.c b/lib/e2p/project.c
new file mode 100644
index 000000000000..6f9cc0d5d2ee
--- /dev/null
+++ b/lib/e2p/project.c
@@ -0,0 +1,55 @@
+#define _LARGEFILE_SOURCE
+
+#include "config.h"
+#if HAVE_ERRNO_H
+#include <errno.h>
+#endif
+#if HAVE_UNISTD_H
+#include <unistd.h>
+#endif
+#include <fcntl.h>
+#include <sys/ioctl.h>
+
+#include "e2p.h"
+
+int fgetproject(const char *name, unsigned *project)
+{
+#if HAVE_EXT2_IOCTLS
+	int fd, ret, save_errno = 0;
+
+	fd = open(name, O_RDONLY | O_NONBLOCK | O_NOCTTY);
+	if (fd < 0)
+		return -1;
+	ret = ioctl(fd, FS_IOC_GETPROJECT, project);
+	if (ret < 0)
+		save_errno = errno;
+	close(fd);
+	if (ret < 0)
+		errno = save_errno;
+	return ret;
+#else /* ! HAVE_EXT2_IOCTLS */
+	errno = EOPNOTSUPP;
+	return -1;
+#endif /* ! HAVE_EXT2_IOCTLS */
+}
+
+int fsetproject(const char *name, unsigned project)
+{
+#if HAVE_EXT2_IOCTLS
+	int fd, ret, save_errno = 0;
+
+	fd = open(name, O_RDONLY | O_NONBLOCK | O_NOCTTY);
+	if (fd < 0)
+		return -1;
+	ret = ioctl(fd, FS_IOC_SETPROJECT, &project);
+	if (ret < 0)
+		save_errno = errno;
+	close(fd);
+	if (ret < 0)
+		errno = save_errno;
+	return ret;
+#else /* ! HAVE_EXT2_IOCTLS */
+	errno = EOPNOTSUPP;
+	return -1;
+#endif /* ! HAVE_EXT2_IOCTLS */
+}
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 77cde1bc009f..8ee9566c460b 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -376,6 +376,11 @@ struct ext4_new_group_input {
 #define EXT4_IOC_GROUP_ADD		_IOW('f', 8,struct ext4_new_group_input)
 #define EXT4_IOC_RESIZE_FS		_IOW('f', 16, __u64)
 
+#ifndef FS_IOC_GETPROJECT
+#define FS_IOC_GETPROJECT		_IOR('f', 20, unsigned)
+#define FS_IOC_SETPROJECT		_IOW('f', 21, unsigned)
+#endif
+
 /*
  * Structure of an inode on the disk
  */
diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 33ef9a20f591..abe0aa496e62 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -12,6 +12,10 @@ chattr \- change file attributes on a Linux file system
 .I version
 ]
 [
+.B \-p
+.I project
+]
+[
 .I mode
 ]
 .I files...
@@ -71,6 +75,9 @@ Suppress most error messages.
 .TP
 .BI \-v " version"
 Set the file's version/generation number.
+.TP
+.BI \-p " project"
+Set the file's project id.
 .SH ATTRIBUTES
 A file with the 'a' attribute set can only be open in append mode for writing.
 Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
diff --git a/misc/chattr.c b/misc/chattr.c
index f130108c7ec0..ea0ad2e7bd43 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -64,6 +64,9 @@ static int set_version;
 
 static unsigned long version;
 
+static int set_project;
+static unsigned project;
+
 static int recursive;
 static int verbose;
 static int silent;
@@ -83,7 +86,7 @@ static unsigned long sf;
 static void usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-RVf] [-+=aAcCdDeijsStTu] [-v version] files...\n"),
+		_("Usage: %s [-RVf] [-+=aAcCdDeijsStTu] [-v version] [-p project] files...\n"),
 		program_name);
 	exit(1);
 }
@@ -159,6 +162,20 @@ static int decode_arg (int * i, int argc, char ** argv)
 				set_version = 1;
 				continue;
 			}
+			if (*p == 'p') {
+				(*i)++;
+				if (*i >= argc)
+					usage();
+				project = strtoul(argv[*i], &tmp, 0);
+				if (*tmp) {
+					com_err (program_name, 0,
+						 _("bad project - %s\n"),
+						 argv[*i]);
+					usage();
+				}
+				set_project = 1;
+				continue;
+			}
 			if ((fl = get_flag(*p)) == 0)
 				usage();
 			rf |= fl;
@@ -248,6 +265,17 @@ static int change_attributes(const char * name)
 			return -1;
 		}
 	}
+	if (set_project) {
+		if (verbose)
+			printf(_("Project of %s set as %u\n"), name, project);
+		if (fsetproject(name, project) == -1) {
+			if (!silent)
+				com_err(program_name, errno,
+					_("while setting project on %s"),
+					name);
+			return -1;
+		}
+	}
 	if (S_ISDIR(st.st_mode) && recursive)
 		return iterate_on_dir (name, chattr_dir_proc, NULL);
 	return 0;
@@ -311,8 +339,8 @@ int main (int argc, char ** argv)
 		fputs("Can't both set and unset same flag.\n", stderr);
 		exit (1);
 	}
-	if (!(add || rem || set || set_version)) {
-		fputs(_("Must use '-v', =, - or +\n"), stderr);
+	if (!(add || rem || set || set_version || set_project)) {
+		fputs(_("Must use '-v', '-p', =, - or +\n"), stderr);
 		exit (1);
 	}
 	if (verbose)
diff --git a/misc/lsattr.1.in b/misc/lsattr.1.in
index 7798a3444af2..775628b93134 100644
--- a/misc/lsattr.1.in
+++ b/misc/lsattr.1.in
@@ -5,7 +5,7 @@ lsattr \- list file attributes on a Linux second extended file system
 .SH SYNOPSIS
 .B lsattr
 [
-.B \-RVadv
+.B \-RVadvp
 ]
 [
 .I files...
@@ -31,6 +31,9 @@ List directories like other files, rather than listing their contents.
 .TP
 .B \-v
 List the file's version/generation number.
+.TP
+.B \-p
+List the file's project id.
 .SH AUTHOR
 .B lsattr
 was written by Remy Card <Remy.Card@linux.org>.  It is currently being
diff --git a/misc/lsattr.c b/misc/lsattr.c
index e5e59690f493..81b4e9065a56 100644
--- a/misc/lsattr.c
+++ b/misc/lsattr.c
@@ -60,6 +60,7 @@ static unsigned pf_options;
 static int recursive;
 static int verbose;
 static int generation_opt;
+static int project_opt;
 
 #ifdef _LFS64_LARGEFILE
 #define LSTAT		lstat64
@@ -71,7 +72,7 @@ static int generation_opt;
 
 static void usage(void)
 {
-	fprintf(stderr, _("Usage: %s [-RVadlv] [files...]\n"), program_name);
+	fprintf(stderr, _("Usage: %s [-RVadlvp] [files...]\n"), program_name);
 	exit(1);
 }
 
@@ -94,6 +95,17 @@ static int list_attributes (const char * name)
 		}
 		printf ("%5lu ", generation);
 	}
+	if (project_opt) {
+		unsigned project;
+
+		if (fgetproject(name, &project) == -1) {
+			com_err (program_name, errno,
+				 _("While reading project on %s"),
+				 name);
+			return -1;
+		}
+		printf ("%5u ", project);
+	}
 	if (pf_options & PFOPT_LONG) {
 		printf("%-28s ", name);
 		print_flags(stdout, flags, pf_options);
@@ -171,7 +183,7 @@ int main (int argc, char ** argv)
 #endif
 	if (argc && *argv)
 		program_name = *argv;
-	while ((c = getopt (argc, argv, "RVadlv")) != EOF)
+	while ((c = getopt (argc, argv, "RVadlvp")) != EOF)
 		switch (c)
 		{
 			case 'R':
@@ -192,6 +204,9 @@ int main (int argc, char ** argv)
 			case 'v':
 				generation_opt = 1;
 				break;
+			case 'p':
+				project_opt = 1;
+				break;
 			default:
 				usage();
 		}

