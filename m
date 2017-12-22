From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] misc: add e2mmpstatus utility
Date: Fri, 22 Dec 2017 02:22:44 -0700
Message-ID: <1513934564-89598-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Shuichi Ihara <sihara@ddn.com>,
        Li Xi <lixi@ddn.com>, Wang Shilong <wshilong@ddn.com>,
        Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-so.shaw.ca ([64.59.136.138]:45748 "EHLO
        smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932956AbdLVJWr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Dec 2017 04:22:47 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Shuichi Ihara <sihara@ddn.com>

e2mmpstatus is an MMP helper utility to read status from an MMP block.
It outputs the latest MMP updated nodename and time for the device.

Signed-off-by: Shuichi Ihara <sihara@ddn.com>
Signed-off-by: Li Xi <lixi@ddn.com>
Signed-off-by: Wang Shilong <wshilong@ddn.com>
Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 .gitignore                   |   2 +
 configure                    |  36 ++++++-
 configure.ac                 |  27 +++++
 e2fsprogs.spec.in            |   2 +
 lib/config.h.in              |  15 ++-
 lib/ext2fs/mmp.c             |   4 +-
 misc/Makefile.in             |  25 ++++-
 misc/e2mmpstatus.8.in        |  57 +++++++++++
 misc/e2mmpstatus.c           | 234 +++++++++++++++++++++++++++++++++++++++++++
 tests/m_mmp_bad_csum/expect  |   5 +
 tests/m_mmp_bad_csum/script  |   1 +
 tests/m_mmp_bad_magic/expect |   5 +
 tests/m_mmp_bad_magic/script |   1 +
 tests/test_config            |   1 +
 14 files changed, 405 insertions(+), 10 deletions(-)
 create mode 100644 misc/e2mmpstatus.8.in
 create mode 100644 misc/e2mmpstatus.c

diff --git a/.gitignore b/.gitignore
index d3bcefc..30fd9cc 100644
--- a/.gitignore
+++ b/.gitignore
@@ -169,6 +169,8 @@ misc/e2image
 misc/e2image.8
 misc/e2initrd_helper
 misc/e2label.8
+misc/e2mmpstatus
+misc/e2mmpstatus.8
 misc/e2undo
 misc/e2undo.8
 misc/e4defrag
diff --git a/configure b/configure
index b2701d2..110f010 100755
--- a/configure
+++ b/configure
@@ -736,6 +736,8 @@ TDB_CMT
 UUIDD_CMT
 E2INITRD_MAN
 E2INITRD_PROG
+E2MMPSTATUS_MAN
+E2MMPSTATUS_PROG
 FSCK_MAN
 FSCK_PROG
 DEFRAG_CMT
@@ -875,6 +877,7 @@ enable_imager
 enable_resizer
 enable_defrag
 enable_fsck
+enable_e2mmpstatus
 enable_e2initrd_helper
 enable_tls
 enable_uuidd
@@ -1549,6 +1552,7 @@ Optional Features:
   --disable-resizer   	  disable support of e2resize program
   --disable-defrag   	  disable support of e4defrag program
   --enable-fsck           build fsck wrapper program
+  --enable-e2mmpstatus           build e2mmpstatus program
   --enable-e2initrd-helper build e2initrd-helper program
   --disable-tls           disable use of thread local support
   --disable-uuidd         disable building the uuid daemon
@@ -5782,6 +5786,36 @@ fi
 
 
 
+# Check whether --enable-e2mmpstatus was given.
+if test "${enable_e2mmpstatus+set}" = set; then :
+  enableval=$enable_e2mmpstatus; if test "$enableval" = "no"
+then
+	E2MMPSTATUS_PROG='' E2MMPSTATUS_MAN=''
+	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Not building e2mmpstatus" >&5
+$as_echo "Not building e2mmpstatus" >&6; }
+else
+	E2MMPSTATUS_PROG=e2mmpstatus E2MMPSTATUS_MAN=e2mmpstatus.8
+	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Building e2mmpstatus" >&5
+$as_echo "Building e2mmpstatus" >&6; }
+fi
+
+else
+  case "$host_os" in
+  gnu*)
+    E2MMPSTATUS_PROG='' E2MMPSTATUS_MAN=''
+    { $as_echo "$as_me:${as_lineno-$LINENO}: result: No e2mmpstatus by default" >&5
+$as_echo "No e2mmpstatus by default" >&6; }
+    ;;
+  *)
+    E2MMPSTATUS_PROG=e2mmpstatus E2MMPSTATUS_MAN=e2mmpstatus.8
+    { $as_echo "$as_me:${as_lineno-$LINENO}: result: Building e2mmpstatus by default" >&5
+$as_echo "Building e2mmpstatus by default" >&6; }
+esac
+
+fi
+
+
+
 # Check whether --enable-e2initrd-helper was given.
 if test "${enable_e2initrd_helper+set}" = set; then :
   enableval=$enable_e2initrd_helper; if test "$enableval" = "no"
