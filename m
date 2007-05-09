From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/2] Add stack I/O manager.
Date: Wed,  9 May 2007 13:59:14 +0530
Message-ID: <1178699354690-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:46940 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbXEII3W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 04:29:22 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l498V3hn4341828
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 18:31:03 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l498WmWi176742
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 18:32:48 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l498TGVm021523
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 18:29:16 +1000
Message-Id: <d286e4520f717821cf2363ff3c71a9fff5ecad2f.1178698029.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


This I/O manager helps in stacking different I/O managers.
For example one can stack the undo I/O manager on top
of Unix I/O manager to achieve the undo functionality.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 lib/ext2fs/Makefile.in |   10 +-
 lib/ext2fs/ext2_io.h   |    4 +
 lib/ext2fs/stack_io.c  |  419 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 431 insertions(+), 2 deletions(-)
 create mode 100644 lib/ext2fs/stack_io.c

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 799659e..f5d141a 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -66,7 +66,8 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	unix_io.o \
 	unlink.o \
 	valid_blk.o \
-	version.o
+	version.o \
+	stack_io.o
 
 SRCS= ext2_err.c \
 	$(srcdir)/alloc.c \
@@ -134,7 +135,8 @@ SRCS= ext2_err.c \
 	$(srcdir)/tst_bitops.c \
 	$(srcdir)/tst_byteswap.c \
 	$(srcdir)/tst_getsize.c \
-	$(srcdir)/tst_iscan.c
+	$(srcdir)/tst_iscan.c \
+	$(srcdir)/stack_io.c
 
 HFILES= bitops.h ext2fs.h ext2_io.h ext2_fs.h ext2_ext_attr.h ext3_extents.h
 HFILES_IN=  ext2_err.h ext2_types.h
