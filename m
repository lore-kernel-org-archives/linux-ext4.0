From: Li Xi <pkuelelixi@gmail.com>
Subject: [v3 5/5] Add project ID support for chattr/lsattr
Date: Tue, 12 Jan 2016 17:56:48 +0900
Message-ID: <1452589008-18750-6-git-send-email-lixi@ddn.com>
References: <1452589008-18750-1-git-send-email-lixi@ddn.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org,
	dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:33869 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934529AbcALI5I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2016 03:57:08 -0500
Received: by mail-pf0-f177.google.com with SMTP id q63so61397773pfb.1
        for <linux-ext4@vger.kernel.org>; Tue, 12 Jan 2016 00:57:07 -0800 (PST)
In-Reply-To: <1452589008-18750-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Chattr and lsattr can be used to set or get project ID:
chattr -p <project id> file
lsattr -p file

Signed-off-by: Li Xi <lixi@ddn.com>
Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 lib/e2p/Makefile.in |   11 +++++++++--
 lib/e2p/e2p.h       |    2 ++
 misc/chattr.1.in    |    7 +++++++
 misc/chattr.c       |   33 +++++++++++++++++++++++++++++++--
 misc/lsattr.1.in    |    5 ++++-
 misc/lsattr.c       |   18 ++++++++++++++++--
 6 files changed, 69 insertions(+), 7 deletions(-)

diff --git a/lib/e2p/Makefile.in b/lib/e2p/Makefile.in
index ab036a6..2ab93f4 100644
--- a/lib/e2p/Makefile.in
+++ b/lib/e2p/Makefile.in
@@ -19,7 +19,7 @@ all::	e2p.pc
 OBJS=		feature.o fgetflags.o fsetflags.o fgetversion.o fsetversion.o \
 		getflags.o getversion.o hashstr.o iod.o ls.o mntopts.o \
 		parse_num.o pe.o pf.o ps.o setflags.o setversion.o uuid.o \
-		ostype.o percent.o crypto_mode.o
+		ostype.o percent.o crypto_mode.o fgetproject.o fsetproject.o
 
 SRCS=		$(srcdir)/feature.c $(srcdir)/fgetflags.c \
 		$(srcdir)/fsetflags.c $(srcdir)/fgetversion.c \
@@ -28,7 +28,8 @@ SRCS=		$(srcdir)/feature.c $(srcdir)/fgetflags.c \
 		$(srcdir)/ls.c $(srcdir)/mntopts.c $(srcdir)/parse_num.c \
 		$(srcdir)/pe.c $(srcdir)/pf.c $(srcdir)/ps.c \
 		$(srcdir)/setflags.c $(srcdir)/setversion.c $(srcdir)/uuid.c \
-		$(srcdir)/ostype.c $(srcdir)/percent.c $(srcdir)/crypto_mode.c
+		$(srcdir)/ostype.c $(srcdir)/percent.c $(srcdir)/crypto_modei.c \
+		$(srcdir)/fgetproject.c $(srcdir)/fsetproject.c
 HFILES= e2p.h
 
 LIBRARY= libe2p
@@ -137,6 +138,12 @@ fgetversion.o: $(srcdir)/fgetversion.c $(top_builddir)/lib/config.h \
 fsetversion.o: $(srcdir)/fsetversion.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2p.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h
+fsetproject.o: $(srcdir)/fsetproject.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2p.h $(srcdir)/project.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h
+fgetproject.o: $(srcdir)/fgetproject.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2p.h $(srcdir)/project.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h
 getflags.o: $(srcdir)/getflags.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2p.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h
diff --git a/lib/e2p/e2p.h b/lib/e2p/e2p.h
index 5fa41f4..66b83b4 100644
--- a/lib/e2p/e2p.h
+++ b/lib/e2p/e2p.h
@@ -32,6 +32,8 @@ int fgetflags (const char * name, unsigned long * flags);
 int fgetversion (const char * name, unsigned long * version);
 int fsetflags (const char * name, unsigned long flags);
 int fsetversion (const char * name, unsigned long version);
+int fgetproject(const char *name, unsigned long *project);
+int fsetproject(const char *name, unsigned long project);
 int getflags (int fd, unsigned long * flags);
 int getversion (int fd, unsigned long * version);
 int iterate_on_dir (const char * dir_name,
diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 1d6b057..9cd14b2 100644
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
+Set the file's project number.
 .SH ATTRIBUTES
 A file with the 'a' attribute set can only be open in append mode for writing.
 Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
diff --git a/misc/chattr.c b/misc/chattr.c
index 40069c9..982a593 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -64,6 +64,9 @@ static int set_version;
 
 static unsigned long version;
 
+static int set_project;
+static unsigned long project;
+
 static int recursive;
 static int verbose;
 static int silent;
@@ -83,7 +86,7 @@ static unsigned long sf;
 static void usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-RVf] [-+=aAcCdDeijPsStTu] [-v version] files...\n"),
