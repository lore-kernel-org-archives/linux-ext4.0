From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: delalloc is crippling fs_mark performance
Date: Tue, 22 Jul 2008 16:41:37 +0530
Message-ID: <20080722111137.GA17860@skywalker>
References: <4880C0B2.9040706@redhat.com> <4884B7CF.7060800@redhat.com> <20080721223935.GC15203@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:39838 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbYGVLNP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jul 2008 07:13:15 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m6MBCBTI021000
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 21:12:11 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6MBBvbS300222
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 21:11:57 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6MBBvVh032518
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 21:11:57 +1000
Content-Disposition: inline
In-Reply-To: <20080721223935.GC15203@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 21, 2008 at 04:39:35PM -0600, Andreas Dilger wrote:
> On Jul 21, 2008  11:22 -0500, Eric Sandeen wrote:
> > Eric Sandeen wrote:
> > > running fs_mark like this:
> > > 
> > > fs_mark -d /mnt/test -D 256 -n 100000 -t 4 -s 20480 -F -S 0
> > > 
> > > (256 subdirs, 100000 files/iteration, 4 threads, 20k files, no sync)
> > > 
> > > on a 1T fs, with and without delalloc (mount option), is pretty interesting:
> > > 
> > > http://people.redhat.com/esandeen/ext4/fs_mark.png
> > 
> > I've updated this graph with another run where the group_prealloc
> > tuneable was set to a perfect multiple of the allocation size, or 500
> > blocks.  This way the leftover 2-block preallocations don't wind up
> > causing the list to grow with unuseable tiny leftover preallocations.
> > After tuning this way, it does clearly seem to be the problem here.
> 
> Looking at that graph it would seem that allowing 1000 PAs to accumulate
> with Aneesh's patch adds a constant slowdown.  Compared with the "perfect"
> case where the PA list is always empty it is noticably slower.
> 
> I'd guess that the right thing to do is have a few buckets for PAs of
> different sizes, and keep them very short (e.g. <= 8) to avoid a lot of
> list walking overhead on each access.
> 
> I think keeping a single PA of "each size" would likely run out if
> different-sized allocations are being done, requiring a re-search.
> 

How about

>From 049cfcf425e57fba0c3d1555e3f9f72f8104b4ed Mon Sep 17 00:00:00 2001
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Tue, 22 Jul 2008 16:39:07 +0530
Subject: [PATCH] ext4: Don't allow lg prealloc list to be grow large.

Currently locality group prealloc list is freed only when there is a block allocation
failure. This can result in large number of per cpu locality group prealloc space
and also make the ext4_mb_use_preallocated expensive. Convert the locality group
prealloc list to a hash list. The hash index is the order of number of blocks
in the prealloc space with a max order of 9. When adding prealloc space to the
list we make sure total entries for each order does not exceed 8. If it is more
than 8 we discard few entries and make sure the we have only <= 5 entries.


Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |  266 +++++++++++++++++++++++++++++++++++++++++------------
 fs/ext4/mballoc.h |   10 ++-
 2 files changed, 215 insertions(+), 61 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5b854b7..e058509 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2481,7 +2481,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
 int ext4_mb_init(struct super_block *sb, int needs_recovery)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	unsigned i;
+	unsigned i, j;
 	unsigned offset;
 	unsigned max;
 	int ret;
@@ -2553,7 +2553,8 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 		struct ext4_locality_group *lg;
 		lg = &sbi->s_locality_groups[i];
 		mutex_init(&lg->lg_mutex);
-		INIT_LIST_HEAD(&lg->lg_prealloc_list);
+		for (j = 0; j < PREALLOC_TB_SIZE; j++)
+			INIT_LIST_HEAD(&lg->lg_prealloc_list[j]);
 		spin_lock_init(&lg->lg_prealloc_lock);
 	}
 
