From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH] e4defrag: Fix compile warnings
Date: Fri, 10 Jul 2009 16:45:16 +0900
Message-ID: <4A56F18C.3060705@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:45239 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZGJHqM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jul 2009 03:46:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When compile e2fsprogs git tree with gcc-wall option, we get some warnings about
e4defrag. This patch fixes them.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 e4defrag.c |   71 ++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 36 insertions(+), 35 deletions(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 1c7c012..f747436 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -15,8 +15,6 @@
 #define _LARGEFILE64_SOURCE
 #endif
 
-#define _XOPEN_SOURCE	500
-#define _GNU_SOURCE
 #include <ctype.h>
 #include <dirent.h>
 #include <endian.h>
@@ -357,7 +355,7 @@ __u32 ext2fs_swab32(__u32 val)
  * @len:		area length.
  * @advise:		process flag.
  */
-int fadvise(int fd, loff_t offset, size_t len, int advise)
+static int fadvise(int fd, loff_t offset, size_t len, int advise)
 {
 	return syscall(__NR_fadvise64, fd, offset, len, advise);
 }
@@ -383,7 +381,7 @@ int sync_file_range(int fd, loff_t offset, loff_t length, unsigned int flag)
  * @offset:		file offset.
  * @len:		file size.
  */
-int fallocate(int fd, int mode, loff_t offset, loff_t len)
+static int fallocate(int fd, int mode, loff_t offset, loff_t len)
 {
 	return syscall(__NR_fallocate, fd, mode, offset, len);
 }
@@ -395,10 +393,11 @@ int fallocate(int fd, int mode, loff_t offset, loff_t len)
  * @mount_point:	the mount point.
  * @dir_path_len:	the length of directory.
  */
-int get_mount_point(const char *devname, char *mount_point, int dir_path_len)
+static int get_mount_point(const char *devname, char *mount_point,
+							int dir_path_len)
 {
 	/* Refer to /etc/mtab */
-	char	*mtab = MOUNTED;
+	const char	*mtab = MOUNTED;
 	FILE	*fp = NULL;
 	struct mntent	*mnt = NULL;
 
@@ -431,14 +430,14 @@ int get_mount_point(const char *devname, char *mount_point, int dir_path_len)
  *
  * @file:		the file's name.
  */
-int is_ext4(const char *file)
+static int is_ext4(const char *file)
 {
 	int 	maxlen = 0;
 	int	len, ret;
 	FILE	*fp = NULL;
 	char	*mnt_type = NULL;
 	/* Refer to /etc/mtab */
-	char	*mtab = MOUNTED;
+	const char	*mtab = MOUNTED;
 	char	file_path[PATH_MAX + 1];
 	struct mntent	*mnt = NULL;
 	struct statfs64	fsbuf;
@@ -507,7 +506,7 @@ int is_ext4(const char *file)
  * @flag:		file type.
  * @ftwbuf:		the pointer of a struct FTW.
  */
-int calc_entry_counts(const char *file EXT2FS_ATTR((unused)),
+static int calc_entry_counts(const char *file EXT2FS_ATTR((unused)),
 		const struct stat64 *buf, int flag EXT2FS_ATTR((unused)),
 		struct FTW *ftwbuf EXT2FS_ATTR((unused)))
 {
@@ -527,7 +526,7 @@ int calc_entry_counts(const char *file EXT2FS_ATTR((unused)),
  * @vec:		page state array.
  * @page_num:		page number.
  */
-int page_in_core(int fd, struct move_extent defrag_data,
+static int page_in_core(int fd, struct move_extent defrag_data,
 			unsigned char **vec, unsigned int *page_num)
 {
 	long	pagesize = sysconf(_SC_PAGESIZE);
@@ -573,7 +572,7 @@ int page_in_core(int fd, struct move_extent defrag_data,
  * @vec:		page state array.
  * @page_num:		page number.
  */
-int defrag_fadvise(int fd, struct move_extent defrag_data,
+static int defrag_fadvise(int fd, struct move_extent defrag_data,
 		   unsigned char *vec, unsigned int page_num)
 {
 	int	flag = 1;
@@ -620,7 +619,7 @@ int defrag_fadvise(int fd, struct move_extent defrag_data,
  * @file:		file name.
  * @buf:		the pointer of the struct stat64.
  */
-int check_free_size(int fd, const char *file, const struct stat64 *buf)
+static int check_free_size(int fd, const char *file, const struct stat64 *buf)
 {
 	ext4_fsblk_t	blk_count;
 	ext4_fsblk_t	free_blk_count;
@@ -655,7 +654,7 @@ int check_free_size(int fd, const char *file, const struct stat64 *buf)
  *
  * @fd:			defrag target file's descriptor.
  */
-int file_frag_count(int fd)
+static int file_frag_count(int fd)
 {
 	int	ret;
 	struct fiemap	fiemap_buf;
@@ -683,7 +682,7 @@ int file_frag_count(int fd)
  * @file:		the file's name.
  * @extents:		the file's extents.
  */
-int file_check(int fd, const struct stat64 *buf, const char *file,
+static int file_check(int fd, const struct stat64 *buf, const char *file,
 		int extents)
 {
 	int	ret;
@@ -747,7 +746,7 @@ int file_check(int fd, const struct stat64 *buf, const char *file,
  * @ext_list_head:	the head of logical extent list.
  * @ext:		the extent element which will be inserted.
  */
-int insert_extent_by_logical(struct fiemap_extent_list **ext_list_head,
+static int insert_extent_by_logical(struct fiemap_extent_list **ext_list_head,
 			struct fiemap_extent_list *ext)
 {
 	struct fiemap_extent_list	*ext_list_tmp = *ext_list_head;
@@ -805,7 +804,7 @@ out:
  * @ext_list_head:	the head of physical extent list.
  * @ext:		the extent element which will be inserted.
  */
-int insert_extent_by_physical(struct fiemap_extent_list **ext_list_head,
+static int insert_extent_by_physical(struct fiemap_extent_list **ext_list_head,
 			struct fiemap_extent_list *ext)
 {
 	struct fiemap_extent_list	*ext_list_tmp = *ext_list_head;
@@ -863,7 +862,7 @@ out:
  * @ext_group_head:		the head of a exts_group list.
  * @exts_group:			the exts_group element which will be inserted.
  */
-int insert_exts_group(struct fiemap_extent_group **ext_group_head,
+static int insert_exts_group(struct fiemap_extent_group **ext_group_head,
 				struct fiemap_extent_group *exts_group)
 {
 	struct fiemap_extent_group	*ext_group_tmp = NULL;
@@ -893,7 +892,7 @@ int insert_exts_group(struct fiemap_extent_group **ext_group_head,
  * @ext_list_head:		the head of the extent list.
  * @ext_group_head:		the head of the target exts_group list.
  */
-int join_extents(struct fiemap_extent_list *ext_list_head,
+static int join_extents(struct fiemap_extent_list *ext_list_head,
 		struct fiemap_extent_group **ext_group_head)
 {
 	__u64	len = ext_list_head->data.len;
@@ -948,7 +947,7 @@ int join_extents(struct fiemap_extent_list *ext_list_head,
  * @fd:			defrag target file's descriptor.
  * @ext_list_head:	the head of the extent list.
  */
-int get_file_extents(int fd, struct fiemap_extent_list **ext_list_head)
+static int get_file_extents(int fd, struct fiemap_extent_list **ext_list_head)
 {
 	__u32	i;
 	int	ret;
@@ -1028,7 +1027,7 @@ out:
  *
  * @logical_list_head:	the head of the logical extent list.
  */
-int get_logical_count(struct fiemap_extent_list *logical_list_head)
+static int get_logical_count(struct fiemap_extent_list *logical_list_head)
 {
 	int ret = 0;
 	struct fiemap_extent_list *ext_list_tmp  = logical_list_head;
@@ -1046,7 +1045,7 @@ int get_logical_count(struct fiemap_extent_list *logical_list_head)
  *
  * @physical_list_head:	the head of the physical extent list.
  */
-int get_physical_count(struct fiemap_extent_list *physical_list_head)
+static int get_physical_count(struct fiemap_extent_list *physical_list_head)
 {
 	int ret = 0;
 	struct fiemap_extent_list *ext_list_tmp = physical_list_head;
@@ -1070,8 +1069,9 @@ int get_physical_count(struct fiemap_extent_list *physical_list_head)
  * @physical_list_head:	the head of physical extent list.
  * @logical_list_head:	the head of logical extent list.
  */
-int change_physical_to_logical(struct fiemap_extent_list **physical_list_head,
-				struct fiemap_extent_list **logical_list_head)
+static int change_physical_to_logical(
+			struct fiemap_extent_list **physical_list_head,
+			struct fiemap_extent_list **logical_list_head)
 {
 	int ret;
 	struct fiemap_extent_list *ext_list_tmp = *physical_list_head;
@@ -1110,7 +1110,7 @@ int change_physical_to_logical(struct fiemap_extent_list **physical_list_head,
  *
  * @ext_list_head:	the extent list head of which will be free.
  */
-void free_ext(struct fiemap_extent_list *ext_list_head)
+static void free_ext(struct fiemap_extent_list *ext_list_head)
 {
 	struct fiemap_extent_list	*ext_list_tmp = NULL;
 
@@ -1132,7 +1132,7 @@ void free_ext(struct fiemap_extent_list *ext_list_head)
  *
  * @*ext_group_head:	the exts_group list head which will be free.
  */
- void free_exts_group(struct fiemap_extent_group *ext_group_head)
+static void free_exts_group(struct fiemap_extent_group *ext_group_head)
 {
 	struct fiemap_extent_group	*ext_group_tmp = NULL;
 
@@ -1155,10 +1155,10 @@ void free_ext(struct fiemap_extent_list *ext_list_head)
  * @file:		the file's name.
  * @sb:		the pointer of the struct ext4_super_block.
  */
-int get_superblock_info(const char *file, struct ext4_super_block *sb)
+static int get_superblock_info(const char *file, struct ext4_super_block *sb)
 {
 	/* Refer to /etc/mtab */
-	char	*mtab = MOUNTED;
+	const char	*mtab = MOUNTED;
 	FILE	*fp = NULL;
 
 	int	fd = -1;
@@ -1215,7 +1215,7 @@ out:
  *
  * @block_count:		the file's physical block count.
  */
-int get_best_count(ext4_fsblk_t block_count)
+static int get_best_count(ext4_fsblk_t block_count)
 {
 	int ret;
 	unsigned int flex_bg_num;
@@ -1241,13 +1241,13 @@ int get_best_count(ext4_fsblk_t block_count)
  * @flag:		file type.
  * @ftwbuf:		the pointer of a struct FTW.
  */
-int file_statistic(const char *file, const struct stat64 *buf,
+static int file_statistic(const char *file, const struct stat64 *buf,
 			int flag EXT2FS_ATTR((unused)),
 			struct FTW *ftwbuf EXT2FS_ATTR((unused)))
 {
 	int	fd;
 	int	ret;
-	int	now_ext_count, best_ext_count, physical_ext_count;
+	int	now_ext_count, best_ext_count = 0, physical_ext_count;
 	int	i, j;
 	float	ratio = 0.0;
 	ext4_fsblk_t	blk_count = 0;
@@ -1468,7 +1468,7 @@ out:
  * @start:		logical offset for defrag target file
  * @file_size:		defrag target filesize
  */
-void print_progress(const char *file, loff_t start, loff_t file_size)
+static void print_progress(const char *file, loff_t start, loff_t file_size)
 {
 	int percent = (start * 100) / file_size;
 	printf("\033[79;0H\033[K[%u/%u]%s:\t%3d%%",
@@ -1487,7 +1487,7 @@ void print_progress(const char *file, loff_t start, loff_t file_size)
  * @buf:			pointer of the struct stat64.
  * @ext_list_head:	head of the extent list.
  */
-int call_defrag(int fd, int donor_fd, const char *file,
+static int call_defrag(int fd, int donor_fd, const char *file,
 	const struct stat64 *buf, struct fiemap_extent_list *ext_list_head)
 {
 	loff_t	start = 0;
@@ -1582,7 +1582,7 @@ int call_defrag(int fd, int donor_fd, const char *file,
  * @flag:		file type.
  * @ftwbuf:		the pointer of a struct FTW.
  */
-int file_defrag(const char *file, const struct stat64 *buf,
+static int file_defrag(const char *file, const struct stat64 *buf,
 			int flag EXT2FS_ATTR((unused)),
 			struct FTW *ftwbuf EXT2FS_ATTR((unused)))
 {
@@ -1591,7 +1591,7 @@ int file_defrag(const char *file, const struct stat64 *buf,
 	int	ret;
 	int	best;
 	int	file_frags_start, file_frags_end;
-	int	orig_physical_cnt, donor_physical_cnt;
+	int	orig_physical_cnt, donor_physical_cnt = 0;
 	char	tmp_inode_name[PATH_MAX + 8];
 	struct fiemap_extent_list	*orig_list_physical = NULL;
 	struct fiemap_extent_list	*orig_list_logical = NULL;
@@ -1710,7 +1710,8 @@ int file_defrag(const char *file, const struct stat64 *buf,
 
 	/* Create donor inode */
 	memset(tmp_inode_name, 0, PATH_MAX + 8);
-	sprintf(tmp_inode_name, "%.*s.defrag",  strnlen(file, PATH_MAX), file);
+	sprintf(tmp_inode_name, "%.*s.defrag",
+				(int)strnlen(file, PATH_MAX), file);
 	donor_fd = open64(tmp_inode_name, O_WRONLY | O_CREAT | O_EXCL, S_IRUSR);
 	if (donor_fd < 0) {
 		if (mode_flag & DETAIL) {

