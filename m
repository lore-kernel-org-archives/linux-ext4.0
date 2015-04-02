From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 15/35] libext2fs: support atexit cleanups
Date: Wed, 01 Apr 2015 19:35:39 -0700
Message-ID: <20150402023539.25243.26702.stgit@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35619 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbbDBCfn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2015 22:35:43 -0400
In-Reply-To: <20150402023359.25243.79782.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use the atexit() function to provide a means for the library to clean
itself up on program exit.  This will be used by the undo IO manager
to flush the undo file state to disk if the program should terminate
without closing the io channel, since most e2fsprogs clients will
simply exit() when they hit errors.

This won't help for signal termination; client programs must set
up signal handlers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/Makefile.in |    8 +++
 lib/ext2fs/atexit.c    |  112 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2fsP.h   |    5 ++
 lib/ext2fs/undo_io.c   |   32 ++++++++++++--
 4 files changed, 154 insertions(+), 3 deletions(-)
 create mode 100644 lib/ext2fs/atexit.c


diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 367f440..e717ae0 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -57,6 +57,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	alloc_sb.o \
 	alloc_stats.o \
 	alloc_tables.o \
+	atexit.o \
 	badblocks.o \
 	bb_inode.o \
 	bitmaps.o \
@@ -133,6 +134,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/alloc_sb.c \
 	$(srcdir)/alloc_stats.c \
 	$(srcdir)/alloc_tables.c \
+	$(srcdir)/atexit.c \
 	$(srcdir)/badblocks.c \
 	$(srcdir)/bb_compat.c \
 	$(srcdir)/bb_inode.c \
@@ -639,6 +641,12 @@ alloc_tables.o: $(srcdir)/alloc_tables.c $(top_builddir)/lib/config.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h $(srcdir)/ext2fsP.h
+atexit.o: $(srcdir)/atexit.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
+ $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
+ $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h $(srcdir)/ext2fsP.h
 badblocks.o: $(srcdir)/badblocks.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fsP.h \
diff --git a/lib/ext2fs/atexit.c b/lib/ext2fs/atexit.c
new file mode 100644
index 0000000..5eba993
--- /dev/null
+++ b/lib/ext2fs/atexit.c
@@ -0,0 +1,112 @@
+/*
+ * atexit.c --- Clean things up when we exit normally.
+ *
+ * Copyright Oracle, 2014
+ * Author Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Library
+ * General Public License, version 2.
+ * %End-Header%
+ */
+
+#define _LARGEFILE_SOURCE
+#define _LARGEFILE64_SOURCE
+
+#include "config.h"
+#include <stdlib.h>
+
+#include "ext2_fs.h"
+#include "ext2fs.h"
+#include "ext2fsP.h"
+
+struct exit_data {
+	ext2_exit_fn func;
+	void *data;
+};
+
+static struct exit_data *items;
+static size_t nr_items;
+
+static void handle_exit(void)
+{
+	struct exit_data *ed;
+
+	for (ed = items + nr_items - 1; ed >= items; ed--) {
+		if (ed->func == NULL)
+			continue;
+		ed->func(ed->data);
+	}
+
+	ext2fs_free_mem(&items);
+	nr_items = 0;
+}
+
+/*
+ * Schedule a function to be called at (normal) program termination.
+ * If you want this to be called during a signal exit, you must capture
+ * the signal and call exit() yourself!
+ */
+errcode_t ext2fs_add_exit_fn(ext2_exit_fn func, void *data)
+{
+	struct exit_data *ed, *free_ed = NULL;
+	size_t x;
+	errcode_t ret;
+
+	if (func == NULL)
+		return EXT2_ET_INVALID_ARGUMENT;
+
+	for (x = 0, ed = items; x < nr_items; x++, ed++) {
+		if (ed->func == func && ed->data == data)
+			return EXT2_ET_FILE_EXISTS;
+		if (ed->func == NULL)
+			free_ed = ed;
+	}
+
+	if (free_ed) {
+		free_ed->func = func;
+		free_ed->data = data;
+		return 0;
+	}
+
+	if (nr_items == 0) {
+		ret = atexit(handle_exit);
+		if (ret)
+			return ret;
+	}
+
+	ret = ext2fs_resize_mem(0, (nr_items + 1) * sizeof(struct exit_data),
+				&items);
+	if (ret)
+		return ret;
+
+	items[nr_items].func = func;
+	items[nr_items].data = data;
+	nr_items++;
+
+	return 0;
+}
+
+/* Remove a function from the exit cleanup list. */
+errcode_t ext2fs_remove_exit_fn(ext2_exit_fn func, void *data)
+{
+	struct exit_data *ed;
+	size_t x;
+
+	if (func == NULL)
+		return EXT2_ET_INVALID_ARGUMENT;
+
+	for (x = 0, ed = items; x < nr_items; x++, ed++) {
+		if (ed->func == NULL)
+			return 0;
+		if (ed->func == func && ed->data == data) {
+			size_t sz = (nr_items - (x + 1)) *
+				    sizeof(struct exit_data);
+			memmove(ed, ed + 1, sz);
+			memset(items + nr_items - 1, 0,
+			       sizeof(struct exit_data));
+		}
+	}
+
+	return 0;
+}
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index f8c61e6..8de9d33 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -169,3 +169,8 @@ extern int ext2fs_mem_is_zero(const char *mem, size_t len);
 extern int ext2fs_file_block_offset_too_big(ext2_filsys fs,
 					    struct ext2_inode *inode,
 					    blk64_t offset);
