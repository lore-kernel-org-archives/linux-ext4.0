From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 20/31] e2fsprogs: Add (optional) sparse checking to the build
Date: Mon, 30 Sep 2013 18:28:50 -0700
Message-ID: <20131001012850.28415.63936.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37978 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab3JAB2y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:28:54 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Run sparse against source files when building e2fsprogs with 'make C=1'.  If
instead C=2, it configures basic ext2 types for bitwise checking with sparse,
which can help find the (many many) spots where conversion errors are
(possibly) happening.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Makefile.in             |   13 +++++++++++++
 debugfs/Makefile.in     |    1 +
 e2fsck/Makefile.in      |    1 +
 ext2ed/Makefile.in      |    1 +
 intl/Makefile.in        |    1 +
 lib/blkid/Makefile.in   |    1 +
 lib/e2p/Makefile.in     |    1 +
 lib/et/Makefile.in      |    1 +
 lib/ext2fs/Makefile.in  |    1 +
 lib/ext2fs/ext2fs.h     |   22 ++++++++++++++--------
 lib/quota/Makefile.in   |    1 +
 lib/ss/Makefile.in      |    1 +
 lib/uuid/Makefile.in    |    1 +
 misc/Makefile.in        |    1 +
 resize/Makefile.in      |    1 +
 tests/progs/Makefile.in |    1 +
 util/Makefile.in        |    1 +
 17 files changed, 42 insertions(+), 8 deletions(-)


diff --git a/Makefile.in b/Makefile.in
index 544ed02..95cbf1b 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -5,6 +5,19 @@ top_builddir = .
 my_dir = .
 INSTALL = @INSTALL@
 
+CHECK=sparse
+CHECK_OPTS=-Wsparse-all -Wno-transparent-union -Wno-return-void -Wno-undef -Wno-non-pointer-null
+ifeq ("$(C)", "2")
+  CHECK_CMD=$(CHECK) $(CHECK_OPTS) -Wbitwise -D__CHECK_ENDIAN__
+else
+  ifeq ("$(C)", "1")
+    CHECK_CMD=$(CHECK) $(CHECK_OPTS)
+   else
+    CHECK_CMD=@true
+  endif
+endif
+export CHECK_CMD
+
 @MCONFIG@
 
 % : %.sh
diff --git a/debugfs/Makefile.in b/debugfs/Makefile.in
index 9a86dc6..bf037e0 100644
--- a/debugfs/Makefile.in
+++ b/debugfs/Makefile.in
@@ -44,6 +44,7 @@ STATIC_DEPLIBS= $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBSS) \
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 
 all:: $(PROGS) $(MANPAGES)
 
diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 9c27571..6ecfcd9 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -38,6 +38,7 @@ COMPILE_ET=$(top_builddir)/lib/et/compile_et --build-tree
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 
 #
diff --git a/ext2ed/Makefile.in b/ext2ed/Makefile.in
index b3b606a..290f06e 100644
--- a/ext2ed/Makefile.in
+++ b/ext2ed/Makefile.in
@@ -33,6 +33,7 @@ DOCS=   doc/ext2ed-design.pdf doc/user-guide.pdf doc/ext2fs-overview.pdf \
 
 .c.o:
 	$(CC) -c $(ALL_CFLAGS) $< -o $@
+	$(CHECK_CMD) $(ALL_CFLAGS) $<
 
 .SUFFIXES: .sgml .ps .pdf .html
 
diff --git a/intl/Makefile.in b/intl/Makefile.in
index 9dbc84e..bf24f63 100644
--- a/intl/Makefile.in
+++ b/intl/Makefile.in
@@ -191,6 +191,7 @@ LTV_AGE=4
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(COMPILE) $<
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 
 .y.c:
 	$(YACC) $(YFLAGS) --output $@ $<
