From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [RFC][PATCH V3 4/4] e4defrag: add solving relevant file fragmentation
 mode
Date: Wed, 01 Dec 2010 15:06:55 +0900
Message-ID: <4CF5E5FF.7030809@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:65394 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab0LAGNZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Dec 2010 01:13:25 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

All files contained in the same directory are likely to be read at onc time.
So, it is preferred that data blocks of the files in the same directory will be
allocated near to reduce seek time.

This patch adds new feature to e4defrag to move files near the block
containing the data of TARGET (regular file or directory). Note that
TARGET isn't moved anywhere.

Usage	: e4defrag -r [-v] TARGET FILE...

How to make the newest e4defrag: 
1. Download e2fsprogs git tree
   # git pull http://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

2. Apply the patch unified bugfix/improvement
   http://marc.info/?l=linux-ext4&m=128272690010784&w=4
   
3. Apply the patch to fix the segfault
   http://marc.info/?l=linux-ext4&m=129015317309425&w=4

4. Apply the attached RFC patch 

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 misc/e4defrag.c |  416 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 367 insertions(+), 49 deletions(-)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 42782c7..4f6dc04 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -41,6 +41,15 @@
 #define EXT4_IOC_MOVE_EXT      _IOWR('f', 15, struct move_extent)
 #endif
 
+#ifndef EXT4_IOC_CONTROL_PA
+#define EXT4_IOC_CONTROL_PA	_IOWR('f', 16, struct ext4_prealloc_info)
+#endif
+
+/* Macros for EXT4_IOC_CONTROL_PA */
+#define EXT4_MB_MANDATORY       0x0001
+#define EXT4_MB_ADVISORY        0x0002
+#define EXT4_MB_DISCARD_PA      0x0004
+
 /* Macro functions */
 #define PRINT_ERR_MSG(msg)	fprintf(stderr, "%s\n", (msg))
 #define IN_FTW_PRINT_ERR_MSG(msg)	\
@@ -80,6 +89,7 @@
 /* The mode of defrag */
 #define DETAIL			0x01
 #define STATISTIC		0x02
+#define RELEVANT		0x04
 
 #define DEVNAME			0
 #define DIRNAME			1
@@ -105,10 +115,14 @@
  */
 #define EXTENT_MAX_COUNT	512
 
+/* The maximum number of inode PAs that EXT4_IOC_CONTROL_PA can set */
+#define EXT4_MAX_PREALLOC	1024
+
 /* The following macros are error message */
 #define MSG_USAGE		\
-"Usage	: e4defrag [-v] file...| directory...| device...\n\
-	: e4defrag  -c  file...| directory...| device...\n"
+"Usage	: e4defrag [-v] FILE...\n\
+	: e4defrag -c [-v] FILE...\n\
+	: e4defrag -r [-v] TARGET FILE...\n"
 
 #define NGMSG_EXT4		"Filesystem is not ext4 filesystem"
 #define NGMSG_FILE_EXTENT	"Failed to get file extents"
@@ -157,6 +171,16 @@ struct frag_statistic_ino {
 	char msg_buffer[PATH_MAX + 1];	/* pathname of the file */
 };
 
+struct ext4_prealloc_info {
+	__u64 pi_pstart; /* physical offset for the start of the PA from
+			  * the beginning of the file (in/out) */
+	__u32 pi_lstart; /* logical offset for the start of the PA from
+			  * the beginning of the disk (in/out) */
+	__u32 pi_len;    /* length for this PA (in/out) */
+	__u32 pi_free;   /* the number of free blocks in this PA (out) */
+	__u16 pi_flags;  /* flags for the inode PA setting ioctl (in) */
+};
+
 typedef __u16 __le16;
 typedef __u32 __le32;
 typedef __u64 __le64;
@@ -269,6 +293,8 @@ __le32 blocks_per_group;
 __le32 feature_incompat;
 ext4_fsblk_t	files_block_count;
 struct frag_statistic_ino	frag_rank[SHOW_FRAG_FILES];
+__u64 r_pstart;
+blk64_t fs_blocks_count;
 
 
 /* Local definitions of some syscalls glibc may not yet have */
@@ -1562,6 +1588,154 @@ static int call_defrag(int fd, int donor_fd, const char *file,
 	return 0;
 }
 
