From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mark many more functions in mballoc.c as noinline
Date: Wed, 24 Jun 2009 12:11:51 -0500
Message-ID: <4A425E57.3090109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44644 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbZFXRLv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Jun 2009 13:11:51 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n5OHBsxZ027458
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2009 13:11:54 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5OHBroI009183
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2009 13:11:53 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n5OHBp3r004311
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2009 13:11:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This marks many (more) functions in mballoc.c as noinline.

It results in some significant stack savings for example on x86_64:

-ext4_mb_free_blocks 200
+ext4_mb_free_blocks 184

-ext4_mb_init_cache 232
+ext4_mb_init_cache 136

-ext4_mb_regular_allocator 232
+ext4_mb_regular_allocator 104

-ext4_mb_new_blocks 104
(drops below 100 bytes)

Some of these are in the writeback path, so can be critical.

This might be a bit heavy handed, as it adds 37 new noinlines,
but I did my best to keep the smaller functions inlineable.

I haven't done perf testing w/ the change, but blowing the stack
has a significant perf impact as well!

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
--- 

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ed8482e..e1fda62 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -334,11 +334,14 @@
 static struct kmem_cache *ext4_pspace_cachep;
 static struct kmem_cache *ext4_ac_cachep;
 static struct kmem_cache *ext4_free_ext_cachep;
-static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
+static noinline_for_stack
+void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group);
-static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
+static noinline_for_stack
+void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
 						ext4_group_t group);
-static void release_blocks_on_commit(journal_t *journal, transaction_t *txn);
+static noinline_for_stack
+void release_blocks_on_commit(journal_t *journal, transaction_t *txn);
 
 
 
@@ -404,7 +407,8 @@ static inline int mb_find_next_bit(void *addr, int max, int start)
 	return ret;
 }
 
-static void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
+static noinline_for_stack
+void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
 {
 	char *bb;
 
@@ -428,7 +432,8 @@ static void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
 }
 
 #ifdef DOUBLE_CHECK
-static void mb_free_blocks_double(struct inode *inode, struct ext4_buddy *e4b,
+static noinline_for_stack
+void mb_free_blocks_double(struct inode *inode, struct ext4_buddy *e4b,
 			   int first, int count)
 {
 	int i;
@@ -454,7 +459,8 @@ static void mb_free_blocks_double(struct inode *inode, struct ext4_buddy *e4b,
 	}
 }
 
-static void mb_mark_used_double(struct ext4_buddy *e4b, int first, int count)
+static noinline_for_stack
+void mb_mark_used_double(struct ext4_buddy *e4b, int first, int count)
 {
 	int i;
 
@@ -467,7 +473,8 @@ static void mb_mark_used_double(struct ext4_buddy *e4b, int first, int count)
 	}
 }
 
