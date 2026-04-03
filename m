Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85970282F0F
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 04:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775189023; cv=none; b=O/dbVMI6z9lo77gLp9LQZ62g5cTkcUFgPnbEunUDpyWDzlbOykYoFpalPtSbrk5p60VZ53NGISBSV4buyJe3ZhqIutcLTO4u7h841AtFohoA87jSvuquY+MhpfGkskWKVkjNP0SvikMSsqaA1Rn9yr0vqxfmI/yIH21aPG5nmME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775189023; c=relaxed/simple;
	bh=c419BAkWp3WEZ9WnLXUoEl8hYxkxgiNB6GPEcVgsERM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZU2ALH1pCtuvMwxL7xdspPTVOPr0HqNLABqg4y4cFAJwMo39AFfTO3n+s5y20TzGXqnlQlb2Xb/ViqXa7IN/EgqCfpfMwDKzXWturn01gUP1BiSDa+HLv2MKPaWPuPuz7j29iMamv1QRCJGFZ7oyv7WxR88x+c7nW0ANVduHp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Vt6EZ7yk; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Vt6EZ7yk"
Received: from trampoline.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63343XgF005245
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 3 Apr 2026 00:03:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775189015; bh=8a9XubKYofDKTEsqwFWca7AWNfZeMqbD+7hjz0rLfBE=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=Vt6EZ7ykO9VqOH7uARl4cRO0TQtGd2syGOG7qRWLgD0x48z7rGscI7dIJgEgqu59s
	 7rllPYJRz6gM2P6/USfpw45hMY41LOpK1If05Pb5xx9DRTu7fg/f0P7NT4m/OVzaEk
	 aL+2tJ//+0+YotmCN9+9C+OBmr06w5XYoji/wnwS68KuBd0bSUI9+xhC4YNodYFEIR
	 s1/yGbF9QN2j+gB6aNDMMLDP6ju3ccNKPKhQBISuDwgI8yDXErroMEkhQ83m/387wz
	 AOefSX4N+UL+xVWb454ecs5OTv1InmltRtk0iN68wWGM8mLdWH2cWp+MIBY5+bJ4QH
	 nCJ1JiU2dgzJQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 7570C2E00D1; Fri, 03 Apr 2026 00:03:33 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 1/3] libsupport: fix portability issues with the bthread.c
Date: Fri,  3 Apr 2026 00:03:26 -0400
Message-ID: <20260403040328.2385083-2-tytso@mit.edu>
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

The function pthread_setname_np() is non-portable; that's what the
"np" means.  In particular, on Mac systems, the function takes only a
single argument, while on most other systems which have the function,
it takes two arguments.

Also fix a problem where a 1-bit signed integer can only accept values
of 0 or -1.  Change it to be a 1-bit unsigned integer, which can
accept values of 0 or 1.  Clang will issue a warning if 1-bit signed
integer are used incorrectly, and fail with -Werror.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 configure             |  6 ++++++
 configure.ac          |  1 +
 lib/config.h.in       | 24 +++++++++++++++---------
 lib/support/bthread.c | 12 ++++++++++--
 4 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/configure b/configure
index 4da5439fe..b9a82dcec 100755
--- a/configure
+++ b/configure
@@ -13887,6 +13887,12 @@ if test "x$ac_cv_func_pwrite64" = xyes
 then :
   printf "%s\n" "#define HAVE_PWRITE64 1" >>confdefs.h
 
+fi
+ac_fn_c_check_func "$LINENO" "pthread_setname_np" "ac_cv_func_pthread_setname_np"
+if test "x$ac_cv_func_pthread_setname_np" = xyes
+then :
+  printf "%s\n" "#define HAVE_PTHREAD_SETNAME_NP 1" >>confdefs.h
+
 fi
 ac_fn_c_check_func "$LINENO" "qsort_r" "ac_cv_func_qsort_r"
 if test "x$ac_cv_func_qsort_r" = xyes
