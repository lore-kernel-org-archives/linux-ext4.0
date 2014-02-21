From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] e2fsprogs: Build external libblkid by default
Date: Fri, 21 Feb 2014 12:06:30 +0100
Message-ID: <1392980790-6674-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbaBULGh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Feb 2014 06:06:37 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit changes configure script to build external libblkid library by
default instead of building the local blkid. The reason is that the
the external libblkid is where all the development takes place and it
should be always preferred option. We still have an option
'--enable-blkid' to enable local build of the blkid library.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 configure    | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++----------
 configure.in | 23 +++++++++++++----------
 2 files changed, 63 insertions(+), 20 deletions(-)

diff --git a/configure b/configure
index 3c5a5ff..642615f 100755
--- a/configure
+++ b/configure
@@ -1500,7 +1500,7 @@ Optional Features:
   --enable-blkid-debug    enable blkid debugging
   --disable-testio-debug  disable the use of the test I/O manager for debugging
   --disable-libuuid	  do not build private uuid library
-  --disable-libblkid	  do not build private blkid library
+  --enable-libblkid	  build private blkid library
   --enable-quota	  enable quota support
   --disable-backtrace	  disable use backtrace
   --disable-debugfs   	  disable support of debugfs program
@@ -5178,16 +5178,56 @@ $as_echo "Enabling private blkid library" >&6; }
 fi
 
 else
-  LIBBLKID='$(LIB)/libblkid'$LIB_EXT
-DEPLIBBLKID=$LIBBLKID
-STATIC_LIBBLKID='$(LIB)/libblkid'$STATIC_LIB_EXT
-DEPSTATIC_LIBBLKID=$STATIC_LIBBLKID
-PROFILED_LIBBLKID='$(LIB)/libblkid'$PROFILED_LIB_EXT
-DEPPROFILED_LIBBLKID=$PROFILED_LIBBLKID
-$as_echo "#define CONFIG_BUILD_FINDFS 1" >>confdefs.h
+  if test -z "$PKG_CONFIG"; then
+	as_fn_error $? "pkg-config not installed; please install it." "$LINENO" 5
+fi
+
+{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for blkid_get_cache in -lblkid" >&5
+$as_echo_n "checking for blkid_get_cache in -lblkid... " >&6; }
+if ${ac_cv_lib_blkid_blkid_get_cache+:} false; then :
+  $as_echo_n "(cached) " >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-lblkid $LIBBLKID $LIBS"
+cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char blkid_get_cache ();
+int
+main ()
+{
+return blkid_get_cache ();
+  ;
+  return 0;
+}
+_ACEOF
+if ac_fn_c_try_link "$LINENO"; then :
+  ac_cv_lib_blkid_blkid_get_cache=yes
+else
+  ac_cv_lib_blkid_blkid_get_cache=no
+fi
+rm -f core conftest.err conftest.$ac_objext \
+    conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_cv_lib_blkid_blkid_get_cache" >&5
+$as_echo "$ac_cv_lib_blkid_blkid_get_cache" >&6; }
+if test "x$ac_cv_lib_blkid_blkid_get_cache" = xyes; then :
+  LIBBLKID=`$PKG_CONFIG --libs blkid`;
+	 STATIC_LIBBLKID=`$PKG_CONFIG --static --libs blkid`
+else
+  as_fn_error $? "external blkid library not found" "$LINENO" 5
+fi
 
-{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Enabling private blkid library by default" >&5
-$as_echo "Enabling private blkid library by default" >&6; }
+BLKID_CMT=#
+{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Disabling private blkid library by default" >&5
+$as_echo "Disabling private blkid library by default" >&6; }
 
 fi
 
diff --git a/configure.in b/configure.in
index 28d7557..ed072fa 100644
--- a/configure.in
+++ b/configure.in
@@ -516,7 +516,7 @@ AC_SUBST(PROFILED_LIBUUID)
 AC_SUBST(DEPPROFILED_LIBUUID)
 AC_SUBST(UUID_CMT)
 dnl
-dnl handle --disable-libblkid
+dnl handle --enable-libblkid
 dnl
 PKG_PROG_PKG_CONFIG
 LIBBLKID=
@@ -528,7 +528,7 @@ DEPPROFILED_LIBBLKID=
 BLKID_CMT=
 AH_TEMPLATE([CONFIG_BUILD_FINDFS], [Define to 1 to compile findfs])
 AC_ARG_ENABLE([libblkid],
-[  --disable-libblkid	  do not build private blkid library],
+[  --enable-libblkid	  build private blkid library],
 if test "$enableval" = "no"
 then
 	if test -z "$PKG_CONFIG"; then
@@ -553,14 +553,17 @@ else
 	AC_MSG_RESULT([Enabling private blkid library])
 fi
 ,
-LIBBLKID='$(LIB)/libblkid'$LIB_EXT
-DEPLIBBLKID=$LIBBLKID
-STATIC_LIBBLKID='$(LIB)/libblkid'$STATIC_LIB_EXT
-DEPSTATIC_LIBBLKID=$STATIC_LIBBLKID
-PROFILED_LIBBLKID='$(LIB)/libblkid'$PROFILED_LIB_EXT
-DEPPROFILED_LIBBLKID=$PROFILED_LIBBLKID
-AC_DEFINE(CONFIG_BUILD_FINDFS, 1)
-AC_MSG_RESULT([Enabling private blkid library by default])
+if test -z "$PKG_CONFIG"; then
+	AC_MSG_ERROR([pkg-config not installed; please install it.])
+fi
+
+AC_CHECK_LIB(blkid, blkid_get_cache,
+	[LIBBLKID=`$PKG_CONFIG --libs blkid`;
+	 STATIC_LIBBLKID=`$PKG_CONFIG --static --libs blkid`],
+	[AC_MSG_ERROR([external blkid library not found])],
+	[$LIBBLKID])
+BLKID_CMT=#
+AC_MSG_RESULT([Disabling private blkid library by default])
 )
 AC_SUBST(LIBBLKID)
 AC_SUBST(DEPLIBBLKID)
-- 
1.8.3.1

