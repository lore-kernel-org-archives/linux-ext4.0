From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Use an rbtree for tracking blocks freed during
	transaction.
Date: Mon, 19 Jan 2009 17:05:37 +0530
Message-ID: <20090119113537.GF9482@skywalker>
References: <E1LOG9D-0006h4-7R@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:49652 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbZASLfo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Jan 2009 06:35:44 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp08.in.ibm.com (8.13.1/8.13.1) with ESMTP id n0JBJU3N004293
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 16:49:30 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0JBXjpL389192
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 17:03:45 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id n0JBZfcC030754
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 17:05:41 +0530
Content-Disposition: inline
In-Reply-To: <E1LOG9D-0006h4-7R@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Use an rbtree for tracking blocks freed during transaction.

With this patch we track the block freed during a transaction using
red-black tree.  We also make sure contiguous blocks freed are collected
in one node in the tree.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

---
 fs/ext4/mballoc.c |  185 ++++++++++++++++++++++++++++++++++-------------------
 fs/ext4/mballoc.h |   25 ++++---
 2 files changed, 133 insertions(+), 77 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index dd7a092..93e4c09 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -332,6 +332,7 @@
  */
 static struct kmem_cache *ext4_pspace_cachep;
 static struct kmem_cache *ext4_ac_cachep;
+static struct kmem_cache *ext4_free_ext_cachep;
 static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group);
 static int ext4_mb_init_per_dev_proc(struct super_block *sb);
@@ -2512,6 +2513,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 
 	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
 	init_rwsem(&meta_group_info[i]->alloc_sem);
+	meta_group_info[i]->bb_free_root.rb_node = NULL;;
 
 #ifdef DOUBLE_CHECK
 	{
@@ -2825,13 +2827,11 @@ int ext4_mb_release(struct super_block *sb)
 static noinline_for_stack void
 ext4_mb_free_committed_blocks(struct super_block *sb)
 {
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	int err;
-	int i;
-	int count = 0;
-	int count2 = 0;
-	struct ext4_free_metadata *md;
 	struct ext4_buddy e4b;
+	struct ext4_group_info *db;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int err, count = 0, count2 = 0;
+	struct ext4_free_data *entry;
 
 	if (list_empty(&sbi->s_committed_transaction))
 		return;
@@ -2839,44 +2839,46 @@ ext4_mb_free_committed_blocks(struct super_block *sb)
 	/* there is committed blocks to be freed yet */
 	do {
 		/* get next array of blocks */
-		md = NULL;
+		entry = NULL;
 		spin_lock(&sbi->s_md_lock);
 		if (!list_empty(&sbi->s_committed_transaction)) {
-			md = list_entry(sbi->s_committed_transaction.next,
-					struct ext4_free_metadata, list);
-			list_del(&md->list);
+			entry = list_entry(sbi->s_committed_transaction.next,
+					struct ext4_free_data, list);
+			list_del(&entry->list);
 		}
 		spin_unlock(&sbi->s_md_lock);
 
-		if (md == NULL)
+		if (entry == NULL)
 			break;
 
 		mb_debug("gonna free %u blocks in group %lu (0x%p):",
-				md->num, md->group, md);
+				entry->count, entry->group, entry);
 
-		err = ext4_mb_load_buddy(sb, md->group, &e4b);
+		err = ext4_mb_load_buddy(sb, entry->group, &e4b);
 		/* we expect to find existing buddy because it's pinned */
 		BUG_ON(err != 0);
 
+		db = e4b.bd_info;
 		/* there are blocks to put in buddy to make them really free */
-		count += md->num;
+		count += entry->count;
 		count2++;
-		ext4_lock_group(sb, md->group);
-		for (i = 0; i < md->num; i++) {
-			mb_debug(" %u", md->blocks[i]);
-			mb_free_blocks(NULL, &e4b, md->blocks[i], 1);
+		ext4_lock_group(sb, entry->group);
+		/* Take it out of per group rb tree */
+		rb_erase(&entry->node, &(db->bb_free_root));
+		mb_free_blocks(NULL, &e4b, entry->start_blk, entry->count);
+
+		if (!db->bb_free_root.rb_node) {
+			/* No more items in the per group rb tree
+			 * balance refcounts from ext4_mb_free_metadata()
+			 */
+			page_cache_release(e4b.bd_buddy_page);
+			page_cache_release(e4b.bd_bitmap_page);
 		}
-		mb_debug("\n");
-		ext4_unlock_group(sb, md->group);
-
-		/* balance refcounts from ext4_mb_free_metadata() */
-		page_cache_release(e4b.bd_buddy_page);
-		page_cache_release(e4b.bd_bitmap_page);
+		ext4_unlock_group(sb, entry->group);
 
-		kfree(md);
+		kmem_cache_free(ext4_free_ext_cachep, entry);
 		ext4_mb_release_desc(&e4b);
-
-	} while (md);
+	} while (1);
 
 	mb_debug("freed %u blocks in %u structures\n", count, count2);
 }
