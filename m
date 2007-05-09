From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/2] Add undo I/O manager.
Date: Wed,  9 May 2007 13:42:18 +0530
Message-ID: <11786983434148-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11786983382211-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11786983412804-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:37426 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbXEIIMc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 04:12:32 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l498WAMF191864
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 18:32:10 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.250.243])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l498FvvB169602
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 18:15:59 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l498CP6W024959
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 18:12:25 +1000
In-Reply-To: <11786983412804-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <cd9cd245faaef0628edabe875c507543f3195991.1178698029.git.aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <d286e4520f717821cf2363ff3c71a9fff5ecad2f.1178698029.git.aneesh.kumar@linux.vnet.ibm.com>
References: <d286e4520f717821cf2363ff3c71a9fff5ecad2f.1178698029.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

This I/O manager saves the contents of the location being overwritten
to a tdb database. This helps in undoing the changes done to the
file system.


This can be stacked over unix I/O manager to get the undo functionality.


Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 lib/ext2fs/Makefile.in |   10 +-
 lib/ext2fs/ext2_io.h   |    3 +
 lib/ext2fs/undo_io.c   |  443 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 454 insertions(+), 2 deletions(-)
 create mode 100644 lib/ext2fs/undo_io.c

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index f5d141a..669d4e7 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -67,7 +67,8 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	unlink.o \
 	valid_blk.o \
 	version.o \
-	stack_io.o
+	stack_io.o \
+	undo_io.o
 
 SRCS= ext2_err.c \
 	$(srcdir)/alloc.c \
@@ -136,7 +137,8 @@ SRCS= ext2_err.c \
 	$(srcdir)/tst_byteswap.c \
 	$(srcdir)/tst_getsize.c \
 	$(srcdir)/tst_iscan.c \
-	$(srcdir)/stack_io.c
+	$(srcdir)/stack_io.c  \
+	$(srcdir)/undo_io.c
 
 HFILES= bitops.h ext2fs.h ext2_io.h ext2_fs.h ext2_ext_attr.h ext3_extents.h
 HFILES_IN=  ext2_err.h ext2_types.h
@@ -556,3 +558,7 @@ stack_io.o: $(srcdir)/stack_io.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
+undo_io.o: $(srcdir)/undo_io.c $(srcdir)/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
+ $(srcdir)/ext2_fs.h $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index 65a294e..78ea27c 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -100,6 +100,9 @@ extern io_manager unix_io_manager;
 extern struct struct_io_manager *stack_io_manager_init(void);
 extern errcode_t stack_push_io_manager(struct struct_io_manager *stack,
 						struct  struct_io_manager *io);
+/* undo_io.c */
+extern io_manager undo_io_manager;
+
 /* test_io.c */
 extern io_manager test_io_manager, test_io_backing_manager;
 extern void (*test_io_cb_read_blk)
diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
new file mode 100644
index 0000000..01fa34f
--- /dev/null
+++ b/lib/ext2fs/undo_io.c
@@ -0,0 +1,443 @@
+/*
+ * undo_io.c --- This is the undo io manager that copies the old data that
+ * copies the old data being overwritten into a tdb database
+ *
+ * Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001,
+ *	2002 by Theodore Ts'o.
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
+
+struct undo_private_data {
+	int	magic;
+	TDB_CONTEXT *tdb;
+	char *tdb_file;
+
+	/* device from from which data should be read */
+	int	dev;
+
+	/* to support offset in unix I/O manager */
+	ext2_loff_t offset;
+};
+
+static errcode_t undo_open(const char *name, int flags, io_channel *channel);
+static errcode_t undo_close(io_channel channel);
+static errcode_t undo_set_blksize(io_channel channel, int blksize);
+static errcode_t undo_read_blk(io_channel channel, unsigned long block,
+			       int count, void *data);
+static errcode_t undo_write_blk(io_channel channel, unsigned long block,
+				int count, const void *data);
+static errcode_t undo_flush(io_channel channel);
+static errcode_t undo_write_byte(io_channel channel, unsigned long offset,
+				int size, const void *data);
+static errcode_t undo_set_option(io_channel channel, const char *option, 
+				 const char *arg);
+
+static struct struct_io_manager struct_undo_manager = {
+	EXT2_ET_MAGIC_IO_MANAGER,
+	"Undo I/O Manager",
+	undo_open,
+	undo_close,
+	undo_set_blksize,
+	undo_read_blk,
+	undo_write_blk,
+	undo_flush,
+	undo_write_byte,
+	undo_set_option
+};
+
+io_manager undo_io_manager = &struct_undo_manager;
+
+static int is_trans_overlapping(TDB_CONTEXT *tdb,
+			ext2_loff_t *location, int *size)
+{
+
+	ext2_loff_t req_loc, cur_loc;
+	int req_size, cur_size;
+	TDB_DATA key, data;
+
+restart:
+	req_loc = *location;
+	req_size = *size;
+
+	/* loop through the existing entries and find if they overlap */
+	for (key = tdb_firstkey(tdb); key.dptr; key = tdb_nextkey(tdb, key)) {
+		data = tdb_fetch(tdb, key);
+		/*
+		 * we are not interested in the data
+		 */
+		free(data.dptr);
+
+		cur_loc = *(ext2_loff_t *)key.dptr;
+		cur_size = data.dsize;
+
+		if (req_loc < cur_loc)
+			continue;
+
+		if(req_loc >= cur_loc + cur_size)
+			continue;
+
+		if (req_loc + req_size < cur_loc + cur_size) {
+			/*
+			 * The old entry completely overlap
+			 * with the new entry. So no need
+			 * to add new entries
+			 */
+			return 1;
+		}
+
+		/*
+		 * We have partial overlapping entry
+		 * update location and new size
+		 */
+
+		*location  = cur_loc + cur_size;
+		*size = req_loc + req_size - (*location);
+		/*
+		 * Now we need to check whether the new value of
+		 * location and size are overlapping
+		 */
+		goto restart;
+	}
+
+	/* Not a overlapping entry */
+	return 0;
+
+}
+
+static errcode_t undo_write_tdb(struct undo_private_data * data,
+					ext2_loff_t location, int size)
+
+{
+	TDB_DATA	tdb_key, tdb_data;
+	errcode_t	retval = 0;
+	int		actual = 0;
+	ext2_loff_t cur_loc ;
+
+	if (data->tdb == NULL) {
+		/*
+		 * Transaction database not initialized
+		 */
+		return 0;
+	}
+
+	if (is_trans_overlapping(data->tdb, &location, &size)) {
+		/*
+		 * Already we have the original contents
+		 * in the database. So skip this write
+		 */
+		return 0;
+	}
+
+	tdb_key.dptr = (unsigned char *)&location;
+	tdb_key.dsize = sizeof(location);
+
+	retval = ext2fs_get_mem(size, &(tdb_data.dptr));
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
+	actual = read(data->dev, tdb_data.dptr, size);
+	if (actual != size) {
+		/*
+		 * eventhough it is read we still are doing a write
+		 * so return error that is related to write
+		 */
+		retval = EXT2_ET_SHORT_WRITE;
+		goto error_out;
+	}
+
+	tdb_data.dsize = size;
+
+#ifdef DEBUG
+	printf("Printing with key %lld data %x and size %d\n", location, tdb_data.dptr, size);
+#endif
+	// I have libtdb1. Enable after rebasing to latest e2fsprogs that has this API
+	//tdb_transaction_start(data->tdb);
+
+	retval = tdb_store(data->tdb, tdb_key, tdb_data, TDB_INSERT);
+	if (retval == -1) {
+		/* FIXME!! Not sure what should be the error */
+		//tdb_transaction_cancel(data->tdb);
+		retval = EXT2_ET_SHORT_WRITE;
+		goto error_out;
+
+	}
+	//tdb_transaction_commit(data->tdb);
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
+
+static void undo_setup_tdb(char *tdb_file,
+				struct undo_private_data *data)
+{
+	errcode_t	retval;
+
+	data->tdb = tdb_open(tdb_file, 0, TDB_CLEAR_IF_FIRST,
+			   O_RDWR | O_CREAT | O_TRUNC, 0600);
+	return;
+
+}
+static errcode_t undo_open(const char *name, int flags, io_channel *channel)
+{
+	io_channel	io = NULL;
+	struct undo_private_data *data = NULL;
+	errcode_t	retval;
+	int		open_flags;
+	struct stat	st;
+
+	if (name == 0)
+		return EXT2_ET_BAD_DEVICE_NAME;
+	retval = ext2fs_get_mem(sizeof(struct struct_io_channel), &io);
+	if (retval)
+		return retval;
+	memset(io, 0, sizeof(struct struct_io_channel));
+	io->magic = EXT2_ET_MAGIC_IO_CHANNEL;
+	retval = ext2fs_get_mem(sizeof(struct undo_private_data), &data);
+	if (retval)
+		goto cleanup;
+
+	io->manager = undo_io_manager;
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
+	memset(data, 0, sizeof(struct undo_private_data));
+	data->magic = EXT2_ET_MAGIC_UNIX_IO_CHANNEL;
+
+#ifdef HAVE_OPEN64
+	data->dev = open64(io->name, O_RDONLY);
+#else
+	data->dev = open(io->name, O_RDONLY);
+#endif
+	if (data->dev < 0) {
+		retval = errno;
+		goto cleanup;
+	}
+
+	*channel = io;
+	return 0;
+
+cleanup:
+	if (data) {
+		ext2fs_free_mem(&data);
+	}
+	if (io)
+		ext2fs_free_mem(&io);
+	return retval;
+}
+
+static errcode_t undo_close(io_channel channel)
+{
+	struct undo_private_data *data;
+	errcode_t	retval = 0;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct undo_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	if (--channel->refcount > 0)
+		return 0;
+
+	if (data->tdb)
+		tdb_close(data->tdb);
+
+	if (close(data->dev) < 0)
+		retval = errno;
+
+	ext2fs_free_mem(&channel->private_data);
+	if (channel->name)
+		ext2fs_free_mem(&channel->name);
+	ext2fs_free_mem(&channel);
+
+	return retval;
+}
+
+static errcode_t undo_set_blksize(io_channel channel, int blksize)
+{
+	struct undo_private_data *data;
+	errcode_t		retval;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct undo_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	channel->block_size = blksize;
+	return 0;
+}
+
+
+static errcode_t undo_read_blk(io_channel channel, unsigned long block,
+			       int count, void *buf)
+{
+	return 0;
+}
+
+static errcode_t undo_write_blk(io_channel channel, unsigned long block,
+				int count, const void *buf)
+{
+	struct undo_private_data *data;
+	errcode_t	retval = 0;
+	ssize_t		size;
+	ext2_loff_t	location;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct undo_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
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
+
+	retval = undo_write_tdb(data, location, size);
+	if (retval) {
+		 return retval;
+	}
+
+	return 0;
+
+}
+
+static errcode_t undo_write_byte(io_channel channel, unsigned long offset,
+				 int size, const void *buf)
+{
+	struct undo_private_data *data;
+	errcode_t	retval = 0;
+	ssize_t		actual;
+	ext2_loff_t	location;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct undo_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	location = offset + data->offset;
+	retval = undo_write_tdb(data, location, size);
+	if (retval)
+		return retval;
+
+	return 0;
+}
+
+/*
+ * Flush data buffers to disk.  
+ */
+static errcode_t undo_flush(io_channel channel)
+{
+	return 0;
+}
+
+static errcode_t undo_set_option(io_channel channel, const char *option, 
+				 const char *arg)
+{
+	struct undo_private_data *data;
+	unsigned long tmp;
+	char *end;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct undo_private_data *) channel->private_data;
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
+
+	if (!strcmp(option, "tdbfilename")) {
+		if (!arg)
+			return EXT2_ET_INVALID_ARGUMENT;
+
+		data->tdb_file = strdup(arg);
+		/*
+		 * Initialize the database context
+		 * We need to do it in set_option because when
+		 * undo_open is called we don't have the
+		 * tdb file name set.
+		 */
+		undo_setup_tdb(data->tdb_file, data);
+		return 0;
+	}
+	return EXT2_ET_INVALID_ARGUMENT;
+}
-- 
1.5.2.rc0.71.g4342-dirty
