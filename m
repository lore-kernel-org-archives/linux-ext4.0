From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/47] libext2fs: use a dynamically sized (or
 caller-provided) block zeroing buffer
Date: Fri, 07 Nov 2014 13:51:46 -0800
Message-ID: <20141107215146.883.18254.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45187 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaKGVvv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:51:51 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dynamically grow the block zeroing buffer to a maximum of 4MB, and
allow callers to provide their own zeroed buffer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/alloc.c     |    2 +-
 lib/ext2fs/ext2fs.h    |    3 ++
 lib/ext2fs/mkjournal.c |   62 ++++++++++++++++++++++++++++++++++++++----------
 3 files changed, 53 insertions(+), 14 deletions(-)


diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 54535c4..cb778f7 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -203,7 +203,7 @@ errcode_t ext2fs_alloc_block2(ext2_filsys fs, blk64_t goal,
 			goto fail;
 	}
 
-	retval = ext2fs_zero_blocks2(fs, block, 1, NULL, NULL);
+	retval = ext2fs_zero_blocks3(fs, block, 1, NULL, NULL, block_buf);
 	if (retval)
 		goto fail;
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 506d43b..f9599a3 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1491,6 +1491,9 @@ extern errcode_t ext2fs_zero_blocks(ext2_filsys fs, blk_t blk, int num,
 				    blk_t *ret_blk, int *ret_count);
 extern errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
 				     blk64_t *ret_blk, int *ret_count);
+extern errcode_t ext2fs_zero_blocks3(ext2_filsys fs, blk64_t blk, int num,
+				     blk64_t *ret_blk, int *ret_count,
+				     const void *block_buf);
 extern errcode_t ext2fs_create_journal_superblock(ext2_filsys fs,
 						  __u32 num_blocks, int flags,
 						  char  **ret_jsb);
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index e8f8b30..fdd788b 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -148,12 +148,14 @@ errfree:
  * attempt to free the static zeroizing buffer.  (This is to keep
  * programs that check for memory leaks happy.)
  */
-#define STRIDE_LENGTH (4194304 / fs->blocksize)
-errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
-			      blk64_t *ret_blk, int *ret_count)
+#define MAX_STRIDE_LENGTH (4194304 / fs->blocksize)
+errcode_t ext2fs_zero_blocks3(ext2_filsys fs, blk64_t blk, int num,
+			      blk64_t *ret_blk, int *ret_count,
+			      const void *block_buf)
 {
 	int		j, count;
-	static char	*buf;
+	static void	*buf;
+	static unsigned	stride_length;
 	errcode_t	retval;
 
 	/* If fs is null, clean up the static buffer and return */
@@ -164,24 +166,52 @@ errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
 		}
 		return 0;
 	}
+
+	/* Deal with zeroing less than 1 block */
+	if (num <= 0)
+		return 0;
+
+	/* If the user gave us a buffer, write that out */
+	if (block_buf) {
+		retval = io_channel_write_blk64(fs->io, blk, num, block_buf);
+		if (retval) {
+			if (ret_count)
+				*ret_count = num;
+			if (ret_blk)
+				*ret_blk = blk;
+		}
+
+		return retval;
+	}
+
 	/* Allocate the zeroizing buffer if necessary */
-	if (!buf) {
-		buf = malloc(fs->blocksize * STRIDE_LENGTH);
-		if (!buf)
-			return ENOMEM;
-		memset(buf, 0, fs->blocksize * STRIDE_LENGTH);
+	if (num > stride_length) {
+		void *p;
+		unsigned new_stride = num;
+
+		if (new_stride > MAX_STRIDE_LENGTH)
+			new_stride = MAX_STRIDE_LENGTH;
+		if (new_stride == stride_length)
+			goto skip_alloc;
+		p = realloc(buf, fs->blocksize * new_stride);
+		if (!p)
+			return EXT2_ET_NO_MEMORY;
+		buf = p;
+		stride_length = new_stride;
+		memset(buf, 0, fs->blocksize * stride_length);
 	}
+skip_alloc:
 	/* OK, do the write loop */
 	j=0;
 	while (j < num) {
-		if (blk % STRIDE_LENGTH) {
-			count = STRIDE_LENGTH - (blk % STRIDE_LENGTH);
+		if (blk % stride_length) {
+			count = stride_length - (blk % stride_length);
 			if (count > (num - j))
 				count = num - j;
 		} else {
 			count = num - j;
-			if (count > STRIDE_LENGTH)
-				count = STRIDE_LENGTH;
+			if (count > stride_length)
+				count = stride_length;
 		}
 		retval = io_channel_write_blk64(fs->io, blk, count, buf);
 		if (retval) {
@@ -196,6 +226,12 @@ errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
 	return 0;
 }
 
+errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
+			      blk64_t *ret_blk, int *ret_count)
+{
+	return ext2fs_zero_blocks3(fs, blk, num, ret_blk, ret_count, NULL);
+}
+
 errcode_t ext2fs_zero_blocks(ext2_filsys fs, blk_t blk, int num,
 			     blk_t *ret_blk, int *ret_count)
 {

