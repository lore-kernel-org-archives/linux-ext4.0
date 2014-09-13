From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 13/34] misc: add plausibility checks to
 debugfs/tune2fs/dumpe2fs/e2fsck
Date: Sat, 13 Sep 2014 15:12:39 -0700
Message-ID: <20140913221239.13646.32074.stgit@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32261 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaIMWMo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2014 18:12:44 -0400
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If any of these utilities detect a bad superblock magic, call
check_plausibility to see if blkid can identify the passed-in argument
as something else (xfs, partition, etc.) in the hopes of catching a
user error.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/Makefile.in                 |   23 ++++++++++++++++++----
 debugfs/debugfs.c                   |    3 +++
 e2fsck/Makefile.in                  |   19 ++++++++++++++++--
 e2fsck/problem.c                    |    2 +-
 e2fsck/unix.c                       |    7 ++++++-
 misc/Makefile.in                    |   33 ++++++++++++++++++--------------
 misc/dumpe2fs.c                     |    3 +++
 misc/e2image.c                      |    3 +++
 misc/tune2fs.c                      |    2 ++
 tests/f_detect_xfs/expect           |   25 ++++++++++++++++++++++++
 tests/f_detect_xfs/expect.nodebugfs |   23 ++++++++++++++++++++++
 tests/f_detect_xfs/image.bz2        |  Bin
 tests/f_detect_xfs/name             |    1 +
 tests/f_detect_xfs/script           |   36 +++++++++++++++++++++++++++++++++++
 14 files changed, 156 insertions(+), 24 deletions(-)
 create mode 100644 tests/f_detect_xfs/expect
 create mode 100644 tests/f_detect_xfs/expect.nodebugfs
 create mode 100644 tests/f_detect_xfs/image.bz2
 create mode 100644 tests/f_detect_xfs/name
 create mode 100755 tests/f_detect_xfs/script


diff --git a/debugfs/Makefile.in b/debugfs/Makefile.in
index 6220943..b33f73b 100644
--- a/debugfs/Makefile.in
+++ b/debugfs/Makefile.in
@@ -19,11 +19,12 @@ MK_CMDS=	_SS_DIR_OVERRIDE=../lib/ss ../lib/ss/mk_cmds
 DEBUG_OBJS= debug_cmds.o debugfs.o util.o ncheck.o icheck.o ls.o \
 	lsdel.o dump.o set_fields.o logdump.o htree.o unused.o e2freefrag.o \
 	filefrag.o extent_cmds.o extent_inode.o zap.o create_inode.o \
-	quota.o xattrs.o journal.o revoke.o recovery.o do_journal.o
+	quota.o xattrs.o journal.o revoke.o recovery.o do_journal.o \
+	plausible.o
 
 RO_DEBUG_OBJS= ro_debug_cmds.o ro_debugfs.o util.o ncheck.o icheck.o ls.o \
 	lsdel.o logdump.o htree.o e2freefrag.o filefrag.o extent_cmds.o \
-	extent_inode.o quota.o xattrs.o
+	extent_inode.o quota.o xattrs.o ../misc/plausible.o
 
 SRCS= debug_cmds.c $(srcdir)/debugfs.c $(srcdir)/util.c $(srcdir)/ls.c \
 	$(srcdir)/ncheck.c $(srcdir)/icheck.c $(srcdir)/lsdel.c \
@@ -32,7 +33,8 @@ SRCS= debug_cmds.c $(srcdir)/debugfs.c $(srcdir)/util.c $(srcdir)/ls.c \
 	$(srcdir)/filefrag.c $(srcdir)/extent_inode.c $(srcdir)/zap.c \
 	$(srcdir)/../misc/create_inode.c $(srcdir)/xattrs.c $(srcdir)/quota.c \
 	$(srcdir)/journal.c $(srcdir)/../e2fsck/revoke.c \