diff --git a/configure.ac b/configure.ac
index ecef9df39..2473879fd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1269,6 +1269,7 @@ AC_CHECK_FUNCS(m4_flatten([
 	pwrite
 	pread64
 	pwrite64
+	pthread_setname_np
 	qsort_r
 	secure_getenv
 	setmntent
diff --git a/lib/config.h.in b/lib/config.h.in
index 8ea7ec2b1..c6cbced5f 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -46,9 +46,6 @@
 /* Define to the version of FUSE to use */
 #undef FUSE_USE_VERSION
 
-/* Define to 1 if fuse supports cache_readdir */
-#undef HAVE_FUSE_CACHE_READDIR
-
 /* Define to 1 if you have the 'add_key' function. */
 #undef HAVE_ADD_KEY
 
@@ -73,9 +70,6 @@
 /* Define to 1 if you have the BSD-style 'qsort_r' function. */
 #undef HAVE_BSD_QSORT_R
 
-/* Define to 1 if PR_SET_IO_FLUSHER is present */
-#undef HAVE_PR_SET_IO_FLUSHER
-
 /* Define to 1 if you have the Mac OS X function
    CFLocaleCopyPreferredLanguages in the CoreFoundation framework. */
 #undef HAVE_CFLOCALECOPYPREFERREDLANGUAGES
@@ -87,6 +81,9 @@
 /* Define to 1 if you have the 'chflags' function. */
 #undef HAVE_CHFLAGS
 
+/* Define to 1 if CLOCK_MONOTONIC is present */
+#undef HAVE_CLOCK_MONOTONIC
+
 /* Define if the GNU dcgettext() function is already present or preinstalled.
    */
 #undef HAVE_DCGETTEXT
@@ -136,9 +133,15 @@
 /* Define to 1 if you have the 'fsync' function. */
 #undef HAVE_FSYNC
 
+/* Define to 1 if FS_IOC_READ_VERITY_METADATA ioctl is available */
+#undef HAVE_FS_IOC_READ_VERITY_METADATA
+
 /* Define to 1 if you have the 'ftruncate64' function. */
 #undef HAVE_FTRUNCATE64
 
+/* Define to 1 if fuse supports cache_readdir */
+#undef HAVE_FUSE_CACHE_READDIR
+
 /* Define to 1 if you have the <fuse.h> header file. */
 #undef HAVE_FUSE_H
 
@@ -313,6 +316,9 @@
 /* Define to 1 if you have the 'pread64' function. */
 #undef HAVE_PREAD64
 
+/* Define to 1 if PR_SET_IO_FLUSHER is present */
+#undef HAVE_PR_SET_IO_FLUSHER
+
 /* Define if you have POSIX threads libraries and header files. */
 #undef HAVE_PTHREAD
 
@@ -322,6 +328,9 @@
 /* Have PTHREAD_PRIO_INHERIT. */
 #undef HAVE_PTHREAD_PRIO_INHERIT
 
+/* Define to 1 if you have the 'pthread_setname_np' function. */
+#undef HAVE_PTHREAD_SETNAME_NP
+
 /* Define to 1 if you have the 'pwrite' function. */
 #undef HAVE_PWRITE
 
@@ -699,7 +708,4 @@
 /* Define to 1 on platforms where this makes time_t a 64-bit type. */
 #undef __MINGW_USE_VC2005_COMPAT
 
-/* Define to 1 if CLOCK_MONOTONIC is present */
-#undef HAVE_CLOCK_MONOTONIC
-
 #include <dirpaths.h>
diff --git a/lib/support/bthread.c b/lib/support/bthread.c
index 936ca0f0f..87eeb1b3d 100644
--- a/lib/support/bthread.c
+++ b/lib/support/bthread.c
@@ -9,6 +9,7 @@
  * %End-Header%
  */
 #include "config.h"
+#ifdef HAVE_PTHREAD
 #include <stdlib.h>
 #include <errno.h>
 #include <pthread.h>
@@ -33,7 +34,7 @@ struct bthread {
 	bthread_fn_t fn;
 	void *data;
 	unsigned int period; /* seconds */
-	int can_join:1;
+	unsigned int can_join:1;
 };
 
 /* Wait for a signal or for the periodic interval */
@@ -101,7 +102,13 @@ int bthread_create(const char *name,  bthread_fn_t fn, void *data,
 	if (error)
 		goto out_cond;
 
+#ifdef HAVE_PTHREAD_SETNAME_NP
+#ifdef __APPLE__
+	pthread_setname_np(name);
+#else
 	pthread_setname_np(bt->thread, name);
+#endif
+#endif
 
 	*btp = bt;
 	return 0;
@@ -178,7 +185,7 @@ int bthread_cancel(struct bthread *bt)
 /* Ask the thread to cancel itself and wait for it */
 void bthread_stop(struct bthread *bt)
 {
-	int need_join = 0;
+	unsigned int need_join = 0;
 
 	pthread_mutex_lock(&bt->lock);
 	switch (bt->state) {
@@ -199,3 +206,4 @@ void bthread_stop(struct bthread *bt)
 	if (need_join)
 		pthread_join(bt->thread, NULL);
 }
+#endif /* HAVE_PTHREAD */
-- 
2.51.0