-static void mb_cmp_bitmaps(struct ext4_buddy *e4b, void *bitmap)
+static noinline_for_stack
+void mb_cmp_bitmaps(struct ext4_buddy *e4b, void *bitmap)
 {
 	if (memcmp(e4b->bd_info->bb_bitmap, bitmap, e4b->bd_sb->s_blocksize)) {
 		unsigned char *b1, *b2;
@@ -515,7 +522,8 @@ do {									\
 	}								\
 } while (0)
 
-static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
+static noinline_for_stack
+int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 				const char *function, int line)
 {
 	struct super_block *sb = e4b->bd_sb;
@@ -621,7 +629,8 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 #endif
 
 /* FIXME!! need more doc */
-static void ext4_mb_mark_free_simple(struct super_block *sb,
+static noinline_for_stack
+void ext4_mb_mark_free_simple(struct super_block *sb,
 				void *buddy, unsigned first, int len,
 					struct ext4_group_info *grp)
 {
@@ -657,7 +666,8 @@ static void ext4_mb_mark_free_simple(struct super_block *sb,
 	}
 }
 
-static void ext4_mb_generate_buddy(struct super_block *sb,
+static noinline_for_stack
+void ext4_mb_generate_buddy(struct super_block *sb,
 				void *buddy, void *bitmap, ext4_group_t group)
 {
 	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
@@ -725,7 +735,8 @@ static void ext4_mb_generate_buddy(struct super_block *sb,
  * is blocks_per_page/2
  */
 
-static int ext4_mb_init_cache(struct page *page, char *incore)
+static noinline_for_stack
+int ext4_mb_init_cache(struct page *page, char *incore)
 {
 	ext4_group_t ngroups;
 	int blocksize;
@@ -907,8 +918,8 @@ out:
 	return err;
 }
 
-static noinline_for_stack int
-ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
+static noinline_for_stack
+int ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 					struct ext4_buddy *e4b)
 {
 	int blocks_per_page;
@@ -1104,7 +1115,8 @@ static void mb_set_bits(void *bm, int cur, int len)
 	}
 }
 
-static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
+static noinline_for_stack
+void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 			  int first, int count)
 {
 	int block = 0;
@@ -1188,7 +1200,8 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 	mb_check_buddy(e4b);
 }
 
-static int mb_find_extent(struct ext4_buddy *e4b, int order, int block,
+static noinline_for_stack
+int mb_find_extent(struct ext4_buddy *e4b, int order, int block,
 				int needed, struct ext4_free_extent *ex)
 {
 	int next = block;
@@ -1246,7 +1259,8 @@ static int mb_find_extent(struct ext4_buddy *e4b, int order, int block,
 	return ex->fe_len;
 }
 
-static int mb_mark_used(struct ext4_buddy *e4b, struct ext4_free_extent *ex)
+static noinline_for_stack
+int mb_mark_used(struct ext4_buddy *e4b, struct ext4_free_extent *ex)
 {
 	int ord;
 	int mlen = 0;
@@ -1323,7 +1337,8 @@ static int mb_mark_used(struct ext4_buddy *e4b, struct ext4_free_extent *ex)
 /*
  * Must be called under group lock!
  */
-static void ext4_mb_use_best_found(struct ext4_allocation_context *ac,
+static noinline_for_stack
+void ext4_mb_use_best_found(struct ext4_allocation_context *ac,
 					struct ext4_buddy *e4b)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
@@ -1371,7 +1386,8 @@ static void ext4_mb_use_best_found(struct ext4_allocation_context *ac,
  * regular allocator, for general purposes allocation
  */
 
-static void ext4_mb_check_limits(struct ext4_allocation_context *ac,
+static noinline_for_stack
+void ext4_mb_check_limits(struct ext4_allocation_context *ac,
 					struct ext4_buddy *e4b,
 					int finish_group)
 {
@@ -1421,7 +1437,8 @@ static void ext4_mb_check_limits(struct ext4_allocation_context *ac,
  *
  * FIXME: real allocation policy is to be designed yet!
  */
-static void ext4_mb_measure_extent(struct ext4_allocation_context *ac,
+static noinline_for_stack
+void ext4_mb_measure_extent(struct ext4_allocation_context *ac,
 					struct ext4_free_extent *ex,
 					struct ext4_buddy *e4b)
 {
@@ -1480,7 +1497,8 @@ static void ext4_mb_measure_extent(struct ext4_allocation_context *ac,
 	ext4_mb_check_limits(ac, e4b, 0);
 }
 
-static int ext4_mb_try_best_found(struct ext4_allocation_context *ac,
+static noinline_for_stack
+int ext4_mb_try_best_found(struct ext4_allocation_context *ac,
 					struct ext4_buddy *e4b)
 {
 	struct ext4_free_extent ex = ac->ac_b_ex;
@@ -1507,7 +1525,8 @@ static int ext4_mb_try_best_found(struct ext4_allocation_context *ac,
 	return 0;
 }
 
-static int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
+static noinline_for_stack
+int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 				struct ext4_buddy *e4b)
 {
 	ext4_group_t group = ac->ac_g_ex.fe_group;
@@ -1566,7 +1585,8 @@ static int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
  * The routine scans buddy structures (not bitmap!) from given order
  * to max order and tries to find big enough chunk to satisfy the req
  */
-static void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
+static noinline_for_stack
+void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
 					struct ext4_buddy *e4b)
 {
 	struct super_block *sb = ac->ac_sb;
@@ -1609,7 +1629,8 @@ static void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
  * In order to optimize scanning, caller must pass number of
  * free blocks in the group, so the routine can know upper limit.
  */
-static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
+static noinline_for_stack
+void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 					struct ext4_buddy *e4b)
 {
 	struct super_block *sb = ac->ac_sb;
@@ -1668,7 +1689,8 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
  * we try to find stripe-aligned chunks for stripe-size requests
  * XXX should do so at least for multiples of stripe size as well
  */
-static void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
+static noinline_for_stack
+void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
 				 struct ext4_buddy *e4b)
 {
 	struct super_block *sb = ac->ac_sb;
@@ -1703,7 +1725,8 @@ static void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
 	}
 }
 
-static int ext4_mb_good_group(struct ext4_allocation_context *ac,
+static noinline_for_stack
+int ext4_mb_good_group(struct ext4_allocation_context *ac,
 				ext4_group_t group, int cr)
 {
 	unsigned free, fragments;
@@ -1831,7 +1854,8 @@ void ext4_mb_put_buddy_cache_lock(struct super_block *sb,
 
 }
 
-static int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
+static noinline_for_stack
+int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
 {
 
 	int ret;
@@ -1921,8 +1945,8 @@ err:
 	return ret;
 }
 
-static noinline_for_stack int
-ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
+static noinline_for_stack
+int ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 {
 	ext4_group_t ngroups, group, i;
 	int cr;
@@ -2142,7 +2166,8 @@ static void *ext4_mb_seq_history_next(struct seq_file *seq, void *v,
 		return ext4_mb_history_skip_empty(s, ++hs, 0);
 }
 
-static int ext4_mb_seq_history_show(struct seq_file *seq, void *v)
+static noinline_for_stack
+int ext4_mb_seq_history_show(struct seq_file *seq, void *v)
 {
 	char buf[25], buf2[25], buf3[25], *fmt;
 	struct ext4_mb_history *hs = v;
@@ -2312,7 +2337,8 @@ static void *ext4_mb_seq_groups_next(struct seq_file *seq, void *v, loff_t *pos)
 	return (void *) ((unsigned long) group);
 }
 
-static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
+static noinline_for_stack
+int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
 {
 	struct super_block *sb = seq->private;
 	ext4_group_t group = (ext4_group_t) ((unsigned long) v);
@@ -2420,8 +2446,8 @@ static void ext4_mb_history_init(struct super_block *sb)
 	/* if we can't allocate history, then we simple won't use it */
 }
 
-static noinline_for_stack void
-ext4_mb_store_history(struct ext4_allocation_context *ac)
+static noinline_for_stack
+void ext4_mb_store_history(struct ext4_allocation_context *ac)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 	struct ext4_mb_history h;
@@ -2560,7 +2586,8 @@ void ext4_mb_update_group_info(struct ext4_group_info *grp, ext4_grpblk_t add)
 	grp->bb_free += add;
 }
 
-static int ext4_mb_init_backend(struct super_block *sb)
+static noinline_for_stack
+int ext4_mb_init_backend(struct super_block *sb)
 {
 	ext4_group_t ngroups = ext4_get_groups_count(sb);
 	ext4_group_t i;
@@ -2819,7 +2846,8 @@ int ext4_mb_release(struct super_block *sb)
  * This function is called by the jbd2 layer once the commit has finished,
  * so we know we can free the blocks that were released with that commit.
  */
-static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
+static noinline_for_stack
+void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 {
 	struct super_block *sb = journal->j_private;
 	struct ext4_buddy e4b;
@@ -2914,8 +2942,8 @@ void exit_ext4_mballoc(void)
  * Check quota and mark choosed space (ac->ac_b_ex) non-free in bitmaps
  * Returns 0 if success or error code
  */
-static noinline_for_stack int
-ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
+static noinline_for_stack
+int ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 				handle_t *handle, unsigned int reserv_blks)
 {
 	struct buffer_head *bitmap_bh = NULL;
@@ -3059,8 +3087,8 @@ static void ext4_mb_normalize_group_request(struct ext4_allocation_context *ac)
  * Normalization means making request better in terms of
  * size and alignment
  */
-static noinline_for_stack void
-ext4_mb_normalize_request(struct ext4_allocation_context *ac,
+static noinline_for_stack
+void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 				struct ext4_allocation_request *ar)
 {
 	int bsbits, max;
@@ -3349,8 +3377,8 @@ ext4_mb_check_group_pa(ext4_fsblk_t goal_block,
 /*
  * search goal blocks in preallocated space
  */
-static noinline_for_stack int
-ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
+static noinline_for_stack
+int ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 {
 	int order, i;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
@@ -3458,7 +3486,8 @@ static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
  * used in in-core bitmap. buddy must be generated from this bitmap
  * Need to be called with ext4 group lock held
  */
-static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
+static noinline_for_stack
+void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group)
 {
 	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
@@ -3506,7 +3535,8 @@ static void ext4_mb_pa_callback(struct rcu_head *head)
  * drops a reference to preallocated space descriptor
  * if this was the last reference and the space is consumed
  */
-static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
+static noinline_for_stack
+void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 			struct super_block *sb, struct ext4_prealloc_space *pa)
 {
 	ext4_group_t grp;
@@ -3563,8 +3593,8 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 /*
  * creates new preallocated space for given inode
  */
-static noinline_for_stack int
-ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
+static noinline_for_stack
+int ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 {
 	struct super_block *sb = ac->ac_sb;
 	struct ext4_prealloc_space *pa;
@@ -3657,8 +3687,8 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 /*
  * creates new preallocated space for locality group inodes belongs to
  */
-static noinline_for_stack int
-ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
+static noinline_for_stack
+int ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 {
 	struct super_block *sb = ac->ac_sb;
 	struct ext4_locality_group *lg;
@@ -3716,7 +3746,8 @@ ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 	return 0;
 }
 
-static int ext4_mb_new_preallocation(struct ext4_allocation_context *ac)
+static noinline_for_stack
+int ext4_mb_new_preallocation(struct ext4_allocation_context *ac)
 {
 	int err;
 
@@ -3735,8 +3766,9 @@ static int ext4_mb_new_preallocation(struct ext4_allocation_context *ac)
  * the caller MUST hold group/inode locks.
  * TODO: optimize the case when there are no in-core structures yet
  */
-static noinline_for_stack int
-ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
+static noinline_for_stack
+int ext4_mb_release_inode_pa(struct ext4_buddy *e4b,
+			struct buffer_head *bitmap_bh,
 			struct ext4_prealloc_space *pa,
 			struct ext4_allocation_context *ac)
 {
@@ -3808,8 +3840,8 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
 	return err;
 }
 
-static noinline_for_stack int
-ext4_mb_release_group_pa(struct ext4_buddy *e4b,
+static noinline_for_stack
+int ext4_mb_release_group_pa(struct ext4_buddy *e4b,
 				struct ext4_prealloc_space *pa,
 				struct ext4_allocation_context *ac)
 {
@@ -3850,8 +3882,8 @@ ext4_mb_release_group_pa(struct ext4_buddy *e4b,
  * - how many do we discard
  *   1) how many requested
  */
-static noinline_for_stack int
-ext4_mb_discard_group_preallocations(struct super_block *sb,
+static noinline_for_stack
+int ext4_mb_discard_group_preallocations(struct super_block *sb,
 					ext4_group_t group, int needed)
 {
 	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
@@ -4082,14 +4114,16 @@ repeat:
  * XXX: at the moment, truncate (which is the only way to free blocks)
  * discards all preallocations
  */
-static void ext4_mb_return_to_preallocation(struct inode *inode,
+static noinline_for_stack
+void ext4_mb_return_to_preallocation(struct inode *inode,
 					struct ext4_buddy *e4b,
 					sector_t block, int count)
 {
 	BUG_ON(!list_empty(&EXT4_I(inode)->i_prealloc_list));
 }
 #ifdef MB_DEBUG
-static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
+static noinline_for_stack
+void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 {
 	struct super_block *sb = ac->ac_sb;
 	ext4_group_t ngroups, i;
@@ -4156,7 +4190,8 @@ static inline void ext4_mb_show_ac(struct ext4_allocation_context *ac)
  *
  * One can tune this size via /sys/fs/ext4/<partition>/mb_stream_req
  */
-static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
+static noinline_for_stack
+void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 	int bsbits = ac->ac_sb->s_blocksize_bits;
@@ -4191,8 +4226,8 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 	mutex_lock(&ac->ac_lg->lg_mutex);
 }
 
-static noinline_for_stack int
-ext4_mb_initialize_context(struct ext4_allocation_context *ac,
+static noinline_for_stack
+int ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 				struct ext4_allocation_request *ar)
 {
 	struct super_block *sb = ar->inode->i_sb;
@@ -4261,8 +4296,8 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 
 }
 
-static noinline_for_stack void
-ext4_mb_discard_lg_preallocations(struct super_block *sb,
+static noinline_for_stack
+void ext4_mb_discard_lg_preallocations(struct super_block *sb,
 					struct ext4_locality_group *lg,
 					int order, int total_entries)
 {
@@ -4347,7 +4382,8 @@ ext4_mb_discard_lg_preallocations(struct super_block *sb,
  * which can cause the lg_prealloc_list to be updated.
  */
 
-static void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
+static noinline_for_stack
+void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
 {
 	int order, added = 0, lg_prealloc_count = 1;
 	struct super_block *sb = ac->ac_sb;
@@ -4397,7 +4433,8 @@ static void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
 /*
  * release all resource we used in allocation
  */
-static int ext4_mb_release_context(struct ext4_allocation_context *ac)
+static noinline_for_stack
+int ext4_mb_release_context(struct ext4_allocation_context *ac)
 {
 	struct ext4_prealloc_space *pa = ac->ac_pa;
 	if (pa) {
@@ -4439,7 +4476,8 @@ static int ext4_mb_release_context(struct ext4_allocation_context *ac)
 	return 0;
 }
 
-static int ext4_mb_discard_preallocations(struct super_block *sb, int needed)
+static noinline_for_stack
+int ext4_mb_discard_preallocations(struct super_block *sb, int needed)
 {
 	ext4_group_t i, ngroups = ext4_get_groups_count(sb);
 	int ret;
@@ -4625,8 +4663,8 @@ static int can_merge(struct ext4_free_data *entry1,
 	return 0;
 }
 
-static noinline_for_stack int
-ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
+static noinline_for_stack
+int ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 		      struct ext4_free_data *new_entry)
 {
 	ext4_grpblk_t block;

