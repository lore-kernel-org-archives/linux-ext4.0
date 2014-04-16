From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC PATCH v2 3/4] ext4: improve extents status tree shrinker lru algorithm
Date: Wed, 16 Apr 2014 19:30:29 +0800
Message-ID: <1397647830-24444-4-git-send-email-wenqing.lz@taobao.com>
References: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44925 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbaDPLYY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2014 07:24:24 -0400
Received: by mail-pb0-f45.google.com with SMTP id uo5so10728250pbc.18
        for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2014 04:24:24 -0700 (PDT)
In-Reply-To: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Currently there are two defects in extents status tree shrinker.  One is
non-reclaimable entry, and another is lru list.

The extents status tree shrinker will scan all inodes on sbi->s_es_lru
under heavy memory pressure, and try to reclaim the entry from extents
status tree.  During this process it couldn't reclaim the delayed entry
because ext4 needs to use these entries to do delayed allocation space
reservation, seek_data/hole, etc....  So if a system did a huge number
of writes and these dirty pages don't be written out.  There will be a
lot of delayed entries on extents status tree.  If shrinker tries to
reclaim memory from the tree, it will burn some CPU time to iterate on
these non-reclaimable entries.  Under some circumstances it could cause
excessive stall time.  In this commit a new list is used to track
reclaimable entries of extent status tree (e.g. written/unwritten/hole
entries).  The shrinker will scan reclaimable entry on this list.  So it
won't encouter any delayed entry and don't need to take too much time to
spin.  But the defect is that we need to cost extra 1/3 memory space for
one entry.  Before this commit, 'struct extent_status' occupies 48 bytes
on a 64bits platform.  After that it will occupy 64 bytes. :(

Another improvement in this commit is to make lru list more efficient.
Now when we can not shrink any entry from the extents status tree every
time, we will sort lru list and scan again.  But it takes too much time,
and cause a huge stall when the application opens a large number of
files.  In this commit we just use ei->i_touch_when to determine whether
or not the shrinker reclaim entry from an inode.  This time stamp will
be touched in ext4_es_lru_add().  After that, entry whose i_touch_when
is less than es_stats_last_scanned is discarded.  When the shrinker can
not reclaim any entry, es_stats_last_scanned will be updated, and it will
try to reclaim precached inode.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents_status.c |   98 ++++++++++++++--------------------------------
 fs/ext4/extents_status.h |    4 +-
 2 files changed, 33 insertions(+), 69 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 9d977a3..fe33557 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -10,7 +10,6 @@
  * Ext4 extents status tree core functions.
  */
 #include <linux/rbtree.h>
-#include <linux/list_sort.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include "ext4.h"
@@ -171,6 +170,7 @@ void ext4_exit_es(void)
 void ext4_es_init_tree(struct ext4_es_tree *tree)
 {
 	tree->root = RB_ROOT;
+	INIT_HLIST_HEAD(&tree->evictable_list);
 	tree->cache_es = NULL;
 }
 
@@ -302,10 +302,14 @@ static struct extent_status *
 ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
 		     ext4_fsblk_t pblk)
 {
+	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct extent_status *es;
+
 	es = kmem_cache_alloc(ext4_es_cachep, GFP_ATOMIC);
 	if (es == NULL)
 		return NULL;
+
+	INIT_HLIST_NODE(&es->es_list);
 	es->es_lblk = lblk;
 	es->es_len = len;
 	es->es_pblk = pblk;
@@ -314,9 +318,10 @@ ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
 	 * We don't count delayed extent because we never try to reclaim them
 	 */
 	if (!ext4_es_is_delayed(es)) {
-		EXT4_I(inode)->i_es_lru_nr++;
+		ei->i_es_lru_nr++;
 		percpu_counter_inc(&EXT4_SB(inode->i_sb)->
 					s_es_stats.es_stats_lru_cnt);
+		hlist_add_head(&es->es_list, &ei->i_es_tree.evictable_list);
 	}
 
 	EXT4_I(inode)->i_es_all_nr++;
@@ -327,13 +332,15 @@ ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
 
 static void ext4_es_free_extent(struct inode *inode, struct extent_status *es)
 {
+	struct ext4_inode_info *ei = EXT4_I(inode);
+
 	EXT4_I(inode)->i_es_all_nr--;
 	percpu_counter_dec(&EXT4_SB(inode->i_sb)->s_es_stats.es_stats_all_cnt);
 
 	/* Decrease the lru counter when this es is not delayed */
 	if (!ext4_es_is_delayed(es)) {
-		BUG_ON(EXT4_I(inode)->i_es_lru_nr == 0);
-		EXT4_I(inode)->i_es_lru_nr--;
+		BUG_ON(ei->i_es_lru_nr-- == 0);
+		hlist_del_init(&es->es_list);
 		percpu_counter_dec(&EXT4_SB(inode->i_sb)->
 					s_es_stats.es_stats_lru_cnt);
 	}
@@ -912,34 +919,11 @@ int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 	return err;
 }
 
-static int ext4_inode_touch_time_cmp(void *priv, struct list_head *a,
-				     struct list_head *b)
-{
-	struct ext4_inode_info *eia, *eib;
-	eia = list_entry(a, struct ext4_inode_info, i_es_lru);
-	eib = list_entry(b, struct ext4_inode_info, i_es_lru);
-
-	if (ext4_test_inode_state(&eia->vfs_inode, EXT4_STATE_EXT_PRECACHED) &&
-	    !ext4_test_inode_state(&eib->vfs_inode, EXT4_STATE_EXT_PRECACHED))
-		return 1;
-	if (!ext4_test_inode_state(&eia->vfs_inode, EXT4_STATE_EXT_PRECACHED) &&
-	    ext4_test_inode_state(&eib->vfs_inode, EXT4_STATE_EXT_PRECACHED))
-		return -1;
-	if (eia->i_touch_when == eib->i_touch_when)
-		return 0;
-	if (time_after(eia->i_touch_when, eib->i_touch_when))
-		return 1;
-	else
-		return -1;
-}
-
 static int __ext4_es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 			    struct ext4_inode_info *locked_ei)
 {
 	struct ext4_inode_info *ei;
 	struct ext4_es_stats *es_stats;
-	struct list_head *cur, *tmp;
-	LIST_HEAD(skipped);
 	ktime_t start_time;
 	u64 scan_time;
 	int nr_shrunk = 0;
@@ -950,7 +934,7 @@ static int __ext4_es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 	spin_lock(&sbi->s_es_lru_lock);
 
 retry:
-	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {
+	list_for_each_entry(ei, &sbi->s_es_lru, i_es_lru) {
 		int shrunk;
 
 		/*
@@ -961,18 +945,15 @@ retry:
 				&es_stats->es_stats_lru_cnt) == 0)
 			break;
 
-		ei = list_entry(cur, struct ext4_inode_info, i_es_lru);
-
 		/*
-		 * Skip the inode that is newer than the last_sorted
+		 * Skip the inode that is newer than the last_scanned
 		 * time.  Normally we try hard to avoid shrinking
 		 * precached inodes, but we will as a last resort.
 		 */
-		if ((es_stats->es_stats_last_sorted < ei->i_touch_when) ||
+		if ((es_stats->es_stats_last_scanned < ei->i_touch_when) ||
 		    (skip_precached && ext4_test_inode_state(&ei->vfs_inode,
 						EXT4_STATE_EXT_PRECACHED))) {
 			nr_skipped++;
-			list_move_tail(cur, &skipped);
 			continue;
 		}
 
@@ -981,8 +962,6 @@ retry:
 
 		write_lock(&ei->i_es_lock);
 		shrunk = __es_try_to_reclaim_extents(ei, nr_to_scan);
-		if (ei->i_es_lru_nr == 0)
-			list_del_init(&ei->i_es_lru);
 		write_unlock(&ei->i_es_lock);
 
 		nr_shrunk += shrunk;
@@ -991,27 +970,18 @@ retry:
 			break;
 	}
 
-	/* Move the newer inodes into the tail of the LRU list. */
-	list_splice_tail(&skipped, &sbi->s_es_lru);
-	INIT_LIST_HEAD(&skipped);
-
 	/*
 	 * If we skipped any inodes, and we weren't able to make any
-	 * forward progress, sort the list and try again.
+	 * forward progress, update the last scanned time stamp and try again.
 	 */
 	if ((nr_shrunk == 0) && nr_skipped && !retried) {
+		es_stats->es_stats_last_scanned = jiffies;
 		retried++;
-		list_sort(NULL, &sbi->s_es_lru, ext4_inode_touch_time_cmp);
-		es_stats->es_stats_last_sorted = jiffies;
-		ei = list_first_entry(&sbi->s_es_lru, struct ext4_inode_info,
-				      i_es_lru);
 		/*
-		 * If there are no non-precached inodes left on the
-		 * list, start releasing precached extents.
+		 * If the shrinker can not reclaim any objects at the
+		 * first round, we start to reclaim precached inodes.
 		 */
-		if (ext4_test_inode_state(&ei->vfs_inode,
-					  EXT4_STATE_EXT_PRECACHED))
-			skip_precached = 0;
+		skip_precached = 0;
 		goto retry;
 	}
 
@@ -1106,10 +1076,10 @@ static int ext4_es_seq_shrinker_info_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "stats:\n  %lld objects\n  %lld reclaimable objects\n",
 		   percpu_counter_sum_positive(&es_stats->es_stats_all_cnt),
 		   percpu_counter_sum_positive(&es_stats->es_stats_lru_cnt));
-	if (es_stats->es_stats_last_sorted != 0)
+	if (es_stats->es_stats_last_scanned != 0)
 		seq_printf(seq, "  %u ms last sorted interval\n",
 			   jiffies_to_msecs(jiffies -
-					    es_stats->es_stats_last_sorted));
+					    es_stats->es_stats_last_scanned));
 	if (inode_cnt)
 		seq_printf(seq, "  %d inodes on lru list\n", inode_cnt);
 
