From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/2] mke2fs: clean up kernel version tests
Date: Wed, 18 Dec 2013 17:15:29 -0800
Message-ID: <20131219011529.16794.73664.stgit@birch.djwong.org>
References: <20131219011522.16794.68027.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50435 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab3LSBPg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Dec 2013 20:15:36 -0500
In-Reply-To: <20131219011522.16794.68027.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Refactor the running kernel version checks to hide the details of
version code checking, etc.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/mke2fs.c |   40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 4075099..0b32172 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -27,6 +27,7 @@
 #include <time.h>
 #ifdef __linux__
 #include <sys/utsname.h>
+#include <linux/version.h>
 #endif
 #ifdef HAVE_GETOPT_H
 #include <getopt.h>
@@ -109,7 +110,6 @@ char **fs_types;
 profile_t	profile;
 
 int sys_page_size = 4096;
-int linux_version_code = 0;
 
 static void usage(void)
 {
@@ -168,7 +168,28 @@ static int parse_version_number(const char *s)
 	rev = strtol(cp, &endptr, 10);
 	if (cp == endptr)
 		return 0;
-	return ((((major * 256) + minor) * 256) + rev);
+	return KERNEL_VERSION(major, minor, rev);
+}
+
+static int is_before_linux_ver(unsigned int major, unsigned int minor)
+{
+	struct		utsname ut;
+	int		linux_version_code = 0;
+
+	if (uname(&ut)) {
+		perror("uname");
+		exit(1);
+	}
+	linux_version_code = parse_version_number(ut.release);
+	if (linux_version_code == 0)
+		return 0;
+
+	return linux_version_code < KERNEL_VERSION(major, minor, 0);
+}
+#else
+static int is_before_linux_ver(unsigned int major, unsigned int minor)
+{
+	return 0;
 }
 #endif
 
@@ -1315,9 +1336,6 @@ static void PRS(int argc, char *argv[])
 	 * Finally, we complain about fs_blocks_count > 2^32 on a non-64bit fs.
 	 */
 	blk64_t		fs_blocks_count = 0;
-#ifdef __linux__
-	struct 		utsname ut;
-#endif
 	long		sysval;
 	int		s_opt = -1, r_opt = -1;
 	char		*fs_features = 0;
@@ -1383,15 +1401,8 @@ profile_error:
 	memset(&fs_param, 0, sizeof(struct ext2_super_block));
 	fs_param.s_rev_level = 1;  /* Create revision 1 filesystems now */
 
-#ifdef __linux__
-	if (uname(&ut)) {
-		perror("uname");
-		exit(1);
-	}
-	linux_version_code = parse_version_number(ut.release);
-	if (linux_version_code && linux_version_code < (2*65536 + 2*256))
+	if (is_before_linux_ver(2, 2))
 		fs_param.s_rev_level = 0;
-#endif
 
 	if (argc && *argv) {
 		program_name = get_progname(*argv);
@@ -1829,8 +1840,7 @@ profile_error:
 
 		if (use_bsize == -1) {
 			use_bsize = sys_page_size;
-			if ((linux_version_code < (2*65536 + 6*256)) &&
-			    (use_bsize > 4096))
+			if (is_before_linux_ver(2, 6) && use_bsize > 4096)
 				use_bsize = 4096;
 		}
 		if (lsector_size && use_bsize < lsector_size)

