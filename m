From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 10/12] mke2fs: optimize fix_cluster_bg_counts()
Date: Mon, 20 Jan 2014 00:54:12 -0500
Message-ID: <1390197254-14583-11-git-send-email-tytso@mit.edu>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49972 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbaATFy3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jan 2014 00:54:29 -0500
In-Reply-To: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Instead of iterating over the allocation bitmap using
ext2fs_test_block_bitmap2(), bit by bit, use
ext2fs_find_first_set_block_bitmap2() instead.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/mke2fs.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index c45b42f..7daa87e 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2332,27 +2332,40 @@ static int mke2fs_discard_device(ext2_filsys fs)
 
 static void fix_cluster_bg_counts(ext2_filsys fs)
 {
-	blk64_t	cluster, num_clusters, tot_free;
-	unsigned num = 0;
-	int	grp_free, num_free, group;
+	blk64_t		cluster, num_clusters, tot_free, last_cluster, next;
+	errcode_t	retval;
+	dgrp_t		group = 0;
+	int		grp_free = 0, num_free = 0;
 
 	num_clusters = EXT2FS_B2C(fs, ext2fs_blocks_count(fs->super));
-	tot_free = num_free = group = grp_free = 0;
-	for (cluster = EXT2FS_B2C(fs, fs->super->s_first_data_block);
-	     cluster < num_clusters; cluster++) {
-		if (!ext2fs_test_block_bitmap2(fs->block_map,
-					       EXT2FS_C2B(fs, cluster))) {
-			grp_free++;
-			tot_free++;
+	last_cluster = EXT2FS_B2C(fs, ext2fs_group_last_block2(fs, group));
+	cluster = EXT2FS_B2C(fs, fs->super->s_first_data_block);
+	while (cluster < num_clusters) {
+		retval = ext2fs_find_first_zero_block_bitmap2(fs->block_map,
+						cluster, last_cluster, &next);
+		if (retval == 0)
+			cluster = next;
+		else {
+			cluster = last_cluster + 1;
+			goto next_bg;
 		}
-		num++;
-		if ((num == fs->super->s_clusters_per_group) ||
-		    (cluster == num_clusters-1)) {
+
+		retval = ext2fs_find_first_set_block_bitmap2(fs->block_map,
+						cluster, last_cluster, &next);
+		if (retval)
+			next = last_cluster + 1;
+		grp_free += next - cluster;
+		tot_free += next - cluster;
+		cluster = next;
+
+		if (cluster > last_cluster) {
+		next_bg:
 			ext2fs_bg_free_blocks_count_set(fs, group, grp_free);
 			ext2fs_group_desc_csum_set(fs, group);
-			num = 0;
 			grp_free = 0;
 			group++;
+			last_cluster = EXT2FS_B2C(fs,
+					ext2fs_group_last_block2(fs, group));
 		}
 	}
 	ext2fs_free_blocks_count_set(fs->super, EXT2FS_C2B(fs, tot_free));
-- 
1.8.5.rc3.362.gdf10213

