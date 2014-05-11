From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 7/9] debugfs: add commands to query the quota information
Date: Sun, 11 May 2014 00:32:51 -0400
Message-ID: <1399782773-20029-8-git-send-email-tytso@mit.edu>
References: <1399782773-20029-1-git-send-email-tytso@mit.edu>
Cc: adityakali@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60787 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbaEKEdG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 May 2014 00:33:06 -0400
In-Reply-To: <1399782773-20029-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This allows us to verify quota information in an ext4 file systems
with the quota feature.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: adityakali@google.com
---
 debugfs/Makefile.in      | 177 ++++++++++++++++++++++++++++++++++-------------
 debugfs/debug_cmds.ct    |   6 ++
 debugfs/debugfs.c        |   3 +
 debugfs/debugfs.h        |   6 ++
 debugfs/quota.c          | 170 +++++++++++++++++++++++++++++++++++++++++++++
 debugfs/ro_debug_cmds.ct |   7 +-
 6 files changed, 319 insertions(+), 50 deletions(-)
 create mode 100644 debugfs/quota.c

diff --git a/debugfs/Makefile.in b/debugfs/Makefile.in
index 5ddeab7..3dd06f0 100644
--- a/debugfs/Makefile.in
+++ b/debugfs/Makefile.in
@@ -18,25 +18,27 @@ MK_CMDS=	_SS_DIR_OVERRIDE=../lib/ss ../lib/ss/mk_cmds
 
 DEBUG_OBJS= debug_cmds.o debugfs.o util.o ncheck.o icheck.o ls.o \
 	lsdel.o dump.o set_fields.o logdump.o htree.o unused.o e2freefrag.o \
-	filefrag.o extent_cmds.o extent_inode.o zap.o
+	filefrag.o extent_cmds.o extent_inode.o zap.o quota.o
 
 RO_DEBUG_OBJS= ro_debug_cmds.o ro_debugfs.o util.o ncheck.o icheck.o ls.o \
 	lsdel.o logdump.o htree.o e2freefrag.o filefrag.o extent_cmds.o \
-	extent_inode.o
+	extent_inode.o quota.o
 
 SRCS= debug_cmds.c $(srcdir)/debugfs.c $(srcdir)/util.c $(srcdir)/ls.c \
 	$(srcdir)/ncheck.c $(srcdir)/icheck.c $(srcdir)/lsdel.c \
 	$(srcdir)/dump.c $(srcdir)/set_fields.c ${srcdir}/logdump.c \
 	$(srcdir)/htree.c $(srcdir)/unused.c ${srcdir}/../misc/e2freefrag.c \
-	$(srcdir)/filefrag.c $(srcdir)/extent_inode.c $(srcdir)/zap.c
+	$(srcdir)/filefrag.c $(srcdir)/extent_inode.c $(srcdir)/zap.c \
+	$(srcdir)/quota.c
 
-LIBS= $(LIBEXT2FS) $(LIBE2P) $(LIBSS) $(LIBCOM_ERR) $(LIBBLKID) \
+LIBS= $(LIBQUOTA) $(LIBEXT2FS) $(LIBE2P) $(LIBSS) $(LIBCOM_ERR) $(LIBBLKID) \
 	$(LIBUUID) $(SYSLIBS)
-DEPLIBS= $(LIBEXT2FS) $(LIBE2P) $(DEPLIBSS) $(DEPLIBCOM_ERR) \
+DEPLIBS= $(DEPLIBQUOTA) $(LIBEXT2FS) $(LIBE2P) $(DEPLIBSS) $(DEPLIBCOM_ERR) \
 	$(DEPLIBBLKID) $(DEPLIBUUID)
 
-STATIC_LIBS= $(STATIC_LIBEXT2FS) $(STATIC_LIBSS) $(STATIC_LIBCOM_ERR) \
-	$(STATIC_LIBBLKID) $(STATIC_LIBUUID) $(STATIC_LIBE2P) $(SYSLIBS)
+STATIC_LIBS= $(STATIC_LIBQUOTA) $(STATIC_LIBEXT2FS) $(STATIC_LIBSS) \
+	$(STATIC_LIBCOM_ERR) $(STATIC_LIBBLKID) $(STATIC_LIBUUID) \
+	$(STATIC_LIBE2P) $(SYSLIBS)
 STATIC_DEPLIBS= $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBSS) \
 		$(DEPSTATIC_LIBCOM_ERR) $(DEPSTATIC_LIBUUID) \
 		$(DEPSTATIC_LIBE2P)
