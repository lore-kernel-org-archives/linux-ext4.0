From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 14/34] misc: use libmagic when libblkid can't identify
 something
Date: Sat, 13 Sep 2014 15:12:46 -0700
Message-ID: <20140913221246.13646.27212.stgit@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32269 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbaIMWMw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2014 18:12:52 -0400
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we're using check_plausibility() to try to identify something that
obviously isn't an ext* filesystem and libblkid doesn't know what it
is, try libmagic instead.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 MCONFIG.in                           |    1 +
 configure                            |   54 ++++++++++++++++++++++++++++++++++
 configure.in                         |    6 ++++
 debugfs/Makefile.in                  |    4 +--
 e2fsck/Makefile.in                   |    4 +--
 lib/config.h.in                      |    3 ++
 misc/Makefile.in                     |   23 ++++++++------
 misc/plausible.c                     |   22 ++++++++++++++
 tests/f_detect_junk/expect           |   25 ++++++++++++++++
 tests/f_detect_junk/expect.nodebugfs |   23 ++++++++++++++
 tests/f_detect_junk/image.bz2        |  Bin
 tests/f_detect_junk/name             |    1 +
 tests/f_detect_junk/script           |   43 +++++++++++++++++++++++++++
 13 files changed, 195 insertions(+), 14 deletions(-)
 create mode 100644 tests/f_detect_junk/expect
 create mode 100644 tests/f_detect_junk/expect.nodebugfs
 create mode 100644 tests/f_detect_junk/image.bz2
 create mode 100644 tests/f_detect_junk/name
 create mode 100755 tests/f_detect_junk/script


diff --git a/MCONFIG.in b/MCONFIG.in
index 2a5055f..4751176 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -114,6 +114,7 @@ LIBCOM_ERR = $(LIB)/libcom_err@LIB_EXT@ @PRIVATE_LIBS_CMT@ @SEM_INIT_LIB@
 LIBE2P = $(LIB)/libe2p@LIB_EXT@
 LIBEXT2FS = $(LIB)/libext2fs@LIB_EXT@
 LIBUUID = @LIBUUID@ @SOCKET_LIB@
+LIBMAGIC = @MAGIC_LIB@
 LIBQUOTA = @STATIC_LIBQUOTA@
 LIBBLKID = @LIBBLKID@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
 LIBINTL = @LIBINTL@
diff --git a/configure b/configure
index 0ea5fc5..ac2fba0 100755
--- a/configure
+++ b/configure
@@ -643,6 +643,7 @@ CYGWIN_CMT
 LINUX_CMT
 UNI_DIFF_OPTS
 SEM_INIT_LIB
+MAGIC_LIB
 SOCKET_LIB
 SIZEOF_OFF_T
 SIZEOF_LONG_LONG
@@ -13125,6 +13126,59 @@ if test "x$ac_cv_lib_socket_socket" = xyes; then :
 fi
 
 
+{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for magic_file in -lmagic" >&5
+$as_echo_n "checking for magic_file in -lmagic... " >&6; }
+if ${ac_cv_lib_magic_magic_file+:} false; then :
+  $as_echo_n "(cached) " >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-lmagic  $LIBS"
+cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char magic_file ();
+int
+main ()
+{
+return magic_file ();
+  ;
+  return 0;
+}
+_ACEOF
+if ac_fn_c_try_link "$LINENO"; then :
+  ac_cv_lib_magic_magic_file=yes
+else
+  ac_cv_lib_magic_magic_file=no
+fi
+rm -f core conftest.err conftest.$ac_objext \
+    conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_cv_lib_magic_magic_file" >&5
+$as_echo "$ac_cv_lib_magic_magic_file" >&6; }
+if test "x$ac_cv_lib_magic_magic_file" = xyes; then :
+  MAGIC_LIB=-lmagic
+for ac_header in magic.h
+do :
+  ac_fn_c_check_header_mongrel "$LINENO" "magic.h" "ac_cv_header_magic_h" "$ac_includes_default"
+if test "x$ac_cv_header_magic_h" = xyes; then :
+  cat >>confdefs.h <<_ACEOF
+#define HAVE_MAGIC_H 1
+_ACEOF
+
+fi
+
+done
+
+fi
+
+
 { $as_echo "$as_me:${as_lineno-$LINENO}: checking for optreset" >&5
 $as_echo_n "checking for optreset... " >&6; }
 if ${ac_cv_have_optreset+:} false; then :