@@ -13097,7 +13131,7 @@ fi
 if test -n "$DLOPEN_LIB" ; then
    ac_cv_func_dlopen=yes
 fi
-for ac_func in  	__secure_getenv 	add_key 	backtrace 	blkid_probe_get_topology 	blkid_probe_enable_partitions 	chflags 	dlopen 	fadvise64 	fallocate 	fallocate64 	fchown 	fcntl 	fdatasync 	fstat64 	fsync 	ftruncate64 	futimes 	getcwd 	getdtablesize 	getmntinfo 	getpwuid_r 	getrlimit 	getrusage 	jrand48 	keyctl 	llistxattr 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	mempcpy 	mmap 	msync 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_fadvise64 	posix_memalign 	prctl 	pread 	pwrite 	pread64 	pwrite64 	secure_getenv 	setmntent 	setresgid 	setresuid 	snprintf 	srandom 	stpcpy 	strcasecmp 	strdup 	strnlen 	strptime 	strtoull 	sync_file_range 	sysconf 	usleep 	utime 	utimes 	valloc
+for ac_func in  	__secure_getenv 	add_key 	backtrace 	blkid_probe_get_topology 	blkid_probe_enable_partitions 	chflags 	dlopen 	fadvise64 	fallocate 	fallocate64 	fchown 	fcntl 	fdatasync 	fstat64 	fsync 	ftruncate64 	futimes 	getcwd 	getdtablesize 	gethostname 	getmntinfo 	getpwuid_r 	getrlimit 	getrusage 	jrand48 	keyctl 	llistxattr 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	mempcpy 	mmap 	msync 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_fadvise64 	posix_memalign 	prctl 	pread 	pwrite 	pread64 	pwrite64 	secure_getenv 	setmntent 	setresgid 	setresuid 	snprintf 	srandom 	stpcpy 	strcasecmp 	strdup 	strnlen 	strptime 	strtoull 	sync_file_range 	sysconf 	usleep 	utime 	utimes 	valloc
 do :
   as_ac_var=`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
 ac_fn_c_check_func "$LINENO" "$ac_func" "$as_ac_var"
diff --git a/configure.ac b/configure.ac
index 7392959..cfb5911 100644
--- a/configure.ac
+++ b/configure.ac
@@ -685,6 +685,32 @@ esac]
 AC_SUBST(FSCK_PROG)
 AC_SUBST(FSCK_MAN)
 dnl
+dnl See whether to install the `e2mmpstatus' program
+dnl
+AC_ARG_ENABLE([e2mmpstatus],
+[  --enable-e2mmpstatus           build e2mmpstatus program],
+[if test "$enableval" = "no"
+then
+	E2MMPSTATUS_PROG='' E2MMPSTATUS_MAN=''
+	AC_MSG_RESULT([Not building e2mmpstatus])
+else
+	E2MMPSTATUS_PROG=e2mmpstatus E2MMPSTATUS_MAN=e2mmpstatus.8
+	AC_MSG_RESULT([Building e2mmpstatus])
+fi]
+,
+[case "$host_os" in
+  gnu*)
+    E2MMPSTATUS_PROG='' E2MMPSTATUS_MAN=''
+    AC_MSG_RESULT([No e2mmpstatus by default])
+    ;;
+  *)
+    E2MMPSTATUS_PROG=e2mmpstatus E2MMPSTATUS_MAN=e2mmpstatus.8
+    AC_MSG_RESULT([Building e2mmpstatus by default])
+esac]
+)
+AC_SUBST(E2MMPSTATUS_PROG)
+AC_SUBST(E2MMPSTATUS_MAN)
+dnl
 dnl See whether to install the `e2initrd-helper' program
 dnl
 AC_ARG_ENABLE([e2initrd-helper],
@@ -1124,6 +1150,7 @@ AC_CHECK_FUNCS(m4_flatten([
 	futimes
 	getcwd
 	getdtablesize
+	gethostname
 	getmntinfo
 	getpwuid_r
 	getrlimit
diff --git a/e2fsprogs.spec.in b/e2fsprogs.spec.in
index b188b75..f42c4be 100644
--- a/e2fsprogs.spec.in
+++ b/e2fsprogs.spec.in
@@ -116,6 +116,7 @@ exit 0
 %{_root_sbindir}/e2fsck
 %{_root_sbindir}/e2image
 %{_root_sbindir}/e2label
+%{_root_sbindir}/e2mmpstatus
 %{_root_sbindir}/e2undo
 %{_root_sbindir}/findfs
 %{_root_sbindir}/fsck
@@ -167,6 +168,7 @@ exit 0
 %{_mandir}/man8/fsck.ext4dev.8*
 %{_mandir}/man8/e2image.8*
 %{_mandir}/man8/e2label.8*
+%{_mandir}/man8/e2mmpstatus.8*
 %{_mandir}/man8/e2undo.8*
 %{_mandir}/man8/fsck.8*
 %{_mandir}/man8/logsave.8*
diff --git a/lib/config.h.in b/lib/config.h.in
index 9cc0793..67a0548 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -147,6 +147,9 @@
 /* Define to 1 if you have the `fchown' function. */
 #undef HAVE_FCHOWN
 
