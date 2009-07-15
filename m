From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e4defrag: remove a lot of cruft
Date: Wed, 15 Jul 2009 12:36:58 -0500
Message-ID: <4A5E13BA.5020401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56174 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694AbZGORhE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Jul 2009 13:37:04 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n6FHb4Bm023280
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 13:37:04 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6FHaxwW008137
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 13:37:04 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n6FHawrO027299
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 13:36:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e4defrag.c had a lot of stuff copied into it from other
places, redefinitions of existing interfaces, etc.

We should be able to remove most of this, as the tool only
works on recent kernels anyway, we should just pick up
definitions from recent kernel headers whenever possible.

I've left the local definitions of fallocate, fadvise
(changed to posix_fadvise) and sync_file_range, and
wrapped them in #ifdef configure-time tests - though
really it seems like only fallocate should be necessary
by now, and perhaps the others can be dropped.

We still need some Makefile work so that it won't try to
build e4defrag if the right pieces aren't there (and
if the local definitions won't work...)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/configure b/configure
index 769dc09..4b3d221 100755
--- a/configure
+++ b/configure
@@ -15790,7 +15790,7 @@ fi
 
 
 
-for ac_func in chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid usleep nanosleep getdtablesize getrlimit
+for ac_func in chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid usleep nanosleep getdtablesize getrlimit sync_file_range posix_fadvise fallocate
 do
 as_ac_var=`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
 { $as_echo "$as_me:$LINENO: checking for $ac_func" >&5
diff --git a/configure.in b/configure.in
index d11faec..22554a2 100644
--- a/configure.in
+++ b/configure.in
@@ -828,7 +828,7 @@ AC_CHECK_MEMBER(struct sockaddr.sa_len,
 	[#include <sys/types.h>
 	 #include <sys/socket.h>])
 dnl
-AC_CHECK_FUNCS(chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid usleep nanosleep getdtablesize getrlimit)
+AC_CHECK_FUNCS(chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid usleep nanosleep getdtablesize getrlimit sync_file_range posix_fadvise fallocate)
 dnl
 dnl Check to see if -lsocket is required (solaris) to make something
 dnl that uses socket() to compile; this is needed for the UUID library
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index c25514a..fb1a42a 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -34,6 +34,7 @@
 #include <ext2fs/ext2_types.h>
 #include <ext2fs/ext2fs.h>
 #include <linux/fs.h>
+#include <linux/fiemap.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
@@ -41,9 +42,10 @@
 #include <sys/syscall.h>
 #include <sys/vfs.h>
 
-/* Ioctl command */
-#define FS_IOC_FIEMAP		_IOWR('f', 11, struct fiemap)
-#define EXT4_IOC_MOVE_EXT	_IOWR('f', 15, struct move_extent)
+/* A relatively new ioctl interface ... */
+#ifndef EXT4_IOC_MOVE_EXT
+#define EXT4_IOC_MOVE_EXT      _IOWR('f', 15, struct move_extent)
+#endif
 
 /* Macro functions */
 #define PRINT_ERR_MSG(msg)	fprintf(stderr, "%s\n", (msg))
@@ -83,36 +85,6 @@
 #define EXT2FS_ATTR(x)
 #endif
 
-#ifndef __NR_fadvise64
-#define __NR_fadvise64		250
-#endif
-
-#ifndef __NR_sync_file_range
-#define __NR_sync_file_range	314
-#endif
-
-#ifndef __NR_fallocate
-#define __NR_fallocate		324
-#endif
-
-#ifndef POSIX_FADV_DONTNEED
-#if defined(__s390x__)
-#define POSIX_FADV_DONTNEED	6 /* Don't need these pages */
-#else
-#define POSIX_FADV_DONTNEED	4 /* Don't need these pages */
-#endif
-#endif
-
-#ifndef SYNC_FILE_RANGE_WAIT_BEFORE
-#define SYNC_FILE_RANGE_WAIT_BEFORE	1
-#endif
-#ifndef SYNC_FILE_RANGE_WRITE
-#define SYNC_FILE_RANGE_WRITE		2
-#endif
-#ifndef SYNC_FILE_RANGE_WAIT_AFTER
-#define SYNC_FILE_RANGE_WAIT_AFTER	4
-#endif
-
 /* The mode of defrag */
 #define DETAIL			0x01
 #define STATISTIC		0x02
@@ -135,17 +107,10 @@
 /* Definition of flex_bg */
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 
-/* The following four macros are used for ioctl FS_IOC_FIEMAP
- * FIEMAP_FLAG_SYNC:	sync file data before map.
- * FIEMAP_EXTENT_LAST:	last extent in file.
- * FIEMAP_MAX_OFFSET:	max file offset.
+/* The following macro is used for ioctl FS_IOC_FIEMAP
  * EXTENT_MAX_COUNT:	the maximum number of extents for exchanging between
  *			kernel-space and user-space per ioctl
  */
-#define FIEMAP_FLAG_SYNC	0x00000001
-#define FIEMAP_EXTENT_LAST	0x00000001
-#define FIEMAP_EXTENT_UNWRITTEN	0x00000800
-#define FIEMAP_MAX_OFFSET	(~0ULL)
 #define EXTENT_MAX_COUNT	512
 
 /* The following macros are error message */
@@ -192,30 +157,6 @@ struct move_extent {
 	__u64 moved_len;	/* moved block length */
 };
 
-struct fiemap_extent {
-	__u64 fe_logical;	/* logical offset in bytes for the start of
-				* the extent from the beginning of the file */
-	__u64 fe_physical;	/* physical offset in bytes for the start
-				* of the extent from the beginning
-				* of the disk */
-	__u64 fe_length;	/* length in bytes for this extent */
-	__u64 fe_reserved64[2];
-	__u32 fe_flags;    	/* FIEMAP_EXTENT_* flags for this extent */
-	__u32 fe_reserved[3];
-};
-
-struct fiemap {
-	__u64 fm_start;		/* logical offset (inclusive) at
-				* which to start mapping (in) */
-	__u64 fm_length;	/* logical length of mapping which
-				* userspace wants (in) */
-	__u32 fm_flags;		/* FIEMAP_FLAG_* flags for request (in/out) */
-	__u32 fm_mapped_extents;/* number of extents that were mapped (out) */
-	__u32 fm_extent_count;	/* size of fm_extents array (in) */
-	__u32 fm_reserved;
-	struct fiemap_extent fm_extents[0];/* array of mapped extents (out) */
-};
-
 struct frag_statistic_ino {
 	int now_count;	/* the file's extents count of before defrag */
 	int best_count; /* the best file's extents count */
@@ -336,20 +277,15 @@ __le32 feature_incompat;
 ext4_fsblk_t	files_block_count;
 struct frag_statistic_ino	frag_rank[SHOW_FRAG_FILES];
 
-/*
- * ext2fs_swab32() -	Change endian.
- *
- * @val:		the entry used for change.
- */
-__u32 ext2fs_swab32(__u32 val)
-{
-#if BYTE_ORDER == BIG_ENDIAN
-	return (val >> 24) | ((val >> 8) & 0xFF00) |
-		((val << 8) & 0xFF0000) | (val << 24);
-#else
-	return val;
+
+/* Local definitions of some syscalls glibc may not yet have */
+
+#ifndef HAVE_POSIX_FADVISE
+#warning Using locally defined posix_fadvise interface.
+
+#ifndef __NR_fadvise64_64
+#error Your kernel headers dont define __NR_fadvise64_64
 #endif
-}
 
 /*
  * fadvise() -		Give advice about file access.
@@ -359,10 +295,18 @@ __u32 ext2fs_swab32(__u32 val)
  * @len:		area length.
  * @advise:		process flag.
  */
-static int fadvise(int fd, loff_t offset, size_t len, int advise)
+static int posix_fadvise(int fd, loff_t offset, size_t len, int advise)
 {
-	return syscall(__NR_fadvise64, fd, offset, len, advise);
+	return syscall(__NR_fadvise64_64, fd, offset, len, advise);
 }
+#endif /* ! HAVE_FADVISE64_64 */
+
+#ifndef HAVE_SYNC_FILE_RANGE
+#warning Using locally defined sync_file_range interface.
+
+#ifndef __NR_sync_file_range
+#error Your kernel headers dont define __NR_sync_file_range
+#endif
 
 /*
  * sync_file_range() -	Sync file region.
@@ -376,6 +320,14 @@ int sync_file_range(int fd, loff_t offset, loff_t length, unsigned int flag)
 {
 	return syscall(__NR_sync_file_range, fd, offset, length, flag);
 }
+#endif /* ! HAVE_SYNC_FILE_RANGE */
+
+#ifndef HAVE_FALLOCATE
+#warning Using locally defined fallocate syscall interface.
+
+#ifndef __NR_fallocate
+#error Your kernel headers dont define __NR_fallocate
+#endif
 
 /*
  * fallocate() -	Manipulate file space.
@@ -389,6 +341,7 @@ static int fallocate(int fd, int mode, loff_t offset, loff_t len)
 {
 	return syscall(__NR_fallocate, fd, mode, offset, len);
 }
+#endif /* ! HAVE_FALLOCATE */
 
 /*
  * get_mount_point() -	Get device's mount point.
@@ -604,7 +557,7 @@ static int defrag_fadvise(int fd, struct move_extent defrag_data,
 			offset += pagesize;
 			continue;
 		}
-		if (fadvise(fd, offset, pagesize, fadvise_flag) < 0) {
+		if (posix_fadvise(fd, offset, pagesize, fadvise_flag) < 0) {
 			if ((mode_flag & DETAIL) && flag) {
 				perror("\tFailed to fadvise");
 				flag = 0;

