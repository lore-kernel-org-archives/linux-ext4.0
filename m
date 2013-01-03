From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/4] resize2fs: add resource tracking as a debug option
Date: Thu,  3 Jan 2013 09:13:27 -0500
Message-ID: <1357222408-7310-3-git-send-email-tytso@mit.edu>
References: <1357222408-7310-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41498 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594Ab3ACONf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jan 2013 09:13:35 -0500
In-Reply-To: <1357222408-7310-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a new debug flag which prints how much time is consumed by the
various parts of resize2fs's processing.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/Makefile.in      |  27 +++++++---
 resize/resize2fs.8.in   |   2 +
 resize/resize2fs.c      |  50 +++++++++++++++----
 resize/resize2fs.h      |  22 +++++++++
 resize/resource_track.c | 128 ++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 213 insertions(+), 16 deletions(-)
 create mode 100644 resize/resource_track.c

diff --git a/resize/Makefile.in b/resize/Makefile.in
index b2739ac..a06b642 100644
--- a/resize/Makefile.in
+++ b/resize/Makefile.in
@@ -16,7 +16,8 @@ PROGS=		resize2fs
 TEST_PROGS=	test_extent
 MANPAGES=	resize2fs.8
 
-RESIZE_OBJS= extent.o resize2fs.o main.o online.o sim_progress.o 
+RESIZE_OBJS= extent.o resize2fs.o main.o online.o resource_track.o \
+		sim_progress.o
 
 TEST_EXTENT_OBJS= extent.o test_extent.o
 
@@ -24,6 +25,7 @@ SRCS= $(srcdir)/extent.c \
 	$(srcdir)/resize2fs.c \
 	$(srcdir)/main.c \
 	$(srcdir)/online.c \
+	$(srcdir)/resource_track.c \
 	$(srcdir)/sim_progress.c
 
 LIBS= $(LIBE2P) $(LIBEXT2FS) $(LIBCOM_ERR) $(LIBINTL)
@@ -144,35 +146,48 @@ source_tar_file: $(top_srcdir)/.exclude-file
 # Makefile dependencies follow.  This must be the last section in
 # the Makefile.in file
 #
-extent.o: $(srcdir)/extent.c $(srcdir)/resize2fs.h \
+extent.o: $(srcdir)/extent.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/resize2fs.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(top_srcdir)/lib/e2p/e2p.h
-resize2fs.o: $(srcdir)/resize2fs.c $(srcdir)/resize2fs.h \
+resize2fs.o: $(srcdir)/resize2fs.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/resize2fs.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(top_srcdir)/lib/e2p/e2p.h
-main.o: $(srcdir)/main.c $(top_srcdir)/lib/e2p/e2p.h \
+main.o: $(srcdir)/main.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/e2p/e2p.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(srcdir)/resize2fs.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
  $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(top_srcdir)/version.h
-online.o: $(srcdir)/online.c $(srcdir)/resize2fs.h \
+online.o: $(srcdir)/online.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/resize2fs.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(top_srcdir)/lib/e2p/e2p.h
-sim_progress.o: $(srcdir)/sim_progress.c $(srcdir)/resize2fs.h \
+resource_track.o: $(srcdir)/resource_track.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/resize2fs.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(top_srcdir)/lib/e2p/e2p.h
+sim_progress.o: $(srcdir)/sim_progress.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/resize2fs.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
index 9ff6e0a..735fc91 100644
--- a/resize/resize2fs.8.in
+++ b/resize/resize2fs.8.in
@@ -99,6 +99,8 @@ from the following list:
 	4	\-\ Debug inode relocations
 .br
 	8	\-\ Debug moving the inode table
