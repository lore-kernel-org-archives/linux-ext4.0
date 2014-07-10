From: Ross Burton <ross.burton@intel.com>
Subject: [PATCH] build: use MKDIR_P instead of MKINSTALLDIRS
Date: Thu, 10 Jul 2014 15:39:05 +0100
Message-ID: <1405003145-11506-1-git-send-email-ross.burton@intel.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49287 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaGJOjQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2014 10:39:16 -0400
Received: by mail-wi0-f178.google.com with SMTP id f8so4173528wiw.5
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2014 07:39:15 -0700 (PDT)
Received: from melchett.burtonini.com (35.106.2.81.in-addr.arpa. [81.2.106.35])
        by mx.google.com with ESMTPSA id w5sm32542584wif.3.2014.07.10.07.39.13
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jul 2014 07:39:14 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

---
 MCONFIG.in               |    1 -
 configure.in             |    1 +
 debugfs/Makefile.in      |    4 ++--
 doc/Makefile.in          |    4 ++--
 e2fsck/Makefile.in       |    4 ++--
 intl/Makefile.in         |    4 ++--
 lib/Makefile.elf-lib     |    4 ++--
 lib/Makefile.solaris-lib |    2 +-
 lib/blkid/Makefile.in    |    4 ++--
 lib/e2p/Makefile.in      |    4 ++--
 lib/et/Makefile.in       |    4 ++--
 lib/ext2fs/Makefile.in   |    4 ++--
 lib/ss/Makefile.in       |    4 ++--
 lib/uuid/Makefile.in     |    4 ++--
 misc/Makefile.in         |    4 ++--
 resize/Makefile.in       |    4 ++--
 16 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/MCONFIG.in b/MCONFIG.in
index f80da04..158c533 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -103,7 +103,6 @@ LDCONFIG = @LDCONFIG@
 INSTALL_PROGRAM = @INSTALL_PROGRAM@
 INSTALL_DATA = @INSTALL_DATA@
 INSTALL_SCRIPT = @INSTALL_SCRIPT@
-MKINSTALLDIRS = @MKINSTALLDIRS@
 
 #
 # Library definitions
diff --git a/configure.in b/configure.in
index eb6598f..2018a68 100644
--- a/configure.in
+++ b/configure.in
@@ -889,6 +889,7 @@ AC_SUBST(BINARY_TYPE)
 AC_PROG_MAKE_SET
 CHECK_GNU_MAKE
 AC_PATH_PROG(LN, ln, ln)
+AC_PROG_MKDIR_P
 AC_PROG_LN_S
 AC_PATH_PROG(MV, mv, mv)
 AC_PATH_PROG(CP, cp, cp)
diff --git a/debugfs/Makefile.in b/debugfs/Makefile.in
index 0f23595..56ae442 100644
--- a/debugfs/Makefile.in
+++ b/debugfs/Makefile.in
@@ -95,8 +95,8 @@ debugfs.8: $(DEP_SUBSTITUTE) $(srcdir)/debugfs.8.in
 	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/debugfs.8.in debugfs.8
 
 installdirs:
-	$(E) "	MKINSTALLDIRS $(root_sbindir) $(man8dir)"
-	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(root_sbindir) \
+	$(E) "	MKDIR_P $(root_sbindir) $(man8dir)"
+	$(Q) $(MKDIR_P) $(DESTDIR)$(root_sbindir) \
 		$(DESTDIR)$(man8dir)
 
 install: $(PROGS) $(MANPAGES) installdirs
diff --git a/doc/Makefile.in b/doc/Makefile.in
index a2b2612..9414c20 100644
--- a/doc/Makefile.in
+++ b/doc/Makefile.in
@@ -21,8 +21,8 @@ all:: libext2fs.info libext2fs.dvi libext2fs.html
 
 install-doc-libs: libext2fs.info libext2fs.dvi
 	$(Q) $(RM) -rf $(DESTDIR)$(infodir)/libext2fs.info*
-	$(E) "	MKINSTALLDIRS $(infodir)"
-	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(infodir)
+	$(E) "	MKDIR_P $(infodir)"
+	$(Q) $(MKDIR_P) $(DESTDIR)$(infodir)
 	-$(Q) for i in libext2fs.info* ; do \
 		echo "	INSTALL_DATA $(infodir)/$$i" ; \
 		$(INSTALL_DATA) $$i $(DESTDIR)$(infodir)/$$i ; \
diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index db70abc..f3e6800 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -199,8 +199,8 @@ e2fsck.conf.5: $(DEP_SUBSTITUTE) $(srcdir)/e2fsck.conf.5.in
 	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/e2fsck.conf.5.in e2fsck.conf.5
 
 installdirs:
-	$(E) "	MKINSTALLDIRS $(root_sbindir) $(man8dir)"
-	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(root_sbindir) \
+	$(E) "	MKDIR_P $(root_sbindir) $(man8dir)"
+	$(Q) $(MKDIR_P) $(DESTDIR)$(root_sbindir) \
 		$(DESTDIR)$(man8dir) $(DESTDIR)$(man5dir)
 
 install: $(PROGS) $(MANPAGES) $(FMANPAGES) installdirs
