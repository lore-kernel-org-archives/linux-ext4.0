From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Fix up configure so it finds mkinstalldirs
Date: Thu, 10 Jul 2014 00:19:18 -0400
Message-ID: <1404965958-4793-1-git-send-email-tytso@mit.edu>
Cc: Ross Burton <ross.burton@intel.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55069 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaGJET2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Jul 2014 00:19:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As an object lesson in why autoreconf is fundamentally unsafe, the
newer version of nls.m4 no longer handles @MKINSTALLDIRS@.  So add
this back, since our Makefiles depend on it.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 acinclude.m4 | 18 ++++++++++++++++++
 configure    | 14 ++++++++++++++
 configure.in |  1 +
 3 files changed, 33 insertions(+)

diff --git a/acinclude.m4 b/acinclude.m4
index cf84acc..4c8a77c 100644
--- a/acinclude.m4
+++ b/acinclude.m4
@@ -128,3 +128,21 @@ dnl If there was a GNU version, then set @ifGNUmake@ to the empty string, '#' ot
         AC_SUBST(ifGNUmake)
         AC_SUBST(ifNotGNUmake)
 ] )
+# was originally from nls.m4 serial 1 (gettext-0.12)
+AC_DEFUN([AM_MKINSTALLDIRS],
+[
+  dnl If the AC_CONFIG_AUX_DIR macro for autoconf is used we possibly
+  dnl find the mkinstalldirs script in another subdir but $(top_srcdir).
+  dnl Try to locate it.
+  MKINSTALLDIRS=
+  if test -n "$ac_aux_dir"; then
+    case "$ac_aux_dir" in
+      /*) MKINSTALLDIRS="$ac_aux_dir/mkinstalldirs" ;;
+      *) MKINSTALLDIRS="\$(top_builddir)/$ac_aux_dir/mkinstalldirs" ;;
+    esac
+  fi
+  if test -z "$MKINSTALLDIRS"; then
+    MKINSTALLDIRS="\$(top_srcdir)/mkinstalldirs"
+  fi
+  AC_SUBST(MKINSTALLDIRS)
+])
diff --git a/configure b/configure
index 33613bd..1886f8f 100755
--- a/configure
+++ b/configure
@@ -627,6 +627,7 @@ ac_subst_vars='LTLIBOBJS
 LIBOBJS
 BUILD_LDFLAGS
 BUILD_CFLAGS
+MKINSTALLDIRS
 INCLUDES
 DO_TEST_SUITE
 ET_DIR
@@ -13386,6 +13387,19 @@ if test -n "$WITH_DIET_LIBC" ; then
 	INCLUDES="$INCLUDES -D_REENTRANT"
 fi
 
+
+        MKINSTALLDIRS=
+  if test -n "$ac_aux_dir"; then
+    case "$ac_aux_dir" in
+      /*) MKINSTALLDIRS="$ac_aux_dir/mkinstalldirs" ;;
+      *) MKINSTALLDIRS="\$(top_builddir)/$ac_aux_dir/mkinstalldirs" ;;
+    esac
+  fi
+  if test -z "$MKINSTALLDIRS"; then
+    MKINSTALLDIRS="\$(top_srcdir)/mkinstalldirs"
+  fi
+
+
 if test $cross_compiling = no; then
    BUILD_CFLAGS="$CFLAGS $CPPFLAGS $INCLUDES -DHAVE_CONFIG_H"
    BUILD_LDFLAGS="$LDFLAGS"
diff --git a/configure.in b/configure.in
index 6b09f21..ed9f691 100644
--- a/configure.in
+++ b/configure.in
@@ -1295,6 +1295,7 @@ if test -n "$WITH_DIET_LIBC" ; then
 	INCLUDES="$INCLUDES -D_REENTRANT"
 fi
 AC_SUBST(INCLUDES)
+AM_MKINSTALLDIRS
 dnl
 dnl Build CFLAGS
 dnl
-- 
2.0.0

