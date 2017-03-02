From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/3] e2spacey: create a program to use getfsmap to profile
 free space
Date: Wed, 01 Mar 2017 20:52:27 -0800
Message-ID: <148843034776.21733.3790987196585797215.stgit@birch.djwong.org>
References: <148843032650.21733.13980225191301375698.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17022 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753792AbdCBEwe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Mar 2017 23:52:34 -0500
In-Reply-To: <148843032650.21733.13980225191301375698.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

e2spacey is a new tool that uses the GETFSMAP ioctl and the FSGEOMETRY
ioctl to find all the free extents in a mounted filesystem and display
either per-flexbg free block counts or a histogram of free extents.
At this point it's mostly useful as a debugging tool.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Makefile.in          |    3 
 configure            |    6 +
 configure.ac         |    5 -
 lib/ext2fs/ext2_fs.h |    8 +
 spacey/Makefile.in   |  152 +++++++++++++++++
 spacey/e2spacey.8.in |   65 +++++++
 spacey/fsmap.h       |   89 ++++++++++
 spacey/main.c        |  456 ++++++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 781 insertions(+), 3 deletions(-)
 create mode 100644 spacey/Makefile.in
 create mode 100644 spacey/e2spacey.8.in
 create mode 100644 spacey/fsmap.h
 create mode 100644 spacey/main.c


diff --git a/Makefile.in b/Makefile.in
index 7da9ad7..b48d0f9 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -13,10 +13,11 @@ INSTALL = @INSTALL@
 @DEBUGFS_CMT@DEBUGFS_DIR= debugfs
 @UUID_CMT@UUID_LIB_SUBDIR= lib/uuid
 @BLKID_CMT@BLKID_LIB_SUBDIR= lib/blkid
+@SPACEY_CMT@SPACEY_DIR= spacey
 SUPPORT_LIB_SUBDIR= lib/support
 
 LIB_SUBDIRS=lib/et lib/ss lib/e2p $(UUID_LIB_SUBDIR) $(BLKID_LIB_SUBDIR) $(SUPPORT_LIB_SUBDIR) lib/ext2fs intl
-PROG_SUBDIRS=e2fsck $(DEBUGFS_DIR) misc $(RESIZE_DIR) tests/progs po
+PROG_SUBDIRS=e2fsck $(DEBUGFS_DIR) misc $(RESIZE_DIR) tests/progs po $(SPACEY_DIR)
 SUBDIRS=util $(LIB_SUBDIRS) $(PROG_SUBDIRS) tests
 
 SUBS= util/subst.conf lib/config.h $(top_builddir)/lib/dirpaths.h \
diff --git a/configure b/configure
index b553da1..940b11c 100755
--- a/configure
+++ b/configure
@@ -642,6 +642,7 @@ root_prefix
 UNIX_CMT
 CYGWIN_CMT
 LINUX_CMT
+SPACEY_CMT
 E2INFO_CMT
 UNI_DIFF_OPTS
 SEM_INIT_LIB
@@ -13665,15 +13666,18 @@ fi
 $as_echo "$UNI_DIFF_OPTS" >&6; }
 
 E2INFO_CMT="#"
+SPACEY_CMT="#"
 case "$host_os" in
 linux*)
 
 $as_echo "#define HAVE_EXT2_IOCTLS 1" >>confdefs.h
 
 	E2INFO_CMT=
+	SPACEY_CMT=
 	;;
 esac
 
+
 LINUX_CMT="#"
 CYGWIN_CMT="#"
 UNIX_CMT=
@@ -13875,7 +13879,7 @@ for i in MCONFIG Makefile e2fsprogs.spec \
 	misc/Makefile ext2ed/Makefile e2fsck/Makefile \
 	debugfs/Makefile tests/Makefile tests/progs/Makefile \
 	resize/Makefile doc/Makefile intl/Makefile \
-	intl/libgnuintl.h po/Makefile.in ; do
+	intl/libgnuintl.h po/Makefile.in spacey/Makefile ; do
 	if test -d `dirname ${srcdir}/$i` ; then
 		outlist="$outlist $i"
 	fi
