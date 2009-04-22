From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid: add --disable-libblkid (v2)
Date: Wed, 22 Apr 2009 09:33:04 -0400
Message-ID: <20090422133304.GP15541@mit.edu>
References: <20090224084434.GF6020@nb.net.home> <20090324121147.GA22386@zelda.netsplit.com> <20090416102241.GA3290@nb.net.home> <1239976118.11603.109.camel@quest>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Karel Zak <kzak@redhat.com>, linux-ext4@vger.kernel.org,
	Kay Sievers <kay.sievers@vrfy.org>
To: Scott James Remnant <scott@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33206 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbZDVNdP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Apr 2009 09:33:15 -0400
Content-Disposition: inline
In-Reply-To: <1239976118.11603.109.camel@quest>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is the version of the the --disable-libblkid patch which I
ultimately dropped into the my tree.  I have not tested it with the
util-linux-ng libblkid --- I haven't had the time to try to build and
install it on a test system.  I have tested to make sure it builds
correctly using the in-system libblkid (from e2fsprogs).

The big change which I made from the submitted patch --- I try very
hard not to let GNU make'isms creep into the e2fsprogs dependency; it
compiles on other OS's, including Darwin, Solaris, *BSD, etc., so
ix-nay on using ifdef in Makefile or Makefile fragments, like MCONFIG.

