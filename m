From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] misc: quiet "unused variable" compiler warnings
Date: Tue, 14 Jun 2011 16:25:16 -0600
Message-ID: <1308090316-16173-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:40263 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab1FNWZS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jun 2011 18:25:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some of the newly-merged patches added "unused variable" compiler
warnings.  Delete unused variables.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 lib/ext2fs/alloc.c |    2 +-
 misc/e2image.c     |   13 +++----------
 misc/mke2fs.c      |    2 +-
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index fbecdbe..b112495 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -256,7 +256,7 @@ errcode_t ext2fs_alloc_block(ext2_filsys fs, blk_t goal,
 errcode_t ext2fs_get_free_blocks2(ext2_filsys fs, blk64_t start, blk64_t finish,
 				 int num, ext2fs_block_bitmap map, blk64_t *ret)
 {
-	blk64_t	b = start, c = 0;
+	blk64_t	b = start;
 	int	c_ratio;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
diff --git a/misc/e2image.c b/misc/e2image.c
index 3f91f64..83a9d02 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -92,7 +92,6 @@ static void generic_write(int fd, void *buf, int blocksize, blk64_t block)
 {
 	int count, free_buf = 0;
 	errcode_t err;
-	blk64_t offset;
 
 	if (!blocksize)
 		return;
@@ -128,7 +127,7 @@ static void generic_write(int fd, void *buf, int blocksize, blk64_t block)
 static void write_header(int fd, void *hdr, int hdr_size, int wrt_size)
 {
 	char *header_buf;
-	int actual, ret;
+	int ret;
 
 	/* Sanity check */
 	if (hdr_size > wrt_size) {
@@ -712,8 +711,6 @@ static int initialize_qcow2_image(int fd, ext2_filsys fs,
 
 static void free_qcow2_image(struct ext2_qcow2_image *img)
 {
-	unsigned int i;
-
 	if (!img)
 		return;
 
@@ -910,14 +907,10 @@ static int sync_refcount(int fd, struct ext2_qcow2_image *img)
 static void output_qcow2_meta_data_blocks(ext2_filsys fs, int fd)
 {
 	errcode_t		retval;
-	blk64_t			blk, datablk, offset, size, actual, end;
+	blk64_t			blk, offset, size, end;
 	char			*buf;
-	int			sparse = 0;
 	struct ext2_qcow2_image	*img;
-	unsigned int		header_size, i;
-	blk64_t			l1_index, l2_offset, l2_index;
-	char			*buffer;
-	__u64			*l2_table;
+	unsigned int		header_size;
 
 	/* allocate  struct ext2_qcow2_image */
 	retval = ext2fs_get_mem(sizeof(struct ext2_qcow2_image), &img);
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index cdf2281..7e0cc34 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2110,7 +2110,7 @@ static int mke2fs_discard_device(ext2_filsys fs)
 	return retval;
 }
 
-static fix_cluster_bg_counts(ext2_filsys fs)
+static void fix_cluster_bg_counts(ext2_filsys fs)
 {
 	blk64_t	cluster, num_clusters, tot_free;
 	int	grp_free, num_free, group, num;
-- 
1.7.3.4