+/* Define to 1 if you have the `fcntl' function. */
+#undef HAVE_FCNTL
+
 /* Define to 1 if you have the `fdatasync' function. */
 #undef HAVE_FDATASYNC
 
@@ -156,6 +159,9 @@
 /* Define to 1 if you have the `fstat64' function. */
 #undef HAVE_FSTAT64
 
+/* Define to 1 if you have the `fsync' function. */
+#undef HAVE_FSYNC
+
 /* Define to 1 if you have the `ftruncate64' function. */
 #undef HAVE_FTRUNCATE64
 
@@ -183,6 +189,9 @@
 /* Define to 1 if you have the `getgid' function. */
 #undef HAVE_GETGID
 
+/* Define to 1 if you have the `gethostname' function. */
+#undef HAVE_GETHOSTNAME
+
 /* Define to 1 if you have the `getmntinfo' function. */
 #undef HAVE_GETMNTINFO
 
@@ -253,6 +262,9 @@
 /* Define to 1 if you have the <linux/major.h> header file. */
 #undef HAVE_LINUX_MAJOR_H
 
+/* Define to 1 if you have the <linux/types.h> header file. */
+#undef HAVE_LINUX_TYPES_H
+
 /* Define to 1 if you have the `llistxattr' function. */
 #undef HAVE_LLISTXATTR
 
@@ -470,9 +482,6 @@
 /* Define to 1 if you have the `sync_file_range' function. */
 #undef HAVE_SYNC_FILE_RANGE
 
-/* Define to 1 if you have the 'fsync' function. */
-#undef HAVE_FSYNC
-
 /* Define to 1 if you have the `sysconf' function. */
 #undef HAVE_SYSCONF
 
diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
index 9a771de..85bd8ff 100644
--- a/lib/ext2fs/mmp.c
+++ b/lib/ext2fs/mmp.c
@@ -194,7 +194,7 @@ static errcode_t ext2fs_mmp_reset(ext2_filsys fs)
 	mmp_s->mmp_magic = EXT4_MMP_MAGIC;
 	mmp_s->mmp_seq = EXT4_MMP_SEQ_CLEAN;
 	mmp_s->mmp_time = 0;
