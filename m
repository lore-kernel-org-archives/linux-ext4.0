From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 5/6] ext4: use a list to track all reclaimable objects for extent status tree
Date: Thu,  7 Aug 2014 11:35:52 +0800
Message-ID: <1407382553-24256-6-git-send-email-wenqing.lz@taobao.com>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:55137 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbaHGDkv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Aug 2014 23:40:51 -0400
Received: by mail-pa0-f41.google.com with SMTP id rd3so4607729pab.28
        for <linux-ext4@vger.kernel.org>; Wed, 06 Aug 2014 20:40:50 -0700 (PDT)
In-Reply-To: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Currently the shrinker needs to take a long time to reclaim some objects
from a extent status tree because there are a lot of objects that are
delayed.  These objects could not be reclaimed because ext4 uses them to
finish seeking data/hole, finding delayed range and other works.  If a
rb-tree has a large number of delayed objects, shrinker should scan more
objects and the latency will be high.  This commit uses a list to track
all reclaimble objects in order to reduce the latency when the shrinker
tries to reclaim some objects from a extent status tree.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents_status.c |   74 ++++++++++++++++++++++++++--------------------
 fs/ext4/extents_status.h |    2 ++
 2 files changed, 44 insertions(+), 32 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 8d76fd5..2f81d1e 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -148,7 +148,8 @@ static int __es_insert_extent(struct inode *inode, struct extent_status *newes);
 static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 			      ext4_lblk_t end);
 static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
-				       int nr_to_scan);
+				       struct list_head *freeable,
+				       int *nr_to_scan);
 static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 		       struct ext4_inode_info *locked_ei);
 
@@ -171,6 +172,7 @@ void ext4_exit_es(void)
 void ext4_es_init_tree(struct ext4_es_tree *tree)
 {
 	tree->root = RB_ROOT;
+	INIT_LIST_HEAD(&tree->list);
 	tree->cache_es = NULL;
 }
 
@@ -302,6 +304,7 @@ static struct extent_status *
 ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
 		     ext4_fsblk_t pblk)
 {
+	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct extent_status *es;
 	es = kmem_cache_alloc(ext4_es_cachep, GFP_ATOMIC);
 	if (es == NULL)
@@ -314,12 +317,13 @@ ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
 	 * We don't count delayed extent because we never try to reclaim them
 	 */
 	if (!ext4_es_is_delayed(es)) {
-		EXT4_I(inode)->i_es_shk_nr++;
+		list_add_tail(&es->list, &ei->i_es_tree.list);
+		ei->i_es_shk_nr++;
 		percpu_counter_inc(&EXT4_SB(inode->i_sb)->
 					s_es_stats.es_stats_shk_cnt);
 	}
 
-	EXT4_I(inode)->i_es_all_nr++;
+	ei->i_es_all_nr++;
 	percpu_counter_inc(&EXT4_SB(inode->i_sb)->s_es_stats.es_stats_all_cnt);
 
 	return es;
@@ -327,13 +331,15 @@ ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
 
 static void ext4_es_free_extent(struct inode *inode, struct extent_status *es)
 {
-	EXT4_I(inode)->i_es_all_nr--;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+
+	ei->i_es_all_nr--;
 	percpu_counter_dec(&EXT4_SB(inode->i_sb)->s_es_stats.es_stats_all_cnt);
 
 	/* Decrease the shrink counter when this es is not delayed */
 	if (!ext4_es_is_delayed(es)) {
-		BUG_ON(EXT4_I(inode)->i_es_shk_nr == 0);
-		EXT4_I(inode)->i_es_shk_nr--;
+		list_del(&es->list);
+		BUG_ON(ei->i_es_shk_nr-- == 0);
 		percpu_counter_dec(&EXT4_SB(inode->i_sb)->
 					s_es_stats.es_stats_shk_cnt);
 	}
@@ -958,11 +964,24 @@ void ext4_es_list_del(struct inode *inode)
 	spin_unlock(&sbi->s_es_lock);
 }
 
+static void dispose_list(struct inode *inode, struct list_head *head)
+{
+	while (!list_empty(head)) {
+		struct extent_status *es;
+
+		es = list_first_entry(head, struct extent_status, list);
+		list_del_init(&es->list);
+
+		ext4_es_free_extent(inode, es);
+	}
+}
+
 static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 		       struct ext4_inode_info *locked_ei)
 {
 	struct ext4_inode_info *ei;
 	struct ext4_es_stats *es_stats;
+	LIST_HEAD(freeable);
 	ktime_t start_time;
 	u64 scan_time;
 	int nr_to_walk;
@@ -976,8 +995,6 @@ retry:
 	spin_lock(&sbi->s_es_lock);
 	nr_to_walk = sbi->s_es_nr_inode;
 	while (!list_empty(&sbi->s_es_list) && nr_to_walk-- > 0) {
-		int shrunk;
-
 		ei = list_first_entry(&sbi->s_es_list, struct ext4_inode_info,
 				      i_es_list);
 
@@ -1009,11 +1026,10 @@ retry:
 			continue;
 		}
 
-		shrunk = __es_try_to_reclaim_extents(ei, nr_to_scan);
+		nr_shrunk += __es_try_to_reclaim_extents(ei, &freeable,
+							 &nr_to_scan);
 		write_unlock(&ei->i_es_lock);
-
-		nr_shrunk += shrunk;
-		nr_to_scan -= shrunk;
+		dispose_list(&ei->vfs_inode, &freeable);
 
 		if (nr_to_scan == 0)
 			goto out;
@@ -1030,8 +1046,11 @@ retry:
 		goto retry;
 	}
 
-	if (locked_ei && nr_shrunk == 0)
-		nr_shrunk = __es_try_to_reclaim_extents(locked_ei, nr_to_scan);
+	if (locked_ei && nr_shrunk == 0) {
+		nr_shrunk = __es_try_to_reclaim_extents(locked_ei, &freeable,
+							&nr_to_scan);
+		dispose_list(&locked_ei->vfs_inode, &freeable);
+	}
 
 out:
 	scan_time = ktime_to_ns(ktime_sub(ktime_get(), start_time));
@@ -1227,12 +1246,12 @@ void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi)
 }
 
 static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
-				       int nr_to_scan)
+				       struct list_head *freeable,
+				       int *nr_to_scan)
 {
 	struct inode *inode = &ei->vfs_inode;
 	struct ext4_es_tree *tree = &ei->i_es_tree;
-	struct rb_node *node;
-	struct extent_status *es;
+	struct extent_status *es, *tmp;
 	unsigned long nr_shrunk = 0;
 	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
@@ -1244,21 +1263,12 @@ static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
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
+	list_for_each_entry_safe(es, tmp, &tree->list, list) {
+		rb_erase(&es->rb_node, &tree->root);
+		list_move_tail(&es->list, freeable);
+		nr_shrunk++;
+		if (--*nr_to_scan == 0)
+			break;
 	}
 	tree->cache_es = NULL;
 	return nr_shrunk;
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index 0e6a33e..a45c7fe 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -54,6 +54,7 @@ struct ext4_extent;
 
 struct extent_status {
 	struct rb_node rb_node;
+	struct list_head list;
 	ext4_lblk_t es_lblk;	/* first logical block extent covers */
 	ext4_lblk_t es_len;	/* length of extent in block */
 	ext4_fsblk_t es_pblk;	/* first physical block */
@@ -61,6 +62,7 @@ struct extent_status {
 
 struct ext4_es_tree {
 	struct rb_root root;
+	struct list_head list;
 	struct extent_status *cache_es;	/* recently accessed extent */
 };
 
-- 
1.7.9.7

