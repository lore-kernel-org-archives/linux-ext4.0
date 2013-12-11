From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/74] libext2fs: don't overflow when punching indirect blocks
 with large blocks
Date: Tue, 10 Dec 2013 17:18:21 -0800
Message-ID: <20131211011821.30655.67004.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25760 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3LKBS2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:18:28 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On a FS with a rather large blockize (> 4K), the old block map
structure can construct a fat enough "tree" (or whatever we call that
lopsided thing) that (at least in theory) one could create mappings
for logical blocks higher than 32 bits.  In practice this doesn't
happen, but the 'max' and 'iter' variables that the punch helpers use
will overflow because the BLOCK_SIZE_BITS shifts are too large to fit
a 32-bit variable.  The current variable declarations also cause punch
to fail on TIND-mapped blocks even if the file is < 16T.  So enlarge
the fields to fit.

Yes this is an obscure corner case, but it seems a little silly if we
can't punch a file's block 300,000,000 on a 64k-block filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/punch.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)


diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index 4471f46..790a0ad8 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -50,15 +50,16 @@ static errcode_t ind_punch(ext2_filsys fs, struct ext2_inode *inode,
 			   blk_t start, blk_t count, int max)
 {
 	errcode_t	retval;
-	blk_t		b, offset;
-	int		i, incr;
+	blk_t		b;
+	int		i;
+	blk64_t		offset, incr;
 	int		freed = 0;
 
 #ifdef PUNCH_DEBUG
 	printf("Entering ind_punch, level %d, start %u, count %u, "
 	       "max %d\n", level, start, count, max);
 #endif
-	incr = 1 << ((EXT2_BLOCK_SIZE_BITS(fs->super)-2)*level);
+	incr = 1ULL << ((EXT2_BLOCK_SIZE_BITS(fs->super)-2)*level);
 	for (i=0, offset=0; i < max; i++, p++, offset += incr) {
 		if (offset >= start + count)
 			break;
@@ -87,7 +88,7 @@ static errcode_t ind_punch(ext2_filsys fs, struct ext2_inode *inode,
 				continue;
 		}
 #ifdef PUNCH_DEBUG
-		printf("Freeing block %u (offset %d)\n", b, offset);
+		printf("Freeing block %u (offset %llu)\n", b, offset);
 #endif
 		ext2fs_block_alloc_stats(fs, b, -1);
 		*p = 0;
@@ -108,7 +109,7 @@ static errcode_t ext2fs_punch_ind(ext2_filsys fs, struct ext2_inode *inode,
 	int			num = EXT2_NDIR_BLOCKS;
 	blk_t			*bp = inode->i_block;
 	blk_t			addr_per_block;
-	blk_t			max = EXT2_NDIR_BLOCKS;
+	blk64_t			max = EXT2_NDIR_BLOCKS;
 
 	if (!block_buf) {
 		retval = ext2fs_get_array(3, fs->blocksize, &buf);
@@ -119,10 +120,10 @@ static errcode_t ext2fs_punch_ind(ext2_filsys fs, struct ext2_inode *inode,
 
 	addr_per_block = (blk_t) fs->blocksize >> 2;
 
-	for (level=0; level < 4; level++, max *= addr_per_block) {
+	for (level = 0; level < 4; level++, max *= (blk64_t)addr_per_block) {
 #ifdef PUNCH_DEBUG
 		printf("Main loop level %d, start %u count %u "
-		       "max %d num %d\n", level, start, count, max, num);
+		       "max %llu num %d\n", level, start, count, max, num);
 #endif
 		if (start < max) {
 			retval = ind_punch(fs, inode, block_buf, bp, level,

