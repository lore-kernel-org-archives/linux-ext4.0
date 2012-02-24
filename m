From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] libquota: don't include system quota.h header
Date: Fri, 24 Feb 2012 00:31:26 -0700
Message-ID: <1330068686-35788-1-git-send-email-adilger@whamcloud.com>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:26858 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab2BXHbX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Feb 2012 02:31:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't use the system <sys/quota.h> header in mkquota.c, since there
is a local e2fsprogs version of quota.h that has the desired quota
constants, and avoids symbol conflict on OSX.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 configure            |    2 +-
 configure.in         |    2 +-
 lib/blkid/getsize.c  |   13 ++++++-------
 lib/ext2fs/getsize.c |    2 +-
 lib/quota/mkquota.c  |    3 ---
 resize/main.c        |   12 ++----------
 6 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/configure b/configure
index 9f5eeb5..4b1939c 100755
--- a/configure
+++ b/configure
@@ -10251,7 +10251,7 @@ fi
 done
 
 fi
-for ac_header in dirent.h errno.h execinfo.h getopt.h malloc.h mntent.h paths.h semaphore.h setjmp.h signal.h stdarg.h stdint.h stdlib.h termios.h termio.h unistd.h utime.h linux/falloc.h linux/fd.h linux/major.h net/if_dl.h netinet/in.h sys/disklabel.h sys/file.h sys/ioctl.h sys/mkdev.h sys/mman.h sys/prctl.h sys/queue.h sys/quota.h sys/resource.h sys/select.h sys/socket.h sys/sockio.h sys/stat.h sys/syscall.h sys/sysmacros.h sys/time.h sys/types.h sys/un.h sys/wait.h
+for ac_header in dirent.h errno.h execinfo.h getopt.h malloc.h mntent.h paths.h semaphore.h setjmp.h signal.h stdarg.h stdint.h stdlib.h termios.h termio.h unistd.h utime.h linux/falloc.h linux/fd.h linux/major.h net/if_dl.h netinet/in.h sys/disklabel.h sys/file.h sys/ioctl.h sys/mkdev.h sys/mman.h sys/prctl.h sys/queue.h sys/resource.h sys/select.h sys/socket.h sys/sockio.h sys/stat.h sys/syscall.h sys/sysmacros.h sys/time.h sys/types.h sys/un.h sys/wait.h
 do :
   as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
 ac_fn_c_check_header_mongrel "$LINENO" "$ac_header" "$as_ac_Header" "$ac_includes_default"
diff --git a/configure.in b/configure.in
index c304a8d..9fb29cb 100644
--- a/configure.in
+++ b/configure.in
@@ -784,7 +784,7 @@ if test $cross_compiling = no; then
 else
   AC_CHECK_PROGS(BUILD_CC, gcc cc)
 fi
