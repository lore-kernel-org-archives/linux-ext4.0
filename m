From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 23/25 v2] ext2fs: add readahead method to improve scanning
Date: Thu, 11 Sep 2014 14:29:49 -0700
Message-ID: <20140911212949.GY10351@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231408.25904.47150.stgit@birch.djwong.org>
 <20140911211031.GA17990@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <andreas.dilger@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24589 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaIKV34 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 17:29:56 -0400
Content-Disposition: inline
In-Reply-To: <20140911211031.GA17990@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sure thing.  Here's the patch again, but with the test_io.c bits added.
---
From: Andreas Dilger <adilger@whamcloud.com>

Add a readahead method for prefetching ranges of disk blocks.  This is
useful for inode table scanning, and other large contiguous ranges of
blocks, and may also prove useful for random block prefetch, since it
will allow reordering of the IO without waiting synchronously for the
reads to complete.

It is currently using the posix_fadvise(POSIX_FADV_WILLNEED)
interface, as this proved most efficient during our testing.

[darrick.wong@oracle.com]
Make the arguments to the readahead function take the same ULL values
as the other IO functions, and return an appropriate error code when
fadvise isn't available.

v2: Plumb in test_io.c for cache readahead.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext2_io.h    |    8 +++++++-
 lib/ext2fs/io_manager.c |    9 +++++++++
 lib/ext2fs/test_io.c    |   22 ++++++++++++++++++++++
 lib/ext2fs/unix_io.c    |   27 ++++++++++++++++++++++++---
 4 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index 1894fb8..4c5a5c5 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -90,7 +90,10 @@ struct struct_io_manager {
 					int count, const void *data);
 	errcode_t (*discard)(io_channel channel, unsigned long long block,
 			     unsigned long long count);
-	long	reserved[16];
+	errcode_t (*cache_readahead)(io_channel channel,
+				     unsigned long long block,
+				     unsigned long long count);
+	long	reserved[15];
 };
 
 #define IO_FLAG_RW		0x0001
@@ -124,6 +127,9 @@ extern errcode_t io_channel_discard(io_channel channel,
 				    unsigned long long count);
 extern errcode_t io_channel_alloc_buf(io_channel channel,
 				      int count, void *ptr);
+extern errcode_t io_channel_cache_readahead(io_channel io,
+					    unsigned long long block,
+					    unsigned long long count);
 
 /* unix_io.c */
 extern io_manager unix_io_manager;
diff --git a/lib/ext2fs/io_manager.c b/lib/ext2fs/io_manager.c
index 34e4859..dc5888d 100644
--- a/lib/ext2fs/io_manager.c
+++ b/lib/ext2fs/io_manager.c
@@ -128,3 +128,12 @@ errcode_t io_channel_alloc_buf(io_channel io, int count, void *ptr)
 	else
 		return ext2fs_get_mem(size, ptr);
 }
+
+errcode_t io_channel_cache_readahead(io_channel io, unsigned long long block,
+				     unsigned long long count)
+{
+	if (!io->manager->cache_readahead)
+		return EXT2_ET_OP_NOT_SUPPORTED;
+
+	return io->manager->cache_readahead(io, block, count);
+}
diff --git a/lib/ext2fs/test_io.c b/lib/ext2fs/test_io.c
index 6f0d035..b03a939 100644
--- a/lib/ext2fs/test_io.c
+++ b/lib/ext2fs/test_io.c
@@ -85,6 +85,7 @@ void (*test_io_cb_write_byte)
 #define TEST_FLAG_DUMP			0x10
 #define TEST_FLAG_SET_OPTION		0x20
 #define TEST_FLAG_DISCARD		0x40
+#define TEST_FLAG_READAHEAD		0x80
 
 static void test_dump_block(io_channel channel,
 			    struct test_private_data *data,
@@ -486,6 +487,26 @@ static errcode_t test_discard(io_channel channel, unsigned long long block,
 	return retval;
 }
 
+static errcode_t test_cache_readahead(io_channel channel,
+				      unsigned long long block,
+				      unsigned long long count)
+{
+	struct test_private_data *data;
+	errcode_t	retval = 0;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct test_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_TEST_IO_CHANNEL);
+
+	if (data->real)
+		retval = io_channel_cache_readahead(data->real, block, count);
+	if (data->flags & TEST_FLAG_READAHEAD)
+		fprintf(data->outfile,
+			"Test_io: readahead(%llu, %llu) returned %s\n",
+			block, count, retval ? error_message(retval) : "OK");
+	return retval;
+}
+
 static struct struct_io_manager struct_test_manager = {
 	.magic		= EXT2_ET_MAGIC_IO_MANAGER,
 	.name		= "Test I/O Manager",
@@ -501,6 +522,7 @@ static struct struct_io_manager struct_test_manager = {
 	.read_blk64	= test_read_blk64,
 	.write_blk64	= test_write_blk64,
 	.discard	= test_discard,
+	.cache_readahead	= test_cache_readahead,
 };
 
 io_manager test_io_manager = &struct_test_manager;
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index eb39b28..189adce 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -15,6 +15,9 @@
  * %End-Header%
  */
 
+#define _XOPEN_SOURCE 600
+#define _DARWIN_C_SOURCE
+#define _FILE_OFFSET_BITS 64
 #define _LARGEFILE_SOURCE
 #define _LARGEFILE64_SOURCE
 #ifndef _GNU_SOURCE
@@ -35,6 +38,9 @@
 #ifdef __linux__
 #include <sys/utsname.h>
 #endif
+#if HAVE_SYS_TYPES_H
+#include <sys/types.h>
+#endif
 #ifdef HAVE_SYS_IOCTL_H
 #include <sys/ioctl.h>
 #endif
@@ -44,9 +50,6 @@
 #if HAVE_SYS_STAT_H
 #include <sys/stat.h>
 #endif
-#if HAVE_SYS_TYPES_H
-#include <sys/types.h>
-#endif
 #if HAVE_SYS_RESOURCE_H
 #include <sys/resource.h>
 #endif
@@ -830,6 +833,23 @@ static errcode_t unix_write_blk64(io_channel channel, unsigned long long block,
 #endif /* NO_IO_CACHE */
 }
 
+static errcode_t unix_cache_readahead(io_channel channel,
+				      unsigned long long block,
+				      unsigned long long count)
+{
+#ifdef POSIX_FADV_WILLNEED
+	struct unix_private_data *data;
+
+	data = (struct unix_private_data *)channel->private_data;
+	return posix_fadvise(data->dev,
+			     (ext2_loff_t)block * channel->block_size,
+			     (ext2_loff_t)count * channel->block_size,
+			     POSIX_FADV_WILLNEED);
+#else
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
+}
+
 static errcode_t unix_write_blk(io_channel channel, unsigned long block,
 				int count, const void *buf)
 {
@@ -981,6 +1001,7 @@ static struct struct_io_manager struct_unix_manager = {
 	.read_blk64	= unix_read_blk64,
 	.write_blk64	= unix_write_blk64,
 	.discard	= unix_discard,
+	.cache_readahead	= unix_cache_readahead,
 };
 
 io_manager unix_io_manager = &struct_unix_manager;
