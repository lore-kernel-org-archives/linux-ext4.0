Return-Path: <SRS0=nu1L=M2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-it1-f195.google.com ([209.85.166.195]:51260 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbeJNWlr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Oct 2018 18:41:47 -0400
Received: by mail-it1-f195.google.com with SMTP id 74-v6so25273506itw.1
        for <linux-ext4@vger.kernel.org>; Sun, 14 Oct 2018 08:00:31 -0700 (PDT)
From: nicholas.clark@gmail.com
To: linux-ext4@vger.kernel.org
Cc: Nicholas Clark <nicholas.clark@gmail.com>
Subject: [PATCH RESEND 2/2] Fuse2fs: add fakeroot option.
Date: Sun, 14 Oct 2018 09:00:25 -0600
Message-Id: <20181014150025.6477-3-nicholas.clark@gmail.com>
In-Reply-To: <20181014150025.6477-1-nicholas.clark@gmail.com>
References: <20181014150025.6477-1-nicholas.clark@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Nicholas Clark <nicholas.clark@gmail.com>

Add a new 'fakeroot' option to fuse2fs. When enabled, fuse2fs will
will pretend to be root when checking file permssions. This allows
fuse2fs to be used for building/modifying rootfs images as an
unprivileged user.

As per the maintainer's request, nosuid and nodev are automatically
enabled when fakeroot is selected (on platforms that support them)
to help prevent accidental misuse.

Signed-off-by: Nicholas Clark <nicholas.clark@gmail.com>
---
 acinclude.m4      |  47 ++++++++++++++++
 configure         | 134 ++++++++++++++++++++++++++++++++++++++++++++++
 configure.ac      |   4 ++
 lib/config.h.in   |   6 +++
 misc/fuse2fs.1.in |   3 ++
 misc/fuse2fs.c    |  29 +++++++---
 6 files changed, 216 insertions(+), 7 deletions(-)

diff --git a/acinclude.m4 b/acinclude.m4
index e9890f75..0b91745e 100644
--- a/acinclude.m4
+++ b/acinclude.m4
@@ -133,3 +133,50 @@ dnl If there was a GNU version, then set @ifGNUmake@ to the empty string, '#' ot
         AC_SUBST(ifGNUmake)
         AC_SUBST(ifNotGNUmake)
 ] )
