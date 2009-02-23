From: Karel Zak <kzak@redhat.com>
Subject: [PATCH] blkid: add --disable-libblkid to build with external libblkid
Date: Mon, 23 Feb 2009 18:38:52 +0100
Message-ID: <1235410733-4193-2-git-send-email-kzak@redhat.com>
References: <1235410733-4193-1-git-send-email-kzak@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Karel Zak <kzak@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:32958 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbZBWRjl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Feb 2009 12:39:41 -0500
In-Reply-To: <1235410733-4193-1-git-send-email-kzak@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch allows to switch between private (in-tree) libblkid and
public (in-system installed) library. The private version is still
enabled by default.

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 MCONFIG.in       |   28 ++++++++++++++++++++++------
 Makefile.in      |    3 ++-
 configure.in     |   30 ++++++++++++++++++++++++++++++
 misc/Makefile.in |   20 ++++++++++++++------
 4 files changed, 68 insertions(+), 13 deletions(-)

diff --git a/MCONFIG.in b/MCONFIG.in
index f67682e..c7c16bf 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -69,36 +69,52 @@ MKINSTALLDIRS = @MKINSTALLDIRS@
 #
 # Library definitions
 #
+@BLKID_CMT@PRIVATE_LIBBLKID = yes
+
+# public libblkid options
+BLKID_LIBS = @BLKID_LIBS@
+STATIC_BLKID_LIBS = @STATIC_BLKID_LIBS@
+
+ifdef PRIVATE_LIBBLKID
+LIBBLKID = $(LIB)/libblkid@LIB_EXT@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
+DEPLIBBLKID = $(LIB)/libblkid@LIB_EXT@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
+STATIC_LIBBLKID = $(LIB)/libblkid@STATIC_LIB_EXT@ $(STATIC_LIBUUID)
+DEPSTATIC_LIBBLKID = $(LIB)/libblkid@STATIC_LIB_EXT@
+PROFILED_LIBBLKID = $(LIB)/libblkid@PROFILED_LIB_EXT@ $(PROFILED_LIBUUID)
+DEPPROFILED_LIBBLKID = $(LIB)/libblkid@PROFILED_LIB_EXT@
+else
+LIBBLKID = $(BLKID_LIBS) @PRIVATE_LIBS_CMT@ $(LIBUUID)
+DEPLIBBLKID = $(BLKID_LIBS) @PRIVATE_LIBS_CMT@ $(LIBUUID)
+STATIC_LIBBLKID = $(STATIC_BLKID_LIBS) $(STATIC_LIBUUID)
+DEPSTATIC_LIBBLKID = $(STATIC_BLKID_LIBS)
+PROFILED_LIBBLKID = $(BLKID_LIBS) $(PROFILED_LIBUUID)
+DEPPROFILED_LIBBLKID = $(BLKID_LIBS)
+endif
+
 LIB = $(top_builddir)/lib
 LIBSS = $(LIB)/libss@LIB_EXT@ @PRIVATE_LIBS_CMT@ @DLOPEN_LIB@
 LIBCOM_ERR = $(LIB)/libcom_err@LIB_EXT@ @PRIVATE_LIBS_CMT@ @SEM_INIT_LIB@
 LIBE2P = $(LIB)/libe2p@LIB_EXT@
 LIBEXT2FS = $(LIB)/libext2fs@LIB_EXT@
 LIBUUID = $(LIB)/libuuid@LIB_EXT@ @SOCKET_LIB@
-LIBBLKID = $(LIB)/libblkid@LIB_EXT@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
 LIBINTL = @LIBINTL@
 DEPLIBSS = $(LIB)/libss@LIB_EXT@
 DEPLIBUUID = $(LIB)/libuuid@LIB_EXT@
