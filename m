From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/34] misc: move check_plausibility into a separate file
Date: Sat, 13 Sep 2014 15:12:33 -0700
Message-ID: <20140913221233.13646.56301.stgit@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24334 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaIMWMj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2014 18:12:39 -0400
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Move check_plausibility() into a separate file so that various
programs can use it without having to declare useless global variables
that the util.c functions seem to require.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/Makefile.in |   11 ++
 misc/Makefile.in       |   20 +++-
 misc/mke2fs.c          |    1 
 misc/plausible.c       |  232 ++++++++++++++++++++++++++++++++++++++++++++++++
 misc/plausible.h       |   28 ++++++
 misc/tune2fs.c         |    1 
 misc/util.c            |  197 -----------------------------------------
 misc/util.h            |   11 --
 8 files changed, 285 insertions(+), 216 deletions(-)
 create mode 100644 misc/plausible.c
 create mode 100644 misc/plausible.h


diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 45e733c..343d5d0 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -23,7 +23,7 @@ DEBUG_OBJS= debug_cmds.o extent_cmds.o tst_cmds.o debugfs.o util.o \
 	ncheck.o icheck.o ls.o lsdel.o dump.o set_fields.o logdump.o \
 	htree.o unused.o e2freefrag.o filefrag.o extent_inode.o zap.o \
 	xattrs.o quota.o tst_libext2fs.o create_inode.o journal.o \
-	revoke.o recovery.o do_journal.o
+	revoke.o recovery.o do_journal.o plausible.o
 
 DEBUG_SRCS= debug_cmds.c extent_cmds.c tst_cmds.c \
 	$(top_srcdir)/debugfs/debugfs.c \
@@ -47,7 +47,8 @@ DEBUG_SRCS= debug_cmds.c extent_cmds.c tst_cmds.c \
 	$(top_srcdir)/debugfs/journal.c \
 	$(top_srcdir)/e2fsck/revoke.c \
 	$(top_srcdir)/e2fsck/recovery.c \
-	$(top_srcdir)/debugfs/do_journal.c
+	$(top_srcdir)/debugfs/do_journal.c \
+	$(top_srcdir)/misc/plausible.c
 
 OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	$(TEST_IO_LIB_OBJS) \
@@ -412,6 +413,10 @@ recovery.o: $(top_srcdir)/e2fsck/recovery.c
 	$(E) "	CC $<"
 	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
 
+plausible.o: $(top_srcdir)/misc/plausible.c
+	$(E) "	CC $<"
+	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
+
 do_journal.o: $(top_srcdir)/debugfs/do_journal.c
 	$(E) "	CC $<"
 	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
@@ -464,7 +469,7 @@ tst_libext2fs: $(DEBUG_OBJS) \
 	$(E) "	LD $@"
 	$(Q) $(CC) -o tst_libext2fs $(ALL_LDFLAGS) -DDEBUG $(DEBUG_OBJS) \
 		$(STATIC_LIBSS) $(STATIC_LIBE2P) $(LIBQUOTA) \
-		$(STATIC_LIBEXT2FS) $(LIBBLKID) $(LIBUUID) \
+		$(STATIC_LIBEXT2FS) $(LIBBLKID) $(LIBUUID) $(LIBMAGIC) \
 		$(STATIC_LIBCOM_ERR) $(SYSLIBS) -I $(top_srcdir)/debugfs
 
 tst_inline: $(srcdir)/inline.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 925846e..e49078b 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -40,10 +40,10 @@ UMANPAGES=	chattr.1 lsattr.1 @UUID_CMT@ uuidgen.1
 
 LPROGS=		@E2INITRD_PROG@
 
-TUNE2FS_OBJS=	tune2fs.o util.o
+TUNE2FS_OBJS=	tune2fs.o util.o plausible.o
 MKLPF_OBJS=	mklost+found.o
 MKE2FS_OBJS=	mke2fs.o util.o profile.o prof_err.o default_profile.o \
-			mk_hugefiles.o create_inode.o
+			mk_hugefiles.o create_inode.o plausible.o
 CHATTR_OBJS=	chattr.o
 LSATTR_OBJS=	lsattr.o
 UUIDGEN_OBJS=	uuidgen.o
