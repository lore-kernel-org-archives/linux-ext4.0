From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] configure: sort AC_CHECK_FUNCS list
Date: Mon,  5 Mar 2012 00:33:17 -0500
Message-ID: <1330925597-6938-1-git-send-email-vapier@gentoo.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:51005 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab2CEFdP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2012 00:33:15 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 019E81B4014
	for <linux-ext4@vger.kernel.org>; Mon,  5 Mar 2012 05:33:14 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

By using m4_flatten, should be easier to maintain this list.

Regen configure and config.h.in after doing this.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 configure       |    2 +-
 configure.in    |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 lib/config.h.in |    3 +++
 3 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/configure b/configure
index 9f5eeb5..f4d1098 100755
--- a/configure
+++ b/configure
@@ -10893,7 +10893,7 @@ if test "$ac_res" != no; then :
 fi
 
 fi
-for ac_func in chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync quotactl strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap msync utime setresuid setresgid usleep nanosleep getdtablesize getrlimit sync_file_range posix_fadvise fallocate fallocate64 blkid_probe_get_topology mbstowcs backtrace
+for ac_func in  	__secure_getenv 	backtrace 	blkid_probe_get_topology 	chflags 	fallocate 	fallocate64 	fchown 	fdatasync 	fstat64 	ftruncate64 	getdtablesize 	getmntinfo 	getrlimit 	getrusage 	jrand48 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	mmap 	msync 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_memalign 	prctl 	quotactl 	setresgid 	setresuid 	srandom 	strcasecmp 	strdup 	strnlen 	strptime 	strtoull 	sync_file_range 	sysconf 	usleep 	utime 	valloc
 do :
   as_ac_var=`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
 ac_fn_c_check_func "$LINENO" "$ac_func" "$as_ac_var"
diff --git a/configure.in b/configure.in
index 8eeaaa5..04176a0 100644
--- a/configure.in
+++ b/configure.in
@@ -916,7 +916,50 @@ if test -n "$BLKID_CMT"; then
   AC_SEARCH_LIBS([blkid_probe_all], [blkid])
 fi
 dnl
-AC_CHECK_FUNCS(chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync quotactl strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap msync utime setresuid setresgid usleep nanosleep getdtablesize getrlimit sync_file_range posix_fadvise fallocate fallocate64 blkid_probe_get_topology mbstowcs backtrace)
+AC_CHECK_FUNCS(m4_flatten([
+	__secure_getenv
+	backtrace
+	blkid_probe_get_topology
+	chflags
+	fallocate
+	fallocate64
+	fchown
+	fdatasync
+	fstat64
+	ftruncate64
+	getdtablesize
+	getmntinfo
+	getrlimit
+	getrusage
+	jrand48
+	llseek
+	lseek64
+	mallinfo
+	mbstowcs
+	memalign
+	mmap
+	msync
+	nanosleep
+	open64
+	pathconf
+	posix_fadvise
+	posix_memalign
+	prctl
+	quotactl
+	setresgid
+	setresuid
+	srandom
+	strcasecmp
+	strdup
+	strnlen
+	strptime
+	strtoull
+	sync_file_range
+	sysconf
+	usleep
+	utime
+	valloc
+]))
 dnl
 dnl Check to see if -lsocket is required (solaris) to make something
 dnl that uses socket() to compile; this is needed for the UUID library
diff --git a/lib/config.h.in b/lib/config.h.in
index 0e83634..7dd34bc 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -239,6 +239,9 @@
 /* Define to 1 if you have the <mntent.h> header file. */
 #undef HAVE_MNTENT_H
 
+/* Define to 1 if you have the `msync' function. */
+#undef HAVE_MSYNC
+
 /* Define to 1 if you have the `munmap' function. */
 #undef HAVE_MUNMAP
 
-- 
1.7.8.4

