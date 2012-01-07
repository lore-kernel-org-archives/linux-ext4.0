From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 2/2] misc: Add fuse2fs, a FUSE server for e2fsprogs
Date: Sat, 07 Jan 2012 00:55:35 -0800
Message-ID: <20120107085534.4325.32519.stgit@elm3c44.beaverton.ibm.com>
References: <20120107085523.4325.42183.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33727 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab2AGIzj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Jan 2012 03:55:39 -0500
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 03:55:38 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q078ta8n281550
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 03:55:36 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q078tZXb026034
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 03:55:36 -0500
In-Reply-To: <20120107085523.4325.42183.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is the initial implementation of a FUSE server based on e2fsprogs.  The
point of this program is to enable ext4 to run on any OS that FUSE supports
(and doesn't already have a native driver), such as MacOS X, BSDs, and Windows.
The code requires FUSE API v28, which is available in Linux fuse and osxfuse
releases that are available as of January 2012.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 MCONFIG.in       |    1 
 configure        |   89 +++
 configure.in     |    9 
 misc/Makefile.in |   14 
 misc/fuse2fs.c   | 1747 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 1858 insertions(+), 2 deletions(-)
 create mode 100644 misc/fuse2fs.c


diff --git a/MCONFIG.in b/MCONFIG.in
index bdb3580..bee52f5 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -89,6 +89,7 @@ LIBCOM_ERR = $(LIB)/libcom_err@LIB_EXT@ @PRIVATE_LIBS_CMT@ @SEM_INIT_LIB@
 LIBE2P = $(LIB)/libe2p@LIB_EXT@
 LIBEXT2FS = $(LIB)/libext2fs@LIB_EXT@
 LIBUUID = @LIBUUID@ @SOCKET_LIB@
+LIBFUSE = @FUSE_LIB@
 LIBQUOTA = @STATIC_LIBQUOTA@
 LIBBLKID = @LIBBLKID@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
 LIBINTL = @LIBINTL@
diff --git a/configure b/configure
index 9f5eeb5..89dc7e6 100755
--- a/configure
+++ b/configure
@@ -611,6 +611,8 @@ CYGWIN_CMT
 LINUX_CMT
 UNI_DIFF_OPTS
 SEM_INIT_LIB
+FUSE_CMT
+FUSE_LIB
 SOCKET_LIB
 SIZEOF_LONG_LONG
 SIZEOF_LONG
@@ -10948,6 +10950,93 @@ if test "x$ac_cv_lib_socket_socket" = x""yes; then :
 fi
 
 
+FUSE_CMT=''
+FUSE_LIB=''
+{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for fuse_main in -losxfuse" >&5
+$as_echo_n "checking for fuse_main in -losxfuse... " >&6; }
+if test "${ac_cv_lib_osxfuse_fuse_main+set}" = set; then :
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
+if test "x$ac_cv_lib_osxfuse_fuse_main" = x""yes; then :
+  FUSE_LIB=-losxfuse
+else
+  { $as_echo "$as_me:${as_lineno-$LINENO}: checking for fuse_main in -lfuse" >&5
+$as_echo_n "checking for fuse_main in -lfuse... " >&6; }
+if test "${ac_cv_lib_fuse_fuse_main+set}" = set; then :
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
+if test "x$ac_cv_lib_fuse_fuse_main" = x""yes; then :
+  FUSE_LIB=-lfuse
+else
+  FUSE_CMT="#"
+fi
+
+fi
+
+
+
 { $as_echo "$as_me:${as_lineno-$LINENO}: checking for optreset" >&5
 $as_echo_n "checking for optreset... " >&6; }
 if test "${ac_cv_have_optreset+set}" = set; then :
diff --git a/configure.in b/configure.in
index c304a8d..bae8d7c 100644
--- a/configure.in
+++ b/configure.in
@@ -923,6 +923,15 @@ SOCKET_LIB=''
 AC_CHECK_LIB(socket, socket, [SOCKET_LIB=-lsocket])
 AC_SUBST(SOCKET_LIB)
 dnl
+dnl Check to see if the FUSE library is -lfuse or -losxfuse
+dnl
+FUSE_CMT=''
+FUSE_LIB=''
+dnl osxfuse.dylib supersedes fuselib.dylib
+AC_CHECK_LIB(osxfuse, fuse_main, [FUSE_LIB=-losxfuse], [AC_CHECK_LIB(fuse, fuse_main, [FUSE_LIB=-lfuse], [FUSE_CMT="#"])])
+AC_SUBST(FUSE_LIB)
+AC_SUBST(FUSE_CMT)
+dnl
 dnl See if optreset exists
 dnl
 AC_MSG_CHECKING(for optreset)
diff --git a/misc/Makefile.in b/misc/Makefile.in
index cb3c6d9..51ce2d8 100644
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
@@ -74,6 +78,7 @@ PROFILED_BLKID_OBJS=	profiled/blkid.o
 PROFILED_FILEFRAG_OBJS=	profiled/filefrag.o
 PROFILED_E2UNDO_OBJS=	profiled/e2undo.o
 PROFILED_E4DEFRAG_OBJS=	profiled/e4defrag.o
+PROFILED_FUSE2FS_OJBS=	profiled/fuse2fs.o
 
 SRCS=	$(srcdir)/tune2fs.c $(srcdir)/mklost+found.c $(srcdir)/mke2fs.c \
 		$(srcdir)/chattr.c $(srcdir)/lsattr.c $(srcdir)/dumpe2fs.c \
@@ -81,7 +86,7 @@ SRCS=	$(srcdir)/tune2fs.c $(srcdir)/mklost+found.c $(srcdir)/mke2fs.c \
 		$(srcdir)/uuidgen.c $(srcdir)/blkid.c $(srcdir)/logsave.c \
 		$(srcdir)/filefrag.c $(srcdir)/base_device.c \
 		$(srcdir)/ismounted.c $(srcdir)/../e2fsck/profile.c \
-		$(srcdir)/e2undo.c $(srcdir)/e2freefrag.c
+		$(srcdir)/e2undo.c $(srcdir)/e2freefrag.c $(srcdir)/fuse2fs.c
 
 LIBS= $(LIBEXT2FS) $(LIBCOM_ERR) 
 DEPLIBS= $(LIBEXT2FS) $(DEPLIBCOM_ERR)
@@ -321,6 +326,11 @@ filefrag.profiled: $(PROFILED_FILEFRAG_OBJS)
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o filefrag.profiled \
 		$(PROFILED_FILEFRAG_OBJS) 
 
+fuse2fs: $(FUSE2FS_OBJS)
+	$(E) "  LD $@"
+	$(Q) $(CC) $(ALL_LDFLAGS) -o fuse2fs $(FUSE2FS_OBJS) $(LIBS) \
+		$(LIBFUSE) $(LIBBLKID) $(LIBUUID) $(LIBEXT2FS)
+
 tst_ismounted: $(srcdir)/ismounted.c $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
 	$(E) "	LD $@"
 	$(CC) -o tst_ismounted $(srcdir)/ismounted.c -DDEBUG $(ALL_CFLAGS) \
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
new file mode 100644
index 0000000..8d9b507
--- /dev/null
+++ b/misc/fuse2fs.c
@@ -0,0 +1,1747 @@
+/*
+ * fuse2fs.c - FUSE server for e2fsprogs.
+ *
+ * Copyright (C) 2012 IBM.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+#define _FILE_OFFSET_BITS 64
+#define FUSE_USE_VERSION 28
+#include <fuse.h>
+#include "ext2fs/ext2fs.h"
+#include "ext2fs/ext2_fs.h"
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
+	if (!clock_gettime(CLOCK_REALTIME, now))
+		return;
+
+	now->tv_sec = time(NULL);
+	now->tv_nsec = 0;
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
+}
+
+static errcode_t update_ctime(ext2_filsys fs, ext2_ino_t ino,
+			      struct ext2_inode_large *pinode)
+{
+	errcode_t err;
+	struct timespec now;
+	struct ext2_inode_large inode;
+
+	get_now(&now);
+
+	/* If user already has a inode buffer, just update that */
+	if (pinode) {
+		EXT4_INODE_SET_XTIME(i_ctime, &now, pinode);
+		return 0;
+	}
+
+	/* Otherwise we have to read-modify-write the inode */
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err)
+		return -EIO;
+
+	EXT4_INODE_SET_XTIME(i_ctime, &now, &inode);
+
+	err = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err)
+		return -EIO;
+
+	return 0;
+}
+
+static errcode_t update_atime(ext2_filsys fs, ext2_ino_t ino)
+{
+	errcode_t err;
+	struct ext2_inode_large inode, *pinode;
+	struct timespec atime, mtime, now;
+
+	if (!(fs->flags & EXT2_FLAG_RW))
+		return 0;
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err)
+		return -EIO;
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
+		return -EIO;
+}
+
+static errcode_t update_mtime(ext2_filsys fs, ext2_ino_t ino)
+{
+	errcode_t err;
+	struct ext2_inode_large inode;
+	struct timespec now;
+
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err)
+		return -EIO;
+
+	get_now(&now);
+	EXT4_INODE_SET_XTIME(i_mtime, &now, &inode);
+	EXT4_INODE_SET_XTIME(i_ctime, &now, &inode);
+
+	err = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err)
+		return -EIO;
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
+static int check_inum_access(struct fuse_context *ctxt, ext2_filsys fs,
+			     ext2_ino_t ino, int mask)
+{
+	errcode_t err;
+	struct ext2_inode inode;
+	mode_t perms;
+
+	/* no writing to rofs */
+	if ((mask & W_OK) && !(fs->flags & EXT2_FLAG_RW))
+		return -EROFS;
+
+	err = ext2fs_read_inode(fs, ino, &inode);
+	if (err)
+		return -ENOENT;
+
+	/* existence check */
+	if (mask == 0)
+		return 0;
+
+	perms = inode.i_mode & 0777;
+
+	/* always allow root */
+	if (ctxt->uid == 0)
+		return 0;
+
+	/* allow owner, if perms match */
+	if (inode.i_uid == ctxt->uid) {
+		if ((mask << 6) & perms)
+			return 0;
+		return -EACCES;
+	}
+
+	/* allow group, if perms match */
+	if (inode.i_gid == ctxt->gid) {
+		if ((mask << 3) & perms)
+			return 0;
+		return -EACCES;
+	}
+
+	/* otherwise check other */
+	if (mask & perms)
+		return 0;
+	return -EACCES;
+}
+
+static void *op_init(struct fuse_conn_info *conn)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	return ctxt->private_data;
+}
+
+static int op_getattr(const char *path, struct stat *statbuf)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+	ext2_ino_t ino;
+	errcode_t err;
+	struct ext2_inode_large inode;
+	dev_t fakedev = 0;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err)
+		return -ENOENT;
+
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err)
+		return -ENOENT;
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
+	return 0;
+}
+
+static int op_readlink(const char *path, char *buf, size_t len)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+	errcode_t err;
+	ext2_ino_t ino;
+	struct ext2_inode inode;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err || ino == 0)
+		return -ENOENT;
+
+	err = ext2fs_read_inode(fs, ino, &inode);
+	if (err)
+		return -ENOENT;
+
+	if (!LINUX_S_ISLNK(inode.i_mode))
+		return -EINVAL;
+
+	len--;
+	if (inode.i_size < len)
+		len = inode.i_size;
+	if (ext2fs_inode_data_blocks2(fs, &inode)) {
+		/* big symlink */
+		unsigned int got;
+		ext2_file_t file;
+
+		err = ext2fs_file_open(fs, ino, 0, &file);
+		if (err)
+			return -ENOMEM;
+
+		err = ext2fs_file_read(file, buf, len, &got);
+		if (err || got != len) {
+			ext2fs_file_close(file);
+			return -ENOMEM;
+		}
+
+		err = ext2fs_file_close(file);
+		if (err)
+			return -ENOMEM;
+	} else
+		/* inline symlink */
+		memcpy(buf, (char *)inode.i_block, len);
+	buf[len] = 0;
+
+	return 0;
+}
+
+static int op_mknod(const char *path, mode_t mode, dev_t dev)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+	ext2_ino_t parent, child;
+	char *temp_path = strdup(path);
+	errcode_t err;
+	char *node_name, a;
+	int filetype;
+	struct ext2_inode_large inode;
+
+	if (!temp_path) {
+		err = -ENOMEM;
+		goto out;
+	}
+	node_name = strrchr(temp_path, '/');
+	if (!node_name) {
+		err = -ENOMEM;
+		goto out;
+	}
+	node_name++;
+	a = *node_name;
+	*node_name = 0;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, temp_path,
+			   &parent);
+	if (err) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	err = check_inum_access(ctxt, fs, parent, W_OK);
+	if (err)
+		goto out;
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
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = ext2fs_new_inode(fs, parent, mode, 0, &child);
+	if (err) {
+		err = -ENOSPC;
+		goto out;
+	}
+
+	err = ext2fs_link(fs, parent, node_name, child, filetype);
+	if (err == EXT2_ET_DIR_NO_SPACE) {
+		err = ext2fs_expand_dir(fs, parent);
+		if (err) {
+			err = -ENOSPC;
+			goto out;
+		}
+
+		err = ext2fs_link(fs, parent, node_name, child,
+				     filetype);
+	}
+	if (err) {
+		err = -ENOSPC;
+		goto out;
+	}
+
+	err = update_mtime(fs, parent);
+	if (err) {
+		err = -EIO;
+		goto out;
+	}
+
+	memset(&inode, 0, sizeof(inode));
+	inode.i_mode = mode;
+	init_times(&inode);
+
+	if (dev & ~0xFFFF)
+		inode.i_block[1] = dev;
+	else
+		inode.i_block[0] = dev;
+	inode.i_links_count = 1;
+	inode.i_extra_isize = sizeof(struct ext2_inode_large) -
+		EXT2_GOOD_OLD_INODE_SIZE;
+
+	err = ext2fs_write_inode_full(fs, child, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err)
+		goto out;
+
+	ext2fs_inode_alloc_stats2(fs, child, 1, 0);
+out:
+	free(temp_path);
+	return err;
+}
+
+static int op_mkdir(const char *path, mode_t mode)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+	ext2_ino_t parent;
+	char *temp_path = strdup(path);
+	errcode_t err;
+	char *node_name, a;
+
+	if (!temp_path) {
+		err = -ENOMEM;
+		goto out;
+	}
+	node_name = strrchr(temp_path, '/');
+	if (!node_name) {
+		err = -ENOMEM;
+		goto out;
+	}
+	node_name++;
+	a = *node_name;
+	*node_name = 0;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, temp_path,
+			   &parent);
+	if (err) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	err = check_inum_access(ctxt, fs, parent, W_OK);
+	if (err)
+		goto out;
+
+	*node_name = a;
+
+	err = ext2fs_mkdir(fs, parent, 0, node_name);
+	if (err == EXT2_ET_DIR_NO_SPACE) {
+		err = ext2fs_expand_dir(fs, parent);
+		if (err) {
+			err = -ENOSPC;
+			goto out;
+		}
+
+		err = ext2fs_mkdir(fs, parent, 0, node_name);
+	}
+	if (err) {
+		err = -ENOSPC;
+		goto out;
+	}
+
+	err = update_mtime(fs, parent);
+	if (err) {
+		err = -EIO;
+		goto out;
+	}
+
+out:
+	free(temp_path);
+	return err;
+}
+
+static int unlink_file_by_name(struct fuse_context *ctxt, ext2_filsys fs,
+			       const char *path)
+{
+	errcode_t err;
+	ext2_ino_t dir;
+	char *filename = strdup(path);
+	char *base_name;
+
+	base_name = strrchr(filename, '/');
+	if (base_name) {
+		*base_name++ = '\0';
+		err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, filename,
+				   &dir);
+		if (err) {
+			free(filename);
+			return -EINVAL;
+		}
+	} else {
+		dir = EXT2_ROOT_INO;
+		base_name = filename;
+	}
+
+	err = check_inum_access(ctxt, fs, dir, W_OK);
+	if (err) {
+		free(filename);
+		return err;
+	}
+
+	err = ext2fs_unlink(fs, dir, base_name, 0, 0);
+	free(filename);
+	if (err)
+		return -EIO;
+
+	err = update_mtime(fs, dir);
+	if (err)
+		return -EIO;
+
+	return 0;
+}
+
+static int release_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
+			       e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
+			       blk64_t ref_block EXT2FS_ATTR((unused)),
+			       int ref_offset EXT2FS_ATTR((unused)),
+			       void *private EXT2FS_ATTR((unused)))
+{
+	blk64_t	block;
+
+	block = *blocknr;
+	ext2fs_block_alloc_stats2(fs, block, -1);
+	return 0;
+}
+
+static int kill_file_by_inode(ext2_filsys fs, ext2_ino_t ino)
+{
+	errcode_t err;
+	struct ext2_inode_large inode;
+
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err)
+		return -EIO;
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
+	err = update_ctime(fs, ino, &inode);
+	if (err)
+		return -EIO;
+
+	err = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err)
+		return -EIO;
+
+	if (inode.i_links_count)
+		return 0;
+
+	ext2fs_block_iterate3(fs, ino, BLOCK_FLAG_READ_ONLY, NULL,
+			      release_blocks_proc, NULL);
+	ext2fs_inode_alloc_stats2(fs, ino, -1,
+				  LINUX_S_ISDIR(inode.i_mode));
+
+	return 0;
+}
+
+static int op_unlink(const char *path)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+	ext2_ino_t ino;
+	errcode_t err;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err)
+		return -ENOENT;
+
+	err = check_inum_access(ctxt, fs, ino, W_OK);
+	if (err)
+		return err;
+
+	err = unlink_file_by_name(ctxt, fs, path);
+	if (err)
+		return err;
+	return kill_file_by_inode(fs, ino);
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
+static int op_rmdir(const char *path)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+	ext2_ino_t child;
+	errcode_t err;
+	struct ext2_inode inode;
+	struct rd_struct rds;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &child);
+	if (err)
+		return -ENOENT;
+
+	err = check_inum_access(ctxt, fs, child, W_OK);
+	if (err)
+		return err;
+
+	rds.parent = 0;
+	rds.empty = 1;
+
+	err = ext2fs_dir_iterate2(fs, child, 0, 0, rmdir_proc, &rds);
+	if (err)
+		return -EIO;
+
+	if (rds.empty == 0)
+		return -ENOTEMPTY;
+
+	err = unlink_file_by_name(ctxt, fs, path);
+	if (err)
+		return err;
+	err = kill_file_by_inode(fs, child);
+	if (err)
+		return err;
+	err = kill_file_by_inode(fs, child);
+	if (err)
+		return err;
+
+	if (rds.parent) {
+		err = ext2fs_read_inode(fs, rds.parent, &inode);
+		if (err)
+			return -EIO;
+		if (inode.i_links_count > 1)
+			inode.i_links_count--;
+		err = update_mtime(fs, rds.parent);
+		if (err)
+			return -EIO;
+		err = ext2fs_write_inode(fs, rds.parent, &inode);
+		if (err)
+			return -EIO;
+	}
+
+	return 0;
+}
+
+static int op_symlink(const char *src, const char *dest)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+	ext2_ino_t parent, child;
+	char *temp_path = strdup(dest);
+	errcode_t err;
+	char *node_name, a;
+	struct ext2_inode_large inode;
+	int len = strlen(src);
+
+	if (!temp_path) {
+		err = -ENOMEM;
+		goto out;
+	}
+	node_name = strrchr(temp_path, '/');
+	if (!node_name) {
+		err = -ENOMEM;
+		goto out;
+	}
+	node_name++;
+	a = *node_name;
+	*node_name = 0;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, temp_path,
+			   &parent);
+	if (err) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	err = check_inum_access(ctxt, fs, parent, W_OK);
+	if (err)
+		goto out;
+
+	*node_name = a;
+
+	err = ext2fs_new_inode(fs, parent, 0, 0, &child);
+	if (err) {
+		err = -ENOSPC;
+		goto out;
+	}
+
+	err = ext2fs_link(fs, parent, node_name, child, EXT2_FT_SYMLINK);
+	if (err == EXT2_ET_DIR_NO_SPACE) {
+		err = ext2fs_expand_dir(fs, parent);
+		if (err) {
+			err = -ENOSPC;
+			goto out;
+		}
+
+		err = ext2fs_link(fs, parent, node_name, child,
+				     EXT2_FT_SYMLINK);
+	}
+	if (err) {
+		err = -ENOSPC;
+		goto out;
+	}
+
+	err = update_mtime(fs, parent);
+	if (err) {
+		err = -EIO;
+		goto out;
+	}
+
+	memset(&inode, 0, sizeof(inode));
+	inode.i_mode = S_IFLNK | 0777;
+	init_times(&inode);
+	inode.i_links_count = 1;
+	inode.i_size = len;
+	inode.i_uid = ctxt->uid;
+	inode.i_gid = ctxt->gid;
+	inode.i_extra_isize = sizeof(struct ext2_inode_large) -
+		EXT2_GOOD_OLD_INODE_SIZE;
+
+	if (len <= sizeof(inode.i_block) - 1) {
+		/* fast symlink */
+		memcpy(inode.i_block, src, len);
+
+		err = ext2fs_write_inode_full(fs, child,
+					      (struct ext2_inode *)&inode,
+					      sizeof(inode));
+		if (err) {
+			err = -EIO;
+			goto out;
+		}
+	} else {
+		unsigned int got;
+		ext2_file_t file;
+
+		if (fs->super->s_feature_incompat &
+				EXT3_FEATURE_INCOMPAT_EXTENTS)
+			inode.i_flags = EXT4_EXTENTS_FL;
+
+		err = ext2fs_write_inode_full(fs, child,
+					      (struct ext2_inode *)&inode,
+					      sizeof(inode));
+		if (err) {
+			err = -EIO;
+			goto out;
+		}
+
+		err = ext2fs_file_open(fs, child, EXT2_FILE_WRITE, &file);
+		if (err) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		err = ext2fs_file_write(file, src, len, &got);
+		if (err || got != len) {
+			ext2fs_file_close(file);
+			err = -ENOMEM;
+			goto out;
+		}
+
+		err = ext2fs_file_close(file);
+		if (err) {
+			err = -ENOMEM;
+			goto out;
+		}
+	}
+
+	ext2fs_inode_alloc_stats2(fs, child, 1, 0);
+out:
+	free(temp_path);
+	return err;
+}
+
+static int op_rename(const char *from, const char *to)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+	errcode_t err;
+	ext2_ino_t from_ino, to_ino, to_dir_ino;
+	char *temp_to, *cp, a;
+	struct ext2_inode from_inode;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, from, &from_ino);
+	if (err || from_ino == 0)
+		return -ENOENT;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, to, &to_ino);
+	if (err && err != EXT2_ET_FILE_NOT_FOUND)
+		return -ENOENT;
+
+	if (err == EXT2_ET_FILE_NOT_FOUND)
+		to_ino = 0;
+
+	/* Already the same file? */
+	if (to_ino != 0 && to_ino == from_ino)
+		return 0;
+
+	temp_to = strdup(to);
+	cp = strrchr(temp_to, '/');
+	if (!cp) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	a = *(cp + 1);
+	*(cp + 1) = 0;
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, temp_to,
+			   &to_dir_ino);
+	if (err || to_dir_ino == 0) {
+		err = -ENOENT;
+		goto out;
+	}
+	*(cp + 1) = a;
+
+	err = ext2fs_read_inode(fs, from_ino, &from_inode);
+	if (err) {
+		err = -EIO;
+		goto out;
+	}
+
+	/*
+	 * The _to_ parameter should not be a dir.
+	 * If _to_ doesn't exist, move _from_ to _to_ in _to_'s parent.
+	 * If _to_ exists, decrement _to_'s link count, and update the
+	 * dir entry to point to _from_.
+	 */
+
+	/* If the target exists, unlink it first */
+	if (to_ino != 0) {
+		err = op_unlink(to);
+		if (err)
+			goto out;
+	}
+
+	/* Link in the new file */
+	err = ext2fs_link(fs, to_dir_ino, cp + 1, from_ino,
+			  ext2_file_type(from_inode.i_mode));
+	if (err == EXT2_ET_DIR_NO_SPACE) {
+		err = ext2fs_expand_dir(fs, to_dir_ino);
+		if (err) {
+			err = -ENOSPC;
+			goto out;
+		}
+
+		err = ext2fs_link(fs, to_dir_ino, cp + 1, from_ino,
+				     ext2_file_type(from_inode.i_mode));
+	}
+	if (err) {
+		err = -ENOSPC;
+		goto out;
+	}
+
+	err = update_mtime(fs, to_dir_ino);
+	if (err) {
+		err = -EIO;
+		goto out;
+	}
+
+	/* Remove the old file */
+	err = unlink_file_by_name(ctxt, fs, from);
+	if (err) {
+		err = -EIO;
+		goto out;
+	}
+
+	/* Flush the whole mess out */
+	err = ext2fs_flush2(fs, 0);
+
+out:
+	free(temp_to);
+	return err;
+}
+
+static int op_link(const char *src, const char *dest)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+	char *temp_path = strdup(dest);
+	errcode_t err;
+	char *node_name, a;
+	ext2_ino_t parent, ino;
+	struct ext2_inode_large inode;
+
+	if (!temp_path) {
+		err = -ENOMEM;
+		goto out;
+	}
+	node_name = strrchr(temp_path, '/');
+	if (!node_name) {
+		err = -ENOMEM;
+		goto out;
+	}
+	node_name++;
+	a = *node_name;
+	*node_name = 0;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, temp_path,
+			   &parent);
+	if (err) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	err = check_inum_access(ctxt, fs, parent, W_OK);
+	if (err)
+		goto out;
+
+	*node_name = a;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, src, &ino);
+	if (err || ino == 0) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err) {
+		err = -EIO;
+		goto out;
+	}
+
+	inode.i_links_count++;
+	err = update_ctime(fs, ino, &inode);
+	if (err) {
+		err = -EIO;
+		goto out;
+	}
+
+	err = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err) {
+		err = -EIO;
+		goto out;
+	}
+
+	err = ext2fs_link(fs, parent, node_name, ino,
+			  ext2_file_type(inode.i_mode));
+	if (err == EXT2_ET_DIR_NO_SPACE) {
+		err = ext2fs_expand_dir(fs, parent);
+		if (err) {
+			err = -ENOSPC;
+			goto out;
+		}
+
+		err = ext2fs_link(fs, parent, node_name, ino,
+				     ext2_file_type(inode.i_mode));
+	}
+	if (err) {
+		err = -ENOSPC;
+		goto out;
+	}
+
+	err = update_mtime(fs, parent);
+	if (err) {
+		err = -EIO;
+		goto out;
+	}
+
+out:
+	free(temp_path);
+	return err;
+}
+
+static int op_chmod(const char *path, mode_t mode)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+	errcode_t err;
+	ext2_ino_t ino;
+	struct ext2_inode_large inode;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err)
+		return -ENOENT;
+
+	err = check_inum_access(ctxt, fs, ino, W_OK);
+	if (err)
+		return err;
+
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err)
+		return -EIO;
+
+	inode.i_mode &= ~0xFFF;
+	inode.i_mode |= mode & 0xFFF;
+	err = update_ctime(fs, ino, &inode);
+	if (err)
+		return -EIO;
+
+	err = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err)
+		return -EIO;
+
+	return 0;
+}
+
+static int op_chown(const char *path, uid_t owner, gid_t group)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+	errcode_t err;
+	ext2_ino_t ino;
+	struct ext2_inode_large inode;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err)
+		return -ENOENT;
+
+	err = check_inum_access(ctxt, fs, ino, W_OK);
+	if (err)
+		return err;
+
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err)
+		return -EIO;
+
+	inode.i_uid = owner;
+	inode.i_gid = group;
+	err = update_ctime(fs, ino, &inode);
+	if (err)
+		return -EIO;
+
+	err = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err)
+		return -EIO;
+
+	return 0;
+}
+
+static int op_truncate(const char *path, off_t len)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+	errcode_t err;
+	ext2_ino_t ino;
+	ext2_file_t file;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err || ino == 0)
+		return -ENOENT;
+
+	err = check_inum_access(ctxt, fs, ino, W_OK);
+	if (err)
+		return err;
+
+	err = ext2fs_file_open(fs, ino, EXT2_FILE_WRITE, &file);
+	if (err)
+		return -ENOMEM;
+
+	err = ext2fs_file_set_size2(file, len);
+	if (err) {
+		err = -EIO;
+		goto out;
+	}
+
+	err = update_mtime(fs, ino);
+	if (err) {
+		err = -EIO;
+		goto out;
+	}
+
+out:
+	if (err)
+		ext2fs_file_close(file);
+	else
+		err = ext2fs_file_close(file);
+	return err;
+}
+
+static int op_open(const char *path, struct fuse_file_info *fp)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+	errcode_t err;
+	ext2_ino_t ino;
+	ext2_file_t file;
+
+	int open_flags = 0;
+	if (fp->flags & (O_RDWR | O_WRONLY))
+		open_flags |= EXT2_FILE_WRITE;
+	if (fp->flags & O_CREAT)
+		open_flags |= EXT2_FILE_CREATE;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err || ino == 0)
+		return -ENOENT;
+
+	err = check_inum_access(ctxt, fs, ino,
+				(open_flags & EXT2_FILE_WRITE ? W_OK : 0) |
+				R_OK);
+	if (err)
+		return err;
+
+	err = ext2fs_file_open(fs, ino, open_flags, &file);
+	if (err)
+		return -ENOMEM;
+	fp->fh = (uint64_t)file;
+
+	return 0;
+}
+
+static int op_read(const char *path, char *buf, size_t len, off_t offset,
+		     struct fuse_file_info *fp)
+{
+	ext2_file_t file = (ext2_file_t)fp->fh;
+	errcode_t err;
+	unsigned int got;
+
+	err = ext2fs_file_llseek(file, offset, SEEK_SET, NULL);
+	if (err)
+		return -ENOENT;
+
+	err = ext2fs_file_read(file, buf, len, &got);
+	if (err)
+		return -ENOENT;
+
+	err = update_atime(ext2fs_file_get_fs(file),
+			   ext2fs_file_get_inode_num(file));
+	if (err)
+		return err;
+
+	return got;
+}
+
+static int op_write(const char *path, const char *buf, size_t len, off_t offset,
+		      struct fuse_file_info *fp)
+{
+	ext2_file_t file = (ext2_file_t)fp->fh;
+	errcode_t err;
+	unsigned int got;
+	__u64 fsize;
+
+	err = ext2fs_file_llseek(file, offset, SEEK_SET, NULL);
+	if (err)
+		return -ENOENT;
+
+	err = ext2fs_file_write(file, buf, len, &got);
+	if (err)
+		return -EIO;
+
+	/*
+	 * Apparently ext2fs_file_write will dirty the inode (to allocate
+	 * blocks) without bothering to write out the inode, so change the
+	 * file size *after* the write, because changing the size forces
+	 * the inode out to disk.
+	 */
+	err = ext2fs_file_get_lsize(file, &fsize);
+	if (err)
+		return -EIO;
+	if (offset + len > fsize) {
+		fsize = offset + len;
+		err = ext2fs_file_set_size2(file, fsize);
+		if (err)
+			return -EIO;
+	}
+
+	err = update_mtime(ext2fs_file_get_fs(file),
+			   ext2fs_file_get_inode_num(file));
+	if (err)
+		return -EIO;
+
+	return got;
+}
+
+static int op_statfs(const char *path, struct statvfs *buf)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
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
+static int op_flush(const char *path, struct fuse_file_info *fp)
+{
+	ext2_file_t file = (ext2_file_t)fp->fh;
+
+	if (ext2fs_file_flush(file))
+		return -EIO;
+
+	return 0;
+}
+
+static int op_release(const char *path, struct fuse_file_info *fp)
+{
+	ext2_file_t file = (ext2_file_t)fp->fh;
+
+	fp->fh = 0;
+	if (ext2fs_file_close(file))
+		return -EIO;
+
+	return 0;
+}
+
+static int op_fsync(const char *path, int datasync, struct fuse_file_info *fp)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+
+	/* For now, flush everything, even if it's slow */
+	if (ext2fs_flush2(fs, 0))
+		return -EIO;
+
+	return 0;
+}
+
+#ifdef SUPPORT_XATTR
+static int op_setxattr(const char *path, const char *key, const char *value,
+		       size_t len, int flags)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+
+	printf("%s\n", __FUNCTION__);
+	return -ENOTTY;
+}
+
+static int op_getxattr(const char *path, const char *key, char *value,
+		       size_t len)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+
+	printf("%s\n", __FUNCTION__);
+	return -ENOTTY;
+}
+
+static int op_listxattr(const char *path, char *names, size_t len)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+
+	printf("%s\n", __FUNCTION__);
+	return -ENOTTY;
+}
+
+static int op_removexattr(const char *path, const char *key)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+
+	printf("%s\n", __FUNCTION__);
+	return -ENOTTY;
+}
+#endif
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
+	ext2_filsys fs = ctxt->private_data;
+	errcode_t err;
+	ext2_ino_t ino;
+	struct readdir_iter i;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err || ino == 0)
+		return -ENOENT;
+
+	i.buf = buf;
+	i.func = fill_func;
+	err = ext2fs_dir_iterate2(fs, ino, 0, NULL, op_readdir_iter, &i);
+	if (err)
+		return -ENOENT;
+
+	err = update_atime(fs, ino);
+	if (err)
+		return -EIO;
+
+	return 0;
+}
+
+static int op_access(const char *path, int mask)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+	errcode_t err;
+	ext2_ino_t ino;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err || ino == 0)
+		return -ENOENT;
+
+	return check_inum_access(ctxt, fs, ino, mask);
+}
+
+static int op_create(const char *path, mode_t mode, struct fuse_file_info *fp)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+	ext2_ino_t parent, child;
+	char *temp_path = strdup(path);
+	errcode_t err;
+	char *node_name, a;
+	int filetype;
+	struct ext2_inode_large inode;
+
+	if (!temp_path) {
+		err = -ENOMEM;
+		goto out;
+	}
+	node_name = strrchr(temp_path, '/');
+	if (!node_name) {
+		err = -ENOMEM;
+		goto out;
+	}
+	node_name++;
+	a = *node_name;
+	*node_name = 0;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, temp_path,
+			   &parent);
+	if (err) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	err = check_inum_access(ctxt, fs, parent, W_OK);
+	if (err)
+		goto out;
+
+	*node_name = a;
+
+	filetype = ext2_file_type(mode);
+
+	err = ext2fs_new_inode(fs, parent, mode, 0, &child);
+	if (err) {
+		err = -ENOSPC;
+		goto out;
+	}
+
+	err = ext2fs_link(fs, parent, node_name, child, filetype);
+	if (err == EXT2_ET_DIR_NO_SPACE) {
+		err = ext2fs_expand_dir(fs, parent);
+		if (err) {
+			err = -ENOSPC;
+			goto out;
+		}
+
+		err = ext2fs_link(fs, parent, node_name, child,
+				     filetype);
+	}
+	if (err) {
+		err = -ENOSPC;
+		goto out;
+	}
+
+	err = update_mtime(fs, parent);
+	if (err) {
+		err = -EIO;
+		goto out;
+	}
+
+	memset(&inode, 0, sizeof(inode));
+	inode.i_mode = mode;
+	init_times(&inode);
+	inode.i_links_count = 1;
+	inode.i_extra_isize = sizeof(struct ext2_inode_large) -
+		EXT2_GOOD_OLD_INODE_SIZE;
+	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS)
+		inode.i_flags = EXT4_EXTENTS_FL;
+
+	err = ext2fs_write_inode_full(fs, child, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err)
+		goto out;
+
+	ext2fs_inode_alloc_stats2(fs, child, 1, 0);
+
+	err = op_open(path, fp);
+out:
+	free(temp_path);
+	return err;
+}
+
+static int op_ftruncate(const char *path, off_t len, struct fuse_file_info *fp)
+{
+	ext2_file_t file = (ext2_file_t)fp->fh;
+	errcode_t err;
+
+	if (ext2fs_file_set_size2(file, len))
+		return -EIO;
+
+	err = update_mtime(ext2fs_file_get_fs(file),
+			   ext2fs_file_get_inode_num(file));
+	if (err)
+		return -EIO;
+
+	return 0;
+}
+
+static int op_fgetattr(const char *path, struct stat *statbuf,
+		       struct fuse_file_info *fp)
+{
+	return op_getattr(path, statbuf);
+}
+
+#ifdef SUPERFLUOUS
+static int op_lock(const char *path, struct fuse_file_info *fp, int cmd,
+		     struct flock *fl)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+
+	printf("%s\n", __FUNCTION__);
+	return -ENOTTY;
+}
+#endif
+
+static int op_utimens(const char *path, const struct timespec tv[2])
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+	errcode_t err;
+	ext2_ino_t ino;
+	struct ext2_inode_large inode;
+
+	err = ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, path, &ino);
+	if (err)
+		return -ENOENT;
+
+	err = check_inum_access(ctxt, fs, ino, W_OK);
+	if (err)
+		return err;
+
+	err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err)
+		return -EIO;
+
+	EXT4_INODE_SET_XTIME(i_atime, tv, &inode);
+	EXT4_INODE_SET_XTIME(i_mtime, tv + 1, &inode);
+	err = update_ctime(fs, ino, &inode);
+	if (err)
+		return -EIO;
+
+	err = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err)
+		return -EIO;
+
+	return 0;
+}
+
+#ifdef SUPERFLUOUS
+static int op_bmap(const char *path, size_t blocksize, uint64_t *idx)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+
+	printf("%s\n", __FUNCTION__);
+	return -ENOTTY;
+}
+
+static int op_ioctl(const char *path, int cmd, void *arg,
+		      struct fuse_file_info *fp, unsigned int flags, void *data)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+
+	printf("%s\n", __FUNCTION__);
+	return -ENOTTY;
+}
+
+static int op_poll(const char *path, struct fuse_file_info *fp,
+		     struct fuse_pollhandle *ph, unsigned *reventsp)
+{
+	struct fuse_context *ctxt = fuse_get_context();
+	ext2_filsys fs = ctxt->private_data;
+
+	printf("%s\n", __FUNCTION__);
+	return -ENOTTY;
+}
+#endif
+
+static struct fuse_operations fs_ops = {
+	.init = op_init,
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
+	.flush = op_flush,
+	.release = op_release,
+	.fsync = op_fsync,
+#ifdef SUPPORT_XATTR
+	.setxattr = op_setxattr,
+	.getxattr = op_getxattr,
+	.listxattr = op_listxattr,
+	.removexattr = op_removexattr,
+#endif
+#ifdef READDIR_NEEDS_OPEN
+	.opendir = op_open,
+#endif
+	.readdir = op_readdir,
+#ifdef READDIR_NEEDS_OPEN
+	.releasedir = op_release,
+#endif
+	.fsyncdir = op_fsync,
+	.access = op_access,
+	.create = op_create,
+	.ftruncate = op_ftruncate,
+	.fgetattr = op_fgetattr,
+	.utimens = op_utimens,
+#ifdef SUPERFLUOUS
+	.lock = op_lock,
+	.bmap = op_bmap,
+	.ioctl = op_ioctl,
+	.poll = op_poll,
+#endif
+};
+
+int main(int argc, char *argv[])
+{
+	errcode_t err;
+	ext2_filsys fs;
+	char *tok, *arg;
+	int i;
+	int readwrite = 1;
+
+	if (argc < 2) {
+		printf("Usage: %s dev mntpt [fuse_args]\n", argv[0]);
+		return 1;
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
+		}
+	}
+
+	err = ext2fs_open(argv[1], (readwrite ? EXT2_FLAG_RW : 0), 0, 0,
+			  unix_io_manager, &fs);
+	if (err)
+		return err;
+
+	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER) {
+		err = -EINVAL;
+		printf("Journal needs recovery; running `e2fsck -E "
+		       "journal_only' is required.\n");
+		goto out;
+	}
+
+	if (readwrite) {
+		err = ext2fs_read_inode_bitmap(fs);
+		if (err)
+			goto out;
+		err = ext2fs_read_block_bitmap(fs);
+		if (err)
+			goto out;
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
+
+	if (fs->super->s_state & EXT2_ERROR_FS) {
+		printf("Errors detected; running e2fsck is required.\n");
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (readwrite) {
+		fs->super->s_mnt_count++;
+		fs->super->s_mtime = time(NULL);
+		fs->super->s_state &= ~EXT2_VALID_FS;
+		ext2fs_mark_super_dirty(fs);
+		err = ext2fs_flush2(fs, 0);
+		if (err) {
+			err = -EIO;
+			goto out;
+		}
+	}
+
+	fuse_main(argc - 1, argv + 1, &fs_ops, fs);
+
+	if (readwrite) {
+		fs->super->s_state |= EXT2_VALID_FS;
+		ext2fs_mark_super_dirty(fs);
+		err = ext2fs_set_gdt_csum(fs);
+	}
+out:
+	if (err)
+		ext2fs_close(fs);
+	else
+		err = ext2fs_close(fs);
+
+	return err;
+}

