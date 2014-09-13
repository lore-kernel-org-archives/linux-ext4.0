From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 15/34] libext2fs: support BLKZEROOUT/FALLOC_FL_ZERO_RANGE in
 ext2fs_zero_blocks
Date: Sat, 13 Sep 2014 15:12:53 -0700
Message-ID: <20140913221253.13646.7723.stgit@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32277 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaIMWM5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2014 18:12:57 -0400
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Plumb a new call into the IO manager to support translating
ext2fs_zero_blocks calls into the equivalent kernel-level BLKZEROOUT
ioctl or FALLOC_FL_ZERO_RANGE fallocate flag primitives when possible.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 contrib/fallocate.c     |   14 +++++++++
 lib/ext2fs/ext2_io.h    |    7 ++++-
 lib/ext2fs/io_manager.c |   11 +++++++
 lib/ext2fs/mkjournal.c  |    6 ++++
 lib/ext2fs/test_io.c    |   21 ++++++++++++++
 lib/ext2fs/unix_io.c    |   71 +++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 128 insertions(+), 2 deletions(-)


diff --git a/contrib/fallocate.c b/contrib/fallocate.c
index 1f9b59a..01d4af7 100644
--- a/contrib/fallocate.c
+++ b/contrib/fallocate.c
@@ -36,6 +36,8 @@
 // #include <linux/falloc.h>
 #define FALLOC_FL_KEEP_SIZE	0x01
 #define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
