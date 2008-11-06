From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V3 7/9] ext4: don't use blocks freed but not yet committed in buddy cache init
Date: Fri,  7 Nov 2008 00:19:32 +0530
Message-ID: <1225997374-10846-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1225997374-10846-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:59844 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYKFS5j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 13:57:39 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id mA6J5J9R145908
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 06:05:19 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA6Io7Ti175940
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 05:50:07 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA6Io67R022680
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 05:50:07 +1100
In-Reply-To: <1225997374-10846-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we generate buddy cache (especially during resize) we need to
make sure we don't use the blocks freed but not yet comitted.  This
makes sure we have the right value of free blocks count in the group
info and also in the bitmap.  This also ensures the ordered mode
consistency

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |   83 ++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f4753bd..7293209 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -335,6 +335,8 @@
 static struct kmem_cache *ext4_free_ext_cachep;
 static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group);
+static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
+						ext4_group_t group);
 static int ext4_mb_init_per_dev_proc(struct super_block *sb);
 static int ext4_mb_destroy_per_dev_proc(struct super_block *sb);
 static void release_blocks_on_commit(journal_t *journal, transaction_t *txn);
@@ -858,7 +860,9 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 			/*
 			 * incore got set to the group block bitmap below
 			 */
+			ext4_lock_group(sb, group);
 			ext4_mb_generate_buddy(sb, data, incore, group);
+			ext4_unlock_group(sb, group);
 			incore = NULL;
 		} else {
 			/* this is block of bitmap */
@@ -872,6 +876,7 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 
 			/* mark all preallocated blks used in in-core bitmap */
 			ext4_mb_generate_from_pa(sb, data, group);
+			ext4_mb_generate_from_freelist(sb, data, group);
 			ext4_unlock_group(sb, group);
 
 			/* set incore so that the buddy information can be
@@ -3428,6 +3433,32 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
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
@@ -4527,27 +4558,22 @@ static int can_merge(struct ext4_free_data *entry1,
 
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
@@ -4565,7 +4591,6 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 		else if (block >= (entry->start_blk + entry->count))
 			n = &(*n)->rb_right;
 		else {
-			ext4_unlock_group(sb, group);
 			ext4_error(sb, __func__,
 			    "Double free of blocks %d (%d %d)\n",
 			    block, entry->start_blk, entry->count);
@@ -4607,7 +4632,6 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 	spin_lock(&sbi->s_md_lock);
 	list_add(&new_entry->list, &handle->h_transaction->t_private_list);
 	spin_unlock(&sbi->s_md_lock);
-	ext4_unlock_group(sb, group);
 	return 0;
 }
 
@@ -4712,15 +4736,6 @@ void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
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
@@ -4734,11 +4749,29 @@ void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
 		goto error_return;
 	}
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
@@ -4761,6 +4794,10 @@ void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
 
 	*freed += count;
 
+	/* We dirtied the bitmap block */
+	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
+	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
+
 	/* And the group descriptor block */
 	BUFFER_TRACE(gd_bh, "dirtied group descriptor block");
 	ret = ext4_journal_dirty_metadata(handle, gd_bh);
-- 
1.6.0.3.514.g2f91b

