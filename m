From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/9] quota: integrate mkquota.h into quotaio.h
Date: Sun, 11 May 2014 00:32:49 -0400
Message-ID: <1399782773-20029-6-git-send-email-tytso@mit.edu>
References: <1399782773-20029-1-git-send-email-tytso@mit.edu>
Cc: adityakali@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60786 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbaEKEdG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 May 2014 00:33:06 -0400
In-Reply-To: <1399782773-20029-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are interfaces that are used by mke2fs.c and tune2fs.c which are
in quotaio.h, and some future changes will be much simpler if we can
combine the two header files together.  Also the guard #ifdef for
mkquota.h was incorrect, which caused problems when both header files
needed to be included.

Also remove quota.pc and installation rules for libquota, since this
library is never going to be something that we can export externally
anyway.  Eventually we'll want to clean up the interfaces and move the
external publishable interfaces to the libext2fs library, and then
rename what's left from libquota.a to libsupport.a for internal use
only.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: adityakali@google.com
---
 debian/rules          |   4 --
 e2fsck/Makefile.in    | 186 ++++++++++++++++++++++----------------------------
 e2fsck/e2fsck.h       |   2 +-
 e2fsck/quota.c        |   1 -
 lib/quota/Makefile.in |  59 ++++------------
 lib/quota/mkquota.c   |   1 -
 lib/quota/mkquota.h   |  64 -----------------
 lib/quota/quota.pc.in |  11 ---
 lib/quota/quotaio.h   |  56 +++++++++++++++
 misc/Makefile.in      |  14 ++--
 misc/mke2fs.c         |   2 +-
 misc/tune2fs.c        |   2 +-
 12 files changed, 160 insertions(+), 242 deletions(-)
 delete mode 100644 lib/quota/mkquota.h
 delete mode 100644 lib/quota/quota.pc.in

diff --git a/debian/rules b/debian/rules
index 2f722aa..7e8d01d 100755
--- a/debian/rules
+++ b/debian/rules
@@ -425,10 +425,6 @@ ifneq ($(BUILD_E2FSCK_STATIC),no)
 	cp ${mandir}/man8/e2fsck.8 ${mandir}/man8/e2fsck.static.8
 endif
 
-  # remove static quota library for now
-	rm ${tmpdir}/usr/include/quota/mkquota.h
-	find ${tmpdir} -name quota.pc -o -name libquota.a | xargs rm
-
 ifeq ($(DEB_BUILD_GNU_SYSTEM), gnu) 
 	${INSTALL} -m 0644 misc/mke2fs-hurd.conf ${tmpdir}/etc/mke2fs.conf
 endif
diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 77017ef..4b10f6f 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -297,10 +297,9 @@ e2fsck.o: $(srcdir)/e2fsck.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(srcdir)/problem.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/problem.h
 crc32.o: $(srcdir)/crc32.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -308,10 +307,9 @@ crc32.o: $(srcdir)/crc32.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(srcdir)/crc32defs.h crc32table.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/crc32defs.h crc32table.h
 gen_crc32table.o: $(srcdir)/gen_crc32table.c $(srcdir)/crc32defs.h
 dict.o: $(srcdir)/dict.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/dict.h
@@ -322,10 +320,9 @@ super.o: $(srcdir)/super.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(srcdir)/problem.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/problem.h
 pass1.o: $(srcdir)/pass1.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -333,10 +330,9 @@ pass1.o: $(srcdir)/pass1.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(srcdir)/problem.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/problem.h
 pass1b.o: $(srcdir)/pass1b.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
