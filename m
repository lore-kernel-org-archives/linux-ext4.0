From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] misc: replace comparison macros with inline functions
Date: Sat,  5 Mar 2016 17:30:16 -0700
Message-ID: <1457224216-71316-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-so.shaw.ca ([64.59.136.137]:44075 "EHLO
	smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbcCFAaG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Mar 2016 19:30:06 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Replace the EXT2FS_RB_EMPTY_ROOT(), EXT2FS_RB_EMPTY_NODE(),
EXT2FS_RB_CLEAR_NODE(), IS_BLOCK_BM(), IS_INODE_BM(), and
IS_INODE_TB() macros with static inline functions to avoid
suprious compiler warnings with clang:

	pass1.c:618:28: warning: equality comparison with extraneous
		parentheses [-Wparentheses-equality]
	if ((*((__u32 *)(entry)) == 0UL)) {
             ~~~~~~~~~~~~~~~~~~~~^~~~~~
	pass1.c:618:28: note: remove extraneous parentheses
		around the comparison to silence this warning
	if ((*((__u32 *)(entry)) == 0UL)) {
				 ^~
	pass1.c:618:28: note: use '=' to turn this equality
		comparison into an assignment
	if ((*((__u32 *)(entry)) == 0UL)) {
				 ^~
				 =

The static inline functions should compile identically, and allow
some extra compile-time checking for the arguments over macros.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 lib/ext2fs/blkmap64_rb.c | 10 +++++-----
 lib/ext2fs/rbtree.h      | 17 ++++++++++++++---
 resize/resize2fs.c       | 38 ++++++++++++++++++++++++--------------
 3 files changed, 43 insertions(+), 22 deletions(-)

diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index fdbd330..07d6b48 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -490,7 +490,7 @@ static int rb_remove_extent(__u64 start, __u64 count,
 	__u64 new_start, new_count;
 	int retval = 0;
 
-	if (EXT2FS_RB_EMPTY_ROOT(root))
+	if (ext2fs_rb_empty_root(root))
 		return 0;
 
 	while (*n) {
@@ -639,7 +639,7 @@ static int rb_test_clear_bmap_extent(ext2fs_generic_bitmap bitmap,
 	n = &bp->root.rb_node;
 	start -= bitmap->start;
 
-	if ((len == 0) || EXT2FS_RB_EMPTY_ROOT(&bp->root))
+	if (len == 0 || ext2fs_rb_empty_root(&bp->root))
 		return 1;
 
 	/*
@@ -742,7 +742,7 @@ static errcode_t rb_get_bmap_range(ext2fs_generic_bitmap bitmap,
 	n = &bp->root.rb_node;
 	start -= bitmap->start;
 
-	if (EXT2FS_RB_EMPTY_ROOT(&bp->root))
+	if (ext2fs_rb_empty_root(&bp->root))
 		return 0;
 
 	while (*n) {
@@ -822,7 +822,7 @@ static errcode_t rb_find_first_zero(ext2fs_generic_bitmap bitmap,
 	if (start > end)
 		return EINVAL;
 
-	if (EXT2FS_RB_EMPTY_ROOT(&bp->root))
+	if (ext2fs_rb_empty_root(&bp->root))
 		return ENOENT;
 
 	while (*n) {
@@ -859,7 +859,7 @@ static errcode_t rb_find_first_set(ext2fs_generic_bitmap bitmap,
 	if (start > end)
 		return EINVAL;
 
-	if (EXT2FS_RB_EMPTY_ROOT(&bp->root))
+	if (ext2fs_rb_empty_root(&bp->root))
 		return ENOENT;
 
 	while (*n) {
diff --git a/lib/ext2fs/rbtree.h b/lib/ext2fs/rbtree.h
index 3b0b078..6aaa941 100644
--- a/lib/ext2fs/rbtree.h
+++ b/lib/ext2fs/rbtree.h
@@ -142,9 +142,20 @@ static inline void ext2fs_rb_set_color(struct rb_node *rb, int color)
 #define RB_ROOT	(struct rb_root) { NULL, }
 #define	ext2fs_rb_entry(ptr, type, member) container_of(ptr, type, member)
 
-#define EXT2FS_RB_EMPTY_ROOT(root)	((root)->rb_node == NULL)
-#define EXT2FS_RB_EMPTY_NODE(node)	(ext2fs_rb_parent(node) == node)
-#define EXT2FS_RB_CLEAR_NODE(node)	(ext2fs_rb_set_parent(node, node))
+static inline int ext2fs_rb_empty_root(struct rb_root *root)
+{
+	return root->rb_node == NULL;
+}
+
+static inline int ext2fs_rb_empty_node(struct rb_node *node)
+{
+	return ext2fs_rb_parent(node) == node;
+}
+
+static inline void ext2fs_rb_clear_node(struct rb_node *node)
+{
+	ext2fs_rb_set_parent(node, node);
+}
 
 extern void ext2fs_rb_insert_color(struct rb_node *, struct rb_root *);
 extern void ext2fs_rb_erase(struct rb_node *, struct rb_root *);
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index a2806b1..dc22b9d 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -58,14 +58,24 @@ static errcode_t reserve_sparse_super2_last_group(ext2_resize_t rfs,
 						 ext2fs_block_bitmap meta_bmap);
 
 /*
- * Some helper CPP macros
+ * Some helper functions to check if a block is in a metadata area
  */
-#define IS_BLOCK_BM(fs, i, blk) ((blk) == ext2fs_block_bitmap_loc((fs),(i)))
-#define IS_INODE_BM(fs, i, blk) ((blk) == ext2fs_inode_bitmap_loc((fs),(i)))
+static inline int is_block_bm(ext2_filsys fs, unsigned int grp, blk64_t blk)
+{
+	return blk == ext2fs_block_bitmap_loc(fs, grp);
+}
 
-#define IS_INODE_TB(fs, i, blk) (((blk) >= ext2fs_inode_table_loc((fs), (i))) && \
-				 ((blk) < (ext2fs_inode_table_loc((fs), (i)) + \
-					   (fs)->inode_blocks_per_group)))
+static inline int is_inode_bm(ext2_filsys fs, unsigned int grp, blk64_t blk)
+{
+	return blk == ext2fs_inode_bitmap_loc(fs, grp);
+}
+
+static inline int is_inode_tb(ext2_filsys fs, unsigned int grp, blk64_t blk)
+{
+	return blk >= ext2fs_inode_table_loc(fs, grp) &&
+	       blk < (ext2fs_inode_table_loc(fs, grp) +
+		      fs->inode_blocks_per_group);
+}
 
 /* Some bigalloc helper macros which are more succint... */
 #define B2C(x)	EXT2FS_B2C(fs, (x))
@@ -843,7 +853,7 @@ static void mark_fs_metablock(ext2_resize_t rfs,
 			      ext2fs_block_bitmap meta_bmap,
 			      int group, blk64_t blk)
 {
-	ext2_filsys 	fs = rfs->new_fs;
+	ext2_filsys fs = rfs->new_fs;
 
 	ext2fs_mark_block_bitmap2(rfs->reserve_blocks, blk);
 	ext2fs_block_alloc_stats2(fs, blk, +1);
@@ -853,17 +863,17 @@ static void mark_fs_metablock(ext2_resize_t rfs,
 	 * or the inode tables.  If not, and the block is in use, then
 	 * mark it as a block to be moved.
 	 */
-	if (IS_BLOCK_BM(fs, group, blk)) {
+	if (is_block_bm(fs, group, blk)) {
 		ext2fs_block_bitmap_loc_set(fs, group, 0);
 		rfs->needed_blocks++;
 		return;
 	}
-	if (IS_INODE_BM(fs, group, blk)) {
+	if (is_inode_bm(fs, group, blk)) {
 		ext2fs_inode_bitmap_loc_set(fs, group, 0);
 		rfs->needed_blocks++;
 		return;
 	}
-	if (IS_INODE_TB(fs, group, blk)) {
+	if (is_inode_tb(fs, group, blk)) {
 		ext2fs_inode_table_loc_set(fs, group, 0);
 		rfs->needed_blocks++;
 		return;
@@ -871,18 +881,18 @@ static void mark_fs_metablock(ext2_resize_t rfs,
 	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) {
 		dgrp_t i;
 
-		for (i=0; i < rfs->old_fs->group_desc_count; i++) {
-			if (IS_BLOCK_BM(fs, i, blk)) {
+		for (i = 0; i < rfs->old_fs->group_desc_count; i++) {
+			if (is_block_bm(fs, i, blk)) {
 				ext2fs_block_bitmap_loc_set(fs, i, 0);
 				rfs->needed_blocks++;
 				return;
 			}
-			if (IS_INODE_BM(fs, i, blk)) {
+			if (is_inode_bm(fs, i, blk)) {
 				ext2fs_inode_bitmap_loc_set(fs, i, 0);
 				rfs->needed_blocks++;
 				return;
 			}
-			if (IS_INODE_TB(fs, i, blk)) {
+			if (is_inode_tb(fs, i, blk)) {
 				ext2fs_inode_table_loc_set(fs, i, 0);
 				rfs->needed_blocks++;
 				return;
-- 
1.8.0

