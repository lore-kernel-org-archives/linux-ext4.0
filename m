From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/4] misc: enable thread sanitizer if the builder wants it
Date: Fri, 19 Jan 2018 22:13:15 -0800
Message-ID: <151642879586.9652.2681042788789696355.stgit@magnolia>
References: <151642877063.9652.3628059578106842868.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47638 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbeATGOC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Jan 2018 01:14:02 -0500
In-Reply-To: <151642877063.9652.3628059578106842868.stgit@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable the gcc/clang thread data corruption sanitizer if the builder
requests it and it's available.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 MCONFIG.in   |    4 ++--
 configure    |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.ac |   31 +++++++++++++++++++++++++++++++
 debian/rules |    2 +-
 4 files changed, 90 insertions(+), 3 deletions(-)


diff --git a/MCONFIG.in b/MCONFIG.in
index 3440cce..6355b49 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -80,8 +80,8 @@ UDEVRULESDIR = @udevrulesdir@
 @ifNotGNUmake@ CHECK_CMD=true
 @ifNotGNUmake@ CPPCHECK_CMD=true
 
-SANITIZER_CFLAGS = @lto_cflags@ @ubsan_cflags@ @addrsan_cflags@
-SANITIZER_LDFLAGS = @lto_ldflags@ @ubsan_ldflags@ @addrsan_ldflags@
+SANITIZER_CFLAGS = @lto_cflags@ @ubsan_cflags@ @addrsan_cflags@ @threadsan_cflags@
+SANITIZER_LDFLAGS = @lto_ldflags@ @ubsan_ldflags@ @addrsan_ldflags@ @threadsan_ldflags@
 
 CC = @CC@
 BUILD_CC = @BUILD_CC@
diff --git a/configure b/configure
index 1d5f907..045434a 100755
--- a/configure
+++ b/configure
@@ -649,6 +649,9 @@ E2SCRUB_CMT
 UNIX_CMT
 CYGWIN_CMT
 LINUX_CMT
+threadsan_ldflags
+threadsan_cflags
+have_threadsan
 addrsan_ldflags
 addrsan_cflags
 have_addrsan
@@ -912,6 +915,7 @@ enable_fuse2fs
 enable_lto
 enable_ubsan
 enable_addrsan
+enable_threadsan
 with_multiarch
 '
       ac_precious_vars='build_alias
@@ -1586,6 +1590,7 @@ Optional Features:
   --enable-lto		  enable link time optimization
   --enable-ubsan	  enable undefined behavior sanitizer
   --enable-addrsan	  enable address sanitizer
+  --enable-threadsan	  enable thread sanitizer
 
 Optional Packages:
   --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
@@ -13945,6 +13950,57 @@ fi
 if test "$enable_addrsan" = "yes" && test "$have_addrsan" != "yes"; then
 	as_fn_error $? "ADDRSAN not supported by compiler." "$LINENO" 5
 fi
