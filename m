From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/31] libext2fs: Fix off-by-one error in file truncation
Date: Mon, 30 Sep 2013 18:27:34 -0700
Message-ID: <20131001012734.28415.45404.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22453 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab3JAB1j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:27:39 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When told to truncate a file, ext2fs_file_set_size2 should start with the first
block past the end of the file.  The current calculation jumps one more block
ahead, with the result that it fails to hack off the last block.  Adding
blocksize-1 and dividing is sufficient to find the last block.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/fileio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index ae5cbf1..d875630 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -384,10 +384,10 @@ errcode_t ext2fs_file_set_size2(ext2_file_t file, ext2_off64_t size)
 	EXT2_CHECK_MAGIC(file, EXT2_ET_MAGIC_EXT2_FILE);
 
 	truncate_block = ((size + file->fs->blocksize - 1) >>
-			  EXT2_BLOCK_SIZE_BITS(file->fs->super)) + 1;
+			  EXT2_BLOCK_SIZE_BITS(file->fs->super));
 	old_size = EXT2_I_SIZE(&file->inode);
 	old_truncate = ((old_size + file->fs->blocksize - 1) >>
-		      EXT2_BLOCK_SIZE_BITS(file->fs->super)) + 1;
+		      EXT2_BLOCK_SIZE_BITS(file->fs->super));
 
 	/* If we're writing a large file, set the large_file flag */
 	if (LINUX_S_ISREG(file->inode.i_mode) &&

