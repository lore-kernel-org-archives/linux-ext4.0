From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/4] Add unix COW io manager
Date: Fri,  4 May 2007 14:43:21 +0530
Message-ID: <11782700081019-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11782700042368-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:50054 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767756AbXEDJNg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 May 2007 05:13:36 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l449WwYu171418
	for <linux-ext4@vger.kernel.org>; Fri, 4 May 2007 19:32:58 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l449H1WC167942
	for <linux-ext4@vger.kernel.org>; Fri, 4 May 2007 19:17:02 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l449DTB5009031
	for <linux-ext4@vger.kernel.org>; Fri, 4 May 2007 19:13:30 +1000
In-Reply-To: <11782700042368-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <eb16ba5f2c6f399ea747169097434ae84443728f.1178262585.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 lib/ext2fs/Makefile.in   |    6 +
 lib/ext2fs/ext2_io.h     |    3 +
 lib/ext2fs/unix_cow_io.c |  864 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 873 insertions(+), 0 deletions(-)
 create mode 100644 lib/ext2fs/unix_cow_io.c

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 799659e..938f2d3 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -64,6 +64,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	rw_bitmaps.o \
 	swapfs.o \
 	unix_io.o \
+	unix_cow_io.o \
 	unlink.o \
 	valid_blk.o \
 	version.o
@@ -126,6 +127,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/swapfs.c \
 	$(srcdir)/test_io.c \
 	$(srcdir)/unix_io.c \
+	$(srcdir)/unix_cow_io.c \
 	$(srcdir)/unlink.c \
 	$(srcdir)/valid_blk.c \
 	$(srcdir)/version.c \
