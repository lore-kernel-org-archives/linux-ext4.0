From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/5] libquota: clean up some gcc -Wall warnings
Date: Tue,  4 Oct 2011 12:16:35 -0400
Message-ID: <1317744998-8238-2-git-send-email-tytso@mit.edu>
References: <1317744998-8238-1-git-send-email-tytso@mit.edu>
Cc: Aditya Kali <adityakali@google.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43534 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244Ab1JDQQm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 12:16:42 -0400
In-Reply-To: <1317744998-8238-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove unused variables, places where 'return' was used with no value
in a non-void function, missing function declarations, etc.  Don't
assume that all systems have quotactl(), and use <sys/quota.h> if it
exists to define the quotactl interfaces.

One of the unused variables also got rid of a non-portable use of
PATH_MAX.

Cc: Aditya Kali <adityakali@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 configure              |    4 ++--
 configure.in           |    4 ++--
 lib/config.h.in        |    6 ++++++
 lib/ext2fs/ext2fs.h    |    2 +-
 lib/quota/mkquota.c    |   17 ++++++++---------
 lib/quota/quota.h      |   36 ------------------------------------
 lib/quota/quotaio.c    |    7 -------
 lib/quota/quotaio.h    |    2 ++
 lib/quota/quotaio_v2.c |   16 ++++++++--------
 9 files changed, 29 insertions(+), 65 deletions(-)

diff --git a/configure b/configure
index 35dd5ce..6c8eb49 100755
--- a/configure
+++ b/configure
@@ -10316,7 +10316,7 @@ fi
 done
 
 fi
-for ac_header in dirent.h errno.h execinfo.h getopt.h malloc.h mntent.h paths.h semaphore.h setjmp.h signal.h stdarg.h stdint.h stdlib.h termios.h termio.h unistd.h utime.h linux/falloc.h linux/fd.h linux/major.h net/if_dl.h netinet/in.h sys/disklabel.h sys/file.h sys/ioctl.h sys/mkdev.h sys/mman.h sys/prctl.h sys/queue.h sys/resource.h sys/select.h sys/socket.h sys/sockio.h sys/stat.h sys/syscall.h sys/sysmacros.h sys/time.h sys/types.h sys/un.h sys/wait.h
+for ac_header in dirent.h errno.h execinfo.h getopt.h malloc.h mntent.h paths.h semaphore.h setjmp.h signal.h stdarg.h stdint.h stdlib.h termios.h termio.h unistd.h utime.h linux/falloc.h linux/fd.h linux/major.h net/if_dl.h netinet/in.h sys/disklabel.h sys/file.h sys/ioctl.h sys/mkdev.h sys/mman.h sys/prctl.h sys/queue.h sys/quota.h sys/resource.h sys/select.h sys/socket.h sys/sockio.h sys/stat.h sys/syscall.h sys/sysmacros.h sys/time.h sys/types.h sys/un.h sys/wait.h
 do :
   as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
 ac_fn_c_check_header_mongrel "$LINENO" "$ac_header" "$as_ac_Header" "$ac_includes_default"
@@ -10958,7 +10958,7 @@ if test "$ac_res" != no; then :
 fi
 
 fi
