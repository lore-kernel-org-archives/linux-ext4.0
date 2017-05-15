From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] e2freefrag: use GETFSMAP on mounted filesystems
Date: Mon, 15 May 2017 11:37:11 -0700
Message-ID: <20170515183711.GC4510@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45443 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932948AbdEOShU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 15 May 2017 14:37:20 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use GETFSMAP to query mounted filesystems for free space information.
This prevents us from reporting stale free space stats if there happen
to be uncheckpointed block bitmap updates sitting in the journal.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: various cleanups to isolate the ioctl code more effectively
---
 configure         |    2 -
 configure.ac      |    1 
 lib/config.h.in   |    3 +
 misc/e2freefrag.c |  121 +++++++++++++++++++++++++++++++++++++++++++++++++----
 misc/fsmap.h      |   89 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 206 insertions(+), 10 deletions(-)
 create mode 100644 misc/fsmap.h

diff --git a/configure b/configure
index 5f7b429..2d75150 100755
--- a/configure
+++ b/configure
@@ -12368,7 +12368,7 @@ fi
 done
 
 fi
-for ac_header in  	dirent.h 	errno.h 	execinfo.h 	getopt.h 	malloc.h 	mntent.h 	paths.h 	semaphore.h 	setjmp.h 	signal.h 	stdarg.h 	stdint.h 	stdlib.h 	termios.h 	termio.h 	unistd.h 	utime.h 	attr/xattr.h 	linux/falloc.h 	linux/fd.h 	linux/major.h 	linux/loop.h 	net/if_dl.h 	netinet/in.h 	sys/acl.h 	sys/disklabel.h 	sys/disk.h 	sys/file.h 	sys/ioctl.h 	sys/key.h 	sys/mkdev.h 	sys/mman.h 	sys/mount.h 	sys/prctl.h 	sys/resource.h 	sys/select.h 	sys/socket.h 	sys/sockio.h 	sys/stat.h 	sys/syscall.h 	sys/sysctl.h 	sys/sysmacros.h 	sys/time.h 	sys/types.h 	sys/un.h 	sys/wait.h
+for ac_header in  	dirent.h 	errno.h 	execinfo.h 	getopt.h 	malloc.h 	mntent.h 	paths.h 	semaphore.h 	setjmp.h 	signal.h 	stdarg.h 	stdint.h 	stdlib.h 	termios.h 	termio.h 	unistd.h 	utime.h 	attr/xattr.h 	linux/falloc.h 	linux/fd.h 	linux/fsmap.h 	linux/major.h 	linux/loop.h 	net/if_dl.h 	netinet/in.h 	sys/acl.h 	sys/disklabel.h 	sys/disk.h 	sys/file.h 	sys/ioctl.h 	sys/key.h 	sys/mkdev.h 	sys/mman.h 	sys/mount.h 	sys/prctl.h 	sys/resource.h 	sys/select.h 	sys/socket.h 	sys/sockio.h 	sys/stat.h 	sys/syscall.h 	sys/sysctl.h 	sys/sysmacros.h 	sys/time.h 	sys/types.h 	sys/un.h 	sys/wait.h
 do :
   as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
 ac_fn_c_check_header_mongrel "$LINENO" "$ac_header" "$as_ac_Header" "$ac_includes_default"