diff --git a/configure.ac b/configure.ac
index bf613fd..5b95f6b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1261,13 +1261,16 @@ dnl
 dnl We use the EXT2 ioctls only under Linux
 dnl
 E2INFO_CMT="#"
+SPACEY_CMT="#"
 case "$host_os" in
 linux*)
 	AC_DEFINE(HAVE_EXT2_IOCTLS, 1, [Define to 1 if Ext2 ioctls present])
 	E2INFO_CMT=
+	SPACEY_CMT=
 	;;
 esac
 AC_SUBST(E2INFO_CMT)
+AC_SUBST(SPACEY_CMT)
 dnl
 dnl OS-specific uncomment control
 dnl
@@ -1469,7 +1472,7 @@ for i in MCONFIG Makefile e2fsprogs.spec \
 	misc/Makefile ext2ed/Makefile e2fsck/Makefile \
 	debugfs/Makefile tests/Makefile tests/progs/Makefile \
 	resize/Makefile doc/Makefile intl/Makefile \
-	intl/libgnuintl.h po/Makefile.in ; do
+	intl/libgnuintl.h po/Makefile.in spacey/Makefile ; do
 	if test -d `dirname ${srcdir}/$i` ; then
 		outlist="$outlist $i"
 	fi
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index bad7648..4beebb6 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -406,6 +406,14 @@ struct ext4_fsop_geom {
 
 #define EXT4_IOC_FSGEOMETRY		_IOR ('f', 19, struct ext4_fsop_geom)
 
+/* Custom FS_IOC_GETFSMAP owner codes */
+#define EXT4_FMR_OWN_FREE	FMR_OWN_FREE      /* free space */
+#define EXT4_FMR_OWN_UNKNOWN	FMR_OWN_UNKNOWN   /* unknown owner */
+#define EXT4_FMR_OWN_GDT	FMR_OWNER('f', 1) /* group descriptors */
+#define EXT4_FMR_OWN_RESV_GDT	FMR_OWNER('f', 2) /* reserved gdt blocks */
+#define EXT4_FMR_OWN_BLKBM	FMR_OWNER('f', 3) /* inode bitmap */
+#define EXT4_FMR_OWN_INOBM	FMR_OWNER('f', 4) /* block bitmap */
+
 /*
  * Structure of an inode on the disk
  */
diff --git a/spacey/Makefile.in b/spacey/Makefile.in
new file mode 100644
index 0000000..3c842f3
--- /dev/null
+++ b/spacey/Makefile.in
@@ -0,0 +1,152 @@
+#
+# Makefile for e2spacey
+#
+
+srcdir = @srcdir@
+top_srcdir = @top_srcdir@
+VPATH = @srcdir@
+top_builddir = ..
+my_dir = scrub
+INSTALL = @INSTALL@
+
+@MCONFIG@
+
+PROGS=		e2spacey
+MANPAGES=	e2spacey.8
+
+LIBS= $(LIBSUPPORT) $(LIBEXT2FS) $(LIBCOM_ERR) $(LIBBLKID) $(LIBUUID) \
+	$(LIBINTL) $(LIBE2P) $(LIBMAGIC) $(SYSLIBS)
+DEPLIBS= $(DEPLIBSUPPORT) $(LIBEXT2FS) $(DEPLIBCOM_ERR) $(DEPLIBBLKID) \
+	 $(DEPLIBUUID) $(DEPLIBE2P)
+
+STATIC_LIBS= $(STATIC_LIBSUPPORT) $(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR) \
+	     $(STATIC_LIBBLKID) $(STATIC_LIBUUID) $(LIBINTL) $(STATIC_LIBE2P) \
+	     $(LIBMAGIC) $(SYSLIBS)
+STATIC_DEPLIBS= $(DEPSTATIC_LIBSUPPORT) $(STATIC_LIBEXT2FS) \
+		$(DEPSTATIC_LIBCOM_ERR) $(DEPSTATIC_LIBBLKID) \
+		$(DEPSTATIC_LIBUUID) $(DEPSTATIC_LIBE2P)
+
+PROFILED_LIBS= $(PROFILED_LIBSUPPORT) $(PROFILED_LIBEXT2FS) \
+	       $(PROFILED_LIBCOM_ERR) $(PROFILED_LIBBLKID) $(PROFILED_LIBUUID) \
+	       $(PROFILED_LIBE2P) $(LIBINTL) $(LIBMAGIC) $(SYSLIBS)
+PROFILED_DEPLIBS= $(DEPPROFILED_LIBSUPPORT) $(PROFILED_LIBEXT2FS) \
+		  $(DEPPROFILED_LIBCOM_ERR) $(DEPPROFILED_LIBBLKID) \
+		  $(DEPPROFILED_LIBUUID) $(DEPPROFILED_LIBE2P)
+
+COMPILE_ET=	_ET_DIR_OVERRIDE=$(srcdir)/../lib/et/et ../lib/et/compile_et
+
+.c.o:
+	$(E) "	CC $<"
+	$(Q) $(CC) -c $(ALL_CFLAGS) $< -o $@
+	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
+	$(Q) $(CPPCHECK_CMD) $(CPPFLAGS) $<
+@PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
+
+#
+# Flags for doing mtrace --- uncomment to produce mtracing e2spacey
+# 	Note:  The optimization flags must include -g
+#
+#MTRACE=	-DMTRACE
+#MTRACE_OBJ= mtrace.o
+#MTRACE_SRC= $(srcdir)/mtrace.c
+#OPT= -g
+
+#
+# Flags for doing mcheck --- uncomment to produce mchecking e2spacey
+# 	Note:  The optimization flags must include -g
+#
+#MCHECK= -DMCHECK
+
+OBJS= main.o
+
+PROFILED_OBJS= profiled/main.o
+
+SRCS= $(srcdir)/main.o
+
+all:: profiled $(PROGS) $(MANPAGES)
+
+@PROFILE_CMT@all:: e2spacey.profiled
+
+e2spacey: $(OBJS)  $(DEPLIBS)
+	$(E) "	LD $@"
+	$(Q) $(LD) $(ALL_LDFLAGS) $(RDYNAMIC) -o e2spacey $(OBJS) $(LIBS)
+
+e2spacey.static: $(OBJS) $(STATIC_DEPLIBS)
+	$(E) "	LD $@"
+	$(Q) $(LD) $(LDFLAGS_STATIC) -o e2spacey.static $(OBJS) $(STATIC_LIBS) -lpthread
+
+e2spacey.profiled: $(OBJS)  $(PROFILED_DEPLIBS)
+	$(E) "	LD $@"
+	$(Q) $(LD) $(ALL_LDFLAGS) -g -pg -o e2spacey.profiled $(PROFILED_OBJS) \
+		$(PROFILED_LIBS) -lpthread
+
+test_profile: $(srcdir)/profile.c profile_helpers.o argv_parse.o \
+		prof_err.o profile.h $(DEPSTATIC_LIBCOM_ERR)
+	$(E) "	LD $@"
+	$(Q) $(CC) -o test_profile -DDEBUG_PROGRAM $(srcdir)/profile.c prof_err.o \
+		profile_helpers.o argv_parse.o $(STATIC_LIBCOM_ERR) \
+		$(ALL_CFLAGS)
+
+profiled:
+@PROFILE_CMT@	$(E) "	MKDIR $@"
+@PROFILE_CMT@	$(Q) mkdir profiled
+
+e2spacey.8: $(DEP_SUBSTITUTE) $(srcdir)/e2spacey.8.in
+	$(E) "	SUBST $@"
+	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/e2spacey.8.in e2spacey.8
+
+installdirs:
+	$(E) "	MKINSTALLDIRS $(root_sbindir) $(man8dir)"
+	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(root_sbindir) \
+		$(DESTDIR)$(man8dir) $(DESTDIR)$(man5dir)
+
+install: $(PROGS) $(MANPAGES) $(FMANPAGES) installdirs
+	$(Q) for i in $(PROGS); do \
+		$(ES) "	INSTALL $(root_sbindir)/$$i"; \
+		$(INSTALL_PROGRAM) $$i $(DESTDIR)$(root_sbindir)/$$i; \
+	done
+	$(Q) for i in $(MANPAGES); do \
+		for j in $(COMPRESS_EXT); do \
+			$(RM) -f $(DESTDIR)$(man8dir)/$$i.$$j; \
+		done; \
+		$(ES) "	INSTALL_DATA $(man8dir)/$$i"; \
+		$(INSTALL_DATA) $$i $(DESTDIR)$(man8dir)/$$i; \
+	done
+
+install-strip: install
+	$(Q) for i in $(PROGS); do \
+		$(ES) "	STRIP $(root_sbindir)/$$i"; \
+		$(STRIP) $(DESTDIR)$(root_sbindir)/$$i; \
+	done
+
+uninstall:
+	for i in $(PROGS); do \
+		$(RM) -f $(DESTDIR)$(root_sbindir)/$$i; \
+	done
+	for i in $(MANPAGES); do \
+		$(RM) -f $(DESTDIR)$(man8dir)/$$i; \
+	done
+
+clean::
+	$(RM) -f $(PROGS)
+	$(RM) -rf profiled
+
+mostlyclean: clean
+distclean: clean
+	$(RM) -f .depend Makefile $(srcdir)/TAGS $(srcdir)/Makefile.in.old
+
+# +++ Dependency line eater +++
+# 
+# Makefile dependencies follow.  This must be the last section in
+# the Makefile.in file
+#
+main.o: $(srcdir)/main.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/fsmap.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(top_srcdir)/lib/support/profile.h $(top_builddir)/lib/support/prof_err.h \
+ $(top_srcdir)/lib/support/quotaio.h $(top_srcdir)/lib/support/dqblk_v2.h \
+ $(top_srcdir)/lib/support/quotaio_tree.h
diff --git a/spacey/e2spacey.8.in b/spacey/e2spacey.8.in
new file mode 100644
index 0000000..f4956fc
--- /dev/null
+++ b/spacey/e2spacey.8.in
@@ -0,0 +1,65 @@
+.TH E2SPACEY 8 "@E2FSPROGS_MONTH@ @E2FSPROGS_YEAR@" "E2fsprogs version @E2FSPROGS_VERSION@"
+.SH NAME
+e2spacey \- show free space information about an ext4 filesystem
+.SH SYNOPSIS
+.B e2spacey
+[
+.B \-srg
+]
+[
+.B \-b
+|
+.B \-e
+.I bsize
+|
+.B \-h
+.I h1
+[
+.B \-m
+.I bmult
+]
+]
+[
+.B \-a
+.I group
+]
+.I mountpoint
+.br
+.B e2spacey \-V
+.SH DESCRIPTION
+.B e2spacey
+reports and controls free space usage in an ext4 filesystem.
+When the
+.B flex_bg
+feature is enabled, the free space information is grouped by flex block groups
+instead of regular block groups.
+This enables reporting of free space extents that span multiple block groups.
+
+.SH OPTIONS
+.TP 1.0i
+.BI \-a " group"
+Only query the specified block group's free space information.
+Multiple options may be provided.
+.TP
+.B \-b
+Establish histogram bins sized in successive powers of two.
+.TP
+.B \-e
+Fix the histogram bin size to a specific value.
+.TP
+.B \-g
+Instead of printing a histogram, simply report the number of free extents
+and number of free blocks per block group.
+.TP
+.BI \-h " hist"
+Fix the histogram bin size to a specific initial value.
+Use this in comination with the
+.B \-m
+option to specify a custom histgram bin size growth function.
+.TP
+.BI \-m " mult"
+The size of each histogram bin should be computed by multiplying the
+previous bin's size by this quantity.
+.TP
+.B \-s
+Print a summary of the free space before exiting.
diff --git a/spacey/fsmap.h b/spacey/fsmap.h
new file mode 100644
index 0000000..3c5084c
--- /dev/null
+++ b/spacey/fsmap.h
@@ -0,0 +1,89 @@
+/*
+ * Copyright (c) 2017 Oracle.
+ * All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef FSMAP_H_
+#define FSMAP_H_
+
+/* FS_IOC_GETFSMAP ioctl definitions */
+#ifndef FS_IOC_GETFSMAP
+struct fsmap {
+	__u32		fmr_device;	/* device id */
+	__u32		fmr_flags;	/* mapping flags */
+	__u64		fmr_physical;	/* device offset of segment */
+	__u64		fmr_owner;	/* owner id */
+	__u64		fmr_offset;	/* file offset of segment */
+	__u64		fmr_length;	/* length of segment */
+	__u64		fmr_reserved[3];	/* must be zero */
+};
+
+struct fsmap_head {
+	__u32		fmh_iflags;	/* control flags */
+	__u32		fmh_oflags;	/* output flags */
+	__u32		fmh_count;	/* # of entries in array incl. input */
+	__u32		fmh_entries;	/* # of entries filled in (output). */
+	__u64		fmh_reserved[6];	/* must be zero */
+
+	struct fsmap	fmh_keys[2];	/* low and high keys for the mapping search */
+	struct fsmap	fmh_recs[];	/* returned records */
+};
+
+/* Size of an fsmap_head with room for nr records. */
+static inline size_t
+fsmap_sizeof(
+	unsigned int	nr)
+{
+	return sizeof(struct fsmap_head) + nr * sizeof(struct fsmap);
+}
+
+/* Start the next fsmap query at the end of the current query results. */
+static inline void
+fsmap_advance(
+	struct fsmap_head	*head)
+{
+	head->fmh_keys[0] = head->fmh_recs[head->fmh_entries - 1];
+}
+
+/*	fmh_iflags values - set by FS_IOC_GETFSMAP caller in the header. */
+/* no flags defined yet */
+#define FMH_IF_VALID		0
+
+/*	fmh_oflags values - returned in the header segment only. */
+#define FMH_OF_DEV_T		0x1	/* fmr_device values will be dev_t */
+
+/*	fmr_flags values - returned for each non-header segment */
+#define FMR_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
+#define FMR_OF_ATTR_FORK	0x2	/* segment = attribute fork */
+#define FMR_OF_EXTENT_MAP	0x4	/* segment = extent map */
+#define FMR_OF_SHARED		0x8	/* segment = shared with another file */
+#define FMR_OF_SPECIAL_OWNER	0x10	/* owner is a special value */
+#define FMR_OF_LAST		0x20	/* segment is the last in the FS */
+
+/* Each FS gets to define its own special owner codes. */
+#define FMR_OWNER(type, code)	(((__u64)type << 32) | \
+				 ((__u64)code & 0xFFFFFFFFULL))
+#define FMR_OWNER_TYPE(owner)	((__u32)((__u64)owner >> 32))
+#define FMR_OWNER_CODE(owner)	((__u32)(((__u64)owner & 0xFFFFFFFFULL)))
+#define FMR_OWN_FREE		FMR_OWNER(0, 1) /* free space */
+#define FMR_OWN_UNKNOWN		FMR_OWNER(0, 2) /* unknown owner */
+#define FMR_OWN_METADATA	FMR_OWNER(0, 3) /* metadata */
+
+#define FS_IOC_GETFSMAP		_IOWR('X', 59, struct fsmap_head)
+#endif /* FS_IOC_GETFSMAP */ 
+
+#endif
diff --git a/spacey/main.c b/spacey/main.c
new file mode 100644
index 0000000..009a965
--- /dev/null
+++ b/spacey/main.c
@@ -0,0 +1,456 @@
+/*
+ * Copyright (c) 2017 Oracle.
+ * All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "config.h"
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <libgen.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <mntent.h>
+#include <limits.h>
+#include "ext2fs/ext2_types.h"
+#include "ext2fs/ext2fs.h"
+#include "fsmap.h"
+#include "ext2fs/ext2_fs.h"
+
+#include "../version.h"
+#include "support/nls-enable.h"
+
+static const char *progname = "e2spaceman";
+
+struct histent
+{
+	blk64_t		low;
+	blk64_t		high;
+	size_t		count;
+	blk64_t		blocks;
+};
+
+static struct ext4_fsop_geom fsgeo;
+static struct ext4_fsop_geom flexgeo;
+
+static struct histent *hist;
+static size_t histcount;
+
+static dgrp_t *bglist;
+static size_t bgcount;
+
+static blk64_t totblocks;
+static long long totexts;
+
+static int equalsize;
+static int multsize;
+
+static int seen1;
+static int dumpflag;
+static int gflag;
+static const char *filename;
+static dev_t datadev;
+
+static inline dgrp_t f2b(dgrp_t fgroup)
+{
+	return fsgeo.efg_flexbgsize ? fgroup * fsgeo.efg_flexbgsize : fgroup;
+}
+
+static inline dgrp_t b2f(dgrp_t group)
+{
+	return fsgeo.efg_flexbgsize ? group / fsgeo.efg_flexbgsize : group;
+}
+
+static void usage(void)
+{
+	fprintf(stderr, _(
+"Usage: %s [options] mountpoint\n\n\
+	-V          print version information\n"),
+		progname);
+	exit(2);
+}
+
+#define PROC_MOUNTS	"/proc/mounts"
+int find_datadev(const char *arg, dev_t *datadev, char *mntpoint)
+{
+	struct mntent *mnt;
+	FILE *mtp;
+	char *mtab_file;
+	char rmnt_fsname[PATH_MAX], rmnt_dir[PATH_MAX];
+	struct stat sbuf;
+	dev_t fd_dev;
+
+	if (stat(arg, &sbuf) < 0)
+		return errno;
+	/*
+	 * We want to match st_rdev if the path provided is a device
+	 * special file.  Otherwise we are looking for the the
+	 * device id for the containing filesystem, in st_dev.
+	 */
+	if (S_ISBLK(sbuf.st_mode) || S_ISCHR(sbuf.st_mode))
+		fd_dev = sbuf.st_rdev;
+	else
+		fd_dev = sbuf.st_dev;
+
+	mtab_file = PROC_MOUNTS;
+	if (access(mtab_file, R_OK) != 0)
+		mtab_file = MOUNTED;
+
+	if ((mtp = setmntent(mtab_file, "r")) == NULL)
+		return ENOENT;
+
+	while ((mnt = getmntent(mtp)) != NULL) {
+		if (!realpath(mnt->mnt_dir, rmnt_dir))
+			continue;
+		if (!realpath(mnt->mnt_fsname, rmnt_fsname))
+			continue;
+
+		if (stat(rmnt_fsname, &sbuf) < 0)
+			continue;
+		if (sbuf.st_rdev == fd_dev) {
+			*datadev = fd_dev;
+			strncpy(mntpoint, rmnt_dir, PATH_MAX);
+			break;
+		}
+	}
+	endmntent(mtp);
+	return 0;
+}
+
+static void addhistent(blk64_t h)
+{
+	hist = realloc(hist, (histcount + 1) * sizeof(*hist));
+	if (!hist) {
+		perror("addhistent");
+		exit(2);
+	}
+	if (h == 0)
+		h = 1;
+	hist[histcount].low = h;
+	hist[histcount].count = hist[histcount].blocks = 0;
+	histcount++;
+	if (h == 1)
+		seen1 = 1;
+}
+
+static void addtohist(dgrp_t group, blk64_t fsb, blk64_t len)
+{
+	size_t i;
+
+	if (dumpflag)
+		printf("%8u %8llu %8llu\n", group, fsb, len);
+	totexts++;
+	totblocks += len;
+	for (i = 0; i < histcount; i++) {
+		if (hist[i].high >= len) {
+			hist[i].count++;
+			hist[i].blocks += len;
+			break;
+		}
+	}
+}
+
+static int hcmp(const void *a, const void *b)
+{
+	return ((struct histent *)a)->low - ((struct histent *)b)->low;
+}
+
+static void histinit(blk64_t maxlen)
+{
+	blk64_t i;
+
+	if (equalsize) {
+		for (i = 1; i < maxlen; i += equalsize)
+			addhistent(i);
+	} else if (multsize) {
+		for (i = 1; i < maxlen; i *= multsize)
+			addhistent(i);
+	} else {
+		if (!seen1)
+			addhistent(1);
+		qsort(hist, histcount, sizeof(*hist), hcmp);
+	}
+	for (i = 0; i < histcount; i++) {
+		if (i < histcount - 1)
+			hist[i].high = hist[i + 1].low - 1;
+		else
+			hist[i].high = maxlen;
+	}
+}
+
+static void printhist(void)
+{
+	size_t i;
+
+	printf("%7s %7s %7s %7s %6s\n",
+		_("from"), _("to"), _("extents"), _("blocks"), _("pct"));
+	for (i = 0; i < histcount; i++) {
+		if (hist[i].count)
+			printf("%7llu %7llu %7Zu %7llu %6.2f\n", hist[i].low,
+				hist[i].high, hist[i].count, hist[i].blocks,
+				hist[i].blocks * 100.0 / totblocks);
+	}
+}
+
+static int inbglist(dgrp_t fgroup)
+{
+	size_t i;
+
+	if (bgcount == 0)
+		return 1;
+	for (i = 0; i < bgcount; i++)
+		if (b2f(bglist[i]) == fgroup)
+			return 1;
+	return 0;
+}
+
+#define NR_EXTENTS 1024
+
+static void scan_bg(int fd, dgrp_t fgroup)
+{
+	struct fsmap_head *fsmap;
+	struct fsmap *extent;
+	struct fsmap *l, *h;
+	struct fsmap *p;
+	off64_t blocksize = flexgeo.efg_blocksize;
+	off64_t bytes_per_bg;
+	off64_t len;
+	blk64_t fsb;
+	blk64_t freeblks = 0;
+	blk64_t freeexts = 0;
+	int ret;
+	int i;
+
+	bytes_per_bg = (off64_t)flexgeo.efg_bgblocks * blocksize;
+
+	fsmap = malloc(fsmap_sizeof(NR_EXTENTS));
+	if (!fsmap) {
+		fprintf(stderr, _("%s: fsmap malloc failed.\n"), progname);
+		exit(1);
+	}
+
+	memset(fsmap, 0, sizeof(*fsmap));
+	fsmap->fmh_count = NR_EXTENTS;
+	l = fsmap->fmh_keys;
+	h = fsmap->fmh_keys + 1;
+	l->fmr_physical = fgroup * bytes_per_bg;
+	h->fmr_physical = ((fgroup + 1) * bytes_per_bg) - 1;
+	l->fmr_device = h->fmr_device = datadev;
+	h->fmr_owner = ULLONG_MAX;
+	h->fmr_flags = UINT_MAX;
+	h->fmr_offset = ULLONG_MAX;
+
+	while (1) {
+		ret = ioctl(fd, FS_IOC_GETFSMAP, fsmap);
+		if (ret < 0) {
+			fprintf(stderr,
+_("%s: FS_IOC_GETFSMAP [\"%s\"]: %s\n"),
+				progname, filename, strerror(errno));
+			free(fsmap);
+			exit(1);
+		}
+
+		/* No more extents to map, exit */
+		if (!fsmap->fmh_entries)
+			break;
+
+		for (i = 0, extent = fsmap->fmh_recs;
+		     i < fsmap->fmh_entries;
+		     i++, extent++) {
+			if (!(extent->fmr_flags & FMR_OF_SPECIAL_OWNER) ||
+			    extent->fmr_owner != FMR_OWN_FREE)
+				continue;
+
+			fsb = extent->fmr_physical / blocksize;
+			len = extent->fmr_length / blocksize;
+			freeblks += len;
+			freeexts++;
+
+			addtohist(f2b(fgroup), fsb, len);
+		}
+
+		p = &fsmap->fmh_recs[fsmap->fmh_entries - 1];
+		if (p->fmr_flags & FMR_OF_LAST)
+			break;
+		fsmap_advance(fsmap);
+	}
+
+	if (gflag)
+		printf(_("%10u %10llu %10llu\n"), f2b(fgroup), freeexts,
+		       freeblks);
+}
+
+static void bglistadd(char *a)
+{
+	bglist = realloc(bglist, (bgcount + 1) * sizeof(*bglist));
+	bglist[bgcount] = (dgrp_t)atoi(a);
+	bgcount++;
+}
+
+
+static void setup_fsgeo(int fd)
+{
+	/* Get the current filesystem size & geometry */
+	if (ioctl(fd, EXT4_IOC_FSGEOMETRY, &fsgeo) < 0) {
+		fprintf(stderr, _(
+			"%s: cannot determine geometry of ext4 filesystem"
+			" mounted at %s.\n"),
+			progname, filename);
+		exit(1);
+	}
+
+	/*
+	 * Refactor the geometry so that a "group" is the size of the smallest
+	 * number of BGs required to contain the longest free extent possible.
+	 *
+	 * (IOWs, we handle everything in terms of flexbgs.)
+	 */
+	flexgeo = fsgeo;
+	if (fsgeo.efg_flexbgsize) {
+		flexgeo.efg_bgblocks *= fsgeo.efg_flexbgsize;
+		flexgeo.efg_bgcount = (fsgeo.efg_bgcount +
+				       fsgeo.efg_flexbgsize - 1) /
+				      fsgeo.efg_flexbgsize;
+		flexgeo.efg_bg_iblocks *= fsgeo.efg_flexbgsize;
+		flexgeo.efg_flexbgsize = 0;
+	}
+}
+
+int main(int argc, char **argv)
+{
+	char *progname;
+	int fd;
+	int c;
+	char mntpoint[PATH_MAX];
+	blk64_t max_extent;
+	int speced, summaryflag;
+	dgrp_t fgroup;
+
+	speced = dumpflag = summaryflag = gflag = 0;
+
+	progname = basename(argv[0]);
+#ifdef ENABLE_NLS
+	setlocale(LC_ALL, "");
+	bindtextdomain(PACKAGE, LOCALEDIR);
+	textdomain(PACKAGE);
+#endif
+
+	while ((c = getopt(argc, argv, "a:bde:gh:m:sV")) != EOF) {
+		switch (c) {
+		case 'a':
+			bglistadd(optarg);
+			break;
+		case 'b':
+			if (speced)
+				return 0;
+			multsize = 2;
+			speced = 1;
+			break;
+		case 'd':
+			dumpflag = 1;
+			break;
+		case 'e':
+			if (speced)
+				return 0;
+			equalsize = atoi(optarg);
+			speced = 1;
+			break;
+		case 'g':
+			histcount = 0;
+			gflag++;
+			break;
+		case 'h':
+			if (speced && !histcount)
+				return 0;
+			addhistent(atoi(optarg));
+			speced = 1;
+			break;
+		case 'm':
+			if (speced)
+				return 0;
+			multsize = atoi(optarg);
+			speced = 1;
+			break;
+		case 's':
+			summaryflag = 1;
+			break;
+		case 'V':
+			printf(_("%s version %s\n"), progname, VERSION);
+			exit(0);
+		case '?':
+		default:
+			usage();
+		}
+	}
+	if (argc - optind != 1)
+		usage();
+
+	filename = argv[optind];
+	fd = open(argv[optind], O_RDONLY);
+	if (fd < 0) {
+		perror(argv[optind]);
+		return 1;
+	}
+
+	if (find_datadev(argv[optind], &datadev, mntpoint)) {
+		perror("find_datadev");
+		exit(1);
+	}
+
+	close(fd);
+	fd = open(mntpoint, O_RDONLY);
+	if (fd < 0) {
+		perror(mntpoint);
+		return 1;
+	}
+
+	setup_fsgeo(fd);
+
+	/* Set up histogram */
+	max_extent = flexgeo.efg_bgblocks;
+
+	if (!speced)
+		multsize = 2;
+	histinit(max_extent);
+
+	/* Collect data and print */
+	if (gflag)
+		printf(_("        AG    extents     blocks\n"));
+	for (fgroup = 0; fgroup < flexgeo.efg_bgcount; fgroup++)  {
+		if (inbglist(fgroup))
+			scan_bg(fd, fgroup);
+	}
+	if (histcount && !gflag)
+		printhist();
+	if (summaryflag) {
+		printf(_("total free extents %lld\n"), totexts);
+		printf(_("total free blocks %lld\n"), totblocks);
+		printf(_("average free extent size %g\n"),
+			(double)totblocks / (double)totexts);
+	}
+	if (bglist)
+		free(bglist);
+	if (hist)
+		free(hist);
+	close(fd);
+
+	return 0;
+}
