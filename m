From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH] e2fslibs: fix llseek on i386
Date: Thu, 24 Jan 2013 11:21:56 -0500
Message-ID: <1359044517-18243-1-git-send-email-psusi@ubuntu.com>
Cc: linux-ext4@vger.kernel.org, Phillip Susi <psusi@ubuntu.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rrcs-67-78-168-186.se.biz.rr.com ([67.78.168.186]:40218 "EHLO
	iriserv.iradimed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab3AXQWF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2013 11:22:05 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_llseek() was using lseek instead of lseek64.  The
only time it would use lseek64 is if passed an offset that
overflowed 32 bits.  This works for SEEK_SET, but not
SEEK_CUR, which can apply a small offset to move the file
pointer past the 32 bit limit.

The code has been changed to instead try lseek64 first, and
fall back to lseek if that fails.  It also was doing a
runtime check of the size of off_t.  This has been moved to
compile time.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 configure.in        |    3 +++
 lib/config.h.in     |    3 +++
 lib/ext2fs/llseek.c |   13 +++++--------
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/configure.in b/configure.in
index ac3cd92..181faeb 100644
--- a/configure.in
+++ b/configure.in
@@ -970,14 +970,17 @@ AC_CHECK_SIZEOF(short)
 AC_CHECK_SIZEOF(int)
 AC_CHECK_SIZEOF(long)
 AC_CHECK_SIZEOF(long long)
+AC_CHECK_SIZEOF(off_t)
 SIZEOF_SHORT=$ac_cv_sizeof_short
 SIZEOF_INT=$ac_cv_sizeof_int
 SIZEOF_LONG=$ac_cv_sizeof_long
 SIZEOF_LONG_LONG=$ac_cv_sizeof_long_long
+SIZEOF_OFF_T=$ac_cv_sizeof_off_t
 AC_SUBST(SIZEOF_SHORT)
 AC_SUBST(SIZEOF_INT)
 AC_SUBST(SIZEOF_LONG)
 AC_SUBST(SIZEOF_LONG_LONG)
+AC_SUBST(SIZEOF_OFF_T)
 AC_C_BIGENDIAN
 BUILD_CC="$BUILD_CC" CPP="$CPP" /bin/sh $ac_aux_dir/parse-types.sh
 ASM_TYPES_HEADER=./asm_types.h
diff --git a/lib/config.h.in b/lib/config.h.in
index 6f88c9c..eebb75d 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -552,6 +552,9 @@
 /* The size of `long long', as computed by sizeof. */
 #undef SIZEOF_LONG_LONG
 
+/* The size of `off_t', as computed by sizeof. */
+#undef SIZEOF_OFF_T
+
 /* The size of `short', as computed by sizeof. */
 #undef SIZEOF_SHORT
 
diff --git a/lib/ext2fs/llseek.c b/lib/ext2fs/llseek.c
index b0576e4..e5cb784 100644
--- a/lib/ext2fs/llseek.c
+++ b/lib/ext2fs/llseek.c
@@ -90,18 +90,14 @@ static ext2_loff_t my_llseek (int fd, ext2_loff_t offset, int origin)
 
 ext2_loff_t ext2fs_llseek (int fd, ext2_loff_t offset, int origin)
 {
+#if SIZEOF_OFF_T >= SIZEOF_LONG_LONG
+	return lseek (fd, offset, origin);
+#else
 	ext2_loff_t result;
 	static int do_compat = 0;
 
-	if ((sizeof(off_t) >= sizeof(ext2_loff_t)) ||
-	    (offset < ((ext2_loff_t) 1 << ((sizeof(off_t)*8) -1))))
+	if (do_compat)
 		return lseek(fd, (off_t) offset, origin);
-
-	if (do_compat) {
-		errno = EINVAL;
-		return -1;
-	}
