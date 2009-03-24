From: Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] blkid: add --disable-libblkid (v2)
Date: Tue, 24 Mar 2009 12:11:47 +0000
Message-ID: <20090324121147.GA22386@zelda.netsplit.com>
References: <20090224084434.GF6020@nb.net.home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Cc: Karel Zak <kzak@redhat.com>, Theodore Tso <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zelda.netsplit.com ([87.194.19.211]:42653 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbZCXML6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Mar 2009 08:11:58 -0400
Content-Disposition: inline
In-Reply-To: <20090224084434.GF6020@nb.net.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Karel Zak wrote:

> I found some bugs in my previous patches. Please, use the patch
> below. This patch includes all necessary changes. Sorry.
> 
When putting together an Ubuntu package with this patch, I found that it
ends up putting the pkg-config output into the make dependency variables
and thus fails because it can't make the "-L/lib" target.

The attached patch fixes that, and includes your previous patch.

Scott

--qDbXVdCdHGoSgWSk
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="blkid-add---disable-libblkid-v3.patch"

diff -ruNp e2fsprogs-1.41.4~/MCONFIG.in e2fsprogs-1.41.4/MCONFIG.in
--- e2fsprogs-1.41.4~/MCONFIG.in	2008-11-15 17:17:22.000000000 +0000
+++ e2fsprogs-1.41.4/MCONFIG.in	2009-03-24 11:28:26.000000000 +0000
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
+DEPLIBBLKID = @PRIVATE_LIBS_CMT@ $(LIBUUID)
+STATIC_LIBBLKID = $(STATIC_BLKID_LIBS) $(STATIC_LIBUUID)
+DEPSTATIC_LIBBLKID = 
+PROFILED_LIBBLKID = $(BLKID_LIBS) $(PROFILED_LIBUUID)
+DEPPROFILED_LIBBLKID =
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
diff -ruNp e2fsprogs-1.41.4~/Makefile.in e2fsprogs-1.41.4/Makefile.in
--- e2fsprogs-1.41.4~/Makefile.in	2008-10-13 04:12:22.000000000 +0100
+++ e2fsprogs-1.41.4/Makefile.in	2009-03-23 18:58:48.000000000 +0000
@@ -11,8 +11,9 @@ INSTALL = @INSTALL@
 
 @RESIZER_CMT@RESIZE_DIR= resize
 @DEBUGFS_CMT@DEBUGFS_DIR= debugfs
+@BLKID_CMT@BLKID_LIB_SUBDIR= lib/blkid
 
-LIB_SUBDIRS=lib/et lib/ss lib/e2p lib/uuid lib/ext2fs lib/blkid intl
+LIB_SUBDIRS=lib/et lib/ss lib/e2p lib/uuid lib/ext2fs $(BLKID_LIB_SUBDIR) intl
 PROG_SUBDIRS=e2fsck $(DEBUGFS_DIR) misc $(RESIZE_DIR) tests/progs po
 SUBDIRS=util $(LIB_SUBDIRS) $(PROG_SUBDIRS) tests
 
diff -ruNp e2fsprogs-1.41.4~/configure.in e2fsprogs-1.41.4/configure.in
--- e2fsprogs-1.41.4~/configure.in	2008-10-07 15:22:39.000000000 +0100
+++ e2fsprogs-1.41.4/configure.in	2009-03-23 18:58:48.000000000 +0000
@@ -276,6 +276,39 @@ AC_MSG_RESULT([Disabling BSD shared libr
 AC_SUBST(BSDLIB_CMT)
 AC_SUBST_FILE(MAKEFILE_BSDLIB)
 dnl
+dnl handle --disable-libblkid
+dnl
+PKG_PROG_PKG_CONFIG
+BLKID_LIBS=
+STATIC_BLKID_LIBS=
+BLKID_CMT=
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
+	AC_DEFINE(CONFIG_BUILD_FINDFS)
+	AC_MSG_RESULT([Enabling private blkid library])
+fi
+,
+AC_DEFINE(CONFIG_BUILD_FINDFS)
+AC_MSG_RESULT([Enabling private blkid library by default])
+)
+AC_SUBST(BLKID_CMT)
+AC_SUBST(BLKID_LIBS)
+AC_SUBST(STATIC_BLKID_LIBS)
+dnl
 dnl handle --enable-profile
 dnl
 AC_ARG_ENABLE([profile],
diff -ruNp e2fsprogs-1.41.4~/misc/Makefile.in e2fsprogs-1.41.4/misc/Makefile.in
--- e2fsprogs-1.41.4~/misc/Makefile.in	2008-11-15 17:33:33.000000000 +0000
+++ e2fsprogs-1.41.4/misc/Makefile.in	2009-03-23 18:58:48.000000000 +0000
@@ -17,11 +17,18 @@ INSTALL = @INSTALL@
 @UUIDD_CMT@UUIDD_PROG= uuidd
 @UUIDD_CMT@UUIDD_MAN= uuidd.8
 
-SPROGS=		mke2fs badblocks tune2fs dumpe2fs blkid logsave \
+@BLKID_CMT@BLKID_PROG= blkid
+@BLKID_CMT@BLKID_MAN= blkid.8
+@BLKID_CMT@BLKID_PROFILED= blkid.profiled
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
 
@@ -94,7 +101,7 @@ COMPILE_ET=$(top_builddir)/lib/et/compil
 all:: profiled $(SPROGS) $(UPROGS) $(USPROGS) $(SMANPAGES) $(UMANPAGES) \
 	$(FMANPAGES) $(LPROGS)
 
-@PROFILE_CMT@all:: tune2fs.profiled blkid.profiled e2image.profiled \
+@PROFILE_CMT@all:: tune2fs.profiled $(BLKID_PROFILED) e2image.profiled \
 	e2undo.profiled mke2fs.profiled dumpe2fs.profiled fsck.profiled \
 	logsave.profiled filefrag.profiled uuidgen.profiled uuidd.profiled \
 	e2image.profiled
@@ -397,9 +404,11 @@ install: all $(SMANPAGES) $(UMANPAGES) i
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
@@ -509,7 +518,7 @@ uninstall:
 	for i in $(UMANPAGES); do \
 		$(RM) -f $(DESTDIR)$(man1dir)/$$i; \
 	done
-	for i in findfs e2label ; do \
+	for i in $(FINDFS_LINK) e2label ; do \
 		$(RM) -f $(DESTDIR)$(root_sbindir)/$$i; \
 	done
 	for i in $(FMANPAGES); do \
diff -ruNp e2fsprogs-1.41.4~/misc/tune2fs.c e2fsprogs-1.41.4/misc/tune2fs.c
--- e2fsprogs-1.41.4~/misc/tune2fs.c	2009-01-20 15:50:01.000000000 +0000
+++ e2fsprogs-1.41.4/misc/tune2fs.c	2009-03-23 18:58:48.000000000 +0000
@@ -95,7 +95,9 @@ struct blk_move {
 
 static const char *please_fsck = N_("Please run e2fsck on the filesystem.\n");
 
+#ifdef CONFIG_BUILD_FINDFS
 void do_findfs(int argc, char **argv);
+#endif
 
 static void usage(void)
 {
@@ -836,6 +838,7 @@ static void parse_tune2fs_options(int ar
 	}
 }
 
+#ifdef CONFIG_BUILD_FINDFS
 void do_findfs(int argc, char **argv)
 {
 	char	*dev;
@@ -854,6 +857,7 @@ void do_findfs(int argc, char **argv)
 	puts(dev);
 	exit(0);
 }
+#endif
 
 static void parse_extended_opts(ext2_filsys fs, const char *opts)
 {
@@ -1492,8 +1496,10 @@ int main(int argc, char **argv)
 		program_name = *argv;
 	add_error_table(&et_ext2_error_table);
 
+#ifdef CONFIG_BUILD_FINDFS
 	if (strcmp(get_progname(argv[0]), "findfs") == 0)
 		do_findfs(argc, argv);
+#endif
 	if (strcmp(get_progname(argv[0]), "e2label") == 0)
 		parse_e2label_options(argc, argv);
 	else

--qDbXVdCdHGoSgWSk--
