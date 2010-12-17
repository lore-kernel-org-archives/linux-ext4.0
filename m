From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: [PATCH] allow e4defrag build against old kernel headers
Date: Fri, 17 Dec 2010 12:50:09 -0700
Message-ID: <1292615409-26697-2-git-send-email-adilger.kernel@dilger.ca>
References: <1292615409-26697-1-git-send-email-adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:50369 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab0LQTuL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Dec 2010 14:50:11 -0500
In-Reply-To: <1292615409-26697-1-git-send-email-adilger.kernel@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Building e2fsprogs with older userspace with old kernel headers may
not define the __NR_fallocate and __NR_sync_file_range system calls,
even if a newer kernel is installed on the system.

Avoid e4defrag build failures for e2fsprogs on older systems, but may
result in the e4defrag command failing at runtime due to the actual
lack of these system calls, as opposed to just old kernel headers
on a system running a new kernel.
---
 misc/e4defrag.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 82e3868..d739da2 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -304,12 +304,6 @@ static int posix_fadvise(int fd, loff_t offset, size_t len, int advise)
 #ifndef HAVE_SYNC_FILE_RANGE
 #warning Using locally defined sync_file_range interface.
 
-#ifndef __NR_sync_file_range
-#ifndef __NR_sync_file_range2 /* ppc */
-#error Your kernel headers dont define __NR_sync_file_range
-#endif
-#endif
-
 /*
  * sync_file_range() -	Sync file region.
  *
@@ -322,8 +316,19 @@ int sync_file_range(int fd, loff_t offset, loff_t length, unsigned int flag)
 {
 #ifdef __NR_sync_file_range
 	return syscall(__NR_sync_file_range, fd, offset, length, flag);
-#else
+#elif defined(__NR_sync_file_range2)
 	return syscall(__NR_sync_file_range2, fd, flag, offset, length);
+#else
+	return fsync(fd);
+#ifndef SYNC_FILE_RANGE_WAIT_BEFORE
+#define SYNC_FILE_RANGE_WAIT_BEFORE 0
+#endif
+#ifndef SYNC_FILE_RANGE_WRITE
+#define SYNC_FILE_RANGE_WRITE 0
+#endif
+#ifndef SYNC_FILE_RANGE_WAIT_AFTER
+#define SYNC_FILE_RANGE_WAIT_AFTER 0
+#endif
 #endif
 }
 #endif /* ! HAVE_SYNC_FILE_RANGE */
@@ -332,7 +337,17 @@ int sync_file_range(int fd, loff_t offset, loff_t length, unsigned int flag)
 #warning Using locally defined fallocate syscall interface.
 
 #ifndef __NR_fallocate
-#error Your kernel headers dont define __NR_fallocate
+# if defined(__x86_64__)
+#  define __NR_fallocate 285
+# elif defined(__i386__)
+#  define __NR_fallocate 324
+# elif defined(__powerpc__)
+#  define __NR_fallocate 309
+# else
+/* fallback position might be posix_fallocate(), but I suspect any kernel
+ * that doesn't have fallocate will also not have EXT4_IOC_MOVE_EXT */
+#  error Your kernel headers dont define __NR_fallocate
+# endif
 #endif
 
 /*
-- 
1.4.4.2

