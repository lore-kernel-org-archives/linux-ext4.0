From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4 - using
 rbtree
Date: Mon, 26 Apr 2010 20:38:09 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1004262036070.29999@localhost>
References: <1271674527-2977-2-git-send-email-lczerner@redhat.com> <1271674527-2977-3-git-send-email-lczerner@redhat.com> <r2k87f94c371004201421se796c0ekbae28495e62a9eb7@mail.gmail.com> <4BCE6243.5010209@teksavvy.com> <4BCE66C5.3060906@redhat.com>
 <v2w87f94c371004211159ue3a48923u6a543e8090dcdfa6@mail.gmail.com> <4BCF4C53.3010608@redhat.com> <x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com> <k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com> <alpine.LFD.2.00.1004230944070.2814@localhost>
 <20100426165527.GB21179@atrey.karlin.mff.cuni.cz> <alpine.LFD.2.00.1004261903260.2797@localhost> <4BD5D2EA.1070008@redhat.com> <alpine.LFD.2.00.1004261957001.29999@localhost> <x49hbmy2hmz.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>, Jan Kara <jack@suse.cz>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Mark Lord <kernel@teksavvy.com>, linux-ext4@vger.kernel.org,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab0DZSiR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Apr 2010 14:38:17 -0400
In-Reply-To: <x49hbmy2hmz.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create an ioctl which walks through all the free extents in each
allocating group and discard those extents. As an addition to improve
its performance one can specify minimum free extent length, so ioctl
will not bother with shorter extents.

This of course means, that with each invocation the ioctl must walk
through whole file system, checking and discarding free extents, which
is not very efficient. The best way to avoid this is to keep track of
deleted (freed) blocks. Then the ioctl have to trim just those free
extents which were recently freed.

In order to implement this I have created new structure
ext4_deleted_data which represents deleted extent in per-group rbtree.
When blocks are freed, extents are stored in the tree (possibly merged
with other extents). The ioctl then can walk through the tree, take out
extents from the tree, compare them with the free extents and possibly
trim them.

Note that there is support for setting minimum extent length in ioctl
call, so it will not bother with shorter extents. Also, when the
previously deleted range is taken from the tree and it is not entirely
free, the free fragments are discarded and extents shorter than minlen
are NOT returned back to the tree to avoid fragmentation of the tree
which could lead to the big memory consumption.

