From: number9652 <number9652@yahoo.com>
Subject: [PATCH] libext2fs: ensure validate_entry doesn't read beyond blocksize
Date: Fri, 12 Jun 2009 09:04:32 -0700 (PDT)
Message-ID: <687495.40108.qm@web43515.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n77.bullet.mail.sp1.yahoo.com ([98.136.44.45]:38028 "HELO
	n77.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760913AbZFLQEa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Jun 2009 12:04:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


ext2fs_validate_entry would read beyond the end of the block to get dirent->rec_len for certain arguments (like if blocksize == final_offset).  This patch adds a check so that doesn't happen, and changes the types of the arguments to avoid a compiler warning.

Signed-off-by: Nic Case <number9652@yahoo.com>

diff --git a/e2fsprogs-1.41.5-orig/lib/ext2fs/dir_iterate.c b/e2fsprogs-1.41.5/lib/ext2fs/dir_iterate.c
index 1f8cf8f..6be066c 100644
--- a/e2fsprogs-1.41.5-orig/lib/ext2fs/dir_iterate.c
+++ b/e2fsprogs-1.41.5/lib/ext2fs/dir_iterate.c
@@ -29,13 +29,15 @@
  * undeleted entry.  Returns 1 if the deleted entry looks valid, zero
  * if not valid.
  */
-static int ext2fs_validate_entry(ext2_filsys fs, char *buf, int offset,
-				 int final_offset)
+static int ext2fs_validate_entry(ext2_filsys fs, char *buf,
+				 unsigned int offset,
+				 unsigned int final_offset)
 {
 	struct ext2_dir_entry *dirent;
 	int	rec_len;
+	int dirent_min_len = 12;
 
-	while (offset < final_offset) {
+	while (offset < final_offset &&	offset <= fs->blocksize - dirent_min_len) {
 		dirent = (struct ext2_dir_entry *)(buf + offset);
 		rec_len = (dirent->rec_len || fs->blocksize < 65536) ?
 			dirent->rec_len : 65536;



      