diff --git a/lib/blkid/Makefile.in b/lib/blkid/Makefile.in
index 0ec8564..3f15c67 100644
--- a/lib/blkid/Makefile.in
+++ b/lib/blkid/Makefile.in
@@ -55,6 +55,7 @@ DEPLIBS_BLKID=	$(DEPSTATIC_LIBBLKID) $(DEPSTATIC_LIBUUID)
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/e2p/Makefile.in b/lib/e2p/Makefile.in
index e2d0940..d6992fc 100644
--- a/lib/e2p/Makefile.in
+++ b/lib/e2p/Makefile.in
@@ -55,6 +55,7 @@ BSDLIB_INSTALL_DIR = $(root_libdir)
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/et/Makefile.in b/lib/et/Makefile.in
index 8d1ea26..fd4e6e2 100644
--- a/lib/et/Makefile.in
+++ b/lib/et/Makefile.in
@@ -43,6 +43,7 @@ BSDLIB_INSTALL_DIR = $(root_libdir)
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index dc7b0d1..e1e6216 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -202,6 +202,7 @@ all:: ext2fs.pc
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 847b33c..9fef6d3 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -64,14 +64,20 @@ extern "C" {
 #include <ext2fs/ext3_extents.h>
 #endif /* EXT2_FLAT_INCLUDES */
 
-typedef __u32		ext2_ino_t;
-typedef __u32		blk_t;
-typedef __u64		blk64_t;
-typedef __u32		dgrp_t;
-typedef __u32		ext2_off_t;
-typedef __u64		ext2_off64_t;
-typedef __s64		e2_blkcnt_t;
-typedef __u32		ext2_dirhash_t;
+#ifdef __CHECK_ENDIAN__
+#define __bitwise __attribute__((bitwise))
+#else
+#define __bitwise
+#endif
+
+typedef __u32 __bitwise		ext2_ino_t;
+typedef __u32 __bitwise		blk_t;
+typedef __u64 __bitwise		blk64_t;
+typedef __u32 __bitwise		dgrp_t;
+typedef __u32 __bitwise		ext2_off_t;
+typedef __u64 __bitwise		ext2_off64_t;
+typedef __s64 __bitwise		e2_blkcnt_t;
+typedef __u32 __bitwise		ext2_dirhash_t;
 
 #if EXT2_FLAT_INCLUDES
 #include "com_err.h"
diff --git a/lib/quota/Makefile.in b/lib/quota/Makefile.in
index 720befd..ec4f6c4 100644
--- a/lib/quota/Makefile.in
+++ b/lib/quota/Makefile.in
@@ -47,6 +47,7 @@ LIBDIR= quota
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 #ELF_CMT#	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/ss/Makefile.in b/lib/ss/Makefile.in
index c396f2d..1b23b38 100644
--- a/lib/ss/Makefile.in
+++ b/lib/ss/Makefile.in
@@ -34,6 +34,7 @@ MK_CMDS=_SS_DIR_OVERRIDE=. ./mk_cmds
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $<
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -DSHARED_ELF_LIB -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/uuid/Makefile.in b/lib/uuid/Makefile.in
index 7329467..14d08c1 100644
--- a/lib/uuid/Makefile.in
+++ b/lib/uuid/Makefile.in
@@ -62,6 +62,7 @@ BSDLIB_INSTALL_DIR = $(root_libdir)
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 8a69855..a798f96 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -100,6 +100,7 @@ COMPILE_ET=$(top_builddir)/lib/et/compile_et --build-tree
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 
 all:: profiled $(SPROGS) $(UPROGS) $(USPROGS) $(SMANPAGES) $(UMANPAGES) \
diff --git a/resize/Makefile.in b/resize/Makefile.in
index a06b642..b8fb3ae 100644
--- a/resize/Makefile.in
+++ b/resize/Makefile.in
@@ -38,6 +38,7 @@ DEPSTATIC_LIBS= $(STATIC_LIBE2P) $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 
 all:: $(PROGS) $(TEST_PROGS) $(MANPAGES) 
 
diff --git a/tests/progs/Makefile.in b/tests/progs/Makefile.in
index e3c1ef4..37abf23 100644
--- a/tests/progs/Makefile.in
+++ b/tests/progs/Makefile.in
@@ -27,6 +27,7 @@ DEPLIBS= $(LIBEXT2FS) $(DEPLIBSS) $(DEPLIBCOM_ERR)
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 
 all:: $(PROGS)
 
diff --git a/util/Makefile.in b/util/Makefile.in
index adf0b46..76c3f88 100644
--- a/util/Makefile.in
+++ b/util/Makefile.in
@@ -16,6 +16,7 @@ SRCS = $(srcdir)/subst.c
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(BUILD_CC) -c $(BUILD_CFLAGS) $< -o $@
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 
 PROGS=		subst symlinks
 