But you may notice, that there is one problem. bb_bitmap_deleted does
not survive umount. To bypass the problem the first ioctl call have to
walk through whole file system trimming all free extents.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ext4.h    |    5 +
 fs/ext4/mballoc.c |  321 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ext4/mballoc.h |    9 ++
 fs/ext4/super.c   |    1 +
 4 files changed, 325 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bf938cf..41fe9ec 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1437,6 +1437,8 @@ extern int ext4_mb_add_groupinfo(struct super_block *sb,
 extern int ext4_mb_get_buddy_cache_lock(struct super_block *, ext4_group_t);
 extern void ext4_mb_put_buddy_cache_lock(struct super_block *,
 						ext4_group_t, int);
+extern int ext4_trim_fs(unsigned int, struct super_block *);
+
 /* inode.c */
 struct buffer_head *ext4_getblk(handle_t *, struct inode *,
 						ext4_lblk_t, int, int *);
@@ -1682,6 +1684,9 @@ struct ext4_group_info {
 #ifdef DOUBLE_CHECK
 	void            *bb_bitmap;
 #endif
+	ext4_grpblk_t	bb_deleted;
+	struct rb_root  bb_deleted_root;
+
 	struct rw_semaphore alloc_sem;
 	ext4_grpblk_t	bb_counters[];	/* Nr of free power-of-two-block
 					 * regions, index is order.
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b423a36..ebfe9d8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -338,6 +338,7 @@
 static struct kmem_cache *ext4_pspace_cachep;
 static struct kmem_cache *ext4_ac_cachep;
 static struct kmem_cache *ext4_free_ext_cachep;
+static struct kmem_cache *ext4_deleted_ext_cachep;
 static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group);
 static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
@@ -2255,6 +2256,10 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
 	init_rwsem(&meta_group_info[i]->alloc_sem);
 	meta_group_info[i]->bb_free_root = RB_ROOT;
+	meta_group_info[i]->bb_deleted_root = RB_ROOT;
+	meta_group_info[i]->bb_deleted = -1;
+
+
 
 #ifdef DOUBLE_CHECK
 	{
@@ -2516,6 +2521,106 @@ int ext4_mb_release(struct super_block *sb)
 	return 0;
 }
 
+static int can_merge_deleted(struct ext4_deleted_data *entry1,
+				struct ext4_deleted_data *entry2)
+{
+	if (((entry1->start_blk + entry1->count) >= entry2->start_blk))
+		return 1;
+	return 0;
+}
+
+static int store_deleted_entry(struct ext4_free_data *free_entry,
+				struct ext4_group_info *db)
+{
+	struct rb_node **n = &db->bb_deleted_root.rb_node, *node;
+	struct rb_node *parent = NULL, *new_node;
+	ext4_grpblk_t block, blk_end;
+	struct ext4_deleted_data *new_entry;
+	int count = 0;
+
+	block = free_entry->start_blk;
+	blk_end = free_entry->start_blk + free_entry->count;
+
+	/* Find out where to put the new entry */
+	while (*n) {
+		struct ext4_deleted_data *entry;
+
+		parent = *n;
+		entry = rb_entry(parent, struct ext4_deleted_data, node);
+		if ((block >= entry->start_blk) &&
+			 (blk_end <= (entry->start_blk + entry->count))) {
+			/* Embedded interval */
+			return count;
+		} else if (block < entry->start_blk)
+			n = &(*n)->rb_left;
+		else if (block >= entry->start_blk)
+			n = &(*n)->rb_right;
+		else
+			break;
+	}
+
+	/* Allocate and insert the new entry */
+	new_entry = kmem_cache_alloc(ext4_deleted_ext_cachep, GFP_NOFS);
+	new_entry->start_blk = free_entry->start_blk;
+	new_entry->count = count = free_entry->count;
+
+	new_node = &new_entry->node;
+
+	rb_link_node(new_node, parent, n);
+	rb_insert_color(new_node, &db->bb_deleted_root);
+
+	/* Now lets see if the new entry can be merged to left */
+	node = rb_prev(new_node);
+	if (node) {
+		struct ext4_deleted_data *entry;
+
+		entry = rb_entry(node, struct ext4_deleted_data, node);
+		if (can_merge_deleted(entry, new_entry)) {
+			count -= entry->count;
+
+
+			new_entry->count = count =
+				(new_entry->count + new_entry->start_blk)
+				- entry->start_blk;
+			new_entry->start_blk = entry->start_blk;
+
+
+			rb_erase(node, &(db->bb_deleted_root));
+			kmem_cache_free(ext4_deleted_ext_cachep, entry);
+		}
+	}
+
+	/*
+	 * Lets see if the new entry can be merged to the right
+	 * There can be multiple merges as the new entry's interval
+	 * can overlap other entries.
+	 */
+	node = rb_next(new_node);
+	while (node) {
+		struct ext4_deleted_data *entry;
+
+		entry = rb_entry(node, struct ext4_deleted_data, node);
+		if (can_merge_deleted(new_entry, entry)) {
+			ext4_grpblk_t new_count;
+			count -= entry->count;
+
+			new_count = (entry->start_blk + entry->count)
+				- new_entry->start_blk;
+			if (new_count > new_entry->count)
+				new_entry->count = new_count;
+
+			rb_erase(node, &(db->bb_deleted_root));
+			kmem_cache_free(ext4_deleted_ext_cachep, entry);
+		} else {
+			/* No more merging needed */
+			break;
+		}
+		node = rb_next(new_node);
+	}
+
+	return count;
+}
+
 /*
  * This function is called by the jbd2 layer once the commit has finished,
  * so we know we can free the blocks that were released with that commit.
@@ -2535,17 +2640,6 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 		mb_debug(1, "gonna free %u blocks in group %u (0x%p):",
 			 entry->count, entry->group, entry);
 
-		if (test_opt(sb, DISCARD)) {
-			ext4_fsblk_t discard_block;
-
-			discard_block = entry->start_blk +
-				ext4_group_first_block_no(sb, entry->group);
-			trace_ext4_discard_blocks(sb,
-					(unsigned long long)discard_block,
-					entry->count);
-			sb_issue_discard(sb, discard_block, entry->count);
-		}
-
 		err = ext4_mb_load_buddy(sb, entry->group, &e4b);
 		/* we expect to find existing buddy because it's pinned */
 		BUG_ON(err != 0);
@@ -2554,6 +2648,7 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 		/* there are blocks to put in buddy to make them really free */
 		count += entry->count;
 		count2++;
+
 		ext4_lock_group(sb, entry->group);
 		/* Take it out of per group rb tree */
 		rb_erase(&entry->node, &(db->bb_free_root));
@@ -2566,6 +2661,9 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 			page_cache_release(e4b.bd_buddy_page);
 			page_cache_release(e4b.bd_bitmap_page);
 		}