@@ -3047,6 +3049,7 @@ void exit_ext4_mballoc(void)
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("fs/ext4", NULL);
 #endif
+	kmem_cache_destroy(ext4_free_ext_cachep);
 }
 
 
@@ -3566,6 +3569,16 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 		ac->ac_criteria = 20;
 		return 1;
 	}
+
+	ext4_free_ext_cachep =
+		kmem_cache_create("ext4_free_block_extents",
+				     sizeof(struct ext4_free_data),
+				     0, SLAB_RECLAIM_ACCOUNT, NULL);
+	if (ext4_free_ext_cachep == NULL) {
+		kmem_cache_destroy(ext4_pspace_cachep);
+		kmem_cache_destroy(ext4_ac_cachep);
+		return -ENOMEM;
+	}
 	return 0;
 }
 
@@ -4690,6 +4703,21 @@ static void ext4_mb_poll_new_transaction(struct super_block *sb,
 	ext4_mb_free_committed_blocks(sb);
 }
 
+/*
+ * We can merge two free data extents only if the physical blocks
+ * are contiguous, AND the extents were freed by the same transaction,
+ * AND the blocks are associated with the same group.
+ */
+static int can_merge(struct ext4_free_data *entry1,
+			struct ext4_free_data *entry2)
+{
+	if ((entry1->t_tid == entry2->t_tid) &&
+	    (entry1->group == entry2->group) &&
+	    ((entry1->start_blk + entry1->count) == entry2->start_blk))
+		return 1;
+	return 0;
+}
+
 static noinline_for_stack int
 ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 			  ext4_group_t group, ext4_grpblk_t block, int count)
@@ -4697,57 +4725,80 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 	struct ext4_group_info *db = e4b->bd_info;
 	struct super_block *sb = e4b->bd_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct ext4_free_metadata *md;
-	int i;
+	struct ext4_free_data *entry, *new_entry;
+	struct rb_node **n = &db->bb_free_root.rb_node, *node;
+	struct rb_node *parent = NULL, *new_node;
+
 
 	BUG_ON(e4b->bd_bitmap_page == NULL);
 	BUG_ON(e4b->bd_buddy_page == NULL);
 
+	new_entry  = kmem_cache_alloc(ext4_free_ext_cachep, GFP_NOFS);
+	new_entry->start_blk = block;
+	new_entry->group  = group;
+	new_entry->count = count;
+	new_entry->t_tid = handle->h_transaction->t_tid;
+	new_node = &new_entry->node;
+
 	ext4_lock_group(sb, group);
