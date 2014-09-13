From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/34] ext2fs: add readahead method to improve scanning
Date: Sat, 13 Sep 2014 15:11:58 -0700
Message-ID: <20140913221158.13646.41794.stgit@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <andreas.dilger@intel.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32178 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbaIMWME (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2014 18:12:04 -0400
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=46r=C3=B8m: Andreas Dilger <adilger@whamcloud.com>

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
=20
 #define IO_FLAG_RW		0x0001
@@ -124,6 +127,9 @@ extern errcode_t io_channel_discard(io_channel chan=
nel,
 				    unsigned long long count);
 extern errcode_t io_channel_alloc_buf(io_channel channel,
 				      int count, void *ptr);
+extern errcode_t io_channel_cache_readahead(io_channel io,
+					    unsigned long long block,
+					    unsigned long long count);
=20
 /* unix_io.c */
 extern io_manager unix_io_manager;
diff --git a/lib/ext2fs/io_manager.c b/lib/ext2fs/io_manager.c
index 34e4859..dc5888d 100644
--- a/lib/ext2fs/io_manager.c
+++ b/lib/ext2fs/io_manager.c
@@ -128,3 +128,12 @@ errcode_t io_channel_alloc_buf(io_channel io, int =
count, void *ptr)
 	else
 		return ext2fs_get_mem(size, ptr);
 }
+
+errcode_t io_channel_cache_readahead(io_channel io, unsigned long long=
 block,
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
=20
 static void test_dump_block(io_channel channel,
 			    struct test_private_data *data,
@@ -486,6 +487,26 @@ static errcode_t test_discard(io_channel channel, =
unsigned long long block,
 	return retval;
 }
=20
+static errcode_t test_cache_readahead(io_channel channel,
+				      unsigned long long block,
+				      unsigned long long count)
+{
+	struct test_private_data *data;
+	errcode_t	retval =3D 0;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data =3D (struct test_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_TEST_IO_CHANNEL);
+
+	if (data->real)
+		retval =3D io_channel_cache_readahead(data->real, block, count);
+	if (data->flags & TEST_FLAG_READAHEAD)
+		fprintf(data->outfile,
+			"Test_io: readahead(%llu, %llu) returned %s\n",
+			block, count, retval ? error_message(retval) : "OK");
+	return retval;
+}
+
 static struct struct_io_manager struct_test_manager =3D {
 	.magic		=3D EXT2_ET_MAGIC_IO_MANAGER,
 	.name		=3D "Test I/O Manager",
@@ -501,6 +522,7 @@ static struct struct_io_manager struct_test_manager=
 =3D {
 	.read_blk64	=3D test_read_blk64,
 	.write_blk64	=3D test_write_blk64,
 	.discard	=3D test_discard,
+	.cache_readahead	=3D test_cache_readahead,
 };
=20
 io_manager test_io_manager =3D &struct_test_manager;
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index eb39b28..189adce 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -15,6 +15,9 @@
  * %End-Header%
  */
=20
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
@@ -830,6 +833,23 @@ static errcode_t unix_write_blk64(io_channel chann=
el, unsigned long long block,
 #endif /* NO_IO_CACHE */
 }
=20
+static errcode_t unix_cache_readahead(io_channel channel,
+				      unsigned long long block,
+				      unsigned long long count)
+{
+#ifdef POSIX_FADV_WILLNEED
+	struct unix_private_data *data;
+
+	data =3D (struct unix_private_data *)channel->private_data;
+	return posix_fadvise(data->dev,
+			     (ext2_loff_t)block * channel->block_size,
+			     (ext2_loff_t)count * channel->block_size,
+			     POSIX_FADV_WILLNEED);
+#else
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
+}
+
 static errcode_t unix_write_blk(io_channel channel, unsigned long bloc=
k,
 				int count, const void *buf)
 {
@@ -981,6 +1001,7 @@ static struct struct_io_manager struct_unix_manage=
r =3D {
 	.read_blk64	=3D unix_read_blk64,
 	.write_blk64	=3D unix_write_blk64,
 	.discard	=3D unix_discard,
+	.cache_readahead	=3D unix_cache_readahead,
 };
=20
 io_manager unix_io_manager =3D &struct_unix_manager;

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
