From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 10/10 v3] ext4: reclaim extents from extent status tree
Date: Wed, 23 Jan 2013 20:04:00 +0800
Message-ID: <1358942640-2262-11-git-send-email-wenqing.lz@taobao.com>
References: <1358942640-2262-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:35020 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab3AWLvM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jan 2013 06:51:12 -0500
In-Reply-To: <1358942640-2262-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Although extent status is loaded on-demand, we also need to reclaim
extent from the tree when we are under a heavy memory pressure because
in some cases fragmented extent tree causes status tree costs too much
memory.

Here we maintain a lru list in super_block.  When the extent status of
an inode is accessed and changed, this inode will be move to the tail
of the list.  The inode will be dropped from this list when it is
cleared.  In the inode, a counter is added to count the number of
cached objects in extent status tree.  Here only written/unwritten
extent is counted because delayed extent doesn't be reclaimed due to
fiemap, bigalloc and seek_data/hole need it.  The counter will be
increased as a new extent is allocated, and it will be decreased as a
extent is freed.

In this commit we define nr_cached_objects and free_cached_objects
callback functions in order to reclaim extents from the tree.  In
nr_cached_objects, every inodes in lru list are traversed and all
counters are counted.  In free_cached_objects, we traverse every inodes
in the list and reclaim all written/unwritten extents from the extent
status tree of the inode until the number of reclaimed objects is equal
to nr_to_scan or all cached objects are reclaimed.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h              |   6 +++
 fs/ext4/extents_status.c    | 118 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/extents_status.h    |   5 ++
 fs/ext4/super.c             |  19 +++++++
 include/trace/events/ext4.h |  40 +++++++++++++++
 5 files changed, 188 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 60d16d1..317aa0b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -881,6 +881,8 @@ struct ext4_inode_info {
 	/* extents status tree */
 	struct ext4_es_tree i_es_tree;
 	rwlock_t i_es_lock;
+	struct list_head i_es_lru;
+	unsigned int i_es_lru_nr;	/* protected by i_es_lock */
 
 	/* ialloc */
 	ext4_group_t	i_last_alloc_group;
@@ -1296,6 +1298,10 @@ struct ext4_sb_info {
 
 	/* Precomputed FS UUID checksum for seeding other checksums */
 	__u32 s_csum_seed;
+
+	/* Reclaim extents from extent status tree */
+	struct list_head s_es_lru;
+	spinlock_t s_es_lru_lock ____cacheline_aligned_in_smp;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index badfaa2..dbdcb2b 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -145,6 +145,8 @@ static struct kmem_cache *ext4_es_cachep;
 static int __es_insert_extent(struct inode *inode, struct extent_status *newes);
 static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 			      ext4_lblk_t end);
+static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
+				       int nr_to_scan);
 
 int __init ext4_init_es(void)
 {
@@ -280,6 +282,7 @@ out:
 
 	read_unlock(&EXT4_I(inode)->i_es_lock);
 
+	ext4_es_lru_add(inode);
 	trace_ext4_es_find_extent_exit(inode, es, ret);
 	return ret;
 }
@@ -296,11 +299,24 @@ ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
 	es->es_len = len;
 	es->es_pblk = pblk;
 	es->es_status = status;
+
+	/*
+	 * We don't count delayed extent because we never try to reclaim them
+	 */
+	if (!ext4_es_is_delayed(es))
+		EXT4_I(inode)->i_es_lru_nr++;
+
 	return es;
 }
 
 static void ext4_es_free_extent(struct inode *inode, struct extent_status *es)
 {
+	/* Decrease the lru count when this es is not delayed */
+	if (!ext4_es_is_delayed(es)) {
+		BUG_ON(EXT4_I(inode)->i_es_lru_nr == 0);
+		EXT4_I(inode)->i_es_lru_nr--;
+	}
+
 	kmem_cache_free(ext4_es_cachep, es);
 }
 
@@ -453,6 +469,7 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 error:
 	write_unlock(&EXT4_I(inode)->i_es_lock);
 
