From: Aditya Kali <adityakali@google.com>
Subject: [PATCH 1/5] e2fsprogs: add quota library to e2fsprogs
Date: Wed, 20 Jul 2011 11:40:02 -0700
Message-ID: <1311187206-30553-2-git-send-email-adityakali@google.com>
References: <1311187206-30553-1-git-send-email-adityakali@google.com>
Cc: Aditya Kali <adityakali@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:10110 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1GTSlD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jul 2011 14:41:03 -0400
Received: from wpaz13.hot.corp.google.com (wpaz13.hot.corp.google.com [172.24.198.77])
	by smtp-out.google.com with ESMTP id p6KIf2RD027081
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jul 2011 11:41:02 -0700
In-Reply-To: <1311187206-30553-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds the quota library (ported form Jan Kara's quota-tools) in
e2fsprogs in order to make quotas as a first class supported feature in Ext4.
This patch also provides interface in lib/quota/mkquota.h that will be used by
mke2fs, tune2fs, e2fsck, etc. to initialize and update quota files.
This first version of the quota library does not support reading existing quota
files. This support will be added in the near future.
Thanks to Jan Kara for his work on quota-tools. Most of the files in this patch
are taken as-is from quota tools and were simply modified to work with
libext2fs in e2fsprogs.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 MCONFIG.in               |    6 +
 Makefile.in              |    3 +-
 configure                |   32 +++
 configure.in             |   51 ++++
 lib/quota/Makefile.in    |  127 ++++++++++
 lib/quota/common.c       |   63 +++++
 lib/quota/common.h       |   78 +++++++
 lib/quota/dqblk_v2.h     |   43 ++++
 lib/quota/mkquota.c      |  400 ++++++++++++++++++++++++++++++++
 lib/quota/mkquota.h      |   66 ++++++
 lib/quota/quota.h        |  190 +++++++++++++++
 lib/quota/quota.pc.in    |   11 +
 lib/quota/quotaio.c      |  359 +++++++++++++++++++++++++++++
 lib/quota/quotaio.h      |  163 +++++++++++++
 lib/quota/quotaio_tree.c |  574 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/quota/quotaio_tree.h |   63 +++++
 lib/quota/quotaio_v2.c   |  314 +++++++++++++++++++++++++
 lib/quota/quotaio_v2.h   |  103 +++++++++
 18 files changed, 2645 insertions(+), 1 deletions(-)
 create mode 100644 lib/quota/Makefile.in
 create mode 100644 lib/quota/common.c
 create mode 100644 lib/quota/common.h
 create mode 100644 lib/quota/dqblk_v2.h
 create mode 100644 lib/quota/mkquota.c
 create mode 100644 lib/quota/mkquota.h
 create mode 100644 lib/quota/quota.h
 create mode 100644 lib/quota/quota.pc.in
 create mode 100644 lib/quota/quotaio.c
 create mode 100644 lib/quota/quotaio.h
 create mode 100644 lib/quota/quotaio_tree.c
 create mode 100644 lib/quota/quotaio_tree.h
 create mode 100644 lib/quota/quotaio_v2.c
 create mode 100644 lib/quota/quotaio_v2.h

diff --git a/MCONFIG.in b/MCONFIG.in
index 75cf3de..d0730ab 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -91,11 +91,13 @@ LIBCOM_ERR = $(LIB)/libcom_err@LIB_EXT@ @PRIVATE_LIBS_CMT@ @SEM_INIT_LIB@
 LIBE2P = $(LIB)/libe2p@LIB_EXT@
 LIBEXT2FS = $(LIB)/libext2fs@LIB_EXT@
 LIBUUID = @LIBUUID@ @SOCKET_LIB@
+LIBQUOTA = @LIBQUOTA@
 LIBBLKID = @LIBBLKID@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
 LIBINTL = @LIBINTL@
 DEPLIBSS = $(LIB)/libss@LIB_EXT@
 DEPLIBCOM_ERR = $(LIB)/libcom_err@LIB_EXT@
 DEPLIBUUID = @DEPLIBUUID@
+DEPLIBQUOTA = @DEPLIBQUOTA@
 DEPLIBBLKID = @DEPLIBBLKID@ @PRIVATE_LIBS_CMT@ $(DEPLIBUUID)
 
 STATIC_LIBSS = $(LIB)/libss@STATIC_LIB_EXT@ @DLOPEN_LIB@
@@ -103,10 +105,12 @@ STATIC_LIBCOM_ERR = $(LIB)/libcom_err@STATIC_LIB_EXT@ @SEM_INIT_LIB@
 STATIC_LIBE2P = $(LIB)/libe2p@STATIC_LIB_EXT@
 STATIC_LIBEXT2FS = $(LIB)/libext2fs@STATIC_LIB_EXT@
 STATIC_LIBUUID = @STATIC_LIBUUID@ @SOCKET_LIB@
+STATIC_LIBQUOTA = @STATIC_LIBQUOTA@
 STATIC_LIBBLKID = @STATIC_LIBBLKID@ $(STATIC_LIBUUID)
 DEPSTATIC_LIBSS = $(LIB)/libss@STATIC_LIB_EXT@
 DEPSTATIC_LIBCOM_ERR = $(LIB)/libcom_err@STATIC_LIB_EXT@
 DEPSTATIC_LIBUUID = @DEPSTATIC_LIBUUID@
+DEPSTATIC_LIBQUOTA = @DEPSTATIC_LIBQUOTA@
 DEPSTATIC_LIBBLKID = @DEPSTATIC_LIBBLKID@ $(DEPSTATIC_LIBUUID)
 
 PROFILED_LIBSS = $(LIB)/libss@PROFILED_LIB_EXT@ @DLOPEN_LIB@
@@ -114,10 +118,12 @@ PROFILED_LIBCOM_ERR = $(LIB)/libcom_err@PROFILED_LIB_EXT@ @SEM_INIT_LIB@
 PROFILED_LIBE2P = $(LIB)/libe2p@PROFILED_LIB_EXT@
 PROFILED_LIBEXT2FS = $(LIB)/libext2fs@PROFILED_LIB_EXT@
 PROFILED_LIBUUID = @PROFILED_LIBUUID@ @SOCKET_LIB@
+PROFILED_LIBQUOTA = @PROFILED_LIBQUOTA@
 PROFILED_LIBBLKID = @PROFILED_LIBBLKID@ $(PROFILED_LIBUUID)
 DEPPROFILED_LIBSS = $(LIB)/libss@PROFILED_LIB_EXT@
 DEPPROFILED_LIBCOM_ERR = $(LIB)/libcom_err@PROFILED_LIB_EXT@
 DEPPROFILED_LIBUUID = @PROFILED_LIBUUID@
+DEPPROFILED_LIBQUOTA = @PROFILED_LIBQUOTA@
 DEPPROFILED_LIBBLKID = @PROFILED_LIBBLKID@ $(DEPPROFILED_LIBUUID)
 
 # An include directive pointing to a directory holding enough linux-like
diff --git a/Makefile.in b/Makefile.in
index d336c57..a61c5c2 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -13,8 +13,9 @@ INSTALL = @INSTALL@
 @DEBUGFS_CMT@DEBUGFS_DIR= debugfs
 @UUID_CMT@UUID_LIB_SUBDIR= lib/uuid
 @BLKID_CMT@BLKID_LIB_SUBDIR= lib/blkid
+@QUOTA_CMT@QUOTA_LIB_SUBDIR= lib/quota
 
-LIB_SUBDIRS=lib/et lib/ss lib/e2p $(UUID_LIB_SUBDIR) lib/ext2fs $(BLKID_LIB_SUBDIR) intl
+LIB_SUBDIRS=lib/et lib/ss lib/e2p $(UUID_LIB_SUBDIR) lib/ext2fs $(BLKID_LIB_SUBDIR) $(QUOTA_LIB_SUBDIR) intl
 PROG_SUBDIRS=e2fsck $(DEBUGFS_DIR) misc $(RESIZE_DIR) tests/progs po
 SUBDIRS=util $(LIB_SUBDIRS) $(PROG_SUBDIRS) tests
 
diff --git a/configure b/configure
index 6dccb3c..bd35b93 100755
--- a/configure
+++ b/configure
@@ -677,6 +677,14 @@ DEFRAG_CMT
 RESIZER_CMT
 IMAGER_CMT
 DEBUGFS_CMT
+QUOTA_CMT
+DEPPROFILED_LIBQUOTA
+PROFILED_LIBQUOTA
+DEPSTATIC_LIBQUOTA
+STATIC_LIBQUOTA
+DEPLIBQUOTA
+LIBQUOTA
+UUID_CMT
 BLKID_CMT
 DEPPROFILED_LIBBLKID
 PROFILED_LIBBLKID
@@ -5336,6 +5344,29 @@ fi
 
 
 
+
+# Enable libquota
+LIBQUOTA='$(LIB)/libquota'$LIB_EXT
+DEPLIBQUOTA=$LIBQUOTA
+STATIC_LIBQUOTA='$(LIB)/libquota'$STATIC_LIB_EXT
+DEPSTATIC_LIBQUOTA=$STATIC_LIBQUOTA
+PROFILED_LIBQUOTA='$(LIB)/libquota'$PROFILED_LIB_EXT
+DEPPROFILED_LIBQUOTA=$PROFILED_LIBQUOTA
+$as_echo "#define CONFIG_BUILD_FINDFS 1" >>confdefs.h
+
+{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Enabling private quota library by default" >&5
+$as_echo "Enabling private quota library by default" >&6; }
+
+
+
+
+
+
+
+
+
+
+
 # Check whether --enable-debugfs was given.
 if test "${enable_debugfs+set}" = set; then :
   enableval=$enable_debugfs; if test "$enableval" = "no"
@@ -11112,6 +11143,7 @@ for i in MCONFIG Makefile e2fsprogs.spec \
 	util/Makefile util/subst.conf util/gen-tarball \
 	lib/et/Makefile lib/ss/Makefile lib/e2p/Makefile \
 	lib/ext2fs/Makefile lib/ext2fs/ext2_types.h \
+	lib/quota/Makefile lib/quota/quota.pc \
 	lib/uuid/Makefile lib/uuid/uuid_types.h \
 	lib/blkid/Makefile lib/blkid/blkid_types.h \
 	lib/ss/ss.pc lib/uuid/uuid.pc lib/et/com_err.pc \
diff --git a/configure.in b/configure.in
index af639c3..eca4206 100644
--- a/configure.in
+++ b/configure.in
@@ -523,6 +523,57 @@ AC_SUBST(PROFILED_LIBBLKID)
 AC_SUBST(DEPPROFILED_LIBBLKID)
 AC_SUBST(BLKID_CMT)
 dnl
+dnl handle --disable-libquota
+dnl
+PKG_PROG_PKG_CONFIG
+LIBQUOTA=
+DEPLIBQUOTA=
+STATIC_LIBQUOTA=
+DEPSTATIC_LIBQUOTA=
+PROFILED_LIBQUOTA=
+DEPPROFILED_LIBQUOTA=
+QUOTA_CMT=
+AC_ARG_ENABLE([libquota],
+[  --disable-libquota	  do not build private quota library],
+if test "$enableval" = "no"
+then
+	if test -z "$PKG_CONFIG"; then
+		AC_MSG_ERROR([pkg-config not installed; please install it.])
+	fi
+
+	AC_CHECK_LIB(quota,
+		[LIBQUOTA=`$PKG_CONFIG --libs quota`;
+		 STATIC_LIBQUOTA=`$PKG_CONFIG --static --libs quota`],
+		[AC_MSG_ERROR([external quota library not found])],
+		[$LIBQUOTA])
+	QUOTA_CMT=#
+	AC_MSG_RESULT([Disabling private quota library])
+else
+	LIBQUOTA='$(LIB)/libquota'$LIB_EXT
+	DEPLIBQUOTA=$LIBQUOTA
+	STATIC_LIBQUOTA='$(LIB)/libquota'$STATIC_LIB_EXT
+	DEPSTATIC_LIBQUOTA=$STATIC_LIBQUOTA
+	PROFILED_LIBQUOTA='$(LIB)/libquota'$PROFILED_LIB_EXT
+	DEPPROFILED_LIBQUOTA=$PROFILED_LIBQUOTA
+	AC_MSG_RESULT([Enabling private quota library])
+fi
+,
+LIBQUOTA='$(LIB)/libquota'$LIB_EXT
+DEPLIBQUOTA=$LIBQUOTA
+STATIC_LIBQUOTA='$(LIB)/libquota'$STATIC_LIB_EXT
+DEPSTATIC_LIBQUOTA=$STATIC_LIBQUOTA
+PROFILED_LIBQUOTA='$(LIB)/libquota'$PROFILED_LIB_EXT
+DEPPROFILED_LIBQUOTA=$PROFILED_LIBQUOTA
+AC_MSG_RESULT([Enabling private quota library by default])
+)
+AC_SUBST(LIBQUOTA)
+AC_SUBST(DEPLIBQUOTA)
+AC_SUBST(STATIC_LIBQUOTA)
+AC_SUBST(DEPSTATIC_LIBQUOTA)
+AC_SUBST(PROFILED_LIBQUOTA)
+AC_SUBST(DEPPROFILED_LIBQUOTA)
+AC_SUBST(QUOTA_CMT)
+dnl
 dnl handle --enable-debugfs
 dnl
 AC_ARG_ENABLE([debugfs],
diff --git a/lib/quota/Makefile.in b/lib/quota/Makefile.in
new file mode 100644
index 0000000..8f8b918
--- /dev/null
+++ b/lib/quota/Makefile.in
@@ -0,0 +1,127 @@
+# Makefile for the QUOTA library
+#
+
+srcdir = @srcdir@
+top_srcdir = @top_srcdir@
+VPATH = @srcdir@
+top_builddir = ../..
+my_dir = lib/quota
+INSTALL = @INSTALL@
+
+@MCONFIG@
+
+all::
+
+SMANPAGES=
+
+
+OBJS=		mkquota.o dict.o common.o quotaio.o quotaio_v2.o quotaio_tree.o
+
+SRCS=		$(srcdir)/common.c \
+		$(srcdir)/mkquota.c \
+		$(srcdir)/quotaio.c \
+		$(srcdir)/quotaio_tree.c \
+		$(srcdir)/quotaio_v2.c \
+		$(srcdir)/../../e2fsck/dict.c
+
+LIBRARY= libquota
+LIBDIR= quota
+
+ELF_VERSION = 1.0
+ELF_SO_VERSION = 1
+ELF_IMAGE = libquota
+ELF_MYDIR = quota
+ELF_INSTALL_DIR = $(root_libdir)
+ELF_OTHER_LIBS =
+
+BSDLIB_VERSION = 1.0
+BSDLIB_IMAGE = libquota
+BSDLIB_MYDIR = quota
+BSDLIB_INSTALL_DIR = $(root_libdir)
+
+@MAKEFILE_LIBRARY@
+@MAKEFILE_ELF@
+@MAKEFILE_BSDLIB@
+@MAKEFILE_PROFILE@
+@MAKEFILE_CHECKER@
+
+.c.o:
+	$(E) "	CC $<"
+	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+@PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
+@CHECKER_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -checker -g -o checker/$*.o -c $<
+@ELF_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -fPIC -o elfshared/$*.o -c $<
+@BSDLIB_CMT@	$(Q) $(CC) $(ALL_CFLAGS) $(BSDLIB_PIC_FLAG) -o pic/$*.o -c $<
+
+all:: $(SMANPAGES) quota.pc
+
+
+
+quota.pc: $(srcdir)/quota.pc.in $(top_builddir)/config.status
+	$(E) "	CONFIG.STATUS $@"
+	$(Q) cd $(top_builddir); CONFIG_FILES=lib/quota/quota.pc ./config.status
+
+dict.o:
+	$(E) "	CC $<"
+	$(Q) $(CC) -c $(ALL_CFLAGS) $(srcdir)/../../e2fsck/dict.c -o $@
+
+installdirs::
+	$(E) "	MKINSTALLDIRS $(libdir) $(includedir)/quota $(man3dir)"
+	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(libdir)  \
+		$(DESTDIR)$(includedir)/quota $(DESTDIR)$(man3dir) \
+		$(DESTDIR)$(libdir)/pkgconfig
+
+install:: all installdirs
+	$(E) "	INSTALL_DATA $(libdir)/libquota.a"
+	$(Q) $(INSTALL_DATA) libquota.a $(DESTDIR)$(libdir)/libquota.a
+	-$(Q) $(RANLIB) $(DESTDIR)$(libdir)/libquota.a
+	$(Q) $(CHMOD) $(LIBMODE) $(DESTDIR)$(libdir)/libquota.a
+	$(E) "	INSTALL_DATA $(includedir)/quota/quota.h"
+	$(Q) $(INSTALL_DATA) mkquota.h $(DESTDIR)$(includedir)/quota/mkquota.h
+	$(Q) for i in $(SMANPAGES); do \
+		$(RM) -f $(DESTDIR)$(man3dir)/$$i.gz; \
+		echo "	INSTALL_DATA $(man3dir)/$$i"; \
+		$(INSTALL_DATA) $$i $(DESTDIR)$(man3dir)/$$i; \
+	done
+	$(E) "	INSTALL_DATA $(libdir)/pkgconfig/quota.pc"
+	$(Q) $(INSTALL_DATA) quota.pc $(DESTDIR)$(libdir)/pkgconfig/quota.pc
+
+uninstall::
+	$(RM) -f $(DESTDIR)$(libdir)/libquota.a \
+		$(DESTDIR)$(libdir)/pkgconfig/quota.pc
+	for i in $(SMANPAGES); do \
+		$(RM) -f $(DESTDIR)$(man3dir)/$$i; \
+	done
+
+clean::
+	$(RM) -f \#* *.s *.o *.a *~ *.bak core profiled/* checker/*
+	$(RM) -f ../libquota.a ../libquota_p.a $(SMANPAGES)
+
+#check:: tst_uuid
+#	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_uuid
+
+mostlyclean:: clean
+distclean:: clean
+	$(RM) -f .depend Makefile quota.pc \
+		$(srcdir)/TAGS $(srcdir)/Makefile.in.old
+
+#
+# Hack to parallel makes recognize dependencies correctly.
+#
+../../lib/libquota.a: libquota.a
+../../lib/libquota.so: image
+../../lib/libquota.dylib: image
+
+$(OBJS): 
+
+# +++ Dependency line eater +++
+#
+# Makefile dependencies follow.  This must be the last section in
+# the Makefile.in file
+#
+dict.o: $(srcdir)/../../e2fsck/dict.c $(srcdir)/../../e2fsck/dict.h
+common.o: $(srcdir)/common.c $(srcdir)/common.h
+quotaio.o: $(srcdir)/quotaio.c $(srcdir)/quotaio.h $(srcdir)/quota.h $(srcdir)/dqblk_v2.h common.o
+quotaio_v2.o: $(srcdir)/quotaio_v2.c $(srcdir)/quota.h $(srcdir)/quotaio.h $(srcdir)/common.h $(srcdir)/quotaio_v2.h common.o
+quotaio_tree.o: $(srcdir)/quotaio_tree.c  $(srcdir)/quota.h $(srcdir)/quotaio.h $(srcdir)/quotaio_tree.h common.o
+mkquota.o: $(srcdir)/mkquota.c $(srcdir)/mkquota.h $(srcdir)/quota.h $(srcdir)/dict.o common.o quotaio.o quotaio_v2.o quotaio_tree.o
diff --git a/lib/quota/common.c b/lib/quota/common.c
new file mode 100644
index 0000000..70221cf
--- /dev/null
+++ b/lib/quota/common.c
@@ -0,0 +1,63 @@
+/*
+ * Common things for all utilities
+ *
+ * Jan Kara <jack@suse.cz> - sponsored by SuSE CR
+ *
+ * Jani Jaakkola <jjaakkol@cs.helsinki.fi> - syslog support
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdarg.h>
+#include <string.h>
+#include <syslog.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include "common.h"
+
+void *smalloc(size_t size)
+{
+	void *ret = malloc(size);
+
+	if (!ret) {
+		fputs("Not enough memory.\n", stderr);
+		exit(3);
+	}
+	return ret;
+}
+
+void *srealloc(void *ptr, size_t size)
+{
+	void *ret = realloc(ptr, size);
+
+	if (!ret) {
+		fputs("Not enough memory.\n", stderr);
+		exit(3);
+	}
+	return ret;
+}
+
+void sstrncpy(char *d, const char *s, size_t len)
+{
+	strncpy(d, s, len);
+	d[len - 1] = 0;
+}
+
+void sstrncat(char *d, const char *s, size_t len)
+{
+	strncat(d, s, len);
+	d[len - 1] = 0;
+}
+
+char *sstrdup(const char *s)
+{
+	char *r = strdup(s);
+
+	if (!r) {
+		puts("Not enough memory.");
+		exit(3);
+	}
+	return r;
+}
+
diff --git a/lib/quota/common.h b/lib/quota/common.h
new file mode 100644
index 0000000..48f191f
--- /dev/null
+++ b/lib/quota/common.h
@@ -0,0 +1,78 @@
+/*
+ *
+ *	Various things common for all utilities
+ *
+ */
+
+#ifndef __QUOTA_COMMON_H__
+#define __QUOTA_COMMON_H__
+
+#ifndef __attribute__
+# if !defined __GNUC__ || __GNUC__ < 2 || (__GNUC__ == 2 && __GNUC_MINOR__ < 8) || __STRICT_ANSI__
+#  define __attribute__(x)
+# endif
+#endif
+
+#ifdef ENABLE_NLS
+#include <libintl.h>
+#include <locale.h>
+#define _(a) (gettext (a))
+#ifdef gettext_noop
+#define N_(a) gettext_noop (a)
+#else
+#define N_(a) (a)
+#endif
+#define P_(singular, plural, n) (ngettext (singular, plural, n))
+#ifndef NLS_CAT_NAME
+#define NLS_CAT_NAME "e2fsprogs"
+#endif
+#ifndef LOCALEDIR
+#define LOCALEDIR "/usr/share/locale"
+#endif
+#else
+#define _(a) (a)
+#define N_(a) a
+#define P_(singular, plural, n) ((n) == 1 ? (singular) : (plural))
+#endif
+
+#define log_fatal(exit_code, format, ...)	do { \
+		fprintf(stderr, _("[FATAL] %s:%d:%s:: " format "\n"), \
+			__FILE__, __LINE__, __func__, __VA_ARGS__); \
+		exit(exit_code); \
+	} while (0)
+
+#define log_err(format, ...)	fprintf(stderr, \
+				_("[ERROR] %s:%d:%s:: " format "\n"), \
+				__FILE__, __LINE__, __func__, __VA_ARGS__)
+
+#ifdef DEBUG_QUOTA
+# define log_debug(format, ...)	fprintf(stderr, \
+				_("[DEBUG] %s:%d:%s:: " format "\n"), \
+				__FILE__, __LINE__, __func__, __VA_ARGS__)
+#else
+# define log_debug(format, ...)
+#endif
+
+#define BUG_ON(x)		do { if ((x)) { \
+					fprintf(stderr, \
+						_("BUG_ON: %s:%d:: ##x"), \
+						__FILE__, __LINE__); \
+					exit(2); \
+				} } while (0)
+
+/* malloc() with error check */
+void *smalloc(size_t);
+
+/* realloc() with error check */
+void *srealloc(void *, size_t);
+
+/* Safe strncpy - always finishes string */
+void sstrncpy(char *, const char *, size_t);
+
+/* Safe strncat - always finishes string */
+void sstrncat(char *, const char *, size_t);
+
+/* Safe version of strdup() */
+char *sstrdup(const char *s);
+
+#endif /* __QUOTA_COMMON_H__ */
diff --git a/lib/quota/dqblk_v2.h b/lib/quota/dqblk_v2.h
new file mode 100644
index 0000000..ca07902
--- /dev/null
+++ b/lib/quota/dqblk_v2.h
@@ -0,0 +1,43 @@
+/*
+ * Header file for disk format of new quotafile format
+ *
+ * Jan Kara <jack@suse.cz> - sponsored by SuSE CR
+ */
+
+#ifndef __QUOTA_DQBLK_V2_H__
+#define __QUOTA_DQBLK_V2_H__
+
+#include <sys/types.h>
+#include "quotaio_tree.h"
+
+#define Q_V2_GETQUOTA	0x0D00	/* Get limits and usage */
+#define Q_V2_SETQUOTA	0x0E00	/* Set limits and usage */
+#define Q_V2_SETUSE	0x0F00	/* Set only usage */
+#define Q_V2_SETQLIM	0x0700	/* Set only limits */
+#define Q_V2_GETINFO	0x0900	/* Get information about quota */
+#define Q_V2_SETINFO	0x0A00	/* Set information about quota */
+#define Q_V2_SETGRACE	0x0B00	/* Set just grace times in quotafile
+				 * information */
+#define Q_V2_SETFLAGS	0x0C00	/* Set just flags in quotafile information */
+#define Q_V2_GETSTATS	0x1100	/* get collected stats (before proc was used) */
+
+/* Structure for format specific information */
+struct v2_mem_dqinfo {
+	struct qtree_mem_dqinfo dqi_qtree;
+	uint dqi_flags;		/* Flags set in quotafile */
+	uint dqi_used_entries;	/* Number of entries in file -
+				   updated by scan_dquots */
+	uint dqi_data_blocks;	/* Number of data blocks in file -
+				   updated by scan_dquots */
+};
+
+struct v2_mem_dqblk {
+	loff_t dqb_off;		/* Offset of dquot in file */
+};
+
+struct quotafile_ops;		/* Will be defined later in quotaio.h */
+
+/* Operations above this format */
+extern struct quotafile_ops quotafile_ops_2;
+
+#endif  /* __QUOTA_DQBLK_V2_H__ */
diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
new file mode 100644
index 0000000..cbc76f7
--- /dev/null
+++ b/lib/quota/mkquota.c
@@ -0,0 +1,400 @@
+/*
+ * mkquota.c --- create quota files for a filesystem
+ *
+ * Aditya Kali <adityakali@google.com>
+ */
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <errno.h>
+#include <string.h>
+#include <fcntl.h>
+
+#include "ext2fs/ext2_fs.h"
+#include "ext2fs/ext2fs.h"
+#include "e2p/e2p.h"
+
+#include "quota.h"
+#include "quotaio.h"
+#include "quotaio_v2.h"
+#include "quotaio_tree.h"
+#include "mkquota.h"
+#include "common.h"
+
+/* Needed for architectures where sizeof(int) != sizeof(void *) */
+#define UINT_TO_VOIDPTR(val)  ((void *)(intptr_t)(val))
+#define VOIDPTR_TO_UINT(ptr)  ((unsigned int)(intptr_t)(ptr))
+
+static void print_inode(struct ext2_inode *inode)
+{
+	if (!inode)
+		return;
+
+	fprintf(stderr, "  i_mode = %d\n", inode->i_mode);
+	fprintf(stderr, "  i_uid = %d\n", inode->i_uid);
+	fprintf(stderr, "  i_size = %d\n", inode->i_size);
+	fprintf(stderr, "  i_atime = %d\n", inode->i_atime);
+	fprintf(stderr, "  i_ctime = %d\n", inode->i_ctime);
+	fprintf(stderr, "  i_mtime = %d\n", inode->i_mtime);
+	fprintf(stderr, "  i_dtime = %d\n", inode->i_dtime);
+	fprintf(stderr, "  i_gid = %d\n", inode->i_gid);
+	fprintf(stderr, "  i_links_count = %d\n", inode->i_links_count);
+	fprintf(stderr, "  i_blocks = %d\n", inode->i_blocks);
+	fprintf(stderr, "  i_flags = %d\n", inode->i_flags);
+
+	return;
+}
+
+int is_quota_on(ext2_filsys fs, int type)
+{
+	char tmp[1024];
+	qid_t id = (type == USRQUOTA) ? getuid() : getgid();
+
+	if (!quotactl(QCMD(Q_V2_GETQUOTA, type), fs->device_name, id, tmp))
+		return 1;
+	return 0;
+}
+
+/*
+ * Returns 0 if not able to find the quota file, otherwise returns its
+ * inode number.
+ */
+int quota_file_exists(ext2_filsys fs, int qtype, int fmt)
+{
+	char qf_name[256];
+	errcode_t ret;
+	ext2_ino_t ino;
+
+	if (qtype >= MAXQUOTAS || fmt > QFMT_VFS_V1)
+		return -EINVAL;
+
+	get_qf_name(qtype, fmt, qf_name);
+
+	ret = ext2fs_lookup(fs, EXT2_ROOT_INO, qf_name, strlen(qf_name), 0,
+			    &ino);
+	if (ret)
+		return 0;
+
+	return ino;
+}
+
+/*
+ * Set the value for reserved quota inode number field in superblock.
+ */
+void set_sb_quota_inum(ext2_filsys fs, ext2_ino_t ino, int qtype)
+{
+	ext2_ino_t *inump;
+
+	inump = (qtype == USRQUOTA) ? &fs->super->s_usr_quota_inum :
+		&fs->super->s_grp_quota_inum;
+
+	log_debug("setting quota ino in superblock: ino=%u, type=%d", ino,
+		 qtype);
+	*inump = ino;
+	ext2fs_mark_super_dirty(fs);
+}
+
+errcode_t remove_quota_inode(ext2_filsys fs, int qtype)
+{
+	ext2_ino_t qf_ino;
+
+	ext2fs_read_bitmaps(fs);
+	qf_ino = (qtype == USRQUOTA) ? fs->super->s_usr_quota_inum :
+		fs->super->s_grp_quota_inum;
+	set_sb_quota_inum(fs, 0, qtype);
+	/* Truncate the inode only if its a reserved one. */
+	if (qf_ino < EXT2_FIRST_INODE(fs->super))
+		truncate_quota_inode(fs, qf_ino);
+
+	ext2fs_mark_super_dirty(fs);
+	ext2fs_write_bitmaps(fs);
+	return 0;
+}
+
+static void write_dquots(dict_t *dict, struct quota_handle *qh)
+{
+	int		i = 0;
+	dnode_t		*n;
+	struct dquot	*dq;
+	__u32		key;
+
+	for (n = dict_first(dict); n; n = dict_next(dict, n)) {
+		dq = dnode_get(n);
+		if (dq) {
+			dq->dq_h = qh;
+			update_grace_times(dq);
+			qh->qh_ops->commit_dquot(dq, COMMIT_ALL);
+		}
+	}
+}
+
+errcode_t write_quota_inode(quota_ctx_t qctx, int qtype)
+{
+	int		retval, i;
+	unsigned long	qf_inums[MAXQUOTAS];
+	struct dquot	*dquot;
+	dict_t		*dict;
+	ext2_filsys	fs;
+	struct quota_handle *h;
+	int		fmt = QFMT_VFS_V1;
+
+	if (!qctx)
+		return;
+
+	fs = qctx->fs;
+	h = smalloc(sizeof(struct quota_handle));
+	ext2fs_read_bitmaps(fs);
+
+	for (i = 0; i < MAXQUOTAS; i++) {
+		if ((qtype != -1) && (i != qtype))
+			continue;
+
+		dict = qctx->quota_dict[i];
+		if (!dict)
+			continue;
+
+		retval = new_io(h, fs, i, fmt);
+		if (retval < 0) {
+			log_err("Cannot initialize io on quotafile", "");
+			continue;
+		}
+
+		write_dquots(dict, h);
+		retval = end_io(h);
+		if (retval < 0) {
+			log_err("Cannot finish IO on new quotafile: %s",
+				strerror(errno));
+			if (h->qh_qf.e2_file)
+				ext2fs_file_close(h->qh_qf.e2_file);
+			truncate_quota_inode(fs, h->qh_qf.ino);
+			continue;
+		}
+
+		/* Set quota inode numbers in superblock. */
+		set_sb_quota_inum(fs, h->qh_qf.ino, i);
+		ext2fs_mark_super_dirty(fs);
+		ext2fs_mark_bb_dirty(fs);
+		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+	}
+
+	ext2fs_write_bitmaps(fs);
+out:
+	free(h);
+	return retval;
+}
+
+/******************************************************************/
+/* Helper functions for computing quota in memory.                */
+/******************************************************************/
+
+static int dict_uint_cmp(const void *a, const void *b)
+{
+	unsigned int	c, d;
+
+	c = VOIDPTR_TO_UINT(a);
+	d = VOIDPTR_TO_UINT(b);
+
+	return c - d;
+}
+
+static qid_t get_qid(struct ext2_inode *inode, int qtype)
+{
+	switch (qtype) {
+	case USRQUOTA:
+		return inode_uid(*inode);
+	case GRPQUOTA:
+		return inode_gid(*inode);
+	default:
+		log_err("Invalid quota type: %d", qtype);
+		BUG_ON(1);
+	}
+}
+
+static void quota_dnode_free(dnode_t *node,
+			     void *context EXT2FS_ATTR((unused)))
+{
+	void *ptr = node ? dnode_get(node) : 0;
+
+	free(ptr);
+	free(node);
+}
+
+/*
+ * Called in Pass #1 to set up the quota tracking data structures.
+ */
+void init_quota_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
+{
+	int	i;
+	dict_t	*dict;
+	quota_ctx_t ctx;
+
+	ctx = (quota_ctx_t)smalloc(sizeof(struct quota_ctx));
+	memset(ctx, 0, sizeof(struct quota_ctx));
+	for (i = 0; i < MAXQUOTAS; i++) {
+		if ((qtype != -1) && (i != qtype))
+			continue;
+		dict = (dict_t *)smalloc(sizeof(dict_t));
+		ctx->quota_dict[i] = dict;
+		dict_init(dict, DICTCOUNT_T_MAX, dict_uint_cmp);
+		dict_set_allocator(dict, NULL, quota_dnode_free, NULL);
+	}
+
+	ctx->fs = fs;
+	*qctx = ctx;
+}
+
+void release_quota_context(quota_ctx_t *qctx)
+{
+	dict_t	*dict;
+	int	i;
+	quota_ctx_t ctx;
+
+	if (!qctx)
+		return;
+
+	ctx = *qctx;
+	for (i = 0; i < MAXQUOTAS; i++) {
+		dict = ctx->quota_dict[i];
+		ctx->quota_dict[i] = 0;
+		if (dict) {
+			dict_free_nodes(dict);
+			free(dict);
+		}
+	}
+	*qctx = NULL;
+	free(ctx);
+}
+
+static struct dquot *get_dq(dict_t *dict, __u32 key)
+{
+	struct dquot	*dq;
+	dnode_t		*n;
+
+	n = dict_lookup(dict, UINT_TO_VOIDPTR(key));
+	if (n)
+		dq = dnode_get(n);
+	else {
+		dq = smalloc(sizeof(struct dquot));
+		memset(dq, 0, sizeof(struct dquot));
+		dict_alloc_insert(dict, UINT_TO_VOIDPTR(key), dq);
+	}
+	return dq;
+}
+
+
+/*
+ * Called to update the blocks used by a particular inode
+ */
+void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
+		    qsize_t space)
+{
+	struct dquot	*dq;
+	dict_t		*dict;
+	int		i;
+
+	if (!qctx)
+		return;
+
+	log_debug("ADD_DATA: Inode: %u, UID/GID: %u/%u, space: %ld", ino,
+			inode_uid(*inode),
+			inode_gid(*inode), space);
+	for (i = 0; i < MAXQUOTAS; i++) {
+		dict = qctx->quota_dict[i];
+		if (dict) {
+			dq = get_dq(dict, get_qid(inode, i));
+			dq->dq_dqb.dqb_curspace += space;
+		}
+	}
+}
+
+/*
+ * Called to remove some blocks used by a particular inode
+ */
+void quota_data_sub(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
+		    qsize_t space)
+{
+	struct dquot	*dq;
+	dict_t		*dict;
+	int		i;
+
+	if (!qctx)
+		return;
+
+	log_debug("SUB_DATA: Inode: %u, UID/GID: %u/%u, space: %ld", ino,
+			inode_uid(*inode),
+			inode_gid(*inode), space);
+	for (i = 0; i < MAXQUOTAS; i++) {
+		dict = qctx->quota_dict[i];
+		if (dict) {
+			dq = get_dq(dict, get_qid(inode, i));
+			dq->dq_dqb.dqb_curspace -= space;
+		}
+	}
+}
+
+/*
+ * Called to count the files used by an inode's user/group
+ */
+void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode,
+		       ext2_ino_t ino, int adjust)
+{
+	struct dquot	*dq;
+	dict_t		*dict;
+	int		i;
+
+	if (!qctx)
+		return;
+
+	log_debug("ADJ_INODE: Inode: %u, UID/GID: %u/%u, adjust: %d", ino,
+			inode_uid(*inode),
+			inode_gid(*inode), adjust);
+	for (i = 0; i < MAXQUOTAS; i++) {
+		dict = qctx->quota_dict[i];
+		if (dict) {
+			dq = get_dq(dict, get_qid(inode, i));
+			dq->dq_dqb.dqb_curinodes += adjust;
+		}
+	}
+}
+
+errcode_t compute_quota(quota_ctx_t qctx, int qtype)
+{
+	ext2_filsys fs;
+	const char *name = "lost+found";
+	ext2_ino_t ino;
+	errcode_t ret;
+	struct ext2_inode inode;
+	qsize_t space;
+	ext2_inode_scan scan;
+
+	if (!qctx)
+		return;
+
+	fs = qctx->fs;
+	ret = ext2fs_open_inode_scan(fs, 0, &scan);
+	if (ret) {
+		log_err("while opening inode scan. ret=%ld", ret);
+		return ret;
+	}
+
+	while (1) {
+		ret = ext2fs_get_next_inode(scan, &ino, &inode);
+		if (ret) {
+			log_err("while getting next inode. ret=%ld", ret);
+			ext2fs_close_inode_scan(scan);
+			return ret;
+		}
+		if (ino == 0)
+			break;
+		if (inode.i_links_count) {
+			/* Convert i_blocks to # of 1k blocks */
+			space = (ext2fs_inode_i_blocks(fs, &inode) + 1) >> 1;
+			quota_data_add(qctx, &inode, ino, space);
+			quota_data_inodes(qctx, &inode, ino, +1);
+		}
+	}
+
+	ext2fs_close_inode_scan(scan);
+
+	return 0;
+}
diff --git a/lib/quota/mkquota.h b/lib/quota/mkquota.h
new file mode 100644
index 0000000..b4eba14
--- /dev/null
+++ b/lib/quota/mkquota.h
@@ -0,0 +1,66 @@
+/** mkquota.h
+ *
+ * Interface to the quota library.
+ *
+ * The quota library provides interface for creating and updating the quota
+ * files and the ext4 superblock fields. It supports the new VFS_V1 quota
+ * format. The quota library also provides support for keeping track of quotas
+ * in memory.
+ * The typical way to use the quota library is as follows:
+ * {
+ *	quota_ctx_t qctx;
+ *
+ *	init_quota_context(&qctx, fs, -1);
+ *	{
+ *		compute_quota(qctx, -1);
+ *		AND/OR
+ *		quota_data_add/quota_data_sub/quota_data_inodes();
+ *	}
+ *	write_quota_inode(qctx, USRQUOTA);
+ *	write_quota_inode(qctx, GRPQUOTA);
+ *	release_quota_context(&qctx);
+ * }
+ *
+ * This initial version does not support reading the quota files. This support
+ * will be added in near future.
+ *
+ * Aditya Kali <adityakali@google.com>
+ */
+
+#ifndef __QUOTA_QUOTAIO_H__
+#define __QUOTA_QUOTAIO_H__
+
+#include "ext2fs/ext2_fs.h"
+#include "ext2fs/ext2fs.h"
+#include "quota.h"
+#include "../e2fsck/dict.h"
+
+typedef struct quota_ctx *quota_ctx_t;
+
+struct quota_ctx {
+	ext2_filsys	fs;
+	dict_t		*quota_dict[MAXQUOTAS];
+};
+
+void init_quota_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype);
+void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
+		int adjust);
+void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
+		qsize_t space);
+void quota_data_sub(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
+		qsize_t space);
+errcode_t write_quota_inode(quota_ctx_t qctx, int qtype);
+errcode_t compute_quota(quota_ctx_t qctx, int qtype);
+void release_quota_context(quota_ctx_t *qctx);
+
+errcode_t remove_quota_inode(ext2_filsys fs, int qtype);
+int is_quota_on(ext2_filsys fs, int type);
+int quota_file_exists(ext2_filsys fs, int qtype, int fmt);
+void set_sb_quota_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
+
+/* in quotaio.c */
+const char *get_qf_name(int type, int fmt, char *buf);
+const char *get_qf_path(const char *mntpt, int qtype, int fmt,
+			char *path_buf, size_t path_buf_size);
+
+#endif  /* __QUOTA_QUOTAIO_H__ */
diff --git a/lib/quota/quota.h b/lib/quota/quota.h
new file mode 100644
index 0000000..aab66d9
--- /dev/null
+++ b/lib/quota/quota.h
@@ -0,0 +1,190 @@
+/*
+ * Copyright (c) 1982, 1986 Regents of the University of California.
+ * All rights reserved.
+ *
+ * This code is derived from software contributed to Berkeley by
+ * Robert Elz at The University of Melbourne.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of the University nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef _LINUX_QUOTA_
+#define _LINUX_QUOTA_
+
+#include <errno.h>
+#include <sys/types.h>
+
+#define __DQUOT_VERSION__	"dquot_6.5.2"
+
+typedef u_int32_t qid_t;	/* Type in which we store ids in memory */
+typedef int64_t qsize_t;	/* Type in which we store size limitations */
+
+#define MAXQUOTAS 2
+#define USRQUOTA  0		/* element used for user quotas */
+#define GRPQUOTA  1		/* element used for group quotas */
+
+/*
+ * Definitions for the default names of the quotas files.
+ */
+#define INITQFNAMES { \
+	"user",    /* USRQUOTA */ \
+	"group",   /* GRPQUOTA */ \
+	"undefined", \
+};
+
+/*
+ * Definitions of magics and versions of current quota files
+ */
+#define INITQMAGICS {\
+	0xd9c01f11,	/* USRQUOTA */\
+	0xd9c01927	/* GRPQUOTA */\
+}
+
+/* Size of blocks in which are counted size limits in generic utility parts */
+#define QUOTABLOCK_BITS 10
+#define QUOTABLOCK_SIZE (1 << QUOTABLOCK_BITS)
+
+/* Conversion routines from and to quota blocks */
+#define qb2kb(x) ((x) << (QUOTABLOCK_BITS-10))
+#define kb2qb(x) ((x) >> (QUOTABLOCK_BITS-10))
+#define toqb(x) (((x) + QUOTABLOCK_SIZE - 1) >> QUOTABLOCK_BITS)
+
+/*
+ * Command definitions for the 'quotactl' system call.
+ * The commands are broken into a main command defined below
+ * and a subcommand that is used to convey the type of
+ * quota that is being manipulated (see above).
+ */
+#define SUBCMDMASK  0x00ff
+#define SUBCMDSHIFT 8
+#define QCMD(cmd, type)  (((cmd) << SUBCMDSHIFT) | ((type) & SUBCMDMASK))
+
+#define Q_SYNC     0x800001	/* sync disk copy of a filesystems quotas */
+#define Q_QUOTAON  0x800002	/* turn quotas on */
+#define Q_QUOTAOFF 0x800003	/* turn quotas off */
+#define Q_GETFMT   0x800004	/* get quota format used on given filesystem */
+#define Q_GETINFO  0x800005	/* get information about quota files */
+#define Q_SETINFO  0x800006	/* set information about quota files */
+#define Q_GETQUOTA 0x800007	/* get user quota structure */
+#define Q_SETQUOTA 0x800008	/* set user quota structure */
+
+/* Quota format type IDs */
+#define	QFMT_VFS_OLD 1
+#define	QFMT_VFS_V0 2
+#define QFMT_OCFS2 3
+#define	QFMT_VFS_V1 4
+
+/* Size of block in which space limits are passed through the quota
+ * interface */
+#define QIF_DQBLKSIZE_BITS 10
+#define QIF_DQBLKSIZE (1 << QIF_DQBLKSIZE_BITS)
+
+/*
+ * Quota structure used for communication with userspace via quotactl
+ * Following flags are used to specify which fields are valid
+ */
+enum {
+	QIF_BLIMITS_B = 0,
+	QIF_SPACE_B,
+	QIF_ILIMITS_B,
+	QIF_INODES_B,
+	QIF_BTIME_B,
+	QIF_ITIME_B,
+};
+
+#define QIF_BLIMITS	(1 << QIF_BLIMITS_B)
+#define QIF_SPACE	(1 << QIF_SPACE_B)
+#define QIF_ILIMITS	(1 << QIF_ILIMITS_B)
+#define QIF_INODES	(1 << QIF_INODES_B)
+#define QIF_BTIME	(1 << QIF_BTIME_B)
+#define QIF_ITIME	(1 << QIF_ITIME_B)
+#define QIF_LIMITS	(QIF_BLIMITS | QIF_ILIMITS)
+#define QIF_USAGE	(QIF_SPACE | QIF_INODES)
+#define QIF_TIMES	(QIF_BTIME | QIF_ITIME)
+#define QIF_ALL		(QIF_LIMITS | QIF_USAGE | QIF_TIMES)
+
+struct if_dqblk {
+	__u64 dqb_bhardlimit;
+	__u64 dqb_bsoftlimit;
+	__u64 dqb_curspace;
+	__u64 dqb_ihardlimit;
+	__u64 dqb_isoftlimit;
+	__u64 dqb_curinodes;
+	__u64 dqb_btime;
+	__u64 dqb_itime;
+	__u32 dqb_valid;
+};
+
+/*
+ * Structure used for setting quota information about file via quotactl
+ * Following flags are used to specify which fields are valid
+ */
+#define IIF_BGRACE	1
+#define IIF_IGRACE	2
+#define IIF_FLAGS	4
+#define IIF_ALL		(IIF_BGRACE | IIF_IGRACE | IIF_FLAGS)
+
+struct if_dqinfo {
+	__u64 dqi_bgrace;
+	__u64 dqi_igrace;
+	__u32 dqi_flags;
+	__u32 dqi_valid;
+};
+
+/*
+ * Definitions for quota netlink interface
+ */
+#define QUOTA_NL_NOWARN 0
+#define QUOTA_NL_IHARDWARN 1		/* Inode hardlimit reached */
+#define QUOTA_NL_ISOFTLONGWARN 2	/* Inode grace time expired */
+#define QUOTA_NL_ISOFTWARN 3		/* Inode softlimit reached */
+#define QUOTA_NL_BHARDWARN 4		/* Block hardlimit reached */
+#define QUOTA_NL_BSOFTLONGWARN 5	/* Block grace time expired */
+#define QUOTA_NL_BSOFTWARN 6		/* Block softlimit reached */
+#define QUOTA_NL_IHARDBELOW 7		/* Usage got below inode hardlimit */
+#define QUOTA_NL_ISOFTBELOW 8		/* Usage got below inode softlimit */
+#define QUOTA_NL_BHARDBELOW 9		/* Usage got below block hardlimit */
+#define QUOTA_NL_BSOFTBELOW 10		/* Usage got below block softlimit */
+
+enum {
+	QUOTA_NL_C_UNSPEC,
+	QUOTA_NL_C_WARNING,
+	__QUOTA_NL_C_MAX,
+};
+#define QUOTA_NL_C_MAX (__QUOTA_NL_C_MAX - 1)
+
+enum {
+	QUOTA_NL_A_UNSPEC,
+	QUOTA_NL_A_QTYPE,
+	QUOTA_NL_A_EXCESS_ID,
+	QUOTA_NL_A_WARNING,
+	QUOTA_NL_A_DEV_MAJOR,
+	QUOTA_NL_A_DEV_MINOR,
+	QUOTA_NL_A_CAUSED_ID,
+	__QUOTA_NL_A_MAX,
+};
+#define QUOTA_NL_A_MAX (__QUOTA_NL_A_MAX - 1)
+
+#endif /* _QUOTA_ */
diff --git a/lib/quota/quota.pc.in b/lib/quota/quota.pc.in
new file mode 100644
index 0000000..bcc3c44
--- /dev/null
+++ b/lib/quota/quota.pc.in
@@ -0,0 +1,11 @@
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+libdir=@libdir@
+includedir=@includedir@
+
+Name: quota
+Description: Quota management library
+Version: @E2FSPROGS_VERSION@
+Requires:
+Cflags: -I${includedir}/quota
+Libs: -L${libdir} -lquota
diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
new file mode 100644
index 0000000..803bf12
--- /dev/null
+++ b/lib/quota/quotaio.c
@@ -0,0 +1,359 @@
+/** quotaio.c
+ *
+ * Generic IO operations on quotafiles
+ * Jan Kara <jack@suse.cz> - sponsored by SuSE CR
+ * Aditya Kali <adityakali@google.com> - Ported to e2fsprogs
+ */
+
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/file.h>
+#include <asm/byteorder.h>
+
+#include "common.h"
+#include "quotaio.h"
+
+static const char extensions[MAXQUOTAS + 2][20] = INITQFNAMES;
+static const char * const basenames[] = {
+	"",		/* undefined */
+	"quota",	/* QFMT_VFS_OLD */
+	"aquota",	/* QFMT_VFS_V0 */
+	"",		/* QFMT_OCFS2 */
+	"aquota"	/* QFMT_VFS_V1 */
+};
+
+static const char * const fmtnames[] = {
+	"vfsold",
+	"vfsv0",
+	"vfsv1",
+	"rpc",
+	"xfs"
+};
+
+/* Header in all newer quotafiles */
+struct disk_dqheader {
+	u_int32_t dqh_magic;
+	u_int32_t dqh_version;
+} __attribute__ ((packed));
+
+/**
+ * Convert type of quota to written representation
+ */
+const char *type2name(int type)
+{
+	return extensions[type];
+}
+
+/**
+ * Creates a quota file name for given type and format.
+ */
+const char *get_qf_name(int type, int fmt, char *buf)
+{
+	BUG_ON(!buf);
+	snprintf(buf, PATH_MAX, "%s.%s",
+		 basenames[fmt], extensions[type]);
+
+	return buf;
+}
+
+const char *get_qf_path(const char *mntpt, int qtype, int fmt,
+			char *path_buf, size_t path_buf_size)
+{
+	struct stat	qf_stat;
+	char qf_name[PATH_MAX] = {0};
+
+	BUG_ON(!mntpt);
+	BUG_ON(!path_buf);
+	BUG_ON(!path_buf_size);
+
+	strncpy(path_buf, mntpt, path_buf_size);
+	strncat(path_buf, "/", 1);
+	strncat(path_buf, get_qf_name(qtype, fmt, qf_name),
+		path_buf_size - strlen(path_buf));
+
+	return path_buf;
+}
+
+/*
+ * Set grace time if needed
+ */
+void update_grace_times(struct dquot *q)
+{
+	time_t now;
+
+	time(&now);
+	if (q->dq_dqb.dqb_bsoftlimit && toqb(q->dq_dqb.dqb_curspace) >
+			q->dq_dqb.dqb_bsoftlimit) {
+		if (!q->dq_dqb.dqb_btime)
+			q->dq_dqb.dqb_btime =
+				now + q->dq_h->qh_info.dqi_bgrace;
+	} else {
+		q->dq_dqb.dqb_btime = 0;
+	}
+
+	if (q->dq_dqb.dqb_isoftlimit && q->dq_dqb.dqb_curinodes >
+			q->dq_dqb.dqb_isoftlimit) {
+		if (!q->dq_dqb.dqb_itime)
+				q->dq_dqb.dqb_itime =
+					now + q->dq_h->qh_info.dqi_igrace;
+	} else {
+		q->dq_dqb.dqb_itime = 0;
+	}
+}
+
+static int release_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
+			       e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
+			       blk64_t ref_block EXT2FS_ATTR((unused)),
+			       int ref_offset EXT2FS_ATTR((unused)),
+			       void *private EXT2FS_ATTR((unused)))
+{
+	blk64_t	block;
+
+	block = *blocknr;
+	ext2fs_block_alloc_stats2(fs, block, -1);
+	return 0;
+}
+
+static int compute_num_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
+			       e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
+			       blk64_t ref_block EXT2FS_ATTR((unused)),
+			       int ref_offset EXT2FS_ATTR((unused)),
+			       void *private)
+{
+	blk64_t	block;
+	blk64_t *num_blocks = private;
+
+	*num_blocks += 1;
+	return 0;
+}
+
+void truncate_quota_inode(ext2_filsys fs, ext2_ino_t ino)
+{
+	struct ext2_inode inode;
+	int i;
+
+	if (ext2fs_read_inode(fs, ino, &inode))
+		return;
+
+	inode.i_dtime = fs->now ? fs->now : time(0);
+	if (!ext2fs_inode_has_valid_blocks(&inode))
+		return;
+
+	ext2fs_block_iterate3(fs, ino, BLOCK_FLAG_READ_ONLY, NULL,
+			      release_blocks_proc, NULL);
+
+	memset(&inode, 0, sizeof(struct ext2_inode));
+	ext2fs_write_inode(fs, ino, &inode);
+}
+
+static ext2_off64_t compute_inode_size(ext2_filsys fs, ext2_ino_t ino)
+{
+	struct ext2_inode inode;
+	blk64_t num_blocks = 0;
+
+	ext2fs_block_iterate3(fs, ino,
+			      BLOCK_FLAG_READ_ONLY,
+			      NULL,
+			      compute_num_blocks_proc,
+			      &num_blocks);
+	return num_blocks * fs->blocksize;
+}
+
+/* Functions to read/write quota file. */
+static unsigned int quota_write_nomount(struct quota_file *qf, loff_t offset,
+					void *buf, unsigned int size)
+{
+	ext2_file_t	e2_file = qf->e2_file;
+	unsigned int	bytes_written = 0;
+	errcode_t	err;
+
+	err = ext2fs_file_llseek(e2_file, offset, EXT2_SEEK_SET, NULL);
+	if (err) {
+		log_err("ext2fs_file_llseek failed: %ld", err);
+		return 0;
+	}
+
+	err = ext2fs_file_write(e2_file, buf, size, &bytes_written);
+	if (err) {
+		log_err("ext2fs_file_write failed: %ld", err);
+		return 0;
+	}
+
+	/* Correct inode.i_size is set in end_io. */
+	return bytes_written;
+}
+
+static unsigned int quota_read_nomount(struct quota_file *qf, loff_t offset,
+					void *buf, unsigned int size)
+{
+	ext2_file_t	e2_file = qf->e2_file;
+	unsigned int	bytes_read = 0;
+	errcode_t	err;
+
+	err = ext2fs_file_llseek(e2_file, offset, EXT2_SEEK_SET, NULL);
+	if (err) {
+		log_err("ext2fs_file_llseek failed: %ld", err);
+		return 0;
+	}
+
+	err = ext2fs_file_read(e2_file, buf, size, &bytes_read);
+	if (err) {
+		log_err("ext2fs_file_read failed: %ld", err);
+		return 0;
+	}
+
+	return bytes_read;
+}
+
+/*
+ * Detect quota format and initialize quota IO
+ */
+struct quota_handle *init_io(ext2_filsys fs, const char *mntpt, int type,
+			     int fmt, int flags)
+{
+	log_err("Not Implemented.", "");
+	BUG_ON(1);
+	return NULL;
+}
+
+static errcode_t init_new_quota_inode(ext2_filsys fs, ext2_ino_t ino)
+{
+	struct ext2_inode inode;
+	errcode_t err = 0;
+
+	err = ext2fs_read_inode(fs, ino, &inode);
+	if (err) {
+		log_err("ex2fs_read_inode failed", "");
+		return err;
+	}
+
+	if (EXT2_I_SIZE(&inode))
+		truncate_quota_inode(fs, ino);
+
+	memset(&inode, 0, sizeof(struct ext2_inode));
+	ext2fs_iblk_set(fs, &inode, 0);
+	inode.i_atime = inode.i_mtime =
+		inode.i_ctime = fs->now ? fs->now : time(0);
+	inode.i_links_count = 1;
+	inode.i_mode = LINUX_S_IFREG | 0600;
+	inode.i_flags |= EXT2_IMMUTABLE_FL;
+	if (fs->super->s_feature_incompat &
+			EXT3_FEATURE_INCOMPAT_EXTENTS)
+		inode.i_flags |= EXT4_EXTENTS_FL;
+
+	err = ext2fs_write_new_inode(fs, ino, &inode);
+	if (err) {
+		log_err("ext2fs_write_new_inode failed: %ld", err);
+		return err;
+	}
+	return err;
+}
+
+/*
+ * Create new quotafile of specified format on given filesystem
+ */
+int new_io(struct quota_handle *h, ext2_filsys fs, int type, int fmt)
+{
+	int fd = 0;
+	ext2_file_t e2_file;
+	const char *mnt_fsname;
+	char qf_name[PATH_MAX];
+	int err;
+	struct ext2_inode inode;
+	unsigned long qf_inum;
+	struct stat st;
+
+	if (fmt == -1)
+		fmt = QFMT_VFS_V1;
+
+	h->qh_qf.fs = fs;
+	if (type == USRQUOTA)
+		qf_inum = EXT4_USR_QUOTA_INO;
+	else if (type == GRPQUOTA)
+		qf_inum = EXT4_GRP_QUOTA_INO;
+	else
+		BUG_ON(1);
+	err = ext2fs_read_bitmaps(fs);
+	if (err)
+		goto out_err;
+
+	err = init_new_quota_inode(fs, qf_inum);
+	if (err) {
+		log_err("init_new_quota_inode failed", "");
+		goto out_err;
+	}
+	h->qh_qf.ino = qf_inum;
+	h->e2fs_write = quota_write_nomount;
+	h->e2fs_read = quota_read_nomount;
+
+	log_debug("Creating quota ino=%lu, type=%d", qf_inum, type);
+	err = ext2fs_file_open(fs, qf_inum,
+			EXT2_FILE_WRITE | EXT2_FILE_CREATE, &e2_file);
+	if (err) {
+		log_err("ext2fs_file_open failed: %d", err);
+		goto out_err;
+	}
+	h->qh_qf.e2_file = e2_file;
+
+	h->qh_io_flags = 0;
+	h->qh_type = type;
+	h->qh_fmt = fmt;
+	memset(&h->qh_info, 0, sizeof(h->qh_info));
+	h->qh_ops = &quotafile_ops_2;
+
+	if (h->qh_ops->new_io && (h->qh_ops->new_io(h) < 0)) {
+		log_err("qh_ops->new_io failed", "");
+		goto out_err1;
+	}
+
+	return 0;
+
+out_err1:
+	ext2fs_file_close(e2_file);
+out_err:
+
+	if (qf_inum)
+		truncate_quota_inode(fs, qf_inum);
+
+	return -1;
+}
+
+/*
+ * Close quotafile and release handle
+ */
+int end_io(struct quota_handle *h)
+{
+	if (h->qh_io_flags & IOFL_INFODIRTY) {
+		if (h->qh_ops->write_info && h->qh_ops->write_info(h) < 0)
+			return -1;
+		h->qh_io_flags &= ~IOFL_INFODIRTY;
+	}
+
+	if (h->qh_ops->end_io && h->qh_ops->end_io(h) < 0)
+		return -1;
+	if (h->qh_qf.e2_file) {
+		ext2fs_file_flush(h->qh_qf.e2_file);
+		ext2fs_file_set_size2(h->qh_qf.e2_file,
+			compute_inode_size(h->qh_qf.fs, h->qh_qf.ino));
+		ext2fs_file_close(h->qh_qf.e2_file);
+	}
+
+	return 0;
+}
+
+/*
+ * Create empty quota structure
+ */
+struct dquot *get_empty_dquot(void)
+{
+	struct dquot *dquot = smalloc(sizeof(struct dquot));
+
+	memset(dquot, 0, sizeof(*dquot));
+	dquot->dq_id = -1;
+	return dquot;
+}
diff --git a/lib/quota/quotaio.h b/lib/quota/quotaio.h
new file mode 100644
index 0000000..fd39b55
--- /dev/null
+++ b/lib/quota/quotaio.h
@@ -0,0 +1,163 @@
+/** quotaio.h
+ *
+ * Header of IO operations for quota utilities
+ * Jan Kara <jack@suse.cz>
+ */
+
+#ifndef GUARD_QUOTAIO_H
+#define GUARD_QUOTAIO_H
+
+#include <limits.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include "ext2fs/ext2fs.h"
+#include "quota.h"
+#include "dqblk_v2.h"
+
+/*
+ * Definitions for disk quotas imposed on the average user
+ * (big brother finally hits Linux).
+ *
+ * The following constants define the default amount of time given a user
+ * before the soft limits are treated as hard limits (usually resulting
+ * in an allocation failure). The timer is started when the user crosses
+ * their soft limit, it is reset when they go below their soft limit.
+ */
+#define MAX_IQ_TIME  604800	/* (7*24*60*60) 1 week */
+#define MAX_DQ_TIME  604800	/* (7*24*60*60) 1 week */
+
+#define IOFL_QUOTAON	0x01	/* Is quota enabled in kernel? */
+#define IOFL_INFODIRTY	0x02	/* Did info change? */
+#define IOFL_RO		0x04	/* Just RO access? */
+#define IOFL_NFS_MIXED_PATHS	0x08	/* Should we trim leading slashes
+					   from NFSv4 mountpoints? */
+
+struct quotafile_ops;
+
+/* Generic information about quotafile */
+struct util_dqinfo {
+	time_t dqi_bgrace;	/* Block grace time for given quotafile */
+	time_t dqi_igrace;	/* Inode grace time for given quotafile */
+	union {
+		struct v2_mem_dqinfo v2_mdqi;
+	} u;			/* Format specific info about quotafile */
+};
+
+struct quota_file {
+	ext2_filsys fs;
+	ext2_ino_t ino;
+	ext2_file_t e2_file;
+};
+
+/* Structure for one opened quota file */
+struct quota_handle {
+	int qh_type;		/* Type of quotafile */
+	int qh_fmt;		/* Quotafile format */
+	int qh_io_flags;	/* IO flags for file */
+	struct quota_file qh_qf;
+	unsigned int (*e2fs_read)(struct quota_file *qf, loff_t offset,
+			 void *buf, unsigned int size);
+	unsigned int (*e2fs_write)(struct quota_file *qf, loff_t offset,
+			  void *buf, unsigned int size);
+	struct quotafile_ops *qh_ops;	/* Operations on quotafile */
+	struct util_dqinfo qh_info;	/* Generic quotafile info */
+};
+
+/* Statistics gathered from kernel */
+struct util_dqstats {
+	u_int32_t lookups;
+	u_int32_t drops;
+	u_int32_t reads;
+	u_int32_t writes;
+	u_int32_t cache_hits;
+	u_int32_t allocated_dquots;
+	u_int32_t free_dquots;
+	u_int32_t syncs;
+	u_int32_t version;
+};
+
+/* Utility quota block */
+struct util_dqblk {
+	qsize_t dqb_ihardlimit;
+	qsize_t dqb_isoftlimit;
+	qsize_t dqb_curinodes;
+	qsize_t dqb_bhardlimit;
+	qsize_t dqb_bsoftlimit;
+	qsize_t dqb_curspace;
+	time_t dqb_btime;
+	time_t dqb_itime;
+	union {
+		struct v2_mem_dqblk v2_mdqb;
+	} u;			/* Format specific dquot information */
+};
+
+/* Structure for one loaded quota */
+struct dquot {
+	struct dquot *dq_next;	/* Pointer to next dquot in the list */
+	qid_t dq_id;		/* ID dquot belongs to */
+	int dq_flags;		/* Some flags for utils */
+	struct quota_handle *dq_h;	/* Handle of quotafile for this dquot */
+	struct util_dqblk dq_dqb;	/* Parsed data of dquot */
+};
+
+/* Flags for commit function (have effect only when quota in kernel is
+ * turned on) */
+#define COMMIT_USAGE QIF_USAGE
+#define COMMIT_LIMITS QIF_LIMITS
+#define COMMIT_TIMES QIF_TIMES
+#define COMMIT_ALL (COMMIT_USAGE | COMMIT_LIMITS | COMMIT_TIMES)
+
+/* Structure of quotafile operations */
+struct quotafile_ops {
+	/* Check whether quotafile is in our format */
+	int (*check_file) (struct quota_handle *h, int type, int fmt);
+	/* Open quotafile */
+	int (*init_io) (struct quota_handle *h);
+	/* Create new quotafile */
+	int (*new_io) (struct quota_handle *h);
+	/* Write all changes and close quotafile */
+	int (*end_io) (struct quota_handle *h);
+	/* Write info about quotafile */
+	int (*write_info) (struct quota_handle *h);
+	/* Read dquot into memory */
+	struct dquot *(*read_dquot) (struct quota_handle *h, qid_t id);
+	/* Write given dquot to disk */
+	int (*commit_dquot) (struct dquot *dquot, int flag);
+	/* Scan quotafile and call callback on every structure */
+	int (*scan_dquots) (struct quota_handle *h,
+			    int (*process_dquot) (struct dquot *dquot,
+						  char *dqname));
+	/* Function to print format specific file information */
+	int (*report) (struct quota_handle *h, int verbose);
+};
+
+/* This might go into a special header file but that sounds a bit silly... */
+extern struct quotafile_ops quotafile_ops_meta;
+
+static inline void mark_quotafile_info_dirty(struct quota_handle *h)
+{
+	h->qh_io_flags |= IOFL_INFODIRTY;
+}
+
+#define QIO_ENABLED(h)	((h)->qh_io_flags & IOFL_QUOTAON)
+#define QIO_RO(h)	((h)->qh_io_flags & IOFL_RO)
+
+/* Check quota format used on specified medium and initialize it */
+struct quota_handle *init_io(ext2_filsys fs, const char *mntpt, int type,
+			     int fmt, int flags);
+
+/* Create new quotafile of specified format on given filesystem */
+int new_io(struct quota_handle *h, ext2_filsys fs, int type, int fmt);
+
+/* Close quotafile */
+int end_io(struct quota_handle *h);
+
+/* Get empty quota structure */
+struct dquot *get_empty_dquot(void);
+
+void truncate_quota_inode(ext2_filsys fs, ext2_ino_t ino);
+
+const char *type2name(int type);
+
+#endif /* GUARD_QUOTAIO_H */
diff --git a/lib/quota/quotaio_tree.c b/lib/quota/quotaio_tree.c
new file mode 100644
index 0000000..48e58f6
--- /dev/null
+++ b/lib/quota/quotaio_tree.c
@@ -0,0 +1,574 @@
+/*
+ * Implementation of new quotafile format
+ *
+ * Jan Kara <jack@suse.cz> - sponsored by SuSE CR
+ */
+
+#include <sys/types.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <asm/byteorder.h>
+
+#include "common.h"
+#include "quotaio_tree.h"
+#include "quotaio.h"
+
+typedef char *dqbuf_t;
+
+#define getdqbuf()		smalloc(QT_BLKSIZE)
+#define freedqbuf(buf)		free(buf)
+
+/* Is given dquot empty? */
+int qtree_entry_unused(struct qtree_mem_dqinfo *info, char *disk)
+{
+	int i;
+
+	for (i = 0; i < info->dqi_entry_size; i++)
+		if (disk[i])
+			return 0;
+	return 1;
+}
+
+int qtree_dqstr_in_blk(struct qtree_mem_dqinfo *info)
+{
+	return (QT_BLKSIZE - sizeof(struct qt_disk_dqdbheader)) /
+		info->dqi_entry_size;
+}
+
+static int get_index(qid_t id, int depth)
+{
+	return (id >> ((QT_TREEDEPTH - depth - 1) * 8)) & 0xff;
+}
+
+/* Read given block */
+static void read_blk(struct quota_handle *h, uint blk, dqbuf_t buf)
+{
+	int err;
+
+	err = h->e2fs_read(&h->qh_qf, blk << QT_BLKSIZE_BITS, buf,
+			QT_BLKSIZE);
+	if (err < 0)
+		log_fatal(2, "Cannot read block %u: %s", blk, strerror(errno));
+	else if (err != QT_BLKSIZE)
+		memset(buf + err, 0, QT_BLKSIZE - err);
+}
+
+/* Write block */
+static int write_blk(struct quota_handle *h, uint blk, dqbuf_t buf)
+{
+	int err;
+
+	err = h->e2fs_write(&h->qh_qf, blk << QT_BLKSIZE_BITS, buf,
+			QT_BLKSIZE);
+	if (err < 0 && errno != ENOSPC)
+		log_fatal(2, "Cannot write block (%u): %s",
+			  blk, strerror(errno));
+	if (err != QT_BLKSIZE)
+		return -ENOSPC;
+	return 0;
+}
+
+/* Get free block in file (either from free list or create new one) */
+static int get_free_dqblk(struct quota_handle *h)
+{
+	dqbuf_t buf = getdqbuf();
+	struct qt_disk_dqdbheader *dh = (struct qt_disk_dqdbheader *)buf;
+	struct qtree_mem_dqinfo *info = &h->qh_info.u.v2_mdqi.dqi_qtree;
+	int blk;
+
+	if (info->dqi_free_blk) {
+		blk = info->dqi_free_blk;
+		read_blk(h, blk, buf);
+		info->dqi_free_blk = __le32_to_cpu(dh->dqdh_next_free);
+	} else {
+		memset(buf, 0, QT_BLKSIZE);
+		/* Assure block allocation... */
+		if (write_blk(h, info->dqi_blocks, buf) < 0) {
+			freedqbuf(buf);
+			log_err("Cannot allocate new quota block "
+				"(out of disk space).", "");
+			return -ENOSPC;
+		}
+		blk = info->dqi_blocks++;
+	}
+	mark_quotafile_info_dirty(h);
+	freedqbuf(buf);
+	return blk;
+}
+
+/* Put given block to free list */
+static void put_free_dqblk(struct quota_handle *h, dqbuf_t buf, uint blk)
+{
+	struct qt_disk_dqdbheader *dh = (struct qt_disk_dqdbheader *)buf;
+	struct qtree_mem_dqinfo *info = &h->qh_info.u.v2_mdqi.dqi_qtree;
+
+	dh->dqdh_next_free = __cpu_to_le32(info->dqi_free_blk);
+	dh->dqdh_prev_free = __cpu_to_le32(0);
+	dh->dqdh_entries = __cpu_to_le16(0);
+	info->dqi_free_blk = blk;
+	mark_quotafile_info_dirty(h);
+	write_blk(h, blk, buf);
+}
+
+/* Remove given block from the list of blocks with free entries */
+static void remove_free_dqentry(struct quota_handle *h, dqbuf_t buf, uint blk)
+{
+	dqbuf_t tmpbuf = getdqbuf();
+	struct qt_disk_dqdbheader *dh = (struct qt_disk_dqdbheader *)buf;
+	uint nextblk = __le32_to_cpu(dh->dqdh_next_free), prevblk =
+
+		__le32_to_cpu(dh->dqdh_prev_free);
+
+	if (nextblk) {
+		read_blk(h, nextblk, tmpbuf);
+		((struct qt_disk_dqdbheader *)tmpbuf)->dqdh_prev_free =
+				dh->dqdh_prev_free;
+		write_blk(h, nextblk, tmpbuf);
+	}
+	if (prevblk) {
+		read_blk(h, prevblk, tmpbuf);
+		((struct qt_disk_dqdbheader *)tmpbuf)->dqdh_next_free =
+				dh->dqdh_next_free;
+		write_blk(h, prevblk, tmpbuf);
+	} else {
+		h->qh_info.u.v2_mdqi.dqi_qtree.dqi_free_entry = nextblk;
+		mark_quotafile_info_dirty(h);
+	}
+	freedqbuf(tmpbuf);
+	dh->dqdh_next_free = dh->dqdh_prev_free = __cpu_to_le32(0);
+	write_blk(h, blk, buf);	/* No matter whether write succeeds
+				 * block is out of list */
+}
+
+/* Insert given block to the beginning of list with free entries */
+static void insert_free_dqentry(struct quota_handle *h, dqbuf_t buf, uint blk)
+{
+	dqbuf_t tmpbuf = getdqbuf();
+	struct qt_disk_dqdbheader *dh = (struct qt_disk_dqdbheader *)buf;
+	struct qtree_mem_dqinfo *info = &h->qh_info.u.v2_mdqi.dqi_qtree;
+
+	dh->dqdh_next_free = __cpu_to_le32(info->dqi_free_entry);
+	dh->dqdh_prev_free = __cpu_to_le32(0);
+	write_blk(h, blk, buf);
+	if (info->dqi_free_entry) {
+		read_blk(h, info->dqi_free_entry, tmpbuf);
+		((struct qt_disk_dqdbheader *)tmpbuf)->dqdh_prev_free =
+				__cpu_to_le32(blk);
+		write_blk(h, info->dqi_free_entry, tmpbuf);
+	}
+	freedqbuf(tmpbuf);
+	info->dqi_free_entry = blk;
+	mark_quotafile_info_dirty(h);
+}
+
+/* Find space for dquot */
+static uint find_free_dqentry(struct quota_handle *h, struct dquot *dquot,
+			      int *err)
+{
+	int blk, i;
+	struct qt_disk_dqdbheader *dh;
+	struct qtree_mem_dqinfo *info = &h->qh_info.u.v2_mdqi.dqi_qtree;
+	char *ddquot;
+	dqbuf_t buf;
+
+	*err = 0;
+	buf = getdqbuf();
+	dh = (struct qt_disk_dqdbheader *)buf;
+	if (info->dqi_free_entry) {
+		blk = info->dqi_free_entry;
+		read_blk(h, blk, buf);
+	} else {
+		blk = get_free_dqblk(h);
+		if (blk < 0) {
+			freedqbuf(buf);
+			*err = blk;
+			return 0;
+		}
+		memset(buf, 0, QT_BLKSIZE);
+		info->dqi_free_entry = blk;
+		mark_quotafile_info_dirty(h);
+	}
+
+	/* Block will be full? */
+	if (__le16_to_cpu(dh->dqdh_entries) + 1 >= qtree_dqstr_in_blk(info))
+		remove_free_dqentry(h, buf, blk);
+
+	dh->dqdh_entries = __cpu_to_le16(__le16_to_cpu(dh->dqdh_entries) + 1);
+	/* Find free structure in block */
+	ddquot = buf + sizeof(struct qt_disk_dqdbheader);
+	for (i = 0;
+	     i < qtree_dqstr_in_blk(info) && !qtree_entry_unused(info, ddquot);
+	     i++)
+		ddquot += info->dqi_entry_size;
+
+	if (i == qtree_dqstr_in_blk(info))
+		log_fatal(2, "find_free_dqentry(): Data block full but it "
+			     "shouldn't.", "");
+
+	write_blk(h, blk, buf);
+	dquot->dq_dqb.u.v2_mdqb.dqb_off =
+		(blk << QT_BLKSIZE_BITS) + sizeof(struct qt_disk_dqdbheader) +
+		i * info->dqi_entry_size;
+	freedqbuf(buf);
+	return blk;
+}
+
+/* Insert reference to structure into the trie */
+static int do_insert_tree(struct quota_handle *h, struct dquot *dquot,
+			  uint * treeblk, int depth)
+{
+	dqbuf_t buf;
+	int newson = 0, newact = 0;
+	u_int32_t *ref;
+	uint newblk;
+	int ret = 0;
+
+	log_debug("inserting in tree: treeblk=%u, depth=%d", *treeblk, depth);
+	buf = getdqbuf();
+	if (!*treeblk) {
+		ret = get_free_dqblk(h);
+		if (ret < 0)
+			goto out_buf;
+		*treeblk = ret;
+		memset(buf, 0, QT_BLKSIZE);
+		newact = 1;
+	} else {
+		read_blk(h, *treeblk, buf);
+	}
+
+	ref = (u_int32_t *) buf;
+	newblk = __le32_to_cpu(ref[get_index(dquot->dq_id, depth)]);
+	if (!newblk)
+		newson = 1;
+	if (depth == QT_TREEDEPTH - 1) {
+		if (newblk)
+			log_fatal(2, "Inserting already present quota entry "
+				     "(block %u).",
+				  ref[get_index(dquot->dq_id, depth)]);
+		newblk = find_free_dqentry(h, dquot, &ret);
+	} else {
+		ret = do_insert_tree(h, dquot, &newblk, depth + 1);
+	}
+
+	if (newson && ret >= 0) {
+		ref[get_index(dquot->dq_id, depth)] = __cpu_to_le32(newblk);
+		write_blk(h, *treeblk, buf);
+	} else if (newact && ret < 0) {
+		put_free_dqblk(h, buf, *treeblk);
+	}
+
+out_buf:
+	freedqbuf(buf);
+	return ret;
+}
+
+/* Wrapper for inserting quota structure into tree */
+static void dq_insert_tree(struct quota_handle *h, struct dquot *dquot)
+{
+	uint tmp = QT_TREEOFF;
+
+	if (do_insert_tree(h, dquot, &tmp, 0) < 0)
+		log_fatal(2, "Cannot write quota (id %u): %s",
+			  (uint) dquot->dq_id, strerror(errno));
+}
+
+/* Write dquot to file */
+void qtree_write_dquot(struct dquot *dquot)
+{
+	ssize_t ret;
+	struct quota_handle *h = dquot->dq_h;
+	struct qtree_mem_dqinfo *info =
+			&dquot->dq_h->qh_info.u.v2_mdqi.dqi_qtree;
+	log_debug("writing ddquot 1: off=%llu, info->dqi_entry_size=%u",
+			dquot->dq_dqb.u.v2_mdqb.dqb_off,
+			info->dqi_entry_size);
+	char *ddquot = (char *)smalloc(info->dqi_entry_size);
+
+	if (!dquot->dq_dqb.u.v2_mdqb.dqb_off)
+		dq_insert_tree(dquot->dq_h, dquot);
+	info->dqi_ops->mem2disk_dqblk(ddquot, dquot);
+	log_debug("writing ddquot 2: off=%llu, info->dqi_entry_size=%u",
+			dquot->dq_dqb.u.v2_mdqb.dqb_off,
+			info->dqi_entry_size);
+	ret = h->e2fs_write(&h->qh_qf, dquot->dq_dqb.u.v2_mdqb.dqb_off, ddquot,
+			info->dqi_entry_size);
+
+	if (ret != info->dqi_entry_size) {
+		if (ret > 0)
+			errno = ENOSPC;
+		log_fatal(2, "Quota write failed (id %u): %s",
+			  (uint)dquot->dq_id, strerror(errno));
+	}
+}
+
+/* Free dquot entry in data block */
+static void free_dqentry(struct quota_handle *h, struct dquot *dquot, uint blk)
+{
+	struct qt_disk_dqdbheader *dh;
+	struct qtree_mem_dqinfo *info = &h->qh_info.u.v2_mdqi.dqi_qtree;
+	dqbuf_t buf = getdqbuf();
+
+	if (dquot->dq_dqb.u.v2_mdqb.dqb_off >> QT_BLKSIZE_BITS != blk)
+		log_fatal(2, "Quota structure has offset to other block (%u) "
+			     "than it should (%u).", blk,
+			  (uint) (dquot->dq_dqb.u.v2_mdqb.dqb_off >>
+				  QT_BLKSIZE_BITS));
+
+	read_blk(h, blk, buf);
+	dh = (struct qt_disk_dqdbheader *)buf;
+	dh->dqdh_entries = __cpu_to_le16(__le16_to_cpu(dh->dqdh_entries) - 1);
+
+	if (!__le16_to_cpu(dh->dqdh_entries)) {	/* Block got free? */
+		remove_free_dqentry(h, buf, blk);
+		put_free_dqblk(h, buf, blk);
+	} else {
+		memset(buf + (dquot->dq_dqb.u.v2_mdqb.dqb_off &
+			      ((1 << QT_BLKSIZE_BITS) - 1)),
+		       0, info->dqi_entry_size);
+
+		/* First free entry? */
+		if (__le16_to_cpu(dh->dqdh_entries) ==
+				qtree_dqstr_in_blk(info) - 1)
+			/* This will also write data block */
+			insert_free_dqentry(h, buf, blk);
+		else
+			write_blk(h, blk, buf);
+	}
+	dquot->dq_dqb.u.v2_mdqb.dqb_off = 0;
+	freedqbuf(buf);
+}
+
+/* Remove reference to dquot from tree */
+static void remove_tree(struct quota_handle *h, struct dquot *dquot,
+			uint * blk, int depth)
+{
+	dqbuf_t buf = getdqbuf();
+	uint newblk;
+	u_int32_t *ref = (u_int32_t *) buf;
+
+	read_blk(h, *blk, buf);
+	newblk = __le32_to_cpu(ref[get_index(dquot->dq_id, depth)]);
+	if (depth == QT_TREEDEPTH - 1) {
+		free_dqentry(h, dquot, newblk);
+		newblk = 0;
+	} else {
+		remove_tree(h, dquot, &newblk, depth + 1);
+	}
+
+	if (!newblk) {
+		int i;
+
+		ref[get_index(dquot->dq_id, depth)] = __cpu_to_le32(0);
+
+		/* Block got empty? */
+		for (i = 0; i < QT_BLKSIZE && !buf[i]; i++);
+
+		/* Don't put the root block into the free block list */
+		if (i == QT_BLKSIZE && *blk != QT_TREEOFF) {
+			put_free_dqblk(h, buf, *blk);
+			*blk = 0;
+		} else {
+			write_blk(h, *blk, buf);
+		}
+	}
+	freedqbuf(buf);
+}
+
+/* Delete dquot from tree */
+void qtree_delete_dquot(struct dquot *dquot)
+{
+	uint tmp = QT_TREEOFF;
+
+	if (!dquot->dq_dqb.u.v2_mdqb.dqb_off)	/* Even not allocated? */
+		return;
+	remove_tree(dquot->dq_h, dquot, &tmp, 0);
+}
+
+/* Find entry in block */
+static loff_t find_block_dqentry(struct quota_handle *h,
+				 struct dquot *dquot, uint blk)
+{
+	struct qtree_mem_dqinfo *info = &h->qh_info.u.v2_mdqi.dqi_qtree;
+	dqbuf_t buf = getdqbuf();
+	int i;
+	char *ddquot = buf + sizeof(struct qt_disk_dqdbheader);
+
+	read_blk(h, blk, buf);
+	for (i = 0;
+	     i < qtree_dqstr_in_blk(info) && !info->dqi_ops->is_id(ddquot, dquot);
+	     i++)
+		ddquot += info->dqi_entry_size;
+
+	if (i == qtree_dqstr_in_blk(info))
+		log_fatal(2, "Quota for id %u referenced but not present.",
+			  dquot->dq_id);
+	freedqbuf(buf);
+	return (blk << QT_BLKSIZE_BITS) + sizeof(struct qt_disk_dqdbheader) +
+		i * info->dqi_entry_size;
+}
+
+/* Find entry for given id in the tree */
+static loff_t find_tree_dqentry(struct quota_handle *h, struct dquot *dquot,
+				uint blk, int depth)
+{
+	dqbuf_t buf = getdqbuf();
+	loff_t ret = 0;
+	u_int32_t *ref = (u_int32_t *) buf;
+
+	read_blk(h, blk, buf);
+	ret = 0;
+	blk = __le32_to_cpu(ref[get_index(dquot->dq_id, depth)]);
+	if (!blk)	/* No reference? */
+		goto out_buf;
+	if (depth < QT_TREEDEPTH - 1)
+		ret = find_tree_dqentry(h, dquot, blk, depth + 1);
+	else
+		ret = find_block_dqentry(h, dquot, blk);
+out_buf:
+	freedqbuf(buf);
+	return ret;
+}
+
+/* Find entry for given id in the tree - wrapper function */
+static inline loff_t find_dqentry(struct quota_handle *h, struct dquot *dquot)
+{
+	return find_tree_dqentry(h, dquot, QT_TREEOFF, 0);
+}
+
+/*
+ *  Read dquot (either from disk or from kernel)
+ *  User can use errno to detect errstr when NULL is returned
+ */
+struct dquot *qtree_read_dquot(struct quota_handle *h, qid_t id)
+{
+	struct qtree_mem_dqinfo *info = &h->qh_info.u.v2_mdqi.dqi_qtree;
+	loff_t offset;
+	ssize_t ret;
+	char *ddquot = smalloc(info->dqi_entry_size);
+	struct dquot *dquot = get_empty_dquot();
+
+	dquot->dq_id = id;
+	dquot->dq_h = h;
+	dquot->dq_dqb.u.v2_mdqb.dqb_off = 0;
+	memset(&dquot->dq_dqb, 0, sizeof(struct util_dqblk));
+
+	offset = find_dqentry(h, dquot);
+	if (offset > 0) {
+		dquot->dq_dqb.u.v2_mdqb.dqb_off = offset;
+		ret = h->e2fs_read(&h->qh_qf, offset, ddquot,
+			info->dqi_entry_size);
+		if (ret != info->dqi_entry_size) {
+			if (ret > 0)
+				errno = EIO;
+			log_fatal(2,
+				"Cannot read quota structure for id %u: %s",
+				dquot->dq_id, strerror(errno));
+		}
+		info->dqi_ops->disk2mem_dqblk(dquot, ddquot);
+	}
+	return dquot;
+}
+
+/*
+ *	Scan all dquots in file and call callback on each
+ */
+#define set_bit(bmp, ind) ((bmp)[(ind) >> 3] |= (1 << ((ind) & 7)))
+#define get_bit(bmp, ind) ((bmp)[(ind) >> 3] & (1 << ((ind) & 7)))
+
+static int report_block(struct dquot *dquot, uint blk, char *bitmap,
+			int (*process_dquot) (struct dquot *, char *))
+{
+	struct qtree_mem_dqinfo *info =
+			&dquot->dq_h->qh_info.u.v2_mdqi.dqi_qtree;
+	dqbuf_t buf = getdqbuf();
+	struct qt_disk_dqdbheader *dh;
+	char *ddata;
+	int entries, i;
+
+	set_bit(bitmap, blk);
+	read_blk(dquot->dq_h, blk, buf);
+	dh = (struct qt_disk_dqdbheader *)buf;
+	ddata = buf + sizeof(struct qt_disk_dqdbheader);
+	entries = __le16_to_cpu(dh->dqdh_entries);
+	for (i = 0; i < qtree_dqstr_in_blk(info);
+			i++, ddata += info->dqi_entry_size)
+		if (!qtree_entry_unused(info, ddata)) {
+			info->dqi_ops->disk2mem_dqblk(dquot, ddata);
+			if (process_dquot(dquot, NULL) < 0)
+				break;
+		}
+	freedqbuf(buf);
+	return entries;
+}
+
+static void check_reference(struct quota_handle *h, uint blk)
+{
+	if (blk >= h->qh_info.u.v2_mdqi.dqi_qtree.dqi_blocks)
+		log_fatal(2, "Illegal reference (%u >= %u) in %s quota file. "
+			     "Quota file is probably corrupted.\n"
+			     "Please run e2fsck (8) to fix it.",
+			  blk,
+			  h->qh_info.u.v2_mdqi.dqi_qtree.dqi_blocks,
+			  type2name(h->qh_type));
+}
+
+static int report_tree(struct dquot *dquot, uint blk, int depth, char *bitmap,
+		       int (*process_dquot) (struct dquot *, char *))
+{
+	int entries = 0, i;
+	dqbuf_t buf = getdqbuf();
+	u_int32_t *ref = (u_int32_t *) buf;
+
+	read_blk(dquot->dq_h, blk, buf);
+	if (depth == QT_TREEDEPTH - 1) {
+		for (i = 0; i < QT_BLKSIZE >> 2; i++) {
+			blk = __le32_to_cpu(ref[i]);
+			check_reference(dquot->dq_h, blk);
+			if (blk && !get_bit(bitmap, blk))
+				entries += report_block(dquot, blk, bitmap,
+							process_dquot);
+		}
+	} else {
+		for (i = 0; i < QT_BLKSIZE >> 2; i++)
+			blk = __le32_to_cpu(ref[i]);
+			if (blk) {
+				check_reference(dquot->dq_h, blk);
+				entries += report_tree(dquot, blk, depth + 1,
+						       bitmap, process_dquot);
+			}
+	}
+	freedqbuf(buf);
+	return entries;
+}
+
+static uint find_set_bits(char *bmp, int blocks)
+{
+	uint i, used = 0;
+
+	for (i = 0; i < blocks; i++)
+		if (get_bit(bmp, i))
+			used++;
+	return used;
+}
+
+int qtree_scan_dquots(struct quota_handle *h,
+		      int (*process_dquot) (struct dquot *, char *))
+{
+	char *bitmap;
+	struct v2_mem_dqinfo *v2info = &h->qh_info.u.v2_mdqi;
+	struct qtree_mem_dqinfo *info = &v2info->dqi_qtree;
+	struct dquot *dquot = get_empty_dquot();
+
+	dquot->dq_h = h;
+	bitmap = smalloc((info->dqi_blocks + 7) >> 3);
+	memset(bitmap, 0, (info->dqi_blocks + 7) >> 3);
+	v2info->dqi_used_entries = report_tree(dquot, QT_TREEOFF, 0, bitmap,
+					       process_dquot);
+	v2info->dqi_data_blocks = find_set_bits(bitmap, info->dqi_blocks);
+	free(bitmap);
+	free(dquot);
+	return 0;
+}
diff --git a/lib/quota/quotaio_tree.h b/lib/quota/quotaio_tree.h
new file mode 100644
index 0000000..a23777d
--- /dev/null
+++ b/lib/quota/quotaio_tree.h
@@ -0,0 +1,63 @@
+/*
+ * Definitions of structures for vfsv0 quota format
+ */
+
+#ifndef _LINUX_QUOTA_TREE_H
+#define _LINUX_QUOTA_TREE_H
+
+#include <sys/types.h>
+#include "quota.h"
+
+#define QT_TREEOFF	1	/* Offset of tree in file in blocks */
+#define QT_TREEDEPTH	4	/* Depth of quota tree */
+#define QT_BLKSIZE_BITS	10
+#define QT_BLKSIZE (1 << QT_BLKSIZE_BITS)	/* Size of block with quota
+						 * structures */
+
+/*
+ *  Structure of header of block with quota structures. It is padded to 16 bytes
+ *  so there will be space for exactly 21 quota-entries in a block
+ */
+struct qt_disk_dqdbheader {
+	u_int32_t dqdh_next_free;	/* Number of next block with free
+					 * entry */
+	u_int32_t dqdh_prev_free; /* Number of previous block with free
+				   * entry */
+	u_int16_t dqdh_entries; /* Number of valid entries in block */
+	u_int16_t dqdh_pad1;
+	u_int32_t dqdh_pad2;
+} __attribute__ ((packed));
+
+struct dquot;
+struct quota_handle;
+
+/* Operations */
+struct qtree_fmt_operations {
+	/* Convert given entry from in memory format to disk one */
+	void (*mem2disk_dqblk)(void *disk, struct dquot *dquot);
+	/* Convert given entry from disk format to in memory one */
+	void (*disk2mem_dqblk)(struct dquot *dquot, void *disk);
+	/* Is this structure for given id? */
+	int (*is_id)(void *disk, struct dquot *dquot);
+};
+
+/* Inmemory copy of version specific information */
+struct qtree_mem_dqinfo {
+	unsigned int dqi_blocks;	/* # of blocks in quota file */
+	unsigned int dqi_free_blk;	/* First block in list of free blocks */
+	unsigned int dqi_free_entry;	/* First block with free entry */
+	unsigned int dqi_entry_size;	/* Size of quota entry in quota file */
+	struct qtree_fmt_operations *dqi_ops;	/* Operations for entry
+						 * manipulation */
+};
+
+void qtree_write_dquot(struct dquot *dquot);
+struct dquot *qtree_read_dquot(struct quota_handle *h, qid_t id);
+void qtree_delete_dquot(struct dquot *dquot);
+int qtree_entry_unused(struct qtree_mem_dqinfo *info, char *disk);
+int qtree_scan_dquots(struct quota_handle *h,
+		int (*process_dquot) (struct dquot *, char *));
+
+int qtree_dqstr_in_blk(struct qtree_mem_dqinfo *info);
+
+#endif /* _LINUX_QUOTAIO_TREE_H */
diff --git a/lib/quota/quotaio_v2.c b/lib/quota/quotaio_v2.c
new file mode 100644
index 0000000..3b16144
--- /dev/null
+++ b/lib/quota/quotaio_v2.c
@@ -0,0 +1,314 @@
+/*
+ * Implementation of new quotafile format
+ *
+ * Jan Kara <jack@suse.cz> - sponsored by SuSE CR
+ */
+
+#include <sys/types.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <asm/byteorder.h>
+
+#include "common.h"
+#include "quotaio_v2.h"
+#include "dqblk_v2.h"
+#include "quotaio.h"
+#include "quotaio_tree.h"
+
+typedef char *dqbuf_t;
+
+static int v2_check_file(struct quota_handle *h, int type, int fmt);
+static int v2_init_io(struct quota_handle *h);
+static int v2_new_io(struct quota_handle *h);
+static int v2_write_info(struct quota_handle *h);
+static struct dquot *v2_read_dquot(struct quota_handle *h, qid_t id);
+static int v2_commit_dquot(struct dquot *dquot, int flags);
+static int v2_scan_dquots(struct quota_handle *h,
+			  int (*process_dquot) (struct dquot *dquot,
+						char *dqname));
+static int v2_report(struct quota_handle *h, int verbose);
+
+struct quotafile_ops quotafile_ops_2 = {
+check_file:	v2_check_file,
+init_io:	v2_init_io,
+new_io:		v2_new_io,
+write_info:	v2_write_info,
+read_dquot:	v2_read_dquot,
+commit_dquot:	v2_commit_dquot,
+scan_dquots:	v2_scan_dquots,
+report:	v2_report
+};
+
+#define getdqbuf() smalloc(V2_DQBLKSIZE)
+#define freedqbuf(buf) free(buf)
+
+/*
+ * Copy dquot from disk to memory
+ */
+static void v2r1_disk2memdqblk(struct dquot *dquot, void *dp)
+{
+	struct util_dqblk *m = &dquot->dq_dqb;
+	struct v2r1_disk_dqblk *d = dp, empty;
+
+	dquot->dq_id = __le32_to_cpu(d->dqb_id);
+	m->dqb_ihardlimit = __le64_to_cpu(d->dqb_ihardlimit);
+	m->dqb_isoftlimit = __le64_to_cpu(d->dqb_isoftlimit);
+	m->dqb_bhardlimit = __le64_to_cpu(d->dqb_bhardlimit);
+	m->dqb_bsoftlimit = __le64_to_cpu(d->dqb_bsoftlimit);
+	m->dqb_curinodes = __le64_to_cpu(d->dqb_curinodes);
+	m->dqb_curspace = __le64_to_cpu(d->dqb_curspace);
+	m->dqb_itime = __le64_to_cpu(d->dqb_itime);
+	m->dqb_btime = __le64_to_cpu(d->dqb_btime);
+
+	memset(&empty, 0, sizeof(struct v2r1_disk_dqblk));
+	empty.dqb_itime = __cpu_to_le64(1);
+	if (!memcmp(&empty, dp, sizeof(struct v2r1_disk_dqblk)))
+		m->dqb_itime = 0;
+}
+
+/*
+ * Copy dquot from memory to disk
+ */
+static void v2r1_mem2diskdqblk(void *dp, struct dquot *dquot)
+{
+	struct util_dqblk *m = &dquot->dq_dqb;
+	struct v2r1_disk_dqblk *d = dp;
+
+	d->dqb_ihardlimit = __cpu_to_le64(m->dqb_ihardlimit);
+	d->dqb_isoftlimit = __cpu_to_le64(m->dqb_isoftlimit);
+	d->dqb_bhardlimit = __cpu_to_le64(m->dqb_bhardlimit);
+	d->dqb_bsoftlimit = __cpu_to_le64(m->dqb_bsoftlimit);
+	d->dqb_curinodes = __cpu_to_le64(m->dqb_curinodes);
+	d->dqb_curspace = __cpu_to_le64(m->dqb_curspace);
+	d->dqb_itime = __cpu_to_le64(m->dqb_itime);
+	d->dqb_btime = __cpu_to_le64(m->dqb_btime);
+	d->dqb_id = __cpu_to_le32(dquot->dq_id);
+	if (qtree_entry_unused(&dquot->dq_h->qh_info.u.v2_mdqi.dqi_qtree, dp))
+		d->dqb_itime = __cpu_to_le64(1);
+}
+
+static int v2r1_is_id(void *dp, struct dquot *dquot)
+{
+	struct v2r1_disk_dqblk *d = dp;
+	struct qtree_mem_dqinfo *info =
+			&dquot->dq_h->qh_info.u.v2_mdqi.dqi_qtree;
+
+	if (qtree_entry_unused(info, dp))
+		return 0;
+	return __le32_to_cpu(d->dqb_id) == dquot->dq_id;
+}
+
+static struct qtree_fmt_operations v2r1_fmt_ops = {
+	.mem2disk_dqblk = v2r1_mem2diskdqblk,
+	.disk2mem_dqblk = v2r1_disk2memdqblk,
+	.is_id = v2r1_is_id,
+};
+
+/*
+ * Copy dqinfo from disk to memory
+ */
+static inline void v2_disk2memdqinfo(struct util_dqinfo *m,
+				     struct v2_disk_dqinfo *d)
+{
+	m->dqi_bgrace = __le32_to_cpu(d->dqi_bgrace);
+	m->dqi_igrace = __le32_to_cpu(d->dqi_igrace);
+	m->u.v2_mdqi.dqi_flags = __le32_to_cpu(d->dqi_flags) & V2_DQF_MASK;
+	m->u.v2_mdqi.dqi_qtree.dqi_blocks = __le32_to_cpu(d->dqi_blocks);
+	m->u.v2_mdqi.dqi_qtree.dqi_free_blk = __le32_to_cpu(d->dqi_free_blk);
+	m->u.v2_mdqi.dqi_qtree.dqi_free_entry =
+				__le32_to_cpu(d->dqi_free_entry);
+}
+
+/*
+ * Copy dqinfo from memory to disk
+ */
+static inline void v2_mem2diskdqinfo(struct v2_disk_dqinfo *d,
+				     struct util_dqinfo *m)
+{
+	d->dqi_bgrace = __cpu_to_le32(m->dqi_bgrace);
+	d->dqi_igrace = __cpu_to_le32(m->dqi_igrace);
+	d->dqi_flags = __cpu_to_le32(m->u.v2_mdqi.dqi_flags & V2_DQF_MASK);
+	d->dqi_blocks = __cpu_to_le32(m->u.v2_mdqi.dqi_qtree.dqi_blocks);
+	d->dqi_free_blk = __cpu_to_le32(m->u.v2_mdqi.dqi_qtree.dqi_free_blk);
+	d->dqi_free_entry =
+			__cpu_to_le32(m->u.v2_mdqi.dqi_qtree.dqi_free_entry);
+}
+
+/* Convert kernel quotablock format to utility one */
+static inline void v2_kern2utildqblk(struct util_dqblk *u,
+				     struct v2_kern_dqblk *k)
+{
+	u->dqb_ihardlimit = k->dqb_ihardlimit;
+	u->dqb_isoftlimit = k->dqb_isoftlimit;
+	u->dqb_bhardlimit = k->dqb_bhardlimit;
+	u->dqb_bsoftlimit = k->dqb_bsoftlimit;
+	u->dqb_curinodes = k->dqb_curinodes;
+	u->dqb_curspace = k->dqb_curspace;
+	u->dqb_itime = k->dqb_itime;
+	u->dqb_btime = k->dqb_btime;
+}
+
+/* Convert utility quotablock format to kernel one */
+static inline void v2_util2kerndqblk(struct v2_kern_dqblk *k,
+				     struct util_dqblk *u)
+{
+	k->dqb_ihardlimit = u->dqb_ihardlimit;
+	k->dqb_isoftlimit = u->dqb_isoftlimit;
+	k->dqb_bhardlimit = u->dqb_bhardlimit;
+	k->dqb_bsoftlimit = u->dqb_bsoftlimit;
+	k->dqb_curinodes = u->dqb_curinodes;
+	k->dqb_curspace = u->dqb_curspace;
+	k->dqb_itime = u->dqb_itime;
+	k->dqb_btime = u->dqb_btime;
+}
+
+static int v2_read_header(struct quota_handle *h, struct v2_disk_dqheader *dqh)
+{
+	if (h->e2fs_read(&h->qh_qf, 0, dqh, sizeof(struct v2_disk_dqheader)) !=
+			sizeof(struct v2_disk_dqheader))
+		return 0;
+
+	return 1;
+}
+
+/*
+ * Check whether given quota file is in our format
+ */
+static int v2_check_file(struct quota_handle *h, int type, int fmt)
+{
+	struct v2_disk_dqheader dqh;
+	int file_magics[] = INITQMAGICS;
+	int known_versions[] = INIT_V2_VERSIONS;
+	int version;
+
+	if (!v2_read_header(h, &dqh))
+		return 0;
+	if (fmt == QFMT_VFS_V0)
+		version = 0;
+	else if (fmt == QFMT_VFS_V1)
+		version = 1;
+	else
+		return 0;
+
+	if (__le32_to_cpu(dqh.dqh_magic) != file_magics[type]) {
+		if (__be32_to_cpu(dqh.dqh_magic) == file_magics[type])
+			log_fatal(3, "Your quota file is stored in wrong "
+				  "endianity.", "");
+		return 0;
+	}
+	if (__le32_to_cpu(dqh.dqh_version) > known_versions[type])
+		return 0;
+	if (version != __le32_to_cpu(dqh.dqh_version))
+		return 0;
+	return 1;
+}
+
+/*
+ * Open quotafile
+ */
+static int v2_init_io(struct quota_handle *h)
+{
+	log_err("Not Implemented.", "");
+	BUG_ON(1);
+	return 0;
+}
+
+/*
+ * Initialize new quotafile
+ */
+static int v2_new_io(struct quota_handle *h)
+{
+	int file_magics[] = INITQMAGICS;
+	struct v2_disk_dqheader ddqheader;
+	struct v2_disk_dqinfo ddqinfo;
+	int version = 1;
+
+	BUG_ON(h->qh_fmt != QFMT_VFS_V1);
+
+	/* Write basic quota header */
+	ddqheader.dqh_magic = __cpu_to_le32(file_magics[h->qh_type]);
+	ddqheader.dqh_version = __cpu_to_le32(version);
+	if (h->e2fs_write(&h->qh_qf, 0, &ddqheader, sizeof(ddqheader)) !=
+			sizeof(ddqheader))
+		return -1;
+
+	/* Write information about quotafile */
+	h->qh_info.dqi_bgrace = MAX_DQ_TIME;
+	h->qh_info.dqi_igrace = MAX_IQ_TIME;
+	h->qh_info.u.v2_mdqi.dqi_flags = 0;
+	h->qh_info.u.v2_mdqi.dqi_qtree.dqi_blocks = QT_TREEOFF + 1;
+	h->qh_info.u.v2_mdqi.dqi_qtree.dqi_free_blk = 0;
+	h->qh_info.u.v2_mdqi.dqi_qtree.dqi_free_entry = 0;
+	h->qh_info.u.v2_mdqi.dqi_qtree.dqi_entry_size =
+				sizeof(struct v2r1_disk_dqblk);
+	h->qh_info.u.v2_mdqi.dqi_qtree.dqi_ops = &v2r1_fmt_ops;
+	v2_mem2diskdqinfo(&ddqinfo, &h->qh_info);
+	if (h->e2fs_write(&h->qh_qf, V2_DQINFOOFF, &ddqinfo,
+			  sizeof(ddqinfo)) !=
+	    sizeof(ddqinfo))
+		return -1;
+
+	return 0;
+}
+
+/*
+ * Write information (grace times to file)
+ */
+static int v2_write_info(struct quota_handle *h)
+{
+	struct v2_disk_dqinfo ddqinfo;
+
+	v2_mem2diskdqinfo(&ddqinfo, &h->qh_info);
+	if (h->e2fs_write(&h->qh_qf, V2_DQINFOOFF, &ddqinfo, sizeof(ddqinfo)) !=
+			sizeof(ddqinfo))
+		return -1;
+
+	return 0;
+}
+
+/*
+ * Read dquot (either from disk or from kernel)
+ * User can use errno to detect errstr when NULL is returned
+ */
+static struct dquot *v2_read_dquot(struct quota_handle *h, qid_t id)
+{
+	return qtree_read_dquot(h, id);
+}
+
+/*
+ * Commit changes of dquot to disk - it might also mean deleting it when quota
+ * became fake one and user has no blocks.
+ * User can process use 'errno' to detect errstr.
+ */
+static int v2_commit_dquot(struct dquot *dquot, int flags)
+{
+	struct util_dqblk *b = &dquot->dq_dqb;
+
+	if (!b->dqb_curspace && !b->dqb_curinodes && !b->dqb_bsoftlimit &&
+	    !b->dqb_isoftlimit && !b->dqb_bhardlimit && !b->dqb_ihardlimit)
+		qtree_delete_dquot(dquot);
+	else
+		qtree_write_dquot(dquot);
+	return 0;
+}
+
+static int v2_scan_dquots(struct quota_handle *h,
+			  int (*process_dquot) (struct dquot *, char *))
+{
+	return qtree_scan_dquots(h, process_dquot);
+}
+
+/* Report information about quotafile.
+ * TODO: Not used right now, but we should be able to use this when we add
+ * support to debugfs to read quota files.
+ */
+static int v2_report(struct quota_handle *h, int verbose)
+{
+	log_err("Not Implemented.", "");
+	BUG_ON(1);
+	return 0;
+}
+
diff --git a/lib/quota/quotaio_v2.h b/lib/quota/quotaio_v2.h
new file mode 100644
index 0000000..072e36f
--- /dev/null
+++ b/lib/quota/quotaio_v2.h
@@ -0,0 +1,103 @@
+/*
+ *
+ *	Header file for disk format of new quotafile format
+ *
+ */
+
+#ifndef GUARD_QUOTAIO_V2_H
+#define GUARD_QUOTAIO_V2_H
+
+#include <sys/types.h>
+#include "quota.h"
+
+/* Offset of info header in file */
+#define V2_DQINFOOFF		sizeof(struct v2_disk_dqheader)
+#define INIT_V2_VERSIONS	{ 1, 1}
+
+struct v2_disk_dqheader {
+	u_int32_t dqh_magic;	/* Magic number identifying file */
+	u_int32_t dqh_version;	/* File version */
+} __attribute__ ((packed));
+
+/* Flags for version specific files */
+#define V2_DQF_MASK  0x0000	/* Mask for all valid ondisk flags */
+
+/* Header with type and version specific information */
+struct v2_disk_dqinfo {
+	u_int32_t dqi_bgrace;	/* Time before block soft limit becomes
+				 * hard limit */
+	u_int32_t dqi_igrace;	/* Time before inode soft limit becomes
+				 * hard limit */
+	u_int32_t dqi_flags;	/* Flags for quotafile (DQF_*) */
+	u_int32_t dqi_blocks;	/* Number of blocks in file */
+	u_int32_t dqi_free_blk;	/* Number of first free block in the list */
+	u_int32_t dqi_free_entry;	/* Number of block with at least one
+					 * free entry */
+} __attribute__ ((packed));
+
+/* Structure of quota for one user on disk */
+struct v2r0_disk_dqblk {
+	u_int32_t dqb_id;	/* id this quota applies to */
+	u_int32_t dqb_ihardlimit;	/* absolute limit on allocated inodes */
+	u_int32_t dqb_isoftlimit;	/* preferred inode limit */
+	u_int32_t dqb_curinodes;	/* current # allocated inodes */
+	u_int32_t dqb_bhardlimit;	/* absolute limit on disk space
+					 * (in QUOTABLOCK_SIZE) */
+	u_int32_t dqb_bsoftlimit;	/* preferred limit on disk space
+					 * (in QUOTABLOCK_SIZE) */
+	u_int64_t dqb_curspace;	/* current space occupied (in bytes) */
+	u_int64_t dqb_btime;	/* time limit for excessive disk use */
+	u_int64_t dqb_itime;	/* time limit for excessive inode use */
+} __attribute__ ((packed));
+
+struct v2r1_disk_dqblk {
+	u_int32_t dqb_id;	/* id this quota applies to */
+	u_int32_t dqb_pad;
+	u_int64_t dqb_ihardlimit;	/* absolute limit on allocated inodes */
+	u_int64_t dqb_isoftlimit;	/* preferred inode limit */
+	u_int64_t dqb_curinodes;	/* current # allocated inodes */
+	u_int64_t dqb_bhardlimit;	/* absolute limit on disk space
+					 * (in QUOTABLOCK_SIZE) */
+	u_int64_t dqb_bsoftlimit;	/* preferred limit on disk space
+					 * (in QUOTABLOCK_SIZE) */
+	u_int64_t dqb_curspace;	/* current space occupied (in bytes) */
+	u_int64_t dqb_btime;	/* time limit for excessive disk use */
+	u_int64_t dqb_itime;	/* time limit for excessive inode use */
+} __attribute__ ((packed));
+
+/* Structure of quota for communication with kernel */
+struct v2_kern_dqblk {
+	unsigned int dqb_ihardlimit;
+	unsigned int dqb_isoftlimit;
+	unsigned int dqb_curinodes;
+	unsigned int dqb_bhardlimit;
+	unsigned int dqb_bsoftlimit;
+	qsize_t dqb_curspace;
+	time_t dqb_btime;
+	time_t dqb_itime;
+};
+
+/* Structure of quotafile info for communication with kernel (obsolete) */
+struct v2_kern_dqinfo {
+	unsigned int dqi_bgrace;
+	unsigned int dqi_igrace;
+	unsigned int dqi_flags;
+	unsigned int dqi_blocks;
+	unsigned int dqi_free_blk;
+	unsigned int dqi_free_entry;
+};
+
+/* Structure with gathered statistics from kernel */
+struct v2_dqstats {
+	u_int32_t lookups;
+	u_int32_t drops;
+	u_int32_t reads;
+	u_int32_t writes;
+	u_int32_t cache_hits;
+	u_int32_t allocated_dquots;
+	u_int32_t free_dquots;
+	u_int32_t syncs;
+	u_int32_t version;
+};
+
+#endif
-- 
1.7.3.1

