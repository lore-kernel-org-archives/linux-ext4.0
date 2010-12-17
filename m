From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: [PATCH] disabling e4defrag build with --disable-defrag
Date: Fri, 17 Dec 2010 12:50:08 -0700
Message-ID: <1292615409-26697-1-git-send-email-adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:6319 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab0LQTuL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Dec 2010 14:50:11 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is useful for systems that are known not have the necessary support
for e4defrag to run (fallocate() and EXT4_IOC_MOVE_EXT support).  It cannot
be determined at compile time whether the target kernel will have them.
---
 configure        |   24 ++++++++++++++++++++++++
 configure.in     |   18 ++++++++++++++++++
 misc/Makefile.in |    4 ++--
 3 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/configure b/configure
index 14d9652..9e6d39e 100755
--- a/configure
+++ b/configure
@@ -675,6 +675,7 @@ FSCK_MAN
 FSCK_PROG
 RESIZER_CMT
 IMAGER_CMT
+DEFRAG_CMT
 DEBUGFS_CMT
 BLKID_CMT
 DEPPROFILED_LIBBLKID
@@ -803,6 +804,7 @@ enable_libblkid
 enable_debugfs
 enable_imager
 enable_resizer
+enable_defrag
 enable_fsck
 enable_e2initrd_helper
 enable_tls
@@ -1454,6 +1456,7 @@ Optional Features:
   --disable-debugfs   	  disable support of debugfs program
   --disable-imager   	  disable support of e2image program
   --disable-resizer   	  disable support of e2resize program
+  --disable-defrag   	  disable support of e4defrag program
   --enable-fsck           build fsck wrapper program
   --enable-e2initrd-helper build e2initrd-helper program
   --disable-tls           disable use of thread local support
@@ -5396,6 +5399,27 @@ RESIZER_CMT=
 fi
 
 
+# Check whether --enable-defrag was given.
+if test "${enable_defrag+set}" = set; then :
+  enableval=$enable_defrag; if test "$enableval" = "no"
+then
+	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Disabling e4defrag support" >&5
+$as_echo "Disabling e4defrag support" >&6; }
+	DEFRAG_CMT="#"
+else
+	DEFRAG_CMT=
+	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Enabling e4defrag support" >&5
+$as_echo "Enabling e4defrag support" >&6; }
+fi
+
+else
+  { $as_echo "$as_me:${as_lineno-$LINENO}: result: Enabling e4defrag support by default" >&5
+$as_echo "Enabling e4defrag support by default" >&6; }
+DEFRAG_CMT=
+
+fi
+
+
 # Check whether --enable-fsck was given.
 if test "${enable_fsck+set}" = set; then :
   enableval=$enable_fsck; if test "$enableval" = "no"
diff --git a/configure.in b/configure.in
index 5e67688..13ea07a 100644
--- a/configure.in
+++ b/configure.in
@@ -577,6 +577,24 @@ RESIZER_CMT=
 )
 AC_SUBST(RESIZER_CMT)
 dnl
+dnl handle --enable-defrag
+dnl
+AC_ARG_ENABLE([defrag],
+[  --disable-defrag   	  disable support of e4defrag program],
+if test "$enableval" = "no"
+then
+	AC_MSG_RESULT([Disabling e4defrag support])
+	DEFRAG_CMT="#"
+else
+	DEFRAG_CMT=
+	AC_MSG_RESULT([Enabling e4defrag support])
+fi
+,
+AC_MSG_RESULT([Enabling e4defrag support by default])
+DEFRAG_CMT=
+)
+AC_SUBST(DEFRAG_CMT)
+dnl
 dnl See whether to install the `fsck' wrapper program (that calls e2fsck)
 dnl
 AC_ARG_ENABLE([fsck],
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 8fd7704..d905e14 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -11,8 +11,8 @@ INSTALL = @INSTALL@
 
 @MCONFIG@
 
-@LINUX_CMT@E4DEFRAG_PROG= e4defrag
-@LINUX_CMT@E4DEFRAG_MAN= e4defrag.8
+@DEFRAG_CMT@@LINUX_CMT@E4DEFRAG_PROG= e4defrag
+@DEFRAG_CMT@@LINUX_CMT@E4DEFRAG_MAN= e4defrag.8
 
 @IMAGER_CMT@E2IMAGE_PROG= e2image
 @IMAGER_CMT@E2IMAGE_MAN= e2image.8
-- 
1.4.4.2