+		_("Usage: %s [-pRVf] [-+=aAcCdDeijPsStTu] [-v version] files...\n"),
 		program_name);
 	exit(1);
 }
@@ -146,6 +149,20 @@ static int decode_arg (int * i, int argc, char ** argv)
 				silent = 1;
 				continue;
 			}
+			if (*p == 'p') {
+				(*i)++;
+				if (*i >= argc)
+					usage ();
+				project = strtol (argv[*i], &tmp, 0);
+				if (*tmp) {
+					com_err (program_name, 0,
+						 _("bad project - %s\n"),
+						 argv[*i]);
+					usage ();
+				}
+				set_project = 1;
+				continue;
+			}
 			if (*p == 'v') {
 				(*i)++;
 				if (*i >= argc)
@@ -249,6 +266,18 @@ static int change_attributes(const char * name)
 			return -1;
 		}
 	}
+	if (set_project) {
+		if (verbose)
+			printf (_("Project of %s set as %lu\n"), name, version);
+		if (fsetproject (name, project) == -1) {
+			if (!silent)
+				com_err (program_name, errno,
+					 _("while setting project on %s"),
+					 name);
+			return -1;
+		}
+
+	}
 	if (S_ISDIR(st.st_mode) && recursive)
 		return iterate_on_dir (name, chattr_dir_proc, NULL);
 	return 0;
@@ -312,7 +341,7 @@ int main (int argc, char ** argv)
 		fputs("Can't both set and unset same flag.\n", stderr);
 		exit (1);
 	}
-	if (!(add || rem || set || set_version)) {
+	if (!(add || rem || set || set_version || set_project )) {
 		fputs(_("Must use '-v', =, - or +\n"), stderr);
 		exit (1);
 	}
diff --git a/misc/lsattr.1.in b/misc/lsattr.1.in
index 7798a34..bc137f2 100644
--- a/misc/lsattr.1.in
+++ b/misc/lsattr.1.in
@@ -5,7 +5,7 @@ lsattr \- list file attributes on a Linux second extended file system
 .SH SYNOPSIS
 .B lsattr
 [
-.B \-RVadv
+.B \-RVadpv
 ]
 [
 .I files...
@@ -31,6 +31,9 @@ List directories like other files, rather than listing their contents.
 .TP
 .B \-v
 List the file's version/generation number.
+.TP
+.B \-p
+List the file's project number.
 .SH AUTHOR
 .B lsattr
 was written by Remy Card <Remy.Card@linux.org>.  It is currently being
diff --git a/misc/lsattr.c b/misc/lsattr.c
index f6b4384..786e95c 100644
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
+	fprintf(stderr, _("Usage: %s [-RVadlpv] [files...]\n"), program_name);
 	exit(1);
 }
 
@@ -79,12 +80,22 @@ static int list_attributes (const char * name)
 {
 	unsigned long flags;
 	unsigned long generation;
+	unsigned long project;
 
 	if (fgetflags (name, &flags) == -1) {
 		com_err (program_name, errno, _("While reading flags on %s"),
 			 name);
 		return -1;
 	}
+	if (project_opt) {
+		if (fgetproject(name, &project) == -1) {
+			com_err (program_name, errno,
+				 _("While reading project on %s"),
+				 name);
+			return -1;
+		}
+		printf ("%5lu ", project);
+	}
 	if (generation_opt) {
 		if (fgetversion (name, &generation) == -1) {
 			com_err (program_name, errno,
@@ -171,7 +182,7 @@ int main (int argc, char ** argv)
 #endif
 	if (argc && *argv)
 		program_name = *argv;
-	while ((c = getopt (argc, argv, "RVadlv")) != EOF)
+	while ((c = getopt (argc, argv, "RVadlvp")) != EOF)
 		switch (c)
 		{
 			case 'R':
@@ -192,6 +203,9 @@ int main (int argc, char ** argv)
 			case 'v':
 				generation_opt = 1;
 				break;
+			case 'p':
+				project_opt = 1;
+				break;
 			default:
 				usage();
 		}
-- 
1.7.1