-#if _BSD_SOURCE || _XOPEN_SOURCE >= 500
+#ifdef HAVE_GETHOSTNAME
 	gethostname(mmp_s->mmp_nodename, sizeof(mmp_s->mmp_nodename));
 #else
 	mmp_s->mmp_nodename[0] = '\0';
@@ -332,7 +332,7 @@ clean_seq:
 		goto mmp_error;
 
 	mmp_s->mmp_seq = seq = ext2fs_mmp_new_seq();
-#if _BSD_SOURCE || _XOPEN_SOURCE >= 500
+#ifdef HAVE_GETHOSTNAME
 	gethostname(mmp_s->mmp_nodename, sizeof(mmp_s->mmp_nodename));
 #else
 	strcpy(mmp_s->mmp_nodename, "unknown host");
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 6f631eb..d7f9ceb 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -33,13 +33,14 @@ INSTALL = @INSTALL@
 @FUSE_CMT@FUSE_PROG= fuse2fs
 
 SPROGS=		mke2fs badblocks tune2fs dumpe2fs $(BLKID_PROG) logsave \
-			$(E2IMAGE_PROG) @FSCK_PROG@ e2undo
+			$(E2IMAGE_PROG) @FSCK_PROG@ @E2MMPSTATUS_PROG@ e2undo
 USPROGS=	mklost+found filefrag e2freefrag $(UUIDD_PROG) \
 			$(E4DEFRAG_PROG) $(E4CRYPT_PROG) $(FUSE_PROG)
 SMANPAGES=	tune2fs.8 mklost+found.8 mke2fs.8 dumpe2fs.8 badblocks.8 \
 			e2label.8 $(FINDFS_MAN) $(BLKID_MAN) $(E2IMAGE_MAN) \
 			logsave.8 filefrag.8 e2freefrag.8 e2undo.8 \
-			$(UUIDD_MAN) $(E4DEFRAG_MAN) $(E4CRYPT_MAN) @FSCK_MAN@
+			$(UUIDD_MAN) $(E4DEFRAG_MAN) $(E4CRYPT_MAN) @FSCK_MAN@ \
+			@E2MMPSTATUS_MAN@
 FMANPAGES=	mke2fs.conf.5 ext4.5
 
 UPROGS=		chattr lsattr @UUID_CMT@ uuidgen
@@ -67,6 +68,7 @@ E4DEFRAG_OBJS=	e4defrag.o
 E4CRYPT_OBJS=   e4crypt.o
 E2FREEFRAG_OBJS= e2freefrag.o
 E2FUZZ_OBJS=	e2fuzz.o
+E2MMPSTATUS_OBJS=	e2mmpstatus.o
 FUSE2FS_OBJS=	fuse2fs.o journal.o recovery.o revoke.o
 
 PROFILED_TUNE2FS_OBJS=	profiled/tune2fs.o profiled/util.o profiled/journal.o \
@@ -91,6 +93,7 @@ PROFILED_E2FREEFRAG_OBJS= profiled/e2freefrag.o
 PROFILED_E2UNDO_OBJS=	profiled/e2undo.o
 PROFILED_E4DEFRAG_OBJS=	profiled/e4defrag.o
 PROFILED_E4CRYPT_OBJS=	profiled/e4crypt.o
+PROFILED_E2MMPSTATUS_OBJS=	profiled/e2mmpstatus.o
 PROFILED_FUSE2FS_OJBS=	profiled/fuse2fs.o profiled/journal.o \
 			profiled/recovery.o profiled/revoke.o
 
@@ -101,7 +104,7 @@ SRCS=	$(srcdir)/tune2fs.c $(srcdir)/mklost+found.c $(srcdir)/mke2fs.c $(srcdir)/
 		$(srcdir)/filefrag.c $(srcdir)/base_device.c \
 		$(srcdir)/ismounted.c $(srcdir)/e2undo.c \
 		$(srcdir)/e2freefrag.c $(srcdir)/create_inode.c \
