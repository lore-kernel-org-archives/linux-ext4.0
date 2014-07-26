From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/6] Fix 32/64-bit overflow when multiplying by blocks/clusters per group
Date: Sat, 26 Jul 2014 09:48:33 -0400
Message-ID: <1406382514-8662-6-git-send-email-tytso@mit.edu>
References: <1406382514-8662-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58040 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbaGZNsi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 09:48:38 -0400
In-Reply-To: <1406382514-8662-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are a number of places where we need convert groups to blocks or
clusters by multiply the groups by blocks/clusters per group.
Unfortunately, both quantities are 32-bit, but the result needs to be
64-bit, and very often the cast to 64-bit gets lost.

Fix this by adding new macros, EXT2_GROUPS_TO_BLOCKS() and
EXT2_GROUPS_TO_CLUSTERS().

This should fix a bug where resizing a 64bit file system can result in
calculate_minimum_resize_size() looping forever.

Addresses-Launchpad-Bug: #1321958

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 e2fsck/pass5.c          |  2 +-
 e2fsck/super.c          |  2 +-
 lib/ext2fs/blknum.c     |  2 +-
 lib/ext2fs/ext2_fs.h    |  5 +++++
 lib/ext2fs/imager.c     | 14 +++++++-------
 lib/ext2fs/rw_bitmaps.c |  4 ++--
 misc/tune2fs.c          |  2 +-
 resize/resize2fs.c      | 11 +++++------
 8 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index d0b1ced..bc9a32a 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -776,7 +776,7 @@ static void check_block_end(e2fsck_t ctx)
 	clear_problem_context(&pctx);
 
 	end = ext2fs_get_block_bitmap_start2(fs->block_map) +
-		((blk64_t)EXT2_CLUSTERS_PER_GROUP(fs->super) * fs->group_desc_count) - 1;
+		EXT2_GROUPS_TO_CLUSTERS(fs->super, fs->group_desc_count) - 1;
 	pctx.errcode = ext2fs_fudge_block_bitmap_end2(fs->block_map, end,
 						     &save_blocks_count);
 	if (pctx.errcode) {
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 81503d4..8d468e6 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -421,7 +421,7 @@ void check_resize_inode(e2fsck_t ctx)
 		for (j = 1; j < fs->group_desc_count; j++) {
 			if (!ext2fs_bg_has_super(fs, j))
 				continue;
-			expect = pblk + (j * fs->super->s_blocks_per_group);
+			expect = pblk + EXT2_GROUPS_TO_BLOCKS(fs->super, j);
 			if (ind_buf[ind_off] != expect)
 				goto resize_inode_invalid;
 			ind_off++;
diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index 8ced1ee..7ce6053 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -29,7 +29,7 @@ dgrp_t ext2fs_group_of_blk2(ext2_filsys fs, blk64_t blk)
 blk64_t ext2fs_group_first_block2(ext2_filsys fs, dgrp_t group)
 {
 	return fs->super->s_first_data_block +
-		((blk64_t)group * fs->super->s_blocks_per_group);
+		EXT2_GROUPS_TO_BLOCKS(fs->super, group);
 }
 
 /*
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index d9e14d7..6c3620c 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -264,6 +264,11 @@ struct ext2_dx_countlimit {
 #define EXT2_DESC_PER_BLOCK(s)		(EXT2_BLOCK_SIZE(s) / EXT2_DESC_SIZE(s))
 #endif
 
+#define EXT2_GROUPS_TO_BLOCKS(s, g)   ((blk64_t) EXT2_BLOCKS_PER_GROUP(s) * \
+				       (g))
+#define EXT2_GROUPS_TO_CLUSTERS(s, g) ((blk64_t) EXT2_CLUSTERS_PER_GROUP(s) * \
+				       (g))
+
 /*
  * Constants relative to the data blocks
  */
diff --git a/lib/ext2fs/imager.c b/lib/ext2fs/imager.c
index 378a3c8..b643cc6 100644
--- a/lib/ext2fs/imager.c
+++ b/lib/ext2fs/imager.c
@@ -286,8 +286,8 @@ errcode_t ext2fs_image_bitmap_write(ext2_filsys fs, int fd, int flags)
 	ext2fs_generic_bitmap	bmap;
 	errcode_t		retval;
 	ssize_t			actual;
-	__u32			itr, cnt, size;
-	int			c, total_size;
+	size_t			c;
+	__u64			itr, cnt, size, total_size;
 	char			buf[1024];
 
 	if (flags & IMAGER_FLAG_INODEMAP) {
@@ -308,7 +308,7 @@ errcode_t ext2fs_image_bitmap_write(ext2_filsys fs, int fd, int flags)
 		}
 		bmap = fs->block_map;
 		itr = fs->super->s_first_data_block;
-		cnt = EXT2_BLOCKS_PER_GROUP(fs->super) * fs->group_desc_count;
+		cnt = EXT2_GROUPS_TO_BLOCKS(fs->super, fs->group_desc_count);
 		size = EXT2_BLOCKS_PER_GROUP(fs->super) / 8;
 	}
 	total_size = size * fs->group_desc_count;
@@ -342,9 +342,9 @@ errcode_t ext2fs_image_bitmap_write(ext2_filsys fs, int fd, int flags)
 			if (c > (int) sizeof(buf))
 				c = sizeof(buf);
 			actual = write(fd, buf, c);
-			if (actual == -1)
+			if (actual < 0)
 				return errno;
-			if (actual != c)
+			if ((size_t) actual != c)
 				return EXT2_ET_SHORT_WRITE;
 			size -= c;
 		}