Also, I have not dropped in the debian packaging changes which you
made Scott, since you just conditionally made changes to the
debian/rules and debian/config file, which means e2fsprogs would break
on Debian (which hasn't even packaged util-linux-ng yet) and on
versions of Ubuntu that haven't made the switch yet.  In the ideal
world, the Debian rules file would autodetect whether it is on a
new-style or old-style system, and role play accordingly, with a
DEB_BUILD_OPTIONS flag that would override the defaults.  We'll need
to support both for a while, since there are people who want to
backport the latest e2fsprogs on older distributions.  (For example,
Ubuntu LTS, Debian archaelogical-err-I-mean-stable, etc.)

The changes have been pushed out to the e2fsprogs git repository if
you want to try it out with the latest changes, which will be in the
very-soon-to-be-released e2fsprogs 1.41.5.

						- Ted

P.S.  Scott, if you haven't been tracking linux-ext4, there are some
rather critical resize2fs bugfixes that recently came into the tree,
which fix bugs that cause filesystem corruption when growing or
shrinking ext4 filesystems off-line.


commit 14b596d40997c7e55ec8928bd222787f96808a2b
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Apr 22 09:18:30 2009 -0400

    configure.in: add --disable-libblkid option
    
    Add an option to switch between the private (in-tree) libblkid and
    public (in-system installed) library.  The private version is still
    enabled by default.
    
    If --disable-libblkid is specified the findfs(8) program, which is a
    variant of tune2fs, is also not built or installed.
    
    Signed-off-by: Karel Zak <kzak@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/MCONFIG.in b/MCONFIG.in
index f67682e..7f3e0c5 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -75,30 +75,30 @@ LIBCOM_ERR = $(LIB)/libcom_err@LIB_EXT@ @PRIVATE_LIBS_CMT@ @SEM_INIT_LIB@
 LIBE2P = $(LIB)/libe2p@LIB_EXT@
 LIBEXT2FS = $(LIB)/libext2fs@LIB_EXT@
 LIBUUID = $(LIB)/libuuid@LIB_EXT@ @SOCKET_LIB@
-LIBBLKID = $(LIB)/libblkid@LIB_EXT@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
+LIBBLKID = @LIBBLKID@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
 LIBINTL = @LIBINTL@
 DEPLIBSS = $(LIB)/libss@LIB_EXT@
 DEPLIBUUID = $(LIB)/libuuid@LIB_EXT@
-DEPLIBBLKID = $(LIB)/libblkid@LIB_EXT@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
+DEPLIBBLKID = @DEPLIBBLKID@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
 
 STATIC_LIBSS = $(LIB)/libss@STATIC_LIB_EXT@ @DLOPEN_LIB@
 STATIC_LIBCOM_ERR = $(LIB)/libcom_err@STATIC_LIB_EXT@ @SEM_INIT_LIB@
 STATIC_LIBE2P = $(LIB)/libe2p@STATIC_LIB_EXT@
 STATIC_LIBEXT2FS = $(LIB)/libext2fs@STATIC_LIB_EXT@
 STATIC_LIBUUID = $(LIB)/libuuid@STATIC_LIB_EXT@ @SOCKET_LIB@ 
-STATIC_LIBBLKID = $(LIB)/libblkid@STATIC_LIB_EXT@ $(STATIC_LIBUUID)
+STATIC_LIBBLKID = @STATIC_LIBBLKID@ $(STATIC_LIBUUID)
 DEPSTATIC_LIBSS = $(LIB)/libss@STATIC_LIB_EXT@
 DEPSTATIC_LIBUUID = $(LIB)/libuuid@STATIC_LIB_EXT@
-DEPSTATIC_LIBBLKID = $(LIB)/libblkid@STATIC_LIB_EXT@
+DEPSTATIC_LIBBLKID = @DEPSTATIC_LIBBLKID@ $(STATIC_LIBUUID)
 
 PROFILED_LIBSS = $(LIB)/libss@PROFILED_LIB_EXT@ @DLOPEN_LIB@
 PROFILED_LIBCOM_ERR = $(LIB)/libcom_err@PROFILED_LIB_EXT@ @SEM_INIT_LIB@
 PROFILED_LIBE2P = $(LIB)/libe2p@PROFILED_LIB_EXT@
 PROFILED_LIBEXT2FS = $(LIB)/libext2fs@PROFILED_LIB_EXT@
 PROFILED_LIBUUID = $(LIB)/libuuid@PROFILED_LIB_EXT@ @SOCKET_LIB@ 
-PROFILED_LIBBLKID = $(LIB)/libblkid@PROFILED_LIB_EXT@ $(PROFILED_LIBUUID)
+PROFILED_LIBBLKID = @PROFILED_LIBBLKID@ $(PROFILED_LIBUUID)
 DEPPROFILED_LIBUUID = $(LIB)/libuuid@PROFILED_LIB_EXT@
-DEPPROFILED_LIBBLKID = $(LIB)/libblkid@PROFILED_LIB_EXT@
+DEPPROFILED_LIBBLKID = @PROFILED_LIBBLKID@ $(PROFILED_LIBUUID)
 
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
index caf2cb4..781519c 100644
--- a/configure.in
+++ b/configure.in
@@ -136,7 +136,7 @@ dnl parsing configuration opions, which may modify these
 dnl
 LIB_EXT=.a
 STATIC_LIB_EXT=.a
-PROFILE_LIB_EXT=.a
+PROFILED_LIB_EXT=.a
 dnl
 dnl set $(LDFLAGS) from --with-ldopts=value
 dnl
@@ -379,6 +379,59 @@ TEST_IO_CMT=
 )
 AC_SUBST(TEST_IO_CMT)
 dnl