+
+# AX_CHECK_MOUNT_OPT: an autoconf macro to check for generic filesystem-
+# agnostic 'mount' options. Written by Nicholas Clark. Looks for constants in
+# sys/mount.h to predict whether the 'mount' utility will support a specific
+# mounting option.
+#
+# This macro can be used to check for the presence of 'nodev' (or other mount
+# options), which isn't uniformly implemented in the BSD family at the time of
+# this writing. Tested on FreeBSD, NetBSD, OpenBSD, and Linux.
+#
+# Usage:
+#
+# AX_CHECK_MOUNT_OPT(option)
+#
+# Defines HAVE_MOUNT_$OPTION (in uppercase) if the option exists, and sets
+# ac_cv_mount_$option (in original case) otherwise.
+#
+# Copyright (c) 2018 Nicholas Clark <nicholas.clark@gmail.com>
+#
+# Copying and distribution of this file, with or without modification, are
+# permitted in any medium without royalty or attribution requirement.
+
+AC_DEFUN([AX_CHECK_MOUNT_OPT], [__AX_CHECK_MOUNT_OPT(m4_tolower([$1]),m4_toupper([$1]))])
+AC_DEFUN([__AX_CHECK_MOUNT_OPT],
+[
+    AS_IF([test "x$ac_cv_header_sys_mount_h" = x],
+          [AC_CHECK_HEADERS([sys/mount.h])])
+    AS_IF([test "x$ac_cv_header_sys_mount_h" = xno],
+          [AC_MSG_FAILURE([error: sys/mount.h not present on your system!])])
+    AS_ECHO_N("checking for mount '$1' option... ")
+    AC_TRY_COMPILE(
+        [#include <sys/mount.h>],
+        [void *temp = (void *)(MS_$2); (void) temp;],
+        [AC_DEFINE(HAVE_MOUNT_$2, 1, [Define to 1 if mount supports $1.])
+         AS_VAR_SET(ac_cv_mount_$1, yes)
+         AS_ECHO("yes")],
+        [AC_TRY_COMPILE(
+            [#include <sys/mount.h>],
+            [void *temp = (void *)(MNT_$2); (void) temp;],
+            [AC_DEFINE(HAVE_MOUNT_$2, 1, [Define to 1 if mount supports $1.])
+             AS_VAR_SET(ac_cv_mount_$1, yes)
+             AS_ECHO("yes")],
+            [AS_VAR_SET(ac_cv_mount_$1, no)
+             AS_ECHO("no")]
+        )]
+    )
+])
diff --git a/configure b/configure
index af719199..0a46f0a8 100755
--- a/configure
+++ b/configure
@@ -13774,6 +13774,140 @@ $as_echo "#define HAVE_EXT2_IOCTLS 1" >>confdefs.h
 
 	;;
 esac
+
+    if test "x$ac_cv_header_sys_mount_h" = x; then :
+  for ac_header in sys/mount.h
+do :
+  ac_fn_c_check_header_mongrel "$LINENO" "sys/mount.h" "ac_cv_header_sys_mount_h" "$ac_includes_default"
+if test "x$ac_cv_header_sys_mount_h" = xyes; then :
+  cat >>confdefs.h <<_ACEOF
+#define HAVE_SYS_MOUNT_H 1
+_ACEOF
+
+fi
+
+done
+
+fi
+    if test "x$ac_cv_header_sys_mount_h" = xno; then :
+  { { $as_echo "$as_me:${as_lineno-$LINENO}: error: in \`$ac_pwd':" >&5
+$as_echo "$as_me: error: in \`$ac_pwd':" >&2;}
+as_fn_error $? "error: sys/mount.h not present on your system!
+See \`config.log' for more details" "$LINENO" 5; }
+fi
+    $as_echo_n "checking for mount 'nosuid' option... "
+    cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+#include <sys/mount.h>
+int
+main ()
+{
+void *temp = (void *)(MS_NOSUID); (void) temp;
+  ;
+  return 0;
+}
+_ACEOF
+if ac_fn_c_try_compile "$LINENO"; then :
+
+$as_echo "#define HAVE_MOUNT_NOSUID 1" >>confdefs.h
+
+         ac_cv_mount_nosuid=yes
+         $as_echo "yes"
+else
+  cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+#include <sys/mount.h>
+int
+main ()
+{
+void *temp = (void *)(MNT_NOSUID); (void) temp;
+  ;
+  return 0;
+}
+_ACEOF
+if ac_fn_c_try_compile "$LINENO"; then :
+
+$as_echo "#define HAVE_MOUNT_NOSUID 1" >>confdefs.h
+
+             ac_cv_mount_nosuid=yes
+             $as_echo "yes"
+else
+  ac_cv_mount_nosuid=no
+             $as_echo "no"
+
+fi
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+
+fi
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+
+
+    if test "x$ac_cv_header_sys_mount_h" = x; then :
+  for ac_header in sys/mount.h
+do :
+  ac_fn_c_check_header_mongrel "$LINENO" "sys/mount.h" "ac_cv_header_sys_mount_h" "$ac_includes_default"
+if test "x$ac_cv_header_sys_mount_h" = xyes; then :
+  cat >>confdefs.h <<_ACEOF
+#define HAVE_SYS_MOUNT_H 1
+_ACEOF
+
+fi
+
+done
+
+fi
+    if test "x$ac_cv_header_sys_mount_h" = xno; then :
+  { { $as_echo "$as_me:${as_lineno-$LINENO}: error: in \`$ac_pwd':" >&5
+$as_echo "$as_me: error: in \`$ac_pwd':" >&2;}
+as_fn_error $? "error: sys/mount.h not present on your system!
+See \`config.log' for more details" "$LINENO" 5; }
+fi
+    $as_echo_n "checking for mount 'nodev' option... "
+    cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+#include <sys/mount.h>
+int
+main ()
+{
+void *temp = (void *)(MS_NODEV); (void) temp;
+  ;
+  return 0;
+}
+_ACEOF
+if ac_fn_c_try_compile "$LINENO"; then :
+
+$as_echo "#define HAVE_MOUNT_NODEV 1" >>confdefs.h
+
+         ac_cv_mount_nodev=yes
+         $as_echo "yes"
+else
+  cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+#include <sys/mount.h>
+int
+main ()
+{
+void *temp = (void *)(MNT_NODEV); (void) temp;
+  ;
+  return 0;
+}
+_ACEOF
+if ac_fn_c_try_compile "$LINENO"; then :
+
+$as_echo "#define HAVE_MOUNT_NODEV 1" >>confdefs.h
+
+             ac_cv_mount_nodev=yes
+             $as_echo "yes"
+else
+  ac_cv_mount_nodev=no
+             $as_echo "no"
+
+fi
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+
+fi
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+
 # Check whether --enable-lto was given.
 if test "${enable_lto+set}" = set; then :
   enableval=$enable_lto;
diff --git a/configure.ac b/configure.ac
index c378b81e..fe1cad11 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1315,6 +1315,10 @@ linux*)
 	;;
 esac
 dnl
+dnl Check the available mount options
+dnl
+AX_CHECK_MOUNT_OPT(nosuid)
+AX_CHECK_MOUNT_OPT(nodev)
 dnl Enable LTO for all packages
 dnl
 AC_ARG_ENABLE([lto],
diff --git a/lib/config.h.in b/lib/config.h.in
index 67a05481..caa3faee 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -313,6 +313,12 @@
 /* Define to 1 if you have the <mntent.h> header file. */
 #undef HAVE_MNTENT_H
 
+/* Define to 1 if mount supports nodev. */
+#undef HAVE_MOUNT_NODEV
+
+/* Define to 1 if mount supports nosuid. */
+#undef HAVE_MOUNT_NOSUID
+
 /* Define to 1 if you have the `msync' function. */
 #undef HAVE_MSYNC
 
diff --git a/misc/fuse2fs.1.in b/misc/fuse2fs.1.in
index 4ed37df1..3bc7ada3 100644
--- a/misc/fuse2fs.1.in
+++ b/misc/fuse2fs.1.in
@@ -42,6 +42,9 @@ dump core on error
 \fB-o\fR minixdf
 minix-style df
 .TP
+\fB-o\fR fakeroot
+pretend to be root for permission checks
+.TP
 \fB-o\fR no_default_opts
 do not include default fuse options
 .TP
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 3214be4a..b2e4e84b 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -322,6 +322,7 @@ struct fuse2fs {
 	int no_default_opts;
 	int panic_on_error;
 	int minixdf;
+	int fakeroot;
 	int alloc_all_blocks;
 	FILE *err_fp;
 	unsigned int next_generation;
@@ -630,6 +631,7 @@ static int fs_writeable(ext2_filsys fs)
 static int check_inum_access(ext2_filsys fs, ext2_ino_t ino, mode_t mask)
 {
 	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
 	struct ext2_inode inode;
 	mode_t perms;
 	errcode_t err;
@@ -659,7 +661,7 @@ static int check_inum_access(ext2_filsys fs, ext2_ino_t ino, mode_t mask)
 		return -EACCES;
 
 	/* Figure out what root's allowed to do */
-	if (ctxt->uid == 0) {
+	if (ff->fakeroot || ctxt->uid == 0) {
 		/* Non-file access always ok */
 		if (!LINUX_S_ISREG(inode.i_mode))
 			return 0;
@@ -1905,7 +1907,7 @@ static int op_chmod(const char *path, mode_t mode)
 		goto out;
 	}
 
-	if (ctxt->uid != 0 && ctxt->uid != inode.i_uid) {
+	if (!ff->fakeroot && ctxt->uid != 0 && ctxt->uid != inode.i_uid) {
 		ret = -EPERM;
 		goto out;
 	}
@@ -1915,7 +1917,7 @@ static int op_chmod(const char *path, mode_t mode)
 	 * of the user's groups, but FUSE only tells us about the primary
 	 * group.
 	 */
-	if (ctxt->uid != 0 && ctxt->gid != inode.i_gid)
+	if (!ff->fakeroot && ctxt->uid != 0 && ctxt->gid != inode.i_gid)
 		mode &= ~S_ISGID;
 
 	inode.i_mode &= ~0xFFF;
@@ -1968,7 +1970,7 @@ static int op_chown(const char *path, uid_t owner, gid_t group)
 	/* FUSE seems to feed us ~0 to mean "don't change" */
 	if (owner != (uid_t) ~0) {
 		/* Only root gets to change UID. */
-		if (ctxt->uid != 0 &&
+		if (!ff->fakeroot && ctxt->uid != 0 &&
 		    !(inode.i_uid == ctxt->uid && owner == ctxt->uid)) {
 			ret = -EPERM;
 			goto out;
@@ -1978,7 +1980,7 @@ static int op_chown(const char *path, uid_t owner, gid_t group)
 
 	if (group != (gid_t) ~0) {
 		/* Only root or the owner get to change GID. */
-		if (ctxt->uid != 0 && inode.i_uid != ctxt->uid) {
+		if (!ff->fakeroot && ctxt->uid != 0 && inode.i_uid != ctxt->uid) {
 			ret = -EPERM;
 			goto out;
 		}
@@ -3120,6 +3122,7 @@ static int ioctl_setflags(ext2_filsys fs, struct fuse2fs_file_handle *fh,
 	int ret;
 	__u32 flags = *(__u32 *)data;
 	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
 
 	FUSE2FS_CHECK_MAGIC(fs, fh, FUSE2FS_FILE_MAGIC);
 	dbg_printf("%s: ino=%d\n", __func__, fh->ino);
@@ -3129,7 +3132,7 @@ static int ioctl_setflags(ext2_filsys fs, struct fuse2fs_file_handle *fh,
 	if (err)
 		return translate_error(fs, fh->ino, err);
 
-	if (ctxt->uid != 0 && inode.i_uid != ctxt->uid)
+	if (!ff->fakeroot && ctxt->uid != 0 && inode.i_uid != ctxt->uid)
 		return -EPERM;
 
 	if ((inode.i_flags ^ flags) & ~FUSE2FS_MODIFIABLE_IFLAGS)
@@ -3176,6 +3179,7 @@ static int ioctl_setversion(ext2_filsys fs, struct fuse2fs_file_handle *fh,
 	int ret;
 	__u32 generation = *(__u32 *)data;
 	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
 
 	FUSE2FS_CHECK_MAGIC(fs, fh, FUSE2FS_FILE_MAGIC);
 	dbg_printf("%s: ino=%d\n", __func__, fh->ino);
@@ -3185,7 +3189,7 @@ static int ioctl_setversion(ext2_filsys fs, struct fuse2fs_file_handle *fh,
 	if (err)
 		return translate_error(fs, fh->ino, err);
 
-	if (ctxt->uid != 0 && inode.i_uid != ctxt->uid)
+	if (!ff->fakeroot && ctxt->uid != 0 && inode.i_uid != ctxt->uid)
 		return -EPERM;
 
 	inode.i_generation = generation;
@@ -3655,6 +3659,7 @@ static struct fuse_opt fuse2fs_opts[] = {
 	FUSE2FS_OPT("ro",		ro,			1),
 	FUSE2FS_OPT("errors=panic",	panic_on_error,		1),
 	FUSE2FS_OPT("minixdf",		minixdf,		1),
+	FUSE2FS_OPT("fakeroot",		fakeroot,		1),
 	FUSE2FS_OPT("fuse2fs_debug",	debug,			1),
 	FUSE2FS_OPT("no_default_opts",	no_default_opts,	1),
 
@@ -3693,6 +3698,7 @@ static int fuse2fs_opt_proc(void *data, const char *arg,
 	"    -o ro                  read-only mount\n"
 	"    -o errors=panic        dump core on error\n"
 	"    -o minixdf             minix-style df\n"
+	"    -o fakeroot            pretend to be root for permission checks\n"
 	"    -o no_default_opts     do not include default fuse options\n"
 	"    -o fuse2fs_debug       enable fuse2fs debugging\n"
 	"\n",
@@ -3849,6 +3855,15 @@ int main(int argc, char *argv[])
 	if (fctx.no_default_opts == 0)
 		fuse_opt_add_arg(&args, extra_args);
 
+	if (fctx.fakeroot) {
+#ifdef HAVE_MOUNT_NODEV
+		fuse_opt_add_arg(&args,"-onodev");
+#endif
+#ifdef HAVE_MOUNT_NOSUID
+		fuse_opt_add_arg(&args,"-onosuid");
+#endif
+	}
+
 	if (fctx.debug) {
 		int	i;
 
-- 
2.17.1