-	$(srcdir)/../e2fsck/recovery.c $(srcdir)/do_journal.c
+	$(srcdir)/../e2fsck/recovery.c $(srcdir)/do_journal.c \
+	$(srcdir)/../misc/plausible.c
 
 LIBS= $(LIBQUOTA) $(LIBEXT2FS) $(LIBE2P) $(LIBSS) $(LIBCOM_ERR) $(LIBBLKID) \
 	$(LIBUUID) $(SYSLIBS) $(LIBINTL)
@@ -59,6 +61,10 @@ DEPEND_CFLAGS = -I$(srcdir)
 
 all:: $(PROGS) $(MANPAGES)
 
+plausible.o: $(top_srcdir)/misc/plausible.c
+	$(E) "	CC $<"
+	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+
 debugfs: $(DEBUG_OBJS) $(DEPLIBS)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o debugfs $(DEBUG_OBJS) $(LIBS)
@@ -172,7 +178,8 @@ debugfs.o: $(srcdir)/debugfs.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
  $(top_srcdir)/lib/../e2fsck/dict.h $(top_srcdir)/version.h \
  $(srcdir)/../e2fsck/jfs_user.h $(top_srcdir)/lib/ext2fs/kernel-jbd.h \
- $(top_srcdir)/lib/ext2fs/jfs_compat.h $(top_srcdir)/lib/ext2fs/kernel-list.h
+ $(top_srcdir)/lib/ext2fs/jfs_compat.h $(top_srcdir)/lib/ext2fs/kernel-list.h \
+ $(srcdir)/../misc/plausible.h
 util.o: $(srcdir)/util.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/ss/ss.h \
  $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/lib/et/com_err.h \
@@ -398,3 +405,11 @@ do_journal.o: $(srcdir)/do_journal.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/../e2fsck/jfs_user.h \
  $(top_srcdir)/lib/ext2fs/kernel-jbd.h $(top_srcdir)/lib/ext2fs/jfs_compat.h \
  $(top_srcdir)/lib/ext2fs/kernel-list.h
+plausible.o: $(srcdir)/../misc/plausible.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/et/com_err.h \
+ $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
+ $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(srcdir)/../misc/nls-enable.h $(srcdir)/../misc/plausible.h
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 0d8e9e8..db85028 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -34,6 +34,7 @@ extern char *optarg;
 
 #include "../version.h"
 #include "jfs_user.h"
+#include "../misc/plausible.h"
 
 #ifndef BUFSIZ
 #define BUFSIZ 8192
@@ -87,6 +88,8 @@ static void open_filesystem(char *device, int open_flags, blk64_t superblock,
 			     unix_io_manager, &current_fs);
 	if (retval) {
 		com_err(device, retval, "while opening filesystem");
+		if (retval == EXT2_ET_BAD_MAGIC)
+			check_plausibility(device, CHECK_FS_EXIST, NULL);
 		current_fs = NULL;
 		return;
 	}
diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 8d7e769..1afd15f 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -62,7 +62,7 @@ OBJS= dict.o unix.o e2fsck.o super.o pass1.o pass1b.o pass2.o \
 	pass3.o pass4.o pass5.o journal.o badblocks.o util.o dirinfo.o \
 	dx_dirinfo.o ehandler.o problem.o message.o quota.o recovery.o \
 	region.o revoke.o ea_refcount.o rehash.o profile.o prof_err.o \
-	logfile.o sigcatcher.o readahead.o $(MTRACE_OBJ)
+	logfile.o sigcatcher.o readahead.o $(MTRACE_OBJ) plausible.o
 
 PROFILED_OBJS= profiled/dict.o profiled/unix.o profiled/e2fsck.o \
 	profiled/super.o profiled/pass1.o profiled/pass1b.o \
@@ -73,7 +73,7 @@ PROFILED_OBJS= profiled/dict.o profiled/unix.o profiled/e2fsck.o \
 	profiled/recovery.o profiled/region.o profiled/revoke.o \
 	profiled/ea_refcount.o profiled/rehash.o profiled/profile.o \
 	profiled/prof_err.o profiled/logfile.o \