+	ext4_es_lru_add(inode);
 	ext4_es_print_tree(inode);
 
 	return err;
@@ -513,6 +530,7 @@ out:
 
 	read_unlock(&EXT4_I(inode)->i_es_lock);
 
+	ext4_es_lru_add(inode);
 	trace_ext4_es_lookup_extent_exit(inode, es, found);
 	return found;
 }
@@ -626,3 +644,103 @@ int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 	ext4_es_print_tree(inode);
 	return err;
 }
+
+void ext4_es_lru_add(struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+
+	spin_lock(&sbi->s_es_lru_lock);
+	if (list_empty(&ei->i_es_lru))
+		list_add_tail(&ei->i_es_lru, &sbi->s_es_lru);
+	else
+		list_move_tail(&ei->i_es_lru, &sbi->s_es_lru);
+	spin_unlock(&sbi->s_es_lru_lock);
+}
+
+void ext4_es_lru_del(struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+
+	spin_lock(&sbi->s_es_lru_lock);
+	if (!list_empty(&ei->i_es_lru))
+		list_del_init(&ei->i_es_lru);
+	spin_unlock(&sbi->s_es_lru_lock);
+}
+
+int ext4_es_reclaim_extents_count(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_inode_info *ei;
+	struct list_head *cur;
+	int nr_cached = 0;
+
+	spin_lock(&sbi->s_es_lru_lock);
+	list_for_each(cur, &sbi->s_es_lru) {
+		ei = list_entry(cur, struct ext4_inode_info, i_es_lru);
+		read_lock(&ei->i_es_lock);
+		nr_cached += ei->i_es_lru_nr;
+		read_unlock(&ei->i_es_lock);
+	}
+	spin_unlock(&sbi->s_es_lru_lock);
+	trace_ext4_es_reclaim_extents_count(sb, nr_cached);
+	return nr_cached;
+}
+
+static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
+				       int nr_to_scan)
+{
+	struct inode *inode = &ei->vfs_inode;
+	struct ext4_es_tree *tree = &ei->i_es_tree;
+	struct rb_node *node;
+	struct extent_status *es;
+	int nr_shrunk = 0;
+
+	if (ei->i_es_lru_nr == 0)
+		return 0;
+
+	node = rb_first(&tree->root);
+	while (node != NULL) {
+		es = rb_entry(node, struct extent_status, rb_node);
+		node = rb_next(&es->rb_node);
+		/*
+		 * We can't reclaim delayed extent from status tree because
+		 * fiemap, bigallic, and seek_data/hole need to use it.
+		 */
+		if (!ext4_es_is_delayed(es)) {
+			rb_erase(&es->rb_node, &tree->root);
+			ext4_es_free_extent(inode, es);
+			nr_shrunk++;
+			if (--nr_to_scan == 0)
+				break;
+		}
+	}
+	tree->cache_es = NULL;
+	return nr_shrunk;
+}
+
+void ext4_es_reclaim_extents(struct super_block *sb, int nr_to_scan)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_inode_info *ei;
+	struct list_head *cur;
+
+	trace_ext4_es_reclaim_extents(sb, nr_to_scan);
+	spin_lock(&sbi->s_es_lru_lock);
+	list_for_each(cur, &sbi->s_es_lru) {
+		ei = list_entry(cur, struct ext4_inode_info, i_es_lru);
+		read_lock(&ei->i_es_lock);
+		if (ei->i_es_lru_nr == 0) {
+			read_unlock(&ei->i_es_lock);
+			continue;
+		}
+		read_unlock(&ei->i_es_lock);
+		write_lock(&ei->i_es_lock);
+		nr_to_scan -= __es_try_to_reclaim_extents(ei, nr_to_scan);
+		write_unlock(&ei->i_es_lock);
+		if (nr_to_scan == 0)
+			break;
+	}
+	spin_unlock(&sbi->s_es_lru_lock);
+}
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index 6350d35..17e7a28 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -77,4 +77,9 @@ static inline ext4_fsblk_t ext4_es_get_pblock(struct extent_status *es,
 	return (ext4_es_is_delayed(es) ? ~0 : pb);
 }
 
