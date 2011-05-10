From: Aditya Kali <adityakali@google.com>
Subject: [PATCH] mke2fs: Support floating point values in mke2fs.conf
Date: Tue, 10 May 2011 09:37:21 -0700
Message-ID: <1305045441-2411-1-git-send-email-adityakali@google.com>
Cc: linux-ext4@vger.kernel.org, Aditya Kali <adityakali@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:46802 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1EJQhk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 May 2011 12:37:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds profile_get_double function in profile.c that allows reading
floating point values from profile files. The floating point support is used
to read reserved_ratio (reserved for super user block percentage) from
mke2fs.conf.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 e2fsck/profile.c     |   37 +++++++++++++++++++++++++++++++++++++
 e2fsck/profile.h     |    5 +++++
 misc/mke2fs.c        |   26 +++++++++++++++++++++++++-
 tests/mke2fs.conf.in |    1 +
 4 files changed, 68 insertions(+), 1 deletions(-)

diff --git a/e2fsck/profile.c b/e2fsck/profile.c
index 5e9dc53..327bfb4 100644
--- a/e2fsck/profile.c
+++ b/e2fsck/profile.c
@@ -1596,6 +1596,43 @@ profile_get_uint(profile_t profile, const char *name, const char *subname,
 	return 0;
 }
 
+errcode_t
+profile_get_double(profile_t profile, const char *name, const char *subname,
+		   const char *subsubname, double def_val, double *ret_double)
+{
+	const char	*value;
+	errcode_t	  retval;
+	char        *end_value;
+	double      double_val;
+
+	*ret_double = def_val;
+	if (profile == 0)
+		return 0;
+
+	retval = profile_get_value(profile, name, subname, subsubname, &value);
+	if (retval == PROF_NO_SECTION || retval == PROF_NO_RELATION) {
+		*ret_double = def_val;
+		return 0;
+	} else if (retval)
+		return retval;
+
+	if (value[0] == 0)
+		/* Empty string is no good.  */
+		return PROF_BAD_INTEGER;
+	errno = 0;
+	double_val = strtod(value, &end_value);
+
+	/* Overflow or underflow.  */
+	if (errno != 0)
+		return PROF_BAD_INTEGER;
+	/* Garbage in string.  */
+	if (end_value != value + strlen(value))
+		return PROF_BAD_INTEGER;
+
+	*ret_double = double_val;
+	return 0;
+}
+
 static const char *const conf_yes[] = {
     "y", "yes", "true", "t", "1", "on",
     0,
diff --git a/e2fsck/profile.h b/e2fsck/profile.h
index 0c17732..4cc10eb 100644
--- a/e2fsck/profile.h
+++ b/e2fsck/profile.h
@@ -78,6 +78,11 @@ long profile_get_uint
 		const char *subsubname, unsigned int def_val,
 		unsigned int *ret_int);
 
+long profile_get_double
+	(profile_t profile, const char *name, const char *subname,
+		const char *subsubname, double def_val,
+		double *ret_float);
+
 long profile_get_boolean
 	(profile_t profile, const char *name, const char *subname,
 			const char *subsubname, int def_val,
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 23f8c10..313423b 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1072,6 +1072,18 @@ static int get_int_from_profile(char **fs_types, const char *opt, int def_val)
 	return ret;
 }
 
+static double get_double_from_profile(char **fs_types, const char *opt,
+				      double def_val)
+{
+	double ret;
+	char **cpp;
+
+	profile_get_double(profile, "defaults", opt, 0, def_val, &ret);
+	for (cpp = fs_types; *cpp; cpp++)
+		profile_get_double(profile, "fs_types", *cpp, opt, ret, &ret);
+	return ret;
+}
+
 static int get_bool_from_profile(char **fs_types, const char *opt, int def_val)
 {
 	int ret;
@@ -1144,7 +1156,7 @@ static void PRS(int argc, char *argv[])
 	int		inode_ratio = 0;
 	int		inode_size = 0;
 	unsigned long	flex_bg_size = 0;
-	double		reserved_ratio = 5.0;
+	double		reserved_ratio = -1.0;
 	int		lsector_size = 0, psector_size = 0;
 	int		show_version_only = 0;
 	unsigned long long num_inodes = 0; /* unsigned long long to catch too-large input */
@@ -1667,6 +1679,18 @@ profile_error:
 			EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 	}
 
+	/* Get reserved_ratio from profile if not specified on cmd line. */
+	if (reserved_ratio < 0.0) {
+		reserved_ratio = get_double_from_profile(
+					fs_types, "reserved_ratio", 5.0);
+		if (reserved_ratio > 50 || reserved_ratio < 0) {
+			com_err(program_name, 0,
+				_("invalid reserved blocks percent - %lf"),
+				reserved_ratio);
+			exit(1);
+		}
+	}
+
 	if (fs_param.s_feature_incompat &
 	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
 		reserved_ratio = 0;
diff --git a/tests/mke2fs.conf.in b/tests/mke2fs.conf.in
index 070d5d5..fbe2e2a 100644
--- a/tests/mke2fs.conf.in
+++ b/tests/mke2fs.conf.in
@@ -3,6 +3,7 @@
 	blocksize = 4096
 	inode_size = 256
 	inode_ratio = 16384
+	reserved_ratio = 5.0
 	enable_periodic_fsck = true
 	lazy_itable_init = false
 	default_mntopts = ^acl
-- 
1.7.3.1

