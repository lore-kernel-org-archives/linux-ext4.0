From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/3] e2fsck: read-ahead metadata during pass1 and pass2
Date: Sat, 01 Feb 2014 02:37:41 -0800
Message-ID: <20140201103741.9011.90207.stgit@birch.djwong.org>
References: <20140201103721.9011.5971.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22294 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaBAKhv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Feb 2014 05:37:51 -0500
In-Reply-To: <20140201103721.9011.5971.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2fsck pass1 is modified to use the block group data prefetch function
to try to fetch the data into the pagecache before it is needed.
pass2 is modified to use the dirblock prefetching function to prefetch
the list of directory blocks that are assembled in pass1.

In general, these mechanisms can halve fsck time... if the host system
has sufficient memory.  SSDs and multi-spindle RAIDs see the most
speedup, and single-spindle USB mass storage devices see hardly any
benefit.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 MCONFIG.in         |    1 +
 configure          |   47 ++++++++++++++++++++++++++++++++++++++++
 configure.in       |    5 ++++
 e2fsck/Makefile.in |    4 ++-
 e2fsck/pass1.c     |   26 ++++++++++++++++++++++
 e2fsck/pass2.c     |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/config.h.in    |    6 +++++
 7 files changed, 148 insertions(+), 2 deletions(-)


diff --git a/MCONFIG.in b/MCONFIG.in
index 114de0a..528c35e 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -111,6 +111,7 @@ LIBFUSE = @FUSE_LIB@
 LIBQUOTA = @STATIC_LIBQUOTA@
 LIBBLKID = @LIBBLKID@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
 LIBINTL = @LIBINTL@
+LIBPTHREADS = @PTHREADS_LIB@
 SYSLIBS = @LIBS@
 DEPLIBSS = $(LIB)/libss@LIB_EXT@
 DEPLIBCOM_ERR = $(LIB)/libcom_err@LIB_EXT@
diff --git a/configure b/configure
index 5d032ce..f1f9b1b 100755
--- a/configure
+++ b/configure
@@ -639,6 +639,7 @@ CYGWIN_CMT
 LINUX_CMT
 UNI_DIFF_OPTS
 SEM_INIT_LIB
+PTHREADS_LIB
 FUSE_CMT
 FUSE_LIB
 SOCKET_LIB
@@ -11492,6 +11493,52 @@ if test $ac_cv_have_optreset = yes; then
 $as_echo "#define HAVE_OPTRESET 1" >>confdefs.h
 
 fi
+PTHREADS_LIB='-lpthread'
+{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for pthread_create in -lpthread" >&5
+$as_echo_n "checking for pthread_create in -lpthread... " >&6; }
+if ${ac_cv_lib_pthread_pthread_create+:} false; then :
+  $as_echo_n "(cached) " >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-lpthread  $LIBS"
+cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char pthread_create ();
+int
+main ()
+{
+return pthread_create ();
+  ;
+  return 0;
+}
+_ACEOF
+if ac_fn_c_try_link "$LINENO"; then :
+  ac_cv_lib_pthread_pthread_create=yes
+else
+  ac_cv_lib_pthread_pthread_create=no
+fi
+rm -f core conftest.err conftest.$ac_objext \
+    conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_cv_lib_pthread_pthread_create" >&5
+$as_echo "$ac_cv_lib_pthread_pthread_create" >&6; }
+if test "x$ac_cv_lib_pthread_pthread_create" = xyes; then :
+  cat >>confdefs.h <<_ACEOF
+#define HAVE_LIBPTHREAD 1
+_ACEOF
+
+  LIBS="-lpthread $LIBS"
+
+fi
+
 
 SEM_INIT_LIB=''
 ac_fn_c_check_func "$LINENO" "sem_init" "ac_cv_func_sem_init"
diff --git a/configure.in b/configure.in
index 2eda7ae..f130d7e 100644
--- a/configure.in
+++ b/configure.in
@@ -1212,6 +1212,11 @@ if test $ac_cv_have_optreset = yes; then
   AC_DEFINE(HAVE_OPTRESET, 1, [Define to 1 if optreset for getopt is present])
 fi
 dnl
+dnl Test for pthread_create in -lpthread
+dnl
+PTHREADS_LIB='-lpthread'
+AC_CHECK_LIB(pthread, pthread_create, AC_SUBST(PTHREADS_LIB))
+dnl
 dnl Test for sem_init, and which library it might require:
 dnl
 AH_TEMPLATE([HAVE_SEM_INIT], [Define to 1 if sem_init() exists])
diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 8ca329b..7e8e78e 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -16,13 +16,13 @@ MANPAGES=	e2fsck.8
 FMANPAGES=	e2fsck.conf.5
 
 LIBS= $(LIBQUOTA) $(LIBEXT2FS) $(LIBCOM_ERR) $(LIBBLKID) $(LIBUUID) \
-	$(LIBINTL) $(LIBE2P) $(SYSLIBS)
+	$(LIBINTL) $(LIBE2P) $(SYSLIBS) $(LIBPTHREADS)
 DEPLIBS= $(DEPLIBQUOTA) $(LIBEXT2FS) $(DEPLIBCOM_ERR) $(DEPLIBBLKID) \
 	 $(DEPLIBUUID) $(DEPLIBE2P)
 
 STATIC_LIBS= $(STATIC_LIBQUOTA) $(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR) \
 	     $(STATIC_LIBBLKID) $(STATIC_LIBUUID) $(LIBINTL) $(STATIC_LIBE2P) \