@@ -344,10 +340,9 @@ pass1b.o: $(srcdir)/pass1b.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(srcdir)/problem.h $(srcdir)/dict.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/problem.h $(srcdir)/dict.h
 pass2.o: $(srcdir)/pass2.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -355,10 +350,9 @@ pass2.o: $(srcdir)/pass2.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(srcdir)/problem.h $(srcdir)/dict.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/problem.h $(srcdir)/dict.h
 pass3.o: $(srcdir)/pass3.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -366,10 +360,9 @@ pass3.o: $(srcdir)/pass3.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(srcdir)/problem.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/problem.h
 pass4.o: $(srcdir)/pass4.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -377,10 +370,9 @@ pass4.o: $(srcdir)/pass4.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(srcdir)/problem.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/problem.h
 pass5.o: $(srcdir)/pass5.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -388,10 +380,9 @@ pass5.o: $(srcdir)/pass5.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(srcdir)/problem.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/problem.h
 journal.o: $(srcdir)/journal.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/jfs_user.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -399,11 +390,11 @@ journal.o: $(srcdir)/journal.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(top_srcdir)/lib/ext2fs/kernel-jbd.h $(top_srcdir)/lib/ext2fs/jfs_compat.h \
- $(top_srcdir)/lib/ext2fs/kernel-list.h $(srcdir)/problem.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(top_srcdir)/lib/ext2fs/kernel-jbd.h \
+ $(top_srcdir)/lib/ext2fs/jfs_compat.h $(top_srcdir)/lib/ext2fs/kernel-list.h \
+ $(srcdir)/problem.h
 recovery.o: $(srcdir)/recovery.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/jfs_user.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -411,11 +402,10 @@ recovery.o: $(srcdir)/recovery.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(top_srcdir)/lib/ext2fs/kernel-jbd.h $(top_srcdir)/lib/ext2fs/jfs_compat.h \
- $(top_srcdir)/lib/ext2fs/kernel-list.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(top_srcdir)/lib/ext2fs/kernel-jbd.h \
+ $(top_srcdir)/lib/ext2fs/jfs_compat.h $(top_srcdir)/lib/ext2fs/kernel-list.h
 revoke.o: $(srcdir)/revoke.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/jfs_user.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -423,11 +413,10 @@ revoke.o: $(srcdir)/revoke.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(top_srcdir)/lib/ext2fs/kernel-jbd.h $(top_srcdir)/lib/ext2fs/jfs_compat.h \
- $(top_srcdir)/lib/ext2fs/kernel-list.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(top_srcdir)/lib/ext2fs/kernel-jbd.h \
+ $(top_srcdir)/lib/ext2fs/jfs_compat.h $(top_srcdir)/lib/ext2fs/kernel-list.h
 badblocks.o: $(srcdir)/badblocks.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
@@ -435,9 +424,9 @@ badblocks.o: $(srcdir)/badblocks.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h
 util.o: $(srcdir)/util.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -445,9 +434,9 @@ util.o: $(srcdir)/util.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h
 unix.o: $(srcdir)/unix.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/e2p/e2p.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -455,10 +444,10 @@ unix.o: $(srcdir)/unix.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(srcdir)/problem.h $(top_srcdir)/version.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/problem.h \
+ $(top_srcdir)/version.h
 dirinfo.o: $(srcdir)/dirinfo.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -466,10 +455,9 @@ dirinfo.o: $(srcdir)/dirinfo.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(top_srcdir)/lib/ext2fs/tdb.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(top_srcdir)/lib/ext2fs/tdb.h
 dx_dirinfo.o: $(srcdir)/dx_dirinfo.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -477,9 +465,9 @@ dx_dirinfo.o: $(srcdir)/dx_dirinfo.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h
 ehandler.o: $(srcdir)/ehandler.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -487,9 +475,9 @@ ehandler.o: $(srcdir)/ehandler.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h
 problem.o: $(srcdir)/problem.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -497,10 +485,9 @@ problem.o: $(srcdir)/problem.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(srcdir)/problem.h $(srcdir)/problemP.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/problem.h $(srcdir)/problemP.h
 message.o: $(srcdir)/message.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -508,10 +495,9 @@ message.o: $(srcdir)/message.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(srcdir)/problem.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/problem.h
 ea_refcount.o: $(srcdir)/ea_refcount.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -519,9 +505,9 @@ ea_refcount.o: $(srcdir)/ea_refcount.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h
 rehash.o: $(srcdir)/rehash.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -529,10 +515,9 @@ rehash.o: $(srcdir)/rehash.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(srcdir)/problem.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/problem.h
 region.o: $(srcdir)/region.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -540,9 +525,9 @@ region.o: $(srcdir)/region.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h
 profile.o: $(srcdir)/profile.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/profile.h prof_err.h
