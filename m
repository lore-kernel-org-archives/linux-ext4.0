Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627CE1624D5
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 04:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775189022; cv=none; b=tEhZQj+WUz8f+T2QoPsMs8DlO3LEme9cdXg9VeSwejyAeVdczQwsiTzXa/GzCni/mUKyNUoAVAFikSaxxlwqTKNesVYz7cr9AfTqWY0LR8rAZVq1RP5C11tYTxxqkYcXzaz7tVngE2VdnL09Zy7H0U5mJd9sAn60jfuanKcGvRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775189022; c=relaxed/simple;
	bh=VM5UOhVbXY/OG6vhHRvvmBThfCrY/wBYTTPhwDhy7M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZMcY/u1VIZ5ovI09mol5EHQF9fFpkJ8zK0VQjOWTjDKZalnmWnCoopYPrnLqIiU8F/kUjyCVV5XY0gNOcCU7u/L4jcsiORrYiBNe39UwJp6UHmCuIrG9LwfZCB7GkZIpNf77vUfheycuOwSTETITFk9w7CVBHk8lG+756O8dvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Xhp9gGt0; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Xhp9gGt0"
Received: from trampoline.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63343Xdg005246
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 3 Apr 2026 00:03:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775189015; bh=gVpCksOP+qT9v9bAENj/GDIDBmyQHkd9l6NiYSzX5rw=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=Xhp9gGt0MwQalKNEKp/7oeAXGMKGdKaxbUXs+12IwbSbBnB2fa1ppRLgrfqDXywVa
	 8zHUHQLFpXaygMgoQJAugiiuBbTDoLYnLHGrBzIEJyumlMjnxywMzKdx1fH0kJq9VN
	 E3HJJmDnflVWHafpjgTJnx2SlF0IWEKGedPuKGjypfUgkSAgtlQ8rLY7zYpMWRsBPl
	 IsACxdCqFA5OsUViGQmqa9dydO1OC6c8Uj705nI4NVYSMfZML0ep9FTcb2SsbhcxFR
	 DrxuhZFpONboirH53/Rmaa4V0bQSl5Cb5qLQDPYcOpKhZ5XB1jZW3JAHghEH5hhToi
	 fTFSWz5c/oLdg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 78B3D2E00D9; Fri, 03 Apr 2026 00:03:33 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 2/3] libsupport: add a portable get_thread_id() function
Date: Fri,  3 Apr 2026 00:03:27 -0400
Message-ID: <20260403040328.2385083-3-tytso@mit.edu>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260403040328.2385083-1-tytso@mit.edu>
References: <20260403040328.2385083-1-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The gettid() system call is only available on Linux.  So create a new
function, get_thread_id() which implements a number of different ways
of providing a thread id as an integer.

Use get_thread_id() instead of gettid() in fuse2fs.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 configure               | 12 ++++++++++++
 configure.ac            |  2 ++
 lib/config.h.in         |  6 ++++++
 lib/support/Makefile.in | 13 +++++++++++--
 lib/support/thread.c    | 36 ++++++++++++++++++++++++++++++++++++
 lib/support/thread.h    |  5 +++++
 misc/fuse2fs.c          |  3 ++-
 7 files changed, 74 insertions(+), 3 deletions(-)
 create mode 100644 lib/support/thread.c
 create mode 100644 lib/support/thread.h

diff --git a/configure b/configure
index b9a82dcec..b04b31aff 100755
--- a/configure
+++ b/configure
@@ -13749,6 +13749,12 @@ if test "x$ac_cv_func_getrusage" = xyes
 then :
   printf "%s\n" "#define HAVE_GETRUSAGE 1" >>confdefs.h
 
+fi
+ac_fn_c_check_func "$LINENO" "gettid" "ac_cv_func_gettid"
+if test "x$ac_cv_func_gettid" = xyes
+then :
+  printf "%s\n" "#define HAVE_GETTID 1" >>confdefs.h
+
 fi
 ac_fn_c_check_func "$LINENO" "jrand48" "ac_cv_func_jrand48"
 if test "x$ac_cv_func_jrand48" = xyes
@@ -13893,6 +13899,12 @@ if test "x$ac_cv_func_pthread_setname_np" = xyes
 then :
   printf "%s\n" "#define HAVE_PTHREAD_SETNAME_NP 1" >>confdefs.h
 
+fi
+ac_fn_c_check_func "$LINENO" "pthread_threadid_np" "ac_cv_func_pthread_threadid_np"
+if test "x$ac_cv_func_pthread_threadid_np" = xyes
+then :
+  printf "%s\n" "#define HAVE_PTHREAD_THREADID_NP 1" >>confdefs.h
+
 fi
 ac_fn_c_check_func "$LINENO" "qsort_r" "ac_cv_func_qsort_r"
 if test "x$ac_cv_func_qsort_r" = xyes