+static unsigned long long get_physical_offset(const int fd, int *ret)
+{
+	struct fiemap	*fiemap_buf;
+	char *fiebuf;
+	int bufsize = sizeof(struct fiemap) + sizeof(struct fiemap_extent);
+	unsigned long long blk;
+
+	fiebuf = malloc(bufsize);
+
+	if (!fiebuf) {
+		*ret = -1;
+		return 0;
+	}
+
+	fiemap_buf = (struct fiemap *)fiebuf;
+	/* When fm_extent_count is 0,
+	 * ioctl just get file fragment count.
+	 */
+	memset(fiemap_buf, 0, bufsize);
+	fiemap_buf->fm_start = 0;
+	fiemap_buf->fm_length = FIEMAP_MAX_OFFSET;
+	fiemap_buf->fm_flags |= FIEMAP_FLAG_SYNC;
+	fiemap_buf->fm_extent_count = 1;
+
+	*ret = ioctl(fd, FS_IOC_FIEMAP, fiemap_buf);
+	if (*ret < 0) {
+		free(fiebuf);
+		return 0;
+	}
+
+	blk = fiemap_buf->fm_extents[0].fe_physical / block_size;
+	free(fiebuf);
+	return blk;
+}
+
+/* Will go away. We should use ext2fs_blocks_count instead.*/
+static ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
+{
+	return ((ext4_fsblk_t)es->s_blocks_count_hi) << 32 |
+		es->s_blocks_count_lo;
+}
+
+/*
+ * relevant_balloc() -		Block allocate for donor file in relevant mode.
+ *
+ *
+ */
+static int relevant_balloc(const char *file, int donor_fd,
+			struct fiemap_extent_group *orig_group_head)
+{
+	struct ext4_prealloc_info pi;
+	struct fiemap_extent_group *orig_group_tmp;
+	loff_t logical_byte, len_byte;
+	int ret = 0, rest;
+	int bpg = blocks_per_group;
+	int first_data_block = 0;
+	unsigned int prealloc_max_blk;
+
+	/* Calculate first_data_block based on blocksize */
+	if (block_size == 1024)
+		first_data_block = 1;
+
+	/*
+	 * Calculate the maximum number of blocks of preallocation.
+	 * General user doesn't know blocks_per_group. So if he executes
+	 * e4defrag to ext4 whose blocks_per_group is not the same as a default
+	 * value, EXT4_IOC_CONTROL_PA will always return EINVAL.
+	 */
+	if (blocks_per_group)
+		prealloc_max_blk = blocks_per_group - 10;
+	else
+		prealloc_max_blk = 8 * block_size - 10;
+
+	/* Allocate space for donor inode */
+	orig_group_tmp = orig_group_head;
+
+	memset(&pi, 0, sizeof(pi));
+	pi.pi_pstart = r_pstart;
+	pi.pi_lstart = orig_group_tmp->start->data.logical;
+	pi.pi_flags = EXT4_MB_ADVISORY;
+	rest = orig_group_tmp->len;
+	/* Loop for each extent group */
+	do {
+
+		/* Allocating  all blocks in an extent group */
+		while (rest > 0) {
+			pi.pi_len = rest;
+			if (current_uid == ROOT_UID) {
+				int grp_offset;
+				grp_offset = (pi.pi_pstart - first_data_block) %
+					bpg;
+				if ((int)(grp_offset + pi.pi_len) > bpg)
+					pi.pi_len = bpg - grp_offset;
+				if ((pi.pi_pstart + pi.pi_len) >
+						fs_blocks_count)
+					pi.pi_len = fs_blocks_count -
+						pi.pi_pstart;
+			}
+			pi.pi_len = min(pi.pi_len, prealloc_max_blk);
+
+			ret = ioctl(donor_fd, EXT4_IOC_CONTROL_PA, &pi);
+			if (ret < 0) {
+				if (mode_flag & DETAIL) {
+					PRINT_FILE_NAME(file);
+					PRINT_ERR_MSG_WITH_ERRNO(
+						      "Failed to preallocate");
+				}
+				goto out;
+			}
+
+			len_byte = pi.pi_len * block_size;
+			logical_byte = pi.pi_lstart * block_size;
+
+			ret = fallocate(donor_fd, 0, logical_byte, len_byte);
+			if (ret < 0) {
+				if (mode_flag & DETAIL) {
+					PRINT_FILE_NAME(file);
+					PRINT_ERR_MSG_WITH_ERRNO(
+							"Failed to fallocate");
+				}
+				goto out;
+			}
+			rest -= pi.pi_len;
+			if (rest < 0) {
+				ret = -1;
+				printf("relevant_balloc: error! rest %d < 0\n",
+									rest);
+				goto out;
+			}
+
+			pi.pi_lstart += pi.pi_len;
+			pi.pi_pstart += pi.pi_len;
+
+			if (pi.pi_pstart >= fs_blocks_count)
+				pi.pi_pstart = first_data_block;
+		}
+		orig_group_tmp = orig_group_tmp->next;
+
+		/* There is no need to change pi.pi_pstart */
+		pi.pi_lstart = orig_group_tmp->start->data.logical;
+		pi.pi_flags = EXT4_MB_ADVISORY;
+		rest = orig_group_tmp->len;
+	} while (orig_group_tmp != orig_group_head);
+
+out:
+	return ret;
+}
+
 /*
  * file_defrag() -		Check file attributes and call ioctl to defrag.
  *
@@ -1580,6 +1754,7 @@ static int file_defrag(const char *file, const struct stat *buf,
 	int	best;
 	int	file_frags_start, file_frags_end;
 	int	orig_physical_cnt, donor_physical_cnt = 0;
+	int	no_mvext;
 	char	tmp_inode_name[PATH_MAX + 8];
 	ext4_fsblk_t			blk_count = 0;
 	struct fiemap_extent_list	*orig_list_physical = NULL;
@@ -1684,8 +1859,13 @@ static int file_defrag(const char *file, const struct stat *buf,
 	else
 		best = 1;
 
-	if (file_frags_start <= best)
-		goto check_improvement;
+	if (mode_flag & RELEVANT) {
+		if (file_frags_start < best)
+			goto check_improvement;
+	} else {
+		if (file_frags_start <= best)
+			goto check_improvement;
+	}
 
 	/* Combine extents to group */
 	ret = join_extents(orig_list_logical, &orig_group_head);
