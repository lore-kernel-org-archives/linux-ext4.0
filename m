From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 15/49] all: Introduce cppcheck static checking for make C=1
Date: Mon, 10 Mar 2014 23:55:34 -0700
Message-ID: <20140311065534.30585.64998.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32428 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaCKGzi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:55:38 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Introduce more static checking via cppcheck.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 MCONFIG.in              |    6 ++++++
 debugfs/Makefile.in     |    1 +
 e2fsck/Makefile.in      |    1 +
 ext2ed/Makefile.in      |    1 +
 intl/Makefile.in        |    7 +++++++
 lib/blkid/Makefile.in   |    1 +
 lib/e2p/Makefile.in     |    1 +
 lib/et/Makefile.in      |    1 +
 lib/ext2fs/Makefile.in  |    1 +
 lib/quota/Makefile.in   |    1 +
 lib/ss/Makefile.in      |    1 +
 lib/uuid/Makefile.in    |    1 +
 misc/Makefile.in        |    1 +
 resize/Makefile.in      |    1 +
 tests/progs/Makefile.in |    1 +
 util/Makefile.in        |    1 +
 16 files changed, 27 insertions(+)


diff --git a/MCONFIG.in b/MCONFIG.in
index 5ed4df0..9b411d6 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -52,17 +52,23 @@ datadir = @datadir@
 
 @ifGNUmake@ CHECK=sparse
 @ifGNUmake@ CHECK_OPTS=-Wsparse-all -Wno-transparent-union -Wno-return-void -Wno-undef -Wno-non-pointer-null
+@ifGNUmake@ CPPCHECK=cppcheck
+@ifGNUmake@ CPPCHECK_OPTS=--force --enable=all
 @ifGNUmake@ ifeq ("$(C)", "2")
 @ifGNUmake@   CHECK_CMD=$(CHECK) $(CHECK_OPTS) -Wbitwise -D__CHECK_ENDIAN__
+@ifGNUmake@   CPPCHECK_CMD=$(CPPCHECK) $(CPPCHECK_OPTS)
 @ifGNUmake@ else
 @ifGNUmake@   ifeq ("$(C)", "1")
 @ifGNUmake@     CHECK_CMD=$(CHECK) $(CHECK_OPTS)
+@ifGNUmake@     CPPCHECK_CMD=$(CPPCHECK) $(CPPCHECK_OPTS)
 @ifGNUmake@    else
 @ifGNUmake@     CHECK_CMD=@true
+@ifGNUmake@     CPPCHECK_CMD=@true
 @ifGNUmake@   endif
 @ifGNUmake@ endif
 
 @ifNotGNUmake@ CHECK_CMD=@true
+@ifNotGNUmake@ CPPHECK_CMD=@true
 
 CC = @CC@
 BUILD_CC = @BUILD_CC@
diff --git a/debugfs/Makefile.in b/debugfs/Makefile.in
index 16d6aa7..34cdac1 100644
--- a/debugfs/Makefile.in
+++ b/debugfs/Makefile.in
@@ -46,6 +46,7 @@ STATIC_DEPLIBS= $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBSS) \
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
+	$(Q) $(CPPCHECK_CMD) $<
 
 all:: $(PROGS) $(MANPAGES)
 
diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index c23f1cb..5c8ce39 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -40,6 +40,7 @@ COMPILE_ET=$(top_builddir)/lib/et/compile_et --build-tree
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
+	$(Q) $(CPPCHECK_CMD) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 
 #
diff --git a/ext2ed/Makefile.in b/ext2ed/Makefile.in
index 5f4cc69..f05a562 100644
--- a/ext2ed/Makefile.in
+++ b/ext2ed/Makefile.in
@@ -34,6 +34,7 @@ DOCS=   doc/ext2ed-design.pdf doc/user-guide.pdf doc/ext2fs-overview.pdf \
 .c.o:
 	$(CC) -c $(ALL_CFLAGS) $< -o $@
 	$(CHECK_CMD) $(ALL_CFLAGS) $<
+	$(CPPCHECK_CMD) $<
 
 .SUFFIXES: .sgml .ps .pdf .html
 
diff --git a/intl/Makefile.in b/intl/Makefile.in
index 87d081f..07700c8 100644
--- a/intl/Makefile.in
+++ b/intl/Makefile.in
@@ -61,17 +61,23 @@ mkinstalldirs = $(SHELL) $(MKINSTALLDIRS)
 
 @ifGNUmake@ CHECK=sparse
 @ifGNUmake@ CHECK_OPTS=-Wsparse-all -Wno-transparent-union -Wno-return-void -Wno-undef -Wno-non-pointer-null
+@ifGNUmake@ CPPCHECK=cppcheck
+@ifGNUmake@ CPPCHECK_OPTS=--force --enable=all
 @ifGNUmake@ ifeq ("$(C)", "2")
 @ifGNUmake@   CHECK_CMD=$(CHECK) $(CHECK_OPTS) -Wbitwise -D__CHECK_ENDIAN__
+@ifGNUmake@   CPPCHECK_CMD=$(CPPCHECK) $(CPPCHECK_OPTS)
 @ifGNUmake@ else
 @ifGNUmake@   ifeq ("$(C)", "1")
 @ifGNUmake@     CHECK_CMD=$(CHECK) $(CHECK_OPTS)
