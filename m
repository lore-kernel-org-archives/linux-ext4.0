From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/5] subst: clean up various coverity nits
Date: Fri,  3 Jan 2014 00:29:58 -0500
Message-ID: <1388726998-14349-5-git-send-email-tytso@mit.edu>
References: <1388726998-14349-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45543 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbaACFaI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jan 2014 00:30:08 -0500
In-Reply-To: <1388726998-14349-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add appropriate error checking for all error returns, and only open
each file that we need to manipulate once, to avoid potential
time-of-check/time-of-use races.  (Not that this is likely for this
program, but the result is much more clean.)

We also preserve the atime in the case where the file has not changed.

Addresses-Coverty-Id: #709537
Addresses-Coverty-Id: #1049150
Addresses-Coverty-Id: #1049151

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 configure       | 12 +++++++-
 configure.in    |  3 +-
 lib/config.h.in |  6 ++++
 util/subst.c    | 93 +++++++++++++++++++++++++++++++++++++--------------------
 4 files changed, 80 insertions(+), 34 deletions(-)

diff --git a/configure b/configure
index 95ce324..6661265 100755
--- a/configure
+++ b/configure
@@ -10448,6 +10448,16 @@ $as_echo "#define HAVE_RECLEN_DIRENT 1" >>confdefs.h
 
 fi
 
+ac_fn_c_check_member "$LINENO" "struct stat" "st_atim" "ac_cv_member_struct_stat_st_atim" "$ac_includes_default"
+if test "x$ac_cv_member_struct_stat_st_atim" = xyes; then :
+
+cat >>confdefs.h <<_ACEOF
+#define HAVE_STRUCT_STAT_ST_ATIM 1
+_ACEOF
+
+
+fi
+
 ac_fn_c_check_type "$LINENO" "ssize_t" "ac_cv_type_ssize_t" "#include <sys/types.h>
 "
 if test "x$ac_cv_type_ssize_t" = xyes; then :
@@ -11427,7 +11437,7 @@ if test "$USE_INCLUDED_LIBINTL" = "yes" ; then
 fi
 
 if test $cross_compiling = no; then
-   BUILD_CFLAGS="$CFLAGS $CPPFLAGS"
+   BUILD_CFLAGS="$CFLAGS $CPPFLAGS $INCLUDES -DHAVE_CONFIG_H"
    BUILD_LDFLAGS="$LDFLAGS"
 else
    BUILD_CFLAGS=
