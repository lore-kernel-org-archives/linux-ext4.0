From: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] configure: Disable libuuid by default
Date: Thu, 16 Jul 2009 19:51:39 +0100
Message-ID: <E1MRWBp-0000yX-IX@zelda.netsplit.com>
Cc: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Since util-linux-ng now builds libuuid by default, e2fsprogs
should not do so.

Signed-off-by: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 configure    |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 configure.in |   20 +++++++-----
 2 files changed, 96 insertions(+), 17 deletions(-)

diff --git a/configure b/configure
index 9a29609..f3fe992 100755
--- a/configure
+++ b/configure
@@ -1498,7 +1498,7 @@ Optional Features:
   --enable-jbd-debug  	  enable journal debugging
   --enable-blkid-debug    enable blkid debugging
   --disable-testio-debug  disable the use of the test I/O manager for debugging
-  --disable-libuuid	  do not build private uuid library
+  --enable-libuuid	  build private uuid library
   --enable-libblkid	  build private blkid library
   --disable-debugfs   	  disable support of debugfs program
   --disable-imager   	  disable support of e2image program
@@ -4440,14 +4440,89 @@ $as_echo "Enabling private uuid library" >&6; }
 fi
 
 else
-  LIBUUID='$(LIB)/libuuid'$LIB_EXT
-DEPLIBUUID=$LIBUUID
-STATIC_LIBUUID='$(LIB)/libuuid'$STATIC_LIB_EXT
-DEPSTATIC_LIBUUID=$STATIC_LIBUUID
-PROFILED_LIBUUID='$(LIB)/libuuid'$PROFILED_LIB_EXT
-DEPPROFILED_LIBUUID=$PROFILED_LIBUUID
-{ $as_echo "$as_me:$LINENO: result: Enabling private uuid library by default" >&5
-$as_echo "Enabling private uuid library by default" >&6; }
+  if test -z "$PKG_CONFIG"; then
+	{ { $as_echo "$as_me:$LINENO: error: pkg-config not installed; please install it." >&5
+$as_echo "$as_me: error: pkg-config not installed; please install it." >&2;}
+   { (exit 1); exit 1; }; }
+fi
+
+{ $as_echo "$as_me:$LINENO: checking for uuid_generate in -luuid" >&5
+$as_echo_n "checking for uuid_generate in -luuid... " >&6; }
+if test "${ac_cv_lib_uuid_uuid_generate+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-luuid $LIBUUID $LIBS"
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
+char uuid_generate ();
+int
+main ()
+{
+return uuid_generate ();
+  ;
+  return 0;
+}
+_ACEOF
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
+  ac_cv_lib_uuid_uuid_generate=yes
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_lib_uuid_uuid_generate=no
+fi
+
+rm -rf conftest.dSYM
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_lib_uuid_uuid_generate" >&5
+$as_echo "$ac_cv_lib_uuid_uuid_generate" >&6; }
+if test "x$ac_cv_lib_uuid_uuid_generate" = x""yes; then
+  LIBUUID=`$PKG_CONFIG --libs uuid`;
+	 STATIC_LIBUUID=`$PKG_CONFIG --static --libs uuid`
+else
+  { { $as_echo "$as_me:$LINENO: error: external uuid library not found" >&5
+$as_echo "$as_me: error: external uuid library not found" >&2;}
+   { (exit 1); exit 1; }; }
+fi
+
+UUID_CMT=#
+{ $as_echo "$as_me:$LINENO: result: Disabling private uuid library by default" >&5
+$as_echo "Disabling private uuid library by default" >&6; }
 
 fi
 
diff --git a/configure.in b/configure.in
index d9990b4..1a7c040 100644
--- a/configure.in
+++ b/configure.in
@@ -412,7 +412,7 @@ PROFILED_LIBUUID=
 DEPPROFILED_LIBUUID=
 UUID_CMT=
 AC_ARG_ENABLE([libuuid],
-[  --disable-libuuid	  do not build private uuid library],
+[  --enable-libuuid	  build private uuid library],
 if test "$enableval" = "no"
 then
 	if test -z "$PKG_CONFIG"; then
@@ -436,13 +436,17 @@ else
 	AC_MSG_RESULT([Enabling private uuid library])
 fi
 ,
-LIBUUID='$(LIB)/libuuid'$LIB_EXT
-DEPLIBUUID=$LIBUUID
-STATIC_LIBUUID='$(LIB)/libuuid'$STATIC_LIB_EXT
-DEPSTATIC_LIBUUID=$STATIC_LIBUUID
-PROFILED_LIBUUID='$(LIB)/libuuid'$PROFILED_LIB_EXT
-DEPPROFILED_LIBUUID=$PROFILED_LIBUUID
-AC_MSG_RESULT([Enabling private uuid library by default])
+if test -z "$PKG_CONFIG"; then
+	AC_MSG_ERROR([pkg-config not installed; please install it.])
+fi
+
+AC_CHECK_LIB(uuid, uuid_generate,
+	[LIBUUID=`$PKG_CONFIG --libs uuid`;
+	 STATIC_LIBUUID=`$PKG_CONFIG --static --libs uuid`],
+	[AC_MSG_ERROR([external uuid library not found])],
+	[$LIBUUID])
+UUID_CMT=#
+AC_MSG_RESULT([Disabling private uuid library by default])
 )
 AC_SUBST(LIBUUID)
 AC_SUBST(DEPLIBUUID)
-- 
1.6.0.5

--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