@@ -550,3 +552,7 @@ tst_iscan.o: $(srcdir)/tst_iscan.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
+stack_io.o: $(srcdir)/stack_io.c $(srcdir)/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
+ $(srcdir)/ext2_fs.h $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index eada278..65a294e 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -96,6 +96,10 @@ extern errcode_t io_channel_write_byte(io_channel channel,
 /* unix_io.c */
 extern io_manager unix_io_manager;
 
+/* stack_io.c */
+extern struct struct_io_manager *stack_io_manager_init(void);
+extern errcode_t stack_push_io_manager(struct struct_io_manager *stack,
+						struct  struct_io_manager *io);
 /* test_io.c */
 extern io_manager test_io_manager, test_io_backing_manager;
 extern void (*test_io_cb_read_blk)
diff --git a/lib/ext2fs/stack_io.c b/lib/ext2fs/stack_io.c
new file mode 100644
index 0000000..5adfe4d
--- /dev/null
+++ b/lib/ext2fs/stack_io.c
@@ -0,0 +1,419 @@
+/*
+ * stack_io.c --- This is the io manager used to stack different io managers.
+ *
+ * Copyright (C) 1996 Theodore Ts'o.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include <stdio.h>
+#include <string.h>
+#if HAVE_UNISTD_H
+#include <unistd.h>
+#endif
+#include <fcntl.h>
+#include <time.h>
+#if HAVE_SYS_STAT_H
+#include <sys/stat.h>
+#endif
+#if HAVE_SYS_TYPES_H
+#include <sys/types.h>
+#endif
+#ifdef HAVE_SYS_PRCTL_H
+#include <sys/prctl.h>
+#else
+#define PR_GET_DUMPABLE 3
+#endif
+#if (!defined(HAVE_PRCTL) && defined(linux))
+#include <sys/syscall.h>
+#endif
+
+#include "ext2_fs.h"
+#include "ext2fs.h"
+#include "kernel-list.h"
+
+/*
+ * For checking structure magic numbers...
+ */
+
+#define EXT2_CHECK_MAGIC(struct, code) \
+	  if ((struct)->magic != (code)) return (code)
+
+#define EXT2_ET_MAGIC_STACK_IO_CHANNEL     (2133571428L)
+
+struct stack_private_data {
+	int	magic;
+	struct list_head st_elements;
+};
+
+struct stack_element {
+	struct struct_io_manager *io;
+	struct struct_io_channel *channel;
+	struct list_head  list;
+};
+
+
+static errcode_t stack_open(const char *name, int flags, io_channel *channel);
+static errcode_t stack_close(io_channel channel);
+static errcode_t stack_set_blksize(io_channel channel, int blksize);
+static errcode_t stack_read_blk(io_channel channel, unsigned long block,
+			       int count, void *data);
+static errcode_t stack_write_blk(io_channel channel, unsigned long block,
+				int count, const void *data);
+static errcode_t stack_flush(io_channel channel);
+static errcode_t stack_write_byte(io_channel channel, unsigned long offset,
+				 int count, const void *buf);
+static errcode_t stack_set_option(io_channel channel, const char *option, 
+				 const char *arg);
+
+static struct struct_io_manager struct_stack_manager = {
+	.magic		= EXT2_ET_MAGIC_IO_MANAGER,
+	.name		= "Stack I/O Manager",
+	.open		= stack_open,
+	.close		= stack_close,
+	.set_blksize	= stack_set_blksize,
+	.read_blk	= stack_read_blk,
+	.write_blk	= stack_write_blk,
+	.flush		= stack_flush,
+	.write_byte	= stack_write_byte,
+	.set_option	= stack_set_option,
+};
+
+io_manager stack_io_manager = &struct_stack_manager;
+/* FIXME!! get rid of this. not thread safe */
+static struct stack_private_data private_data;
+struct struct_io_manager *stack_io_manager_init(void)
+{
+
+
+	INIT_LIST_HEAD(&(private_data.st_elements));
+	private_data.magic	=  EXT2_ET_MAGIC_STACK_IO_CHANNEL;
+
+	return stack_io_manager;
+
+}
+
+errcode_t stack_push_io_manager(struct struct_io_manager *stack, struct  struct_io_manager *io)
+{
+	errcode_t	retval;
+	(void)(stack);
+	struct stack_element *element;
+	retval = ext2fs_get_mem(sizeof(struct stack_element), &element);
+	if (retval)
+		return retval;
+	element->io = io;
+	list_add(&(element->list), &(private_data.st_elements));
+
+	return 0;
+}
+
+
+static errcode_t stack_open(const char *name, int flags, io_channel *channel)
+{
+	io_channel	io = NULL, stack_io_channel = NULL;
+	errcode_t	retval;
+	char		*value;
+	struct list_head *entry;
+	struct stack_element *element;
+
+	if (name == 0)
+		return EXT2_ET_BAD_DEVICE_NAME;
+	retval = ext2fs_get_mem(sizeof(struct struct_io_channel), &io);
+	if (retval)
+		return retval;
+	memset(io, 0, sizeof(struct struct_io_channel));
+	io->magic = EXT2_ET_MAGIC_IO_CHANNEL;
+
+	io->manager = stack_io_manager;
+	retval = ext2fs_get_mem(strlen(name)+1, &io->name);
+	if (retval)
+		goto cleanup;
+
+	strcpy(io->name, name);
+	io->private_data = &(private_data);
+	io->block_size = 1024;
+	io->read_error = 0;
+	io->write_error = 0;
+	io->refcount = 1;
+
+	/*
+	 * Now call all the io managers open routine
+	 */
+	list_for_each(entry, &(private_data.st_elements)) {
+
+		element = list_entry(entry, struct stack_element, list);
+		if (element->io) {
+			retval = element->io->open(name, flags,
+							&stack_io_channel);
+			if (retval) {
+				/*
+				 * FIXME!! we need cleanup previous
+				 * successfull I/O manager open
+				 */
+				goto cleanup;
+			}
+		}
+		element->channel = stack_io_channel;
+	}
+
+	*channel = io;
+	return 0;
+
+cleanup:
+	if (io)
+		ext2fs_free_mem(&io);
+	return retval;
+}
+
+static errcode_t stack_io_channel_close(io_channel channel)
+{
+	if (channel && channel->manager->close)
+		return channel->manager->close(channel);
+
+	return 0;
+
+}
+
+static errcode_t stack_close(io_channel channel)
+{
+	struct stack_private_data *data;
+	struct list_head *entry;
+	struct stack_element *element;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct stack_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_STACK_IO_CHANNEL);
+
+	if (--channel->refcount > 0)
+		return 0;
+
+	list_for_each(entry, &(data->st_elements)) {
+		element = list_entry(entry, struct stack_element, list);
+		stack_io_channel_close(element->channel);
+	}
+
+	if (channel->name)
+		ext2fs_free_mem(&channel->name);
+	ext2fs_free_mem(&channel);
+
+	return 0;
+}
+
+static errcode_t stack_io_channel_set_blksize(io_channel channel, int blksize)
+{
+	if (channel && channel->manager->set_blksize)
+		return channel->manager->set_blksize(channel, blksize);
+
+	return 0;
+
+}
+static errcode_t stack_set_blksize(io_channel channel, int blksize)
+{
+	struct stack_private_data *data;
+	struct list_head *entry;
+	struct stack_element *element;
+	errcode_t	retval = 0;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct stack_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_STACK_IO_CHANNEL);
+
+	list_for_each(entry, &(data->st_elements)) {
+		element = list_entry(entry, struct stack_element, list);
+		retval = stack_io_channel_set_blksize(element->channel, blksize);
+		if (retval)
+			return retval;
+	}
+
+	channel->block_size = blksize;
+	return retval;
+}
+
+#define list_for_each_prev(pos, head) \
+	        for (pos = (head)->prev;  pos != (head); \
+				                pos = pos->prev)
+
+static errcode_t stack_io_channel_read_blk(io_channel channel,
+		unsigned long block, int count, void *buf)
+{
+	if (channel && channel->manager->read_blk)
+		return channel->manager->read_blk(channel,
+						block, count, buf);
+
+	return 0;
+}
+static errcode_t stack_read_blk(io_channel channel, unsigned long block,
+			       int count, void *buf)
+{
+	struct stack_private_data *data;
+	struct list_head *entry;
+	struct stack_element *element;
+	errcode_t	retval = 0;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct stack_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_STACK_IO_CHANNEL);
+
+	/*
+	 * we should read int the reverse order
+	 */
+	list_for_each_prev(entry, &(data->st_elements)) {
+		element = list_entry(entry, struct stack_element, list);
+		retval = stack_io_channel_read_blk(element->channel, block, count, buf);
+		if (retval)
+			return retval;
+	}
+
+	return retval;
+}
+
+static errcode_t stack_io_channel_write_blk(io_channel channel,
+		unsigned long block, int count, const void *buf)
+{
+	if (channel && channel->manager->write_blk)
+		return channel->manager->write_blk(channel,
+						block, count, buf);
+
+	return 0;
+}
+static errcode_t stack_write_blk(io_channel channel, unsigned long block,
+			       int count, const void *buf)
+{
+	struct stack_private_data *data;
+	struct list_head *entry;
+	struct stack_element *element;
+	errcode_t	retval = 0;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct stack_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_STACK_IO_CHANNEL);
+
+	list_for_each(entry, &(data->st_elements)) {
+		element = list_entry(entry, struct stack_element, list);
+		retval = stack_io_channel_write_blk(element->channel, block, count, buf);
+		if (retval)
+			return retval;
+	}
+
+	return retval;
+}
+
+static errcode_t stack_io_channel_write_byte(io_channel channel,
+		unsigned long offset, int count, const void *buf)
+{
+	if (channel && channel->manager->write_byte)
+		return channel->manager->write_byte(channel,
+						offset, count, buf);
+
+	return 0;
+}
+
+static errcode_t stack_write_byte(io_channel channel, unsigned long offset,
+			       int count, const void *buf)
+{
+	struct stack_private_data *data;
+	struct list_head *entry;
+	struct stack_element *element;
+	errcode_t	retval = 0;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct stack_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_STACK_IO_CHANNEL);
+
+	list_for_each(entry, &(data->st_elements)) {
+		element = list_entry(entry, struct stack_element, list);
+		retval = stack_io_channel_write_byte(element->channel, offset, count, buf);
+		if (retval)
+			return retval;
+	}
+
+	return retval;
+}
+
+static errcode_t stack_io_channel_flush(io_channel channel)
+{
+	if (channel && channel->manager->flush)
+		return channel->manager->flush(channel);
+
+	return 0;
+
+}
+
+/*
+ * Flush data buffers to disk.
+ */
+static errcode_t stack_flush(io_channel channel)
+{
+	struct stack_private_data *data;
+	struct list_head *entry;
+	struct stack_element *element;
+	errcode_t	retval = 0;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct stack_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_STACK_IO_CHANNEL);
+
+	list_for_each(entry, &(data->st_elements)) {
+		element = list_entry(entry, struct stack_element, list);
+		retval = stack_io_channel_flush(element->channel);
+		if (retval)
+			return retval;
+	}
+
+	return retval;
+}
+
+
+static errcode_t stack_io_channel_set_option(io_channel channel,
+				 const char *option, const char *arg)
+{
+	if (channel && channel->manager->set_option)
+		return channel->manager->set_option(channel,
+						option, arg);
+
+	return 0;
+
+}
+static errcode_t stack_set_option(io_channel channel, const char *option,
+				 const char *arg)
+{
+	struct stack_private_data *data;
+	struct list_head *entry;
+	struct stack_element *element;
+	errcode_t	retval = 0;
+	struct struct_io_manager *io_mng;
+	int success;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct stack_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_STACK_IO_CHANNEL);
+
+	list_for_each(entry, &(data->st_elements)) {
+		element = list_entry(entry, struct stack_element, list);
+		retval = stack_io_channel_set_option(element->channel,
+							option, arg);
+		if (retval == 0) {
+			success = 1;
+			continue;
+		}
+
+		if (retval == EXT2_ET_INVALID_ARGUMENT) {
+			/*
+			 * this may be the option for some other io manager
+			 * if everybody said EXT2_ET_INVALID_ARGUMENT
+			 * then we will return that
+			 */
+			continue;
+		} else  {
+			return retval;
+		}
+	}
+
+	if (success)
+		return 0;
+
+	return retval;
+}
-- 
1.5.2.rc0.71.g4342-dirty