-	for (i = 0; i < count; i++) {
-		md = db->bb_md_cur;
-		if (md && db->bb_tid != handle->h_transaction->t_tid) {
-			db->bb_md_cur = NULL;
-			md = NULL;
+	if (!*n) {
+		/* first free block exent. We need to
+		   protect buddy cache from being freed,
+		 * otherwise we'll refresh it from
+		 * on-disk bitmap and lose not-yet-available
+		 * blocks */
+		page_cache_get(e4b->bd_buddy_page);
+		page_cache_get(e4b->bd_bitmap_page);
+	}
+	while (*n) {
+		parent = *n;
+		entry = rb_entry(parent, struct ext4_free_data, node);
+		if (block < entry->start_blk)
+			n = &(*n)->rb_left;
+		else if (block >= (entry->start_blk + entry->count))
+			n = &(*n)->rb_right;
+		else {
+			ext4_error(sb, __func__,
+			    "Double free of blocks %d (%d %d)\n",
+			    block, entry->start_blk, entry->count);
+			return 0;
 		}
+	}
 
-		if (md == NULL) {
-			ext4_unlock_group(sb, group);
-			md = kmalloc(sizeof(*md), GFP_NOFS);
-			if (md == NULL)
-				return -ENOMEM;
-			md->num = 0;
-			md->group = group;
-
-			ext4_lock_group(sb, group);
-			if (db->bb_md_cur == NULL) {
-				spin_lock(&sbi->s_md_lock);
-				list_add(&md->list, &sbi->s_active_transaction);
-				spin_unlock(&sbi->s_md_lock);
-				/* protect buddy cache from being freed,
-				 * otherwise we'll refresh it from
-				 * on-disk bitmap and lose not-yet-available
-				 * blocks */
-				page_cache_get(e4b->bd_buddy_page);
-				page_cache_get(e4b->bd_bitmap_page);
-				db->bb_md_cur = md;
-				db->bb_tid = handle->h_transaction->t_tid;
-				mb_debug("new md 0x%p for group %lu\n",
-						md, md->group);
-			} else {
-				kfree(md);
-				md = db->bb_md_cur;
-			}
+	rb_link_node(new_node, parent, n);
+	rb_insert_color(new_node, &db->bb_free_root);
+
+	/* Now try to see the extent can be merged to left and right */
+	node = rb_prev(new_node);
+	if (node) {
+		entry = rb_entry(node, struct ext4_free_data, node);
+		if (can_merge(entry, new_entry)) {
+			new_entry->start_blk = entry->start_blk;
+			new_entry->count += entry->count;
+			rb_erase(node, &(db->bb_free_root));
+			spin_lock(&sbi->s_md_lock);
+			list_del(&entry->list);
+			spin_unlock(&sbi->s_md_lock);
+			kmem_cache_free(ext4_free_ext_cachep, entry);
 		}
+	}
 
-		BUG_ON(md->num >= EXT4_BB_MAX_BLOCKS);
-		md->blocks[md->num] = block + i;
-		md->num++;
-		if (md->num == EXT4_BB_MAX_BLOCKS) {
-			/* no more space, put full container on a sb's list */
-			db->bb_md_cur = NULL;
+	node = rb_next(new_node);
+	if (node) {
+		entry = rb_entry(node, struct ext4_free_data, node);
+		if (can_merge(new_entry, entry)) {
+			new_entry->count += entry->count;
+			rb_erase(node, &(db->bb_free_root));
+			spin_lock(&sbi->s_md_lock);
+			list_del(&entry->list);
+			spin_unlock(&sbi->s_md_lock);
+			kmem_cache_free(ext4_free_ext_cachep, entry);
 		}
 	}
+	/* Add the extent to active_transaction list */
+	spin_lock(&sbi->s_md_lock);
+	list_add(&new_entry->list, &sbi->s_active_transaction);
+	spin_unlock(&sbi->s_md_lock);
 	ext4_unlock_group(sb, group);
 	return 0;
 }
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 9a020e6..0a28dd3 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -97,22 +97,27 @@
  */
 #define MB_DEFAULT_GROUP_PREALLOC	512
 
-#ifdef EXT4_BB_MAX_BLOCKS
-#undef EXT4_BB_MAX_BLOCKS
-#endif
-#define EXT4_BB_MAX_BLOCKS	30
+struct ext4_free_data {
+	/* this links the free block information from group_info */
+	struct rb_node node;
 
-struct ext4_free_metadata {
-	ext4_group_t group;
-	unsigned short num;
-	ext4_grpblk_t  blocks[EXT4_BB_MAX_BLOCKS];
+	/* this links the free block information from ext4_sb_info */
 	struct list_head list;
+
+	/* group which free block extent belongs */
+	ext4_group_t group;
+
+	/* free block extent */
+	ext4_grpblk_t start_blk;
+	ext4_grpblk_t count;
+
+	/* transaction which freed this extent */
+	tid_t	t_tid;
 };
 
 struct ext4_group_info {
 	unsigned long	bb_state;
-	unsigned long	bb_tid;
-	struct ext4_free_metadata *bb_md_cur;
+	struct rb_root  bb_free_root;
 	unsigned short	bb_first_free;
 	unsigned short	bb_free;
 	unsigned short	bb_fragments;
-- 
tg: (5d9c0a4..) use-rb-tree-for-free-blocks-tracking (depends on: aneesh-3-use_EXT4_GROUP_INFO_NEED_INIT_BIT-during-resize)
