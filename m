From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/5] e2fsck: add logging capability
Date: Sun, 18 Mar 2012 15:52:48 -0400
Message-ID: <1332100368-2683-6-git-send-email-tytso@mit.edu>
References: <1332100368-2683-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40336 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756118Ab2CRTwr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Mar 2012 15:52:47 -0400
In-Reply-To: <1332100368-2683-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add the ability to log messages about a file system to a specified
directory, using a file name templace that can be specified in
/etc/e2fsck.conf.  This allows us to suppress the output of overly
verbose e2fsck outputs while still allowing the full logging output to
go to an appropriate file.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/Makefile.in      |  186 ++++++++++++++---------
 e2fsck/e2fsck.c         |    3 +
 e2fsck/e2fsck.conf.5.in |  134 +++++++++++++++++
 e2fsck/e2fsck.h         |   17 ++-
 e2fsck/logfile.c        |  383 +++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/message.c        |  182 +++++++++++-----------
 e2fsck/problem.c        |   30 +++--
 e2fsck/problem.h        |    2 +-
 e2fsck/unix.c           |  266 +++++++++++++++++++--------------
 e2fsck/util.c           |   99 ++++++++-----
 10 files changed, 978 insertions(+), 324 deletions(-)
 create mode 100644 e2fsck/logfile.c

diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index b5336a4..d558985 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -68,7 +68,7 @@ OBJS= crc32.o dict.o unix.o e2fsck.o super.o pass1.o pass1b.o pass2.o \
 	pass3.o pass4.o pass5.o journal.o badblocks.o util.o dirinfo.o \
 	dx_dirinfo.o ehandler.o problem.o message.o quota.o recovery.o \
 	region.o revoke.o ea_refcount.o rehash.o profile.o prof_err.o \
-	sigcatcher.o $(MTRACE_OBJ)
+	logfile.o sigcatcher.o $(MTRACE_OBJ)
 
 PROFILED_OBJS= profiled/dict.o profiled/unix.o profiled/e2fsck.o \
 	profiled/super.o profiled/pass1.o profiled/pass1b.o \
@@ -78,7 +78,8 @@ PROFILED_OBJS= profiled/dict.o profiled/unix.o profiled/e2fsck.o \
 	profiled/message.o profiled/problem.o profiled/quota.o \
 	profiled/recovery.o profiled/region.o profiled/revoke.o \
 	profiled/ea_refcount.o profiled/rehash.o profiled/profile.o \
-	profiled/crc32.o profiled/prof_err.o profiled/sigcatcher.o
+	profiled/crc32.o profiled/prof_err.o profiled/logfile.o \
+	profiled/sigcatcher.o
 
 SRCS= $(srcdir)/e2fsck.c \
 	$(srcdir)/crc32.c \
@@ -107,6 +108,7 @@ SRCS= $(srcdir)/e2fsck.c \
 	$(srcdir)/region.c \
 	$(srcdir)/profile.c \
 	$(srcdir)/sigcatcher.c \
+	$(srcdir)/logfile.c \
 	prof_err.c \
 	$(srcdir)/quota.c \
 	$(MTRACE_SRC)
@@ -160,6 +162,11 @@ tst_refcount: ea_refcount.c $(DEPLIBCOM_ERR)
 	$(Q) $(CC) -o tst_refcount $(srcdir)/ea_refcount.c \
 		$(ALL_CFLAGS) -DTEST_PROGRAM $(LIBCOM_ERR) $(LIBEXT2FS) 
 
+tst_logfile: $(srcdir)/logfile.c
+	$(E) "	LD $@"
+	$(Q) $(CC) -o tst_logfile $(srcdir)/logfile.c $(ALL_CFLAGS) \
+		-DTEST_PROGRAM
+
 tst_region: region.c $(DEPLIBCOM_ERR)
 	$(E) "	LD $@"
 	$(Q) $(CC) -o tst_region $(srcdir)/region.c \
@@ -279,7 +286,8 @@ distclean: clean
 # Makefile dependencies follow.  This must be the last section in
 # the Makefile.in file
 #
-e2fsck.o: $(srcdir)/e2fsck.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
+e2fsck.o: $(srcdir)/e2fsck.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
@@ -288,7 +296,8 @@ e2fsck.o: $(srcdir)/e2fsck.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(srcdir)/problem.h
-crc32.o: $(srcdir)/crc32.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
+crc32.o: $(srcdir)/crc32.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
@@ -297,10 +306,11 @@ crc32.o: $(srcdir)/crc32.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(srcdir)/crc32defs.h crc32table.h
-gen_crc32table.o: $(srcdir)/gen_crc32table.c $(top_builddir)/lib/config.h \
- $(srcdir)/crc32defs.h
-dict.o: $(srcdir)/dict.c $(top_builddir)/lib/config.h $(srcdir)/dict.h
-super.o: $(srcdir)/super.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
+gen_crc32table.o: $(srcdir)/gen_crc32table.c $(srcdir)/crc32defs.h
+dict.o: $(srcdir)/dict.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/dict.h
+super.o: $(srcdir)/super.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
@@ -309,7 +319,8 @@ super.o: $(srcdir)/super.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(srcdir)/problem.h
-pass1.o: $(srcdir)/pass1.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
+pass1.o: $(srcdir)/pass1.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
@@ -319,15 +330,17 @@ pass1.o: $(srcdir)/pass1.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(srcdir)/problem.h
 pass1b.o: $(srcdir)/pass1b.c $(top_builddir)/lib/config.h \
- $(top_srcdir)/lib/et/com_err.h $(srcdir)/e2fsck.h \
- $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
- $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
- $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/et/com_err.h \
+ $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
+ $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(srcdir)/problem.h $(srcdir)/dict.h
-pass2.o: $(srcdir)/pass2.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
+pass2.o: $(srcdir)/pass2.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
@@ -336,7 +349,8 @@ pass2.o: $(srcdir)/pass2.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(srcdir)/problem.h $(srcdir)/dict.h
-pass3.o: $(srcdir)/pass3.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
+pass3.o: $(srcdir)/pass3.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
@@ -345,7 +359,8 @@ pass3.o: $(srcdir)/pass3.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(srcdir)/problem.h
-pass4.o: $(srcdir)/pass4.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
+pass4.o: $(srcdir)/pass4.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
@@ -354,7 +369,8 @@ pass4.o: $(srcdir)/pass4.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(srcdir)/problem.h
-pass5.o: $(srcdir)/pass5.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
+pass5.o: $(srcdir)/pass5.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
@@ -364,44 +380,49 @@ pass5.o: $(srcdir)/pass5.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(srcdir)/problem.h
 journal.o: $(srcdir)/journal.c $(top_builddir)/lib/config.h \
- $(srcdir)/jfs_user.h $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
- $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
- $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/jfs_user.h $(srcdir)/e2fsck.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(top_srcdir)/lib/ext2fs/kernel-jbd.h $(top_srcdir)/lib/ext2fs/jfs_compat.h \
  $(top_srcdir)/lib/ext2fs/kernel-list.h $(srcdir)/problem.h
 recovery.o: $(srcdir)/recovery.c $(top_builddir)/lib/config.h \
- $(srcdir)/jfs_user.h $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
- $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
- $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/jfs_user.h $(srcdir)/e2fsck.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(top_srcdir)/lib/ext2fs/kernel-jbd.h $(top_srcdir)/lib/ext2fs/jfs_compat.h \
  $(top_srcdir)/lib/ext2fs/kernel-list.h
 revoke.o: $(srcdir)/revoke.c $(top_builddir)/lib/config.h \
- $(srcdir)/jfs_user.h $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
- $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
- $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/jfs_user.h $(srcdir)/e2fsck.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(top_srcdir)/lib/ext2fs/kernel-jbd.h $(top_srcdir)/lib/ext2fs/jfs_compat.h \
  $(top_srcdir)/lib/ext2fs/kernel-list.h
 badblocks.o: $(srcdir)/badblocks.c $(top_builddir)/lib/config.h \
- $(top_srcdir)/lib/et/com_err.h $(srcdir)/e2fsck.h \
- $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
- $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
- $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/et/com_err.h \
+ $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
+ $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h
-util.o: $(srcdir)/util.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
+util.o: $(srcdir)/util.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
@@ -410,67 +431,74 @@ util.o: $(srcdir)/util.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h
 unix.o: $(srcdir)/unix.c $(top_builddir)/lib/config.h \
- $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
- $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/et/com_err.h \
- $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
- $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
- $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/e2p/e2p.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/et/com_err.h $(srcdir)/e2fsck.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(srcdir)/problem.h $(top_srcdir)/version.h
 dirinfo.o: $(srcdir)/dirinfo.c $(top_builddir)/lib/config.h \
- $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
- $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
- $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(top_srcdir)/lib/ext2fs/tdb.h
 dx_dirinfo.o: $(srcdir)/dx_dirinfo.c $(top_builddir)/lib/config.h \
- $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
- $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
- $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h
 ehandler.o: $(srcdir)/ehandler.c $(top_builddir)/lib/config.h \
- $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
- $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
- $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h
 problem.o: $(srcdir)/problem.c $(top_builddir)/lib/config.h \
- $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
- $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
- $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(srcdir)/problem.h $(srcdir)/problemP.h
 message.o: $(srcdir)/message.c $(top_builddir)/lib/config.h \
- $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
- $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
- $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(srcdir)/problem.h
 ea_refcount.o: $(srcdir)/ea_refcount.c $(top_builddir)/lib/config.h \
- $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
- $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
- $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h
-rehash.o: $(srcdir)/rehash.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
+rehash.o: $(srcdir)/rehash.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
@@ -479,7 +507,8 @@ rehash.o: $(srcdir)/rehash.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(srcdir)/problem.h
-region.o: $(srcdir)/region.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
+region.o: $(srcdir)/region.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
@@ -488,17 +517,29 @@ region.o: $(srcdir)/region.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h
 profile.o: $(srcdir)/profile.c $(top_builddir)/lib/config.h \
- $(top_srcdir)/lib/et/com_err.h $(srcdir)/profile.h prof_err.h
+ $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/et/com_err.h \
+ $(srcdir)/profile.h prof_err.h
 sigcatcher.o: $(srcdir)/sigcatcher.c $(top_builddir)/lib/config.h \
- $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
- $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
- $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
+ $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h
+logfile.o: $(srcdir)/logfile.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h
 prof_err.o: prof_err.c
