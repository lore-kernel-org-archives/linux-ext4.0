From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/35] undo-io: add new calls to and speed up the undo io
 manager
Date: Wed, 01 Apr 2015 19:35:06 -0700
Message-ID: <20150402023506.25243.44459.stgit@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48346 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbbDBCfK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2015 22:35:10 -0400
In-Reply-To: <20150402023359.25243.79782.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Implement pass-through calls for discard, zero-out, and readahead in
the IO manager so that we can take advantage of any underlying
support.

Furthermore, improve tdb write-out speed by disabling locking and only
fsyncing at the end -- we don't care about locking because having
multiple writers to the undo file will produce an undo database full
of garbage blocks; and we only need to fsync at the end because if we
fail before the end, our undo file will lack the necessary superblock
data that e2undo requires to do replay safely.  Without this, we call
fsync four times per tdb update(!)  This reduces the overhead of using
undo_io while converting a 2TB FS to metadata_csum from 3+ hours to 55
minutes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/tdb.c     |   10 ++++++
 lib/ext2fs/tdb.h     |    2 +
 lib/ext2fs/undo_io.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 97 insertions(+), 2 deletions(-)


diff --git a/lib/ext2fs/tdb.c b/lib/ext2fs/tdb.c
index 1d97685..7317288 100644
--- a/lib/ext2fs/tdb.c
+++ b/lib/ext2fs/tdb.c
@@ -4142,3 +4142,13 @@ int tdb_reopen_all(int parent_longlived)
 
 	return 0;
 }
+
+/**
+ * Flush a database file from the page cache.
+ **/
+int tdb_flush(struct tdb_context *tdb)
+{
+	if (tdb->fd != -1)
+		return fsync(tdb->fd);
+	return 0;
+}
diff --git a/lib/ext2fs/tdb.h b/lib/ext2fs/tdb.h
index 732ef0e..6a4086c 100644
--- a/lib/ext2fs/tdb.h
+++ b/lib/ext2fs/tdb.h
@@ -129,6 +129,7 @@ typedef struct TDB_DATA {
 #define tdb_lockall_nonblock ext2fs_tdb_lockall_nonblock
 #define tdb_lockall_read_nonblock ext2fs_tdb_lockall_read_nonblock
 #define tdb_lockall_unmark ext2fs_tdb_lockall_unmark
+#define tdb_flush ext2fs_tdb_flush
 
 /* this is the context structure that is returned from a db open */
 typedef struct tdb_context TDB_CONTEXT;
@@ -191,6 +192,7 @@ size_t tdb_map_size(struct tdb_context *tdb);
 int tdb_get_flags(struct tdb_context *tdb);
 void tdb_enable_seqnum(struct tdb_context *tdb);
 void tdb_increment_seqnum_nonblock(struct tdb_context *tdb);
+int tdb_flush(struct tdb_context *tdb);
 
 /* Low level locking functions: use with care */
 int tdb_chainlock(struct tdb_context *tdb, TDB_DATA key);
diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
index d6beb02..94317cb 100644
--- a/lib/ext2fs/undo_io.c
+++ b/lib/ext2fs/undo_io.c
@@ -37,6 +37,7 @@
 #if HAVE_SYS_RESOURCE_H
 #include <sys/resource.h>
 #endif
+#include <limits.h>
 
 #include "tdb.h"
 
@@ -354,8 +355,12 @@ static errcode_t undo_open(const char *name, int flags, io_channel *channel)
 		data->real = 0;
 	}
 
+	if (data->real)
+		io->flags = (io->flags & ~CHANNEL_FLAGS_DISCARD_ZEROES) |
+			    (data->real->flags & CHANNEL_FLAGS_DISCARD_ZEROES);
+
 	/* setup the tdb file */
-	data->tdb = tdb_open(tdb_file, 0, TDB_CLEAR_IF_FIRST,
+	data->tdb = tdb_open(tdb_file, 0, TDB_CLEAR_IF_FIRST | TDB_NOLOCK | TDB_NOSYNC,
 			     O_RDWR | O_CREAT | O_TRUNC | O_EXCL, 0600);
 	if (!data->tdb) {
 		retval = errno;
@@ -399,8 +404,10 @@ static errcode_t undo_close(io_channel channel)
 		return retval;
 	if (data->real)
 		retval = io_channel_close(data->real);
-	if (data->tdb)
+	if (data->tdb) {
+		tdb_flush(data->tdb);
 		tdb_close(data->tdb);
+	}
 	ext2fs_free_mem(&channel->private_data);
 	if (channel->name)
 		ext2fs_free_mem(&channel->name);
@@ -510,6 +517,77 @@ static errcode_t undo_write_byte(io_channel channel, unsigned long offset,
 	return retval;
 }
 
+static errcode_t undo_discard(io_channel channel, unsigned long long block,
+			      unsigned long long count)
+{
+	struct undo_private_data *data;
+	errcode_t	retval = 0;
+	int icount;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct undo_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	if (count > INT_MAX)
+		return EXT2_ET_UNIMPLEMENTED;
+	icount = count;
+
+	/*
+	 * First write the existing content into database
+	 */
+	retval = undo_write_tdb(channel, block, icount);
+	if (retval)
+		return retval;
+	if (data->real)
+		retval = io_channel_discard(data->real, block, count);
+
+	return retval;
+}
+
+static errcode_t undo_zeroout(io_channel channel, unsigned long long block,
+			      unsigned long long count)
+{
+	struct undo_private_data *data;
+	errcode_t	retval = 0;
+	int icount;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct undo_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	if (count > INT_MAX)
+		return EXT2_ET_UNIMPLEMENTED;
+	icount = count;
+
+	/*
+	 * First write the existing content into database
+	 */
+	retval = undo_write_tdb(channel, block, icount);
+	if (retval)
+		return retval;
+	if (data->real)
+		retval = io_channel_zeroout(data->real, block, count);
+
+	return retval;
+}
+
+static errcode_t undo_cache_readahead(io_channel channel,
+				      unsigned long long block,
+				      unsigned long long count)
+{
+	struct undo_private_data *data;
+	errcode_t	retval = 0;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct undo_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	if (data->real)
+		retval = io_channel_cache_readahead(data->real, block, count);
+
+	return retval;
+}
+
 /*
  * Flush data buffers to disk.
  */
@@ -522,6 +600,8 @@ static errcode_t undo_flush(io_channel channel)
 	data = (struct undo_private_data *) channel->private_data;
 	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
 
+	if (data->tdb)
+		tdb_flush(data->tdb);
 	if (data->real)
 		retval = io_channel_flush(data->real);
 
@@ -601,6 +681,9 @@ static struct struct_io_manager struct_undo_manager = {
 	.get_stats	= undo_get_stats,
 	.read_blk64	= undo_read_blk64,
 	.write_blk64	= undo_write_blk64,
+	.discard	= undo_discard,
+	.zeroout	= undo_zeroout,
+	.cache_readahead	= undo_cache_readahead,
 };
 
 io_manager undo_io_manager = &struct_undo_manager;

