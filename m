Return-Path: <SRS0=NmFT=PW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36172 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726745AbfANXhO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jan 2019 18:37:14 -0500
Date: Mon, 14 Jan 2019 15:37:08 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
Subject: [PATCH] libext2fs: revert "try to always use PUNCH_HOLE for
 unix_discard"
Message-ID: <20190114233708.GA20465@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Revert bcca9876a3428c10417c660b78933e6e70e8a5f5, because
fallocate(PUNCH_HOLE) on block devices was changed to use zeroout
instead of discard shortly after block device fallocate was merged.
zeroout isn't necessarily a "drop storage" operation like discard is,
so we prefer to use that on block devices.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/unix_io.c |   61 ++++++++++++++++++++------------------------------
 1 file changed, 25 insertions(+), 36 deletions(-)

diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 16e2052cd..74fc8a75d 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -1081,38 +1081,6 @@ static errcode_t unix_set_option(io_channel channel, const char *option,
 #define BLKDISCARD		_IO(0x12,119)
 #endif
 
-/*
- * Try a PUNCH_HOLE to unmap blocks, then BLKDISCARD if that doesn't work.
- * We prefer PUNCH_HOLE because it invalidates the page cache, even on block
- * devices.
- */
-static int __unix_discard(int fd, int is_bdev, off_t offset, off_t len)
-{
-#ifdef BLKDISCARD
-	__u64 range[2];
-#endif
-	int ret = -1;
-
-#if defined(HAVE_FALLOCATE) && defined(FALLOC_FL_PUNCH_HOLE) && defined(FALLOC_FL_KEEP_SIZE)
-	ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
-			offset, len);
-	if (ret == 0)
-		return 0;
-#endif
-#ifdef BLKDISCARD
-	if (is_bdev) {
-		range[0] = (__u64)offset;
-		range[1] = (__u64)len;
-
-		ret = ioctl(fd, BLKDISCARD, &range);
-		if (ret == 0)
-			return 0;
-	}
-#endif
-	errno = EOPNOTSUPP;
-	return ret;
-}
-
 static errcode_t unix_discard(io_channel channel, unsigned long long block,
 			      unsigned long long count)
 {
@@ -1123,10 +1091,31 @@ static errcode_t unix_discard(io_channel channel, unsigned long long block,
 	data = (struct unix_private_data *) channel->private_data;
 	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
 
-	ret = __unix_discard(data->dev,
-			(channel->flags & CHANNEL_FLAGS_BLOCK_DEVICE),
-			(off_t)(block) * channel->block_size + data->offset,
-			(off_t)(count) * channel->block_size);
+	if (channel->flags & CHANNEL_FLAGS_BLOCK_DEVICE) {
+#ifdef BLKDISCARD
+		__u64 range[2];
+
+		range[0] = (__u64)(block) * channel->block_size + data->offset;
+		range[1] = (__u64)(count) * channel->block_size;
+
+		ret = ioctl(data->dev, BLKDISCARD, &range);
+#else
+		goto unimplemented;
+#endif
+	} else {
+#if defined(HAVE_FALLOCATE) && defined(FALLOC_FL_PUNCH_HOLE)
+		/*
+		 * If we are not on block device, try to use punch hole
+		 * to reclaim free space.
+		 */
+		ret = fallocate(data->dev,
+				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				(off_t)(block) * channel->block_size + data->offset,
+				(off_t)(count) * channel->block_size);
+#else
+		goto unimplemented;
+#endif
+	}
 	if (ret < 0) {
 		if (errno == EOPNOTSUPP)
 			goto unimplemented;
