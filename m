From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] chattr: provide an exit code in case of failure and add -f flag
Date: Mon, 22 Oct 2007 09:30:07 -0400
Message-ID: <1193059807-7933-3-git-send-email-tytso@mit.edu>
References: <20071022125504.GB29220@thunk.org>
 <1193059807-7933-1-git-send-email-tytso@mit.edu>
 <1193059807-7933-2-git-send-email-tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53214 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbXJVNaT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Oct 2007 09:30:19 -0400
In-Reply-To: <1193059807-7933-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fix chattr so that if there are errors, it will report it via a
non-zero exit code.  It will now explicitly give errors when
attempting to set files that are not files or directories (which are
currently not supported under Linux).  The -f flag will suppress error
messages from being printed, although the exit status will still be
non-zero.

Addresses-Red-Hat-Bugzilla: #180596

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 misc/chattr.1.in |    7 ++--
 misc/chattr.c    |   83 +++++++++++++++++++++++++++++++----------------------
 2 files changed, 52 insertions(+), 38 deletions(-)

diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 2b48fb0..2334675 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -5,7 +5,7 @@ chattr \- change file attributes on a Linux second extended file system
 .SH SYNOPSIS
 .B chattr
 [
-.B \-RV
+.B \-RVf
 ]
 [
 .B \-v
@@ -34,12 +34,13 @@ synchronous updates (S), and top of directory hierarchy (T).
 .TP
 .B \-R
 Recursively change attributes of directories and their contents.
-Symbolic links encountered during recursive directory traversals are
-ignored.
 .TP
 .B \-V
 Be verbose with chattr's output and print the program version.
 .TP
+.B \-f
+Suppress most error messages.
+.TP
 .BI \-v " version"
 Set the file's version/generation number.
 .SH ATTRIBUTES
diff --git a/misc/chattr.c b/misc/chattr.c
index c6d8d9f..efaa559 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -65,6 +65,7 @@ static unsigned long version;
 
 static int recursive;
 static int verbose;
+static int silent;
 
 static unsigned long af;
 static unsigned long rf;
@@ -80,8 +81,8 @@ static unsigned long sf;
 
 static void usage(void)
 {
-	fprintf(stderr, 
-		_("Usage: %s [-RV] [-+=AacDdijsSu] [-v version] files...\n"),
+	fprintf(stderr,
+		_("Usage: %s [-RVf] [-+=AacDdijsSu] [-v version] files...\n"),
 		program_name);
 	exit(1);
 }
@@ -137,6 +138,10 @@ static int decode_arg (int * i, int argc, char ** argv)
 				verbose = 1;
 				continue;
 			}
+			if (*p == 'f') {
+				silent = 1;
+				continue;
+			}
 			if (*p == 'v') {
 				(*i)++;
 				if (*i >= argc)
@@ -144,7 +149,7 @@ static int decode_arg (int * i, int argc, char ** argv)
 				version = strtol (argv[*i], &tmp, 0);
 				if (*tmp) {
 					com_err (program_name, 0,
-						 _("bad version - %s\n"), 
+						 _("bad version - %s\n"),
 						 argv[*i]);
 					usage ();
 				}
@@ -182,26 +187,17 @@ static int decode_arg (int * i, int argc, char ** argv)
 
 static int chattr_dir_proc (const char *, struct dirent *, void *);
 
-static void change_attributes (const char * name)
+static int change_attributes (const char * name, int cmdline)
 {
 	unsigned long flags;
 	STRUCT_STAT	st;
 
 	if (LSTAT (name, &st) == -1) {
-		com_err (program_name, errno, _("while trying to stat %s"), 
-			 name);
-		return;
+		if (!silent)
+			com_err (program_name, errno,
+				 _("while trying to stat %s"), name);
+		return -1;
 	}
-	if (S_ISLNK(st.st_mode) && recursive)
-		return;
-
-	/* Don't try to open device files, fifos etc.  We probably
-           ought to display an error if the file was explicitly given
-           on the command line (whether or not recursive was
-           requested).  */
-	if (!S_ISREG(st.st_mode) && !S_ISLNK(st.st_mode) &&
-	    !S_ISDIR(st.st_mode))
-		return;
 
 	if (set) {
 		if (verbose) {
@@ -212,10 +208,12 @@ static void change_attributes (const char * name)
 		if (fsetflags (name, sf) == -1)
 			perror (name);
 	} else {
-		if (fgetflags (name, &flags) == -1)
-			com_err (program_name, errno,
-			         _("while reading flags on %s"), name);
-		else {
+		if (fgetflags (name, &flags) == -1) {
+			if (!silent)
+				com_err (program_name, errno,
+					 _("while reading flags on %s"), name);
+			return -1;
+		} else {
 			if (rem)
 				flags &= ~rf;
 			if (add)
@@ -227,25 +225,36 @@ static void change_attributes (const char * name)
 			}
 			if (!S_ISDIR(st.st_mode))
 				flags &= ~EXT2_DIRSYNC_FL;
-			if (fsetflags (name, flags) == -1)
-				com_err (program_name, errno,
-				         _("while setting flags on %s"), name);
+			if (fsetflags (name, flags) == -1) {
+				if (!silent)
+					com_err(program_name, errno,
+						_("while setting flags on %s"),
+						name);
+				return -1;
+			}
 		}
 	}
 	if (set_version) {
 		if (verbose)
 			printf (_("Version of %s set as %lu\n"), name, version);
-		if (fsetversion (name, version) == -1)
-			com_err (program_name, errno,
-			         _("while setting version on %s"), name);
+		if (fsetversion (name, version) == -1) {
+			if (!silent)
+				com_err (program_name, errno,
+					 _("while setting version on %s"),
+					 name);
+			return -1;
+		}
 	}
 	if (S_ISDIR(st.st_mode) && recursive)
-		iterate_on_dir (name, chattr_dir_proc, NULL);
+		return iterate_on_dir (name, chattr_dir_proc, NULL);
+	return 0;
 }
 
 static int chattr_dir_proc (const char * dir_name, struct dirent * de,
 			    void * private EXT2FS_ATTR((unused)))
 {
+	int ret = 0;
+
 	if (strcmp (de->d_name, ".") && strcmp (de->d_name, "..")) {
 	        char *path;
 
@@ -253,19 +262,20 @@ static int chattr_dir_proc (const char * dir_name, struct dirent * de,
 		if (!path) {
 			fprintf(stderr, _("Couldn't allocate path variable "
 					  "in chattr_dir_proc"));
-			exit(1);
+			return -1;
 		}
-		sprintf (path, "%s/%s", dir_name, de->d_name);
-		change_attributes (path);
+		sprintf(path, "%s/%s", dir_name, de->d_name);
+		ret = change_attributes(path, 0);
 		free(path);
 	}
-	return 0;
+	return ret;
 }
 
 int main (int argc, char ** argv)
 {
 	int i, j;
 	int end_arg = 0;
+	int err, retval = 0;
 
 #ifdef ENABLE_NLS
 	setlocale(LC_MESSAGES, "");
@@ -303,7 +313,10 @@ int main (int argc, char ** argv)
 	if (verbose)
 		fprintf (stderr, "chattr %s (%s)\n",
 			 E2FSPROGS_VERSION, E2FSPROGS_DATE);
-	for (j = i; j < argc; j++)
-		change_attributes (argv[j]);
-	exit(0);
+	for (j = i; j < argc; j++) {
+		err = change_attributes (argv[j], 1);
+		if (err)
+			retval = 1;
+	}
+	exit(retval);
 }
-- 
1.5.3.4.1232.g9991d-dirty
