From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 31/54] undo-io: use a bitmap to track what we've already
 written
Date: Mon, 26 Jan 2015 23:38:56 -0800
Message-ID: <20150127073856.13308.93629.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46878 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbbA0HjA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:39:00 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It's really inefficient to (ab)use the TDB key store as a bitmap to
find out if we've already written a block to the undo file, because
the tdb code is reads the database key btree disk blocks for *every*
query.  Changing that logic to a bitmap reduces overhead by a large
margin -- the overhead of using undo_io while converting a 2TB FS to
metadata_csum is reduced from 55 minutes to 45.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/undo_io.c |   69 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 51 insertions(+), 18 deletions(-)


diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
index 70b90d5..9a01e30 100644
--- a/lib/ext2fs/undo_io.c
+++ b/lib/ext2fs/undo_io.c
@@ -70,6 +70,9 @@ struct undo_private_data {
 
 	/* to support offset in unix I/O manager */
 	ext2_loff_t offset;
+
+	ext2fs_block_bitmap written_block_map;
+	struct struct_ext2_filsys fake_fs;
 };
 
 static io_manager undo_io_backing_manager;
@@ -164,6 +167,38 @@ static errcode_t write_block_size(TDB_CONTEXT *tdb, int block_size)
 	return retval;
 }
 
+static errcode_t undo_setup_tdb(struct undo_private_data *data)
+{
+	errcode_t retval;
+
+	if (data->tdb_written == 1)
+		return 0;
+
+	data->tdb_written = 1;
+
+	/* Make a bitmap to track what we've written */
+	memset(&data->fake_fs, 0, sizeof(data->fake_fs));
+	data->fake_fs.blocksize = data->tdb_data_size;
+	retval = ext2fs_alloc_generic_bmap(&data->fake_fs,
+				EXT2_ET_MAGIC_BLOCK_BITMAP64,
+				EXT2FS_BMAP64_RBTREE,
+				0, ~1ULL, ~1ULL,
+				"undo block map", &data->written_block_map);
+	if (retval)
+		return retval;
+
+	/* Write the blocksize to tdb file */
+	tdb_transaction_start(data->tdb);
+	retval = write_block_size(data->tdb,
+				  data->tdb_data_size);
+	if (retval) {
+		tdb_transaction_cancel(data->tdb);
+		return EXT2_ET_TDB_ERR_IO;
+	}
+	tdb_transaction_commit(data->tdb);
+	return 0;
+}
+
 static errcode_t undo_write_tdb(io_channel channel,
 				unsigned long long block, int count)
 
@@ -194,6 +229,10 @@ static errcode_t undo_write_tdb(io_channel channel,
 		else
 			size = count * channel->block_size;
 	}
+
+	retval = undo_setup_tdb(data);
+	if (retval)
+		return retval;
 	/*
 	 * Data is stored in tdb database as blocks of tdb_data_size size
 	 * This helps in efficient lookup further.
@@ -212,11 +251,14 @@ static errcode_t undo_write_tdb(io_channel channel,
 		/*
 		 * Check if we have the record already
 		 */
-		if (tdb_exists(data->tdb, tdb_key)) {
+		if (ext2fs_test_block_bitmap2(data->written_block_map,
+						   block_num)) {
 			/* Try the next block */
 			block_num++;
 			continue;
 		}
+		ext2fs_mark_block_bitmap2(data->written_block_map, block_num);
+
 		/*
 		 * Read one block using the backing I/O manager
 		 * The backing I/O manager block size may be
@@ -265,19 +307,7 @@ static errcode_t undo_write_tdb(io_channel channel,
 		       tdb_data.dptr,
 		       tdb_data.dsize);
 #endif
-		if (data->tdb_written != 1) {
-			data->tdb_written = 1;
-			/* Write the blocksize to tdb file */
-			retval = write_block_size(data->tdb,
-						  data->tdb_data_size);
-			if (retval) {
-				tdb_transaction_cancel(data->tdb);
-				retval = EXT2_ET_TDB_ERR_IO;
-				free(read_ptr);
-				return retval;
-			}
-		}
-		retval = tdb_store(data->tdb, tdb_key, tdb_data, TDB_INSERT);
+		retval = tdb_store(data->tdb, tdb_key, tdb_data, TDB_REPLACE);
 		if (retval == -1) {
 			/*
 			 * TDB_ERR_EXISTS cannot happen because we
@@ -345,6 +375,7 @@ static errcode_t undo_open(const char *name, int flags, io_channel *channel)
 
 	memset(data, 0, sizeof(struct undo_private_data));
 	data->magic = EXT2_ET_MAGIC_UNIX_IO_CHANNEL;
+	data->written_block_map = NULL;
 
 	if (undo_io_backing_manager) {
 		retval = undo_io_backing_manager->open(name, flags,
@@ -390,7 +421,7 @@ cleanup:
 static errcode_t undo_close(io_channel channel)
 {
 	struct undo_private_data *data;
-	errcode_t	retval = 0;
+	errcode_t	err, retval = 0;
 
 	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
 	data = (struct undo_private_data *) channel->private_data;
@@ -399,20 +430,22 @@ static errcode_t undo_close(io_channel channel)
 	if (--channel->refcount > 0)
 		return 0;
 	/* Before closing write the file system identity */
-	retval = write_file_system_identity(channel, data->tdb);
-	if (retval)
-		return retval;
+	err = write_file_system_identity(channel, data->tdb);
 	if (data->real)
 		retval = io_channel_close(data->real);
 	if (data->tdb) {
 		tdb_flush(data->tdb);
 		tdb_close(data->tdb);
 	}
+	if (data->written_block_map)
+		ext2fs_free_generic_bitmap(data->written_block_map);
 	ext2fs_free_mem(&channel->private_data);
 	if (channel->name)
 		ext2fs_free_mem(&channel->name);
 	ext2fs_free_mem(&channel);
 
+	if (err)
+		return err;
 	return retval;
 }
 