@@ -3258,12 +3259,68 @@ static void ext4_mb_use_inode_pa(struct ext4_allocation_context *ac,
 }
 
 /*
+ * release the locality group prealloc space.
+ * called with lg_mutex held
+ * called with lg->lg_prealloc_lock held
+ */
+static noinline_for_stack void
+ext4_mb_discard_lg_preallocations_prep(struct list_head *discard_list,
+					struct list_head *lg_prealloc_list,
+					int total_entries)
+{
+	struct ext4_prealloc_space *pa;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(pa, lg_prealloc_list, pa_inode_list) {
+		spin_lock(&pa->pa_lock);
+		if (atomic_read(&pa->pa_count)) {
+			spin_unlock(&pa->pa_lock);
+			continue;
+		}
+		if (pa->pa_deleted) {
+			spin_unlock(&pa->pa_lock);
+			continue;
+		}
+		/* only lg prealloc space */
+		BUG_ON(!pa->pa_linear);
+
+		/* seems this one can be freed ... */
+		pa->pa_deleted = 1;
+		spin_unlock(&pa->pa_lock);
+
+
+		list_del_rcu(&pa->pa_inode_list);
+		list_add(&pa->u.pa_tmp_list, discard_list);
+
+		total_entries--;
+		if (total_entries <= 5) {
+			/*
+			 * we want to keep only 5 entries
+			 * allowing it to grow to 8. This
+			 * mak sure we don't call discard
+			 * soon for this list.
+			 */
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return;
+}
+
+/*
  * use blocks preallocated to locality group
+ * called with lg->lg_prealloc_lock held
  */
 static void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
-				struct ext4_prealloc_space *pa)
+				struct ext4_prealloc_space *pa,
+				struct list_head *discard_list)
 {
+	int order, added = 0, lg_prealloc_count = 1;
 	unsigned int len = ac->ac_o_ex.fe_len;
+	struct ext4_prealloc_space *tmp_pa;
+	struct ext4_locality_group *lg = ac->ac_lg;
+
 	ext4_get_group_no_and_offset(ac->ac_sb, pa->pa_pstart,
 					&ac->ac_b_ex.fe_group,
 					&ac->ac_b_ex.fe_start);
@@ -3278,6 +3335,112 @@ static void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
 	 * Other CPUs are prevented from allocating from this pa by lg_mutex
 	 */
 	mb_debug("use %u/%u from group pa %p\n", pa->pa_lstart-len, len, pa);
+
+	/* remove the pa from the current list and add it to the new list */
+	pa->pa_free -= len;
+	order  = fls(pa->pa_free) - 1;
+
+	/* remove from the old list */
+	list_del_rcu(&pa->pa_inode_list);
+
+	list_for_each_entry_rcu(tmp_pa, &lg->lg_prealloc_list[order],
+					pa_inode_list) {
+		if (!added && pa->pa_free < tmp_pa->pa_free) {
+			/* Add to the tail of the previous entry */
+			list_add_tail_rcu(&pa->pa_inode_list,
+					tmp_pa->pa_inode_list.prev);
+			added = 1;
+			/* we want to count the total
+			 * number of entries in the list
+			 */
+		}
+		lg_prealloc_count++;
+	}
+	if (!added)
+		list_add_tail_rcu(&pa->pa_inode_list, &tmp_pa->pa_inode_list);
+
+	/* Now trim the list to be not more than 8 elements */
+	if (lg_prealloc_count > 8) {
+		/*
+		 * We can remove the prealloc space from grp->bb_prealloc_list
+		 * here because we are holding lg_prealloc_lock and can't take
+		 * group lock.
+		 */
+		ext4_mb_discard_lg_preallocations_prep(discard_list,
+						&lg->lg_prealloc_list[order],
+						lg_prealloc_count);
+	}
+}
+
+static noinline_for_stack int
+ext4_mb_release_group_pa(struct ext4_buddy *e4b,
+				struct ext4_prealloc_space *pa,
+				struct ext4_allocation_context *ac)
+{
+	struct super_block *sb = e4b->bd_sb;
+	ext4_group_t group;
+	ext4_grpblk_t bit;
+
+	if (ac)
+		ac->ac_op = EXT4_MB_HISTORY_DISCARD;
+
+	BUG_ON(pa->pa_deleted == 0);
+	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
+	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
+	mb_free_blocks(pa->pa_inode, e4b, bit, pa->pa_len);
+	atomic_add(pa->pa_len, &EXT4_SB(sb)->s_mb_discarded);
+
+	if (ac) {
+		ac->ac_sb = sb;
+		ac->ac_inode = NULL;
+		ac->ac_b_ex.fe_group = group;
+		ac->ac_b_ex.fe_start = bit;
+		ac->ac_b_ex.fe_len = pa->pa_len;
+		ac->ac_b_ex.fe_logical = 0;
+		ext4_mb_store_history(ac);
+	}
+
+	return 0;
+}
+
+static void ext4_mb_pa_callback(struct rcu_head *head)
+{
+	struct ext4_prealloc_space *pa;
+	pa = container_of(head, struct ext4_prealloc_space, u.pa_rcu);
+	kmem_cache_free(ext4_pspace_cachep, pa);
+}
+
+static noinline_for_stack void
+ext4_mb_discard_lg_preallocations_commit(struct super_block *sb,
+					struct list_head *discard_list)
+{
+	ext4_group_t group = 0;
+	struct ext4_buddy e4b;
+	struct ext4_allocation_context *ac;
+	struct ext4_prealloc_space *pa, *tmp;
+
+	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
+
+	list_for_each_entry_safe(pa, tmp, discard_list, u.pa_tmp_list) {
+
+		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
+		if (ext4_mb_load_buddy(sb, group, &e4b)) {
+			ext4_error(sb, __func__, "Error in loading buddy "
+					"information for %lu\n", group);
+			continue;
+		}
+		ext4_lock_group(sb, group);
+		list_del(&pa->pa_group_list);
+		ext4_mb_release_group_pa(&e4b, pa, ac);
+		ext4_unlock_group(sb, group);
+
+		ext4_mb_release_desc(&e4b);
+		list_del(&pa->u.pa_tmp_list);
+		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
+	}
+	if (ac)
+		kmem_cache_free(ext4_ac_cachep, ac);
+	return;
 }
 
 /*
@@ -3286,14 +3449,17 @@ static void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
 static noinline_for_stack int
 ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 {
+	int order, lg_prealloc_count = 0, i;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
 	struct ext4_locality_group *lg;
 	struct ext4_prealloc_space *pa;
+	struct list_head discard_list;
 
 	/* only data can be preallocated */
 	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
 		return 0;
 
