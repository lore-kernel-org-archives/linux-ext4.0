From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 2/2 V3] mke2fs: disallow creating FS on a loop mounted file
 with no option
Date: Tue, 02 Jul 2013 17:35:39 +0900
Message-ID: <51D290DB.7@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:52164 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab3GBIpI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Jul 2013 04:45:08 -0400
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r628j6j0016979
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jul 2013 17:45:06 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When /etc/mtab is a symlink of /proc/mounts, mke2fs can create a filesystem
on the loop mounted file without -F option. In this case, we should specify
-F option twice.

How to reproduce:
  # mke2fs -t ext4 -Fq /mnt/mp1/fs.img
  # mount -o loop /mnt/mp1/fs.img /mnt/mp2
  # mke2fs -t ext4 -q /mnt/mp1/fs.img
  /mnt/mp1/fs.img is not a block special device.
  Proceed anyway? (y,n) y
  # echo $?
  0

Signed-off-by: Kazuya Mio <k-mio@sx.jp..nec.com>
---
 configure.in           |    2 ++
 lib/ext2fs/ismounted.c |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)
diff --git a/configure.in b/configure.in
index 8963d17..fe29aa3 100644
--- a/configure.in
+++ b/configure.in
@@ -912,6 +912,8 @@ AC_CHECK_HEADERS(m4_flatten([
 	linux/falloc.h
 	linux/fd.h
 	linux/major.h
+	linux/version.h
+	linux/loop.h
 	net/if_dl.h
 	netinet/in.h
 	sys/disklabel.h
diff --git a/lib/ext2fs/ismounted.c b/lib/ext2fs/ismounted.c
index 6a223df..499b4c0 100644
--- a/lib/ext2fs/ismounted.c
+++ b/lib/ext2fs/ismounted.c
@@ -21,6 +21,14 @@
 #ifdef HAVE_LINUX_FD_H
 #include <linux/fd.h>
 #endif
+#ifdef HAVE_LINUX_VERSION_H
+#include <linux/version.h>
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 0) /* kernel >= 2.6 */
+#ifdef HAVE_LINUX_LOOP_H
+#include <linux/loop.h>
+#endif /* HAVE_LINUX_LOOP_H */
+#endif /* kernel >= 2.6 */
+#endif /* HAVE_LINUX_VERSION_H */
 #ifdef HAVE_MNTENT_H
 #include <mntent.h>
 #endif
@@ -31,6 +39,7 @@
 #endif /* HAVE_GETMNTINFO */
 #include <string.h>
 #include <sys/stat.h>
+#include <sys/ioctl.h>
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
@@ -51,6 +60,11 @@ static errcode_t check_mntent_file(const char *mtab_file, const char *file,
 	ino_t		file_ino=0;
 	FILE 		*f;
 	int		fd;
+#if defined(HAVE_LINUX_LOOP_H) && defined(LOOP_GET_STATUS64)
+	int		result = 0;
+	struct loop_info64 lo_info;
+	memset(&lo_info, 0, sizeof(struct loop_info64));
+#endif /* defined(HAVE_LINUX_LOOP_H) && defined(LOOP_GET_STATUS64) */
 
 	*mount_flags = 0;
 	if ((f = setmntent (mtab_file, "r")) == NULL)
@@ -70,6 +84,30 @@ static errcode_t check_mntent_file(const char *mtab_file, const char *file,
 			continue;
 		if (strcmp(file, mnt->mnt_fsname) == 0)
 			break;
+#if defined(HAVE_LINUX_LOOP_H) && defined(LOOP_GET_STATUS64)
+		/*
+		 * Check to see if a regular file is mounted.
+		 * If /etc/mtab/ is a symlink of /proc/mounts, you will need
+		 * the following check because the name in /proc/mounts
+		 * is a loopback device not a regular file.
+		 */
+		if (strncmp(mnt->mnt_fsname, "/dev/loop", 9) == 0) {
+			fd = open(mnt->mnt_fsname, O_RDONLY);
+			if (fd < 0) {
+				retval = errno;
+				goto errout;
+			}
+			result = ioctl(fd, LOOP_GET_STATUS64, &lo_info);
+			close(fd);
+			if (result < 0) {
+				retval = errno;
+				goto errout;
+			}
+			if (file_dev == lo_info.lo_device &&
+				file_ino == lo_info.lo_inode)
+				break;
+		}
+#endif /* defined(HAVE_LINUX_LOOP_H) && defined(LOOP_GET_STATUS64) */
 		if (stat(mnt->mnt_fsname, &st_buf) == 0) {
 			if (S_ISBLK(st_buf.st_mode)) {
 #ifndef __GNU__
