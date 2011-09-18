From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] xfstest: fsstress add EXT2_IOC_{SET,GET}FLAGS operations
Date: Sun, 18 Sep 2011 18:54:59 +0400
Message-ID: <1316357699-22692-2-git-send-email-dmonakhov@openvz.org>
References: <1316357699-22692-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64750 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab1IROzU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Sep 2011 10:55:20 -0400
In-Reply-To: <1316357699-22692-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add two new operations:
- getattr: ioctl(fd, EXT2_IOC_GETFLAGS, &fl)
- setattr: ioctl(fd, EXT2_IOC_SETFLAGS, &random_flags)
By default IOC_SET_SETFLAGS has zero probability because
it may produce inodes with APPEND or IMMUTABLE flags which
are not deletable by default. Let's assumes that one who
enable it knows how to delete such inodes.
For example like follows:
find $TEST_PATH -exec chattr -i -a {} \;
rm -rf $TEST_PATH

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 aclocal.m4            |    6 +++++
 configure.in          |    2 +
 ltp/fsstress.c        |   61 +++++++++++++++++++++++++++++++++++++++++++++++++
 m4/package_e2fslib.m4 |    6 +++++
 4 files changed, 75 insertions(+), 0 deletions(-)
 create mode 100644 m4/package_e2fslib.m4

diff --git a/aclocal.m4 b/aclocal.m4
index 5532606..30ac837 100644
--- a/aclocal.m4
+++ b/aclocal.m4
@@ -21,6 +21,11 @@ AC_DEFUN([AC_PACKAGE_WANT_LINUX_PRCTL_H],
     AC_SUBST(have_prctl)
   ])
 
+AC_DEFUN([AC_PACKAGE_WANT_EXT2_INCLUDE],
+  [ AC_CHECK_HEADER([ext2fs/ext2fs.h],[ have_ext2_include=true ], [ have_ext2_include=false ])
+  AC_SUBST(have_ext2_include)
+  ])
+
 AC_DEFUN([AC_PACKAGE_WANT_FALLOCATE],
   [ AC_MSG_CHECKING([for fallocate])
     AC_TRY_LINK([
@@ -43,3 +48,4 @@ m4_include([m4/package_globals.m4])
 m4_include([m4/package_utilies.m4])
 m4_include([m4/package_uuiddev.m4])
 m4_include([m4/package_xfslibs.m4])
+m4_include([m4/package_e2fslib.m4])
diff --git a/configure.in b/configure.in
index 76d23e4..1e0d138 100644
--- a/configure.in
+++ b/configure.in
@@ -68,6 +68,8 @@ in
 		AC_PACKAGE_WANT_LINUX_FIEMAP_H
 		AC_PACKAGE_WANT_FALLOCATE
 		AC_PACKAGE_WANT_LINUX_PRCTL_H
+
+		AC_PACKAGE_WANT_EXT2_INCLUDE
 		;;
 esac
 
diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index cee2cad..416190b 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -31,6 +31,9 @@
 #ifdef HAVE_SYS_PRCTL_H
 #include <sys/prctl.h>
 #endif
+#ifdef HAVE_EXT2_INCLUDE
+#include <ext2fs/ext2fs.h>
+#endif
 #include <math.h>
 #define XFS_ERRTAG_MAX		17
 #define XFS_IDMODULO_MAX	31	/* user/group IDs (1 << x)  */
@@ -68,6 +71,8 @@ typedef enum {
 	OP_UNLINK,
 	OP_UNRESVSP,
 	OP_WRITE,
+	OP_GETATTR,
+	OP_SETATTR,
 	OP_LAST
 } opty_t;
 
@@ -142,6 +147,8 @@ void	resvsp_f(int, long);
 void	rmdir_f(int, long);
 void	setxattr_f(int, long);
 void	stat_f(int, long);
+void	getattr_f(int, long);
+void	setattr_f(int, long);
 void	symlink_f(int, long);
 void	sync_f(int, long);
 void	truncate_f(int, long);
@@ -179,6 +186,8 @@ opdesc_t	ops[] = {
 	{ OP_UNLINK, "unlink", unlink_f, 1, 1 },
 	{ OP_UNRESVSP, "unresvsp", unresvsp_f, 1, 1 },
 	{ OP_WRITE, "write", write_f, 4, 1 },
+	{ OP_GETATTR, "getattr", getattr_f, 1, 0 },
+	{ OP_SETATTR, "setattr", setattr_f, 0, 1 },
 }, *ops_end;
 
 flist_t	flist[FT_nft] = {
@@ -1729,6 +1738,58 @@ setxattr_f(int opno, long r)
 }
 
 void
+getattr_f(int opno, long r)
+{
+#ifdef HAVE_EXT2_INCLUDE
+	int		fd;
+	int		e;
+	pathname_t	f;
+	uint		fl;
+	int		v;
+
+	init_pathname(&f);
+	if (!get_fname(FT_ANYm, r, &f, NULL, NULL, &v))
+		append_pathname(&f, ".");
+	fd = open_path(&f, O_RDWR);
+	e = fd < 0 ? errno : 0;
+	check_cwd();
+
+	e = ioctl(fd, EXT2_IOC_GETFLAGS, &fl);
+	if (v)
+		printf("%d/%d: getattr %s %u %d\n", procid, opno, f.path, fl, e);
+	free_pathname(&f);
+	close(fd);
+#endif
+}
+
+void
+setattr_f(int opno, long r)
+{
+#ifdef HAVE_EXT2_INCLUDE
+	int		fd;
+	int		e;
+	pathname_t	f;
+	uint		fl;
+	int		v;
+
+	init_pathname(&f);
+	if (!get_fname(FT_ANYm, r, &f, NULL, NULL, &v))
+		append_pathname(&f, ".");
+	fd = open_path(&f, O_RDWR);
+	e = fd < 0 ? errno : 0;
+	check_cwd();
+
+	fl = (uint)random();
+	e = ioctl(fd, EXT2_IOC_SETFLAGS, &fl);
+	if (v)
+		printf("%d/%d: setattr %s %u %d\n", procid, opno, f.path, fl, e);
+	free_pathname(&f);
+	close(fd);
+#endif
+}
+
+
+void
 creat_f(int opno, long r)
 {
 	struct fsxattr	a;
diff --git a/m4/package_e2fslib.m4 b/m4/package_e2fslib.m4
new file mode 100644
index 0000000..6ab48f4
--- /dev/null
+++ b/m4/package_e2fslib.m4
@@ -0,0 +1,6 @@
+AC_DEFUN([AC_PACKAGE_WANT_EXT2_INCLUDE],
+  [AC_CHECK_HEADER([ext2fs/ext2fs.h])
+  if test "$ac_cv_header_ext2fs_ext2fs_h" == "yes"; then
+     AC_DEFINE([HAVE_EXT2_INCLUDE], 1, [Header files for e2fslib])
+  fi
+])
\ No newline at end of file
-- 
1.7.2.3

