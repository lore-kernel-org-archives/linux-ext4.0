From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] build: fix compile warnings on OSX
Date: Fri, 24 Feb 2012 00:48:57 -0700
Message-ID: <1330069737-36009-1-git-send-email-adilger@whamcloud.com>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:60593 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab2BXHs6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Feb 2012 02:48:58 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Clean up some compile warnings related to fstat64(), which is
verbosely deprecated on OSX.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 lib/blkid/getsize.c  |   13 ++++++-------
 lib/ext2fs/getsize.c |    2 +-
 resize/main.c        |   12 ++----------
 3 files changed, 9 insertions(+), 18 deletions(-)

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