@@ -133,76 +135,153 @@ distclean: clean
 #
 debug_cmds.o: debug_cmds.c $(top_srcdir)/lib/ss/ss.h \
  $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/lib/et/com_err.h
-debugfs.o: $(srcdir)/debugfs.c $(top_srcdir)/lib/et/com_err.h \
- $(top_srcdir)/lib/ss/ss.h $(top_builddir)/lib/ss/ss_err.h \
+debugfs.o: $(srcdir)/debugfs.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/debugfs.h $(top_srcdir)/lib/ss/ss.h \
+ $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/lib/et/com_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
+ $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
+ $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/version.h $(srcdir)/jfs_user.h \
+ $(top_srcdir)/lib/ext2fs/kernel-jbd.h $(top_srcdir)/lib/ext2fs/jfs_compat.h \
+ $(top_srcdir)/lib/ext2fs/kernel-list.h
+util.o: $(srcdir)/util.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/ss/ss.h \
+ $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/debugfs.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
  $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/version.h $(srcdir)/jfs_user.h \
- $(top_srcdir)/lib/ext2fs/kernel-jbd.h $(top_srcdir)/lib/ext2fs/jfs_compat.h \
- $(top_srcdir)/lib/ext2fs/kernel-list.h
-util.o: $(srcdir)/util.c $(srcdir)/debugfs.h \
+ $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
+ $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+ls.o: $(srcdir)/ls.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/debugfs.h $(top_srcdir)/lib/ss/ss.h \
+ $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/lib/et/com_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
- $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
- $(top_builddir)/lib/ext2fs/ext2_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h
-ls.o: $(srcdir)/ls.c $(srcdir)/debugfs.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
- $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
- $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h
-ncheck.o: $(srcdir)/ncheck.c $(srcdir)/debugfs.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
+ $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+ncheck.o: $(srcdir)/ncheck.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/debugfs.h $(top_srcdir)/lib/ss/ss.h \
+ $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/lib/et/com_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
- $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
- $(top_builddir)/lib/ext2fs/ext2_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h
-icheck.o: $(srcdir)/icheck.c $(srcdir)/debugfs.h \
+ $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
+ $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+icheck.o: $(srcdir)/icheck.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/debugfs.h $(top_srcdir)/lib/ss/ss.h \
+ $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/lib/et/com_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
- $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
- $(top_builddir)/lib/ext2fs/ext2_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h
-lsdel.o: $(srcdir)/lsdel.c $(srcdir)/debugfs.h \
+ $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
+ $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+lsdel.o: $(srcdir)/lsdel.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/debugfs.h $(top_srcdir)/lib/ss/ss.h \
+ $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/lib/et/com_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
- $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
- $(top_builddir)/lib/ext2fs/ext2_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h
-dump.o: $(srcdir)/dump.c $(srcdir)/debugfs.h \
+ $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
+ $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+dump.o: $(srcdir)/dump.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/debugfs.h $(top_srcdir)/lib/ss/ss.h \
+ $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/lib/et/com_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
- $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
- $(top_builddir)/lib/ext2fs/ext2_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h
-set_fields.o: $(srcdir)/set_fields.c $(srcdir)/debugfs.h \
+ $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
+ $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+set_fields.o: $(srcdir)/set_fields.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/debugfs.h $(top_srcdir)/lib/ss/ss.h \
+ $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/lib/et/com_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
- $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
- $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
+ $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(top_srcdir)/lib/e2p/e2p.h
-logdump.o: $(srcdir)/logdump.c $(srcdir)/debugfs.h \
+logdump.o: $(srcdir)/logdump.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/debugfs.h $(top_srcdir)/lib/ss/ss.h \
+ $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/lib/et/com_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
- $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
- $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
+ $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(srcdir)/jfs_user.h $(top_srcdir)/lib/ext2fs/kernel-jbd.h \
  $(top_srcdir)/lib/ext2fs/jfs_compat.h $(top_srcdir)/lib/ext2fs/kernel-list.h
-htree.o: $(srcdir)/htree.c $(srcdir)/debugfs.h \
+htree.o: $(srcdir)/htree.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/debugfs.h $(top_srcdir)/lib/ss/ss.h \
+ $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/lib/et/com_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
- $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
- $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
+ $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
  $(top_srcdir)/lib/e2p/e2p.h