+		if (test_opt(sb, DISCARD) && (db->bb_deleted >= 0))
+			db->bb_deleted += store_deleted_entry(entry, db);
+
 		ext4_unlock_group(sb, entry->group);
 		kmem_cache_free(ext4_free_ext_cachep, entry);
 		ext4_mb_release_desc(&e4b);
@@ -2635,6 +2733,17 @@ int __init init_ext4_mballoc(void)
 		kmem_cache_destroy(ext4_ac_cachep);
 		return -ENOMEM;
 	}
+
+	ext4_deleted_ext_cachep =
+		kmem_cache_create("ext4_deleted_block_extents",
+				     sizeof(struct ext4_deleted_data),
+				     0, SLAB_RECLAIM_ACCOUNT, NULL);
+	if (ext4_deleted_ext_cachep == NULL) {
+		kmem_cache_destroy(ext4_pspace_cachep);
+		kmem_cache_destroy(ext4_ac_cachep);
+		kmem_cache_destroy(ext4_free_ext_cachep);
+		return -ENOMEM;
+	}
 	ext4_create_debugfs_entry();
 	return 0;
 }
@@ -2649,6 +2758,7 @@ void exit_ext4_mballoc(void)
 	kmem_cache_destroy(ext4_pspace_cachep);
 	kmem_cache_destroy(ext4_ac_cachep);
 	kmem_cache_destroy(ext4_free_ext_cachep);
+	kmem_cache_destroy(ext4_deleted_ext_cachep);
 	ext4_remove_debugfs_entry();
 }
 
@@ -4640,3 +4750,192 @@ error_return:
 		kmem_cache_free(ext4_ac_cachep, ac);
 	return;
 }