-DEPLIBBLKID = $(LIB)/libblkid@LIB_EXT@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
 
 STATIC_LIBSS = $(LIB)/libss@STATIC_LIB_EXT@ @DLOPEN_LIB@
 STATIC_LIBCOM_ERR = $(LIB)/libcom_err@STATIC_LIB_EXT@ @SEM_INIT_LIB@
 STATIC_LIBE2P = $(LIB)/libe2p@STATIC_LIB_EXT@
 STATIC_LIBEXT2FS = $(LIB)/libext2fs@STATIC_LIB_EXT@
 STATIC_LIBUUID = $(LIB)/libuuid@STATIC_LIB_EXT@ @SOCKET_LIB@ 
-STATIC_LIBBLKID = $(LIB)/libblkid@STATIC_LIB_EXT@ $(STATIC_LIBUUID)
 DEPSTATIC_LIBSS = $(LIB)/libss@STATIC_LIB_EXT@
 DEPSTATIC_LIBUUID = $(LIB)/libuuid@STATIC_LIB_EXT@
-DEPSTATIC_LIBBLKID = $(LIB)/libblkid@STATIC_LIB_EXT@
 
 PROFILED_LIBSS = $(LIB)/libss@PROFILED_LIB_EXT@ @DLOPEN_LIB@
 PROFILED_LIBCOM_ERR = $(LIB)/libcom_err@PROFILED_LIB_EXT@ @SEM_INIT_LIB@
 PROFILED_LIBE2P = $(LIB)/libe2p@PROFILED_LIB_EXT@
 PROFILED_LIBEXT2FS = $(LIB)/libext2fs@PROFILED_LIB_EXT@
 PROFILED_LIBUUID = $(LIB)/libuuid@PROFILED_LIB_EXT@ @SOCKET_LIB@ 
-PROFILED_LIBBLKID = $(LIB)/libblkid@PROFILED_LIB_EXT@ $(PROFILED_LIBUUID)
 DEPPROFILED_LIBUUID = $(LIB)/libuuid@PROFILED_LIB_EXT@
-DEPPROFILED_LIBBLKID = $(LIB)/libblkid@PROFILED_LIB_EXT@
 
 # An include directive pointing to a directory holding enough linux-like
 # include files to satisfy some programs here
diff --git a/Makefile.in b/Makefile.in
index 728d3a5..1f1b8ea 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -11,8 +11,9 @@ INSTALL = @INSTALL@
 
 @RESIZER_CMT@RESIZE_DIR= resize
 @DEBUGFS_CMT@DEBUGFS_DIR= debugfs
+@BLKID_CMT@BLKID_LIB_SUBDIR= lib/blkid
 
-LIB_SUBDIRS=lib/et lib/ss lib/e2p lib/uuid lib/ext2fs lib/blkid intl
+LIB_SUBDIRS=lib/et lib/ss lib/e2p lib/uuid lib/ext2fs $(BLKID_LIB_SUBDIR) intl
 PROG_SUBDIRS=e2fsck $(DEBUGFS_DIR) misc $(RESIZE_DIR) tests/progs po
 SUBDIRS=util $(LIB_SUBDIRS) $(PROG_SUBDIRS) tests
 
diff --git a/configure.in b/configure.in
index 2534df4..83ab14d 100644
--- a/configure.in
+++ b/configure.in
@@ -276,6 +276,36 @@ AC_MSG_RESULT([Disabling BSD shared libraries by default])
 AC_SUBST(BSDLIB_CMT)
 AC_SUBST_FILE(MAKEFILE_BSDLIB)
 dnl
