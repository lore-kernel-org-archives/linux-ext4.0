From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 03/11 RESEND] e4defrag: Remove -c option which check the file
 fragments
Date: Wed, 15 Jun 2011 15:35:07 +0900
Message-ID: <4DF8529B.1070104@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:49869 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab1FOGmU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jun 2011 02:42:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove -c option form e4defrag, because filefrag can output the fragmentation
score.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.8.in |   29 ---
 misc/e4defrag.c    |  408 +----------------------------------------------------
 2 files changed, 12 insertions(+), 425 deletions(-)
diff --git a/misc/e4defrag.8.in b/misc/e4defrag.8.in
index 75e1bc9..81adc29 100644
--- a/misc/e4defrag.8.in
+++ b/misc/e4defrag.8.in
@@ -1,12 +1,9 @@
-.TH E4DEFRAG 8 "May 2009" "e4defrag version 2.0"
+.TH E4DEFRAG 8 "Feb 2011" "e4defrag version 2.1"
 .SH NAME
 e4defrag \- online defragmenter for ext4 filesystem
 .SH SYNOPSIS
 .B e4defrag
 [
-.B \-c
-]
-[
 .B \-v
 ]
 .I target
@@ -34,26 +31,6 @@ gets the mount point of it and reduces fragmentation of all files in this mount
 point.
 .SH OPTIONS
 .TP
-.B \-c
-Get a current fragmentation count and an ideal fragmentation count, and
-calculate fragmentation score based on them. By seeing this score, we can
-determine whether we should execute
-.B e4defrag
-to
-.IR target .
-When used with
-.B \-v
-option, the current fragmentation count and the ideal fragmentation count are
-printed for each file.
-.IP
-Also this option outputs the average data size in one extent. If you see it,
-you'll find the file has ideal extents or not. Note that the maximum extent
-size is 131072KB in ext4 filesystem (if block size is 4KB).
-.IP
-If this option is specified,
-.I target
-is never defragmented.
-.TP
 .B \-v
 Print error messages and the fragmentation count before and after defrag for
 each file.
@@ -68,9 +45,7 @@ doesn't defragment files in mount point of other device.
 .PP
 Non-privileged users can execute
 .B e4defrag
-to their own file, but the score is not printed if
-.B \-c
-option is specified. Therefore, it is desirable to be executed by root user.
+to their own file.
 .SH AUTHOR
 Written by Akira Fujita <a-fujita@rs.jp.nec.com> and Takashi Sato
 <t-sato@yk.jp.nec.com>.
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index eea3057..0fb61e0 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -54,13 +54,7 @@
 #define PRINT_FILE_NAME(file)	fprintf(stderr, " \"%s\"\n", (file))
 #define PRINT_ERR_MSG_WITH_ERRNO(msg)	\
 	fprintf(stderr, "\t%s:%s\t[ NG ]\n", (msg), strerror(errno))
-#define STATISTIC_ERR_MSG(msg)	\
-	fprintf(stderr, "\t%s\n", (msg))
-#define STATISTIC_ERR_MSG_WITH_ERRNO(msg)	\
-	fprintf(stderr, "\t%s:%s\n", (msg), strerror(errno))
 #define min(x, y) (((x) > (y)) ? (y) : (x))
-#define CALC_SCORE(ratio) \
-	((ratio) > 10 ? (80 + 20 * (ratio) / 100) : (8 * (ratio)))
 /* Wrap up the free function */
 #define FREE(tmp)				\
 	do {					\
@@ -85,7 +79,6 @@
 
 /* The mode of defrag */
 #define DETAIL			0x01
-#define STATISTIC		0x02
 
 #define DEVNAME			0
 #define DIRNAME			1
@@ -96,9 +89,6 @@
 #define FS_EXT4			"ext4"
 #define ROOT_UID		0
 
-#define BOUND_SCORE		55
-#define SHOW_FRAG_FILES	5
-
 /* Magic number for ext4 */
 #define EXT4_SUPER_MAGIC	0xEF53
 
@@ -113,8 +103,7 @@
 
 /* The following macros are error message */
 #define MSG_USAGE		\
-"Usage	: e4defrag [-v] file...| directory...| device...\n\
-	: e4defrag  -c  file...| directory...| device...\n"
+"Usage	: e4defrag [-v] file...| directory...| device...\n"
 
 #define NGMSG_EXT4		"Filesystem is not ext4 filesystem"
 #define NGMSG_FILE_EXTENT	"Failed to get file extents"
@@ -155,14 +144,6 @@ struct move_extent {
 	__u64 moved_len;	/* moved block length */
 };
 
-struct frag_statistic_ino {
-	int now_count;	/* the file's extents count of before defrag */
-	int best_count; /* the best file's extents count */
-	__u64 size_per_ext;	/* size(KB) per extent */
-	float ratio;	/* the ratio of fragmentation */
-	char msg_buffer[PATH_MAX + 1];	/* pathname of the file */
-};
-
 char	lost_found_dir[PATH_MAX + 1];
 int	block_size;
 int	extents_before_defrag;
@@ -178,8 +159,6 @@ unsigned int	total_count;
 __u8 log_groups_per_flex;
 __u32 blocks_per_group;
 __u32 feature_incompat;
-ext4_fsblk_t	files_block_count;
-struct frag_statistic_ino	frag_rank[SHOW_FRAG_FILES];
 
 
 /* Local definitions of some syscalls glibc may not yet have */
@@ -1055,252 +1034,6 @@ static int get_best_count(ext4_fsblk_t block_count)
 	return ret;
 }
 
