From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/47] libext2fs: support BLKZEROOUT/FALLOC_FL_ZERO_RANGE in
 ext2fs_zero_blocks
Date: Fri, 07 Nov 2014 13:51:52 -0800
Message-ID: <20141107215152.883.6795.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35575 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaKGVv5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:51:57 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Plumb a new call into the IO manager to support translating
ext2fs_zero_blocks calls into the equivalent kernel-level BLKZEROOUT
ioctl or FALLOC_FL_ZERO_RANGE fallocate flag primitives when possible.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext2_io.h    |    7 ++-
 lib/ext2fs/io_manager.c |   11 ++++
 lib/ext2fs/mkjournal.c  |    5 ++
 lib/ext2fs/test_io.c    |   21 ++++++++
 lib/ext2fs/unix_io.c    |  125 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 168 insertions(+), 1 deletion(-)


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
index fdd788b..2cd7ca5 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -171,6 +171,11 @@ errcode_t ext2fs_zero_blocks3(ext2_filsys fs, blk64_t blk, int num,
 	if (num <= 0)
 		return 0;
 
+	/* Try a zero out command, if supported */
+	retval = io_channel_zeroout(fs->io, blk, num);
+	if (retval == 0)
+		return 0;
+
 	/* If the user gave us a buffer, write that out */
 	if (block_buf) {
 		retval = io_channel_write_blk64(fs->io, blk, num, block_buf);
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
index c3a8ea5..6bc543b 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -987,6 +987,130 @@ unimplemented:
 	return EXT2_ET_UNIMPLEMENTED;
 }
 
+#if defined(__linux__) && !defined(BLKZEROOUT)
+#define BLKZEROOUT		_IO(0x12, 127)
+#endif
+
+#if defined(__linux__) && !defined(BLKFLSBUF)
+#define BLKFLSBUF		_IO(0x12, 97)
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
+		__u64 range[2];
+
+		if (count == 0)
+			return 0;
+		/*
+		 * This is a heavyweight operation.  Refuse to
+		 * zero-out a single block, and hope that the
+		 * caller will fall back to io_channel_write().
+		 */
+		else if (count == 1)
+			goto unimplemented;
+
+		range[0] = (__u64)(block) * channel->block_size;
+		range[1] = (__u64)(count) * channel->block_size;
+
+		errno = EOPNOTSUPP;
+		ret = -1;
+#if defined(BLKZEROOUT) && (defined(POSIX_FADV_DONTNEED) || defined(BLKFLSBUF))
+		/*
+		 * BLKZEROOUT doesn't invalidate the page cache.  Therefore,
+		 * we need to flush dirty pages to disk prior to calling the
+		 * ioctl and invalidate at least those same pages from the page
+		 * cache afterwards.  If we're using direct IO we can skip all
+		 * that wrangling.
+		 */
+		if (!(data->flags & IO_FLAG_DIRECT_IO)) {
+			ret = fsync(data->dev);
+			if (ret)
+				goto err;
+		}
+		ret = ioctl(data->dev, BLKZEROOUT, range);
+		if (ret)
+			goto err;
+		if (!(data->flags & IO_FLAG_DIRECT_IO)) {
+#ifdef POSIX_FADV_DONTNEED
+			ret = posix_fadvise(data->dev, range[0], range[1],
+					    POSIX_FADV_DONTNEED);
+			if (ret == 0)
+				goto err;
+#endif
+#ifdef BLKFLSBUF
+			ret = ioctl(data->dev, BLKFLSBUF, 0);
+#endif
+		}
+#elif defined(BLKZEROOUT)
+		if (data->flags & IO_FLAG_DIRECT_IO)
+			ret = ioctl(data->dev, BLKZEROOUT, range);
+#endif
+	} else {
+		/* Regular file, try to use truncate/punch/zero. */
+#if defined(HAVE_FALLOCATE) && (defined(FALLOC_FL_ZERO_RANGE) || \
+	(defined(FALLOC_FL_PUNCH_HOLE) && defined(FALLOC_FL_KEEP_SIZE)))
+		struct stat statbuf;
+
+		if (count == 0)
+			return 0;
+		/*
+		 * If we're trying to zero a range past the end of the file,
+		 * extend the file size, then punch (or zero_range) everything.
+		 */
+		ret = fstat(data->dev, &statbuf);
+		if (ret)
+			goto err;
+		if (statbuf.st_size < (block + count) * channel->block_size) {
+			ret = ftruncate(data->dev,
+					(block + count) * channel->block_size);
+			if (ret)
+				goto err;
+		}
+#if defined(FALLOC_FL_PUNCH_HOLE) && defined(FALLOC_FL_KEEP_SIZE)
+		ret = fallocate(data->dev,
+				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				(off_t)(block) * channel->block_size,
+				(off_t)(count) * channel->block_size);
+		if (ret == 0)
+			goto err;
+#endif
+#ifdef FALLOC_FL_ZERO_RANGE
+		ret = fallocate(data->dev,
+				FALLOC_FL_ZERO_RANGE,
+				(off_t)(block) * channel->block_size,
+				(off_t)(count) * channel->block_size);
+#endif
+#else
+		goto unimplemented;
+#endif /* HAVE_FALLOCATE && (ZERO_RANGE || (PUNCH_HOLE && KEEP_SIZE)) */
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
@@ -1003,6 +1127,7 @@ static struct struct_io_manager struct_unix_manager = {
 	.write_blk64	= unix_write_blk64,
 	.discard	= unix_discard,
 	.cache_readahead	= unix_cache_readahead,
+	.zeroout	= unix_zeroout,
 };
 
 io_manager unix_io_manager = &struct_unix_manager;

