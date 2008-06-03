From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: Add 64-bit support to the undo manager
Date: Mon,  2 Jun 2008 22:44:50 -0400
Message-ID: <1212461090-18989-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:40899 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753274AbYFCCpB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 22:45:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/undo_io.c |   55 ++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
index e1e6458..1499972 100644
--- a/lib/ext2fs/undo_io.c
+++ b/lib/ext2fs/undo_io.c
@@ -67,6 +67,10 @@ struct undo_private_data {
 static errcode_t undo_open(const char *name, int flags, io_channel *channel);
 static errcode_t undo_close(io_channel channel);
 static errcode_t undo_set_blksize(io_channel channel, int blksize);
+static errcode_t undo_read_blk64(io_channel channel, unsigned long long block,
+				 int count, void *data);
+static errcode_t undo_write_blk64(io_channel channel, unsigned long long block,
+				  int count, const void *data);
 static errcode_t undo_read_blk(io_channel channel, unsigned long block,
 			       int count, void *data);
 static errcode_t undo_write_blk(io_channel channel, unsigned long block,
@@ -76,6 +80,7 @@ static errcode_t undo_write_byte(io_channel channel, unsigned long offset,
 				int size, const void *data);
 static errcode_t undo_set_option(io_channel channel, const char *option,
 				 const char *arg);
+static errcode_t undo_get_stats(io_channel channel, io_stats *stats);
 
 static struct struct_io_manager struct_undo_manager = {
 	EXT2_ET_MAGIC_IO_MANAGER,
@@ -87,7 +92,10 @@ static struct struct_io_manager struct_undo_manager = {
 	undo_write_blk,
 	undo_flush,
 	undo_write_byte,
-	undo_set_option
+	undo_set_option,
+	undo_get_stats,
+	undo_read_blk64,
+	undo_write_blk64,
 };
 
 io_manager undo_io_manager = &struct_undo_manager;
@@ -180,17 +188,17 @@ static errcode_t write_block_size(TDB_CONTEXT *tdb, int block_size)
 }
 
 static errcode_t undo_write_tdb(io_channel channel,
-				unsigned long block, int count)
+				unsigned long long block, int count)
 
 {
 	int size, i, sz;
-	unsigned long block_num, backing_blk_num;
+	unsigned long long block_num, backing_blk_num;
 	errcode_t retval = 0;
 	ext2_loff_t offset;
 	struct undo_private_data *data;
 	TDB_DATA tdb_key, tdb_data;
 	char *read_ptr;
-	unsigned long end_block;
+	unsigned long long end_block;
 
 	data = (struct undo_private_data *) channel->private_data;
 
@@ -256,7 +264,7 @@ static errcode_t undo_write_tdb(io_channel channel,
 			sz = count / channel->block_size;
 		else
 			sz = -count;
-		retval = io_channel_read_blk(data->real, backing_blk_num,
+		retval = io_channel_read_blk64(data->real, backing_blk_num,
 					     sz, read_ptr);
 		if (retval) {
 			if (retval != EXT2_ET_SHORT_READ) {
@@ -275,7 +283,7 @@ static errcode_t undo_write_tdb(io_channel channel,
 		tdb_data.dptr = read_ptr +
 				((offset - data->offset) % channel->block_size);
 #ifdef DEBUG
-		printf("Printing with key %ld data %x and size %d\n",
+		printf("Printing with key %lld data %x and size %d\n",
 		       block_num,
 		       tdb_data.dptr,
 		       tdb_data.dsize);
@@ -443,7 +451,7 @@ static errcode_t undo_set_blksize(io_channel channel, int blksize)
 	return retval;
 }
 
-static errcode_t undo_read_blk(io_channel channel, unsigned long block,
+static errcode_t undo_read_blk64(io_channel channel, unsigned long long block,
 			       int count, void *buf)
 {
 	errcode_t	retval;
@@ -454,12 +462,18 @@ static errcode_t undo_read_blk(io_channel channel, unsigned long block,
 	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
 
 	if (data->real)
-		retval = io_channel_read_blk(data->real, block, count, buf);
+		retval = io_channel_read_blk64(data->real, block, count, buf);
 
 	return retval;
 }
 
-static errcode_t undo_write_blk(io_channel channel, unsigned long block,
+static errcode_t undo_read_blk(io_channel channel, unsigned long block,
+			       int count, void *buf)
+{
+	return undo_read_blk64(channel, block, count, buf);
+}
+
+static errcode_t undo_write_blk64(io_channel channel, unsigned long long block,
 				int count, const void *buf)
 {
 	struct undo_private_data *data;
@@ -475,11 +489,17 @@ static errcode_t undo_write_blk(io_channel channel, unsigned long block,
 	if (retval)
 		 return retval;
 	if (data->real)
-		retval = io_channel_write_blk(data->real, block, count, buf);
+		retval = io_channel_write_blk64(data->real, block, count, buf);
 
 	return retval;
 }
 
+static errcode_t undo_write_blk(io_channel channel, unsigned long block,
+				int count, const void *buf)
+{
+	return undo_write_blk64(channel, block, count, buf);
+}
+
 static errcode_t undo_write_byte(io_channel channel, unsigned long offset,
 				 int size, const void *buf)
 {
@@ -573,3 +593,18 @@ static errcode_t undo_set_option(io_channel channel, const char *option,
 	}
 	return retval;
 }
+
+static errcode_t undo_get_stats(io_channel channel, io_stats *stats)
+{
+	errcode_t	retval;
+	struct undo_private_data *data;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct undo_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	if (data->real)
+		retval = (data->real->manager->get_stats)(data->real, stats);
+
+	return retval;
+}
-- 
1.5.4.1.144.gdfee-dirty