-		$(srcdir)/fuse2fs.c \
+		$(srcdir)/e2mmpstatus.c $(srcdir)/fuse2fs.c \
 		$(srcdir)/../debugfs/journal.c $(srcdir)/../e2fsck/revoke.c \
 		$(srcdir)/../e2fsck/recovery.c
 
@@ -137,7 +140,7 @@ all:: profiled $(SPROGS) $(UPROGS) $(USPROGS) $(SMANPAGES) $(UMANPAGES) \
 	e2undo.profiled mke2fs.profiled dumpe2fs.profiled fsck.profiled \
 	logsave.profiled filefrag.profiled uuidgen.profiled $(UUIDD_PROFILED) \
 	e2image.profiled e4defrag.profiled e4crypt.profiled \
-	e2freefrag.profiled
+	e2freefrag.profiled e2mmpstatus.profiled
 
 profiled:
 @PROFILE_CMT@	$(E) "	MKDIR $@"
@@ -247,6 +250,16 @@ e4crypt.profiled: $(E4CRYPT_OBJS) $(DEPPROFILED_LIBUUID) $(PROFILED_DEPLIBS)
 		$(PROFILED_E4CRYPT_OBJS) $(PROFILED_LIBUUID) $(PROFILED_LIBS) \
 		$(SYSLIBS)
 
+e2mmpstatus: $(E2MMPSTATUS_OBJS) $(DEPLIBBLKID)
+	$(E) "	LD $@"
+	$(Q) $(CC) $(ALL_LDFLAGS) -o e2mmpstatus $(E2MMPSTATUS_OBJS) \
+		$(LIBBLKID) $(LIBINTL) $(LIBS)
+
+e2mmpstatus.profiled: $(E2MMPSTATUS_OBJS) $(PROFILED_DEPLIBBLKID)
+	$(E) "	LD $@"
+	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o e2mmpstatus.profiled \
+		$(PROFILED_E2MMPSTATUS_OBJS) $(PROFILED_LIBBLKID) $(LIBINTL)
+
 base_device: base_device.c
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) $(srcdir)/base_device.c \
@@ -459,6 +472,10 @@ e4crypt.8: $(DEP_SUBSTITUTE) $(srcdir)/e4crypt.8.in
 	$(E) "	SUBST $@"
 	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/e4crypt.8.in e4crypt.8
 
+e2mmpstatus.8: $(DEP_SUBSTITUTE) $(srcdir)/e2mmpstatus.8.in
+	$(E) "	SUBST $@"
+	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/e2mmpstatus.8.in e2mmpstatus.8
+
 dumpe2fs.8: $(DEP_SUBSTITUTE) $(srcdir)/dumpe2fs.8.in 
 	$(E) "	SUBST $@"
 	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/dumpe2fs.8.in dumpe2fs.8
