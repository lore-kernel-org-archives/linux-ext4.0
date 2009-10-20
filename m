From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [RFC][PATCH v2 1/4] e4defrag: output size per extent by -c option
Date: Tue, 20 Oct 2009 17:15:20 +0900
Message-ID: <4ADD7198.60007@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
	Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:58451 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZJTIRf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Oct 2009 04:17:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have addressed Greg's comments.
(http://marc.info/?l=linux-ext4&m=125433530126348&w=4)

e4defrag with -c option outputs "ratio" that means the levels of
fragmentation. However, it's difficult for users to understand, so we will
use size per extent instead of ratio.

Before:
# e4defrag -c /mnt/mp1/file
<File>                                         now/best          ratio
/mnt/mp1/file                                    6/1             0.00%

 Total/best extents                             6/1
 Fragmentation ratio                            0.00%
 Fragmentation score                            0.04
 [0-30 no problem: 31-55 a little bit fragmented: 55- needs defrag]
 This file(/mnt/mp1/file) does not need defragmentation.
 Done.

After:
# e4defrag -c /mnt/mp1/file
<File>                                         now/best       size/ext
/mnt/mp1/file                                    6/1          16666 KB

 Total/best extents                             6/1
 Average size per extent                        16666 KB
 Fragmentation score                            0
 [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
 This file (/mnt/mp1/file) does not need defragmentation.
 Done.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---

 e4defrag.c |   76 +++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 52 insertions(+), 24 deletions(-)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 82e3868..d8c7d97 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -160,6 +160,7 @@ struct move_extent {
 struct frag_statistic_ino {
 	int now_count;	/* the file's extents count of before defrag */
 	int best_count; /* the best file's extents count */
+	__u64 size_per_ext;	/* size(KB) per extent */
 	float ratio;	/* the ratio of fragmentation */
 	char msg_buffer[PATH_MAX + 1];	/* pathname of the file */
 };
@@ -1212,6 +1213,7 @@ static int file_statistic(const char *file, const struct stat64 *buf,
 	int	ret;
 	int	now_ext_count, best_ext_count = 0, physical_ext_count;
 	int	i, j;
+	__u64	size_per_ext = 0;
 	float	ratio = 0.0;
 	ext4_fsblk_t	blk_count = 0;
 	char	msg_buffer[PATH_MAX + 24];
@@ -1312,12 +1314,16 @@ static int file_statistic(const char *file, const struct stat64 *buf,
 	now_ext_count = get_logical_count(logical_list_head);
 
 	if (current_uid == ROOT_UID) {
-		/* Calculate fragment ratio  */
+		/* Calculate the size per extent */
 		blk_count =
 				SECTOR_TO_BLOCK(buf->st_blocks, block_size);
 
 		best_ext_count = get_best_count(blk_count);
 
+		/* e4defrag rounds size_per_ext up to a block size boundary */
+		size_per_ext = blk_count * (buf->st_blksize / 1024) /
+							now_ext_count;
+
 		ratio = (float)(physical_ext_count - best_ext_count) * 100 /
 							blk_count;
 
@@ -1346,16 +1352,16 @@ static int file_statistic(const char *file, const struct stat64 *buf,
 
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
@@ -1378,14 +1384,14 @@ static int file_statistic(const char *file, const struct stat64 *buf,
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
@@ -1401,8 +1407,20 @@ static int file_statistic(const char *file, const struct stat64 *buf,
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
@@ -1410,6 +1428,7 @@ static int file_statistic(const char *file, const struct stat64 *buf,
 						strnlen(file, PATH_MAX));
 			frag_rank[i].now_count = now_ext_count;
 			frag_rank[i].best_count = best_ext_count;
+			frag_rank[i].size_per_ext = size_per_ext;
 			frag_rank[i].ratio = ratio;
 			break;
 		}
@@ -1992,7 +2011,7 @@ int main(int argc, char *argv[])
 			if (mode_flag & STATISTIC) {
 				if (mode_flag & DETAIL)
 					printf("%-40s%10s/%-10s%9s\n",
-					"<File>", "now", "best", "ratio");
+					"<File>", "now", "best", "size/ext");
 
 				if (!(mode_flag & DETAIL) &&
 						current_uid != ROOT_UID) {
@@ -2009,24 +2028,28 @@ int main(int argc, char *argv[])
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
@@ -2109,26 +2132,31 @@ int main(int argc, char *argv[])
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
-					printf(" This device(%s) ", argv[i]);
+					printf(" This device (%s) ", argv[i]);
 				else if (arg_type == DIRNAME)
-					printf(" This directory(%s) ", argv[i]);
+					printf(" This directory (%s) ",
+								argv[i]);
 				else
-					printf(" This file(%s) ", argv[i]);
+					printf(" This file (%s) ", argv[i]);
 
 				if (score > BOUND_SCORE)
 					printf("needs defragmentation.\n");
