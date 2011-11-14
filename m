From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH v3 09/11] e4defrag: Fix error messages more clearly
Date: Mon, 14 Nov 2011 15:25:13 +0900
Message-ID: <4EC0B449.4010409@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:57380 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab1KNGcO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Nov 2011 01:32:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are some error messages we don't really understand what happens.
This patch fixes those messages.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 7cf0cf0..9938c12 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -324,6 +324,7 @@ static int is_ext4(const char *file)
 
 		mnt_type = realloc(mnt_type, strlen(mnt->mnt_type) + 1);
 		if (mnt_type == NULL) {
+			perror("Failed to allocate memory");
 			endmntent(fp);
 			return -1;
 		}
@@ -518,10 +519,9 @@ static int file_frag_count(int fd)
  *
  * @fd:			defrag target file's descriptor.
  * @file:		file name.
- * @extents:		file extents.
  * @blk_count:		file blocks.
  */
-static int file_check(int fd, const char *file, int extents, blk64_t blk_count)
+static int file_check(int fd, const char *file, blk64_t blk_count)
 {
 	int	ret;
 	struct flock	lock;
@@ -536,9 +536,7 @@ static int file_check(int fd, const char *file, int extents, blk64_t blk_count)
 	ret = check_free_size(fd, file, blk_count);
 	if (ret < 0) {
 		if ((mode_flag & DETAIL) && ret == -ENOSPC) {
-			printf("\033[79;0H\033[K[%u/%u] \"%s\"\t\t"
-				"  extents: %d -> %d\n", defraged_file_count,
-				total_count, file, extents, extents);
+			PRINT_FILE_NAME(file);
 			IN_FTW_PRINT_ERR_MSG(
 			"Defrag size is larger than filesystem's free space");
 		}
@@ -731,11 +729,9 @@ static int get_file_extents(int fd, struct fiemap_extent_list **ext_list_head)
 		!(ext_buf[EXTENT_MAX_COUNT-1].fe_flags
 					& FIEMAP_EXTENT_LAST));
 
-	FREE(fiemap_buf);
-	return 0;
 out:
 	FREE(fiemap_buf);
-	return -1;
+	return (errno == 0) ? 0 : -1;
 }
 
 /*
@@ -877,7 +873,7 @@ static int call_defrag(int fd, int donor_fd, const char *file,
 			if (mode_flag & DETAIL) {
 				printf("\n");
 				PRINT_ERR_MSG_WITH_ERRNO(
-					"Failed to free page");
+					"Failed to synchronize the file");
 			} else {
 				printf("\t[ NG ]\n");
 			}
@@ -1001,13 +997,19 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
 		}
 		goto out;
+	} else if (orig_list == NULL) {
+		if (mode_flag & DETAIL) {
+			PRINT_FILE_NAME(file);
+			IN_FTW_PRINT_ERR_MSG("File has no blocks");
+		}
+		goto out;
 	}
 
 	/* Count file fragments before defrag */
 	file_frags_start = get_exts_count(orig_list);
 
 	blk_count = buf->st_blocks / (block_size / 512);
-	if (file_check(fd, file, file_frags_start, blk_count) < 0)
+	if (file_check(fd, file, blk_count) < 0)
 		goto out;
 
 	if (fsync(fd) < 0) {
@@ -1093,6 +1095,12 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
 		}
 		goto out;
+	} else if (donor_list == NULL) {
+		if (mode_flag & DETAIL) {
+			PRINT_FILE_NAME(file);
+			IN_FTW_PRINT_ERR_MSG("Temporary file was removed");
+		}
+		goto out;
 	}
 
 	donor_score = e2p_get_fragscore(donor_fd, threshold,
@@ -1140,7 +1148,7 @@ check_improvement:
 		file_frags_end = file_frag_count(fd);
 		if (file_frags_end < 0) {
 			printf("\n");
-			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_INFO);
+			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
 			goto out;
 		}
 
@@ -1286,10 +1294,7 @@ int main(int argc, char *argv[])
 		}
 
 		switch (arg_type) {
-		case DIRNAME:
-			printf("ext4 defragmentation for directory(%s)\n",
-					argv[i]);
