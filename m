From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: don't use blocks freed but not yet committed in
	buddy cache init
Date: Mon, 19 Jan 2009 17:06:40 +0530
Message-ID: <20090119113640.GG9482@skywalker>
References: <E1LOG9D-0006h4-7R@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:39081 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbZATHz0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jan 2009 02:55:26 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id n0JBtkkP216632
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 22:57:26 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0JBbBN8025012
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 22:37:11 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n0JBbA7b016416
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 22:37:10 +1100
Content-Disposition: inline
In-Reply-To: <E1LOG9D-0006h4-7R@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: don't use blocks freed but not yet committed in buddy cache init

When we generate buddy cache (especially during resize) we need to
make sure we don't use the blocks freed but not yet comitted.  This
makes sure we have the right value of free blocks count in the group
info and also in the bitmap.  This also ensures the ordered mode
consistency

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>   

---
 fs/ext4/mballoc.c |   82 ++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 60 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 93e4c09..ea13c5e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -335,6 +335,8 @@ static struct kmem_cache *ext4_ac_cachep;
 static struct kmem_cache *ext4_free_ext_cachep;
 static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group);
+static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
+						ext4_group_t group);
 static int ext4_mb_init_per_dev_proc(struct super_block *sb);
 static int ext4_mb_destroy_per_dev_proc(struct super_block *sb);
 static void ext4_mb_free_committed_blocks(struct super_block *);
@@ -859,7 +861,9 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 			/*
 			 * incore got set to the group block bitmap below
 			 */
+			ext4_lock_group(sb, group);
 			ext4_mb_generate_buddy(sb, data, incore, group);
+			ext4_unlock_group(sb, group);
 			incore = NULL;
 		} else {
 			/* this is block of bitmap */
@@ -873,6 +877,7 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 
 			/* mark all preallocated blks used in in-core bitmap */
 			ext4_mb_generate_from_pa(sb, data, group);
+			ext4_mb_generate_from_freelist(sb, data, group);
 			ext4_unlock_group(sb, group);
 
 			/* set incore so that the buddy information can be
@@ -3583,6 +3588,32 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 }
 
 /*
+ * the function goes through all block freed in the group
+ * but not yet committed and marks them used in in-core bitmap.
+ * buddy must be generated from this bitmap
+ * Need to be called with ext4 group lock (ext4_lock_group)
+ */
+static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
+						ext4_group_t group)
+{
+	struct rb_node *n;
+	struct ext4_group_info *grp;
+	struct ext4_free_data *entry;
+
+	grp = ext4_get_group_info(sb, group);
+	n = rb_first(&(grp->bb_free_root));
+
+	while (n) {
+		entry = rb_entry(n, struct ext4_free_data, node);
+		mb_set_bits(sb_bgl_lock(EXT4_SB(sb), group),
+				bitmap, entry->start_blk,
+				entry->count);
+		n = rb_next(n);
+	}
+	return;
+}
+
+/*
  * the function goes through all preallocation in this group and marks them
  * used in in-core bitmap. buddy must be generated from this bitmap
  * Need to be called with ext4 group lock (ext4_lock_group)
@@ -4720,27 +4751,22 @@ static int can_merge(struct ext4_free_data *entry1,
 
 static noinline_for_stack int
 ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
-			  ext4_group_t group, ext4_grpblk_t block, int count)
+			struct ext4_free_data *new_entry)
 {
+	ext4_grpblk_t block;
+	struct ext4_free_data *entry;
 	struct ext4_group_info *db = e4b->bd_info;
 	struct super_block *sb = e4b->bd_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct ext4_free_data *entry, *new_entry;
 	struct rb_node **n = &db->bb_free_root.rb_node, *node;
 	struct rb_node *parent = NULL, *new_node;
 
-
 	BUG_ON(e4b->bd_bitmap_page == NULL);
 	BUG_ON(e4b->bd_buddy_page == NULL);
 
-	new_entry  = kmem_cache_alloc(ext4_free_ext_cachep, GFP_NOFS);
-	new_entry->start_blk = block;
-	new_entry->group  = group;
-	new_entry->count = count;
-	new_entry->t_tid = handle->h_transaction->t_tid;
 	new_node = &new_entry->node;
+	block = new_entry->start_blk;
 
-	ext4_lock_group(sb, group);
 	if (!*n) {
 		/* first free block exent. We need to
 		   protect buddy cache from being freed,
@@ -4799,7 +4825,6 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 	spin_lock(&sbi->s_md_lock);
 	list_add(&new_entry->list, &sbi->s_active_transaction);
 	spin_unlock(&sbi->s_md_lock);
-	ext4_unlock_group(sb, group);
 	return 0;
 }
 
@@ -4906,15 +4931,6 @@ do_more:
 			BUG_ON(!mb_test_bit(bit + i, bitmap_bh->b_data));
 	}
 #endif
-	mb_clear_bits(sb_bgl_lock(sbi, block_group), bitmap_bh->b_data,
-			bit, count);
-
-	/* We dirtied the bitmap block */
-	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
-	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
-	if (err)
-		goto error_return;
-
 	if (ac) {
 		ac->ac_b_ex.fe_group = block_group;
 		ac->ac_b_ex.fe_start = bit;
@@ -4926,11 +4942,29 @@ do_more:
 	if (err)
 		goto error_return;
 	if (metadata) {
-		/* blocks being freed are metadata. these blocks shouldn't
-		 * be used until this transaction is committed */
-		ext4_mb_free_metadata(handle, &e4b, block_group, bit, count);
+		struct ext4_free_data *new_entry;
+		/*
+		 * blocks being freed are metadata. these blocks shouldn't
+		 * be used until this transaction is committed
+		 */
+		new_entry  = kmem_cache_alloc(ext4_free_ext_cachep, GFP_NOFS);
+		new_entry->start_blk = bit;
+		new_entry->group  = block_group;
+		new_entry->count = count;
+		new_entry->t_tid = handle->h_transaction->t_tid;
+		ext4_lock_group(sb, block_group);
+		mb_clear_bits(sb_bgl_lock(sbi, block_group), bitmap_bh->b_data,
+				bit, count);
+		ext4_mb_free_metadata(handle, &e4b, new_entry);
+		ext4_unlock_group(sb, block_group);
 	} else {
 		ext4_lock_group(sb, block_group);
+		/* need to update group_info->bb_free and bitmap
+		 * with group lock held. generate_buddy look at
+		 * them with group lock_held
+		 */
+		mb_clear_bits(sb_bgl_lock(sbi, block_group), bitmap_bh->b_data,
+				bit, count);
 		mb_free_blocks(inode, &e4b, bit, count);
 		ext4_mb_return_to_preallocation(inode, &e4b, block, count);
 		ext4_unlock_group(sb, block_group);
@@ -4953,6 +4987,10 @@ do_more:
 
 	*freed += count;
 
+	/* We dirtied the bitmap block */
+	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
+	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
+
 	/* And the group descriptor block */
 	BUFFER_TRACE(gd_bh, "dirtied group descriptor block");
 	ret = ext4_journal_dirty_metadata(handle, gd_bh);
-- 
tg: (7830455..) aneesh-7-dont-use-blocks-freed-but-not-yet-committed-in-buddy-cache-init (depends on: use-rb-tree-for-free-blocks-tracking)
