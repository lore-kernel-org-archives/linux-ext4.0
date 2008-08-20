From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 01/15][e2fsprogs] libext2fs: Add 64-bit support to the undo
	manager
Date: Wed, 20 Aug 2008 12:32:41 -0500
Message-ID: <20080820173241.23412.39573.stgit@gara>
References: <20080820173210.23412.46020.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47077 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbYHTRbu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Aug 2008 13:31:50 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7KHVkLS004437
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:31:46 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7KHVfL21609740
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:31:42 -0400
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7KHVdRB007470
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 11:31:40 -0600
In-Reply-To: <20080820173210.23412.46020.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

libext2fs: Add 64-bit support to the undo manager

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
--

 lib/ext2fs/undo_io.c |   55 +++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
index 827c038..7661b83 100644
--- a/lib/ext2fs/undo_io.c
+++ b/lib/ext2fs/undo_io.c
@@ -73,6 +73,10 @@ struct undo_private_data {
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
@@ -82,6 +86,7 @@ static errcode_t undo_write_byte(io_channel channel, unsigned long offset,
 				int size, const void *data);
 static errcode_t undo_set_option(io_channel channel, const char *option,
 				 const char *arg);
+static errcode_t undo_get_stats(io_channel channel, io_stats *stats);
 
 static struct struct_io_manager struct_undo_manager = {
 	EXT2_ET_MAGIC_IO_MANAGER,
@@ -93,7 +98,10 @@ static struct struct_io_manager struct_undo_manager = {
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
@@ -190,17 +198,17 @@ static errcode_t write_block_size(TDB_CONTEXT *tdb, int block_size)
 }
 
 static errcode_t undo_write_tdb(io_channel channel,
-				unsigned long block, int count)
+				unsigned long long block, int count)
 
 {
 	int size, sz;
-	unsigned long block_num, backing_blk_num;
+	unsigned long long block_num, backing_blk_num;
 	errcode_t retval = 0;
 	ext2_loff_t offset;
 	struct undo_private_data *data;
 	TDB_DATA tdb_key, tdb_data;
 	unsigned char *read_ptr;
-	unsigned long end_block;
+	unsigned long long end_block;
 
 	data = (struct undo_private_data *) channel->private_data;
 
@@ -266,7 +274,7 @@ static errcode_t undo_write_tdb(io_channel channel,
 			sz = count / channel->block_size;
 		else
 			sz = -count;
-		retval = io_channel_read_blk(data->real, backing_blk_num,
+		retval = io_channel_read_blk64(data->real, backing_blk_num,
 					     sz, read_ptr);
 		if (retval) {
 			if (retval != EXT2_ET_SHORT_READ) {
@@ -285,7 +293,7 @@ static errcode_t undo_write_tdb(io_channel channel,
 		tdb_data.dptr = read_ptr +
 				((offset - data->offset) % channel->block_size);
 #ifdef DEBUG
-		printf("Printing with key %ld data %x and size %d\n",
+		printf("Printing with key %lld data %x and size %d\n",
 		       block_num,
 		       tdb_data.dptr,
 		       tdb_data.dsize);
@@ -455,7 +463,7 @@ static errcode_t undo_set_blksize(io_channel channel, int blksize)
 	return retval;
 }
 
-static errcode_t undo_read_blk(io_channel channel, unsigned long block,
+static errcode_t undo_read_blk64(io_channel channel, unsigned long long block,
 			       int count, void *buf)
 {
 	errcode_t	retval = 0;
@@ -466,12 +474,18 @@ static errcode_t undo_read_blk(io_channel channel, unsigned long block,
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
@@ -487,11 +501,17 @@ static errcode_t undo_write_blk(io_channel channel, unsigned long block,
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
@@ -584,3 +604,18 @@ static errcode_t undo_set_option(io_channel channel, const char *option,
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

