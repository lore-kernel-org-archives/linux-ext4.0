From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: [PATCH] e4defrag: Fix segfault when /etc/mtab is empty
Date: Thu, 18 Oct 2012 12:06:14 +0530
Message-ID: <1350542174-11565-1-git-send-email-ashish.sangwan2@gmail.com>
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org,
	Ashish Sangwan <ashish.sangwan2@gmail.com>,
	Namjae Jeon <linkinjeon@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58643 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab2JRGgp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Oct 2012 02:36:45 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so7987884pad.19
        for <linux-ext4@vger.kernel.org>; Wed, 17 Oct 2012 23:36:45 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently, e4defrag will not work on machines where /etc/mtab is not present
OR is empty.
This patch does 2 things:
a) For obtaining mounted FS info, first we try to scan /proc/mounts,
if failed to access this file, try with /etc/mtab.
b) In function is_ext4, check if the varibale "mnt_type" is null before
calling strcmp, otherwise segfault would occur.

Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 misc/e4defrag.8.in |  6 +++++-
 misc/e4defrag.c    | 26 ++++++++++++++++----------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/misc/e4defrag.8.in b/misc/e4defrag.8.in
index 75e1bc9..a5401dc 100644
--- a/misc/e4defrag.8.in
+++ b/misc/e4defrag.8.in
@@ -31,7 +31,11 @@ reduces fragmentation of all files in it. If
 is a device,
 .B e4defrag
 gets the mount point of it and reduces fragmentation of all files in this mount
-point.
+point. Mount information is obtained by reading
+.B /proc/mounts.
+If this file is not accessible,  e4defrag will try to get required 
+information from
+.B /etc/mtab.
 .SH OPTIONS
 .TP
 .B \-c
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 4b31d03..285d594 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -123,6 +123,7 @@
 #define NGMSG_FILE_OPEN		"Failed to open"
 #define NGMSG_FILE_UNREG	"File is not regular file"
 #define NGMSG_LOST_FOUND	"Can not process \"lost+found\""
+#define _PATH_PROC_MOUNTS       "/proc/mounts"
 
 /* Data type for filesystem-wide blocks number */
 typedef unsigned long long ext4_fsblk_t;
@@ -262,10 +263,8 @@ static int fallocate64(int fd, int mode, loff_t offset, loff_t len)
  * @dir_path_len:	the length of directory.
  */
 static int get_mount_point(const char *devname, char *mount_point,
-							int dir_path_len)
+			   int dir_path_len, const char *mtab)
 {
-	/* Refer to /etc/mtab */
-	const char	*mtab = MOUNTED;
 	FILE		*fp = NULL;
 	struct mntent	*mnt = NULL;
 	struct stat64	sb;
@@ -278,7 +277,7 @@ static int get_mount_point(const char *devname, char *mount_point,
 
 	fp = setmntent(mtab, "r");
 	if (fp == NULL) {
-		perror("Couldn't access /etc/mtab");
+		printf("Couldn't access %s\n", mtab);
 		return -1;
 	}
 
@@ -313,14 +312,12 @@ static int get_mount_point(const char *devname, char *mount_point,
  *
  * @file:		the file's name.
  */
-static int is_ext4(const char *file, char *devname)
+static int is_ext4(const char *file, char *devname, const char *mtab)
 {
 	int 	maxlen = 0;
 	int	len, ret;
 	FILE	*fp = NULL;
 	char	*mnt_type = NULL;
-	/* Refer to /etc/mtab */
-	const char	*mtab = MOUNTED;
 	char	file_path[PATH_MAX + 1];
 	struct mntent	*mnt = NULL;
 	struct statfs64	fsbuf;
@@ -345,7 +342,7 @@ static int is_ext4(const char *file, char *devname)
 
 	fp = setmntent(mtab, "r");
 	if (fp == NULL) {
-		perror("Couldn't access /etc/mtab");
+		printf("Couldn't access %s", mtab);
 		return -1;
 	}
 
@@ -374,6 +371,10 @@ static int is_ext4(const char *file, char *devname)
 	}
 
 	endmntent(fp);
+	if (mnt_type == NULL) {
+		printf("Could not get mount information from %s\n", mtab);
+		return -1;
+	}
 	if (strcmp(mnt_type, FS_EXT4) == 0) {
 		FREE(mnt_type);
 		return 0;
@@ -1724,6 +1725,7 @@ int main(int argc, char *argv[])
 	int	success_flag = 0;
 	char	dir_name[PATH_MAX + 1];
 	char	dev_name[PATH_MAX + 1];
+	char *mtab = NULL;
 	struct stat64	buf;
 	ext2_filsys fs = NULL;
 
@@ -1743,6 +1745,10 @@ int main(int argc, char *argv[])
 			goto out;
 		}
 	}
+	if (access(_PATH_PROC_MOUNTS, R_OK) == 0)
+		mtab = _PATH_PROC_MOUNTS;
+	else
+		mtab = _PATH_MOUNTED;
 
 	if (argc == optind)
 		goto out;
@@ -1797,7 +1803,7 @@ int main(int argc, char *argv[])
 		if (S_ISBLK(buf.st_mode)) {
 			/* Block device */
 			strncpy(dev_name, argv[i], strnlen(argv[i], PATH_MAX));
-			if (get_mount_point(argv[i], dir_name, PATH_MAX) < 0)
+			if (get_mount_point(argv[i], dir_name, PATH_MAX, mtab) < 0)
 				continue;
 			if (lstat64(dir_name, &buf) < 0) {
 				perror(NGMSG_FILE_INFO);
@@ -1833,7 +1839,7 @@ int main(int argc, char *argv[])
 		 * filesystem type checked in get_mount_point()
 		 */
 		if (arg_type == FILENAME || arg_type == DIRNAME) {
-			if (is_ext4(argv[i], dev_name) < 0)
+			if (is_ext4(argv[i], dev_name, mtab) < 0)
 				continue;
 			if (realpath(argv[i], dir_name) == NULL) {
 				perror("Couldn't get full path");
-- 
1.7.11.4

