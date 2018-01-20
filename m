From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/4] misc: enable gcc/clang address sanitizer if the builder
 wants it
Date: Fri, 19 Jan 2018 22:13:09 -0800
Message-ID: <151642878957.9652.12356002085847453730.stgit@magnolia>
References: <151642877063.9652.3628059578106842868.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33040 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbeATGNN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Jan 2018 01:13:13 -0500
In-Reply-To: <151642877063.9652.3628059578106842868.stgit@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable AddressSanitizer to look for memory usage errors if the builder
asks for it and it's available.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 MCONFIG.in   |    4 ++--
 configure    |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.ac |   28 ++++++++++++++++++++++++++++
 debian/rules |    3 ++-
 4 files changed, 84 insertions(+), 3 deletions(-)


diff --git a/MCONFIG.in b/MCONFIG.in
index cb168a5..3440cce 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -80,8 +80,8 @@ UDEVRULESDIR = @udevrulesdir@
 @ifNotGNUmake@ CHECK_CMD=true
 @ifNotGNUmake@ CPPCHECK_CMD=true
 
-SANITIZER_CFLAGS = @lto_cflags@ @ubsan_cflags@
-SANITIZER_LDFLAGS = @lto_ldflags@ @ubsan_ldflags@
+SANITIZER_CFLAGS = @lto_cflags@ @ubsan_cflags@ @addrsan_cflags@
+SANITIZER_LDFLAGS = @lto_ldflags@ @ubsan_ldflags@ @addrsan_ldflags@
 
 CC = @CC@
 BUILD_CC = @BUILD_CC@
diff --git a/configure b/configure
index b3e8473..1d5f907 100755
--- a/configure
+++ b/configure
@@ -649,6 +649,9 @@ E2SCRUB_CMT
 UNIX_CMT
 CYGWIN_CMT
 LINUX_CMT
+addrsan_ldflags
+addrsan_cflags
+have_addrsan
 ubsan_ldflags
 ubsan_cflags
 have_ubsan
@@ -908,6 +911,7 @@ with_libintl_prefix
 enable_fuse2fs
 enable_lto
 enable_ubsan
+enable_addrsan
 with_multiarch
 '
       ac_precious_vars='build_alias
@@ -1581,6 +1585,7 @@ Optional Features:
   --disable-fuse2fs	  do not build fuse2fs
   --enable-lto		  enable link time optimization
   --enable-ubsan	  enable undefined behavior sanitizer
+  --enable-addrsan	  enable address sanitizer
 
 Optional Packages:
   --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
@@ -13893,6 +13898,53 @@ fi
 if test "$enable_ubsan" = "yes" && test "$have_ubsan" != "yes"; then
 	as_fn_error $? "UBSAN not supported by compiler." "$LINENO" 5
 fi
+# Check whether --enable-addrsan was given.
+if test "${enable_addrsan+set}" = set; then :
+  enableval=$enable_addrsan;
+else
+  enable_addrsan=no
+fi
+
+if test "$enable_addrsan" = "yes" || test "$enable_addrsan" = "probe"; then
+	{ $as_echo "$as_me:${as_lineno-$LINENO}: checking if C compiler supports ADDRSAN" >&5
+$as_echo_n "checking if C compiler supports ADDRSAN... " >&6; }
+	OLD_CFLAGS="$CFLAGS"
+	OLD_LDFLAGS="$LDFLAGS"
+	ADDRSAN_FLAGS="-fsanitize=address"
+	CFLAGS="$CFLAGS $ADDRSAN_FLAGS"
+	LDFLAGS="$LDFLAGS $ADDRSAN_FLAGS"
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
+		addrsan_cflags=$ADDRSAN_FLAGS
+		addrsan_ldflags=$ADDRSAN_FLAGS
+		have_addrsan=yes
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
+if test "$enable_addrsan" = "yes" && test "$have_addrsan" != "yes"; then
+	as_fn_error $? "ADDRSAN not supported by compiler." "$LINENO" 5
+fi
 LINUX_CMT="#"
 CYGWIN_CMT="#"
 UNIX_CMT=
diff --git a/configure.ac b/configure.ac
index 95a6832..826a09a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1356,6 +1356,34 @@ if test "$enable_ubsan" = "yes" && test "$have_ubsan" != "yes"; then
 	AC_MSG_ERROR([UBSAN not supported by compiler.])
 fi
 dnl
+dnl Enable ADDRSAN for all packages
+dnl
+AC_ARG_ENABLE([addrsan],
+[  --enable-addrsan	  enable address sanitizer],,
+enable_addrsan=no)
+if test "$enable_addrsan" = "yes" || test "$enable_addrsan" = "probe"; then
+	AC_MSG_CHECKING([if C compiler supports ADDRSAN])
+	OLD_CFLAGS="$CFLAGS"
+	OLD_LDFLAGS="$LDFLAGS"
+	ADDRSAN_FLAGS="-fsanitize=address"
+	CFLAGS="$CFLAGS $ADDRSAN_FLAGS"
+	LDFLAGS="$LDFLAGS $ADDRSAN_FLAGS"
+	AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
+		[AC_MSG_RESULT([yes])]
+		[addrsan_cflags=$ADDRSAN_FLAGS]
+		[addrsan_ldflags=$ADDRSAN_FLAGS]
+		[have_addrsan=yes],
+		[AC_MSG_RESULT([no])])
+	CFLAGS="${OLD_CFLAGS}"
+	LDFLAGS="${OLD_LDFLAGS}"
+	AC_SUBST(have_addrsan)
+	AC_SUBST(addrsan_cflags)
+	AC_SUBST(addrsan_ldflags)
+fi
+if test "$enable_addrsan" = "yes" && test "$have_addrsan" != "yes"; then
+	AC_MSG_ERROR([ADDRSAN not supported by compiler.])
+fi
+dnl
 dnl OS-specific uncomment control
 dnl
 LINUX_CMT="#"
diff --git a/debian/rules b/debian/rules
index 5dc257f..41436f3 100755
--- a/debian/rules
+++ b/debian/rules
@@ -147,7 +147,8 @@ endif
 
 BACKTRACE_CONF_FLAGS ?= $(shell if ${debdir}/scripts/test-backtrace ; then echo --disable-backtrace ; fi)
 
-COMMON_CONF_FLAGS = --enable-lto --disable-ubsan --disable-e2initrd-helper \
+COMMON_CONF_FLAGS = --enable-lto --disable-ubsan --disable-addrsan \
+	--disable-e2initrd-helper \
 	--infodir=/usr/share/info  --enable-symlink-install \
 	--with-multiarch=$(DEB_HOST_MULTIARCH) \
 	$(BACKTRACE_CONF_FLAGS) $(UTIL_CONF_FLAGS)
