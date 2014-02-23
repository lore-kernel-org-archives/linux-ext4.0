From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Add coverage testing using gcov
Date: Sun, 23 Feb 2014 00:19:29 -0500
Message-ID: <1393132769-23648-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32975 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaBWFTg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Feb 2014 00:19:36 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To check the coverage of e2fsprogs's regression test, do the
following:

	configure --enable-gcov
	make -j8 ; make -j8 check ; make coverage.txt

The coverage information will be the coverage.txt and *.gcov files in
the build directories.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 MCONFIG.in              |  8 ++++++++
 Makefile.in             | 11 +++++++----
 configure               | 14 ++++++++++++++
 configure.in            | 12 ++++++++++++
 debugfs/Makefile.in     |  2 +-
 e2fsck/Makefile.in      |  2 +-
 ext2ed/Makefile.in      |  2 +-
 intl/Makefile.in        |  3 ++-
 lib/blkid/Makefile.in   |  2 +-
 lib/ext2fs/Makefile.in  | 14 +++++++-------
 misc/Makefile.in        |  2 +-
 po/Makefile.in.in       |  4 +++-
 resize/Makefile.in      |  2 +-
 tests/progs/Makefile.in |  2 +-
 util/Makefile.in        |  2 +-
 15 files changed, 61 insertions(+), 21 deletions(-)

diff --git a/MCONFIG.in b/MCONFIG.in
index af649ed..5ed4df0 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -249,6 +249,14 @@ Makefile: $(srcdir)/Makefile.in $(top_builddir)/MCONFIG \
 @MAINTAINER_CMT@$(top_srcdir)/configure: $(top_srcdir)/configure.in
 @MAINTAINER_CMT@	cd $(top_srcdir) && autoheader && autoconf
 
+coverage.txt: Makefile $(SRCS)
+	if test -n "$(SRCS)"; then \
+		gcov -s $(top_srcdir) -o . $(SRCS) > coverage.txt 2>&1 ; \
+	fi
+
+clean::
+	$(RM) -f *.gcda *.gcov *.gcno coverage.txt
+
 #
 # Make depend magic...
 #
diff --git a/Makefile.in b/Makefile.in
index f327d19..cf129db 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -73,10 +73,12 @@ install-libs: install-libs-recursive
 
 uninstall-libs: uninstall-libs-recursive
 
+coverage.txt: coverage.txt-recursive
+
 check-recursive: all
 
 TAGS clean-recursive distclean-recursive depend-recursive check-recursive \
-  mostlyclean-recursive realclean-recursive:
+  mostlyclean-recursive realclean-recursive coverage.txt-recursive:
 	@for subdir in $(SUBDIRS); do \
 	  if test -d $$subdir ; then \
 	    target=`echo $@|$(SED) 's/-recursive//'`; \
@@ -86,7 +88,7 @@ TAGS clean-recursive distclean-recursive depend-recursive check-recursive \
 	done
 
 all-progs-recursive install-progs-recursive install-strip-progs-recursive \
-  uninstall-progs-recursive: all-libs-recursive
+  uninstall-progs-recursive coverage.txt-progs-recursive: all-libs-recursive
 	@for subdir in $(PROG_SUBDIRS); do \
 	  if test -d $$subdir ; then \
 	    target=`echo $@|$(SED) 's/-progs-recursive//'`; \
@@ -97,7 +99,8 @@ all-progs-recursive install-progs-recursive install-strip-progs-recursive \
 
 all-libs-recursive install-libs-recursive install-strip-libs-recursive \
   uninstall-libs-recursive install-shlibs-libs-recursive \
-  install-shlibs-strip-libs-recursive uninstall-shlibs-libs-recursive:
+  install-shlibs-strip-libs-recursive uninstall-shlibs-libs-recursive \
+  coverage.txt-libs-recursive:
 	@for subdir in $(LIB_SUBDIRS); do \
 	  if test -d $$subdir ; then \
 	    target=`echo $@|$(SED) 's/-libs-recursive//'`; \