-	profiled/sigcatcher.o profiled/readahead.o
+	profiled/sigcatcher.o profiled/readahead.o profiled/plausible.o
 
 SRCS= $(srcdir)/e2fsck.c \
 	$(srcdir)/dict.c \
@@ -104,12 +104,17 @@ SRCS= $(srcdir)/e2fsck.c \
 	$(srcdir)/logfile.c \
 	prof_err.c \
 	$(srcdir)/quota.c \
+	$(srcdir)/../misc/plausible.c \
 	$(MTRACE_SRC)
 
 all:: profiled $(PROGS) e2fsck $(MANPAGES) $(FMANPAGES)
 
 @PROFILE_CMT@all:: e2fsck.profiled
 
+plausible.o: $(top_srcdir)/misc/plausible.c
+	$(E) "	CC $<"
+	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+
 prof_err.c prof_err.h: prof_err.et
 	$(E) "	COMPILE_ET prof_err.et"
 	$(Q) $(COMPILE_ET) $(srcdir)/prof_err.et
@@ -411,7 +416,7 @@ unix.o: $(srcdir)/unix.c $(top_builddir)/lib/config.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
  $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
  $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/problem.h \
- $(top_srcdir)/version.h
+ $(top_srcdir)/version.h $(srcdir)/../misc/plausible.h
 dirinfo.o: $(srcdir)/dirinfo.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -529,3 +534,11 @@ quota.o: $(srcdir)/quota.c $(top_builddir)/lib/config.h \
 readahead.o: $(srcdir)/readahead.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/e2fsck.h prof_err.h
+plausible.o: $(srcdir)/../misc/plausible.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/et/com_err.h \
+ $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
+ $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(srcdir)/../misc/nls-enable.h $(srcdir)/../misc/plausible.h
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 174f45a..a4da64b 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -126,7 +126,7 @@ static struct e2fsck_problem problem_table[] = {
 	  "    e2fsck -b 8193 <@v>\n"
 	  " or\n"
 	  "    e2fsck -b 32768 <@v>\n\n"),
-	  PROMPT_NONE, PR_FATAL },
+	  PROMPT_NONE, 0 },
 
 	/* Filesystem size is wrong */
 	{ PR_0_FS_SIZE_WRONG,
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 6b0ca96..b3338ab 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -52,6 +52,7 @@ extern int optind;
 #include "e2fsck.h"
 #include "problem.h"
 #include "../version.h"
+#include "../misc/plausible.h"
 
 /* Command line options */
 static int cflag;		/* check disk */
@@ -1410,8 +1411,12 @@ failure:
 					     "-n option to do a read-only\n"
 					     "check of the device.\n"));
 #endif