-AC_CHECK_HEADERS(dirent.h errno.h execinfo.h getopt.h malloc.h mntent.h paths.h semaphore.h setjmp.h signal.h stdarg.h stdint.h stdlib.h termios.h termio.h unistd.h utime.h linux/falloc.h linux/fd.h linux/major.h net/if_dl.h netinet/in.h sys/disklabel.h sys/file.h sys/ioctl.h sys/mkdev.h sys/mman.h sys/prctl.h sys/queue.h sys/quota.h sys/resource.h sys/select.h sys/socket.h sys/sockio.h sys/stat.h sys/syscall.h sys/sysmacros.h sys/time.h sys/types.h sys/un.h sys/wait.h)
+AC_CHECK_HEADERS(dirent.h errno.h execinfo.h getopt.h malloc.h mntent.h paths.h semaphore.h setjmp.h signal.h stdarg.h stdint.h stdlib.h termios.h termio.h unistd.h utime.h linux/falloc.h linux/fd.h linux/major.h net/if_dl.h netinet/in.h sys/disklabel.h sys/file.h sys/ioctl.h sys/mkdev.h sys/mman.h sys/prctl.h sys/queue.h sys/resource.h sys/select.h sys/socket.h sys/sockio.h sys/stat.h sys/syscall.h sys/sysmacros.h sys/time.h sys/types.h sys/un.h sys/wait.h)
 AC_CHECK_HEADERS(sys/disk.h sys/mount.h,,,
 [[
 #if HAVE_SYS_QUEUE_H
diff --git a/lib/blkid/getsize.c b/lib/blkid/getsize.c
index 77e68cf..f670e1b 100644
--- a/lib/blkid/getsize.c
+++ b/lib/blkid/getsize.c
@@ -77,7 +77,7 @@ blkid_loff_t blkid_get_dev_size(int fd)
 {
 	int valid_blkgetsize64 = 1;
 #ifdef __linux__
-	struct 		utsname ut;
+	struct		utsname ut;
 #endif
 	unsigned long long size64;
 	unsigned long size;
@@ -116,7 +116,7 @@ blkid_loff_t blkid_get_dev_size(int fd)
 			return 0; /* EFBIG */
 		return size64;
 	}
-#endif
+#endif /* BLKGETSIZE64 */
 
 #ifdef BLKGETSIZE
 	if (ioctl(fd, BLKGETSIZE, &size) >= 0)
@@ -143,8 +143,9 @@ blkid_loff_t blkid_get_dev_size(int fd)
 	 * Note that FreeBSD >= 4.0 has disk devices as unbuffered (raw,
 	 * character) devices, so we need to check for S_ISCHR, too.
 	 */
-	if ((fstat(fd, &st) >= 0) && (S_ISBLK(st.st_mode) || S_ISCHR(st.st_mode)))
+	if (fstat(fd, &st) >= 0 && (S_ISBLK(st.st_mode) || S_ISCHR(st.st_mode)))
 		part = st.st_rdev & 7;
+
 	if (part >= 0 && (ioctl(fd, DIOCGDINFO, (char *)&lab) >= 0)) {
 		pp = &lab.d_partitions[part];
 		if (pp->p_size)
@@ -152,7 +153,7 @@ blkid_loff_t blkid_get_dev_size(int fd)
 	}
 #endif /* HAVE_SYS_DISKLABEL_H */
 	{
-#ifdef HAVE_FSTAT64
+#if defined(HAVE_FSTAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
 		struct stat64   st;
 		if (fstat64(fd, &st) == 0)
 #else
@@ -163,7 +164,6 @@ blkid_loff_t blkid_get_dev_size(int fd)
 				return st.st_size;
 	}
 
-
 	/*
 	 * OK, we couldn't figure it out by using a specialized ioctl,
 	 * which is generally the best way.  So do binary search to
@@ -172,8 +172,7 @@ blkid_loff_t blkid_get_dev_size(int fd)
 	low = 0;
 	for (high = 1024; valid_offset(fd, high); high *= 2)
 		low = high;
-	while (low < high - 1)
-	{
+	while (low < high - 1) {
 		const blkid_loff_t mid = (low + high) / 2;
 
 		if (valid_offset(fd, mid))
diff --git a/lib/ext2fs/getsize.c b/lib/ext2fs/getsize.c
index 1e0ed16..0a7053e 100644
--- a/lib/ext2fs/getsize.c
+++ b/lib/ext2fs/getsize.c
@@ -183,7 +183,7 @@ errcode_t ext2fs_get_device_size2(const char *file, int blocksize,
 		*retblocks = size64 / blocksize;
 		goto out;
 	}
-#endif
+#endif /* BLKGETSIZE64 */
 
 #ifdef BLKGETSIZE
 	if (ioctl(fd, BLKGETSIZE, &size) >= 0) {
diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index ac7288c..fbfde92 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -6,9 +6,6 @@
 #include "config.h"
 #include <sys/types.h>
 #include <sys/stat.h>
-#ifdef HAVE_SYS_QUOTA_H
-#include <sys/quota.h>
-#endif
 #include <unistd.h>
 #include <errno.h>
 #include <string.h>
diff --git a/resize/main.c b/resize/main.c
index 1ab0e04..ffefe01 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -165,11 +165,7 @@ int main (int argc, char ** argv)
 	io_manager	io_ptr;
 	char		*new_size_str = 0;
 	int		use_stride = -1;
-#ifdef HAVE_FSTAT64
-	struct stat64	st_buf;
-#else
-	struct stat	st_buf;
-#endif
+	ext2fs_struct_stat st_buf;
 	__s64		new_file_size;
 	unsigned int	sys_page_size = 4096;
 	long		sysval;
@@ -265,11 +261,7 @@ int main (int argc, char ** argv)
 		exit(1);
 	}
 
-#ifdef HAVE_FSTAT64
-	ret = fstat64(fd, &st_buf);
-#else
-	ret = fstat(fd, &st_buf);
-#endif
+	ret = ext2fs_fstat(fd, &st_buf);
 	if (ret < 0) {
 		com_err("open", errno,
 			_("while getting stat information for %s"),
-- 
1.7.2

