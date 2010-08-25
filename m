From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [RFC][PATCH V2 4/5] e4defrag: unified bugfix/improvement patches
Date: Wed, 25 Aug 2010 17:52:25 +0900
Message-ID: <4C74D9C9.40608@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:43819 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab0HYJBh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Aug 2010 05:01:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch unifies the following patches that have been posted but not merged
into e2fsprogs yet. And this patch also includes a little bugfix that doesn't
use ext2fs_swab32() in case of getting superblock information. You can use the
latest e4defrag if you apply this patch to e2fsprogs git tree.

Skip "rootfs" entry when checking for ext4 filesystem.
(Posted by Eric Sandeen)
http://marc.info/?l=linux-ext4&m=125238215627201&w=3%29

[RFC][PATCH v2 1/4] e4defrag: output size per extent by -c option
http://marc.info/?l=linux-ext4&m=125602666514382&w=4

[RFC][PATCH v2 2/4] e4defrag: fix file blocks calculation
http://marc.info/?l=linux-ext4&m=125602676114522&w=4

[RFC][PATCH v2 3/4] e4defrag: avoid unsuccessful return in non-privilege
http://marc.info/?l=linux-ext4&m=125602682614647&w=4

[RFC][PATCH v2 3/4] e4defrag: update man page about -c option
http://marc.info/?l=linux-ext4&m=125602694414881&w=4

[PATCH] e2fsprogs: Fix the overflow in e4defrag with 2GB over file
http://marc.info/?l=linux-ext4&m=126993099707986&w=4

Open the source file in read write mode to avoid failures from EXT4_IOC_EXT_MOVE
(Posted by Manish Katiyar)
http://marc.info/?l=linux-ext4&m=126387489114532&w=4

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 misc/e4defrag.8.in |   14 ++--
 misc/e4defrag.c    |  179 +++++++++++++++++++++++++++++++----------------------
 2 files changed, 116 insertions(+), 77 deletions(-)

diff --git a/misc/e4defrag.8.in b/misc/e4defrag.8.in
index 2c43b32..1a15755 100644
--- a/misc/e4defrag.8.in
+++ b/misc/e4defrag.8.in
@@ -35,16 +35,20 @@ point.
 .SH OPTIONS
 .TP
 .B \-c
-Get the fragmentation count and calculate fragmentation score based on it
-before and after defrag. By seeing this score, we can determine whether we
-should execute
+Get a current fragmentation count and an ideal fragmentation count, and
+calculate fragmentation score based on them. By seeing this score, we can
+determine whether we should execute
 .B e4defrag
 to
 .IR target .
 When used with
 .B \-v
-option, the fragmentation count before and after defrag is printed for each
-file.
+option, the current fragmentation count and the ideal fragmentation count are
+printed for each file.
+.IP
+Also this option outputs the average data size in one extent. If you see it,
+you'll find the file has close to ideal extents or not. Note that the maximum
+extent size is 131072KB in ext4 filesystem (if block size is 4KB).
 .IP
 If this option is specified,
 .I target
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 82e3868..61eb259 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -7,13 +7,7 @@
  *         Takashi Sato	<t-sato@yk.jp.nec.com>
  */
 
-#ifndef _LARGEFILE_SOURCE
-#define _LARGEFILE_SOURCE
-#endif
-
-#ifndef _LARGEFILE64_SOURCE
-#define _LARGEFILE64_SOURCE
-#endif
+#define _FILE_OFFSET_BITS 64
 
 #ifndef _GNU_SOURCE
 #define _GNU_SOURCE
@@ -59,8 +53,6 @@
 #define STATISTIC_ERR_MSG_WITH_ERRNO(msg)	\
 	fprintf(stderr, "\t%s:%s\n", (msg), strerror(errno))
 #define min(x, y) (((x) > (y)) ? (y) : (x))
-#define SECTOR_TO_BLOCK(sectors, blocksize) \
-	((sectors) / ((blocksize) >> 9))
 #define CALC_SCORE(ratio) \
 	((ratio) > 10 ? (80 + 20 * (ratio) / 100) : (8 * (ratio)))
 /* Wrap up the free function */