diff --git a/configure.in b/configure.in
index 5106f96..98dca5e 100644
--- a/configure.in
+++ b/configure.in
@@ -1146,6 +1146,12 @@ SOCKET_LIB=''
 AC_CHECK_LIB(socket, socket, [SOCKET_LIB=-lsocket])
 AC_SUBST(SOCKET_LIB)
 dnl
+dnl See if libmagic exists
+dnl
+AC_CHECK_LIB(magic, magic_file, [MAGIC_LIB=-lmagic
+AC_CHECK_HEADERS([magic.h])])
+AC_SUBST(MAGIC_LIB)
+dnl
 dnl See if optreset exists
 dnl
 AC_MSG_CHECKING(for optreset)
diff --git a/debugfs/Makefile.in b/debugfs/Makefile.in
index b33f73b..f6eae6c 100644
--- a/debugfs/Makefile.in
+++ b/debugfs/Makefile.in
@@ -37,13 +37,13 @@ SRCS= debug_cmds.c $(srcdir)/debugfs.c $(srcdir)/util.c $(srcdir)/ls.c \
 	$(srcdir)/../misc/plausible.c
 
 LIBS= $(LIBQUOTA) $(LIBEXT2FS) $(LIBE2P) $(LIBSS) $(LIBCOM_ERR) $(LIBBLKID) \
-	$(LIBUUID) $(SYSLIBS) $(LIBINTL)
+	$(LIBUUID) $(SYSLIBS) $(LIBINTL) $(LIBMAGIC)
 DEPLIBS= $(DEPLIBQUOTA) $(LIBEXT2FS) $(LIBE2P) $(DEPLIBSS) $(DEPLIBCOM_ERR) \
 	$(DEPLIBBLKID) $(DEPLIBUUID)
 
 STATIC_LIBS= $(STATIC_LIBQUOTA) $(STATIC_LIBEXT2FS) $(STATIC_LIBSS) \
 	$(STATIC_LIBCOM_ERR) $(STATIC_LIBBLKID) $(STATIC_LIBUUID) \
-	$(STATIC_LIBE2P) $(SYSLIBS) $(LIBINTL)
+	$(STATIC_LIBE2P) $(SYSLIBS) $(LIBINTL) $(LIBMAGIC)
 STATIC_DEPLIBS= $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBSS) \
 		$(DEPSTATIC_LIBCOM_ERR) $(DEPSTATIC_LIBUUID) \
 		$(DEPSTATIC_LIBE2P)
diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 1afd15f..5c40fee 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -16,13 +16,13 @@ MANPAGES=	e2fsck.8
 FMANPAGES=	e2fsck.conf.5
 
 LIBS= $(LIBQUOTA) $(LIBEXT2FS) $(LIBCOM_ERR) $(LIBBLKID) $(LIBUUID) \
-	$(LIBINTL) $(LIBE2P) $(SYSLIBS)
+	$(LIBINTL) $(LIBE2P) $(SYSLIBS) $(LIBMAGIC)
 DEPLIBS= $(DEPLIBQUOTA) $(LIBEXT2FS) $(DEPLIBCOM_ERR) $(DEPLIBBLKID) \
 	 $(DEPLIBUUID) $(DEPLIBE2P)
 
 STATIC_LIBS= $(STATIC_LIBQUOTA) $(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR) \
 	     $(STATIC_LIBBLKID) $(STATIC_LIBUUID) $(LIBINTL) $(STATIC_LIBE2P) \
