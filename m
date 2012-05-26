From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] ext2fs: remove 64-bit wrappers from ext2fs.h (v2)
Date: Fri, 25 May 2012 18:23:21 -0600
Message-ID: <1337991801-29500-1-git-send-email-adilger@whamcloud.com>
References: <1337984034-14756-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:32044 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab2EZAXX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 May 2012 20:23:23 -0400
In-Reply-To: <1337984034-14756-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The creation of inline wrappers ext2fs_open() and ext2fs_stat()
in commit c859cb1de0d624caa0779fb17d1a53766143136e in ext2fs.h
caused difficulties with the use of headers, since the headers
for open64() and stat64() may already be included (and skip the
declaration of the 64-bit variants) before ext2fs.h is ever read.
There is no real way to solve the missing prototypes and resulting
compiler warnings inside ext2fs.h.

Since ext2fs_open() and ext2fs_stat() are not performance critical
operations, they do not need to be inline functions at all, and
the needed function headers can be handled properly in one file.

Similarly, posix_memalloc() was having difficulties with headers,
and was being defined in ext2fs.h, but it is now only being used
by a single file, so move the required header there.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 e2fsck/logfile.c     |    3 +++
 lib/ext2fs/ext2fs.h  |   46 ----------------------------------------------
 lib/ext2fs/inline.c  |    3 +++
 lib/ext2fs/unix_io.c |   32 ++++++++++++++++++++++++++++++++
 4 files changed, 38 insertions(+), 46 deletions(-)

diff --git a/e2fsck/logfile.c b/e2fsck/logfile.c
index 3bb15cd..9229fbf 100644
--- a/e2fsck/logfile.c
+++ b/e2fsck/logfile.c
@@ -13,6 +13,9 @@
 #ifdef HAVE_ERRNO_H
 #include <errno.h>
 #endif
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
 
 #include "e2fsck.h"
 #include <pwd.h>
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 9a0e736..ff088bb 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -29,10 +29,6 @@ extern "C" {
 #define NO_INLINE_FUNCS
 #endif
 
-#ifndef _XOPEN_SOURCE
-#define _XOPEN_SOURCE 600	/* for posix_memalign() */
-#endif
-
 /*
  * Where the master copy of the superblock is located, and how big
  * superblocks are supposed to be.  We define SUPERBLOCK_SIZE because
@@ -57,16 +53,6 @@ extern "C" {
 #include <stdlib.h>
 #include <string.h>
 #include <errno.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-
-#ifndef __USE_XOPEN2K
-/* If the "#define _XOPEN_SOURCE 600" didn't succeed in declaring
- * posix_memalign(), maybe due to <features.h> or <stdlib.h> included beforej
- * _XOPEN_SOURCE, declare it here to avoid compiler warnings. */
-extern int posix_memalign(void **__memptr, size_t __alignment, size_t __size);
-#endif
 
 #if EXT2_FLAT_INCLUDES
 #include "e2_types.h"
@@ -1709,38 +1695,6 @@ _INLINE_ __u64 ext2fs_div64_ceil(__u64 a, __u64 b)
 	return ((a - 1) / b) + 1;
 }
 
-_INLINE_ int ext2fs_open_file(const char *pathname, int flags, mode_t mode)
-{
-	if (mode)
-#if defined(HAVE_OPEN64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
-		return open64(pathname, flags, mode);
-	else
-		return open64(pathname, flags);
-#else
-		return open(pathname, flags, mode);
-	else
-		return open(pathname, flags);
-#endif
-}
-
-_INLINE_ int ext2fs_stat(const char *path, ext2fs_struct_stat *buf)
-{
-#if defined(HAVE_FSTAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
-	return stat64(path, buf);
-#else
-	return stat(path, buf);
-#endif
-}
-
-_INLINE_ int ext2fs_fstat(int fd, ext2fs_struct_stat *buf)
-{
-#if defined(HAVE_FSTAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
-	return fstat64(fd, buf);
-#else
-	return fstat(fd, buf);
-#endif
-}
-
 #undef _INLINE_
 #endif
 
diff --git a/lib/ext2fs/inline.c b/lib/ext2fs/inline.c
index 8e66846..eef3dda 100644
--- a/lib/ext2fs/inline.c
+++ b/lib/ext2fs/inline.c
@@ -11,6 +11,9 @@
  * %End-Header%
  */
 
+#ifndef _XOPEN_SOURCE
+#define _XOPEN_SOURCE 600	/* for posix_memalign() */
+#endif
 
 #include "config.h"
 #include <stdio.h>
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index e66b5c8..02570f0 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -435,6 +435,38 @@ static errcode_t flush_cached_blocks(io_channel channel,
 #endif
 #endif
 
+int ext2fs_open_file(const char *pathname, int flags, mode_t mode)
+{
+	if (mode)
+#if defined(HAVE_OPEN64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
+		return open64(pathname, flags, mode);
+	else
+		return open64(pathname, flags);
+#else
+		return open(pathname, flags, mode);
+	else
+		return open(pathname, flags);
+#endif
+}
+
+int ext2fs_stat(const char *path, ext2fs_struct_stat *buf)
+{
+#if defined(HAVE_FSTAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
+	return stat64(path, buf);
+#else
+	return stat(path, buf);
+#endif
+}
+
+int ext2fs_fstat(int fd, ext2fs_struct_stat *buf)
+{
+#if defined(HAVE_FSTAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
+	return fstat64(fd, buf);
+#else
+	return fstat(fd, buf);
+#endif
+}
+
 static errcode_t unix_open(const char *name, int flags, io_channel *channel)
 {
 	io_channel	io = NULL;
-- 
1.7.3.4

