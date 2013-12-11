From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 14/74] libext2fs: fileio should use 64bit io routines
Date: Tue, 10 Dec 2013 17:19:54 -0800
Message-ID: <20131211011954.30655.12129.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26148 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab3LKBUA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:20:00 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When reading or writing file blocks, use the IO manager routines that
can handle 64bit block numbers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/fileio.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index a6bcbe7..d092e65 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -142,8 +142,7 @@ errcode_t ext2fs_file_flush(ext2_file_t file)
 			return retval;
 	}
 
-	retval = io_channel_write_blk(fs->io, file->physblock,
-				      1, file->buf);
+	retval = io_channel_write_blk64(fs->io, file->physblock, 1, file->buf);
 	if (retval)
 		return retval;
 
@@ -194,9 +193,9 @@ static errcode_t load_buffer(ext2_file_t file, int dontfill)
 			return retval;
 		if (!dontfill) {
 			if (file->physblock) {
-				retval = io_channel_read_blk(fs->io,
-							     file->physblock,
-							     1, file->buf);
+				retval = io_channel_read_blk64(fs->io,
+							       file->physblock,
+							       1, file->buf);
 				if (retval)
 					return retval;
 			} else

