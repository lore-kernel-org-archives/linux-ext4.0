From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 09/13] ext4: enable ext4_update_super() to handle a flex groups
Date: Thu, 11 Aug 2011 11:28:24 +0800
Message-ID: <1313033308-882-10-git-send-email-xiaoqiangnk@gmail.com>
References: <1313033308-882-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: aedilger@gmail.com, tytso@mit.edu,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48649 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab1HKDfo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Aug 2011 23:35:44 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so2947235pzk.1
        for <linux-ext4@vger.kernel.org>; Wed, 10 Aug 2011 20:35:44 -0700 (PDT)
In-Reply-To: <1313033308-882-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch enables ext4_update_super() to handle a flex groups.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |   58 +++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 5939b62..606de3a 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1183,17 +1183,24 @@ static int ext4_setup_new_descs(handle_t *handle, struct super_block *sb,
 }
 
 /*
- * ext4_update_super() updates super so that new the added group can be seen
- *   by the filesystem.
+ * ext4_update_super() updates super block so that new added groups can be seen
+ * by the filesystem.
  *
  * @sb: super block
+ * @flex_gd: new added groups
  */
 static void ext4_update_super(struct super_block *sb,
-			      struct ext4_new_group_data *input)
+			     struct ext4_new_flex_group_data *flex_gd)
 {
+	ext4_fsblk_t blocks_count = 0;
+	ext4_fsblk_t free_blocks = 0;
+	ext4_fsblk_t reserved_blocks = 0;
+	struct ext4_new_group_data *group_data = flex_gd->groups;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
+	int i;
 
+	BUG_ON(flex_gd->count == 0 || group_data == NULL);
 	/*
 	 * Make the new blocks and inodes valid next.  We do this before
 	 * increasing the group count so that once the group is enabled,
@@ -1204,9 +1211,19 @@ static void ext4_update_super(struct super_block *sb,
 	 * blocks/inodes before the group is live won't actually let us
 	 * allocate the new space yet.
 	 */
-	ext4_blocks_count_set(es, ext4_blocks_count(es) +
-		input->blocks_count);
-	le32_add_cpu(&es->s_inodes_count, EXT4_INODES_PER_GROUP(sb));
+	for (i = 0; i < flex_gd->count; i++) {
+		blocks_count += group_data[i].blocks_count;
+		free_blocks += group_data[i].free_blocks_count;
+	}
+
+	reserved_blocks = ext4_r_blocks_count(es) * 100;
+	do_div(reserved_blocks, ext4_blocks_count(es));
+	reserved_blocks *= blocks_count;
+	do_div(reserved_blocks, 100);
+
+	ext4_blocks_count_set(es, ext4_blocks_count(es) + blocks_count);
+	le32_add_cpu(&es->s_inodes_count, EXT4_INODES_PER_GROUP(sb) *
+		     flex_gd->count);
 
 	/*
 	 * We need to protect s_groups_count against other CPUs seeing
@@ -1214,11 +1231,11 @@ static void ext4_update_super(struct super_block *sb,
 	 *
 	 * The precise rules we use are:
 	 *
-	 * * Writers must perform a smp_wmb() after updating all dependent
-	 *   data and before modifying the groups count
+	 * * Writers must perform a smp_wmb() after updating all
+	 *   dependent data and before modifying the groups count
 	 *
-	 * * Readers must perform an smp_rmb() after reading the groups count
-	 *   and before reading any dependent data.
+	 * * Readers must perform an smp_rmb() after reading the groups
+	 *   count and before reading any dependent data.
 	 *
 	 * NB. These rules can be relaxed when checking the group count
 	 * while freeing data, as we can only allocate from a block
@@ -1229,29 +1246,34 @@ static void ext4_update_super(struct super_block *sb,
 	smp_wmb();
 
 	/* Update the global fs size fields */
-	sbi->s_groups_count++;
+	sbi->s_groups_count += flex_gd->count;
 
 	/* Update the reserved block counts only once the new group is
 	 * active. */
 	ext4_r_blocks_count_set(es, ext4_r_blocks_count(es) +
-		input->reserved_blocks);
+				reserved_blocks);
 
 	/* Update the free space counts */
 	percpu_counter_add(&sbi->s_freeblocks_counter,
-			   input->free_blocks_count);
+			   free_blocks);
 	percpu_counter_add(&sbi->s_freeinodes_counter,
-			   EXT4_INODES_PER_GROUP(sb));
+			   EXT4_INODES_PER_GROUP(sb) * flex_gd->count);
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb,
+				      EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
 	    sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group;
-		flex_group = ext4_flex_group(sbi, input->group);
-		atomic_add(input->free_blocks_count,
+		flex_group = ext4_flex_group(sbi, group_data[0].group);
+		atomic_add(free_blocks,
 			   &sbi->s_flex_groups[flex_group].free_blocks);
-		atomic_add(EXT4_INODES_PER_GROUP(sb),
+		atomic_add(EXT4_INODES_PER_GROUP(sb) * flex_gd->count,
 			   &sbi->s_flex_groups[flex_group].free_inodes);
 	}
 
+	if (test_opt(sb, DEBUG))
+		printk(KERN_DEBUG "EXT4-fs: added group %u:"
+		       "%llu blocks(%llu free %llu reserved)\n", flex_gd->count,
+		       blocks_count, free_blocks, reserved_blocks);
 }
 
 /* Add group descriptor data to an existing or new group descriptor block.
-- 
1.7.5.1