@@ -553,9 +538,9 @@ sigcatcher.o: $(srcdir)/sigcatcher.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h
 logfile.o: $(srcdir)/logfile.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -563,18 +548,7 @@ logfile.o: $(srcdir)/logfile.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+ $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h
 prof_err.o: prof_err.c
-quota.o: $(srcdir)/quota.c $(top_builddir)/lib/config.h \
- $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
- $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
- $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
- $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
- $(top_builddir)/lib/ext2fs/ext2_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/profile.h prof_err.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(srcdir)/problem.h $(top_srcdir)/lib/quota/quotaio.h
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 8fc9993..c71a0a5 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -67,7 +67,7 @@
 #define E2FSCK_ATTR(x)
 #endif
 
-#include "quota/mkquota.h"
+#include "quota/quotaio.h"
 
 /*
  * Exit codes used by fsck-type programs
diff --git a/e2fsck/quota.c b/e2fsck/quota.c
index 42569bb..c6bbb9a 100644
--- a/e2fsck/quota.c
+++ b/e2fsck/quota.c
@@ -15,7 +15,6 @@
 
 #include "e2fsck.h"
 #include "problem.h"
-#include "quota/mkquota.h"
 #include "quota/quotaio.h"
 
 static void move_quota_inode(ext2_filsys fs, ext2_ino_t from_ino,
diff --git a/lib/quota/Makefile.in b/lib/quota/Makefile.in
index dc3eae0..92df268 100644
--- a/lib/quota/Makefile.in
+++ b/lib/quota/Makefile.in
@@ -12,9 +12,6 @@ INSTALL = @INSTALL@
 
 all::
 
-SMANPAGES=
-
-
 OBJS=		mkquota.o quotaio.o quotaio_v2.o quotaio_tree.o dict.o
 
 SRCS=		$(srcdir)/mkquota.c \
@@ -53,12 +50,6 @@ LIBDIR= quota
 #ELF_CMT#	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
 #BSDLIB_CMT#	$(Q) $(CC) $(ALL_CFLAGS) $(BSDLIB_PIC_FLAG) -o pic/$*.o -c $<
 
-all:: $(SMANPAGES) quota.pc
-
-quota.pc: $(srcdir)/quota.pc.in $(top_builddir)/config.status
-	$(E) "	CONFIG.STATUS $@"
-	$(Q) cd $(top_builddir); CONFIG_FILES=lib/quota/quota.pc ./config.status
-
 dict.o:
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $(top_srcdir)/e2fsck/dict.c -o $@
@@ -72,32 +63,10 @@ dict.o:
 #BSDLIB_CMT#	$(top_srcdir)/e2fsck/dict.c
 
 installdirs::
-	$(E) "	MKINSTALLDIRS $(libdir) $(includedir)/quota $(man3dir)"
-	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(libdir)  \
-		$(DESTDIR)$(includedir)/quota $(DESTDIR)$(man3dir) \
-		$(DESTDIR)$(pkgconfigdir)
-
-install:: all installdirs
-	$(E) "	INSTALL_DATA $(libdir)/libquota.a"
-	$(Q) $(INSTALL_DATA) libquota.a $(DESTDIR)$(libdir)/libquota.a
-	-$(Q) $(RANLIB) $(DESTDIR)$(libdir)/libquota.a
-	$(Q) $(CHMOD) $(LIBMODE) $(DESTDIR)$(libdir)/libquota.a
-	$(E) "	INSTALL_DATA $(includedir)/quota/mkquota.h"
-	$(Q) $(INSTALL_DATA) $(srcdir)/mkquota.h $(DESTDIR)$(includedir)/quota/mkquota.h
-	$(Q) for i in $(SMANPAGES); do \
-		$(RM) -f $(DESTDIR)$(man3dir)/$$i.gz; \
-		echo "	INSTALL_DATA $(man3dir)/$$i"; \
-		$(INSTALL_DATA) $$i $(DESTDIR)$(man3dir)/$$i; \
-	done
-	$(E) "	INSTALL_DATA $(pkgconfigdir)/quota.pc"
-	$(Q) $(INSTALL_DATA) quota.pc $(DESTDIR)$(pkgconfigdir)/quota.pc
+
+install:: all
 
 uninstall::
-	$(RM) -f $(DESTDIR)$(libdir)/libquota.a \
-		$(DESTDIR)$(pkgconfigdir)/quota.pc
-	for i in $(SMANPAGES); do \
-		$(RM) -f $(DESTDIR)$(man3dir)/$$i; \
-	done
 
 clean::
 	$(RM) -f \#* *.s *.o *.a *~ *.bak core profiled/* checker/*
@@ -108,7 +77,7 @@ clean::
 
 mostlyclean:: clean
 distclean:: clean
-	$(RM) -f .depend Makefile quota.pc \
+	$(RM) -f .depend Makefile \
 		$(srcdir)/TAGS $(srcdir)/Makefile.in.old
 
 #
@@ -132,33 +101,35 @@ mkquota.o: $(srcdir)/mkquota.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(top_srcdir)/lib/e2p/e2p.h $(srcdir)/quotaio.h $(srcdir)/dqblk_v2.h \
- $(srcdir)/quotaio_tree.h $(srcdir)/quotaio_v2.h $(srcdir)/mkquota.h \
- $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/common.h
+ $(srcdir)/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
+ $(srcdir)/quotaio_v2.h $(srcdir)/common.h
 quotaio.o: $(srcdir)/quotaio.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/common.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/quotaio.h \
- $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
  $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/dqblk_v2.h $(srcdir)/quotaio_tree.h
+ $(srcdir)/dqblk_v2.h $(srcdir)/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h
 quotaio_tree.o: $(srcdir)/quotaio_tree.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/common.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/quotaio_tree.h \
- $(srcdir)/quotaio.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
- $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(srcdir)/quotaio.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/dqblk_v2.h
+ $(srcdir)/dqblk_v2.h $(top_srcdir)/lib/../e2fsck/dict.h
 quotaio_v2.o: $(srcdir)/quotaio_v2.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/common.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/quotaio_v2.h \
- $(srcdir)/quotaio.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
- $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(srcdir)/quotaio.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(srcdir)/dqblk_v2.h $(srcdir)/quotaio_tree.h
+ $(srcdir)/dqblk_v2.h $(srcdir)/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h
 dict.o: $(srcdir)/../../e2fsck/dict.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/../../e2fsck/dict.h
diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index ed10890..bb8482b 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -18,7 +18,6 @@
 #include "quotaio.h"
 #include "quotaio_v2.h"
 #include "quotaio_tree.h"
-#include "mkquota.h"
 #include "common.h"
 
 /* Needed for architectures where sizeof(int) != sizeof(void *) */
