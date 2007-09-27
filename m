From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mballoc update
Date: Thu, 27 Sep 2007 14:48:21 +0530
Message-ID: <46FB755D.6030108@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:56105 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXI0JTY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Sep 2007 05:19:24 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8R9IqCE030943
	for <linux-ext4@vger.kernel.org>; Thu, 27 Sep 2007 19:18:53 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8R9MP6e146042
	for <linux-ext4@vger.kernel.org>; Thu, 27 Sep 2007 19:22:26 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8R9IZwr029169
	for <linux-ext4@vger.kernel.org>; Thu, 27 Sep 2007 19:18:35 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi

This is the changes with which i am going to update the mballoc core patch.
There is a new FIXME in here which i would like others to look at. 

Also the commit message is updated to explain the mballoc
approach.

Mingming,

I have placed the new patch at 
http://www.radian.org/~kvaneesh/ext4/sep-27-2007/mballoc-core.patch


-aneesh


diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c4e6c92..3984959 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -312,7 +312,7 @@ static struct kmem_cache *ext4_pspace_cachep;
 struct ext4_free_metadata {
 	unsigned short group;
 	unsigned short num;
-	unsigned short blocks[EXT4_BB_MAX_BLOCKS];
+	ext4_grpblk_t  blocks[EXT4_BB_MAX_BLOCKS];
 	struct list_head list;
 };
 
@@ -347,7 +347,7 @@ struct ext4_prealloc_space {
 	spinlock_t		pa_lock;
 	atomic_t		pa_count;
 	unsigned		pa_deleted;
-	unsigned long		pa_pstart;	/* phys. block */
+	ext4_fsblk_t		pa_pstart;	/* phys. block */
 	unsigned long		pa_lstart;	/* log. block */
 	unsigned short		pa_len;		/* len of preallocated chunk */
 	unsigned short		pa_free;	/* how many blocks are free */
@@ -454,54 +454,47 @@ static void ext4_mb_store_history(struct ext4_allocation_context *ac);
 #define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
 
 static struct proc_dir_entry *proc_root_ext4;
-
-int ext4_create(struct inode *, struct dentry *, int, struct nameidata *);
 struct buffer_head *read_block_bitmap(struct super_block *, unsigned int);
 ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
-void ext4_mb_release_blocks(struct super_block *, int);
-void ext4_mb_poll_new_transaction(struct super_block *, handle_t *);
-void ext4_mb_free_committed_blocks(struct super_block *);
-void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap, int group);
-void ext4_mb_free_consumed_preallocations(struct ext4_allocation_context *ac);
-void ext4_mb_return_to_preallocation(struct inode *inode,
+
+static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap, int group);
+static void ext4_mb_poll_new_transaction(struct super_block *, handle_t *);
+static void ext4_mb_free_committed_blocks(struct super_block *);
+static void ext4_mb_return_to_preallocation(struct inode *inode,
 					struct ext4_buddy *e4b, sector_t block,
 					int count);