@@ -59,11 +59,12 @@ E4DEFRAG_OBJS=	e4defrag.o
 E2FREEFRAG_OBJS= e2freefrag.o
 E2FUZZ_OBJS=	e2fuzz.o
 
-PROFILED_TUNE2FS_OBJS=	profiled/tune2fs.o profiled/util.o
+PROFILED_TUNE2FS_OBJS=	profiled/tune2fs.o profiled/util.o profiled/plausible.o
 PROFILED_MKLPF_OBJS=	profiled/mklost+found.o
 PROFILED_MKE2FS_OBJS=	profiled/mke2fs.o profiled/util.o profiled/profile.o \
 			profiled/prof_err.o profiled/default_profile.o \
-			profiled/mk_hugefiles.o profiled/create_inode.o
+			profiled/mk_hugefiles.o profiled/create_inode.o \
+			profiled/plausible.o
 
 PROFILED_CHATTR_OBJS=	profiled/chattr.o
 PROFILED_LSATTR_OBJS=	profiled/lsattr.o
@@ -86,7 +87,8 @@ SRCS=	$(srcdir)/tune2fs.c $(srcdir)/mklost+found.c $(srcdir)/mke2fs.c $(srcdir)/
 		$(srcdir)/uuidgen.c $(srcdir)/blkid.c $(srcdir)/logsave.c \
 		$(srcdir)/filefrag.c $(srcdir)/base_device.c \
 		$(srcdir)/ismounted.c $(srcdir)/../e2fsck/profile.c \
-		$(srcdir)/e2undo.c $(srcdir)/e2freefrag.c $(srcdir)/create_inode.c
+		$(srcdir)/e2undo.c $(srcdir)/e2freefrag.c $(srcdir)/create_inode.c \
+		$(srcdir)/plausible.c
 
 LIBS= $(LIBEXT2FS) $(LIBCOM_ERR)
 DEPLIBS= $(LIBEXT2FS) $(DEPLIBCOM_ERR)
@@ -698,6 +700,14 @@ badblocks.o: $(srcdir)/badblocks.c $(top_builddir)/lib/config.h \
 fsck.o: $(srcdir)/fsck.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(top_srcdir)/version.h \
  $(srcdir)/nls-enable.h $(srcdir)/fsck.h
+plausible.o: $(srcdir)/plausible.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/et/com_err.h \
+ $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
+ $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(srcdir)/nls-enable.h $(srcdir)/plausible.h
 util.o: $(srcdir)/util.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/et/com_err.h \
  $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 2bc435b..3a963d7 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -52,6 +52,7 @@ extern int optind;
 #include "ext2fs/ext2fsP.h"
 #include "uuid/uuid.h"
 #include "util.h"
+#include "plausible.h"
 #include "profile.h"
 #include "prof_err.h"
 #include "../version.h"
