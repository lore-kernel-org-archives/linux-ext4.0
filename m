From: Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 1/2] libext2fs: fix block-mapped file punch
Date: Thu, 19 Nov 2015 01:13:18 -0700
Message-ID: <1447920799-12834-1-git-send-email-andreas.dilger@intel.com>
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <andreas.dilger@intel.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-so.shaw.ca ([64.59.136.138]:46726 "EHLO
	smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbbKSIVa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Nov 2015 03:21:30 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If ext2fs_punch() was called with "end = ~0ULL" to indicate truncate
to the end of file it tried to compute "count" for ext2fs_punch_ind()
based on "start" and "end", but incorrectly passed "count = ~0U" even
when "start" was non-zero, causing an overflow in some cases.

The calling convention for ext2fs_punch_ind() was also gratuitously
different from ext2fs_punch() and ext2fs_punch_extent(), passing
"count" instead of "end" as the last parameter.  Fix this by passing
it "end" like the other functions, and handle "count" internally.

Add checks to ext2fs_punch_ind() if "end" is at or beyond the 2^32
indirect block limit so the 32-bit internal variables don't overflow.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 lib/ext2fs/punch.c |   48 +++++++++++++++++++++++++++---------------------
 1 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index 2a2cf10..62ddd50 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -47,7 +47,7 @@ static int check_zero_block(char *buf, int blocksize)
  */
 static errcode_t ind_punch(ext2_filsys fs, struct ext2_inode *inode,
 			   char *block_buf, blk_t *p, int level,
-			   blk_t start, blk_t count, int max)
+			   blk64_t start, blk64_t count, int max)
 {
 	errcode_t	retval;
 	blk_t		b;
@@ -56,11 +56,11 @@ static errcode_t ind_punch(ext2_filsys fs, struct ext2_inode *inode,
 	int		freed = 0;
 
 #ifdef PUNCH_DEBUG
-	printf("Entering ind_punch, level %d, start %u, count %u, "
+	printf("Entering ind_punch, level %d, start %llu, count %llu, "
 	       "max %d\n", level, start, count, max);
 #endif
-	incr = 1ULL << ((EXT2_BLOCK_SIZE_BITS(fs->super)-2)*level);
-	for (i=0, offset=0; i < max; i++, p++, offset += incr) {
+	incr = 1ULL << ((EXT2_BLOCK_SIZE_BITS(fs->super) - 2) * level);
+	for (i = 0, offset = 0; i < max; i++, p++, offset += incr) {
 		if (offset >= start + count)
 			break;
 		if (*p == 0 || (offset+incr) <= start)
@@ -100,8 +100,9 @@ static errcode_t ind_punch(ext2_filsys fs, struct ext2_inode *inode,
 	return ext2fs_iblk_sub_blocks(fs, inode, freed);
 }
 
+#define BLK_T_MAX ((blk_t)~0ULL)
 static errcode_t ext2fs_punch_ind(ext2_filsys fs, struct ext2_inode *inode,
-				  char *block_buf, blk_t start, blk_t count)
+				  char *block_buf, blk64_t start, blk64_t end)
 {
 	errcode_t		retval;
 	char			*buf = 0;
@@ -110,6 +111,15 @@ static errcode_t ext2fs_punch_ind(ext2_filsys fs, struct ext2_inode *inode,
 	blk_t			*bp = inode->i_block;
 	blk_t			addr_per_block;
 	blk64_t			max = EXT2_NDIR_BLOCKS;
+	blk_t			count;
+
+	/* Check start/end don't overflow the 2^32-1 indirect block limit */
+	if (start > BLK_T_MAX)
+		return 0;
+	if (end >= BLK_T_MAX || end - start + 1 >= BLK_T_MAX)
+		count = BLK_T_MAX - start;
+	else
+		count = end - start + 1;
 
 	if (!block_buf) {
 		retval = ext2fs_get_array(3, fs->blocksize, &buf);
@@ -118,11 +128,11 @@ static errcode_t ext2fs_punch_ind(ext2_filsys fs, struct ext2_inode *inode,
 		block_buf = buf;
 	}
 
-	addr_per_block = (blk_t) fs->blocksize >> 2;
+	addr_per_block = (blk_t)fs->blocksize >> 2;
 
 	for (level = 0; level < 4; level++, max *= (blk64_t)addr_per_block) {
 #ifdef PUNCH_DEBUG
-		printf("Main loop level %d, start %u count %u "
+		printf("Main loop level %d, start %llu count %u "
 		       "max %llu num %d\n", level, start, count, max, num);
 #endif
 		if (start < max) {
@@ -149,6 +159,7 @@ errout:
 		ext2fs_free_mem(&buf);
 	return retval;
 }
+#undef BLK_T_MAX
 
 #ifdef PUNCH_DEBUG
 
@@ -428,10 +439,10 @@ errout:
 	ext2fs_extent_free(handle);
 	return retval;
 }
-	
+
 /*
- * Deallocate all logical blocks starting at start to end, inclusive.
- * If end is ~0, then this is effectively truncate.
+ * Deallocate all logical _blocks_ starting at start to end, inclusive.
+ * If end is ~0ULL, then this is effectively truncate.
  */
 errcode_t ext2fs_punch(ext2_filsys fs, ext2_ino_t ino,
 		       struct ext2_inode *inode,
@@ -453,19 +464,14 @@ errcode_t ext2fs_punch(ext2_filsys fs, ext2_ino_t ino,
 	}
 	if (inode->i_flags & EXT4_EXTENTS_FL)
 		retval = ext2fs_punch_extent(fs, ino, inode, start, end);
-	else {
-		blk_t	count;
