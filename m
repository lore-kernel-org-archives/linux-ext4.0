From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: remove checker infrastructure
Date: Thu, 17 Apr 2014 17:05:38 -0500
Message-ID: <53505032.5060303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbaDQWFj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Apr 2014 18:05:39 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3HM5d0Z012192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Apr 2014 18:05:39 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s3HM5cHo001238
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Apr 2014 18:05:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Per http://www.gnu.org/software/checker/ the gcc "-checker" option
is long deprecated.  Nuke it from e2fsprogs.

Most people would never hit this, but people who love to turn
knobs, such as the reporter of kernel.org bz#74171, might
run into it and be sad.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This hits "configure" too,but maybe you just want to regenerate
it from the configure.in change, I dunno.

-Eric

diff --git a/configure b/configure
index 6449f59..60a4c8a 100755
--- a/configure
+++ b/configure
@@ -4697,36 +4697,6 @@ fi
 
 fi
 
-# Check whether --enable-checker was given.
-if test "${enable_checker+set}" = set; then :
-  enableval=$enable_checker; if test "$enableval" = "no"
-then
-	CHECKER_CMT=#
-	MAKEFILE_CHECKER=/dev/null
-	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Disabling checker libraries" >&5
-$as_echo "Disabling checker libraries" >&6; }
-else
-	CHECKER_CMT=
-	MAKEFILE_CHECKER=$srcdir/lib/Makefile.checker
-	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Building checker libraries" >&5
-$as_echo "Building checker libraries" >&6; }
-fi
-
-else
-  CHECKER_CMT=#
-MAKEFILE_CHECKER=/dev/null
-{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Disabling checker libraries by default" >&5
-$as_echo "Disabling checker libraries by default" >&6; }
-
-fi
-
-
-
-
-
-
-
-
 # Check whether --enable-jbd-debug was given.
 if test "${enable_jbd_debug+set}" = set; then :
   enableval=$enable_jbd_debug; if test "$enableval" = "no"
diff --git a/configure.in b/configure.in
index 8a033b0..a13be2c 100644
--- a/configure.in
+++ b/configure.in
@@ -392,28 +392,7 @@ then
 	AC_MSG_RESULT([Enabling gcov support])
 fi
 )
-dnl
-dnl handle --enable-checker
-dnl
-AC_ARG_ENABLE([checker],
-[  --enable-checker	  build checker libraries],
-if test "$enableval" = "no"
-then
-	CHECKER_CMT=#
-	MAKEFILE_CHECKER=/dev/null
-	AC_MSG_RESULT([Disabling checker libraries])
-else
-	CHECKER_CMT=
-	MAKEFILE_CHECKER=$srcdir/lib/Makefile.checker
-	AC_MSG_RESULT([Building checker libraries])
-fi
-,
-CHECKER_CMT=#
-MAKEFILE_CHECKER=/dev/null
-AC_MSG_RESULT([Disabling checker libraries by default])
-)
-AC_SUBST(CHECKER_CMT)
-AC_SUBST_FILE(MAKEFILE_CHECKER)
+
 dnl
 dnl Substitute library extensions
 dnl
diff --git a/lib/Makefile.checker b/lib/Makefile.checker
deleted file mode 100644
index 7bff0f4..0000000
--- a/lib/Makefile.checker
+++ /dev/null
@@ -1,17 +0,0 @@
-all:: $(LIBRARY)_chk.a
-
-real-subdirs:: Makefile
-	$(E) "	MKDIR checker"
-	$(Q) mkdir -p checker
-
-clean::
-	$(RM) -rf checker
-
-$(LIBRARY)_chk.a: $(OBJS)
-	$(E) "	GEN_CHECKER_LIB $@"
-	$(Q) (test -r $@ && $(RM) -f $@.bak && $(MV) $@ $@.bak)
-	$(Q) (cd checker; $(ARGEN) $@ $(OBJS))
-	-$(Q) $(RANLIB) $@
-	$(Q) $(RM) -f ../$@
-	$(Q) (cd .. ; $(LN) $(LINK_BUILD_FLAGS) \
-	     `echo $(my_dir) | sed -e 's;lib/;;'`/$@ $@)
diff --git a/lib/blkid/Makefile.in b/lib/blkid/Makefile.in
index 69b5b4c..2ae223c 100644
--- a/lib/blkid/Makefile.in
+++ b/lib/blkid/Makefile.in
@@ -58,7 +58,6 @@ DEPLIBS_BLKID=	$(DEPSTATIC_LIBBLKID) $(DEPSTATIC_LIBUUID)
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 	$(Q) $(CPPCHECK_CMD) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
-@CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
 @BSDLIB_CMT@	$(Q) $(CC) $(ALL_CFLAGS) $(BSDLIB_PIC_FLAG) -o pic/$*.o -c $<
 
