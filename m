From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [RFC][PATCH V2 5/5] e4defrag: add solving relevant file fragmentation
 mode
Date: Wed, 25 Aug 2010 17:52:39 +0900
Message-ID: <4C74D9D7.4020005@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:43997 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab0HYJCG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Aug 2010 05:02:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

All files contained in the same directory are likely to be read at once.
So, we hope that data blocks of the files in the same directory will be
allocated near to reduce seek time.

This patch adds e4defrag -r option. If you use this option, files under the
specified directory will be moved near the block containing the directory data.
If you execute e4defrag with -r option to the directory, you can read files
in the target directory faster than before.

Usage	: e4defrag  -r  directory...| device...

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 misc/e4defrag.c |  250 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 235 insertions(+), 15 deletions(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 61eb259..3f1df05 100644
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
@@ -105,10 +115,17 @@
  */
 #define EXTENT_MAX_COUNT	512
 
+/* The maximum number of inode PAs that EXT4_IOC_CONTROL_PA can set */
+#define EXT4_MAX_PREALLOC	1024
+
+/* The upper limit of length of prealloc which EXT4_IOC_CONTROL_PA can set */
+#define PREALLOC_MAX_BLK (blocks_per_group - 10)
+
 /* The following macros are error message */
 #define MSG_USAGE		\
 "Usage	: e4defrag [-v] file...| directory...| device...\n\
-	: e4defrag  -c  file...| directory...| device...\n"
+	: e4defrag  -c  file...| directory...| device...\n\
+	: e4defrag  -r  directory...| device...\n"
 
 #define NGMSG_EXT4		"Filesystem is not ext4 filesystem"
 #define NGMSG_FILE_EXTENT	"Failed to get file extents"
@@ -116,6 +133,7 @@
 #define NGMSG_FILE_OPEN		"Failed to open"
 #define NGMSG_FILE_UNREG	"File is not regular file"
 #define NGMSG_LOST_FOUND	"Can not process \"lost+found\""
+#define NGMSG_FILE_UNDIR	"Target is not directory"
 
 /* Data type for filesystem-wide blocks number */
 typedef unsigned long long ext4_fsblk_t;
@@ -157,6 +175,16 @@ struct frag_statistic_ino {
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
@@ -267,8 +295,11 @@ unsigned int	total_count;
 __u8 log_groups_per_flex;
 __le32 blocks_per_group;
 __le32 feature_incompat;
+__le32 first_data_block;
 ext4_fsblk_t	files_block_count;
 struct frag_statistic_ino	frag_rank[SHOW_FRAG_FILES];
+__u64 r_pstart;
+blk64_t fs_blocks_count;
 
 
 /* Local definitions of some syscalls glibc may not yet have */
@@ -1562,6 +1593,133 @@ static int call_defrag(int fd, int donor_fd, const char *file,
 	return 0;
 }
 
+static unsigned long long get_dir_offset(const int fd, int *ret)
+{
+	struct fiemap	*fiemap_buf;
+	char *fiebuf;
+	unsigned long long blk;
+
+	fiebuf = malloc(sizeof(struct fiemap) + sizeof(struct fiemap_extent));
+
+	if (!fiebuf) {
+		*ret = -1;
+		return;
+	}
+
+	fiemap_buf = (struct fiemap *)fiebuf;
+	/* When fm_extent_count is 0,
+	 * ioctl just get file fragment count.
+	 */
+	memset(fiemap_buf, 0, sizeof(struct fiemap));
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
+	loff_t tmp_log, tmp_len, fallocated = 0;
+	int ret = 0, rest;
+	int bpg = blocks_per_group;
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
+			int grp_offset;
+			grp_offset = (pi.pi_pstart - first_data_block) % bpg;
+
+			pi.pi_len = rest;
+			if ((grp_offset + pi.pi_len) > bpg)
+				pi.pi_len = bpg - grp_offset;
+			if ((pi.pi_pstart + pi.pi_len) > fs_blocks_count)
+				pi.pi_len = fs_blocks_count - pi.pi_pstart;
+			pi.pi_len = min(pi.pi_len, PREALLOC_MAX_BLK);
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
@@ -1580,6 +1738,7 @@ static int file_defrag(const char *file, const struct stat *buf,
 	int	best;
 	int	file_frags_start, file_frags_end;
 	int	orig_physical_cnt, donor_physical_cnt = 0;
+	int	no_mvext;
 	char	tmp_inode_name[PATH_MAX + 8];
 	ext4_fsblk_t			blk_count = 0;
 	struct fiemap_extent_list	*orig_list_physical = NULL;
@@ -1684,8 +1843,13 @@ static int file_defrag(const char *file, const struct stat *buf,
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
@@ -1724,22 +1888,36 @@ static int file_defrag(const char *file, const struct stat *buf,
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
@@ -1773,8 +1951,16 @@ check_improvement:
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
@@ -1855,7 +2041,7 @@ int main(int argc, char *argv[])
 	if (argc == 1)
 		goto out;
 
-	while ((opt = getopt(argc, argv, "vc")) != EOF) {
+	while ((opt = getopt(argc, argv, "vcr")) != EOF) {
 		switch (opt) {
 		case 'v':
 			mode_flag |= DETAIL;
@@ -1863,6 +2049,9 @@ int main(int argc, char *argv[])
 		case 'c':
 			mode_flag |= STATISTIC;
 			break;
+		case 'r':
+			mode_flag |= RELEVANT;
+			break;
 		default:
 			goto out;
 		}
@@ -1939,6 +2128,13 @@ int main(int argc, char *argv[])
 			continue;
 		}
 
+		/* -r mode can defrag only directory. */
+		if ((mode_flag & RELEVANT) && arg_type == FILENAME) {
+			PRINT_ERR_MSG(NGMSG_FILE_UNDIR);
+			PRINT_FILE_NAME(argv[i]);
+			continue;
+		}
+
 		/* Set blocksize */
 		block_size = buf.st_blksize;
 
@@ -1967,8 +2163,10 @@ int main(int argc, char *argv[])
 			}
 
 			blocks_per_group = sb.s_blocks_per_group;
+			first_data_block = sb.s_first_data_block;
 			feature_incompat = sb.s_feature_incompat;
 			log_groups_per_flex = sb.s_log_groups_per_flex;
+			fs_blocks_count = ext4_blocks_count(&sb);
 		}
 
 		switch (arg_type) {
@@ -2013,6 +2211,28 @@ int main(int argc, char *argv[])
 							   PATH_MAX));
 			}
 
+			if (mode_flag & RELEVANT) {
+				int fd, ret;
+				fd = dirfd(opendir(dir_name));
+				if (fd < 0) {
+					if (mode_flag & DETAIL) {
+						perror(NGMSG_FILE_OPEN);
+						PRINT_FILE_NAME(dir_name);
+					}
+					continue;
+				}
+
+				r_pstart = get_dir_offset(fd, &ret);
+				if (ret < 0) {
+					if (mode_flag & DETAIL) {
+						perror("failed to fiemap\n");
+						PRINT_FILE_NAME(dir_name);
+					}
+					continue;
+				}
+				close(fd);
+			}
+
 			nftw(dir_name, calc_entry_counts, FTW_OPEN_FD, flags);
 
 			if (mode_flag & STATISTIC) {
