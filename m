From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] resize2fs: correctly account for clusters when calculating summary stats
Date: Sun, 20 Jan 2013 00:35:24 -0500
Message-ID: <1358660125-19027-2-git-send-email-tytso@mit.edu>
References: <20130120052744.GC9874@thunk.org>
 <1358660125-19027-1-git-send-email-tytso@mit.edu>
Cc: jon@severinsson.net, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44383 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab3ATFf1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Jan 2013 00:35:27 -0500
In-Reply-To: <1358660125-19027-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixes resize2fs so it correctly calculates the number of free clusters
in each block group for file systems with the bigalloc feature
enabled.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/resize2fs.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 8fdf35c..6885aeb 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -62,6 +62,15 @@ static errcode_t fix_sb_journal_backup(ext2_filsys fs);
 				 ((blk) < (ext2fs_inode_table_loc((fs), (i)) + \
 					   (fs)->inode_blocks_per_group)))
 
+/* Some bigalloc helper macros which are more succint... */
+#define B2C(x)	EXT2FS_B2C(fs, (x))
+#define C2B(x)	EXT2FS_C2B(fs, (x))
+#define EQ_CLSTR(x, y) (B2C(x) == B2C(y))
+#define LE_CLSTR(x, y) (B2C(x) <= B2C(y))
+#define LT_CLSTR(x, y) (B2C(x) <  B2C(y))
+#define GE_CLSTR(x, y) (B2C(x) >= B2C(y))
+#define GT_CLSTR(x, y) (B2C(x) >  B2C(y))
+
 int lazy_itable_init;
 
 /*
@@ -1822,26 +1831,27 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 	else
 		old_desc_blocks = fs->desc_blocks +
 			fs->super->s_reserved_gdt_blocks;
-	for (blk = fs->super->s_first_data_block;
-	     blk < ext2fs_blocks_count(fs->super); blk++) {
+	for (blk = B2C(fs->super->s_first_data_block);
+	     blk < ext2fs_blocks_count(fs->super);
+	     blk += EXT2FS_CLUSTER_RATIO(fs)) {
 		if ((uninit &&
-		     !((blk == super_blk) ||
+		     !(EQ_CLSTR(blk, super_blk) ||
 		       ((old_desc_blk && old_desc_blocks &&
-			 (blk >= old_desc_blk) &&
-			 (blk < old_desc_blk + old_desc_blocks))) ||
-		       ((new_desc_blk && (blk == new_desc_blk))) ||
-		       (blk == ext2fs_block_bitmap_loc(fs, group)) ||
-		       (blk == ext2fs_inode_bitmap_loc(fs, group)) ||
-		       ((blk >= ext2fs_inode_table_loc(fs, group) &&
-			 (blk < ext2fs_inode_table_loc(fs, group)
-			  + fs->inode_blocks_per_group))))) ||
+			 GE_CLSTR(blk, old_desc_blk) &&
+			 LT_CLSTR(blk, old_desc_blk + old_desc_blocks))) ||
+		       ((new_desc_blk && EQ_CLSTR(blk, new_desc_blk))) ||
+		       EQ_CLSTR(blk, ext2fs_block_bitmap_loc(fs, group)) ||
+		       EQ_CLSTR(blk, ext2fs_inode_bitmap_loc(fs, group)) ||
+		       ((GE_CLSTR(blk, ext2fs_inode_table_loc(fs, group)) &&
+			 LT_CLSTR(blk, ext2fs_inode_table_loc(fs, group)
+				  + fs->inode_blocks_per_group))))) ||
 		    (!ext2fs_fast_test_block_bitmap2(fs->block_map, blk))) {
 			group_free++;
 			total_blocks_free++;
 		}
 		count++;
-		if ((count == fs->super->s_blocks_per_group) ||
-		    (blk == ext2fs_blocks_count(fs->super)-1)) {
+		if ((count == fs->super->s_clusters_per_group) ||
+		    EQ_CLSTR(blk, ext2fs_blocks_count(fs->super)-1)) {
 			ext2fs_bg_free_blocks_count_set(fs, group, group_free);
 			ext2fs_group_desc_csum_set(fs, group);
 			group++;
@@ -1861,6 +1871,7 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 					fs->super->s_reserved_gdt_blocks;
 		}
 	}
+	total_blocks_free = C2B(total_blocks_free);
 	ext2fs_free_blocks_count_set(fs->super, total_blocks_free);
 
 	/*
-- 
1.7.12.rc0.22.gcdd159b

