From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/4] misc: enable link time optimization, if requested
Date: Fri, 19 Jan 2018 22:12:57 -0800
Message-ID: <151642877694.9652.14991059893032625705.stgit@magnolia>
References: <151642877063.9652.3628059578106842868.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49906 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbeATGNB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Jan 2018 01:13:01 -0500
In-Reply-To: <151642877063.9652.3628059578106842868.stgit@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable link time optimization (LTO) if the builder requests it.  The
extra link optimization results in smaller binaries.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 MCONFIG.in   |   19 +++++---
 configure    |  140 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 configure.ac |   34 ++++++++++++++
 debian/rules |    2 -
 4 files changed, 184 insertions(+), 11 deletions(-)


diff --git a/MCONFIG.in b/MCONFIG.in
index aa7d0d1..84de8d9 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -80,21 +80,24 @@ UDEVRULESDIR = @udevrulesdir@
 @ifNotGNUmake@ CHECK_CMD=true
 @ifNotGNUmake@ CPPCHECK_CMD=true
 
+SANITIZER_CFLAGS = @lto_cflags@
+SANITIZER_LDFLAGS = @lto_ldflags@
+
 CC = @CC@
 BUILD_CC = @BUILD_CC@
-CFLAGS = @CFLAGS@
-CFLAGS_SHLIB = @CFLAGS_SHLIB@
-CFLAGS_STLIB = @CFLAGS_STLIB@
+CFLAGS = $(SANITIZER_CFLAGS) @CFLAGS@
+CFLAGS_SHLIB = $(SANITIZER_CFLAGS) @CFLAGS_SHLIB@
+CFLAGS_STLIB = $(SANITIZER_CFLAGS) @CFLAGS_STLIB@
 CPPFLAGS = @INCLUDES@
 ALL_CFLAGS = $(CPPFLAGS) $(CFLAGS) $(CFLAGS_WARN) @DEFS@ $(LOCAL_CFLAGS)
 ALL_CFLAGS_SHLIB = $(CPPFLAGS) $(CFLAGS_SHLIB) $(CFLAGS_WARN) @DEFS@ $(LOCAL_CFLAGS)
 ALL_CFLAGS_STLIB = $(CPPFLAGS) $(CFLAGS_STLIB) $(CFLAGS_WARN) @DEFS@ $(LOCAL_CFLAGS)
-LDFLAGS = @LDFLAGS@
-LDFLAGS_SHLIB = @LDFLAGS_SHLIB@
+LDFLAGS = $(SANITIZER_LDFLAGS) @LDFLAGS@
+LDFLAGS_SHLIB = $(SANITIZER_LDFLAGS) @LDFLAGS_SHLIB@
 ALL_LDFLAGS = $(LDFLAGS) @LDFLAG_DYNAMIC@
-LDFLAGS_STATIC = @LDFLAGS_STATIC@
-BUILD_CFLAGS = @BUILD_CFLAGS@
-BUILD_LDFLAGS = @BUILD_LDFLAGS@
+LDFLAGS_STATIC = $(SANITIZER_LDFLAGS) @LDFLAGS_STATIC@
+BUILD_CFLAGS = $(SANITIZER_CFLAGS) @BUILD_CFLAGS@
+BUILD_LDFLAGS = $(SANITIZER_LDFLAGS) @BUILD_LDFLAGS@
 RDYNAMIC = @RDYNAMIC@
 LINK_BUILD_FLAGS = @LINK_BUILD_FLAGS@
 LINK_INSTALL_FLAGS = @LINK_INSTALL_FLAGS@
diff --git a/configure b/configure
index 5f9a2d0..181fb76 100755
--- a/configure
+++ b/configure
@@ -649,6 +649,11 @@ E2SCRUB_CMT
 UNIX_CMT
 CYGWIN_CMT
 LINUX_CMT
+lto_ldflags
+lto_cflags
+have_lto
+gcc_ranlib
+gcc_ar
 UNI_DIFF_OPTS
 SEM_INIT_LIB
 FUSE_CMT
@@ -898,6 +903,7 @@ with_libiconv_prefix
 with_included_gettext
 with_libintl_prefix
 enable_fuse2fs
