From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/37] misc: create better-packaged static analysis reports
Date: Thu, 01 May 2014 16:12:29 -0700
Message-ID: <20140501231229.31890.25646.stgit@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28022 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaEAXMf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:12:35 -0400
In-Reply-To: <20140501231222.31890.82860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix some minor bugs relating to passing CFLAGS to cppcheck, and
package the cppcheck output into nicer looking reports.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 MCONFIG.in                   |   17 ++++++++++++-----
 debugfs/Makefile.in          |    2 +-
 e2fsck/Makefile.in           |    2 +-
 ext2ed/Makefile.in           |    2 +-
 intl/Makefile.in             |    4 ++--
 lib/blkid/Makefile.in        |    2 +-
 lib/e2p/Makefile.in          |    2 +-
 lib/et/Makefile.in           |    2 +-
 lib/ext2fs/Makefile.in       |    2 +-
 lib/quota/Makefile.in        |    2 +-
 lib/ss/Makefile.in           |    2 +-
 lib/uuid/Makefile.in         |    2 +-
 misc/Makefile.in             |    2 +-
 resize/Makefile.in           |    2 +-
 tests/progs/Makefile.in      |    2 +-
 util/Makefile.in             |    2 +-
 util/static-analysis-cleanup |   20 ++++++++++++++++++++
 17 files changed, 48 insertions(+), 21 deletions(-)
 create mode 100644 util/static-analysis-cleanup


diff --git a/MCONFIG.in b/MCONFIG.in
index 9b411d6..7e520be 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -53,7 +53,7 @@ datadir = @datadir@
 @ifGNUmake@ CHECK=sparse
 @ifGNUmake@ CHECK_OPTS=-Wsparse-all -Wno-transparent-union -Wno-return-void -Wno-undef -Wno-non-pointer-null
 @ifGNUmake@ CPPCHECK=cppcheck
-@ifGNUmake@ CPPCHECK_OPTS=--force --enable=all
+@ifGNUmake@ CPPCHECK_OPTS=--force --enable=all --quiet
 @ifGNUmake@ ifeq ("$(C)", "2")
 @ifGNUmake@   CHECK_CMD=$(CHECK) $(CHECK_OPTS) -Wbitwise -D__CHECK_ENDIAN__
 @ifGNUmake@   CPPCHECK_CMD=$(CPPCHECK) $(CPPCHECK_OPTS)
@@ -183,7 +183,7 @@ DEP_INSTALL_SYMLINK = $(top_builddir)/util/install-symlink \
 # Run make gcc-wall to do a build with warning messages.
 #
 #
-WFLAGS=		-std=c99 -D_XOPEN_SOURCE=600 -D_GNU_SOURCE \
+WFLAGS=		-std=gnu99 -D_XOPEN_SOURCE=600 -D_GNU_SOURCE \
 			-pedantic $(WFLAGS_EXTRA) \
 			-Wall -W -Wwrite-strings -Wpointer-arith \
 			-Wcast-qual -Wcast-align -Wno-variadic-macros \
@@ -194,11 +194,18 @@ WFLAGS=		-std=c99 -D_XOPEN_SOURCE=600 -D_GNU_SOURCE \
 			-UENABLE_NLS
 
 gcc-wall-new:
-	(make CFLAGS="@CFLAGS@ $(WFLAGS)" > /dev/null) 2>&1 | sed -f $(top_srcdir)/util/gcc-wall-cleanup 
+	($(MAKE) CFLAGS="@CFLAGS@ $(WFLAGS)" > /dev/null) 2>&1 | sed -f $(top_srcdir)/util/gcc-wall-cleanup
 
 gcc-wall:
-	make clean > /dev/null
-	make gcc-wall-new
+	$(MAKE) clean > /dev/null
+	$(MAKE) gcc-wall-new
+
+static-check:
+	($(MAKE) C=1 V=1 CFLAGS="@CFLAGS@ $(WFLAGS)") 2>&1 | sed -f $(top_srcdir)/util/static-analysis-cleanup
+
+static-check-all:
+	$(MAKE) clean > /dev/null
+	$(MAKE) static-check
 
 #
 # Installation user and groups
diff --git a/debugfs/Makefile.in b/debugfs/Makefile.in
index 34cdac1..5097749 100644
--- a/debugfs/Makefile.in
+++ b/debugfs/Makefile.in
@@ -46,7 +46,7 @@ STATIC_DEPLIBS= $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBSS) \
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
-	$(Q) $(CPPCHECK_CMD) $<
+	$(Q) $(CPPCHECK_CMD) $(CPPFLAGS) $<
 
 all:: $(PROGS) $(MANPAGES)
 
diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 5c8ce39..5a6883a 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -40,7 +40,7 @@ COMPILE_ET=$(top_builddir)/lib/et/compile_et --build-tree
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
-	$(Q) $(CPPCHECK_CMD) $<
+	$(Q) $(CPPCHECK_CMD) $(CPPFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 
 #
diff --git a/ext2ed/Makefile.in b/ext2ed/Makefile.in
index f05a562..0697431 100644
--- a/ext2ed/Makefile.in
+++ b/ext2ed/Makefile.in
@@ -34,7 +34,7 @@ DOCS=   doc/ext2ed-design.pdf doc/user-guide.pdf doc/ext2fs-overview.pdf \
 .c.o:
 	$(CC) -c $(ALL_CFLAGS) $< -o $@
 	$(CHECK_CMD) $(ALL_CFLAGS) $<
-	$(CPPCHECK_CMD) $<
+	$(CPPCHECK_CMD) $(CPPFLAGS) $<
 
 .SUFFIXES: .sgml .ps .pdf .html
 
diff --git a/intl/Makefile.in b/intl/Makefile.in
index 07700c8..db6d7d7 100644
--- a/intl/Makefile.in
+++ b/intl/Makefile.in
@@ -62,7 +62,7 @@ mkinstalldirs = $(SHELL) $(MKINSTALLDIRS)
 @ifGNUmake@ CHECK=sparse
 @ifGNUmake@ CHECK_OPTS=-Wsparse-all -Wno-transparent-union -Wno-return-void -Wno-undef -Wno-non-pointer-null
 @ifGNUmake@ CPPCHECK=cppcheck
-@ifGNUmake@ CPPCHECK_OPTS=--force --enable=all
+@ifGNUmake@ CPPCHECK_OPTS=--force --enable=all --quiet --check-config
 @ifGNUmake@ ifeq ("$(C)", "2")
 @ifGNUmake@   CHECK_CMD=$(CHECK) $(CHECK_OPTS) -Wbitwise -D__CHECK_ENDIAN__
 @ifGNUmake@   CPPCHECK_CMD=$(CPPCHECK) $(CPPCHECK_OPTS)
@@ -212,7 +212,7 @@ LTV_AGE=4
 	$(E) "	CC $<"
 	$(Q) $(COMPILE) $<
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
-	$(Q) $(CPPCHECK_CMD) $<
+	$(Q) $(CPPCHECK_CMD) $(CPPFLAGS) $<
 
 .y.c:
 	$(YACC) $(YFLAGS) --output $@ $<
diff --git a/lib/blkid/Makefile.in b/lib/blkid/Makefile.in
index 69b5b4c..ecd0e8f 100644
--- a/lib/blkid/Makefile.in
+++ b/lib/blkid/Makefile.in
@@ -56,7 +56,7 @@ DEPLIBS_BLKID=	$(DEPSTATIC_LIBBLKID) $(DEPSTATIC_LIBUUID)
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
-	$(Q) $(CPPCHECK_CMD) $<
+	$(Q) $(CPPCHECK_CMD) $(CPPFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/e2p/Makefile.in b/lib/e2p/Makefile.in
index 761ac48..60920dd 100644
--- a/lib/e2p/Makefile.in
+++ b/lib/e2p/Makefile.in
@@ -56,7 +56,7 @@ BSDLIB_INSTALL_DIR = $(root_libdir)
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
-	$(Q) $(CPPCHECK_CMD) $<
+	$(Q) $(CPPCHECK_CMD) $(CPPFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/et/Makefile.in b/lib/et/Makefile.in
index 4f2d31f..db2e056 100644
--- a/lib/et/Makefile.in
+++ b/lib/et/Makefile.in
@@ -44,7 +44,7 @@ BSDLIB_INSTALL_DIR = $(root_libdir)
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
-	$(Q) $(CPPCHECK_CMD) $<
+	$(Q) $(CPPCHECK_CMD) $(CPPFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 0c880c7..f287a57 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -205,7 +205,7 @@ all:: ext2fs.pc
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
-	$(Q) $(CPPCHECK_CMD) $<
+	$(Q) $(CPPCHECK_CMD) $(CPPFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/quota/Makefile.in b/lib/quota/Makefile.in
index 0344d09..aa513a0 100644
--- a/lib/quota/Makefile.in
+++ b/lib/quota/Makefile.in
@@ -48,7 +48,7 @@ LIBDIR= quota
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
-	$(Q) $(CPPCHECK_CMD) $<
+	$(Q) $(CPPCHECK_CMD) $(CPPFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 #ELF_CMT#	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/ss/Makefile.in b/lib/ss/Makefile.in
index 4c1ef8f..a94de79 100644
--- a/lib/ss/Makefile.in
+++ b/lib/ss/Makefile.in
@@ -35,7 +35,7 @@ MK_CMDS=_SS_DIR_OVERRIDE=. ./mk_cmds
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $<
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
-	$(Q) $(CPPCHECK_CMD) $<
+	$(Q) $(CPPCHECK_CMD) $(CPPFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -DSHARED_ELF_LIB -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/uuid/Makefile.in b/lib/uuid/Makefile.in
index f5b767e..f436b36 100644
--- a/lib/uuid/Makefile.in
+++ b/lib/uuid/Makefile.in
@@ -63,7 +63,7 @@ BSDLIB_INSTALL_DIR = $(root_libdir)
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
-	$(Q) $(CPPCHECK_CMD) $<
+	$(Q) $(CPPCHECK_CMD) $(CPPFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 18a8a2f..7bd9b5f 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -103,7 +103,7 @@ COMPILE_ET=$(top_builddir)/lib/et/compile_et --build-tree
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
-	$(Q) $(CPPCHECK_CMD) $<
+	$(Q) $(CPPCHECK_CMD) $(CPPFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 
 all:: profiled $(SPROGS) $(UPROGS) $(USPROGS) $(SMANPAGES) $(UMANPAGES) \
diff --git a/resize/Makefile.in b/resize/Makefile.in
index 16f2a95..201e268 100644
--- a/resize/Makefile.in
+++ b/resize/Makefile.in
@@ -39,7 +39,7 @@ DEPSTATIC_LIBS= $(STATIC_LIBE2P) $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
-	$(Q) $(CPPCHECK_CMD) $<
+	$(Q) $(CPPCHECK_CMD) $(CPPFLAGS) $<
 
 all:: $(PROGS) $(TEST_PROGS) $(MANPAGES) 
 
diff --git a/tests/progs/Makefile.in b/tests/progs/Makefile.in
index 6c986e4..22d9417 100644
--- a/tests/progs/Makefile.in
+++ b/tests/progs/Makefile.in
@@ -28,7 +28,7 @@ DEPLIBS= $(LIBEXT2FS) $(DEPLIBSS) $(DEPLIBCOM_ERR)
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
-	$(Q) $(CPPCHECK_CMD) $<
+	$(Q) $(CPPCHECK_CMD) $(CPPFLAGS) $<
 
 all:: $(PROGS)
 
diff --git a/util/Makefile.in b/util/Makefile.in
index 2375e17..5171c1c 100644
--- a/util/Makefile.in
+++ b/util/Makefile.in
@@ -17,7 +17,7 @@ SRCS = $(srcdir)/subst.c
 	$(E) "	CC $<"
 	$(Q) $(BUILD_CC) -c $(BUILD_CFLAGS) $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
-	$(Q) $(CPPCHECK_CMD) $<
+	$(Q) $(CPPCHECK_CMD) $(CPPFLAGS) $<
 
 PROGS=		subst symlinks
 
diff --git a/util/static-analysis-cleanup b/util/static-analysis-cleanup
new file mode 100644
index 0000000..6749259
--- /dev/null
+++ b/util/static-analysis-cleanup
@@ -0,0 +1,20 @@
+#!/bin/sed -f
+#
+# This script filters out gcc-wall crud that we're not interested in seeing.
+#
+/^cc /d
+/^kcc /d
+/^gcc /d
+/does not support `long long'/d
+/forbids long long integer constants/d
+/does not support the `ll' length modifier/d
+/does not support the `ll' printf length modifier/d
+/ANSI C forbids long long integer constants/d
+/traditional C rejects string concatenation/d
+/integer constant is unsigned in ANSI C, signed with -traditional/d
+/warning: missing initializer/d
+/warning: (near initialization for/d
+/^[ 	]*from/d
+/unused parameter/d
+/e2_types.h" not found.$/d
+/e2_bitops.h" not found.$/d

