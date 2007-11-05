From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH/RFC e2fsprogs] - replace MKINSTALLDIRS with MKDIR_P for newer
 autotools
Date: Mon, 05 Nov 2007 15:55:20 -0600
Message-ID: <472F9148.1050405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbXKEVz3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2007 16:55:29 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lA5LtP89030006
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 16:55:25 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lA5LtOMs012375
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 16:55:24 -0500
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id lA5LtLQv027847
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 16:55:22 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Thomas Woerner <twoerner@redhat.com <mailto:twoerner@redhat.com>>

(Thomas was the original author of this patch)

I do not claim to be an autotools guru, hence the RFC.
RH bugzilla #220715 claims that newer autoconf/automake no longer
support MKINSTALLDIRS, and the changelog seems to confirm that, as
does testing.  :)

The following is the patch we've been carrying for Fedora:

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Addresses-Red-Hat-Bugzilla: #220715

---

Index: e2fsprogs-git/debugfs/Makefile.in
===================================================================
--- e2fsprogs-git.orig/debugfs/Makefile.in
+++ e2fsprogs-git/debugfs/Makefile.in
@@ -48,8 +48,8 @@ debugfs.8: $(DEP_SUBSTITUTE) $(srcdir)/d
 	@$(SUBSTITUTE_UPTIME) $(srcdir)/debugfs.8.in debugfs.8
 
 installdirs:
-	@echo "	MKINSTALLDIRS $(root_sbindir) $(man8dir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(root_sbindir) \
+	@echo "	MKDIR_P $(root_sbindir) $(man8dir)"
+	@$(MKDIR_P) $(DESTDIR)$(root_sbindir) \
 		$(DESTDIR)$(man8dir)
 
 install: $(PROGS) $(MANPAGES) installdirs
Index: e2fsprogs-git/intl/Makefile.in
===================================================================
--- e2fsprogs-git.orig/intl/Makefile.in
+++ e2fsprogs-git/intl/Makefile.in
@@ -40,8 +40,8 @@ subdir = intl
 
 INSTALL = @INSTALL@
 INSTALL_DATA = @INSTALL_DATA@
-MKINSTALLDIRS = @MKINSTALLDIRS@
-mkinstalldirs = $(SHELL) $(MKINSTALLDIRS)
+MKDIR_P = @MKDIR_P@
+mkdir_p = @MKDIR_P@
 
 l = @INTL_LIBTOOL_SUFFIX_PREFIX@
 
Index: e2fsprogs-git/po/Makefile.in.in
===================================================================
--- e2fsprogs-git.orig/po/Makefile.in.in
+++ e2fsprogs-git/po/Makefile.in.in
@@ -26,11 +26,10 @@ datarootdir = @datarootdir@
 datadir = @datadir@
 localedir = $(datadir)/locale
 gettextsrcdir = $(datadir)/gettext/po
+mkdir_p = @MKDIR_P@
 
 INSTALL = @INSTALL@
 INSTALL_DATA = @INSTALL_DATA@
-MKINSTALLDIRS = @MKINSTALLDIRS@
-mkinstalldirs = $(SHELL) $(MKINSTALLDIRS)
 
 GMSGFMT = @GMSGFMT@
 MSGFMT = @MSGFMT@
@@ -150,7 +149,7 @@ install: install-exec install-data
 install-exec:
 install-data: install-data-@USE_NLS@
 	if test "$(PACKAGE)" = "gettext-tools"; then \
-	  $(mkinstalldirs) $(DESTDIR)$(gettextsrcdir); \
+	  $(mkdir_p) $(DESTDIR)$(gettextsrcdir); \
 	  for file in $(DISTFILES.common) Makevars.template; do \
 	    $(INSTALL_DATA) $(srcdir)/$$file \
 			    $(DESTDIR)$(gettextsrcdir)/$$file; \
@@ -163,13 +162,13 @@ install-data: install-data-@USE_NLS@
 	fi
 install-data-no: all
 install-data-yes: all
-	$(mkinstalldirs) $(DESTDIR)$(datadir)
+	$(mkdir_p) $(DESTDIR)$(datadir)
 	@catalogs='$(CATALOGS)'; \
 	for cat in $$catalogs; do \
 	  cat=`basename $$cat`; \
 	  lang=`echo $$cat | sed -e 's/\.gmo$$//'`; \
 	  dir=$(localedir)/$$lang/LC_MESSAGES; \
