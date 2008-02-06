From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] allocate struct ext4_allocation_context from a kmem cache
 to save stack space
Date: Wed, 06 Feb 2008 11:05:14 -0600
Message-ID: <47A9E8CA.2070404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbYBFRFP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Feb 2008 12:05:15 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m16H5F8h001893
	for <linux-ext4@vger.kernel.org>; Wed, 6 Feb 2008 12:05:15 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m16H5FfQ012036
	for <linux-ext4@vger.kernel.org>; Wed, 6 Feb 2008 12:05:15 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id m16H5E6Q026387
	for <linux-ext4@vger.kernel.org>; Wed, 6 Feb 2008 12:05:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

struct ext4_allocation_context is rather large, and this bloats
the stack of many functions which use it.  Allocating it from
a named slab cache will alleviate this.

For example, with this change (on top of the noinline patch sent earlier):

-ext4_mb_new_blocks		200
+ext4_mb_new_blocks		 40

-ext4_mb_free_blocks		344
+ext4_mb_free_blocks		168

-ext4_mb_release_inode_pa	216
+ext4_mb_release_inode_pa	 40

-ext4_mb_release_group_pa	192
+ext4_mb_release_group_pa	 24

Most of these stack-allocated structs are actually used only for
mballoc history; and in those cases often a smaller struct would do.
So changing that may be another way around it, at least for those
functions, if preferred.  For now, in those cases where the ac
is only for history, an allocation failure simply skips the history
recording, and does not cause any other failures.

Comments?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6.24-rc6-mm1/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.24-rc6-mm1.orig/fs/ext4/mballoc.c
+++ linux-2.6.24-rc6-mm1/fs/ext4/mballoc.c
@@ -419,6 +419,7 @@
 #define MB_DEFAULT_GROUP_PREALLOC	512
 
 static struct kmem_cache *ext4_pspace_cachep;
+static struct kmem_cache *ext4_ac_cachep;
 
 #ifdef EXT4_BB_MAX_BLOCKS
 #undef EXT4_BB_MAX_BLOCKS
@@ -2958,11 +2959,18 @@ int __init init_ext4_mballoc(void)
 	if (ext4_pspace_cachep == NULL)
 		return -ENOMEM;
 
-#ifdef CONFIG_PROC_FS
+	ext4_ac_cachep =
+		kmem_cache_create("ext4_alloc_context",
+				     sizeof(struct ext4_allocation_context),
+				     0, SLAB_RECLAIM_ACCOUNT, NULL);
+	if (ext4_ac_cachep == NULL) {
+		kmem_cache_destroy(ext4_pspace_cachep);
+		return -ENOMEM;
+	}
+
 	proc_root_ext4 = proc_mkdir(EXT4_ROOT, proc_root_fs);
 	if (proc_root_ext4 == NULL)
 		printk(KERN_ERR "EXT4-fs: Unable to create %s\n", EXT4_ROOT);
-#endif
 
 	return 0;
 }
@@ -2971,9 +2979,8 @@ void exit_ext4_mballoc(void)
 {
 	/* XXX: synchronize_rcu(); */
 	kmem_cache_destroy(ext4_pspace_cachep);
-#ifdef CONFIG_PROC_FS
+	kmem_cache_destroy(ext4_ac_cachep);
 	remove_proc_entry(EXT4_ROOT, proc_root_fs);
-#endif
 }
 
 