-quota.o: $(srcdir)/quota.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
+quota.o: $(srcdir)/quota.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
@@ -506,4 +547,5 @@ quota.o: $(srcdir)/quota.c $(top_builddir)/lib/config.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
  $(top_srcdir)/lib/quota/quota.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(srcdir)/problem.h
+ $(srcdir)/problem.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h
diff --git a/e2fsck/e2fsck.c b/e2fsck/e2fsck.c
index c6e137b..994f80e 100644
--- a/e2fsck/e2fsck.c
+++ b/e2fsck/e2fsck.c
@@ -187,6 +187,9 @@ void e2fsck_free_context(e2fsck_t ctx)
 	if (ctx->device_name)
 		ext2fs_free_mem(&ctx->device_name);
 
+	if (ctx->log_fn)
+		free(ctx->log_fn);
+
 	ext2fs_free_mem(&ctx);
 }
 
diff --git a/e2fsck/e2fsck.conf.5.in b/e2fsck/e2fsck.conf.5.in
index a89d7b4..0d4651b 100644
--- a/e2fsck/e2fsck.conf.5.in
+++ b/e2fsck/e2fsck.conf.5.in
@@ -136,6 +136,47 @@ filesystem checks (either based on time or number of mounts) should
 be doubled if the system is running on battery.  This setting defaults to 
 true.
 .TP
+.I log_dir
+If the
+.I log_filename
+relation contains a relative pathname, then the log file will be placed
+in the directory named by the
+.I log_dir
+relation.
+.TP
+.I log_dir_fallback
+This relation contains an alternate directory that will be used if the
+directory specified by
+.I log_dir
+is not available or is not writeable.
+.TP
+.I log_dir_wait
+If this boolean relation is true, them if the directories specified by
+.I log_dir
+or
+.I log_dir_fallback
+are not available or are not yet writeable, e2fsck will save the output
+in a memory buffer, and a child process will periodically test to see if
+the log directory has become available after the boot sequence has
+mounted the requiste filesytem for reading/writing.  This implements the
+functionality provided by
+.BR logsave (8)
+for e2fsck log files.
+.TP
+.I log_filename
+This relation specifies the file name where a copy of e2fsck's output
+will be written.   If certain problem reports are suppressed using the
+.I max_count_problems
+relation, (or on a per-problem basis using the
+.I max_count
+relation), the full set of problem reports will be written to the log
+file.  The filename may contain various percent-expressions (%D, %T, %N,
+etc.) which will be expanded so that the file name for the log file can
+include things like date, time, device name, and other run-time
+parameters.  See the
+.B LOGGING
+section for more details.
+.TP
 .I max_count_problems
 This relation specifies the maximum number of problem reports of a
 particular type will be printed to stdout before further problem reports
@@ -241,6 +282,76 @@ defaults to true.
 This relation controls whether or not the scratch file directory is used
 instead of an in-memory data structure when tracking inode counts.  It
 defaults to true.
+.SH LOGGING
+E2fsck has the facility to save the information from an e2fsck run in a
+directory so that a system administrator can review its output at their
+leisure.  This allows information captured during the automatic e2fsck
+preen run, as well as a manually started e2fsck run, to be saved for
+posterity.  This facility is controlled by the
+.IR log_filename ,
+.IR log_dir ,
+.IR log_dir_fallback ,
+and
+.I log_dir_wait
+relations in the
+.I [options]
+stanza.
+.PP
+The filename in
+.I log_filename
+may contain the following percent-expressions that will be expanded as
+follows.
+.TP
+.B %d
+The current day of the month
+.TP
+.B %D
+The current date; this is a equivalent of
+.B %Y%m%d
+.TP
+.B %h
+The hostname of the system.
+.TP
+.B %H
+The current hour in 24-hour format (00..23)
+.TP
+.B %m
+The current month as a two-digit number (01..12)
+.TP
+.B %M
+The current minute (00..59)
+.TP
+.B %N
+The name of the block device containing the file system, with any
+directory pathname stripped off.
+.TP
+.B %p
+The pid of the e2fsck process
+.TP
+.B %s
+The current time expressed as the number of seconds since 1970-01-01
+00:00:00 UTC
+.TP
+.B %S
+The current second (00..59)
+.TP
+.B %T
+The current time; this is equivalent of
+.B %H%M%S
+.TP
+.B %u
+The name of the user running e2fsck.
+.TP
+.B %U
+This percent expression does not expand to anything, but it signals that
+any following date or time expressions should be expressed in UTC time
+instead of the local timzeone.
+.TP
+.B %y
+The last two digits of the current year (00..99)
+.TP
+.B %Y
+The current year (i.e., 2012).
 .SH EXAMPLES
 The following recipe will prevent e2fsck from aborting during the boot
 process when a filesystem contains orphaned files.  (Of course, this is
@@ -259,6 +370,29 @@ things out may be dangerous.)
 			description = "@u @i %i.  "
 .br
 		}
+.P
+The following recipe will cause an e2fsck logfile to be written to the
+directory /var/log/e2fsck, with a filename that contains the device
+name, the hostname of the system, the date, and time: e.g.,
+"e2fsck-sda3.server.INFO.20120314-112142".  If the directory containing
+/var/log is located on the root file system
+which is initially mounted read-only, then the output will be saved in
+memory and written out once the root file system has been remounted
+read/write.   To avoid too much detail from being written to the serial
+console (which could potentially slow down the boot sequence), only print
+no more than 16 instances of each type of file system corruption.
+.P
+.br
+	[options]
+.br
+		max_count_problems = 16
+.br
+		log_dir = /var/log/e2fsck
+.br
+		log_filename = e2fsck-%N.%h.INFO.%D-%T
+.br
+		log_dir_wait = true
+.P
 .SH FILES
 .TP
 .I /etc/e2fsck.conf
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index ed8b0c7..971390e 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -61,6 +61,12 @@
 #define P_(singular, plural, n) ((n) == 1 ? (singular) : (plural))
 #endif
 
+#ifdef __GNUC__
+#define E2FSCK_ATTR(x) __attribute__(x)
+#else
+#define E2FSCK_ATTR(x)
+#endif
+
 #include "quota/mkquota.h"
 
 /*
@@ -214,6 +220,8 @@ struct e2fsck_struct {
 	char *filesystem_name;
 	char *device_name;
 	char *io_options;
+	FILE	*logf;
+	char	*log_fn;
 	int	flags;		/* E2fsck internal flags */
 	int	options;
 	int	blocksize;	/* blocksize */
@@ -449,6 +457,9 @@ extern int e2fsck_run_ext3_journal(e2fsck_t ctx);
 extern void e2fsck_move_ext3_journal(e2fsck_t ctx);
 extern int e2fsck_fix_ext3_journal_hint(e2fsck_t ctx);
 
+/* logfile.c */
+extern void set_up_logging(e2fsck_t ctx);
+
 /* quota.c */
 extern void e2fsck_hide_quota(e2fsck_t ctx);
 
@@ -498,8 +509,12 @@ void check_resize_inode(e2fsck_t ctx);
 extern void *e2fsck_allocate_memory(e2fsck_t ctx, unsigned int size,
 				    const char *description);
 extern int ask(e2fsck_t ctx, const char * string, int def);
-extern int ask_yn(const char * string, int def);
+extern int ask_yn(e2fsck_t ctx, const char * string, int def);
 extern void fatal_error(e2fsck_t ctx, const char * fmt_string);
+extern void log_out(e2fsck_t ctx, const char *fmt, ...)
+	E2FSCK_ATTR((format(printf, 2, 3)));
+extern void log_err(e2fsck_t ctx, const char *fmt, ...)
+	E2FSCK_ATTR((format(printf, 2, 3)));
 extern void e2fsck_read_bitmaps(e2fsck_t ctx);
 extern void e2fsck_write_bitmaps(e2fsck_t ctx);
 extern void preenhalt(e2fsck_t ctx);
