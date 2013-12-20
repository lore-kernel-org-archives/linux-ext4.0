From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC PATCH 2/2] ext4: improve extents status tree shrinker to avoid scanning delayed entries
Date: Fri, 20 Dec 2013 18:42:45 +0800
Message-ID: <1387536165-15956-3-git-send-email-wenqing.lz@taobao.com>
References: <1387536165-15956-1-git-send-email-wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:51133 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631Ab3LTKjg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Dec 2013 05:39:36 -0500
Received: by mail-pb0-f44.google.com with SMTP id rq2so2443441pbb.17
        for <linux-ext4@vger.kernel.org>; Fri, 20 Dec 2013 02:39:35 -0800 (PST)
In-Reply-To: <1387536165-15956-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

The extents status tree shrinker will scan all inodes on sbi->s_es_lru
under heavy memory pressure, and try to reclaim the entry from extents
status tree.  During this process it couldn't reclaim the delayed entry
because ext4 needs to use these entries to do delayed allocation space
reservation, seek_data/hole, etc....  So if a system has done a huge
number of writes and these dirty pages don't be written out.  There will
be a lot of delayed entries on extents status tree.  If shrinker tries
to reclaim memory from the tree, it will burn some CPU time to iterate
on these non-reclaimable entries.  At some circumstances it could cause
excessive stall time.

In this commit a new list is used to track reclaimable entries of extent
status tree (e.g. written/unwritten/hole entries).  The shrinker will
scan reclaimable entry on this list.  So it won't encouter any delayed
entry and don't need to take too much time to spin.  But the defect is
that we need to cost extra 1/3 memory space for one entry.  Before this
commit, 'struct extent_status' occupies 48 bytes on a 64bits platform.
After that it will occupy 64 bytes. :(

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents_status.c |   38 +++++++++++++++++++-------------------
 fs/ext4/extents_status.h |    2 ++
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index e842d74..11bdb2f 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -169,6 +169,7 @@ void ext4_exit_es(void)
 void ext4_es_init_tree(struct ext4_es_tree *tree)
 {
 	tree->root = RB_ROOT;
+	INIT_HLIST_HEAD(&tree->evictable_list);
 	tree->cache_es = NULL;
 }
 
@@ -300,10 +301,14 @@ static struct extent_status *
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
@@ -312,8 +317,9 @@ ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
 	 * We don't count delayed extent because we never try to reclaim them
 	 */
 	if (!ext4_es_is_delayed(es)) {
-		EXT4_I(inode)->i_es_lru_nr++;
+		ei->i_es_lru_nr++;
 		percpu_counter_inc(&EXT4_SB(inode->i_sb)->s_extent_cache_cnt);
+		hlist_add_head(&es->es_list, &ei->i_es_tree.evictable_list);
 	}
 
 	return es;
@@ -321,10 +327,12 @@ ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
 
 static void ext4_es_free_extent(struct inode *inode, struct extent_status *es)
 {
+	struct ext4_inode_info *ei = EXT4_I(inode);
+
 	/* Decrease the lru counter when this es is not delayed */
 	if (!ext4_es_is_delayed(es)) {
-		BUG_ON(EXT4_I(inode)->i_es_lru_nr == 0);
-		EXT4_I(inode)->i_es_lru_nr--;
+		BUG_ON(ei->i_es_lru_nr-- == 0);
+		hlist_del_init(&es->es_list);
 		percpu_counter_dec(&EXT4_SB(inode->i_sb)->s_extent_cache_cnt);
 	}
 
@@ -1092,8 +1100,8 @@ static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
 {
 	struct inode *inode = &ei->vfs_inode;
 	struct ext4_es_tree *tree = &ei->i_es_tree;
-	struct rb_node *node;
 	struct extent_status *es;
+	struct hlist_node *tmp;
 	unsigned long nr_shrunk = 0;
 	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
@@ -1105,21 +1113,13 @@ static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
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
index 167f4ab8..38ca83e 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -54,6 +54,7 @@ struct ext4_extent;
 
 struct extent_status {
 	struct rb_node rb_node;
+	struct hlist_node es_list;
 	ext4_lblk_t es_lblk;	/* first logical block extent covers */
 	ext4_lblk_t es_len;	/* length of extent in block */
 	ext4_fsblk_t es_pblk;	/* first physical block */
@@ -61,6 +62,7 @@ struct extent_status {
 
 struct ext4_es_tree {
 	struct rb_root root;
+	struct hlist_head evictable_list;
 	struct extent_status *cache_es;	/* recently accessed extent */
 };
 
-- 
1.7.9.7