@@ -3698,7 +3705,7 @@ static noinline int ext4_mb_release_inod
 				struct buffer_head *bitmap_bh,
 				struct ext4_prealloc_space *pa)
 {
-	struct ext4_allocation_context ac;
+	struct ext4_allocation_context *ac;
 	struct super_block *sb = e4b->bd_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	unsigned long end;
@@ -3714,9 +3721,13 @@ static noinline int ext4_mb_release_inod
 	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
 	end = bit + pa->pa_len;
 
-	ac.ac_sb = sb;
-	ac.ac_inode = pa->pa_inode;
-	ac.ac_op = EXT4_MB_HISTORY_DISCARD;
+	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
+
+	if (ac) {
+		ac->ac_sb = sb;
+		ac->ac_inode = pa->pa_inode;
+		ac->ac_op = EXT4_MB_HISTORY_DISCARD;
+	}
 
 	while (bit < end) {
 		bit = ext4_find_next_zero_bit(bitmap_bh->b_data, end, bit);
@@ -3732,11 +3743,13 @@ static noinline int ext4_mb_release_inod
 				(unsigned) group);
 		free += next - bit;
 
-		ac.ac_b_ex.fe_group = group;
-		ac.ac_b_ex.fe_start = bit;
-		ac.ac_b_ex.fe_len = next - bit;
-		ac.ac_b_ex.fe_logical = 0;
-		ext4_mb_store_history(&ac);
+		if (ac) {
+			ac->ac_b_ex.fe_group = group;
+			ac->ac_b_ex.fe_start = bit;
+			ac->ac_b_ex.fe_len = next - bit;
+			ac->ac_b_ex.fe_logical = 0;
+			ext4_mb_store_history(ac);
+		}
 
 		mb_free_blocks(pa->pa_inode, e4b, bit, next - bit);
 		bit = next + 1;
@@ -3750,6 +3763,8 @@ static noinline int ext4_mb_release_inod
 	}
 	BUG_ON(free != pa->pa_free);
 	atomic_add(free, &sbi->s_mb_discarded);
+	if (ac)
+		kmem_cache_free(ext4_ac_cachep, ac);
 
 	return err;
 }
@@ -3757,12 +3772,15 @@ static noinline int ext4_mb_release_inod
 static noinline int ext4_mb_release_group_pa(struct ext4_buddy *e4b,
 				struct ext4_prealloc_space *pa)
 {
-	struct ext4_allocation_context ac;
+	struct ext4_allocation_context *ac;
 	struct super_block *sb = e4b->bd_sb;
 	ext4_group_t group;
 	ext4_grpblk_t bit;
 
-	ac.ac_op = EXT4_MB_HISTORY_DISCARD;
+	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
+
+	if (ac)
+		ac->ac_op = EXT4_MB_HISTORY_DISCARD;
 
 	BUG_ON(pa->pa_deleted == 0);
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
@@ -3770,13 +3788,16 @@ static noinline int ext4_mb_release_grou
 	mb_free_blocks(pa->pa_inode, e4b, bit, pa->pa_len);
 	atomic_add(pa->pa_len, &EXT4_SB(sb)->s_mb_discarded);
 
-	ac.ac_sb = sb;
-	ac.ac_inode = NULL;
-	ac.ac_b_ex.fe_group = group;
-	ac.ac_b_ex.fe_start = bit;
-	ac.ac_b_ex.fe_len = pa->pa_len;
-	ac.ac_b_ex.fe_logical = 0;
-	ext4_mb_store_history(&ac);
+	if (ac) {
+		ac->ac_sb = sb;
+		ac->ac_inode = NULL;
+		ac->ac_b_ex.fe_group = group;
+		ac->ac_b_ex.fe_start = bit;
+		ac->ac_b_ex.fe_len = pa->pa_len;
+		ac->ac_b_ex.fe_logical = 0;
+		ext4_mb_store_history(ac);
+		kmem_cache_free(ext4_ac_cachep, ac);
+	}
 
 	return 0;
 }
@@ -4230,7 +4251,7 @@ static int ext4_mb_discard_preallocation
 ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 				 struct ext4_allocation_request *ar, int *errp)
 {
-	struct ext4_allocation_context ac;
+	struct ext4_allocation_context *ac = NULL;
 	struct ext4_sb_info *sbi;
 	struct super_block *sb;
 	ext4_fsblk_t block = 0;
@@ -4256,53 +4277,60 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 	}
 	inquota = ar->len;
 
+	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
+	if (!ac) {
+		*errp = -ENOMEM;
+		return 0;
+	}
+
 	ext4_mb_poll_new_transaction(sb, handle);
 
-	*errp = ext4_mb_initialize_context(&ac, ar);
+	*errp = ext4_mb_initialize_context(ac, ar);
 	if (*errp) {
 		ar->len = 0;
 		goto out;
 	}
 
