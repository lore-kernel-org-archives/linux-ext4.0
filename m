From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -v2 8/9] ext4: Fix double free of blocks
Date: Mon,  3 Nov 2008 23:06:08 +0530
Message-ID: <1225733769-23734-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1225733769-23734-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225733769-23734-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225733769-23734-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225733769-23734-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225733769-23734-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225733769-23734-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225733769-23734-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:57581 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYKCRiA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 12:38:00 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id mA3Haotj005438
	for <linux-ext4@vger.kernel.org>; Tue, 4 Nov 2008 04:36:50 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA3HaiXm4722764
	for <linux-ext4@vger.kernel.org>; Tue, 4 Nov 2008 04:36:44 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA3Hagix013995
	for <linux-ext4@vger.kernel.org>; Tue, 4 Nov 2008 04:36:42 +1100
In-Reply-To: <1225733769-23734-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

blocks freed but not yet committed will be marked free
in disk bitmap. We need to consider them as used when
releasing inode prealloc space. Otherwise we would
double free them via mb_free_blocks

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |   72 +++++++++++++++++++++++++++++++++-------------------
 1 files changed, 46 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f6d9e30..c169256 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3454,7 +3454,6 @@ static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
 		grp = ext4_get_group_info(sb, group);
 		n = grp->bb_free_root.rb_node;
 		entry = rb_entry(n, struct ext4_free_data, node);
-
 	} else
 		n = &entry->node;
 
@@ -3741,19 +3740,19 @@ static int ext4_mb_new_preallocation(struct ext4_allocation_context *ac)
  * TODO: optimize the case when there are no in-core structures yet
  */
 static noinline_for_stack int
-ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
+ext4_mb_release_inode_pa(struct ext4_buddy *e4b, void *bitmap,
 			struct ext4_prealloc_space *pa,
 			struct ext4_allocation_context *ac)
 {
-	struct super_block *sb = e4b->bd_sb;
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int err = 0;
+	int free = 0;
+	sector_t start;
 	unsigned long end;
 	unsigned long next;
 	ext4_group_t group;
 	ext4_grpblk_t bit;
-	sector_t start;
-	int err = 0;
-	int free = 0;
+	struct super_block *sb = e4b->bd_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	BUG_ON(pa->pa_deleted == 0);
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
@@ -3765,12 +3764,11 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
 		ac->ac_inode = pa->pa_inode;
 		ac->ac_op = EXT4_MB_HISTORY_DISCARD;
 	}
-
 	while (bit < end) {
-		bit = mb_find_next_zero_bit(bitmap_bh->b_data, end, bit);
+		bit = mb_find_next_zero_bit(bitmap, end, bit);
 		if (bit >= end)
 			break;
-		next = mb_find_next_bit(bitmap_bh->b_data, end, bit);
+		next = mb_find_next_bit(bitmap, end, bit);
 		start = group * EXT4_BLOCKS_PER_GROUP(sb) + bit +
 				le32_to_cpu(sbi->s_es->s_first_data_block);
 		mb_debug("    free preallocated %u/%u in group %u\n",
@@ -3789,18 +3787,12 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
 		mb_free_blocks(pa->pa_inode, e4b, bit, next - bit);
 		bit = next + 1;
 	}
-	if (free != pa->pa_free) {
-		printk(KERN_CRIT "pa %p: logic %lu, phys. %lu, len %lu\n",
-			pa, (unsigned long) pa->pa_lstart,
-			(unsigned long) pa->pa_pstart,
-			(unsigned long) pa->pa_len);
-		ext4_error(sb, __func__, "free %u, pa_free %u\n",
-						free, pa->pa_free);
-		/*
-		 * pa is already deleted so we use the value obtained
-		 * from the bitmap and continue.
-		 */
-	}
+	/*
+	 * The blocks allocated and later freed from this pa
+	 * can result in pa_free being different from the
+	 * bitmap free block count. This is because we don't
+	 * update pa_len on releasing blocks.
+	 */
 	atomic_add(free, &sbi->s_mb_discarded);
 
 	return err;
@@ -3856,6 +3848,7 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 	struct ext4_allocation_context *ac;
 	struct list_head list;
 	struct ext4_buddy e4b;
+	void *bitmap;
 	int err;
 	int busy = 0;
 	int free = 0;
@@ -3871,12 +3864,21 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 				"bitmap for %lu\n", group);
 		return 0;
 	}
-
+	/* blocks freed but not yet committed will
+	 * be marked free in disk bitmap. We need to
+	 * consider them as used when releasing inode
+	 * pa. Otherwise we would double free them
+	 * via mb_free_blocks
+	 */
+	bitmap = kmalloc(sb->s_blocksize, GFP_NOFS);
+	if (!bitmap)
+		return 0;
 	err = ext4_mb_load_buddy(sb, group, &e4b);
 	if (err) {
 		__release(e4b->alloc_semp);
 		ext4_error(sb, __func__, "Error in loading buddy "
 				"information for %lu\n", group);
+		kfree(bitmap);
 		put_bh(bitmap_bh);
 		return 0;
 	}
@@ -3931,6 +3933,8 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 		goto out;
 	}
 
+	memcpy(bitmap, bitmap_bh->b_data, sb->s_blocksize);
+	ext4_mb_generate_from_freelist(sb, bitmap, group, NULL);
 	/* now free all selected PAs */
 	list_for_each_entry_safe(pa, tmp, &list, u.pa_tmp_list) {
 
@@ -3942,7 +3946,7 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 		if (pa->pa_linear)
 			ext4_mb_release_group_pa(&e4b, pa, ac);
 		else
-			ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa, ac);
+			ext4_mb_release_inode_pa(&e4b, bitmap, pa, ac);
 
 		list_del(&pa->u.pa_tmp_list);
 		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
@@ -3953,6 +3957,7 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 	if (ac)
 		kmem_cache_free(ext4_ac_cachep, ac);
 	ext4_mb_release_desc(&e4b);
+	kfree(bitmap);
 	put_bh(bitmap_bh);
 	return free;
 }
@@ -3977,6 +3982,7 @@ void ext4_discard_preallocations(struct inode *inode)
 	struct list_head list;
 	struct ext4_buddy e4b;
 	int err;
+	void *bitmap;
 
 	if (!S_ISREG(inode->i_mode)) {
 		/*BUG_ON(!list_empty(&ei->i_prealloc_list));*/
@@ -4055,14 +4061,28 @@ void ext4_discard_preallocations(struct inode *inode)
 			ext4_mb_release_desc(&e4b);
 			continue;
 		}
-
+		/* blocks freed but not yet committed will
+		 * be marked free in disk bitmap. We need to
+		 * consider them as used when releasing inode
+		 * pa. Otherwise we would double free them
+		 * via mb_free_blocks
+		 */
+		bitmap = kmalloc(sb->s_blocksize, GFP_NOFS);
+		if (!bitmap) {
+			ext4_mb_release_desc(&e4b);
+			put_bh(bitmap_bh);
+			continue;
+		}
+		memcpy(bitmap, bitmap_bh->b_data, sb->s_blocksize);
 		ext4_lock_group(sb, group);
+		ext4_mb_generate_from_freelist(sb, bitmap, group, NULL);
 		list_del(&pa->pa_group_list);
-		ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa, ac);
+		ext4_mb_release_inode_pa(&e4b, bitmap, pa, ac);
 		ext4_unlock_group(sb, group);
 
 		ext4_mb_release_desc(&e4b);
 		put_bh(bitmap_bh);
+		kfree(bitmap);
 
 		list_del(&pa->u.pa_tmp_list);
 		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
-- 
1.6.0.3.514.g2f91b