+extern void ext4_es_lru_add(struct inode *inode);
+extern void ext4_es_lru_del(struct inode *inode);
+extern int ext4_es_reclaim_extents_count(struct super_block *sb);
+extern void ext4_es_reclaim_extents(struct super_block *sb, int nr_to_scan);
+
 #endif /* _EXT4_EXTENTS_STATUS_H */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a35c6c1..3a2c3a7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -943,6 +943,8 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	spin_lock_init(&ei->i_prealloc_lock);
 	ext4_es_init_tree(&ei->i_es_tree);
 	rwlock_init(&ei->i_es_lock);
+	INIT_LIST_HEAD(&ei->i_es_lru);
+	ei->i_es_lru_nr = 0;
 	ei->i_reserved_data_blocks = 0;
 	ei->i_reserved_meta_blocks = 0;
 	ei->i_allocated_meta_blocks = 0;
@@ -1030,6 +1032,7 @@ void ext4_clear_inode(struct inode *inode)
 	dquot_drop(inode);
 	ext4_discard_preallocations(inode);
 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
+	ext4_es_lru_del(inode);
 	if (EXT4_I(inode)->jinode) {
 		jbd2_journal_release_jbd_inode(EXT4_JOURNAL(inode),
 					       EXT4_I(inode)->jinode);
@@ -1101,6 +1104,16 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
 	return try_to_free_buffers(page);
 }
 
+static int nr_cached_objects(struct super_block *sb)
+{
+	return ext4_es_reclaim_extents_count(sb);
+}
+
+static void free_cached_objects(struct super_block *sb, int nr_to_scan)
+{
+	ext4_es_reclaim_extents(sb, nr_to_scan);
+}
+
 #ifdef CONFIG_QUOTA
 #define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
 #define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
@@ -1176,6 +1189,8 @@ static const struct super_operations ext4_sops = {
 	.quota_write	= ext4_quota_write,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
+	.nr_cached_objects = nr_cached_objects,
+	.free_cached_objects = free_cached_objects,
 };
 
 static const struct super_operations ext4_nojournal_sops = {
@@ -1194,6 +1209,8 @@ static const struct super_operations ext4_nojournal_sops = {
 	.quota_write	= ext4_quota_write,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
+	.nr_cached_objects = nr_cached_objects,
+	.free_cached_objects = free_cached_objects,
 };
 
 static const struct export_operations ext4_export_ops = {
@@ -3770,6 +3787,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_stripe = ext4_get_stripe_size(sbi);
 	sbi->s_max_writeback_mb_bump = 128;
 	sbi->s_extent_max_zeroout_kb = 32;
+	INIT_LIST_HEAD(&sbi->s_es_lru);
+	spin_lock_init(&sbi->s_es_lru_lock);
 
 	/*
 	 * set up enough so that it can read an inode
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index f23c177..816f0ae 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -2233,6 +2233,46 @@ TRACE_EVENT(ext4_es_lookup_extent_exit,
 		  __entry->found ? __entry->status : 0)
 );
 
+TRACE_EVENT(ext4_es_reclaim_extents_count,
+	TP_PROTO(struct super_block *sb, int nr_cached),
+
+	TP_ARGS(sb, nr_cached),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	int,	nr_cached		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= sb->s_dev;
+		__entry->nr_cached	= nr_cached;
+	),
+
+	TP_printk("dev %d,%d cached objects nr %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->nr_cached)
+);
+
+TRACE_EVENT(ext4_es_reclaim_extents,
+	TP_PROTO(struct super_block *sb, int nr_to_scan),
+
+	TP_ARGS(sb, nr_to_scan),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	int,	nr_to_scan		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= sb->s_dev;
+		__entry->nr_to_scan	= nr_to_scan;
+	),
+
+	TP_printk("dev %d,%d nr to scan %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->nr_to_scan)
+);
+
 #endif /* _TRACE_EXT4_H */
 
 /* This part must be outside protection */
-- 
1.7.12.rc2.18.g61b472e