@@ -1724,22 +1904,36 @@ static int file_defrag(const char *file, const struct stat *buf,
 		goto out;
 	}
 
-	/* Allocate space for donor inode */
-	orig_group_tmp = orig_group_head;
-	do {
-		ret = fallocate(donor_fd, 0,
-		  (loff_t)orig_group_tmp->start->data.logical * block_size,
-		  (loff_t)orig_group_tmp->len * block_size);
+	if (mode_flag & RELEVANT) {
+		ret = relevant_balloc(file, donor_fd, orig_group_head);
 		if (ret < 0) {
 			if (mode_flag & DETAIL) {
 				PRINT_FILE_NAME(file);
-				PRINT_ERR_MSG_WITH_ERRNO("Failed to fallocate");
+				PRINT_ERR_MSG_WITH_ERRNO(
+						"Failed to relevant balloc");
 			}
 			goto out;
 		}
+	} else {
+		/* Allocate space for donor inode */
+		orig_group_tmp = orig_group_head;
+		do {
+			ret = fallocate(donor_fd, 0,
+			  (loff_t)orig_group_tmp->start->data.logical *
+				block_size,
+			  (loff_t)orig_group_tmp->len * block_size);
+			if (ret < 0) {
+				if (mode_flag & DETAIL) {
+					PRINT_FILE_NAME(file);
+					PRINT_ERR_MSG_WITH_ERRNO(
+							"Failed to fallocate");
+				}
+				goto out;
+			}
 
-		orig_group_tmp = orig_group_tmp->next;
-	} while (orig_group_tmp != orig_group_head);
+			orig_group_tmp = orig_group_tmp->next;
+		} while (orig_group_tmp != orig_group_head);
+	}
 
 	/* Get donor inode's extents */
 	ret = get_file_extents(donor_fd, &donor_list_physical);
@@ -1773,8 +1967,16 @@ check_improvement:
 		extents_before_defrag += file_frags_start;
 	}
 
