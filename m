From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e4defrag: choose the best available posix_fadvise variant
Date: Sun, 5 Jan 2014 01:12:33 -0500
Message-ID: <20140105061233.GA5849@thunk.org>
References: <23c2b99441922fe311235e241eca52e9701e54d4.1388645034.git.baruch@tkos.co.il>
 <20140103004710.GA31411@thunk.org>
 <20140103045747.GM6589@tarshish>
 <20140103162344.GD31411@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Baruch Siach <baruch@tkos.co.il>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45991 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaAEGMh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jan 2014 01:12:37 -0500
Content-Disposition: inline
In-Reply-To: <20140103162344.GD31411@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 03, 2014 at 11:23:44AM -0500, Theodore Ts'o wrote:
>=20
> Oh, oops.  I'll find the other version of the patch and fix it up. =20

Here is the revised version of your patch which I currently have in my
sources.  Let me know what you think.

				- Ted

commit e47e7100a357ed9ba1575a6a8caca9258b1aab77
Author: Baruch Siach <baruch@tkos.co.il>
Date:   Thu Jan 2 13:05:37 2014 -0500

    e4defrag: choose the best available posix_fadvise variant
   =20
    Use posix_fadvise64() when available. This allows 64bit offsets on =
32bit
    systems.
   =20
    Rename the internal posix_fadvise() implementation to avoid collisi=
on with the
    C library signature that is sometimes present event when the implem=
entation
    itself is not. This fixes build errors like:
   =20
    e4defrag.c:189:2: warning: #warning Using locally defined posix_fad=
vise interface. [-Wcpp
    e4defrag.c:203:12: error: conflicting types for =E2=80=98posix_fadv=
ise=E2=80=99
   =20
    [ Modified by tytso to try to use fadvise64 as well, and to remove =
the
      attempt to use the syscall directly, since between fadvise64,
      fadvise64_64, and complexities caused by required dummy arguments=
 on
      some architectures, it's not worth the hair.  ]
   =20
    Signed-off-by: Baruch Siach <baruch@tkos.co.il>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/configure b/configure
index 6f8f1ab..5943849 100755
--- a/configure
+++ b/configure
@@ -11051,7 +11051,7 @@ if test "$ac_res" !=3D no; then :
 fi
=20
 fi
-for ac_func in  	__secure_getenv 	backtrace 	blkid_probe_get_topology =
	chflags 	fallocate 	fallocate64 	fchown 	fdatasync 	fstat64 	ftruncate=
64 	futimes 	getdtablesize 	getmntinfo 	getpwuid_r 	getrlimit 	getrusag=
e 	jrand48 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	mmap 	msync =
	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_memalign 	prctl 	sec=
ure_getenv 	setmntent 	setresgid 	setresuid 	srandom 	strcasecmp 	strdu=
p 	strnlen 	strptime 	strtoull 	sync_file_range 	sysconf 	usleep 	utime=
 	valloc
+for ac_func in  	__secure_getenv 	backtrace 	blkid_probe_get_topology =
	chflags 	fadvise64 	fallocate 	fallocate64 	fchown 	fdatasync 	fstat64=
 	ftruncate64 	futimes 	getdtablesize 	getmntinfo 	getpwuid_r 	getrlimi=
t 	getrusage 	jrand48 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	m=
map 	msync 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_fadvise64=
 	posix_memalign 	prctl 	secure_getenv 	setmntent 	setresgid 	setresuid=
 	srandom 	strcasecmp 	strdup 	strnlen 	strptime 	strtoull 	sync_file_r=
ange 	sysconf 	usleep 	utime 	valloc
 do :
   as_ac_var=3D`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
 ac_fn_c_check_func "$LINENO" "$ac_func" "$as_ac_var"
diff --git a/configure.in b/configure.in
index b70a3f9..214d3f6 100644
--- a/configure.in
+++ b/configure.in
@@ -1026,6 +1026,7 @@ AC_CHECK_FUNCS(m4_flatten([
 	backtrace
 	blkid_probe_get_topology
 	chflags
+	fadvise64
 	fallocate
 	fallocate64
 	fchown
@@ -1050,6 +1051,7 @@ AC_CHECK_FUNCS(m4_flatten([
 	open64
 	pathconf
 	posix_fadvise
+	posix_fadvise64
 	posix_memalign
 	prctl
 	secure_getenv
diff --git a/lib/config.h.in b/lib/config.h.in
index ef2e664..0197b56 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -103,6 +103,9 @@
 /* Define to 1 if Ext2 ioctls present */
 #undef HAVE_EXT2_IOCTLS
=20
+/* Define to 1 if you have the `fadvise64' function. */
+#undef HAVE_FADVISE64
+
 /* Define to 1 if you have the `fallocate' function. */
 #undef HAVE_FALLOCATE
=20
@@ -287,6 +290,9 @@
 /* Define to 1 if you have the `posix_fadvise' function. */
 #undef HAVE_POSIX_FADVISE
=20
+/* Define to 1 if you have the `posix_fadvise64' function. */
+#undef HAVE_POSIX_FADVISE64
+
 /* Define to 1 if you have the `posix_memalign' function. */
 #undef HAVE_POSIX_MEMALIGN
=20
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index c6a5f0d..65933b1 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -34,13 +34,11 @@
 #include <unistd.h>
 #include <ext2fs/ext2_types.h>
 #include <ext2fs/ext2fs.h>
-#include <linux/fs.h>
 #include <sys/ioctl.h>
 #include <ext2fs/fiemap.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/statfs.h>
-#include <sys/syscall.h>
 #include <sys/vfs.h>
=20
 /* A relatively new ioctl interface ... */
@@ -183,28 +181,21 @@ static ext4_fsblk_t	files_block_count;
 static struct frag_statistic_ino	frag_rank[SHOW_FRAG_FILES];
=20
=20
-/* Local definitions of some syscalls glibc may not yet have */
-
-#ifndef HAVE_POSIX_FADVISE
-#warning Using locally defined posix_fadvise interface.
-
-#ifndef __NR_fadvise64_64
-#error Your kernel headers dont define __NR_fadvise64_64
-#endif
-
-/*
- * fadvise() -		Give advice about file access.
+/* Local definitions of some syscalls glibc may not yet have
  *
- * @fd:			defrag target file's descriptor.
- * @offset:		file offset.
- * @len:		area length.
- * @advise:		process flag.
+ * We prefer posix_fadvise64 when available, as it allows 64bit offset=
 on
+ * 32bit systems
  */
-static int posix_fadvise(int fd, loff_t offset, size_t len, int advise=
)
-{
-	return syscall(__NR_fadvise64_64, fd, offset, len, advise);
-}
-#endif /* ! HAVE_FADVISE64_64 */
+
+#if defined(HAVE_POSIX_FADVISE64)
+#define posix_fadvise	posix_fadvise64
+#elif defined(HAVE_FADVISE64)
+#define posix_fadvise	fadvise64
+#elif defined(HAVE_POSIX_FADVISE)
+#define posix_fadvise	posix_fadvise
+#else
+#error posix_fadvise not available!
+#endif
=20
 #ifndef HAVE_SYNC_FILE_RANGE
 #warning Using locally defined sync_file_range interface.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
