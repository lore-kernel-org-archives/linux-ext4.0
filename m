From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/3] e2fsprogs: Add write_byte64 into struct_io_manager
Date: Fri,  8 Feb 2013 12:07:02 +0100
Message-ID: <1360321623-8188-2-git-send-email-lczerner@redhat.com>
References: <1360321623-8188-1-git-send-email-lczerner@redhat.com>
Cc: sandeen@redhat.com, tytso@mit.edu,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946238Ab3BHLHL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Feb 2013 06:07:11 -0500
In-Reply-To: <1360321623-8188-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current implementation of write_byte() is not able to cover 64bit
offsets. In order to preserve the ABI this commit introduces new
function into struct_io_manager called write_byte64 which is able to
accept 64bit offset.

All io managers are updated to implement write_byte64() and use it even
for write_byte().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ext2fs/ext2_io.h    |    4 +++-
 lib/ext2fs/inode_io.c   |   18 +++++++++++++++---
 lib/ext2fs/io_manager.c |   20 ++++++++++++++++++++
 lib/ext2fs/test_io.c    |   32 ++++++++++++++++++++++++++++++++
 lib/ext2fs/unix_io.c    |   17 ++++++++++++++---
 5 files changed, 84 insertions(+), 7 deletions(-)

diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index 1894fb8..e49119c 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -90,7 +90,9 @@ struct struct_io_manager {
 					int count, const void *data);
 	errcode_t (*discard)(io_channel channel, unsigned long long block,
 			     unsigned long long count);
-	long	reserved[16];
+	errcode_t (*write_byte64)(io_channel channel, unsigned long long offset,
+				  int count, const void *data);
+	long	reserved[15];
 };
 
 #define IO_FLAG_RW		0x0001