diff --git a/misc/plausible.c b/misc/plausible.c
new file mode 100644
index 0000000..2768e4b
--- /dev/null
+++ b/misc/plausible.c
@@ -0,0 +1,232 @@
+/*
+ * plausible.c --- Figure out if a pathname is ext* or something else.
+ *
+ * Copyright 2014, Oracle, Inc.
+ *
+ * Some parts are:
+ * Copyright 1995, 1996, 1997, 1998, 1999, 2000 by Theodore Ts'o.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#define _LARGEFILE_SOURCE
+#define _LARGEFILE64_SOURCE
+
+#include "config.h"
+#include <fcntl.h>
+#include <time.h>
+#ifdef HAVE_LINUX_MAJOR_H
+#include <linux/major.h>
+#endif
+#include <sys/types.h>
+#ifdef HAVE_SYS_STAT_H
+#include <sys/stat.h>
+#endif
+#ifdef HAVE_UNISTD_H
+#include <unistd.h>
+#endif
+#include "plausible.h"
+#include "ext2fs/ext2fs.h"
+#include "nls-enable.h"
+#include "blkid/blkid.h"
+
+static void print_ext2_info(const char *device)
+
+{
+	struct ext2_super_block	*sb;
+	ext2_filsys		fs;
+	errcode_t		retval;
+	time_t			tm;
+	char			buf[80];
+
+	retval = ext2fs_open2(device, 0, EXT2_FLAG_64BITS, 0, 0,
+			      unix_io_manager, &fs);
+	if (retval)
+		return;
+	sb = fs->super;
+
+	if (sb->s_mtime) {
+		tm = sb->s_mtime;
+		if (sb->s_last_mounted[0]) {
+			memset(buf, 0, sizeof(buf));
+			strncpy(buf, sb->s_last_mounted,
+				sizeof(sb->s_last_mounted));
+			printf(_("\tlast mounted on %s on %s"), buf,
+			       ctime(&tm));
+		} else
+			printf(_("\tlast mounted on %s"), ctime(&tm));
+	} else if (sb->s_mkfs_time) {
+		tm = sb->s_mkfs_time;
+		printf(_("\tcreated on %s"), ctime(&tm));
+	} else if (sb->s_wtime) {
+		tm = sb->s_wtime;
+		printf(_("\tlast modified on %s"), ctime(&tm));
+	}
+	ext2fs_close_free(&fs);
+}
+
+/*
+ * return 1 if there is no partition table, 0 if a partition table is
+ * detected, and -1 on an error.
+ */
+static int check_partition_table(const char *device)
+{
+#ifdef HAVE_BLKID_PROBE_ENABLE_PARTITIONS
+	blkid_probe pr;
+	const char *value;
+	int ret;
+
+	pr = blkid_new_probe_from_filename(device);
+	if (!pr)
+		return -1;
+
+	ret = blkid_probe_enable_partitions(pr, 1);
+	if (ret < 0)
+		goto errout;
+
+	ret = blkid_probe_enable_superblocks(pr, 0);
+	if (ret < 0)
+		goto errout;
+
+	ret = blkid_do_fullprobe(pr);
+	if (ret < 0)
+		goto errout;
+
+	ret = blkid_probe_lookup_value(pr, "PTTYPE", &value, NULL);
+	if (ret == 0)
+		fprintf(stderr, _("Found a %s partition table in %s\n"),
+			value, device);
+	else
+		ret = 1;
+
+errout:
+	blkid_free_probe(pr);
+	return ret;
+#else
+	return -1;
+#endif
+}
+
+/*
+ * return 1 if the device looks plausible, creating the file if necessary
+ */
+int check_plausibility(const char *device, int flags, int *ret_is_dev)
+{
+	int fd, ret, is_dev = 0;
+	ext2fs_struct_stat s;
+	int fl = O_RDONLY;
+	blkid_cache cache = NULL;
+	char *fs_type = NULL;
+	char *fs_label = NULL;
+
+	fd = ext2fs_open_file(device, fl, 0666);
+	if ((fd < 0) && (errno == ENOENT) && (flags & NO_SIZE)) {
+		fprintf(stderr, _("The file %s does not exist and no "
+				  "size was specified.\n"), device);
+		exit(1);
+	}
+	if ((fd < 0) && (errno == ENOENT) && (flags & CREATE_FILE)) {
+		fl |= O_CREAT;
+		fd = ext2fs_open_file(device, fl, 0666);
+		if (fd >= 0 && (flags & VERBOSE_CREATE))
+			printf(_("Creating regular file %s\n"), device);
+	}
+	if (fd < 0) {
+		fprintf(stderr, _("Could not open %s: %s\n"),
+			device, error_message(errno));
+		if (errno == ENOENT)
+			fputs(_("\nThe device apparently does not exist; "
+				"did you specify it correctly?\n"), stderr);
+		exit(1);
+	}
+
+	if (ext2fs_fstat(fd, &s) < 0) {
+		perror("stat");
+		exit(1);
+	}
+	close(fd);
+
+	if (S_ISBLK(s.st_mode))
+		is_dev = 1;
+#if defined(__FreeBSD__) || defined(__FreeBSD_kernel__)
+	/* On FreeBSD, all disk devices are character specials */
+	if (S_ISCHR(s.st_mode))
+		is_dev = 1;
+#endif
+	if (ret_is_dev)
+		*ret_is_dev = is_dev;
+
+	if ((flags & CHECK_BLOCK_DEV) && !is_dev) {
+		printf(_("%s is not a block special device.\n"), device);
+		return 0;
+	}
+
+	/*
+	 * Note: we use the older-style blkid API's here because we
+	 * want as much functionality to be available when using the
+	 * internal blkid library, when e2fsprogs is compiled for
+	 * non-Linux systems that will probably not have the libraries
+	 * from util-linux available.  We only use the newer
+	 * blkid-probe interfaces to access functionality not
+	 * available in the original blkid library.
+	 */
+	if ((flags & CHECK_FS_EXIST) && blkid_get_cache(&cache, NULL) >= 0) {
+		fs_type = blkid_get_tag_value(cache, "TYPE", device);
+		if (fs_type)
+			fs_label = blkid_get_tag_value(cache, "LABEL", device);
+		blkid_put_cache(cache);
+	}
+
+	if (fs_type) {
+		if (fs_label)
+			printf(_("%s contains a %s file system "
+				 "labelled '%s'\n"), device, fs_type, fs_label);
+		else
+			printf(_("%s contains a %s file system\n"), device,
+			       fs_type);
+		if (strncmp(fs_type, "ext", 3) == 0)
+			print_ext2_info(device);
+		free(fs_type);
+		free(fs_label);
+		return 0;
+	}
+
+	ret = check_partition_table(device);
+	if (ret >= 0)
+		return ret;
+
+#ifdef HAVE_LINUX_MAJOR_H
+#ifndef MAJOR
+#define MAJOR(dev)	((dev)>>8)
+#define MINOR(dev)	((dev) & 0xff)
+#endif
+#ifndef SCSI_BLK_MAJOR
+#ifdef SCSI_DISK0_MAJOR
+#ifdef SCSI_DISK8_MAJOR
+#define SCSI_DISK_MAJOR(M) ((M) == SCSI_DISK0_MAJOR || \
+	((M) >= SCSI_DISK1_MAJOR && (M) <= SCSI_DISK7_MAJOR) || \
+	((M) >= SCSI_DISK8_MAJOR && (M) <= SCSI_DISK15_MAJOR))
+#else
+#define SCSI_DISK_MAJOR(M) ((M) == SCSI_DISK0_MAJOR || \
+	((M) >= SCSI_DISK1_MAJOR && (M) <= SCSI_DISK7_MAJOR))
+#endif /* defined(SCSI_DISK8_MAJOR) */
+#define SCSI_BLK_MAJOR(M) (SCSI_DISK_MAJOR((M)) || (M) == SCSI_CDROM_MAJOR)
+#else
+#define SCSI_BLK_MAJOR(M)  ((M) == SCSI_DISK_MAJOR || (M) == SCSI_CDROM_MAJOR)
+#endif /* defined(SCSI_DISK0_MAJOR) */
+#endif /* defined(SCSI_BLK_MAJOR) */
+	if (((MAJOR(s.st_rdev) == HD_MAJOR &&
+	      MINOR(s.st_rdev)%64 == 0) ||
+	     (SCSI_BLK_MAJOR(MAJOR(s.st_rdev)) &&
+	      MINOR(s.st_rdev)%16 == 0))) {
+		printf(_("%s is entire device, not just one partition!\n"),
+		       device);
+		return 0;
+	}
+#endif
+	return 1;
+}
+
diff --git a/misc/plausible.h b/misc/plausible.h
new file mode 100644
index 0000000..594e4b1
--- /dev/null
+++ b/misc/plausible.h
@@ -0,0 +1,28 @@
+/*
+ * plausible.h --- header file defining prototypes for helper functions
+ * used by tune2fs and mke2fs
+ *
+ * Copyright 2014 by Oracle, Inc.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#ifndef PLAUSIBLE_H_
+#define PLAUSIBLE_H_
+
+/*
+ * Flags for check_plausibility()
+ */
+#define CHECK_BLOCK_DEV	0x0001
+#define CREATE_FILE	0x0002
+#define CHECK_FS_EXIST	0x0004
+#define VERBOSE_CREATE	0x0008
+#define NO_SIZE		0x0010
+
+extern int check_plausibility(const char *device, int flags,
+			      int *ret_is_dev);
+
+#endif /* PLAUSIBLE_H_ */
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 510e936..c454b84 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -59,6 +59,7 @@ extern int optind;
 #include "e2p/e2p.h"
 #include "jfs_user.h"
 #include "util.h"
