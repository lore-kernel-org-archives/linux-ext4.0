From: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] configure: Disable libblkid by default
Date: Thu, 16 Jul 2009 19:46:13 +0100
Message-ID: <E1MRWBp-0000yN-9a@zelda.netsplit.com>
Cc: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Since util-linux-ng now builds libblkid by default, e2fsprogs
should not do so.

Signed-off-by: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 configure    |   93 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 configure.in |   21 +++++++-----
 2 files changed, 94 insertions(+), 20 deletions(-)

diff --git a/configure b/configure
index 769dc09..5c272d8 100755
--- a/configure
+++ b/configure
@@ -1499,7 +1499,7 @@ Optional Features:
   --enable-blkid-debug    enable blkid debugging
   --disable-testio-debug  disable the use of the test I/O manager for debugging
   --disable-libuuid	  do not build private uuid library
-  --disable-libblkid	  do not build private blkid library
+  --enable-libblkid	  build private blkid library
   --disable-debugfs   	  disable support of debugfs program
   --disable-imager   	  disable support of e2image program
   --disable-resizer   	  disable support of e2resize program
@@ -4684,18 +4684,89 @@ $as_echo "Enabling private blkid library" >&6; }
 fi
 
 else
-  LIBBLKID='$(LIB)/libblkid'$LIB_EXT
-DEPLIBBLKID=$LIBBLKID
-STATIC_LIBBLKID='$(LIB)/libblkid'$STATIC_LIB_EXT
-DEPSTATIC_LIBBLKID=$STATIC_LIBBLKID
-PROFILED_LIBBLKID='$(LIB)/libblkid'$PROFILED_LIB_EXT
-DEPPROFILED_LIBBLKID=$PROFILED_LIBBLKID
-cat >>confdefs.h <<\_ACEOF
-#define CONFIG_BUILD_FINDFS 1
+  if test -z "$PKG_CONFIG"; then
+	{ { $as_echo "$as_me:$LINENO: error: pkg-config not installed; please install it." >&5
+$as_echo "$as_me: error: pkg-config not installed; please install it." >&2;}
+   { (exit 1); exit 1; }; }
+fi
+
+{ $as_echo "$as_me:$LINENO: checking for blkid_get_cache in -lblkid" >&5
+$as_echo_n "checking for blkid_get_cache in -lblkid... " >&6; }
+if test "${ac_cv_lib_blkid_blkid_get_cache+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-lblkid $LIBBLKID $LIBS"
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
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
 _ACEOF
+rm -f conftest.$ac_objext conftest$ac_exeext
+if { (ac_try="$ac_link"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
+$as_echo "$ac_try_echo") >&5
+  (eval "$ac_link") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest$ac_exeext && {
+	 test "$cross_compiling" = yes ||
+	 $as_test_x conftest$ac_exeext
+       }; then
+  ac_cv_lib_blkid_blkid_get_cache=yes
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_lib_blkid_blkid_get_cache=no
+fi
+
+rm -rf conftest.dSYM
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_lib_blkid_blkid_get_cache" >&5
+$as_echo "$ac_cv_lib_blkid_blkid_get_cache" >&6; }
+if test "x$ac_cv_lib_blkid_blkid_get_cache" = x""yes; then
+  LIBBLKID=`$PKG_CONFIG --libs blkid`;
+	 STATIC_LIBBLKID=`$PKG_CONFIG --static --libs blkid`
+else
+  { { $as_echo "$as_me:$LINENO: error: external blkid library not found" >&5
+$as_echo "$as_me: error: external blkid library not found" >&2;}
+   { (exit 1); exit 1; }; }
+fi
 
-{ $as_echo "$as_me:$LINENO: result: Enabling private blkid library by default" >&5
-$as_echo "Enabling private blkid library by default" >&6; }
+BLKID_CMT=#
+{ $as_echo "$as_me:$LINENO: result: Disabling private blkid library by default" >&5
+$as_echo "Disabling private blkid library by default" >&6; }
 
 fi
 
diff --git a/configure.in b/configure.in
index d11faec..25b9427 100644
--- a/configure.in
+++ b/configure.in
@@ -463,7 +463,7 @@ PROFILED_LIBBLKID=
 DEPPROFILED_LIBBLKID=
 BLKID_CMT=
 AC_ARG_ENABLE([libblkid],
-[  --disable-libblkid	  do not build private blkid library],
+[  --enable-libblkid	  build private blkid library],
 if test "$enableval" = "no"
 then
 	if test -z "$PKG_CONFIG"; then
@@ -488,14 +488,17 @@ else
 	AC_MSG_RESULT([Enabling private blkid library])
 fi
 ,
-LIBBLKID='$(LIB)/libblkid'$LIB_EXT
-DEPLIBBLKID=$LIBBLKID
-STATIC_LIBBLKID='$(LIB)/libblkid'$STATIC_LIB_EXT
-DEPSTATIC_LIBBLKID=$STATIC_LIBBLKID
-PROFILED_LIBBLKID='$(LIB)/libblkid'$PROFILED_LIB_EXT
-DEPPROFILED_LIBBLKID=$PROFILED_LIBBLKID
-AC_DEFINE(CONFIG_BUILD_FINDFS)
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
1.6.0.5

--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