diff --git a/lib/quota/mkquota.h b/lib/quota/mkquota.h
deleted file mode 100644
index ee15071..0000000
--- a/lib/quota/mkquota.h
+++ /dev/null
@@ -1,64 +0,0 @@
-/** mkquota.h
- *
- * Interface to the quota library.
- *
- * The quota library provides interface for creating and updating the quota
- * files and the ext4 superblock fields. It supports the new VFS_V1 quota
- * format. The quota library also provides support for keeping track of quotas
- * in memory.
- * The typical way to use the quota library is as follows:
- * {
- *	quota_ctx_t qctx;
- *
- *	quota_init_context(&qctx, fs, -1);
- *	{
- *		quota_compute_usage(qctx, -1);
- *		AND/OR
- *		quota_data_add/quota_data_sub/quota_data_inodes();
- *	}
- *	quota_write_inode(qctx, USRQUOTA);
- *	quota_write_inode(qctx, GRPQUOTA);
- *	quota_release_context(&qctx);
- * }
- *
- * This initial version does not support reading the quota files. This support
- * will be added in near future.
- *
- * Aditya Kali <adityakali@google.com>
- */
-
-#ifndef __QUOTA_QUOTAIO_H__
-#define __QUOTA_QUOTAIO_H__
-
-#include "ext2fs/ext2_fs.h"
-#include "ext2fs/ext2fs.h"
-#include "quotaio.h"
-#include "../e2fsck/dict.h"
-
-typedef struct quota_ctx *quota_ctx_t;
-
-struct quota_ctx {
-	ext2_filsys	fs;
-	dict_t		*quota_dict[MAXQUOTAS];
-};
-
-/* In mkquota.c */
-errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype);
-void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
-		int adjust);
-void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
-		qsize_t space);
-void quota_data_sub(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
-		qsize_t space);
-errcode_t quota_write_inode(quota_ctx_t qctx, int qtype);
-errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, int type);
-errcode_t quota_compute_usage(quota_ctx_t qctx);
-void quota_release_context(quota_ctx_t *qctx);
-
-errcode_t quota_remove_inode(ext2_filsys fs, int qtype);
-int quota_file_exists(ext2_filsys fs, int qtype, int fmt);
-void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
-errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
-				   int *usage_inconsistent);
-
-#endif  /* __QUOTA_QUOTAIO_H__ */
diff --git a/lib/quota/quota.pc.in b/lib/quota/quota.pc.in
deleted file mode 100644
index 1e4b887..0000000
--- a/lib/quota/quota.pc.in
+++ /dev/null
@@ -1,11 +0,0 @@
-prefix=@prefix@
-exec_prefix=@exec_prefix@
-libdir=@libdir@
-includedir=@includedir@
-
-Name: quota
-Description: Quota management library
-Version: @E2FSPROGS_VERSION@
-Requires:
-Cflags: -I${includedir}/quota -I${includedir}
-Libs: -L${libdir} -lquota
diff --git a/lib/quota/quotaio.h b/lib/quota/quotaio.h
index 55e6eb0..d3820a4 100644
--- a/lib/quota/quotaio.h
+++ b/lib/quota/quotaio.h
@@ -1,6 +1,32 @@
 /** quotaio.h
  *
+ * Interface to the quota library.
+ *
+ * The quota library provides interface for creating and updating the quota
+ * files and the ext4 superblock fields. It supports the new VFS_V1 quota
+ * format. The quota library also provides support for keeping track of quotas
+ * in memory.
+ * The typical way to use the quota library is as follows:
+ * {
+ *	quota_ctx_t qctx;
+ *
+ *	quota_init_context(&qctx, fs, -1);
+ *	{
+ *		quota_compute_usage(qctx, -1);
+ *		AND/OR
+ *		quota_data_add/quota_data_sub/quota_data_inodes();
+ *	}
+ *	quota_write_inode(qctx, USRQUOTA);
+ *	quota_write_inode(qctx, GRPQUOTA);
+ *	quota_release_context(&qctx);
+ * }
+ *
+ * This initial version does not support reading the quota files. This support
+ * will be added in near future.
+ *
+ * Aditya Kali <adityakali@google.com>
  * Header of IO operations for quota utilities
+ *
  * Jan Kara <jack@suse.cz>
  */
 
