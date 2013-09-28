From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/2] ext4: Spot-check block group sub-table locations
Date: Fri, 27 Sep 2013 17:14:04 -0700
Message-ID: <20130928001404.25857.43349.stgit@birch.djwong.org>
References: <20130928001349.25857.76724.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, gnehzuil.liu@gmail.com
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38603 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3I1AOK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Sep 2013 20:14:10 -0400
In-Reply-To: <20130928001349.25857.76724.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Perform a quick sanity check of bitmap and inode table block numbers when
loading them, and if there's something suspicious, mark the block group
corrupt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/balloc.c |    7 +++++++
 fs/ext4/ext4.h   |    2 ++
 fs/ext4/ialloc.c |    6 ++++++
 fs/ext4/inode.c  |    9 +++++++++
 fs/ext4/super.c  |   21 +++++++++++++++++++++
 5 files changed, 45 insertions(+)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 6ea7b14..2f35689 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -396,13 +396,20 @@ ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group)
 	struct ext4_group_desc *desc;
 	struct buffer_head *bh;
 	ext4_fsblk_t bitmap_blk;
+	struct ext4_group_info *grp;
 
 	desc = ext4_get_group_desc(sb, block_group, NULL);
 	if (!desc)
 		return NULL;
 	bitmap_blk = ext4_block_bitmap(sb, desc);
+	if (!ext4_is_sane_bgdata_location(sb, block_group, bitmap_blk)) {
+		grp = ext4_get_group_info(sb, block_group);
+		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
+		goto no_bitmap;
+	}
 	bh = sb_getblk(sb, bitmap_blk);
 	if (unlikely(!bh)) {
+no_bitmap:
 		ext4_error(sb, "Cannot get buffer for block bitmap - "
 			   "block_group = %u, block_bitmap = %llu",
 			   block_group, bitmap_blk);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index af815ea..afb1bb2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2531,6 +2531,8 @@ static inline void ext4_unlock_group(struct super_block *sb,
 	spin_unlock(ext4_group_lock_ptr(sb, group));
 }
 
+int ext4_is_sane_bgdata_location(struct super_block *sb, ext4_group_t grp,
+				 ext4_fsblk_t blk);
 /*
  * Block validity checking
  */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 137193f..4e7994b 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -122,8 +122,14 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 		return NULL;
 
 	bitmap_blk = ext4_inode_bitmap(sb, desc);
+	if (!ext4_is_sane_bgdata_location(sb, block_group, bitmap_blk)) {
+		grp = ext4_get_group_info(sb, block_group);
+		set_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, &grp->bb_state);
+		goto no_bitmap;
+	}
 	bh = sb_getblk(sb, bitmap_blk);
 	if (unlikely(!bh)) {
+no_bitmap:
 		ext4_error(sb, "Cannot read inode bitmap - "
 			    "block_group = %u, inode_bitmap = %llu",
 			    block_group, bitmap_blk);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0d424d7..0a54e13 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3795,6 +3795,7 @@ static int __ext4_get_inode_loc(struct inode *inode,
 	struct super_block	*sb = inode->i_sb;
 	ext4_fsblk_t		block;
 	int			inodes_per_block, inode_offset;
+	struct ext4_group_info	*grp;
 
 	iloc->bh = NULL;
 	if (!ext4_valid_inum(sb, inode->i_ino))
@@ -3814,6 +3815,14 @@ static int __ext4_get_inode_loc(struct inode *inode,
 	block = ext4_inode_table(sb, gdp) + (inode_offset / inodes_per_block);
 	iloc->offset = (inode_offset % inodes_per_block) * EXT4_INODE_SIZE(sb);
 
+	if (!ext4_is_sane_bgdata_location(sb, iloc->block_group, block)) {
+		grp = ext4_get_group_info(sb, iloc->block_group);
+		set_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, &grp->bb_state);
+		ext4_error(sb, "Cannot read inode table - "
+			    "block_group = %u, inode_table_block = %llu",
+			    iloc->block_group, block);
+		return -EIO;
+	}
 	bh = sb_getblk(sb, block);
 	if (unlikely(!bh))
 		return -ENOMEM;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2c2e6cb..d22248e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2049,6 +2049,27 @@ void ext4_group_desc_csum_set(struct super_block *sb, __u32 block_group,
 	gdp->bg_checksum = ext4_group_desc_csum(EXT4_SB(sb), block_group, gdp);
 }
 
+/* returns 1 if the location of a blockgroup data item seems sane */
+int ext4_is_sane_bgdata_location(struct super_block *sb, ext4_group_t grp,
+				 ext4_fsblk_t blk)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	ext4_fsblk_t first_block = le32_to_cpu(sbi->s_es->s_first_data_block);
+	ext4_fsblk_t last_block;
+
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
+		last_block = ext4_blocks_count(sbi->s_es) - 1;
+	else {
+		first_block += grp * sbi->s_blocks_per_group;
+		last_block = first_block + (EXT4_BLOCKS_PER_GROUP(sb) - 1);
+	}
+
+	if (last_block >= ext4_blocks_count(sbi->s_es))
+		last_block = ext4_blocks_count(sbi->s_es) - 1;
+
+	return blk >= first_block && blk <= last_block;
+}
+
 /* Called at mount-time, super-block is locked */
 static int ext4_check_descriptors(struct super_block *sb,
 				  ext4_group_t *first_not_zeroed)

