From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 14/15][e2fsprogs] Add 64-bit mkjournal.c interface
Date: Wed, 20 Aug 2008 12:34:13 -0500
Message-ID: <20080820173413.23412.82350.stgit@gara>
References: <20080820173210.23412.46020.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48129 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589AbYHTRdK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Aug 2008 13:33:10 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7KHX91Y005783
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:33:09 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7KHX9Le202744
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:33:09 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7KHX9OF017940
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:33:09 -0400
In-Reply-To: <20080820173210.23412.46020.stgit@gara>
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
index 8703b79..8985419 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1110,6 +1110,8 @@ extern errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum
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