@@ -11,8 +37,10 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 
+#include "ext2fs/ext2_fs.h"
 #include "ext2fs/ext2fs.h"
 #include "dqblk_v2.h"
+#include "../e2fsck/dict.h"
 
 typedef int64_t qsize_t;	/* Type in which we store size limitations */
 
@@ -20,6 +48,13 @@ typedef int64_t qsize_t;	/* Type in which we store size limitations */
 #define USRQUOTA 0
 #define GRPQUOTA 1
 
+typedef struct quota_ctx *quota_ctx_t;
+
+struct quota_ctx {
+	ext2_filsys	fs;
+	dict_t		*quota_dict[MAXQUOTAS];
+};
+
 /*
  * Definitions of magics and versions of current quota files
  */
@@ -164,4 +199,25 @@ const char *quota_get_qf_name(int type, int fmt, char *buf);
 const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
 			      char *path_buf, size_t path_buf_size);
 
+/* In mkquota.c */
+errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype);
+void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
+		int adjust);
+void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
+		qsize_t space);
+void quota_data_sub(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
+		qsize_t space);
+errcode_t quota_write_inode(quota_ctx_t qctx, int qtype);
+errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, int type);
+errcode_t quota_compute_usage(quota_ctx_t qctx);
+void quota_release_context(quota_ctx_t *qctx);
+
+errcode_t quota_remove_inode(ext2_filsys fs, int qtype);
+int quota_file_exists(ext2_filsys fs, int qtype, int fmt);
+void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
+errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
+				   int *usage_inconsistent);
+
+
+
 #endif /* GUARD_QUOTAIO_H */
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 29b6aab..8d3318b 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -629,10 +629,9 @@ tune2fs.o: $(srcdir)/tune2fs.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/e2p/e2p.h $(srcdir)/jfs_user.h \
  $(top_srcdir)/lib/ext2fs/kernel-jbd.h $(top_srcdir)/lib/ext2fs/jfs_compat.h \
  $(top_srcdir)/lib/ext2fs/kernel-list.h $(srcdir)/util.h \