-	     $(SYSLIBS)
+	     $(SYSLIBS) $(LIBMAGIC)
 STATIC_DEPLIBS= $(DEPSTATIC_LIBQUOTA) $(STATIC_LIBEXT2FS) \
 		$(DEPSTATIC_LIBCOM_ERR) $(DEPSTATIC_LIBBLKID) \
 		$(DEPSTATIC_LIBUUID) $(DEPSTATIC_LIBE2P)
diff --git a/lib/config.h.in b/lib/config.h.in
index be8f976..92fca3e 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -265,6 +265,9 @@
 /* Define to 1 if lseek64 declared in unistd.h */
 #undef HAVE_LSEEK64_PROTOTYPE
 
+/* Define to 1 if you have the <magic.h> header file. */
+#undef HAVE_MAGIC_H
+
 /* Define to 1 if you have the `mallinfo' function. */
 #undef HAVE_MALLINFO
 
diff --git a/misc/Makefile.in b/misc/Makefile.in
index bdeaa49..d19908f 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -165,14 +165,14 @@ tune2fs: $(TUNE2FS_OBJS) $(DEPLIBS) $(DEPLIBS_E2P) $(DEPLIBBLKID) \
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o tune2fs $(TUNE2FS_OBJS) $(LIBS) \
 		$(LIBBLKID) $(LIBUUID) $(LIBQUOTA) $(LIBEXT2FS) $(LIBS_E2P) \
-		$(LIBINTL) $(SYSLIBS) $(LIBBLKID)
+		$(LIBINTL) $(SYSLIBS) $(LIBBLKID) $(LIBMAGIC)
 
 tune2fs.static: $(TUNE2FS_OBJS) $(STATIC_DEPLIBS) $(STATIC_LIBE2P) $(DEPSTATIC_LIBBLKID)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(LDFLAGS_STATIC) -o tune2fs.static $(TUNE2FS_OBJS) \
 		$(STATIC_LIBS) $(STATIC_LIBBLKID) $(STATIC_LIBUUID) \
 		$(STATIC_LIBQUOTA) $(STATIC_LIBE2P) $(LIBINTL) $(SYSLIBS) \
-		$(STATIC_LIBBLKID)
+		$(STATIC_LIBBLKID) $(LIBMAGIC)
 
 tune2fs.profiled: $(TUNE2FS_OBJS) $(PROFILED_DEPLIBS) \
 		$(PROFILED_E2P) $(DEPPROFILED_LIBBLKID) $(DEPPROFILED_LIBUUID) \
@@ -181,7 +181,8 @@ tune2fs.profiled: $(TUNE2FS_OBJS) $(PROFILED_DEPLIBS) \
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o tune2fs.profiled \
 		$(PROFILED_TUNE2FS_OBJS) $(PROFILED_LIBBLKID) \
 		$(PROFILED_LIBUUID) $(PROFILED_LIBQUOTA) $(PROFILED_LIBE2P) \
-		$(LIBINTL) $(PROFILED_LIBS) $(SYSLIBS) $(PROFILED_LIBBLKID)
+		$(LIBINTL) $(PROFILED_LIBS) $(SYSLIBS) $(PROFILED_LIBBLKID) \
+		$(PROFILED_LIBMAGIC)
 
 blkid: $(BLKID_OBJS) $(DEPLIBBLKID) $(LIBEXT2FS)
 	$(E) "	LD $@"
@@ -202,13 +203,13 @@ blkid.profiled: $(BLKID_OBJS) $(DEPPROFILED_LIBBLKID) \
 e2image: $(E2IMAGE_OBJS) $(DEPLIBS) $(DEPLIBBLKID)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o e2image $(E2IMAGE_OBJS) $(LIBS) \
