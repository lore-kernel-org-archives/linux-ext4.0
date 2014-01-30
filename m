From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/2] libext2fs: mmap io manager
Date: Thu, 30 Jan 2014 15:50:51 -0800
Message-ID: <20140130235051.31064.46416.stgit@birch.djwong.org>
References: <20140130235044.31064.38113.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47031 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbaA3Xu4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Jan 2014 18:50:56 -0500
In-Reply-To: <20140130235044.31064.38113.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Implement an IO manager that uses a gigantic mmap of the disk device.
This enables us to experiment with multithreaded metadata prefetch,
where we spawn a bunch of threads to issue a massive amount of IO to
fault in metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/unix.c          |    7 +
 lib/ext2fs/Makefile.in |    8 +
 lib/ext2fs/ext2_io.h   |    3 
 lib/ext2fs/mmap_io.c   |  534 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 551 insertions(+), 1 deletion(-)
 create mode 100644 lib/ext2fs/mmap_io.c


diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 67d7384..eeeef7c 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1255,7 +1255,12 @@ restart:
 		test_io_backing_manager = unix_io_manager;
 	} else
 #endif
-		io_ptr = unix_io_manager;
+	{
+		if (getenv("TEST_MMAP_IO"))
+			io_ptr = mmap_io_manager;
+		else
+			io_ptr = unix_io_manager;
+	}
 	flags |= EXT2_FLAG_NOFREE_ON_ERROR;
 	profile_get_boolean(ctx->profile, "options", "old_bitmaps", 0, 0,
 			    &old_bitmaps);
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 29d3527..a1b5a01 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -67,6 +67,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	lookup.o \
 	mkdir.o \
 	mkjournal.o \
+	mmap_io.o \
 	mmp.o \
 	namei.o \
 	native.o \
@@ -143,6 +144,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/lookup.c \
 	$(srcdir)/mkdir.c \
 	$(srcdir)/mkjournal.c \
+	$(srcdir)/mmap_io.c \
 	$(srcdir)/mmp.c	\
 	$(srcdir)/namei.c \
 	$(srcdir)/native.c \
@@ -825,6 +827,12 @@ mkjournal.o: $(srcdir)/mkjournal.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/ext2_ext_attr.h \
  $(srcdir)/bitops.h $(srcdir)/jfs_user.h $(srcdir)/kernel-jbd.h \
  $(srcdir)/jfs_compat.h $(srcdir)/kernel-list.h
