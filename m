From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/4] misc: enable UBSAN if the builder wants it
Date: Fri, 19 Jan 2018 22:13:03 -0800
Message-ID: <151642878322.9652.3306957963896239601.stgit@magnolia>
References: <151642877063.9652.3628059578106842868.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47600 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbeATGOA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Jan 2018 01:14:00 -0500
In-Reply-To: <151642877063.9652.3628059578106842868.stgit@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable the undefined behavior sanitizer (ubsan) if the builder requests
it and it's available.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 MCONFIG.in       |    4 ++--
 config/ltmain.sh |    1 +
 configure        |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.ac     |   28 ++++++++++++++++++++++++++++
 debian/rules     |    2 +-
 5 files changed, 84 insertions(+), 3 deletions(-)
 create mode 120000 config/ltmain.sh


diff --git a/MCONFIG.in b/MCONFIG.in
index 84de8d9..cb168a5 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -80,8 +80,8 @@ UDEVRULESDIR = @udevrulesdir@
 @ifNotGNUmake@ CHECK_CMD=true
 @ifNotGNUmake@ CPPCHECK_CMD=true
 
-SANITIZER_CFLAGS = @lto_cflags@
-SANITIZER_LDFLAGS = @lto_ldflags@
+SANITIZER_CFLAGS = @lto_cflags@ @ubsan_cflags@
+SANITIZER_LDFLAGS = @lto_ldflags@ @ubsan_ldflags@
 
 CC = @CC@
 BUILD_CC = @BUILD_CC@
diff --git a/config/ltmain.sh b/config/ltmain.sh
new file mode 120000
index 0000000..8cff389
--- /dev/null
+++ b/config/ltmain.sh
@@ -0,0 +1 @@
+/usr/share/libtool/build-aux/ltmain.sh
\ No newline at end of file
diff --git a/configure b/configure
index 181fb76..b3e8473 100755
--- a/configure
+++ b/configure
@@ -649,6 +649,9 @@ E2SCRUB_CMT
 UNIX_CMT
 CYGWIN_CMT
 LINUX_CMT
+ubsan_ldflags
+ubsan_cflags
+have_ubsan
 lto_ldflags
 lto_cflags
 have_lto
@@ -904,6 +907,7 @@ with_included_gettext
 with_libintl_prefix
 enable_fuse2fs
 enable_lto
+enable_ubsan
 with_multiarch
 '
       ac_precious_vars='build_alias
@@ -1576,6 +1580,7 @@ Optional Features:
   --disable-rpath         do not hardcode runtime library paths
   --disable-fuse2fs	  do not build fuse2fs
   --enable-lto		  enable link time optimization
+  --enable-ubsan	  enable undefined behavior sanitizer
 
 Optional Packages:
   --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
@@ -13841,6 +13846,53 @@ fi
 if test "$enable_lto" = "yes" && test "$have_lto" != "yes"; then
 	as_fn_error $? "LTO not supported by compiler." "$LINENO" 5
 fi
+# Check whether --enable-ubsan was given.
+if test "${enable_ubsan+set}" = set; then :
+  enableval=$enable_ubsan;
+else
+  enable_ubsan=no
+fi
+
+if test "$enable_ubsan" = "yes" || test "$enable_ubsan" = "probe"; then
+	{ $as_echo "$as_me:${as_lineno-$LINENO}: checking if C compiler supports UBSAN" >&5
+$as_echo_n "checking if C compiler supports UBSAN... " >&6; }
+	OLD_CFLAGS="$CFLAGS"
+	OLD_LDFLAGS="$LDFLAGS"
+	UBSAN_FLAGS="-fsanitize=undefined"
+	CFLAGS="$CFLAGS $UBSAN_FLAGS"
+	LDFLAGS="$LDFLAGS $UBSAN_FLAGS"
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
+		ubsan_cflags=$UBSAN_FLAGS
+		ubsan_ldflags=$UBSAN_FLAGS
+		have_ubsan=yes
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
+if test "$enable_ubsan" = "yes" && test "$have_ubsan" != "yes"; then
+	as_fn_error $? "UBSAN not supported by compiler." "$LINENO" 5
+fi
 LINUX_CMT="#"
 CYGWIN_CMT="#"
 UNIX_CMT=
diff --git a/configure.ac b/configure.ac
index 609207f..95a6832 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1328,6 +1328,34 @@ if test "$enable_lto" = "yes" && test "$have_lto" != "yes"; then
 	AC_MSG_ERROR([LTO not supported by compiler.])
 fi
 dnl
+dnl Enable UBSAN for all packages
+dnl
+AC_ARG_ENABLE([ubsan],
+[  --enable-ubsan	  enable undefined behavior sanitizer],,
+enable_ubsan=no)
+if test "$enable_ubsan" = "yes" || test "$enable_ubsan" = "probe"; then
+	AC_MSG_CHECKING([if C compiler supports UBSAN])
+	OLD_CFLAGS="$CFLAGS"
+	OLD_LDFLAGS="$LDFLAGS"
+	UBSAN_FLAGS="-fsanitize=undefined"
+	CFLAGS="$CFLAGS $UBSAN_FLAGS"
+	LDFLAGS="$LDFLAGS $UBSAN_FLAGS"
+	AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
+		[AC_MSG_RESULT([yes])]
+		[ubsan_cflags=$UBSAN_FLAGS]
+		[ubsan_ldflags=$UBSAN_FLAGS]
+		[have_ubsan=yes],
+		[AC_MSG_RESULT([no])])
+	CFLAGS="${OLD_CFLAGS}"
+	LDFLAGS="${OLD_LDFLAGS}"
+	AC_SUBST(have_ubsan)
+	AC_SUBST(ubsan_cflags)
+	AC_SUBST(ubsan_ldflags)
+fi
+if test "$enable_ubsan" = "yes" && test "$have_ubsan" != "yes"; then
+	AC_MSG_ERROR([UBSAN not supported by compiler.])
+fi
+dnl
 dnl OS-specific uncomment control
 dnl
 LINUX_CMT="#"
diff --git a/debian/rules b/debian/rules
index 3a22c35..5dc257f 100755
--- a/debian/rules
+++ b/debian/rules
@@ -147,7 +147,7 @@ endif
 
 BACKTRACE_CONF_FLAGS ?= $(shell if ${debdir}/scripts/test-backtrace ; then echo --disable-backtrace ; fi)
 
-COMMON_CONF_FLAGS = --enable-lto --disable-e2initrd-helper \
+COMMON_CONF_FLAGS = --enable-lto --disable-ubsan --disable-e2initrd-helper \
 	--infodir=/usr/share/info  --enable-symlink-install \
 	--with-multiarch=$(DEB_HOST_MULTIARCH) \
 	$(BACKTRACE_CONF_FLAGS) $(UTIL_CONF_FLAGS)