diff --git a/misc/e2mmpstatus.8.in b/misc/e2mmpstatus.8.in
new file mode 100644
index 0000000..805fa19
--- /dev/null
+++ b/misc/e2mmpstatus.8.in
@@ -0,0 +1,57 @@
+.\" -*- nroff -*-
+.\" This file may be copied under the terms of the GNU Public License.
+.\"
+.TH E2MMPSTATUS 8 "@E2FSPROGS_MONTH@ @E2FSPROGS_YEAR@" "E2fsprogs version @E2FSPROGS_VERSION@"
+.SH NAME
+e2mmpstatus \- Check MMP status of an ext4 filesystem
+.SH SYNOPSIS
+.B e2mmpstatus
+.RB [ \-i | \--info ]
+.RI < filesystem >
+.SH OPTIONS
+.TP
+.B \-i, \--info
+prints out the MMP information rather than check it.
+.SH DESCRIPTION
+.B e2mmpstatus
+is used to check Multiple-Mount Protection (MMP) status of an ext4 file
+system with the
+.B mmp
+feature enabled.  The
+.I filesystem
+can be a device name (e.g.
+.IR /dev/hdc1 ", " /dev/sdb2 ),
+or an ext4 filesystem label or UUID, for example
+.B UUID=8868abf6-88c5-4a83-98b8-bfc24057f7bd
+or
+.BR LABEL=root .
+By default, the
+.B e2mmpstatus
+program checks whether it is safe to mount the filesystem without taking
+the risk of mounting it more than once.
+.PP
+MMP (multiple-mount protection) is a feature that protects
+the filesystem from being mounted simultaneously to more than one node.
+It is NOT safe to mount a filesystem when one of the following condition
+is true:
+.br
+\	1. The MMP block shows that fsck is running on the filesystem.
+.br
+\	2. The MMP block is being updated by another node.
+.br
+The
+.B e2mmpstatus
+program might wait for some time to see whether MMP is updated by any node
+during this period.  The time taken depends on how often the MMP block is
+being written by the other node.
+.SH RETURN CODE
+The exit code returned by
+.B e2mmpstatus
+is 0 when it is safe to mount the filesystem, 1 when it is NOT safe to mount
+the filesystem, and 2 on some other failure. When
+.B \-i
+flag is specified, the exit code
+is 0 on success, 2 on failure.
+.SH SEE ALSO
+.BR fstab (5),
+.BR fsck (8),
diff --git a/misc/e2mmpstatus.c b/misc/e2mmpstatus.c
new file mode 100644
index 0000000..b269daa
--- /dev/null
+++ b/misc/e2mmpstatus.c
@@ -0,0 +1,234 @@
+/*
+ * GPL HEADER START
+ *
+ * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 only,
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License version 2 for more details (a copy is included
+ * in the LICENSE file that accompanied this code).
+ *
+ * You should have received a copy of the GNU General Public License
+ * version 2 along with this program; if not, see
+ * http://www.gnu.org/licenses/gpl-2.0.html
+ *
+ * GPL HEADER END
+ */
+/*
+ * Copyright (C) 2012 DataDirect Networks, Inc.
+ */
+
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <assert.h>
+#include <time.h>
+#include <getopt.h>
+#include <sys/time.h>
+#include "ext2fs/ext2fs.h"
+#include "blkid/blkid.h"
+
+#ifndef min
+#define min(x, y) ((x) < (y) ? (x) : (y))
+#endif
+
+int check_mmp(const char *program, ext2_filsys filesystem, int dump)
+{
+	struct ext2_super_block *sb;
+	struct mmp_struct *mmp_s;
+	unsigned int interval;
+	__u32 seq;
+	int ret;
+
+	assert(filesystem);
+	sb = filesystem->super;
+
+	if (filesystem->mmp_buf == NULL) {
+		ret = ext2fs_get_mem(filesystem->blocksize,
+				     &filesystem->mmp_buf);
+		if (ret) {
+			fprintf(stderr, "%s: failed to alloc MMP buffer\n",
+				program);
+			ret = 2;
+			goto out;
+		}
+	}
+
+	mmp_s = filesystem->mmp_buf;
+	ret = ext2fs_mmp_read(filesystem, filesystem->super->s_mmp_block,
+			      filesystem->mmp_buf);
+
+	if (ret) {
+		fprintf(stderr, "%s: failed to read MMP block\n", program);
+		ret = 2;
+		goto out;
+	}
+
+	if (dump) {
+		time_t mmp_time = mmp_s->mmp_time;
+		char *ctimep, *ctimelf;
+
+		fprintf(stdout, "MMP_information:\n");
+		fprintf(stdout, "    mmp_magic: 0x%x\n", mmp_s->mmp_magic);
+		fprintf(stdout, "    block_number: %llu\n",
+			filesystem->super->s_mmp_block);
+		fprintf(stdout, "    update_interval: %d\n",
+			filesystem->super->s_mmp_update_interval);
+		fprintf(stdout, "    check_interval: %d\n",
+			mmp_s->mmp_check_interval);
+		fprintf(stdout, "    sequence: %08x\n", mmp_s->mmp_seq);
+		fprintf(stdout, "    update_seconds: %lld\n", mmp_s->mmp_time);
+		ctimep = ctime(&mmp_time);
+		ctimelf = strchr(ctimep, '\n');
+		if (ctimelf) /* this should always be true */
+			*ctimelf = '\0';
+		fprintf(stdout, "    update_time: \"%s\"\n", ctimep);
+		fprintf(stdout, "    node_name: %s\n", mmp_s->mmp_nodename);
+		fprintf(stdout, "    device_name: %s\n", mmp_s->mmp_bdevname);
+	} else {
+		if (mmp_s->mmp_seq == EXT4_MMP_SEQ_CLEAN) {
+			fprintf(stdout,
+				"%s: it is safe to mount '%s', MMP is clean\n",
+				program, mmp_s->mmp_bdevname);
+			ret = 1;
+			goto out;
+		} else if (mmp_s->mmp_seq == EXT4_MMP_SEQ_FSCK) {
+			fprintf(stdout, "%s: filesystem '%s' used by e2fsck\n",
+				program, mmp_s->mmp_nodename);
+			ret = 0;
+			goto out;
+		}
+		seq = mmp_s->mmp_seq;
+
+		interval = filesystem->super->s_mmp_update_interval;
+		if (interval < mmp_s->mmp_check_interval)
+			interval = mmp_s->mmp_check_interval;
+		interval = min(interval * 2 + 1, interval + 60);
+		assert(interval > 0);
+
+		fprintf(stderr, "%s: wait for %d seconds to check MMP\n",
+			program, interval);
+		sleep(interval);
+
+		ret = ext2fs_mmp_read(filesystem,
+				      filesystem->super->s_mmp_block,
+				      filesystem->mmp_buf);
+		if (ret) {
+			fprintf(stderr, "%s: failed to read '%s' MMP block\n",
+				program, mmp_s->mmp_bdevname);
+			ret = 2;
+			goto out;
+		}
+
+		if (mmp_s->mmp_seq == EXT4_MMP_SEQ_CLEAN) {
+			fprintf(stdout, "%s: it is safe to mount '%s', "
+				"MMP became clean while checking\n",
+				program, mmp_s->mmp_bdevname);
+			ret = 0;
+		} else if (mmp_s->mmp_seq == EXT4_MMP_SEQ_FSCK) {
+			fprintf(stdout,
+				"%s: e2fsck started on '%s' while checking\n",
+				program, mmp_s->mmp_bdevname);
+			ret = 1;
+		} else if (mmp_s->mmp_seq == seq) {
+			fprintf(stdout,
+				"%s: it is safe to mount '%s', MMP is idle\n",
+				program, mmp_s->mmp_bdevname);
+			ret = 0;
+		} else {
+			/* MMP updated */
+			fprintf(stdout,
+				"%s: MMP updated by '%s' %u times in %ds\n",
+				program, mmp_s->mmp_nodename,
+				mmp_s->mmp_seq - seq, interval);
+			ret = 1;
+		}
+	}
+
+out:
+	return ret;
+}
+
+void usage(const char *program)
+{
+	fprintf(stderr, "usage: %s [-i|--info] device\n"
+		"\t-i: print out MMP information rather than check status\n",
+		program);
+}
+
+/*
+ * Return 1 when MMP is being updated,
+ * 0 if not, and 2 on falure
+ */
+int main(int argc, char **argv)
+{
+	char       *device_name;
+	int         open_flags = 0;
+	blk64_t     superblock = 0;
+	blk64_t     blocksize = 0;
+	ext2_filsys filesystem = NULL;
+	int         ret;
+	struct option long_opts[] = {
+		{"info",     no_argument, 0, 'i'},
+		{"help",      no_argument, 0, 'h'},
+		{0, 0, 0, 0}
+	};
+	int c;
+	int info = 0;
+
+	while ((c = getopt_long_only(argc, argv, "ih",
+				     long_opts, NULL)) >= 0) {
+		switch (c) {
+		case 'i':
+			info++;
+			break;
+		case 'h':
+			usage(argv[0]);
+			ret = 2;
+			goto out;
+		default:
+			fprintf(stderr, "%s: option '%s' unrecognized\n",
+				argv[0], argv[optind - 1]);
+			usage(argv[0]);
+			ret = 2;
+			goto out;
+		}
+	}
+
+	if (optind != argc - 1) {
+		usage(argv[0]);
+		ret = 2;
+		goto out;
+	}
+
+	device_name = blkid_get_devname(NULL, argv[optind], NULL);
+	if (device_name == NULL) {
+		fprintf(stderr, "%s: failed to get device for '%s'\n",
+			argv[0], argv[optind]);
+		ret = 2;
+		goto out;
+	}
+
+	ret = ext2fs_open(device_name, open_flags, superblock, blocksize,
+			  unix_io_manager, &filesystem);
+	if (ret) {
+		fprintf(stderr, "%s: failed to open filesystem '%s', "
+				"is it a valid ext4 filesystem?\n",
+				argv[0], device_name);
+		ret = 2;
+		goto out_free_device;
+	}
+
+	ret = check_mmp(argv[0], filesystem, info);
+	ext2fs_close(filesystem);
+out_free_device:
+	free(device_name);
+out:
+	assert(ret == 0 || ret == 1 || ret == 2);
+	return ret;
+}
diff --git a/tests/m_mmp_bad_csum/expect b/tests/m_mmp_bad_csum/expect
index e15e7b4..4a71f0e 100644
--- a/tests/m_mmp_bad_csum/expect
+++ b/tests/m_mmp_bad_csum/expect
@@ -7,3 +7,8 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 test_filesys: 11/128 files (0.0% non-contiguous), 19/512 blocks
 Exit status is 0
