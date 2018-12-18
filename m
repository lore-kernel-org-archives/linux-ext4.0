Return-Path: <SRS0=0j4F=O3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:16595 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726419AbeLRL5A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Dec 2018 06:57:00 -0500
From: "zhangyi (F)" <yi.zhang@huawei.com>
To: <linux-ext4@vger.kernel.org>
CC: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <wshilong@ddn.com>,
        <yi.zhang@huawei.com>, <miaoxie@huawei.com>
Subject: [PATCH 2/2] ext4: clean up group state test macros with predicate functions
Date: Tue, 18 Dec 2018 20:00:01 +0800
Message-ID: <1545134401-104523-2-git-send-email-yi.zhang@huawei.com>
In-Reply-To: <1545134401-104523-1-git-send-email-yi.zhang@huawei.com>
References: <1545134401-104523-1-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create separate predicate functions to test/set/clear/test_and_set
bb_state flags in ext4_group_info like features testing, and then
replace all old macros and the places where we use
EXT4_GROUP_INFO_XXX_BIT directly.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/ext4/balloc.c  |  6 +++---
 fs/ext4/ext4.h    | 45 ++++++++++++++++++++++++++-------------------
 fs/ext4/ialloc.c  |  8 ++++----
 fs/ext4/mballoc.c | 35 +++++++++++++++++------------------
 fs/ext4/super.c   |  4 ++--
 5 files changed, 52 insertions(+), 46 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e5d6ee6..082387a 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -364,7 +364,7 @@ static int ext4_validate_block_bitmap(struct super_block *sb,
 
 	if (buffer_verified(bh))
 		return 0;
-	if (EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
+	if (ext4_mb_grp_bbitmap_corrupt(grp))
 		return -EFSCORRUPTED;
 
 	ext4_lock_group(sb, block_group);
@@ -699,7 +699,7 @@ ext4_fsblk_t ext4_count_free_clusters(struct super_block *sb)
 		grp = NULL;
 		if (EXT4_SB(sb)->s_group_info)
 			grp = ext4_get_group_info(sb, i);
-		if (!grp || !EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
+		if (!grp || !ext4_mb_grp_bbitmap_corrupt(grp))
 			desc_count += ext4_free_group_clusters(sb, gdp);
 		brelse(bitmap_bh);
 		bitmap_bh = ext4_read_block_bitmap(sb, i);
@@ -729,7 +729,7 @@ ext4_fsblk_t ext4_count_free_clusters(struct super_block *sb)
 		grp = NULL;
 		if (EXT4_SB(sb)->s_group_info)
 			grp = ext4_get_group_info(sb, i);
-		if (!grp || !EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
+		if (!grp || !ext4_mb_grp_bbitmap_corrupt(grp))
 			desc_count += ext4_free_group_clusters(sb, gdp);
 	}
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 755ba14..e460b05 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2882,25 +2882,32 @@ struct ext4_group_info {
 #define EXT4_GROUP_INFO_IBITMAP_CORRUPT		\
 	(1 << EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT)
 
-#define EXT4_MB_GRP_NEED_INIT(grp)	\
-	(test_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &((grp)->bb_state)))
-#define EXT4_MB_GRP_BBITMAP_CORRUPT(grp)	\
-	(test_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &((grp)->bb_state)))
-#define EXT4_MB_GRP_IBITMAP_CORRUPT(grp)	\
-	(test_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, &((grp)->bb_state)))
-#define EXT4_MB_GRP_TEST_AND_SET_BBITMAP_CORRUPT(grp)	\
-	(test_and_set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, \
-			  &((grp)->bb_state)))
-#define EXT4_MB_GRP_TEST_AND_SET_IBITMAP_CORRUPT(grp)	\
-	(test_and_set_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, \
-			  &((grp)->bb_state)))
-
-#define EXT4_MB_GRP_WAS_TRIMMED(grp)	\
-	(test_bit(EXT4_GROUP_INFO_WAS_TRIMMED_BIT, &((grp)->bb_state)))
-#define EXT4_MB_GRP_SET_TRIMMED(grp)	\
-	(set_bit(EXT4_GROUP_INFO_WAS_TRIMMED_BIT, &((grp)->bb_state)))
-#define EXT4_MB_GRP_CLEAR_TRIMMED(grp)	\
-	(clear_bit(EXT4_GROUP_INFO_WAS_TRIMMED_BIT, &((grp)->bb_state)))
+
+#define EXT4_MB_GROUP_STATE_FUNCS(name, statename)			\
+static inline int ext4_mb_grp_##name(struct ext4_group_info *grp)	\
+{									\
+	return test_bit(EXT4_GROUP_INFO_##statename##_BIT,		\
+			&(grp->bb_state));				\
+}									\
+static inline void ext4_mb_grp_set_##name(struct ext4_group_info *grp)	\
+{									\
+	set_bit(EXT4_GROUP_INFO_##statename##_BIT, &(grp->bb_state));	\
+}									\
+static inline void ext4_mb_grp_clear_##name(struct ext4_group_info *grp)\
+{									\
+	clear_bit(EXT4_GROUP_INFO_##statename##_BIT, &(grp->bb_state));	\
+}									\
+static inline int ext4_mb_grp_test_and_set_##name(struct ext4_group_info *grp) \
+{									\
+	return test_and_set_bit(EXT4_GROUP_INFO_##statename##_BIT,	\
+				&(grp->bb_state));			\
+}
+
+EXT4_MB_GROUP_STATE_FUNCS(need_init, NEED_INIT)
+EXT4_MB_GROUP_STATE_FUNCS(trimmed, WAS_TRIMMED)
+EXT4_MB_GROUP_STATE_FUNCS(bbitmap_corrupt, BBITMAP_CORRUPT)
+EXT4_MB_GROUP_STATE_FUNCS(ibitmap_corrupt, IBITMAP_CORRUPT)
+
 
 #define EXT4_MAX_CONTENTION		8
 #define EXT4_CONTENTION_THRESHOLD	2
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 014f6a6..ca86368 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -86,7 +86,7 @@ static int ext4_validate_inode_bitmap(struct super_block *sb,
 
 	if (buffer_verified(bh))
 		return 0;
-	if (EXT4_MB_GRP_IBITMAP_CORRUPT(grp))
+	if (ext4_mb_grp_ibitmap_corrupt(grp))
 		return -EFSCORRUPTED;
 
 	ext4_lock_group(sb, block_group);
@@ -293,7 +293,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 		bitmap_bh = NULL;
 		goto error_return;
 	}
-	if (unlikely(EXT4_MB_GRP_IBITMAP_CORRUPT(grp))) {
+	if (unlikely(ext4_mb_grp_ibitmap_corrupt(grp))) {
 		fatal = -EFSCORRUPTED;
 		goto error_return;
 	}
@@ -898,13 +898,13 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 
 		grp = ext4_get_group_info(sb, group);
 		/* Skip groups with already-known suspicious inode tables */
-		if (EXT4_MB_GRP_IBITMAP_CORRUPT(grp))
+		if (ext4_mb_grp_ibitmap_corrupt(grp))
 			goto next_group;
 
 		brelse(inode_bitmap_bh);
 		inode_bitmap_bh = ext4_read_inode_bitmap(sb, group);
 		/* Skip groups with suspicious inode tables */
-		if (EXT4_MB_GRP_IBITMAP_CORRUPT(grp) ||
+		if (ext4_mb_grp_ibitmap_corrupt(grp) ||
 		    IS_ERR(inode_bitmap_bh)) {
 			inode_bitmap_bh = NULL;
 			goto next_group;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e224808..4151c76 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -622,7 +622,7 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 			MB_CHECK_ASSERT(mb_test_bit(k, buddy2));
 		}
 	}
-	MB_CHECK_ASSERT(!EXT4_MB_GRP_NEED_INIT(e4b->bd_info));
+	MB_CHECK_ASSERT(!ext4_mb_grp_need_init(e4b->bd_info));
 	MB_CHECK_ASSERT(e4b->bd_info->bb_fragments == fragments);
 
 	grp = ext4_get_group_info(sb, e4b->bd_group);
@@ -755,7 +755,7 @@ void ext4_mb_generate_buddy(struct super_block *sb,
 	}
 	mb_set_largest_free_order(sb, grp);
 
-	clear_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &(grp->bb_state));
+	ext4_mb_grp_clear_need_init(grp);
 
 	period = get_cycles() - period;
 	spin_lock(&sbi->s_bal_lock);
@@ -857,7 +857,7 @@ static int ext4_mb_init_cache(struct page *page, char *incore, gfp_t gfp)
 		 * we must skip all initialized uptodate buddies on the page,
 		 * which may be currently in use by an allocating task.
 		 */
-		if (PageUptodate(page) && !EXT4_MB_GRP_NEED_INIT(grinfo)) {
+		if (PageUptodate(page) && !ext4_mb_grp_need_init(grinfo)) {
 			bh[i] = NULL;
 			continue;
 		}
@@ -1050,7 +1050,7 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group, gfp_t gfp)
 	 * page accessed.
 	 */
 	ret = ext4_mb_get_buddy_page_lock(sb, group, &e4b, gfp);
-	if (ret || !EXT4_MB_GRP_NEED_INIT(this_grp)) {
+	if (ret || !ext4_mb_grp_need_init(this_grp)) {
 		/*
 		 * somebody initialized the group
 		 * return without doing anything
@@ -1122,7 +1122,7 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 	e4b->bd_buddy_page = NULL;
 	e4b->bd_bitmap_page = NULL;
 
-	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
+	if (unlikely(ext4_mb_grp_need_init(grp))) {
 		/*
 		 * we need full data about the group
 		 * to make a good selection
@@ -1424,7 +1424,7 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 	BUG_ON(last >= (sb->s_blocksize << 3));
 	assert_spin_locked(ext4_group_lock_ptr(sb, e4b->bd_group));
 	/* Don't bother if the block group is corrupt. */
-	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info)))
+	if (unlikely(ext4_mb_grp_bbitmap_corrupt(e4b->bd_info)))
 		return;
 
 	mb_check_buddy(e4b);
@@ -1833,7 +1833,7 @@ int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 	if (err)
 		return err;
 
-	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info))) {
+	if (unlikely(ext4_mb_grp_bbitmap_corrupt(e4b->bd_info))) {
 		ext4_mb_unload_buddy(e4b);
 		return 0;
 	}
@@ -2046,11 +2046,11 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
 	if (cr <= 2 && free < ac->ac_g_ex.fe_len)
 		return 0;
 
-	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(grp)))
+	if (unlikely(ext4_mb_grp_bbitmap_corrupt(grp)))
 		return 0;
 
 	/* We only do this if the grp has never been initialized */
