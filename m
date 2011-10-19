From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/8] xfstests: fsstress add FS_IOC_{SET,GET}FLAGS operations
Date: Wed, 19 Oct 2011 14:29:45 +0400
Message-ID: <1319020189-13584-5-git-send-email-dmonakhov@openvz.org>
References: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, jack@suse.cz, hch@infradead.org,
	aelder@sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add two new operations:
- getattr: ioctl(fd, FS_IOC_GETFLAGS, &fl)
- setattr: ioctl(fd, FS_IOC_SETFLAGS, &random_flags)
By default FS_IOC_SETFLAGS has zero probability because
it may produce inodes with APPEND or IMMUTABLE flags which
are not deletable by default. Let's assumes that one who
enable it knows how to delete such inodes.
For example like follows:
find $TEST_PATH -exec chattr -i -a {} \;
rm -rf $TEST_PATH

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 aclocal.m4     |    4 +++
 configure.in   |    1 +
 ltp/fsstress.c |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/aclocal.m4 b/aclocal.m4
index 5532606..5739004 100644
--- a/aclocal.m4
+++ b/aclocal.m4
@@ -21,6 +21,10 @@ AC_DEFUN([AC_PACKAGE_WANT_LINUX_PRCTL_H],
     AC_SUBST(have_prctl)
   ])
 
+AC_DEFUN([AC_PACKAGE_WANT_LINUX_FS_H],
+  [ AC_CHECK_HEADER([linux/fs.h])
+  ])
+
 AC_DEFUN([AC_PACKAGE_WANT_FALLOCATE],
   [ AC_MSG_CHECKING([for fallocate])
     AC_TRY_LINK([
diff --git a/configure.in b/configure.in
index 76d23e4..3b40e55 100644
--- a/configure.in
+++ b/configure.in
@@ -68,6 +68,7 @@ in
 		AC_PACKAGE_WANT_LINUX_FIEMAP_H
 		AC_PACKAGE_WANT_FALLOCATE
 		AC_PACKAGE_WANT_LINUX_PRCTL_H
+		AC_PACKAGE_WANT_LINUX_FS_H
 		;;
 esac
 
diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 4aba34f..756bdd6 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -37,6 +37,15 @@
 #ifdef HAVE_SYS_PRCTL_H
 #include <sys/prctl.h>
 #endif
+
+#include <linux/fs.h>
+#ifndef FS_IOC_GETFLAGS
+#define FS_IOC_GETFLAGS                 _IOR('f', 1, long)
+#endif
+#ifndef FS_IOC_SETFLAGS
+#define FS_IOC_SETFLAGS                 _IOW('f', 2, long)
+#endif
+
 #include <math.h>
 #define XFS_ERRTAG_MAX		17
 #define XFS_IDMODULO_MAX	31	/* user/group IDs (1 << x)  */
@@ -58,6 +67,7 @@ typedef enum {
 	OP_FDATASYNC,
 	OP_FREESP,
 	OP_FSYNC,
+	OP_GETATTR,
 	OP_GETDENTS,
 	OP_LINK,
 	OP_MKDIR,
@@ -68,6 +78,7 @@ typedef enum {
 	OP_RENAME,
 	OP_RESVSP,
 	OP_RMDIR,
+	OP_SETATTR,
 	OP_SETXATTR,
 	OP_STAT,
 	OP_SYMLINK,
@@ -152,6 +163,8 @@ void	resvsp_f(int, long);
 void	rmdir_f(int, long);
 void	setxattr_f(int, long);
 void	stat_f(int, long);
+void	getattr_f(int, long);
+void	setattr_f(int, long);
 void	symlink_f(int, long);
 void	sync_f(int, long);
 void	truncate_f(int, long);
@@ -173,6 +186,7 @@ opdesc_t	ops[] = {
 	{ OP_FDATASYNC, "fdatasync", fdatasync_f, 1, 1 },
 	{ OP_FREESP, "freesp", freesp_f, 1, 1 },
 	{ OP_FSYNC, "fsync", fsync_f, 1, 1 },
+	{ OP_GETATTR, "getattr", getattr_f, 1, 0 },
 	{ OP_GETDENTS, "getdents", getdents_f, 1, 0 },
 	{ OP_LINK, "link", link_f, 1, 1 },
 	{ OP_MKDIR, "mkdir", mkdir_f, 2, 1 },
@@ -183,6 +197,7 @@ opdesc_t	ops[] = {
 	{ OP_RENAME, "rename", rename_f, 2, 1 },
 	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
 	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
+	{ OP_SETATTR, "setattr", setattr_f, 0, 1 },
 	{ OP_SETXATTR, "setxattr", setxattr_f, 1, 1 },
 	{ OP_STAT, "stat", stat_f, 1, 0 },
 	{ OP_SYMLINK, "symlink", symlink_f, 2, 1 },
@@ -1769,6 +1784,54 @@ setxattr_f(int opno, long r)
 }
 
 void
+getattr_f(int opno, long r)
+{
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
+	e = ioctl(fd, FS_IOC_GETFLAGS, &fl);
+	if (v)
+		printf("%d/%d: getattr %s %u %d\n", procid, opno, f.path, fl, e);
+	free_pathname(&f);
+	close(fd);
+}
+
+void
+setattr_f(int opno, long r)
+{
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
+	e = ioctl(fd, FS_IOC_SETFLAGS, &fl);
+	if (v)
+		printf("%d/%d: setattr %s %u %d\n", procid, opno, f.path, fl, e);
+	free_pathname(&f);
+	close(fd);
+}
+
+
+void
 creat_f(int opno, long r)
 {
 	struct fsxattr	a;
-- 
1.7.1

