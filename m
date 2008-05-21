From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [Take2 PATCH 03/10][e2fsprogs] Use blk64_t for blocks in struct
	ext2_file.
Date: Wed, 21 May 2008 12:53:43 -0500
Message-ID: <20080521175343.18810.45821.stgit@gara>
References: <20080521175325.18810.25160.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46607 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757007AbYEURxq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 May 2008 13:53:46 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4LHrjNO000708
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 13:53:45 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4LHripW121446
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 13:53:44 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4LHriN1031712
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 13:53:44 -0400
In-Reply-To: <20080521175325.18810.25160.stgit@gara>
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

