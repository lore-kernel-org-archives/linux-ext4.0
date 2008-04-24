From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] e2fsprogs: Fix undo-mgr to work with larger blocksize.
Date: Thu, 24 Apr 2008 15:26:17 +0530
Message-ID: <1209030977-3661-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:55176 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYDXJ4Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Apr 2008 05:56:24 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m3O9uHhZ021473
	for <linux-ext4@vger.kernel.org>; Thu, 24 Apr 2008 15:26:17 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3O9uBuo1310856
	for <linux-ext4@vger.kernel.org>; Thu, 24 Apr 2008 15:26:11 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m3O9uGSp011613
	for <linux-ext4@vger.kernel.org>; Thu, 24 Apr 2008 09:56:16 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Also make sure we use the right size whe
we have short reads from the backing manager.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 lib/ext2fs/undo_io.c |  106 ++++++++++++++++++++++++-------------------------
 1 files changed, 52 insertions(+), 54 deletions(-)

diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
index 9bee1b6..34b6d06 100644
--- a/lib/ext2fs/undo_io.c
+++ b/lib/ext2fs/undo_io.c
@@ -93,6 +93,7 @@ static struct struct_io_manager struct_undo_manager = {
 io_manager undo_io_manager = &struct_undo_manager;
 static io_manager undo_io_backing_manager ;
 static char *tdb_file;
+static int actual_size;
 
 errcode_t set_undo_io_backing_manager(io_manager manager)
 {
@@ -182,13 +183,14 @@ static errcode_t undo_write_tdb(io_channel channel,
 				unsigned long block, int count)
 
 {
-	int size, loop_count = 0, i;
+	int size, i;
 	unsigned long block_num, backing_blk_num;
 	errcode_t retval = 0;
 	ext2_loff_t offset;
 	struct undo_private_data *data;
 	TDB_DATA tdb_key, tdb_data;
 	char *read_ptr;
+	unsigned long end_block;
 
 	data = (struct undo_private_data *) channel->private_data;
 
@@ -207,36 +209,29 @@ static errcode_t undo_write_tdb(io_channel channel,
 		else
 			size = count * channel->block_size;
 	}
-
 	/*
 	 * Data is stored in tdb database as blocks of tdb_data_size size
 	 * This helps in efficient lookup further.
 	 *
 	 * We divide the disk to blocks of tdb_data_size.
 	 */
-
-	block_num = ((block*channel->block_size)+data->offset) /
-		data->tdb_data_size;
-
-	loop_count = (size + data->tdb_data_size -1) /
-		data->tdb_data_size;
+	offset = (block * channel->block_size) + data->offset ;
+	block_num = offset / data->tdb_data_size;
+	end_block = (offset + size) / data->tdb_data_size;
 
 	tdb_transaction_start(data->tdb);
-	for (i = 0; i < loop_count; i++) {
+	while (block_num <= end_block ) {
 
 		tdb_key.dptr = (unsigned char *)&block_num;
 		tdb_key.dsize = sizeof(block_num);
-
 		/*
 		 * Check if we have the record already
 		 */
 		if (tdb_exists(data->tdb, tdb_key)) {
-
 			/* Try the next block */
 			block_num++;
 			continue;
 		}
-
 		/*
 		 * Read one block using the backing I/O manager
 		 * The backing I/O manager block size may be
@@ -244,13 +239,11 @@ static errcode_t undo_write_tdb(io_channel channel,
 		 * Also we need to recalcuate the block number with respect
 		 * to the backing I/O manager.
 		 */
-
 		offset = block_num * data->tdb_data_size;
 		backing_blk_num = (offset - data->offset) / channel->block_size;
 
 		count = data->tdb_data_size +
 				((offset - data->offset) % channel->block_size);
-
 		retval = ext2fs_get_mem(count, &read_ptr);
 		if (retval) {
 			tdb_transaction_cancel(data->tdb);
@@ -258,28 +251,43 @@ static errcode_t undo_write_tdb(io_channel channel,
 		}
 
 		memset(read_ptr, 0, count);
-
+		actual_size = 0;
 		retval = io_channel_read_blk(data->real, backing_blk_num,
 					     -count, read_ptr);
 		if (retval) {
-			free(read_ptr);
-			tdb_transaction_cancel(data->tdb);
-			return retval;
+			if (retval != EXT2_ET_SHORT_READ) {
+				free(read_ptr);
+				tdb_transaction_cancel(data->tdb);
+				return retval;
+			}
+			/*
+			 * short read so update the record size
+			 * accordingly
+			 */
+			tdb_data.dsize = actual_size;
+		} else {
+			tdb_data.dsize = data->tdb_data_size;
 		}
-
 		tdb_data.dptr = read_ptr +
 				((offset - data->offset) % channel->block_size);
-
-		tdb_data.dsize = data->tdb_data_size;
-
 #ifdef DEBUG
 		printf("Printing with key %ld data %x and size %d\n",
 		       block_num,
 		       tdb_data.dptr,
-		       channel->tdb_data_size);
+		       tdb_data.dsize);
 #endif
-
-		data->tdb_written = 1;
+		if (!data->tdb_written) {
+			data->tdb_written = 1;
+			/* Write the blocksize to tdb file */
+			retval = write_block_size(data->tdb,
+						  data->tdb_data_size);
+			if (retval) {
+				tdb_transaction_cancel(data->tdb);
+				retval = EXT2_ET_TDB_ERR_IO;
+				free(read_ptr);
+				return retval;
+			}
+		}
 		retval = tdb_store(data->tdb, tdb_key, tdb_data, TDB_INSERT);
 		if (retval == -1) {
 			/*
@@ -290,18 +298,29 @@ static errcode_t undo_write_tdb(io_channel channel,
 			retval = EXT2_ET_TDB_ERR_IO;
 			free(read_ptr);
 			return retval;
-
 		}
 		free(read_ptr);
 		/* Next block */
 		block_num++;
 	}
-
 	tdb_transaction_commit(data->tdb);
 
 	return retval;
 }
 
+static errcode_t undo_io_read_error(io_channel channel,
+			unsigned long block, int count, void *data,
+			size_t size, int actual, errcode_t error)
+{
+	actual_size = actual;
+	return error;
+}
+
+static void undo_err_handler_init(io_channel channel)
+{
+	channel->read_error = undo_io_read_error;
+}
+
 static errcode_t undo_open(const char *name, int flags, io_channel *channel)
 {
 	io_channel	io = NULL;
@@ -353,19 +372,22 @@ static errcode_t undo_open(const char *name, int flags, io_channel *channel)
 		goto cleanup;
 	}
 
+	/*
+	 * setup err handler for read so that we know
+	 * when the backing manager fails do short read
+	 */
+	undo_err_handler_init(data->real);
+
 	*channel = io;
 	return 0;
 
 cleanup:
 	if (data->real)
 		io_channel_close(data->real);
-
 	if (data)
 		ext2fs_free_mem(&data);
-
 	if (io)
 		ext2fs_free_mem(&io);
-
 	return retval;
 }
 
@@ -380,18 +402,14 @@ static errcode_t undo_close(io_channel channel)
 
 	if (--channel->refcount > 0)
 		return 0;
-
 	/* Before closing write the file system identity */
 	retval = write_file_system_identity(channel, data->tdb);
 	if (retval)
 		return retval;
-
 	if (data->real)
 		retval = io_channel_close(data->real);
-
 	if (data->tdb)
 		tdb_close(data->tdb);
-
 	ext2fs_free_mem(&channel->private_data);
 	if (channel->name)
 		ext2fs_free_mem(&channel->name);
@@ -411,19 +429,12 @@ static errcode_t undo_set_blksize(io_channel channel, int blksize)
 
 	if (data->real)
 		retval = io_channel_set_blksize(data->real, blksize);
-
 	/*
 	 * Set the block size used for tdb
 	 */
 	if (!data->tdb_data_size) {
 		data->tdb_data_size = blksize;
-
-		/* Write it to tdb file */
-		retval = write_block_size(data->tdb, data->tdb_data_size);
-		if (retval)
-			return retval;
 	}
-
 	channel->block_size = blksize;
 	return retval;
 }
@@ -453,14 +464,12 @@ static errcode_t undo_write_blk(io_channel channel, unsigned long block,
 	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
 	data = (struct undo_private_data *) channel->private_data;
 	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
-
 	/*
 	 * First write the existing content into database
 	 */
 	retval = undo_write_tdb(channel, block, count);
 	if (retval)
 		 return retval;
-
 	if (data->real)
 		retval = io_channel_write_blk(data->real, block, count, buf);
 
@@ -490,11 +499,9 @@ static errcode_t undo_write_byte(io_channel channel, unsigned long offset,
 	 */
 	count = (size + (location % channel->block_size) +
 			channel->block_size  -1)/channel->block_size;
-
 	retval = undo_write_tdb(channel, blk_num, count);
 	if (retval)
 		return retval;
-
 	if (data->real && data->real->manager->write_byte)
 		retval = io_channel_write_byte(data->real, offset, size, buf);
 
@@ -540,16 +547,9 @@ static errcode_t undo_set_option(io_channel channel, const char *option,
 			return EXT2_ET_INVALID_ARGUMENT;
 		if (!data->tdb_data_size || !data->tdb_written) {
 			data->tdb_data_size = tmp;
-
-			/* Write it to tdb file */
-			retval = write_block_size(data->tdb,
-						  data->tdb_data_size);
-			if (retval)
-				return retval;
 		}
 		return 0;
 	}
-
 	/*
 	 * Need to support offset option to work with
 	 * Unix I/O manager
@@ -558,7 +558,6 @@ static errcode_t undo_set_option(io_channel channel, const char *option,
 		retval = data->real->manager->set_option(data->real,
 							option, arg);
 	}
-
 	if (!retval && !strcmp(option, "offset")) {
 		if (!arg)
 			return EXT2_ET_INVALID_ARGUMENT;
@@ -568,6 +567,5 @@ static errcode_t undo_set_option(io_channel channel, const char *option,
 			return EXT2_ET_INVALID_ARGUMENT;
 		data->offset = tmp;
 	}
