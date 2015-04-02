From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/35] libext2fs/e2fsck: provide routines to read-ahead
 metadata
Date: Wed, 01 Apr 2015 19:34:19 -0700
Message-ID: <20150402023419.25243.1245.stgit@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48126 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbbDBCeY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2015 22:34:24 -0400
In-Reply-To: <20150402023359.25243.79782.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds to e2fsck the ability to pre-fetch metadata into the
page cache in the hopes of speeding up fsck runs.  There are two new
functions -- the first allows a caller to readahead a list of blocks,
and the second is a helper function that uses that first mechanism to
load group data (bitmaps, inode tables).

These new e2fsck routines require the addition of a dblist API to
allow us to iterate a subset of a dblist.  This will enable
incremental directory block readahead in e2fsck pass 2.

There's also a function to estimate the readahead given a FS.

v2: Add an API to create a dblist with a given number of list elements
pre-allocated.  This enables us to save ~2ms per call to
e2fsck_readahead() (assuming a 2MB RA buffer) by not having to
repeatedly call ext2_resize_mem as we add blocks to the list.

v3: Instead of creating dblists of arbitrary size, change the dblist
iterator to allow iterating a sub-range.  This eliminates a lot of
unnecessary list copying during e2fsck part2.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure           |    2 
 configure.in        |    1 
 e2fsck/Makefile.in  |    9 +-
 e2fsck/e2fsck.h     |   18 ++++
 e2fsck/readahead.c  |  252 +++++++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/util.c       |   51 ++++++++++
 lib/config.h.in     |    3 +
 lib/ext2fs/dblist.c |   21 ++++
 lib/ext2fs/ext2fs.h |   10 ++
 9 files changed, 359 insertions(+), 8 deletions(-)
 create mode 100644 e2fsck/readahead.c


diff --git a/configure b/configure
index f59d232..fdc93c0 100755
--- a/configure
+++ b/configure
@@ -12414,7 +12414,7 @@ fi
 done
 
 fi
-for ac_header in  	dirent.h 	errno.h 	execinfo.h 	getopt.h 	malloc.h 	mntent.h 	paths.h 	semaphore.h 	setjmp.h 	signal.h 	stdarg.h 	stdint.h 	stdlib.h 	termios.h 	termio.h 	unistd.h 	utime.h 	attr/xattr.h 	linux/falloc.h 	linux/fd.h 	linux/major.h 	linux/loop.h 	net/if_dl.h 	netinet/in.h 	sys/disklabel.h 	sys/disk.h 	sys/file.h 	sys/ioctl.h 	sys/mkdev.h 	sys/mman.h 	sys/mount.h 	sys/prctl.h 	sys/resource.h 	sys/select.h 	sys/socket.h 	sys/sockio.h 	sys/stat.h 	sys/syscall.h 	sys/sysmacros.h 	sys/time.h 	sys/types.h 	sys/un.h 	sys/wait.h
+for ac_header in  	dirent.h 	errno.h 	execinfo.h 	getopt.h 	malloc.h 	mntent.h 	paths.h 	semaphore.h 	setjmp.h 	signal.h 	stdarg.h 	stdint.h 	stdlib.h 	termios.h 	termio.h 	unistd.h 	utime.h 	attr/xattr.h 	linux/falloc.h 	linux/fd.h 	linux/major.h 	linux/loop.h 	net/if_dl.h 	netinet/in.h 	sys/disklabel.h 	sys/disk.h 	sys/file.h 	sys/ioctl.h 	sys/mkdev.h 	sys/mman.h 	sys/mount.h 	sys/prctl.h 	sys/resource.h 	sys/select.h 	sys/socket.h 	sys/sockio.h 	sys/stat.h 	sys/syscall.h 	sys/sysctl.h 	sys/sysmacros.h 	sys/time.h 	sys/types.h 	sys/un.h 	sys/wait.h
 do :
   as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
 ac_fn_c_check_header_mongrel "$LINENO" "$ac_header" "$as_ac_Header" "$ac_includes_default"