+	INIT_LIST_HEAD(&discard_list);
 	/* first, try per-file preallocation */
 	rcu_read_lock();
 	list_for_each_entry_rcu(pa, &ei->i_prealloc_list, pa_inode_list) {
@@ -3326,22 +3492,39 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 	lg = ac->ac_lg;
 	if (lg == NULL)
 		return 0;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(pa, &lg->lg_prealloc_list, pa_inode_list) {
-		spin_lock(&pa->pa_lock);
-		if (pa->pa_deleted == 0 && pa->pa_free >= ac->ac_o_ex.fe_len) {
-			atomic_inc(&pa->pa_count);
-			ext4_mb_use_group_pa(ac, pa);
+	order  = fls(ac->ac_o_ex.fe_len) - 1;
+	if (order > PREALLOC_TB_SIZE - 1)
+		/* The max size of hash table is PREALLOC_TB_SIZE */
+		order = PREALLOC_TB_SIZE - 1;
+	/*
+	 * We take the lock on the locality object to prevent a
+	 * discard via ext4_mb_discard_group_preallocations
+	 */
+	spin_lock(&lg->lg_prealloc_lock);
+	for (i = order; i < PREALLOC_TB_SIZE; i++) {
+		lg_prealloc_count = 0;
+		rcu_read_lock();
+		list_for_each_entry_rcu(pa, &lg->lg_prealloc_list[i],
+					pa_inode_list) {
+			spin_lock(&pa->pa_lock);
+			if (pa->pa_deleted == 0 &&
+					pa->pa_free >= ac->ac_o_ex.fe_len) {
+				atomic_inc(&pa->pa_count);
+				ext4_mb_use_group_pa(ac, pa, &discard_list);
+				spin_unlock(&pa->pa_lock);
+				ac->ac_criteria = 20;
+				rcu_read_unlock();
+				spin_unlock(&lg->lg_prealloc_lock);
+				return 1;
+			}
 			spin_unlock(&pa->pa_lock);
-			ac->ac_criteria = 20;
-			rcu_read_unlock();
-			return 1;
+			lg_prealloc_count++;
 		}
-		spin_unlock(&pa->pa_lock);
+		rcu_read_unlock();
 	}
-	rcu_read_unlock();
-
+	spin_unlock(&lg->lg_prealloc_lock);
+	ext4_mb_discard_lg_preallocations_commit(ac->ac_sb,
+						&discard_list);
 	return 0;
 }
 
@@ -3388,13 +3571,6 @@ static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 	mb_debug("prellocated %u for group %lu\n", preallocated, group);
 }
 
-static void ext4_mb_pa_callback(struct rcu_head *head)
-{
-	struct ext4_prealloc_space *pa;
-	pa = container_of(head, struct ext4_prealloc_space, u.pa_rcu);
-	kmem_cache_free(ext4_pspace_cachep, pa);
-}
-
 /*
  * drops a reference to preallocated space descriptor
  * if this was the last reference and the space is consumed
@@ -3543,6 +3719,7 @@ ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 	struct ext4_locality_group *lg;
 	struct ext4_prealloc_space *pa;
 	struct ext4_group_info *grp;
+	struct list_head discard_list;
 
 	/* preallocate only when found space is larger then requested */
 	BUG_ON(ac->ac_o_ex.fe_len >= ac->ac_b_ex.fe_len);
@@ -3554,6 +3731,7 @@ ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 	if (pa == NULL)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&discard_list);
 	/* preallocation can change ac_b_ex, thus we store actually
 	 * allocated blocks for history */
 	ac->ac_f_ex = ac->ac_b_ex;