+MMP_information:
+    mmp_magic: 0x4d4d50
+    block_number: 8
+    check_interval: 5
+    sequence: ff4d4d50
diff --git a/tests/m_mmp_bad_csum/script b/tests/m_mmp_bad_csum/script
index 09e870c..1ae4051 100644
--- a/tests/m_mmp_bad_csum/script
+++ b/tests/m_mmp_bad_csum/script
@@ -14,6 +14,7 @@ OUT=$test_name.log
 EXP=$test_dir/expect
 $FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed > $OUT
 echo Exit status is $? >> $OUT
+$E2MMPSTATUS -i $TMPFILE | egrep -v "node_name:|update_|device_name:" >> $OUT
 
 rm -f $TMPFILE
 cmp -s $OUT $EXP
diff --git a/tests/m_mmp_bad_magic/expect b/tests/m_mmp_bad_magic/expect
index b5dfb89..787a1de 100644
--- a/tests/m_mmp_bad_magic/expect
+++ b/tests/m_mmp_bad_magic/expect
@@ -7,3 +7,8 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 test_filesys: 11/128 files (0.0% non-contiguous), 19/512 blocks
 Exit status is 0
+MMP_information:
+    mmp_magic: 0x4d4d50
+    block_number: 8
+    check_interval: 5
+    sequence: ff4d4d50
diff --git a/tests/m_mmp_bad_magic/script b/tests/m_mmp_bad_magic/script
index 09e870c..1ae4051 100644
--- a/tests/m_mmp_bad_magic/script
+++ b/tests/m_mmp_bad_magic/script
@@ -14,6 +14,7 @@ OUT=$test_name.log
 EXP=$test_dir/expect
 $FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed > $OUT
 echo Exit status is $? >> $OUT
+$E2MMPSTATUS -i $TMPFILE | egrep -v "node_name:|update_|device_name:" >> $OUT
 
 rm -f $TMPFILE
 cmp -s $OUT $EXP
diff --git a/tests/test_config b/tests/test_config
index c13aa74..fe79c02 100644
--- a/tests/test_config
+++ b/tests/test_config
@@ -18,6 +18,7 @@ RESIZE2FS_EXE="../resize/resize2fs"
 RESIZE2FS="$USE_VALGRIND $RESIZE2FS_EXE"
 E2UNDO_EXE="../misc/e2undo"
 E2UNDO="$USE_VALGRIND $E2UNDO_EXE"
+E2MMPSTATUS="$USE_VALGRIND ../misc/e2mmpstatus"
 TEST_REL=../tests/progs/test_rel
 TEST_ICOUNT=../tests/progs/test_icount
 CRCSUM=../tests/progs/crcsum
-- 
1.8.0