-		$(LIBINTL) $(SYSLIBS) $(LIBBLKID)
+		$(LIBINTL) $(SYSLIBS) $(LIBBLKID) $(LIBMAGIC)
 
 e2image.profiled: $(E2IMAGE_OBJS) $(PROFILED_DEPLIBS) $(DEPLIBBLKID)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o e2image.profiled \
 		$(PROFILED_E2IMAGE_OBJS) $(PROFILED_LIBS) $(LIBINTL) $(SYSLIBS) \
-		$(LIBBLKID)
+		$(LIBBLKID) $(LIBMAGIC)
 
 e2undo: $(E2UNDO_OBJS) $(DEPLIBS)
 	$(E) "	LD $@"
@@ -249,14 +250,15 @@ mke2fs: $(MKE2FS_OBJS) $(DEPLIBS) $(LIBE2P) $(DEPLIBBLKID) $(DEPLIBUUID) \
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o mke2fs $(MKE2FS_OBJS) $(LIBS) $(LIBBLKID) \
 		$(LIBUUID) $(LIBQUOTA) $(LIBEXT2FS) $(LIBE2P) $(LIBINTL) \
-		$(SYSLIBS)
+		$(SYSLIBS) $(LIBMAGIC)
 
 mke2fs.static: $(MKE2FS_OBJS) $(STATIC_DEPLIBS) $(STATIC_LIBE2P) $(DEPSTATIC_LIBUUID) \
 		$(DEPSTATIC_LIBQUOTA) $(DEPSTATIC_LIBBLKID)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -static -o mke2fs.static $(MKE2FS_OBJS) \
 		$(STATIC_LIBQUOTA) $(STATIC_LIBS) $(STATIC_LIBE2P) \
-		$(STATIC_LIBBLKID) $(STATIC_LIBUUID) $(LIBINTL) $(SYSLIBS)
+		$(STATIC_LIBBLKID) $(STATIC_LIBUUID) $(LIBINTL) $(SYSLIBS) \
+		$(LIBMAGIC)
 
 mke2fs.profiled: $(MKE2FS_OBJS) $(PROFILED_DEPLIBS) \
 	$(PROFILED_LIBE2P) $(PROFILED_DEPLIBBLKID) $(PROFILED_DEPLIBUUID) \
@@ -265,7 +267,7 @@ mke2fs.profiled: $(MKE2FS_OBJS) $(PROFILED_DEPLIBS) \
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o mke2fs.profiled \
 		$(PROFILED_MKE2FS_OBJS) $(PROFILED_LIBBLKID) \
 		$(PROFILED_LIBUUID) $(PROFILED_LIBQUOTA) $(PROFILED_LIBE2P) \
-		$(LIBINTL) $(PROFILED_LIBS) $(SYSLIBS)
+		$(LIBINTL) $(PROFILED_LIBS) $(SYSLIBS) $(LIBMAGIC)
 
 chattr: $(CHATTR_OBJS) $(DEPLIBS_E2P)
 	$(E) "	LD $@"
@@ -301,7 +303,8 @@ uuidd.profiled: $(UUIDD_OBJS) $(PROFILED_DEPLIBUUID)
 dumpe2fs: $(DUMPE2FS_OBJS) $(DEPLIBS) $(DEPLIBS_E2P) $(DEPLIBUUID) $(DEPLIBBLKID)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o dumpe2fs $(DUMPE2FS_OBJS) $(LIBS) \
-		$(LIBS_E2P) $(LIBUUID) $(LIBINTL) $(SYSLIBS) $(LIBBLKID)
+		$(LIBS_E2P) $(LIBUUID) $(LIBINTL) $(SYSLIBS) $(LIBBLKID) \
+		$(LIBMAGIC)
 
 dumpe2fs.profiled: $(DUMPE2FS_OBJS) $(PROFILED_DEPLIBS) \
 		$(PROFILED_LIBE2P) $(PROFILED_DEPLIBUUID) $(PROFILED_DEPLIBBLKID)
