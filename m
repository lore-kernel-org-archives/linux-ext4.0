From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/2] libext2fs/e2fsck: implement metadata prefetching
Date: Thu, 30 Jan 2014 15:50:58 -0800
Message-ID: <20140130235058.31064.21096.stgit@birch.djwong.org>
References: <20140130235044.31064.38113.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23950 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbaA3XvD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Jan 2014 18:51:03 -0500
In-Reply-To: <20140130235044.31064.38113.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use threads with our new mmap IO manager to prefetch metadata.  This
results in a major e2fsck run time speedup.  There's also a stupider
multiprocess version that works with the good old UNIX IO manager to
get pages into the page cache.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/unix.c          |   13 +
 lib/ext2fs/Makefile.in |    8 +
 lib/ext2fs/ext2fs.h    |   13 +
 lib/ext2fs/prefetch.c  |  456 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 490 insertions(+)
 create mode 100644 lib/ext2fs/prefetch.c


diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index eeeef7c..33afc06 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1181,6 +1181,7 @@ int main (int argc, char *argv[])
 	__u32 features[3];
 	char *cp;
 	int qtype = -99;  /* quota type */
+	struct ext2fs_prefetch_handle *h = NULL;
 
 	clear_problem_context(&pctx);
 	sigcatcher_setup();
@@ -1638,9 +1639,21 @@ print_unsupp_features:
 		quota_init_context(&ctx->qctx, ctx->fs, qtype);
 	}
 
+	if (getenv("PREFETCH")) {
+		int flags = PREFETCH_INODES | PREFETCH_DIRS | PREFETCH_THREADED;
+		if (getenv("PREFETCH_WAIT"))
+			flags &= ~PREFETCH_THREADED;
+		retval = ext2fs_prefetch(fs, flags, &h);
+		if (retval)
+			com_err(ctx->program_name, retval, "prefetching");
+	}
+
 	run_result = e2fsck_run(ctx);
 	e2fsck_clear_progbar(ctx);
 