+dnl handle --disable-libblkid
+dnl
+PKG_PROG_PKG_CONFIG
+LIBBLKID=
+DEPLIBBLKID=
+STATIC_LIBBLKID=
+DEPSTATIC_LIBBLKID=
+PROFILED_LIBBLKID=
+DEPPROFILED_LIBBLKID=
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
+		[LIBBLKID=`$PKG_CONFIG --libs blkid`;
+		 STATIC_LIBBLKID=`$PKG_CONFIG --static --libs blkid`],
+		[AC_MSG_ERROR([external blkid library not found])],
+		[$LIBBLKID])
+	BLKID_CMT=#
+	AC_MSG_RESULT([Disabling private blkid library])
+else
+	LIBBLKID='$(LIB)/libblkid'$LIB_EXT
+	DEPLIBBLKID=$LIBBLKID
+	STATIC_LIBBLKID='$(LIB)/libblkid'$STATIC_LIB_EXT
+	DEPSTATIC_LIBBLKID=$STATIC_LIBBLKID
+	PROFILED_LIBBLKID='$(LIB)/libblkid'$PROFILED_LIB_EXT
+	DEPPROFILED_LIBBLKID=$PROFILED_LIBBLKID
+	AC_DEFINE(CONFIG_BUILD_FINDFS)
+	AC_MSG_RESULT([Enabling private blkid library])
+fi
+,
+LIBBLKID='$(LIB)/libblkid'$LIB_EXT
+DEPLIBBLKID=$LIBBLKID
+STATIC_LIBBLKID='$(LIB)/libblkid'$STATIC_LIB_EXT
+DEPSTATIC_LIBBLKID=$STATIC_LIBBLKID
+PROFILED_LIBBLKID='$(LIB)/libblkid'$PROFILED_LIB_EXT
+DEPPROFILED_LIBBLKID=$PROFILED_LIBBLKID
+AC_DEFINE(CONFIG_BUILD_FINDFS)
+AC_MSG_RESULT([Enabling private blkid library by default])
+)
+AC_SUBST(LIBBLKID)
+AC_SUBST(DEPLIBBLKID)
+AC_SUBST(STATIC_LIBBLKID)
+AC_SUBST(DEPSTATIC_LIBBLKID)
+AC_SUBST(PROFILED_LIBBLKID)
+AC_SUBST(DEPPROFILED_LIBBLKID)
+AC_SUBST(BLKID_CMT)
+dnl
 dnl handle --enable-debugfs
 dnl
 AC_ARG_ENABLE([debugfs],
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 63b4c20..99cb149 100644
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
 
@@ -402,9 +408,11 @@ install: all $(SMANPAGES) $(UMANPAGES) installdirs
 	@echo "	LINK $(root_sbindir)/e2label"
 	@$(LN) -f $(DESTDIR)$(root_sbindir)/tune2fs \
 		$(DESTDIR)$(root_sbindir)/e2label
-	@echo "	LINK $(root_sbindir)/findfs"
-	@$(LN) -f $(DESTDIR)$(root_sbindir)/tune2fs \
-		$(DESTDIR)$(root_sbindir)/findfs
+	@if test -n "$(FINDFS_LINK)"; then \
+		echo "  LINK $(root_sbindir)/findfs"; \
+		$(LN) -f $(DESTDIR)$(root_sbindir)/tune2fs \
+			$(DESTDIR)$(root_sbindir)/$(FINDFS_LINK); \
+	fi
 	@for i in $(UPROGS); do \
 		echo "	INSTALL $(bindir)/$$i"; \
 		$(INSTALL_PROGRAM) $$i $(DESTDIR)$(bindir)/$$i; \
@@ -514,7 +522,7 @@ uninstall:
 	for i in $(UMANPAGES); do \
 		$(RM) -f $(DESTDIR)$(man1dir)/$$i; \
 	done
-	for i in findfs e2label ; do \
+	for i in $(FINDFS_LINK) e2label ; do \
 		$(RM) -f $(DESTDIR)$(root_sbindir)/$$i; \
 	done
 	for i in $(FMANPAGES); do \
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 5808e49..b8fdd63 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -95,7 +95,9 @@ struct blk_move {
 
 static const char *please_fsck = N_("Please run e2fsck on the filesystem.\n");
 
+#ifdef CONFIG_BUILD_FINDFS
 void do_findfs(int argc, char **argv);
+#endif
 
 static void usage(void)
 {
@@ -836,6 +838,7 @@ static void parse_tune2fs_options(int argc, char **argv)
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
@@ -1503,8 +1507,10 @@ int main(int argc, char **argv)
 		program_name = *argv;
 	add_error_table(&et_ext2_error_table);
 
+#ifdef CONFIG_BUILD_FINDFS
 	if (strcmp(get_progname(argv[0]), "findfs") == 0)
 		do_findfs(argc, argv);
+#endif
 	if (strcmp(get_progname(argv[0]), "e2label") == 0)
 		parse_e2label_options(argc, argv);
 	else


