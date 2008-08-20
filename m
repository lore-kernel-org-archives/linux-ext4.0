From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 07/15][e2fsprogs] Add 64-bit alloc interface.
Date: Wed, 20 Aug 2008 12:33:19 -0500
Message-ID: <20080820173319.23412.7702.stgit@gara>
References: <20080820173210.23412.46020.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50032 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbYHTRci (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Aug 2008 13:32:38 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7KHWP0A006451
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:32:25 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7KHWFRN219232
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:32:15 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7KHWFXF016853
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:32:15 -0400
In-Reply-To: <20080820173210.23412.46020.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add 64-bit alloc interface.

Add new ext2fs_new_block2(), ext2fs_get_free_blocks2() and
ext2fs_alloc_block2() that take and return blk64_t.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/alloc.c  |   70 ++++++++++++++++++++++++++++++++++++++-------------
 lib/ext2fs/ext2fs.h |    8 ++++++
 2 files changed, 60 insertions(+), 18 deletions(-)

diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index f8d8a5f..411e934 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -73,10 +73,10 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
  * Stupid algorithm --- we now just search forward starting from the
  * goal.  Should put in a smarter one someday....
  */
-errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
-			   ext2fs_block_bitmap map, blk_t *ret)
+errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
+			   ext2fs_block_bitmap map, blk64_t *ret)
 {
-	blk_t	i;
+	blk64_t	i;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -88,7 +88,8 @@ errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
 		goal = fs->super->s_first_data_block;
 	i = goal;
 	do {
-		if (!ext2fs_fast_test_block_bitmap(map, i)) {
+		/* FIXME-64 */
+		if (!ext2fs_fast_test_block_bitmap(map, (blk_t) i)) {
 			*ret = i;
 			return 0;
 		}
@@ -99,15 +100,26 @@ errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
 	return EXT2_ET_BLOCK_ALLOC_FAIL;
 }
 
+errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
+			   ext2fs_block_bitmap map, blk_t *ret)
+{
+	errcode_t retval;
+	blk64_t val;
+	retval = ext2fs_new_block2(fs, goal, map, &val);
+	if (!retval)
+		*ret = (blk_t) val;
+	return retval;
+}
+
 /*
  * This function zeros out the allocated block, and updates all of the
  * appropriate filesystem records.
  */
-errcode_t ext2fs_alloc_block(ext2_filsys fs, blk_t goal,
-			     char *block_buf, blk_t *ret)
+errcode_t ext2fs_alloc_block2(ext2_filsys fs, blk64_t goal,
+			     char *block_buf, blk64_t *ret)
 {
 	errcode_t	retval;
-	blk_t		block;
+	blk64_t		block;
 	char		*buf = 0;
 
 	if (!block_buf) {
@@ -119,29 +131,27 @@ errcode_t ext2fs_alloc_block(ext2_filsys fs, blk_t goal,
 	memset(block_buf, 0, fs->blocksize);
 
 	if (fs->get_alloc_block) {
-		blk64_t	new;
-
-		retval = (fs->get_alloc_block)(fs, (blk64_t) goal, &new);
+		retval = (fs->get_alloc_block)(fs, goal, &block);
 		if (retval)
 			goto fail;
-		block = (blk_t) new;
 	} else {
 		if (!fs->block_map) {
+			/* FIXME-64 */
 			retval = ext2fs_read_block_bitmap(fs);
 			if (retval)
 				goto fail;
 		}
 
-		retval = ext2fs_new_block(fs, goal, 0, &block);
+		retval = ext2fs_new_block2(fs, goal, 0, &block);
 		if (retval)
 			goto fail;
 	}
 
-	retval = io_channel_write_blk(fs->io, block, 1, block_buf);
+	retval = io_channel_write_blk64(fs->io, block, 1, block_buf);
 	if (retval)
 		goto fail;
 	
-	ext2fs_block_alloc_stats(fs, block, +1);
+	ext2fs_block_alloc_stats2(fs, block, +1);
 	*ret = block;
 
 fail:
@@ -150,10 +160,21 @@ fail:
 	return retval;
 }
 
-errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start, blk_t finish,
-				 int num, ext2fs_block_bitmap map, blk_t *ret)
+errcode_t ext2fs_alloc_block(ext2_filsys fs, blk_t goal,
+			     char *block_buf, blk_t *ret)
+{
+	errcode_t retval;
+	blk64_t	val;
+	retval = ext2fs_alloc_block2(fs, goal, block_buf, &val);
+	if (!retval)
+		*ret = (blk_t) val;
+	return retval;
+}
+
+errcode_t ext2fs_get_free_blocks2(ext2_filsys fs, blk64_t start, blk64_t finish,
+				 int num, ext2fs_block_bitmap map, blk64_t *ret)
 {
-	blk_t	b = start;
+	blk64_t	b = start;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -170,7 +191,9 @@ errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start, blk_t finish,
 	do {
 		if (b+num-1 > fs->super->s_blocks_count)
 			b = fs->super->s_first_data_block;
-		if (ext2fs_fast_test_block_bitmap_range(map, b, num)) {
+		/* FIXME-64 */
+		if (ext2fs_fast_test_block_bitmap_range(map, (blk_t) b,
+							(blk_t) num)) {
 			*ret = b;
 			return 0;
 		}
@@ -179,6 +202,17 @@ errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start, blk_t finish,
 	return EXT2_ET_BLOCK_ALLOC_FAIL;
 }
 
+errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start, blk_t finish,
+				 int num, ext2fs_block_bitmap map, blk_t *ret)
+{
+	errcode_t retval;
+	blk64_t val;
+	retval = ext2fs_get_free_blocks2(fs, start, finish, num, map, &val);
+	if(!retval)
+		*ret = (blk_t) val;
+	return retval;
+}
+
 void ext2fs_set_alloc_block_callback(ext2_filsys fs, 
 				     errcode_t (*func)(ext2_filsys fs,
 						       blk64_t goal,
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 434ff02..bdb04e0 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -555,12 +555,20 @@ extern errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir, int mode,
 				  ext2fs_inode_bitmap map, ext2_ino_t *ret);
 extern errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
 				  ext2fs_block_bitmap map, blk_t *ret);
+extern errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
+				   ext2fs_block_bitmap map, blk64_t *ret);
 extern errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start,
 					blk_t finish, int num,
 					ext2fs_block_bitmap map,
 					blk_t *ret);
+extern errcode_t ext2fs_get_free_blocks2(ext2_filsys fs, blk64_t start,
+					 blk64_t finish, int num,
+					 ext2fs_block_bitmap map,
+					 blk64_t *ret);
 extern errcode_t ext2fs_alloc_block(ext2_filsys fs, blk_t goal,
 				    char *block_buf, blk_t *ret);
+extern errcode_t ext2fs_alloc_block2(ext2_filsys fs, blk64_t goal,
+				     char *block_buf, blk64_t *ret);
 extern void ext2fs_set_alloc_block_callback(ext2_filsys fs, 
 					    errcode_t (*func)(ext2_filsys fs,
 							      blk64_t goal,

