From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: add ext2fs_group_blocks_count helper
Date: Wed, 20 Jul 2011 16:46:56 -0500
Message-ID: <4E274CD0.1000801@redhat.com>
References: <1311090411-13766-1-git-send-email-xiaoqiangnk@gmail.com> <4E25AE6A.6090909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab1GTVq7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jul 2011 17:46:59 -0400
In-Reply-To: <4E25AE6A.6090909@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Code to count the number of blocks in the last partial
group is cut and pasted around the e2fsprogs codebase, and
is wrong in at least one instancem as pointed out by
Yongqiang Yang (but not fixed in this patch).

Making this a helper function should improve matters.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(I have not fixed up the spot Yongqiang Yang discovered,
but this helper should now make that fix easy to do.)

 e2fsck/pass5.c        |    6 +-----
 lib/ext2fs/alloc_sb.c |   10 +---------
 lib/ext2fs/blknum.c   |   19 +++++++++++++++++++
 lib/ext2fs/closefs.c  |    9 +--------
 lib/ext2fs/ext2fs.h   |    1 +
 resize/online.c       |    7 +------
 resize/resize2fs.c    |   14 ++------------
 7 files changed, 26 insertions(+), 40 deletions(-)


diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index b423d28..73db4e8 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -218,11 +218,7 @@ redo_counts:
 					fs->super->s_reserved_gdt_blocks;
 
 				count = 0;
-				cmp_block = fs->super->s_blocks_per_group;
-				if (group == (int)fs->group_desc_count - 1)
-					cmp_block =
-						ext2fs_blocks_count(fs->super) %
-						fs->super->s_blocks_per_group;
+				cmp_block = ext2fs_group_blocks_count(fs, group);
 			}
 
 			bitmap = 0;
diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c
index d5fca3b..98aec52 100644
--- a/lib/ext2fs/alloc_sb.c
+++ b/lib/ext2fs/alloc_sb.c
@@ -71,15 +71,7 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 	if (new_desc_blk)
 		ext2fs_mark_block_bitmap2(bmap, new_desc_blk);
 
-	if (group == fs->group_desc_count-1) {
-		num_blocks = (ext2fs_blocks_count(fs->super) -
-			     fs->super->s_first_data_block) %
-			fs->super->s_blocks_per_group;
-		if (!num_blocks)
-			num_blocks = fs->super->s_blocks_per_group;
-	} else
-		num_blocks = fs->super->s_blocks_per_group;
-
+	num_blocks = ext2fs_group_blocks_count(fs, group);
 	num_blocks -= 2 + fs->inode_blocks_per_group + used_blks;
 
 	return num_blocks  ;
diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index b3e6dca..f1bbe9b 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -43,6 +43,25 @@ blk64_t ext2fs_group_last_block2(ext2_filsys fs, dgrp_t group)
 }
 
 /*
+ * Return the number of blocks in a group
+ */
+int ext2fs_group_blocks_count(ext2_filsys fs, dgrp_t group)
+{
+	int num_blocks;
+
+	if (group == fs->group_desc_count-1) {
+		num_blocks = (ext2fs_blocks_count(fs->super) -
+				fs->super->s_first_data_block) %
+			      fs->super->s_blocks_per_group;
+		if (!num_blocks)
+			num_blocks = fs->super->s_blocks_per_group;
+	} else
+		num_blocks = fs->super->s_blocks_per_group;
+
+	return num_blocks;
+}
+
+/*
  * Return the inode data block count
  */
 blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 7a23e46..b13a0c9 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -150,14 +150,7 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 					&ret_new_desc_blk2,
 					&ret_used_blks);
 
-	if (group == fs->group_desc_count-1) {
-		numblocks = (ext2fs_blocks_count(fs->super) -
-			     (blk64_t) fs->super->s_first_data_block) %
-			(blk64_t) fs->super->s_blocks_per_group;
-		if (!numblocks)
-			numblocks = fs->super->s_blocks_per_group;
-	} else
-		numblocks = fs->super->s_blocks_per_group;
+	numblocks = ext2fs_group_blocks_count(fs, group);
 
 	if (ret_super_blk)
 		*ret_super_blk = (blk_t)ret_super_blk2;
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d3eb31d..5983adc 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -731,6 +731,7 @@ extern errcode_t ext2fs_get_block_bitmap_range2(ext2fs_block_bitmap bmap,
 extern dgrp_t ext2fs_group_of_blk2(ext2_filsys fs, blk64_t);
 extern blk64_t ext2fs_group_first_block2(ext2_filsys fs, dgrp_t group);
 extern blk64_t ext2fs_group_last_block2(ext2_filsys fs, dgrp_t group);
+extern int ext2fs_group_blocks_count(ext2_filsys fs, dgrp_t group);
 extern blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
 					 struct ext2_inode *inode);
 extern blk64_t ext2fs_inode_i_blocks(ext2_filsys fs,
diff --git a/resize/online.c b/resize/online.c
index 1d8d4ec..c2b98c6 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -135,12 +135,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 		input.block_bitmap = ext2fs_block_bitmap_loc(new_fs, i);
 		input.inode_bitmap = ext2fs_inode_bitmap_loc(new_fs, i);
 		input.inode_table = ext2fs_inode_table_loc(new_fs, i);
-		input.blocks_count = sb->s_blocks_per_group;
-		if (i == new_fs->group_desc_count-1) {
-			input.blocks_count = ext2fs_blocks_count(new_fs->super) -
-				sb->s_first_data_block -
-				(i * sb->s_blocks_per_group);
-		}
+		input.blocks_count = ext2fs_group_blocks_count(new_fs, i);
 		input.reserved_blocks = (blk_t) (percent * input.blocks_count
 						 / 100.0);
 
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 216a626..4b83ca9 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -499,18 +499,8 @@ retry:
 		ext2fs_bg_flags_zap(fs, i);
 		if (csum_flag)
 			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_UNINIT | EXT2_BG_INODE_ZEROED);
-		if (i == fs->group_desc_count-1) {
-			numblocks = (ext2fs_blocks_count(fs->super) -
-				     fs->super->s_first_data_block) %
-					     fs->super->s_blocks_per_group;
-			if (!numblocks)
-				numblocks = fs->super->s_blocks_per_group;
-		} else {
-			numblocks = fs->super->s_blocks_per_group;
-			if (csum_flag)
-				ext2fs_bg_flags_set(fs, i,
-						    EXT2_BG_BLOCK_UNINIT);
-		}
+
+		numblocks = ext2fs_group_blocks_count(fs, i);
 
 		has_super = ext2fs_bg_has_super(fs, i);
 		if (has_super) {