@@ -1171,7 +1141,7 @@ int ext4_es_register_shrinker(struct ext4_sb_info *sbi)
 
 	INIT_LIST_HEAD(&sbi->s_es_lru);
 	spin_lock_init(&sbi->s_es_lru_lock);
-	sbi->s_es_stats.es_stats_last_sorted = 0;
+	sbi->s_es_stats.es_stats_last_scanned = 0;
 	sbi->s_es_stats.es_stats_shrunk = 0;
 	sbi->s_es_stats.es_stats_scan_time = 0;
 	sbi->s_es_stats.es_stats_max_scan_time = 0;
@@ -1243,8 +1213,8 @@ static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
 {
 	struct inode *inode = &ei->vfs_inode;
 	struct ext4_es_tree *tree = &ei->i_es_tree;
-	struct rb_node *node;
 	struct extent_status *es;
+	struct hlist_node *tmp;
 	unsigned long nr_shrunk = 0;
 	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
@@ -1256,21 +1226,13 @@ static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
 	    __ratelimit(&_rs))
 		ext4_warning(inode->i_sb, "forced shrink of precached extents");
 
-	node = rb_first(&tree->root);
-	while (node != NULL) {
-		es = rb_entry(node, struct extent_status, rb_node);
-		node = rb_next(&es->rb_node);
-		/*
-		 * We can't reclaim delayed extent from status tree because
-		 * fiemap, bigallic, and seek_data/hole need to use it.
-		 */
-		if (!ext4_es_is_delayed(es)) {
-			rb_erase(&es->rb_node, &tree->root);
-			ext4_es_free_extent(inode, es);
-			nr_shrunk++;
-			if (--nr_to_scan == 0)
-				break;
-		}
+	hlist_for_each_entry_safe(es, tmp, &tree->evictable_list, es_list) {
+		BUG_ON(ext4_es_is_delayed(es));
+		rb_erase(&es->rb_node, &tree->root);
+		ext4_es_free_extent(inode, es);
+		nr_shrunk++;
+		if (--nr_to_scan == 0)
+			break;
 	}
 	tree->cache_es = NULL;
 	return nr_shrunk;
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index 647c3c9..f19ca17 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -54,6 +54,7 @@ struct ext4_extent;
 
 struct extent_status {
 	struct rb_node rb_node;
+	struct hlist_node es_list;
 	ext4_lblk_t es_lblk;	/* first logical block extent covers */
 	ext4_lblk_t es_len;	/* length of extent in block */
 	ext4_fsblk_t es_pblk;	/* first physical block */
@@ -61,11 +62,12 @@ struct extent_status {
 
 struct ext4_es_tree {
 	struct rb_root root;
+	struct hlist_head evictable_list;
 	struct extent_status *cache_es;	/* recently accessed extent */
 };
 
 struct ext4_es_stats {
-	unsigned long es_stats_last_sorted;
+	unsigned long es_stats_last_scanned;
 	unsigned long es_stats_shrunk;
 	u64 es_stats_scan_time;
 	u64 es_stats_max_scan_time;
-- 
1.7.9.7