diff --git a/intl/Makefile.in b/intl/Makefile.in
index db6d7d7..adfbb7f 100644
--- a/intl/Makefile.in
+++ b/intl/Makefile.in
@@ -40,8 +40,8 @@ subdir = intl
 
 INSTALL = @INSTALL@
 INSTALL_DATA = @INSTALL_DATA@
-MKINSTALLDIRS = @MKINSTALLDIRS@
-mkinstalldirs = $(SHELL) $(MKINSTALLDIRS)
+MKDIR_P = @MKINSTALLDIRS@
+mkinstalldirs = $(SHELL) $(MKDIR_P)
 
 @SET_MAKE@
 
diff --git a/lib/Makefile.elf-lib b/lib/Makefile.elf-lib
index 78479d3..0b757e6 100644
--- a/lib/Makefile.elf-lib
+++ b/lib/Makefile.elf-lib
@@ -35,8 +35,8 @@ $(ELF_LIB): $(OBJS)
 	$(Q) (cd ..; $(LN) $(LINK_BUILD_FLAGS) $(ELF_LIB) $(ELF_SONAME))
 
 installdirs-elf-lib::
-	$(E) "	MKINSTALLDIRS $(ELF_INSTALL_DIR) $(libdir)"
-	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(ELF_INSTALL_DIR) \
+	$(E) "	MKDIR_P $(ELF_INSTALL_DIR) $(libdir)"
+	$(Q) $(MKDIR_P) $(DESTDIR)$(ELF_INSTALL_DIR) \
 		$(DESTDIR)$(libdir)
 
 installdirs:: installdirs-elf-lib
diff --git a/lib/Makefile.solaris-lib b/lib/Makefile.solaris-lib
index 5990be8..cb00692 100644
--- a/lib/Makefile.solaris-lib
+++ b/lib/Makefile.solaris-lib
@@ -35,7 +35,7 @@ $(ELF_LIB): $(OBJS)
 	$(Q) (cd ..; $(LN) $(LINK_BUILD_FLAGS) $(ELF_LIB) $(ELF_SONAME))
 
 installdirs-elf-lib::
-	$(MKINSTALLDIRS) $(DESTDIR)$(ELF_INSTALL_DIR) \
+	$(MKDIR_P) $(DESTDIR)$(ELF_INSTALL_DIR) \
 		$(DESTDIR)$(libdir)
 
 installdirs:: installdirs-elf-lib
diff --git a/lib/blkid/Makefile.in b/lib/blkid/Makefile.in
index a27b20c..1156393 100644
--- a/lib/blkid/Makefile.in
+++ b/lib/blkid/Makefile.in
@@ -147,8 +147,8 @@ blkid.pc: $(srcdir)/blkid.pc.in $(top_builddir)/config.status
 	$(Q) cd $(top_builddir); CONFIG_FILES=lib/blkid/blkid.pc ./config.status
 
 installdirs::
-	$(E) "	MKINSTALLDIRS $(libdir) $(includedir)/blkid"
-	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
+	$(E) "	MKDIR_P $(libdir) $(includedir)/blkid"
+	$(Q) $(MKDIR_P) $(DESTDIR)$(libdir) \
 		$(DESTDIR)$(includedir)/blkid $(DESTDIR)$(pkgconfigdir)
 
 install:: all installdirs 
diff --git a/lib/e2p/Makefile.in b/lib/e2p/Makefile.in
index c8925cf..b87d5af 100644
--- a/lib/e2p/Makefile.in
+++ b/lib/e2p/Makefile.in
@@ -81,8 +81,8 @@ check::	tst_ostype tst_feature
 	./tst_feature
 
 installdirs::
-	$(E) "	MKINSTALLDIRS $(libdir) $(includedir)/e2p"
-	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
+	$(E) "	MKDIR_P $(libdir) $(includedir)/e2p"
+	$(Q) $(MKDIR_P) $(DESTDIR)$(libdir) \
 		$(DESTDIR)$(includedir)/e2p $(DESTDIR)$(pkgconfigdir)
 
 install:: all installdirs 
diff --git a/lib/et/Makefile.in b/lib/et/Makefile.in
index f9a79c0..a7599ca 100644
--- a/lib/et/Makefile.in
+++ b/lib/et/Makefile.in
@@ -102,8 +102,8 @@ TAGS:	$(SRCS)
 	$(TAGS) $(SRCS)
 
 installdirs::