@@ -108,7 +111,7 @@ all-libs-recursive install-libs-recursive install-strip-libs-recursive \
 
 mostlyclean: mostlyclean-recursive mostlyclean-local
 
-clean: clean-recursive clean-local clean-doc
+clean:: clean-recursive clean-local clean-doc
 	$(RM) -f $(SUBS) 
 
 distclean: distclean-doc distclean-recursive
diff --git a/configure b/configure
index 19e8d82..44664c3 100755
--- a/configure
+++ b/configure
@@ -836,6 +836,7 @@ enable_htree
 enable_elf_shlibs
 enable_bsd_shlibs
 enable_profile
+enable_gcov
 enable_checker
 enable_jbd_debug
 enable_blkid_debug
@@ -1492,6 +1493,7 @@ Optional Features:
   --enable-elf-shlibs	  select ELF shared libraries
   --enable-bsd-shlibs	  select BSD shared libraries
   --enable-profile	  build profiling libraries
+  --enable-gcov	  	  build for coverage testing using gcov
   --enable-checker	  build checker libraries
   --enable-jbd-debug  	  enable journal debugging
   --enable-blkid-debug    enable blkid debugging
@@ -4677,6 +4679,18 @@ fi
 
 
 
+# Check whether --enable-gcov was given.
+if test "${enable_gcov+set}" = set; then :
+  enableval=$enable_gcov; if test "$enableval" = "yes"
+then
+	CFLAGS="-g -fprofile-arcs -ftest-coverage"
+	LDFLAGS="-fprofile-arcs -ftest-coverage"
+	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Enabling gcov support" >&5
+$as_echo "Enabling gcov support" >&6; }
+fi
+
+fi
+
 # Check whether --enable-checker was given.
 if test "${enable_checker+set}" = set; then :
   enableval=$enable_checker; if test "$enableval" = "no"
diff --git a/configure.in b/configure.in
index fffab7a..e0e6d48 100644
--- a/configure.in
+++ b/configure.in
@@ -381,6 +381,18 @@ AC_MSG_RESULT([Disabling profiling libraries by default])
 AC_SUBST(PROFILE_CMT)
 AC_SUBST_FILE(MAKEFILE_PROFILE)
 dnl
