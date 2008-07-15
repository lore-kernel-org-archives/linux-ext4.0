From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 04/15][e2fsprogs] Use blk64_t for blocks in struct ext2_file.
Date: Tue, 15 Jul 2008 11:50:27 -0500
Message-ID: <20080715165027.28567.28170.stgit@ichigo>
References: <20080715164332.28567.27913.stgit@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58136 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbYGOQu3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 12:50:29 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6FGoSbc029018
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:50:28 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6FGoSeQ233954
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:50:28 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6FGoSDN031821
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:50:28 -0400
In-Reply-To: <20080715164332.28567.27913.stgit@ichigo>
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