+enable_lto
 with_multiarch
 '
       ac_precious_vars='build_alias
@@ -1569,6 +1575,7 @@ Optional Features:
   --disable-threads       build without multithread safety
   --disable-rpath         do not hardcode runtime library paths
   --disable-fuse2fs	  do not build fuse2fs
+  --enable-lto		  enable link time optimization
 
 Optional Packages:
   --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
@@ -7243,8 +7250,6 @@ main ()
     if (*(data + i) != *(data3 + i))
       return 14;
   close (fd);
-  free (data);
-  free (data3);
   return 0;
 }
 _ACEOF
@@ -13705,6 +13710,137 @@ $as_echo "#define HAVE_EXT2_IOCTLS 1" >>confdefs.h
 
 	;;
 esac
+# Check whether --enable-lto was given.
+if test "${enable_lto+set}" = set; then :
+  enableval=$enable_lto;
+else
+  enable_lto=probe
+fi
+
+if test "$enable_lto" = "yes" || test "$enable_lto" = "probe"; then
+	{ $as_echo "$as_me:${as_lineno-$LINENO}: checking if C compiler supports LTO" >&5
+$as_echo_n "checking if C compiler supports LTO... " >&6; }
+	OLD_CFLAGS="$CFLAGS"
+	OLD_LDFLAGS="$LDFLAGS"
+	LTO_FLAGS="-flto -ffat-lto-objects"
+	CFLAGS="$CFLAGS $LTO_FLAGS"
+	LDFLAGS="$LDFLAGS $LTO_FLAGS"
+	cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+
+int
+main ()
+{
+
+  ;
+  return 0;
+}
+_ACEOF
+if ac_fn_c_try_link "$LINENO"; then :
+  { $as_echo "$as_me:${as_lineno-$LINENO}: result: yes" >&5
+$as_echo "yes" >&6; }
+		lto_cflags=$LTO_FLAGS
+		lto_ldflags=$LTO_FLAGS
+		# Extract the first word of "gcc-ar", so it can be a program name with args.
+set dummy gcc-ar; ac_word=$2
+{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for $ac_word" >&5
+$as_echo_n "checking for $ac_word... " >&6; }
+if ${ac_cv_path_gcc_ar+:} false; then :
+  $as_echo_n "(cached) " >&6
+else
+  case $gcc_ar in
+  [\\/]* | ?:[\\/]*)
+  ac_cv_path_gcc_ar="$gcc_ar" # Let the user override the test with a path.
+  ;;
+  *)
+  as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+    for ac_exec_ext in '' $ac_executable_extensions; do
+  if as_fn_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
+    ac_cv_path_gcc_ar="$as_dir/$ac_word$ac_exec_ext"
+    $as_echo "$as_me:${as_lineno-$LINENO}: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+  done
+IFS=$as_save_IFS
+
+  ;;
+esac
+fi
+gcc_ar=$ac_cv_path_gcc_ar
+if test -n "$gcc_ar"; then
+  { $as_echo "$as_me:${as_lineno-$LINENO}: result: $gcc_ar" >&5
+$as_echo "$gcc_ar" >&6; }
+else
+  { $as_echo "$as_me:${as_lineno-$LINENO}: result: no" >&5
+$as_echo "no" >&6; }
+fi
+
+
+		# Extract the first word of "gcc-ranlib", so it can be a program name with args.
+set dummy gcc-ranlib; ac_word=$2
+{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for $ac_word" >&5
+$as_echo_n "checking for $ac_word... " >&6; }
+if ${ac_cv_path_gcc_ranlib+:} false; then :
+  $as_echo_n "(cached) " >&6
+else
+  case $gcc_ranlib in
+  [\\/]* | ?:[\\/]*)
+  ac_cv_path_gcc_ranlib="$gcc_ranlib" # Let the user override the test with a path.
+  ;;
+  *)
+  as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+    for ac_exec_ext in '' $ac_executable_extensions; do
+  if as_fn_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
+    ac_cv_path_gcc_ranlib="$as_dir/$ac_word$ac_exec_ext"
+    $as_echo "$as_me:${as_lineno-$LINENO}: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+  done
+IFS=$as_save_IFS
+
+  ;;
+esac
+fi
+gcc_ranlib=$ac_cv_path_gcc_ranlib
+if test -n "$gcc_ranlib"; then
+  { $as_echo "$as_me:${as_lineno-$LINENO}: result: $gcc_ranlib" >&5
+$as_echo "$gcc_ranlib" >&6; }
+else
+  { $as_echo "$as_me:${as_lineno-$LINENO}: result: no" >&5
+$as_echo "no" >&6; }
+fi
+
+
+else
+  { $as_echo "$as_me:${as_lineno-$LINENO}: result: no" >&5
+$as_echo "no" >&6; }
+fi
+rm -f core conftest.err conftest.$ac_objext \
+    conftest$ac_exeext conftest.$ac_ext
+	if test -x "$gcc_ar" && test -x "$gcc_ranlib"; then
+		have_lto=yes
+		AR="${gcc_ar}"
+		RANLIB="${gcc_ranlib}"
+	fi
+	CFLAGS="${OLD_CFLAGS}"
+	LDFLAGS="${OLD_LDFLAGS}"
+
+
+
+fi
+if test "$enable_lto" = "yes" && test "$have_lto" != "yes"; then
+	as_fn_error $? "LTO not supported by compiler." "$LINENO" 5
+fi
 LINUX_CMT="#"
 CYGWIN_CMT="#"
 UNIX_CMT=
