From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 41/49] ext4: Add multi block allocator for ext4
Date: Thu, 24 Jan 2008 14:34:21 +0530
Message-ID: <20080124090421.GB14348@skywalker>
References: <1200970948-17903-35-git-send-email-tytso@mit.edu> <1200970948-17903-36-git-send-email-tytso@mit.edu> <1200970948-17903-37-git-send-email-tytso@mit.edu> <1200970948-17903-38-git-send-email-tytso@mit.edu> <1200970948-17903-39-git-send-email-tytso@mit.edu> <1200970948-17903-40-git-send-email-tytso@mit.edu> <1200970948-17903-41-git-send-email-tytso@mit.edu> <1200970948-17903-42-git-send-email-tytso@mit.edu> <20080123140727.f47e9c9d.akpm@linux-foundation.org> <20080124075614.GA14348@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
	alex@clusterfs.com, adilger@clusterfs.com, sandeen@redhat.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:47664 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754590AbYAXJEa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2008 04:04:30 -0500
Content-Disposition: inline
In-Reply-To: <20080124075614.GA14348@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

updated patch. Waiting for the test results.

I am only attaching the diff. Mballoc patch is really large.

-aneesh
diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 4f329af..ec7d349 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -89,6 +89,8 @@ When mounting an ext4 filesystem, the following option are accepted:
 extents			ext4 will use extents to address file data.  The
 			file system will no longer be mountable by ext3.
 
+noextents		ext4 will not use extents for new files created.
+
 journal_checksum	Enable checksumming of the journal transactions.
 			This will allow the recovery code in e2fsck and the
 			kernel to detect corruption in the kernel.  It is a
@@ -206,6 +208,10 @@ nobh			(a) cache disk block mapping information
 			"nobh" option tries to avoid associating buffer
 			heads (supported only for "writeback" mode).
 
+mballoc		(*)	Use the mutliblock allocator for block allocation
+nomballoc		disabled multiblock allocator for block allocation.
+stripe=n		filesystem blocks per stripe for a RAID configuration.
+
 
 Data Mode
 ---------
diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index dec9945..4413a2d 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -857,6 +857,45 @@ CPUs.
 The   "procs_blocked" line gives  the  number of  processes currently blocked,
 waiting for I/O to complete.
 