-void ext4_mb_show_ac(struct ext4_allocation_context *ac);
-void ext4_mb_check_with_pa(struct ext4_buddy *e4b, int first, int count);
-void ext4_mb_put_pa(struct ext4_allocation_context *, struct super_block *,
+static void ext4_mb_show_ac(struct ext4_allocation_context *ac);
+static void ext4_mb_put_pa(struct ext4_allocation_context *, struct super_block *,
 						struct ext4_prealloc_space *pa);
-int ext4_mb_init_per_dev_proc(struct super_block *sb);
-int ext4_mb_destroy_per_dev_proc(struct super_block *sb);
+static int ext4_mb_init_per_dev_proc(struct super_block *sb);
+static int ext4_mb_destroy_per_dev_proc(struct super_block *sb);
 
 
-static inline void
-ext4_lock_group(struct super_block *sb, int group)
+static inline void ext4_lock_group(struct super_block *sb, int group)
 {
 	bit_spin_lock(EXT4_GROUP_INFO_LOCKED_BIT,
 		      &EXT4_GROUP_INFO(sb, group)->bb_state);
 }
 
-static inline void
-ext4_unlock_group(struct super_block *sb, int group)
+static inline void ext4_unlock_group(struct super_block *sb, int group)
 {
 	bit_spin_unlock(EXT4_GROUP_INFO_LOCKED_BIT,
 			&EXT4_GROUP_INFO(sb, group)->bb_state);
 }
 
-static inline int
-ext4_is_group_locked(struct super_block *sb, int group)
+static inline int ext4_is_group_locked(struct super_block *sb, int group)
 {
 	return bit_spin_is_locked(EXT4_GROUP_INFO_LOCKED_BIT,
 					&EXT4_GROUP_INFO(sb, group)->bb_state);
 }
 
-unsigned long ext4_grp_offs_to_block(struct super_block *sb,
+static ext4_fsblk_t ext4_grp_offs_to_block(struct super_block *sb,
 					struct ext4_free_extent *fex)
 {
-	unsigned long block;
+	ext4_fsblk_t block;
 
-	block = (unsigned long) fex->fe_group * EXT4_BLOCKS_PER_GROUP(sb)
+	block = (ext4_fsblk_t) fex->fe_group * EXT4_BLOCKS_PER_GROUP(sb)
 			+ fex->fe_start
 			+ le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
 	return block;
@@ -612,7 +605,7 @@ static inline void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
 }
 
 #ifdef DOUBLE_CHECK
-void mb_free_blocks_double(struct inode *inode, struct ext4_buddy *e4b,
+static void mb_free_blocks_double(struct inode *inode, struct ext4_buddy *e4b,
 			   int first, int count)
 {
 	int i;
@@ -638,7 +631,7 @@ void mb_free_blocks_double(struct inode *inode, struct ext4_buddy *e4b,
 	}
 }
 
-void mb_mark_used_double(struct ext4_buddy *e4b, int first, int count)
+static void mb_mark_used_double(struct ext4_buddy *e4b, int first, int count)
 {
 	int i;
 
@@ -651,7 +644,7 @@ void mb_mark_used_double(struct ext4_buddy *e4b, int first, int count)
 	}
 }
 
-void mb_cmp_bitmaps(struct ext4_buddy *e4b, void *bitmap)
+static void mb_cmp_bitmaps(struct ext4_buddy *e4b, void *bitmap)
 {
 	if (memcmp(e4b->bd_info->bb_bitmap, bitmap, e4b->bd_sb->s_blocksize)) {
 		unsigned char *b1, *b2;
@@ -814,9 +807,9 @@ static inline int fmsb(unsigned short word)
 	return order;
 }
 
-static inline void
-ext4_mb_mark_free_simple(struct super_block *sb, void *buddy, unsigned first,
-				int len, struct ext4_group_info *grp)
+static inline void ext4_mb_mark_free_simple(struct super_block *sb,
+				void *buddy, unsigned first, int len,
+					struct ext4_group_info *grp)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	unsigned short min;
@@ -850,9 +843,8 @@ ext4_mb_mark_free_simple(struct super_block *sb, void *buddy, unsigned first,
 	}
 }
 
-static void
-ext4_mb_generate_buddy(struct super_block *sb, void *buddy, void *bitmap,
-			int group)
+static void ext4_mb_generate_buddy(struct super_block *sb,
+				void *buddy, void *bitmap, int group)
 {
 	struct ext4_group_info *grp = EXT4_GROUP_INFO(sb, group);
 	unsigned short max = EXT4_BLOCKS_PER_GROUP(sb);
@@ -1480,7 +1472,7 @@ static void ext4_mb_use_best_found(struct ext4_allocation_context *ac,
  * regular allocator, for general purposes allocation
  */
 
-void ext4_mb_check_limits(struct ext4_allocation_context *ac,
+static void ext4_mb_check_limits(struct ext4_allocation_context *ac,
 					struct ext4_buddy *e4b,
 					int finish_group)
 {
@@ -1828,7 +1820,7 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
 	return 0;
 }
 
-int ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
+static int ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 {
 	int group;
 	int i;
@@ -2312,8 +2304,7 @@ static void ext4_mb_history_init(struct super_block *sb)
 	/* if we can't allocate history, then we simple won't use it */
 }
 
-static void
-ext4_mb_store_history(struct ext4_allocation_context *ac)
+static void ext4_mb_store_history(struct ext4_allocation_context *ac)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 	struct ext4_mb_history h;
@@ -2351,7 +2342,7 @@ ext4_mb_store_history(struct ext4_allocation_context *ac)
 #define ext4_mb_history_init(sb)
 #endif
 
-int ext4_mb_init_backend(struct super_block *sb)
+static int ext4_mb_init_backend(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int i;
@@ -2571,7 +2562,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	return 0;
 }
 
-void ext4_mb_cleanup_pa(struct ext4_group_info *grp)
+static void ext4_mb_cleanup_pa(struct ext4_group_info *grp)
 {
 	struct ext4_prealloc_space *pa;
 	struct list_head *cur, *tmp;
@@ -2658,7 +2649,7 @@ int ext4_mb_release(struct super_block *sb)
 	return 0;
 }
 
-void ext4_mb_free_committed_blocks(struct super_block *sb)
+static void ext4_mb_free_committed_blocks(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int err;
@@ -2851,7 +2842,7 @@ do {									\
 	proc->write_proc = ext4_mb_write_##var;				\
 } while (0)
 
-int ext4_mb_init_per_dev_proc(struct super_block *sb)
+static int ext4_mb_init_per_dev_proc(struct super_block *sb)
 {
 	mode_t mode = S_IFREG | S_IRUGO | S_IWUSR;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -2888,7 +2879,7 @@ err_out:
 	return -ENOMEM;
 }
 
-int ext4_mb_destroy_per_dev_proc(struct super_block *sb)
+static int ext4_mb_destroy_per_dev_proc(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	char devname[64];
@@ -2939,7 +2930,7 @@ void exit_ext4_proc(void)
  * Check quota and mark choosed space (ac->ac_b_ex) non-free in bitmaps
  * Returns 0 if success or error code
  */
-int ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
+static int ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 				handle_t *handle)
 {
 	struct buffer_head *bitmap_bh = NULL;
@@ -3026,7 +3017,7 @@ out_err:
  * here we normalize request for locality group
  * XXX: should we try to preallocate more than the group has now?
  */
-void ext4_mb_normalize_group_request(struct ext4_allocation_context *ac)
+static void ext4_mb_normalize_group_request(struct ext4_allocation_context *ac)
 {
 	struct super_block *sb = ac->ac_sb;
 	struct ext4_locality_group *lg = ac->ac_lg;
@@ -3041,7 +3032,7 @@ void ext4_mb_normalize_group_request(struct ext4_allocation_context *ac)
  * Normalization means making request better in terms of
  * size and alignment
  */
-void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
+static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 				struct ext4_allocation_request *ar)
 {
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
@@ -3070,8 +3061,10 @@ void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	if (ac->ac_flags & EXT4_MB_HINT_NOPREALLOC)
 		return;
 
-	if (ac->ac_flags & EXT4_MB_HINT_GROUP_ALLOC)
-		return ext4_mb_normalize_group_request(ac);
+	if (ac->ac_flags & EXT4_MB_HINT_GROUP_ALLOC) {
+		ext4_mb_normalize_group_request(ac);
+		return ;
+	}
 
 	bsbits = ac->ac_sb->s_blocksize_bits;
 
@@ -3215,7 +3208,7 @@ void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 		(unsigned) orig_size, (unsigned) start);
 }
 
-void ext4_mb_collect_stats(struct ext4_allocation_context *ac)
+static void ext4_mb_collect_stats(struct ext4_allocation_context *ac)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 
@@ -3238,10 +3231,10 @@ void ext4_mb_collect_stats(struct ext4_allocation_context *ac)
 /*
  * use blocks preallocated to inode
  */
-void ext4_mb_use_inode_pa(struct ext4_allocation_context *ac,
+static void ext4_mb_use_inode_pa(struct ext4_allocation_context *ac,
 				struct ext4_prealloc_space *pa)
 {
-	unsigned long start;
+	ext4_fsblk_t start;
 	unsigned long len;
 
 	/* found preallocated blocks, use them */
@@ -3265,7 +3258,7 @@ void ext4_mb_use_inode_pa(struct ext4_allocation_context *ac,
 /*
  * use blocks preallocated to locality group
  */
-void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
+static void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
 				struct ext4_prealloc_space *pa)
 {
 	unsigned len = ac->ac_o_ex.fe_len;
@@ -3281,13 +3274,18 @@ void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
 	 * possible race when tte group is being loaded concurrently
 	 * instead we correct pa later, after blocks are marked
 	 * in on-disk bitmap -- see ext4_mb_release_context() */
+	/*
+	 * FIXME!! but the other CPUs can look at this particular
+	 * pa and think that it have enought free blocks if we
+	 * don't update pa_free here right ?
+	 */
 	mb_debug("use %lu/%lu from group pa %p\n", pa->pa_lstart-len, len, pa);
 }
 
 /*
  * search goal blocks in preallocated space
  */
-int ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
+static int ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 {
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
 	struct ext4_locality_group *lg;
@@ -3355,7 +3353,7 @@ int ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
  * the function goes through all preallocation in this group and marks them
  * used in in-core bitmap. buddy must be generated from this bitmap
  */
-void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap, int group)
+static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap, int group)
 {
 	struct ext4_group_info *grp = EXT4_GROUP_INFO(sb, group);
 	struct ext4_prealloc_space *pa;
@@ -3389,7 +3387,6 @@ void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap, int group)
 	mb_debug("prellocated %u for group %u\n", preallocated, group);
 }
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 5)
 static void ext4_mb_pa_callback(struct rcu_head *head)
 {
 	struct ext4_prealloc_space *pa;
@@ -3397,19 +3394,12 @@ static void ext4_mb_pa_callback(struct rcu_head *head)
 	kmem_cache_free(ext4_pspace_cachep, pa);
 }
 #define mb_call_rcu(__pa)	call_rcu(&(__pa)->u.pa_rcu, ext4_mb_pa_callback)
-#else
-static void ext4_mb_pa_callback(void *pa)
-{
-	kmem_cache_free(ext4_pspace_cachep, pa);
-}
-#define mb_call_rcu(__pa)	call_rcu(&(__pa)->u.pa_rcu, ext4_mb_pa_callback, pa)
-#endif
 
 /*
  * drops a reference to preallocated space descriptor
  * if this was the last reference and the space is consumed
  */
-void ext4_mb_put_pa(struct ext4_allocation_context *ac,
+static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 			struct super_block *sb, struct ext4_prealloc_space *pa)
 {
 	unsigned long grp;
@@ -3458,7 +3448,7 @@ void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 /*
  * creates new preallocated space for given inode
  */
-int ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
+static int ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 {
 	struct super_block *sb = ac->ac_sb;
 	struct ext4_prealloc_space *pa;
@@ -3545,7 +3535,7 @@ int ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 /*
  * creates new preallocated space for locality group inodes belongs to
  */
-int ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
+static int ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 {
 	struct super_block *sb = ac->ac_sb;
 	struct ext4_locality_group *lg;
@@ -3599,7 +3589,7 @@ int ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 	return 0;
 }
 
-int ext4_mb_new_preallocation(struct ext4_allocation_context *ac)
+static int ext4_mb_new_preallocation(struct ext4_allocation_context *ac)
 {
 	int err;
 
@@ -3618,7 +3608,7 @@ int ext4_mb_new_preallocation(struct ext4_allocation_context *ac)
  * the caller MUST hold group/inode locks.
  * TODO: optimize the case when there are no in-core structures yet
  */
-int ext4_mb_release_inode_pa(struct ext4_buddy *e4b,
+static int ext4_mb_release_inode_pa(struct ext4_buddy *e4b,
 				struct buffer_head *bitmap_bh,
 				struct ext4_prealloc_space *pa)
 {
@@ -3678,7 +3668,7 @@ int ext4_mb_release_inode_pa(struct ext4_buddy *e4b,
 	return err;
 }
 
-int ext4_mb_release_group_pa(struct ext4_buddy *e4b,
+static int ext4_mb_release_group_pa(struct ext4_buddy *e4b,
 				struct ext4_prealloc_space *pa)
 {
 	struct ext4_allocation_context ac;
@@ -3714,7 +3704,7 @@ int ext4_mb_release_group_pa(struct ext4_buddy *e4b,
  * - how many do we discard
  *   1) how many requested
  */
-int ext4_mb_discard_group_preallocations(struct super_block *sb,
+static int ext4_mb_discard_group_preallocations(struct super_block *sb,
 						int group, int needed)
 {
 	struct ext4_group_info *grp = EXT4_GROUP_INFO(sb, group);
@@ -3927,14 +3917,14 @@ repeat:
  * XXX: at the moment, truncate (which is the only way to free blocks)
  * discards all preallocations
  */
-void ext4_mb_return_to_preallocation(struct inode *inode,
+static void ext4_mb_return_to_preallocation(struct inode *inode,
 					struct ext4_buddy *e4b,
 					sector_t block, int count)
 {
 	BUG_ON(!list_empty(&EXT4_I(inode)->i_prealloc_list));
 }
 
-void ext4_mb_show_ac(struct ext4_allocation_context *ac)
+static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 {
 #if 0
 	struct super_block *sb = ac->ac_sb;
@@ -3984,7 +3974,7 @@ void ext4_mb_show_ac(struct ext4_allocation_context *ac)
  * based allocation
  */
 
-void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
+static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 
@@ -4015,7 +4005,7 @@ void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 	down(&ac->ac_lg->lg_sem);
 }
 
-int ext4_mb_initialize_context(struct ext4_allocation_context *ac,
+static int ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 				struct ext4_allocation_request *ar)
 {
 	struct super_block *sb = ar->inode->i_sb;
@@ -4086,7 +4076,7 @@ int ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 /*
  * release all resource we used in allocation
  */
-int ext4_mb_release_context(struct ext4_allocation_context *ac)
+static int ext4_mb_release_context(struct ext4_allocation_context *ac)
 {
 	if (ac->ac_pa) {
 		if (ac->ac_pa->pa_linear) {
@@ -4110,7 +4100,7 @@ int ext4_mb_release_context(struct ext4_allocation_context *ac)
 	return 0;
 }
 
-int ext4_mb_discard_preallocations(struct super_block *sb, int needed)
+static int ext4_mb_discard_preallocations(struct super_block *sb, int needed)
 {
 	int i;
 	int ret;
@@ -4130,13 +4120,13 @@ int ext4_mb_discard_preallocations(struct super_block *sb, int needed)
  * it tries to use preallocation first, then falls back
  * to usual allocation
  */
-unsigned long ext4_mb_new_blocks(handle_t *handle,
+ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 				 struct ext4_allocation_request *ar, int *errp)
 {
 	struct ext4_allocation_context ac;
 	struct ext4_sb_info *sbi;
 	struct super_block *sb;
-	unsigned long block = 0;
+	ext4_fsblk_t block = 0;
 	int freed;
 	int inquota;
 
@@ -4217,7 +4207,7 @@ out:
 }
 EXPORT_SYMBOL(ext4_mb_new_blocks);
 
-void ext4_mb_poll_new_transaction(struct super_block *sb, handle_t *handle)
+static void ext4_mb_poll_new_transaction(struct super_block *sb, handle_t *handle)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
@@ -4247,8 +4237,8 @@ void ext4_mb_poll_new_transaction(struct super_block *sb, handle_t *handle)
 	ext4_mb_free_committed_blocks(sb);
 }
 
-int ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
-			  int group, int block, int count)
+static int ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
+			  int group, ext4_grpblk_t block, int count)
 {
 	struct ext4_group_info *db = e4b->bd_info;
 	struct super_block *sb = e4b->bd_sb;
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index a8d51ad..a07399e 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -981,10 +981,8 @@ extern long ext4_mb_stats;
 extern long ext4_mb_max_to_scan;
 extern int ext4_mb_init(struct super_block *, int);
 extern int ext4_mb_release(struct super_block *);
-extern unsigned long ext4_mb_new_blocks(handle_t *, struct ext4_allocation_request *, int *);
+extern ext4_fsblk_t ext4_mb_new_blocks(handle_t *, struct ext4_allocation_request *, int *);
 extern int ext4_mb_reserve_blocks(struct super_block *, int);
-extern void ext4_mb_release_blocks(struct super_block *, int);
-extern void ext4_mb_release_blocks(struct super_block *, int);
 extern void ext4_mb_discard_inode_preallocations(struct inode *);
 extern int __init init_ext4_proc(void);
 extern void exit_ext4_proc(void);