diff --git a/e2fsck/logfile.c b/e2fsck/logfile.c
new file mode 100644
index 0000000..76ae52d
--- /dev/null
+++ b/e2fsck/logfile.c
@@ -0,0 +1,383 @@
+/*
+ * logfile.c --- set up e2fsck log files
+ *
+ * Copyright 1996, 1997 by Theodore Ts'o
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include "config.h"
+#ifdef HAVE_ERRNO_H
+#include <errno.h>
+#endif
+
+#include "e2fsck.h"
+#include <pwd.h>
+
+struct string {
+	char	*s;
+	int	len;
+	int	end;
+};
+
+static void alloc_string(struct string *s, int len)
+{
+	s->s = malloc(len);
+/* e2fsck_allocate_memory(ctx, len, "logfile name"); */
+	s->len = len;
+	s->end = 0;
+}
+
+static void append_string(struct string *s, const char *a, int len)
+{
+	if (!len)
+		len = strlen(a);
+
+	if (s->end + len >= s->len) {
+		char *n = realloc(s, s->len * 2);
+
+		if (n) {
+			s->s = n;
+			s->len = s->len * 2;
+		} else {
+			len = s->len - s->end - 1;
+			if (len <= 0)
+				return;
+		}
+	}
+	memcpy(s->s + s->end, a, len);
+	s->end += len;
+	s->s[s->end] = 0;
+}
+
+#define FLAG_UTC	0x0001
+
+static void expand_percent_expression(e2fsck_t ctx, char ch,
+				      struct string *s, int *flags)
+{
+	struct tm	*tm = NULL, tm_struct;
+	struct passwd	*pw = NULL, pw_struct;
+	char		*cp;
+	char		buf[256];
+
+	if ((ch == 'D') || (ch == 'd') || (ch == 'm') || (ch == 'y') ||
+	    (ch == 'Y') ||
+	    (ch == 'T') || (ch == 'H') || (ch == 'M') || (ch == 'S')) {
+		tzset();
+		tm = (*flags & FLAG_UTC) ? gmtime_r(&ctx->now, &tm_struct) :
+			localtime_r(&ctx->now, &tm_struct);
+	}
+
+	switch (ch) {
+	case '%':
+		append_string(s, "%", 1);
+		return;
+	case 'd':
+		sprintf(buf, "%02d", tm->tm_mday);
+		break;
+	case 'D':
+		sprintf(buf, "%d%02d%02d", tm->tm_year + 1900, tm->tm_mon + 1,
+			tm->tm_mday);
+		break;
+	case 'h':
+#ifdef TEST_PROGRAM
+		strcpy(buf, "server");
+#else
+		buf[0] = 0;
+		gethostname(buf, sizeof(buf));
+		buf[sizeof(buf)-1] = 0;
+#endif
+		break;
+	case 'H':
+		sprintf(buf, "%02d", tm->tm_hour);
+		break;
+	case 'm':
+		sprintf(buf, "%02d", tm->tm_mon + 1);
+		break;
+	case 'M':
+		sprintf(buf, "%02d", tm->tm_min);
+		break;
+	case 'N':		/* block device name */
+		cp = strrchr(ctx->filesystem_name, '/');
+		if (cp)
+			cp++;
+		else
+			cp = ctx->filesystem_name;
+		append_string(s, cp, 0);
+		return;
+	case 'p':
+		sprintf(buf, "%lu", (unsigned long) getpid());
+		break;
+	case 's':
+		sprintf(buf, "%lu", (unsigned long) ctx->now);
+		break;
+	case 'S':
+		sprintf(buf, "%02d", tm->tm_sec);
+		break;
+	case 'T':
+		sprintf(buf, "%02d%02d%02d", tm->tm_hour, tm->tm_min,
+			tm->tm_sec);
+		break;
+	case 'u':
+#ifdef TEST_PROGRAM
+		strcpy(buf, "tytso");
+		break;
+#else
+		getpwuid_r(getuid(), &pw_struct, buf, sizeof(buf), &pw);
+		if (pw)
+			append_string(s, pw->pw_name, 0);
+		return;
+#endif
+	case 'U':
+		*flags |= FLAG_UTC;
+		return;
+	case 'y':
+		sprintf(buf, "%02d", tm->tm_year % 100);
+		break;
+	case 'Y':
+		sprintf(buf, "%d", tm->tm_year + 1900);
+		break;
+	}
+	append_string(s, buf, 0);
+}
+
+static void expand_logfn(e2fsck_t ctx, const char *log_fn, struct string *s)
+{
+	const char	*cp;
+	int		i;
+	int		flags = 0;
+
+	alloc_string(s, 100);
+	for (cp = log_fn; *cp; cp++) {
+		if (cp[0] == '%') {
+			cp++;
+			expand_percent_expression(ctx, *cp, s, &flags);
+			continue;
+		}
+		for (i = 0; cp[i]; i++)
+			if (cp[i] == '%')
+				break;
+		append_string(s, cp, i);
+		cp += i-1;
+	}
+}
+
+static int	outbufsize;
+static void	*outbuf;
+
+static int do_read(int fd)
+{
+	int	c;
+	char		*n;
+	char	buffer[4096];
+
+	c = read(fd, buffer, sizeof(buffer)-1);
+	if (c <= 0)
+		return c;
+
+	n = realloc(outbuf, outbufsize + c);
+	if (n) {
+		outbuf = n;
+		memcpy(((char *)outbuf)+outbufsize, buffer, c);
+		outbufsize += c;
+	}
+	return c;
+}
+
+/*
+ * Fork a child process to save the output of the logfile until the
+ * appropriate file system is mounted read/write.
+ */
+static FILE *save_output(const char *s0, const char *s1, const char *s2)
+{
+	int c, fd, fds[2];
+	char *cp;
+	pid_t pid;
+	FILE *ret;
+
+	if (s0 && *s0 == 0)
+		s0 = 0;
+	if (s1 && *s1 == 0)
+		s1 = 0;
+	if (s2 && *s2 == 0)
+		s2 = 0;
+
+	/* At least one potential output file name is valid */
+	if (!s0 && !s1 && !s2)
+		return NULL;
+	if (pipe(fds) < 0) {
+		perror("pipe");
+		exit(1);
+	}
+
+	pid = fork();
+	if (pid < 0) {
+		perror("fork");
+		exit(1);
+	}
+
+	if (pid == 0) {
+		if (daemon(0, 0) < 0) {
+			perror("daemon");
+			exit(1);
+		}
+		/*
+		 * Grab the output from our parent
+		 */
+		close(fds[1]);
+		while (do_read(fds[0]) > 0)
+			;
+		close(fds[0]);
+
+		/* OK, now let's try to open the output file */
+		fd = -1;
+		while (1) {
+			if (fd < 0 && s0)
+				fd = open(s0, O_WRONLY|O_CREAT|O_TRUNC, 0644);
+			if (fd < 0 && s1)
+				fd = open(s1, O_WRONLY|O_CREAT|O_TRUNC, 0644);
+			if (fd < 0 && s2)
+				fd = open(s2, O_WRONLY|O_CREAT|O_TRUNC, 0644);
+			if (fd >= 0)
+				break;
+			sleep(1);
+		}
+
+		cp = outbuf;
+		while (outbufsize > 0) {
+			c = write(fd, cp, outbufsize);
+			if (c < 0) {
+				if ((errno == EAGAIN) || (errno == EINTR))
+					continue;
+				break;
+			}
+			outbufsize -= c;
+			cp += c;
+		}
+		exit(0);
+	}
+
+	close(fds[0]);
+	ret = fdopen(fds[1], "w");
+	if (!ret)
+		close(fds[1]);
+	return ret;
+}
+
+#ifndef TEST_PROGRAM
+void set_up_logging(e2fsck_t ctx)
+{
+	struct string s, s1, s2;
+	char *s0 = 0, *log_dir = 0, *log_fn = 0;
+	int log_dir_wait = 0;
+
+	s.s = s1.s = s2.s = 0;
+
+	profile_get_boolean(ctx->profile, "options", "log_dir_wait", 0, 0,
+			    &log_dir_wait);
+	if (ctx->log_fn)
+		log_fn = string_copy(ctx, ctx->log_fn, 0);
+	else
+		profile_get_string(ctx->profile, "options", "log_filename",
+				   0, 0, &log_fn);
+	profile_get_string(ctx->profile, "options", "log_dir", 0, 0, &log_dir);
+
+	if (!log_fn || !log_fn[0])
+		goto out;
+
+	expand_logfn(ctx, log_fn, &s);
+	if ((log_fn[0] == '/') || !log_dir || !log_dir[0])
+		s0 = s.s;
+
+	if (log_dir && log_dir[0]) {
+		alloc_string(&s1, strlen(log_dir) + strlen(s.s) + 2);
+		append_string(&s1, log_dir, 0);
+		append_string(&s1, "/", 1);
+		append_string(&s1, s.s, 0);
+	}
+
+	free(log_dir);
+	profile_get_string(ctx->profile, "options", "log_dir_fallback", 0, 0,
+			   &log_dir);
+	if (log_dir && log_dir[0]) {
+		alloc_string(&s2, strlen(log_dir) + strlen(s.s) + 2);
+		append_string(&s2, log_dir, 0);
+		append_string(&s2, "/", 1);
+		append_string(&s2, s.s, 0);
+		printf("%s\n", s2.s);
+	}
+
+	if (s0)
+		ctx->logf = fopen(s0, "w");
+	if (!ctx->logf && s1.s)
+		ctx->logf = fopen(s1.s, "w");
+	if (!ctx->logf && s2.s)
+		ctx->logf = fopen(s2.s, "w");
+	if (!ctx->logf && log_dir_wait)
+		ctx->logf = save_output(s0, s1.s, s2.s);
+
+out:
+	free(s.s);
+	free(s1.s);
+	free(s2.s);
+	free(log_fn);
+	free(log_dir);
+	return;
+}
+#else
+void *e2fsck_allocate_memory(e2fsck_t ctx, unsigned int size,
+			     const char *description)
+{
+	void *ret;
+	char buf[256];
+
+	ret = malloc(size);
+	if (!ret) {
+		sprintf(buf, "Can't allocate %s\n", description);
+		exit(1);
+	}
+	memset(ret, 0, size);
+	return ret;
+}
+
+errcode_t e2fsck_allocate_context(e2fsck_t *ret)
+{
+	e2fsck_t	context;
+	errcode_t	retval;
+	char		*time_env;
+
+	context = malloc(sizeof(struct e2fsck_struct));
+	if (!context)
+		return ENOMEM;
+
+	memset(context, 0, sizeof(struct e2fsck_struct));
+
+	context->now = 1332006474;
+
+	context->filesystem_name = "/dev/sda3";
+	context->device_name = "fslabel";
+
+	*ret = context;
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	e2fsck_t	ctx;
+	struct string	s;
+
+	putenv("TZ=EST+5:00");
+	e2fsck_allocate_context(&ctx);
+	expand_logfn(ctx, "e2fsck-%N.%h.%u.%D-%T", &s);
+	printf("%s\n", s.s);
+	free(s.s);
+	expand_logfn(ctx, "e2fsck-%N.%h.%u.%Y%m%d-%H%M%S", &s);
+	printf("%s\n", s.s);
+	free(s.s);
+
+	return 0;
+}
+#endif
diff --git a/e2fsck/message.c b/e2fsck/message.c
index 6274824..980dc4b 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -168,7 +168,7 @@ static const char *special_inode_name[] =
  * This function does "safe" printing.  It will convert non-printable
  * ASCII characters using '^' and M- notation.
  */
-static void safe_print(const char *cp, int len)
+static void safe_print(FILE *f, const char *cp, int len)
 {
 	unsigned char	ch;
 
@@ -178,14 +178,14 @@ static void safe_print(const char *cp, int len)
 	while (len--) {
 		ch = *cp++;
 		if (ch > 128) {
-			fputs("M-", stdout);
+			fputs("M-", f);
 			ch -= 128;
 		}
 		if ((ch < 32) || (ch == 0x7f)) {
-			fputc('^', stdout);
+			fputc('^', f);
 			ch ^= 0x40; /* ^@, ^A, ^B; ^? for DEL */
 		}
-		fputc(ch, stdout);
+		fputc(ch, f);
 	}
 }
 
@@ -194,27 +194,28 @@ static void safe_print(const char *cp, int len)
  * This function prints a pathname, using the ext2fs_get_pathname
  * function
  */
-static void print_pathname(ext2_filsys fs, ext2_ino_t dir, ext2_ino_t ino)
+static void print_pathname(FILE *f, ext2_filsys fs, ext2_ino_t dir,
+			   ext2_ino_t ino)
 {
 	errcode_t	retval;
 	char		*path;
 
 	if (!dir && (ino < num_special_inodes)) {
-		fputs(_(special_inode_name[ino]), stdout);
+		fputs(_(special_inode_name[ino]), f);
 		return;
 	}
 
 	if (fs)
 		retval = ext2fs_get_pathname(fs, dir, ino, &path);
 	if (!fs || retval)
-		fputs("???", stdout);
+		fputs("???", f);
 	else {
-		safe_print(path, -1);
+		safe_print(f, path, -1);
 		ext2fs_free_mem(&path);
 	}
 }
 