diff --git a/lib/ext2fs/inode_io.c b/lib/ext2fs/inode_io.c
index 8e0944e..9a88c28 100644
--- a/lib/ext2fs/inode_io.c
+++ b/lib/ext2fs/inode_io.c
@@ -57,6 +57,9 @@ static errcode_t inode_write_blk(io_channel channel, unsigned long block,
 static errcode_t inode_flush(io_channel channel);
 static errcode_t inode_write_byte(io_channel channel, unsigned long offset,
 				int size, const void *data);
+static errcode_t inode_write_byte64(io_channel channel,
+				    unsigned long long offset,
+				    int size, const void *data);
 static errcode_t inode_read_blk64(io_channel channel,
 				unsigned long long block, int count, void *data);
 static errcode_t inode_write_blk64(io_channel channel,
@@ -75,7 +78,9 @@ static struct struct_io_manager struct_inode_manager = {
 	NULL,
 	NULL,
 	inode_read_blk64,
-	inode_write_blk64
+	inode_write_blk64,
+	NULL,
+	inode_write_byte64,
 };
 
 io_manager inode_io_manager = &struct_inode_manager;
@@ -259,8 +264,9 @@ static errcode_t inode_write_blk(io_channel channel, unsigned long block,
 	return inode_write_blk64(channel, block, count, buf);
 }
 
-static errcode_t inode_write_byte(io_channel channel, unsigned long offset,
-				 int size, const void *buf)
+static errcode_t inode_write_byte64(io_channel channel,
+				    unsigned long long offset,
+				    int size, const void *buf)
 {
 	struct inode_private_data *data;
 	errcode_t	retval = 0;
@@ -276,6 +282,12 @@ static errcode_t inode_write_byte(io_channel channel, unsigned long offset,
 	return ext2fs_file_write(data->file, buf, size, 0);
 }
 
+static errcode_t inode_write_byte(io_channel channel, unsigned long offset,
+				 int size, const void *buf)
+{
+	return inode_write_byte64(channel, offset, size, buf);
+}
+
 /*
  * Flush data buffers to disk.
  */
diff --git a/lib/ext2fs/io_manager.c b/lib/ext2fs/io_manager.c
index 34e4859..72f13d7 100644
--- a/lib/ext2fs/io_manager.c
+++ b/lib/ext2fs/io_manager.c
@@ -69,6 +69,26 @@ errcode_t io_channel_write_byte(io_channel channel, unsigned long offset,
 	return EXT2_ET_UNIMPLEMENTED;
 }
 
+errcode_t io_channel_write_byte64(io_channel channel, unsigned long long offset,
+				  int count, const void *data)
+{
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+
+	if (channel->manager->write_byte64)
+		return channel->manager->write_byte64(channel, offset,
+						    count, data);
+
+	if ((offset >> 32) != 0)
+		return EXT2_ET_IO_CHANNEL_NO_SUPPORT_64;
+
+	if (channel->manager->write_byte)
+		return channel->manager->write_byte(channel, offset,
+						    count, data);
+
+	return EXT2_ET_UNIMPLEMENTED;
+}
+
+
 errcode_t io_channel_read_blk64(io_channel channel, unsigned long long block,
 				 int count, void *data)
 {
diff --git a/lib/ext2fs/test_io.c b/lib/ext2fs/test_io.c
index 7d3cdfe..dc9f0c1 100644
--- a/lib/ext2fs/test_io.c
+++ b/lib/ext2fs/test_io.c
@@ -55,6 +55,8 @@ struct test_private_data {
 	void (*write_byte)(unsigned long block, int count, errcode_t err);
 	void (*read_blk64)(unsigned long long block, int count, errcode_t err);
 	void (*write_blk64)(unsigned long long block, int count, errcode_t err);
+	void (*write_byte64)(unsigned long long block, int count,
+			     errcode_t err);
 };
 
 static errcode_t test_open(const char *name, int flags, io_channel *channel);
@@ -71,6 +73,9 @@ static errcode_t test_write_blk64(io_channel channel, unsigned long long block,
 static errcode_t test_flush(io_channel channel);
 static errcode_t test_write_byte(io_channel channel, unsigned long offset,
 				 int count, const void *buf);
+static errcode_t test_write_byte64(io_channel channel,
+				   unsigned long long offset,
+				   int count, const void *buf);
 static errcode_t test_set_option(io_channel channel, const char *option,
 				 const char *arg);
 static errcode_t test_get_stats(io_channel channel, io_stats *stats);
@@ -92,6 +97,7 @@ static struct struct_io_manager struct_test_manager = {
 	test_read_blk64,
 	test_write_blk64,
 	test_discard,
+	test_write_byte64,
 };
 
 io_manager test_io_manager = &struct_test_manager;
@@ -113,6 +119,8 @@ void (*test_io_cb_set_blksize)
 	(int blksize, errcode_t err) = 0;
 void (*test_io_cb_write_byte)
 	(unsigned long block, int count, errcode_t err) = 0;
+void (*test_io_cb_write_byte64)
+	(unsigned long long block, int count, errcode_t err) = 0;
 
 /*
  * Test flags
@@ -222,6 +230,7 @@ static errcode_t test_open(const char *name, int flags, io_channel *channel)
 	data->write_blk = 	test_io_cb_write_blk;
 	data->set_blksize = 	test_io_cb_set_blksize;
 	data->write_byte = 	test_io_cb_write_byte;
+	data->write_byte64 = 	test_io_cb_write_byte64;
 	data->read_blk64 = 	test_io_cb_read_blk64;
 	data->write_blk64 = 	test_io_cb_write_blk64;
 
@@ -418,6 +427,29 @@ static errcode_t test_write_blk64(io_channel channel, unsigned long long block,
 	return retval;
 }
 
+static errcode_t test_write_byte64(io_channel channel,
+				   unsigned long long offset,
+				   int count, const void *buf)
+{
+	struct test_private_data *data;
+	errcode_t	retval = 0;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct test_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_TEST_IO_CHANNEL);
+
+	if (data->real && data->real->manager->write_byte64)
+		retval = io_channel_write_byte64(data->real, offset,
+						 count, buf);
+	if (data->write_byte64)
+		data->write_byte64(offset, count, retval);
+	if (data->flags & TEST_FLAG_WRITE)
+		fprintf(data->outfile,
+			"Test_io: write_byte64(%llu, %d) returned %s\n",
+			offset, count, retval ? error_message(retval) : "OK");
+	return retval;
+}
+
 static errcode_t test_write_byte(io_channel channel, unsigned long offset,
 			       int count, const void *buf)
 {
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 19be630..e67c682 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -107,6 +107,9 @@ static errcode_t unix_write_blk(io_channel channel, unsigned long block,
 static errcode_t unix_flush(io_channel channel);
 static errcode_t unix_write_byte(io_channel channel, unsigned long offset,
 				int size, const void *data);
+static errcode_t unix_write_byte64(io_channel channel,
+				   unsigned long long offset,
+				   int size, const void *data);
 static errcode_t unix_set_option(io_channel channel, const char *option,
 				 const char *arg);
 static errcode_t unix_get_stats(io_channel channel, io_stats *stats)
@@ -135,6 +138,7 @@ static struct struct_io_manager struct_unix_manager = {
 	unix_read_blk64,
 	unix_write_blk64,
 	unix_discard,
+	unix_write_byte64,
 };
 
 io_manager unix_io_manager = &struct_unix_manager;
@@ -834,8 +838,9 @@ static errcode_t unix_write_blk(io_channel channel, unsigned long block,
 	return unix_write_blk64(channel, block, count, buf);
 }
 
-static errcode_t unix_write_byte(io_channel channel, unsigned long offset,
-				 int size, const void *buf)
+static errcode_t unix_write_byte64(io_channel channel,
+				   unsigned long long offset,
+				   int size, const void *buf)
 {
 	struct unix_private_data *data;
 	errcode_t	retval = 0;
@@ -860,7 +865,7 @@ static errcode_t unix_write_byte(io_channel channel, unsigned long offset,
 		return retval;
 #endif
 
-	if (lseek(data->dev, offset + data->offset, SEEK_SET) < 0)
+	if (ext2fs_llseek(data->dev, offset + data->offset, SEEK_SET) < 0)
 		return errno;
 
 	actual = write(data->dev, buf, size);
@@ -870,6 +875,12 @@ static errcode_t unix_write_byte(io_channel channel, unsigned long offset,
 	return 0;
 }
 
+static errcode_t unix_write_byte(io_channel channel, unsigned long offset,
+				 int size, const void *buf)
+{
+	return unix_write_byte64(channel, offset, size, buf);
+}
+
 /*
  * Flush data buffers to disk.
  */
-- 
1.7.7.6

