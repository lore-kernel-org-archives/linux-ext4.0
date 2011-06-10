From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] misc: fix compile warnings on OSX
Date: Fri, 10 Jun 2011 00:59:24 -0600
Message-ID: <1307689164-11902-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:59355 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab1FJG70 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 02:59:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The BLKFLSBUF and FDFLUSH ioctls are Linux specific, and do not
really have anything to do with __GNUC__ (which is also used on
OS/X and Solaris).  Only print these warnings on Linux systems.

statfs64() is deprecated on OSX and generates a deliberate warning.
Fix some other warnings that show up on OSX builds.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 lib/e2p/fgetflags.c  |    8 ++++----
 lib/e2p/fsetflags.c  |   15 ++++++++-------
 lib/e2p/getflags.c   |    5 +++--
 lib/e2p/setflags.c   |    5 +++--
 lib/ext2fs/flushb.c  |   12 ++++--------
 lib/ext2fs/getsize.c |    2 +-
 6 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/lib/e2p/fgetflags.c b/lib/e2p/fgetflags.c
index d66f8e1..ca3ea16 100644
--- a/lib/e2p/fgetflags.c
+++ b/lib/e2p/fgetflags.c
@@ -63,7 +63,7 @@ int fgetflags (const char * name, unsigned long * flags)
 #endif
 
 	return 0;
-#else
+#else /* !HAVE_STAT_FLAGS || (APPLE_DARWIN && HAVE_EXT2_IOCTLS) */
 #if HAVE_EXT2_IOCTLS
 	int fd, r, f, save_errno = 0;
 
@@ -83,15 +83,15 @@ int fgetflags (const char * name, unsigned long * flags)
 	if (save_errno)
 		errno = save_errno;
 	return r;
-#else
+#else /* APPLE_DARWIN */
    f = -1;
    save_errno = syscall(SYS_fsctl, name, EXT2_IOC_GETFLAGS, &f, 0);
    *flags = f;
    return (save_errno);
-#endif
+#endif /* !APPLE_DARWIN */
+notsupp:
 #endif /* HAVE_EXT2_IOCTLS */
 #endif
-notsupp:
 	errno = EOPNOTSUPP;
 	return -1;
 }
diff --git a/lib/e2p/fsetflags.c b/lib/e2p/fsetflags.c
index 30437a2..08dd114 100644
--- a/lib/e2p/fsetflags.c
+++ b/lib/e2p/fsetflags.c
@@ -51,7 +51,6 @@
 
 int fsetflags (const char * name, unsigned long flags)
 {
-	struct stat buf;
 #if HAVE_CHFLAGS && !(APPLE_DARWIN && HAVE_EXT2_IOCTLS)
 	unsigned long bsd_flags = 0;
 
@@ -69,9 +68,10 @@ int fsetflags (const char * name, unsigned long flags)
 #endif
 
 	return chflags (name, bsd_flags);
-#else
+#else /* !HAVE_CHFLAGS || (APPLE_DARWIN && HAVE_EXT2_IOCTLS) */
 #if HAVE_EXT2_IOCTLS
 	int fd, r, f, save_errno = 0;
+	struct stat buf;
 
 	if (!lstat(name, &buf) &&
 	    !S_ISREG(buf.st_mode) && !S_ISDIR(buf.st_mode)) {
@@ -88,14 +88,15 @@ int fsetflags (const char * name, unsigned long flags)
 	close (fd);
 	if (save_errno)
 		errno = save_errno;
-#else
-   f = (int) flags;
-   return syscall(SYS_fsctl, name, EXT2_IOC_SETFLAGS, &f, 0);
-#endif
+#else /* APPLE_DARWIN */
+	f = (int) flags;
+	return syscall(SYS_fsctl, name, EXT2_IOC_SETFLAGS, &f, 0);
+#endif /* !APPLE_DARWIN */
 	return r;
+
+notsupp:
 #endif /* HAVE_EXT2_IOCTLS */
 #endif
-notsupp:
 	errno = EOPNOTSUPP;
 	return -1;
 }
diff --git a/lib/e2p/getflags.c b/lib/e2p/getflags.c
index a738fed..e871684 100644
--- a/lib/e2p/getflags.c
+++ b/lib/e2p/getflags.c
@@ -57,12 +57,13 @@ int getflags (int fd, unsigned long * flags)
 	if (!fstat(fd, &buf) &&
 	    !S_ISREG(buf.st_mode) && !S_ISDIR(buf.st_mode))
 		goto notsupp;
-	r = ioctl (fd, EXT2_IOC_GETFLAGS, &f);
+	r = ioctl(fd, EXT2_IOC_GETFLAGS, &f);
 	*flags = f;
+
 	return r;
+notsupp:
 #endif /* HAVE_EXT2_IOCTLS */
 #endif
-notsupp:
 	errno = EOPNOTSUPP;
 	return -1;
 }
diff --git a/lib/e2p/setflags.c b/lib/e2p/setflags.c
index cc00b20..72cf441 100644
--- a/lib/e2p/setflags.c
+++ b/lib/e2p/setflags.c
@@ -38,7 +38,6 @@
 
 int setflags (int fd, unsigned long flags)
 {
-	struct stat buf;
 #if HAVE_CHFLAGS
 	unsigned long bsd_flags = 0;
 
@@ -58,6 +57,7 @@ int setflags (int fd, unsigned long flags)
 	return fchflags (fd, bsd_flags);
 #else
 #if HAVE_EXT2_IOCTLS
+	struct stat buf;
 	int	f;
 
 	if (!fstat(fd, &buf) &&
@@ -66,7 +66,8 @@ int setflags (int fd, unsigned long flags)
 		return -1;
 	}
 	f = (int) flags;
-	return ioctl (fd, EXT2_IOC_SETFLAGS, &f);
+
+	return ioctl(fd, EXT2_IOC_SETFLAGS, &f);
 #endif /* HAVE_EXT2_IOCTLS */
 #endif
 	errno = EOPNOTSUPP;
diff --git a/lib/ext2fs/flushb.c b/lib/ext2fs/flushb.c
index 394bb07..ee0093a 100644
--- a/lib/ext2fs/flushb.c
+++ b/lib/ext2fs/flushb.c
@@ -65,17 +65,13 @@ errcode_t ext2fs_sync_device(int fd, int flushb)
 #ifdef BLKFLSBUF
 		if (ioctl (fd, BLKFLSBUF, 0) == 0)
 			return 0;
-#else
-#ifdef __GNUC__
- #warning BLKFLSBUF not defined
-#endif /* __GNUC__ */
+#elif defined(__linux__)
+#warning BLKFLSBUF not defined
 #endif
 #ifdef FDFLUSH
 		ioctl (fd, FDFLUSH, 0);   /* In case this is a floppy */
-#else
-#ifdef __GNUC__
- #warning FDFLUSH not defined
-#endif /* __GNUC__ */
+#elif defined(__linux__)
+#warning FDFLUSH not defined
 #endif
 	}
 	return 0;
diff --git a/lib/ext2fs/getsize.c b/lib/ext2fs/getsize.c
index 5ef0081..0c91b5b 100644
--- a/lib/ext2fs/getsize.c
+++ b/lib/ext2fs/getsize.c
@@ -235,7 +235,7 @@ errcode_t ext2fs_get_device_size2(const char *file, int blocksize,
 #endif /* HAVE_SYS_DISKLABEL_H */
 
 	{
-#ifdef HAVE_FSTAT64
+#if defined(HAVE_FSTAT64) && !defined(__OSX__)
 		struct stat64   st;
 		if (fstat64(fd, &st) == 0)
 #else
-- 
1.7.3.4