@@ -512,6 +514,10 @@ unix_io.o: $(srcdir)/unix_io.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
+unix_cow_io.o: $(srcdir)/unix_cow_io.c $(srcdir)/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
+ $(srcdir)/ext2_fs.h $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
 unlink.o: $(srcdir)/unlink.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index eada278..cdfdd51 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -96,6 +96,9 @@ extern errcode_t io_channel_write_byte(io_channel channel,
 /* unix_io.c */
 extern io_manager unix_io_manager;
 
+/* unix_cow_io.c */
+extern io_manager unix_cow_io_manager;
+
 /* test_io.c */
 extern io_manager test_io_manager, test_io_backing_manager;
 extern void (*test_io_cb_read_blk)
diff --git a/lib/ext2fs/unix_cow_io.c b/lib/ext2fs/unix_cow_io.c
new file mode 100644
index 0000000..aeebec8
--- /dev/null
+++ b/lib/ext2fs/unix_cow_io.c
@@ -0,0 +1,864 @@
+/*
+ * unix_cow_io.c --- This is the Unix (well, really POSIX) implementation
+ * 	of the COW I/O manager.
+ *
+ * Implements a one-block write-through cache.
+ *
+ * Includes support for Windows NT support under Cygwin. 
+ *
+ * Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001,
+ * 	2002 by Theodore Ts'o.
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
+#if HAVE_SYS_STAT_H
+#include <sys/stat.h>
+#endif
+#if HAVE_SYS_TYPES_H
+#include <sys/types.h>
+#endif
+#if HAVE_SYS_RESOURCE_H
+#include <sys/resource.h>
+#endif
+
+#include <tdb.h>
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
+struct unix_cache {
+	char		*buf;
+	unsigned long	block;
+	int		access_time;
+	unsigned	dirty:1;
+	unsigned	in_use:1;
+};
+
+#define CACHE_SIZE 8
+#define WRITE_DIRECT_SIZE 4	/* Must be smaller than CACHE_SIZE */
+#define READ_DIRECT_SIZE 4	/* Should be smaller than CACHE_SIZE */
+
+struct unix_cow_private_data {
+	int	magic;
+	int	dev;
+	int	flags;
+	int	access_time;
+	ext2_loff_t offset;
+	TDB_CONTEXT *tdb;
+	char *tdb_file;
+	struct unix_cache cache[CACHE_SIZE];
+};
+
+static errcode_t unix_cow_open(const char *name, int flags, io_channel *channel);
+static errcode_t unix_cow_close(io_channel channel);
+static errcode_t unix_cow_set_blksize(io_channel channel, int blksize);
+static errcode_t unix_cow_read_blk(io_channel channel, unsigned long block,
+			       int count, void *data);
+static errcode_t unix_cow_write_blk(io_channel channel, unsigned long block,
+				int count, const void *data);
+static errcode_t unix_cow_flush(io_channel channel);
+static errcode_t unix_cow_write_byte(io_channel channel, unsigned long offset,
+				int size, const void *data);
+static errcode_t unix_cow_set_option(io_channel channel, const char *option, 
+				 const char *arg);
+
+static void reuse_cache(io_channel channel, struct unix_cow_private_data *data,
+		 struct unix_cache *cache, unsigned long block);
+
+/* __FreeBSD_kernel__ is defined by GNU/kFreeBSD - the FreeBSD kernel
+ * does not know buffered block devices - everything is raw. */
+#if defined(__CYGWIN__) || defined(__FreeBSD__) || defined(__FreeBSD_kernel__)
+#define NEED_BOUNCE_BUFFER
+#else
+#undef NEED_BOUNCE_BUFFER
+#endif
+
+static struct struct_io_manager struct_unix_cow_manager = {
+	EXT2_ET_MAGIC_IO_MANAGER,
+	"Unix COW_I/O Manager",
+	unix_cow_open,
+	unix_cow_close,
+	unix_cow_set_blksize,
+	unix_cow_read_blk,
+	unix_cow_write_blk,
+	unix_cow_flush,
+#ifdef NEED_BOUNCE_BUFFER
+	0,
+#else
+	unix_cow_write_byte,
+#endif
+	unix_cow_set_option
+};
+
+io_manager unix_cow_io_manager = &struct_unix_cow_manager;
+
+/*
+ * Here are the raw I/O functions
+ */
+#ifndef NEED_BOUNCE_BUFFER
+static errcode_t raw_read_blk(io_channel channel,
+			      struct unix_cow_private_data *data,
+			      unsigned long block,
+			      int count, void *buf)
+{
+	errcode_t	retval;
+	ssize_t		size;
+	ext2_loff_t	location;
+	int		actual = 0;
+
+	size = (count < 0) ? -count : count * channel->block_size;
+	location = ((ext2_loff_t) block * channel->block_size) + data->offset;
+	if (ext2fs_llseek(data->dev, location, SEEK_SET) != location) {
+		retval = errno ? errno : EXT2_ET_LLSEEK_FAILED;
+		goto error_out;
+	}
+	actual = read(data->dev, buf, size);
+	if (actual != size) {
+		if (actual < 0)
+			actual = 0;
+		retval = EXT2_ET_SHORT_READ;
+		goto error_out;
+	}
+	return 0;
+	
+error_out:
+	memset((char *) buf+actual, 0, size-actual);
+	if (channel->read_error)
+		retval = (channel->read_error)(channel, block, count, buf,
+					       size, actual, retval);
+	return retval;
+}
+#else /* NEED_BOUNCE_BUFFER */
+/*
+ * Windows and FreeBSD block devices only allow sector alignment IO in offset and size
+ */
+static errcode_t raw_read_blk(io_channel channel,
+			      struct unix_cow_private_data *data,
+			      unsigned long block,
+			      int count, void *buf)
+{
+	errcode_t	retval;
+	size_t		size, alignsize, fragment;
+	ext2_loff_t	location;
+	int		total = 0, actual;
+#define BLOCKALIGN 512
+	char		sector[BLOCKALIGN];
+
+	size = (count < 0) ? -count : count * channel->block_size;
+	location = ((ext2_loff_t) block * channel->block_size) + data->offset;
+#ifdef DEBUG
+	printf("count=%d, size=%d, block=%lu, blk_size=%d, location=%llx\n",
+	 		count, size, block, channel->block_size, (long long)location);
+#endif
+	if (ext2fs_llseek(data->dev, location, SEEK_SET) != location) {
+		retval = errno ? errno : EXT2_ET_LLSEEK_FAILED;
+		goto error_out;
+	}
+	fragment = size % BLOCKALIGN;
+	alignsize = size - fragment;
+	if (alignsize) {
+		actual = read(data->dev, buf, alignsize);
+		if (actual != alignsize)
+			goto short_read;
+	}
+	if (fragment) {
+		actual = read(data->dev, sector, BLOCKALIGN);
+		if (actual != BLOCKALIGN)
+			goto short_read;
+		memcpy(buf+alignsize, sector, fragment);
+	}
+	return 0;
+
+short_read:
+	if (actual>0)
+		total += actual;
+	retval = EXT2_ET_SHORT_READ;
+
+error_out:
+	memset((char *) buf+total, 0, size-actual);
+	if (channel->read_error)
+		retval = (channel->read_error)(channel, block, count, buf,
+					       size, actual, retval);
+	return retval;
+}
+#endif
+
+static errcode_t unix_cow_write_tdb(struct unix_cow_private_data * data,
+					ext2_loff_t location, int size)
+
+{
+	TDB_DATA	tdb_key, tdb_data;
+	errcode_t	retval = 0;
+	int		actual = 0, rsize = size;
+	ext2_loff_t cur_loc ;
+
+	if (data->tdb == NULL) {
+		/*
+		 * Transaction database not initialized
+		 */
+		return 0;
+	}
+
+	tdb_key.dptr = (unsigned char *)&location;
+	tdb_key.dsize = sizeof(location);
+
+	/* insert a new entry and refuse to overwrite an existing entry */
+	/* See if we have an entry already */
+	tdb_data = tdb_fetch(data->tdb, tdb_key);
+	if (tdb_data.dptr) {
+		if (tdb_data.dsize == size) {
+			/*
+			 * already we wrote something at this
+			 * location with the same size
+			 */
+			return 0;
+		} else {
+			/*
+			 * Write at the same location but with different size
+			 */
+			rsize = size - tdb_data.dsize ;
+			if (rsize < 0) {
+				/*
+				 * smaller chunk. return doing nothing
+				 */
+				return 0;
+			}
+			location += tdb_data.dsize;
+		}
+		free(tdb_data.dptr);
+	}
+
+	retval = ext2fs_get_mem(rsize, &(tdb_data.dptr));
+	if (retval) {
+		return retval;
+	}
+
+	if ((cur_loc = ext2fs_llseek(data->dev, 0, SEEK_CUR)) == -1) {
+		retval = errno ? errno : EXT2_ET_LLSEEK_FAILED;
+		goto error_out_lseek;
+	}
+
+	if (ext2fs_llseek(data->dev, location, SEEK_SET) != location) {
+		retval = errno ? errno : EXT2_ET_LLSEEK_FAILED;
+		goto error_out_lseek;
+	}
+
+	actual = read(data->dev, tdb_data.dptr, rsize);
+	if (actual != rsize) {
+		/*
+		 * eventhough it is read we still are doing a write
+		 * so return error that is related to write
+		 */
+		retval = EXT2_ET_SHORT_WRITE;
+		goto error_out;
+	}
+
+	tdb_data.dsize = rsize;
+
+#ifdef DEBUG
+	printf("Printing with key %lld data %x and size %d\n", location, tdb_data.dptr, rsize);
+#endif
+
+	retval = tdb_store(data->tdb, tdb_key, tdb_data, TDB_INSERT);
+	if (retval == -1) {
+		/* FIXME!! Not sure what should be the error */
+		retval = EXT2_ET_SHORT_WRITE;
+		goto error_out;
+
+	}
+
+error_out:
+	/* Move the location back */
+	if (ext2fs_llseek(data->dev, cur_loc, SEEK_SET) != cur_loc) {
+		retval = errno ? errno : EXT2_ET_LLSEEK_FAILED;
+		goto error_out;
+	}
+
+error_out_lseek:
+	free(tdb_data.dptr);
+	return retval;
+
+}
+static errcode_t raw_write_blk(io_channel channel,
+			       struct unix_cow_private_data *data,
+			       unsigned long block,
+			       int count, const void *buf)
+{
+	ssize_t		size;
+	ext2_loff_t	location;
+	int		actual = 0;
+	errcode_t	retval;
+	TDB_DATA	tdb_key, tdb_data;
+
+	if (count == 1)
+		size = channel->block_size;
+	else {
+		if (count < 0)
+			size = -count;
+		else
+			size = count * channel->block_size;
+	}
+
+	location = ((ext2_loff_t) block * channel->block_size) + data->offset;
+	if (ext2fs_llseek(data->dev, location, SEEK_SET) != location) {
+		retval = errno ? errno : EXT2_ET_LLSEEK_FAILED;
+		goto error_out;
+	}
+
+
+	/*
+	 * before writing to the location read the data from the location
+	 * and put it in the database. This will help us to replay the
+	 * database content in cae of crash later
+	 */
+	retval = unix_cow_write_tdb(data, location, size);
+	if (retval) {
+		goto error_out;
+	}
+
+	actual = write(data->dev, buf, size);
+	if (actual != size) {
+		retval = EXT2_ET_SHORT_WRITE;
+		goto error_out;
+	}
+	return 0;
+
+error_out:
+	if (channel->write_error)
+		retval = (channel->write_error)(channel, block, count, buf,
+						size, actual, retval);
+	return retval;
+}
+
+
+/*
+ * Here we implement the cache functions
+ */
+
+/* Allocate the cache buffers */
+static errcode_t alloc_cache(io_channel channel,
+			     struct unix_cow_private_data *data)
+{
+	errcode_t		retval;
+	struct unix_cache	*cache;
+	int			i;
+	
+	data->access_time = 0;
+	for (i=0, cache = data->cache; i < CACHE_SIZE; i++, cache++) {
+		cache->block = 0;
+		cache->access_time = 0;
+		cache->dirty = 0;
+		cache->in_use = 0;
+		if ((retval = ext2fs_get_mem(channel->block_size,
+					     &cache->buf)))
+			return retval;
+	}
+	return 0;
+}
+
+/* Free the cache buffers */
+static void free_cache(struct unix_cow_private_data *data)
+{
+	struct unix_cache	*cache;
+	int			i;
+	
+	data->access_time = 0;
+	for (i=0, cache = data->cache; i < CACHE_SIZE; i++, cache++) {
+		cache->block = 0;
+		cache->access_time = 0;
+		cache->dirty = 0;
+		cache->in_use = 0;
+		if (cache->buf)
+			ext2fs_free_mem(&cache->buf);
+		cache->buf = 0;
+	}
+}
+
+#ifndef NO_IO_CACHE
+/*
+ * Try to find a block in the cache.  If the block is not found, and
+ * eldest is a non-zero pointer, then fill in eldest with the cache
+ * entry to that should be reused.
+ */
+static struct unix_cache *find_cached_block(struct unix_cow_private_data *data,
+					    unsigned long block,
+					    struct unix_cache **eldest)
+{
+	struct unix_cache	*cache, *unused_cache, *oldest_cache;
+	int			i;
+	
+	unused_cache = oldest_cache = 0;
+	for (i=0, cache = data->cache; i < CACHE_SIZE; i++, cache++) {
+		if (!cache->in_use) {
+			if (!unused_cache)
+				unused_cache = cache;
+			continue;
+		}
+		if (cache->block == block) {
+			cache->access_time = ++data->access_time;
+			return cache;
+		}
+		if (!oldest_cache ||
+		    (cache->access_time < oldest_cache->access_time))
+			oldest_cache = cache;
+	}
+	if (eldest)
+		*eldest = (unused_cache) ? unused_cache : oldest_cache;
+	return 0;
+}
+
+/*
+ * Reuse a particular cache entry for another block.
+ */
+static void reuse_cache(io_channel channel, struct unix_cow_private_data *data,
+		 struct unix_cache *cache, unsigned long block)
+{
+	if (cache->dirty && cache->in_use)
+		raw_write_blk(channel, data, cache->block, 1, cache->buf);
+
+	cache->in_use = 1;
+	cache->dirty = 0;
+	cache->block = block;
+	cache->access_time = ++data->access_time;
+}
+
+/*
+ * Flush all of the blocks in the cache
+ */
+static errcode_t flush_cached_blocks(io_channel channel,
+				     struct unix_cow_private_data *data,
+				     int invalidate)
+
+{
+	struct unix_cache	*cache;
+	errcode_t		retval, retval2;
+	int			i;
+	
+	retval2 = 0;
+	for (i=0, cache = data->cache; i < CACHE_SIZE; i++, cache++) {
+		if (!cache->in_use)
+			continue;
+		
+		if (invalidate)
+			cache->in_use = 0;
+		
+		if (!cache->dirty)
+			continue;
+		
+		retval = raw_write_blk(channel, data,
+				       cache->block, 1, cache->buf);
+		if (retval)
+			retval2 = retval;
+		else
+			cache->dirty = 0;
+	}
+	return retval2;
+}
+#endif /* NO_IO_CACHE */
+
+static void unix_cow_setup_tdb(char *tdb_file,
+				struct unix_cow_private_data *data)
+{
+	errcode_t	retval;
+
+	data->tdb = tdb_open(tdb_file, 0, TDB_CLEAR_IF_FIRST,
+			   O_RDWR | O_CREAT | O_TRUNC, 0600);
+	return;
+
+}
+static errcode_t unix_cow_open(const char *name, int flags, io_channel *channel)
+{
+	io_channel	io = NULL;
+	struct unix_cow_private_data *data = NULL;
+	errcode_t	retval;
+	int		open_flags;
+	struct stat	st;
+#ifdef __linux__
+	struct 		utsname ut;
+#endif
+
+	if (name == 0)
+		return EXT2_ET_BAD_DEVICE_NAME;
+	retval = ext2fs_get_mem(sizeof(struct struct_io_channel), &io);
+	if (retval)
+		return retval;
+	memset(io, 0, sizeof(struct struct_io_channel));
+	io->magic = EXT2_ET_MAGIC_IO_CHANNEL;
+	retval = ext2fs_get_mem(sizeof(struct unix_cow_private_data), &data);
+	if (retval)
+		goto cleanup;
+
+	io->manager = unix_cow_io_manager;
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
+	memset(data, 0, sizeof(struct unix_cow_private_data));
+	data->magic = EXT2_ET_MAGIC_UNIX_IO_CHANNEL;
+
+	if ((retval = alloc_cache(io, data)))
+		goto cleanup;
+
+	open_flags = (flags & IO_FLAG_RW) ? O_RDWR : O_RDONLY;
+	if (flags & IO_FLAG_EXCLUSIVE)
+		open_flags |= O_EXCL;
+#ifdef HAVE_OPEN64
+	data->dev = open64(io->name, open_flags);
+#else
+	data->dev = open(io->name, open_flags);
+#endif
+	if (data->dev < 0) {
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
+	    (fstat(data->dev, &st) == 0) &&
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
+
+	*channel = io;
+	return 0;
+
+cleanup:
+	if (data) {
+		free_cache(data);
+		ext2fs_free_mem(&data);
+	}
+	if (io)
+		ext2fs_free_mem(&io);
+	return retval;
+}
+
+static errcode_t unix_cow_close(io_channel channel)
+{
+	struct unix_cow_private_data *data;
+	errcode_t	retval = 0;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct unix_cow_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	if (--channel->refcount > 0)
+		return 0;
+
+#ifndef NO_IO_CACHE
+	retval = flush_cached_blocks(channel, data, 0);
+#endif
+	if (data->tdb)
+		tdb_close(data->tdb);
+
+	if (close(data->dev) < 0)
+		retval = errno;
+	free_cache(data);
+
+	ext2fs_free_mem(&channel->private_data);
+	if (channel->name)
+		ext2fs_free_mem(&channel->name);
+	ext2fs_free_mem(&channel);
+	return retval;
+}
+
+static errcode_t unix_cow_set_blksize(io_channel channel, int blksize)
+{
+	struct unix_cow_private_data *data;
+	errcode_t		retval;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct unix_cow_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	if (channel->block_size != blksize) {
+#ifndef NO_IO_CACHE
+		if ((retval = flush_cached_blocks(channel, data, 0)))
+			return retval;
+#endif
+		
+		channel->block_size = blksize;
+		free_cache(data);
+		if ((retval = alloc_cache(channel, data)))
+			return retval;
+	}
+	return 0;
+}
+
+
+static errcode_t unix_cow_read_blk(io_channel channel, unsigned long block,
+			       int count, void *buf)
+{
+	struct unix_cow_private_data *data;
+	struct unix_cache *cache, *reuse[READ_DIRECT_SIZE];
+	errcode_t	retval;
+	char		*cp;
+	int		i, j;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct unix_cow_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+#ifdef NO_IO_CACHE
+	return raw_read_blk(channel, data, block, count, buf);
+#else
+	/*
+	 * If we're doing an odd-sized read or a very large read,
+	 * flush out the cache and then do a direct read.
+	 */
+	if (count < 0 || count > WRITE_DIRECT_SIZE) {
+		if ((retval = flush_cached_blocks(channel, data, 0)))
+			return retval;
+		return raw_read_blk(channel, data, block, count, buf);
+	}
+
+	cp = buf;
+	while (count > 0) {
+		/* If it's in the cache, use it! */
+		if ((cache = find_cached_block(data, block, &reuse[0]))) {
+#ifdef DEBUG
+			printf("Using cached block %lu\n", block);
+#endif
+			memcpy(cp, cache->buf, channel->block_size);
+			count--;
+			block++;
+			cp += channel->block_size;
+			continue;
+		}
+		/*
+		 * Find the number of uncached blocks so we can do a
+		 * single read request
+		 */
+		for (i=1; i < count; i++)
+			if (find_cached_block(data, block+i, &reuse[i]))
+				break;
+#ifdef DEBUG
+		printf("Reading %d blocks starting at %lu\n", i, block);
+#endif
+		if ((retval = raw_read_blk(channel, data, block, i, cp)))
+			return retval;
+		
+		/* Save the results in the cache */
+		for (j=0; j < i; j++) {
+			count--;
+			cache = reuse[j];
+			reuse_cache(channel, data, cache, block++);
+			memcpy(cache->buf, cp, channel->block_size);
+			cp += channel->block_size;
+		}
+	}
+	return 0;
+#endif /* NO_IO_CACHE */
+}
+
+static errcode_t unix_cow_write_blk(io_channel channel, unsigned long block,
+				int count, const void *buf)
+{
+	struct unix_cow_private_data *data;
+	struct unix_cache *cache, *reuse;
+	errcode_t	retval = 0;
+	const char	*cp;
+	int		writethrough;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct unix_cow_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+#ifdef NO_IO_CACHE
+	return raw_write_blk(channel, data, block, count, buf);
+#else	
+	/*
+	 * If we're doing an odd-sized write or a very large write,
+	 * flush out the cache completely and then do a direct write.
+	 */
+	if (count < 0 || count > WRITE_DIRECT_SIZE) {
+		if ((retval = flush_cached_blocks(channel, data, 1)))
+			return retval;
+		return raw_write_blk(channel, data, block, count, buf);
+	}
+
+	/*
+	 * For a moderate-sized multi-block write, first force a write
+	 * if we're in write-through cache mode, and then fill the
+	 * cache with the blocks.
+	 */
+	writethrough = channel->flags & CHANNEL_FLAGS_WRITETHROUGH;
+	if (writethrough)
+		retval = raw_write_blk(channel, data, block, count, buf);
+	
+	cp = buf;
+	while (count > 0) {
+		cache = find_cached_block(data, block, &reuse);
+		if (!cache) {
+			cache = reuse;
+			reuse_cache(channel, data, cache, block);
+		}
+		memcpy(cache->buf, cp, channel->block_size);
+		cache->dirty = !writethrough;
+		count--;
+		block++;
+		cp += channel->block_size;
+	}
+	return retval;
+#endif /* NO_IO_CACHE */
+}
+
+
+static errcode_t unix_cow_write_byte(io_channel channel, unsigned long offset,
+				 int size, const void *buf)
+{
+	struct unix_cow_private_data *data;
+	errcode_t	retval = 0;
+	ssize_t		actual;
+	ext2_loff_t	location;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct unix_cow_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+#ifndef NO_IO_CACHE
+	/*
+	 * Flush out the cache completely
+	 */
+	if ((retval = flush_cached_blocks(channel, data, 1)))
+		return retval;
+#endif
+
+	if (lseek(data->dev, offset + data->offset, SEEK_SET) < 0)
+		return errno;
+	
+	/*
+	 * before writing to the location read the data from the location
+	 * and put it in the database. This will help us to replay the
+	 * database content in cae of crash later
+	 */
+
+	location = offset + data->offset;
+	retval = unix_cow_write_tdb(data, location, size);
+	if (retval)
+		return retval;
+
+	actual = write(data->dev, buf, size);
+	if (actual != size)
+		return EXT2_ET_SHORT_WRITE;
+
+	return 0;
+}
+
+/*
+ * Flush data buffers to disk.  
+ */
+static errcode_t unix_cow_flush(io_channel channel)
+{
+	struct unix_cow_private_data *data;
+	errcode_t retval = 0;
+	
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct unix_cow_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+#ifndef NO_IO_CACHE
+	retval = flush_cached_blocks(channel, data, 0);
+#endif
+	fsync(data->dev);
+	return retval;
+}
+
+static errcode_t unix_cow_set_option(io_channel channel, const char *option, 
+				 const char *arg)
+{
+	struct unix_cow_private_data *data;
+	unsigned long tmp;
+	char *end;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct unix_cow_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	if (!strcmp(option, "offset")) {
+		if (!arg)
+			return EXT2_ET_INVALID_ARGUMENT;
+
+		tmp = strtoul(arg, &end, 0);
+		if (*end)
+			return EXT2_ET_INVALID_ARGUMENT;
+		data->offset = tmp;
+		return 0;
+	}
+	if (!strcmp(option, "tdbfilename")) {
+		if (!arg)
+			return EXT2_ET_INVALID_ARGUMENT;
+
+		data->tdb_file = strdup(arg);
+		/*
+		 * Initialize the database context
+		 * We need to do it in set_option because when
+		 * unix_cow_open is called we don't have the
+		 * tdb file name set.
+		 */
+		unix_cow_setup_tdb(data->tdb_file, data);
+		return 0;
+	}
+	return EXT2_ET_INVALID_ARGUMENT;
+}
-- 
1.5.2.rc0.71.g4342-dirty
