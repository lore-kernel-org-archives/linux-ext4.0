From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC PATCH v2 4/4] ext4: use a round-robin algorithm to shrink extent cache
Date: Wed, 16 Apr 2014 19:30:30 +0800
Message-ID: <1397647830-24444-5-git-send-email-wenqing.lz@taobao.com>
References: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:50407 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbaDPLY1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2014 07:24:27 -0400
Received: by mail-pb0-f49.google.com with SMTP id jt11so10734715pbb.36
        for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2014 04:24:26 -0700 (PDT)
In-Reply-To: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This commit drops lru algorithm and uses a new round-robin algorithm to
reclaim the extent cache.  The new algorithm scans all extent caches and
saves the inode and offset that it stopped at last time, and rescans from
here.  If this inode has been reclaimed, the shrinker will scan from the
next inode.

At the first round the shrinker skips the precached inode, and the
shrinker will rescan the list to reclaim these precached inodes if it
doesn't reclaim any objects at the first round.

In fact the shrinker shouldn't need to add any new variables to save the
inode or offset.  Every time the inodes that have been scanned will be
moved to the tail of the list.  Meanwhile extent cache is added into the
tail of the list.  Thus every time the shrinker will scan from the inode
and offset that last time it stopped.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/ext4.h           |    7 ++--
 fs/ext4/extents.c        |    4 +--
 fs/ext4/extents_status.c |   82 ++++++++++++++++++++++------------------------
 fs/ext4/extents_status.h |    9 +++--
 fs/ext4/inode.c          |    4 +--
 fs/ext4/ioctl.c          |    4 +--
 fs/ext4/super.c          |    5 ++-
 7 files changed, 54 insertions(+), 61 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 89f3dfa..82238ba 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -889,10 +889,9 @@ struct ext4_inode_info {
 	/* extents status tree */
 	struct ext4_es_tree i_es_tree;
 	rwlock_t i_es_lock;
-	struct list_head i_es_lru;
+	struct list_head i_es_list;
 	unsigned int i_es_all_nr;	/* protected by i_es_lock */
 	unsigned int i_es_lru_nr;	/* protected by i_es_lock */
-	unsigned long i_touch_when;	/* jiffies of last accessing */
 
 	/* ialloc */
 	ext4_group_t	i_last_alloc_group;
@@ -1329,10 +1328,10 @@ struct ext4_sb_info {
 
 	/* Reclaim extents from extent status tree */
 	struct shrinker s_es_shrinker;
-	struct list_head s_es_lru;
+	struct list_head s_es_list;
 	struct ext4_es_stats s_es_stats;
 	struct mb_cache *s_mb_cache;
-	spinlock_t s_es_lru_lock ____cacheline_aligned_in_smp;
+	spinlock_t s_es_lock ____cacheline_aligned_in_smp;
 
 	/* Ratelimit ext4 messages. */
 	struct ratelimit_state s_err_ratelimit_state;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 82df3ce..ed7da01 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4617,7 +4617,7 @@ out2:
 
 	trace_ext4_ext_map_blocks_exit(inode, flags, map,
 				       err ? err : allocated);
-	ext4_es_lru_add(inode);
+	ext4_es_list_add(inode);
 	return err ? err : allocated;
 }
 
@@ -5159,7 +5159,7 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		error = ext4_fill_fiemap_extents(inode, start_blk,
 						 len_blks, fieinfo);
 	}
-	ext4_es_lru_add(inode);
+	ext4_es_list_add(inode);
 	return error;
 }
 
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index fe33557..f05cb40 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -170,7 +170,7 @@ void ext4_exit_es(void)
 void ext4_es_init_tree(struct ext4_es_tree *tree)
 {
 	tree->root = RB_ROOT;
-	INIT_HLIST_HEAD(&tree->evictable_list);
+	INIT_LIST_HEAD(&tree->evictable_list);
 	tree->cache_es = NULL;
 }
 
@@ -309,7 +309,7 @@ ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
 	if (es == NULL)
 		return NULL;
 
-	INIT_HLIST_NODE(&es->es_list);
+	INIT_LIST_HEAD(&es->es_list);
 	es->es_lblk = lblk;
 	es->es_len = len;
 	es->es_pblk = pblk;
