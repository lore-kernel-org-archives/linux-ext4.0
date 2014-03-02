From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 13/32] libext2fs: file IO routines should handle uninit blocks
Date: Sat, 01 Mar 2014 23:18:01 -0800
Message-ID: <20140302071801.28217.13063.stgit@birch.djwong.org>
References: <20140302071639.28217.57302.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44260 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaCBHSF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Mar 2014 02:18:05 -0500
In-Reply-To: <20140302071639.28217.57302.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The file IO routines do not handle uninit blocks at all.  The read
method should check for the uninit flag and return a buffer of zeroes,
and the write routine should convert unwritten extents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/fileio.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)


diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 5a39c32..607609f 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -123,6 +123,8 @@ errcode_t ext2fs_file_flush(ext2_file_t file)
 {
 	errcode_t	retval;
 	ext2_filsys fs;
+	int		ret_flags;
+	blk64_t		dontcare;
 
 	EXT2_CHECK_MAGIC(file, EXT2_ET_MAGIC_EXT2_FILE);
 	fs = file->fs;
@@ -131,6 +133,22 @@ errcode_t ext2fs_file_flush(ext2_file_t file)
 	    !(file->flags & EXT2_FILE_BUF_DIRTY))
 		return 0;
 
+	/* Is this an uninit block? */
+	if (file->physblock && file->inode.i_flags & EXT4_EXTENTS_FL) {
+		retval = ext2fs_bmap2(fs, file->ino, &file->inode, BMAP_BUFFER,
+				      0, file->blockno, &ret_flags, &dontcare);
+		if (retval)
+			return retval;
+		if (ret_flags & BMAP_RET_UNINIT) {
+			retval = ext2fs_bmap2(fs, file->ino, &file->inode,
+					      BMAP_BUFFER, BMAP_SET,
+					      file->blockno, 0,
+					      &file->physblock);
+			if (retval)
+				return retval;
+		}
+	}
+
 	/*
 	 * OK, the physical block hasn't been allocated yet.
 	 * Allocate it.
@@ -185,15 +203,17 @@ static errcode_t load_buffer(ext2_file_t file, int dontfill)
 {
 	ext2_filsys	fs = file->fs;
 	errcode_t	retval;
+	int		ret_flags;
 
 	if (!(file->flags & EXT2_FILE_BUF_VALID)) {
 		retval = ext2fs_bmap2(fs, file->ino, &file->inode,
-				     BMAP_BUFFER, 0, file->blockno, 0,
+				     BMAP_BUFFER, 0, file->blockno, &ret_flags,
 				     &file->physblock);
 		if (retval)
 			return retval;
 		if (!dontfill) {
-			if (file->physblock) {
+			if (file->physblock &&
+			    !(ret_flags & BMAP_RET_UNINIT)) {
 				retval = io_channel_read_blk64(fs->io,
 							       file->physblock,
 							       1, file->buf);

