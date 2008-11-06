From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V3 8/9] ext4: Fix double free of blocks
Date: Fri,  7 Nov 2008 00:19:33 +0530
Message-ID: <1225997374-10846-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1225997374-10846-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:42125 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYKFS5n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 13:57:43 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id mA6IuAbc4608186
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 05:56:10 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA6IoBAp117744
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 05:50:11 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA6IoA2x022837
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 05:50:11 +1100
In-Reply-To: <1225997374-10846-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Blocks freed but not yet committed will be marked free in disk bitmap.
We need to consider them as used when releasing inode prealloc
space. Otherwise we would double free them via mb_free_blocks
ext4_mb_release_inode_pa looks at the block bitmap and mark the
block found free in the bitmap withing the inode prealloc space
as unused. If we have blocks allocated out of a prealloc space
and later freed we would have called ext4_mb_free_blocks on them
That would mark blocks as free in bitmap and later on journal commit
we would call mb_free_blocks on them, thus resuling in double free

ext4_lock_group is used to make sure nothing gets added to the free
list when we are doing a release_inode_pa

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |   75 ++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 48 insertions(+), 27 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7293209..f58de20 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3725,19 +3725,19 @@ static int ext4_mb_new_preallocation(struct ext4_allocation_context *ac)
  * TODO: optimize the case when there are no in-core structures yet
  */
 static noinline_for_stack int
-ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
-			struct ext4_prealloc_space *pa,
-			struct ext4_allocation_context *ac)
+ext4_mb_release_inode_pa(struct ext4_buddy *e4b, void *bitmap,
+			 struct ext4_prealloc_space *pa,
+			 struct ext4_allocation_context *ac)
 {
-	struct super_block *sb = e4b->bd_sb;
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int err = 0;
+	int free = 0;
+	sector_t start;
 	unsigned int end;
 	unsigned int next;
 	ext4_group_t group;
 	ext4_grpblk_t bit;
-	sector_t start;
-	int err = 0;
-	int free = 0;
+	struct super_block *sb = e4b->bd_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	BUG_ON(pa->pa_deleted == 0);
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
@@ -3749,12 +3749,11 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
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
@@ -3773,18 +3772,12 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
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
@@ -3840,6 +3833,7 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 	struct ext4_allocation_context *ac;
 	struct list_head list;
 	struct ext4_buddy e4b;
+	void *bitmap;
 	int err;
 	int busy = 0;
 	int free = 0;
@@ -3855,12 +3849,21 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 				"bitmap for %u\n", group);
 		return 0;
 	}
-
+	/*
+	 * Blocks freed but not yet committed will be marked free in
+	 * disk bitmap.  We need to consider them as used when
+	 * releasing inode pa.  Otherwise we would double free them via
+	 * mb_free_blocks
+	 */
+	bitmap = kmalloc(sb->s_blocksize, GFP_NOFS);
+	if (!bitmap)
+		return 0;
 	err = ext4_mb_load_buddy(sb, group, &e4b);
 	if (err) {
 		__release(e4b->alloc_semp);
 		ext4_error(sb, __func__, "Error in loading buddy "
 				"information for %u\n", group);
+		kfree(bitmap);
 		put_bh(bitmap_bh);
 		return 0;
 	}
@@ -3915,6 +3918,8 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 		goto out;
 	}
 
+	memcpy(bitmap, bitmap_bh->b_data, sb->s_blocksize);
+	ext4_mb_generate_from_freelist(sb, bitmap, group);
 	/* now free all selected PAs */
 	list_for_each_entry_safe(pa, tmp, &list, u.pa_tmp_list) {
 
@@ -3926,7 +3931,7 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 		if (pa->pa_linear)
 			ext4_mb_release_group_pa(&e4b, pa, ac);
 		else
-			ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa, ac);
+			ext4_mb_release_inode_pa(&e4b, bitmap, pa, ac);
 
 		list_del(&pa->u.pa_tmp_list);
 		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
@@ -3937,6 +3942,7 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 	if (ac)
 		kmem_cache_free(ext4_ac_cachep, ac);
 	ext4_mb_release_desc(&e4b);
+	kfree(bitmap);
 	put_bh(bitmap_bh);
 	return free;
 }
@@ -3961,6 +3967,7 @@ void ext4_discard_preallocations(struct inode *inode)
 	struct list_head list;
 	struct ext4_buddy e4b;
 	int err;
+	void *bitmap;
 
 	if (!S_ISREG(inode->i_mode)) {
 		/*BUG_ON(!list_empty(&ei->i_prealloc_list));*/
@@ -4039,14 +4046,28 @@ void ext4_discard_preallocations(struct inode *inode)
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
+		ext4_mb_generate_from_freelist(sb, bitmap, group);
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

