From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/2] e2fsprogs: Add undo I/O manager
Date: Thu, 19 Jul 2007 23:28:07 +0530
Message-ID: <1184867892768-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11848678881380-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: tytso@mit.edu, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:45770 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbXGSR6Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jul 2007 13:58:25 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l6JILXam308564
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 04:21:33 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6JI1tS6177728
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 04:01:55 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6JHwMYt019651
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 03:58:22 +1000
In-Reply-To: <11848678881380-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <42dd5d5526f5d0009749a1d612da840a03d58722.1184867582.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

This I/O manager saves the contents of the location being overwritten
to a tdb database. This helps in undoing the changes done to the
file system.

The call sequence involve

set_undo_io_backing_manager(unix_io_manager);
set_undo_io_backup_file("/tmp/test.tdb");
retval = ext2fs_open2(dev_name, 0, flags,
		superblock, block_size, undo_io_manager,
		&current_fs);

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 lib/ext2fs/Makefile.in |    7 +-
 lib/ext2fs/ext2_io.h   |    5 +
 lib/ext2fs/undo_io.c   |  491 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 501 insertions(+), 2 deletions(-)
 create mode 100644 lib/ext2fs/undo_io.c

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 199164a..8644565 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -66,7 +66,8 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	unix_io.o \
 	unlink.o \
 	valid_blk.o \
-	version.o
+	version.o \
+	undo_io.o
 
 SRCS= ext2_err.c \
 	$(srcdir)/alloc.c \
@@ -134,7 +135,8 @@ SRCS= ext2_err.c \
 	$(srcdir)/tst_bitops.c \
 	$(srcdir)/tst_byteswap.c \
 	$(srcdir)/tst_getsize.c \
-	$(srcdir)/tst_iscan.c
+	$(srcdir)/tst_iscan.c \
+	$(srcdir)/undo_io.c
 
 HFILES= bitops.h ext2fs.h ext2_io.h ext2_fs.h ext2_ext_attr.h ext3_extents.h \
 	tdb.h