diff --git a/configure.ac b/configure.ac
index 2473879fd..4921f81f7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1246,6 +1246,7 @@ AC_CHECK_FUNCS(m4_flatten([
 	getrandom
 	getrlimit
 	getrusage
+	gettid
 	jrand48
 	keyctl
 	llistxattr
@@ -1270,6 +1271,7 @@ AC_CHECK_FUNCS(m4_flatten([
 	pread64
 	pwrite64
 	pthread_setname_np
+	pthread_threadid_np
 	qsort_r
 	secure_getenv
 	setmntent
diff --git a/lib/config.h.in b/lib/config.h.in
index c6cbced5f..f129abfe7 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -181,6 +181,9 @@
 /* Define if the GNU gettext() function is already present or preinstalled. */
 #undef HAVE_GETTEXT
 
+/* Define to 1 if you have the 'gettid' function. */
+#undef HAVE_GETTID
+
 /* Define to 1 if you have the GNU-style 'qsort_r' function. */
 #undef HAVE_GNU_QSORT_R
 
@@ -331,6 +334,9 @@
 /* Define to 1 if you have the 'pthread_setname_np' function. */
 #undef HAVE_PTHREAD_SETNAME_NP
 
+/* Define to 1 if you have the 'pthread_threadid_np' function. */
+#undef HAVE_PTHREAD_THREADID_NP
+
 /* Define to 1 if you have the 'pwrite' function. */
 #undef HAVE_PWRITE
 
diff --git a/lib/support/Makefile.in b/lib/support/Makefile.in
index 6383816fd..9aac9cf00 100644
--- a/lib/support/Makefile.in
+++ b/lib/support/Makefile.in
@@ -25,6 +25,7 @@ OBJS=		bthread.o \
 		quotaio.o \
 		quotaio_v2.o \
 		quotaio_tree.o \
+		thread.o \
 		dict.o \
 		devname.o
 
@@ -41,6 +42,7 @@ SRCS=		$(srcdir)/argv_parse.c \
 		$(srcdir)/quotaio.c \
 		$(srcdir)/quotaio_tree.c \
 		$(srcdir)/quotaio_v2.c \
+		$(srcdir)/thread.c \
 		$(srcdir)/dict.c \
 		$(srcdir)/devname.c
 
@@ -81,10 +83,15 @@ test_cstring: $(srcdir)/cstring.c
 	$(Q) $(CC) -o test_cstring -DDEBUG_PROGRAM $(srcdir)/cstring.c \
 		$(ALL_CFLAGS)
 
+test_thread: $(srcdir)/thread.c
+	$(E) " CC $@"
+	$(Q) $(CC) -o test_thread -DDEBUG_PROGRAM $(srcdir)/thread.c \
+		$(ALL_CFLAGS)
+
 clean::
 	$(RM) -f \#* *.s *.o *.a *~ *.bak core profiled/* \
 		../libsupport.a ../libsupport_p.a $(SMANPAGES) \
-		prof_err.c prof_err.h test_profile test_cstring
+		prof_err.c prof_err.h test_profile test_cstring test_thread
 
 #fullcheck check:: tst_uuid
 #	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_uuid
@@ -111,7 +118,7 @@ $(OBJS):
 argv_parse.o: $(srcdir)/argv_parse.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/argv_parse.h
 bthread.o: $(srcdir)/bthread.c $(top_builddir)/lib/config.h \
- $(srcdir)/bthread.h
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/bthread.h
 cstring.o: $(srcdir)/cstring.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/cstring.h
 mkquota.o: $(srcdir)/mkquota.c $(top_builddir)/lib/config.h \
@@ -183,6 +190,8 @@ quotaio_v2.o: $(srcdir)/quotaio_v2.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/hashmap.h \
  $(top_srcdir)/lib/ext2fs/bitops.h $(srcdir)/dqblk_v2.h \
  $(srcdir)/quotaio_tree.h
+thread.o: $(srcdir)/thread.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/thread.h
 dict.o: $(srcdir)/dict.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/dict.h
 devname.o: $(srcdir)/devname.c $(top_builddir)/lib/config.h \
diff --git a/lib/support/thread.c b/lib/support/thread.c
new file mode 100644
index 000000000..a9a10940c
--- /dev/null
+++ b/lib/support/thread.c
@@ -0,0 +1,36 @@
+/*
+ * thread.c - utility functions for Posix threads
+ */
+
+#include "config.h"
+#ifdef HAVE_PTHREAD
+#include <pthread.h>
+#endif
+#include <stdint.h>
+#include <stdio.h>
+#include <unistd.h>
+
+#include "support/thread.h"
+
+uint64_t get_thread_id(void)
+{
+#if defined(HAVE_GETTID)
+	return gettid();
+#elif defined(HAVE_PTHREAD_THREADID_NP)
+	uint64_t tid;
+
+	if (pthread_threadid_np(NULL, &tid))
+		return tid;
+#elif defined(HAVE_PTHREAD)
+	return (__u64)(uintptr_t) pthread_self();
+#endif
+	return getpid();
+}
+
+#ifdef DEBUG_PROGRAM
+int main(int argc, char **argv)
+{
+	printf("Thread id: %llu\n", get_thread_id());
+	return 0;
+}
+#endif
diff --git a/lib/support/thread.h b/lib/support/thread.h
new file mode 100644
index 000000000..9a7f5c9db
--- /dev/null
+++ b/lib/support/thread.h
@@ -0,0 +1,5 @@
+/*
+ * thread.h -- header file for thread utilities
+ */
+
+uint64_t get_thread_id(void);
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 0b43ec0fb..dfbc98636 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -48,6 +48,7 @@
 #include "ext2fs/ext2_fs.h"
 #include "ext2fs/ext2fsP.h"
 #include "support/bthread.h"
+#include "support/thread.h"
 #if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 0)
 # define FUSE_PLATFORM_OPTS	""
 #else
@@ -148,7 +149,7 @@ static inline uint64_t round_down(uint64_t b, unsigned int align)
 
 #define dbg_printf(fuse2fs, format, ...) \
 	while ((fuse2fs)->debug) { \
-		printf("FUSE2FS (%s): tid=%d " format, (fuse2fs)->shortdev, gettid(), ##__VA_ARGS__); \
+		printf("FUSE2FS (%s): tid=%llu " format, (fuse2fs)->shortdev, get_thread_id(), ##__VA_ARGS__); \
 		fflush(stdout); \
 		break; \
 	}
-- 
2.51.0