@@ -309,7 +312,7 @@ dumpe2fs.profiled: $(DUMPE2FS_OBJS) $(PROFILED_DEPLIBS) \
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o dumpe2fs.profiled \
 		$(PROFILED_DUMPE2FS_OBJS) $(PROFILED_LIBS) \
 		$(PROFILED_LIBE2P) $(PROFILED_LIBUUID) $(LIBINTL) $(SYSLIBS) \
-		$(PROFILED_LIBBLKID)
+		$(PROFILED_LIBBLKID) $(PROFILED_LIBMAGIC)
 
 fsck: $(FSCK_OBJS) $(DEPLIBBLKID)
 	$(E) "	LD $@"
diff --git a/misc/plausible.c b/misc/plausible.c
index 2768e4b..caeb929 100644
--- a/misc/plausible.c
+++ b/misc/plausible.c
@@ -28,6 +28,9 @@
 #ifdef HAVE_UNISTD_H
 #include <unistd.h>
 #endif
+#ifdef HAVE_MAGIC_H
+#include <magic.h>
+#endif
 #include "plausible.h"
 #include "ext2fs/ext2fs.h"
 #include "nls-enable.h"
@@ -194,6 +197,25 @@ int check_plausibility(const char *device, int flags, int *ret_is_dev)
 		return 0;
 	}
 
+#ifdef HAVE_MAGIC_H
+	if (flags & CHECK_FS_EXIST) {
+		const char *msg;
+		magic_t mag;
+
+		mag = magic_open(MAGIC_RAW | MAGIC_SYMLINK | MAGIC_DEVICES |
+				 MAGIC_ERROR | MAGIC_NO_CHECK_ELF |
+				 MAGIC_NO_CHECK_COMPRESS);
+		magic_load(mag, NULL);
+
+		msg = magic_file(mag, device);
+		if (msg && strcmp(msg, "data") && strcmp(msg, "empty"))
+			printf(_("%s contains a `%s'\n"), device, msg);
+
+		magic_close(mag);
+		return 0;
+	}
+#endif
+
 	ret = check_partition_table(device);
 	if (ret >= 0)
 		return ret;