+1.9 Ext4 file system parameters
+------------------------------
+Ext4 file system have one directory per partition under /proc/fs/ext4/
+# ls /proc/fs/ext4/hdc/
+group_prealloc  max_to_scan  mb_groups  mb_history  min_to_scan  order2_req
+stats  stream_req
+
+mb_groups:
+This file gives the details of mutiblock allocator buddy cache of free blocks
+
+mb_history:
+Multiblock allocation history.
+
+stats:
+This file indicate whether the multiblock allocator should start collecting
+statistics. The statistics are shown during unmount
+
+group_prealloc:
+The multiblock allocator normalize the block allocation request to
+group_prealloc filesystem blocks if we don't have strip value set.
+The stripe value can be specified at mount time or during mke2fs.
+
+max_to_scan:
+How long multiblock allocator can look for a best extent (in found extents)
+
+min_to_scan:
+How long multiblock allocator  must look for a best extent
+
+order2_req:
+Multiblock allocator use  2^N search using buddies only for requests greater
+than or equal to order2_req. The request size is specfied in file system
+blocks. A value of 2 indicate only if the requests are greater than or equal
+to 4 blocks.
+
+stream_req:
+Files smaller than stream_req are served by the stream allocator, whose
+purpose is to pack requests as close each to other as possible to
+produce smooth I/O traffic. Avalue of 16 indicate that file smaller than 16
+filesystem block size will use group based preallocation.
 
 ------------------------------------------------------------------------------
 Summary
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 0398aa0..310bad6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -489,7 +489,7 @@ struct ext4_free_extent {
  */
 struct ext4_locality_group {
 	/* for allocator */
-	struct semaphore	lg_sem;		/* to serialize allocates */
+	struct mutex		lg_sem;		/* to serialize allocates */
 	struct list_head	lg_prealloc_list;/* list of preallocations */
 	spinlock_t		lg_prealloc_lock;
 };
@@ -563,7 +563,10 @@ struct ext4_buddy {
 #define EXT4_MB_BUDDY(e4b)	((e4b)->bd_buddy)
 
 #ifndef EXT4_MB_HISTORY
-#define ext4_mb_store_history(ac)
+static inline void ext4_mb_store_history(struct ext4_allocation_context *ac)
+{
+	return;
+}
 #else
 static void ext4_mb_store_history(struct ext4_allocation_context *ac);
 #endif
@@ -641,6 +644,10 @@ static ext4_fsblk_t ext4_grp_offs_to_block(struct super_block *sb,
 
 static inline int mb_test_bit(int bit, void *addr)
 {
+	/*
+	 * ext4_test_bit on architecture like powerpc
+	 * needs unsigned long aligned address
+	 */
 	mb_correct_addr_and_bit(bit, addr);
 	return ext4_test_bit(bit, addr);
 }
@@ -669,7 +676,7 @@ static inline void mb_clear_bit_atomic(spinlock_t *lock, int bit, void *addr)
 	ext4_clear_bit_atomic(lock, bit, addr);
 }
 
-static inline void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
+static void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
 {
 	char *bb;
 
@@ -752,9 +759,20 @@ static void mb_cmp_bitmaps(struct ext4_buddy *e4b, void *bitmap)
 }
 
 #else
-#define mb_free_blocks_double(a, b, c, d)
-#define mb_mark_used_double(a, b, c)
-#define mb_cmp_bitmaps(a, b)
+static inline void mb_free_blocks_double(struct inode *inode,
+				struct ext4_buddy *e4b, int first, int count)
+{
+	return;
+}
+static inline void mb_mark_used_double(struct ext4_buddy *e4b,
+						int first, int count)
+{
+	return;
+}
+static inline void mb_cmp_bitmaps(struct ext4_buddy *e4b, void *bitmap)
+{
+	return;
+}
 #endif
 
 #ifdef AGGRESSIVE_CHECK
@@ -877,26 +895,6 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 #define mb_check_buddy(e4b)
 #endif
 
-/* find most significant bit */
-static int fmsb(unsigned short word)
-{
-	int order;
-
-	if (word > 255) {
-		order = 7;
-		word >>= 8;
-	} else {
-		order = -1;
-	}
-
-	do {
-		order++;
-		word >>= 1;
-	} while (word != 0);
-
-	return order;
-}
-
 /* FIXME!! need more doc */
 static void ext4_mb_mark_free_simple(struct super_block *sb,
 				void *buddy, unsigned first, int len,
@@ -917,7 +915,7 @@ static void ext4_mb_mark_free_simple(struct super_block *sb,
 		max = ffs(first | border) - 1;
 
 		/* find how many blocks of power 2 we need to mark */
-		min = fmsb(len);
+		min = fls(len);
 
 		if (max < min)
 			min = max;
@@ -1029,10 +1027,9 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 	if (groups_per_page > 1) {
 		err = -ENOMEM;
 		i = sizeof(struct buffer_head *) * groups_per_page;
-		bh = kmalloc(i, GFP_NOFS);
+		bh = kzalloc(i, GFP_NOFS);
 		if (bh == NULL)
 			goto out;
-		memset(bh, 0, i);
 	} else
 		bh = &bhs;
 
@@ -1055,15 +1052,9 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 		if (bh[i] == NULL)
 			goto out;
 
-		if (buffer_uptodate(bh[i]))
+		if (bh_uptodate_or_lock(bh[i]))
 			continue;
 
-		lock_buffer(bh[i]);
-		if (buffer_uptodate(bh[i])) {
-			unlock_buffer(bh[i]);
-			continue;
-		}
-
 		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 			ext4_init_block_bitmap(sb, bh[i],
 						first_group + i, desc);
@@ -1302,7 +1293,7 @@ static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
 	len = cur + len;
 	while (cur < len) {
 		if ((cur & 31) == 0 && (len - cur) >= 32) {
-			/* fast path: clear whole word at once */
+			/* fast path: set whole word at once */
 			addr = bm + (cur >> 3);
 			*addr = 0xffffffff;
 			cur += 32;
@@ -2675,7 +2666,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	for (i = 0; i < NR_CPUS; i++) {
 		struct ext4_locality_group *lg;
 		lg = &sbi->s_locality_groups[i];
-		sema_init(&lg->lg_sem, 1);
+		mutex_init(&lg->lg_sem);
 		INIT_LIST_HEAD(&lg->lg_prealloc_list);
 		spin_lock_init(&lg->lg_prealloc_lock);
 	}
@@ -2687,6 +2678,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	return 0;
 }
 
+/* need to called with ext4 group lock (ext4_lock_group) */
 static void ext4_mb_cleanup_pa(struct ext4_group_info *grp)
 {
 	struct ext4_prealloc_space *pa;
@@ -2695,7 +2687,7 @@ static void ext4_mb_cleanup_pa(struct ext4_group_info *grp)
 
 	list_for_each_safe(cur, tmp, &grp->bb_prealloc_list) {
 		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
-		list_del_rcu(&pa->pa_group_list);
+		list_del(&pa->pa_group_list);
 		count++;
 		kfree(pa);
 	}
@@ -3441,6 +3433,7 @@ static int ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 /*
  * the function goes through all preallocation in this group and marks them
  * used in in-core bitmap. buddy must be generated from this bitmap
+ * Need to be called with ext4 group lock (ext4_lock_group)
  */
 static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group)
@@ -3462,7 +3455,7 @@ static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 	 * allocation in buddy when concurrent ext4_mb_put_pa()
 	 * is dropping preallocation
 	 */
-	list_for_each_rcu(cur, &grp->bb_prealloc_list) {
+	list_for_each(cur, &grp->bb_prealloc_list) {
 		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
 		spin_lock(&pa->pa_lock);
 		ext4_get_group_no_and_offset(sb, pa->pa_pstart,
@@ -3486,7 +3479,6 @@ static void ext4_mb_pa_callback(struct rcu_head *head)
 	pa = container_of(head, struct ext4_prealloc_space, u.pa_rcu);
 	kmem_cache_free(ext4_pspace_cachep, pa);
 }
-#define mb_call_rcu(__pa)	call_rcu(&(__pa)->u.pa_rcu, ext4_mb_pa_callback)
 
 /*
  * drops a reference to preallocated space descriptor
@@ -3528,14 +3520,14 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 	 * against that pair
 	 */
 	ext4_lock_group(sb, grp);
-	list_del_rcu(&pa->pa_group_list);
+	list_del(&pa->pa_group_list);
 	ext4_unlock_group(sb, grp);
 
 	spin_lock(pa->pa_obj_lock);
 	list_del_rcu(&pa->pa_inode_list);
 	spin_unlock(pa->pa_obj_lock);
 
-	mb_call_rcu(pa);
+	call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
 }
 
 /*
@@ -3615,7 +3607,7 @@ static int ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 	pa->pa_inode = ac->ac_inode;
 
 	ext4_lock_group(sb, ac->ac_b_ex.fe_group);
-	list_add_rcu(&pa->pa_group_list, &grp->bb_prealloc_list);
+	list_add(&pa->pa_group_list, &grp->bb_prealloc_list);
 	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
 
 	spin_lock(pa->pa_obj_lock);
@@ -3672,7 +3664,7 @@ static int ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 	pa->pa_inode = NULL;
 
 	ext4_lock_group(sb, ac->ac_b_ex.fe_group);
-	list_add_rcu(&pa->pa_group_list, &grp->bb_prealloc_list);
+	list_add(&pa->pa_group_list, &grp->bb_prealloc_list);
 	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
 
 	spin_lock(pa->pa_obj_lock);
@@ -3853,7 +3845,7 @@ repeat:
 
 		spin_unlock(&pa->pa_lock);
 
-		list_del_rcu(&pa->pa_group_list);
+		list_del(&pa->pa_group_list);
 		list_add(&pa->u.pa_tmp_list, &list);
 	}
 
@@ -3889,7 +3881,7 @@ repeat:
 			ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa);
 
 		list_del(&pa->u.pa_tmp_list);
-		mb_call_rcu(pa);
+		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
 	}
 
 out:
@@ -3942,9 +3934,8 @@ repeat:
 			spin_unlock(&pa->pa_lock);
 			spin_unlock(&ei->i_prealloc_lock);
 			printk(KERN_ERR "uh-oh! used pa while discarding\n");
-			dump_stack();
-			current->state = TASK_UNINTERRUPTIBLE;
-			schedule_timeout(HZ);
+			WARN_ON(1);
+			schedule_timeout_uninterruptible(HZ);
 			goto repeat;
 
 		}
@@ -3972,8 +3963,7 @@ repeat:
 		 * add a flag to force wait only in case
 		 * of ->clear_inode(), but not in case of
 		 * regular truncate */
-		current->state = TASK_UNINTERRUPTIBLE;
-		schedule_timeout(HZ);
+		schedule_timeout_uninterruptible(HZ);
 		goto repeat;
 	}
 	spin_unlock(&ei->i_prealloc_lock);
@@ -3993,7 +3983,7 @@ repeat:
 		}
 
 		ext4_lock_group(sb, group);
-		list_del_rcu(&pa->pa_group_list);
+		list_del(&pa->pa_group_list);
 		ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa);
 		ext4_unlock_group(sb, group);
 
@@ -4001,7 +3991,7 @@ repeat:
 		brelse(bitmap_bh);
 
 		list_del(&pa->u.pa_tmp_list);
-		mb_call_rcu(pa);
+		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
 	}
 }
 
@@ -4051,7 +4041,8 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 		struct ext4_prealloc_space *pa;
 		ext4_grpblk_t start;
 		struct list_head *cur;
-		list_for_each_rcu(cur, &grp->bb_prealloc_list) {
+		ext4_lock_group(sb, i);
+		list_for_each(cur, &grp->bb_prealloc_list) {
 			pa = list_entry(cur, struct ext4_prealloc_space,
 					pa_group_list);
 			spin_lock(&pa->pa_lock);
@@ -4061,6 +4052,7 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 			printk(KERN_ERR "PA:%lu:%d:%u \n", i,
 							start, pa->pa_len);
 		}
+		ext4_lock_group(sb, i);
 
 		if (grp->bb_free == 0)
 			continue;
@@ -4070,7 +4062,10 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 	printk(KERN_ERR "\n");
 }
 #else
-#define ext4_mb_show_ac(x)
+static inline void ext4_mb_show_ac(struct ext4_allocation_context *ac)
+{
+	return;
+}
 #endif
 
 /*
@@ -4091,8 +4086,7 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 
 	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
 	isize = i_size_read(ac->ac_inode) >> bsbits;
-	if (size < isize)
-		size = isize;
+	size = max(size, isize);
 
 	/* don't use group allocation for large files */
 	if (size >= sbi->s_mb_stream_request)
@@ -4102,6 +4096,11 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 		return;
 
 	BUG_ON(ac->ac_lg != NULL);
+	/*
+	 * locality group prealloc space are per cpu. The reason for having
+	 * per cpu locality group is to reduce the contention between block
+	 * request from multiple CPUs.
+	 */
 	ac->ac_lg = &sbi->s_locality_groups[get_cpu()];
 	put_cpu();
 
@@ -4109,7 +4108,7 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;
 
 	/* serialize all allocations in the group */
-	down(&ac->ac_lg->lg_sem);
+	mutex_lock(&ac->ac_lg->lg_sem);
 }
 
 static int ext4_mb_initialize_context(struct ext4_allocation_context *ac,
@@ -4202,7 +4201,7 @@ static int ext4_mb_release_context(struct ext4_allocation_context *ac)
 	if (ac->ac_buddy_page)
 		page_cache_release(ac->ac_buddy_page);
 	if (ac->ac_flags & EXT4_MB_HINT_GROUP_ALLOC)
-		up(&ac->ac_lg->lg_sem);
+		mutex_unlock(&ac->ac_lg->lg_sem);
 	ext4_mb_collect_stats(ac);
 	return 0;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 136d095..3a51ffc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1779,13 +1779,14 @@ static unsigned long ext4_get_stripe_size(struct ext4_sb_info *sbi)
 	unsigned long stripe_width =
 			le32_to_cpu(sbi->s_es->s_raid_stripe_width);
 
-	if (sbi->s_stripe && sbi->s_stripe <= sbi->s_blocks_per_group) {
+	if (sbi->s_stripe && sbi->s_stripe <= sbi->s_blocks_per_group)
 		return sbi->s_stripe;
-	} else if (stripe_width <= sbi->s_blocks_per_group) {
+
+	if (stripe_width <= sbi->s_blocks_per_group)
 		return stripe_width;
-	} else if (stride <= sbi->s_blocks_per_group) {
+
+	if (stride <= sbi->s_blocks_per_group)
 		return stride;
-	}
 
 	return 0;
 }