diff --git a/configure.in b/configure.in
index 9069234..73cfeb4 100644
--- a/configure.in
+++ b/configure.in
@@ -949,6 +949,7 @@ AC_CHECK_HEADERS(m4_flatten([
 	sys/sockio.h
 	sys/stat.h
 	sys/syscall.h
+	sys/sysctl.h
 	sys/sysmacros.h
 	sys/time.h
 	sys/types.h
diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index d0e64eb..e40e51b 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -62,7 +62,7 @@ OBJS= dict.o unix.o e2fsck.o super.o pass1.o pass1b.o pass2.o \
 	pass3.o pass4.o pass5.o journal.o badblocks.o util.o dirinfo.o \
 	dx_dirinfo.o ehandler.o problem.o message.o quota.o recovery.o \
 	region.o revoke.o ea_refcount.o rehash.o profile.o prof_err.o \
-	logfile.o sigcatcher.o $(MTRACE_OBJ) plausible.o
+	logfile.o sigcatcher.o $(MTRACE_OBJ) plausible.o readahead.o
 
 PROFILED_OBJS= profiled/dict.o profiled/unix.o profiled/e2fsck.o \
 	profiled/super.o profiled/pass1.o profiled/pass1b.o \
@@ -73,7 +73,8 @@ PROFILED_OBJS= profiled/dict.o profiled/unix.o profiled/e2fsck.o \
 	profiled/recovery.o profiled/region.o profiled/revoke.o \
 	profiled/ea_refcount.o profiled/rehash.o profiled/profile.o \
 	profiled/prof_err.o profiled/logfile.o \
-	profiled/sigcatcher.o profiled/plausible.o
+	profiled/sigcatcher.o profiled/plausible.o \
+	profiled/sigcatcher.o profiled/readahead.o
 
 SRCS= $(srcdir)/e2fsck.c \
 	$(srcdir)/dict.c \
@@ -97,6 +98,7 @@ SRCS= $(srcdir)/e2fsck.c \
 	$(srcdir)/message.c \
 	$(srcdir)/ea_refcount.c \
 	$(srcdir)/rehash.c \
+	$(srcdir)/readahead.c \
 	$(srcdir)/region.c \
 	$(srcdir)/profile.c \
 	$(srcdir)/sigcatcher.c \
@@ -541,3 +543,6 @@ plausible.o: $(srcdir)/../misc/plausible.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/../misc/nls-enable.h $(srcdir)/../misc/plausible.h
+readahead.o: $(srcdir)/readahead.c $(top_builddir)/lib/config.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/e2fsck.h prof_err.h
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index e0a9239..b8795a8 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -495,6 +495,23 @@ extern ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix);
 extern errcode_t e2fsck_adjust_inode_count(e2fsck_t ctx, ext2_ino_t ino,
 					   int adj);
 
+/* readahead.c */
+#define E2FSCK_READA_SUPER	(0x01)
+#define E2FSCK_READA_GDT	(0x02)
+#define E2FSCK_READA_BBITMAP	(0x04)
+#define E2FSCK_READA_IBITMAP	(0x08)
+#define E2FSCK_READA_ITABLE	(0x10)
+#define E2FSCK_READA_ALL_FLAGS	(0x1F)
+errcode_t e2fsck_readahead(ext2_filsys fs, int flags, dgrp_t start,
+			   dgrp_t ngroups);
+#define E2FSCK_RA_DBLIST_IGNORE_BLOCKCNT	(0x01)
+#define E2FSCK_RA_DBLIST_ALL_FLAGS		(0x01)
+errcode_t e2fsck_readahead_dblist(ext2_filsys fs, int flags,
+				  ext2_dblist dblist,
+				  unsigned long long start,
+				  unsigned long long count);
+int e2fsck_can_readahead(ext2_filsys fs);
+unsigned long long e2fsck_guess_readahead(ext2_filsys fs);
 
 /* region.c */
 extern region_t region_create(region_addr_t min, region_addr_t max);
@@ -582,6 +599,7 @@ extern errcode_t e2fsck_allocate_subcluster_bitmap(ext2_filsys fs,
 						   int default_type,
 						   const char *profile_name,
 						   ext2fs_block_bitmap *ret);
+unsigned long long get_memory_size(void);
 
 /* unix.c */
 extern void e2fsck_clear_progbar(e2fsck_t ctx);
diff --git a/e2fsck/readahead.c b/e2fsck/readahead.c
new file mode 100644
index 0000000..8190d1f
--- /dev/null
+++ b/e2fsck/readahead.c
@@ -0,0 +1,252 @@
+/*
+ * readahead.c -- Prefetch filesystem metadata to speed up fsck.
+ *
+ * Copyright (C) 2014 Oracle.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Library
+ * General Public License, version 2.
+ * %End-Header%
+ */
+
+#include "config.h"
+#include <string.h>
+
+#include "e2fsck.h"
+
+#undef DEBUG
+
+#ifdef DEBUG
+# define dbg_printf(f, a...)  do {printf(f, ## a); fflush(stdout); } while (0)
+#else
+# define dbg_printf(f, a...)
+#endif
+
+struct read_dblist {
+	errcode_t err;
+	blk64_t run_start;
+	blk64_t run_len;
+	int flags;
+};
+
+static int readahead_dir_block(ext2_filsys fs, struct ext2_db_entry2 *db,
+			       void *priv_data)
+{
+	struct read_dblist *pr = priv_data;
+	e2_blkcnt_t count = (pr->flags & E2FSCK_RA_DBLIST_IGNORE_BLOCKCNT ?
+			     1 : db->blockcnt);
+
+	if (!pr->run_len || db->blk != pr->run_start + pr->run_len) {
+		if (pr->run_len) {
+			pr->err = io_channel_cache_readahead(fs->io,
+							     pr->run_start,
+							     pr->run_len);
+			dbg_printf("readahead start=%llu len=%llu err=%d\n",
+				   pr->run_start, pr->run_len,
+				   (int)pr->err);
+		}
+		pr->run_start = db->blk;
+		pr->run_len = 0;
+	}
+	pr->run_len += count;
+
+	return pr->err ? DBLIST_ABORT : 0;
+}
+
+errcode_t e2fsck_readahead_dblist(ext2_filsys fs, int flags,
+				  ext2_dblist dblist,
+				  unsigned long long start,
+				  unsigned long long count)
+{
+	errcode_t err;
+	struct read_dblist pr;
+
+	dbg_printf("%s: flags=0x%x\n", __func__, flags);
+	if (flags & ~E2FSCK_RA_DBLIST_ALL_FLAGS)
+		return EXT2_ET_INVALID_ARGUMENT;
+
+	memset(&pr, 0, sizeof(pr));
+	pr.flags = flags;
+	err = ext2fs_dblist_iterate3(dblist, readahead_dir_block, start,
+				     count, &pr);
+	if (pr.err)
+		return pr.err;
+	if (err)
+		return err;
+
+	if (pr.run_len)
+		err = io_channel_cache_readahead(fs->io, pr.run_start,
+						 pr.run_len);
+
+	return err;
+}
+
+static errcode_t e2fsck_readahead_bitmap(ext2_filsys fs,
+					 ext2fs_block_bitmap ra_map)
+{
+	blk64_t start, end, out;
+	errcode_t err;
+
+	start = 1;
+	end = ext2fs_blocks_count(fs->super) - 1;
+
+	err = ext2fs_find_first_set_block_bitmap2(ra_map, start, end, &out);
+	while (err == 0) {
+		start = out;
+		err = ext2fs_find_first_zero_block_bitmap2(ra_map, start, end,
+							   &out);
+		if (err == ENOENT) {
+			out = end;
+			err = 0;
+		} else if (err)
+			break;
+
+		err = io_channel_cache_readahead(fs->io, start, out - start);
+		if (err)
+			break;
+		start = out;
+		err = ext2fs_find_first_set_block_bitmap2(ra_map, start, end,
+							  &out);
+	}
+
+	if (err == ENOENT)
+		err = 0;
+
+	return err;
+}
+
+/* Try not to spew bitmap range errors for readahead */
+static errcode_t mark_bmap_range(ext2_filsys fs, ext2fs_block_bitmap map,
+				 blk64_t blk, unsigned int num)
+{
+	if (blk >= ext2fs_get_generic_bmap_start(map) &&
+	    blk + num <= ext2fs_get_generic_bmap_end(map))
+		ext2fs_mark_block_bitmap_range2(map, blk, num);
+	else
+		return EXT2_ET_INVALID_ARGUMENT;
+	return 0;
+}
+
+static errcode_t mark_bmap(ext2_filsys fs, ext2fs_block_bitmap map, blk64_t blk)
+{
+	if (blk >= ext2fs_get_generic_bmap_start(map) &&
+	    blk <= ext2fs_get_generic_bmap_end(map))
+		ext2fs_mark_block_bitmap2(map, blk);
+	else
+		return EXT2_ET_INVALID_ARGUMENT;
+	return 0;
+}
+
+errcode_t e2fsck_readahead(ext2_filsys fs, int flags, dgrp_t start,
+			   dgrp_t ngroups)
+{
+	blk64_t		super, old_gdt, new_gdt;
+	blk_t		blocks;
+	dgrp_t		i;
+	ext2fs_block_bitmap		ra_map = NULL;
+	dgrp_t		end = start + ngroups;
+	errcode_t	err = 0;
+
+	dbg_printf("%s: flags=0x%x start=%d groups=%d\n", __func__, flags,
+		   start, ngroups);
+	if (flags & ~E2FSCK_READA_ALL_FLAGS)
+		return EXT2_ET_INVALID_ARGUMENT;
+
+	if (end > fs->group_desc_count)
+		end = fs->group_desc_count;
+
+	if (flags == 0)
+		return 0;
+
+	err = ext2fs_allocate_block_bitmap(fs, "readahead bitmap",
+					   &ra_map);
+	if (err)
+		return err;
+
+	for (i = start; i < end; i++) {
+		err = ext2fs_super_and_bgd_loc2(fs, i, &super, &old_gdt,
+						&new_gdt, &blocks);
+		if (err)
+			break;
+
+		if (flags & E2FSCK_READA_SUPER) {
+			err = mark_bmap(fs, ra_map, super);
+			if (err)
+				break;
+		}
+
+		if (flags & E2FSCK_READA_GDT) {
+			err = mark_bmap_range(fs, ra_map,
+					      old_gdt ? old_gdt : new_gdt,
+					      blocks);
+			if (err)
+				break;
+		}
+
+		if ((flags & E2FSCK_READA_BBITMAP) &&
+		    !ext2fs_bg_flags_test(fs, i, EXT2_BG_BLOCK_UNINIT) &&
+		    ext2fs_bg_free_blocks_count(fs, i) <
+				fs->super->s_blocks_per_group) {
+			super = ext2fs_block_bitmap_loc(fs, i);
+			err = mark_bmap(fs, ra_map, super);
+			if (err)
+				break;
+		}
+
+		if ((flags & E2FSCK_READA_IBITMAP) &&
+		    !ext2fs_bg_flags_test(fs, i, EXT2_BG_INODE_UNINIT) &&
+		    ext2fs_bg_free_inodes_count(fs, i) <
+				fs->super->s_inodes_per_group) {
+			super = ext2fs_inode_bitmap_loc(fs, i);
+			err = mark_bmap(fs, ra_map, super);
+			if (err)
+				break;
+		}
+
+		if ((flags & E2FSCK_READA_ITABLE) &&
+		    ext2fs_bg_free_inodes_count(fs, i) <
+				fs->super->s_inodes_per_group) {
+			super = ext2fs_inode_table_loc(fs, i);
+			blocks = fs->inode_blocks_per_group -
+				 (ext2fs_bg_itable_unused(fs, i) *
+				  EXT2_INODE_SIZE(fs->super) / fs->blocksize);
+			err = mark_bmap_range(fs, ra_map, super, blocks);
+			if (err)
+				break;
+		}
+	}
+
+	if (!err)
+		err = e2fsck_readahead_bitmap(fs, ra_map);
+
+	ext2fs_free_block_bitmap(ra_map);
+	return err;
+}
+
+int e2fsck_can_readahead(ext2_filsys fs)
+{
+	errcode_t err;
+
+	err = io_channel_cache_readahead(fs->io, 0, 1);
+	dbg_printf("%s: supp=%d\n", __func__, err != EXT2_ET_OP_NOT_SUPPORTED);
+	return err != EXT2_ET_OP_NOT_SUPPORTED;
+}
+
+unsigned long long e2fsck_guess_readahead(ext2_filsys fs)
+{
+	unsigned long long guess;
+
+	/*
+	 * The optimal readahead sizes were experimentally determined by
+	 * djwong in August 2014.  Setting the RA size to two block groups'
+	 * worth of inode table blocks seems to yield the largest reductions
+	 * in e2fsck runtime.
+	 */
+	guess = 2 * fs->blocksize * fs->inode_blocks_per_group;
+
+	/* Disable RA if it'd use more 1/50th of RAM. */
+	if (get_memory_size() > (guess * 50))
+		return guess / 1024;
+
+	return 0;
+}
diff --git a/e2fsck/util.c b/e2fsck/util.c
index e2fb982..9e217e6 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -37,6 +37,10 @@
 #include <errno.h>
 #endif
 
+#ifdef HAVE_SYS_SYSCTL_H
+#include <sys/sysctl.h>
+#endif
+
 #include "e2fsck.h"
 
 extern e2fsck_t e2fsck_global_ctx;   /* Try your very best not to use this! */
@@ -819,3 +823,50 @@ errcode_t e2fsck_allocate_subcluster_bitmap(ext2_filsys fs, const char *descr,
 	fs->default_bitmap_type = save_type;
 	return retval;
 }
+
+/* Return memory size in bytes */
+unsigned long long get_memory_size(void)
+{
+#if defined(_SC_PHYS_PAGES)
+# if defined(_SC_PAGESIZE)
+	return (unsigned long long)sysconf(_SC_PHYS_PAGES) *
+	       (unsigned long long)sysconf(_SC_PAGESIZE);
+# elif defined(_SC_PAGE_SIZE)
+	return (unsigned long long)sysconf(_SC_PHYS_PAGES) *
+	       (unsigned long long)sysconf(_SC_PAGE_SIZE);
+# endif
+#elif defined(CTL_HW)
+# if (defined(HW_MEMSIZE) || defined(HW_PHYSMEM64))
+#  define CTL_HW_INT64
+# elif (defined(HW_PHYSMEM) || defined(HW_REALMEM))
+#  define CTL_HW_UINT
+# endif
+	int mib[2];
+
+	mib[0] = CTL_HW;
+# if defined(HW_MEMSIZE)
+	mib[1] = HW_MEMSIZE;
+# elif defined(HW_PHYSMEM64)
+	mib[1] = HW_PHYSMEM64;
+# elif defined(HW_REALMEM)
+	mib[1] = HW_REALMEM;
+# elif defined(HW_PYSMEM)
+	mib[1] = HW_PHYSMEM;
+# endif
+# if defined(CTL_HW_INT64)
+	unsigned long long size = 0;
+# elif defined(CTL_HW_UINT)
+	unsigned int size = 0;
+# endif
+# if defined(CTL_HW_INT64) || defined(CTL_HW_UINT)
+	size_t len = sizeof(size);
+
+	if (sysctl(mib, 2, &size, &len, NULL, 0) == 0)
+		return (unsigned long long)size;
+# endif
+	return 0;
+#else
+# warning "Don't know how to detect memory on your platform?"
+	return 0;
+#endif
+}
diff --git a/lib/config.h.in b/lib/config.h.in
index 0db010f..cd7ec90 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -509,6 +509,9 @@
 /* Define to 1 if you have the <sys/syscall.h> header file. */
 #undef HAVE_SYS_SYSCALL_H
 
+/* Define to 1 if you have the <sys/sysctl.h> header file. */
+#undef HAVE_SYS_SYSCTL_H
+
 /* Define to 1 if you have the <sys/sysmacros.h> header file. */
 #undef HAVE_SYS_SYSMACROS_H
 
diff --git a/lib/ext2fs/dblist.c b/lib/ext2fs/dblist.c
index 942c4f0..bbdb221 100644
--- a/lib/ext2fs/dblist.c
+++ b/lib/ext2fs/dblist.c
@@ -194,20 +194,25 @@ void ext2fs_dblist_sort2(ext2_dblist dblist,
 /*
  * This function iterates over the directory block list
  */
-errcode_t ext2fs_dblist_iterate2(ext2_dblist dblist,
+errcode_t ext2fs_dblist_iterate3(ext2_dblist dblist,
 				 int (*func)(ext2_filsys fs,
 					     struct ext2_db_entry2 *db_info,
 					     void	*priv_data),
+				 unsigned long long start,
+				 unsigned long long count,
 				 void *priv_data)
 {
-	unsigned long long	i;
+	unsigned long long	i, end;
 	int		ret;
 
 	EXT2_CHECK_MAGIC(dblist, EXT2_ET_MAGIC_DBLIST);
 
+	end = start + count;
 	if (!dblist->sorted)
 		ext2fs_dblist_sort2(dblist, 0);
-	for (i=0; i < dblist->count; i++) {
+	if (end > dblist->count)
+		end = dblist->count;
+	for (i = start; i < end; i++) {
 		ret = (*func)(dblist->fs, &dblist->list[i], priv_data);
 		if (ret & DBLIST_ABORT)
 			return 0;
@@ -215,6 +220,16 @@ errcode_t ext2fs_dblist_iterate2(ext2_dblist dblist,
 	return 0;
 }
 
+errcode_t ext2fs_dblist_iterate2(ext2_dblist dblist,
+				 int (*func)(ext2_filsys fs,
+					     struct ext2_db_entry2 *db_info,
+					     void	*priv_data),
+				 void *priv_data)
+{
+	return ext2fs_dblist_iterate3(dblist, func, 0, dblist->count,
+				      priv_data);
+}
+
 static EXT2_QSORT_TYPE dir_block_cmp2(const void *a, const void *b)
 {
 	const struct ext2_db_entry2 *db_a =
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d75dd76..5084d88 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1053,11 +1053,17 @@ extern void ext2fs_dblist_sort2(ext2_dblist dblist,
 extern errcode_t ext2fs_dblist_iterate(ext2_dblist dblist,
 	int (*func)(ext2_filsys fs, struct ext2_db_entry *db_info,
 		    void	*priv_data),
-       void *priv_data);
+	void *priv_data);
 extern errcode_t ext2fs_dblist_iterate2(ext2_dblist dblist,
 	int (*func)(ext2_filsys fs, struct ext2_db_entry2 *db_info,
 		    void	*priv_data),
-       void *priv_data);
+	void *priv_data);
+extern errcode_t ext2fs_dblist_iterate3(ext2_dblist dblist,
+	int (*func)(ext2_filsys fs, struct ext2_db_entry2 *db_info,
+		    void	*priv_data),
+	unsigned long long start,
+	unsigned long long count,
+	void *priv_data);
 extern errcode_t ext2fs_set_dir_block(ext2_dblist dblist, ext2_ino_t ino,
 				      blk_t blk, int blockcnt);
 extern errcode_t ext2fs_set_dir_block2(ext2_dblist dblist, ext2_ino_t ino,