+# Check whether --enable-threadsan was given.
+if test "${enable_threadsan+set}" = set; then :
+  enableval=$enable_threadsan;
+else
+  enable_threadsan=no
+fi
+
+if test "$enable_threadsan" = "yes" || test "$enable_threadsan" = "probe"; then
+	{ $as_echo "$as_me:${as_lineno-$LINENO}: checking if C compiler supports THREADSAN" >&5
+$as_echo_n "checking if C compiler supports THREADSAN... " >&6; }
+	OLD_CFLAGS="$CFLAGS"
+	OLD_LDFLAGS="$LDFLAGS"
+	THREADSAN_FLAGS="-fsanitize=thread"
+	CFLAGS="$CFLAGS $THREADSAN_FLAGS"
+	LDFLAGS="$LDFLAGS $THREADSAN_FLAGS"
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
+		threadsan_cflags=$THREADSAN_FLAGS
+		threadsan_ldflags=$THREADSAN_FLAGS
+		have_threadsan=yes
+else
+  { $as_echo "$as_me:${as_lineno-$LINENO}: result: no" >&5
+$as_echo "no" >&6; }
+fi
+rm -f core conftest.err conftest.$ac_objext \
+    conftest$ac_exeext conftest.$ac_ext
+	CFLAGS="${OLD_CFLAGS}"
+	LDFLAGS="${OLD_LDFLAGS}"
+
+
+
+fi
+if test "$enable_threadsan" = "yes" && test "$have_threadsan" != "yes"; then
+	as_fn_error $? "THREADSAN not supported by compiler." "$LINENO" 5
+fi
+if test "$have_threadsan" = "yes" && test "$have_addrsan" = "yes"; then
+	{ $as_echo "$as_me:${as_lineno-$LINENO}: WARNING: ADDRSAN and THREADSAN are not known to work together." >&5
+$as_echo "$as_me: WARNING: ADDRSAN and THREADSAN are not known to work together." >&2;}
+fi
 LINUX_CMT="#"
 CYGWIN_CMT="#"
 UNIX_CMT=
diff --git a/configure.ac b/configure.ac
index 826a09a..a13ca05 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1384,6 +1384,37 @@ if test "$enable_addrsan" = "yes" && test "$have_addrsan" != "yes"; then
 	AC_MSG_ERROR([ADDRSAN not supported by compiler.])
 fi
 dnl
+dnl Enable THREADSAN for all packages
+dnl
+AC_ARG_ENABLE([threadsan],
+[  --enable-threadsan	  enable thread sanitizer],,
+enable_threadsan=no)
+if test "$enable_threadsan" = "yes" || test "$enable_threadsan" = "probe"; then
+	AC_MSG_CHECKING([if C compiler supports THREADSAN])
+	OLD_CFLAGS="$CFLAGS"
+	OLD_LDFLAGS="$LDFLAGS"
+	THREADSAN_FLAGS="-fsanitize=thread"
+	CFLAGS="$CFLAGS $THREADSAN_FLAGS"
+	LDFLAGS="$LDFLAGS $THREADSAN_FLAGS"
+	AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
+		[AC_MSG_RESULT([yes])]
+		[threadsan_cflags=$THREADSAN_FLAGS]
+		[threadsan_ldflags=$THREADSAN_FLAGS]
+		[have_threadsan=yes],
+		[AC_MSG_RESULT([no])])
+	CFLAGS="${OLD_CFLAGS}"
+	LDFLAGS="${OLD_LDFLAGS}"
+	AC_SUBST(have_threadsan)
+	AC_SUBST(threadsan_cflags)
+	AC_SUBST(threadsan_ldflags)
+fi
+if test "$enable_threadsan" = "yes" && test "$have_threadsan" != "yes"; then
+	AC_MSG_ERROR([THREADSAN not supported by compiler.])
+fi
+if test "$have_threadsan" = "yes" && test "$have_addrsan" = "yes"; then
+	AC_MSG_WARN([ADDRSAN and THREADSAN are not known to work together.])
+fi
+dnl
 dnl OS-specific uncomment control
 dnl
 LINUX_CMT="#"
diff --git a/debian/rules b/debian/rules
index 41436f3..8384804 100755
--- a/debian/rules
+++ b/debian/rules
@@ -148,7 +148,7 @@ endif
 BACKTRACE_CONF_FLAGS ?= $(shell if ${debdir}/scripts/test-backtrace ; then echo --disable-backtrace ; fi)
 
 COMMON_CONF_FLAGS = --enable-lto --disable-ubsan --disable-addrsan \
-	--disable-e2initrd-helper \
+	--disable-threadsan --disable-e2initrd-helper \
 	--infodir=/usr/share/info  --enable-symlink-install \
 	--with-multiarch=$(DEB_HOST_MULTIARCH) \
 	$(BACKTRACE_CONF_FLAGS) $(UTIL_CONF_FLAGS)
