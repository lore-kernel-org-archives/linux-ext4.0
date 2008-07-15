From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 14/15][e2fsprogs] Add 64-bit mkjournal.c interface
Date: Tue, 15 Jul 2008 11:51:24 -0500
Message-ID: <20080715165124.28567.2894.stgit@ichigo>
References: <20080715164332.28567.27913.stgit@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:41623 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099AbYGOQvf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2008 12:51:35 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6FGpYdf023787
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:51:34 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6FGpPm2046458
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 10:51:27 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6FGpObf010238
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 10:51:25 -0600
In-Reply-To: <20080715164332.28567.27913.stgit@ichigo>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add 64-bit mkjournal.c interface

Added 64-bit mkjournal.c interface.  Needed to zero inode tables.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/ext2fs.h    |    2 ++
 lib/ext2fs/mkjournal.c |   18 +++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 6881c8a..859f9b6 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1104,6 +1104,8 @@ extern errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum
 /* mkjournal.c */
 extern errcode_t ext2fs_zero_blocks(ext2_filsys fs, blk_t blk, int num,
 				    blk_t *ret_blk, int *ret_count);
+extern errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
+				     blk64_t *ret_blk, int *ret_count); 
 extern errcode_t ext2fs_create_journal_superblock(ext2_filsys fs,
 						  __u32 size, int flags,
 						  char  **ret_jsb);
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index e55dcbd..8c3b93f 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -145,8 +145,8 @@ errout:
  * programs that check for memory leaks happy.)
  */
 #define STRIDE_LENGTH 8
-errcode_t ext2fs_zero_blocks(ext2_filsys fs, blk_t blk, int num,
-			     blk_t *ret_blk, int *ret_count)
+errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
+			      blk64_t *ret_blk, int *ret_count)
 {
 	int		j, count;
 	static char	*buf;
@@ -179,7 +179,7 @@ errcode_t ext2fs_zero_blocks(ext2_filsys fs, blk_t blk, int num,
 			if (count > STRIDE_LENGTH)
 				count = STRIDE_LENGTH;
 		}
-		retval = io_channel_write_blk(fs->io, blk, count, buf);
+		retval = io_channel_write_blk64(fs->io, blk, count, buf);
 		if (retval) {
 			if (ret_count)
 				*ret_count = count;
@@ -192,6 +192,18 @@ errcode_t ext2fs_zero_blocks(ext2_filsys fs, blk_t blk, int num,
 	return 0;
 }
 
+errcode_t ext2fs_zero_blocks(ext2_filsys fs, blk_t blk, int num,
+			     blk_t *ret_blk, int *ret_count)
+{
+	blk64_t ret_blk2;
+	errcode_t retval;
+
+	retval = ext2fs_zero_blocks2(fs, blk, num, &ret_blk2, ret_count);
+	if (retval)
+		*ret_blk = (blk_t) ret_blk2;
+	return retval;
+}
+
 /*
  * Helper function for creating the journal using direct I/O routines
  */