-unused.o: $(srcdir)/unused.c $(srcdir)/debugfs.h \
+unused.o: $(srcdir)/unused.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/debugfs.h $(top_srcdir)/lib/ss/ss.h \
+ $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/lib/et/com_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
- $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
- $(top_builddir)/lib/ext2fs/ext2_err.h \
- $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h
+ $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
+ $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+e2freefrag.o: $(srcdir)/../misc/e2freefrag.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
+ $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(srcdir)/../misc/e2freefrag.h
+filefrag.o: $(srcdir)/filefrag.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/debugfs.h $(top_srcdir)/lib/ss/ss.h \
+ $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/lib/et/com_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
+ $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+extent_inode.o: $(srcdir)/extent_inode.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/debugfs.h $(top_srcdir)/lib/ss/ss.h \
+ $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/lib/et/com_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
+ $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+zap.o: $(srcdir)/zap.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/debugfs.h $(top_srcdir)/lib/ss/ss.h \
+ $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/lib/et/com_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
+ $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
+quota.o: $(srcdir)/quota.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/debugfs.h $(top_srcdir)/lib/ss/ss.h \
+ $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/lib/et/com_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
+ $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index 96ff00f..6a18df6 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -190,5 +190,11 @@ request do_zap_block, "Zap block: fill with 0, pattern, flip bits etc.",
 request do_block_dump, "Dump contents of a block",
 	block_dump, bd;
 
+request do_list_quota, "List quota",
+	list_quota, lq;
+
+request do_get_quota, "Get quota",
+	get_quota, gq;
+
 end;
 
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 0e56ead..326f41e 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -56,6 +56,7 @@ const char *debug_prog_name;
 int sci_idx;
 
 ext2_filsys	current_fs = NULL;
+quota_ctx_t	current_qctx;
 ext2_ino_t	root, cwd;
 
 static void open_filesystem(char *device, int open_flags, blk64_t superblock,
@@ -238,6 +239,8 @@ static void close_filesystem(NOARGS)
 		if (retval)
 			com_err("ext2fs_write_block_bitmap", retval, 0);
 	}
+	if (current_qctx)
+		quota_release_context(&current_qctx);
 	retval = ext2fs_close(current_fs);
 	if (retval)
 		com_err("ext2fs_close", retval, 0);
diff --git a/debugfs/debugfs.h b/debugfs/debugfs.h
index 33389fa..9b67f69 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -5,6 +5,7 @@
 #include "ss/ss.h"
 #include "ext2fs/ext2_fs.h"
 #include "ext2fs/ext2fs.h"
+#include "quota/quotaio.h"
 
 #ifdef __STDC__
 #define NOARGS void
@@ -21,6 +22,7 @@
 #define CHECK_FS_NOTOPEN	0x0004
 
 extern ext2_filsys current_fs;
+extern quota_ctx_t current_qctx;
 extern ext2_ino_t	root, cwd;
 extern int sci_idx;
 extern ss_request_table debug_cmds, extent_cmds;
@@ -171,6 +173,10 @@ extern void do_set_mmp_value(int argc, char **argv);
 extern void do_freefrag(int argc, char **argv);
 extern void do_filefrag(int argc, char *argv[]);
 
+/* quota.c */
+extern void do_list_quota(int argc, char *argv[]);
+extern void do_get_quota(int argc, char *argv[]);
+
 /* util.c */
 extern time_t string_to_time(const char *arg);
 
