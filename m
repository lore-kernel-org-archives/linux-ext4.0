From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH v3 11/11] e4defrag: Remove unnecessary code
Date: Mon, 14 Nov 2011 15:25:35 +0900
Message-ID: <4EC0B45F.3060106@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:57408 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab1KNGcT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Nov 2011 01:32:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove unused header include, duplicate code, and so on.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.c |   53 ++++++++++++-----------------------------------------
 1 file changed, 12 insertions(+), 41 deletions(-)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 0b4873d..c07a79b 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -20,25 +20,17 @@
 #endif
 
 #include "config.h"
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
@@ -335,15 +327,14 @@ static int is_ext4(const char *file)
 		strncpy(lost_found_dir, mnt->mnt_dir, PATH_MAX);
 	}
 
-	endmntent(fp);
-	if (strcmp(mnt_type, FS_EXT4) == 0) {
-		FREE(mnt_type);
-		return 0;
-	} else {
-		FREE(mnt_type);
+	ret = strcmp(mnt_type, FS_EXT4);
+	if (ret != 0)
 		PRINT_ERR_MSG(NGMSG_EXT4);
-		return -1;
-	}
+
+	endmntent(fp);
+	FREE(mnt_type);
+
+	return (ret == 0) ? 0 : -1;
 }
 
 /*
@@ -381,9 +372,6 @@ static int page_in_core(int fd, struct move_extent defrag_data,
 	void	*page = NULL;
 	loff_t	offset, end_offset, length;
 
-	if (vec == NULL || *vec != NULL)
-		return -1;
-
 	pagesize = sysconf(_SC_PAGESIZE);
 	if (pagesize < 0)
 		return -1;
@@ -505,7 +493,6 @@ static int file_frag_count(int fd)
 	 * ioctl just get file fragment count.
 	 */
 	memset(&fiemap_buf, 0, sizeof(struct fiemap));
-	fiemap_buf.fm_start = 0;
 	fiemap_buf.fm_length = FIEMAP_MAX_OFFSET;
 	fiemap_buf.fm_flags |= FIEMAP_FLAG_SYNC;
 
@@ -883,7 +870,7 @@ static int call_defrag(int fd, int donor_fd, const char *file,
 
 		/* Free pages */
 		ret = defrag_fadvise(fd, move_data, vec, page_num);
-		if (vec) {
+		if (vec != NULL) {
 			free(vec);
 			vec = NULL;
 		}
@@ -1030,14 +1017,6 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	if (file_check(fd, file, blk_count) < 0)
 		goto out;
 
-	if (fsync(fd) < 0) {
-		if (mode_flag & DETAIL) {
-			PRINT_FILE_NAME(file);
-			PRINT_ERR_MSG_WITH_ERRNO("Failed to sync(fsync)");
-		}
-		goto out;
-	}
-
 	orig_score = e2p_get_fragscore(fd, threshold, EXTENT_MAX_BLKS, &err);
 	if (err != 0) {
 		errno = err;
@@ -1216,9 +1195,6 @@ int main(int argc, char *argv[])
 	struct stat64	buf;
 
 	/* Parse arguments */
-	if (argc == 1)
-		goto out;
-
 	while ((opt = getopt(argc, argv, "Fv")) != EOF) {
 		switch (opt) {
 		case 'F':
@@ -1285,7 +1261,6 @@ int main(int argc, char *argv[])
 				continue;
 			}
 			arg_type = DIRNAME;
-			strncpy(dir_name, argv[i], strnlen(argv[i], PATH_MAX));
 		} else if (S_ISREG(buf.st_mode)) {
 			/* Regular file */
 			arg_type = FILENAME;
@@ -1314,17 +1289,16 @@ int main(int argc, char *argv[])
 
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
@@ -1337,9 +1311,6 @@ int main(int argc, char *argv[])
 					PRINT_FILE_NAME(argv[i]);
 					continue;
 				}
