From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] debugfs: fix filehandle leak in copy_file()
Date: Tue, 20 May 2014 16:30:35 -0600
Message-ID: <1400625035-61772-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48759 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbaETWak (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2014 18:30:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix a file handle leak for the target file in copy_file() when error
handlers return without closing the file.  Instead, clean up at the
end of the function to handle cleanup in normal and error cases.

Minor other code style cleanups.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 debugfs/debugfs.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 326f41e..e53e0b9 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1578,10 +1578,11 @@ void do_find_free_inode(int argc, char *argv[])
 }
 
 #ifndef READ_ONLY
-static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize, int make_holes)
+static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize,
+			   int make_holes)
 {
 	ext2_file_t	e2_file;
-	errcode_t	retval;
+	errcode_t	retval, close_ret;
 	int		got;
 	unsigned int	written;
 	char		*buf;
@@ -1597,15 +1598,14 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize, int make_hol
 	retval = ext2fs_get_mem(bufsize, &buf);
 	if (retval) {
 		com_err("copy_file", retval, "can't allocate buffer\n");
-		return retval;
+		goto out_close;
 	}
 
 	/* This is used for checking whether the whole block is zero */
 	retval = ext2fs_get_memzero(bufsize, &zero_buf);
 	if (retval) {
-		com_err("copy_file", retval, "can't allocate buffer\n");
-		ext2fs_free_mem(&buf);
-		return retval;
+		com_err("copy_file", retval, "can't allocate zero buffer\n");
+		goto out_free_buf;
 	}
 
 	while (1) {
@@ -1624,7 +1624,8 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize, int make_hol
 			cmp = memcmp(ptr, zero_buf, got);
 			if (cmp == 0) {
 				 /* The whole block is zero, make a hole */
-				retval = ext2fs_file_lseek(e2_file, got, EXT2_SEEK_CUR, NULL);
+				retval = ext2fs_file_lseek(e2_file, got,
+							   EXT2_SEEK_CUR, NULL);
 				if (retval)
 					goto fail;
 				got = 0;
@@ -1642,15 +1643,15 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize, int make_hol
 			ptr += written;
 		}
 	}
-	ext2fs_free_mem(&buf);
-	ext2fs_free_mem(&zero_buf);
-	retval = ext2fs_file_close(e2_file);
-	return retval;
 
 fail:
-	ext2fs_free_mem(&buf);
 	ext2fs_free_mem(&zero_buf);
-	(void) ext2fs_file_close(e2_file);
+out_free_buf:
+	ext2fs_free_mem(&buf);
+out_close:
+	close_ret = ext2fs_file_close(e2_file);
+	if (retval == 0)
+		retval = close_ret;
 	return retval;
 }
 
-- 
1.9.3