+
+/* atexit support */
+typedef void (*ext2_exit_fn)(void *);
+errcode_t ext2fs_add_exit_fn(ext2_exit_fn fn, void *data);
+errcode_t ext2fs_remove_exit_fn(ext2_exit_fn fn, void *data);
diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
index f1c107a..df26e3e 100644
--- a/lib/ext2fs/undo_io.c
+++ b/lib/ext2fs/undo_io.c
@@ -41,6 +41,7 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "ext2fsP.h"
 
 #ifdef __GNUC__
 #define ATTR(x) __attribute__(x)
@@ -135,7 +136,7 @@ struct undo_private_data {
 
 	ext2fs_block_bitmap written_block_map;
 	struct struct_ext2_filsys fake_fs;
-
+	char *tdb_file;
 	struct undo_header hdr;
 };
 #define KEYS_PER_BLOCK(d) (((d)->tdb_data_size / sizeof(struct undo_key)) - 1)
@@ -662,6 +663,17 @@ out:
 	return retval;
 }
 
+static void undo_atexit(void *p)
+{
+	struct undo_private_data *data = p;
+	errcode_t err;
+
+	err = write_undo_indexes(data);
+	io_channel_close(data->undo_file);
+
+	com_err(data->tdb_file, err, "while force-closing undo file");
+}
+
 static errcode_t undo_open(const char *name, int flags, io_channel *channel)
 {
 	io_channel	io = NULL;
@@ -703,11 +715,16 @@ static errcode_t undo_open(const char *name, int flags, io_channel *channel)
 		if (retval)
 			goto cleanup;
 
-		undo_fd = ext2fs_open_file(tdb_file, O_RDWR | O_CREAT, 0600);
+		data->tdb_file = strdup(tdb_file);
+		if (data->tdb_file == NULL)
+			goto cleanup;
+		undo_fd = ext2fs_open_file(data->tdb_file, O_RDWR | O_CREAT,
+					   0600);
 		if (undo_fd < 0)
 			goto cleanup;
 
-		retval = undo_io_backing_manager->open(tdb_file, IO_FLAG_RW,
+		retval = undo_io_backing_manager->open(data->tdb_file,
+						       IO_FLAG_RW,
 						       &data->undo_file);
 		if (retval)
 			goto cleanup;
@@ -732,6 +749,9 @@ static errcode_t undo_open(const char *name, int flags, io_channel *channel)
 		if (retval)
 			goto cleanup;
 	}
+	retval = ext2fs_add_exit_fn(undo_atexit, data);
+	if (retval)
+		goto cleanup;
 
 	*channel = io;
 	if (undo_fd >= 0)
@@ -739,10 +759,13 @@ static errcode_t undo_open(const char *name, int flags, io_channel *channel)
 	return retval;
 
 cleanup:
+	ext2fs_remove_exit_fn(undo_atexit, data);
 	if (undo_fd >= 0)
 		close(undo_fd);
 	if (data && data->undo_file)
 		io_channel_close(data->undo_file);
+	if (data && data->tdb_file)
+		free(data->tdb_file);
 	if (data && data->real)
 		io_channel_close(data->real);
 	if (data)
@@ -769,11 +792,14 @@ static errcode_t undo_close(io_channel channel)
 	err = write_undo_indexes(data);
 	if (data->real)
 		retval = io_channel_close(data->real);
+	if (data->tdb_file)
+		free(data->tdb_file);
 	if (data->undo_file)
 		io_channel_close(data->undo_file);
 	ext2fs_free_mem(&data->keyb);
 	if (data->written_block_map)
 		ext2fs_free_generic_bitmap(data->written_block_map);
+	ext2fs_remove_exit_fn(undo_atexit, data);
 	ext2fs_free_mem(&channel->private_data);
 	if (channel->name)
 		ext2fs_free_mem(&channel->name);