- $(top_srcdir)/lib/quota/mkquota.h $(top_srcdir)/lib/quota/quotaio.h \
- $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
- $(top_srcdir)/lib/../e2fsck/dict.h $(top_srcdir)/version.h \
- $(srcdir)/nls-enable.h
+ $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
+ $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
+ $(top_srcdir)/version.h $(srcdir)/nls-enable.h
 mklost+found.o: $(srcdir)/mklost+found.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/version.h \
@@ -646,10 +645,9 @@ mke2fs.o: $(srcdir)/mke2fs.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
  $(srcdir)/util.h profile.h prof_err.h $(top_srcdir)/version.h \
- $(srcdir)/nls-enable.h $(top_srcdir)/lib/quota/mkquota.h \
- $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
- $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
- $(srcdir)/mke2fs.h
+ $(srcdir)/nls-enable.h $(top_srcdir)/lib/quota/quotaio.h \
+ $(top_srcdir)/lib/quota/dqblk_v2.h $(top_srcdir)/lib/quota/quotaio_tree.h \
+ $(top_srcdir)/lib/../e2fsck/dict.h $(srcdir)/mke2fs.h
 mk_hugefiles.o: $(srcdir)/mk_hugefiles.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fsP.h \
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 51532ef..e1fd40e 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -62,7 +62,7 @@ extern int optind;
 #include "prof_err.h"
 #include "../version.h"
 #include "nls-enable.h"
-#include "quota/mkquota.h"
+#include "quota/quotaio.h"
 #include "mke2fs.h"
 
 #define STRIDE_LENGTH 8
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 7b3723b..37f0b56 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -60,7 +60,7 @@ extern int optind;
 #include "jfs_user.h"
 #include "util.h"
 #include "blkid/blkid.h"
-#include "quota/mkquota.h"
+#include "quota/quotaio.h"
 
 #include "../version.h"
 #include "nls-enable.h"
-- 
1.9.0