@@ -583,3 +585,4 @@ tst_iscan.o: $(srcdir)/tst_iscan.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
+undo_io.o: $(srcdir)/undo_io.c $(srcdir)/ext2_fs.h $(srcdir)/ext2fs.h
diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index eada278..476eb4d 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -96,6 +96,11 @@ extern errcode_t io_channel_write_byte(io_channel channel,
 /* unix_io.c */
 extern io_manager unix_io_manager;
 
+/* undo_io.c */
+extern io_manager undo_io_manager;
+extern errcode_t set_undo_io_backing_manager(io_manager manager);
+extern errcode_t set_undo_io_backup_file(char *file_name);
+
 /* test_io.c */
 extern io_manager test_io_manager, test_io_backing_manager;
 extern void (*test_io_cb_read_blk)
diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
new file mode 100644
index 0000000..ea37398
--- /dev/null
+++ b/lib/ext2fs/undo_io.c
@@ -0,0 +1,491 @@
+/*
+ * undo_io.c --- This is the undo io manager that copies the old data that
+ * copies the old data being overwritten into a tdb database
+ *
+ * Copyright IBM Corporation, 2007
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
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
+#include "tdb.h"
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
+
+struct undo_private_data {
+	int	magic;
+	TDB_CONTEXT *tdb;
+	char *tdb_file;
+
+	/* The backing io channel */
+	io_channel real;
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
+static io_manager undo_io_backing_manager ;
+static  char *tdb_file ;
+static int tdb_data_size = 0;
+
+errcode_t set_undo_io_backing_manager(io_manager manager)
+{
+	/*
+	 * We may want to do some validation later
+	 */
+	undo_io_backing_manager = manager;
+	return 0;
+}
+
+errcode_t set_undo_io_backup_file(char *file_name)
+{
+	tdb_file = strdup(file_name);
+
+	if (tdb_file == NULL) {
+		return EXT2_ET_NO_MEMORY;
+	}
+
+	return 0;
+}
+
+
+static errcode_t undo_write_tdb(io_channel channel,
+					unsigned long block, int count)
+
+{
+	int size, loop_count = 0, i;
+	unsigned long block_num, backing_blk_num;
+	errcode_t retval = 0;
+	ext2_loff_t offset;
+	struct undo_private_data *data;
+	TDB_DATA tdb_key, tdb_data;
+	char *read_ptr;
+
+	data = (struct undo_private_data *) channel->private_data;
+
+
+	if (data->tdb == NULL) {
+		/*
+		 * Transaction database not initialized
+		 */
+		return 0;
+	}
+
+	/*
+	 * Set the block size used to read for tdb
+	 */
+	if (!tdb_data_size)
+		tdb_data_size = channel->block_size;
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
+	/*
+	 * Data is stored in tdb database as blocks of tdb_data_size size
+	 * This helps in efficient lookup further.
+	 *
+	 * We divide the disk to blocks of tdb_data_size.
+	 */
+
+	block_num = ((block*channel->block_size)+data->offset)/tdb_data_size;
+
+
+	loop_count = (size + tdb_data_size -1)/tdb_data_size;
+
+	tdb_transaction_start(data->tdb);
+	for (i = 0; i < loop_count; i++) {
+
+		tdb_key.dptr = (unsigned char *)&block_num;
+		tdb_key.dsize = sizeof(block_num);
+
+		/*
+		 * Check if we have the record already
+		 */
+		if (tdb_exists(data->tdb, tdb_key)) {
+
+			/* Try the next block */
+			block_num++;
+			continue;
+		}
+
+		/*
+		 * Read one block using the backing I/O manager
+		 * The backing I/O manager block size may be
+		 * different from the tdb_data_size.
+		 * Also we need to recalcuate the block number with respect
+		 * to the backing I/O manager.
+		 */
+
+		offset = block_num * tdb_data_size;
+		backing_blk_num = (offset - data->offset) / channel->block_size;
+
+		count = tdb_data_size +
+				((offset - data->offset) % channel->block_size);
+
+		retval = ext2fs_get_mem(count, &read_ptr);
+		if (retval) {
+			tdb_transaction_cancel(data->tdb);
+			return retval;
+		}
+
+		memset(read_ptr, 0, count);
+
+		retval = io_channel_read_blk(data->real,
+						backing_blk_num,
+						-count, read_ptr);
+		if (retval) {
+			free(read_ptr);
+			tdb_transaction_cancel(data->tdb);
+			return retval;
+		}
+
+
+		tdb_data.dptr = read_ptr +
+				((offset - data->offset) % channel->block_size);
+
+		tdb_data.dsize = tdb_data_size;
+
+#ifdef DEBUG
+		printf("Printing with key %ld data %x and size %d\n",
+						block_num,
+						tdb_data.dptr, tdb_data_size);
+#endif
+
+		retval = tdb_store(data->tdb, tdb_key, tdb_data, TDB_INSERT);
+		if (retval == -1) {
+			/*
+			 * TDB_ERR_EXISTS cannot happen because we
+			 * have already verified it doesn't exist
+			 */
+			tdb_transaction_cancel(data->tdb);
+			retval = EXT2_ET_TDB_ERR_IO;
+			free(read_ptr);
+			return retval;
+
+		}
+		free(read_ptr);
+		/* Next block */
+		block_num++;
+	}
+
+	tdb_transaction_commit(data->tdb);
+
+
+	return retval;
+}
+
+static TDB_CONTEXT *undo_setup_tdb(char *tdb_file,
+				struct undo_private_data *data)
+{
+	errcode_t	retval;
+
+	data->tdb = tdb_open(tdb_file, 0, TDB_CLEAR_IF_FIRST,
+			   O_RDWR | O_CREAT | O_TRUNC, 0600);
+	return data->tdb;
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
+	if (undo_io_backing_manager) {
+		retval = undo_io_backing_manager->open(name, flags,
+						       &data->real);
+		if (retval)
+			goto cleanup;
+	} else {
+		data->real = 0;
+	}
+
+	/* setup the tdb file */
+	if (undo_setup_tdb(tdb_file, data) == NULL )
+		goto cleanup;
+
+	*channel = io;
+	return 0;
+
+cleanup:
+	if (data->real)
+		io_channel_close(data->real);
+
+	if (data)
+		ext2fs_free_mem(&data);
+
+	if (io)
+		ext2fs_free_mem(&io);
+
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
+	if (data->real)
+		retval = io_channel_close(data->real);
+
+	if (data->tdb)
+		tdb_close(data->tdb);
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
+	if (data->real)
+		retval = io_channel_set_blksize(data->real, blksize);
+
+	channel->block_size = blksize;
+	return retval;
+}
+
+
+static errcode_t undo_read_blk(io_channel channel, unsigned long block,
+			       int count, void *buf)
+{
+	errcode_t	retval;
+	struct undo_private_data *data;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct undo_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	if (data->real)
+		retval = io_channel_read_blk(data->real, block, count, buf);
+
+	return retval;
+}
+
+static errcode_t undo_write_blk(io_channel channel, unsigned long block,
+				int count, const void *buf)
+{
+	struct undo_private_data *data;
+	errcode_t	retval = 0;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct undo_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	/*
+	 * First write the existing content into database
+	 */
+	retval = undo_write_tdb(channel, block, count);
+	if (retval)
+		 return retval;
+
+
+	if (data->real)
+		retval = io_channel_write_blk(data->real, block, count, buf);
+
+	return retval;
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
+	unsigned long blk_num, count;;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct undo_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	location = offset + data->offset;
+	blk_num = location/channel->block_size;
+	/*
+	 * the size specified may spread across multiple blocks
+	 * also make sure we account for the fact that block start
+	 * offset for tdb is different from the backing I/O manager
+	 * due to possible different block size
+	 */
+	count = (size + (location % channel->block_size) +
+			channel->block_size  -1)/channel->block_size;
+
+	retval = undo_write_tdb(channel, blk_num, count);
+	if (retval)
+		return retval;
+
+	if (data->real && data->real->manager->write_byte)
+		retval = io_channel_write_byte(data->real, offset, size, buf);
+
+	return retval;
+}
+
+/*
+ * Flush data buffers to disk.
+ */
+static errcode_t undo_flush(io_channel channel)
+{
+	errcode_t	retval = 0;
+	struct undo_private_data *data;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct undo_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	if (data->real)
+		retval = io_channel_flush(data->real);
+
+	return retval;
+}
+
+static errcode_t undo_set_option(io_channel channel, const char *option,
+				 const char *arg)
+{
+	errcode_t	retval = 0;
+	struct undo_private_data *data;
+	unsigned long tmp;
+	char *end;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct undo_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	/*
+	 * Need to support offset option to work with
+	 * Unix I/O manager
+	 */
+	if (data->real && data->real->manager->set_option) {
+
+		retval = data->real->manager->set_option(data->real,
+							option, arg);
+	}
+
+	if (!retval && !strcmp(option, "offset")) {
+		if (!arg)
+			return EXT2_ET_INVALID_ARGUMENT;
+
+		tmp = strtoul(arg, &end, 0);
+		if (*end)
+			return EXT2_ET_INVALID_ARGUMENT;
+		data->offset = tmp;
+	}
+
+	return retval;
+}
-- 
1.5.3.rc2-dirty