-	  $(mkinstalldirs) $(DESTDIR)$$dir; \
+	  $(mkdir_p) $(DESTDIR)$$dir; \
 	  if test -r $$cat; then realcat=$$cat; else realcat=$(srcdir)/$$cat; fi; \
 	  $(INSTALL_DATA) $$realcat $(DESTDIR)$$dir/$(DOMAIN).mo; \
 	  echo "installing $$realcat as $(DESTDIR)$$dir/$(DOMAIN).mo"; \
@@ -209,19 +208,19 @@ installdirs: installdirs-exec installdir
 installdirs-exec:
 installdirs-data: installdirs-data-@USE_NLS@
 	if test "$(PACKAGE)" = "gettext-tools"; then \
-	  $(mkinstalldirs) $(DESTDIR)$(gettextsrcdir); \
+	  $(mkdir_p) $(DESTDIR)$(gettextsrcdir); \
 	else \
 	  : ; \
 	fi
 installdirs-data-no:
 installdirs-data-yes:
-	$(mkinstalldirs) $(DESTDIR)$(datadir)
+	$(mkdir_p) $(DESTDIR)$(datadir)
 	@catalogs='$(CATALOGS)'; \
 	for cat in $$catalogs; do \
 	  cat=`basename $$cat`; \
 	  lang=`echo $$cat | sed -e 's/\.gmo$$//'`; \
 	  dir=$(localedir)/$$lang/LC_MESSAGES; \
-	  $(mkinstalldirs) $(DESTDIR)$$dir; \
+	  $(mkdir_p) $(DESTDIR)$$dir; \
 	  for lc in '' $(EXTRA_LOCALE_CATEGORIES); do \
 	    if test -n "$$lc"; then \
 	      if (cd $(DESTDIR)$(localedir)/$$lang && LC_ALL=C ls -l -d $$lc 2>/dev/null) | grep ' -> ' >/dev/null; then \
Index: e2fsprogs-git/misc/Makefile.in
===================================================================
--- e2fsprogs-git.orig/misc/Makefile.in
+++ e2fsprogs-git/misc/Makefile.in
@@ -234,8 +234,8 @@ filefrag.8: $(DEP_SUBSTITUTE) $(srcdir)/
 	@$(SUBSTITUTE_UPTIME) $(srcdir)/filefrag.8.in filefrag.8
 
 installdirs:
-	@echo "	MKINSTALLDIRS $(sbindir) $(root_sbindir) $(bindir) $(man1dir) $(man8dir) $(libdir) $(root_sysconfdir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(sbindir) \
+	@echo "	MKDIR_P $(sbindir) $(root_sbindir) $(bindir) $(man1dir) $(man8dir) $(libdir) $(root_sysconfdir)"
+	@$(MKDIR_P) $(DESTDIR)$(sbindir) \
 		$(DESTDIR)$(root_sbindir) $(DESTDIR)$(bindir) \
 		$(DESTDIR)$(man1dir) $(DESTDIR)$(man8dir) \
 		$(DESTDIR)$(man1dir) $(DESTDIR)$(man5dir) \