+@ifGNUmake@     CPPCHECK_CMD=$(CPPCHECK) $(CPPCHECK_OPTS)
 @ifGNUmake@    else
 @ifGNUmake@     CHECK_CMD=@true
+@ifGNUmake@     CPPCHECK_CMD=@true
 @ifGNUmake@   endif
 @ifGNUmake@ endif
 
 @ifNotGNUmake@ CHECK_CMD=@true
+@ifNotGNUmake@ CPPCHECK_CMD=@true
 
 l = @INTL_LIBTOOL_SUFFIX_PREFIX@
 
@@ -206,6 +212,7 @@ LTV_AGE=4
 	$(E) "	CC $<"
 	$(Q) $(COMPILE) $<
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
+	$(Q) $(CPPCHECK_CMD) $<
 
 .y.c:
 	$(YACC) $(YFLAGS) --output $@ $<
diff --git a/lib/blkid/Makefile.in b/lib/blkid/Makefile.in
index faed6f1..69b5b4c 100644
--- a/lib/blkid/Makefile.in
+++ b/lib/blkid/Makefile.in
@@ -56,6 +56,7 @@ DEPLIBS_BLKID=	$(DEPSTATIC_LIBBLKID) $(DEPSTATIC_LIBUUID)
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
+	$(Q) $(CPPCHECK_CMD) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/e2p/Makefile.in b/lib/e2p/Makefile.in
index d6992fc..761ac48 100644
--- a/lib/e2p/Makefile.in
+++ b/lib/e2p/Makefile.in
@@ -56,6 +56,7 @@ BSDLIB_INSTALL_DIR = $(root_libdir)
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
+	$(Q) $(CPPCHECK_CMD) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/et/Makefile.in b/lib/et/Makefile.in
index ff99f5d..4f2d31f 100644
--- a/lib/et/Makefile.in
+++ b/lib/et/Makefile.in
@@ -44,6 +44,7 @@ BSDLIB_INSTALL_DIR = $(root_libdir)
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
+	$(Q) $(CPPCHECK_CMD) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 7777cb1..0c880c7 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -205,6 +205,7 @@ all:: ext2fs.pc
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
+	$(Q) $(CPPCHECK_CMD) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/quota/Makefile.in b/lib/quota/Makefile.in
index e423356..0344d09 100644
--- a/lib/quota/Makefile.in
+++ b/lib/quota/Makefile.in
@@ -48,6 +48,7 @@ LIBDIR= quota
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
+	$(Q) $(CPPCHECK_CMD) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 #ELF_CMT#	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/ss/Makefile.in b/lib/ss/Makefile.in
index 28bcfd5..4c1ef8f 100644
--- a/lib/ss/Makefile.in
+++ b/lib/ss/Makefile.in
@@ -35,6 +35,7 @@ MK_CMDS=_SS_DIR_OVERRIDE=. ./mk_cmds
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $<
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
+	$(Q) $(CPPCHECK_CMD) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -DSHARED_ELF_LIB -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/uuid/Makefile.in b/lib/uuid/Makefile.in
index 14d08c1..f5b767e 100644
--- a/lib/uuid/Makefile.in
+++ b/lib/uuid/Makefile.in
@@ -63,6 +63,7 @@ BSDLIB_INSTALL_DIR = $(root_libdir)
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
+	$(Q) $(CPPCHECK_CMD) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/misc/Makefile.in b/misc/Makefile.in
index e061867..18a8a2f 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -103,6 +103,7 @@ COMPILE_ET=$(top_builddir)/lib/et/compile_et --build-tree
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
+	$(Q) $(CPPCHECK_CMD) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 
 all:: profiled $(SPROGS) $(UPROGS) $(USPROGS) $(SMANPAGES) $(UMANPAGES) \
diff --git a/resize/Makefile.in b/resize/Makefile.in
index f7b80ef..16f2a95 100644
--- a/resize/Makefile.in
+++ b/resize/Makefile.in
@@ -39,6 +39,7 @@ DEPSTATIC_LIBS= $(STATIC_LIBE2P) $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
+	$(Q) $(CPPCHECK_CMD) $<
 
 all:: $(PROGS) $(TEST_PROGS) $(MANPAGES) 
 
diff --git a/tests/progs/Makefile.in b/tests/progs/Makefile.in
index 44d04b5..6c986e4 100644
--- a/tests/progs/Makefile.in
+++ b/tests/progs/Makefile.in
@@ -28,6 +28,7 @@ DEPLIBS= $(LIBEXT2FS) $(DEPLIBSS) $(DEPLIBCOM_ERR)
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
+	$(Q) $(CPPCHECK_CMD) $<
 
 all:: $(PROGS)
 
diff --git a/util/Makefile.in b/util/Makefile.in
index d235fff..2375e17 100644
--- a/util/Makefile.in
+++ b/util/Makefile.in
@@ -17,6 +17,7 @@ SRCS = $(srcdir)/subst.c
 	$(E) "	CC $<"
 	$(Q) $(BUILD_CC) -c $(BUILD_CFLAGS) $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
+	$(Q) $(CPPCHECK_CMD) $<
 
 PROGS=		subst symlinks
 

