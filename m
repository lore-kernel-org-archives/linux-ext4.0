From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/4] misc: enable link time optimization, if requested
Date: Thu, 07 Dec 2017 10:48:48 -0800
Message-ID: <151267252874.1350.6941160583740966622.stgit@magnolia>
References: <151267250365.1350.7799938074608034424.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59938 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750929AbdLGStD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Dec 2017 13:49:03 -0500
In-Reply-To: <151267250365.1350.7799938074608034424.stgit@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable link time optimization (LTO) if the builder requests it.  The
extra link optimization results in smaller binaries.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 MCONFIG.in   |   16 +++----
 configure    |  139 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.ac |   35 +++++++++++++++
 debian/rules |    2 -
 4 files changed, 183 insertions(+), 9 deletions(-)


diff --git a/MCONFIG.in b/MCONFIG.in
index aa7d0d1..a396935 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -82,19 +82,19 @@ UDEVRULESDIR = @udevrulesdir@
 
 CC = @CC@
 BUILD_CC = @BUILD_CC@
-CFLAGS = @CFLAGS@
-CFLAGS_SHLIB = @CFLAGS_SHLIB@
-CFLAGS_STLIB = @CFLAGS_STLIB@
+CFLAGS = @lto_cflags@ @CFLAGS@
+CFLAGS_SHLIB = @lto_cflags@ @CFLAGS_SHLIB@
+CFLAGS_STLIB = @lto_cflags@ @CFLAGS_STLIB@
 CPPFLAGS = @INCLUDES@
 ALL_CFLAGS = $(CPPFLAGS) $(CFLAGS) $(CFLAGS_WARN) @DEFS@ $(LOCAL_CFLAGS)
 ALL_CFLAGS_SHLIB = $(CPPFLAGS) $(CFLAGS_SHLIB) $(CFLAGS_WARN) @DEFS@ $(LOCAL_CFLAGS)
 ALL_CFLAGS_STLIB = $(CPPFLAGS) $(CFLAGS_STLIB) $(CFLAGS_WARN) @DEFS@ $(LOCAL_CFLAGS)
-LDFLAGS = @LDFLAGS@
-LDFLAGS_SHLIB = @LDFLAGS_SHLIB@
+LDFLAGS = @lto_ldflags@ @LDFLAGS@
+LDFLAGS_SHLIB = @lto_ldflags@ @LDFLAGS_SHLIB@
 ALL_LDFLAGS = $(LDFLAGS) @LDFLAG_DYNAMIC@
-LDFLAGS_STATIC = @LDFLAGS_STATIC@
-BUILD_CFLAGS = @BUILD_CFLAGS@
-BUILD_LDFLAGS = @BUILD_LDFLAGS@
+LDFLAGS_STATIC = @lto_ldflags@ @LDFLAGS_STATIC@
+BUILD_CFLAGS = @lto_cflags@ @BUILD_CFLAGS@
+BUILD_LDFLAGS = @lto_ldflags@ @BUILD_LDFLAGS@
 RDYNAMIC = @RDYNAMIC@
 LINK_BUILD_FLAGS = @LINK_BUILD_FLAGS@
 LINK_INSTALL_FLAGS = @LINK_INSTALL_FLAGS@
diff --git a/configure b/configure
index cca0c23..26a027e 100755
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
+  --enable-lto		enable link time optimization
 
 Optional Packages:
   --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
@@ -13703,6 +13710,138 @@ $as_echo "#define HAVE_EXT2_IOCTLS 1" >>confdefs.h
 
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
+	echo "MUGGA \"${enable_lto}\" OR \"${have_lto}\""
+	as_fn_error $? "LTO not supported by compiler." "$LINENO" 5
+fi
 LINUX_CMT="#"
 CYGWIN_CMT="#"
 UNIX_CMT=
diff --git a/configure.ac b/configure.ac
index 28172bd..e44d040 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1293,6 +1293,41 @@ linux*)
 	;;
 esac
 dnl
+dnl Enable LTO for all packages
+dnl
+AC_ARG_ENABLE([lto],
+[  --enable-lto		enable link time optimization],,
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
+	echo "MUGGA \"${enable_lto}\" OR \"${have_lto}\""
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
