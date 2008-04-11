From: Josef Bacik <jbacik@redhat.com>
Subject: [RFC][PATCH 2/2] convert alloc.c to use blk64_t
Date: Fri, 11 Apr 2008 11:36:16 -0400
Message-ID: <20080411153616.GB32661@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760012AbYDKPoc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2008 11:44:32 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,


commit 0b80dee54f94f13210ae87a504e3b49d3dc284d4
Author: Josef Bacik <jbacik@redhat.com>
Date:   Fri Apr 11 18:23:13 2008 -0400

    Convert the block alloc functions to be 64bit capable.
    
    Signed-off-by: Josef Bacik <jbacik@redhat.com>

diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 65f3ea1..6924457 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -73,10 +73,10 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
  * Stupid algorithm --- we now just search forward starting from the
  * goal.  Should put in a smarter one someday....
  */
-errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
-			   ext2fs_block_bitmap map, blk_t *ret)
+errcode_t ext2fs_new_block64(ext2_filsys fs, blk64_t goal,
+			     ext2fs_block_bitmap map, blk64_t *ret)
 {
-	blk_t	i;
+	blk64_t	i;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -84,7 +84,7 @@ errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
 		map = fs->block_map;
 	if (!map)
 		return EXT2_ET_NO_BLOCK_BITMAP;
-	if (!goal || (goal >= fs->super->s_blocks_count))
+	if (!goal || (goal >= ext2fs_super_blocks_count(fs)))
 		goal = fs->super->s_first_data_block;
 	i = goal;
 	do {
@@ -93,7 +93,7 @@ errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
 			return 0;
 		}
 		i++;
-		if (i >= fs->super->s_blocks_count)
+		if (i >= ext2fs_super_blocks_count(fs))
 			i = fs->super->s_first_data_block;
 	} while (i != goal);
 	return EXT2_ET_BLOCK_ALLOC_FAIL;
@@ -103,11 +103,11 @@ errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
  * This function zeros out the allocated block, and updates all of the
  * appropriate filesystem records.
  */
-errcode_t ext2fs_alloc_block(ext2_filsys fs, blk_t goal,
-			     char *block_buf, blk_t *ret)
+errcode_t ext2fs_alloc_block64(ext2_filsys fs, blk64_t goal,
+			     char *block_buf, blk64_t *ret)
 {
 	errcode_t	retval;
-	blk_t		block;
+	blk64_t		block;
 	char		*buf = 0;
 
 	if (!block_buf) {
@@ -124,11 +124,11 @@ errcode_t ext2fs_alloc_block(ext2_filsys fs, blk_t goal,
 			goto fail;
 	}
 
-	retval = ext2fs_new_block(fs, goal, 0, &block);
+	retval = ext2fs_new_block64(fs, goal, 0, &block);
 	if (retval)
 		goto fail;
 
-	retval = io_channel_write_blk(fs->io, block, 1, block_buf);
+	retval = io_channel_write_blk64(fs->io, block, 1, block_buf);
 	if (retval)
 		goto fail;
 	
@@ -141,10 +141,11 @@ fail:
 	return retval;
 }
 
-errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start, blk_t finish,
-				 int num, ext2fs_block_bitmap map, blk_t *ret)
+errcode_t ext2fs_get_free_blocks64(ext2_filsys fs, blk64_t start,
+				   blk64_t finish, int num,
+				   ext2fs_block_bitmap map, blk64_t *ret)
 {
-	blk_t	b = start;
+	blk64_t	b = start;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -159,7 +160,7 @@ errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start, blk_t finish,
 	if (!num)
 		num = 1;
 	do {
-		if (b+num-1 > fs->super->s_blocks_count)
+		if (b+num-1 > ext2fs_super_blocks_count(fs))
 			b = fs->super->s_first_data_block;
 		if (ext2fs_fast_test_block_bitmap_range(map, b, num)) {
 			*ret = b;
@@ -170,3 +171,42 @@ errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start, blk_t finish,
 	return EXT2_ET_BLOCK_ALLOC_FAIL;
 }
 
+errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start, blk_t finish,
+				 int num, ext2fs_block_bitmap map, blk_t *ret)
+{
+	blk64_t ret64 = 0;
+	errcode_t err;
+
+	err = ext2fs_get_free_blocks64(fs, start, finish, num, map, &ret64);
+
+	*ret = (blk_t)ret64;
+
+	return err;
+}
+
+errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
+			   ext2fs_block_bitmap map, blk_t *ret)
+{
+	blk64_t ret64 = 0;
+	errcode_t err;
+
+	err = ext2fs_new_block64(fs, goal, map, &ret64);
+
+	*ret = (blk_t)ret64;
+
+	return err;
+}
+
+errcode_t ext2fs_alloc_block(ext2_filsys fs, blk_t goal,
+			     char *block_buf, blk_t *ret)
+{
+	blk64_t ret64 = 0;
+	errcode_t err;
+
+	err = ext2fs_alloc_block64(fs, goal, block_buf, &ret64);
+
+	*ret = (blk_t)ret64;
+
+	return err;
+}
+
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index a60e28b..058dea7 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1385,6 +1385,17 @@ _INLINE_ blk64_t ext2fs_inode_data_blocks64(ext2_filsys fs,
 	return ret;
 }
 
+/*
+ * Return the s_blocks_count in 64 bit
+ */
+_INLINE_ blk64_t ext2fs_super_blocks_count(ext2_filsys fs)
+{
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		return (((blk64_t)fs->super->s_blocks_count << 32) |
+			fs->super->s_blocks_count);
+	return fs->super->s_blocks_count;
+}
+
 #undef _INLINE_
 #endif
 
