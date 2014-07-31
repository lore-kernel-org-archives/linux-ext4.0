From: basile@opensource.dyc.edu
Subject: [PATCH] misc/e4defrag.c: use posix_fallocate64() if fallocate64() is unavailable
Date: Thu, 31 Jul 2014 14:07:48 -0400
Message-ID: <1406830068-6485-1-git-send-email-basile@opensource.dyc.edu>
Cc: "Anthony G. Basile" <blueness@gentoo.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.virtual.dyc.edu ([67.222.116.22]:43909 "EHLO
	virtual.dyc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaGaSM3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2014 14:12:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Anthony G. Basile" <blueness@gentoo.org>

Commit 58229aaf removed the broken fallback syscall for fallocate64() on systems
where the latter is unavailable.  However, it did not provide a substitute,
so the build fails on uClibc which does not have fallocate64(), but does have
posix_fallocate64().  Since fallocate64() is called with mode=0, we can make use
of posix_fallocate64() on such systems.

See `man 2 fallocate` and `man 3 posix_fallocate`.
---
 configure       |  2 +-
 configure.in    |  1 +
 lib/config.h.in |  3 +++
 misc/e4defrag.c | 10 +++++++---
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/configure b/configure
index 6c503aa..9853bc0 100755
--- a/configure
+++ b/configure
@@ -13071,7 +13071,7 @@ if test "$ac_res" != no; then :
 fi
 
 fi
-for ac_func in  	__secure_getenv 	backtrace 	blkid_probe_get_topology 	blkid_probe_enable_partitions 	chflags 	fadvise64 	fallocate 	fallocate64 	fchown 	fdatasync 	fstat64 	ftruncate64 	futimes 	getcwd 	getdtablesize 	getmntinfo 	getpwuid_r 	getrlimit 	getrusage 	jrand48 	llistxattr 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	mempcpy 	mmap 	msync 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_fadvise64 	posix_memalign 	prctl 	secure_getenv 	setmntent 	setresgid 	setresuid 	snprintf 	srandom 	stpcpy 	strcasecmp 	strdup 	strnlen 	strptime 	strtoull 	sync_file_range 	sysconf 	usleep 	utime 	valloc
+for ac_func in  	__secure_getenv 	backtrace 	blkid_probe_get_topology 	blkid_probe_enable_partitions 	chflags 	fadvise64 	fallocate 	fallocate64 	fchown 	fdatasync 	fstat64 	ftruncate64 	futimes 	getcwd 	getdtablesize 	getmntinfo 	getpwuid_r 	getrlimit 	getrusage 	jrand48 	llistxattr 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	mempcpy 	mmap 	msync 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_fadvise64 	posix_fallocate64 	posix_memalign 	prctl 	secure_getenv 	setmntent 	setresgid 	setresuid 	snprintf 	srandom 	stpcpy 	strcasecmp 	strdup 	strnlen 	strptime 	strtoull 	sync_file_range 	sysconf 	usleep 	utime 	valloc
 do :
   as_ac_var=`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
 ac_fn_c_check_func "$LINENO" "$ac_func" "$as_ac_var"
diff --git a/configure.in b/configure.in
index 67e5453..48fa099 100644
--- a/configure.in
+++ b/configure.in
@@ -1113,6 +1113,7 @@ AC_CHECK_FUNCS(m4_flatten([
 	pathconf
 	posix_fadvise
 	posix_fadvise64
+	posix_fallocate64
 	posix_memalign
 	prctl
 	secure_getenv
diff --git a/lib/config.h.in b/lib/config.h.in
index 12a609a..3d6796d 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -331,6 +331,9 @@
 /* Define to 1 if you have the `posix_fadvise64' function. */
 #undef HAVE_POSIX_FADVISE64
 
+/* Define to 1 if you have the `posix_fallocate64' function. */
+#undef HAVE_POSIX_FALLOCATE64
+
 /* Define to 1 if you have the `posix_memalign' function. */
 #undef HAVE_POSIX_MEMALIGN
 
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index d0eac60..ba16a76 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -197,9 +197,9 @@ static struct frag_statistic_ino	frag_rank[SHOW_FRAG_FILES];
 #error sync_file_range not available!
 #endif /* ! HAVE_SYNC_FILE_RANGE */
 
-#ifndef HAVE_FALLOCATE64
-#error fallocate64 not available!
-#endif /* ! HAVE_FALLOCATE64 */
+#if !defined(HAVE_FALLOCATE64) && !defined(HAVE_POSIX_FALLOCATE64)
+#error neither fallocate64 nor posix_fallocate64 available!
+#endif /* ! HAVE_FALLOCATE64 && ! HAVE_POSIX_FALLOCATE64 */
 
 /*
  * get_mount_point() -	Get device's mount point.
@@ -1554,7 +1554,11 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	/* Allocate space for donor inode */
 	orig_group_tmp = orig_group_head;
 	do {
+#ifdef HAVE_FALLOCATE64
 		ret = fallocate64(donor_fd, 0,
+#else /* HAVE_POSIX_FALLOCATE64 */
+		ret = posix_fallocate64(donor_fd,
+#endif
 		  (loff_t)orig_group_tmp->start->data.logical * block_size,
 		  (loff_t)orig_group_tmp->len * block_size);
 		if (ret < 0) {
-- 
1.8.5.5

