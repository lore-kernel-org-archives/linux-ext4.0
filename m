From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 04/11] e4defrag: Remove old fragmentation score calculation
 code
Date: Fri, 08 Apr 2011 16:52:14 +0900
Message-ID: <4D9EBEAE.7050207@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:38778 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab1DHIHM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 04:07:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove the old fragmentation score calculation to replace with
get_fragment_score().

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.c |  349 ++++----------------------------------------------------
 1 file changed, 29 insertions(+), 320 deletions(-)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 0fb61e0..58fd9be 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -32,7 +32,6 @@
 #include <string.h>
 #include <unistd.h>
 #include <ext2fs/ext2_types.h>
-#include <ext2fs/ext2fs.h>
 #include <linux/fs.h>
 #include <sys/ioctl.h>
 #include <ext2fs/fiemap.h>
@@ -92,9 +91,6 @@
 /* Magic number for ext4 */
 #define EXT4_SUPER_MAGIC	0xEF53
 
-/* Definition of flex_bg */
-#define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
-
 /* The following macro is used for ioctl FS_IOC_FIEMAP
  * EXTENT_MAX_COUNT:	the maximum number of extents for exchanging between
  *			kernel-space and user-space per ioctl
@@ -156,10 +152,6 @@ unsigned int	frag_files_after_defrag;
 unsigned int	regular_count;
 unsigned int	succeed_cnt;
 unsigned int	total_count;
-__u8 log_groups_per_flex;
-__u32 blocks_per_group;
-__u32 feature_incompat;
-
 
 /* Local definitions of some syscalls glibc may not yet have */
 