@@ -3564,13 +3742,13 @@ ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 	pa->pa_free = pa->pa_len;
 	atomic_set(&pa->pa_count, 1);
 	spin_lock_init(&pa->pa_lock);
+	INIT_LIST_HEAD(&pa->pa_inode_list);
 	pa->pa_deleted = 0;
 	pa->pa_linear = 1;
 
 	mb_debug("new group pa %p: %llu/%u for %u\n", pa,
 			pa->pa_pstart, pa->pa_len, pa->pa_lstart);
 
-	ext4_mb_use_group_pa(ac, pa);
 	atomic_add(pa->pa_free, &EXT4_SB(sb)->s_mb_preallocated);
 
 	grp = ext4_get_group_info(sb, ac->ac_b_ex.fe_group);
@@ -3584,10 +3762,12 @@ ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 	list_add(&pa->pa_group_list, &grp->bb_prealloc_list);
 	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
 
-	spin_lock(pa->pa_obj_lock);
-	list_add_tail_rcu(&pa->pa_inode_list, &lg->lg_prealloc_list);
-	spin_unlock(pa->pa_obj_lock);
+	/* ext4_mb_use_group_pa will also add the pa to the lg list */
+	spin_lock(&lg->lg_prealloc_lock);
+	ext4_mb_use_group_pa(ac, pa, &discard_list);
+	spin_unlock(&lg->lg_prealloc_lock);
 
+	ext4_mb_discard_lg_preallocations_commit(sb, &discard_list);
 	return 0;
 }
 
@@ -3676,37 +3856,6 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
 	return err;
 }
 
-static noinline_for_stack int
-ext4_mb_release_group_pa(struct ext4_buddy *e4b,
-				struct ext4_prealloc_space *pa,
-				struct ext4_allocation_context *ac)
-{
-	struct super_block *sb = e4b->bd_sb;
-	ext4_group_t group;
-	ext4_grpblk_t bit;
-
-	if (ac)
-		ac->ac_op = EXT4_MB_HISTORY_DISCARD;
-
-	BUG_ON(pa->pa_deleted == 0);
-	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
-	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
-	mb_free_blocks(pa->pa_inode, e4b, bit, pa->pa_len);
-	atomic_add(pa->pa_len, &EXT4_SB(sb)->s_mb_discarded);
-
-	if (ac) {
-		ac->ac_sb = sb;
-		ac->ac_inode = NULL;
-		ac->ac_b_ex.fe_group = group;
-		ac->ac_b_ex.fe_start = bit;
-		ac->ac_b_ex.fe_len = pa->pa_len;
-		ac->ac_b_ex.fe_logical = 0;
-		ext4_mb_store_history(ac);
-	}
-
-	return 0;
-}
-
 /*
  * releases all preallocations in given group
  *
@@ -4136,7 +4285,6 @@ static int ext4_mb_release_context(struct ext4_allocation_context *ac)
 			spin_lock(&ac->ac_pa->pa_lock);
 			ac->ac_pa->pa_pstart += ac->ac_b_ex.fe_len;
 			ac->ac_pa->pa_lstart += ac->ac_b_ex.fe_len;
-			ac->ac_pa->pa_free -= ac->ac_b_ex.fe_len;
 			ac->ac_pa->pa_len -= ac->ac_b_ex.fe_len;
 			spin_unlock(&ac->ac_pa->pa_lock);
 		}
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 1141ad5..6b46c86 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -164,11 +164,17 @@ struct ext4_free_extent {
  * Locality group:
  *   we try to group all related changes together
  *   so that writeback can flush/allocate them together as well
+ *   Size of lg_prealloc_list hash is determined by MB_DEFAULT_GROUP_PREALLOC
+ *   (512). We store prealloc space into the hash based on the pa_free blocks
+ *   order value.ie, fls(pa_free)-1;
  */
+#define PREALLOC_TB_SIZE 10
 struct ext4_locality_group {
 	/* for allocator */
-	struct mutex		lg_mutex;	/* to serialize allocates */
-	struct list_head	lg_prealloc_list;/* list of preallocations */
+	/* to serialize allocates */
+	struct mutex		lg_mutex;
+	/* list of preallocations */
+	struct list_head	lg_prealloc_list[PREALLOC_TB_SIZE];
 	spinlock_t		lg_prealloc_lock;
 };
 
-- 
1.5.6.3.439.g1e10.dirty