+dnl handle --enable-gcov
+dnl
+AC_ARG_ENABLE([gcov],
+[  --enable-gcov	  	  build for coverage testing using gcov],
+if test "$enableval" = "yes"
+then
+	CFLAGS="-g -fprofile-arcs -ftest-coverage"
+	LDFLAGS="-fprofile-arcs -ftest-coverage"
+	AC_MSG_RESULT([Enabling gcov support])
+fi
+)
+dnl
 dnl handle --enable-checker
 dnl
 AC_ARG_ENABLE([checker],
diff --git a/debugfs/Makefile.in b/debugfs/Makefile.in
index 80fba5d..5ddeab7 100644
--- a/debugfs/Makefile.in
+++ b/debugfs/Makefile.in
@@ -117,7 +117,7 @@ uninstall:
 		$(RM) -f $(DESTDIR)$(man8dir)/$$i; \
 	done
 
-clean:
+clean::
 	$(RM) -f $(PROGS) debugfs.8 \#* *.s *.o *.a *~ debug_cmds.c \
 		extent_cmds.c ro_debug_cmds.c core rdebugfs debugfs.static
 
diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 897bc2b..77017ef 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -273,7 +273,7 @@ uninstall:
 			$(DESTDIR)$(root_sbindir)/fsck.ext4 \
 			$(DESTDIR)$(root_sbindir)/fsck.ext4dev
 
-clean:
+clean::
 	$(RM) -f $(PROGS) \#* *\# *.s *.o *.a *~ core e2fsck.static \
 		e2fsck.shared e2fsck.profiled flushb e2fsck.8 \
 		tst_problem tst_crc32 tst_region tst_refcount gen_crc32table \
diff --git a/ext2ed/Makefile.in b/ext2ed/Makefile.in
index 290f06e..5f4cc69 100644
--- a/ext2ed/Makefile.in
+++ b/ext2ed/Makefile.in
@@ -65,7 +65,7 @@ ext2ed.8: $(DEP_SUBSTITUTE) $(srcdir)/ext2ed.8.in
 ext2ed.conf: $(DEP_SUBSTITUTE) $(srcdir)/ext2ed.conf.in
 	$(SUBSTITUTE_UPTIME) $(srcdir)/ext2ed.conf.in ext2ed.conf
 
-clean:
+clean::
 	$(RM) -f ext2ed $(OBJS) $(DOCS) ext2ed.conf ext2ed.8
 	-rmdir doc
 
diff --git a/intl/Makefile.in b/intl/Makefile.in
index 49989e8..87d081f 100644
--- a/intl/Makefile.in
+++ b/intl/Makefile.in
@@ -488,13 +488,14 @@ id: ID
 ID: $(HEADERS) $(SOURCES)
 	here=`pwd`; cd $(srcdir) && mkid -f$$here/ID $(HEADERS) $(SOURCES)
 
+coverage.txt::
 
 mostlyclean:
 	rm -f *.a *.la *.o *.obj *.lo core core.*
 	rm -f libgnuintl.h libintl.h charset.alias ref-add.sed ref-del.sed
 	rm -f -r .libs _libs
 
-clean: mostlyclean
+clean:: mostlyclean
 
 distclean: clean
 	rm -f Makefile ID TAGS
diff --git a/lib/blkid/Makefile.in b/lib/blkid/Makefile.in
index 3f15c67..faed6f1 100644
--- a/lib/blkid/Makefile.in
+++ b/lib/blkid/Makefile.in
@@ -118,7 +118,7 @@ tst_tag: $(srcdir)/tag.c $(DEPLIBS_BLKID)
 
 tst_types: tst_types.o blkid_types.h 
 	$(E) "	LD $@"
-	$(Q) $(CC) -o tst_types tst_types.o 
+	$(Q) $(CC) -o tst_types $(ALL_LDFLAGS) tst_types.o
 
 ../../misc/blkid.o: $(top_srcdir)/misc/blkid.c blkid.h
 	$(E) "	CC $@"
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 1063e62..ad6525a 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -224,8 +224,8 @@ ext2fs.pc: $(srcdir)/ext2fs.pc.in $(top_builddir)/config.status
 
 tst_badblocks: tst_badblocks.o $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
-	$(Q) $(CC) -o tst_badblocks tst_badblocks.o $(STATIC_LIBEXT2FS) \
-		$(STATIC_LIBCOM_ERR) $(SYSLIBS)
+	$(Q) $(CC) -o tst_badblocks tst_badblocks.o $(ALL_LDFLAGS) \
+		$(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR) $(SYSLIBS)
 
 tst_icount: $(srcdir)/icount.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
@@ -234,7 +234,7 @@ tst_icount: $(srcdir)/icount.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 
 tst_iscan: tst_iscan.o $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
-	$(Q) $(CC) -o tst_iscan tst_iscan.o $(STATIC_LIBEXT2FS) \
+	$(Q) $(CC) -o tst_iscan tst_iscan.o $(ALL_LDFLAGS) $(STATIC_LIBEXT2FS) \
 		$(STATIC_LIBCOM_ERR) $(SYSLIBS)
 
 tst_getsize: tst_getsize.o $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
@@ -268,13 +268,13 @@ tst_types.o: $(srcdir)/tst_types.c ext2_types.h
 
 tst_types: tst_types.o ext2_types.h 
 	$(E) "	LD $@"
-	$(Q) $(CC) -o tst_types tst_types.o $(SYSLIBS)
+	$(Q) $(CC) -o tst_types tst_types.o $(ALL_LDFLAGS) $(SYSLIBS)
 
 tst_super_size.o: $(srcdir)/tst_super_size.c $(srcdir)/ext2_fs.h
 
 tst_super_size: tst_super_size.o
 	$(E) "	LD $@"
-	$(Q) $(CC) -o tst_super_size tst_super_size.o $(SYSLIBS)
+	$(Q) $(CC) -o tst_super_size tst_super_size.o $(ALL_LDFLAGS) $(SYSLIBS)
 
 tst_fs_struct.o: $(srcdir)/tst_fs_struct.c $(srcdir)/ext2fs.h
 
@@ -286,11 +286,11 @@ tst_inode_size.o: $(srcdir)/tst_inode_size.c $(srcdir)/ext2_fs.h
 
 tst_inode_size: tst_inode_size.o
 	$(E) "	LD $@"
-	$(Q) $(CC) -o tst_inode_size tst_inode_size.o $(SYSLIBS)
+	$(Q) $(CC) -o tst_inode_size tst_inode_size.o $(ALL_LDFLAGS) $(SYSLIBS)
 
 ext2_tdbtool: tdbtool.o
 	$(E) "	LD $@"
-	$(Q) $(CC) -o ext2_tdbtool tdbtool.o tdb.o $(SYSLIBS)
+	$(Q) $(CC) -o ext2_tdbtool tdbtool.o tdb.o $(ALL_LDFLAGS) $(SYSLIBS)
 
 extent_dbg.c: $(srcdir)/extent_dbg.ct
 	$(E) "	MK_CMDS $<"
diff --git a/misc/Makefile.in b/misc/Makefile.in
index e8cfdb5..29b6aab 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -599,7 +599,7 @@ uninstall:
 		$(RM) $(DESTDIR)/$(root_sysconfdir)/mke2fs.conf; \
 	fi
 
-clean:
+clean::
 	$(RM) -f $(SPROGS) $(USPROGS) $(UPROGS) $(UMANPAGES) $(SMANPAGES) \
 		$(FMANPAGES) profile.h \
 		base_device base_device.out mke2fs.static filefrag e2freefrag \
diff --git a/po/Makefile.in.in b/po/Makefile.in.in
index 8dbd0c5..2ae2f2a 100644
--- a/po/Makefile.in.in
+++ b/po/Makefile.in.in
@@ -281,7 +281,9 @@ mostlyclean:
 	rm -f $(DOMAIN).po.bak
 	rm -fr *.o
 
-clean: mostlyclean
+coverage.txt::
+
+clean:: mostlyclean
 
 distclean: clean
 	rm -f Makefile Makefile.in POTFILES *.mo
diff --git a/resize/Makefile.in b/resize/Makefile.in
index eb6f890..f7b80ef 100644
--- a/resize/Makefile.in
+++ b/resize/Makefile.in
@@ -104,7 +104,7 @@ check:: test_extent.out
 		exit 1 ; \
 	fi
 
-clean:
+clean::
 	$(RM) -f $(PROGS) $(TEST_PROGS) $(MANPAGES) \#* *.s *.o *.a *~ core \
 		resize2fs.static test_extent.out
 
diff --git a/tests/progs/Makefile.in b/tests/progs/Makefile.in
index 4c63991..44d04b5 100644
--- a/tests/progs/Makefile.in
+++ b/tests/progs/Makefile.in
@@ -51,7 +51,7 @@ test_icount_cmds.c: test_icount_cmds.ct
 	$(E) "	MK_CMDS $@"
 	$(Q) $(MK_CMDS) $(srcdir)/test_icount_cmds.ct
 
-clean:
+clean::
 	$(RM) -f $(PROGS) test_rel_cmds.c test_icount_cmds.c \
 		\#* *.s *.o *.a *~ core
 
diff --git a/util/Makefile.in b/util/Makefile.in
index 69683b0..d235fff 100644
--- a/util/Makefile.in
+++ b/util/Makefile.in
@@ -50,7 +50,7 @@ tarballs: gen-tarball
 	sh gen-tarball all
 	sh gen-tarball subset
 
-clean:
+clean::
 	$(RM) -f $(PROGS) \#* *.s *.o *.a *~ core *.tar.gz gen-tarball \
 		copy-sparse dirpaths.h
 
-- 
1.9.0

