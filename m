From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 35/74] libext2fs: zero block contents past EOF when setting
 size
Date: Tue, 10 Dec 2013 17:22:13 -0800
Message-ID: <20131211012213.30655.39040.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26741 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3LKBWT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:22:19 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we set the file size, find the block containing EOF, and zero
everything in that block past EOF so that we can't return stale data
if we ever use fallocate or truncate to lengthen the file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/fileio.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)


diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 03bdf86..582b306 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -393,6 +393,52 @@ ext2_off_t ext2fs_file_get_size(ext2_file_t file)
 	return size;
 }
 
+/* Zero the parts of the last block that are past EOF. */
+errcode_t ext2fs_file_zero_past_offset(ext2_file_t file, ext2_off64_t offset)
+{
+	ext2_filsys fs = file->fs;
+	char *b = NULL;
+	ext2_off64_t off = offset % fs->blocksize;
+	blk64_t blk;
+	int ret_flags;
+	errcode_t retval;
+
+	if (off == 0)
+		return 0;
+
+	retval = sync_buffer_position(file);
+	if (retval)
+		return retval;
+
+	/* Is there an initialized block at the end? */
+	retval = ext2fs_bmap2(fs, file->ino, NULL, NULL, 0,
+			      offset / fs->blocksize, &ret_flags, &blk);
+	if (retval)
+		return retval;
+	if ((blk == 0) || (ret_flags & BMAP_RET_UNINIT))
+		return 0;
+
+	/* Zero to the end of the block */
+	retval = ext2fs_get_mem(fs->blocksize, &b);
+	if (retval)
+		return retval;
+
+	/* Read/zero/write block */
+	retval = io_channel_read_blk64(fs->io, blk, 1, b);
+	if (retval)
+		goto out;
+
+	memset(b + off, 0, fs->blocksize - off);
+
+	retval = io_channel_write_blk64(fs->io, blk, 1, b);
+	if (retval)
+		goto out;
+
+out:
+	ext2fs_free_mem(&b);
+	return retval;
+}
+
 /*
  * This function sets the size of the file, truncating it if necessary
  *
@@ -434,6 +480,10 @@ errcode_t ext2fs_file_set_size2(ext2_file_t file, ext2_off64_t size)
 			return retval;
 	}
 
+	retval = ext2fs_file_zero_past_offset(file, size);
+	if (retval)
+		return retval;
+
 	if (truncate_block >= old_truncate)
 		return 0;
 