@@ -160,6 +152,7 @@ struct move_extent {
 struct frag_statistic_ino {
 	int now_count;	/* the file's extents count of before defrag */
 	int best_count; /* the best file's extents count */
+	__u64 size_per_ext;	/* size(KB) per extent */
 	float ratio;	/* the ratio of fragmentation */
 	char msg_buffer[PATH_MAX + 1];	/* pathname of the file */
 };
@@ -403,7 +396,7 @@ static int is_ext4(const char *file)
 	const char	*mtab = MOUNTED;
 	char	file_path[PATH_MAX + 1];
 	struct mntent	*mnt = NULL;
-	struct statfs64	fsbuf;
+	struct statfs	fsbuf;
 
 	/* Get full path */
 	if (realpath(file, file_path) == NULL) {
@@ -412,7 +405,7 @@ static int is_ext4(const char *file)
 		return -1;
 	}
 
-	if (statfs64(file_path, &fsbuf) < 0) {
+	if (statfs(file_path, &fsbuf) < 0) {
 		perror("Failed to get filesystem information");
 		PRINT_FILE_NAME(file);
 		return -1;
@@ -430,6 +423,8 @@ static int is_ext4(const char *file)
 	}
 
 	while ((mnt = getmntent(fp)) != NULL) {
+		if (mnt->mnt_fsname[0] != '/')
+			continue;
 		len = strlen(mnt->mnt_dir);
 		ret = memcmp(file_path, mnt->mnt_dir, len);
 		if (ret != 0)
@@ -470,7 +465,7 @@ static int is_ext4(const char *file)
  * @ftwbuf:		the pointer of a struct FTW.
  */
 static int calc_entry_counts(const char *file EXT2FS_ATTR((unused)),
-		const struct stat64 *buf, int flag EXT2FS_ATTR((unused)),
+		const struct stat *buf, int flag EXT2FS_ATTR((unused)),
 		struct FTW *ftwbuf EXT2FS_ATTR((unused)))
 {
 	if (S_ISREG(buf->st_mode))
@@ -580,15 +575,14 @@ static int defrag_fadvise(int fd, struct move_extent defrag_data,
  *
  * @fd:			defrag target file's descriptor.
  * @file:		file name.
- * @buf:		the pointer of the struct stat64.
+ * @blk_count:		file blocks.
  */
-static int check_free_size(int fd, const char *file, const struct stat64 *buf)
+static int check_free_size(int fd, const char *file, ext4_fsblk_t blk_count)
 {
-	ext4_fsblk_t	blk_count;
 	ext4_fsblk_t	free_blk_count;
-	struct statfs64	fsbuf;
+	struct statfs	fsbuf;
 
-	if (fstatfs64(fd, &fsbuf) < 0) {
+	if (fstatfs(fd, &fsbuf) < 0) {
 		if (mode_flag & DETAIL) {
 			PRINT_FILE_NAME(file);
 			PRINT_ERR_MSG_WITH_ERRNO(
@@ -597,9 +591,6 @@ static int check_free_size(int fd, const char *file, const struct stat64 *buf)
 		return -1;
 	}
 
-	/* Target file size measured by filesystem IO blocksize */
-	blk_count = SECTOR_TO_BLOCK(buf->st_blocks, fsbuf.f_bsize);
-
 	/* Compute free space for root and normal user separately */
 	if (current_uid == ROOT_UID)
 		free_blk_count = fsbuf.f_bfree;
@@ -615,7 +606,7 @@ static int check_free_size(int fd, const char *file, const struct stat64 *buf)
 /*
  * file_frag_count() -	Get file fragment count.
  *
- * @fd:			defrag target file's descriptor.
+ * @fd:	defrag target file's descriptor.
  */
 static int file_frag_count(int fd)
 {
@@ -641,12 +632,13 @@ static int file_frag_count(int fd)
  * file_check() -	Check file's attributes.
  *
  * @fd:			defrag target file's descriptor.
- * @buf:		a pointer of the struct stat64.
- * @file:		the file's name.
- * @extents:		the file's extents.
+ * @buf:		a pointer of the struct stat.
+ * @file:		file name.
+ * @extents:		file extents.
+ * @blk_count:		file blocks.
  */
-static int file_check(int fd, const struct stat64 *buf, const char *file,
-		int extents)
+static int file_check(int fd, const struct stat *buf, const char *file,
+		int extents, ext4_fsblk_t blk_count)
 {
 	int	ret;
 	struct flock	lock;
@@ -658,7 +650,7 @@ static int file_check(int fd, const struct stat64 *buf, const char *file,
 	lock.l_len = 0;
 
 	/* Free space */
-	ret = check_free_size(fd, file, buf);
+	ret = check_free_size(fd, file, blk_count);
 	if (ret < 0) {
 		if ((mode_flag & DETAIL) && ret == -ENOSPC) {
 			printf("\033[79;0H\033[K[%u/%u] \"%s\"\t\t"
@@ -1068,6 +1060,23 @@ static int change_physical_to_logical(
 	return 0;
 }
 
+/* get_file_blocks() -  Get total file blocks.
+ *
+ * @ext_list_head:	the extent list head of the target file
+ */
+static ext4_fsblk_t get_file_blocks(struct fiemap_extent_list *ext_list_head)
+{
+	ext4_fsblk_t blk_count = 0;
+	struct fiemap_extent_list *ext_list_tmp = ext_list_head;
+
+	do {
+		blk_count += ext_list_tmp->data.len;
+		ext_list_tmp = ext_list_tmp->next;
+	} while (ext_list_tmp != ext_list_head);
+
+	return blk_count;
+}
+
 /*
  * free_ext() -		Free the extent list.
  *
@@ -1151,14 +1160,14 @@ static int get_superblock_info(const char *file, struct ext4_super_block *sb)
 				strnlen(mnt->mnt_fsname, PATH_MAX));
 	}
 
-	fd = open64(dev_name, O_RDONLY);
+	fd = open(dev_name, O_RDONLY);
 	if (fd < 0) {
 		ret = -1;
 		goto out;
 	}
 
 	/* Set offset to read superblock */
-	ret = lseek64(fd, SUPERBLOCK_OFFSET, SEEK_SET);
+	ret = lseek(fd, SUPERBLOCK_OFFSET, SEEK_SET);
 	if (ret < 0)
 		goto out;
 
@@ -1200,11 +1209,11 @@ static int get_best_count(ext4_fsblk_t block_count)
  * file_statistic() -	Get statistic info of the file's fragments.
  *
  * @file:		the file's name.
- * @buf:		the pointer of the struct stat64.
+ * @buf:		the pointer of the struct stat.
  * @flag:		file type.
  * @ftwbuf:		the pointer of a struct FTW.
  */
-static int file_statistic(const char *file, const struct stat64 *buf,
+static int file_statistic(const char *file, const struct stat *buf,
 			int flag EXT2FS_ATTR((unused)),
 			struct FTW *ftwbuf EXT2FS_ATTR((unused)))
 {
@@ -1212,6 +1221,7 @@ static int file_statistic(const char *file, const struct stat64 *buf,
 	int	ret;
 	int	now_ext_count, best_ext_count = 0, physical_ext_count;
 	int	i, j;
+	__u64	size_per_ext = 0;
 	float	ratio = 0.0;
 	ext4_fsblk_t	blk_count = 0;
 	char	msg_buffer[PATH_MAX + 24];
@@ -1275,7 +1285,7 @@ static int file_statistic(const char *file, const struct stat64 *buf,
 		return 0;
 	}
 
-	fd = open64(file, O_RDONLY);
+	fd = open(file, O_RDONLY);
 	if (fd < 0) {
 		if (mode_flag & DETAIL) {
 			PRINT_FILE_NAME(file);
@@ -1312,12 +1322,14 @@ static int file_statistic(const char *file, const struct stat64 *buf,
 	now_ext_count = get_logical_count(logical_list_head);
 
 	if (current_uid == ROOT_UID) {
-		/* Calculate fragment ratio  */
-		blk_count =
-				SECTOR_TO_BLOCK(buf->st_blocks, block_size);
+		/* Calculate the size per extent  */
+		blk_count = get_file_blocks(logical_list_head);
 
 		best_ext_count = get_best_count(blk_count);
 
+		/* e4defrag rounds size_per_ext up to a blocksize boundary */
+		size_per_ext = blk_count * (buf->st_blksize / 1024) /
+							now_ext_count;
 		ratio = (float)(physical_ext_count - best_ext_count) * 100 /
 							blk_count;
 
@@ -1346,16 +1358,16 @@ static int file_statistic(const char *file, const struct stat64 *buf,
 
 		} else {
 			printf("%-40s%10s/%-10s%9s\n",
-					"<File>", "now", "best", "ratio");
+					"<File>", "now", "best", "size/ext");
 			if (current_uid == ROOT_UID) {
 				if (strlen(file) > 40)
-					printf("%s\n%50d/%-10d%8.2f%%\n",
+					printf("%s\n%50d/%-10d%6llu KB\n",
 						file, now_ext_count,
-						best_ext_count, ratio);
+						best_ext_count, size_per_ext);
 				else
-					printf("%-40s%10d/%-10d%8.2f%%\n",
+					printf("%-40s%10d/%-10d%6llu KB\n",
 						file, now_ext_count,
-						best_ext_count, ratio);
+						best_ext_count, size_per_ext);
 			} else {
 				if (strlen(file) > 40)
 					printf("%s\n%50d/%-10s%7s\n",
@@ -1378,14 +1390,14 @@ static int file_statistic(const char *file, const struct stat64 *buf,
 		if (current_uid == ROOT_UID) {
 			if (strlen(msg_buffer) > 40)
 				printf("\033[79;0H\033[K%s\n"
-						"%50d/%-10d%8.2f%%\n",
+						"%50d/%-10d%6llu KB\n",
 						msg_buffer, now_ext_count,
-						best_ext_count, ratio);
+						best_ext_count, size_per_ext);
 			else
 				printf("\033[79;0H\033[K%-40s"
-						"%10d/%-10d%8.2f%%\n",
+						"%10d/%-10d%6llu KB\n",
 						msg_buffer, now_ext_count,
-						best_ext_count, ratio);
+						best_ext_count, size_per_ext);
 		} else {
 			if (strlen(msg_buffer) > 40)
 				printf("\033[79;0H\033[K%s\n%50d/%-10s%7s\n",
@@ -1401,8 +1413,20 @@ static int file_statistic(const char *file, const struct stat64 *buf,
 	for (i = 0; i < SHOW_FRAG_FILES; i++) {
 		if (ratio >= frag_rank[i].ratio) {
 			for (j = SHOW_FRAG_FILES - 1; j > i; j--) {
-				memcpy(&frag_rank[j], &frag_rank[j - 1],
+				memset(&frag_rank[j], 0,
 					sizeof(struct frag_statistic_ino));
+				strncpy(frag_rank[j].msg_buffer,
+					frag_rank[j - 1].msg_buffer,
+					strnlen(frag_rank[j - 1].msg_buffer,
+					PATH_MAX));
+				frag_rank[j].now_count =
+					frag_rank[j - 1].now_count;
+				frag_rank[j].best_count =
+					frag_rank[j - 1].best_count;
+				frag_rank[j].size_per_ext =
+					frag_rank[j - 1].size_per_ext;
+				frag_rank[j].ratio =
+					frag_rank[j - 1].ratio;
 			}
 			memset(&frag_rank[i], 0,
 					sizeof(struct frag_statistic_ino));
@@ -1410,6 +1434,7 @@ static int file_statistic(const char *file, const struct stat64 *buf,
 						strnlen(file, PATH_MAX));
 			frag_rank[i].now_count = now_ext_count;
 			frag_rank[i].best_count = best_ext_count;
+			frag_rank[i].size_per_ext = size_per_ext;
 			frag_rank[i].ratio = ratio;
 			break;
 		}
@@ -1447,11 +1472,11 @@ static void print_progress(const char *file, loff_t start, loff_t file_size)
  * @fd:			target file descriptor.
  * @donor_fd:		donor file descriptor.
  * @file:			target file name.
- * @buf:			pointer of the struct stat64.
+ * @buf:			pointer of the struct stat.
  * @ext_list_head:	head of the extent list.
  */
 static int call_defrag(int fd, int donor_fd, const char *file,
-	const struct stat64 *buf, struct fiemap_extent_list *ext_list_head)
+	const struct stat *buf, struct fiemap_extent_list *ext_list_head)
 {
 	loff_t	start = 0;
 	unsigned int	page_num;
@@ -1541,11 +1566,11 @@ static int call_defrag(int fd, int donor_fd, const char *file,
  * file_defrag() -		Check file attributes and call ioctl to defrag.
  *
  * @file:		the file's name.
- * @buf:		the pointer of the struct stat64.
+ * @buf:		the pointer of the struct stat.
  * @flag:		file type.
  * @ftwbuf:		the pointer of a struct FTW.
  */
-static int file_defrag(const char *file, const struct stat64 *buf,
+static int file_defrag(const char *file, const struct stat *buf,
 			int flag EXT2FS_ATTR((unused)),
 			struct FTW *ftwbuf EXT2FS_ATTR((unused)))
 {
@@ -1556,6 +1581,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	int	file_frags_start, file_frags_end;
 	int	orig_physical_cnt, donor_physical_cnt = 0;
 	char	tmp_inode_name[PATH_MAX + 8];
+	ext4_fsblk_t			blk_count = 0;
 	struct fiemap_extent_list	*orig_list_physical = NULL;
 	struct fiemap_extent_list	*orig_list_logical = NULL;
 	struct fiemap_extent_list	*donor_list_physical = NULL;
@@ -1605,7 +1631,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 		return 0;
 	}
 
-	fd = open64(file, O_RDONLY);
+	fd = open(file, O_RDWR);
 	if (fd < 0) {
 		if (mode_flag & DETAIL) {
 			PRINT_FILE_NAME(file);
@@ -1641,7 +1667,8 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	/* Count file fragments before defrag */
 	file_frags_start = get_logical_count(orig_list_logical);
 
-	if (file_check(fd, buf, file, file_frags_start) < 0)
+	blk_count = get_file_blocks(orig_list_logical);
+	if (file_check(fd, buf, file, file_frags_start, blk_count) < 0)
 		goto out;
 
 	if (fsync(fd) < 0) {
@@ -1653,8 +1680,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	}
 
 	if (current_uid == ROOT_UID)
-		best =
-		get_best_count(SECTOR_TO_BLOCK(buf->st_blocks, block_size));
+		best = get_best_count(blk_count);
 	else
 		best = 1;
 
@@ -1675,7 +1701,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	memset(tmp_inode_name, 0, PATH_MAX + 8);
 	sprintf(tmp_inode_name, "%.*s.defrag",
 				(int)strnlen(file, PATH_MAX), file);
-	donor_fd = open64(tmp_inode_name, O_WRONLY | O_CREAT | O_EXCL, S_IRUSR);
+	donor_fd = open(tmp_inode_name, O_WRONLY | O_CREAT | O_EXCL, S_IRUSR);
 	if (donor_fd < 0) {
 		if (mode_flag & DETAIL) {
 			PRINT_FILE_NAME(file);
@@ -1822,7 +1848,7 @@ int main(int argc, char *argv[])
 	int	arg_type = -1;
 	int	success_flag = 0;
 	char	dir_name[PATH_MAX + 1];
-	struct stat64	buf;
+	struct stat	buf;
 	struct ext4_super_block sb;
 
 	/* Parse arguments */
@@ -1876,7 +1902,7 @@ int main(int argc, char *argv[])
 		continue;
 #endif
 
-		if (lstat64(argv[i], &buf) < 0) {
+		if (lstat(argv[i], &buf) < 0) {
 			perror(NGMSG_FILE_INFO);
 			PRINT_FILE_NAME(argv[i]);
 			continue;
@@ -1886,7 +1912,7 @@ int main(int argc, char *argv[])
 			/* Block device */
 			if (get_mount_point(argv[i], dir_name, PATH_MAX) < 0)
 				continue;
-			if (lstat64(dir_name, &buf) < 0) {
+			if (lstat(dir_name, &buf) < 0) {
 				perror(NGMSG_FILE_INFO);
 				PRINT_FILE_NAME(argv[i]);
 				continue;
@@ -1940,8 +1966,8 @@ int main(int argc, char *argv[])
 				continue;
 			}
 
-			blocks_per_group = ext2fs_swab32(sb.s_blocks_per_group);
-			feature_incompat = ext2fs_swab32(sb.s_feature_incompat);
+			blocks_per_group = sb.s_blocks_per_group;
+			feature_incompat = sb.s_feature_incompat;
 			log_groups_per_flex = sb.s_log_groups_per_flex;
 		}
 
@@ -1987,20 +2013,21 @@ int main(int argc, char *argv[])
 							   PATH_MAX));
 			}
 
-			nftw64(dir_name, calc_entry_counts, FTW_OPEN_FD, flags);
+			nftw(dir_name, calc_entry_counts, FTW_OPEN_FD, flags);
 
 			if (mode_flag & STATISTIC) {
 				if (mode_flag & DETAIL)
 					printf("%-40s%10s/%-10s%9s\n",
-					"<File>", "now", "best", "ratio");
+					"<File>", "now", "best", "size/ext");
 
 				if (!(mode_flag & DETAIL) &&
 						current_uid != ROOT_UID) {
 					printf(" Done.\n");
+					success_flag = 1;
 					continue;
 				}
 
-				nftw64(dir_name, file_statistic,
+				nftw(dir_name, file_statistic,
 							FTW_OPEN_FD, flags);
 
 				if (succeed_cnt != 0 &&
@@ -2009,24 +2036,28 @@ int main(int argc, char *argv[])
 						printf("\n");
 					printf("%-40s%10s/%-10s%9s\n",
 						"<Fragmented files>", "now",
-						"best", "ratio");
+						"best", "size/ext");
 					for (j = 0; j < SHOW_FRAG_FILES; j++) {
 						if (strlen(frag_rank[j].
 							msg_buffer) > 37) {
 							printf("%d. %s\n%50d/"
-							"%-10d%8.2f%%\n", j + 1,
+							"%-10d%6llu KB\n",
+							j + 1,
 							frag_rank[j].msg_buffer,
 							frag_rank[j].now_count,
 							frag_rank[j].best_count,
-							frag_rank[j].ratio);
+							frag_rank[j].
+								size_per_ext);
 						} else if (strlen(frag_rank[j].
 							msg_buffer) > 0) {
 							printf("%d. %-37s%10d/"
-							"%-10d%8.2f%%\n", j + 1,
+							"%-10d%6llu KB\n",
+							j + 1,
 							frag_rank[j].msg_buffer,
 							frag_rank[j].now_count,
 							frag_rank[j].best_count,
-							frag_rank[j].ratio);
+							frag_rank[j].
+								size_per_ext);
 						} else
 							break;
 					}
@@ -2034,7 +2065,7 @@ int main(int argc, char *argv[])
 				break;
 			}
 			/* File tree walk */
-			nftw64(dir_name, file_defrag, FTW_OPEN_FD, flags);
+			nftw(dir_name, file_defrag, FTW_OPEN_FD, flags);
 			printf("\n\tSuccess:\t\t\t[ %u/%u ]\n", succeed_cnt,
 				total_count);
 			printf("\tFailure:\t\t\t[ %u/%u ]\n",
@@ -2109,19 +2140,23 @@ int main(int argc, char *argv[])
 			} else {
 				float files_ratio = 0.0;
 				float score = 0.0;
+				__u64 size_per_ext = files_block_count *
+						(buf.st_blksize / 1024) /
+						extents_before_defrag;
 				files_ratio = (float)(extents_before_defrag -
 						extents_after_defrag) *
 						100 / files_block_count;
 				score = CALC_SCORE(files_ratio);
 				printf("\n Total/best extents\t\t\t\t%d/%d\n"
-					" Fragmentation ratio\t\t\t\t%.2f%%\n"
-					" Fragmentation score\t\t\t\t%.2f\n",
+					" Average size per extent"
+					"\t\t\t%llu KB\n"
+					" Fragmentation score\t\t\t\t%.0f\n",
 						extents_before_defrag,
 						extents_after_defrag,
-						files_ratio, score);
+						size_per_ext, score);
 				printf(" [0-30 no problem:"
 					" 31-55 a little bit fragmented:"
-					" 55- needs defrag]\n");
+					" 56- needs defrag]\n");
 
 				if (arg_type == DEVNAME)
 					printf(" This device(%s) ", argv[i]);