-	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
+	if (unlikely(ext4_mb_grp_need_init(grp))) {
 		int ret = ext4_mb_init_group(ac->ac_sb, group, GFP_NOFS);
 		if (ret)
 			return ret;
@@ -2304,7 +2304,7 @@ static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
 
 	grinfo = ext4_get_group_info(sb, group);
 	/* Load the group info in memory only if not already loaded. */
-	if (unlikely(EXT4_MB_GRP_NEED_INIT(grinfo))) {
+	if (unlikely(ext4_mb_grp_need_init(grinfo))) {
 		err = ext4_mb_load_buddy(sb, group, &e4b);
 		if (err) {
 			seq_printf(seq, "#%-5u: I/O error\n", group);
@@ -2418,8 +2418,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 		ext4_msg(sb, KERN_ERR, "can't allocate buddy mem");
 		goto exit_group_info;
 	}
-	set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,
-		&(meta_group_info[i]->bb_state));
+	ext4_mb_grp_set_need_init(meta_group_info[i]);
 
 	/*
 	 * initialize bb_free to be able to skip
@@ -2807,7 +2806,7 @@ static void ext4_free_data_in_buddy(struct super_block *sb,
 	 * is supported and the free blocks will be trimmed online.
 	 */
 	if (!test_opt(sb, DISCARD))
-		EXT4_MB_GRP_CLEAR_TRIMMED(db);
+		ext4_mb_grp_clear_trimmed(db);
 
 	if (!db->bb_free_root.rb_node) {
 		/* No more items in the per group rb tree
@@ -4790,7 +4789,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	overflow = 0;
 	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
 
-	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(
+	if (unlikely(ext4_mb_grp_bbitmap_corrupt(
 			ext4_get_group_info(sb, block_group))))
 		return;
 
@@ -4896,7 +4895,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 					 " with %d", block_group, bit, count,
 					 err);
 		} else
-			EXT4_MB_GRP_CLEAR_TRIMMED(e4b.bd_info);
+			ext4_mb_grp_clear_trimmed(e4b.bd_info);
 
 		ext4_lock_group(sb, block_group);
 		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
@@ -5169,7 +5168,7 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 	bitmap = e4b.bd_bitmap;
 
 	ext4_lock_group(sb, group);
-	if (EXT4_MB_GRP_WAS_TRIMMED(e4b.bd_info) &&
+	if (ext4_mb_grp_trimmed(e4b.bd_info) &&
 	    minblocks >= atomic_read(&EXT4_SB(sb)->s_last_trim_minblks))
 		goto out;
 
@@ -5210,7 +5209,7 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 
 	if (!ret) {
 		ret = count;
-		EXT4_MB_GRP_SET_TRIMMED(e4b.bd_info);
+		ext4_mb_grp_set_trimmed(e4b.bd_info);
 	}
 out:
 	ext4_unlock_group(sb, group);
@@ -5273,7 +5272,7 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	for (group = first_group; group <= last_group; group++) {
 		grp = ext4_get_group_info(sb, group);
 		/* We only do this if the grp has never been initialized */
-		if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
+		if (unlikely(ext4_mb_grp_need_init(grp))) {
 			ret = ext4_mb_init_group(sb, group, GFP_NOFS);
 			if (ret)
 				break;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5b83765..d08bcd7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -798,14 +798,14 @@ void ext4_mark_group_bitmap_corrupted(struct super_block *sb,
 	int ret;
 
 	if (flags & EXT4_GROUP_INFO_BBITMAP_CORRUPT) {
-		ret = EXT4_MB_GRP_TEST_AND_SET_BBITMAP_CORRUPT(grp);
+		ret = ext4_mb_grp_test_and_set_bbitmap_corrupt(grp);
 		if (!ret)
 			percpu_counter_sub(&sbi->s_freeclusters_counter,
 					   grp->bb_free);
 	}
 
 	if (flags & EXT4_GROUP_INFO_IBITMAP_CORRUPT) {
-		ret = EXT4_MB_GRP_TEST_AND_SET_IBITMAP_CORRUPT(grp);
+		ret = ext4_mb_grp_test_and_set_ibitmap_corrupt(grp);
 		if (!ret && gdp) {
 			int count;
 
-- 
2.7.4