+mmap_io.o: $(srcdir)/mmap_io.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
+ $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
+ $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h
 mmp.o: $(srcdir)/mmp.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index 1894fb8..39e0594 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -125,6 +125,9 @@ extern errcode_t io_channel_discard(io_channel channel,
 extern errcode_t io_channel_alloc_buf(io_channel channel,
 				      int count, void *ptr);
 
+/* mmap_io.c */
+extern io_manager mmap_io_manager;
+
 /* unix_io.c */
 extern io_manager unix_io_manager;
 
diff --git a/lib/ext2fs/mmap_io.c b/lib/ext2fs/mmap_io.c
new file mode 100644
index 0000000..37ca18b
--- /dev/null
+++ b/lib/ext2fs/mmap_io.c
@@ -0,0 +1,534 @@
+/*
+ * mmap_io.c --- This is the mmap implementation of the I/O manager.
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
+#include "config.h"
+#include <stdio.h>
+#include <string.h>
+#if HAVE_UNISTD_H
+#include <unistd.h>
+#endif
+#if HAVE_ERRNO_H
+#include <errno.h>
+#endif
+#include <fcntl.h>
+#include <time.h>
+#ifdef __linux__
+#include <sys/utsname.h>
+#endif
+#ifdef HAVE_SYS_IOCTL_H
+#include <sys/ioctl.h>
+#endif
+#ifdef HAVE_SYS_MOUNT_H
+#include <sys/mount.h>
+#endif
+#if HAVE_SYS_STAT_H
+#include <sys/stat.h>
+#endif
+#if HAVE_SYS_TYPES_H
+#include <sys/types.h>
+#endif
+#if HAVE_SYS_RESOURCE_H
+#include <sys/resource.h>
+#endif
+#if HAVE_LINUX_FALLOC_H
+#include <linux/falloc.h>
+#endif
+#include <sys/mman.h>
+#include <stdint.h>
+
+#if defined(__linux__) && defined(_IO) && !defined(BLKROGET)
+#define BLKROGET   _IO(0x12, 94) /* Get read-only status (0 = read_write).  */
+#endif
+
+#undef ALIGN_DEBUG
+
+#include "ext2_fs.h"
+#include "ext2fs.h"
+
+/*
+ * For checking structure magic numbers...
+ */
+
+#define EXT2_CHECK_MAGIC(struct, code) \
+	  if ((struct)->magic != (code)) return (code)
+
+struct mmap_private_data {
+	int	magic;
+	int	dev;
+	int	flags;
+	int	access_time;
+	ext2_loff_t offset;
+	void	*bounce;
+	struct struct_io_stats io_stats;
+	void	*map;
+	blk64_t	length;
+};
+
+static errcode_t mmap_open(const char *name, int flags, io_channel *channel);
+static errcode_t mmap_close(io_channel channel);
+static errcode_t mmap_set_blksize(io_channel channel, int blksize);
+static errcode_t mmap_read_blk(io_channel channel, unsigned long block,
+			       int count, void *data);
+static errcode_t mmap_write_blk(io_channel channel, unsigned long block,
+				int count, const void *data);
+static errcode_t mmap_flush(io_channel channel);
+static errcode_t mmap_write_byte(io_channel channel, unsigned long offset,
+				int size, const void *data);
+static errcode_t mmap_set_option(io_channel channel, const char *option,
+				 const char *arg);
+static errcode_t mmap_get_stats(io_channel channel, io_stats *stats)
+;
+static errcode_t mmap_read_blk64(io_channel channel, unsigned long long block,
+			       int count, void *data);
+static errcode_t mmap_write_blk64(io_channel channel, unsigned long long block,
+				int count, const void *data);
+static errcode_t mmap_discard(io_channel channel, unsigned long long block,
+			      unsigned long long count);
+
+static struct struct_io_manager struct_mmap_manager = {
+	EXT2_ET_MAGIC_IO_MANAGER,
+	"MMAP I/O Manager",
+	mmap_open,
+	mmap_close,
+	mmap_set_blksize,
+	mmap_read_blk,
+	mmap_write_blk,
+	mmap_flush,
+	mmap_write_byte,
+	mmap_set_option,
+	mmap_get_stats,
+	mmap_read_blk64,
+	mmap_write_blk64,
+	mmap_discard,
+};
+
+io_manager mmap_io_manager = &struct_mmap_manager;
+
+static errcode_t mmap_get_stats(io_channel channel, io_stats *stats)
+{
+	errcode_t	retval = 0;
+
+	struct mmap_private_data *data;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct mmap_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	if (stats)
+		*stats = &data->io_stats;
+
+	return retval;
+}
+
+/*
+ * Here are the raw I/O functions
+ */
+static errcode_t raw_read_blk(io_channel channel,
+			      struct mmap_private_data *data,
+			      unsigned long long block,
+			      int count, void *bufv)
+{
+	ssize_t		size;
+	ext2_loff_t	location;
+	int		actual = 0;
+	unsigned char	*buf = bufv;
+
+	size = (count < 0) ? -count : count * channel->block_size;
+	data->io_stats.bytes_read += size;
+	location = ((ext2_loff_t) block * channel->block_size) + data->offset;
+	memcpy(buf, data->map + location, size);
+
+	return 0;
+}
+
+static errcode_t raw_write_blk(io_channel channel,
+			       struct mmap_private_data *data,
+			       unsigned long long block,
+			       int count, const void *bufv)
+{
+	ssize_t		size;
+	ext2_loff_t	location;
+	int		actual = 0;
+	const unsigned char *buf = bufv;
+
+	size = (count < 0) ? -count : count * channel->block_size;
+	data->io_stats.bytes_written += size;
+	location = ((ext2_loff_t) block * channel->block_size) + data->offset;
+	memcpy(data->map + location, buf, size);
+
+	return 0;
+}
+
+#ifdef __linux__
+#ifndef BLKDISCARDZEROES
+#define BLKDISCARDZEROES _IO(0x12, 124)
+#endif
+#endif
+
+static errcode_t mmap_open(const char *name, int flags, io_channel *channel)
+{
+	io_channel	io = NULL;
+	struct mmap_private_data *data = NULL;
+	errcode_t	retval;
+	int		open_flags;
+	int		f_nocache = 0;
+	ext2fs_struct_stat st;
+#ifdef __linux__
+	struct		utsname ut;
+#endif
+
+	if (name == 0)
+		return EXT2_ET_BAD_DEVICE_NAME;
+	retval = ext2fs_get_mem(sizeof(struct struct_io_channel), &io);
+	if (retval)
+		goto cleanup;
+	memset(io, 0, sizeof(struct struct_io_channel));
+	io->magic = EXT2_ET_MAGIC_IO_CHANNEL;
+	retval = ext2fs_get_mem(sizeof(struct mmap_private_data), &data);
+	if (retval)
+		goto cleanup;
+
+	io->manager = mmap_io_manager;
+	retval = ext2fs_get_mem(strlen(name)+1, &io->name);
+	if (retval)
+		goto cleanup;
+
+	strcpy(io->name, name);
+	io->private_data = data;
+	io->block_size = 1024;
+	io->read_error = 0;
+	io->write_error = 0;
+	io->refcount = 1;
+
+	memset(data, 0, sizeof(struct mmap_private_data));
+	data->magic = EXT2_ET_MAGIC_UNIX_IO_CHANNEL;
+	data->io_stats.num_fields = 2;
+	data->dev = -1;
+
+	open_flags = (flags & IO_FLAG_RW) ? O_RDWR : O_RDONLY;
+	if (flags & IO_FLAG_EXCLUSIVE)
+		open_flags |= O_EXCL;
+#if defined(O_DIRECT)
+	if (flags & IO_FLAG_DIRECT_IO)
+		open_flags |= O_DIRECT;
+#elif defined(F_NOCACHE)
+	if (flags & IO_FLAG_DIRECT_IO)
+		f_nocache = F_NOCACHE;
+#endif
+	data->flags = flags;
+
+	data->dev = ext2fs_open_file(io->name, open_flags, 0);
+	if (data->dev < 0) {
+		retval = errno;
+		goto cleanup;
+	}
+	if (f_nocache) {
+		if (fcntl(data->dev, f_nocache, 1) < 0) {
+			retval = errno;
+			goto cleanup;
+		}
+	}
+
+	/*
+	 * If the device is really a block device, then set the
+	 * appropriate flag, otherwise we can set DISCARD_ZEROES flag
+	 * because we are going to use punch hole instead of discard
+	 * and if it succeed, subsequent read from sparse area returns
+	 * zero.
+	 */
+	if (ext2fs_stat(io->name, &st) == 0) {
+		if (S_ISBLK(st.st_mode))
+			io->flags |= CHANNEL_FLAGS_BLOCK_DEVICE;
+		else
+			io->flags |= CHANNEL_FLAGS_DISCARD_ZEROES;
+	}
+
+#ifdef BLKDISCARDZEROES
+	{
+		int zeroes = 0;
+		if (ioctl(data->dev, BLKDISCARDZEROES, &zeroes) == 0 &&
+		    zeroes)
+			io->flags |= CHANNEL_FLAGS_DISCARD_ZEROES;
+	}
+#endif
+
+#ifdef BLKROGET
+	if (flags & IO_FLAG_RW) {
+		int error;
+		int readonly = 0;
+
+		/* Is the block device actually writable? */
+		error = ioctl(data->dev, BLKROGET, &readonly);
+		if (!error && readonly) {
+			retval = EPERM;
+			goto cleanup;
+		}
+	}
+#endif
+
+	retval = ext2fs_get_device_size2(name, 1024, &data->length);
+	if (retval)
+		goto cleanup;
+	if (data->length == 0) {
+		retval = EINVAL;
+		goto cleanup;
+	}
+	data->length *= 1024;
+	data->map = mmap(NULL, data->length,
+			 PROT_READ | (flags & IO_FLAG_RW ? PROT_WRITE : 0),
+			 MAP_SHARED, data->dev, 0);
+	if (data->map == MAP_FAILED) {
+		retval = errno;
+		goto cleanup;
+	}
+
+#ifdef __linux__
+#undef RLIM_INFINITY
+#if (defined(__alpha__) || ((defined(__sparc__) || defined(__mips__)) && (SIZEOF_LONG == 4)))
+#define RLIM_INFINITY	((unsigned long)(~0UL>>1))
+#else
+#define RLIM_INFINITY  (~0UL)
+#endif
+	/*
+	 * Work around a bug in 2.4.10-2.4.18 kernels where writes to
+	 * block devices are wrongly getting hit by the filesize
+	 * limit.  This workaround isn't perfect, since it won't work
+	 * if glibc wasn't built against 2.2 header files.  (Sigh.)
+	 *
+	 */
+	if ((flags & IO_FLAG_RW) &&
+	    (uname(&ut) == 0) &&
+	    ((ut.release[0] == '2') && (ut.release[1] == '.') &&
+	     (ut.release[2] == '4') && (ut.release[3] == '.') &&
+	     (ut.release[4] == '1') && (ut.release[5] >= '0') &&
+	     (ut.release[5] < '8')) &&
+	    (ext2fs_stat(io->name, &st) == 0) &&
+	    (S_ISBLK(st.st_mode))) {
+		struct rlimit	rlim;
+
+		rlim.rlim_cur = rlim.rlim_max = (unsigned long) RLIM_INFINITY;
+		setrlimit(RLIMIT_FSIZE, &rlim);
+		getrlimit(RLIMIT_FSIZE, &rlim);
+		if (((unsigned long) rlim.rlim_cur) <
+		    ((unsigned long) rlim.rlim_max)) {
+			rlim.rlim_cur = rlim.rlim_max;
+			setrlimit(RLIMIT_FSIZE, &rlim);
+		}
+	}
+#endif
+	*channel = io;
+	return 0;
+
+cleanup:
+	if (data) {
+		if (data->dev >= 0)
+			close(data->dev);
+		ext2fs_free_mem(&data);
+	}
+	if (io) {
+		if (io->name)
+			ext2fs_free_mem(&io->name);
+		ext2fs_free_mem(&io);
+	}
+	return retval;
+}
+
+static errcode_t mmap_close(io_channel channel)
+{
+	struct mmap_private_data *data;
+	errcode_t	retval = 0;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct mmap_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	if (--channel->refcount > 0)
+		return 0;
+
+	munmap(data->map, data->length);
+
+	if (close(data->dev) < 0)
+		retval = errno;
+
+	ext2fs_free_mem(&channel->private_data);
+	if (channel->name)
+		ext2fs_free_mem(&channel->name);
+	ext2fs_free_mem(&channel);
+	return retval;
+}
+
+static errcode_t mmap_set_blksize(io_channel channel, int blksize)
+{
+	struct mmap_private_data *data;
+	errcode_t		retval;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct mmap_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	channel->block_size = blksize;
+	return 0;
+}
+
+
+static errcode_t mmap_read_blk64(io_channel channel, unsigned long long block,
+			       int count, void *buf)
+{
+	struct mmap_private_data *data;
+	errcode_t	retval;
+	char		*cp;
+	int		i, j;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct mmap_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	return raw_read_blk(channel, data, block, count, buf);
+}
+
+static errcode_t mmap_read_blk(io_channel channel, unsigned long block,
+			       int count, void *buf)
+{
+	return mmap_read_blk64(channel, block, count, buf);
+}
+
+static errcode_t mmap_write_blk64(io_channel channel, unsigned long long block,
+				int count, const void *buf)
+{
+	struct mmap_private_data *data;
+	errcode_t	retval = 0;
+	const char	*cp;
+	int		writethrough;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct mmap_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	return raw_write_blk(channel, data, block, count, buf);
+}
+
+static errcode_t mmap_write_blk(io_channel channel, unsigned long block,
+				int count, const void *buf)
+{
+	return mmap_write_blk64(channel, block, count, buf);
+}
+
+static errcode_t mmap_write_byte(io_channel channel, unsigned long offset,
+				 int size, const void *buf)
+{
+	struct mmap_private_data *data;
+	errcode_t	retval = 0;
+	ssize_t		actual;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct mmap_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	memcpy(data->map + offset + data->offset, buf, size);
+	return 0;
+}
+
+/*
+ * Flush data buffers to disk.
+ */
+static errcode_t mmap_flush(io_channel channel)
+{
+	struct mmap_private_data *data;
+	errcode_t retval = 0;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct mmap_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	fsync(data->dev);
+	return retval;
+}
+
+static errcode_t mmap_set_option(io_channel channel, const char *option,
+				 const char *arg)
+{
+	struct mmap_private_data *data;
+	unsigned long long tmp;
+	char *end;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct mmap_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	if (!strcmp(option, "offset")) {
+		if (!arg)
+			return EXT2_ET_INVALID_ARGUMENT;
+
+		tmp = strtoull(arg, &end, 0);
+		if (*end)
+			return EXT2_ET_INVALID_ARGUMENT;
+		data->offset = tmp;
+		if (data->offset < 0)
+			return EXT2_ET_INVALID_ARGUMENT;
+		return 0;
+	}
+	return EXT2_ET_INVALID_ARGUMENT;
+}
+
+#if defined(__linux__) && !defined(BLKDISCARD)
+#define BLKDISCARD		_IO(0x12, 119)
+#endif
+
+static errcode_t mmap_discard(io_channel channel, unsigned long long block,
+			      unsigned long long count)
+{
+	struct mmap_private_data *data;
+	int		ret;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct mmap_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	if (channel->flags & CHANNEL_FLAGS_BLOCK_DEVICE) {
+#ifdef BLKDISCARD
+		__uint64_t range[2];
+
+		range[0] = (__uint64_t)(block) * channel->block_size;
+		range[1] = (__uint64_t)(count) * channel->block_size;
+
+		ret = ioctl(data->dev, BLKDISCARD, &range);
+#else
+		goto unimplemented;
+#endif
+	} else {
+#if defined(HAVE_FALLOCATE) && defined(FALLOC_FL_PUNCH_HOLE)
+		/*
+		 * If we are not on block device, try to use punch hole
+		 * to reclaim free space.
+		 */
+		ret = fallocate(data->dev,
+				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				(off_t)(block) * channel->block_size,
+				(off_t)(count) * channel->block_size);
+#else
+		goto unimplemented;
+#endif
+	}
+	if (ret < 0) {
+		if (errno == EOPNOTSUPP)
+			goto unimplemented;
+		return errno;
+	}
+	return 0;
+unimplemented:
+	return EXT2_ET_UNIMPLEMENTED;
+}