@@ -321,7 +321,7 @@ ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
 		ei->i_es_lru_nr++;
 		percpu_counter_inc(&EXT4_SB(inode->i_sb)->
 					s_es_stats.es_stats_lru_cnt);
-		hlist_add_head(&es->es_list, &ei->i_es_tree.evictable_list);
+		list_add_tail(&es->es_list, &ei->i_es_tree.evictable_list);
 	}
 
 	EXT4_I(inode)->i_es_all_nr++;
@@ -340,7 +340,7 @@ static void ext4_es_free_extent(struct inode *inode, struct extent_status *es)
 	/* Decrease the lru counter when this es is not delayed */
 	if (!ext4_es_is_delayed(es)) {
 		BUG_ON(ei->i_es_lru_nr-- == 0);
-		hlist_del_init(&es->es_list);
+		list_del_init(&es->es_list);
 		percpu_counter_dec(&EXT4_SB(inode->i_sb)->
 					s_es_stats.es_stats_lru_cnt);
 	}
@@ -922,21 +922,20 @@ int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 static int __ext4_es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 			    struct ext4_inode_info *locked_ei)
 {
-	struct ext4_inode_info *ei;
 	struct ext4_es_stats *es_stats;
+	struct ext4_inode_info *ei;
+	LIST_HEAD(scanned);
 	ktime_t start_time;
 	u64 scan_time;
-	int nr_shrunk = 0;
+	int nr_shrunk = 0, shrunk;
 	int retried = 0, skip_precached = 1, nr_skipped = 0;
 
 	es_stats = &sbi->s_es_stats;
 	start_time = ktime_get();
-	spin_lock(&sbi->s_es_lru_lock);
+	spin_lock(&sbi->s_es_lock);
 
 retry:
-	list_for_each_entry(ei, &sbi->s_es_lru, i_es_lru) {
-		int shrunk;
-
+	list_for_each_entry(ei, &sbi->s_es_list, i_es_list) {
 		/*
 		 * If we have already reclaimed all extents from extent
 		 * status tree, just stop the loop immediately.
@@ -950,9 +949,8 @@ retry:
 		 * time.  Normally we try hard to avoid shrinking
 		 * precached inodes, but we will as a last resort.
 		 */
-		if ((es_stats->es_stats_last_scanned < ei->i_touch_when) ||
-		    (skip_precached && ext4_test_inode_state(&ei->vfs_inode,
-						EXT4_STATE_EXT_PRECACHED))) {
+		if (skip_precached && ext4_test_inode_state(&ei->vfs_inode,
+						EXT4_STATE_EXT_PRECACHED)) {
 			nr_skipped++;
 			continue;
 		}
@@ -970,12 +968,18 @@ retry:
 			break;
 	}
 
+	/* Move the scanned inodes into the tail of the list */
+	if (&ei->i_es_list != &sbi->s_es_list) {
+		struct ext4_inode_info *prev = list_prev_entry(ei, i_es_list);
+		list_cut_position(&scanned, &sbi->s_es_list, &prev->i_es_list);
+		list_splice_tail(&scanned, &sbi->s_es_list);
+	}
+
 	/*
 	 * If we skipped any inodes, and we weren't able to make any
-	 * forward progress, update the last scanned time stamp and try again.
+	 * forward progress, release precached inode.
 	 */
 	if ((nr_shrunk == 0) && nr_skipped && !retried) {
-		es_stats->es_stats_last_scanned = jiffies;
 		retried++;
 		/*
 		 * If the shrinker can not reclaim any objects at the
@@ -985,7 +989,7 @@ retry:
 		goto retry;
 	}
 
-	spin_unlock(&sbi->s_es_lru_lock);
+	spin_unlock(&sbi->s_es_lock);
 
 	if (locked_ei && nr_shrunk == 0)
 		nr_shrunk = __es_try_to_reclaim_extents(locked_ei, nr_to_scan);
@@ -1063,25 +1067,21 @@ static int ext4_es_seq_shrinker_info_show(struct seq_file *seq, void *v)
 		return 0;
 
 	/* here we just find an inode that has the max nr. of objects */
-	spin_lock(&sbi->s_es_lru_lock);
-	list_for_each_entry(ei, &sbi->s_es_lru, i_es_lru) {
+	spin_lock(&sbi->s_es_lock);
+	list_for_each_entry(ei, &sbi->s_es_list, i_es_list) {
 		inode_cnt++;
 		if (max && max->i_es_all_nr < ei->i_es_all_nr)
 			max = ei;
 		else if (!max)
 			max = ei;
 	}
-	spin_unlock(&sbi->s_es_lru_lock);
+	spin_unlock(&sbi->s_es_lock);
 
 	seq_printf(seq, "stats:\n  %lld objects\n  %lld reclaimable objects\n",
 		   percpu_counter_sum_positive(&es_stats->es_stats_all_cnt),
 		   percpu_counter_sum_positive(&es_stats->es_stats_lru_cnt));
-	if (es_stats->es_stats_last_scanned != 0)
-		seq_printf(seq, "  %u ms last sorted interval\n",
-			   jiffies_to_msecs(jiffies -
-					    es_stats->es_stats_last_scanned));
 	if (inode_cnt)
-		seq_printf(seq, "  %d inodes on lru list\n", inode_cnt);
+		seq_printf(seq, "  %d inodes on list\n", inode_cnt);
 
 	seq_printf(seq, "average:\n  %llu us scan time\n",
 	    div_u64(es_stats->es_stats_scan_time, 1000));
@@ -1139,9 +1139,8 @@ int ext4_es_register_shrinker(struct ext4_sb_info *sbi)
 {
 	int err;
 
-	INIT_LIST_HEAD(&sbi->s_es_lru);
-	spin_lock_init(&sbi->s_es_lru_lock);
-	sbi->s_es_stats.es_stats_last_scanned = 0;
+	INIT_LIST_HEAD(&sbi->s_es_list);
+	spin_lock_init(&sbi->s_es_lock);
 	sbi->s_es_stats.es_stats_shrunk = 0;
 	sbi->s_es_stats.es_stats_scan_time = 0;
 	sbi->s_es_stats.es_stats_max_scan_time = 0;
@@ -1181,31 +1180,29 @@ void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi)
 	unregister_shrinker(&sbi->s_es_shrinker);
 }
 
-void ext4_es_lru_add(struct inode *inode)
+void ext4_es_list_add(struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 
-	ei->i_touch_when = jiffies;
-
-	if (!list_empty(&ei->i_es_lru))
+	if (!list_empty(&ei->i_es_list))
 		return;
 
-	spin_lock(&sbi->s_es_lru_lock);
-	if (list_empty(&ei->i_es_lru))
-		list_add_tail(&ei->i_es_lru, &sbi->s_es_lru);
-	spin_unlock(&sbi->s_es_lru_lock);
+	spin_lock(&sbi->s_es_lock);
+	if (list_empty(&ei->i_es_list))
+		list_add_tail(&ei->i_es_list, &sbi->s_es_list);
+	spin_unlock(&sbi->s_es_lock);
 }
 
-void ext4_es_lru_del(struct inode *inode)
+void ext4_es_list_del(struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 
-	spin_lock(&sbi->s_es_lru_lock);
-	if (!list_empty(&ei->i_es_lru))
-		list_del_init(&ei->i_es_lru);
-	spin_unlock(&sbi->s_es_lru_lock);
+	spin_lock(&sbi->s_es_lock);
+	if (!list_empty(&ei->i_es_list))
+		list_del_init(&ei->i_es_list);
+	spin_unlock(&sbi->s_es_lock);
 }
 
 static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
@@ -1213,8 +1210,7 @@ static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
 {
 	struct inode *inode = &ei->vfs_inode;
 	struct ext4_es_tree *tree = &ei->i_es_tree;
-	struct extent_status *es;
-	struct hlist_node *tmp;
+	struct extent_status *es, *tmp;
 	unsigned long nr_shrunk = 0;
 	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
@@ -1226,7 +1222,7 @@ static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
 	    __ratelimit(&_rs))
 		ext4_warning(inode->i_sb, "forced shrink of precached extents");
 
-	hlist_for_each_entry_safe(es, tmp, &tree->evictable_list, es_list) {
+	list_for_each_entry_safe(es, tmp, &tree->evictable_list, es_list) {
 		BUG_ON(ext4_es_is_delayed(es));
 		rb_erase(&es->rb_node, &tree->root);
 		ext4_es_free_extent(inode, es);
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index f19ca17..3626d88 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -54,7 +54,7 @@ struct ext4_extent;
 
 struct extent_status {
 	struct rb_node rb_node;
-	struct hlist_node es_list;
+	struct list_head es_list;
 	ext4_lblk_t es_lblk;	/* first logical block extent covers */
 	ext4_lblk_t es_len;	/* length of extent in block */
 	ext4_fsblk_t es_pblk;	/* first physical block */
@@ -62,12 +62,11 @@ struct extent_status {
 
 struct ext4_es_tree {
 	struct rb_root root;
-	struct hlist_head evictable_list;
+	struct list_head evictable_list;
 	struct extent_status *cache_es;	/* recently accessed extent */
 };
 
 struct ext4_es_stats {
-	unsigned long es_stats_last_scanned;
 	unsigned long es_stats_shrunk;
 	u64 es_stats_scan_time;
 	u64 es_stats_max_scan_time;
@@ -151,7 +150,7 @@ static inline void ext4_es_store_pblock_status(struct extent_status *es,
 
 extern int ext4_es_register_shrinker(struct ext4_sb_info *sbi);
 extern void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi);
-extern void ext4_es_lru_add(struct inode *inode);
-extern void ext4_es_lru_del(struct inode *inode);
+extern void ext4_es_list_add(struct inode *inode);
+extern void ext4_es_list_del(struct inode *inode);
 
 #endif /* _EXT4_EXTENTS_STATUS_H */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0171c19..dba2c1f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -523,7 +523,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, map->m_lblk, &es)) {
-		ext4_es_lru_add(inode);
+		ext4_es_list_add(inode);
 		if (ext4_es_is_written(&es) || ext4_es_is_unwritten(&es)) {
 			map->m_pblk = ext4_es_pblock(&es) +
 					map->m_lblk - es.es_lblk;
@@ -1532,7 +1532,7 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, iblock, &es)) {
-		ext4_es_lru_add(inode);
+		ext4_es_list_add(inode);
 		if (ext4_es_is_hole(&es)) {
 			retval = 0;
 			down_read((&EXT4_I(inode)->i_data_sem));
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 0f2252e..25c9ef0 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -78,8 +78,8 @@ static void swap_inode_data(struct inode *inode1, struct inode *inode2)
 	memswap(&ei1->i_disksize, &ei2->i_disksize, sizeof(ei1->i_disksize));
 	ext4_es_remove_extent(inode1, 0, EXT_MAX_BLOCKS);
 	ext4_es_remove_extent(inode2, 0, EXT_MAX_BLOCKS);
-	ext4_es_lru_del(inode1);
-	ext4_es_lru_del(inode2);
+	ext4_es_list_del(inode1);
+	ext4_es_list_del(inode2);
 
 	isize = i_size_read(inode1);
 	i_size_write(inode1, i_size_read(inode2));
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index df0fb22..8d9cdf4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -882,10 +882,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	spin_lock_init(&ei->i_prealloc_lock);
 	ext4_es_init_tree(&ei->i_es_tree);
 	rwlock_init(&ei->i_es_lock);
-	INIT_LIST_HEAD(&ei->i_es_lru);
+	INIT_LIST_HEAD(&ei->i_es_list);
 	ei->i_es_all_nr = 0;
 	ei->i_es_lru_nr = 0;
-	ei->i_touch_when = 0;
 	ei->i_reserved_data_blocks = 0;
 	ei->i_reserved_meta_blocks = 0;
 	ei->i_allocated_meta_blocks = 0;
@@ -974,7 +973,7 @@ void ext4_clear_inode(struct inode *inode)
 	dquot_drop(inode);
 	ext4_discard_preallocations(inode);
 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
-	ext4_es_lru_del(inode);
+	ext4_es_list_del(inode);
 	if (EXT4_I(inode)->jinode) {
 		jbd2_journal_release_jbd_inode(EXT4_JOURNAL(inode),
 					       EXT4_I(inode)->jinode);
-- 
1.7.9.7

