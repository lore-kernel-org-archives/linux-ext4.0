From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] undo-io: write out index block after every write
Date: Wed, 6 May 2015 16:17:00 -0700
Message-ID: <20150506231700.GB30577@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28636 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbbEFXRE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 May 2015 19:17:04 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Write out the undo file's index block after writing a block to the
undo file.  This ensures that we always have a consistent undo file
in the page cache, even if the program crashes.  When we fill up a
key block in the undo file, we'll call fsync to force the whole
thing to storage; this should happen about every 255 blocks given
the usual 4K block size.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/undo_io.c |   47 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
index 4a48193..b9294c3 100644
--- a/lib/ext2fs/undo_io.c
+++ b/lib/ext2fs/undo_io.c
@@ -165,7 +165,7 @@ errcode_t set_undo_io_backup_file(char *file_name)
 	return 0;
 }
 
-static errcode_t write_undo_indexes(struct undo_private_data *data)
+static errcode_t write_undo_indexes(struct undo_private_data *data, int flush)
 {
 	errcode_t retval;
 	struct ext2_super_block super;
@@ -187,9 +187,14 @@ static errcode_t write_undo_indexes(struct undo_private_data *data)
 						1, data->keyb);
 		if (retval)
 			return retval;
-		memset(data->keyb, 0, data->tdb_data_size);
-		data->keys_in_block = 0;
-		data->key_blk_num = data->undo_blk_num;
+		/* Move on to the next key block if it's full. */
+		if (data->keys_in_block == KEYS_PER_BLOCK(data)) {
+			memset(data->keyb, 0, data->tdb_data_size);
+			data->keys_in_block = 0;
+			data->key_blk_num = data->undo_blk_num;
+			data->undo_blk_num++;
+			flush = 1;
+		}
 	}
 
 	/* Prepare superblock for write */
@@ -230,7 +235,8 @@ static errcode_t write_undo_indexes(struct undo_private_data *data)
 	if (retval)
 		goto err_out;
 
-	retval = io_channel_flush(data->undo_file);
+	if (flush)
+		retval = io_channel_flush(data->undo_file);
 err_out:
 	io_channel_set_blksize(channel, block_size);
 	return retval;
@@ -261,7 +267,7 @@ static errcode_t undo_setup_tdb(struct undo_private_data *data)
 	retval = ext2fs_get_mem(data->tdb_data_size, &data->keyb);
 	if (retval)
 		return retval;
-	data->key_blk_num = data->undo_blk_num;
+	data->key_blk_num = data->first_key_blk;
 
 	/* Record block size */
 	dbg_printf("Undo block size %llu\n", data->tdb_data_size);
@@ -348,22 +354,6 @@ static errcode_t undo_write_tdb(io_channel channel,
 		}
 		ext2fs_mark_block_bitmap2(data->written_block_map, block_num);
 
-		/* Spit out a key block */
-		if (data->keys_in_block == KEYS_PER_BLOCK(data)) {
-			retval = write_undo_indexes(data);
-			if (retval)
-				return retval;
-			retval = io_channel_write_blk64(data->undo_file,
-							data->key_blk_num, 1,
-							data->keyb);
-			if (retval)
-				return retval;
-		}
-
-		/* Allocate new key block */
-		if (data->keys_in_block == 0)
-			data->undo_blk_num++;
-
 		/*
 		 * Read one block using the backing I/O manager
 		 * The backing I/O manager block size may be
@@ -458,6 +448,12 @@ static errcode_t undo_write_tdb(io_channel channel,
 		}
 		data->undo_blk_num++;
 		free(read_ptr);
+
+		/* Write out the key block */
+		retval = write_undo_indexes(data, 0);
+		if (retval)
+			return retval;
+
 		/* Next block */
 		block_num++;
 	}
@@ -668,7 +664,7 @@ static void undo_atexit(void *p)
 	struct undo_private_data *data = p;
 	errcode_t err;
 
-	err = write_undo_indexes(data);
+	err = write_undo_indexes(data, 1);
 	io_channel_close(data->undo_file);
 
 	com_err(data->tdb_file, err, "while force-closing undo file");
@@ -707,7 +703,8 @@ static errcode_t undo_open(const char *name, int flags, io_channel *channel)
 	memset(data, 0, sizeof(struct undo_private_data));
 	data->magic = EXT2_ET_MAGIC_UNIX_IO_CHANNEL;
 	data->super_blk_num = 1;
-	data->undo_blk_num = data->first_key_blk = 2;
+	data->first_key_blk = 2;
+	data->undo_blk_num = 3;
 
 	if (undo_io_backing_manager) {
 		retval = undo_io_backing_manager->open(name, flags,
@@ -789,7 +786,7 @@ static errcode_t undo_close(io_channel channel)
 	/* Before closing write the file system identity */
 	if (!getenv("UNDO_IO_SIMULATE_UNFINISHED"))
 		data->hdr.state = ext2fs_cpu_to_le32(E2UNDO_STATE_FINISHED);
-	err = write_undo_indexes(data);
+	err = write_undo_indexes(data, 1);
 	ext2fs_remove_exit_fn(undo_atexit, data);
 	if (data->real)
 		retval = io_channel_close(data->real);