diff --git a/configure.ac b/configure.ac
index 9da7b86..a8bc15d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -918,6 +918,7 @@ AC_CHECK_HEADERS(m4_flatten([
 	attr/xattr.h
 	linux/falloc.h
 	linux/fd.h
+	linux/fsmap.h
 	linux/major.h
 	linux/loop.h
 	net/if_dl.h
diff --git a/lib/config.h.in b/lib/config.h.in
index bc006de..37d0c46 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -244,6 +244,9 @@
 /* Define to 1 if you have the <linux/fd.h> header file. */
 #undef HAVE_LINUX_FD_H
 
+/* Define to 1 if you have the <linux/fsmap.h> header file. */
+#undef HAVE_LINUX_FSMAP_H
+
 /* Define to 1 if you have the <linux/loop.h> header file. */
 #undef HAVE_LINUX_LOOP_H
 
diff --git a/misc/e2freefrag.c b/misc/e2freefrag.c
index 90acb7e..b315263 100644
--- a/misc/e2freefrag.c
+++ b/misc/e2freefrag.c
@@ -25,11 +25,25 @@
 extern char *optarg;
 extern int optind;
 #endif
+#if defined(HAVE_EXT2_IOCTLS) && !defined(DEBUGFS)
+# include <sys/ioctl.h>
+# include <sys/types.h>
+# include <sys/stat.h>
+# include <fcntl.h>
+# include <limits.h>
+#endif
 
 #include "ext2fs/ext2_fs.h"
 #include "ext2fs/ext2fs.h"
 #include "e2freefrag.h"
 
+#if defined(HAVE_EXT2_IOCTLS) && !defined(DEBUGFS)
+# ifdef HAVE_LINUX_FSMAP_H
+#  include <linux/fsmap.h>
+# endif
+# include "fsmap.h"
+#endif
+
 static void usage(const char *prog)
 {
 	fprintf(stderr, "usage: %s [-c chunksize in kb] [-h] "
@@ -143,8 +157,97 @@ static void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
 		update_chunk_stats(info, last_chunk_size);
 }
 
-static errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info,
-				FILE *f)
+#if defined(HAVE_EXT2_IOCTLS) && !defined(DEBUGFS)
+# define FSMAP_EXTENTS	1024
+static int scan_online(ext2_filsys fs, struct chunk_info *info)
+{
+	struct fsmap_head *fsmap;
+	struct fsmap *extent;
+	struct fsmap *p;
+	char mntpoint[PATH_MAX + 1];
+	errcode_t retval;
+	int mount_flags;
+	int fd;
+	int ret;
+	int i;
+
+	/* Try to open the mountpoint for a live query. */
+	retval = ext2fs_check_mount_point(fs->device_name, &mount_flags,
+					  mntpoint, PATH_MAX);
+	if (retval) {
+		com_err(fs->device_name, retval, "while checking mount status");
+		return 0;
+	}
+	if (!mount_flags & EXT2_MF_MOUNTED)
+		return 0;
+	fd = open(mntpoint, O_RDONLY);
+	if (fd < 0) {
+		com_err(mntpoint, errno, "while opening mount point");
+		return 0;
+	}
+
+	fsmap = malloc(fsmap_sizeof(FSMAP_EXTENTS));
+	if (!fsmap) {
+		com_err(fs->device_name, errno, "while allocating memory");
+		return 0;
+	}
+
+	memset(fsmap, 0, sizeof(*fsmap));
+	fsmap->fmh_count = FSMAP_EXTENTS;
+	fsmap->fmh_keys[1].fmr_device = UINT_MAX;
+	fsmap->fmh_keys[1].fmr_physical = ULLONG_MAX;
+	fsmap->fmh_keys[1].fmr_owner = ULLONG_MAX;
+	fsmap->fmh_keys[1].fmr_offset = ULLONG_MAX;
+	fsmap->fmh_keys[1].fmr_flags = UINT_MAX;
+
+	/* Fill the extent histogram with live data */
+	while (1) {
+		ret = ioctl(fd, FS_IOC_GETFSMAP, fsmap);
+		if (ret < 0) {
+			com_err(fs->device_name, errno, "while calling fsmap");
+			free(fsmap);
+			return 0;
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
+			update_chunk_stats(info,
+					   extent->fmr_length / fs->blocksize);
+		}
+
+		p = &fsmap->fmh_recs[fsmap->fmh_entries - 1];
+		if (p->fmr_flags & FMR_OF_LAST)
+			break;
+		fsmap_advance(fsmap);
+	}
+
+	return 1;
+}
+#else
+# define scan_online(fs, info)	(0)
+#endif /* HAVE_EXT2_IOCTLS */
+
+static errcode_t scan_offline(ext2_filsys fs, struct chunk_info *info)
+{
+	errcode_t retval;
+
+	retval = ext2fs_read_block_bitmap(fs);
+	if (retval)
+		return retval;
+	scan_block_bitmap(fs, info);
+	return 0;
+}
+
+static errcode_t dump_chunk_info(ext2_filsys fs, struct chunk_info *info,
+				 FILE *f)
 {
 	unsigned long total_chunks;
 	const char *unitp = "KMGTPEZY";
@@ -152,8 +255,6 @@ static errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info,
 	unsigned long start = 0, end;
 	int i, retval = 0;
 
-	scan_block_bitmap(fs, info);
-
 	fprintf(f, "Total blocks: %llu\nFree blocks: %u (%0.1f%%)\n",
 		ext2fs_blocks_count(fs->super), fs->super->s_free_blocks_count,
 		(double)fs->super->s_free_blocks_count * 100 /
@@ -228,18 +329,20 @@ static void collect_info(ext2_filsys fs, struct chunk_info *chunk_info, FILE *f)
 	fprintf(f, "Device: %s\n", fs->device_name);
 	fprintf(f, "Blocksize: %u bytes\n", fs->blocksize);
 
-	retval = ext2fs_read_block_bitmap(fs);
+	init_chunk_info(fs, chunk_info);
+	if (!scan_online(fs, chunk_info)) {
+		init_chunk_info(fs, chunk_info);
+		retval = scan_offline(fs, chunk_info);
+	}
 	if (retval) {
 		com_err(fs->device_name, retval, "while reading block bitmap");
 		close_device(fs->device_name, fs);
 		exit(1);
 	}
 
-	init_chunk_info(fs, chunk_info);
-
-	retval = get_chunk_info(fs, chunk_info, f);
+	retval = dump_chunk_info(fs, chunk_info, f);
 	if (retval) {
-		com_err(fs->device_name, retval, "while collecting chunk info");
+		com_err(fs->device_name, retval, "while dumping chunk info");
                 close_device(fs->device_name, fs);
 		exit(1);
 	}
diff --git a/misc/fsmap.h b/misc/fsmap.h
new file mode 100644
index 0000000..e9590aa
--- /dev/null
+++ b/misc/fsmap.h
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