+#define FALLOC_FL_COLLAPSE_RANGE	0x08
+#define FALLOC_FL_ZERO_RANGE		0x10
 
 void usage(void)
 {
@@ -95,7 +97,7 @@ int main(int argc, char **argv)
 	int	error;
 	int	tflag = 0;
 
-	while ((opt = getopt(argc, argv, "npl:o:t")) != -1) {
+	while ((opt = getopt(argc, argv, "npl:o:tzc")) != -1) {
 		switch(opt) {
 		case 'n':
 			/* do not change filesize */
@@ -106,6 +108,16 @@ int main(int argc, char **argv)
 			falloc_mode = (FALLOC_FL_PUNCH_HOLE |
 				       FALLOC_FL_KEEP_SIZE);
 			break;
+		case 'c':
+			/* collapse range mode */
+			falloc_mode = (FALLOC_FL_COLLAPSE_RANGE |
+				       FALLOC_FL_KEEP_SIZE);
+			break;
+		case 'z':
+			/* zero range mode */
+			falloc_mode = (FALLOC_FL_ZERO_RANGE |
+				       FALLOC_FL_KEEP_SIZE);
+			break;
 		case 'l':
 			length = cvtnum(optarg);
 			break;
diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index 4c5a5c5..1faa720 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -93,7 +93,9 @@ struct struct_io_manager {
 	errcode_t (*cache_readahead)(io_channel channel,
 				     unsigned long long block,
 				     unsigned long long count);
-	long	reserved[15];
+	errcode_t (*zeroout)(io_channel channel, unsigned long long block,
+			     unsigned long long count);
+	long	reserved[14];
 };
 
 #define IO_FLAG_RW		0x0001
@@ -125,6 +127,9 @@ extern errcode_t io_channel_write_blk64(io_channel channel,
 extern errcode_t io_channel_discard(io_channel channel,
 				    unsigned long long block,
 				    unsigned long long count);
+extern errcode_t io_channel_zeroout(io_channel channel,
+				    unsigned long long block,
+				    unsigned long long count);
 extern errcode_t io_channel_alloc_buf(io_channel channel,
 				      int count, void *ptr);
 extern errcode_t io_channel_cache_readahead(io_channel io,
diff --git a/lib/ext2fs/io_manager.c b/lib/ext2fs/io_manager.c
index dc5888d..c395d61 100644
--- a/lib/ext2fs/io_manager.c
+++ b/lib/ext2fs/io_manager.c
@@ -112,6 +112,17 @@ errcode_t io_channel_discard(io_channel channel, unsigned long long block,
 	return EXT2_ET_UNIMPLEMENTED;
 }
 
+errcode_t io_channel_zeroout(io_channel channel, unsigned long long block,
+			     unsigned long long count)
+{
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+
+	if (channel->manager->zeroout)
+		return (channel->manager->zeroout)(channel, block, count);
+
+	return EXT2_ET_UNIMPLEMENTED;
+}
+
 errcode_t io_channel_alloc_buf(io_channel io, int count, void *ptr)
 {
 	size_t	size;
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 6f3a862..5be425c 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -164,6 +164,12 @@ errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
 		}
 		return 0;
 	}
+
+	/* Try a zero out command, if supported */
+	retval = io_channel_zeroout(fs->io, blk, num);
+	if (retval == 0)
+		return 0;
+
 	/* Allocate the zeroizing buffer if necessary */
 	if (!buf) {
 		buf = malloc(fs->blocksize * STRIDE_LENGTH);
diff --git a/lib/ext2fs/test_io.c b/lib/ext2fs/test_io.c
index b03a939..f7c50d1 100644
--- a/lib/ext2fs/test_io.c
+++ b/lib/ext2fs/test_io.c
@@ -86,6 +86,7 @@ void (*test_io_cb_write_byte)
 #define TEST_FLAG_SET_OPTION		0x20
 #define TEST_FLAG_DISCARD		0x40
 #define TEST_FLAG_READAHEAD		0x80
+#define TEST_FLAG_ZEROOUT		0x100
 
 static void test_dump_block(io_channel channel,
 			    struct test_private_data *data,
@@ -507,6 +508,25 @@ static errcode_t test_cache_readahead(io_channel channel,
 	return retval;
 }
 
+static errcode_t test_zeroout(io_channel channel, unsigned long long block,
+			      unsigned long long count)
+{
+	struct test_private_data *data;
+	errcode_t	retval = 0;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct test_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_TEST_IO_CHANNEL);
+
+	if (data->real)
+		retval = io_channel_zeroout(data->real, block, count);
+	if (data->flags & TEST_FLAG_ZEROOUT)
+		fprintf(data->outfile,
+			"Test_io: zeroout(%llu, %llu) returned %s\n",
+			block, count, retval ? error_message(retval) : "OK");
+	return retval;
+}
+
 static struct struct_io_manager struct_test_manager = {
 	.magic		= EXT2_ET_MAGIC_IO_MANAGER,
 	.name		= "Test I/O Manager",
@@ -523,6 +543,7 @@ static struct struct_io_manager struct_test_manager = {
 	.write_blk64	= test_write_blk64,
 	.discard	= test_discard,
 	.cache_readahead	= test_cache_readahead,
+	.zeroout	= test_zeroout,
 };
 
 io_manager test_io_manager = &struct_test_manager;
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 189adce..20e5b64 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -986,6 +986,76 @@ unimplemented:
 	return EXT2_ET_UNIMPLEMENTED;
 }
 
+#if defined(__linux__) && !defined(BLKZEROOUT)
+#define BLKZEROOUT		_IO(0x12, 127)
+#endif
+
+#if defined(__linux__) && !defined(FALLOC_FL_ZERO_RANGE)
+#define FALLOC_FL_ZERO_RANGE    0x10
+#endif
+
+static errcode_t unix_zeroout(io_channel channel, unsigned long long block,
+			      unsigned long long count)
+{
+	struct unix_private_data *data;
+	int		ret;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct unix_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	if (getenv("UNIX_IO_NOZEROOUT"))
+		goto unimplemented;
+
+	if (channel->flags & CHANNEL_FLAGS_BLOCK_DEVICE) {
+#ifdef BLKZEROOUT
+		__u64 range[2];
+
+		range[0] = (__u64)(block) * channel->block_size;
+		range[1] = (__u64)(count) * channel->block_size;
+
+		ret = ioctl(data->dev, BLKZEROOUT, &range);
+#else
+		goto unimplemented;
+#endif
+	} else {
+#if defined(HAVE_FALLOCATE) && defined(FALLOC_FL_ZERO_RANGE)
+		int flag = FALLOC_FL_ZERO_RANGE;
+		struct stat statbuf;
+
+		/*
+		 * If we're trying to zero a range past the end of the file,
+		 * just use regular fallocate to get there, because zeroing
+		 * a range past EOF does not extend the file.
+		 */
+		ret = fstat(data->dev, &statbuf);
+		if (ret)
+			goto err;
+		if (statbuf.st_size < (block + count) * channel->block_size)
+			flag = 0;
+		/*
+		 * If we are not on block device, try to use the zero out
+		 * primitive.
+		 */
+		ret = fallocate(data->dev,
+				flag,
+				(off_t)(block) * channel->block_size,
+				(off_t)(count) * channel->block_size);
+#else
+		goto unimplemented;
+#endif
+	}
+err:
+	if (ret < 0) {
+		if (errno == EOPNOTSUPP)
+			goto unimplemented;
+		return errno;
+	}
+	return 0;
+unimplemented:
+	return EXT2_ET_UNIMPLEMENTED;
+}
+
 static struct struct_io_manager struct_unix_manager = {
 	.magic		= EXT2_ET_MAGIC_IO_MANAGER,
 	.name		= "Unix I/O Manager",
@@ -1002,6 +1072,7 @@ static struct struct_io_manager struct_unix_manager = {
 	.write_blk64	= unix_write_blk64,
 	.discard	= unix_discard,
 	.cache_readahead	= unix_cache_readahead,
+	.zeroout	= unix_zeroout,
 };
 
 io_manager unix_io_manager = &struct_unix_manager;

