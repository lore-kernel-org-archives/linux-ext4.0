From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [RFC PATCH 5/9][e2fsprogs] Add 64-bit alloc interface.
Date: Fri, 09 May 2008 11:39:58 -0500
Message-ID: <20080509163958.15484.88576.stgit@gara>
References: <20080509163928.15484.22146.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:34179 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758894AbYEIQja (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 May 2008 12:39:30 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m49GdTHG031162
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 12:39:29 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m49GdTnH023830
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 10:39:29 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m49GdTUi025965
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 10:39:29 -0600
In-Reply-To: <20080509163928.15484.22146.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add 64-bit alloc interface.

Add new ext2fs_new_block2(), ext2fs_get_free_blocks2() and
ext2fs_alloc_block2() that take and return blk64_t.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/alloc.c  |   59 +++++++++++++++++++++++++++++++++++++++++----------
 lib/ext2fs/ext2fs.h |    8 +++++++
 2 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 65f3ea1..3dda7f4 100644
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
 
@@ -88,6 +88,7 @@ errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
 		goal = fs->super->s_first_data_block;
 	i = goal;
 	do {
+		/* FIXME: Not blk64_t clean */
 		if (!ext2fs_fast_test_block_bitmap(map, i)) {
 			*ret = i;
 			return 0;
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
@@ -119,20 +131,21 @@ errcode_t ext2fs_alloc_block(ext2_filsys fs, blk_t goal,
 	memset(block_buf, 0, fs->blocksize);
 
 	if (!fs->block_map) {
+		/* FIXME: Not blk64_t clean */
 		retval = ext2fs_read_block_bitmap(fs);
 		if (retval)
 			goto fail;
 	}
 
-	retval = ext2fs_new_block(fs, goal, 0, &block);
+	retval = ext2fs_new_block2(fs, goal, 0, &block);
 	if (retval)
 		goto fail;
 
-	retval = io_channel_write_blk(fs->io, block, 1, block_buf);
+	retval = io_channel_write_blk64(fs->io, block, 1, block_buf);
 	if (retval)
 		goto fail;
 	
-	ext2fs_block_alloc_stats(fs, block, +1);
+	ext2fs_block_alloc_stats2(fs, block, 1);
 	*ret = block;
 
 fail:
@@ -141,10 +154,21 @@ fail:
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
 
@@ -161,6 +185,7 @@ errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start, blk_t finish,
 	do {
 		if (b+num-1 > fs->super->s_blocks_count)
 			b = fs->super->s_first_data_block;
+		/* FIXME: Not blk64_t clean */
 		if (ext2fs_fast_test_block_bitmap_range(map, b, num)) {
 			*ret = b;
 			return 0;
@@ -170,3 +195,13 @@ errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start, blk_t finish,
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
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 8107d94..80ccfd9 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -537,12 +537,20 @@ extern errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir, int mode,
 				  ext2fs_inode_bitmap map, ext2_ino_t *ret);
 extern errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
 				  ext2fs_block_bitmap map, blk_t *ret);
+extern errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
+				  ext2fs_block_bitmap map, blk64_t *ret);
 extern errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start,
 					blk_t finish, int num,
 					ext2fs_block_bitmap map,
 					blk_t *ret);
+extern errcode_t ext2fs_get_free_blocks2(ext2_filsys fs, blk64_t start,
+					blk64_t finish, int num,
+					ext2fs_block_bitmap map,
+					blk64_t *ret);
 extern errcode_t ext2fs_alloc_block(ext2_filsys fs, blk_t goal,
 				    char *block_buf, blk_t *ret);
+extern errcode_t ext2fs_alloc_block2(ext2_filsys fs, blk64_t goal,
+				    char *block_buf, blk64_t *ret);
 
 /* alloc_sb.c */
 extern int ext2fs_reserve_super_and_bgd(ext2_filsys fs, 

