From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/6] e2fsprogs: Add (optional) sparse checking to the build
Date: Wed, 28 Aug 2013 17:44:10 -0700
Message-ID: <20130829004410.3190.37124.stgit@blackbox.djwong.org>
References: <20130829004344.3190.28053.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29204 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab3H2AoS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Aug 2013 20:44:18 -0400
In-Reply-To: <20130829004344.3190.28053.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Run sparse against source files when building e2fsprogs with 'make C=1'.  If
instead C=2, it configures basic ext2 types for bitwise checking with sparse,
which can help find the (many many) spots where conversion errors are
(possibly) happening.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Makefile.in             |   13 +++++++++++++
 debugfs/Makefile.in     |    2 ++
 e2fsck/Makefile.in      |    3 +++
 e2fsck/pass1.c          |    2 +-
 ext2ed/Makefile.in      |    1 +
 intl/Makefile.in        |    2 ++
 lib/blkid/Makefile.in   |    2 ++
 lib/e2p/Makefile.in     |    2 ++
 lib/et/Makefile.in      |    2 ++
 lib/ext2fs/Makefile.in  |    2 ++
 lib/ext2fs/ext2fs.h     |   22 ++++++++++++++--------
 lib/quota/Makefile.in   |    2 ++
 lib/ss/Makefile.in      |    2 ++
 lib/uuid/Makefile.in    |    2 ++
 misc/Makefile.in        |    2 ++
 resize/Makefile.in      |    2 ++
 tests/progs/Makefile.in |    2 ++
 util/Makefile.in        |    2 ++
 18 files changed, 58 insertions(+), 9 deletions(-)


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
index 9a86dc6..afde5ac 100644
--- a/debugfs/Makefile.in
+++ b/debugfs/Makefile.in
@@ -44,6 +44,8 @@ STATIC_DEPLIBS= $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBSS) \
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
+	$(E) "	SPARSE $<"
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 
 all:: $(PROGS) $(MANPAGES)
 
diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 9c27571..a900b9b 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -34,10 +34,13 @@ PROFILED_DEPLIBS= $(DEPPROFILED_LIBQUOTA) $(PROFILED_LIBEXT2FS) \
 		  $(DEPPROFILED_LIBUUID) $(DEPPROFILED_LIBE2P)
 
 COMPILE_ET=$(top_builddir)/lib/et/compile_et --build-tree
+CHECK=sparse
 
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
+	$(E) "	SPARSE $<"
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 
 #
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index ba6025b..89a7c20 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2674,7 +2674,7 @@ static int process_bad_block(ext2_filsys fs,
 	return 0;
 }
 
-static void new_table_block(e2fsck_t ctx, blk_t first_block, int group,
+static void new_table_block(e2fsck_t ctx, blk64_t first_block, int group,
 			    const char *name, int num, blk64_t *new_block)
 {
 	ext2_filsys fs = ctx->fs;
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
index 9dbc84e..6555331 100644
--- a/intl/Makefile.in
+++ b/intl/Makefile.in
@@ -191,6 +191,8 @@ LTV_AGE=4
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(COMPILE) $<
+	$(E) "	SPARSE $<"
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 
 .y.c:
 	$(YACC) $(YFLAGS) --output $@ $<
diff --git a/lib/blkid/Makefile.in b/lib/blkid/Makefile.in
index 0ec8564..ec393fe 100644
--- a/lib/blkid/Makefile.in
+++ b/lib/blkid/Makefile.in
@@ -55,6 +55,8 @@ DEPLIBS_BLKID=	$(DEPSTATIC_LIBBLKID) $(DEPSTATIC_LIBUUID)
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+	$(E) "	SPARSE $<"
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/e2p/Makefile.in b/lib/e2p/Makefile.in
index e2d0940..1360155 100644
--- a/lib/e2p/Makefile.in
+++ b/lib/e2p/Makefile.in
@@ -55,6 +55,8 @@ BSDLIB_INSTALL_DIR = $(root_libdir)
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+	$(E) "	SPARSE $<"
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/et/Makefile.in b/lib/et/Makefile.in
index 8d1ea26..9a16c80 100644
--- a/lib/et/Makefile.in
+++ b/lib/et/Makefile.in
@@ -43,6 +43,8 @@ BSDLIB_INSTALL_DIR = $(root_libdir)
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+	$(E) "	SPARSE $<"
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index dc7b0d1..d142cf3 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -202,6 +202,8 @@ all:: ext2fs.pc
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+	$(E) "	SPARSE $<"
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 311ceda..b078ec9 100644
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
index 720befd..7ea5100 100644
--- a/lib/quota/Makefile.in
+++ b/lib/quota/Makefile.in
@@ -47,6 +47,8 @@ LIBDIR= quota
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+	$(E) "	SPARSE $<"
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 #ELF_CMT#	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/ss/Makefile.in b/lib/ss/Makefile.in
index c396f2d..95834fc 100644
--- a/lib/ss/Makefile.in
+++ b/lib/ss/Makefile.in
@@ -34,6 +34,8 @@ MK_CMDS=_SS_DIR_OVERRIDE=. ./mk_cmds
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $<
+	$(E) "	SPARSE $<"
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -DSHARED_ELF_LIB -fPIC -o elfshared/$*.o -c $<
diff --git a/lib/uuid/Makefile.in b/lib/uuid/Makefile.in
index 7329467..1d350ee 100644
--- a/lib/uuid/Makefile.in
+++ b/lib/uuid/Makefile.in
@@ -62,6 +62,8 @@ BSDLIB_INSTALL_DIR = $(root_libdir)
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+	$(E) "	SPARSE $<"
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 @CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 8a69855..cae1b9f 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -100,6 +100,8 @@ COMPILE_ET=$(top_builddir)/lib/et/compile_et --build-tree
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
+	$(E) "	SPARSE $<"
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 
 all:: profiled $(SPROGS) $(UPROGS) $(USPROGS) $(SMANPAGES) $(UMANPAGES) \
diff --git a/resize/Makefile.in b/resize/Makefile.in
index a06b642..e7ea302 100644
--- a/resize/Makefile.in
+++ b/resize/Makefile.in
@@ -38,6 +38,8 @@ DEPSTATIC_LIBS= $(STATIC_LIBE2P) $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
+	$(E) "	SPARSE $<"
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 
 all:: $(PROGS) $(TEST_PROGS) $(MANPAGES) 
 
diff --git a/tests/progs/Makefile.in b/tests/progs/Makefile.in
index e3c1ef4..6508520 100644
--- a/tests/progs/Makefile.in
+++ b/tests/progs/Makefile.in
@@ -27,6 +27,8 @@ DEPLIBS= $(LIBEXT2FS) $(DEPLIBSS) $(DEPLIBCOM_ERR)
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
+	$(E) "	SPARSE $<"
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 
 all:: $(PROGS)
 
diff --git a/util/Makefile.in b/util/Makefile.in
index adf0b46..8412442 100644
--- a/util/Makefile.in
+++ b/util/Makefile.in
@@ -16,6 +16,8 @@ SRCS = $(srcdir)/subst.c
 .c.o:
 	$(E) "	CC $<"
 	$(Q) $(BUILD_CC) -c $(BUILD_CFLAGS) $< -o $@
+	$(E) "	SPARSE $<"
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 
 PROGS=		subst symlinks
 

