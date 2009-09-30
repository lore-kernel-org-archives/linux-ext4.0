From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 1/3] e4defrag: output blocks per extent by -c option
Date: Wed, 30 Sep 2009 16:20:16 +0900
Message-ID: <4AC306B0.9070308@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:43187 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZI3HZo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2009 03:25:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e4defrag with -c option outputs "ratio" that means the levels of
fragmentation. However, it's difficult for users to understand, so we will
use blocks per extent instead of ratio.

Before:
# e4defrag -c /mnt/mp1/file
<File>                                         now/best          ratio
/mnt/mp1/file                                   14/1             0.01%

 Total/best extents                             14/1
 Fragmentation ratio                            0.01%
 Fragmentation score                            0.10
 [0-30 no problem: 31-55 a little bit fragmented: 55- needs defrag]
 This file(/mnt/mp1/file) does not need defragmentation.
 Done.

After:
# e4defrag -c /mnt/mp1/file
<File>                                         now/best        blk/ext
/mnt/mp1/file                                   14/1              7142

 Total/best extents                             14/1
 Average blocks per extent                      7142
 Fragmentation score                            0
 [0-30 no problem: 31-55 a little bit fragmented: 55- needs defrag]
 This file(/mnt/mp1/file) does not need defragmentation.
 Done.


Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---

 e4defrag.c |   61 +++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 20 deletions(-)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 82e3868..ca63229 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -160,6 +160,7 @@ struct move_extent {
 struct frag_statistic_ino {
 	int now_count;	/* the file's extents count of before defrag */
 	int best_count; /* the best file's extents count */
+	__u64 blk_per_ext;	/* blocks per extent */
 	float ratio;	/* the ratio of fragmentation */
 	char msg_buffer[PATH_MAX + 1];	/* pathname of the file */
 };
@@ -1212,6 +1213,7 @@ static int file_statistic(const char *file, const struct stat64 *buf,
 	int	ret;
 	int	now_ext_count, best_ext_count = 0, physical_ext_count;
 	int	i, j;
+	__u64	blk_per_ext = 0;
 	float	ratio = 0.0;
 	ext4_fsblk_t	blk_count = 0;
 	char	msg_buffer[PATH_MAX + 24];
@@ -1312,12 +1314,13 @@ static int file_statistic(const char *file, const struct stat64 *buf,
 	now_ext_count = get_logical_count(logical_list_head);
 
 	if (current_uid == ROOT_UID) {
-		/* Calculate fragment ratio  */
+		/* Calculate the blocks per extent  */
 		blk_count =
 				SECTOR_TO_BLOCK(buf->st_blocks, block_size);
 
 		best_ext_count = get_best_count(blk_count);
 
+		blk_per_ext = blk_count / now_ext_count;
 		ratio = (float)(physical_ext_count - best_ext_count) * 100 /
 							blk_count;
 
@@ -1346,16 +1349,16 @@ static int file_statistic(const char *file, const struct stat64 *buf,
 
 		} else {
 			printf("%-40s%10s/%-10s%9s\n",
-					"<File>", "now", "best", "ratio");
+					"<File>", "now", "best", "blk/ext");
 			if (current_uid == ROOT_UID) {
 				if (strlen(file) > 40)
-					printf("%s\n%50d/%-10d%8.2f%%\n",
+					printf("%s\n%50d/%-10d%9llu\n",
 						file, now_ext_count,
-						best_ext_count, ratio);
+						best_ext_count, blk_per_ext);
 				else
-					printf("%-40s%10d/%-10d%8.2f%%\n",
+					printf("%-40s%10d/%-10d%9llu\n",
 						file, now_ext_count,
-						best_ext_count, ratio);
+						best_ext_count, blk_per_ext);
 			} else {
 				if (strlen(file) > 40)
 					printf("%s\n%50d/%-10s%7s\n",
@@ -1378,14 +1381,14 @@ static int file_statistic(const char *file, const struct stat64 *buf,
 		if (current_uid == ROOT_UID) {
 			if (strlen(msg_buffer) > 40)
 				printf("\033[79;0H\033[K%s\n"
-						"%50d/%-10d%8.2f%%\n",
+						"%50d/%-10d%9llu\n",
 						msg_buffer, now_ext_count,
-						best_ext_count, ratio);
+						best_ext_count, blk_per_ext);
 			else
 				printf("\033[79;0H\033[K%-40s"
-						"%10d/%-10d%8.2f%%\n",
+						"%10d/%-10d%9llu\n",
 						msg_buffer, now_ext_count,
-						best_ext_count, ratio);
+						best_ext_count, blk_per_ext);
 		} else {
 			if (strlen(msg_buffer) > 40)
 				printf("\033[79;0H\033[K%s\n%50d/%-10s%7s\n",
@@ -1401,8 +1404,20 @@ static int file_statistic(const char *file, const struct stat64 *buf,
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
+				frag_rank[j].blk_per_ext =
+					frag_rank[j - 1].blk_per_ext;
+				frag_rank[j].ratio =
+					frag_rank[j - 1].ratio;
 			}
 			memset(&frag_rank[i], 0,
 					sizeof(struct frag_statistic_ino));
@@ -1410,6 +1425,7 @@ static int file_statistic(const char *file, const struct stat64 *buf,
 						strnlen(file, PATH_MAX));
 			frag_rank[i].now_count = now_ext_count;
 			frag_rank[i].best_count = best_ext_count;
+			frag_rank[i].blk_per_ext = blk_per_ext;
 			frag_rank[i].ratio = ratio;
 			break;
 		}
@@ -1992,7 +2008,7 @@ int main(int argc, char *argv[])
 			if (mode_flag & STATISTIC) {
 				if (mode_flag & DETAIL)
 					printf("%-40s%10s/%-10s%9s\n",
-					"<File>", "now", "best", "ratio");
+					"<File>", "now", "best", "blk/ext");
 
 				if (!(mode_flag & DETAIL) &&
 						current_uid != ROOT_UID) {
@@ -2009,24 +2025,26 @@ int main(int argc, char *argv[])
 						printf("\n");
 					printf("%-40s%10s/%-10s%9s\n",
 						"<Fragmented files>", "now",
-						"best", "ratio");
+						"best", "blk/ext");
 					for (j = 0; j < SHOW_FRAG_FILES; j++) {
 						if (strlen(frag_rank[j].
 							msg_buffer) > 37) {
 							printf("%d. %s\n%50d/"
-							"%-10d%8.2f%%\n", j + 1,
+							"%-10d%9llu\n", j + 1,
 							frag_rank[j].msg_buffer,
 							frag_rank[j].now_count,
 							frag_rank[j].best_count,
-							frag_rank[j].ratio);
+							frag_rank[j].
+								blk_per_ext);
 						} else if (strlen(frag_rank[j].
 							msg_buffer) > 0) {
 							printf("%d. %-37s%10d/"
-							"%-10d%8.2f%%\n", j + 1,
+							"%-10d%9llu\n", j + 1,
 							frag_rank[j].msg_buffer,
 							frag_rank[j].now_count,
 							frag_rank[j].best_count,
-							frag_rank[j].ratio);
+							frag_rank[j].
+								blk_per_ext);
 						} else
 							break;
 					}
@@ -2109,16 +2127,19 @@ int main(int argc, char *argv[])
 			} else {
 				float files_ratio = 0.0;
 				float score = 0.0;
+				__u64 blk_per_ext = files_block_count /
+						extents_before_defrag;
+
 				files_ratio = (float)(extents_before_defrag -
 						extents_after_defrag) *
 						100 / files_block_count;
 				score = CALC_SCORE(files_ratio);
 				printf("\n Total/best extents\t\t\t\t%d/%d\n"
-					" Fragmentation ratio\t\t\t\t%.2f%%\n"
-					" Fragmentation score\t\t\t\t%.2f\n",
+					" Average blocks per extent\t\t\t%llu\n"
+					" Fragmentation score\t\t\t\t%.0f\n",
 						extents_before_defrag,
 						extents_after_defrag,
-						files_ratio, score);
+						blk_per_ext, score);
 				printf(" [0-30 no problem:"
 					" 31-55 a little bit fragmented:"
 					" 55- needs defrag]\n");
