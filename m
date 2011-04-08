From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 11/11] e4defrag: Remove unnecessary code
Date: Fri, 08 Apr 2011 16:53:22 +0900
Message-ID: <4D9EBEF2.4040508@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:58578 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab1DHIOP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 04:14:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove unused header include, duplicate code, and so on.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.c |   53 +++++++++++------------------------------------------
 1 file changed, 11 insertions(+), 42 deletions(-)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 76e84a2..11810a3 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -19,25 +19,17 @@
 #define _GNU_SOURCE
 #endif
 
-#include <ctype.h>
-#include <dirent.h>
-#include <endian.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <ftw.h>
-#include <limits.h>
 #include <mntent.h>
 #include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
 #include <unistd.h>
 #include <linux/fs.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/statfs.h>
-#include <sys/syscall.h>
-#include <sys/vfs.h>
 
 #include "e2p/e2p.h"
 #include "ext2fs/ext2_types.h"
@@ -325,15 +317,14 @@ static int is_ext4(const char *file)
 		strncpy(lost_found_dir, mnt->mnt_dir, PATH_MAX);
 	}
 
-	endmntent(fp);
-	if (strcmp(mnt_type, FS_EXT4) == 0) {
-		FREE(mnt_type);
-		return 0;
-	} else {
-		FREE(mnt_type);
+	ret = strcmp(mnt_type, FS_EXT4);
+	if (ret)
 		PRINT_ERR_MSG(NGMSG_EXT4);
-		return -1;
-	}
+
+	endmntent(fp);
+	FREE(mnt_type);
+
+	return ret ? -1 : 0;
 }
 
 /*
@@ -371,9 +362,6 @@ static int page_in_core(int fd, struct move_extent defrag_data,
 	void	*page = NULL;
 	loff_t	offset, end_offset, length;
 
-	if (vec == NULL || *vec != NULL)
-		return -1;
-
 	/* In mmap, offset should be a multiple of the page size */
 	offset = (loff_t)defrag_data.orig_start * block_size;
 	length = (loff_t)defrag_data.len * block_size;
@@ -498,7 +486,6 @@ static int file_frag_count(int fd)
 	 * ioctl just get file fragment count.
 	 */
 	memset(&fiemap_buf, 0, sizeof(struct fiemap));
-	fiemap_buf.fm_start = 0;
 	fiemap_buf.fm_length = FIEMAP_MAX_OFFSET;
 	fiemap_buf.fm_flags |= FIEMAP_FLAG_SYNC;
 
@@ -824,8 +811,6 @@ static void print_progress(const char *file, loff_t start, loff_t file_size)
 	printf("\033[79;0H\033[K[%u/%u]%s:\t%3d%%",
 		defraged_file_count, total_count, file, min(percent, 100));
 	fflush(stdout);
-
-	return;
 }
 
 /*
@@ -1018,14 +1003,6 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	if (file_check(fd, file, file_frags_start, blk_count) < 0)
 		goto out;
 
-	if (fsync(fd) < 0) {
-		if (mode_flag & DETAIL) {
-			PRINT_FILE_NAME(file);
-			PRINT_ERR_MSG_WITH_ERRNO("Failed to sync(fsync)");
-		}
-		goto out;
-	}
-
 	/*
 	 * Calculate the threshold of perfection.
 	 * NOTE: 2048 means the maximum block region of mballoc.
@@ -1209,9 +1186,6 @@ int main(int argc, char *argv[])
 	struct stat64	buf;
 
 	/* Parse arguments */
-	if (argc == 1)
-		goto out;
-
 	while ((opt = getopt(argc, argv, "v")) != EOF) {
 		switch (opt) {
 		case 'v':
@@ -1270,7 +1244,6 @@ int main(int argc, char *argv[])
 				continue;
 			}
 			arg_type = DIRNAME;
-			strncpy(dir_name, argv[i], strnlen(argv[i], PATH_MAX));
 		} else if (S_ISREG(buf.st_mode)) {
 			/* Regular file */
 			arg_type = FILENAME;
@@ -1299,17 +1272,16 @@ int main(int argc, char *argv[])
 
 		switch (arg_type) {
 		case DIRNAME: {
-			int mount_dir_len = 0;
-			mount_dir_len = strnlen(lost_found_dir, PATH_MAX);
+			int mount_dir_len = strnlen(lost_found_dir, PATH_MAX);
 
 			strncat(lost_found_dir, "/lost+found",
 				PATH_MAX - strnlen(lost_found_dir, PATH_MAX));
 
-			/* Not the case("e4defrag  mount_piont_dir") */
+			/* Not the case("e4defrag  mount_point_dir") */
 			if (dir_name[mount_dir_len] != '\0') {
 				/*
-				 * "e4defrag mount_piont_dir/lost+found"
-				 * or "e4defrag mount_piont_dir/lost+found/"
+				 * "e4defrag mount_point_dir/lost+found"
+				 * or "e4defrag mount_point_dir/lost+found/"
 				 */
 				if (strncmp(lost_found_dir, dir_name,
 					    strnlen(lost_found_dir,
@@ -1322,9 +1294,6 @@ int main(int argc, char *argv[])
 					PRINT_FILE_NAME(argv[i]);
 					continue;
 				}