-for ac_func in chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid usleep nanosleep getdtablesize getrlimit sync_file_range posix_fadvise fallocate fallocate64 blkid_probe_get_topology mbstowcs backtrace
+for ac_func in chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync quotactl strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid usleep nanosleep getdtablesize getrlimit sync_file_range posix_fadvise fallocate fallocate64 blkid_probe_get_topology mbstowcs backtrace
 do :
   as_ac_var=`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
 ac_fn_c_check_func "$LINENO" "$ac_func" "$as_ac_var"
diff --git a/configure.in b/configure.in
index 90a6eec..0b609bb 100644
--- a/configure.in
+++ b/configure.in
@@ -802,7 +802,7 @@ if test $cross_compiling = no; then
 else
   AC_CHECK_PROGS(BUILD_CC, gcc cc)
 fi
-AC_CHECK_HEADERS(dirent.h errno.h execinfo.h getopt.h malloc.h mntent.h paths.h semaphore.h setjmp.h signal.h stdarg.h stdint.h stdlib.h termios.h termio.h unistd.h utime.h linux/falloc.h linux/fd.h linux/major.h net/if_dl.h netinet/in.h sys/disklabel.h sys/file.h sys/ioctl.h sys/mkdev.h sys/mman.h sys/prctl.h sys/queue.h sys/resource.h sys/select.h sys/socket.h sys/sockio.h sys/stat.h sys/syscall.h sys/sysmacros.h sys/time.h sys/types.h sys/un.h sys/wait.h)
+AC_CHECK_HEADERS(dirent.h errno.h execinfo.h getopt.h malloc.h mntent.h paths.h semaphore.h setjmp.h signal.h stdarg.h stdint.h stdlib.h termios.h termio.h unistd.h utime.h linux/falloc.h linux/fd.h linux/major.h net/if_dl.h netinet/in.h sys/disklabel.h sys/file.h sys/ioctl.h sys/mkdev.h sys/mman.h sys/prctl.h sys/queue.h sys/quota.h sys/resource.h sys/select.h sys/socket.h sys/sockio.h sys/stat.h sys/syscall.h sys/sysmacros.h sys/time.h sys/types.h sys/un.h sys/wait.h)
 AC_CHECK_HEADERS(sys/disk.h sys/mount.h,,,
 [[
 #if HAVE_SYS_QUEUE_H
@@ -932,7 +932,7 @@ if test -n "$BLKID_CMT"; then
   AC_SEARCH_LIBS([blkid_probe_all], [blkid])
 fi
 dnl
-AC_CHECK_FUNCS(chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid usleep nanosleep getdtablesize getrlimit sync_file_range posix_fadvise fallocate fallocate64 blkid_probe_get_topology mbstowcs backtrace)
+AC_CHECK_FUNCS(chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync quotactl strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid usleep nanosleep getdtablesize getrlimit sync_file_range posix_fadvise fallocate fallocate64 blkid_probe_get_topology mbstowcs backtrace)
 dnl
 dnl Check to see if -lsocket is required (solaris) to make something
 dnl that uses socket() to compile; this is needed for the UUID library
diff --git a/lib/config.h.in b/lib/config.h.in
index 04613d6..a58745e 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -281,6 +281,9 @@
 /* Define to 1 if you have the `putenv' function. */
 #undef HAVE_PUTENV
 
+/* Define to 1 if you have the `quotactl' function. */
+#undef HAVE_QUOTACTL
+
 /* Define to 1 if dirent has d_reclen */
 #undef HAVE_RECLEN_DIRENT
 
@@ -399,6 +402,9 @@
 /* Define to 1 if you have the <sys/queue.h> header file. */
 #undef HAVE_SYS_QUEUE_H
 
+/* Define to 1 if you have the <sys/quota.h> header file. */
+#undef HAVE_SYS_QUOTA_H
+
 /* Define to 1 if you have the <sys/resource.h> header file. */
 #undef HAVE_SYS_RESOURCE_H
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 7df0b0d..b04b0d1 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1355,7 +1355,7 @@ errcode_t ext2fs_mmp_init(ext2_filsys fs);
 errcode_t ext2fs_mmp_start(ext2_filsys fs);
 errcode_t ext2fs_mmp_update(ext2_filsys fs);
 errcode_t ext2fs_mmp_stop(ext2_filsys fs);