diff --git a/debugfs/quota.c b/debugfs/quota.c
new file mode 100644
index 0000000..cbf237a
--- /dev/null
+++ b/debugfs/quota.c
@@ -0,0 +1,170 @@
+/*
+ * quota.c --- debugfs quota commands
+ *
+ * Copyright (C) 2014 Theodore Ts'o.  This file may be redistributed
+ * under the terms of the GNU Public License.
+ */
+
+#include "config.h"
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <ctype.h>
+#include <string.h>
+#include <time.h>
+#ifdef HAVE_ERRNO_H
+#include <errno.h>
+#endif
+#include <sys/types.h>
+#ifdef HAVE_GETOPT_H
+#include <getopt.h>
+#else
+extern int optind;
+extern char *optarg;
+#endif
+
+#include "debugfs.h"
+
+const char *quota_type[] = { "user", "group", NULL };
+
+static int load_quota_ctx(char *progname)
+{
+	errcode_t	retval;
+
+	if (check_fs_open(progname))
+		return 1;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(current_fs->super,
+					EXT4_FEATURE_RO_COMPAT_QUOTA)) {
+		com_err(progname, 0, "quota feature not eanbled");
+		return 1;
+	}
+
+	if (current_qctx)
+		return 0;
+
+	retval = quota_init_context(&current_qctx, current_fs, -1);
+	if (retval) {
+		com_err(current_fs->device_name, retval,
+			"while trying to load quota information");
+		return 1;
+	}
+	return 0;
+}
+
+static int parse_quota_type(const char *cmdname, const char *str)
+{
+	errcode_t	retval;
+	char		*t;
+	int		flags = 0;
+	int		i;
+
+	for (i = 0; i < MAXQUOTAS; i++) {
+		if (strcasecmp(str, quota_type[i]) == 0)
+			break;
+	}
+	if (i >= MAXQUOTAS) {
+		i = strtol(str, &t, 0);
+		if (*t)
+			i = -1;
+	}
+	if (i < 0 || i >= MAXQUOTAS) {
+		com_err(0, 0, "Invalid quota type: %s", str);
+		printf("Valid quota types are: ");
+		for (i = 0; i < MAXQUOTAS; i++)
+			printf("%s ", quota_type[i]);
+		printf("\n");
+		return -1;
+	}
+
+	if (current_fs->flags & EXT2_FLAG_RW)
+		flags |= EXT2_FILE_WRITE;
+
+	retval = quota_file_open(current_qctx, NULL, 0, i, -1, flags);
+	if (retval) {
+		com_err(cmdname, retval,
+			"while opening quota inode (type %d)", i);
+		return -1;
+	}
+	return i;
+}
+
+
+static int list_quota_callback(struct dquot *dq, void *cb_data)
+{
+	printf("%8u   %8lld %8lld %8lld    %8lld %8lld %8lld\n",
+	       dq->dq_id, dq->dq_dqb.dqb_curspace,
+	       dq->dq_dqb.dqb_bsoftlimit, dq->dq_dqb.dqb_bhardlimit,
+	       dq->dq_dqb.dqb_curinodes,
+	       dq->dq_dqb.dqb_isoftlimit, dq->dq_dqb.dqb_ihardlimit);
+}
+
+void do_list_quota(int argc, char *argv[])
+{
+	errcode_t	retval;
+	int		i, type;
+	int		flags = 0;
+	struct quota_handle *qh;
+
+	if (load_quota_ctx(argv[0]))
+		return;
+
+	if (argc != 2) {
+		com_err(0, 0, "Usage: list_quota <quota_type>\n");
+		return;
+	}
+
+	type = parse_quota_type(argv[0], argv[1]);
+	if (type < 0)
+		return;
+
+	printf("%8s   %8s %8s %8s    %8s %8s %8s\n",
+	       (type == 0) ? "user id" : "group id",
+	       "blocks", "quota", "limit", "inodes", "quota", "limit");
+	qh = current_qctx->quota_file[type];
+	retval = qh->qh_ops->scan_dquots(qh, list_quota_callback, NULL);
+	if (retval) {
+		com_err(argv[0], retval, "while scanning dquots");
+		return;
+	}
+}
+
+void do_get_quota(int argc, char *argv[])
+{
+	errcode_t	retval;
+	int		i, err, type;
+	int		flags = 0;
+	struct quota_handle *qh;
+	struct dquot	*dq;
+	qid_t		id;
+
+	if (load_quota_ctx(argv[0]))
+		return;
+
+	if (argc != 3) {
+		com_err(0, 0, "Usage: get_quota <quota_type> <id>\n");
+		return;
+	}
+
+	type = parse_quota_type(argv[0], argv[1]);
+	if (type < 0)
+		return;
+
+	id = parse_ulong(argv[2], argv[0], "id", &err);
+	if (err)
+		return;
+
+	printf("%8s   %8s %8s %8s    %8s %8s %8s\n",
+	       (type == 0) ? "user id" : "group id",
+	       "blocks", "quota", "limit", "inodes", "quota", "limit");
+
+	qh = current_qctx->quota_file[type];
+
+	dq = qh->qh_ops->read_dquot(qh, id);
+	if (dq) {
+		list_quota_callback(dq, NULL);
+		ext2fs_free_mem(&dq);
+	} else
+		com_err(argv[0], 0, "couldn't read quota record");
+
+}
diff --git a/debugfs/ro_debug_cmds.ct b/debugfs/ro_debug_cmds.ct
index 8226d1a..736ade6 100644
--- a/debugfs/ro_debug_cmds.ct
+++ b/debugfs/ro_debug_cmds.ct
@@ -90,5 +90,10 @@ request do_dump_mmp, "Dump MMP information",
 request do_extent_open, "Open inode for extent manipulation",
 	extent_open, eo;
 
-end;
+request do_list_quota, "List quota",
+	lost_quota, lq;
+
+request do_get_quota, "Get quota",
+	get_quota, gq;
 
+end;
-- 
1.9.0

