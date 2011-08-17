From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH v2 11/12] e4defrag: Fix error messages more clearly
Date: Wed, 17 Aug 2011 16:48:05 +0900
Message-ID: <4E4B7235.3040605@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:35703 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab1HQIET (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Aug 2011 04:04:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are some error messages we don't really understand what happens.
This patch fixes those messages.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index ec1b15a..df532d3 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -323,6 +323,7 @@ static int is_ext4(const char *file)
 
 		mnt_type = realloc(mnt_type, strlen(mnt->mnt_type) + 1);
 		if (mnt_type == NULL) {
+			perror("Failed to allocate memory");
 			endmntent(fp);
 			return -1;
 		}
@@ -727,11 +728,9 @@ static int get_file_extents(int fd, struct fiemap_extent_list **ext_list_head)
 		!(ext_buf[EXTENT_MAX_COUNT-1].fe_flags
 					& FIEMAP_EXTENT_LAST));
 
-	FREE(fiemap_buf);
-	return 0;
 out:
 	FREE(fiemap_buf);
-	return -1;
+	return errno ? -1 : 0;
 }
 
 /*
@@ -873,7 +872,7 @@ static int call_defrag(int fd, int donor_fd, const char *file,
 			if (mode_flag & DETAIL) {
 				printf("\n");
 				PRINT_ERR_MSG_WITH_ERRNO(
-					"Failed to free page");
+					"Failed to synchronize the file");
 			} else {
 				printf("\t[ NG ]\n");
 			}
@@ -971,15 +970,6 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 		return 0;
 	}
 
-	/* Has no blocks */
-	if (buf->st_blocks == 0) {
-		if (mode_flag & DETAIL) {
-			PRINT_FILE_NAME(file);
-			IN_FTW_PRINT_ERR_MSG("File has no blocks");
-		}
-		return 0;
-	}
-
 	fd = open64(file, O_RDWR);
 	if (fd < 0) {
 		if (mode_flag & DETAIL) {
@@ -997,6 +987,12 @@ static int file_defrag(const char *file, const struct stat64 *buf,
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
@@ -1089,6 +1085,12 @@ static int file_defrag(const char *file, const struct stat64 *buf,
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
@@ -1136,7 +1138,7 @@ check_improvement:
 		file_frags_end = file_frag_count(fd);
 		if (file_frags_end < 0) {
 			printf("\n");
-			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_INFO);
+			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
 			goto out;
 		}
 
@@ -1282,10 +1284,7 @@ int main(int argc, char *argv[])
 		}
 
 		switch (arg_type) {
-		case DIRNAME:
-			printf("ext4 defragmentation for directory(%s)\n",
-					argv[i]);
