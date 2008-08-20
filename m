From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 04/15][e2fsprogs] Use blk64_t for blocks in struct ext2_file.
Date: Wed, 20 Aug 2008 12:33:00 -0500
Message-ID: <20080820173300.23412.56974.stgit@gara>
References: <20080820173210.23412.46020.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:35982 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbYHTRb7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 13:31:59 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7KHVwfc019427
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:31:58 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7KHVuGG046224
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 11:31:57 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7KHVusY011635
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 11:31:56 -0600
In-Reply-To: <20080820173210.23412.46020.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Use blk64_t for blocks in struct ext2_file.

The ext2_file structure is never exposed through the libext2fs API so
it is safe to use 64-bit blocks for blockno and physclock without
breaking the ABI.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/fileio.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
--

 lib/ext2fs/fileio.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 8bf99fb..4b9e1ce 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -25,8 +25,8 @@ struct ext2_file {
 	struct ext2_inode	inode;
 	int 			flags;
 	__u64			pos;
-	blk_t			blockno;
-	blk_t			physblock;
+	blk64_t			blockno;
+	blk64_t			physblock;
 	char 			*buf;
 };
 
@@ -116,9 +116,9 @@ errcode_t ext2fs_file_flush(ext2_file_t file)
 	 * Allocate it.
 	 */
 	if (!file->physblock) {
-		retval = ext2fs_bmap(fs, file->ino, &file->inode,
+		retval = ext2fs_bmap2(fs, file->ino, &file->inode,
 				     BMAP_BUFFER, file->ino ? BMAP_ALLOC : 0,
-				     file->blockno, &file->physblock);
+				     file->blockno, 0, &file->physblock);
 		if (retval)
 			return retval;
 	}
@@ -168,8 +168,8 @@ static errcode_t load_buffer(ext2_file_t file, int dontfill)
 	errcode_t	retval;
 
 	if (!(file->flags & EXT2_FILE_BUF_VALID)) {
-		retval = ext2fs_bmap(fs, file->ino, &file->inode,
-				     BMAP_BUFFER, 0, file->blockno,
+		retval = ext2fs_bmap2(fs, file->ino, &file->inode,
+				     BMAP_BUFFER, 0, file->blockno, 0,
 				     &file->physblock);
 		if (retval)
 			return retval;