diff --git a/configure.in b/configure.in
index 2b0087e..d6a3796 100644
--- a/configure.in
+++ b/configure.in
@@ -909,6 +909,7 @@ dnl is not decleared.
 AC_CHECK_MEMBER(struct dirent.d_reclen,[AC_DEFINE(HAVE_RECLEN_DIRENT, 1,
 		       [Define to 1 if dirent has d_reclen])],,
 		[#include <dirent.h>])
+AC_CHECK_MEMBERS([struct stat.st_atim])
 dnl Check to see if ssize_t was declared
 AC_CHECK_TYPE(ssize_t,[AC_DEFINE(HAVE_TYPE_SSIZE_T, 1,
 		[Define to 1 if ssize_t declared])],,
@@ -1281,7 +1282,7 @@ dnl
 dnl Build CFLAGS
 dnl
 if test $cross_compiling = no; then
-   BUILD_CFLAGS="$CFLAGS $CPPFLAGS"
+   BUILD_CFLAGS="$CFLAGS $CPPFLAGS $INCLUDES -DHAVE_CONFIG_H"
    BUILD_LDFLAGS="$LDFLAGS"
 else
    BUILD_CFLAGS=
diff --git a/lib/config.h.in b/lib/config.h.in
index 284eb33..ada69ed 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -284,6 +284,9 @@
 /* Define to 1 if you have the `posix_fadvise' function. */
 #undef HAVE_POSIX_FADVISE
 
+/* Define to 1 if you have the `posix_fadvise64' function. */
+#undef HAVE_POSIX_FADVISE64
+
 /* Define to 1 if you have the `posix_memalign' function. */
 #undef HAVE_POSIX_MEMALIGN
 
@@ -384,6 +387,9 @@
 /* Define to 1 if you have the `strtoull' function. */
 #undef HAVE_STRTOULL
 
+/* Define to 1 if `st_atim' is a member of `struct stat'. */
+#undef HAVE_STRUCT_STAT_ST_ATIM
+
 /* Define to 1 if you have the `sync_file_range' function. */
 #undef HAVE_SYNC_FILE_RANGE
 
diff --git a/util/subst.c b/util/subst.c
index 20dd6f2..f2e2424 100644
--- a/util/subst.c
+++ b/util/subst.c
@@ -5,6 +5,9 @@
  *
  */
 
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif
 #include <stdio.h>
 #include <errno.h>
 #include <stdlib.h>
@@ -13,6 +16,7 @@
 #include <ctype.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <fcntl.h>
 #include <time.h>
 #include <utime.h>
 
@@ -264,21 +268,11 @@ static void parse_config_file(FILE *f)
 /*
  * Return 0 if the files are different, 1 if the files are the same.
  */
-static int compare_file(const char *outfn, const char *newfn)
+static int compare_file(FILE *old_f, FILE *new_f)
 {
-	FILE	*old_f, *new_f;
 	char	oldbuf[2048], newbuf[2048], *oldcp, *newcp;
 	int	retval;
 
-	old_f = fopen(outfn, "r");
-	if (!old_f)
-		return 0;
-	new_f = fopen(newfn, "r");
-	if (!new_f) {
-		fclose(old_f);
-		return 0;
-	}
-
 	while (1) {
 		oldcp = fgets(oldbuf, sizeof(oldbuf), old_f);
 		newcp = fgets(newbuf, sizeof(newbuf), new_f);
@@ -291,8 +285,6 @@ static int compare_file(const char *outfn, const char *newfn)
 			break;
 		}
 	}
-	fclose(old_f);
-	fclose(new_f);
 	return retval;
 }
 
@@ -302,12 +294,14 @@ int main(int argc, char **argv)
 {
 	char	line[2048];
 	int	c;
-	FILE	*in, *out;
+	int	fd;
+	FILE	*in, *out, *old = NULL;
 	char	*outfn = NULL, *newfn = NULL;
 	int	verbose = 0;
 	int	adjust_timestamp = 0;
+	int	got_atime = 0;
 	struct stat stbuf;
-	struct utimbuf ut;
+	struct timeval tv[2];
 
 	while ((c = getopt (argc, argv, "f:tv")) != EOF) {
 		switch (c) {
@@ -351,11 +345,34 @@ int main(int argc, char **argv)
 		}
 		strcpy(newfn, outfn);
 		strcat(newfn, ".new");
-		out = fopen(newfn, "w");
-		if (!out) {
+		fd = open(newfn, O_CREAT|O_TRUNC|O_RDWR, 0444);
+		if (fd < 0) {
 			perror(newfn);
 			exit(1);
 		}
+		out = fdopen(fd, "w+");
+		if (!out) {
+			perror("fdopen");
+			exit(1);
+		}
+
+		fd = open(outfn, O_RDONLY);
+		if (fd > 0) {
+			/* save the original atime, if possible */
+			if (fstat(fd, &stbuf) == 0) {
+#if HAVE_STRUCT_STAT_ST_ATIM
+				tv[0].tv_sec = stbuf.st_atim.tv_sec;
+				tv[0].tv_usec = stbuf.st_atim.tv_nsec / 1000;
+#else
+				tv[0].tv_sec = stbuf.st_atime;
+				tv[0].tv_usec = 0;
+#endif
+				got_atime = 1;
+			}
+			old = fdopen(fd, "r");
+			if (!old)
+				close(fd);
+		}
 	} else {
 		out = stdout;
 		outfn = 0;
@@ -368,32 +385,44 @@ int main(int argc, char **argv)
 		fputs(line, out);
 	}
 	fclose(in);
-	fclose(out);
 	if (outfn) {
-		struct stat st;
-		if (compare_file(outfn, newfn)) {
+		fflush(out);
+		rewind(out);
+		if (old && compare_file(old, out)) {
 			if (verbose)
 				printf("No change, keeping %s.\n", outfn);
 			if (adjust_timestamp) {
-				if (stat(outfn, &stbuf) == 0) {
-					if (verbose)
-						printf("Updating modtime for %s\n", outfn);
-					ut.actime = stbuf.st_atime;
-					ut.modtime = time(0);
-					if (utime(outfn, &ut) < 0)
-						perror("utime");
+				if (verbose)
+					printf("Updating modtime for %s\n", outfn);
+				if (gettimeofday(&tv[1], NULL) < 0) {
+					perror("gettimeofday");
+					exit(1);
 				}
+				if (got_atime == 0)
+					tv[0] = tv[1];
+				else if (verbose)
+					printf("Using original atime\n");
+				if (futimes(fileno(old), tv) < 0)
+					perror("futimes");
 			}
-			unlink(newfn);
+			fclose(out);
+			if (unlink(newfn) < 0)
+				perror("unlink");
 		} else {
 			if (verbose)
 				printf("Creating or replacing %s.\n", outfn);
-			rename(newfn, outfn);
+			fclose(out);
+			if (old)
+				fclose(old);
+			old = NULL;
+			if (rename(newfn, outfn) < 0) {
+				perror("rename");
+				exit(1);
+			}
 		}
-		/* set read-only to alert user it is a generated file */
-		if (stat(outfn, &st) == 0)
-			chmod(outfn, st.st_mode & ~0222);
 	}
+	if (old)
+		fclose(old);
 	return (0);
 }
 
-- 
1.8.5.rc3.362.gdf10213