diff --git a/tests/f_detect_junk/expect b/tests/f_detect_junk/expect
new file mode 100644
index 0000000..57f7f89
--- /dev/null
+++ b/tests/f_detect_junk/expect
@@ -0,0 +1,25 @@
+*** e2fsck
+ext2fs_open2: Bad magic number in super-block
+../e2fsck/e2fsck: Superblock invalid, trying backup blocks...
+../e2fsck/e2fsck: Bad magic number in super-block while trying to open test.img
+
+The superblock could not be read or does not describe a valid ext2/ext3/ext4
+filesystem.  If the device is valid and it really contains an ext2/ext3/ext4
+filesystem (and not swap or ufs or something else), then the superblock
+is corrupt, and you might try running e2fsck with an alternate superblock:
+    e2fsck -b 8193 <device>
+ or
+    e2fsck -b 32768 <device>
+
+test.img contains a `PNG image data, 148 x 31, 8-bit/color RGBA, non-interlaced'
+*** debugfs
+test.img: Bad magic number in super-block while opening filesystem
+test.img contains a `PNG image data, 148 x 31, 8-bit/color RGBA, non-interlaced'
+*** tune2fs
+../misc/tune2fs: Bad magic number in super-block while trying to open test.img
+test.img contains a `PNG image data, 148 x 31, 8-bit/color RGBA, non-interlaced'
+*** mke2fs
+Creating filesystem with 16384 1k blocks and 4096 inodes
+Superblock backups stored on blocks: 
+	8193
+
diff --git a/tests/f_detect_junk/expect.nodebugfs b/tests/f_detect_junk/expect.nodebugfs
new file mode 100644
index 0000000..d9281a0
--- /dev/null
+++ b/tests/f_detect_junk/expect.nodebugfs
@@ -0,0 +1,23 @@
+*** e2fsck
+ext2fs_open2: Bad magic number in super-block
+../e2fsck/e2fsck: Superblock invalid, trying backup blocks...
+../e2fsck/e2fsck: Bad magic number in super-block while trying to open test.img
+
+The superblock could not be read or does not describe a valid ext2/ext3/ext4
+filesystem.  If the device is valid and it really contains an ext2/ext3/ext4
+filesystem (and not swap or ufs or something else), then the superblock
+is corrupt, and you might try running e2fsck with an alternate superblock:
+    e2fsck -b 8193 <device>
+ or
+    e2fsck -b 32768 <device>
+
+test.img contains a `PNG image data, 148 x 31, 8-bit/color RGBA, non-interlaced'
+*** debugfs
+*** tune2fs
+../misc/tune2fs: Bad magic number in super-block while trying to open test.img
+test.img contains a `PNG image data, 148 x 31, 8-bit/color RGBA, non-interlaced'
+*** mke2fs
+Creating filesystem with 16384 1k blocks and 4096 inodes
+Superblock backups stored on blocks: 
+	8193
+
diff --git a/tests/f_detect_junk/image.bz2 b/tests/f_detect_junk/image.bz2
new file mode 100644
index 0000000000000000000000000000000000000000..3d52600d67d5f9e3212f6e6b5b8bbc918343fd41
GIT binary patch
literal 2504
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
SjgZZI;_gVN3KAGF=qTVdHMar)

literal 0
HcmV?d00001

diff --git a/tests/f_detect_junk/name b/tests/f_detect_junk/name
new file mode 100644
index 0000000..81cf655
--- /dev/null
+++ b/tests/f_detect_junk/name
@@ -0,0 +1 @@
+detect non-fs file data
diff --git a/tests/f_detect_junk/script b/tests/f_detect_junk/script
new file mode 100755
index 0000000..8409fdd
--- /dev/null
+++ b/tests/f_detect_junk/script
@@ -0,0 +1,43 @@
+#!/bin/bash
+
+if [ "$(grep -c 'define HAVE_MAGIC_H' $test_dir/../../lib/config.h)" -gt 0 ]; then
+
+FSCK_OPT=-fn
+IMAGE=$test_dir/image.bz2
+
+bzip2 -d < $IMAGE > $TMPFILE
+dd if=/dev/zero of=$TMPFILE conv=notrunc oflag=append bs=1024k count=16 > /dev/null 2>&1
+
+# Run fsck to fix things?
+if [ -x $DEBUGFS_EXE ]; then
+	EXP=$test_dir/expect
+else
+	EXP=$test_dir/expect.nodebugfs
+fi
+OUT=$test_name.log
+rm -rf $test_name.failed $test_name.ok
+
+echo "*** e2fsck" > $OUT
+$FSCK $FSCK_OPT $TMPFILE >> $OUT 2>&1
+echo "*** debugfs" >> $OUT
+test -x $DEBUGFS_EXE && $DEBUGFS_EXE -R 'quit' $TMPFILE >> $OUT 2>&1
+echo "*** tune2fs" >> $OUT
+$TUNE2FS -i 0 $TMPFILE >> $OUT 2>&1
+echo "*** mke2fs" >> $OUT
+$MKE2FS -n $TMPFILE >> $OUT 2>&1
+
+sed -f $cmd_dir/filter.sed -e "s|$TMPFILE|test.img|g" -i $OUT
+
+# Figure out what happened
+if cmp -s $EXP $OUT; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff -u $EXP $OUT >> $test_name.failed
+fi
+unset EXP OUT FSCK_OPT IMAGE
+
+else #if HAVE_MAGIC_H
+	echo "$test_name: $test_description: skipped"
+fi

