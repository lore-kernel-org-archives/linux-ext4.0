From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: fix ext2fs_llseek on i386
Date: Thu, 24 Jan 2013 23:14:18 -0500
Message-ID: <1359087258-13276-1-git-send-email-tytso@mit.edu>
References: <20130125041313.GF28908@thunk.org>
Cc: psusi@ubuntu.com, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45393 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab3AYEOU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jan 2013 23:14:20 -0500
In-Reply-To: <20130125041313.GF28908@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Phillip Susi <psusi@ubuntu.com>

ext2fs_llseek() was using lseek instead of lseek64.  The
only time it would use lseek64 is if passed an offset that
overflowed 32 bits.  This works for SEEK_SET, but not
SEEK_CUR, which can apply a small offset to move the file
pointer past the 32 bit limit.

The code has been changed to instead try lseek64 first, and
fall back to lseek if that fails.  It also was doing a
runtime check of the size of off_t.  This has been moved to
compile time.

This fixes a problem which would cause e2image when built for
x86-32 to bomb out when used with large file systems.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 configure.in        |  3 +++
 lib/config.h.in     |  3 +++
 lib/ext2fs/llseek.c | 18 ++++++++++--------
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/configure.in b/configure.in
index cf96e43..c3687bb 100644
--- a/configure.in
+++ b/configure.in
@@ -916,14 +916,17 @@ AC_CHECK_SIZEOF(short)
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
index 90e9743..e14eff4 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -543,6 +543,9 @@
 /* The size of `long long', as computed by sizeof. */
 #undef SIZEOF_LONG_LONG
 
+/* The size of `off_t', as computed by sizeof. */
+#undef SIZEOF_OFF_T
+
 /* The size of `short', as computed by sizeof. */
 #undef SIZEOF_SHORT
 
diff --git a/lib/ext2fs/llseek.c b/lib/ext2fs/llseek.c
index b0576e4..c3a98a2 100644
--- a/lib/ext2fs/llseek.c
+++ b/lib/ext2fs/llseek.c
@@ -90,17 +90,14 @@ static ext2_loff_t my_llseek (int fd, ext2_loff_t offset, int origin)
 
 ext2_loff_t ext2fs_llseek (int fd, ext2_loff_t offset, int origin)
 {
+#if SIZEOF_OFF_T >= SIZEOF_LONG_LONG
+	return lseek (fd, offset, origin);
+#else
 	ext2_loff_t result;
 	static int do_compat = 0;
 
-	if ((sizeof(off_t) >= sizeof(ext2_loff_t)) ||
-	    (offset < ((ext2_loff_t) 1 << ((sizeof(off_t)*8) -1))))
-		return lseek(fd, (off_t) offset, origin);
-
-	if (do_compat) {
-		errno = EINVAL;
-		return -1;
-	}
+	if (do_compat)
+		goto fallback;
 
 	result = my_llseek (fd, offset, origin);
 	if (result == -1 && errno == ENOSYS) {
@@ -109,9 +106,14 @@ ext2_loff_t ext2fs_llseek (int fd, ext2_loff_t offset, int origin)
 		 * which does not support the llseek system call
 		 */
 		do_compat++;
+	fallback:
+		if (offset < ((ext2_loff_t) 1 << ((sizeof(off_t)*8) -1)))
+			return lseek(fd, (off_t) offset, origin);
 		errno = EINVAL;
+		return -1;
 	}
 	return result;
+#endif
 }
 
 #else /* !linux */
-- 
1.7.12.rc0.22.gcdd159b

