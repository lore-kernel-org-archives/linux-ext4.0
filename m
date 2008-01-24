From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Patch queue update
Date: Thu, 24 Jan 2008 20:20:51 +0530
Message-ID: <20080124145051.GC14348@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:54340 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752279AbYAXOvB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2008 09:51:01 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m0OEowhJ000387
	for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2008 20:20:58 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0OEovUA872552
	for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2008 20:20:58 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m0OEovtf006938
	for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2008 14:50:57 GMT
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have updated patches based on the review feedback from Andrew.

I have tested this on 
128(64p) ppc64 	sles
4(2p)    ppc64  debian
4(2p)	 x86_64	ubuntu-gutsy

Updated patches are at
http://www.radian.org/~kvaneesh/ext4/jan-24-2008/
http://www.radian.org/~kvaneesh/ext4/jan-24-2008/patches.tar

Diff for reference

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
diff --git a/fs/buffer.c b/fs/buffer.c
index 982cf1a..921eeec 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3232,19 +3232,21 @@ int bh_uptodate_or_lock(struct buffer_head *bh)
 	return 1;
 }
 EXPORT_SYMBOL(bh_uptodate_or_lock);
+
 /**
  * bh_submit_read: Submit a locked buffer for reading
  * @bh: struct buffer_head
  *
- * Returns a negative error
+ * Returns zero on success and -EIO on error.
  */
 int bh_submit_read(struct buffer_head *bh)
 {
-	if (!buffer_locked(bh))
-		lock_buffer(bh);
+	BUG_ON(!buffer_locked(bh));
 
-	if (buffer_uptodate(bh))
+	if (buffer_uptodate(bh)) {
+		unlock_buffer(bh);
 		return 0;
+	}
 
 	get_bh(bh);
 	bh->b_end_io = end_buffer_read_sync;
@@ -3255,6 +3257,7 @@ int bh_submit_read(struct buffer_head *bh)
 	return -EIO;
 }
 EXPORT_SYMBOL(bh_submit_read);
+
 void __init buffer_init(void)
 {
 	int nrpages;
diff --git a/fs/ext4/defrag.c b/fs/ext4/defrag.c
index 4ef3dc0..0d76c74 100644
--- a/fs/ext4/defrag.c
+++ b/fs/ext4/defrag.c
@@ -30,14 +30,6 @@ ext4_fsblk_t idx_pblock(struct ext4_extent_idx *ix)
 	return block;
 }
 
-/* Will go away */
-static void ext4_ext_store_pblock(struct ext4_extent *ex, ext4_fsblk_t pb)
-{
-	ex->ee_start_lo = cpu_to_le32((unsigned long) (pb & 0xffffffff));
-	ex->ee_start_hi =
-			cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
-}
-
 /*
  * this structure is used to gather extents from the tree via ioctl
  */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index cbda084..c2caf97 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -75,7 +75,7 @@ static ext4_fsblk_t idx_pblock(struct ext4_extent_idx *ix)
  * stores a large physical block number into an extent struct,
  * breaking it into parts
  */