diff --git a/lib/e2p/Makefile.in b/lib/e2p/Makefile.in
index 761ac48..eb307aa 100644
--- a/lib/e2p/Makefile.in
+++ b/lib/e2p/Makefile.in
@@ -58,7 +58,6 @@ BSDLIB_INSTALL_DIR = $(root_libdir)
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 	$(Q) $(CPPCHECK_CMD) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
-@CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
 @BSDLIB_CMT@	$(Q) $(CC) $(ALL_CFLAGS) $(BSDLIB_PIC_FLAG) -o pic/$*.o -c $<
 
diff --git a/lib/et/Makefile.in b/lib/et/Makefile.in
index 4f2d31f..ca332b5 100644
--- a/lib/et/Makefile.in
+++ b/lib/et/Makefile.in
@@ -46,7 +46,6 @@ BSDLIB_INSTALL_DIR = $(root_libdir)
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 	$(Q) $(CPPCHECK_CMD) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
-@CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
 @BSDLIB_CMT@	$(Q) $(CC) $(ALL_CFLAGS) $(BSDLIB_PIC_FLAG) -o pic/$*.o -c $<
 
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 0c880c7..427fcb8 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -207,7 +207,6 @@ all:: ext2fs.pc
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 	$(Q) $(CPPCHECK_CMD) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
-@CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
 @BSDLIB_CMT@	$(Q) $(CC) $(ALL_CFLAGS) $(BSDLIB_PIC_FLAG) -o pic/$*.o -c $<
 
diff --git a/lib/quota/Makefile.in b/lib/quota/Makefile.in
index 0344d09..207dd9e 100644
--- a/lib/quota/Makefile.in
+++ b/lib/quota/Makefile.in
@@ -50,7 +50,6 @@ LIBDIR= quota
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 	$(Q) $(CPPCHECK_CMD) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
-@CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 #ELF_CMT#	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
 #BSDLIB_CMT#	$(Q) $(CC) $(ALL_CFLAGS) $(BSDLIB_PIC_FLAG) -o pic/$*.o -c $<
 
@@ -65,8 +64,6 @@ dict.o:
 	$(Q) $(CC) -c $(ALL_CFLAGS) $(top_srcdir)/e2fsck/dict.c -o $@
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/dict.o -c \
 @PROFILE_CMT@	$(top_srcdir)/e2fsck/dict.c
-@CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c \
-@CHECKER_CMT@	$(top_srcdir)/e2fsck/dict.c
 #ELF_CMT#	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c \
 #ELF_CMT#	$(top_srcdir)/e2fsck/dict.c
 #BSDLIB_CMT#	$(Q) $(CC) $(ALL_CFLAGS) $(BSDLIB_PIC_FLAG) -o pic/$*.o -c \
diff --git a/lib/ss/Makefile.in b/lib/ss/Makefile.in
index 4c1ef8f..fdae4a5 100644
--- a/lib/ss/Makefile.in
+++ b/lib/ss/Makefile.in
@@ -37,7 +37,6 @@ MK_CMDS=_SS_DIR_OVERRIDE=. ./mk_cmds
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 	$(Q) $(CPPCHECK_CMD) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
-@CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -DSHARED_ELF_LIB -fPIC -o elfshared/$*.o -c $<
 @BSDLIB_CMT@	$(Q) $(CC) $(ALL_CFLAGS) $(BSDLIB_PIC_FLAG) -o pic/$*.o -c $<
 
diff --git a/lib/uuid/Makefile.in b/lib/uuid/Makefile.in
index f5b767e..5b47318 100644
--- a/lib/uuid/Makefile.in
+++ b/lib/uuid/Makefile.in
@@ -65,7 +65,6 @@ BSDLIB_INSTALL_DIR = $(root_libdir)
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
 	$(Q) $(CPPCHECK_CMD) $<
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
-@CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
 @ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
 @BSDLIB_CMT@	$(Q) $(CC) $(ALL_CFLAGS) $(BSDLIB_PIC_FLAG) -o pic/$*.o -c $<
 

