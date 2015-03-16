From: Beata Michalska <b.michalska@samsung.com>
Subject: [PATCH v2 1/2] ext4: Add helper function to mark group as corrupted
Date: Mon, 16 Mar 2015 14:25:28 +0100
Message-ID: <1426512329-24299-2-git-send-email-b.michalska@samsung.com>
References: <1426512329-24299-1-git-send-email-b.michalska@samsung.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
To: lczerner@redhat.com, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1426512329-24299-1-git-send-email-b.michalska@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add ext4_mark_group_corrupted helper function to
simplify the code and to keep the logic in one place.

Signed-off-by: Beata Michalska <b.michalska@samsung.com>
---
 fs/ext4/balloc.c  |   17 ++++-------------
 fs/ext4/ext4.h    |    9 +++++++++
 fs/ext4/ialloc.c  |    5 +----
 fs/ext4/mballoc.c |   13 +++----------
 fs/ext4/super.c   |    2 +-
 5 files changed, 18 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 83a6f49..5e6a9ca 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -193,10 +193,7 @@ static int ext4_init_block_bitmap(struct super_block *sb,
 	 * essentially implementing a per-group read-only flag. */
 	if (!ext4_group_desc_csum_verify(sb, block_group, gdp)) {
 		grp = ext4_get_group_info(sb, block_group);
-		if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
-			percpu_counter_sub(&sbi->s_freeclusters_counter,
-					   grp->bb_free);
-		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
+		ext4_mark_group_corrupted(sbi, grp);
 		if (!EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) {
 			int count;
 			count = ext4_free_inodes_count(sb, gdp);
@@ -252,7 +249,7 @@ unsigned ext4_free_clusters_after_init(struct super_block *sb,
 				       ext4_group_t block_group,
 				       struct ext4_group_desc *gdp)
 {
-	return num_clusters_in_group(sb, block_group) - 
+	return num_clusters_in_group(sb, block_group) -
 		ext4_num_overhead_clusters(sb, block_group, gdp);
 }
 
@@ -379,20 +376,14 @@ static void ext4_validate_block_bitmap(struct super_block *sb,
 		ext4_unlock_group(sb, block_group);
 		ext4_error(sb, "bg %u: block %llu: invalid block bitmap",
 			   block_group, blk);
-		if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
-			percpu_counter_sub(&sbi->s_freeclusters_counter,
-					   grp->bb_free);
-		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
+		ext4_mark_group_corrupted(sbi, grp);
 		return;
 	}
 	if (unlikely(!ext4_block_bitmap_csum_verify(sb, block_group,
 			desc, bh))) {
 		ext4_unlock_group(sb, block_group);
 		ext4_error(sb, "bg %u: bad block bitmap checksum", block_group);
-		if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
-			percpu_counter_sub(&sbi->s_freeclusters_counter,
-					   grp->bb_free);
-		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
+		ext4_mark_group_corrupted(sbi, grp);
 		return;
 	}
 	set_buffer_verified(bh);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f63c3d5..e10a94c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2535,6 +2535,15 @@ static inline spinlock_t *ext4_group_lock_ptr(struct super_block *sb,
 	return bgl_lock_ptr(EXT4_SB(sb)->s_blockgroup_lock, group);
 }
 
+static inline
+void ext4_mark_group_corrupted(struct ext4_sb_info *sbi,
+			     struct ext4_group_info *grp)
+{
+	if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
+		percpu_counter_sub(&sbi->s_freeclusters_counter, grp->bb_free);
+	set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
+}
+
 /*
  * Returns true if the filesystem is busy enough that attempts to
  * access the block group locks has run into contention.
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index ac644c3..ebe0499 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -79,10 +79,7 @@ static unsigned ext4_init_inode_bitmap(struct super_block *sb,
 	if (!ext4_group_desc_csum_verify(sb, block_group, gdp)) {
 		ext4_error(sb, "Checksum bad for group %u", block_group);
 		grp = ext4_get_group_info(sb, block_group);
-		if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
-			percpu_counter_sub(&sbi->s_freeclusters_counter,
-					   grp->bb_free);
-		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
+		ext4_mark_group_corrupted(sbi, grp);
 		if (!EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) {
 			int count;
 			count = ext4_free_inodes_count(sb, gdp);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8d1e602..b8817f3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -760,10 +760,7 @@ void ext4_mb_generate_buddy(struct super_block *sb,
 		 * corrupt and update bb_free using bitmap value
 		 */
 		grp->bb_free = free;
-		if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
-			percpu_counter_sub(&sbi->s_freeclusters_counter,
-					   grp->bb_free);
-		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
+		ext4_mark_group_corrupted(sbi, grp);
 	}
 	mb_set_largest_free_order(sb, grp);
 
@@ -1448,12 +1445,8 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 				      "freeing already freed block "
 				      "(bit %u); block bitmap corrupt.",
 				      block);
-		if (!EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info))
-			percpu_counter_sub(&sbi->s_freeclusters_counter,
-					   e4b->bd_info->bb_free);
 		/* Mark the block group as corrupt. */
-		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT,
-			&e4b->bd_info->bb_state);
+		ext4_mark_group_corrupted(sbi, e4b->bd_info);
 		mb_regenerate_buddy(e4b);
 		goto done;
 	}
@@ -2362,7 +2355,7 @@ int ext4_mb_alloc_groupinfo(struct super_block *sb, ext4_group_t ngroups)
 	}
 	sbi->s_group_info = new_groupinfo;
 	sbi->s_group_info_size = size / sizeof(*sbi->s_group_info);
-	ext4_debug("allocated s_groupinfo array for %d meta_bg's\n", 
+	ext4_debug("allocated s_groupinfo array for %d meta_bg's\n",
 		   sbi->s_group_info_size);
 	return 0;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e061e66..b4dfba3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4153,7 +4153,7 @@ no_journal:
 	}
 
 	block = ext4_count_free_clusters(sb);
-	ext4_free_blocks_count_set(sbi->s_es, 
+	ext4_free_blocks_count_set(sbi->s_es,
 				   EXT4_C2B(sbi, block));
 	err = percpu_counter_init(&sbi->s_freeclusters_counter, block,
 				  GFP_KERNEL);
-- 
1.7.9.5