-	ac.ac_op = EXT4_MB_HISTORY_PREALLOC;
-	if (!ext4_mb_use_preallocated(&ac)) {
+	ac->ac_op = EXT4_MB_HISTORY_PREALLOC;
+	if (!ext4_mb_use_preallocated(ac)) {
 
-		ac.ac_op = EXT4_MB_HISTORY_ALLOC;
-		ext4_mb_normalize_request(&ac, ar);
+		ac->ac_op = EXT4_MB_HISTORY_ALLOC;
+		ext4_mb_normalize_request(ac, ar);
 
 repeat:
 		/* allocate space in core */
-		ext4_mb_regular_allocator(&ac);
+		ext4_mb_regular_allocator(ac);
 
 		/* as we've just preallocated more space than
 		 * user requested orinally, we store allocated
 		 * space in a special descriptor */
-		if (ac.ac_status == AC_STATUS_FOUND &&
-				ac.ac_o_ex.fe_len < ac.ac_b_ex.fe_len)
-			ext4_mb_new_preallocation(&ac);
+		if (ac->ac_status == AC_STATUS_FOUND &&
+				ac->ac_o_ex.fe_len < ac->ac_b_ex.fe_len)
+			ext4_mb_new_preallocation(ac);
 	}
 
-	if (likely(ac.ac_status == AC_STATUS_FOUND)) {
-		ext4_mb_mark_diskspace_used(&ac, handle);
+	if (likely(ac->ac_status == AC_STATUS_FOUND)) {
+		ext4_mb_mark_diskspace_used(ac, handle);
 		*errp = 0;
-		block = ext4_grp_offs_to_block(sb, &ac.ac_b_ex);
-		ar->len = ac.ac_b_ex.fe_len;
+		block = ext4_grp_offs_to_block(sb, &ac->ac_b_ex);
+		ar->len = ac->ac_b_ex.fe_len;
 	} else {
-		freed  = ext4_mb_discard_preallocations(sb, ac.ac_o_ex.fe_len);
+		freed  = ext4_mb_discard_preallocations(sb, ac->ac_o_ex.fe_len);
 		if (freed)
 			goto repeat;
 		*errp = -ENOSPC;
-		ac.ac_b_ex.fe_len = 0;
+		ac->ac_b_ex.fe_len = 0;
 		ar->len = 0;
-		ext4_mb_show_ac(&ac);
+		ext4_mb_show_ac(ac);
 	}
 
-	ext4_mb_release_context(&ac);
+	ext4_mb_release_context(ac);
 
 out:
 	if (ar->len < inquota)
 		DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
 
+	kmem_cache_free(ext4_ac_cachep, ac);
 	return block;
 }
 static void ext4_mb_poll_new_transaction(struct super_block *sb,
@@ -4406,7 +4434,7 @@ void ext4_mb_free_blocks(handle_t *handl
 {
 	struct buffer_head *bitmap_bh = 0;
 	struct super_block *sb = inode->i_sb;
-	struct ext4_allocation_context ac;
+	struct ext4_allocation_context *ac = NULL;
 	struct ext4_group_desc *gdp;
 	struct ext4_super_block *es;
 	unsigned long overflow;
@@ -4435,9 +4463,12 @@ void ext4_mb_free_blocks(handle_t *handl
 
 	ext4_debug("freeing block %lu\n", block);
 
-	ac.ac_op = EXT4_MB_HISTORY_FREE;
-	ac.ac_inode = inode;
-	ac.ac_sb = sb;
+	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
+	if (ac) {
+		ac->ac_op = EXT4_MB_HISTORY_FREE;
+		ac->ac_inode = inode;
+		ac->ac_sb = sb;
+	}
 
 do_more:
 	overflow = 0;
@@ -4503,10 +4534,12 @@ do_more:
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
 	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
 
-	ac.ac_b_ex.fe_group = block_group;
-	ac.ac_b_ex.fe_start = bit;
-	ac.ac_b_ex.fe_len = count;
-	ext4_mb_store_history(&ac);
+	if (ac) {
+		ac->ac_b_ex.fe_group = block_group;
+		ac->ac_b_ex.fe_start = bit;
+		ac->ac_b_ex.fe_len = count;
+		ext4_mb_store_history(ac);
+	}
 
 	if (metadata) {
 		/* blocks being freed are metadata. these blocks shouldn't
@@ -4547,5 +4580,7 @@ do_more:
 error_return:
 	brelse(bitmap_bh);
 	ext4_std_error(sb, err);
+	if (ac)
+		kmem_cache_free(ext4_ac_cachep, ac);
 	return;
 }