-	     $(SYSLIBS)
+	     $(SYSLIBS) $(LIBPTHEADS)
 STATIC_DEPLIBS= $(DEPSTATIC_LIBQUOTA) $(STATIC_LIBEXT2FS) \
 		$(DEPSTATIC_LIBCOM_ERR) $(DEPSTATIC_LIBBLKID) \
 		$(DEPSTATIC_LIBUUID) $(DEPSTATIC_LIBE2P)
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 7554f4e..590e1bd 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -44,6 +44,9 @@
 #ifdef HAVE_ERRNO_H
 #include <errno.h>
 #endif
+#ifdef HAVE_PTHREAD_H
+#include <pthread.h>
+#endif
 
 #include "e2fsck.h"
 #include <ext2fs/ext2_ext_attr.h>
@@ -574,6 +577,20 @@ static errcode_t recheck_bad_inode_checksum(ext2_filsys fs, ext2_ino_t ino,
 	return 0;
 }
 
+static void *pass1_readahead(void *p)
+{
+	errcode_t err;
+	e2fsck_t ctx = (e2fsck_t)p;
+
+	printf("%s: START READAHEAD\n", __func__);
+	err = ext2fs_readahead(ctx->fs, EXT2FS_READ_BBITMAP |
+			       EXT2FS_READ_IBITMAP | EXT2FS_READ_ITABLE,
+			       0, ctx->fs->group_desc_count);
+	printf("%s: READAHEAD=%d\n", __func__, (int)err);
+
+	return NULL;
+}
+
 void e2fsck_pass1(e2fsck_t ctx)
 {
 	int	i;
@@ -600,6 +617,15 @@ void e2fsck_pass1(e2fsck_t ctx)
 	init_resource_track(&rtrack, ctx->fs->io);
 	clear_problem_context(&pctx);
 
+	if (getenv("READAHEAD")) {
+#ifdef HAVE_PTHREAD_H
+		pthread_t tid;
+		pthread_create(&tid, NULL, pass1_readahead, ctx);
+#else
+		pass1_readahead(ctx);
+#endif
+	}
+
 	if (!(ctx->options & E2F_OPT_PREEN))
 		fix_problem(ctx, PR_1_PASS_HEADER, &pctx);
 
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 5a2745a..bd7323f 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -44,6 +44,9 @@
 #define _GNU_SOURCE 1 /* get strnlen() */
 #include "config.h"
 #include <string.h>
+#ifdef HAVE_PTHREAD_H
+#include <pthread.h>
+#endif
 
 #include "e2fsck.h"
 #include "problem.h"
@@ -79,6 +82,29 @@ struct check_dir_struct {
 	e2fsck_t ctx;
 };
 
+struct pass2_readahead_data {
+	ext2_filsys fs;
+	ext2_dblist dblist;
+};
+
+static int readahead_dir_block(ext2_filsys fs, struct ext2_db_entry2 *db,
+			       void *priv_data)
+{
+	db->blockcnt = 1;
+}
+
+static void *pass2_readahead(void *p)
+{
+	errcode_t err;
+	struct pass2_readahead_data *pr = p;
+
+	printf("%s: START READAHEAD\n", __func__);
+	err = ext2fs_readahead_dblist(pr->fs, pr->dblist);
+	ext2fs_free_dblist(pr->dblist);
+	ext2fs_free_mem(&pr);
+	printf("%s: END READAHEAD %d\n", __func__, (int)err);
+}
+
 void e2fsck_pass2(e2fsck_t ctx)
 {
 	struct ext2_super_block *sb = ctx->fs->super;
@@ -146,6 +172,41 @@ void e2fsck_pass2(e2fsck_t ctx)
 	if (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX)
 		ext2fs_dblist_sort2(fs->dblist, special_dir_block_cmp);
 
+	if (getenv("READAHEAD")) {
+#ifdef HAVE_PTHREAD_H
+		pthread_t tid;
+#endif
+		struct pass2_readahead_data *pr;
+		errcode_t err;
+
+		err = ext2fs_get_mem(sizeof(*pr), &pr);
+		if (err)
+			goto no_readahead;
+		pr->fs = fs;
+		err = ext2fs_copy_dblist(fs->dblist, &pr->dblist);
+		if (err) {
+			ext2fs_free_mem(&pr);
+			goto no_readahead;
+		}
+		err = ext2fs_dblist_iterate2(pr->dblist, readahead_dir_block,
+					     NULL);
+		if (err) {
+			ext2fs_free_dblist(pr->dblist);
+			ext2fs_free_mem(&pr);
+			goto no_readahead;
+		}
+#ifdef HAVE_PTHREAD_H
+		err = pthread_create(&tid, NULL, pass2_readahead, pr);
+#else
+		pass2_readahead(pr);
+#endif
+		if (err) {
+			ext2fs_free_dblist(pr->dblist);
+			ext2fs_free_mem(&pr);
+		}
+	}
+
+no_readahead:
 	cd.pctx.errcode = ext2fs_dblist_iterate2(fs->dblist, check_dir_block,
 						 &cd);
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK || ctx->flags & E2F_FLAG_RESTART)
diff --git a/lib/config.h.in b/lib/config.h.in
index 35ece01..1dd33b4 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -206,6 +206,9 @@
 /* Define if your <locale.h> file defines LC_MESSAGES. */
 #undef HAVE_LC_MESSAGES
 
+/* Define to 1 if you have the `pthread' library (-lpthread). */
+#undef HAVE_LIBPTHREAD
+
 /* Define to 1 if you have the <limits.h> header file. */
 #undef HAVE_LIMITS_H
 
@@ -314,6 +317,9 @@
 /* Define to 1 if you have the `prctl' function. */
 #undef HAVE_PRCTL
 
+/* Define to 1 if you have the <pthread.h> header file. */
+#undef HAVE_PTHREAD_H
+
 /* Define to 1 if you have the `putenv' function. */
 #undef HAVE_PUTENV
 

