From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 31/74] libext2fs: fail fileio write if we can't allocate a
 block
Date: Tue, 10 Dec 2013 17:21:47 -0800
Message-ID: <20131211012147.30655.98480.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42904 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3LKBVx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:21:53 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we're using ext2fs_file_write() to write to a hole in a file,
ensure that we can actually allocate the block before updating i_size.
In other words, don't update i_size and don't return success if we hit
an error while allocating space.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/fileio.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index d092e65..03bdf86 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -297,6 +297,20 @@ errcode_t ext2fs_file_write(ext2_file_t file, const void *buf,
 		if (retval)
 			goto fail;
 
+		/*
+		 * OK, the physical block hasn't been allocated yet.
+		 * Allocate it.
+		 */
+		if (!file->physblock) {
+			retval = ext2fs_bmap2(fs, file->ino, &file->inode,
+					      BMAP_BUFFER,
+					      file->ino ? BMAP_ALLOC : 0,
+					      file->blockno, 0,
+					      &file->physblock);
+			if (retval)
+				goto fail;
+		}
+
 		file->flags |= EXT2_FILE_BUF_DIRTY;
 		memcpy(file->buf+start, ptr, c);
 		file->pos += c;