-	if (file_frags_start <= best ||
-			orig_physical_cnt <= donor_physical_cnt) {
+	no_mvext = 0;
+	if (mode_flag & RELEVANT) {
+		if (file_frags_start < best ||
+					orig_physical_cnt < donor_physical_cnt)
+			no_mvext = 1;
+	} else if (file_frags_start <= best ||
+					orig_physical_cnt <= donor_physical_cnt)
+		no_mvext = 1;
+
+	if (no_mvext) {
 		printf("\033[79;0H\033[K[%u/%u]%s:\t%3d%%",
 			defraged_file_count, total_count, file, 100);
 		if (mode_flag & DETAIL)
@@ -1848,14 +2050,11 @@ int main(int argc, char *argv[])
 	int	arg_type = -1;
 	int	success_flag = 0;
 	char	dir_name[PATH_MAX + 1];
+	dev_t	first_dev = 0;
 	struct stat	buf;
 	struct ext4_super_block sb;
 
-	/* Parse arguments */
-	if (argc == 1)
-		goto out;
-
-	while ((opt = getopt(argc, argv, "vc")) != EOF) {
+	while ((opt = getopt(argc, argv, "vcr")) != EOF) {
 		switch (opt) {
 		case 'v':
 			mode_flag |= DETAIL;
@@ -1863,14 +2062,26 @@ int main(int argc, char *argv[])
 		case 'c':
 			mode_flag |= STATISTIC;
 			break;
+		case 'r':
+			mode_flag |= RELEVANT;
+			break;
 		default:
 			goto out;
 		}
 	}
 
-	if (argc == optind)
+	if (argc == optind) {
+		PRINT_ERR_MSG("Missing file operand");
+		goto out;
+	} else if ((mode_flag & RELEVANT) && argc - optind == 1) {
+		PRINT_ERR_MSG("Need more than two files");
+		goto out;
+	} else if ((mode_flag & STATISTIC) && (mode_flag & RELEVANT)) {
+		PRINT_ERR_MSG("Too many options");
 		goto out;
+	}
 
+	r_pstart = 0;
 	current_uid = getuid();
 
 	/* Main process */
@@ -1893,6 +2104,13 @@ int main(int argc, char *argv[])
 		memset(frag_rank, 0,
 			sizeof(struct frag_statistic_ino) * SHOW_FRAG_FILES);
 
+		/*
+		 * Abort if e4defrag cannot get the physical block number of
+		 * the TARGET for any reason
+		 */
+		if ((mode_flag & RELEVANT) && i > optind && r_pstart == 0)
+			exit(1);
+
 		if ((mode_flag & STATISTIC) && i > optind)
 			printf("\n");
 
@@ -1918,9 +2136,6 @@ int main(int argc, char *argv[])
 				continue;
 			}
 			arg_type = DEVNAME;
-			if (!(mode_flag & STATISTIC))
-				printf("ext4 defragmentation for device(%s)\n",
-					argv[i]);
 		} else if (S_ISDIR(buf.st_mode)) {
 			/* Directory */
 			if (access(argv[i], R_OK) < 0) {
@@ -1939,6 +2154,18 @@ int main(int argc, char *argv[])
 			continue;
 		}
 
+		/* Set the device number of the first argument */
+		if (i == optind)
+			first_dev = buf.st_dev;
+
+		/* -r mode with TARGET can defrag only the same filesystem */
+		if ((mode_flag & RELEVANT) && first_dev != buf.st_dev) {
+			PRINT_ERR_MSG("FILE is not the same filesystem as "
+					"TARGET");
+			PRINT_FILE_NAME(argv[i]);
+			continue;
+		}
+
 		/* Set blocksize */
 		block_size = buf.st_blksize;
 
@@ -1969,19 +2196,73 @@ int main(int argc, char *argv[])
 			blocks_per_group = sb.s_blocks_per_group;
 			feature_incompat = sb.s_feature_incompat;
 			log_groups_per_flex = sb.s_log_groups_per_flex;
+			fs_blocks_count = ext4_blocks_count(&sb);
 		}
 
 		switch (arg_type) {
 		case DIRNAME:
-			if (!(mode_flag & STATISTIC))
-				printf("ext4 defragmentation "
-					"for directory(%s)\n", argv[i]);
+		case DEVNAME:
+			if ((mode_flag & RELEVANT) && i == optind) {
+				DIR *dp;
+				int fd, ret;
+
+				dp = opendir(dir_name);
+				if (dp == NULL) {
+					if (mode_flag & DETAIL) {
+						perror(NGMSG_FILE_OPEN);
+						PRINT_FILE_NAME(dir_name);
+					}
+					exit(1);
+				}
+
+				fd = dirfd(dp);
+				if (fd < 0) {
+					if (mode_flag & DETAIL) {
+						perror(NGMSG_FILE_OPEN);
+						PRINT_FILE_NAME(dir_name);
+					}
+					closedir(dp);
+					exit(1);
+				}
+
+				r_pstart = get_physical_offset(fd, &ret);
+				close(fd);
+				closedir(dp);
+				if (ret < 0) {
+					if (mode_flag & DETAIL) {
+						perror("failed to fiemap");
+						PRINT_FILE_NAME(dir_name);
+					}
+					exit(1);
+				}
+
+				continue;
+			}
 
 			int mount_dir_len = 0;
-			mount_dir_len = strnlen(lost_found_dir, PATH_MAX);
 
-			strncat(lost_found_dir, "/lost+found",
-				PATH_MAX - strnlen(lost_found_dir, PATH_MAX));
+			if (!(mode_flag & STATISTIC)) {
+				printf("ext4 defragmentation for ");
+				if (arg_type == DIRNAME)
+					printf("directory(%s)\n", argv[i]);
+				else
+					printf("device(%s)\n", argv[i]);
+			}
+
+			if (arg_type == DIRNAME) {
+				mount_dir_len = strnlen(lost_found_dir,
+								PATH_MAX);
+				strncat(lost_found_dir, "/lost+found",
+					PATH_MAX - strnlen(lost_found_dir,
+								PATH_MAX));
+			} else if (arg_type == DEVNAME) {
+				mount_dir_len = strnlen(dir_name, PATH_MAX);
+				strncpy(lost_found_dir, dir_name,
+					strnlen(dir_name, PATH_MAX));
+				strncat(lost_found_dir, "/lost+found/",
+					PATH_MAX - strnlen(lost_found_dir,
+								PATH_MAX));
+			}
 
 			/* Not the case("e4defrag  mount_piont_dir") */
 			if (dir_name[mount_dir_len] != '\0') {
@@ -1990,12 +2271,12 @@ int main(int argc, char *argv[])
 				 * or "e4defrag mount_piont_dir/lost+found/"
 				 */
 				if (strncmp(lost_found_dir, dir_name,
-					    strnlen(lost_found_dir,
-						    PATH_MAX)) == 0 &&
-				    (dir_name[strnlen(lost_found_dir,
-						      PATH_MAX)] == '\0' ||
-				     dir_name[strnlen(lost_found_dir,
-						      PATH_MAX)] == '/')) {
+						strnlen(lost_found_dir,
+							PATH_MAX)) == 0 &&
+					(dir_name[strnlen(lost_found_dir,
+							PATH_MAX)] == '\0' ||
+					dir_name[strnlen(lost_found_dir,
+							PATH_MAX)] == '/')) {
 					PRINT_ERR_MSG(NGMSG_LOST_FOUND);
 					PRINT_FILE_NAME(argv[i]);
 					continue;
@@ -2004,14 +2285,6 @@ int main(int argc, char *argv[])
 				/* "e4defrag mount_piont_dir/else_dir" */
 				memset(lost_found_dir, 0, PATH_MAX + 1);
 			}
-		case DEVNAME:
-			if (arg_type == DEVNAME) {
-				strncpy(lost_found_dir, dir_name,
-					strnlen(dir_name, PATH_MAX));
-				strncat(lost_found_dir, "/lost+found/",
-					PATH_MAX - strnlen(lost_found_dir,
-							   PATH_MAX));
-			}
 
 			nftw(dir_name, calc_entry_counts, FTW_OPEN_FD, flags);
 
@@ -2100,14 +2373,59 @@ int main(int argc, char *argv[])
 				continue;
 			}
 
-			if (mode_flag & STATISTIC) {
+			if (mode_flag & RELEVANT && i == optind) {
+				int fd, ret;
+
+				/*
+				 * Cannot get the physical block if the file has
+				 * no block.
+				 */
+				if (buf.st_size == 0) {
+					if (mode_flag & DETAIL) {
+						PRINT_ERR_MSG("File size is 0");
+						PRINT_FILE_NAME(argv[i]);
+					}
+					exit(1);
+				} else if (buf.st_blocks == 0) {
+					if (mode_flag & DETAIL) {
+						PRINT_ERR_MSG("File has no "
+								"blocks");
+						PRINT_FILE_NAME(argv[i]);
+					}
+					exit(1);
+				}
+
+				/* get physical start of TARGET for PA */
+				fd = open(argv[i], O_RDONLY);
+				if (fd < 0) {
+					if (mode_flag & DETAIL) {
+						perror(NGMSG_FILE_OPEN);
+						PRINT_FILE_NAME(argv[i]);
+					}
+					exit(1);
+				}
+
+				r_pstart = get_physical_offset(fd, &ret);
+				close(fd);
+				if (ret < 0) {
+					if (mode_flag & DETAIL) {
+						perror("failed to fiemap");
+						PRINT_FILE_NAME(argv[i]);
+					}
+					exit(1);
+				}
+
+				continue;
+			} else if (mode_flag & STATISTIC) {
 				file_statistic(argv[i], &buf, FTW_F, NULL);
 				break;
-			} else
+			} else {
 				printf("ext4 defragmentation for %s\n",
-								 argv[i]);
-			/* Defrag single file process */
-			file_defrag(argv[i], &buf, FTW_F, NULL);
+								argv[i]);
+				/* Defrag single file process */
+				file_defrag(argv[i], &buf, FTW_F, NULL);
+			}
+
 			if (succeed_cnt != 0)
 				printf(" Success:\t\t\t[1/1]\n");
 			else
