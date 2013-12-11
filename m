From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 62/74] misc: add fuse2fs, a FUSE server for e2fsprogs
Date: Tue, 10 Dec 2013 17:25:12 -0800
Message-ID: <20131211012512.30655.92166.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27473 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3LKBZT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:25:19 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is the initial implementation of a FUSE server based on
e2fsprogs.  The point of this program is to enable ext4 to run on any
OS that FUSE supports (and doesn't already have a native driver), such
as MacOS X, BSDs, and Windows.  The code requires FUSE API v28, which
is available in Linux fuse and osxfuse releases that are available as
of August 2013.

v2: Remove unnecessary calls to ext2fs_flush(), and ensure that xattr
blocks are freed when removing an inode.  Modify xattr calls to
reflect the API adjustments.

v3: Zero out large inodes before reading them, so that i_extra_size is
always accurate; disable FUSE attribute caching to prevent stat() from
returning stale contents; use rmdir when renaming onto a directory;
fix some resource leaks with error handling; update inode ctime when
modifying extended attributes; emulate kernel behavior when punching a
zero-length range; fix permission checking; expand directory if we run
out of space while creating a symlink.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 MCONFIG.in       |    1 
 configure        |  268 +++++
 configure.in     |   50 +
 misc/Makefile.in |   15 
 misc/fuse2fs.c   | 2967 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 3299 insertions(+), 2 deletions(-)
 create mode 100644 misc/fuse2fs.c


diff --git a/MCONFIG.in b/MCONFIG.in
index 557b37a..8fa3391 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -107,6 +107,7 @@ LIBCOM_ERR = $(LIB)/libcom_err@LIB_EXT@ @PRIVATE_LIBS_CMT@ @SEM_INIT_LIB@
 LIBE2P = $(LIB)/libe2p@LIB_EXT@
 LIBEXT2FS = $(LIB)/libext2fs@LIB_EXT@
 LIBUUID = @LIBUUID@ @SOCKET_LIB@
+LIBFUSE = @FUSE_LIB@
 LIBQUOTA = @STATIC_LIBQUOTA@
 LIBBLKID = @LIBBLKID@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
 LIBINTL = @LIBINTL@
diff --git a/configure b/configure
index 2338fbe..feea2ae 100755
--- a/configure
+++ b/configure
@@ -639,6 +639,8 @@ CYGWIN_CMT
 LINUX_CMT
 UNI_DIFF_OPTS
 SEM_INIT_LIB
+FUSE_CMT
+FUSE_LIB
 SOCKET_LIB
 SIZEOF_OFF_T
 SIZEOF_LONG_LONG
@@ -861,6 +863,7 @@ enable_rpath
 with_libiconv_prefix
 with_included_gettext
 with_libintl_prefix
+enable_fuse2fs
 with_multiarch
 '
       ac_precious_vars='build_alias
@@ -1516,6 +1519,7 @@ Optional Features:
   --enable-bmap-stats-ops enable collection of additional bitmap stats
   --disable-nls           do not use Native Language Support
   --disable-rpath         do not hardcode runtime library paths
+  --disable-fuse2fs	do not build fuse2fs
 
 Optional Packages:
   --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
@@ -11172,6 +11176,270 @@ if test "x$ac_cv_lib_socket_socket" = xyes; then :
 fi
 
 
+FUSE_CMT=
+FUSE_LIB=
+# Check whether --enable-fuse2fs was given.
+if test "${enable_fuse2fs+set}" = set; then :
+  enableval=$enable_fuse2fs; if test "$enableval" = "no"
+then
+	FUSE_CMT="#"
+	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Disabling fuse2fs" >&5
+$as_echo "Disabling fuse2fs" >&6; }
+else
+	for ac_header in pthread.h fuse.h
+do :
+  as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
+ac_fn_c_check_header_compile "$LINENO" "$ac_header" "$as_ac_Header" "#define _FILE_OFFSET_BITS	64
+"
+if eval test \"x\$"$as_ac_Header"\" = x"yes"; then :
+  cat >>confdefs.h <<_ACEOF
+#define `$as_echo "HAVE_$ac_header" | $as_tr_cpp` 1
+_ACEOF
+
+else
+  { { $as_echo "$as_me:${as_lineno-$LINENO}: error: in \`$ac_pwd':" >&5
+$as_echo "$as_me: error: in \`$ac_pwd':" >&2;}
+as_fn_error $? "Cannot find fuse2fs headers.
+See \`config.log' for more details" "$LINENO" 5; }
+fi
+
+done
+
+
+	cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+#ifdef __linux__
+#include <linux/fs.h>
+#include <linux/falloc.h>
+#include <linux/xattr.h>
+#endif
+
+int
+main ()
+{
+
+  ;
+  return 0;
+}
+_ACEOF
+if ac_fn_c_try_cpp "$LINENO"; then :
+
+else
+  { { $as_echo "$as_me:${as_lineno-$LINENO}: error: in \`$ac_pwd':" >&5
+$as_echo "$as_me: error: in \`$ac_pwd':" >&2;}
+as_fn_error $? "Cannot find fuse2fs Linux headers.
+See \`config.log' for more details" "$LINENO" 5; }
+fi
+rm -f conftest.err conftest.i conftest.$ac_ext
+
+	{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for fuse_main in -losxfuse" >&5
+$as_echo_n "checking for fuse_main in -losxfuse... " >&6; }
+if ${ac_cv_lib_osxfuse_fuse_main+:} false; then :
+  $as_echo_n "(cached) " >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-losxfuse  $LIBS"
+cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char fuse_main ();
+int
+main ()
+{
+return fuse_main ();
+  ;
+  return 0;
+}
+_ACEOF
+if ac_fn_c_try_link "$LINENO"; then :
+  ac_cv_lib_osxfuse_fuse_main=yes
+else
+  ac_cv_lib_osxfuse_fuse_main=no
+fi
+rm -f core conftest.err conftest.$ac_objext \
+    conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_cv_lib_osxfuse_fuse_main" >&5
+$as_echo "$ac_cv_lib_osxfuse_fuse_main" >&6; }
+if test "x$ac_cv_lib_osxfuse_fuse_main" = xyes; then :
+  FUSE_LIB=-losxfuse
+else
+  { $as_echo "$as_me:${as_lineno-$LINENO}: checking for fuse_main in -lfuse" >&5
+$as_echo_n "checking for fuse_main in -lfuse... " >&6; }
+if ${ac_cv_lib_fuse_fuse_main+:} false; then :
+  $as_echo_n "(cached) " >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-lfuse  $LIBS"
+cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char fuse_main ();
+int
+main ()
+{
+return fuse_main ();
+  ;
+  return 0;
+}
+_ACEOF
+if ac_fn_c_try_link "$LINENO"; then :
+  ac_cv_lib_fuse_fuse_main=yes
+else
+  ac_cv_lib_fuse_fuse_main=no
+fi
+rm -f core conftest.err conftest.$ac_objext \
+    conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_cv_lib_fuse_fuse_main" >&5
+$as_echo "$ac_cv_lib_fuse_fuse_main" >&6; }
+if test "x$ac_cv_lib_fuse_fuse_main" = xyes; then :
+  FUSE_LIB=-lfuse
+else
+  { { $as_echo "$as_me:${as_lineno-$LINENO}: error: in \`$ac_pwd':" >&5
+$as_echo "$as_me: error: in \`$ac_pwd':" >&2;}
+as_fn_error $? "Cannot find fuse library.
+See \`config.log' for more details" "$LINENO" 5; }
+fi
+
+fi
+
+	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Enabling fuse2fs" >&5
+$as_echo "Enabling fuse2fs" >&6; }
+fi
+
+else
+  for ac_header in pthread.h fuse.h
+do :
+  as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
+ac_fn_c_check_header_compile "$LINENO" "$ac_header" "$as_ac_Header" "#define _FILE_OFFSET_BITS	64
+#ifdef __linux__
+# include <linux/fs.h>
+# include <linux/falloc.h>
+# include <linux/xattr.h>
+#endif
+"
+if eval test \"x\$"$as_ac_Header"\" = x"yes"; then :
+  cat >>confdefs.h <<_ACEOF
+#define `$as_echo "HAVE_$ac_header" | $as_tr_cpp` 1
+_ACEOF
+
+else
+  FUSE_CMT="#"
+fi
+
+done
+
+if test -z "$FUSE_CMT"
+then
+	{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for fuse_main in -losxfuse" >&5
+$as_echo_n "checking for fuse_main in -losxfuse... " >&6; }
+if ${ac_cv_lib_osxfuse_fuse_main+:} false; then :
+  $as_echo_n "(cached) " >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-losxfuse  $LIBS"
+cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char fuse_main ();
+int
+main ()
+{
+return fuse_main ();
+  ;
+  return 0;
+}
+_ACEOF
+if ac_fn_c_try_link "$LINENO"; then :
+  ac_cv_lib_osxfuse_fuse_main=yes
+else
+  ac_cv_lib_osxfuse_fuse_main=no
+fi
+rm -f core conftest.err conftest.$ac_objext \
+    conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_cv_lib_osxfuse_fuse_main" >&5
+$as_echo "$ac_cv_lib_osxfuse_fuse_main" >&6; }
+if test "x$ac_cv_lib_osxfuse_fuse_main" = xyes; then :
+  FUSE_LIB=-losxfuse
+else
+  { $as_echo "$as_me:${as_lineno-$LINENO}: checking for fuse_main in -lfuse" >&5
+$as_echo_n "checking for fuse_main in -lfuse... " >&6; }
+if ${ac_cv_lib_fuse_fuse_main+:} false; then :
+  $as_echo_n "(cached) " >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-lfuse  $LIBS"
+cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char fuse_main ();
+int
+main ()
+{
+return fuse_main ();
+  ;
+  return 0;
+}
+_ACEOF
+if ac_fn_c_try_link "$LINENO"; then :
+  ac_cv_lib_fuse_fuse_main=yes
+else
+  ac_cv_lib_fuse_fuse_main=no
+fi
+rm -f core conftest.err conftest.$ac_objext \
+    conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_cv_lib_fuse_fuse_main" >&5
+$as_echo "$ac_cv_lib_fuse_fuse_main" >&6; }
+if test "x$ac_cv_lib_fuse_fuse_main" = xyes; then :
+  FUSE_LIB=-lfuse
+else
+  FUSE_CMT="#"
+fi
+
+fi
+
+fi
+if test -z "$FUSE_CMT"
+then
+	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Enabling fuse2fs by default." >&5
+$as_echo "Enabling fuse2fs by default." >&6; }
+fi
+
+fi
+
+
+
 { $as_echo "$as_me:${as_lineno-$LINENO}: checking for optreset" >&5
 $as_echo_n "checking for optreset... " >&6; }
 if ${ac_cv_have_optreset+:} false; then :
diff --git a/configure.in b/configure.in
index 049dc11..27655e3 100644
--- a/configure.in
+++ b/configure.in
@@ -1127,6 +1127,56 @@ SOCKET_LIB=''
 AC_CHECK_LIB(socket, socket, [SOCKET_LIB=-lsocket])
 AC_SUBST(SOCKET_LIB)
 dnl
+dnl Check to see if the FUSE library is -lfuse or -losxfuse
+dnl
+FUSE_CMT=
+FUSE_LIB=
+dnl osxfuse.dylib supersedes fuselib.dylib
+AC_ARG_ENABLE([fuse2fs],
+[  --disable-fuse2fs	do not build fuse2fs],
+if test "$enableval" = "no"
+then
+	FUSE_CMT="#"
+	AC_MSG_RESULT([Disabling fuse2fs])
+else
+	AC_CHECK_HEADERS([pthread.h fuse.h], [],
+[AC_MSG_FAILURE([Cannot find fuse2fs headers.])],
+[#define _FILE_OFFSET_BITS	64])
+
+	AC_PREPROC_IFELSE(
+[AC_LANG_PROGRAM([[#ifdef __linux__
+#include <linux/fs.h>
+#include <linux/falloc.h>
+#include <linux/xattr.h>
+#endif
+]], [])], [], [AC_MSG_FAILURE([Cannot find fuse2fs Linux headers.])])
+
+	AC_CHECK_LIB(osxfuse, fuse_main, [FUSE_LIB=-losxfuse],
+		[AC_CHECK_LIB(fuse, fuse_main, [FUSE_LIB=-lfuse],
+			      [AC_MSG_FAILURE([Cannot find fuse library.])])])
+	AC_MSG_RESULT([Enabling fuse2fs])
+fi
+,
+AC_CHECK_HEADERS([pthread.h fuse.h], [], [FUSE_CMT="#"],
+[#define _FILE_OFFSET_BITS	64
+#ifdef __linux__
+# include <linux/fs.h>
+# include <linux/falloc.h>
+# include <linux/xattr.h>
+#endif])
+if test -z "$FUSE_CMT"
+then
+	AC_CHECK_LIB(osxfuse, fuse_main, [FUSE_LIB=-losxfuse],
+[AC_CHECK_LIB(fuse, fuse_main, [FUSE_LIB=-lfuse], [FUSE_CMT="#"])])
+fi
+if test -z "$FUSE_CMT"
+then
+	AC_MSG_RESULT([Enabling fuse2fs by default.])
+fi
+)
+AC_SUBST(FUSE_LIB)
+AC_SUBST(FUSE_CMT)
+dnl
 dnl See if optreset exists
 dnl
 AC_MSG_CHECKING(for optreset)
diff --git a/misc/Makefile.in b/misc/Makefile.in
index a798f96..1838d03 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -26,9 +26,12 @@ INSTALL = @INSTALL@
 @BLKID_CMT@FINDFS_LINK= findfs
 @BLKID_CMT@FINDFS_MAN= findfs.8
 
+@FUSE_CMT@FUSE_PROG= fuse2fs
+
 SPROGS=		mke2fs badblocks tune2fs dumpe2fs $(BLKID_PROG) logsave \
 			$(E2IMAGE_PROG) @FSCK_PROG@ e2undo
-USPROGS=	mklost+found filefrag e2freefrag $(UUIDD_PROG) $(E4DEFRAG_PROG)
+USPROGS=	mklost+found filefrag e2freefrag $(UUIDD_PROG) $(E4DEFRAG_PROG) \
+			$(FUSE_PROG)
 SMANPAGES=	tune2fs.8 mklost+found.8 mke2fs.8 dumpe2fs.8 badblocks.8 \
 			e2label.8 $(FINDFS_MAN) $(BLKID_MAN) $(E2IMAGE_MAN) \
 			logsave.8 filefrag.8 e2freefrag.8 e2undo.8 \
@@ -56,6 +59,7 @@ FILEFRAG_OBJS=	filefrag.o
 E2UNDO_OBJS=  e2undo.o
 E4DEFRAG_OBJS=	e4defrag.o
 E2FREEFRAG_OBJS= e2freefrag.o
+FUSE2FS_OBJS=	fuse2fs.o
 
 PROFILED_TUNE2FS_OBJS=	profiled/tune2fs.o profiled/util.o
 PROFILED_MKLPF_OBJS=	profiled/mklost+found.o
@@ -75,6 +79,7 @@ PROFILED_FILEFRAG_OBJS=	profiled/filefrag.o
 PROFILED_E2FREEFRAG_OBJS= profiled/e2freefrag.o
 PROFILED_E2UNDO_OBJS=	profiled/e2undo.o
 PROFILED_E4DEFRAG_OBJS=	profiled/e4defrag.o
+PROFILED_FUSE2FS_OJBS=	profiled/fuse2fs.o
 
 SRCS=	$(srcdir)/tune2fs.c $(srcdir)/mklost+found.c $(srcdir)/mke2fs.c \
 		$(srcdir)/chattr.c $(srcdir)/lsattr.c $(srcdir)/dumpe2fs.c \
@@ -82,7 +87,7 @@ SRCS=	$(srcdir)/tune2fs.c $(srcdir)/mklost+found.c $(srcdir)/mke2fs.c \
 		$(srcdir)/uuidgen.c $(srcdir)/blkid.c $(srcdir)/logsave.c \
 		$(srcdir)/filefrag.c $(srcdir)/base_device.c \
 		$(srcdir)/ismounted.c $(srcdir)/../e2fsck/profile.c \
-		$(srcdir)/e2undo.c $(srcdir)/e2freefrag.c
+		$(srcdir)/e2undo.c $(srcdir)/e2freefrag.c $(srcdir)/fuse2fs.c
 
 LIBS= $(LIBEXT2FS) $(LIBCOM_ERR) 
 DEPLIBS= $(LIBEXT2FS) $(DEPLIBCOM_ERR)
@@ -335,6 +340,12 @@ filefrag.profiled: $(FILEFRAG_OBJS)
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o filefrag.profiled \
 		$(PROFILED_FILEFRAG_OBJS) 
 
+fuse2fs: $(FUSE2FS_OBJS) $(DEPLIBS) $(DEPLIBBLKID) $(DEPLIBUUID) \
+		$(DEPLIBQUOTA) $(LIBEXT2FS)
+	$(E) "	LD $@"
+	$(Q) $(CC) $(ALL_LDFLAGS) -o fuse2fs $(FUSE2FS_OBJS) $(LIBS) \
+		$(LIBFUSE) $(LIBBLKID) $(LIBUUID) $(LIBEXT2FS)
+
 tst_ismounted: $(srcdir)/ismounted.c $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
 	$(E) "	LD $@"
 	$(CC) -o tst_ismounted $(srcdir)/ismounted.c -DDEBUG $(ALL_CFLAGS) \
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
new file mode 100644
index 0000000..8be9070
--- /dev/null
+++ b/misc/fuse2fs.c
@@ -0,0 +1,2967 @@
+/*
+ * fuse2fs.c - FUSE server for e2fsprogs.
+ *
+ * Copyright (C) 2013 Oracle.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+#define _FILE_OFFSET_BITS 64
+#define FUSE_USE_VERSION 29
+#define _GNU_SOURCE
+#include <pthread.h>
+#ifdef __linux__
+# include <linux/fs.h>
+# include <linux/falloc.h>
+# include <linux/xattr.h>
+#endif
+#include <sys/ioctl.h>
+#include <unistd.h>
+#include <fuse.h>
+#include "ext2fs/ext2fs.h"
+#include "ext2fs/ext2_fs.h"
+
+#if FUSE_VERSION >= FUSE_MAKE_VERSION(2, 8)
+# ifdef _IOR
+#  ifdef _IOW
+#   define SUPPORT_I_FLAGS
+#  endif
+# endif
+#endif
+
+#ifdef FALLOC_FL_KEEP_SIZE
+# define FL_KEEP_SIZE_FLAG FALLOC_FL_KEEP_SIZE
+#else
+# define FL_KEEP_SIZE_FLAG (0)
+#endif
+
+#ifdef FALLOC_FL_PUNCH_HOLE
+# define FL_PUNCH_HOLE_FLAG FALLOC_FL_PUNCH_HOLE
+#else
+# define FL_PUNCH_HOLE_FLAG (0)
+#endif
+
+/*
+ * ext2_file_t contains a struct inode, so we can't leave files open.
+ * Use this as a proxy instead.
+ */
+struct fuse2fs_file_handle {
+	ext2_ino_t ino;
+	int open_flags;
+};
+
+/* Main program context */
+struct fuse2fs {
+	ext2_filsys fs;
+	pthread_mutex_t bfl;
+	int panic_on_error;
+	FILE *err_fp;
+	unsigned int next_generation;
+};
+
+static int __translate_error(ext2_filsys fs, errcode_t err, ext2_ino_t ino,
+			     const char *file, int line);
+#define translate_error(fs, ino, err) __translate_error((fs), (err), (ino), \
+			__FILE__, __LINE__)
+
+/* for macosx */
+#ifndef W_OK
+#  define W_OK 2
+#endif
+
+#ifndef R_OK
+#  define R_OK 4
+#endif
+
+#define EXT4_EPOCH_BITS 2
+#define EXT4_EPOCH_MASK ((1 << EXT4_EPOCH_BITS) - 1)
+#define EXT4_NSEC_MASK  (~0UL << EXT4_EPOCH_BITS)
+
+/*
+ * Extended fields will fit into an inode if the filesystem was formatted
+ * with large inodes (-I 256 or larger) and there are not currently any EAs
+ * consuming all of the available space. For new inodes we always reserve
+ * enough space for the kernel's known extended fields, but for inodes
+ * created with an old kernel this might not have been the case. None of
+ * the extended inode fields is critical for correct filesystem operation.
+ * This macro checks if a certain field fits in the inode. Note that
+ * inode-size = GOOD_OLD_INODE_SIZE + i_extra_isize
+ */
+#define EXT4_FITS_IN_INODE(ext4_inode, field)		\
+	((offsetof(typeof(*ext4_inode), field) +	\
+	  sizeof((ext4_inode)->field))			\
+	<= (EXT2_GOOD_OLD_INODE_SIZE +			\
+	    (ext4_inode)->i_extra_isize))		\
+
+static inline __u32 ext4_encode_extra_time(const struct timespec *time)
+{
+	return (sizeof(time->tv_sec) > 4 ?
+		(time->tv_sec >> 32) & EXT4_EPOCH_MASK : 0) |
+	       ((time->tv_nsec << EXT4_EPOCH_BITS) & EXT4_NSEC_MASK);
+}
+
+static inline void ext4_decode_extra_time(struct timespec *time, __u32 extra)
+{
+	if (sizeof(time->tv_sec) > 4)
+		time->tv_sec |= (__u64)((extra) & EXT4_EPOCH_MASK) << 32;
+	time->tv_nsec = ((extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
+}
+
+#define EXT4_INODE_SET_XTIME(xtime, timespec, raw_inode)		       \
+do {									       \
+	(raw_inode)->xtime = (timespec)->tv_sec;			       \
+	if (EXT4_FITS_IN_INODE(raw_inode, xtime ## _extra))		       \
+		(raw_inode)->xtime ## _extra =				       \
+				ext4_encode_extra_time(timespec);	       \
+} while (0)
+
+#define EXT4_EINODE_SET_XTIME(xtime, timespec, raw_inode)		       \
+do {									       \
+	if (EXT4_FITS_IN_INODE(raw_inode, xtime))			       \
+		(raw_inode)->xtime = (timespec)->tv_sec;		       \
+	if (EXT4_FITS_IN_INODE(raw_inode, xtime ## _extra))		       \
+		(raw_inode)->xtime ## _extra =				       \
+				ext4_encode_extra_time(timespec);	       \
+} while (0)
+
+#define EXT4_INODE_GET_XTIME(xtime, timespec, raw_inode)		       \
+do {									       \
+	(timespec)->tv_sec = (signed)((raw_inode)->xtime);		       \
+	if (EXT4_FITS_IN_INODE(raw_inode, xtime ## _extra))		       \
+		ext4_decode_extra_time((timespec),			       \
+				       raw_inode->xtime ## _extra);	       \
+	else								       \
+		(timespec)->tv_nsec = 0;				       \
+} while (0)
+
+#define EXT4_EINODE_GET_XTIME(xtime, timespec, raw_inode)		       \
+do {									       \
+	if (EXT4_FITS_IN_INODE(raw_inode, xtime))			       \
+		(timespec)->tv_sec =					       \
+			(signed)((raw_inode)->xtime);			       \
+	if (EXT4_FITS_IN_INODE(raw_inode, xtime ## _extra))		       \
+		ext4_decode_extra_time((timespec),			       \
+				       raw_inode->xtime ## _extra);	       \
+	else								       \
+		(timespec)->tv_nsec = 0;				       \
+} while (0)
+
+static void get_now(struct timespec *now)
+{
+#ifdef CLOCK_REALTIME
+	if (!clock_gettime(CLOCK_REALTIME, now))
+		return;
+#endif
+
+	now->tv_sec = time(NULL);
+	now->tv_nsec = 0;
+}
+
+static void increment_version(struct ext2_inode_large *inode)
+{
+	__u64 ver;
+
+	ver = inode->osd1.linux1.l_i_version;
+	if (EXT4_FITS_IN_INODE(inode, i_version_hi))
+		ver |= (__u64)inode->i_version_hi << 32;
+	ver++;
+	inode->osd1.linux1.l_i_version = ver;
+	if (EXT4_FITS_IN_INODE(inode, i_version_hi))
+		inode->i_version_hi = ver >> 32;
+}
+
+static void init_times(struct ext2_inode_large *inode)
+{
+	struct timespec now;
+
+	get_now(&now);
+	EXT4_INODE_SET_XTIME(i_atime, &now, inode);
+	EXT4_INODE_SET_XTIME(i_ctime, &now, inode);
+	EXT4_INODE_SET_XTIME(i_mtime, &now, inode);
+	EXT4_EINODE_SET_XTIME(i_crtime, &now, inode);
+	increment_version(inode);
+}
+
+static int update_ctime(ext2_filsys fs, ext2_ino_t ino,
+			struct ext2_inode_large *pinode)
+{
+	errcode_t err;
+	struct timespec now;
+	struct ext2_inode_large inode;
+
+	get_now(&now);
+
+	/* If user already has a inode buffer, just update that */
+	if (pinode) {
+		increment_version(pinode);
+		EXT4_INODE_SET_XTIME(i_ctime, &now, pinode);
+		return 0;
+	}
+
+	/* Otherwise we have to read-modify-write the inode */
+	memset(&inode, 0, sizeof(inode));
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err)
+		return translate_error(fs, ino, err);
+
+	increment_version(&inode);
+	EXT4_INODE_SET_XTIME(i_ctime, &now, &inode);
+
+	err = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err)
+		return translate_error(fs, ino, err);
+
+	return 0;
+}
+
+static int update_atime(ext2_filsys fs, ext2_ino_t ino)
+{
+	errcode_t err;
+	struct ext2_inode_large inode, *pinode;
+	struct timespec atime, mtime, now;
+
+	if (!(fs->flags & EXT2_FLAG_RW))
+		return 0;
+	memset(&inode, 0, sizeof(inode));
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err)
+		return translate_error(fs, ino, err);
+
+	pinode = &inode;
+	EXT4_INODE_GET_XTIME(i_atime, &atime, pinode);
+	EXT4_INODE_GET_XTIME(i_mtime, &mtime, pinode);
+	get_now(&now);
+	/*
+	 * If atime is newer than mtime and atime hasn't been updated in more
+	 * than a day, skip the atime update.  Same idea as Linux "relatime".
+	 */
+	if (atime.tv_sec >= mtime.tv_sec && atime.tv_sec >= now.tv_sec - 86400)
+		return 0;
+	EXT4_INODE_SET_XTIME(i_atime, &now, &inode);
+
+	err = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err)
+		return translate_error(fs, ino, err);
+
+	return 0;
+}
+
+static int update_mtime(ext2_filsys fs, ext2_ino_t ino)
+{
+	errcode_t err;
+	struct ext2_inode_large inode;
+	struct timespec now;
+
+	memset(&inode, 0, sizeof(inode));
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err)
+		return translate_error(fs, ino, err);
+
+	get_now(&now);
+	EXT4_INODE_SET_XTIME(i_mtime, &now, &inode);
+	EXT4_INODE_SET_XTIME(i_ctime, &now, &inode);
+	increment_version(&inode);
+
+	err = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err)
+		return translate_error(fs, ino, err);
+
+	return 0;
+}
+
+static int ext2_file_type(unsigned int mode)
+{
+	if (LINUX_S_ISREG(mode))
+		return EXT2_FT_REG_FILE;
+
+	if (LINUX_S_ISDIR(mode))
+		return EXT2_FT_DIR;
+
+	if (LINUX_S_ISCHR(mode))
+		return EXT2_FT_CHRDEV;
+
+	if (LINUX_S_ISBLK(mode))
+		return EXT2_FT_BLKDEV;
+
+	if (LINUX_S_ISLNK(mode))
+		return EXT2_FT_SYMLINK;
+
+	if (LINUX_S_ISFIFO(mode))
+		return EXT2_FT_FIFO;
+
+	if (LINUX_S_ISSOCK(mode))
+		return EXT2_FT_SOCK;
+
+	return 0;
+}
+
+static int fs_writeable(ext2_filsys fs)
+{
+	return (fs->flags & EXT2_FLAG_RW) && (fs->super->s_error_count == 0);
+}
+
+static int check_inum_access(struct fuse_context *ctxt, ext2_filsys fs,
+			     ext2_ino_t ino, int mask)
+{
+	errcode_t err;
+	struct ext2_inode inode;
+	mode_t perms;
+
+	/* no writing to read-only or broken fs */
+	if ((mask & W_OK) && !fs_writeable(fs))
+		return -EROFS;
+
+	err = ext2fs_read_inode(fs, ino, &inode);
+	if (err)
+		return translate_error(fs, ino, err);
+	perms = inode.i_mode & 0777;
+
+	printf("access ino=%d mask=e%s%s%s perms=0%o uid=%d\n", ino,
+	       (mask & R_OK ? "r" : ""), (mask & W_OK ? "w" : ""),
+	       (mask & X_OK ? "x" : ""), perms, ctxt->uid);
+
+	/* existence check */
+	if (mask == 0)
+		return 0;
+
+	/* is immutable? */
+	if ((mask & W_OK) &&
+	    (inode.i_flags & EXT2_IMMUTABLE_FL))
+		return -EPERM;
+
+	/* Figure out what root's allowed to do */
+	if (ctxt->uid == 0) {
+		/* Non-file access always ok */
+		if (!LINUX_S_ISREG(inode.i_mode))
+			return 0;
+
+		/* R/W access to a file always ok */
+		if (!(mask & X_OK))
+			return 0;
+
+		/* X access to a file ok if a user/group/other can X */
+		if (perms & 0111)
+			return 0;
+
+		/* Trying to execute a file that's not executable. BZZT! */
+		return -EPERM;
+	}
+
+	/* allow owner, if perms match */
+	if (inode.i_uid == ctxt->uid) {
+		if ((mask & (perms >> 6)) == mask)
+			return 0;
+		return -EPERM;
+	}
+
+	/* allow group, if perms match */
+	if (inode.i_gid == ctxt->gid) {
+		if ((mask & (perms >> 3)) == mask)
+			return 0;
+		return -EPERM;
+	}
+
+	/* otherwise check other */
+	if ((mask & perms) == mask)
+		return 0;
+	return -EPERM;
+}
+
+static void op_destroy(void *p)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	errcode_t err;
+
+	if (fs->flags & EXT2_FLAG_RW) {
+		fs->super->s_state |= EXT2_VALID_FS;
+		if (fs->super->s_error_count)
+			fs->super->s_state |= EXT2_ERROR_FS;
+		ext2fs_mark_super_dirty(fs);
+		err = ext2fs_set_gdt_csum(fs);
+		if (err)
+			translate_error(fs, 0, err);
+
+		err = ext2fs_flush2(fs, 0);
+		if (err)
+			translate_error(fs, 0, err);
+	}
+}
+
+static void *op_init(struct fuse_conn_info *conn)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	errcode_t err;
+
+	if (fs->flags & EXT2_FLAG_RW) {
+		fs->super->s_mnt_count++;
+		fs->super->s_mtime = time(NULL);
+		fs->super->s_state &= ~EXT2_VALID_FS;
+		ext2fs_mark_super_dirty(fs);
+		err = ext2fs_flush2(fs, 0);
+		if (err)
+			translate_error(fs, 0, err);
+	}
+	return ff;
+}
+
+static int stat_inode(ext2_filsys fs, ext2_ino_t ino, struct stat *statbuf)
+{
+	struct ext2_inode_large inode;
+	dev_t fakedev = 0;
+	errcode_t err;
+	int ret = 0;
+
+	memset(&inode, 0, sizeof(inode));
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err)
+		return translate_error(fs, ino, err);
+
+	memcpy(&fakedev, fs->super->s_uuid, sizeof(fakedev));
+	statbuf->st_dev = fakedev;
+	statbuf->st_ino = ino;
+	statbuf->st_mode = inode.i_mode;
+	statbuf->st_nlink = inode.i_links_count;
+	statbuf->st_uid = inode.i_uid;
+	statbuf->st_gid = inode.i_gid;
+	statbuf->st_size = inode.i_size;
+	statbuf->st_blksize = fs->blocksize;
+	statbuf->st_blocks = inode.i_blocks;
+	statbuf->st_atime = inode.i_atime;
+	statbuf->st_mtime = inode.i_mtime;
+	statbuf->st_ctime = inode.i_ctime;
+	if (LINUX_S_ISCHR(inode.i_mode) ||
+	    LINUX_S_ISBLK(inode.i_mode)) {
+		if (inode.i_block[0])
+			statbuf->st_rdev = inode.i_block[0];
+		else
+			statbuf->st_rdev = inode.i_block[1];
+	}
+
+	return ret;
+}
+
+static int op_getattr(const char *path, struct stat *statbuf)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	ext2_ino_t ino;
+	errcode_t err;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err) {
+		ret = translate_error(fs, 0, err);
+		goto out;
+	}
+	ret = stat_inode(fs, ino, statbuf);
+out:
+	pthread_mutex_unlock(&ff->bfl);
+	return ret;
+}
+
+static int op_readlink(const char *path, char *buf, size_t len)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	errcode_t err;
+	ext2_ino_t ino;
+	struct ext2_inode inode;
+	unsigned int got;
+	ext2_file_t file;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err || ino == 0) {
+		ret = translate_error(fs, 0, err);
+		goto out;
+	}
+
+	err = ext2fs_read_inode(fs, ino, &inode);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
+
+	if (!LINUX_S_ISLNK(inode.i_mode)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	len--;
+	if (inode.i_size < len)
+		len = inode.i_size;
+	if (ext2fs_inode_data_blocks2(fs, &inode)) {
+		/* big symlink */
+
+		err = ext2fs_file_open(fs, ino, 0, &file);
+		if (err) {
+			ret = translate_error(fs, ino, err);
+			goto out;
+		}
+
+		err = ext2fs_file_read(file, buf, len, &got);
+		if (err || got != len) {
+			ext2fs_file_close(file);
+			ret = translate_error(fs, ino, err);
+			goto out2;
+		}
+
+out2:
+		err = ext2fs_file_close(file);
+		if (ret)
+			goto out;
+		if (err) {
+			ret = translate_error(fs, ino, err);
+			goto out;
+		}
+	} else
+		/* inline symlink */
+		memcpy(buf, (char *)inode.i_block, len);
+	buf[len] = 0;
+
+	if (fs_writeable(fs)) {
+		ret = update_atime(fs, ino);
+		if (ret)
+			goto out;
+	}
+
+out:
+	pthread_mutex_unlock(&ff->bfl);
+	return ret;
+}
+
+static int op_mknod(const char *path, mode_t mode, dev_t dev)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	ext2_ino_t parent, child;
+	char *temp_path = strdup(path);
+	errcode_t err;
+	char *node_name, a;
+	int filetype;
+	struct ext2_inode_large inode;
+	int ret = 0;
+
+	if (!temp_path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	node_name = strrchr(temp_path, '/');
+	if (!node_name) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	node_name++;
+	a = *node_name;
+	*node_name = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, temp_path,
+			   &parent);
+	if (err) {
+		ret = translate_error(fs, 0, err);
+		goto out2;
+	}
+
+	ret = check_inum_access(ctxt, fs, parent, W_OK);
+	if (ret)
+		goto out2;
+
+	*node_name = a;
+
+	if (LINUX_S_ISCHR(mode))
+		filetype = EXT2_FT_CHRDEV;
+	else if (LINUX_S_ISBLK(mode))
+		filetype = EXT2_FT_BLKDEV;
+	else if (LINUX_S_ISFIFO(mode))
+		filetype = EXT2_FT_FIFO;
+	else {
+		ret = -EINVAL;
+		goto out2;
+	}
+
+	err = ext2fs_new_inode(fs, parent, mode, 0, &child);
+	if (err) {
+		ret = translate_error(fs, 0, err);
+		goto out2;
+	}
+
+	err = ext2fs_link(fs, parent, node_name, child, filetype);
+	if (err == EXT2_ET_DIR_NO_SPACE) {
+		err = ext2fs_expand_dir(fs, parent);
+		if (err) {
+			ret = translate_error(fs, parent, err);
+			goto out2;
+		}
+
+		err = ext2fs_link(fs, parent, node_name, child,
+				     filetype);
+	}
+	if (err) {
+		ret = translate_error(fs, parent, err);
+		goto out2;
+	}
+
+	ret = update_mtime(fs, parent);
+	if (ret)
+		goto out2;
+
+	memset(&inode, 0, sizeof(inode));
+	inode.i_mode = mode;
+
+	if (dev & ~0xFFFF)
+		inode.i_block[1] = dev;
+	else
+		inode.i_block[0] = dev;
+	inode.i_links_count = 1;
+	inode.i_extra_isize = sizeof(struct ext2_inode_large) -
+		EXT2_GOOD_OLD_INODE_SIZE;
+
+	err = ext2fs_write_new_inode(fs, child, (struct ext2_inode *)&inode);
+	if (err) {
+		ret = translate_error(fs, child, err);
+		goto out2;
+	}
+
+	inode.i_generation = ff->next_generation++;
+	init_times(&inode);
+	err = ext2fs_write_inode_full(fs, child, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err) {
+		ret = translate_error(fs, child, err);
+		goto out2;
+	}
+
+	ext2fs_inode_alloc_stats2(fs, child, 1, 0);
+
+out2:
+	pthread_mutex_unlock(&ff->bfl);
+out:
+	free(temp_path);
+	return ret;
+}
+
+static int op_mkdir(const char *path, mode_t mode)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	ext2_ino_t parent, child;
+	char *temp_path = strdup(path);
+	errcode_t err;
+	char *node_name, a;
+	struct ext2_inode_large inode;
+	char *block;
+	blk64_t blk;
+	int ret = 0;
+	mode_t parent_sgid;
+
+	if (!temp_path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	node_name = strrchr(temp_path, '/');
+	if (!node_name) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	node_name++;
+	a = *node_name;
+	*node_name = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, temp_path,
+			   &parent);
+	if (err) {
+		ret = translate_error(fs, 0, err);
+		goto out2;
+	}
+
+	ret = check_inum_access(ctxt, fs, parent, W_OK);
+	if (ret)
+		goto out2;
+
+	/* Is the parent dir sgid? */
+	err = ext2fs_read_inode_full(fs, parent, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err) {
+		ret = translate_error(fs, parent, err);
+		goto out2;
+	}
+	parent_sgid = inode.i_mode & S_ISGID;
+
+	*node_name = a;
+
+	err = ext2fs_mkdir(fs, parent, 0, node_name);
+	if (err == EXT2_ET_DIR_NO_SPACE) {
+		err = ext2fs_expand_dir(fs, parent);
+		if (err) {
+			ret = translate_error(fs, parent, err);
+			goto out2;
+		}
+
+		err = ext2fs_mkdir(fs, parent, 0, node_name);
+	}
+	if (err) {
+		ret = translate_error(fs, parent, err);
+		goto out2;
+	}
+
+	ret = update_mtime(fs, parent);
+	if (ret)
+		goto out2;
+
+	/* Still have to update the uid/gid of the dir */
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, temp_path,
+			   &child);
+	if (err) {
+		ret = translate_error(fs, 0, err);
+		goto out2;
+	}
+
+	memset(&inode, 0, sizeof(inode));
+	err = ext2fs_read_inode_full(fs, child, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err) {
+		ret = translate_error(fs, child, err);
+		goto out2;
+	}
+
+	inode.i_uid = ctxt->uid;
+	inode.i_gid = ctxt->gid;
+	inode.i_mode = LINUX_S_IFDIR | (mode & ~(S_ISUID | fs->umask)) |
+		       parent_sgid;
+	inode.i_generation = ff->next_generation++;
+
+	err = ext2fs_write_inode_full(fs, child, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err) {
+		ret = translate_error(fs, child, err);
+		goto out2;
+	}
+
+	/* Rewrite the directory block checksum, having set i_generation */
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		goto out2;
+	err = ext2fs_new_dir_block(fs, child, parent, &block);
+	if (err) {
+		ret = translate_error(fs, child, err);
+		goto out2;
+	}
+	err = ext2fs_bmap2(fs, child, (struct ext2_inode *)&inode, NULL, 0, 0,
+			   NULL, &blk);
+	if (err) {
+		ret = translate_error(fs, child, err);
+		goto out3;
+	}
+	err = ext2fs_write_dir_block4(fs, blk, block, 0, child);
+	if (err) {
+		ret = translate_error(fs, child, err);
+		goto out3;
+	}
+
+out3:
+	ext2fs_free_mem(&block);
+out2:
+	pthread_mutex_unlock(&ff->bfl);
+out:
+	free(temp_path);
+	return ret;
+}
+
+static int unlink_file_by_name(struct fuse_context *ctxt, ext2_filsys fs,
+			       const char *path)
+{
+	errcode_t err;
+	ext2_ino_t dir;
+	char *filename = strdup(path);
+	char *base_name;
+	int ret;
+
+	base_name = strrchr(filename, '/');
+	if (base_name) {
+		*base_name++ = '\0';
+		err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, filename,
+				   &dir);
+		if (err) {
+			free(filename);
+			return translate_error(fs, 0, err);
+		}
+	} else {
+		dir = EXT2_ROOT_INO;
+		base_name = filename;
+	}
+
+	ret = check_inum_access(ctxt, fs, dir, W_OK);
+	if (ret) {
+		free(filename);
+		return ret;
+	}
+
+	err = ext2fs_unlink(fs, dir, base_name, 0, 0);
+	free(filename);
+	if (err)
+		return translate_error(fs, dir, err);
+
+	return update_mtime(fs, dir);
+}
+
+static int release_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
+			       e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
+			       blk64_t ref_block EXT2FS_ATTR((unused)),
+			       int ref_offset EXT2FS_ATTR((unused)),
+			       void *private EXT2FS_ATTR((unused)))
+{
+	blk64_t blk = *blocknr;
+
+	if (blk % EXT2FS_CLUSTER_RATIO(fs) == 0)
+		ext2fs_block_alloc_stats2(fs, *blocknr, -1);
+	return 0;
+}
+
+static int remove_inode(struct fuse2fs *ff, ext2_ino_t ino)
+{
+	ext2_filsys fs = ff->fs;
+	errcode_t err;
+	struct ext2_inode_large inode;
+	int ret = 0;
+
+	memset(&inode, 0, sizeof(inode));
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
+
+	switch (inode.i_links_count) {
+	case 0:
+		return 0; /* XXX: already done? */
+	case 1:
+		inode.i_links_count--;
+		inode.i_dtime = fs->now ? fs->now : time(0);
+		break;
+	default:
+		inode.i_links_count--;
+	}
+
+	ret = update_ctime(fs, ino, &inode);
+	if (ret)
+		goto out;
+
+	err = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
+
+	if (inode.i_links_count)
+		goto out;
+
+	err = ext2fs_free_ext_attr(fs, ino, &inode);
+	if (err)
+		goto out;
+	if (ext2fs_inode_has_valid_blocks2(fs, (struct ext2_inode *)&inode))
+		ext2fs_block_iterate3(fs, ino, BLOCK_FLAG_READ_ONLY, NULL,
+				      release_blocks_proc, NULL);
+	ext2fs_inode_alloc_stats2(fs, ino, -1,
+				  LINUX_S_ISDIR(inode.i_mode));
+out:
+	return ret;
+}
+
+static int __op_unlink(const char *path)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	ext2_ino_t ino;
+	errcode_t err;
+	int ret = 0;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err) {
+		ret = translate_error(fs, 0, err);
+		goto out;
+	}
+
+	ret = unlink_file_by_name(ctxt, fs, path);
+	if (ret)
+		goto out;
+
+	ret = remove_inode(ff, ino);
+	if (ret)
+		goto out;
+out:
+	return ret;
+}
+
+static int op_unlink(const char *path)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	int ret;
+
+	pthread_mutex_lock(&ff->bfl);
+	ret = __op_unlink(path);
+	pthread_mutex_unlock(&ff->bfl);
+	return ret;
+}
+
+struct rd_struct {
+	ext2_ino_t	parent;
+	int		empty;
+};
+
+static int rmdir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
+		      int	entry EXT2FS_ATTR((unused)),
+		      struct ext2_dir_entry *dirent,
+		      int	offset EXT2FS_ATTR((unused)),
+		      int	blocksize EXT2FS_ATTR((unused)),
+		      char	*buf EXT2FS_ATTR((unused)),
+		      void	*private)
+{
+	struct rd_struct *rds = (struct rd_struct *) private;
+
+	if (dirent->inode == 0)
+		return 0;
+	if (((dirent->name_len & 0xFF) == 1) && (dirent->name[0] == '.'))
+		return 0;
+	if (((dirent->name_len & 0xFF) == 2) && (dirent->name[0] == '.') &&
+	    (dirent->name[1] == '.')) {
+		rds->parent = dirent->inode;
+		return 0;
+	}
+	rds->empty = 0;
+	return 0;
+}
+
+static int __op_rmdir(const char *path)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	ext2_ino_t child;
+	errcode_t err;
+	struct ext2_inode inode;
+	struct rd_struct rds;
+	int ret = 0;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &child);
+	if (err) {
+		ret = translate_error(fs, 0, err);
+		goto out;
+	}
+
+	rds.parent = 0;
+	rds.empty = 1;
+
+	err = ext2fs_dir_iterate2(fs, child, 0, 0, rmdir_proc, &rds);
+	if (err) {
+		ret = translate_error(fs, child, err);
+		goto out;
+	}
+
+	if (rds.empty == 0) {
+		ret = -ENOTEMPTY;
+		goto out;
+	}
+
+	ret = unlink_file_by_name(ctxt, fs, path);
+	if (ret)
+		goto out;
+	/* Directories have to be "removed" twice. */
+	ret = remove_inode(ff, child);
+	if (ret)
+		goto out;
+	ret = remove_inode(ff, child);
+	if (ret)
+		goto out;
+
+	if (rds.parent) {
+		err = ext2fs_read_inode(fs, rds.parent, &inode);
+		if (err) {
+			ret = translate_error(fs, rds.parent, err);
+			goto out;
+		}
+		if (inode.i_links_count > 1)
+			inode.i_links_count--;
+		ret = update_mtime(fs, rds.parent);
+		if (ret)
+			goto out;
+		err = ext2fs_write_inode(fs, rds.parent, &inode);
+		if (err) {
+			ret = translate_error(fs, rds.parent, err);
+			goto out;
+		}
+	}
+
+out:
+	return ret;
+}
+
+static int op_rmdir(const char *path)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	int ret;
+
+	pthread_mutex_lock(&ff->bfl);
+	ret = __op_rmdir(path);
+	pthread_mutex_unlock(&ff->bfl);
+	return ret;
+}
+
+static int op_symlink(const char *src, const char *dest)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	ext2_ino_t parent, child;
+	char *temp_path = strdup(dest);
+	errcode_t err;
+	char *node_name, a;
+	struct ext2_inode_large inode;
+	int len = strlen(src);
+	int ret = 0;
+
+	if (!temp_path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	node_name = strrchr(temp_path, '/');
+	if (!node_name) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	node_name++;
+	a = *node_name;
+	*node_name = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, temp_path,
+			   &parent);
+	*node_name = a;
+	if (err) {
+		ret = translate_error(fs, 0, err);
+		goto out2;
+	}
+
+	ret = check_inum_access(ctxt, fs, parent, W_OK);
+	if (ret)
+		goto out2;
+
+
+	/* Create symlink */
+	err = ext2fs_symlink(fs, parent, 0, node_name, (char *)src);
+	if (err == EXT2_ET_DIR_NO_SPACE) {
+		err = ext2fs_expand_dir(fs, parent);
+		if (err) {
+			ret = translate_error(fs, parent, err);
+			goto out2;
+		}
+
+		err = ext2fs_symlink(fs, parent, 0, node_name, (char *)src);
+	}
+	if (err) {
+		ret = translate_error(fs, parent, err);
+		goto out2;
+	}
+
+	/* Update parent dir's mtime */
+	ret = update_mtime(fs, parent);
+	if (ret)
+		goto out2;
+
+	/* Still have to update the uid/gid of the symlink */
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, temp_path,
+			   &child);
+	if (err) {
+		ret = translate_error(fs, 0, err);
+		goto out2;
+	}
+
+	memset(&inode, 0, sizeof(inode));
+	err = ext2fs_read_inode_full(fs, child, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err) {
+		ret = translate_error(fs, child, err);
+		goto out2;
+	}
+
+	inode.i_uid = ctxt->uid;
+	inode.i_gid = ctxt->gid;
+	inode.i_generation = ff->next_generation++;
+
+	err = ext2fs_write_inode_full(fs, child, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err) {
+		ret = translate_error(fs, child, err);
+		goto out2;
+	}
+out2:
+	pthread_mutex_unlock(&ff->bfl);
+out:
+	free(temp_path);
+	return ret;
+}
+
+static int op_rename(const char *from, const char *to)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	errcode_t err;
+	ext2_ino_t from_ino, to_ino, to_dir_ino, from_dir_ino;
+	char *temp_to = NULL, *temp_from = NULL;
+	char *cp, a;
+	struct ext2_inode inode;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, from, &from_ino);
+	if (err || from_ino == 0) {
+		ret = translate_error(fs, 0, err);
+		goto out;
+	}
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, to, &to_ino);
+	if (err && err != EXT2_ET_FILE_NOT_FOUND) {
+		ret = translate_error(fs, 0, err);
+		goto out;
+	}
+
+	if (err == EXT2_ET_FILE_NOT_FOUND)
+		to_ino = 0;
+
+	/* Already the same file? */
+	if (to_ino != 0 && to_ino == from_ino) {
+		ret = 0;
+		goto out;
+	}
+
+	temp_to = strdup(to);
+	if (!temp_to) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	temp_from = strdup(from);
+	if (!temp_from) {
+		ret = -ENOMEM;
+		goto out2;
+	}
+
+	/* Find parent dir of the source and check write access */
+	cp = strrchr(temp_from, '/');
+	if (!cp) {
+		ret = -EINVAL;
+		goto out2;
+	}
+
+	a = *(cp + 1);
+	*(cp + 1) = 0;
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, temp_from,
+			   &from_dir_ino);
+	*(cp + 1) = a;
+	if (err) {
+		ret = translate_error(fs, 0, err);
+		goto out2;
+	}
+	if (from_dir_ino == 0) {
+		ret = -ENOENT;
+		goto out2;
+	}
+
+	ret = check_inum_access(ctxt, fs, from_dir_ino, W_OK);
+	if (ret)
+		goto out2;
+
+	/* Find parent dir of the destination and check write access */
+	cp = strrchr(temp_to, '/');
+	if (!cp) {
+		ret = -EINVAL;
+		goto out2;
+	}
+
+	a = *(cp + 1);
+	*(cp + 1) = 0;
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, temp_to,
+			   &to_dir_ino);
+	*(cp + 1) = a;
+	if (err) {
+		ret = translate_error(fs, 0, err);
+		goto out2;
+	}
+	if (to_dir_ino == 0) {
+		ret = -ENOENT;
+		goto out2;
+	}
+
+	ret = check_inum_access(ctxt, fs, to_dir_ino, W_OK);
+	if (ret)
+		goto out2;
+
+	/* If the target exists, unlink it first */
+	if (to_ino != 0) {
+		err = ext2fs_read_inode(fs, to_ino, &inode);
+		if (err) {
+			ret = translate_error(fs, to_ino, err);
+			goto out2;
+		}
+
+		if (LINUX_S_ISDIR(inode.i_mode))
+			ret = __op_rmdir(to);
+		else
+			ret = __op_unlink(to);
+		if (ret)
+			goto out2;
+	}
+
+	/* Get ready to do the move */
+	err = ext2fs_read_inode(fs, from_ino, &inode);
+	if (err) {
+		ret = translate_error(fs, from_ino, err);
+		goto out2;
+	}
+
+	/* Link in the new file */
+	err = ext2fs_link(fs, to_dir_ino, cp + 1, from_ino,
+			  ext2_file_type(inode.i_mode));
+	if (err == EXT2_ET_DIR_NO_SPACE) {
+		err = ext2fs_expand_dir(fs, to_dir_ino);
+		if (err) {
+			ret = translate_error(fs, to_dir_ino, err);
+			goto out2;
+		}
+
+		err = ext2fs_link(fs, to_dir_ino, cp + 1, from_ino,
+				     ext2_file_type(inode.i_mode));
+	}
+	if (err) {
+		ret = translate_error(fs, to_dir_ino, err);
+		goto out2;
+	}
+
+	ret = update_ctime(fs, from_ino, NULL);
+	if (ret)
+		goto out2;
+
+	ret = update_mtime(fs, to_dir_ino);
+	if (ret)
+		goto out2;
+
+	/* Remove the old file */
+	ret = unlink_file_by_name(ctxt, fs, from);
+	if (ret)
+		goto out2;
+
+	/* Flush the whole mess out */
+	err = ext2fs_flush2(fs, 0);
+	if (err)
+		ret = translate_error(fs, 0, err);
+
+out2:
+	free(temp_from);
+	free(temp_to);
+out:
+	pthread_mutex_unlock(&ff->bfl);
+	return ret;
+}
+
+static int op_link(const char *src, const char *dest)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	char *temp_path = strdup(dest);
+	errcode_t err;
+	char *node_name, a;
+	ext2_ino_t parent, ino;
+	struct ext2_inode_large inode;
+	int ret = 0;
+
+	if (!temp_path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	node_name = strrchr(temp_path, '/');
+	if (!node_name) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	node_name++;
+	a = *node_name;
+	*node_name = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, temp_path,
+			   &parent);
+	*node_name = a;
+	if (err) {
+		err = -ENOENT;
+		goto out2;
+	}
+
+	ret = check_inum_access(ctxt, fs, parent, W_OK);
+	if (ret)
+		goto out2;
+
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, src, &ino);
+	if (err || ino == 0) {
+		ret = translate_error(fs, 0, err);
+		goto out2;
+	}
+
+	memset(&inode, 0, sizeof(inode));
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out2;
+	}
+
+	inode.i_links_count++;
+	ret = update_ctime(fs, ino, &inode);
+	if (ret)
+		goto out2;
+
+	err = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out2;
+	}
+
+	err = ext2fs_link(fs, parent, node_name, ino,
+			  ext2_file_type(inode.i_mode));
+	if (err == EXT2_ET_DIR_NO_SPACE) {
+		err = ext2fs_expand_dir(fs, parent);
+		if (err) {
+			ret = translate_error(fs, parent, err);
+			goto out2;
+		}
+
+		err = ext2fs_link(fs, parent, node_name, ino,
+				     ext2_file_type(inode.i_mode));
+	}
+	if (err) {
+		ret = translate_error(fs, parent, err);
+		goto out2;
+	}
+
+	ret = update_mtime(fs, parent);
+	if (ret)
+		goto out2;
+
+out2:
+	pthread_mutex_unlock(&ff->bfl);
+out:
+	free(temp_path);
+	return ret;
+}
+
+static int op_chmod(const char *path, mode_t mode)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	errcode_t err;
+	ext2_ino_t ino;
+	struct ext2_inode_large inode;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err) {
+		ret = translate_error(fs, 0, err);
+		goto out;
+	}
+
+	memset(&inode, 0, sizeof(inode));
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
+
+	if (ctxt->uid != 0 && ctxt->uid != inode.i_uid) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	/*
+	 * XXX: We should really check that the inode gid is not in /any/
+	 * of the user's groups, but FUSE only tells us about the primary
+	 * group.
+	 */
+	if (ctxt->uid != 0 && ctxt->gid != inode.i_gid)
+		mode &= ~S_ISGID;
+
+	inode.i_mode &= ~0xFFF;
+	inode.i_mode |= mode & 0xFFF;
+	ret = update_ctime(fs, ino, &inode);
+	if (ret)
+		goto out;
+
+	err = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
+
+out:
+	pthread_mutex_unlock(&ff->bfl);
+	return ret;
+}
+
+static int op_chown(const char *path, uid_t owner, gid_t group)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	errcode_t err;
+	ext2_ino_t ino;
+	struct ext2_inode_large inode;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err) {
+		ret = translate_error(fs, 0, err);
+		goto out;
+	}
+
+	memset(&inode, 0, sizeof(inode));
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
+
+	/* FUSE seems to feed us ~0 to mean "don't change" */
+	if (owner != ~0) {
+		/* Only root gets to change UID. */
+		if (ctxt->uid != 0 &&
+		    !(inode.i_uid == ctxt->uid && owner == ctxt->uid)) {
+			ret = -EPERM;
+			goto out;
+		}
+		inode.i_uid = owner;
+	}
+
+	if (group != ~0) {
+		/* Only root or the owner get to change GID. */
+		if (ctxt->uid != 0 && inode.i_uid != ctxt->uid) {
+			ret = -EPERM;
+			goto out;
+		}
+
+		/* XXX: We /should/ check group membership but FUSE */
+		inode.i_gid = group;
+	}
+
+	ret = update_ctime(fs, ino, &inode);
+	if (ret)
+		goto out;
+
+	err = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
+
+out:
+	pthread_mutex_unlock(&ff->bfl);
+	return ret;
+}
+
+static int op_truncate(const char *path, off_t len)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	errcode_t err;
+	ext2_ino_t ino;
+	ext2_file_t file;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err || ino == 0) {
+		ret = translate_error(fs, 0, err);
+		goto out;
+	}
+
+	ret = check_inum_access(ctxt, fs, ino, W_OK);
+	if (ret)
+		goto out;
+
+	err = ext2fs_file_open(fs, ino, EXT2_FILE_WRITE, &file);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
+
+	err = ext2fs_file_set_size2(file, len);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out2;
+	}
+
+out2:
+	err = ext2fs_file_close(file);
+	if (ret)
+		goto out;
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
+
+	ret = update_mtime(fs, ino);
+
+out:
+	pthread_mutex_unlock(&ff->bfl);
+	return err;
+}
+
+#ifdef __linux__
+void detect_linux_executable_open(int kernel_flags, int *access_check,
+				  int *e2fs_open_flags)
+{
+	/*
+	 * On Linux, execve will bleed __FMODE_EXEC into the file mode flags,
+	 * and FUSE is more than happy to let that slip through.
+	 */
+	if (kernel_flags & 0x20) {
+		*access_check = X_OK;
+		*e2fs_open_flags &= ~EXT2_FILE_WRITE;
+	}
+}
+#else
+void detect_linux_executable_open(int kernel_flags, int *access_check,
+				  int *e2fs_open_flags)
+{
+	/* empty */
+}
+#endif /* __linux__ */
+
+static int __op_open(const char *path, struct fuse_file_info *fp)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	errcode_t err;
+	ext2_ino_t ino;
+	struct fuse2fs_file_handle *file;
+	int check, ret = 0;
+
+	file = calloc(1, sizeof(*file));
+	if (!file)
+		return -ENOMEM;
+
+	file->open_flags = 0;
+	switch (fp->flags & O_ACCMODE) {
+	case O_RDONLY:
+		check = R_OK;
+		break;
+	case O_WRONLY:
+		check = W_OK;
+		file->open_flags |= EXT2_FILE_WRITE;
+		break;
+	case O_RDWR:
+		check = R_OK | W_OK;
+		file->open_flags |= EXT2_FILE_WRITE;
+		break;
+	}
+
+	detect_linux_executable_open(fp->flags, &check, &file->open_flags);
+
+	if (fp->flags & O_CREAT)
+		file->open_flags |= EXT2_FILE_CREATE;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &file->ino);
+	if (err || file->ino == 0) {
+		ret = translate_error(fs, 0, err);
+		goto out;
+	}
+
+	ret = check_inum_access(ctxt, fs, file->ino, check);
+	if (ret) {
+		/*
+		 * In a regular (Linux) fs driver, the kernel will open
+		 * binaries for reading if the user has --x privileges (i.e.
+		 * execute without read).  Since the kernel doesn't have any
+		 * way to tell us if it's opening a file via execve, we'll
+		 * just assume that allowing access is ok if asking for ro mode
+		 * fails but asking for x mode succeeds.  Of course we can
+		 * also employ undocumented hacks (see above).
+		 */
+		if (check == R_OK) {
+			ret = check_inum_access(ctxt, fs, file->ino, X_OK);
+			if (ret)
+				goto out;
+		} else
+			goto out;
+	}
+	fp->fh = (uint64_t)file;
+
+out:
+	if (ret)
+		free(file);
+	return ret;
+}
+
+static int op_open(const char *path, struct fuse_file_info *fp)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	int ret;
+
+	pthread_mutex_lock(&ff->bfl);
+	ret = __op_open(path, fp);
+	pthread_mutex_unlock(&ff->bfl);
+	return ret;
+}
+
+static int op_read(const char *path, char *buf, size_t len, off_t offset,
+		     struct fuse_file_info *fp)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	struct fuse2fs_file_handle *fh = (struct fuse2fs_file_handle *)fp->fh;
+	ext2_file_t efp;
+	errcode_t err;
+	unsigned int got;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	err = ext2fs_file_open(fs, fh->ino, fh->open_flags, &efp);
+	if (err) {
+		ret = translate_error(fs, fh->ino, err);
+		goto out;
+	}
+
+	err = ext2fs_file_llseek(efp, offset, SEEK_SET, NULL);
+	if (err) {
+		ret = translate_error(fs, fh->ino, err);
+		goto out2;
+	}
+
+	err = ext2fs_file_read(efp, buf, len, &got);
+	if (err) {
+		ret = translate_error(fs, fh->ino, err);
+		goto out2;
+	}
+
+out2:
+	err = ext2fs_file_close(efp);
+	if (ret)
+		goto out;
+	if (err) {
+		ret = translate_error(fs, fh->ino, err);
+		goto out;
+	}
+
+	if (fs_writeable(fs)) {
+		ret = update_atime(fs, fh->ino);
+		if (ret)
+			goto out;
+	}
+out:
+	pthread_mutex_unlock(&ff->bfl);
+	return got ? got : ret;
+}
+
+static int op_write(const char *path, const char *buf, size_t len, off_t offset,
+		      struct fuse_file_info *fp)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	struct fuse2fs_file_handle *fh = (struct fuse2fs_file_handle *)fp->fh;
+	ext2_file_t efp;
+	errcode_t err;
+	unsigned int got;
+	__u64 fsize;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	if (!fs_writeable(fs)) {
+		ret = -EROFS;
+		goto out;
+	}
+
+	err = ext2fs_file_open(fs, fh->ino, fh->open_flags, &efp);
+	if (err) {
+		ret = translate_error(fs, fh->ino, err);
+		goto out;
+	}
+
+	err = ext2fs_file_llseek(efp, offset, SEEK_SET, NULL);
+	if (err) {
+		ret = translate_error(fs, fh->ino, err);
+		goto out2;
+	}
+
+	err = ext2fs_file_write(efp, buf, len, &got);
+	if (err) {
+		ret = translate_error(fs, fh->ino, err);
+		goto out2;
+	}
+
+	err = ext2fs_file_flush(efp);
+	if (err) {
+		got = 0;
+		ret = translate_error(fs, fh->ino, err);
+		goto out2;
+	}
+
+out2:
+	err = ext2fs_file_close(efp);
+	if (ret)
+		goto out;
+	if (err) {
+		ret = translate_error(fs, fh->ino, err);
+		goto out;
+	}
+
+	ret = update_mtime(fs, fh->ino);
+	if (ret)
+		goto out;
+
+out:
+	pthread_mutex_unlock(&ff->bfl);
+	return got ? got : ret;
+}
+
+static int op_release(const char *path, struct fuse_file_info *fp)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	struct fuse2fs_file_handle *fh = (struct fuse2fs_file_handle *)fp->fh;
+	errcode_t err;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	if (fs_writeable(fs) && fh->open_flags & EXT2_FILE_WRITE) {
+		err = ext2fs_flush2(fs, EXT2_FLAG_FLUSH_NO_SYNC);
+		if (err)
+			ret = translate_error(fs, fh->ino, err);
+	}
+	fp->fh = 0;
+	pthread_mutex_unlock(&ff->bfl);
+
+	free(fh);
+
+	return ret;
+}
+
+static int op_fsync(const char *path, int datasync, struct fuse_file_info *fp)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	struct fuse2fs_file_handle *fh = (struct fuse2fs_file_handle *)fp->fh;
+	errcode_t err;
+	int ret = 0;
+
+	/* For now, flush everything, even if it's slow */
+	pthread_mutex_lock(&ff->bfl);
+	if (fs_writeable(fs) && fh->open_flags & EXT2_FILE_WRITE) {
+		err = ext2fs_flush2(fs, 0);
+		if (err)
+			ret = translate_error(fs, fh->ino, err);
+	}
+	pthread_mutex_unlock(&ff->bfl);
+
+	return ret;
+}
+
+static int op_statfs(const char *path, struct statvfs *buf)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	uint64_t fsid, *f;
+
+	buf->f_bsize = fs->blocksize;
+	buf->f_frsize = 0;
+	buf->f_blocks = fs->super->s_blocks_count;
+	buf->f_bfree = fs->super->s_free_blocks_count;
+	if (fs->super->s_free_blocks_count < fs->super->s_r_blocks_count)
+		buf->f_bavail = 0;
+	else
+		buf->f_bavail = fs->super->s_free_blocks_count -
+				fs->super->s_r_blocks_count;
+	buf->f_files = fs->super->s_inodes_count;
+	buf->f_ffree = fs->super->s_free_inodes_count;
+	buf->f_favail = fs->super->s_free_inodes_count;
+	f = (uint64_t *)fs->super->s_uuid;
+	fsid = *f;
+	f++;
+	fsid ^= *f;
+	buf->f_fsid = fsid;
+	buf->f_flag = 0;
+	if (fs->flags & EXT2_FLAG_RW)
+		buf->f_flag |= ST_RDONLY;
+	buf->f_namemax = EXT2_NAME_LEN;
+
+	return 0;
+}
+
+static int op_getxattr(const char *path, const char *key, char *value,
+		       size_t len)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	struct ext2_xattr_handle *h;
+	void *ptr;
+	unsigned int plen;
+	ext2_ino_t ino;
+	errcode_t err;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
+				     EXT2_FEATURE_COMPAT_EXT_ATTR)) {
+		ret = -ENOTSUP;
+		goto out;
+	}
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err || ino == 0) {
+		ret = translate_error(fs, 0, err);
+		goto out;
+	}
+
+	ret = check_inum_access(ctxt, fs, ino, R_OK);
+	if (ret)
+		goto out;
+
+	err = ext2fs_xattrs_open(fs, ino, &h);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
+
+	err = ext2fs_xattrs_read(h);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out2;
+	}
+
+	err = ext2fs_xattr_get(h, key, &ptr, &plen);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out2;
+	}
+
+	if (!len) {
+		ret = plen;
+	} else if (len < plen) {
+		ret = -ERANGE;
+	} else {
+		memcpy(value, ptr, plen);
+		ret = plen;
+	}
+
+	ext2fs_free_mem(&ptr);
+out2:
+	err = ext2fs_xattrs_close(&h);
+	if (err)
+		ret = translate_error(fs, ino, err);
+out:
+	pthread_mutex_unlock(&ff->bfl);
+
+	return ret;
+}
+
+static int count_buffer_space(char *name, char *value, size_t value_len,
+			      void *data)
+{
+	unsigned int *x = data;
+
+	*x = *x + strlen(name) + 1;
+	return 0;
+}
+
+static int copy_names(char *name, char *value, size_t value_len, void *data)
+{
+	char **b = data;
+
+	strncpy(*b, name, strlen(name));
+	*b = *b + strlen(name) + 1;
+
+	return 0;
+}
+
+static int op_listxattr(const char *path, char *names, size_t len)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	struct ext2_xattr_handle *h;
+	unsigned int bufsz;
+	ext2_ino_t ino;
+	errcode_t err;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
+				     EXT2_FEATURE_COMPAT_EXT_ATTR)) {
+		ret = -ENOTSUP;
+		goto out;
+	}
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err || ino == 0) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
+
+	ret = check_inum_access(ctxt, fs, ino, R_OK);
+	if (ret)
+		goto out2;
+
+	err = ext2fs_xattrs_open(fs, ino, &h);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
+
+	err = ext2fs_xattrs_read(h);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out2;
+	}
+
+	/* Count buffer space needed for names */
+	bufsz = 0;
+	err = ext2fs_xattrs_iterate(h, count_buffer_space, &bufsz);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out2;
+	}
+
+	if (len == 0) {
+		ret = bufsz;
+		goto out2;
+	} else if (len < bufsz) {
+		ret = -ERANGE;
+		goto out2;
+	}
+
+	/* Copy names out */
+	memset(names, 0, len);
+	err = ext2fs_xattrs_iterate(h, copy_names, &names);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out2;
+	}
+	ret = bufsz;
+out2:
+	err = ext2fs_xattrs_close(&h);
+	if (err)
+		ret = translate_error(fs, ino, err);
+out:
+	pthread_mutex_unlock(&ff->bfl);
+
+	return ret;
+}
+
+static int op_setxattr(const char *path, const char *key, const char *value,
+		       size_t len, int flags)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	struct ext2_xattr_handle *h;
+	ext2_ino_t ino;
+	errcode_t err;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
+				     EXT2_FEATURE_COMPAT_EXT_ATTR)) {
+		ret = -ENOTSUP;
+		goto out;
+	}
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err || ino == 0) {
+		ret = translate_error(fs, 0, err);
+		goto out;
+	}
+
+	ret = check_inum_access(ctxt, fs, ino, W_OK);
+	if (ret)
+		goto out;
+
+	err = ext2fs_xattrs_open(fs, ino, &h);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
+
+	err = ext2fs_xattrs_read(h);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out2;
+	}
+
+	err = ext2fs_xattr_set(h, key, value, len);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out2;
+	}
+
+	err = ext2fs_xattrs_write(h);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out2;
+	}
+
+	ret = update_ctime(fs, ino, NULL);
+out2:
+	err = ext2fs_xattrs_close(&h);
+	if (!ret && err)
+		ret = translate_error(fs, ino, err);
+out:
+	pthread_mutex_unlock(&ff->bfl);
+
+	return ret;
+}
+
+static int op_removexattr(const char *path, const char *key)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	struct ext2_xattr_handle *h;
+	ext2_ino_t ino;
+	errcode_t err;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
+				     EXT2_FEATURE_COMPAT_EXT_ATTR)) {
+		ret = -ENOTSUP;
+		goto out;
+	}
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err || ino == 0) {
+		ret = translate_error(fs, 0, err);
+		goto out;
+	}
+
+	ret = check_inum_access(ctxt, fs, ino, W_OK);
+	if (ret)
+		goto out;
+
+	err = ext2fs_xattrs_open(fs, ino, &h);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
+
+	err = ext2fs_xattrs_read(h);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out2;
+	}
+
+	err = ext2fs_xattr_remove(h, key);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out2;
+	}
+
+	err = ext2fs_xattrs_write(h);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out2;
+	}
+
+	ret = update_ctime(fs, ino, NULL);
+out2:
+	err = ext2fs_xattrs_close(&h);
+	if (err)
+		ret = translate_error(fs, ino, err);
+out:
+	pthread_mutex_unlock(&ff->bfl);
+
+	return ret;
+}
+
+struct readdir_iter {
+	void *buf;
+	fuse_fill_dir_t func;
+};
+
+static int op_readdir_iter(ext2_ino_t dir, int entry,
+			   struct ext2_dir_entry *dirent, int offset,
+			   int blocksize, char *buf, void *data)
+{
+	struct readdir_iter *i = data;
+	struct stat statbuf;
+	char namebuf[EXT2_NAME_LEN + 1];
+	int ret;
+
+	memcpy(namebuf, dirent->name, dirent->name_len & 0xFF);
+	namebuf[dirent->name_len & 0xFF] = 0;
+	statbuf.st_ino = dirent->inode;
+	statbuf.st_mode = S_IFREG;
+	ret = i->func(i->buf, namebuf, NULL, 0);
+	if (ret)
+		return DIRENT_ABORT;
+
+	return 0;
+}
+
+static int op_readdir(const char *path, void *buf, fuse_fill_dir_t fill_func,
+		      off_t offset, struct fuse_file_info *fp)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	struct fuse2fs_file_handle *fh = (struct fuse2fs_file_handle *)fp->fh;
+	errcode_t err;
+	ext2_ino_t ino;
+	struct readdir_iter i;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	i.buf = buf;
+	i.func = fill_func;
+	err = ext2fs_dir_iterate2(fs, fh->ino, 0, NULL, op_readdir_iter, &i);
+	if (err) {
+		ret = translate_error(fs, fh->ino, err);
+		goto out;
+	}
+
+	if (fs_writeable(fs)) {
+		ret = update_atime(fs, fh->ino);
+		if (ret)
+			goto out;
+	}
+out:
+	pthread_mutex_unlock(&ff->bfl);
+	return ret;
+}
+
+static int op_access(const char *path, int mask)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	errcode_t err;
+	ext2_ino_t ino;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err || ino == 0) {
+		ret = translate_error(fs, 0, err);
+		goto out;
+	}
+
+	ret = check_inum_access(ctxt, fs, ino, mask);
+	if (ret)
+		goto out;
+
+out:
+	pthread_mutex_unlock(&ff->bfl);
+	return ret;
+}
+
+static int op_create(const char *path, mode_t mode, struct fuse_file_info *fp)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	struct ext3_extent_header *eh;
+	ext2_ino_t parent, child;
+	char *temp_path = strdup(path);
+	errcode_t err;
+	char *node_name, a;
+	int filetype, i;
+	struct ext2_inode_large inode;
+	int ret = 0;
+
+	if (!temp_path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	node_name = strrchr(temp_path, '/');
+	if (!node_name) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	node_name++;
+	a = *node_name;
+	*node_name = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, temp_path,
+			   &parent);
+	if (err) {
+		ret = translate_error(fs, 0, err);
+		goto out2;
+	}
+
+	ret = check_inum_access(ctxt, fs, parent, W_OK);
+	if (ret)
+		goto out2;
+
+	*node_name = a;
+
+	filetype = ext2_file_type(mode);
+
+	err = ext2fs_new_inode(fs, parent, mode, 0, &child);
+	if (err) {
+		ret = translate_error(fs, parent, err);
+		goto out2;
+	}
+
+	err = ext2fs_link(fs, parent, node_name, child, filetype);
+	if (err == EXT2_ET_DIR_NO_SPACE) {
+		err = ext2fs_expand_dir(fs, parent);
+		if (err) {
+			ret = translate_error(fs, parent, err);
+			goto out2;
+		}
+
+		err = ext2fs_link(fs, parent, node_name, child,
+				     filetype);
+	}
+	if (err) {
+		ret = translate_error(fs, parent, err);
+		goto out2;
+	}
+
+	ret = update_mtime(fs, parent);
+	if (ret)
+		goto out2;
+
+	memset(&inode, 0, sizeof(inode));
+	inode.i_mode = mode;
+	inode.i_links_count = 1;
+	inode.i_extra_isize = sizeof(struct ext2_inode_large) -
+		EXT2_GOOD_OLD_INODE_SIZE;
+	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {
+		inode.i_flags = EXT4_EXTENTS_FL;
+
+		/* This must be initialized, even for a zero byte file. */
+		eh = (struct ext3_extent_header *) &inode.i_block[0];
+		eh->eh_magic = ext2fs_cpu_to_le16(EXT3_EXT_MAGIC);
+		eh->eh_depth = 0;
+		eh->eh_entries = 0;
+		i = (sizeof(inode.i_block) - sizeof(*eh)) /
+			sizeof(struct ext3_extent);
+		eh->eh_max = ext2fs_cpu_to_le16(i);
+	}
+
+	err = ext2fs_write_new_inode(fs, child, (struct ext2_inode *)&inode);
+	if (err) {
+		ret = translate_error(fs, child, err);
+		goto out2;
+	}
+
+	inode.i_generation = ff->next_generation++;
+	init_times(&inode);
+	err = ext2fs_write_inode_full(fs, child, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err) {
+		ret = translate_error(fs, child, err);
+		goto out2;
+	}
+
+	ext2fs_inode_alloc_stats2(fs, child, 1, 0);
+
+	ret = __op_open(path, fp);
+	if (ret)
+		goto out2;
+out2:
+	pthread_mutex_unlock(&ff->bfl);
+out:
+	free(temp_path);
+	return ret;
+}
+
+static int op_ftruncate(const char *path, off_t len, struct fuse_file_info *fp)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	struct fuse2fs_file_handle *fh = (struct fuse2fs_file_handle *)fp->fh;
+	ext2_file_t efp;
+	errcode_t err;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	if (!fs_writeable(fs)) {
+		ret = -EROFS;
+		goto out;
+	}
+
+	err = ext2fs_file_open(fs, fh->ino, fh->open_flags, &efp);
+	if (err) {
+		ret = translate_error(fs, fh->ino, err);
+		goto out;
+	}
+
+	err = ext2fs_file_set_size2(efp, len);
+	if (err) {
+		ret = translate_error(fs, fh->ino, err);
+		goto out2;
+	}
+
+out2:
+	err = ext2fs_file_close(efp);
+	if (ret)
+		goto out;
+	if (err) {
+		ret = translate_error(fs, fh->ino, err);
+		goto out;
+	}
+
+	ret = update_mtime(fs, fh->ino);
+	if (ret)
+		goto out;
+
+out:
+	pthread_mutex_unlock(&ff->bfl);
+	return 0;
+}
+
+static int op_fgetattr(const char *path, struct stat *statbuf,
+		       struct fuse_file_info *fp)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	struct fuse2fs_file_handle *fh = (struct fuse2fs_file_handle *)fp->fh;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	ret = stat_inode(fs, fh->ino, statbuf);
+	pthread_mutex_unlock(&ff->bfl);
+
+	return ret;
+}
+
+static int op_utimens(const char *path, const struct timespec tv[2])
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	errcode_t err;
+	ext2_ino_t ino;
+	struct ext2_inode_large inode;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err) {
+		ret = translate_error(fs, 0, err);
+		goto out;
+	}
+
+	ret = check_inum_access(ctxt, fs, ino, W_OK);
+	if (ret)
+		goto out;
+
+	memset(&inode, 0, sizeof(inode));
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
+
+	EXT4_INODE_SET_XTIME(i_atime, tv, &inode);
+	EXT4_INODE_SET_XTIME(i_mtime, tv + 1, &inode);
+	ret = update_ctime(fs, ino, &inode);
+	if (ret)
+		goto out;
+
+	err = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
+
+out:
+	pthread_mutex_unlock(&ff->bfl);
+	return 0;
+}
+
+#ifdef SUPPORT_I_FLAGS
+static int ioctl_getflags(ext2_filsys fs, struct fuse2fs_file_handle *fh,
+			  void *data)
+{
+	errcode_t err;
+	struct ext2_inode_large inode;
+
+	memset(&inode, 0, sizeof(inode));
+	err = ext2fs_read_inode_full(fs, fh->ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err)
+		return translate_error(fs, fh->ino, err);
+
+	*(__u32 *)data = inode.i_flags & EXT2_FL_USER_VISIBLE;
+	return 0;
+}
+
+#define FUSE2FS_MODIFIABLE_IFLAGS \
+	(EXT2_IMMUTABLE_FL | EXT2_APPEND_FL | EXT2_NODUMP_FL | \
+	 EXT2_NOATIME_FL | EXT3_JOURNAL_DATA_FL | EXT2_DIRSYNC_FL | \
+	 EXT2_TOPDIR_FL)
+
+static int ioctl_setflags(ext2_filsys fs, struct fuse2fs_file_handle *fh,
+			  void *data)
+{
+	errcode_t err;
+	struct ext2_inode_large inode;
+	int ret;
+	__u32 flags = *(__u32 *)data;
+	struct fuse_context *ctxt = fuse_get_context();
+
+	memset(&inode, 0, sizeof(inode));
+	err = ext2fs_read_inode_full(fs, fh->ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err)
+		return translate_error(fs, fh->ino, err);
+
+	if (ctxt->uid != 0 && inode.i_uid != ctxt->uid)
+		return -EPERM;
+
+	if ((inode.i_flags ^ flags) & ~FUSE2FS_MODIFIABLE_IFLAGS)
+		return -EINVAL;
+
+	inode.i_flags = inode.i_flags & ~FUSE2FS_MODIFIABLE_IFLAGS |
+			flags & FUSE2FS_MODIFIABLE_IFLAGS;
+
+	err = ext2fs_write_inode_full(fs, fh->ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err)
+		return translate_error(fs, fh->ino, err);
+
+	return 0;
+}
+#endif /* SUPPORT_I_FLAGS */
+
+#if FUSE_VERSION >= FUSE_MAKE_VERSION(2, 8)
+static int op_ioctl(const char *path, int cmd, void *arg,
+		      struct fuse_file_info *fp, unsigned int flags, void *data)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	struct fuse2fs_file_handle *fh = (struct fuse2fs_file_handle *)fp->fh;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	switch (cmd) {
+#ifdef SUPPORT_I_FLAGS
+	case EXT2_IOC_GETFLAGS:
+		ret = ioctl_getflags(fs, fh, data);
+		break;
+	case EXT2_IOC_SETFLAGS:
+		ret = ioctl_setflags(fs, fh, data);
+		break;
+#endif
+	default:
+		ret = -ENOTTY;
+	}
+	pthread_mutex_unlock(&ff->bfl);
+
+	return ret;
+}
+#endif /* FUSE 28 */
+
+static int op_bmap(const char *path, size_t blocksize, uint64_t *idx)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	ext2_ino_t ino;
+	errcode_t err;
+	int ret = 0;
+
+	pthread_mutex_lock(&ff->bfl);
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err) {
+		ret = translate_error(fs, 0, err);
+		goto out;
+	}
+
+	err = ext2fs_bmap2(fs, ino, NULL, NULL, 0, *idx, 0, (blk64_t *)idx);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
+
+out:
+	pthread_mutex_unlock(&ff->bfl);
+	return ret;
+}
+
+#if FUSE_VERSION >= FUSE_MAKE_VERSION(2, 9)
+static int fallocate_helper(struct fuse_file_info *fp, int mode, off_t offset,
+			    off_t len)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	struct fuse2fs_file_handle *fh = (struct fuse2fs_file_handle *)fp->fh;
+	blk64_t blk, end, x;
+	__u64 fsize;
+	ext2_file_t efp;
+	errcode_t err;
+	int ret = 0;
+
+	/* Allocate a bunch of blocks */
+	end = (offset + len - 1) / fs->blocksize;
+	for (blk = offset / fs->blocksize; blk <= end; blk++) {
+		err = ext2fs_bmap2(fs, fh->ino, NULL, NULL, BMAP_ALLOC, blk,
+				   0, &x);
+		if (err)
+			return translate_error(fs, fh->ino, err);
+	}
+
+	/* Update i_size */
+	if (!(mode & FL_KEEP_SIZE_FLAG)) {
+		err = ext2fs_file_open(fs, fh->ino, fh->open_flags, &efp);
+		if (err)
+			return translate_error(fs, fh->ino, err);
+
+		err = ext2fs_file_get_lsize(efp, &fsize);
+		if (err) {
+			ret = translate_error(fs, fh->ino, err);
+			goto out_isize;
+		}
+		if (offset + len > fsize) {
+			fsize = offset + len;
+			err = ext2fs_file_set_size2(efp, fsize);
+			if (err) {
+				ret = translate_error(fs, fh->ino, err);
+				goto out_isize;
+			}
+		}
+
+out_isize:
+		err = ext2fs_file_close(efp);
+		if (ret)
+			return ret;
+		if (err)
+			return translate_error(fs, fh->ino, err);
+	}
+
+	return update_mtime(fs, fh->ino);
+}
+
+static int punch_helper(struct fuse_file_info *fp, int mode, off_t offset,
+			off_t len)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	struct fuse2fs_file_handle *fh = (struct fuse2fs_file_handle *)fp->fh;
+	blk64_t blk, start, end, x;
+	__u64 fsize;
+	ext2_file_t efp;
+	errcode_t err;
+	int ret = 0;
+
+	/* kernel ext4 punch requires this flag to be set */
+	if (!(mode & FL_KEEP_SIZE_FLAG))
+		return -EINVAL;
+
+	if (len < fs->blocksize)
+		return 0;
+
+	/* Punch out a bunch of blocks */
+	start = (offset + fs->blocksize - 1) / fs->blocksize;
+	end = (offset + len - fs->blocksize) / fs->blocksize;
+
+	if (start > end)
+		return 0;
+
+	err = ext2fs_punch(fs, fh->ino, NULL, NULL, start, end);
+	if (err)
+		return translate_error(fs, fh->ino, err);
+
+	return update_mtime(fs, fh->ino);
+}
+
+static int op_fallocate(const char *path, int mode, off_t offset, off_t len,
+			struct fuse_file_info *fp)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	ext2_filsys fs = ff->fs;
+	int ret;
+
+	/* Catch unknown flags */
+	if (mode & ~(FL_PUNCH_HOLE_FLAG | FL_KEEP_SIZE_FLAG))
+		return -EINVAL;
+
+	pthread_mutex_lock(&ff->bfl);
+	if (!fs_writeable(fs)) {
+		ret = -EROFS;
+		goto out;
+	}
+	if (mode & FL_PUNCH_HOLE_FLAG)
+		ret = punch_helper(fp, mode, offset, len);
+	else
+		ret = fallocate_helper(fp, mode, offset, len);
+out:
+	pthread_mutex_unlock(&ff->bfl);
+
+	return ret;
+}
+#endif /* FUSE 29 */
+
+static struct fuse_operations fs_ops = {
+	.init = op_init,
+	.destroy = op_destroy,
+	.getattr = op_getattr,
+	.readlink = op_readlink,
+	.mknod = op_mknod,
+	.mkdir = op_mkdir,
+	.unlink = op_unlink,
+	.rmdir = op_rmdir,
+	.symlink = op_symlink,
+	.rename = op_rename,
+	.link = op_link,
+	.chmod = op_chmod,
+	.chown = op_chown,
+	.truncate = op_truncate,
+	.open = op_open,
+	.read = op_read,
+	.write = op_write,
+	.statfs = op_statfs,
+	.release = op_release,
+	.fsync = op_fsync,
+	.setxattr = op_setxattr,
+	.getxattr = op_getxattr,
+	.listxattr = op_listxattr,
+	.removexattr = op_removexattr,
+	.opendir = op_open,
+	.readdir = op_readdir,
+	.releasedir = op_release,
+	.fsyncdir = op_fsync,
+	.access = op_access,
+	.create = op_create,
+	.ftruncate = op_ftruncate,
+	.fgetattr = op_fgetattr,
+	.utimens = op_utimens,
+	.bmap = op_bmap,
+#ifdef SUPERFLUOUS
+	.lock = op_lock,
+	.poll = op_poll,
+#endif
+#if FUSE_VERSION >= FUSE_MAKE_VERSION(2, 8)
+	.ioctl = op_ioctl,
+	.flag_nullpath_ok = 1,
+#endif
+#if FUSE_VERSION >= FUSE_MAKE_VERSION(2, 9)
+	.flag_nopath = 1,
+	.fallocate = op_fallocate,
+#endif
+};
+
+static int get_random_bytes(void *p, size_t sz)
+{
+	int fd;
+	ssize_t r;
+
+	fd = open("/dev/random", O_RDONLY);
+	if (fd < 0) {
+		perror("/dev/random");
+		return 0;
+	}
+
+	r = read(fd, p, sz);
+
+	close(fd);
+	return r == sz;
+}
+
+static void print_help(const char *progname)
+{
+	printf("Usage: %s dev mntpt [-o options] [fuse_args]\n", progname);
+}
+
+int main(int argc, char *argv[])
+{
+	errcode_t err;
+	ext2_filsys fs;
+	char *tok, *arg, *logfile;
+	int i;
+	int readwrite = 1, panic_on_error = 0;
+	struct fuse2fs *ff;
+	char extra_args[BUFSIZ];
+	int ret = 0, flags = EXT2_FLAG_64BITS | EXT2_FLAG_EXCLUSIVE;
+
+	if (argc < 2) {
+		print_help(argv[0]);
+		return 1;
+	}
+
+	for (i = 1; i < argc; i++) {
+		if (strcmp(argv[i], "--help") == 0) {
+			print_help(argv[0]);
+			return 1;
+		}
+	}
+
+	for (i = 1; i < argc - 1; i++) {
+		if (strcmp(argv[i], "-o"))
+			continue;
+		arg = argv[i + 1];
+		while ((tok = strtok(arg, ","))) {
+			arg = NULL;
+			if (!strcmp(tok, "ro"))
+				readwrite = 0;
+			else if (!strcmp(tok, "errors=panic"))
+				panic_on_error = 1;
+		}
+	}
+
+	if (!readwrite)
+		printf("Mounting read-only.\n");
+
+#ifdef ENABLE_NLS
+	setlocale(LC_MESSAGES, "");
+	setlocale(LC_CTYPE, "");
+	bindtextdomain(NLS_CAT_NAME, LOCALEDIR);
+	textdomain(NLS_CAT_NAME);
+	set_com_err_gettext(gettext);
+#endif
+	add_error_table(&et_ext2_error_table);
+
+	ff = calloc(1, sizeof(*ff));
+	if (!ff) {
+		perror("init");
+		return 1;
+	}
+	ff->panic_on_error = panic_on_error;
+
+	/* Set up error logging */
+	logfile = getenv("FUSE2FS_LOGFILE");
+	if (logfile) {
+		ff->err_fp = fopen(logfile, "a");
+		if (!ff->err_fp) {
+			perror(logfile);
+			goto out_nofs;
+		}
+	} else
+		ff->err_fp = stderr;
+
+	/* Start up the fs (while we still can use stdout) */
+	ret = 2;
+	if (readwrite)
+		flags |= EXT2_FLAG_RW;
+	err = ext2fs_open3(argv[1], NULL, flags, 0, 0, unix_io_manager, &fs);
+	if (err) {
+		printf("%s: %s.\n", argv[1], error_message(err));
+		printf("Please run e2fsck -fy %s.\n", argv[1]);
+		goto out_nofs;
+	}
+	ff->fs = fs;
+	fs->priv_data = ff;
+
+	ret = 3;
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				      EXT3_FEATURE_INCOMPAT_RECOVER)) {
+		printf("Journal needs recovery; running `e2fsck -E "
+		       "journal_only' is required.\n");
+		goto out;
+	}
+
+	if (readwrite) {
+		if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+					    EXT3_FEATURE_COMPAT_HAS_JOURNAL))
+			printf("Journal mode will not be used.\n");
+		err = ext2fs_read_inode_bitmap(fs);
+		if (err) {
+			translate_error(fs, 0, err);
+			goto out;
+		}
+		err = ext2fs_read_block_bitmap(fs);
+		if (err) {
+			translate_error(fs, 0, err);
+			goto out;
+		}
+	}
+
+	if (!(fs->super->s_state & EXT2_VALID_FS))
+		printf("Warning: Mounting unchecked fs, running e2fsck "
+		       "is recommended.\n");
+	if (fs->super->s_max_mnt_count > 0 &&
+	    fs->super->s_mnt_count >= fs->super->s_max_mnt_count)
+		printf("Warning: Maximal mount count reached, running "
+		       "e2fsck is recommended.\n");
+	if (fs->super->s_checkinterval > 0 &&
+	    fs->super->s_lastcheck + fs->super->s_checkinterval <= time(0))
+		printf("Warning: Check time reached; running e2fsck "
+		       "is recommended.\n");
+	if (fs->super->s_last_orphan)
+		printf("Orphans detected; running e2fsck is recommended.\n");
+
+	if (fs->super->s_state & EXT2_ERROR_FS) {
+		printf("Errors detected; running e2fsck is required.\n");
+		goto out;
+	}
+
+	/* Initialize generation counter */
+	get_random_bytes(&ff->next_generation, sizeof(unsigned int));
+
+	/* Stuff in some fuse parameters of our own */
+	snprintf(extra_args, BUFSIZ, "-okernel_cache,subtype=ext4,use_ino,"
+		 "fsname=%s,attr_timeout=0,nonempty,allow_other", argv[1]);
+	argv[0] = argv[1];
+	argv[1] = argv[2];
+	argv[2] = extra_args;
+
+	pthread_mutex_init(&ff->bfl, NULL);
+	fuse_main(argc, argv, &fs_ops, ff);
+	pthread_mutex_destroy(&ff->bfl);
+
+	ret = 0;
+out:
+	err = ext2fs_close(fs);
+	if (err)
+		ret = translate_error(fs, 0, err);
+out_nofs:
+	free(ff);
+
+	return ret;
+}
+
+static int __translate_error(ext2_filsys fs, errcode_t err, ext2_ino_t ino,
+			     const char *file, int line)
+{
+	struct timespec now;
+	int ret;
+	struct fuse2fs *ff = fs->priv_data;
+	int is_err = 0;
+
+	/* Translate ext2 error to unix error code */
+	switch (err) {
+	case EXT2_ET_NO_MEMORY:
+	case EXT2_ET_TDB_ERR_OOM:
+		ret = -ENOMEM;
+		break;
+	case EXT2_ET_INVALID_ARGUMENT:
+	case EXT2_ET_LLSEEK_FAILED:
+		ret = -EINVAL;
+		break;
+	case EXT2_ET_NO_DIRECTORY:
+		ret = -ENOTDIR;
+		break;
+	case EXT2_ET_FILE_NOT_FOUND:
+		ret = -ENOENT;
+		break;
+	case EXT2_ET_DIR_NO_SPACE:
+		is_err = 1;
+	case EXT2_ET_TOOSMALL:
+	case EXT2_ET_BLOCK_ALLOC_FAIL:
+	case EXT2_ET_INODE_ALLOC_FAIL:
+	case EXT2_ET_EA_NO_SPACE:
+		ret = -ENOSPC;
+		break;
+	case EXT2_ET_SYMLINK_LOOP:
+		ret = -EMLINK;
+		break;
+	case EXT2_ET_FILE_TOO_BIG:
+		ret = -EFBIG;
+		break;
+	case EXT2_ET_TDB_ERR_EXISTS:
+	case EXT2_ET_FILE_EXISTS:
+		ret = -EEXIST;
+		break;
+	case EXT2_ET_MMP_FAILED:
+	case EXT2_ET_MMP_FSCK_ON:
+		ret = -EBUSY;
+		break;
+	case EXT2_ET_EA_KEY_NOT_FOUND:
+		ret = -ENODATA;
+		break;
+	default:
+		is_err = 1;
+		ret = -EIO;
+		break;
+	}
+
+	if (!is_err)
+		return ret;
+
+	if (ino)
+		fprintf(ff->err_fp, "FUSE2FS (%s): %s (inode #%d) at %s:%d.\n",
+			fs && fs->device_name ? fs->device_name : "???",
+			error_message(err), ino, file, line);
+	else
+		fprintf(ff->err_fp, "FUSE2FS (%s): %s at %s:%d.\n",
+			fs && fs->device_name ? fs->device_name : "???",
+			error_message(err), file, line);
+	fflush(ff->err_fp);
+
+	/* Make a note in the error log */
+	get_now(&now);
+	fs->super->s_last_error_time = now.tv_sec;
+	fs->super->s_last_error_ino = ino;
+	fs->super->s_last_error_line = line;
+	fs->super->s_last_error_block = 0;
+	strncpy(fs->super->s_last_error_func, file,
+		sizeof(fs->super->s_last_error_func));
+	if (fs->super->s_first_error_time == 0) {
+		fs->super->s_first_error_time = now.tv_sec;
+		fs->super->s_first_error_ino = ino;
+		fs->super->s_first_error_line = line;
+		fs->super->s_first_error_block = 0;
+		strncpy(fs->super->s_first_error_func, file,
+			sizeof(fs->super->s_first_error_func));
+	}
+
+	fs->super->s_error_count++;
+	ext2fs_mark_super_dirty(fs);
+	ext2fs_flush(fs);
+	if (ff->panic_on_error)
+		abort();
+
+	return ret;
+}