+
+/*
+ * Trim "count" blocks starting at "start" in "group"
+ * This must be called under group lock
+ */
+void ext4_trim_extent(struct super_block *sb, int start, int count,
+		ext4_group_t group, struct ext4_buddy *e4b)
+{
+	ext4_fsblk_t discard_block;
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+	struct ext4_free_extent ex;
+
+	assert_spin_locked(ext4_group_lock_ptr(sb, group));
+
+	ex.fe_start = start;
+	ex.fe_group = group;
+	ex.fe_len = count;
+
+	mb_mark_used(e4b, &ex);
+	ext4_unlock_group(sb, group);
+
+	discard_block = (ext4_fsblk_t)group *
+			EXT4_BLOCKS_PER_GROUP(sb)
+			+ start
+			+ le32_to_cpu(es->s_first_data_block);
+	trace_ext4_discard_blocks(sb,
+			(unsigned long long)discard_block,
+			count);
+	sb_issue_discard(sb, discard_block, count);
+
+	ext4_lock_group(sb, group);
+	mb_free_blocks(NULL, e4b, start, ex.fe_len);
+}
+
+/*
+ * Trim all free blocks, which have at least minlen length
+ * */
+ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
+		ext4_grpblk_t minblocks)
+{
+	void *bitmap;
+	ext4_grpblk_t max = EXT4_BLOCKS_PER_GROUP(sb);
+	ext4_grpblk_t start, next, count = 0;
+	ext4_group_t group;
+
+	BUG_ON(e4b == NULL);
+
+	bitmap = e4b->bd_bitmap;
+	group = e4b->bd_group;
+	start = 0;
+	ext4_lock_group(sb, group);
+
+	while (start < max) {
+
+		start = mb_find_next_zero_bit(bitmap, max, start);
+		if (start >= max)
+			break;
+		next = mb_find_next_bit(bitmap, max, start);
+
+		if ((next - start) >= minblocks) {
+
+			count += next - start;
+			ext4_trim_extent(sb, start,
+				next - start, group, e4b);
+
+		}
+		start = next + 1;
+	}
+
+	e4b->bd_info->bb_deleted = 0;
+
+	ext4_unlock_group(sb, group);
+
+	return count;
+}
+
+/*
+ *Trim only blocks which is free and in bb_deleted rbtree
+ */
+ext4_grpblk_t ext4_trim_deleted(struct super_block *sb, struct ext4_buddy *e4b,
+		ext4_grpblk_t minblocks)
+{
+	void *bitmap;
+	struct ext4_group_info *grp;
+	ext4_group_t group;
+	ext4_grpblk_t max, next, count = 0, start = 0;
+	struct rb_node *node;
+	struct ext4_deleted_data *entry;
+
+	BUG_ON(e4b == NULL);
+
+	bitmap = e4b->bd_bitmap;
+	group = e4b->bd_group;
+	grp = ext4_get_group_info(sb, group);
+
+	if (grp->bb_deleted < minblocks)
+		return 0;
+
+	ext4_lock_group(sb, group);
+
+	for (node = rb_first(&grp->bb_deleted_root);
+	     node; node = rb_next(node))
+	{
+
+		entry = rb_entry(node, struct ext4_deleted_data, node);
+
+		start = entry->start_blk;
+		max = entry->start_blk + entry->count;
+
+		if (entry->count < minblocks)
+			continue;
+
+		count += entry->count;
+
+		rb_erase(node, &(grp->bb_deleted_root));
+		kmem_cache_free(ext4_deleted_ext_cachep, entry);
+
+		while (start < max) {
+			start = mb_find_next_zero_bit(bitmap, max, start);
+			if (start >= max)
+				break;
+			next = mb_find_next_bit(bitmap, max, start);
+			if (next > max)
+				next = max;
+
+			if ((next - start) >= minblocks) {
+
+				ext4_trim_extent(sb, start,
+					next - start, group, e4b);
+			} else {
+				/*
+				 * Do not bother with shorter extents to
+				 * eliminate extreme scenarios, when rbtree
+				 * can consume just too much memory.
+				 */
+			}
+			start = next + 1;
+		}
+	}
+
+	grp->bb_deleted -= count;
+
+	ext4_unlock_group(sb, group);
+
+	ext4_debug("trimmed %d blocks in the group %d\n",
+		count, group);
+
+	return count;
+}
+
+int ext4_trim_fs(unsigned int minlen, struct super_block *sb)
+{
+	struct ext4_buddy e4b;
+	struct ext4_group_info *grp;
+	ext4_group_t group;
+	ext4_group_t ngroups = ext4_get_groups_count(sb);
+	ext4_grpblk_t minblocks;
+
+	if (!test_opt(sb, DISCARD))
+		return 0;
+
+	minblocks = DIV_ROUND_UP(minlen, sb->s_blocksize);
+	if (unlikely(minblocks > EXT4_BLOCKS_PER_GROUP(sb)))
+		return -EINVAL;
+
+	for (group = 0; group < ngroups; group++) {
+		int err;
+
+		err = ext4_mb_load_buddy(sb, group, &e4b);
+		if (err) {
+			ext4_error(sb, "Error in loading buddy "
+					"information for %u", group);
+			continue;
+		}
+		grp = ext4_get_group_info(sb, group);
+
+		if (grp->bb_deleted < 0) {
+			/* First run after mount */
+			ext4_trim_all_free(sb, &e4b, minblocks);
+		} else if (grp->bb_deleted >= minblocks) {
+			/* Trim only blocks deleted since first run */
+			ext4_trim_deleted(sb, &e4b, minblocks);
+		}
+
+		ext4_mb_release_desc(&e4b);
+	}
+
+	return 0;
+}
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index b619322..b25397a 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -95,6 +95,15 @@ extern u8 mb_enable_debug;
 #define MB_DEFAULT_GROUP_PREALLOC	512
 
 
+struct ext4_deleted_data {
+	/* this links the deleted block information from group_info */
+	struct rb_node node;
+
+	/* deleted block extent */
+	ext4_grpblk_t start_blk;
+	ext4_grpblk_t count;
+};
+
 struct ext4_free_data {
 	/* this links the free block information from group_info */
 	struct rb_node node;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e14d22c..253eb98 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1109,6 +1109,7 @@ static const struct super_operations ext4_sops = {
 	.quota_write	= ext4_quota_write,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
+	.trim_fs	= ext4_trim_fs
 };
 
 static const struct super_operations ext4_nojournal_sops = {
-- 
1.6.6.1