-		else
+		else {
 			fix_problem(ctx, PR_0_SB_CORRUPT, &pctx);
+			if (retval == EXT2_ET_BAD_MAGIC)
+				check_plausibility(ctx->filesystem_name,
+						   CHECK_FS_EXIST, NULL);
+		}
 		fatal_error(ctx, 0);
 	}
 	/*
diff --git a/misc/Makefile.in b/misc/Makefile.in
index e49078b..bdeaa49 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -48,9 +48,9 @@ CHATTR_OBJS=	chattr.o
 LSATTR_OBJS=	lsattr.o
 UUIDGEN_OBJS=	uuidgen.o
 UUIDD_OBJS=	uuidd.o
-DUMPE2FS_OBJS=	dumpe2fs.o
+DUMPE2FS_OBJS=	dumpe2fs.o plausible.o
 BADBLOCKS_OBJS=	badblocks.o
-E2IMAGE_OBJS=	e2image.o
+E2IMAGE_OBJS=	e2image.o plausible.o
 FSCK_OBJS=	fsck.o base_device.o ismounted.o
 BLKID_OBJS=	blkid.o
 FILEFRAG_OBJS=	filefrag.o
@@ -70,7 +70,7 @@ PROFILED_CHATTR_OBJS=	profiled/chattr.o
 PROFILED_LSATTR_OBJS=	profiled/lsattr.o
 PROFILED_UUIDGEN_OBJS=	profiled/uuidgen.o
 PROFILED_UUIDD_OBJS=	profiled/uuidd.o
-PROFILED_DUMPE2FS_OBJS=	profiled/dumpe2fs.o
+PROFILED_DUMPE2FS_OBJS=	profiled/dumpe2fs.o profiled/plausible.o
 PROFILED_BADBLOCKS_OBJS=	profiled/badblocks.o
 PROFILED_E2IMAGE_OBJS=	profiled/e2image.o
 PROFILED_FSCK_OBJS=	profiled/fsck.o profiled/base_device.o \
@@ -165,13 +165,14 @@ tune2fs: $(TUNE2FS_OBJS) $(DEPLIBS) $(DEPLIBS_E2P) $(DEPLIBBLKID) \
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o tune2fs $(TUNE2FS_OBJS) $(LIBS) \
 		$(LIBBLKID) $(LIBUUID) $(LIBQUOTA) $(LIBEXT2FS) $(LIBS_E2P) \
-		$(LIBINTL) $(SYSLIBS)
+		$(LIBINTL) $(SYSLIBS) $(LIBBLKID)
 
 tune2fs.static: $(TUNE2FS_OBJS) $(STATIC_DEPLIBS) $(STATIC_LIBE2P) $(DEPSTATIC_LIBBLKID)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(LDFLAGS_STATIC) -o tune2fs.static $(TUNE2FS_OBJS) \
 		$(STATIC_LIBS) $(STATIC_LIBBLKID) $(STATIC_LIBUUID) \
-		$(STATIC_LIBQUOTA) $(STATIC_LIBE2P) $(LIBINTL) $(SYSLIBS)
+		$(STATIC_LIBQUOTA) $(STATIC_LIBE2P) $(LIBINTL) $(SYSLIBS) \
+		$(STATIC_LIBBLKID)
 
 tune2fs.profiled: $(TUNE2FS_OBJS) $(PROFILED_DEPLIBS) \
 		$(PROFILED_E2P) $(DEPPROFILED_LIBBLKID) $(DEPPROFILED_LIBUUID) \
@@ -180,7 +181,7 @@ tune2fs.profiled: $(TUNE2FS_OBJS) $(PROFILED_DEPLIBS) \
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o tune2fs.profiled \
 		$(PROFILED_TUNE2FS_OBJS) $(PROFILED_LIBBLKID) \
 		$(PROFILED_LIBUUID) $(PROFILED_LIBQUOTA) $(PROFILED_LIBE2P) \
-		$(LIBINTL) $(PROFILED_LIBS) $(SYSLIBS)
+		$(LIBINTL) $(PROFILED_LIBS) $(SYSLIBS) $(PROFILED_LIBBLKID)
 
 blkid: $(BLKID_OBJS) $(DEPLIBBLKID) $(LIBEXT2FS)
 	$(E) "	LD $@"
@@ -198,15 +199,16 @@ blkid.profiled: $(BLKID_OBJS) $(DEPPROFILED_LIBBLKID) \
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o blkid.profiled $(PROFILED_BLKID_OBJS) \
 		$(PROFILED_LIBBLKID) $(LIBINTL) $(PROFILED_LIBEXT2FS) $(SYSLIBS)
 
-e2image: $(E2IMAGE_OBJS) $(DEPLIBS)
+e2image: $(E2IMAGE_OBJS) $(DEPLIBS) $(DEPLIBBLKID)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o e2image $(E2IMAGE_OBJS) $(LIBS) \
-		$(LIBINTL) $(SYSLIBS)
+		$(LIBINTL) $(SYSLIBS) $(LIBBLKID)
 
-e2image.profiled: $(E2IMAGE_OBJS) $(PROFILED_DEPLIBS)
+e2image.profiled: $(E2IMAGE_OBJS) $(PROFILED_DEPLIBS) $(DEPLIBBLKID)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o e2image.profiled \
-		$(PROFILED_E2IMAGE_OBJS) $(PROFILED_LIBS) $(LIBINTL) $(SYSLIBS)
+		$(PROFILED_E2IMAGE_OBJS) $(PROFILED_LIBS) $(LIBINTL) $(SYSLIBS) \
+		$(LIBBLKID)
 
 e2undo: $(E2UNDO_OBJS) $(DEPLIBS)
 	$(E) "	LD $@"
@@ -296,17 +298,18 @@ uuidd.profiled: $(UUIDD_OBJS) $(PROFILED_DEPLIBUUID)
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o uuidd.profiled $(PROFILED_UUIDD_OBJS) \
 		$(PROFILED_LIBUUID) $(LIBINTL) $(SYSLIBS)
 
-dumpe2fs: $(DUMPE2FS_OBJS) $(DEPLIBS) $(DEPLIBS_E2P) $(DEPLIBUUID)
+dumpe2fs: $(DUMPE2FS_OBJS) $(DEPLIBS) $(DEPLIBS_E2P) $(DEPLIBUUID) $(DEPLIBBLKID)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o dumpe2fs $(DUMPE2FS_OBJS) $(LIBS) \
-		$(LIBS_E2P) $(LIBUUID) $(LIBINTL) $(SYSLIBS)
+		$(LIBS_E2P) $(LIBUUID) $(LIBINTL) $(SYSLIBS) $(LIBBLKID)
 
 dumpe2fs.profiled: $(DUMPE2FS_OBJS) $(PROFILED_DEPLIBS) \
-		$(PROFILED_LIBE2P) $(PROFILED_DEPLIBUUID)
+		$(PROFILED_LIBE2P) $(PROFILED_DEPLIBUUID) $(PROFILED_DEPLIBBLKID)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o dumpe2fs.profiled \
 		$(PROFILED_DUMPE2FS_OBJS) $(PROFILED_LIBS) \
-		$(PROFILED_LIBE2P) $(PROFILED_LIBUUID) $(LIBINTL) $(SYSLIBS)
+		$(PROFILED_LIBE2P) $(PROFILED_LIBUUID) $(LIBINTL) $(SYSLIBS) \
+		$(PROFILED_LIBBLKID)
 
 fsck: $(FSCK_OBJS) $(DEPLIBBLKID)
 	$(E) "	LD $@"
@@ -688,7 +691,7 @@ dumpe2fs.o: $(srcdir)/dumpe2fs.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/e2p/e2p.h $(srcdir)/jfs_user.h \
  $(top_srcdir)/lib/ext2fs/kernel-jbd.h $(top_srcdir)/lib/ext2fs/jfs_compat.h \
  $(top_srcdir)/lib/ext2fs/kernel-list.h $(top_srcdir)/version.h \
- $(srcdir)/nls-enable.h
+ $(srcdir)/nls-enable.h $(srcdir)/plausible.h
 badblocks.o: $(srcdir)/badblocks.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/et/com_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 39505a8..7c3c2cc 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -42,6 +42,7 @@ extern int optind;
 
 #include "../version.h"
 #include "nls-enable.h"
+#include "plausible.h"
 
 #define in_use(m, x)	(ext2fs_test_bit ((x), (m)))
 
@@ -689,6 +690,8 @@ try_open_again:
 		com_err (program_name, retval, _("while trying to open %s"),
 			 device_name);
 		printf("%s", _("Couldn't find valid filesystem superblock.\n"));
+		if (retval == EXT2_ET_BAD_MAGIC)
+			check_plausibility(device_name, CHECK_FS_EXIST, NULL);
 		exit (1);
 	}
 	fs->default_bitmap_type = EXT2FS_BMAP64_RBTREE;
diff --git a/misc/e2image.c b/misc/e2image.c
index e1c63a7..e876ae8 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -47,6 +47,7 @@ extern int optind;
 
 #include "../version.h"
 #include "nls-enable.h"
+#include "plausible.h"
 
 #define QCOW_OFLAG_COPIED     (1LL << 63)
 #define NO_BLK ((blk64_t) -1)
@@ -1578,6 +1579,8 @@ int main (int argc, char ** argv)
 		com_err (program_name, retval, _("while trying to open %s"),
 			 device_name);
 		fputs(_("Couldn't find valid filesystem superblock.\n"), stdout);
+		if (retval == EXT2_ET_BAD_MAGIC)
+			check_plausibility(device_name, CHECK_FS_EXIST, NULL);
 		exit(1);
 	}
 
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index c454b84..d17c8de 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2575,6 +2575,8 @@ retry_open:
 			fprintf(stderr,
 				_("MMP block magic is bad. Try to fix it by "
 				  "running:\n'e2fsck -f %s'\n"), device_name);
+		else if (retval == EXT2_ET_BAD_MAGIC)
+			check_plausibility(device_name, CHECK_FS_EXIST, NULL);
 		else if (retval != EXT2_ET_MMP_FAILED)
 			fprintf(stderr, "%s",
 			     _("Couldn't find valid filesystem superblock.\n"));
diff --git a/tests/f_detect_xfs/expect b/tests/f_detect_xfs/expect
new file mode 100644
index 0000000..4ab6e5b
--- /dev/null
+++ b/tests/f_detect_xfs/expect
@@ -0,0 +1,25 @@
+*** e2fsck
+ext2fs_open2: Bad magic number in super-block
+../e2fsck/e2fsck: Superblock invalid, trying backup blocks...
+../e2fsck/e2fsck: Bad magic number in super-block while trying to open test.img
+
+The superblock could not be read or does not describe a valid ext2/ext3/ext4
+filesystem.  If the device is valid and it really contains an ext2/ext3/ext4
+filesystem (and not swap or ufs or something else), then the superblock
+is corrupt, and you might try running e2fsck with an alternate superblock:
+    e2fsck -b 8193 <device>
+ or
+    e2fsck -b 32768 <device>
+
+test.img contains a xfs file system labelled 'test_filsys'
+*** debugfs
+test.img: Bad magic number in super-block while opening filesystem
+test.img contains a xfs file system labelled 'test_filsys'
+*** tune2fs
+../misc/tune2fs: Bad magic number in super-block while trying to open test.img
+test.img contains a xfs file system labelled 'test_filsys'
+*** mke2fs
+Creating filesystem with 16384 1k blocks and 4096 inodes
+Superblock backups stored on blocks: 
+	8193
+
diff --git a/tests/f_detect_xfs/expect.nodebugfs b/tests/f_detect_xfs/expect.nodebugfs
new file mode 100644
index 0000000..d3b7935
--- /dev/null
+++ b/tests/f_detect_xfs/expect.nodebugfs
@@ -0,0 +1,23 @@
+*** e2fsck
+ext2fs_open2: Bad magic number in super-block
+../e2fsck/e2fsck: Superblock invalid, trying backup blocks...
+../e2fsck/e2fsck: Bad magic number in super-block while trying to open test.img
+
+The superblock could not be read or does not describe a valid ext2/ext3/ext4
+filesystem.  If the device is valid and it really contains an ext2/ext3/ext4
+filesystem (and not swap or ufs or something else), then the superblock
+is corrupt, and you might try running e2fsck with an alternate superblock:
+    e2fsck -b 8193 <device>
+ or
+    e2fsck -b 32768 <device>
+
+test.img contains a xfs file system labelled 'test_filsys'
+*** debugfs
+*** tune2fs
+../misc/tune2fs: Bad magic number in super-block while trying to open test.img
+test.img contains a xfs file system labelled 'test_filsys'
+*** mke2fs
+Creating filesystem with 16384 1k blocks and 4096 inodes
+Superblock backups stored on blocks: 
+	8193
+
diff --git a/tests/f_detect_xfs/image.bz2 b/tests/f_detect_xfs/image.bz2
new file mode 100644
index 0000000000000000000000000000000000000000..9dc5e44b57c25d68cf46059439245b4f02c0d8f7
GIT binary patch
literal 450
zcmV;z0X_agT4*^jL0KkKS;zj9s{#Zw|NsB~#OOgr144bF4*%07Okh9|5J8R*M73Zb
zK|paT0LiccmH^Pypa1{>&;S9TG|&J505lI%O$b6qr~^O%00000000000E$VZo~DM7
z)6z6F0BC5@u#i7g(8sDakUd6a2AL1Yfk;si5lUbx4#)^}>SV#PqKFOtoDKj&Bt)hQ
zk8_=H64EPjfmeEEP!>VI3Wp>j5<jw30Z|+<sEP=MUzj#;_cN!HS8U^-qR}P6hp9jn
zLrf{B2`xD)w`h`x0sse{6@?1@dwsIeN}o;AbQ95&D0U&9w2%V^w1hwq06CC=9fAQ2
zP@;%{0i_ezHRm%dY`}J5!GbeQt8|LE{1OKI0c-aqxp0C}hF6I9l<yR0!0K)i=|X40
zSj32`7uBmRqBwZRbkQf93>eA_b0RNja^f}oxVPC=$Z%#-O00;l^DMLg0=q1-EQ{|I
z-UFP9{H}W`A0XuTloI=J@mt1a$(Fq?Qdym%5C9rM@4&KeGzZ~%chaW?2qK|iAweqy
sLXu;sl0e`{>cWa302YhTqK(sV6`W^c`qpYum;L`2az!{$kjMU$tCv{5XaE2J

literal 0
HcmV?d00001

diff --git a/tests/f_detect_xfs/name b/tests/f_detect_xfs/name
new file mode 100644
index 0000000..d5b9b82
--- /dev/null
+++ b/tests/f_detect_xfs/name
@@ -0,0 +1 @@
+detect xfs filesystem
diff --git a/tests/f_detect_xfs/script b/tests/f_detect_xfs/script
new file mode 100755
index 0000000..2531c5e
--- /dev/null
+++ b/tests/f_detect_xfs/script
@@ -0,0 +1,36 @@
+#!/bin/bash
+
+FSCK_OPT=-fn
+IMAGE=$test_dir/image.bz2
+
+bzip2 -d < $IMAGE > $TMPFILE
+
+# Run fsck to fix things?
+if [ -x $DEBUGFS_EXE ]; then
+	EXP=$test_dir/expect
+else
+	EXP=$test_dir/expect.nodebugfs
+fi
+OUT=$test_name.log
+rm -rf $test_name.failed $test_name.ok
+
+echo "*** e2fsck" > $OUT
+$FSCK $FSCK_OPT $TMPFILE >> $OUT 2>&1
+echo "*** debugfs" >> $OUT
+test -x $DEBUGFS_EXE && $DEBUGFS_EXE -R 'quit' $TMPFILE >> $OUT 2>&1
+echo "*** tune2fs" >> $OUT
+$TUNE2FS -i 0 $TMPFILE >> $OUT 2>&1
+echo "*** mke2fs" >> $OUT
+$MKE2FS -n $TMPFILE >> $OUT 2>&1
+
+sed -f $cmd_dir/filter.sed -e "s|$TMPFILE|test.img|g" -i $OUT
+
+# Figure out what happened
+if cmp -s $EXP $OUT; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff -u $EXP $OUT >> $test_name.failed
+fi
+unset EXP OUT FSCK_OPT IMAGE

