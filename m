From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [PATCH e2fsprogs] fuse2fs: might need librt
Date: Thu,  9 Jun 2016 07:57:31 -0300
Message-ID: <1465469851-2074-1-git-send-email-gustavo@zacarias.com.ar>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.zacarias.com.ar ([176.9.42.171]:38044 "EHLO
	www.zacarias.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbcFILDo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Jun 2016 07:03:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It uses clock_gettime() which in older glibc versions is in librt.

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 configure.ac     | 5 +++++
 misc/Makefile.in | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 67d7231..a387dfd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1162,6 +1162,11 @@ if test "$ac_cv_func_dlopen" = yes ; then
 fi
 AC_SUBST(MAGIC_LIB)
 dnl
+dnl Check to see if librt is required for clock_gettime() (glibc < 2.17)
+dnl
+AC_CHECK_LIB(rt, clock_gettime, [CLOCK_GETTIME_LIB=-lrt])
+AC_SUBST(CLOCK_GETTIME_LIB)
+dnl
 dnl Check to see if the FUSE library is -lfuse or -losxfuse
 dnl
 FUSE_CMT=
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 43e3c7e..070a6e3 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -387,7 +387,8 @@ fuse2fs: $(FUSE2FS_OBJS) $(DEPLIBS) $(DEPLIBBLKID) $(DEPLIBUUID) \
 		$(LIBEXT2FS)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o fuse2fs $(FUSE2FS_OBJS) $(LIBS) \
-		$(LIBFUSE) $(LIBBLKID) $(LIBUUID) $(LIBEXT2FS) $(LIBINTL)
+		$(LIBFUSE) $(LIBBLKID) $(LIBUUID) $(LIBEXT2FS) $(LIBINTL) \
+		$(CLOCK_GETTIME_LIB)
 
 journal.o: $(srcdir)/../debugfs/journal.c
 	$(E) "	CC $@"
-- 
2.7.3

