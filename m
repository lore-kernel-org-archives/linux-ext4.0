From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH] e2fsprogs: Fix the overflow in e4defrag with 2GB over file
Date: Tue, 30 Mar 2010 15:35:39 +0900
Message-ID: <4BB19BBB.9010509@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:46191 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab0C3Ggf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Mar 2010 02:36:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2fsprogs: Fix the overflow in e4defrag with 2GB over file

From: Akira Fujita <a-fujita@rs.jp.nec.com>

In e4defrag, we use locally defined posix_fallocate interface.
And its "offset" and "len" are defined as off_t (long) type,
their upper limit is 2GB -1 byte.
Thus if we run e4defrag to the file whose size is 2GB over,
the overflow occurs at calling fallocate syscall.

To fix this issue, I add new define _FILE_OFFSET_BITS 64 to use
64bit offset for filesystem related syscalls in e4defrag.c.
(Also this patch includes open mode fix which has been
released but not been merged e2fsprogs git tree yet.
http://lists.openwall.net/linux-ext4/2010/01/19/3)

Reported-by: David Calinski <david@fullrecall.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
  e4defrag.c |   60 +++++++++++++++++++++++++++---------------------------------
  1 file changed, 27 insertions(+), 33 deletions(-)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 82e3868..243949b 100644
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
@@ -403,7 +397,7 @@ static int is_ext4(const char *file)
  	const char	*mtab = MOUNTED;
  	char	file_path[PATH_MAX + 1];
  	struct mntent	*mnt = NULL;
-	struct statfs64	fsbuf;
+	struct statfs	fsbuf;

  	/* Get full path */
  	if (realpath(file, file_path) == NULL) {
@@ -412,7 +406,7 @@ static int is_ext4(const char *file)
  		return -1;
  	}

-	if (statfs64(file_path, &fsbuf) < 0) {
+	if (statfs(file_path, &fsbuf) < 0) {
  		perror("Failed to get filesystem information");
  		PRINT_FILE_NAME(file);
  		return -1;
@@ -470,7 +464,7 @@ static int is_ext4(const char *file)
   * @ftwbuf:		the pointer of a struct FTW.
   */
  static int calc_entry_counts(const char *file EXT2FS_ATTR((unused)),
-		const struct stat64 *buf, int flag EXT2FS_ATTR((unused)),
+		const struct stat *buf, int flag EXT2FS_ATTR((unused)),
  		struct FTW *ftwbuf EXT2FS_ATTR((unused)))
  {
  	if (S_ISREG(buf->st_mode))
@@ -580,15 +574,15 @@ static int defrag_fadvise(int fd, struct move_extent defrag_data,
   *
   * @fd:			defrag target file's descriptor.
   * @file:		file name.
- * @buf:		the pointer of the struct stat64.
+ * @buf:		the pointer of the struct stat.
   */
-static int check_free_size(int fd, const char *file, const struct stat64 *buf)
+static int check_free_size(int fd, const char *file, const struct stat *buf)
  {
  	ext4_fsblk_t	blk_count;
  	ext4_fsblk_t	free_blk_count;
-	struct statfs64	fsbuf;
+	struct statfs	fsbuf;

-	if (fstatfs64(fd, &fsbuf) < 0) {
+	if (fstatfs(fd, &fsbuf) < 0) {
  		if (mode_flag & DETAIL) {
  			PRINT_FILE_NAME(file);
  			PRINT_ERR_MSG_WITH_ERRNO(
@@ -641,11 +635,11 @@ static int file_frag_count(int fd)
   * file_check() -	Check file's attributes.
   *
   * @fd:			defrag target file's descriptor.
- * @buf:		a pointer of the struct stat64.
+ * @buf:		a pointer of the struct stat.
   * @file:		the file's name.
   * @extents:		the file's extents.
   */
-static int file_check(int fd, const struct stat64 *buf, const char *file,
+static int file_check(int fd, const struct stat *buf, const char *file,
  		int extents)
  {
  	int	ret;
@@ -1151,14 +1145,14 @@ static int get_superblock_info(const char *file, struct ext4_super_block *sb)
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

@@ -1200,11 +1194,11 @@ static int get_best_count(ext4_fsblk_t block_count)
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
@@ -1275,7 +1269,7 @@ static int file_statistic(const char *file, const struct stat64 *buf,
  		return 0;
  	}

-	fd = open64(file, O_RDONLY);
+	fd = open(file, O_RDONLY);
  	if (fd < 0) {
  		if (mode_flag & DETAIL) {
  			PRINT_FILE_NAME(file);
@@ -1447,11 +1441,11 @@ static void print_progress(const char *file, loff_t start, loff_t file_size)
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
@@ -1541,11 +1535,11 @@ static int call_defrag(int fd, int donor_fd, const char *file,
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
@@ -1605,7 +1599,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
  		return 0;
  	}

-	fd = open64(file, O_RDONLY);
+	fd = open(file, O_RDWR);
  	if (fd < 0) {
  		if (mode_flag & DETAIL) {
  			PRINT_FILE_NAME(file);
@@ -1675,7 +1669,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
  	memset(tmp_inode_name, 0, PATH_MAX + 8);
  	sprintf(tmp_inode_name, "%.*s.defrag",
  				(int)strnlen(file, PATH_MAX), file);
-	donor_fd = open64(tmp_inode_name, O_WRONLY | O_CREAT | O_EXCL, S_IRUSR);
+	donor_fd = open(tmp_inode_name, O_WRONLY | O_CREAT | O_EXCL, S_IRUSR);
  	if (donor_fd < 0) {
  		if (mode_flag & DETAIL) {
  			PRINT_FILE_NAME(file);
@@ -1822,7 +1816,7 @@ int main(int argc, char *argv[])
  	int	arg_type = -1;
  	int	success_flag = 0;
  	char	dir_name[PATH_MAX + 1];
-	struct stat64	buf;
+	struct stat	buf;
  	struct ext4_super_block sb;

  	/* Parse arguments */
@@ -1876,7 +1870,7 @@ int main(int argc, char *argv[])
  		continue;
  #endif

-		if (lstat64(argv[i], &buf) < 0) {
+		if (lstat(argv[i], &buf) < 0) {
  			perror(NGMSG_FILE_INFO);
  			PRINT_FILE_NAME(argv[i]);
  			continue;
@@ -1886,7 +1880,7 @@ int main(int argc, char *argv[])
  			/* Block device */
  			if (get_mount_point(argv[i], dir_name, PATH_MAX) < 0)
  				continue;
-			if (lstat64(dir_name, &buf) < 0) {
+			if (lstat(dir_name, &buf) < 0) {
  				perror(NGMSG_FILE_INFO);
  				PRINT_FILE_NAME(argv[i]);
  				continue;
@@ -1987,7 +1981,7 @@ int main(int argc, char *argv[])
  							   PATH_MAX));
  			}

-			nftw64(dir_name, calc_entry_counts, FTW_OPEN_FD, flags);
+			nftw(dir_name, calc_entry_counts, FTW_OPEN_FD, flags);

  			if (mode_flag & STATISTIC) {
  				if (mode_flag & DETAIL)
@@ -2000,7 +1994,7 @@ int main(int argc, char *argv[])
  					continue;
  				}

-				nftw64(dir_name, file_statistic,
+				nftw(dir_name, file_statistic,
  							FTW_OPEN_FD, flags);

  				if (succeed_cnt != 0 &&
@@ -2034,7 +2028,7 @@ int main(int argc, char *argv[])
  				break;
  			}
  			/* File tree walk */
-			nftw64(dir_name, file_defrag, FTW_OPEN_FD, flags);
+			nftw(dir_name, file_defrag, FTW_OPEN_FD, flags);
  			printf("\n\tSuccess:\t\t\t[ %u/%u ]\n", succeed_cnt,
  				total_count);
  			printf("\tFailure:\t\t\t[ %u/%u ]\n",