@@ -360,7 +360,7 @@ errcode_t ext2fs_image_bitmap_read(ext2_filsys fs, int fd, int flags)
 {
 	ext2fs_generic_bitmap	bmap;
 	errcode_t		retval;
-	__u32			itr, cnt;
+	__u64			itr, cnt;
 	char			buf[1024];
 	unsigned int		size;
 	ssize_t			actual;
@@ -383,7 +383,7 @@ errcode_t ext2fs_image_bitmap_read(ext2_filsys fs, int fd, int flags)
 		}
 		bmap = fs->block_map;
 		itr = fs->super->s_first_data_block;
-		cnt = EXT2_BLOCKS_PER_GROUP(fs->super) * fs->group_desc_count;
+		cnt = EXT2_GROUPS_TO_BLOCKS(fs->super, fs->group_desc_count);
 		size = EXT2_BLOCKS_PER_GROUP(fs->super) / 8;
 	}
 
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index d24ba9a..a07ecd5 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -262,8 +262,8 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		}
 		blk = (fs->image_header->offset_blockmap /
 		       fs->blocksize);
-		blk_cnt = (blk64_t)EXT2_CLUSTERS_PER_GROUP(fs->super) *
-			fs->group_desc_count;
+		blk_cnt = EXT2_GROUPS_TO_CLUSTERS(fs->super,
+						  fs->group_desc_count);
 		while (block_nbytes > 0) {
 			retval = io_channel_read_blk64(fs->image_io, blk++,
 						     1, block_bitmap);
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 6b21235..ad0b05f 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1383,7 +1383,7 @@ static int ext2fs_is_block_in_group(ext2_filsys fs, dgrp_t group, blk64_t blk)
 {
 	blk64_t start_blk, end_blk;
 	start_blk = fs->super->s_first_data_block +
-			EXT2_BLOCKS_PER_GROUP(fs->super) * group;
+			EXT2_GROUPS_TO_BLOCKS(fs->super, group);
 	/*
 	 * We cannot get new block beyond end_blk for for the last block group
 	 * so we can check with EXT2_BLOCKS_PER_GROUP even for last block group
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 6bd2e1c..9641b1e 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -436,8 +436,7 @@ retry:
 					    fs->inode_map);
 	if (retval) goto errout;
 
-	real_end = (((blk64_t) EXT2_BLOCKS_PER_GROUP(fs->super) *
-		     fs->group_desc_count)) - 1 +
+	real_end = EXT2_GROUPS_TO_BLOCKS(fs->super, fs->group_desc_count) - 1 +
 		fs->super->s_first_data_block;
 	retval = ext2fs_resize_block_bitmap2(new_size - 1,
 					     real_end, fs->block_map);
@@ -2318,7 +2317,7 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 		fs->super->s_free_inodes_count;
 	blks_needed = ext2fs_div_ceil(inode_count,
 				      fs->super->s_inodes_per_group) *
-		EXT2_BLOCKS_PER_GROUP(fs->super);
+		(blk64_t) EXT2_BLOCKS_PER_GROUP(fs->super);
 	groups = ext2fs_div64_ceil(blks_needed,
 				   EXT2_BLOCKS_PER_GROUP(fs->super));
 #ifdef RESIZE2FS_DEBUG
@@ -2365,7 +2364,7 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 	 * figure out how many data blocks we have given the number of groups
 	 * we need for our inodes
 	 */
-	data_blocks = groups * EXT2_BLOCKS_PER_GROUP(fs->super);
+	data_blocks = EXT2_GROUPS_TO_BLOCKS(fs->super, groups);
 	last_start = 0;
 	for (grp = 0; grp < flex_groups; grp++) {
 		overhead = calc_group_overhead(fs, grp, old_desc_blocks);
@@ -2403,7 +2402,7 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 		extra_grps = ext2fs_div64_ceil(remainder,
 					       EXT2_BLOCKS_PER_GROUP(fs->super));
 
-		data_blocks += extra_grps * EXT2_BLOCKS_PER_GROUP(fs->super);
+		data_blocks += EXT2_GROUPS_TO_BLOCKS(fs->super, extra_grps);
 
 		/* ok we have to account for the last group */
 		overhead = calc_group_overhead(fs, groups-1, old_desc_blocks);
@@ -2501,7 +2500,7 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 	 * blocks needed to handle the group descriptor metadata+data
 	 * that we need
 	 */
-	blks_needed = (groups-1) * EXT2_BLOCKS_PER_GROUP(fs->super);
+	blks_needed = EXT2_GROUPS_TO_BLOCKS(fs->super, groups - 1);
 	blks_needed += overhead;
 
 	/*
-- 
2.0.0