@@ -276,7 +268,7 @@ static int get_mount_point(const char *devname, char *mount_point,
  *
  * @file:		the file's name.
  */
-static int is_ext4(const char *file, char *devname)
+static int is_ext4(const char *file)
 {
 	int 	maxlen = 0;
 	int	len, ret;
@@ -333,7 +325,6 @@ static int is_ext4(const char *file, char *devname)
 		memset(mnt_type, 0, strlen(mnt->mnt_type) + 1);
 		strncpy(mnt_type, mnt->mnt_type, strlen(mnt->mnt_type));
 		strncpy(lost_found_dir, mnt->mnt_dir, PATH_MAX);
-		strncpy(devname, mnt->mnt_fsname, strlen(mnt->mnt_fsname) + 1);
 	}
 
 	endmntent(fp);
@@ -587,119 +578,26 @@ static int file_check(int fd, const struct stat64 *buf, const char *file,
 }
 
 /*
- * insert_extent_by_logical() -	Sequentially insert extent by logical.
+ * insert_exts_list() -	insert the extent into extent list.
  *
- * @ext_list_head:	the head of logical extent list.
+ * @ext_list_head:	the head of extent list.
  * @ext:		the extent element which will be inserted.
  */
-static int insert_extent_by_logical(struct fiemap_extent_list **ext_list_head,
+static void insert_exts_list(struct fiemap_extent_list **ext_list_head,
 			struct fiemap_extent_list *ext)
 {
-	struct fiemap_extent_list	*ext_list_tmp = *ext_list_head;
-
-	if (ext == NULL)
-		goto out;
-
-	/* First element */
-	if (*ext_list_head == NULL) {
-		(*ext_list_head) = ext;
-		(*ext_list_head)->prev = *ext_list_head;
-		(*ext_list_head)->next = *ext_list_head;
-		return 0;
-	}
-
-	if (ext->data.logical <= ext_list_tmp->data.logical) {
-		/* Insert before head */
-		if (ext_list_tmp->data.logical <
-			ext->data.logical + ext->data.len)
-			/* Overlap */
-			goto out;
-		/* Adjust head */
-		*ext_list_head = ext;
-	} else {
-		/* Insert into the middle or last of the list */
-		do {
-			if (ext->data.logical < ext_list_tmp->data.logical)
-				break;
-			ext_list_tmp = ext_list_tmp->next;
-		} while (ext_list_tmp != (*ext_list_head));
-		if (ext->data.logical <
-		    ext_list_tmp->prev->data.logical +
-			ext_list_tmp->prev->data.len)
-			/* Overlap */
-			goto out;
-
-		if (ext_list_tmp != *ext_list_head &&
-		    ext_list_tmp->data.logical <
-		    ext->data.logical + ext->data.len)
-			/* Overlap */
-			goto out;
-	}
-	ext_list_tmp = ext_list_tmp->prev;
-	/* Insert "ext" after "ext_list_tmp" */
-	insert(ext_list_tmp, ext);
-	return 0;
-out:
-	errno = EINVAL;
-	return -1;
-}
-
-/*
- * insert_extent_by_physical() -	Sequentially insert extent by physical.
- *
- * @ext_list_head:	the head of physical extent list.
- * @ext:		the extent element which will be inserted.
- */
-static int insert_extent_by_physical(struct fiemap_extent_list **ext_list_head,
-			struct fiemap_extent_list *ext)
-{
-	struct fiemap_extent_list	*ext_list_tmp = *ext_list_head;
-
-	if (ext == NULL)
-		goto out;
+	struct fiemap_extent_list *ext_list_tmp;
 
 	/* First element */
 	if (*ext_list_head == NULL) {
 		(*ext_list_head) = ext;
 		(*ext_list_head)->prev = *ext_list_head;
 		(*ext_list_head)->next = *ext_list_head;
-		return 0;
+		return;
 	}
 
-	if (ext->data.physical <= ext_list_tmp->data.physical) {
-		/* Insert before head */
-		if (ext_list_tmp->data.physical <
-					ext->data.physical + ext->data.len)
-			/* Overlap */
-			goto out;
-		/* Adjust head */
-		*ext_list_head = ext;
-	} else {
-		/* Insert into the middle or last of the list */
-		do {
-			if (ext->data.physical < ext_list_tmp->data.physical)
-				break;
-			ext_list_tmp = ext_list_tmp->next;
-		} while (ext_list_tmp != (*ext_list_head));
-		if (ext->data.physical <
-		    ext_list_tmp->prev->data.physical +
-				ext_list_tmp->prev->data.len)
-			/* Overlap */
-			goto out;
-
-		if (ext_list_tmp != *ext_list_head &&
-		    ext_list_tmp->data.physical <
-				ext->data.physical + ext->data.len)
-			/* Overlap */
-			goto out;
-	}
-	ext_list_tmp = ext_list_tmp->prev;
-	/* Insert "ext" after "ext_list_tmp" */
+	ext_list_tmp = (*ext_list_head)->prev;
 	insert(ext_list_tmp, ext);
-	return 0;
-out:
-	errno = EINVAL;
-	return -1;
 }
 
 /*
@@ -708,28 +606,21 @@ out:
  * @ext_group_head:		the head of a exts_group list.
  * @exts_group:			the exts_group element which will be inserted.
  */
-static int insert_exts_group(struct fiemap_extent_group **ext_group_head,
+static void insert_exts_group(struct fiemap_extent_group **ext_group_head,
 				struct fiemap_extent_group *exts_group)
 {
-	struct fiemap_extent_group	*ext_group_tmp = NULL;
-
-	if (exts_group == NULL) {
-		errno = EINVAL;
-		return -1;
-	}
+	struct fiemap_extent_group *ext_group_tmp;
 
 	/* Initialize list */
 	if (*ext_group_head == NULL) {
 		(*ext_group_head) = exts_group;
 		(*ext_group_head)->prev = *ext_group_head;
 		(*ext_group_head)->next = *ext_group_head;
-		return 0;
+		return;
 	}
 
 	ext_group_tmp = (*ext_group_head)->prev;
 	insert(ext_group_tmp, exts_group);
-
-	return 0;
 }
 
 /*
@@ -765,11 +656,8 @@ static int join_extents(struct fiemap_extent_list *ext_list_head,
 			ext_group_tmp->start = ext_list_start;
 			ext_group_tmp->end = ext_list_tmp->prev;
 
-			if (insert_exts_group(ext_group_head,
-				ext_group_tmp) < 0) {
-				FREE(ext_group_tmp);
-				return -1;
-			}
+			insert_exts_group(ext_group_head, ext_group_tmp);
+
 			ext_list_start = ext_list_tmp;
 			len = ext_list_tmp->data.len;
 			ext_list_tmp = ext_list_tmp->next;
@@ -842,12 +730,7 @@ static int get_file_extents(int fd, struct fiemap_extent_list **ext_list_head)
 			ext_list->data.len = ext_buf[i].fe_length
 						/ block_size;
 
-			ret = insert_extent_by_physical(
-					ext_list_head, ext_list);
-			if (ret < 0) {
-				FREE(ext_list);
-				goto out;
-			}
+			insert_exts_list(ext_list_head, ext_list);
 		}
 		/* Record file's logical offset this time */
 		pos = ext_buf[EXTENT_MAX_COUNT-1].fe_logical +
@@ -869,88 +752,23 @@ out:
 }
 
 /*
- * get_logical_count() -	Get the file logical extents count.
+ * get_exts_count() -	Get the file extents count.
  *
- * @logical_list_head:	the head of the logical extent list.
+ * @ext_list_head:	the head of the extent list.
  */
-static int get_logical_count(struct fiemap_extent_list *logical_list_head)
+static int get_exts_count(struct fiemap_extent_list *ext_list_head)
 {
 	int ret = 0;
-	struct fiemap_extent_list *ext_list_tmp  = logical_list_head;
+	struct fiemap_extent_list *ext_list_tmp  = ext_list_head;
 
 	do {
 		ret++;
 		ext_list_tmp = ext_list_tmp->next;
-	} while (ext_list_tmp != logical_list_head);
-
-	return ret;
-}
-
-/*
- * get_physical_count() -	Get the file physical extents count.
- *
- * @physical_list_head:	the head of the physical extent list.
- */
-static int get_physical_count(struct fiemap_extent_list *physical_list_head)
-{
-	int ret = 0;
-	struct fiemap_extent_list *ext_list_tmp = physical_list_head;
-
-	do {
-		if ((ext_list_tmp->data.physical + ext_list_tmp->data.len)
-				!= ext_list_tmp->next->data.physical) {
-			/* This extent and next extent are not continuous. */
-			ret++;
-		}
-
-		ext_list_tmp = ext_list_tmp->next;
-	} while (ext_list_tmp != physical_list_head);
+	} while (ext_list_tmp != ext_list_head);
 
 	return ret;
 }
 
-/*
- * change_physical_to_logical() -	Change list from physical to logical.
- *
- * @physical_list_head:	the head of physical extent list.
- * @logical_list_head:	the head of logical extent list.
- */
-static int change_physical_to_logical(
-			struct fiemap_extent_list **physical_list_head,
-			struct fiemap_extent_list **logical_list_head)
-{
-	int ret;
-	struct fiemap_extent_list *ext_list_tmp = *physical_list_head;
-	struct fiemap_extent_list *ext_list_next = ext_list_tmp->next;
-
-	while (1) {
-		if (ext_list_tmp == ext_list_next) {
-			ret = insert_extent_by_logical(
-				logical_list_head, ext_list_tmp);
-			if (ret < 0)
-				return -1;
-
-			*physical_list_head = NULL;
-			break;
-		}
-
-		ext_list_tmp->prev->next = ext_list_tmp->next;
-		ext_list_tmp->next->prev = ext_list_tmp->prev;
-		*physical_list_head = ext_list_next;
-
-		ret = insert_extent_by_logical(
-			logical_list_head, ext_list_tmp);
-		if (ret < 0) {
-			FREE(ext_list_tmp);
-			return -1;
-		}
-		ext_list_tmp = ext_list_next;
-		ext_list_next = ext_list_next->next;
-	}
-
-	return 0;
-}
-
 /* get_file_blocks() -  Get total file blocks.
  *
  * @ext_list_head:	the extent list head of the target file
@@ -1013,28 +831,6 @@ static void free_exts_group(struct fiemap_extent_group *ext_group_head)
 }
 
 /*
- * get_best_count() -	Get the file best extents count.
- *
- * @block_count:		the file's physical block count.
- */
-static int get_best_count(ext4_fsblk_t block_count)
-{
-	int ret;
-	unsigned int flex_bg_num;
-
-	/* Calcuate best extents count */
-	if (feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) {
-		flex_bg_num = 1 << log_groups_per_flex;
-		ret = ((block_count - 1) /
-			((ext4_fsblk_t)blocks_per_group *
-				flex_bg_num)) + 1;
-	} else
-		ret = ((block_count - 1) / blocks_per_group) + 1;
-
-	return ret;
-}
-
-/*
  * print_progress -	Print defrag progress
  *
  * @file:		file name.
@@ -1166,15 +962,11 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	int	fd;
 	int	donor_fd = -1;
 	int	ret;
-	int	best;
 	int	file_frags_start, file_frags_end;
-	int	orig_physical_cnt, donor_physical_cnt = 0;
 	char	tmp_inode_name[PATH_MAX + 8];
 	ext4_fsblk_t			blk_count = 0;
-	struct fiemap_extent_list	*orig_list_physical = NULL;
-	struct fiemap_extent_list	*orig_list_logical = NULL;
-	struct fiemap_extent_list	*donor_list_physical = NULL;
-	struct fiemap_extent_list	*donor_list_logical = NULL;
+	struct fiemap_extent_list	*orig_list = NULL;
+	struct fiemap_extent_list	*donor_list = NULL;
 	struct fiemap_extent_group	*orig_group_head = NULL;
 	struct fiemap_extent_group	*orig_group_tmp = NULL;
 
@@ -1230,21 +1022,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	}
 
 	/* Get file's extents */
-	ret = get_file_extents(fd, &orig_list_physical);
-	if (ret < 0) {
-		if (mode_flag & DETAIL) {
-			PRINT_FILE_NAME(file);
-			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
-		}
-		goto out;
-	}
-
-	/* Get the count of file's continuous physical region */
-	orig_physical_cnt = get_physical_count(orig_list_physical);
-
-	/* Change list from physical to logical */
-	ret = change_physical_to_logical(&orig_list_physical,
-							&orig_list_logical);
+	ret = get_file_extents(fd, &orig_list);
 	if (ret < 0) {
 		if (mode_flag & DETAIL) {
 			PRINT_FILE_NAME(file);
@@ -1254,9 +1032,9 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	}
 
 	/* Count file fragments before defrag */
-	file_frags_start = get_logical_count(orig_list_logical);
+	file_frags_start = get_exts_count(orig_list);
 
-	blk_count = get_file_blocks(orig_list_logical);
+	blk_count = get_file_blocks(orig_list);
 	if (file_check(fd, buf, file, file_frags_start, blk_count) < 0)
 		goto out;
 
@@ -1268,16 +1046,8 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 		goto out;
 	}
 
-	if (current_uid == ROOT_UID)
-		best = get_best_count(blk_count);
-	else
-		best = 1;
-
-	if (file_frags_start <= best)
-		goto check_improvement;
-
 	/* Combine extents to group */
-	ret = join_extents(orig_list_logical, &orig_group_head);
+	ret = join_extents(orig_list, &orig_group_head);
 	if (ret < 0) {
 		if (mode_flag & DETAIL) {
 			PRINT_FILE_NAME(file);
@@ -1331,7 +1101,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	} while (orig_group_tmp != orig_group_head);
 
 	/* Get donor inode's extents */
-	ret = get_file_extents(donor_fd, &donor_list_physical);
+	ret = get_file_extents(donor_fd, &donor_list);
 	if (ret < 0) {
 		if (mode_flag & DETAIL) {
 			PRINT_FILE_NAME(file);
@@ -1340,21 +1110,6 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 		goto out;
 	}
 
-	/* Calcuate donor inode's continuous physical region */
-	donor_physical_cnt = get_physical_count(donor_list_physical);
-
-	/* Change donor extent list from physical to logical */
-	ret = change_physical_to_logical(&donor_list_physical,
-							&donor_list_logical);
-	if (ret < 0) {
-		if (mode_flag & DETAIL) {
-			PRINT_FILE_NAME(file);
-			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
-		}
-		goto out;
-	}
-
-check_improvement:
 	if (mode_flag & DETAIL) {
 		if (file_frags_start != 1)
 			frag_files_before_defrag++;
@@ -1362,26 +1117,8 @@ check_improvement:
 		extents_before_defrag += file_frags_start;
 	}
 
-	if (file_frags_start <= best ||
-			orig_physical_cnt <= donor_physical_cnt) {
-		printf("\033[79;0H\033[K[%u/%u]%s:\t%3d%%",
-			defraged_file_count, total_count, file, 100);
-		if (mode_flag & DETAIL)
-			printf("  extents: %d -> %d",
-				file_frags_start, file_frags_start);
-
-		printf("\t[ OK ]\n");
-		succeed_cnt++;
-
-		if (file_frags_start != 1)
-			frag_files_after_defrag++;
-
-		extents_after_defrag += file_frags_start;
-		goto out;
-	}
-
 	/* Defrag the file */
-	ret = call_defrag(fd, donor_fd, file, buf, donor_list_logical);
+	ret = call_defrag(fd, donor_fd, file, buf, donor_list);
 
 	/* Count file fragments after defrag and print extents info */
 	if (mode_flag & DETAIL) {
@@ -1416,9 +1153,7 @@ out:
 	close(fd);
 	if (donor_fd != -1)
 		close(donor_fd);
-	free_ext(orig_list_physical);
-	free_ext(orig_list_logical);
-	free_ext(donor_list_physical);
+	free_ext(orig_list);
 	free_exts_group(orig_group_head);
 	return 0;
 }
@@ -1432,14 +1167,12 @@ out:
 int main(int argc, char *argv[])
 {
 	int	opt;
-	int	i, ret = 0;
+	int	i;
 	int	flags = FTW_PHYS | FTW_MOUNT;
 	int	arg_type = -1;
 	int	success_flag = 0;
 	char	dir_name[PATH_MAX + 1];
-	char	dev_name[PATH_MAX + 1];
 	struct stat64	buf;
-	ext2_filsys fs = NULL;
 
 	/* Parse arguments */
 	if (argc == 1)
@@ -1470,12 +1203,8 @@ int main(int argc, char *argv[])
 		extents_before_defrag = 0;
 		extents_after_defrag = 0;
 		defraged_file_count = 0;
-		blocks_per_group = 0;
-		feature_incompat = 0;
-		log_groups_per_flex = 0;
 
 		memset(dir_name, 0, PATH_MAX + 1);
-		memset(dev_name, 0, PATH_MAX + 1);
 		memset(lost_found_dir, 0, PATH_MAX + 1);
 
 #if BYTE_ORDER != BIG_ENDIAN && BYTE_ORDER != LITTLE_ENDIAN
@@ -1492,7 +1221,6 @@ int main(int argc, char *argv[])
 
 		if (S_ISBLK(buf.st_mode)) {
 			/* Block device */
-			strncpy(dev_name, argv[i], strnlen(argv[i], PATH_MAX));
 			if (get_mount_point(argv[i], dir_name, PATH_MAX) < 0)
 				continue;
 			if (lstat64(dir_name, &buf) < 0) {
@@ -1528,7 +1256,7 @@ int main(int argc, char *argv[])
 		 * filesystem type checked in get_mount_point()
 		 */
 		if (arg_type == FILENAME || arg_type == DIRNAME) {
-			if (is_ext4(argv[i], dev_name) < 0)
+			if (is_ext4(argv[i]) < 0)
 				continue;
 			if (realpath(argv[i], dir_name) == NULL) {
 				perror("Couldn't get full path");
@@ -1537,25 +1265,6 @@ int main(int argc, char *argv[])
 			}
 		}
 
-		if (current_uid == ROOT_UID) {
-			/* Get super block info */
-			ret = ext2fs_open(dev_name, 0, 0, block_size,
-					unix_io_manager, &fs);
-			if (ret) {
-				if (mode_flag & DETAIL) {
-					perror("Can't get super block info");
-					PRINT_FILE_NAME(argv[i]);
-				}
-				continue;
-			}
-
-			blocks_per_group = fs->super->s_blocks_per_group;
-			feature_incompat = fs->super->s_feature_incompat;
-			log_groups_per_flex = fs->super->s_log_groups_per_flex;
-
-			ext2fs_close(fs);
-		}
