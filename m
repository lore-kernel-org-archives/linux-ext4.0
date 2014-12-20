From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 13/31] undo-io: be more flexible about setting block size
Date: Sat, 20 Dec 2014 13:18:17 -0800
Message-ID: <20141220211817.25563.84496.stgit@birch.djwong.org>
References: <20141220211640.25563.80596.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45231 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbaLTVSW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Dec 2014 16:18:22 -0500
In-Reply-To: <20141220211640.25563.80596.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Most of the e2fsprogs utilities set the IO block size multiple times
(once to 1k to read the superblock, then again to set the real block
size if we find a real superblock).  Unfortunately, the undo IO
manager only lets the block size be set once.  For the non-mke2fs
utilities we'd rather catch the real block size and use that.  mke2fs
of course wants to use a really large block size since it's probably
writing a lot of data.

Therefore, if we haven't written any blocks to the undo file, it's
perfectly fine to allow block size changes.  For mke2fs, we'll modify
the IO channel option that lets us set the huge size to lock that
in place.  This greatly reduces index overhead for undo files for
e2fsck/tune2fs/resize2fs while continuing the practice of reducing
it even more for mke2fs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/undo_io.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
index 94317cb..70b90d5 100644
--- a/lib/ext2fs/undo_io.c
+++ b/lib/ext2fs/undo_io.c
@@ -265,7 +265,7 @@ static errcode_t undo_write_tdb(io_channel channel,
 		       tdb_data.dptr,
 		       tdb_data.dsize);
 #endif
-		if (!data->tdb_written) {
+		if (data->tdb_written != 1) {
 			data->tdb_written = 1;
 			/* Write the blocksize to tdb file */
 			retval = write_block_size(data->tdb,
@@ -430,9 +430,8 @@ static errcode_t undo_set_blksize(io_channel channel, int blksize)
 	/*
 	 * Set the block size used for tdb
 	 */
-	if (!data->tdb_data_size) {
+	if (!data->tdb_data_size || !data->tdb_written)
 		data->tdb_data_size = blksize;
-	}
 	channel->block_size = blksize;
 	return retval;
 }
@@ -628,6 +627,7 @@ static errcode_t undo_set_option(io_channel channel, const char *option,
 		if (*end)
 			return EXT2_ET_INVALID_ARGUMENT;
 		if (!data->tdb_data_size || !data->tdb_written) {
+			data->tdb_written = -1;
 			data->tdb_data_size = tmp;
 		}
 		return 0;