-static void print_time(time_t t)
+static void print_time(FILE *f, time_t t)
 {
 	const char *		time_str;
 	static int		do_gmt = -1;
@@ -229,7 +230,7 @@ static void print_time(time_t t)
 		}
 #endif
 		time_str = asctime((do_gmt > 0) ? gmtime(&t) : localtime(&t));
-		printf("%.24s", time_str);
+		fprintf(f, "%.24s", time_str);
 }
 
 /*
@@ -237,7 +238,7 @@ static void print_time(time_t t)
  * expansion; an @ expression can contain further '@' and '%'
  * expressions.
  */
-static _INLINE_ void expand_at_expression(e2fsck_t ctx, char ch,
+static _INLINE_ void expand_at_expression(FILE *f, e2fsck_t ctx, char ch,
 					  struct problem_context *pctx,
 					  int *first, int recurse)
 {
@@ -252,17 +253,17 @@ static _INLINE_ void expand_at_expression(e2fsck_t ctx, char ch,
 		str = _(*cpp) + 1;
 		if (*first && islower(*str)) {
 			*first = 0;
-			fputc(toupper(*str++), stdout);
+			fputc(toupper(*str++), f);
 		}
-		print_e2fsck_message(ctx, str, pctx, *first, recurse+1);
+		print_e2fsck_message(f, ctx, str, pctx, *first, recurse+1);
 	} else
-		printf("@%c", ch);
+		fprintf(f, "@%c", ch);
 }
 
 /*
  * This function expands '%IX' expressions
  */
-static _INLINE_ void expand_inode_expression(ext2_filsys fs, char ch,
+static _INLINE_ void expand_inode_expression(FILE *f, ext2_filsys fs, char ch,
 					     struct problem_context *ctx)
 {
 	struct ext2_inode	*inode;
@@ -277,78 +278,78 @@ static _INLINE_ void expand_inode_expression(ext2_filsys fs, char ch,
 	switch (ch) {
 	case 's':
 		if (LINUX_S_ISDIR(inode->i_mode))
-			printf("%u", inode->i_size);
+			fprintf(f, "%u", inode->i_size);
 		else {
 #ifdef EXT2_NO_64_TYPE
 			if (inode->i_size_high)
-				printf("0x%x%08x", inode->i_size_high,
-				       inode->i_size);
+				fprintf(f, "0x%x%08x", inode->i_size_high,
+					inode->i_size);
 			else
-				printf("%u", inode->i_size);
+				fprintf(f, "%u", inode->i_size);
 #else
-			printf("%llu", EXT2_I_SIZE(inode));
+			fprintf(f, "%llu", EXT2_I_SIZE(inode));
 #endif
 		}
 		break;
 	case 'S':
-		printf("%u", large_inode->i_extra_isize);
+		fprintf(f, "%u", large_inode->i_extra_isize);
 		break;
 	case 'b':
 		if (fs->super->s_feature_ro_compat &
 		    EXT4_FEATURE_RO_COMPAT_HUGE_FILE) 
-			printf("%llu", inode->i_blocks +
-			       (((long long) inode->osd2.linux2.l_i_blocks_hi)
-				<< 32));
+			fprintf(f, "%llu", inode->i_blocks +
+				(((long long) inode->osd2.linux2.l_i_blocks_hi)
+				 << 32));
 		else
-			printf("%u", inode->i_blocks);
+			fprintf(f, "%u", inode->i_blocks);
 		break;
 	case 'l':
-		printf("%d", inode->i_links_count);
+		fprintf(f, "%d", inode->i_links_count);
 		break;
 	case 'm':
-		printf("0%o", inode->i_mode);
+		fprintf(f, "0%o", inode->i_mode);
 		break;
 	case 'M':
-		print_time(inode->i_mtime);
+		print_time(f, inode->i_mtime);
 		break;
 	case 'F':
-		printf("%u", inode->i_faddr);
+		fprintf(f, "%u", inode->i_faddr);
 		break;
 	case 'f':
-		printf("%llu", ext2fs_file_acl_block(fs, inode));
+		fprintf(f, "%llu", ext2fs_file_acl_block(fs, inode));
 		break;
 	case 'd':
-		printf("%u", (LINUX_S_ISDIR(inode->i_mode) ?
-			      inode->i_dir_acl : 0));
+		fprintf(f, "%u", (LINUX_S_ISDIR(inode->i_mode) ?
+				  inode->i_dir_acl : 0));
 		break;
 	case 'u':
-		printf("%d", inode_uid(*inode));
+		fprintf(f, "%d", inode_uid(*inode));
 		break;
 	case 'g':
-		printf("%d", inode_gid(*inode));
+		fprintf(f, "%d", inode_gid(*inode));
 		break;
 	case 't':
 		if (LINUX_S_ISREG(inode->i_mode))
-			printf(_("regular file"));
+			fputs(_("regular file"), f);
 		else if (LINUX_S_ISDIR(inode->i_mode))
-			printf(_("directory"));
+			fputs(_("directory"), f);
 		else if (LINUX_S_ISCHR(inode->i_mode))
-			printf(_("character device"));
+			fputs(_("character device"), f);
 		else if (LINUX_S_ISBLK(inode->i_mode))
-			printf(_("block device"));
+			fputs(_("block device"), f);
 		else if (LINUX_S_ISFIFO(inode->i_mode))
-			printf(_("named pipe"));
+			fputs(_("named pipe"), f);
 		else if (LINUX_S_ISLNK(inode->i_mode))
-			printf(_("symbolic link"));
+			fputs(_("symbolic link"), f);
 		else if (LINUX_S_ISSOCK(inode->i_mode))
-			printf(_("socket"));
+			fputs(_("socket"), f);
 		else
-			printf(_("unknown file type with mode 0%o"),
-			       inode->i_mode);
+			fprintf(f, _("unknown file type with mode 0%o"),
+				inode->i_mode);
 		break;
 	default:
 	no_inode:
-		printf("%%I%c", ch);
+		fprintf(f, "%%I%c", ch);
 		break;
 	}
 }
@@ -356,7 +357,7 @@ static _INLINE_ void expand_inode_expression(ext2_filsys fs, char ch,
 /*
  * This function expands '%dX' expressions
  */
-static _INLINE_ void expand_dirent_expression(ext2_filsys fs, char ch,
+static _INLINE_ void expand_dirent_expression(FILE *f, ext2_filsys fs, char ch,
 					      struct problem_context *ctx)
 {
 	struct ext2_dir_entry	*dirent;
@@ -370,34 +371,34 @@ static _INLINE_ void expand_dirent_expression(ext2_filsys fs, char ch,
 
 	switch (ch) {
 	case 'i':
-		printf("%u", dirent->inode);
+		fprintf(f, "%u", dirent->inode);
 		break;
 	case 'n':
 		len = dirent->name_len & 0xFF;
 		if ((ext2fs_get_rec_len(fs, dirent, &rec_len) == 0) &&
 		    (len > rec_len))
 			len = rec_len;
-		safe_print(dirent->name, len);
+		safe_print(f, dirent->name, len);
 		break;
 	case 'r':
 		(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
-		printf("%u", rec_len);
+		fprintf(f, "%u", rec_len);
 		break;
 	case 'l':
-		printf("%u", dirent->name_len & 0xFF);
+		fprintf(f, "%u", dirent->name_len & 0xFF);
 		break;
 	case 't':
-		printf("%u", dirent->name_len >> 8);
+		fprintf(f, "%u", dirent->name_len >> 8);
 		break;
 	default:
 	no_dirent:
-		printf("%%D%c", ch);
+		fprintf(f, "%%D%c", ch);
 		break;
 	}
 }
 
-static _INLINE_ void expand_percent_expression(ext2_filsys fs, char ch,
-					       int width, int *first,
+static _INLINE_ void expand_percent_expression(FILE *f, ext2_filsys fs,
+					       char ch, int width, int *first,
 					       struct problem_context *ctx)
 {
 	e2fsck_t e2fsck_ctx = fs ? (e2fsck_t) fs->priv_data : NULL;
@@ -408,13 +409,13 @@ static _INLINE_ void expand_percent_expression(ext2_filsys fs, char ch,
 
 	switch (ch) {
 	case '%':
-		fputc('%', stdout);
+		fputc('%', f);
 		break;
 	case 'b':
 #ifdef EXT2_NO_64_TYPE
-		printf("%*u", width, (unsigned long) ctx->blk);
+		fprintf(f, "%*u", width, (unsigned long) ctx->blk);
 #else
-		printf("%*llu", width, (unsigned long long) ctx->blk);
+		fprintf(f, "%*llu", width, (unsigned long long) ctx->blk);
 #endif
 		break;
 	case 'B':
@@ -429,98 +430,98 @@ static _INLINE_ void expand_percent_expression(ext2_filsys fs, char ch,
 		else
 			m = _("block #");
 		if (*first && islower(m[0]))
-			fputc(toupper(*m++), stdout);
-		fputs(m, stdout);
+			fputc(toupper(*m++), f);
+		fputs(m, f);
 		if (ctx->blkcount >= 0) {
 #ifdef EXT2_NO_64_TYPE
-			printf("%d", ctx->blkcount);
+			fprintf(f, "%d", ctx->blkcount);
 #else
-			printf("%lld", (long long) ctx->blkcount);
+			fprintf(f, "%lld", (long long) ctx->blkcount);
 #endif
 		}
 		break;
 	case 'c':
 #ifdef EXT2_NO_64_TYPE
-		printf("%*u", width, (unsigned long) ctx->blk2);
+		fprintf(f, "%*u", width, (unsigned long) ctx->blk2);
 #else
-		printf("%*llu", width, (unsigned long long) ctx->blk2);
+		fprintf(f, "%*llu", width, (unsigned long long) ctx->blk2);
 #endif
 		break;
 	case 'd':
-		printf("%*u", width, ctx->dir);
+		fprintf(f, "%*u", width, ctx->dir);
 		break;
 	case 'g':
-		printf("%*d", width, ctx->group);
+		fprintf(f, "%*d", width, ctx->group);
 		break;
 	case 'i':
-		printf("%*u", width, ctx->ino);
+		fprintf(f, "%*u", width, ctx->ino);
 		break;
 	case 'j':
-		printf("%*u", width, ctx->ino2);
+		fprintf(f, "%*u", width, ctx->ino2);
 		break;
 	case 'm':
-		printf("%*s", width, error_message(ctx->errcode));
+		fprintf(f, "%*s", width, error_message(ctx->errcode));
 		break;
 	case 'N':
 #ifdef EXT2_NO_64_TYPE
-		printf("%*u", width, ctx->num);
+		fprintf(f, "%*u", width, ctx->num);
 #else
-		printf("%*llu", width, (long long)ctx->num);
+		fprintf(f, "%*llu", width, (long long)ctx->num);
 #endif
 		break;
 	case 'p':
-		print_pathname(fs, ctx->ino, 0);
+		print_pathname(f, fs, ctx->ino, 0);
 		break;
 	case 'P':
-		print_pathname(fs, ctx->ino2,
+		print_pathname(f, fs, ctx->ino2,
 			       ctx->dirent ? ctx->dirent->inode : 0);
 		break;
 	case 'q':
-		print_pathname(fs, ctx->dir, 0);
+		print_pathname(f, fs, ctx->dir, 0);
 		break;
 	case 'Q':
-		print_pathname(fs, ctx->dir, ctx->ino);
+		print_pathname(f, fs, ctx->dir, ctx->ino);
 		break;
 	case 'r':
 #ifdef EXT2_NO_64_TYPE
-		printf("%*d", width, ctx->blkcount);
+		fprintf(f, "%*d", width, ctx->blkcount);
 #else
-		printf("%*lld", width, (long long) ctx->blkcount);
+		fprintf(f, "%*lld", width, (long long) ctx->blkcount);
 #endif
 		break;
 	case 'S':
-		printf("%u", get_backup_sb(NULL, fs, NULL, NULL));
+		fprintf(f, "%u", get_backup_sb(NULL, fs, NULL, NULL));
 		break;
 	case 's':
-		printf("%*s", width, ctx->str ? ctx->str : "NULL");
+		fprintf(f, "%*s", width, ctx->str ? ctx->str : "NULL");
 		break;
 	case 't':
-		print_time((time_t) ctx->num);
+		print_time(f, (time_t) ctx->num);
 		break;
 	case 'T':
-		print_time(e2fsck_ctx ? e2fsck_ctx->now : time(0));
+		print_time(f, e2fsck_ctx ? e2fsck_ctx->now : time(0));
 		break;
 	case 'x':
-		printf("0x%0*x", width, ctx->csum1);
+		fprintf(f, "0x%0*x", width, ctx->csum1);
 		break;
 	case 'X':
 #ifdef EXT2_NO_64_TYPE
-		printf("0x%0*x", width, ctx->num);
+		fprintf(f, "0x%0*x", width, ctx->num);
 #else
-		printf("0x%0*llx", width, (long long)ctx->num);
+		fprintf(f, "0x%0*llx", width, (long long)ctx->num);
 #endif
 		break;
 	case 'y':
-		printf("0x%0*x", width, ctx->csum2);
+		fprintf(f, "0x%0*x", width, ctx->csum2);
 		break;
 	default:
 	no_context:
-		printf("%%%c", ch);
+		fprintf(f, "%%%c", ch);
 		break;
 	}
 }
 
-void print_e2fsck_message(e2fsck_t ctx, const char *msg,
+void print_e2fsck_message(FILE *f, e2fsck_t ctx, const char *msg,
 			  struct problem_context *pctx, int first,
 			  int recurse)
 {
@@ -532,7 +533,8 @@ void print_e2fsck_message(e2fsck_t ctx, const char *msg,
 	for (cp = msg; *cp; cp++) {
 		if (cp[0] == '@') {
 			cp++;
-			expand_at_expression(ctx, *cp, pctx, &first, recurse);
+			expand_at_expression(f, ctx, *cp, pctx, &first,
+					     recurse);
 		} else if (cp[0] == '%') {
 			cp++;
 			width = 0;
@@ -542,19 +544,19 @@ void print_e2fsck_message(e2fsck_t ctx, const char *msg,
 			}
 			if (cp[0] == 'I') {
 				cp++;
-				expand_inode_expression(fs, *cp, pctx);
+				expand_inode_expression(f, fs, *cp, pctx);
 			} else if (cp[0] == 'D') {
 				cp++;
-				expand_dirent_expression(fs, *cp, pctx);
+				expand_dirent_expression(f, fs, *cp, pctx);
 			} else {
-				expand_percent_expression(fs, *cp, width,
+				expand_percent_expression(f, fs, *cp, width,
 							  &first, pctx);
 			}
 		} else {
 			for (i=0; cp[i]; i++)
 				if ((cp[i] == '@') || cp[i] == '%')
 					break;
-			printf("%.*s", i, cp);
+			fprintf(f, "%.*s", i, cp);
 			cp += i-1;
 		}
 		first = 0;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 06eb179..56d10b1 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1877,16 +1877,20 @@ int fix_problem(e2fsck_t ctx, problem_t code, struct problem_context *pctx)
 			fflush(stdout);
 		}
 	}
+	message = ptr->e2p_description;
+	if (*message)
+		message = _(message);
 	if (!suppress) {
-		message = ptr->e2p_description;
 		if ((ctx->options & E2F_OPT_PREEN) &&
 		    !(ptr->flags & PR_PREEN_NOHDR)) {
 			printf("%s: ", ctx->device_name ?
 			       ctx->device_name : ctx->filesystem_name);
 		}
 		if (*message)
-			print_e2fsck_message(ctx, _(message), pctx, 1, 0);
+			print_e2fsck_message(stdout, ctx, message, pctx, 1, 0);
 	}
+	if (ctx->logf && message)
+		print_e2fsck_message(ctx->logf, ctx, message, pctx, 1, 0);
 	if (!(ptr->flags & PR_PREEN_OK) && (ptr->prompt != PROMPT_NONE))
 		preenhalt(ctx);
 
@@ -1901,16 +1905,14 @@ int fix_problem(e2fsck_t ctx, problem_t code, struct problem_context *pctx)
 	} else {
 		if (ptr->flags & PR_FORCE_NO) {
 			answer = 0;
-			if (!suppress)
-				print_answer = 1;
+			print_answer = 1;
 		} else if (ctx->options & E2F_OPT_PREEN) {
 			answer = def_yn;
 			if (!(ptr->flags & PR_PREEN_NOMSG))
 				print_answer = 1;
 		} else if ((ptr->flags & PR_LATCH_MASK) &&
 			   (ldesc->flags & (PRL_YES | PRL_NO))) {
-			if (!suppress)
-				print_answer = 1;
+			print_answer = 1;
 			if (ldesc->flags & PRL_YES)
 				answer = 1;
 			else
@@ -1921,10 +1923,16 @@ int fix_problem(e2fsck_t ctx, problem_t code, struct problem_context *pctx)
 		if (!answer && !(ptr->flags & PR_NO_OK))
 			ext2fs_unmark_valid(fs);
 
-		if (print_answer)
-			printf("%s.\n", answer ?
-			       _(preen_msg[(int) ptr->prompt]) : _("IGNORED"));
-
+		if (print_answer) {
+			if (!suppress)
+				printf("%s.\n", answer ?
+				       _(preen_msg[(int) ptr->prompt]) :
+				       _("IGNORED"));
+			if (ctx->logf)
+				fprintf(ctx->logf, "%s.\n", answer ?
+					_(preen_msg[(int) ptr->prompt]) :
+					_("IGNORED"));
+		}
 	}
 
 	if ((ptr->prompt == PROMPT_ABORT) && answer)
@@ -1955,7 +1963,7 @@ profile_get_integer(profile_t profile, const char *name, const char *subname,
 	return 0;
 }
 
-void print_e2fsck_message(e2fsck_t ctx, const char *msg,
+void print_e2fsck_message(FILE *f, e2fsck_t ctx, const char *msg,
 			  struct problem_context *pctx, int first,
 			  int recurse)
 {
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 5c1579d..6633055 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -1034,7 +1034,7 @@ int get_latch_flags(int mask, int *value);
 void clear_problem_context(struct problem_context *pctx);
 
 /* message.c */
-void print_e2fsck_message(e2fsck_t ctx, const char *msg,
+void print_e2fsck_message(FILE *f, e2fsck_t ctx, const char *msg,
 			  struct problem_context *pctx, int first,
 			  int recurse);
 
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index b31a1e3..4f73a4b 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -130,70 +130,76 @@ static void show_stats(e2fsck_t	ctx)
 	frag_percent_total = (frag_percent_total + 5) / 10;
 
 	if (!verbose) {
-		printf(_("%s: %u/%u files (%0d.%d%% non-contiguous), %llu/%llu blocks\n"),
-		       ctx->device_name, inodes_used, inodes,
-		       frag_percent_total / 10, frag_percent_total % 10,
-		       blocks_used, blocks);
+		log_out(ctx, _("%s: %u/%u files (%0d.%d%% non-contiguous), "
+			       "%llu/%llu blocks\n"),
+			ctx->device_name, inodes_used, inodes,
+			frag_percent_total / 10, frag_percent_total % 10,
+			blocks_used, blocks);
 		return;
 	}
-	printf (P_("\n%8u inode used (%2.2f%%)\n", "\n%8u inodes used (%2.2f%%)\n",
-		   inodes_used), inodes_used, 100.0 * inodes_used / inodes);
-	printf (P_("%8u non-contiguous file (%0d.%d%%)\n",
-		   "%8u non-contiguous files (%0d.%d%%)\n",
-		   ctx->fs_fragmented),
+	log_out(ctx, P_("\n%8u inode used (%2.2f%%)\n",
+			"\n%8u inodes used (%2.2f%%)\n",
+			inodes_used), inodes_used,
+		100.0 * inodes_used / inodes);
+	log_out(ctx, P_("%8u non-contiguous file (%0d.%d%%)\n",
+			"%8u non-contiguous files (%0d.%d%%)\n",
+			ctx->fs_fragmented),
 		ctx->fs_fragmented, frag_percent_file / 10,
 		frag_percent_file % 10);
-	printf (P_("%8u non-contiguous directory (%0d.%d%%)\n",
-		   "%8u non-contiguous directories (%0d.%d%%)\n",
-		   ctx->fs_fragmented_dir),
+	log_out(ctx, P_("%8u non-contiguous directory (%0d.%d%%)\n",
+			"%8u non-contiguous directories (%0d.%d%%)\n",
+			ctx->fs_fragmented_dir),
 		ctx->fs_fragmented_dir, frag_percent_dir / 10,
 		frag_percent_dir % 10);
-	printf (_("         # of inodes with ind/dind/tind blocks: %u/%u/%u\n"),
+	log_out(ctx, _("         # of inodes with ind/dind/tind blocks: "
+		       "%u/%u/%u\n"),
 		ctx->fs_ind_count, ctx->fs_dind_count, ctx->fs_tind_count);
 
 	for (j=MAX_EXTENT_DEPTH_COUNT-1; j >=0; j--)
 		if (ctx->extent_depth_count[j])
 			break;
 	if (++j) {
-		printf (_("         Extent depth histogram: "));
+		log_out(ctx, _("         Extent depth histogram: "));
 		for (i=0; i < j; i++) {
 			if (i)
 				fputc('/', stdout);
-			printf("%u", ctx->extent_depth_count[i]);
+			log_out(ctx, "%u", ctx->extent_depth_count[i]);
 		}
-		fputc('\n', stdout);
+		log_out(ctx, "\n");
 	}
 
-	printf (P_("%8llu block used (%2.2f%%)\n",
-		   "%8llu blocks used (%2.2f%%)\n",
+	log_out(ctx, P_("%8llu block used (%2.2f%%)\n",
+			"%8llu blocks used (%2.2f%%)\n",
 		   blocks_used), blocks_used, 100.0 * blocks_used / blocks);
-	printf (P_("%8u bad block\n", "%8u bad blocks\n",
-		   ctx->fs_badblocks_count), ctx->fs_badblocks_count);
-	printf (P_("%8u large file\n", "%8u large files\n",
-		   ctx->large_files), ctx->large_files);
-	printf (P_("\n%8u regular file\n", "\n%8u regular files\n",
-		   ctx->fs_regular_count), ctx->fs_regular_count);
-	printf (P_("%8u directory\n", "%8u directories\n",
-		   ctx->fs_directory_count), ctx->fs_directory_count);
-	printf (P_("%8u character device file\n",
-		   "%8u character device files\n", ctx->fs_chardev_count),
+	log_out(ctx, P_("%8u bad block\n", "%8u bad blocks\n",
+			ctx->fs_badblocks_count), ctx->fs_badblocks_count);
+	log_out(ctx, P_("%8u large file\n", "%8u large files\n",
+			ctx->large_files), ctx->large_files);
+	log_out(ctx, P_("\n%8u regular file\n", "\n%8u regular files\n",
+			ctx->fs_regular_count), ctx->fs_regular_count);
+	log_out(ctx, P_("%8u directory\n", "%8u directories\n",
+			ctx->fs_directory_count), ctx->fs_directory_count);
+	log_out(ctx, P_("%8u character device file\n",
+			"%8u character device files\n", ctx->fs_chardev_count),
 		ctx->fs_chardev_count);
-	printf (P_("%8u block device file\n", "%8u block device files\n",
-		   ctx->fs_blockdev_count), ctx->fs_blockdev_count);
-	printf (P_("%8u fifo\n", "%8u fifos\n", ctx->fs_fifo_count),
+	log_out(ctx, P_("%8u block device file\n", "%8u block device files\n",
+			ctx->fs_blockdev_count), ctx->fs_blockdev_count);
+	log_out(ctx, P_("%8u fifo\n", "%8u fifos\n", ctx->fs_fifo_count),
 		ctx->fs_fifo_count);
-	printf (P_("%8u link\n", "%8u links\n",
-		   ctx->fs_links_count - dir_links),
+	log_out(ctx, P_("%8u link\n", "%8u links\n",
+			ctx->fs_links_count - dir_links),
 		ctx->fs_links_count - dir_links);
-	printf (P_("%8u symbolic link", "%8u symbolic links",
-		   ctx->fs_symlinks_count), ctx->fs_symlinks_count);
-	printf (P_(" (%u fast symbolic link)\n", " (%u fast symbolic links)\n",
-		   ctx->fs_fast_symlinks_count), ctx->fs_fast_symlinks_count);
-	printf (P_("%8u socket\n", "%8u sockets\n", ctx->fs_sockets_count),
+	log_out(ctx, P_("%8u symbolic link", "%8u symbolic links",
+			ctx->fs_symlinks_count), ctx->fs_symlinks_count);
+	log_out(ctx, P_(" (%u fast symbolic link)\n",
+			" (%u fast symbolic links)\n",
+			ctx->fs_fast_symlinks_count),
+		ctx->fs_fast_symlinks_count);
+	log_out(ctx, P_("%8u socket\n", "%8u sockets\n", ctx->fs_sockets_count),
 		ctx->fs_sockets_count);
-	printf ("--------\n");
-	printf (P_("%8u file\n", "%8u files\n",
-		   ctx->fs_total_count - dir_links),
+	log_out(ctx, "--------\n");
+	log_out(ctx, P_("%8u file\n", "%8u files\n",
+			ctx->fs_total_count - dir_links),
 		ctx->fs_total_count - dir_links);
 }
 
@@ -224,19 +230,21 @@ static void check_mount(e2fsck_t ctx)
 
 	if ((ctx->options & E2F_OPT_READONLY) &&
 	    !(ctx->options & E2F_OPT_WRITECHECK)) {
-		printf(_("Warning!  %s is mounted.\n"), ctx->filesystem_name);
+		log_out(ctx, _("Warning!  %s is mounted.\n"),
+			ctx->filesystem_name);
 		return;
 	}
 
-	printf(_("%s is mounted.  "), ctx->filesystem_name);
+	log_out(ctx, _("%s is mounted.  "), ctx->filesystem_name);
 	if (!ctx->interactive)
 		fatal_error(ctx, _("Cannot continue, aborting.\n\n"));
 	puts("\007\007\007\007");
-	printf(_("\n\nWARNING!!!  "
-	       "The filesystem is mounted.   If you continue you ***WILL***\n"
-	       "cause ***SEVERE*** filesystem damage.\n\n"));
+	log_out(ctx, _("\n\nWARNING!!!  "
+		       "The filesystem is mounted.   "
+		       "If you continue you ***WILL***\n"
+		       "cause ***SEVERE*** filesystem damage.\n\n"));
 	puts("\007\007\007");
-	cont = ask_yn(_("Do you really want to continue"), 0);
+	cont = ask_yn(ctx, _("Do you really want to continue"), 0);
 	if (!cont) {
 		printf (_("check aborted.\n"));
 		exit (0);
@@ -356,9 +364,9 @@ static void check_if_skip(e2fsck_t ctx)
 			reason = 0;
 	}
 	if (reason) {
-		fputs(ctx->device_name, stdout);
-		printf(reason, reason_arg);
-		fputs(_(", check forced.\n"), stdout);
+		log_out(ctx, "%s", ctx->device_name);
+		log_out(ctx, reason, reason_arg);
+		log_out(ctx, _(", check forced.\n"));
 		return;
 	}
 
@@ -391,12 +399,13 @@ static void check_if_skip(e2fsck_t ctx)
 	}
 
 	/* Print the summary message when we're skipping a full check */
-	printf(_("%s: clean, %u/%u files, %llu/%llu blocks"), ctx->device_name,
-	       fs->super->s_inodes_count - fs->super->s_free_inodes_count,
-	       fs->super->s_inodes_count,
-	       ext2fs_blocks_count(fs->super) -
-	       ext2fs_free_blocks_count(fs->super),
-	       ext2fs_blocks_count(fs->super));
+	log_out(ctx, _("%s: clean, %u/%u files, %llu/%llu blocks"),
+		ctx->device_name,
+		fs->super->s_inodes_count - fs->super->s_free_inodes_count,
+		fs->super->s_inodes_count,
+		ext2fs_blocks_count(fs->super) -
+		ext2fs_free_blocks_count(fs->super),
+		ext2fs_blocks_count(fs->super));
 	next_check = 100000;
 	if (fs->super->s_max_mnt_count > 0) {
 		next_check = fs->super->s_max_mnt_count - fs->super->s_mnt_count;
@@ -409,14 +418,14 @@ static void check_if_skip(e2fsck_t ctx)
 	if (next_check <= 5) {
 		if (next_check == 1) {
 			if (batt)
-				fputs(_(" (check deferred; on battery)"),
-				      stdout);
+				log_out(ctx, _(" (check deferred; "
+					       "on battery)"));
 			else
-				fputs(_(" (check after next mount)"), stdout);
+				log_out(ctx, _(" (check after next mount)"));
 		} else
-			printf(_(" (check in %ld mounts)"), next_check);
+			log_out(ctx, _(" (check in %ld mounts)"), next_check);
 	}
-	fputc('\n', stdout);
+	log_out(ctx, "\n");
 skip:
 	ext2fs_close(fs);
 	ctx->fs = NULL;
@@ -653,6 +662,12 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 		} else if (strcmp(token, "nodiscard") == 0) {
 			ctx->options &= ~E2F_OPT_DISCARD;
 			continue;
+		} else if (strcmp(token, "log_filename") == 0) {
+			if (!arg)
+				extended_usage++;
+			else
+				ctx->log_fn = string_copy(ctx, arg, 0);
+			continue;
 		} else {
 			fprintf(stderr, _("Unknown extended option: %s\n"),
 				token);
@@ -1071,8 +1086,8 @@ int e2fsck_check_mmp(ext2_filsys fs, e2fsck_t ctx)
 
 	/* Print warning if e2fck will wait for more than 20 secs. */
 	if (verbose || wait_time > EXT4_MMP_MIN_CHECK_INTERVAL * 4) {
-		printf("MMP interval is %u seconds and total wait time is %u "
-		       "seconds. Please wait...\n",
+		log_out(ctx, _("MMP interval is %u seconds and total wait "
+			       "time is %u seconds. Please wait...\n"),
 			mmp_check_interval, wait_time * 2);
 	}
 
@@ -1157,13 +1172,25 @@ int main (int argc, char *argv[])
 	}
 	reserve_stdio_fds();
 
+	set_up_logging(ctx);
+	if (ctx->logf) {
+		int i;
+		fputs("E2fsck run: ", ctx->logf);
+		for (i = 0; i < argc; i++) {
+			if (i)
+				fputc(' ', ctx->logf);
+			fputs(argv[i], ctx->logf);
+		}
+		fputc('\n', ctx->logf);
+	}
+
 	init_resource_track(&ctx->global_rtrack, NULL);
 	if (!(ctx->options & E2F_OPT_PREEN) || show_version_only)
-		fprintf(stderr, "e2fsck %s (%s)\n", my_ver_string,
+		log_err(ctx, "e2fsck %s (%s)\n", my_ver_string,
 			 my_ver_date);
 
 	if (show_version_only) {
-		fprintf(stderr, _("\tUsing %s, %s\n"),
+		log_err(ctx, _("\tUsing %s, %s\n"),
 			error_message(EXT2_ET_BASE), lib_ver_date);
 		exit(FSCK_OK);
 	}
@@ -1214,10 +1241,10 @@ restart:
 			fs = NULL;
 		}
 		if (!fs || (fs->group_desc_count > 1)) {
-			printf(_("%s: %s trying backup blocks...\n"),
-			       ctx->program_name,
-			       retval ? _("Superblock invalid,") :
-			       _("Group descriptors look bad..."));
+			log_out(ctx, _("%s: %s trying backup blocks...\n"),
+				ctx->program_name,
+				retval ? _("Superblock invalid,") :
+				_("Group descriptors look bad..."));
 			orig_superblock = ctx->superblock;
 			get_backup_sb(ctx, fs, ctx->filesystem_name, io_ptr);
 			if (fs)
@@ -1227,10 +1254,13 @@ restart:
 			if ((orig_retval == 0) && retval != 0) {
 				if (fs)
 					ext2fs_close(fs);
-				com_err(ctx->program_name, retval,
-					"when using the backup blocks");
-				printf(_("%s: going back to original "
-					 "superblock\n"), ctx->program_name);
+				log_out(ctx, _("%s: %s while using the "
+					       "backup blocks"),
+					ctx->program_name,
+					error_message(retval));
+				log_out(ctx, _("%s: going back to original "
+					       "superblock\n"),
+					ctx->program_name);
 				ctx->superblock = orig_superblock;
 				retval = try_open_fs(ctx, flags, io_ptr, &fs);
 			}
@@ -1256,30 +1286,32 @@ failure:
 		com_err(ctx->program_name, retval, _("while trying to open %s"),
 			ctx->filesystem_name);
 		if (retval == EXT2_ET_REV_TOO_HIGH) {
-			printf(_("The filesystem revision is apparently "
+			log_out(ctx, _("The filesystem revision is apparently "
 			       "too high for this version of e2fsck.\n"
 			       "(Or the filesystem superblock "
 			       "is corrupt)\n\n"));
 			fix_problem(ctx, PR_0_SB_CORRUPT, &pctx);
 		} else if (retval == EXT2_ET_SHORT_READ)
-			printf(_("Could this be a zero-length partition?\n"));
+			log_out(ctx, _("Could this be a zero-length "
+				       "partition?\n"));
 		else if ((retval == EPERM) || (retval == EACCES))
-			printf(_("You must have %s access to the "
+			log_out(ctx, _("You must have %s access to the "
 			       "filesystem or be root\n"),
 			       (ctx->options & E2F_OPT_READONLY) ?
 			       "r/o" : "r/w");
 		else if (retval == ENXIO)
-			printf(_("Possibly non-existent or swap device?\n"));
+			log_out(ctx, _("Possibly non-existent or "
+				       "swap device?\n"));
 		else if (retval == EBUSY)
-			printf(_("Filesystem mounted or opened exclusively "
-				 "by another program?\n"));
+			log_out(ctx, _("Filesystem mounted or opened "
+				 "exclusively by another program?\n"));
 		else if (retval == ENOENT)
-			printf(_("Possibly non-existent device?\n"));
+			log_out(ctx, _("Possibly non-existent device?\n"));
 #ifdef EROFS
 		else if (retval == EROFS)
-			printf(_("Disk write-protected; use the -n option "
-			       "to do a read-only\n"
-			       "check of the device.\n"));
+			log_out(ctx, _("Disk write-protected; use the -n "
+				       "option to do a read-only\n"
+				       "check of the device.\n"));
 #endif
 		else
 			fix_problem(ctx, PR_0_SB_CORRUPT, &pctx);
@@ -1336,6 +1368,7 @@ failure:
 	fs->priv_data = ctx;
 	fs->now = ctx->now;
 	sb = fs->super;
+
 	if (sb->s_rev_level > E2FSCK_CURRENT_REV) {
 		com_err(ctx->program_name, EXT2_ET_REV_TOO_HIGH,
 			_("while trying to open %s"),
@@ -1377,6 +1410,10 @@ failure:
 		goto restart;
 	}
 
+	if (ctx->logf)
+		fprintf(ctx->logf, "Filesystem UUID: %s\n",
+			e2p_uuid2str(sb->s_uuid));
+
 	if ((ctx->mount_flags & EXT2_MF_MOUNTED) &&
 	    !(sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER))
 		goto skip_journal;
@@ -1398,9 +1435,9 @@ failure:
 	 */
 	if (sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER) {
 		if (ctx->options & E2F_OPT_READONLY) {
-			printf(_("Warning: skipping journal recovery "
-				 "because doing a read-only filesystem "
-				 "check.\n"));
+			log_out(ctx, _("Warning: skipping journal recovery "
+				       "because doing a read-only filesystem "
+				       "check.\n"));
 			io_channel_flush(ctx->fs->io);
 		} else {
 			if (ctx->flags & E2F_FLAG_RESTARTED) {
@@ -1442,30 +1479,30 @@ print_unsupp_features:
 		int	i, j;
 		__u32	*mask = features, m;
 
-		fprintf(stderr, _("%s has unsupported feature(s):"),
+		log_err(ctx, _("%s has unsupported feature(s):"),
 			ctx->filesystem_name);
 
 		for (i=0; i <3; i++,mask++) {
 			for (j=0,m=1; j < 32; j++, m<<=1) {
 				if (*mask & m)
-					fprintf(stderr, " %s",
+					log_err(ctx, " %s",
 						e2p_feature2string(i, m));
 			}
 		}
-		putc('\n', stderr);
+		log_err(ctx, "\n");
 		goto get_newer;
 	}
 #ifdef ENABLE_COMPRESSION
 	if (sb->s_feature_incompat & EXT2_FEATURE_INCOMPAT_COMPRESSION)
-		com_err(ctx->program_name, 0,
-			_("Warning: compression support is experimental.\n"));
+		log_err(ctx, _("%s: warning: compression support "
+			       "is experimental.\n"),
+			ctx->program_name);
 #endif
 #ifndef ENABLE_HTREE
 	if (sb->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX) {
-		com_err(ctx->program_name, 0,
-			_("E2fsck not compiled with HTREE support,\n\t"
+		log_err(ctx, _("%s: e2fsck not compiled with HTREE support,\n\t"
 			  "but filesystem %s has HTREE directories.\n"),
-			ctx->device_name);
+			ctx->program_name, ctx->device_name);
 		goto get_newer;
 	}
 #endif
@@ -1515,11 +1552,11 @@ print_unsupp_features:
 
 	retval = ext2fs_read_bb_inode(fs, &fs->badblocks);
 	if (retval) {
-		com_err(ctx->program_name, retval,
-			_("while reading bad blocks inode"));
+		log_out(ctx, _("%s: %s while reading bad blocks inode\n"),
+			ctx->program_name, error_message(retval));
 		preenhalt(ctx);
-		printf(_("This doesn't bode well,"
-			 " but we'll try to go on...\n"));
+		log_out(ctx, _("This doesn't bode well, "
+			       "but we'll try to go on...\n"));
 	}
 
 	/*
@@ -1556,22 +1593,22 @@ print_unsupp_features:
 				fs->super->s_feature_compat &=
 					~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 				fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
-				com_err(ctx->program_name, 0,
-					_("Couldn't determine journal size"));
+				log_out(ctx, "%s: Couldn't determine "
+					"journal size\n", ctx->program_name);
 				goto no_journal;
 			}
-			printf(_("Creating journal (%d blocks): "),
+			log_out(ctx, _("Creating journal (%d blocks): "),
 			       journal_size);
 			fflush(stdout);
 			retval = ext2fs_add_journal_inode(fs,
 							  journal_size, 0);
 			if (retval) {
-				com_err("Error ", retval,
-					_("\n\twhile trying to create journal"));
+				log_out(ctx, "%s: while trying to create "
+					"journal\n", error_message(retval));
 				goto no_journal;
 			}
-			printf(_(" Done.\n"));
-			printf(_("\n*** journal has been re-created - "
+			log_out(ctx, _(" Done.\n"));
+			log_out(ctx, _("\n*** journal has been re-created - "
 				       "filesystem is now ext3 again ***\n"));
 		}
 	}
@@ -1583,7 +1620,7 @@ no_journal:
 	}
 
 	if (run_result == E2F_FLAG_RESTART) {
-		printf(_("Restarting e2fsck from the beginning...\n"));
+		log_out(ctx, _("Restarting e2fsck from the beginning...\n"));
 		retval = e2fsck_reset_context(ctx);
 		if (retval) {
 			com_err(ctx->program_name, retval,
@@ -1594,8 +1631,8 @@ no_journal:
 		goto restart;
 	}
 	if (run_result & E2F_FLAG_CANCEL) {
-		printf(_("%s: e2fsck canceled.\n"), ctx->device_name ?
-		       ctx->device_name : ctx->filesystem_name);
+		log_out(ctx, _("%s: e2fsck canceled.\n"), ctx->device_name ?
+			ctx->device_name : ctx->filesystem_name);
 		exit_value |= FSCK_CANCELED;
 	}
 	if (run_result & E2F_FLAG_ABORT)
@@ -1611,19 +1648,20 @@ no_journal:
 	if (ext2fs_test_changed(fs)) {
 		exit_value |= FSCK_NONDESTRUCT;
 		if (!(ctx->options & E2F_OPT_PREEN))
-		    printf(_("\n%s: ***** FILE SYSTEM WAS MODIFIED *****\n"),
-			       ctx->device_name);
+			log_out(ctx, _("\n%s: ***** FILE SYSTEM WAS "
+				       "MODIFIED *****\n"),
+				ctx->device_name);
 		if (ctx->mount_flags & EXT2_MF_ISROOT) {
-			printf(_("%s: ***** REBOOT LINUX *****\n"),
-			       ctx->device_name);
+			log_out(ctx, _("%s: ***** REBOOT LINUX *****\n"),
+				ctx->device_name);
 			exit_value |= FSCK_REBOOT;
 		}
 	}
 	if (!ext2fs_test_valid(fs) ||
 	    ((exit_value & FSCK_CANCELED) &&
 	     (sb->s_state & EXT2_ERROR_FS))) {
-		printf(_("\n%s: ********** WARNING: Filesystem still has "
-			 "errors **********\n\n"), ctx->device_name);
+		log_out(ctx, _("\n%s: ********** WARNING: Filesystem still has "
+			       "errors **********\n\n"), ctx->device_name);
 		exit_value |= FSCK_UNCORRECTED;
 		exit_value &= ~FSCK_NONDESTRUCT;
 	}
diff --git a/e2fsck/util.c b/e2fsck/util.c
index 6e3a1dc..7c4caab 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -41,6 +41,7 @@
 
 extern e2fsck_t e2fsck_global_ctx;   /* Try your very best not to use this! */
 
+#include <stdarg.h>
 #include <time.h>
 #include <sys/time.h>
 #include <sys/resource.h>
@@ -59,18 +60,18 @@ void fatal_error(e2fsck_t ctx, const char *msg)
 		if (ctx->fs->io->magic == EXT2_ET_MAGIC_IO_CHANNEL)
 			io_channel_flush(ctx->fs->io);
 		else
-			fprintf(stderr, "e2fsck: io manager magic bad!\n");
+			log_err(ctx, "e2fsck: io manager magic bad!\n");
 	}
 	if (ext2fs_test_changed(fs)) {
 		exit_value |= FSCK_NONDESTRUCT;
-		printf(_("\n%s: ***** FILE SYSTEM WAS MODIFIED *****\n"),
+		log_out(ctx, _("\n%s: ***** FILE SYSTEM WAS MODIFIED *****\n"),
 			ctx->device_name);
 		if (ctx->mount_flags & EXT2_MF_ISROOT)
 			exit_value |= FSCK_REBOOT;
 	}
 	if (!ext2fs_test_valid(fs)) {
-		printf(_("\n%s: ********** WARNING: Filesystem still has "
-			 "errors **********\n\n"), ctx->device_name);
+		log_out(ctx, _("\n%s: ********** WARNING: Filesystem still has "
+			       "errors **********\n\n"), ctx->device_name);
 		exit_value |= FSCK_UNCORRECTED;
 		exit_value &= ~FSCK_NONDESTRUCT;
 	}
@@ -81,6 +82,34 @@ out:
 	exit(exit_value);
 }
 
+void log_out(e2fsck_t ctx, const char *fmt, ...)
+{
+	va_list pvar;
+
+	va_start(pvar, fmt);
+	vprintf(fmt, pvar);
+	va_end(pvar);
+	if (ctx->logf) {
+		va_start(pvar, fmt);
+		vfprintf(ctx->logf, fmt, pvar);
+		va_end(pvar);
+	}
+}
+
+void log_err(e2fsck_t ctx, const char *fmt, ...)
+{
+	va_list pvar;
+
+	va_start(pvar, fmt);
+	vfprintf(stderr, fmt, pvar);
+	va_end(pvar);
+	if (ctx->logf) {
+		va_start(pvar, fmt);
+		vfprintf(ctx->logf, fmt, pvar);
+		va_end(pvar);
+	}
+}
+
 void *e2fsck_allocate_memory(e2fsck_t ctx, unsigned int size,
 			     const char *description)
 {
@@ -153,7 +182,7 @@ static int read_a_char(void)
 }
 #endif
 
-int ask_yn(const char * string, int def)
+int ask_yn(e2fsck_t ctx, const char * string, int def)
 {
 	int		c;
 	const char	*defstr;
@@ -177,7 +206,7 @@ int ask_yn(const char * string, int def)
 		defstr = _(_("<n>"));
 	else
 		defstr = _(" (y/n)");
-	printf("%s%s? ", string, defstr);
+	log_out(ctx, "%s%s? ", string, defstr);
 	while (1) {
 		fflush (stdout);
 		if ((c = read_a_char()) == EOF)
@@ -186,12 +215,11 @@ int ask_yn(const char * string, int def)
 #ifdef HAVE_TERMIOS_H
 			tcsetattr (0, TCSANOW, &termios);
 #endif
-			if (e2fsck_global_ctx &&
-			    e2fsck_global_ctx->flags & E2F_FLAG_SETJMP_OK) {
-				puts("\n");
+			if (ctx->flags & E2F_FLAG_SETJMP_OK) {
+				log_out(ctx, "\n");
 				longjmp(e2fsck_global_ctx->abort_loc, 1);
 			}
-			puts(_("cancelled!\n"));
+			log_out(ctx, _("cancelled!\n"));
 			return 0;
 		}
 		if (strchr(short_yes, (char) c)) {
@@ -206,9 +234,9 @@ int ask_yn(const char * string, int def)
 			break;
 	}
 	if (def)
-		puts(_("yes\n"));
+		log_out(ctx, _("yes\n"));
 	else
-		puts (_("no\n"));
+		log_out(ctx, _("no\n"));
 #ifdef HAVE_TERMIOS_H
 	tcsetattr (0, TCSANOW, &termios);
 #endif
@@ -218,18 +246,18 @@ int ask_yn(const char * string, int def)
 int ask (e2fsck_t ctx, const char * string, int def)
 {
 	if (ctx->options & E2F_OPT_NO) {
-		printf (_("%s? no\n\n"), string);
+		log_out(ctx, _("%s? no\n\n"), string);
 		return 0;
 	}
 	if (ctx->options & E2F_OPT_YES) {
-		printf (_("%s? yes\n\n"), string);
+		log_out(ctx, _("%s? yes\n\n"), string);
 		return 1;
 	}
 	if (ctx->options & E2F_OPT_PREEN) {
-		printf ("%s? %s\n\n", string, def ? _("yes") : _("no"));
+		log_out(ctx, "%s? %s\n\n", string, def ? _("yes") : _("no"));
 		return def;
 	}
-	return ask_yn(string, def);
+	return ask_yn(ctx, string, def);
 }
 
 void e2fsck_read_bitmaps(e2fsck_t ctx)
@@ -283,7 +311,7 @@ void preenhalt(e2fsck_t ctx)
 
 	if (!(ctx->options & E2F_OPT_PREEN))
 		return;
-	fprintf(stderr, _("\n\n%s: UNEXPECTED INCONSISTENCY; "
+	log_err(ctx, _("\n\n%s: UNEXPECTED INCONSISTENCY; "
 		"RUN fsck MANUALLY.\n\t(i.e., without -a or -p options)\n"),
 	       ctx->device_name);
 	ctx->flags |= E2F_FLAG_EXITING;
@@ -358,30 +386,30 @@ void print_resource_track(e2fsck_t ctx, const char *desc,
 	gettimeofday(&time_end, 0);
 
 	if (desc)
-		printf("%s: ", desc);
+		log_out(ctx, "%s: ", desc);
 
 #ifdef HAVE_MALLINFO
 #define kbytes(x)	(((unsigned long)(x) + 1023) / 1024)
 
 	malloc_info = mallinfo();
-	printf(_("Memory used: %luk/%luk (%luk/%luk), "),
-	       kbytes(malloc_info.arena), kbytes(malloc_info.hblkhd),
-	       kbytes(malloc_info.uordblks), kbytes(malloc_info.fordblks));
+	log_out(ctx, _("Memory used: %luk/%luk (%luk/%luk), "),
+		kbytes(malloc_info.arena), kbytes(malloc_info.hblkhd),
+		kbytes(malloc_info.uordblks), kbytes(malloc_info.fordblks));
 #else
-	printf(_("Memory used: %lu, "),
-	       (unsigned long) (((char *) sbrk(0)) - 
-				((char *) track->brk_start)));
+	log_out(ctx, _("Memory used: %lu, "),
+		(unsigned long) (((char *) sbrk(0)) -
+				 ((char *) track->brk_start)));
 #endif
 #ifdef HAVE_GETRUSAGE
 	getrusage(RUSAGE_SELF, &r);
 
-	printf(_("time: %5.2f/%5.2f/%5.2f\n"),
-	       timeval_subtract(&time_end, &track->time_start),
-	       timeval_subtract(&r.ru_utime, &track->user_start),
-	       timeval_subtract(&r.ru_stime, &track->system_start));
+	log_out(ctx, _("time: %5.2f/%5.2f/%5.2f\n"),
+		timeval_subtract(&time_end, &track->time_start),
+		timeval_subtract(&r.ru_utime, &track->user_start),
+		timeval_subtract(&r.ru_stime, &track->system_start));
 #else
-	printf(_("elapsed time: %6.3f\n"),
-	       timeval_subtract(&time_end, &track->time_start));
+	log_out(ctx, _("elapsed time: %6.3f\n"),
+		timeval_subtract(&time_end, &track->time_start));
 #endif
 #define mbytes(x)	(((x) + 1048575) / 1048576)
 	if (channel && channel->manager && channel->manager->get_stats) {
@@ -390,7 +418,7 @@ void print_resource_track(e2fsck_t ctx, const char *desc,
 		unsigned long long bytes_written = 0;
 
 		if (desc)
-			printf("%s: ", desc);
+			log_out(ctx, "%s: ", desc);
 
 		channel->manager->get_stats(channel, &delta);
 		if (delta) {
@@ -398,10 +426,11 @@ void print_resource_track(e2fsck_t ctx, const char *desc,
 			bytes_written = delta->bytes_written -
 				track->bytes_written;
 		}
-		printf("I/O read: %lluMB, write: %lluMB, rate: %.2fMB/s\n",
-		       mbytes(bytes_read), mbytes(bytes_written),
-		       (double)mbytes(bytes_read + bytes_written) /
-		       timeval_subtract(&time_end, &track->time_start));
+		log_out(ctx, "I/O read: %lluMB, write: %lluMB, "
+			"rate: %.2fMB/s\n",
+			mbytes(bytes_read), mbytes(bytes_written),
+			(double)mbytes(bytes_read + bytes_written) /
+			timeval_subtract(&time_end, &track->time_start));
 	}
 }
 #endif /* RESOURCE_TRACK */
-- 
1.7.9.107.g97f9a