diff --git a/configure.ac b/configure.ac
index 922c4bd..609207f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1294,6 +1294,40 @@ linux*)
 	;;
 esac
 dnl
+dnl Enable LTO for all packages
+dnl
+AC_ARG_ENABLE([lto],
+[  --enable-lto		  enable link time optimization],,
+enable_lto=probe)
+if test "$enable_lto" = "yes" || test "$enable_lto" = "probe"; then
+	AC_MSG_CHECKING([if C compiler supports LTO])
+	OLD_CFLAGS="$CFLAGS"
+	OLD_LDFLAGS="$LDFLAGS"
+	LTO_FLAGS="-flto -ffat-lto-objects"
+	CFLAGS="$CFLAGS $LTO_FLAGS"
+	LDFLAGS="$LDFLAGS $LTO_FLAGS"
+	AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
+		[AC_MSG_RESULT([yes])]
+		[lto_cflags=$LTO_FLAGS]
+		[lto_ldflags=$LTO_FLAGS]
+		[AC_PATH_PROG(gcc_ar, gcc-ar,,)]
+		[AC_PATH_PROG(gcc_ranlib, gcc-ranlib,,)],
+		[AC_MSG_RESULT([no])])
+	if test -x "$gcc_ar" && test -x "$gcc_ranlib"; then
+		have_lto=yes
+		AR="${gcc_ar}"
+		RANLIB="${gcc_ranlib}"
+	fi
+	CFLAGS="${OLD_CFLAGS}"
+	LDFLAGS="${OLD_LDFLAGS}"
+	AC_SUBST(have_lto)
+	AC_SUBST(lto_cflags)
+	AC_SUBST(lto_ldflags)
+fi
+if test "$enable_lto" = "yes" && test "$have_lto" != "yes"; then
+	AC_MSG_ERROR([LTO not supported by compiler.])
+fi
+dnl
 dnl OS-specific uncomment control
 dnl
 LINUX_CMT="#"
diff --git a/debian/rules b/debian/rules
index 841715d..3a22c35 100755
--- a/debian/rules
+++ b/debian/rules
@@ -147,7 +147,7 @@ endif
 
 BACKTRACE_CONF_FLAGS ?= $(shell if ${debdir}/scripts/test-backtrace ; then echo --disable-backtrace ; fi)
 
-COMMON_CONF_FLAGS = --disable-e2initrd-helper \
+COMMON_CONF_FLAGS = --enable-lto --disable-e2initrd-helper \
 	--infodir=/usr/share/info  --enable-symlink-install \
 	--with-multiarch=$(DEB_HOST_MULTIARCH) \
 	$(BACKTRACE_CONF_FLAGS) $(UTIL_CONF_FLAGS)
