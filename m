From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 2/3] e4defrag: fix file blocks calculation
Date: Wed, 30 Sep 2009 16:22:20 +0900
Message-ID: <4AC3072C.2080504@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39255 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZI3H0W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2009 03:26:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e4defrag uses st_blocks (struct stat) to calculate file blocks. However,
st_blocks also has meta data blocks in addition to file blocks. So, we
calculate file blocks by sum of the extent length.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---

 e4defrag.c |   46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index b10969c..94f8529 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -59,8 +59,6 @@
 #define STATISTIC_ERR_MSG_WITH_ERRNO(msg)	\
 	fprintf(stderr, "\t%s:%s\n", (msg), strerror(errno))
 #define min(x, y) (((x) > (y)) ? (y) : (x))
-#define SECTOR_TO_BLOCK(sectors, blocksize) \
-	((sectors) / ((blocksize) >> 9))
 #define CALC_SCORE(ratio) \
 	((ratio) > 10 ? (80 + 20 * (ratio) / 100) : (8 * (ratio)))
 /* Wrap up the free function */
@@ -581,11 +579,10 @@ static int defrag_fadvise(int fd, struct move_extent defrag_data,
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
 	struct statfs64	fsbuf;
 
@@ -598,9 +595,6 @@ static int check_free_size(int fd, const char *file, const struct stat64 *buf)
 		return -1;
 	}
 
-	/* Target file size measured by filesystem IO blocksize */
-	blk_count = SECTOR_TO_BLOCK(buf->st_blocks, fsbuf.f_bsize);
-
 	/* Compute free space for root and normal user separately */
 	if (current_uid == ROOT_UID)
 		free_blk_count = fsbuf.f_bfree;
@@ -643,11 +637,12 @@ static int file_frag_count(int fd)
  *
  * @fd:			defrag target file's descriptor.
  * @buf:		a pointer of the struct stat64.
- * @file:		the file's name.
- * @extents:		the file's extents.
+ * @file:		file name.
+ * @extents:		file extents.
+ * @blk_count:		file blocks.
  */
 static int file_check(int fd, const struct stat64 *buf, const char *file,
-		int extents)
+		int extents, ext4_fsblk_t blk_count)
 {
 	int	ret;
 	struct flock	lock;
@@ -659,7 +654,7 @@ static int file_check(int fd, const struct stat64 *buf, const char *file,
 	lock.l_len = 0;
 
 	/* Free space */
-	ret = check_free_size(fd, file, buf);
+	ret = check_free_size(fd, file, blk_count);
 	if (ret < 0) {
 		if ((mode_flag & DETAIL) && ret == -ENOSPC) {
 			printf("\033[79;0H\033[K[%u/%u] \"%s\"\t\t"
@@ -1069,6 +1064,23 @@ static int change_physical_to_logical(
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
@@ -1315,8 +1327,7 @@ static int file_statistic(const char *file, const struct stat64 *buf,
 
 	if (current_uid == ROOT_UID) {
 		/* Calculate the blocks per extent  */
-		blk_count =
-				SECTOR_TO_BLOCK(buf->st_blocks, block_size);
+		blk_count = get_file_blocks(logical_list_head);
 
 		best_ext_count = get_best_count(blk_count);
 
@@ -1572,6 +1583,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	int	file_frags_start, file_frags_end;
 	int	orig_physical_cnt, donor_physical_cnt = 0;
 	char	tmp_inode_name[PATH_MAX + 8];
+	ext4_fsblk_t			blk_count = 0;
 	struct fiemap_extent_list	*orig_list_physical = NULL;
 	struct fiemap_extent_list	*orig_list_logical = NULL;
 	struct fiemap_extent_list	*donor_list_physical = NULL;
@@ -1657,7 +1669,8 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	/* Count file fragments before defrag */
 	file_frags_start = get_logical_count(orig_list_logical);
 
-	if (file_check(fd, buf, file, file_frags_start) < 0)
+	blk_count = get_file_blocks(orig_list_logical);
+	if (file_check(fd, buf, file, file_frags_start, blk_count) < 0)
 		goto out;
 
 	if (fsync(fd) < 0) {
@@ -1669,8 +1682,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	}
 
 	if (current_uid == ROOT_UID)
-		best =
-		get_best_count(SECTOR_TO_BLOCK(buf->st_blocks, block_size));
+		best = get_best_count(blk_count);
 	else
 		best = 1;