+dnl handle --disable-libblkid
+dnl
+PKG_PROG_PKG_CONFIG
+AC_ARG_ENABLE([libblkid],
+[  --disable-libblkid	  do not build private blkid library],
+if test "$enableval" = "no"
+then
+	if test -z "$PKG_CONFIG"; then
+		AC_MSG_ERROR([pkg-config not installed; please install it.])
+	fi
+ 
+	AC_CHECK_LIB(blkid, blkid_get_cache,
+		[BLKID_LIBS=`$PKG_CONFIG --libs blkid`; 
+		 STATIC_BLKID_LIBS=`$PKG_CONFIG --static --libs blkid`],
+		[AC_MSG_ERROR([external blkid library not found])],
+		[$BLKID_LIBS])
+	BLKID_CMT=#
+	AC_MSG_RESULT([Disabling private blkid library])
+else
+	BLKID_CMT=
+	AC_MSG_RESULT([Enabling private blkid library])
+fi
+,
+BLKID_CMT=
+AC_MSG_RESULT([Enabling private blkid library by default])
+)
+AC_SUBST(BLKID_CMT)
+AC_SUBST(BLKID_LIBS)
+AC_SUBST(STATIC_BLKID_LIBS)
+dnl
 dnl handle --enable-profile
 dnl
 AC_ARG_ENABLE([profile],
diff --git a/misc/Makefile.in b/misc/Makefile.in
index e35bb8f..defec7d 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -17,11 +17,17 @@ INSTALL = @INSTALL@
 @UUIDD_CMT@UUIDD_PROG= uuidd
 @UUIDD_CMT@UUIDD_MAN= uuidd.8
 
-SPROGS=		mke2fs badblocks tune2fs dumpe2fs blkid logsave \
+@BLKID_CMT@BLKID_PROG= blkid
+@BLKID_CMT@BLKID_MAN= blkid.8
+
+@BLKID_CMT@FINDFS_LINK= findfs
+@BLKID_CMT@FINDFS_MAN= findfs.8
+
+SPROGS=		mke2fs badblocks tune2fs dumpe2fs $(BLKID_PROG) logsave \
 			$(E2IMAGE_PROG) @FSCK_PROG@ e2undo
 USPROGS=	mklost+found filefrag $(UUIDD_PROG)
 SMANPAGES=	tune2fs.8 mklost+found.8 mke2fs.8 dumpe2fs.8 badblocks.8 \
-			e2label.8 findfs.8 blkid.8 $(E2IMAGE_MAN) \
+			e2label.8 $(FINDFS_MAN) $(BLKID_MAN) $(E2IMAGE_MAN) \
 			logsave.8 filefrag.8 e2undo.8 $(UUIDD_MAN) @FSCK_MAN@
 FMANPAGES=	mke2fs.conf.5
 
@@ -397,9 +403,11 @@ install: all $(SMANPAGES) $(UMANPAGES) installdirs
 	@echo "	LINK $(root_sbindir)/e2label"
 	@$(LN) -f $(DESTDIR)$(root_sbindir)/tune2fs \
 		$(DESTDIR)$(root_sbindir)/e2label
-	@echo "	LINK $(root_sbindir)/findfs"
-	@$(LN) -f $(DESTDIR)$(root_sbindir)/tune2fs \
-		$(DESTDIR)$(root_sbindir)/findfs
+	@if test -n "$(FINDFS_LINK)"; then \
+		echo "	LINK $(root_sbindir)/findfs"; \
+		$(LN) -f $(DESTDIR)$(root_sbindir)/tune2fs \
+			$(DESTDIR)$(root_sbindir)/findfs; \
+	fi
 	@for i in $(UPROGS); do \
 		echo "	INSTALL $(bindir)/$$i"; \
 		$(INSTALL_PROGRAM) $$i $(DESTDIR)$(bindir)/$$i; \
@@ -509,7 +517,7 @@ uninstall:
 	for i in $(UMANPAGES); do \
 		$(RM) -f $(DESTDIR)$(man1dir)/$$i; \
 	done
-	for i in findfs e2label ; do \
+	for i in $(FINDFS_LINK) e2label ; do \
 		$(RM) -f $(DESTDIR)$(root_sbindir)/$$i; \
 	done
 	for i in $(FMANPAGES); do \
-- 
1.6.0.6