Index: e2fsprogs-git/e2fsck/Makefile.in
===================================================================
--- e2fsprogs-git.orig/e2fsck/Makefile.in
+++ e2fsprogs-git/e2fsck/Makefile.in
@@ -172,8 +172,8 @@ e2fsck.conf.5: $(DEP_SUBSTITUTE) $(srcdi
 	@$(SUBSTITUTE_UPTIME) $(srcdir)/e2fsck.conf.5.in e2fsck.conf.5
 
 installdirs:I do not claim to be an autotools guru, hence the RFC.


RH bugzilla #220715 claims that newer autoconf/automake no longer
support MKINSTALLDIRS, and the changelog seems to support that.
The following is the patch we've been carrying for Fedora:


Addresses-Red-Hat-Bugzilla: #220715

Index: e2fsprogs-git/debugfs/Makefile.in
===================================================================
--- e2fsprogs-git.orig/debugfs/Makefile.in
+++ e2fsprogs-git/debugfs/Makefile.in
@@ -48,8 +48,8 @@ debugfs.8: $(DEP_SUBSTITUTE) $(srcdir)/d
 	@$(SUBSTITUTE_UPTIME) $(srcdir)/debugfs.8.in debugfs.8
 
 installdirs:
-	@echo "	MKINSTALLDIRS $(root_sbindir) $(man8dir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(root_sbindir) \
+	@echo "	MKDIR_P $(root_sbindir) $(man8dir)"
+	@$(MKDIR_P) $(DESTDIR)$(root_sbindir) \
 		$(DESTDIR)$(man8dir)
 
 install: $(PROGS) $(MANPAGES) installdirs
Index: e2fsprogs-git/intl/Makefile.in
===================================================================
--- e2fsprogs-git.orig/intl/Makefile.in
+++ e2fsprogs-git/intl/Makefile.in
@@ -40,8 +40,8 @@ subdir = intl
 
 INSTALL = @INSTALL@
 INSTALL_DATA = @INSTALL_DATA@
-MKINSTALLDIRS = @MKINSTALLDIRS@
-mkinstalldirs = $(SHELL) $(MKINSTALLDIRS)
+MKDIR_P = @MKDIR_P@
+mkdir_p = @MKDIR_P@
 
 l = @INTL_LIBTOOL_SUFFIX_PREFIX@
 
Index: e2fsprogs-git/po/Makefile.in.in
===================================================================
--- e2fsprogs-git.orig/po/Makefile.in.in
+++ e2fsprogs-git/po/Makefile.in.in
@@ -26,11 +26,10 @@ datarootdir = @datarootdir@
 datadir = @datadir@
 localedir = $(datadir)/locale
 gettextsrcdir = $(datadir)/gettext/po
+mkdir_p = @MKDIR_P@
 
 INSTALL = @INSTALL@
 INSTALL_DATA = @INSTALL_DATA@
-MKINSTALLDIRS = @MKINSTALLDIRS@
-mkinstalldirs = $(SHELL) $(MKINSTALLDIRS)
 
 GMSGFMT = @GMSGFMT@
 MSGFMT = @MSGFMT@
@@ -150,7 +149,7 @@ install: install-exec install-data
 install-exec:
 install-data: install-data-@USE_NLS@
 	if test "$(PACKAGE)" = "gettext-tools"; then \
-	  $(mkinstalldirs) $(DESTDIR)$(gettextsrcdir); \
+	  $(mkdir_p) $(DESTDIR)$(gettextsrcdir); \
 	  for file in $(DISTFILES.common) Makevars.template; do \
 	    $(INSTALL_DATA) $(srcdir)/$$file \
 			    $(DESTDIR)$(gettextsrcdir)/$$file; \
@@ -163,13 +162,13 @@ install-data: install-data-@USE_NLS@
 	fi
 install-data-no: all
 install-data-yes: all
-	$(mkinstalldirs) $(DESTDIR)$(datadir)
+	$(mkdir_p) $(DESTDIR)$(datadir)
 	@catalogs='$(CATALOGS)'; \
 	for cat in $$catalogs; do \
 	  cat=`basename $$cat`; \
 	  lang=`echo $$cat | sed -e 's/\.gmo$$//'`; \
 	  dir=$(localedir)/$$lang/LC_MESSAGES; \
-	  $(mkinstalldirs) $(DESTDIR)$$dir; \
+	  $(mkdir_p) $(DESTDIR)$$dir; \
 	  if test -r $$cat; then realcat=$$cat; else realcat=$(srcdir)/$$cat; fi; \
 	  $(INSTALL_DATA) $$realcat $(DESTDIR)$$dir/$(DOMAIN).mo; \
 	  echo "installing $$realcat as $(DESTDIR)$$dir/$(DOMAIN).mo"; \
@@ -209,19 +208,19 @@ installdirs: installdirs-exec installdir
 installdirs-exec:
 installdirs-data: installdirs-data-@USE_NLS@
 	if test "$(PACKAGE)" = "gettext-tools"; then \
-	  $(mkinstalldirs) $(DESTDIR)$(gettextsrcdir); \
+	  $(mkdir_p) $(DESTDIR)$(gettextsrcdir); \
 	else \
 	  : ; \
 	fi
 installdirs-data-no:
 installdirs-data-yes:
-	$(mkinstalldirs) $(DESTDIR)$(datadir)
+	$(mkdir_p) $(DESTDIR)$(datadir)
 	@catalogs='$(CATALOGS)'; \
 	for cat in $$catalogs; do \
 	  cat=`basename $$cat`; \
 	  lang=`echo $$cat | sed -e 's/\.gmo$$//'`; \
 	  dir=$(localedir)/$$lang/LC_MESSAGES; \
-	  $(mkinstalldirs) $(DESTDIR)$$dir; \
+	  $(mkdir_p) $(DESTDIR)$$dir; \
 	  for lc in '' $(EXTRA_LOCALE_CATEGORIES); do \
 	    if test -n "$$lc"; then \
 	      if (cd $(DESTDIR)$(localedir)/$$lang && LC_ALL=C ls -l -d $$lc 2>/dev/null) | grep ' -> ' >/dev/null; then \
Index: e2fsprogs-git/misc/Makefile.in
===================================================================
--- e2fsprogs-git.orig/misc/Makefile.in
+++ e2fsprogs-git/misc/Makefile.in
@@ -234,8 +234,8 @@ filefrag.8: $(DEP_SUBSTITUTE) $(srcdir)/
 	@$(SUBSTITUTE_UPTIME) $(srcdir)/filefrag.8.in filefrag.8
 
 installdirs:
-	@echo "	MKINSTALLDIRS $(sbindir) $(root_sbindir) $(bindir) $(man1dir) $(man8dir) $(libdir) $(root_sysconfdir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(sbindir) \
+	@echo "	MKDIR_P $(sbindir) $(root_sbindir) $(bindir) $(man1dir) $(man8dir) $(libdir) $(root_sysconfdir)"
+	@$(MKDIR_P) $(DESTDIR)$(sbindir) \
 		$(DESTDIR)$(root_sbindir) $(DESTDIR)$(bindir) \
 		$(DESTDIR)$(man1dir) $(DESTDIR)$(man8dir) \
 		$(DESTDIR)$(man1dir) $(DESTDIR)$(man5dir) \
Index: e2fsprogs-git/e2fsck/Makefile.in
===================================================================
--- e2fsprogs-git.orig/e2fsck/Makefile.in
+++ e2fsprogs-git/e2fsck/Makefile.in
@@ -172,8 +172,8 @@ e2fsck.conf.5: $(DEP_SUBSTITUTE) $(srcdi
 	@$(SUBSTITUTE_UPTIME) $(srcdir)/e2fsck.conf.5.in e2fsck.conf.5
 
 installdirs:
-	@echo "	MKINSTALLDIRS $(root_sbindir) $(man8dir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(root_sbindir) \
+	@echo "	MKDIR_P $(root_sbindir) $(man8dir)"
+	@$(MKDIR_P) $(DESTDIR)$(root_sbindir) \
 		$(DESTDIR)$(man8dir) $(DESTDIR)$(man5dir)
 
 install: $(PROGS) $(MANPAGES) installdirs
Index: e2fsprogs-git/doc/Makefile.in
===================================================================
--- e2fsprogs-git.orig/doc/Makefile.in
+++ e2fsprogs-git/doc/Makefile.in
@@ -20,8 +20,8 @@ all:: libext2fs.info libext2fs.dvi
 
 install-doc-libs:
 	@$(RM) -rf $(DESTDIR)$(infodir)/libext2fs.info*
-	@echo "	MKINSTALLDIRS $(infodir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(infodir)
+	@echo "	MKDIR_P $(infodir)"
+	@$(MKDIR_P) $(DESTDIR)$(infodir)
 	@for i in libext2fs.info* ; do \
 		echo "	INSTALL_DATA $(infodir)/$$i" ; \
 		$(INSTALL_DATA) $$i $(DESTDIR)$(infodir)/$$i ; \
Index: e2fsprogs-git/resize/Makefile.in
===================================================================
--- e2fsprogs-git.orig/resize/Makefile.in
+++ e2fsprogs-git/resize/Makefile.in
@@ -57,8 +57,8 @@ test_extent: $(TEST_EXTENT_OBJS)
 	@$(CC) $(ALL_LDFLAGS) -o test_extent $(TEST_EXTENT_OBJS) $(LIBS) 
 
 installdirs:
-	@echo "	MKINSTALLDIRS $(root_sbindir) $(man8dir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(root_sbindir) \
+	@echo "	MKDIR_P $(root_sbindir) $(man8dir)"
+	@$(MKDIR_P) $(DESTDIR)$(root_sbindir) \
 		$(DESTDIR)$(man8dir)
 
 install: $(PROGS) $(MANPAGES) installdirs
Index: e2fsprogs-git/MCONFIG.in
===================================================================
--- e2fsprogs-git.orig/MCONFIG.in
+++ e2fsprogs-git/MCONFIG.in
@@ -63,7 +63,7 @@ LDCONFIG = @LDCONFIG@
 INSTALL_PROGRAM = @INSTALL_PROGRAM@
 INSTALL_DATA = @INSTALL_DATA@
 INSTALL_SCRIPT = @INSTALL_SCRIPT@
-MKINSTALLDIRS = @MKINSTALLDIRS@
+MKDIR_P = @MKDIR_P@
 
 #
 # Library definitions
Index: e2fsprogs-git/lib/blkid/Makefile.in
===================================================================
--- e2fsprogs-git.orig/lib/blkid/Makefile.in
+++ e2fsprogs-git/lib/blkid/Makefile.in
@@ -142,8 +142,8 @@ blkid.pc: $(srcdir)/blkid.pc.in $(top_bu
 	@cd $(top_builddir); CONFIG_FILES=lib/blkid/blkid.pc ./config.status
 
 installdirs::
-	@echo "	MKINSTALLDIRS $(libdir) $(includedir)/blkid"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
+	@echo "	MKDIR_P $(libdir) $(includedir)/blkid"
+	@$(MKDIR_P) $(DESTDIR)$(libdir) \
 		$(DESTDIR)$(includedir)/blkid $(DESTDIR)$(libdir)/pkgconfig
 
 install:: all installdirs 
Index: e2fsprogs-git/lib/et/Makefile.in
===================================================================
--- e2fsprogs-git.orig/lib/et/Makefile.in
+++ e2fsprogs-git/lib/et/Makefile.in
@@ -74,8 +74,8 @@ TAGS:	$(SRCS)
 	$(TAGS) $(SRCS)
 
 installdirs::
-	@echo "	MKINSTALLDIRS $(libdir) $(includedir)/et $(datadir)/et $(bindir) $(man1dir) $(man3dir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
+	@echo "	MKDIR_P $(libdir) $(includedir)/et $(datadir)/et $(bindir) $(man1dir) $(man3dir)"
+	@$(MKDIR_P) $(DESTDIR)$(libdir) \
 		$(DESTDIR)$(includedir)/et $(DESTDIR)$(datadir)/et \
 		$(DESTDIR)$(bindir) $(DESTDIR)$(man1dir) \
 		$(DESTDIR)$(man3dir) $(DESTDIR)$(libdir)/pkgconfig
Index: e2fsprogs-git/lib/uuid/Makefile.in
===================================================================
--- e2fsprogs-git.orig/lib/uuid/Makefile.in
+++ e2fsprogs-git/lib/uuid/Makefile.in
@@ -126,8 +126,8 @@ uuid.pc: $(srcdir)/uuid.pc.in $(top_buil
 	@cd $(top_builddir); CONFIG_FILES=lib/uuid/uuid.pc ./config.status
 
 installdirs::
-	@echo "	MKINSTALLDIRS $(libdir) $(includedir)/uuid $(man3dir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(libdir)  \
+	@echo "	MKDIR_P $(libdir) $(includedir)/uuid $(man3dir)"
+	@$(MKDIR_P) $(DESTDIR)$(libdir)  \
 		$(DESTDIR)$(includedir)/uuid $(DESTDIR)$(man3dir) \
 		$(DESTDIR)$(libdir)/pkgconfig
 
Index: e2fsprogs-git/lib/ext2fs/Makefile.in
===================================================================
--- e2fsprogs-git.orig/lib/ext2fs/Makefile.in
+++ e2fsprogs-git/lib/ext2fs/Makefile.in
@@ -256,8 +256,8 @@ check:: tst_bitops tst_badblocks tst_isc
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_super_size
 
 installdirs::
-	@echo "	MKINSTALLDIRS $(libdir) $(includedir)/ext2fs"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
+	@echo "	MKDIR_P $(libdir) $(includedir)/ext2fs"
+	@$(MKDIR_P) $(DESTDIR)$(libdir) \
 		$(DESTDIR)$(includedir)/ext2fs $(DESTDIR)$(libdir)/pkgconfig
 
 install:: all $(HFILES) $(HFILES_IN) installdirs ext2fs.pc
Index: e2fsprogs-git/lib/Makefile.elf-lib
===================================================================
--- e2fsprogs-git.orig/lib/Makefile.elf-lib
+++ e2fsprogs-git/lib/Makefile.elf-lib
@@ -33,8 +33,8 @@ $(ELF_LIB): $(OBJS)
 	@$(LN) ../$(ELF_LIB) ../$(ELF_SONAME)
 
 installdirs-elf-lib::
-	@echo "	MKINSTALLDIRS $(ELF_INSTALL_DIR) $(libdir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(ELF_INSTALL_DIR) \
+	@echo "	MKDIR_P $(ELF_INSTALL_DIR) $(libdir)"
+	@$(MKDIR_P) $(DESTDIR)$(ELF_INSTALL_DIR) \
 		$(DESTDIR)$(libdir)
 
 installdirs:: installdirs-elf-lib
Index: e2fsprogs-git/lib/e2p/Makefile.in
===================================================================
--- e2fsprogs-git.orig/lib/e2p/Makefile.in
+++ e2fsprogs-git/lib/e2p/Makefile.in
@@ -73,8 +73,8 @@ check::	tst_ostype
 	./tst_ostype
 
 installdirs::
-	@echo "	MKINSTALLDIRS $(libdir) $(includedir)/e2p"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
+	@echo "	MKDIR_P $(libdir) $(includedir)/e2p"
+	@$(MKDIR_P) $(DESTDIR)$(libdir) \
 		$(DESTDIR)$(includedir)/e2p $(DESTDIR)$(libdir)/pkgconfig
 
 install:: all installdirs 
Index: e2fsprogs-git/lib/ss/Makefile.in
===================================================================
--- e2fsprogs-git.orig/lib/ss/Makefile.in
+++ e2fsprogs-git/lib/ss/Makefile.in
@@ -125,8 +125,8 @@ ss.pc: $(srcdir)/ss.pc.in $(top_builddir
 	@cd $(top_builddir); CONFIG_FILES=lib/ss/ss.pc ./config.status
 
 installdirs::
-	@echo "	MKINSTALLDIRS $(libdir) $(includedir)/ss $(datadir)/ss $(bindir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
+	@echo "	MKDIR_P $(libdir) $(includedir)/ss $(datadir)/ss $(bindir)"
+	@$(MKDIR_P) $(DESTDIR)$(libdir) \
 		$(DESTDIR)$(includedir)/ss $(DESTDIR)$(datadir)/ss \
 		$(DESTDIR)$(bindir) $(DESTDIR)$(libdir)/pkgconfig
 
Index: e2fsprogs-git/configure.in
===================================================================
--- e2fsprogs-git.orig/configure.in
+++ e2fsprogs-git/configure.in
@@ -563,6 +563,7 @@ AC_CHECK_TOOL(AR, ar, ar)
 AC_CHECK_TOOL(RANLIB, ranlib,  :) 
 AC_CHECK_TOOL(STRIP, strip,  :) 
 AC_PROG_INSTALL
+AC_PROG_MKDIR_P
 # See if we need a separate native compiler.
 if test $cross_compiling = no; then
   BUILD_CC="$CC"



-	@echo "	MKINSTALLDIRS $(root_sbindir) $(man8dir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(root_sbindir) \
+	@echo "	MKDIR_P $(root_sbindir) $(man8dir)"
+	@$(MKDIR_P) $(DESTDIR)$(root_sbindir) \
 		$(DESTDIR)$(man8dir) $(DESTDIR)$(man5dir)
 
 install: $(PROGS) $(MANPAGES) installdirs
Index: e2fsprogs-git/doc/Makefile.in
===================================================================
--- e2fsprogs-git.orig/doc/Makefile.in
+++ e2fsprogs-git/doc/Makefile.in
@@ -20,8 +20,8 @@ all:: libext2fs.info libext2fs.dvi
 
 install-doc-libs:
 	@$(RM) -rf $(DESTDIR)$(infodir)/libext2fs.info*
-	@echo "	MKINSTALLDIRS $(infodir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(infodir)
+	@echo "	MKDIR_P $(infodir)"
+	@$(MKDIR_P) $(DESTDIR)$(infodir)
 	@for i in libext2fs.info* ; do \
 		echo "	INSTALL_DATA $(infodir)/$$i" ; \
 		$(INSTALL_DATA) $$i $(DESTDIR)$(infodir)/$$i ; \
Index: e2fsprogs-git/resize/Makefile.in
===================================================================
--- e2fsprogs-git.orig/resize/Makefile.in
+++ e2fsprogs-git/resize/Makefile.in
@@ -57,8 +57,8 @@ test_extent: $(TEST_EXTENT_OBJS)
 	@$(CC) $(ALL_LDFLAGS) -o test_extent $(TEST_EXTENT_OBJS) $(LIBS) 
 
 installdirs:
-	@echo "	MKINSTALLDIRS $(root_sbindir) $(man8dir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(root_sbindir) \
+	@echo "	MKDIR_P $(root_sbindir) $(man8dir)"
+	@$(MKDIR_P) $(DESTDIR)$(root_sbindir) \
 		$(DESTDIR)$(man8dir)
 
 install: $(PROGS) $(MANPAGES) installdirs
Index: e2fsprogs-git/MCONFIG.in
===================================================================
--- e2fsprogs-git.orig/MCONFIG.in
+++ e2fsprogs-git/MCONFIG.in
@@ -63,7 +63,7 @@ LDCONFIG = @LDCONFIG@
 INSTALL_PROGRAM = @INSTALL_PROGRAM@
 INSTALL_DATA = @INSTALL_DATA@
 INSTALL_SCRIPT = @INSTALL_SCRIPT@
-MKINSTALLDIRS = @MKINSTALLDIRS@
+MKDIR_P = @MKDIR_P@
 
 #
 # Library definitions
Index: e2fsprogs-git/lib/blkid/Makefile.in
===================================================================
--- e2fsprogs-git.orig/lib/blkid/Makefile.in
+++ e2fsprogs-git/lib/blkid/Makefile.in
@@ -142,8 +142,8 @@ blkid.pc: $(srcdir)/blkid.pc.in $(top_bu
 	@cd $(top_builddir); CONFIG_FILES=lib/blkid/blkid.pc ./config.status
 
 installdirs::
-	@echo "	MKINSTALLDIRS $(libdir) $(includedir)/blkid"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
+	@echo "	MKDIR_P $(libdir) $(includedir)/blkid"
+	@$(MKDIR_P) $(DESTDIR)$(libdir) \
 		$(DESTDIR)$(includedir)/blkid $(DESTDIR)$(libdir)/pkgconfig
 
 install:: all installdirs 
Index: e2fsprogs-git/lib/et/Makefile.in
===================================================================
--- e2fsprogs-git.orig/lib/et/Makefile.in
+++ e2fsprogs-git/lib/et/Makefile.in
@@ -74,8 +74,8 @@ TAGS:	$(SRCS)
 	$(TAGS) $(SRCS)
 
 installdirs::
-	@echo "	MKINSTALLDIRS $(libdir) $(includedir)/et $(datadir)/et $(bindir) $(man1dir) $(man3dir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
+	@echo "	MKDIR_P $(libdir) $(includedir)/et $(datadir)/et $(bindir) $(man1dir) $(man3dir)"
+	@$(MKDIR_P) $(DESTDIR)$(libdir) \
 		$(DESTDIR)$(includedir)/et $(DESTDIR)$(datadir)/et \
 		$(DESTDIR)$(bindir) $(DESTDIR)$(man1dir) \
 		$(DESTDIR)$(man3dir) $(DESTDIR)$(libdir)/pkgconfig
Index: e2fsprogs-git/lib/uuid/Makefile.in
===================================================================
--- e2fsprogs-git.orig/lib/uuid/Makefile.in
+++ e2fsprogs-git/lib/uuid/Makefile.in
@@ -126,8 +126,8 @@ uuid.pc: $(srcdir)/uuid.pc.in $(top_buil
 	@cd $(top_builddir); CONFIG_FILES=lib/uuid/uuid.pc ./config.status
 
 installdirs::
-	@echo "	MKINSTALLDIRS $(libdir) $(includedir)/uuid $(man3dir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(libdir)  \
+	@echo "	MKDIR_P $(libdir) $(includedir)/uuid $(man3dir)"
+	@$(MKDIR_P) $(DESTDIR)$(libdir)  \
 		$(DESTDIR)$(includedir)/uuid $(DESTDIR)$(man3dir) \
 		$(DESTDIR)$(libdir)/pkgconfig
 
Index: e2fsprogs-git/lib/ext2fs/Makefile.in
===================================================================
--- e2fsprogs-git.orig/lib/ext2fs/Makefile.in
+++ e2fsprogs-git/lib/ext2fs/Makefile.in
@@ -256,8 +256,8 @@ check:: tst_bitops tst_badblocks tst_isc
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_super_size
 
 installdirs::
-	@echo "	MKINSTALLDIRS $(libdir) $(includedir)/ext2fs"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
+	@echo "	MKDIR_P $(libdir) $(includedir)/ext2fs"
+	@$(MKDIR_P) $(DESTDIR)$(libdir) \
 		$(DESTDIR)$(includedir)/ext2fs $(DESTDIR)$(libdir)/pkgconfig
 
 install:: all $(HFILES) $(HFILES_IN) installdirs ext2fs.pc
Index: e2fsprogs-git/lib/Makefile.elf-lib
===================================================================
--- e2fsprogs-git.orig/lib/Makefile.elf-lib
+++ e2fsprogs-git/lib/Makefile.elf-lib
@@ -33,8 +33,8 @@ $(ELF_LIB): $(OBJS)
 	@$(LN) ../$(ELF_LIB) ../$(ELF_SONAME)
 
 installdirs-elf-lib::
-	@echo "	MKINSTALLDIRS $(ELF_INSTALL_DIR) $(libdir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(ELF_INSTALL_DIR) \
+	@echo "	MKDIR_P $(ELF_INSTALL_DIR) $(libdir)"
+	@$(MKDIR_P) $(DESTDIR)$(ELF_INSTALL_DIR) \
 		$(DESTDIR)$(libdir)
 
 installdirs:: installdirs-elf-lib
Index: e2fsprogs-git/lib/e2p/Makefile.in
===================================================================
--- e2fsprogs-git.orig/lib/e2p/Makefile.in
+++ e2fsprogs-git/lib/e2p/Makefile.in
@@ -73,8 +73,8 @@ check::	tst_ostype
 	./tst_ostype
 
 installdirs::
-	@echo "	MKINSTALLDIRS $(libdir) $(includedir)/e2p"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
+	@echo "	MKDIR_P $(libdir) $(includedir)/e2p"
+	@$(MKDIR_P) $(DESTDIR)$(libdir) \
 		$(DESTDIR)$(includedir)/e2p $(DESTDIR)$(libdir)/pkgconfig
 
 install:: all installdirs 
Index: e2fsprogs-git/lib/ss/Makefile.in
===================================================================
--- e2fsprogs-git.orig/lib/ss/Makefile.in
+++ e2fsprogs-git/lib/ss/Makefile.in
@@ -125,8 +125,8 @@ ss.pc: $(srcdir)/ss.pc.in $(top_builddir
 	@cd $(top_builddir); CONFIG_FILES=lib/ss/ss.pc ./config.status
 
 installdirs::
-	@echo "	MKINSTALLDIRS $(libdir) $(includedir)/ss $(datadir)/ss $(bindir)"
-	@$(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
+	@echo "	MKDIR_P $(libdir) $(includedir)/ss $(datadir)/ss $(bindir)"
+	@$(MKDIR_P) $(DESTDIR)$(libdir) \
 		$(DESTDIR)$(includedir)/ss $(DESTDIR)$(datadir)/ss \
 		$(DESTDIR)$(bindir) $(DESTDIR)$(libdir)/pkgconfig
 
Index: e2fsprogs-git/configure.in
===================================================================
--- e2fsprogs-git.orig/configure.in
+++ e2fsprogs-git/configure.in
@@ -563,6 +563,7 @@ AC_CHECK_TOOL(AR, ar, ar)
 AC_CHECK_TOOL(RANLIB, ranlib,  :) 
 AC_CHECK_TOOL(STRIP, strip,  :) 
 AC_PROG_INSTALL
+AC_PROG_MKDIR_P
 # See if we need a separate native compiler.
 if test $cross_compiling = no; then
   BUILD_CC="$CC"
