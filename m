From: Gui Xiaohua <guixh@cn.fujitsu.com>
Subject: [PATCH: e2fsprogs: resize2fs failed when "mkfs.ext4 -O flex_bg"]
Date: Tue, 10 Feb 2009 08:33:46 +0800
Message-ID: <4990CB6A.1020403@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59967 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZBJAgM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Feb 2009 19:36:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When mkfs.ext4 with flex_bg option, resize2fs with -M option will fail.

Steps to reproduce:

# mkfs.ext4 -O flex_bg /dev/sda6
# resize2fs /dev/sda6 -M

resize2fs: No space left on device while trying to resize /dev/sda6

I found that the group which hand been moved out its meta-data still 
in the orignally block after resize2fs,but its meta-data was invalidation.
I try to fix it and the patch likes below.

Signed-off-by: Gui Xiaohua <guixh@cn.fujitsu.com>
--- e2fsprogs-1.41.3/resize/resize2fs.c	2008-10-07 22:22:39.000000000 +0800
+++ e2fsprogs-1.41.3_org/resize/resize2fs.c	2009-02-03 01:56:24.000000000 +0800
@@ -49,6 +49,10 @@ static errcode_t inode_ref_fix(ext2_resi
 static errcode_t move_itables(ext2_resize_t rfs);
 static errcode_t fix_resize_inode(ext2_filsys fs);
 static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs);
+static int calculate_extent(ext2_filsys fs);
+static blk_t  count_map(ext2fs_block_bitmap bitmap, blk_t begin, blk_t end);
+static void adjust_flex_group(ext2_filsys old_fs, ext2_filsys new_fs);
+
 
 /*
  * Some helper CPP macros
@@ -112,6 +116,12 @@ errcode_t resize_fs(ext2_filsys fs, blk_
 
 	*new_size = rfs->new_fs->super->s_blocks_count;
 
+		/*umark meta-data of would be removed groups*/
+	 if (fs->group_desc_count > rfs->new_fs->group_desc_count &&
+		fs->super->s_log_groups_per_flex) {
+		adjust_flex_group(rfs->old_fs, rfs->new_fs);
+	 }
+
 	retval = blocks_to_move(rfs);
 	if (retval)
 		goto errout;
@@ -1792,7 +1802,7 @@ blk_t calculate_minimum_resize_size(ext2
 {
 	blk_t inode_count, blks_needed, groups, data_blocks;
 	blk_t grp, data_needed, last_start;
-	int overhead = 0, num_of_superblocks = 0;
+	int overhead = 0, num_of_superblocks = 0, extent = 0, i = 0;
 
 	/*
 	 * first figure out how many group descriptors we need to
@@ -1918,5 +1928,110 @@ blk_t calculate_minimum_resize_size(ext2
 	blks_needed = (groups-1) * EXT2_BLOCKS_PER_GROUP(fs->super);
 	blks_needed += overhead;
 
+	/*figure out how many fragment will be produced*/
+	if (fs->group_desc_count > groups && fs->super->s_log_groups_per_flex) {
+		extent = calculate_extent(fs);
+		i = (sizeof(__u32) * EXT2_N_BLOCKS -
+		sizeof(struct ext3_extent_header))/sizeof(struct ext3_extent);
+		if (extent >= i)
+			blks_needed += 1;
+	}
+
 	return blks_needed;
 }
+
+static int calculate_extent(ext2_filsys fs)
+{
+	blk_t start_blk, end_blk, range;
+	dgrp_t group_count;
+	blk_t map = 0;
+	int extent = 0;
+
+	int flex_size = 1 << fs->super->s_log_groups_per_flex;
+	group_count = fs->group_desc_count;
+
+	ext2fs_read_bitmaps(fs);
+	fix_uninit_block_bitmaps(fs);
+
+	/*block_map*/
+	start_blk = fs->group_desc[group_count-1].bg_block_bitmap;
+	end_blk = fs->group_desc[0].bg_block_bitmap + flex_size;
+	range = end_blk - start_blk;
+	map = count_map(fs->block_map, start_blk, end_blk);
+	if (map == range || map == 1)
+		extent += 1;
+	else
+		extent += 2;
+
+	/*inode_map*/
+	start_blk = fs->group_desc[group_count-1].bg_inode_bitmap;
+	end_blk = fs->group_desc[0].bg_inode_bitmap + flex_size;
+	range = end_blk - start_blk;
+	map = count_map(fs->block_map, start_blk, end_blk);
+	if (map == range || map == 1)
+		extent += 1;
+	else
+		extent += 2;
+
+	/*inode_table*/
+	start_blk = fs->group_desc[group_count-1].bg_inode_table +
+			fs->inode_blocks_per_group;
+	end_blk = start_blk + 1;
+	map = count_map(fs->block_map, start_blk, end_blk);
+	if (map)
+		extent += 1;
+
+	return extent;
+}
+
+static blk_t count_map(ext2fs_block_bitmap bitmap, blk_t begin, blk_t end)
+{
+	blk_t map = 0;
+	blk_t i = 0;
+
+	for (i = begin; i < end; i++) {
+		if (ext2fs_test_block_bitmap(bitmap, i))
+			map++;
+	}
+	return map;
+}
+
+static void adjust_flex_group(ext2_filsys old_fs, ext2_filsys new_fs)
+{
+	blk_t			b;
+	unsigned int		j;
+	unsigned int		start, end;
+	dgrp_t			i = new_fs->group_desc_count;
+	ext2fs_block_bitmap new_bitmap = new_fs->block_map;
+	ext2fs_block_bitmap old_bitmap = old_fs->block_map;
+
+	start = ext2fs_get_block_bitmap_start(new_bitmap);
+	end = ext2fs_get_block_bitmap_end(new_bitmap);
+
+	for (; i < old_fs->group_desc_count; i++) {
+		for (j = 0, b = old_fs->group_desc[i].bg_inode_table;
+		     j < (unsigned int) old_fs->inode_blocks_per_group;
+		     j++, b++) {
+			ext2fs_unmark_block_bitmap(old_bitmap, b);
+
+			if (start <= b && end >= b)
+				ext2fs_unmark_block_bitmap(new_bitmap, b);
+		}
+
+		ext2fs_unmark_block_bitmap(old_bitmap,
+				old_fs->group_desc[i].bg_block_bitmap);
+		ext2fs_unmark_block_bitmap(old_bitmap,
+				old_fs->group_desc[i].bg_inode_bitmap);
+		if ((start <= old_fs->group_desc[i].bg_inode_bitmap) &&
+			(end >= old_fs->group_desc[i].bg_inode_bitmap)) {
+			ext2fs_unmark_block_bitmap(new_bitmap,
+					 old_fs->group_desc[i].bg_inode_bitmap);
+		}
+		if ((start <= old_fs->group_desc[i].bg_block_bitmap) &&
+			(end >= old_fs->group_desc[i].bg_block_bitmap)) {
+			ext2fs_unmark_block_bitmap(new_bitmap,
+					 old_fs->group_desc[i].bg_block_bitmap);
+		}
+	}
+}
+