+.br
+	16	\-\ Print timing information
 .TP 
 .B \-f
 Forces resize2fs to proceed with the filesystem resize operation, overriding
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index d9501f9..f6a52e5 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -74,14 +74,7 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 {
 	ext2_resize_t	rfs;
 	errcode_t	retval;
-
-	retval = ext2fs_read_bitmaps(fs);
-	if (retval)
-		return retval;
-
-	fs->super->s_state |= EXT2_ERROR_FS;
-	ext2fs_mark_super_dirty(fs);
-	ext2fs_flush(fs);
+	struct resource_track	rtrack, overall_track;
 
 	/*
 	 * Create the data structure
@@ -89,32 +82,53 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 	retval = ext2fs_get_mem(sizeof(struct ext2_resize_struct), &rfs);
 	if (retval)
 		return retval;
-	memset(rfs, 0, sizeof(struct ext2_resize_struct));
 
-	fix_uninit_block_bitmaps(fs);
+	memset(rfs, 0, sizeof(struct ext2_resize_struct));
 	fs->priv_data = rfs;
 	rfs->old_fs = fs;
 	rfs->flags = flags;
 	rfs->itable_buf	 = 0;
 	rfs->progress = progress;
+
+	init_resource_track(&overall_track, "overall resize2fs", fs->io);
+	init_resource_track(&rtrack, "read_bitmaps", fs->io);
+	retval = ext2fs_read_bitmaps(fs);
+	if (retval)
+		goto errout;
+	print_resource_track(rfs, &rtrack, fs->io);
+
+	fs->super->s_state |= EXT2_ERROR_FS;
+	ext2fs_mark_super_dirty(fs);
+	ext2fs_flush(fs);
+
+	init_resource_track(&rtrack, "fix_uninit_block_bitmaps 1", fs->io);
+	fix_uninit_block_bitmaps(fs);
+	print_resource_track(rfs, &rtrack, fs->io);
 	retval = ext2fs_dup_handle(fs, &rfs->new_fs);
 	if (retval)
 		goto errout;
 
+	init_resource_track(&rtrack, "adjust_superblock", fs->io);
 	retval = adjust_superblock(rfs, *new_size);
 	if (retval)
 		goto errout;
+	print_resource_track(rfs, &rtrack, fs->io);
 
+
+	init_resource_track(&rtrack, "fix_uninit_block_bitmaps 2", fs->io);
 	fix_uninit_block_bitmaps(rfs->new_fs);
+	print_resource_track(rfs, &rtrack, fs->io);
 	/* Clear the block bitmap uninit flag for the last block group */
 	ext2fs_bg_flags_clear(rfs->new_fs, rfs->new_fs->group_desc_count - 1,
 			     EXT2_BG_BLOCK_UNINIT);
 
 	*new_size = ext2fs_blocks_count(rfs->new_fs->super);
 
+	init_resource_track(&rtrack, "blocks_to_move", fs->io);
 	retval = blocks_to_move(rfs);
 	if (retval)
 		goto errout;
+	print_resource_track(rfs, &rtrack, fs->io);
 
 #ifdef RESIZE2FS_DEBUG
 	if (rfs->flags & RESIZE_DEBUG_BMOVE)
@@ -124,36 +138,52 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 		       rfs->needed_blocks);
 #endif
 
+	init_resource_track(&rtrack, "block_mover", fs->io);
 	retval = block_mover(rfs);
 	if (retval)
 		goto errout;
+	print_resource_track(rfs, &rtrack, fs->io);
 
+	init_resource_track(&rtrack, "inode_scan_and_fix", fs->io);
 	retval = inode_scan_and_fix(rfs);
 	if (retval)
 		goto errout;
+	print_resource_track(rfs, &rtrack, fs->io);
 
+	init_resource_track(&rtrack, "inode_ref_fix", fs->io);
 	retval = inode_ref_fix(rfs);
 	if (retval)
 		goto errout;
+	print_resource_track(rfs, &rtrack, fs->io);
 
+	init_resource_track(&rtrack, "move_itables", fs->io);
 	retval = move_itables(rfs);
 	if (retval)
 		goto errout;
+	print_resource_track(rfs, &rtrack, fs->io);
 
+	init_resource_track(&rtrack, "calculate_summary_stats", fs->io);
 	retval = ext2fs_calculate_summary_stats(rfs->new_fs);
 	if (retval)
 		goto errout;
+	print_resource_track(rfs, &rtrack, fs->io);
 
+	init_resource_track(&rtrack, "fix_resize_inode", fs->io);
 	retval = fix_resize_inode(rfs->new_fs);
 	if (retval)
 		goto errout;
+	print_resource_track(rfs, &rtrack, fs->io);
 
+	init_resource_track(&rtrack, "fix_sb_journal_backup", fs->io);
 	retval = fix_sb_journal_backup(rfs->new_fs);
 	if (retval)
 		goto errout;
+	print_resource_track(rfs, &rtrack, fs->io);
 
 	rfs->new_fs->super->s_state &= ~EXT2_ERROR_FS;
 	rfs->new_fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
+
+	print_resource_track(rfs, &overall_track, fs->io);
 	retval = ext2fs_close(rfs->new_fs);
 	if (retval)
 		goto errout;
diff --git a/resize/resize2fs.h b/resize/resize2fs.h
index 2184759..d425491 100644
--- a/resize/resize2fs.h
+++ b/resize/resize2fs.h
@@ -76,11 +76,26 @@ typedef struct ext2_sim_progress *ext2_sim_progmeter;
 #define RESIZE_DEBUG_BMOVE		0x0002
 #define RESIZE_DEBUG_INODEMAP		0x0004
 #define RESIZE_DEBUG_ITABLEMOVE		0x0008
+#define RESIZE_DEBUG_RTRACK		0x0010
 
 #define RESIZE_PERCENT_COMPLETE		0x0100
 #define RESIZE_VERBOSE			0x0200
 
 /*
+ * This structure is used for keeping track of how much resources have
+ * been used for a particular resize2fs pass.
+ */
+struct resource_track {
+	const char *desc;
+	struct timeval time_start;
+	struct timeval user_start;
+	struct timeval system_start;
+	void	*brk_start;
+	unsigned long long bytes_read;
+	unsigned long long bytes_written;
+};
+
+/*
  * The core state structure for the ext2 resizer
  */
 typedef struct ext2_resize_struct *ext2_resize_t;
@@ -148,6 +163,13 @@ extern errcode_t ext2fs_iterate_extent(ext2_extent extent, __u64 *old_loc,
 extern errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 				  blk64_t *new_size, int flags);
 