+#include "plausible.h"
 #include "blkid/blkid.h"
 #include "quota/quotaio.h"
 
diff --git a/misc/util.c b/misc/util.c
index 2898830..f906339 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -108,203 +108,6 @@ void proceed_question(int delay)
 	signal(SIGALRM, SIG_IGN);
 }
 
-static void print_ext2_info(const char *device)
-
-{
-	struct ext2_super_block	*sb;
-	ext2_filsys		fs;
-	errcode_t		retval;
-	time_t 			tm;
-	char			buf[80];
-
-	retval = ext2fs_open2(device, 0, EXT2_FLAG_64BITS, 0, 0,
-			      unix_io_manager, &fs);
-	if (retval)
-		return;
-	sb = fs->super;
-
-	if (sb->s_mtime) {
-		tm = sb->s_mtime;
-		if (sb->s_last_mounted[0]) {
-			memset(buf, 0, sizeof(buf));
-			strncpy(buf, sb->s_last_mounted,
-				sizeof(sb->s_last_mounted));
-			printf(_("\tlast mounted on %s on %s"), buf,
-			       ctime(&tm));
-		} else
-			printf(_("\tlast mounted on %s"), ctime(&tm));
-	} else if (sb->s_mkfs_time) {
-		tm = sb->s_mkfs_time;
-		printf(_("\tcreated on %s"), ctime(&tm));
-	} else if (sb->s_wtime) {
-		tm = sb->s_wtime;
-		printf(_("\tlast modified on %s"), ctime(&tm));
-	}
-	ext2fs_close_free(&fs);
-}
-
-/*
- * return 1 if there is no partition table, 0 if a partition table is
- * detected, and -1 on an error.
- */
-static int check_partition_table(const char *device)
-{
-#ifdef HAVE_BLKID_PROBE_ENABLE_PARTITIONS
-	blkid_probe pr;
-	const char *value;
-	int ret;
-
-	pr = blkid_new_probe_from_filename(device);
-	if (!pr)
-		return -1;
-
-        ret = blkid_probe_enable_partitions(pr, 1);
-        if (ret < 0)
-		goto errout;
-
-	ret = blkid_probe_enable_superblocks(pr, 0);
-	if (ret < 0)
-		goto errout;
-
-	ret = blkid_do_fullprobe(pr);
-	if (ret < 0)
-		goto errout;
-
-	ret = blkid_probe_lookup_value(pr, "PTTYPE", &value, NULL);
-	if (ret == 0)
-		fprintf(stderr, _("Found a %s partition table in %s\n"),
-			value, device);
-	else
-		ret = 1;
-
-errout:
-	blkid_free_probe(pr);
-	return ret;
-#else
-	return -1;
-#endif
-}
-
-/*
- * return 1 if the device looks plausible, creating the file if necessary
- */
-int check_plausibility(const char *device, int flags, int *ret_is_dev)
-{
-	int fd, ret, is_dev = 0;
-	ext2fs_struct_stat s;
-	int fl = O_RDONLY;
-	blkid_cache cache = NULL;
-	char *fs_type = NULL;
-	char *fs_label = NULL;
-
-	fd = ext2fs_open_file(device, fl, 0666);
-	if ((fd < 0) && (errno == ENOENT) && (flags & NO_SIZE)) {
-		fprintf(stderr, _("The file %s does not exist and no "
-				  "size was specified.\n"), device);
-		exit(1);
-	}
-	if ((fd < 0) && (errno == ENOENT) && (flags & CREATE_FILE)) {
-		fl |= O_CREAT;
-		fd = ext2fs_open_file(device, fl, 0666);
-		if (fd >= 0 && (flags & VERBOSE_CREATE))
-			printf(_("Creating regular file %s\n"), device);
-	}
-	if (fd < 0) {
-		fprintf(stderr, _("Could not open %s: %s\n"),
-			device, error_message(errno));
-		if (errno == ENOENT)
-			fputs(_("\nThe device apparently does not exist; "
-				"did you specify it correctly?\n"), stderr);
-		exit(1);
-	}
-
-	if (ext2fs_fstat(fd, &s) < 0) {
-		perror("stat");
-		exit(1);
-	}
-	close(fd);
-
-	if (S_ISBLK(s.st_mode))
-		is_dev = 1;
-#if defined(__FreeBSD__) || defined(__FreeBSD_kernel__)
-	/* On FreeBSD, all disk devices are character specials */
-	if (S_ISCHR(s.st_mode))
-		is_dev = 1;
-#endif
-	if (ret_is_dev)
-		*ret_is_dev = is_dev;
-
-	if ((flags & CHECK_BLOCK_DEV) && !is_dev) {
-		printf(_("%s is not a block special device.\n"), device);
-		return 0;
-	}
-
-	/*
-	 * Note: we use the older-style blkid API's here because we
-	 * want as much functionality to be available when using the
-	 * internal blkid library, when e2fsprogs is compiled for
-	 * non-Linux systems that will probably not have the libraries
-	 * from util-linux available.  We only use the newer
-	 * blkid-probe interfaces to access functionality not
-	 * available in the original blkid library.
-	 */
-	if ((flags & CHECK_FS_EXIST) && blkid_get_cache(&cache, NULL) >= 0) {
-		fs_type = blkid_get_tag_value(cache, "TYPE", device);
-		if (fs_type)
-			fs_label = blkid_get_tag_value(cache, "LABEL", device);
-		blkid_put_cache(cache);
-	}
-
-	if (fs_type) {
-		if (fs_label)
-			printf(_("%s contains a %s file system "
-				 "labelled '%s'\n"), device, fs_type, fs_label);
-		else
-			printf(_("%s contains a %s file system\n"), device,
-			       fs_type);
-		if (strncmp(fs_type, "ext", 3) == 0)
-			print_ext2_info(device);
-		free(fs_type);
-		free(fs_label);
-		return 0;
-	}
-
-	ret = check_partition_table(device);
-	if (ret >= 0)
-		return ret;
-
-#ifdef HAVE_LINUX_MAJOR_H
-#ifndef MAJOR
-#define MAJOR(dev)	((dev)>>8)
-#define MINOR(dev)	((dev) & 0xff)
-#endif
-#ifndef SCSI_BLK_MAJOR
-#ifdef SCSI_DISK0_MAJOR
-#ifdef SCSI_DISK8_MAJOR
-#define SCSI_DISK_MAJOR(M) ((M) == SCSI_DISK0_MAJOR || \
-  ((M) >= SCSI_DISK1_MAJOR && (M) <= SCSI_DISK7_MAJOR) || \
-  ((M) >= SCSI_DISK8_MAJOR && (M) <= SCSI_DISK15_MAJOR))
-#else
-#define SCSI_DISK_MAJOR(M) ((M) == SCSI_DISK0_MAJOR || \
-  ((M) >= SCSI_DISK1_MAJOR && (M) <= SCSI_DISK7_MAJOR))
-#endif /* defined(SCSI_DISK8_MAJOR) */
-#define SCSI_BLK_MAJOR(M) (SCSI_DISK_MAJOR((M)) || (M) == SCSI_CDROM_MAJOR)
-#else
-#define SCSI_BLK_MAJOR(M)  ((M) == SCSI_DISK_MAJOR || (M) == SCSI_CDROM_MAJOR)
-#endif /* defined(SCSI_DISK0_MAJOR) */
-#endif /* defined(SCSI_BLK_MAJOR) */
-	if (((MAJOR(s.st_rdev) == HD_MAJOR &&
-	      MINOR(s.st_rdev)%64 == 0) ||
-	     (SCSI_BLK_MAJOR(MAJOR(s.st_rdev)) &&
-	      MINOR(s.st_rdev)%16 == 0))) {
-		printf(_("%s is entire device, not just one partition!\n"),
-		       device);
-		return 0;
-	}
-#endif
-	return 1;
-}
-
 void check_mount(const char *device, int force, const char *type)
 {
 	errcode_t	retval;
diff --git a/misc/util.h b/misc/util.h
index f3827dd..49b4b9c 100644
--- a/misc/util.h
+++ b/misc/util.h
@@ -15,22 +15,11 @@ extern int	 journal_flags;
 extern char	*journal_device;
 extern char	*journal_location_string;
 
-/*
- * Flags for check_plausibility()
- */
-#define CHECK_BLOCK_DEV	0x0001
-#define CREATE_FILE	0x0002
-#define CHECK_FS_EXIST	0x0004
-#define VERBOSE_CREATE	0x0008
-#define NO_SIZE		0x0010