+	if (h)
+		ext2fs_prefetch_free(&h);
+
 	if (ctx->flags & E2F_FLAG_JOURNAL_INODE) {
 		if (fix_problem(ctx, PR_6_RECREATE_JOURNAL, &pctx)) {
 			if (journal_size < 1024)
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index a1b5a01..9fbf2b5 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -73,6 +73,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	native.o \
 	newdir.o \
 	openfs.o \
+	prefetch.o \
 	progress.o \
 	punch.o \
 	qcow2.o \
@@ -150,6 +151,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/native.c \
 	$(srcdir)/newdir.c \
 	$(srcdir)/openfs.c \
+	$(srcdir)/prefetch.c \
 	$(srcdir)/progress.c \
 	$(srcdir)/punch.c \
 	$(srcdir)/qcow2.c \
@@ -863,6 +865,12 @@ openfs.o: $(srcdir)/openfs.c $(top_builddir)/lib/config.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h $(srcdir)/e2image.h
+prefetch.o: $(srcdir)/prefetch.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2_fs.h \
+ $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/ext2_ext_attr.h \
+ $(srcdir)/bitops.h $(srcdir)/ext2fsP.h
 progress.o: $(srcdir)/progress.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2_fs.h \
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index ba5c388..e634d2c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1522,6 +1522,19 @@ errcode_t ext2fs_mmp_update2(ext2_filsys fs, int immediately);
 errcode_t ext2fs_mmp_stop(ext2_filsys fs);
 unsigned ext2fs_mmp_new_seq(void);
 
+/* prefetch.c */
+#define PREFETCH_THREADED	(0x00000001)
+#define PREFETCH_ERROR_ABORT	(0x00000002)
+#define PREFETCH_BITMAPS	(0x00000004)
+#define PREFETCH_INODES		(0x00000008)
+#define PREFETCH_MAPS		(0x00000010)
+#define PREFETCH_DIRS		(0x00000020)
+struct ext2fs_prefetch_handle;
+errcode_t ext2fs_prefetch(ext2_filsys fs, int flags,
+			  struct ext2fs_prefetch_handle **h);
+errcode_t ext2fs_prefetch_wait(struct ext2fs_prefetch_handle *h);
+errcode_t ext2fs_prefetch_free(struct ext2fs_prefetch_handle **h);
+
 /* read_bb.c */
 extern errcode_t ext2fs_read_bb_inode(ext2_filsys fs,
 				      ext2_badblocks_list *bb_list);
diff --git a/lib/ext2fs/prefetch.c b/lib/ext2fs/prefetch.c
new file mode 100644
index 0000000..022af41
--- /dev/null
+++ b/lib/ext2fs/prefetch.c
@@ -0,0 +1,456 @@
+/*
+ * prefetch.c --- Prefetch filesystem metadata.
+ *
+ * Copyright (C) 2014 by Oracle, Darrick J. Wong.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Library
+ * General Public License, version 2.
+ * %End-Header%
+ */
+
+#define _LARGEFILE_SOURCE
+#define _LARGEFILE64_SOURCE
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <signal.h>
+#include <pthread.h>
+
+#include "config.h"
+#include "ext2_fs.h"
+#include "ext2fs.h"
+
+#define USE_THREADS 1
+#define USE_SUPER 1
+
+struct ext2fs_prefetch_handle {
+	ext2_filsys fs;
+	int flags;
+	int done;
+	pid_t pid;
+#ifdef USE_THREADS
+	pthread_t tid;
+#endif
+};
+
+static int ignore_block(ext2_filsys fs, blk64_t *blocknr, e2_blkcnt_t blockcnt,
+			blk64_t ref_blk, int ref_offset, void *priv_data)
+{
+	return 0;
+}
+
+struct dirent_iterate {
+	void *buf;
+	int flags;
+};
+
+static int dirent_block(ext2_filsys fs, blk64_t *blocknr, e2_blkcnt_t blockcnt,
+			blk64_t ref_blk, int ref_offset, void *priv_data)
+{
+	struct dirent_iterate *di = priv_data;
+	errcode_t err;
+
+	err = io_channel_read_blk64(fs->io, *blocknr, 1, di->buf);
+	if (err && (di->flags & PREFETCH_ERROR_ABORT))
+		return BLOCK_ABORT;
+	return 0;
+}
+
+/*
+ * First dumb prefetch implementation: Separate process, just read data to
+ * get it into the page cache, at least.
+ */
+static void do_ext2fs_prefetch(ext2_filsys fs, int flags)
+{
+	void			*buf;
+	blk64_t			blk;
+	dgrp_t			i;
+	ext2_inode_scan		scan;
+	int			length = EXT2_INODE_SIZE(fs->super);
+	ext2_ino_t		ino;
+	errcode_t		err;
+	struct ext2_inode	inode;
+	struct dirent_iterate	di;
+	int			iter_flags;
+	unsigned int		blocks_to_read;
+
+	err = ext2fs_get_array(fs->blocksize, fs->inode_blocks_per_group, &buf);
+	if (err)
+		return;
+
+	/* load bitmaps */
+	if (!(flags & PREFETCH_BITMAPS))
+		goto skip_bitmaps;
+	err = ext2fs_read_bitmaps(fs);
+	if (err && (flags & PREFETCH_ERROR_ABORT))
+		goto out;
+
+skip_bitmaps:
+	/* load inode tables */
+	if (!(flags & PREFETCH_INODES) || (flags & (PREFETCH_MAPS |
+						    PREFETCH_DIRS)))
+		goto skip_itable;
+
+	for (i = 0; i < fs->group_desc_count; i++) {
+		if (ext2fs_bg_flags_test(fs, i, EXT2_BG_INODE_UNINIT))
+			continue;
+
+		blocks_to_read = fs->inode_blocks_per_group;
+		if (ext2fs_has_group_desc_csum(fs)) {
+			unsigned int num_inodes =
+					fs->super->s_inodes_per_group -
+					ext2fs_bg_itable_unused(fs, i);
+			blocks_to_read = (num_inodes *
+					  EXT2_INODE_SIZE(fs->super)) /
+					 fs->blocksize;
+		}
+
+		blk = ext2fs_inode_table_loc(fs, i);
+		err = io_channel_read_blk64(fs->io, blk, blocks_to_read, buf);
+		if (err && (flags & PREFETCH_ERROR_ABORT))
+			goto out;
+	}
+
+skip_itable:
+	/* load inodes */
+	if (!(flags & (PREFETCH_MAPS | PREFETCH_DIRS)))
+		goto skip_inodes;
+
+	err = ext2fs_open_inode_scan(fs, 0, &scan);
+	if (err && (flags & PREFETCH_ERROR_ABORT))
+		goto out;
+
+	di.buf = buf;
+	di.flags = flags;
+	do {
+		err = ext2fs_get_next_inode_full(scan, &ino, &inode,
+						 sizeof(inode));
+		if (err)
+			break;
+		if (!ino)
+			break;
+		if (!ext2fs_test_inode_bitmap2(fs->inode_map, ino))
+			continue;
+
+		iter_flags = BLOCK_FLAG_READ_ONLY | BLOCK_FLAG_DATA_ONLY;
+		if ((flags & PREFETCH_MAPS) &&
+		    !(flags & PREFETCH_DIRS) &&
+		    (LINUX_S_ISREG(inode.i_mode) ||
+		     LINUX_S_ISLNK(inode.i_mode))) {
+			err = ext2fs_block_iterate3(fs, ino, iter_flags, NULL,
+						    ignore_block, &di);
+		} else if ((flags & PREFETCH_DIRS) &&
+			   !(flags & PREFETCH_MAPS) &&
+			   LINUX_S_ISDIR(inode.i_mode)) {
+			err = ext2fs_block_iterate3(fs, ino, iter_flags, NULL,
+						    dirent_block, &di);
+		} else {
+			int (*func)(ext2_filsys fs, blk64_t *blocknr,
+				    e2_blkcnt_t blockcnt, blk64_t ref_blk,
+				    int ref_offset, void *priv_data) =
+			LINUX_S_ISDIR(inode.i_mode) ? dirent_block :
+						ignore_block;
+			err = ext2fs_block_iterate3(fs, ino, iter_flags, NULL,
+						    func, &di);
+		}
+		if (err && (flags & PREFETCH_ERROR_ABORT))
+			break;
+
+		blk = ext2fs_file_acl_block(fs, &inode);
+		if (!blk)
+			continue;
+		err = io_channel_read_blk64(fs->io, blk, 1, buf);
+		if (err && (flags & PREFETCH_ERROR_ABORT))
+			break;
+	} while (ino);
+
+out2:
+	ext2fs_close_inode_scan(scan);
+
+skip_inodes:
+out:
+	ext2fs_free_mem(&buf);
+
+	return;
+}
+
+static void *prefetch_thread(void *data)
+{
+	struct ext2fs_prefetch_handle *pd = data;
+	do_ext2fs_prefetch(pd->fs, pd->flags);
+	return NULL;
+}
+
+/*
+ * Second, less dumb prefetch: Use threads to preload metadata in group order.
+ */
+struct super_entry {
+	dgrp_t group;
+	ext2_ino_t num_inodes;
+};
+
+struct super_thread {
+	ext2_filsys fs;
+	pthread_t tid;
+	int flags;
+	struct super_entry *start, *end;
+	unsigned int skip_factor;
+	void *buf;
+};
+
+static void *super_func(void *data)
+{
+	struct super_thread *t = data;
+	ext2_filsys fs = t->fs;
+	int flags = t->flags;
+	void *buf = t->buf;
+	struct super_entry *e;
+	unsigned int blocks_to_read;
+	blk64_t blk;
+	ext2_ino_t i, ino;
+	unsigned int nr_read = 0;
+	struct dirent_iterate di;
+	struct ext2_inode inode;
+	int iter_flags;
+	errcode_t err;
+
+	/* Read the inode tables */
+	for (e = t->start; e < t->end; e += t->skip_factor) {
+		blocks_to_read = (e->num_inodes *
+				  EXT2_INODE_SIZE(fs->super)) / fs->blocksize;
+		blk = ext2fs_inode_table_loc(fs, e->group);
+		err = io_channel_read_blk64(fs->io, blk, blocks_to_read, buf);
+		if (err && (flags & PREFETCH_ERROR_ABORT))
+			continue;
+	}
+
+	/* Scan inodes for extent/dir blocks */
+	di.buf = buf;
+	di.flags = flags;
+	for (e = t->start; e < t->end; e += t->skip_factor) {
+		for (i = 0; i < e->num_inodes; i++) {
+			ino = e->group * fs->super->s_inodes_per_group + i;
+			err = ext2fs_read_inode(fs, ino, &inode);
+			if (err)
+				continue;
+			/* Skip unlinked or unknown-type inodes */
+			if (!inode.i_links_count ||
+			    (inode.i_mode & 0xF000) == 0)
+				continue;
+
+			iter_flags = BLOCK_FLAG_READ_ONLY |
+				     BLOCK_FLAG_DATA_ONLY;
+			if ((flags & PREFETCH_MAPS) &&
+			    !(flags & PREFETCH_DIRS) &&
+			    (LINUX_S_ISREG(inode.i_mode) ||
+			     LINUX_S_ISLNK(inode.i_mode))) {
+				err = ext2fs_block_iterate3(fs, ino,
+							    iter_flags, NULL,
+							    ignore_block, &di);
+			} else if ((flags & PREFETCH_DIRS) &&
+				   !(flags & PREFETCH_MAPS) &&
+				   LINUX_S_ISDIR(inode.i_mode)) {
+				err = ext2fs_block_iterate3(fs, ino,
+							    iter_flags, NULL,
+							    dirent_block, &di);
+			} else {
+				int (*func)(ext2_filsys fs, blk64_t *blocknr,
+					    e2_blkcnt_t blockcnt,
+					    blk64_t ref_blk,
+					    int ref_offset, void *priv_data) =
+				LINUX_S_ISDIR(inode.i_mode) ? dirent_block :
+							ignore_block;
+				err = ext2fs_block_iterate3(fs, ino,
+							    iter_flags, NULL,
+							    func, &di);
+			}
+
+			blk = ext2fs_file_acl_block(fs, &inode);
+			if (!blk)
+				continue;
+			err = io_channel_read_blk64(fs->io, blk, 1, buf);
+		}
+	}
+
+	return NULL;
+}
+
+static void *super_prefetch(void *data)
+{
+	struct ext2fs_prefetch_handle *pd = data;
+	ext2_filsys fs = pd->fs;
+	int flags = pd->flags;
+	void *b, *r;
+	struct super_thread *threads = NULL, *t;
+	unsigned int num_threads = sysconf(_SC_NPROCESSORS_ONLN);
+	unsigned int j;
+	struct super_entry *entries = NULL, *e = NULL;
+	unsigned int num_entries = 0;
+	dgrp_t i;
+	ext2_ino_t num_inodes;
+	errcode_t err;
+
+	/* Find all non-empty groups */
+	for (i = 0; i < fs->group_desc_count; i++) {
+		if (ext2fs_bg_flags_test(fs, i, EXT2_BG_INODE_UNINIT))
+			continue;
+
+		num_inodes = fs->super->s_inodes_per_group;
+		if (ext2fs_bg_free_inodes_count(fs, i) == num_inodes)
+			continue;
+		if (ext2fs_has_group_desc_csum(fs))
+			num_inodes -= ext2fs_bg_itable_unused(fs, i);
+		if (e == entries + num_entries) {
+			r = realloc(entries, (num_entries + 32) *
+					     sizeof(*entries));
+			if (r == NULL) {
+				err = errno;
+				goto out;
+			}
+			entries = r;
+			e = entries + num_entries;
+			num_entries += 32;
+		}
+		e->group = i;
+		e->num_inodes = num_inodes;
+		e++;
+	}
+	num_entries = e - entries;
+
+	/* Set up the threads */
+	if (getenv("PREFETCH_THREADS")) {
+		j = atoi(getenv("PREFETCH_THREADS"));
+		if (j > 0)
+			num_threads = j;
+	}
+
+	err = ext2fs_get_arrayzero(num_threads, sizeof(*threads) +
+				(fs->blocksize * fs->inode_blocks_per_group),
+				&b);
+	if (err)
+		goto out;
+	threads = b + (fs->blocksize * fs->inode_blocks_per_group *
+		       num_threads);
+
+	for (j = 0, t = threads, e = entries; j < num_threads; j++, t++, e++) {
+		t->fs = fs;
+		t->flags = flags;
+		t->start = e;
+		t->end = entries + num_entries;
+		t->skip_factor = num_threads;
+		err = ext2fs_dup_handle(fs, &t->fs);
+		if (err)
+			goto out2;
+		t->fs->icache = NULL;
+		t->buf = b + (fs->blocksize * fs->inode_blocks_per_group * j);
+		pthread_create(&t->tid, NULL, super_func, t);
+	}
+
+	/* Wait for threads */
+	for (j = 0, t = threads; j < num_threads; j++, t++)
+		pthread_join(t->tid, NULL);
+	pd->done = 1;
+out2:
+	ext2fs_free_mem(&b);
+out:
+	free(entries);
+	return NULL;
+}
+
+struct unix_private_data_hack {
+	int	magic;
+	int	dev;
+};
+
+errcode_t ext2fs_prefetch(ext2_filsys fs, int flags,
+			  struct ext2fs_prefetch_handle **h)
+{
+	struct ext2fs_prefetch_handle *pd;
+	errcode_t err;
+
+	err = ext2fs_get_memzero(sizeof(*pd), &pd);
+	if (err)
+		return err;
+	pd->fs = fs;
+	pd->flags = flags;
+
+	/* Load the rest */
+	if (flags & PREFETCH_THREADED) {
+		if (fs->io->manager == mmap_io_manager) {
+#if USE_SUPER
+			struct timespec ts;
+			err = pthread_create(&pd->tid, NULL, super_prefetch,
+					     pd);
+			if (err)
+				goto errout;
+			ts.tv_sec = 0; ts.tv_nsec = 500000;
+			nanosleep(&ts, NULL);
+#elif USE_THREADS
+			err = pthread_create(&pd->tid, NULL, prefetch_thread,
+					     pd);
+			if (err)
+				goto errout;
+#else
+			goto single_thread;
+#endif
+		} else if (fs->io->manager == unix_io_manager) {
+			pd->pid = fork();
+			if (pd->pid < 0) {
+				err = errno;
+				goto errout;
+			} else if (pd->pid == 0) {
+				struct unix_private_data_hack *m =
+						fs->io->private_data;
+				m->dev = open(fs->device_name, O_RDONLY);
+				do_ext2fs_prefetch(fs, flags);
+				exit(0);
+			}
+		}
+	} else {
+single_thread:
+#if USE_SUPER
+		super_prefetch(pd);
+#else
+		do_ext2fs_prefetch(fs, flags);
+#endif
+		pd->done = 1;
+	}
+	*h = pd;
+
+	return 0;
+errout:
+	ext2fs_free_mem(&pd);
+	return err;
+}
+
+errcode_t ext2fs_prefetch_wait(struct ext2fs_prefetch_handle *h)
+{
+	pid_t ret;
+	int status;
+
+	if (h->flags & PREFETCH_THREADED && h->done != 0) {
+		if (h->tid)
+			ret = pthread_join(h->tid, NULL);
+		if (h->pid) {
+			ret = waitpid(h->pid, &status, WNOHANG);
+			if (ret == 0)
+				kill(h->pid, SIGKILL);
+			waitpid(h->pid, NULL, 0);
+		}
+	}
+	h->done = 1;
+	return 0;
+}
+
+errcode_t ext2fs_prefetch_free(struct ext2fs_prefetch_handle **h)
+{
+	ext2fs_prefetch_wait(*h);
+	return ext2fs_free_mem(h);
+}