-unsigned ext2fs_mmp_new_seq();
+unsigned ext2fs_mmp_new_seq(void);
 
 /* read_bb.c */
 extern errcode_t ext2fs_read_bb_inode(ext2_filsys fs,
diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index 4316243..263b62b 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -6,6 +6,9 @@
 #include "config.h"
 #include <sys/types.h>
 #include <sys/stat.h>
+#ifdef HAVE_SYS_QUOTA_H
+#include <sys/quota.h>
+#endif
 #include <unistd.h>
 #include <errno.h>
 #include <string.h>
@@ -51,8 +54,10 @@ int is_quota_on(ext2_filsys fs, int type)
 	char tmp[1024];
 	qid_t id = (type == USRQUOTA) ? getuid() : getgid();
 
+#ifdef HAVE_QUOTACTL
 	if (!quotactl(QCMD(Q_V2_GETQUOTA, type), fs->device_name, id, tmp))
 		return 1;
+#endif
 	return 0;
 }
 
@@ -114,10 +119,8 @@ errcode_t remove_quota_inode(ext2_filsys fs, int qtype)
 
 static void write_dquots(dict_t *dict, struct quota_handle *qh)
 {
-	int		i = 0;
 	dnode_t		*n;
 	struct dquot	*dq;
-	__u32		key;
 
 	for (n = dict_first(dict); n; n = dict_next(dict, n)) {
 		dq = dnode_get(n);
@@ -131,16 +134,14 @@ static void write_dquots(dict_t *dict, struct quota_handle *qh)
 
 errcode_t write_quota_inode(quota_ctx_t qctx, int qtype)
 {
-	int		retval, i;
-	unsigned long	qf_inums[MAXQUOTAS];
-	struct dquot	*dquot;
+	int		retval = 0, i;
 	dict_t		*dict;
 	ext2_filsys	fs;
 	struct quota_handle *h;
 	int		fmt = QFMT_VFS_V1;
 
 	if (!qctx)
-		return;
+		return 0;
 
 	fs = qctx->fs;
 	h = smalloc(sizeof(struct quota_handle));
@@ -179,7 +180,6 @@ errcode_t write_quota_inode(quota_ctx_t qctx, int qtype)
 	}
 
 	ext2fs_write_bitmaps(fs);
-out:
 	free(h);
 	return retval;
 }
@@ -361,7 +361,6 @@ void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode,
 errcode_t compute_quota(quota_ctx_t qctx, int qtype)
 {
 	ext2_filsys fs;
-	const char *name = "lost+found";
 	ext2_ino_t ino;
 	errcode_t ret;
 	struct ext2_inode inode;
@@ -369,7 +368,7 @@ errcode_t compute_quota(quota_ctx_t qctx, int qtype)
 	ext2_inode_scan scan;
 
 	if (!qctx)
-		return;
+		return 0;
 
 	fs = qctx->fs;
 	ret = ext2fs_open_inode_scan(fs, 0, &scan);
diff --git a/lib/quota/quota.h b/lib/quota/quota.h
index cc6c98e..a943ec6 100644
--- a/lib/quota/quota.h
+++ b/lib/quota/quota.h
@@ -103,42 +103,6 @@ typedef int64_t qsize_t;	/* Type in which we store size limitations */
 #define QIF_DQBLKSIZE (1 << QIF_DQBLKSIZE_BITS)
 
 /*
- * Quota structure used for communication with userspace via quotactl
- * Following flags are used to specify which fields are valid
- */
-enum {
-	QIF_BLIMITS_B = 0,
-	QIF_SPACE_B,
-	QIF_ILIMITS_B,
-	QIF_INODES_B,
-	QIF_BTIME_B,
-	QIF_ITIME_B,
-};
-
-#define QIF_BLIMITS	(1 << QIF_BLIMITS_B)
-#define QIF_SPACE	(1 << QIF_SPACE_B)
-#define QIF_ILIMITS	(1 << QIF_ILIMITS_B)
-#define QIF_INODES	(1 << QIF_INODES_B)
-#define QIF_BTIME	(1 << QIF_BTIME_B)
-#define QIF_ITIME	(1 << QIF_ITIME_B)
-#define QIF_LIMITS	(QIF_BLIMITS | QIF_ILIMITS)
-#define QIF_USAGE	(QIF_SPACE | QIF_INODES)
-#define QIF_TIMES	(QIF_BTIME | QIF_ITIME)
-#define QIF_ALL		(QIF_LIMITS | QIF_USAGE | QIF_TIMES)
-
-struct if_dqblk {
-	__u64 dqb_bhardlimit;
-	__u64 dqb_bsoftlimit;
-	__u64 dqb_curspace;
-	__u64 dqb_ihardlimit;
-	__u64 dqb_isoftlimit;
-	__u64 dqb_curinodes;
-	__u64 dqb_btime;
-	__u64 dqb_itime;
-	__u32 dqb_valid;
-};
-
-/*
  * Structure used for setting quota information about file via quotactl
  * Following flags are used to specify which fields are valid
  */
diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index cf13e35..ef92f5a 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -117,7 +117,6 @@ static int compute_num_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
 void truncate_quota_inode(ext2_filsys fs, ext2_ino_t ino)
 {
 	struct ext2_inode inode;
-	int i;
 
 	if (ext2fs_read_inode(fs, ino, &inode))
 		return;
@@ -135,7 +134,6 @@ void truncate_quota_inode(ext2_filsys fs, ext2_ino_t ino)
 
 static ext2_off64_t compute_inode_size(ext2_filsys fs, ext2_ino_t ino)
 {
-	struct ext2_inode inode;
 	blk64_t num_blocks = 0;
 
 	ext2fs_block_iterate3(fs, ino,
@@ -241,14 +239,9 @@ static errcode_t init_new_quota_inode(ext2_filsys fs, ext2_ino_t ino)
  */
 int new_io(struct quota_handle *h, ext2_filsys fs, int type, int fmt)
 {
-	int fd = 0;
 	ext2_file_t e2_file;
-	const char *mnt_fsname;
-	char qf_name[PATH_MAX];
 	int err;
-	struct ext2_inode inode;
 	unsigned long qf_inum;
-	struct stat st;
 
 	if (fmt == -1)
 		fmt = QFMT_VFS_V1;
diff --git a/lib/quota/quotaio.h b/lib/quota/quotaio.h
index fd39b55..f2c34f2 100644
--- a/lib/quota/quotaio.h
+++ b/lib/quota/quotaio.h
@@ -160,4 +160,6 @@ void truncate_quota_inode(ext2_filsys fs, ext2_ino_t ino);
 
 const char *type2name(int type);
 
+void update_grace_times(struct dquot *q);
+
 #endif /* GUARD_QUOTAIO_H */
diff --git a/lib/quota/quotaio_v2.c b/lib/quota/quotaio_v2.c
index 660d463..35512c0 100644
--- a/lib/quota/quotaio_v2.c
+++ b/lib/quota/quotaio_v2.c
@@ -32,14 +32,14 @@ static int v2_scan_dquots(struct quota_handle *h,
 static int v2_report(struct quota_handle *h, int verbose);
 
 struct quotafile_ops quotafile_ops_2 = {
-check_file:	v2_check_file,
-init_io:	v2_init_io,
-new_io:		v2_new_io,
-write_info:	v2_write_info,
-read_dquot:	v2_read_dquot,
-commit_dquot:	v2_commit_dquot,
-scan_dquots:	v2_scan_dquots,
-report:	v2_report
+	.check_file	= v2_check_file,
+	.init_io 	= v2_init_io,
+	.new_io 	= v2_new_io,
+	.write_info	= v2_write_info,
+	.read_dquot	= v2_read_dquot,
+	.commit_dquot	= v2_commit_dquot,
+	.scan_dquots	= v2_scan_dquots,
+	.report		= v2_report,
 };
 
 #define getdqbuf() smalloc(V2_DQBLKSIZE)
-- 
1.7.4.1.22.gec8e1.dirty

