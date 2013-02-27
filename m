From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: Convert number of blocks to clusters properly
Date: Wed, 27 Feb 2013 13:25:54 +0100
Message-ID: <1361967954-20586-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758955Ab3B0MZ6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Feb 2013 07:25:58 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1RCPvhm018417
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 27 Feb 2013 07:25:58 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We're using macro EXT4_B2C() to convert number of blocks to number of
clusters, however we should be using EXT4_NUM_B2C(). Fix that.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/balloc.c  |    2 +-
 fs/ext4/mballoc.c |    8 ++++----
 fs/ext4/resize.c  |    6 +++---
 fs/ext4/super.c   |    2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 30444b0..46ac89b 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -633,7 +633,7 @@ ext4_fsblk_t ext4_count_free_clusters(struct super_block *sb)
 	brelse(bitmap_bh);
 	printk(KERN_DEBUG "ext4_count_free_clusters: stored = %llu"
 	       ", computed = %llu, %llu\n",
-	       EXT4_B2C(EXT4_SB(sb), ext4_free_blocks_count(es)),
+	       EXT4_NUM_B2C(EXT4_SB(sb), ext4_free_blocks_count(es)),
 	       desc_count, bitmap_count);
 	return bitmap_count;
 #else
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 1bf6fe7..5dd9e2b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3444,7 +3444,7 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 			win = offs;
 
 		ac->ac_b_ex.fe_logical = ac->ac_o_ex.fe_logical -
-			EXT4_B2C(sbi, win);
+			EXT4_NUM_B2C(sbi, win);
 		BUG_ON(ac->ac_o_ex.fe_logical < ac->ac_b_ex.fe_logical);
 		BUG_ON(ac->ac_o_ex.fe_len > ac->ac_b_ex.fe_len);
 	}
@@ -4590,7 +4590,7 @@ do_more:
 			EXT4_BLOCKS_PER_GROUP(sb);
 		count -= overflow;
 	}
-	count_clusters = EXT4_B2C(sbi, count);
+	count_clusters = EXT4_NUM_B2C(sbi, count);
 	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
 	if (!bitmap_bh) {
 		err = -EIO;
@@ -4832,11 +4832,11 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	ext4_group_desc_csum_set(sb, block_group, desc);
 	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeclusters_counter,
-			   EXT4_B2C(sbi, blocks_freed));
+			   EXT4_NUM_B2C(sbi, blocks_freed));
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
-		atomic_add(EXT4_B2C(sbi, blocks_freed),
+		atomic_add(EXT4_NUM_B2C(sbi, blocks_freed),
 			   &sbi->s_flex_groups[flex_group].free_clusters);
 	}
 
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index d99387b..1dceb43 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1247,7 +1247,7 @@ static int ext4_setup_new_descs(handle_t *handle, struct super_block *sb,
 
 		ext4_inode_table_set(sb, gdp, group_data->inode_table);
 		ext4_free_group_clusters_set(sb, gdp,
-					     EXT4_B2C(sbi, group_data->free_blocks_count));
+			EXT4_NUM_B2C(sbi, group_data->free_blocks_count));
 		ext4_free_inodes_set(sb, gdp, EXT4_INODES_PER_GROUP(sb));
 		if (ext4_has_group_desc_csum(sb))
 			ext4_itable_unused_set(sb, gdp,
@@ -1349,7 +1349,7 @@ static void ext4_update_super(struct super_block *sb,
 
 	/* Update the free space counts */
 	percpu_counter_add(&sbi->s_freeclusters_counter,
-			   EXT4_B2C(sbi, free_blocks));
+			   EXT4_NUM_B2C(sbi, free_blocks));
 	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT4_INODES_PER_GROUP(sb) * flex_gd->count);
 
@@ -1360,7 +1360,7 @@ static void ext4_update_super(struct super_block *sb,
 	    sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group;
 		flex_group = ext4_flex_group(sbi, group_data[0].group);
-		atomic_add(EXT4_B2C(sbi, free_blocks),
+		atomic_add(EXT4_NUM_B2C(sbi, free_blocks),
 			   &sbi->s_flex_groups[flex_group].free_clusters);
 		atomic_add(EXT4_INODES_PER_GROUP(sb) * flex_gd->count,
 			   &sbi->s_flex_groups[flex_group].free_inodes);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3d4fb81..6f12830 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3235,7 +3235,7 @@ int ext4_calculate_overhead(struct super_block *sb)
 	}
 	/* Add the journal blocks as well */
 	if (sbi->s_journal)
-		overhead += EXT4_B2C(sbi, sbi->s_journal->j_maxlen);
+		overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
 
 	sbi->s_overhead = overhead;
 	smp_wmb();
-- 
1.7.7.6