+/* resource_track.c */
+extern void init_resource_track(struct resource_track *track, const char *desc,
+				io_channel channel);
+extern void print_resource_track(ext2_resize_t rfs,
+				 struct resource_track *track,
+				 io_channel channel);
+
 /* sim_progress.c */
 extern errcode_t ext2fs_progress_init(ext2_sim_progmeter *ret_prog,
 				      const char *label,
diff --git a/resize/resource_track.c b/resize/resource_track.c
new file mode 100644
index 0000000..f0efe11
--- /dev/null
+++ b/resize/resource_track.c
@@ -0,0 +1,128 @@
+/*
+ * resource_track.c --- resource tracking
+ *
+ * Copyright (C) 2013 by Theodore Ts'o
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+
+#include "config.h"
+#include "resize2fs.h"
+#include <time.h>
+#ifdef HAVE_MALLOC_H
+#include <malloc.h>
+#endif
+#include <sys/resource.h>
+
+void init_resource_track(struct resource_track *track, const char *desc,
+			 io_channel channel)
+{
+#ifdef HAVE_GETRUSAGE
+	struct rusage r;
+#endif
+	io_stats io_start = 0;
+
+	track->desc = desc;
+	track->brk_start = sbrk(0);
+	gettimeofday(&track->time_start, 0);
+#ifdef HAVE_GETRUSAGE
+#ifdef sun
+	memset(&r, 0, sizeof(struct rusage));
+#endif
+	getrusage(RUSAGE_SELF, &r);
+	track->user_start = r.ru_utime;
+	track->system_start = r.ru_stime;
+#else
+	track->user_start.tv_sec = track->user_start.tv_usec = 0;
+	track->system_start.tv_sec = track->system_start.tv_usec = 0;
+#endif
+	track->bytes_read = 0;
+	track->bytes_written = 0;
+	if (channel && channel->manager && channel->manager->get_stats)
+		channel->manager->get_stats(channel, &io_start);
+	if (io_start) {
+		track->bytes_read = io_start->bytes_read;
+		track->bytes_written = io_start->bytes_written;
+	}
+}
+
+static float timeval_subtract(struct timeval *tv1,
+			      struct timeval *tv2)
+{
+	return ((tv1->tv_sec - tv2->tv_sec) +
+		((float) (tv1->tv_usec - tv2->tv_usec)) / 1000000);
+}
+
+void print_resource_track(ext2_resize_t rfs, struct resource_track *track,
+			  io_channel channel)
+{
+#ifdef HAVE_GETRUSAGE
+	struct rusage r;
+#endif
+#ifdef HAVE_MALLINFO
+	struct mallinfo	malloc_info;
+#endif
+	struct timeval time_end;
+
+	if ((rfs->flags & RESIZE_DEBUG_RTRACK) == 0)
+		return;
+
+	gettimeofday(&time_end, 0);
+
+	if (track->desc)
+		printf("%s: ", track->desc);
+
+#ifdef HAVE_MALLINFO
+#define kbytes(x)	(((unsigned long)(x) + 1023) / 1024)
+
+	malloc_info = mallinfo();
+	printf("Memory used: %luk/%luk (%luk/%luk), ",
+		kbytes(malloc_info.arena), kbytes(malloc_info.hblkhd),
+		kbytes(malloc_info.uordblks), kbytes(malloc_info.fordblks));
+#else
+	printf("Memory used: %lu, ",
+		(unsigned long) (((char *) sbrk(0)) -
+				 ((char *) track->brk_start)));
+#endif
+#ifdef HAVE_GETRUSAGE
+	getrusage(RUSAGE_SELF, &r);
+
+	printf("time: %5.2f/%5.2f/%5.2f\n",
+		timeval_subtract(&time_end, &track->time_start),
+		timeval_subtract(&r.ru_utime, &track->user_start),
+		timeval_subtract(&r.ru_stime, &track->system_start));
+#else
+	printf("elapsed time: %6.3f\n",
+		timeval_subtract(&time_end, &track->time_start));
+#endif
+#define mbytes(x)	(((x) + 1048575) / 1048576)
+	if (channel && channel->manager && channel->manager->get_stats) {
+		io_stats delta = 0;
+		unsigned long long bytes_read = 0;
+		unsigned long long bytes_written = 0;
+
+		channel->manager->get_stats(channel, &delta);
+		if (delta) {
+			bytes_read = delta->bytes_read - track->bytes_read;
+			bytes_written = delta->bytes_written -
+				track->bytes_written;
+			if (bytes_read == 0 && bytes_written == 0)
+				goto skip_io;
+			if (track->desc)
+				printf("%s: ", track->desc);
+			printf("I/O read: %lluMB, write: %lluMB, "
+			       "rate: %.2fMB/s\n",
+			       mbytes(bytes_read),
+			       mbytes(bytes_written),
+			       (double)mbytes(bytes_read + bytes_written) /
+			       timeval_subtract(&time_end, &track->time_start));
+		}
+	}
+skip_io:
+	fflush(stdout);
+}
+
-- 
1.7.12.rc0.22.gcdd159b