-static void ext4_ext_store_pblock(struct ext4_extent *ex, ext4_fsblk_t pb)
+void ext4_ext_store_pblock(struct ext4_extent *ex, ext4_fsblk_t pb)
 {
 	ex->ee_start_lo = cpu_to_le32((unsigned long) (pb & 0xffffffff));
 	ex->ee_start_hi = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e348ceb..bec699a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -435,7 +435,7 @@ struct ext4_free_metadata {
 
 struct ext4_group_info {
 	unsigned long	bb_state;
-	unsigned long 	bb_tid;
+	unsigned long	bb_tid;
 	struct ext4_free_metadata *bb_md_cur;
 	unsigned short	bb_first_free;
 	unsigned short	bb_free;
@@ -489,7 +489,7 @@ struct ext4_free_extent {
  */
 struct ext4_locality_group {
 	/* for allocator */
-	struct semaphore	lg_sem;		/* to serialize allocates */
+	struct mutex		lg_mutex;	/* to serialize allocates */
 	struct list_head	lg_prealloc_list;/* list of preallocations */
 	spinlock_t		lg_prealloc_lock;
 };
@@ -564,7 +564,10 @@ struct ext4_buddy {
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
@@ -642,6 +645,10 @@ static ext4_fsblk_t ext4_grp_offs_to_block(struct super_block *sb,
 
 static inline int mb_test_bit(int bit, void *addr)
 {
+	/*
+	 * ext4_test_bit on architecture like powerpc
+	 * needs unsigned long aligned address
+	 */
 	mb_correct_addr_and_bit(bit, addr);
 	return ext4_test_bit(bit, addr);
 }
@@ -670,7 +677,7 @@ static inline void mb_clear_bit_atomic(spinlock_t *lock, int bit, void *addr)
 	ext4_clear_bit_atomic(lock, bit, addr);
 }
 
-static inline void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
+static void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
 {
 	char *bb;
 
@@ -753,9 +760,20 @@ static void mb_cmp_bitmaps(struct ext4_buddy *e4b, void *bitmap)
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
@@ -878,26 +896,6 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
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
@@ -918,7 +916,7 @@ static void ext4_mb_mark_free_simple(struct super_block *sb,
 		max = ffs(first | border) - 1;
 
 		/* find how many blocks of power 2 we need to mark */
-		min = fmsb(len);
+		min = fls(len) - 1;
 
 		if (max < min)
 			min = max;
@@ -1030,10 +1028,9 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
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
 
@@ -1056,15 +1053,9 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
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
@@ -1303,7 +1294,7 @@ static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
 	len = cur + len;
 	while (cur < len) {
 		if ((cur & 31) == 0 && (len - cur) >= 32) {
-			/* fast path: clear whole word at once */
+			/* fast path: set whole word at once */
 			addr = bm + (cur >> 3);
 			*addr = 0xffffffff;
 			cur += 32;
@@ -2681,7 +2672,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	for (i = 0; i < NR_CPUS; i++) {
 		struct ext4_locality_group *lg;
 		lg = &sbi->s_locality_groups[i];
-		sema_init(&lg->lg_sem, 1);
+		mutex_init(&lg->lg_mutex);
 		INIT_LIST_HEAD(&lg->lg_prealloc_list);
 		spin_lock_init(&lg->lg_prealloc_lock);
 	}
@@ -2693,6 +2684,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	return 0;
 }
 
+/* need to called with ext4 group lock (ext4_lock_group) */
 static void ext4_mb_cleanup_pa(struct ext4_group_info *grp)
 {
 	struct ext4_prealloc_space *pa;
@@ -2701,7 +2693,7 @@ static void ext4_mb_cleanup_pa(struct ext4_group_info *grp)
 
 	list_for_each_safe(cur, tmp, &grp->bb_prealloc_list) {
 		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
-		list_del_rcu(&pa->pa_group_list);
+		list_del(&pa->pa_group_list);
 		count++;
 		kfree(pa);
 	}
@@ -2735,7 +2727,9 @@ int ext4_mb_release(struct super_block *sb)
 #ifdef DOUBLE_CHECK
 			kfree(grinfo->bb_bitmap);
 #endif
+			ext4_lock_group(sb,i);
 			ext4_mb_cleanup_pa(grinfo);
+			ext4_lock_group(sb,i);
 			kfree(grinfo);
 		}
 		num_meta_group_infos = (sbi->s_groups_count +
@@ -3447,6 +3441,7 @@ static int ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 /*
  * the function goes through all preallocation in this group and marks them
  * used in in-core bitmap. buddy must be generated from this bitmap
+ * Need to be called with ext4 group lock (ext4_lock_group)
  */
 static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group)
@@ -3468,7 +3463,7 @@ static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 	 * allocation in buddy when concurrent ext4_mb_put_pa()
 	 * is dropping preallocation
 	 */
-	list_for_each_rcu(cur, &grp->bb_prealloc_list) {
+	list_for_each(cur, &grp->bb_prealloc_list) {
 		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
 		spin_lock(&pa->pa_lock);
 		ext4_get_group_no_and_offset(sb, pa->pa_pstart,
@@ -3492,7 +3487,6 @@ static void ext4_mb_pa_callback(struct rcu_head *head)
 	pa = container_of(head, struct ext4_prealloc_space, u.pa_rcu);
 	kmem_cache_free(ext4_pspace_cachep, pa);
 }
-#define mb_call_rcu(__pa)	call_rcu(&(__pa)->u.pa_rcu, ext4_mb_pa_callback)
 
 /*
  * drops a reference to preallocated space descriptor
@@ -3534,14 +3528,14 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
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
@@ -3621,7 +3615,7 @@ static int ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 	pa->pa_inode = ac->ac_inode;
 
 	ext4_lock_group(sb, ac->ac_b_ex.fe_group);
-	list_add_rcu(&pa->pa_group_list, &grp->bb_prealloc_list);
+	list_add(&pa->pa_group_list, &grp->bb_prealloc_list);
 	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
 
 	spin_lock(pa->pa_obj_lock);
@@ -3678,7 +3672,7 @@ static int ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 	pa->pa_inode = NULL;
 
 	ext4_lock_group(sb, ac->ac_b_ex.fe_group);
-	list_add_rcu(&pa->pa_group_list, &grp->bb_prealloc_list);
+	list_add(&pa->pa_group_list, &grp->bb_prealloc_list);
 	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
 
 	spin_lock(pa->pa_obj_lock);
@@ -3859,7 +3853,7 @@ repeat:
 
 		spin_unlock(&pa->pa_lock);
 
-		list_del_rcu(&pa->pa_group_list);
+		list_del(&pa->pa_group_list);
 		list_add(&pa->u.pa_tmp_list, &list);
 	}
 
@@ -3895,7 +3889,7 @@ repeat:
 			ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa);
 
 		list_del(&pa->u.pa_tmp_list);
-		mb_call_rcu(pa);
+		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
 	}
 
 out:
@@ -3948,9 +3942,8 @@ repeat:
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
@@ -3978,8 +3971,7 @@ repeat:
 		 * add a flag to force wait only in case
 		 * of ->clear_inode(), but not in case of
 		 * regular truncate */
-		current->state = TASK_UNINTERRUPTIBLE;
-		schedule_timeout(HZ);
+		schedule_timeout_uninterruptible(HZ);
 		goto repeat;
 	}
 	spin_unlock(&ei->i_prealloc_lock);
@@ -3999,7 +3991,7 @@ repeat:
 		}
 
 		ext4_lock_group(sb, group);
-		list_del_rcu(&pa->pa_group_list);
+		list_del(&pa->pa_group_list);
 		ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa);
 		ext4_unlock_group(sb, group);
 
@@ -4007,7 +3999,7 @@ repeat:
 		brelse(bitmap_bh);
 
 		list_del(&pa->u.pa_tmp_list);
-		mb_call_rcu(pa);
+		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
 	}
 }
 
@@ -4057,7 +4049,8 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 		struct ext4_prealloc_space *pa;
 		ext4_grpblk_t start;
 		struct list_head *cur;
-		list_for_each_rcu(cur, &grp->bb_prealloc_list) {
+		ext4_lock_group(sb, i);
+		list_for_each(cur, &grp->bb_prealloc_list) {
 			pa = list_entry(cur, struct ext4_prealloc_space,
 					pa_group_list);
 			spin_lock(&pa->pa_lock);
@@ -4067,6 +4060,7 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 			printk(KERN_ERR "PA:%lu:%d:%u \n", i,
 							start, pa->pa_len);
 		}
+		ext4_lock_group(sb, i);
 
 		if (grp->bb_free == 0)
 			continue;
@@ -4076,7 +4070,10 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
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
@@ -4097,8 +4094,7 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 
 	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
 	isize = i_size_read(ac->ac_inode) >> bsbits;
-	if (size < isize)
-		size = isize;
+	size = max(size, isize);
 
 	/* don't use group allocation for large files */
 	if (size >= sbi->s_mb_stream_request)
@@ -4108,6 +4104,11 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 		return;
 
 	BUG_ON(ac->ac_lg != NULL);
+	/*
+	 * locality group prealloc space are per cpu. The reason for having
+	 * per cpu locality group is to reduce the contention between block
+	 * request from multiple CPUs.
+	 */
 	ac->ac_lg = &sbi->s_locality_groups[get_cpu()];
 	put_cpu();
 
@@ -4115,7 +4116,7 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;
 
 	/* serialize all allocations in the group */
-	down(&ac->ac_lg->lg_sem);
+	mutex_lock(&ac->ac_lg->lg_mutex);
 }
 
 static int ext4_mb_initialize_context(struct ext4_allocation_context *ac,
@@ -4209,7 +4210,7 @@ static int ext4_mb_release_context(struct ext4_allocation_context *ac)
 	if (ac->ac_buddy_page)
 		page_cache_release(ac->ac_buddy_page);
 	if (ac->ac_flags & EXT4_MB_HINT_GROUP_ALLOC)
-		up(&ac->ac_lg->lg_sem);
+		mutex_unlock(&ac->ac_lg->lg_mutex);
 	ext4_mb_collect_stats(ac);
 	return 0;
 }
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 6b40f55..5e9c7e8 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -16,19 +16,15 @@
 #include <linux/ext4_jbd2.h>
 #include <linux/ext4_fs_extents.h>
 
+/*
+ * The contiguous blocks details which can be
+ * represented by a single extent
+ */
 struct list_blocks_struct {
 	ext4_lblk_t first_block, last_block;
 	ext4_fsblk_t first_pblock, last_pblock;
 };
 
-/* will go away */
-static void ext4_ext_store_pblock(struct ext4_extent *ex, ext4_fsblk_t pb)
-{
-	ex->ee_start_lo = cpu_to_le32((unsigned long) (pb & 0xffffffff));
-	ex->ee_start_hi = cpu_to_le16((unsigned long) ((pb >> 31) >> 1)
-								& 0xffff);
-}
-
 static int finish_range(handle_t *handle, struct inode *inode,
 				struct list_blocks_struct *lb)
 
@@ -61,15 +57,11 @@ static int finish_range(handle_t *handle, struct inode *inode,
 	/*
 	 * Make sure the credit we accumalated is not really high
 	 */
-
 	if (needed && handle->h_buffer_credits >= EXT4_RESERVE_TRANS_BLOCKS) {
-
 		retval = ext4_journal_restart(handle, needed);
 		if (retval)
 			goto err_out;
-
 	}
-
 	if (needed) {
 		retval = ext4_journal_extend(handle, needed);
 		if (retval != 0) {
@@ -81,19 +73,17 @@ static int finish_range(handle_t *handle, struct inode *inode,
 				goto err_out;
 		}
 	}
-
 	retval = ext4_ext_insert_extent(handle, inode, path, &newext);
-
 err_out:
 	lb->first_pblock = 0;
 	return retval;
 }
+
 static int update_extent_range(handle_t *handle, struct inode *inode,
 				ext4_fsblk_t pblock, ext4_lblk_t blk_num,
 				struct list_blocks_struct *lb)
 {
 	int retval;
-
 	/*
 	 * See if we can add on to the existing range (if it exists)
 	 */
@@ -112,7 +102,6 @@ static int update_extent_range(handle_t *handle, struct inode *inode,
 	lb->first_block = lb->last_block = blk_num;
 
 	return retval;
-
 }
 
 static int update_ind_extent_range(handle_t *handle, struct inode *inode,
@@ -136,7 +125,6 @@ static int update_ind_extent_range(handle_t *handle, struct inode *inode,
 		return -EIO;
 
 	i_data = (__le32 *)bh->b_data;
-
 	for (i = 0; i < max_entries; i++, blk_count++) {
 		if (i_data[i]) {
 			retval = update_extent_range(handle, inode,
@@ -153,6 +141,7 @@ static int update_ind_extent_range(handle_t *handle, struct inode *inode,
 	return retval;
 
 }
+
 static int update_dind_extent_range(handle_t *handle, struct inode *inode,
 				    ext4_fsblk_t pblock, ext4_lblk_t *blk_nump,
 				    struct list_blocks_struct *lb)
@@ -168,13 +157,11 @@ static int update_dind_extent_range(handle_t *handle, struct inode *inode,
 		*blk_nump += max_entries * max_entries;
 		return 0;
 	}
-
 	bh = sb_bread(inode->i_sb, pblock);
 	if (!bh)
 		return -EIO;
 
 	i_data = (__le32 *)bh->b_data;
-
 	for (i = 0; i < max_entries; i++) {
 		if (i_data[i]) {
 			retval = update_ind_extent_range(handle, inode,
@@ -194,6 +181,7 @@ static int update_dind_extent_range(handle_t *handle, struct inode *inode,
 	return retval;
 
 }
+
 static int update_tind_extent_range(handle_t *handle, struct inode *inode,
 				     ext4_fsblk_t pblock, ext4_lblk_t *blk_nump,
 				     struct list_blocks_struct *lb)
@@ -209,13 +197,11 @@ static int update_tind_extent_range(handle_t *handle, struct inode *inode,
 		*blk_nump += max_entries * max_entries * max_entries;
 		return 0;
 	}
-
 	bh = sb_bread(inode->i_sb, pblock);
 	if (!bh)
 		return -EIO;
 
 	i_data = (__le32 *)bh->b_data;
-
 	for (i = 0; i < max_entries; i++) {
 		if (i_data[i]) {
 			retval = update_dind_extent_range(handle, inode,
@@ -228,7 +214,6 @@ static int update_tind_extent_range(handle_t *handle, struct inode *inode,
 			blk_count += max_entries * max_entries;
 		}
 	}
-
 	/* Update the file block number */
 	*blk_nump = blk_count;
 	brelse(bh);
@@ -236,7 +221,6 @@ static int update_tind_extent_range(handle_t *handle, struct inode *inode,
 
 }
 
-
 static int free_dind_blocks(handle_t *handle,
 				struct inode *inode, __le32 i_data)
 {
@@ -258,10 +242,7 @@ static int free_dind_blocks(handle_t *handle,
 	}
 	brelse(bh);
 	ext4_free_blocks(handle, inode, le32_to_cpu(i_data), 1, 1);
-
 	return 0;
-
-
 }
 
 static int free_tind_blocks(handle_t *handle,
@@ -277,7 +258,6 @@ static int free_tind_blocks(handle_t *handle,
 		return -EIO;
 
 	tmp_idata = (__le32 *)bh->b_data;
-
 	for (i = 0; i < max_entries; i++) {
 		if (tmp_idata[i]) {
 			retval = free_dind_blocks(handle,
@@ -290,10 +270,7 @@ static int free_tind_blocks(handle_t *handle,
 	}
 	brelse(bh);
 	ext4_free_blocks(handle, inode, le32_to_cpu(i_data), 1, 1);
-
 	return 0;
-
-
 }
 
 static int free_ind_block(handle_t *handle, struct inode *inode)
@@ -302,10 +279,8 @@ static int free_ind_block(handle_t *handle, struct inode *inode)
 	struct ext4_inode_info *ei = EXT4_I(inode);
 
 	if (ei->i_data[EXT4_IND_BLOCK]) {
-
 		ext4_free_blocks(handle, inode,
 				le32_to_cpu(ei->i_data[EXT4_IND_BLOCK]), 1, 1);
-
 	}
 
 	if (ei->i_data[EXT4_DIND_BLOCK]) {
@@ -321,17 +296,15 @@ static int free_ind_block(handle_t *handle, struct inode *inode)
 		if (retval)
 			return retval;
 	}
-
-
 	return 0;
 }
+
 static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 				struct inode *tmp_inode, int retval)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_inode_info *tmp_ei = EXT4_I(tmp_inode);
 
-
 	retval = free_ind_block(handle, inode);
 	if (retval)
 		goto err_out;
@@ -368,9 +341,7 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 	spin_unlock(&inode->i_lock);
 
 	ext4_mark_inode_dirty(handle, inode);
-
 err_out:
-
 	return retval;
 }
 
@@ -392,7 +363,6 @@ static int free_ext_idx(handle_t *handle, struct inode *inode,
 	struct buffer_head *bh;
 	struct ext4_extent_header *eh;
 
-
 	block = idx_pblock(ix);
 	bh = sb_bread(inode->i_sb, block);
 	if (!bh)
@@ -400,24 +370,19 @@ static int free_ext_idx(handle_t *handle, struct inode *inode,
 
 	eh = (struct ext4_extent_header *)bh->b_data;
 	if (eh->eh_depth == 0) {
-
 		brelse(bh);
 		ext4_free_blocks(handle, inode, block, 1, 1);
-
 	} else {
-
 		ix = EXT_FIRST_INDEX(eh);
 		for (i = 0; i < le16_to_cpu(eh->eh_entries); i++, ix++) {
 			retval = free_ext_idx(handle, inode, ix);
 			if (retval)
 				return retval;
 		}
-
 	}
-
 	return retval;
-
 }
+
 /*
  * Free the extent meta data blocks only
  */
@@ -439,10 +404,10 @@ static int free_ext_block(handle_t *handle, struct inode *inode)
 		if (retval)
 			return retval;
 	}
-
 	return retval;
 
 }
+
 int ext4_ext_migrate(struct inode *inode, struct file *filp,
 				unsigned int cmd, unsigned long arg)
 {
@@ -455,7 +420,6 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 	struct list_blocks_struct lb;
 	unsigned long max_entries;
 
-
 	if (!test_opt(inode->i_sb, EXTENTS)) {
 		/*
 		 * if mounted with noextents
@@ -468,8 +432,6 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 		return -EINVAL;
 
 	down_write(&EXT4_I(inode)->i_data_sem);
-
-
 	handle = ext4_journal_start(inode,
 					EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
@@ -479,18 +441,15 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 		retval = PTR_ERR(handle);
 		goto err_out;
 	}
-
 	tmp_inode = ext4_new_inode(handle,
 				inode->i_sb->s_root->d_inode,
 				S_IFREG);
-
 	if (IS_ERR(tmp_inode)) {
 		retval = -ENOMEM;
 		ext4_journal_stop(handle);
 		tmp_inode = NULL;
 		goto err_out;
 	}
-
 	i_size_write(tmp_inode, i_size_read(inode));
 	/*
 	 * We don't want the inode to be reclaimed
@@ -523,7 +482,6 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 	 */
 	handle = ext4_journal_start(inode, 1);
 	for (i = 0; i < EXT4_NDIR_BLOCKS; i++, blk_count++) {
-
 		if (i_data[i]) {
 			retval = update_extent_range(handle, tmp_inode,
 						le32_to_cpu(i_data[i]),
@@ -532,7 +490,6 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 				goto err_out;
 		}
 	}
-
 	if (i_data[EXT4_IND_BLOCK]) {
 		retval = update_ind_extent_range(handle, tmp_inode,
 					le32_to_cpu(i_data[EXT4_IND_BLOCK]),
@@ -542,7 +499,6 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 	} else {
 		blk_count +=  max_entries;
 	}
-
 	if (i_data[EXT4_DIND_BLOCK]) {
 		retval = update_dind_extent_range(handle, tmp_inode,
 					le32_to_cpu(i_data[EXT4_DIND_BLOCK]),
@@ -552,8 +508,6 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 	} else {
 		blk_count += max_entries * max_entries;
 	}
-
-
 	if (i_data[EXT4_TIND_BLOCK]) {
 		retval = update_tind_extent_range(handle, tmp_inode,
 					le32_to_cpu(i_data[EXT4_TIND_BLOCK]),
@@ -561,12 +515,10 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 			if (retval)
 				goto err_out;
 	}
-
 	/*
 	 * Build the last extent
 	 */
 	retval = finish_range(handle, tmp_inode, &lb);
-
 err_out:
 	/*
 	 * We are either freeing extent information or indirect
@@ -577,14 +529,12 @@ err_out:
 	 *
 	 * FIXME!! we may be touching bitmaps in different block groups.
 	 */
-
 	if (ext4_journal_extend(handle,
 			4 + 2*EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb)) != 0) {
 
 		ext4_journal_restart(handle,
 				4 + 2*EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb));
 	}
-
 	if (retval) {
 		/*
 		 * Failure case delete the extent information with the
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cf2f612..416d919 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1841,13 +1841,14 @@ static unsigned long ext4_get_stripe_size(struct ext4_sb_info *sbi)
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
diff --git a/include/linux/ext4_fs_extents.h b/include/linux/ext4_fs_extents.h
index be4ada4..8bece0e 100644
--- a/include/linux/ext4_fs_extents.h
+++ b/include/linux/ext4_fs_extents.h
@@ -225,6 +225,7 @@ static inline int ext4_ext_get_actual_len(struct ext4_extent *ext)
 		(le16_to_cpu(ext->ee_len) - EXT_INIT_MAX_LEN));
 }
 
+extern void ext4_ext_store_pblock(struct ext4_extent *, ext4_fsblk_t);
 extern int ext4_extent_tree_init(handle_t *, struct inode *);
 extern int ext4_ext_calc_credits_for_insert(struct inode *, struct ext4_ext_path *);
 extern int ext4_ext_try_to_merge(struct inode *inode,
