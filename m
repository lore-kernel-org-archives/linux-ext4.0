From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 22/37] ext2fs: add readahead method to improve scanning
Date: Thu, 01 May 2014 16:14:46 -0700
Message-ID: <20140501231445.31890.69647.stgit@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <andreas.dilger@intel.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28794 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaEAXO7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:14:59 -0400
In-Reply-To: <20140501231222.31890.82860.stgit@birch.djwong.org>
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
Add a cache_release method for advising the pagecache to discard disk
cache blocks.  Make the arguments to the readahead function take the
same ULL values as the other IO functions, and return an appropriate
error code when fadvise isn't available.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext2_io.h    |   12 ++++++++++++
 lib/ext2fs/io_manager.c |   18 ++++++++++++++++++
 lib/ext2fs/unix_io.c    |   46 +++++++++++++++++++++++++++++++++++++++=
++++---
 3 files changed, 73 insertions(+), 3 deletions(-)


diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index 1894fb8..636f797 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -90,6 +90,12 @@ struct struct_io_manager {
 					int count, const void *data);
 	errcode_t (*discard)(io_channel channel, unsigned long long block,
 			     unsigned long long count);
+	errcode_t (*cache_readahead)(io_channel channel,
+				     unsigned long long block,
+				     unsigned long long count);
+	errcode_t (*cache_release)(io_channel channel,
+				   unsigned long long block,
+				   unsigned long long count);
 	long	reserved[16];
 };
=20
@@ -124,6 +130,12 @@ extern errcode_t io_channel_discard(io_channel cha=
nnel,
 				    unsigned long long count);
 extern errcode_t io_channel_alloc_buf(io_channel channel,
 				      int count, void *ptr);
+extern errcode_t io_channel_cache_readahead(io_channel io,
+					    unsigned long long block,
+					    unsigned long long count);
+extern errcode_t io_channel_cache_release(io_channel io,
+					  unsigned long long block,
+					  unsigned long long count);
=20
 /* unix_io.c */
 extern io_manager unix_io_manager;
diff --git a/lib/ext2fs/io_manager.c b/lib/ext2fs/io_manager.c
index 34e4859..a1258c4 100644
--- a/lib/ext2fs/io_manager.c
+++ b/lib/ext2fs/io_manager.c
@@ -128,3 +128,21 @@ errcode_t io_channel_alloc_buf(io_channel io, int =
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
+
+errcode_t io_channel_cache_release(io_channel io, unsigned long long b=
lock,
+				   unsigned long long count)
+{
+	if (!io->manager->cache_release)
+		return EXT2_ET_OP_NOT_SUPPORTED;
+
+	return io->manager->cache_release(io, block, count);
+}
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index a818c13..a95e289 100644
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
@@ -97,6 +100,7 @@ struct unix_private_data {
 #define IS_ALIGNED(n, align) ((((unsigned long) n) & \
 			       ((unsigned long) ((align)-1))) =3D=3D 0)
=20
+
 static errcode_t unix_get_stats(io_channel channel, io_stats *stats)
 {
 	errcode_t	retval =3D 0;
@@ -810,6 +814,40 @@ static errcode_t unix_write_blk64(io_channel chann=
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
+static errcode_t unix_cache_release(io_channel channel,
+				    unsigned long long block,
+				    unsigned long long count)
+{
+#ifdef POSIX_FADV_DONTNEED
+	struct unix_private_data *data;
+
+	data =3D (struct unix_private_data *)channel->private_data;
+	return posix_fadvise(data->dev,
+			     (ext2_loff_t)block * channel->block_size,
+			     (ext2_loff_t)count * channel->block_size,
+			     POSIX_FADV_DONTNEED);
+#else
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
+}
+
 static errcode_t unix_write_blk(io_channel channel, unsigned long bloc=
k,
 				int count, const void *buf)
 {
@@ -961,6 +999,8 @@ static struct struct_io_manager struct_unix_manager=
 =3D {
 	unix_read_blk64,
 	unix_write_blk64,
 	unix_discard,
+	unix_cache_readahead,
+	unix_cache_release,
 };
=20
 io_manager unix_io_manager =3D &struct_unix_manager;

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