-
-/*
- * file_statistic() -	Get statistic info of the file's fragments.
- *
- * @file:		the file's name.
- * @buf:		the pointer of the struct stat64.
- * @flag:		file type.
- * @ftwbuf:		the pointer of a struct FTW.
- */
-static int file_statistic(const char *file, const struct stat64 *buf,
-			int flag EXT2FS_ATTR((unused)),
-			struct FTW *ftwbuf EXT2FS_ATTR((unused)))
-{
-	int	fd;
-	int	ret;
-	int	now_ext_count, best_ext_count = 0, physical_ext_count;
-	int	i, j;
-	__u64	size_per_ext = 0;
-	float	ratio = 0.0;
-	ext4_fsblk_t	blk_count = 0;
-	char	msg_buffer[PATH_MAX + 24];
-	struct fiemap_extent_list *physical_list_head = NULL;
-	struct fiemap_extent_list *logical_list_head = NULL;
-
-	defraged_file_count++;
-
-	if (mode_flag & DETAIL) {
-		if (total_count == 1 && regular_count == 1)
-			printf("<File>\n");
-		else {
-			printf("[%u/%u]", defraged_file_count, total_count);
-			fflush(stdout);
-		}
-	}
-	if (lost_found_dir[0] != '\0' &&
-	    !memcmp(file, lost_found_dir, strnlen(lost_found_dir, PATH_MAX))) {
-		if (mode_flag & DETAIL) {
-			PRINT_FILE_NAME(file);
-			STATISTIC_ERR_MSG(NGMSG_LOST_FOUND);
-		}
-			return 0;
-	}
-
-	if (!S_ISREG(buf->st_mode)) {
-		if (mode_flag & DETAIL) {
-			PRINT_FILE_NAME(file);
-			STATISTIC_ERR_MSG(NGMSG_FILE_UNREG);
-		}
-		return 0;
-	}
-
-	/* Access authority */
-	if (current_uid != ROOT_UID &&
-		buf->st_uid != current_uid) {
-		if (mode_flag & DETAIL) {
-			PRINT_FILE_NAME(file);
-			STATISTIC_ERR_MSG(
-				"File is not current user's file"
-				" or current user is not root");
-		}
-		return 0;
-	}
-
-	/* Empty file */
-	if (buf->st_size == 0) {
-		if (mode_flag & DETAIL) {
-			PRINT_FILE_NAME(file);
-			STATISTIC_ERR_MSG("File size is 0");
-		}
-		return 0;
-	}
-
-	/* Has no blocks */
-	if (buf->st_blocks == 0) {
-		if (mode_flag & DETAIL) {
-			PRINT_FILE_NAME(file);
-			STATISTIC_ERR_MSG("File has no blocks");
-		}
-		return 0;
-	}
-
-	fd = open64(file, O_RDONLY);
-	if (fd < 0) {
-		if (mode_flag & DETAIL) {
-			PRINT_FILE_NAME(file);
-			STATISTIC_ERR_MSG_WITH_ERRNO(NGMSG_FILE_OPEN);
-		}
-		return 0;
-	}
-
-	/* Get file's physical extents  */
-	ret = get_file_extents(fd, &physical_list_head);
-	if (ret < 0) {
-		if (mode_flag & DETAIL) {
-			PRINT_FILE_NAME(file);
-			STATISTIC_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
-		}
-		goto out;
-	}
-
-	/* Get the count of file's continuous physical region */
-	physical_ext_count = get_physical_count(physical_list_head);
-
-	/* Change list from physical to logical */
-	ret = change_physical_to_logical(&physical_list_head,
-							&logical_list_head);
-	if (ret < 0) {
-		if (mode_flag & DETAIL) {
-			PRINT_FILE_NAME(file);
-			STATISTIC_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
-		}
-		goto out;
-	}
-
-	/* Count file fragments before defrag */
-	now_ext_count = get_logical_count(logical_list_head);
-
-	if (current_uid == ROOT_UID) {
-		/* Calculate the size per extent */
-		blk_count = get_file_blocks(logical_list_head);
-
-		best_ext_count = get_best_count(blk_count);
-
-		/* e4defrag rounds size_per_ext up to a block size boundary */
-		size_per_ext = blk_count * (buf->st_blksize / 1024) /
-							now_ext_count;
-
-		ratio = (float)(physical_ext_count - best_ext_count) * 100 /
-							blk_count;
-
-		extents_before_defrag += now_ext_count;
-		extents_after_defrag += best_ext_count;
-		files_block_count += blk_count;
-	}
-
-	if (total_count == 1 && regular_count == 1) {
-		/* File only */
-		if (mode_flag & DETAIL) {
-			int count = 0;
-			struct fiemap_extent_list *ext_list_tmp =
-						logical_list_head;
-
-			/* Print extents info */
-			do {
-				count++;
-				printf("[ext %d]:\tstart %llu:\tlogical "
-						"%llu:\tlen %llu\n", count,
-						ext_list_tmp->data.physical,
-						ext_list_tmp->data.logical,
-						ext_list_tmp->data.len);
-				ext_list_tmp = ext_list_tmp->next;
-			} while (ext_list_tmp != logical_list_head);
-
-		} else {
-			printf("%-40s%10s/%-10s%9s\n",
-					"<File>", "now", "best", "size/ext");
-			if (current_uid == ROOT_UID) {
-				if (strlen(file) > 40)
-					printf("%s\n%50d/%-10d%6llu KB\n",
-						file, now_ext_count,
-						best_ext_count, size_per_ext);
-				else
-					printf("%-40s%10d/%-10d%6llu KB\n",
-						file, now_ext_count,
-						best_ext_count, size_per_ext);
-			} else {
-				if (strlen(file) > 40)
-					printf("%s\n%50d/%-10s%7s\n",
-							file, now_ext_count,
-							"-", "-");
-				else
-					printf("%-40s%10d/%-10s%7s\n",
-							file, now_ext_count,
-							"-", "-");
-			}
-		}
-		succeed_cnt++;
-		goto out;
-	}
-
-	if (mode_flag & DETAIL) {
-		/* Print statistic info */
-		sprintf(msg_buffer, "[%u/%u]%s",
-				defraged_file_count, total_count, file);
-		if (current_uid == ROOT_UID) {
-			if (strlen(msg_buffer) > 40)
-				printf("\033[79;0H\033[K%s\n"
-						"%50d/%-10d%6llu KB\n",
-						msg_buffer, now_ext_count,
-						best_ext_count, size_per_ext);
-			else
-				printf("\033[79;0H\033[K%-40s"
-						"%10d/%-10d%6llu KB\n",
-						msg_buffer, now_ext_count,
-						best_ext_count, size_per_ext);
-		} else {
-			if (strlen(msg_buffer) > 40)
-				printf("\033[79;0H\033[K%s\n%50d/%-10s%7s\n",
-						msg_buffer, now_ext_count,
-							"-", "-");
-			else
-				printf("\033[79;0H\033[K%-40s%10d/%-10s%7s\n",
-						msg_buffer, now_ext_count,
-							"-", "-");
-		}
-	}
-
-	for (i = 0; i < SHOW_FRAG_FILES; i++) {
-		if (ratio >= frag_rank[i].ratio) {
-			for (j = SHOW_FRAG_FILES - 1; j > i; j--) {
-				memset(&frag_rank[j], 0,
-					sizeof(struct frag_statistic_ino));
-				strncpy(frag_rank[j].msg_buffer,
-					frag_rank[j - 1].msg_buffer,
-					strnlen(frag_rank[j - 1].msg_buffer,
-					PATH_MAX));
-				frag_rank[j].now_count =
-					frag_rank[j - 1].now_count;
-				frag_rank[j].best_count =
-					frag_rank[j - 1].best_count;
-				frag_rank[j].size_per_ext =
-					frag_rank[j - 1].size_per_ext;
-				frag_rank[j].ratio =
-					frag_rank[j - 1].ratio;
-			}
-			memset(&frag_rank[i], 0,
-					sizeof(struct frag_statistic_ino));
-			strncpy(frag_rank[i].msg_buffer, file,
-						strnlen(file, PATH_MAX));
-			frag_rank[i].now_count = now_ext_count;
-			frag_rank[i].best_count = best_ext_count;
-			frag_rank[i].size_per_ext = size_per_ext;
-			frag_rank[i].ratio = ratio;
-			break;
-		}
-	}
-
-	succeed_cnt++;
-
-out:
-	close(fd);
-	free_ext(physical_list_head);
-	free_ext(logical_list_head);
-	return 0;
-}
-
 /*
  * print_progress -	Print defrag progress
  *
@@ -1482,7 +1215,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	if (buf->st_blocks == 0) {
 		if (mode_flag & DETAIL) {
 			PRINT_FILE_NAME(file);
-			STATISTIC_ERR_MSG("File has no blocks");
+			IN_FTW_PRINT_ERR_MSG("File has no blocks");
 		}
 		return 0;
 	}
@@ -1699,7 +1432,7 @@ out:
 int main(int argc, char *argv[])
 {
 	int	opt;
-	int	i, j, ret = 0;
+	int	i, ret = 0;
 	int	flags = FTW_PHYS | FTW_MOUNT;
 	int	arg_type = -1;
 	int	success_flag = 0;
@@ -1712,14 +1445,11 @@ int main(int argc, char *argv[])
 	if (argc == 1)
 		goto out;
 
-	while ((opt = getopt(argc, argv, "vc")) != EOF) {
+	while ((opt = getopt(argc, argv, "v")) != EOF) {
 		switch (opt) {
 		case 'v':
 			mode_flag |= DETAIL;
 			break;
-		case 'c':
-			mode_flag |= STATISTIC;
-			break;
 		default:
 			goto out;
 		}
@@ -1740,7 +1470,6 @@ int main(int argc, char *argv[])
 		extents_before_defrag = 0;
 		extents_after_defrag = 0;
 		defraged_file_count = 0;
-		files_block_count = 0;
 		blocks_per_group = 0;
 		feature_incompat = 0;
 		log_groups_per_flex = 0;
@@ -1748,11 +1477,6 @@ int main(int argc, char *argv[])
 		memset(dir_name, 0, PATH_MAX + 1);
 		memset(dev_name, 0, PATH_MAX + 1);
 		memset(lost_found_dir, 0, PATH_MAX + 1);
-		memset(frag_rank, 0,
-			sizeof(struct frag_statistic_ino) * SHOW_FRAG_FILES);
-
-		if ((mode_flag & STATISTIC) && i > optind)
-			printf("\n");
 
 #if BYTE_ORDER != BIG_ENDIAN && BYTE_ORDER != LITTLE_ENDIAN
 		PRINT_ERR_MSG("Endian's type is not big/little endian");
@@ -1777,9 +1501,8 @@ int main(int argc, char *argv[])
 				continue;
 			}
 			arg_type = DEVNAME;
-			if (!(mode_flag & STATISTIC))
-				printf("ext4 defragmentation for device(%s)\n",
-					argv[i]);
+			printf("ext4 defragmentation for device(%s)\n",
+				argv[i]);
 		} else if (S_ISDIR(buf.st_mode)) {
 			/* Directory */
 			if (access(argv[i], R_OK) < 0) {
@@ -1835,9 +1558,8 @@ int main(int argc, char *argv[])
 
 		switch (arg_type) {
 		case DIRNAME:
-			if (!(mode_flag & STATISTIC))
-				printf("ext4 defragmentation "
-					"for directory(%s)\n", argv[i]);
+			printf("ext4 defragmentation for directory(%s)\n",
+					argv[i]);
 
 			int mount_dir_len = 0;
 			mount_dir_len = strnlen(lost_found_dir, PATH_MAX);
@@ -1877,55 +1599,6 @@ int main(int argc, char *argv[])
 
 			nftw64(dir_name, calc_entry_counts, FTW_OPEN_FD, flags);
 
-			if (mode_flag & STATISTIC) {
-				if (mode_flag & DETAIL)
-					printf("%-40s%10s/%-10s%9s\n",
-					"<File>", "now", "best", "size/ext");
-
-				if (!(mode_flag & DETAIL) &&
-						current_uid != ROOT_UID) {
-					printf(" Done.\n");
-					success_flag = 1;
-					continue;
-				}
-
-				nftw64(dir_name, file_statistic,
-							FTW_OPEN_FD, flags);
-
-				if (succeed_cnt != 0 &&
-					current_uid == ROOT_UID) {
-					if (mode_flag & DETAIL)
-						printf("\n");
-					printf("%-40s%10s/%-10s%9s\n",
-						"<Fragmented files>", "now",
-						"best", "size/ext");
-					for (j = 0; j < SHOW_FRAG_FILES; j++) {
-						if (strlen(frag_rank[j].
-							msg_buffer) > 37) {
-							printf("%d. %s\n%50d/"
-							"%-10d%6llu KB\n",
-							j + 1,
-							frag_rank[j].msg_buffer,
-							frag_rank[j].now_count,
-							frag_rank[j].best_count,
-							frag_rank[j].
-								size_per_ext);
-						} else if (strlen(frag_rank[j].
-							msg_buffer) > 0) {
-							printf("%d. %-37s%10d/"
-							"%-10d%6llu KB\n",
-							j + 1,
-							frag_rank[j].msg_buffer,
-							frag_rank[j].now_count,
-							frag_rank[j].best_count,
-							frag_rank[j].
-								size_per_ext);
-						} else
-							break;
-					}
-				}
-				break;
-			}
 			/* File tree walk */
 			nftw64(dir_name, file_defrag, FTW_OPEN_FD, flags);
 			printf("\n\tSuccess:\t\t\t[ %u/%u ]\n", succeed_cnt,
@@ -1962,12 +1635,8 @@ int main(int argc, char *argv[])
 				continue;
 			}
 
-			if (mode_flag & STATISTIC) {
-				file_statistic(argv[i], &buf, FTW_F, NULL);
-				break;
-			} else
-				printf("ext4 defragmentation for %s\n",
-								 argv[i]);
+			printf("ext4 defragmentation for %s\n", argv[i]);
+
 			/* Defrag single file process */
 			file_defrag(argv[i], &buf, FTW_F, NULL);
 			if (succeed_cnt != 0)
@@ -1980,63 +1649,6 @@ int main(int argc, char *argv[])
 
 		if (succeed_cnt != 0)
 			success_flag = 1;
-		if (mode_flag & STATISTIC) {
-			if (current_uid != ROOT_UID) {
-				printf(" Done.\n");
-				continue;
-			}
-
-			if (!succeed_cnt) {
-				if (mode_flag & DETAIL)
-					printf("\n");
-
-				if (arg_type == DEVNAME)
-					printf(" In this device(%s), "
-					"none can be defragmented.\n", argv[i]);
-				else if (arg_type == DIRNAME)
-					printf(" In this directory(%s), "
-					"none can be defragmented.\n", argv[i]);
-				else
-					printf(" This file(%s) "
-					"can't be defragmented.\n", argv[i]);
-			} else {
-				float files_ratio = 0.0;
-				float score = 0.0;
-				__u64 size_per_ext = files_block_count *
-						(buf.st_blksize / 1024) /
-						extents_before_defrag;
-				files_ratio = (float)(extents_before_defrag -
-						extents_after_defrag) *
-						100 / files_block_count;
-				score = CALC_SCORE(files_ratio);
-				printf("\n Total/best extents\t\t\t\t%d/%d\n"
-					" Average size per extent"
-					"\t\t\t%llu KB\n"
-					" Fragmentation score\t\t\t\t%.0f\n",
-						extents_before_defrag,
-						extents_after_defrag,
-						size_per_ext, score);
-				printf(" [0-30 no problem:"
-					" 31-55 a little bit fragmented:"
-					" 56- needs defrag]\n");
-
-				if (arg_type == DEVNAME)
-					printf(" This device (%s) ", argv[i]);
-				else if (arg_type == DIRNAME)
-					printf(" This directory (%s) ",
-								argv[i]);
-				else
-					printf(" This file (%s) ", argv[i]);
-
-				if (score > BOUND_SCORE)
-					printf("needs defragmentation.\n");
-				else
-					printf("does not need "
-							"defragmentation.\n");
-			}
-			printf(" Done.\n");
-		}
