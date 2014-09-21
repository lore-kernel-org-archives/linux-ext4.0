From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] misc: if dlopen() is available, use it to load the libmagic library
Date: Sun, 21 Sep 2014 01:28:26 -0400
Message-ID: <1411277306-29807-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39333 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbaIUF2h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Sep 2014 01:28:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This prevents the libmagic library from being a hard dependency; if
it's not there, we can simply do without it.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure        |  3 +++
 configure.in     |  3 +++
 misc/plausible.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/configure b/configure
index 7ee6323..2bc1275 100755
--- a/configure
+++ b/configure
@@ -13187,6 +13187,9 @@ done
 
 fi
 
+if test "$ac_cv_lib_dl_dlopen" = yes ; then
+   MAGIC_LIB=$DLOPEN_LIB
+fi
 
 { $as_echo "$as_me:${as_lineno-$LINENO}: checking for optreset" >&5
 $as_echo_n "checking for optreset... " >&6; }
diff --git a/configure.in b/configure.in
index 3bd3c20..e809324 100644
--- a/configure.in
+++ b/configure.in
@@ -1157,6 +1157,9 @@ dnl See if libmagic exists
 dnl
 AC_CHECK_LIB(magic, magic_file, [MAGIC_LIB=-lmagic
 AC_CHECK_HEADERS([magic.h])])
+if test "$ac_cv_lib_dl_dlopen" = yes ; then
+   MAGIC_LIB=$DLOPEN_LIB
+fi
 AC_SUBST(MAGIC_LIB)
 dnl
 dnl See if optreset exists
diff --git a/misc/plausible.c b/misc/plausible.c
index caeb929..aea4fce 100644
--- a/misc/plausible.c
+++ b/misc/plausible.c
@@ -36,6 +36,48 @@
 #include "nls-enable.h"
 #include "blkid/blkid.h"
 
+static magic_t (*dl_magic_open)(int);
+static const char *(*dl_magic_file)(magic_t, const char *);
+static int (*dl_magic_load)(magic_t, const char *);
+static void (*dl_magic_close)(magic_t);
+
+#ifdef HAVE_MAGIC_H
+#ifdef HAVE_DLOPEN
+#include <dlfcn.h>
+
+static void *magic_handle;
+
+static int magic_library_available(void)
+{
+	if (!magic_handle) {
+		magic_handle = dlopen("libmagic.so.1", RTLD_NOW);
+		if (!magic_handle)
+			return 0;
+
+		dl_magic_open = dlsym(magic_handle, "magic_open");
+		dl_magic_file = dlsym(magic_handle, "magic_file");
+		dl_magic_load = dlsym(magic_handle, "magic_load");
+		dl_magic_close = dlsym(magic_handle, "magic_close");
+	}
+
+	if (!dl_magic_open || !dl_magic_file ||
+	    !dl_magic_load || !dl_magic_close)
+		return 0;
+	return 1;
+}
+#else
+static int magic_library_available(void)
+{
+	dl_magic_open = magic_open;
+	dl_magic_file = magic_file;
+	dl_magic_load = magic_load;
+	dl_magic_close = magic_close;
+
+	return 1;
+}
+#endif
+#endif
+
 static void print_ext2_info(const char *device)
 
 {
@@ -198,20 +240,20 @@ int check_plausibility(const char *device, int flags, int *ret_is_dev)
 	}
 
 #ifdef HAVE_MAGIC_H
-	if (flags & CHECK_FS_EXIST) {
+	if ((flags & CHECK_FS_EXIST) && magic_library_available()) {
 		const char *msg;
 		magic_t mag;
 
-		mag = magic_open(MAGIC_RAW | MAGIC_SYMLINK | MAGIC_DEVICES |
-				 MAGIC_ERROR | MAGIC_NO_CHECK_ELF |
-				 MAGIC_NO_CHECK_COMPRESS);
-		magic_load(mag, NULL);
+		mag = dl_magic_open(MAGIC_RAW | MAGIC_SYMLINK | MAGIC_DEVICES |
+				    MAGIC_ERROR | MAGIC_NO_CHECK_ELF |
+				    MAGIC_NO_CHECK_COMPRESS);
+		dl_magic_load(mag, NULL);
 
-		msg = magic_file(mag, device);
+		msg = dl_magic_file(mag, device);
 		if (msg && strcmp(msg, "data") && strcmp(msg, "empty"))
 			printf(_("%s contains a `%s'\n"), device, msg);
 
-		magic_close(mag);
+		dl_magic_close(mag);
 		return 0;
 	}
 #endif
-- 
2.1.0