-	$(E) "	MKINSTALLDIRS $(libdir) $(includedir)/et $(datadir)/et $(bindir) $(man1dir) $(man3dir)"
-	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
+	$(E) "	MKDIR_P $(libdir) $(includedir)/et $(datadir)/et $(bindir) $(man1dir) $(man3dir)"
+	$(Q) $(MKDIR_P) $(DESTDIR)$(libdir) \
 		$(DESTDIR)$(includedir)/et $(DESTDIR)$(datadir)/et \
 		$(DESTDIR)$(bindir) $(DESTDIR)$(man1dir) \
 		$(DESTDIR)$(man3dir) $(DESTDIR)$(pkgconfigdir)
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index ddf5942..996e19c 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -499,8 +499,8 @@ check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount \
 	diff $(srcdir)/tst_bitmaps_exp tst_bitmaps_out
 
 installdirs::
-	$(E) "	MKINSTALLDIRS $(libdir) $(includedir)/ext2fs"
-	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
+	$(E) "	MKDIR_P $(libdir) $(includedir)/ext2fs"
+	$(Q) $(MKDIR_P) $(DESTDIR)$(libdir) \
 		$(DESTDIR)$(includedir)/ext2fs $(DESTDIR)$(pkgconfigdir)
 
 install:: all $(HFILES) $(HFILES_IN) installdirs ext2fs.pc
diff --git a/lib/ss/Makefile.in b/lib/ss/Makefile.in
index 0647f6c..c2475c4 100644
--- a/lib/ss/Makefile.in
+++ b/lib/ss/Makefile.in
@@ -126,8 +126,8 @@ ss.pc: $(srcdir)/ss.pc.in $(top_builddir)/config.status
 	$(Q) cd $(top_builddir); CONFIG_FILES=lib/ss/ss.pc ./config.status
 
 installdirs::
-	$(E) "	MKINSTALLDIRS $(libdir) $(includedir)/ss $(datadir)/ss $(bindir)"
-	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
+	$(E) "	MKDIR_P $(libdir) $(includedir)/ss $(datadir)/ss $(bindir)"
+	$(Q) $(MKDIR_P) $(DESTDIR)$(libdir) \
 		$(DESTDIR)$(includedir)/ss $(DESTDIR)$(datadir)/ss \
 		$(DESTDIR)$(bindir) $(DESTDIR)$(pkgconfigdir)
 
diff --git a/lib/uuid/Makefile.in b/lib/uuid/Makefile.in
index f22ab26..dfecf04 100644
--- a/lib/uuid/Makefile.in
+++ b/lib/uuid/Makefile.in
@@ -132,8 +132,8 @@ uuid.pc: $(srcdir)/uuid.pc.in $(top_builddir)/config.status
 	$(Q) cd $(top_builddir); CONFIG_FILES=lib/uuid/uuid.pc ./config.status
 
 installdirs::
-	$(E) "	MKINSTALLDIRS $(libdir) $(includedir)/uuid $(man3dir)"
-	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(libdir)  \
+	$(E) "	MKDIR_P $(libdir) $(includedir)/uuid $(man3dir)"
+	$(Q) $(MKDIR_P) $(DESTDIR)$(libdir)  \
 		$(DESTDIR)$(includedir)/uuid $(DESTDIR)$(man3dir) \
 		$(DESTDIR)$(pkgconfigdir)
 
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 94fac22..69eb4e7 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -447,8 +447,8 @@ filefrag.8: $(DEP_SUBSTITUTE) $(srcdir)/filefrag.8.in
 	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/filefrag.8.in filefrag.8
 
 installdirs:
-	$(E) "	MKINSTALLDIRS $(sbindir) $(root_sbindir) $(bindir) $(man1dir) $(man8dir) $(libdir) $(root_sysconfdir)"
-	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(sbindir) \
+	$(E) "	MKDIR_P $(sbindir) $(root_sbindir) $(bindir) $(man1dir) $(man8dir) $(libdir) $(root_sysconfdir)"
+	$(Q) $(MKDIR_P) $(DESTDIR)$(sbindir) \
 		$(DESTDIR)$(root_sbindir) $(DESTDIR)$(bindir) \
 		$(DESTDIR)$(man1dir) $(DESTDIR)$(man8dir) \
 		$(DESTDIR)$(man1dir) $(DESTDIR)$(man5dir) \
diff --git a/resize/Makefile.in b/resize/Makefile.in
index 201e268..c523d3a 100644
--- a/resize/Makefile.in
+++ b/resize/Makefile.in
@@ -61,8 +61,8 @@ test_extent: $(TEST_EXTENT_OBJS)
 	$(Q) $(CC) $(ALL_LDFLAGS) -o test_extent $(TEST_EXTENT_OBJS) $(LIBS) 
 
 installdirs:
-	$(E) "	MKINSTALLDIRS $(root_sbindir) $(man8dir)"
-	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(root_sbindir) \
+	$(E) "	MKDIR_P $(root_sbindir) $(man8dir)"
+	$(Q) $(MKDIR_P) $(DESTDIR)$(root_sbindir) \
 		$(DESTDIR)$(man8dir)
 
 install: $(PROGS) $(MANPAGES) installdirs
-- 
1.7.10.4

