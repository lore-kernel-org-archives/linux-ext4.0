From: jing zhang <zj.barak@gmail.com>
Subject: [PATCH] ext4: memory black hole in ext4_mb_put_pa()
Date: Sat, 3 Apr 2010 15:16:39 +0800
Message-ID: <v2vac8f92701004030016kb010413cv71ecefddf3bff824@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.211.172]:35534 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab0DCHQl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Apr 2010 03:16:41 -0400
Received: by ywh2 with SMTP id 2so1728758ywh.33
        for <linux-ext4@vger.kernel.org>; Sat, 03 Apr 2010 00:16:40 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jing Zhang <zj.barak@gmail.com>

Date: Sat  Apr 3  15:11:47     2010

The story about the life of PA starts with kmem_cache_alloc(),
followed by atomic_set() at [line:3369/3429],
	
	...
	[many algorithms of EXT4]
	...
	ac->ac_pa = pa;
	...

and is about to finish in the function, ext4_mb_release_context().

Check-Point-01, [line:4101-4125]
	
	First, the rcu_read_lock() method used conflicts with
	that at [line:4019].
	
	Second, whether RCU, by its defination, is capable of
	protecting competive writers should be concerned.
	
	Third, the locality group, please see [line:2418], is
	designed to be PERCPU.
	
	Also note, after added, pa could be at any position on
	the lg_prealloc_list.
	
	If the length of list is greater than 8, let's goto next check point.

Check-Point-02, [line:4019-4057]

	First, the atomic_read() at [line:4023] is not able to assure that
	this pa is the one we just used for block allocation. It is inited
	to be 1 at [line:3369/3429]. The pa_count at [line:4023] is just the
	number of CAs holding this pa, and I guess its value is 1 in case of
	newly created pa.
	
	Second, PAs are selected without good considerations of the sort
	effort mentioned above.
	
	Third, the selected PAs may include the just added pa at [line:4111],
	(let's lable it pa-4111)
	and if selected, let's goto next check point.

Check-Point-03, [line:4074]

	The victim, pa-4111, is destroied.

Check-Point-04, [line:4167-4168]

	After ext4_mb_add_n_trim() returns,
	ext4_mb_put_pa() may be crashed by pa-4111.

Check-Point-05, [line:3261-3269]

	First, [line:3261-3262] are copied here,

	if (!atomic_dec_and_test(&pa->pa_count) || pa->pa_free != 0)
		return;

	and are changed to,

	__3261	if (!atomic_dec_and_test(&pa->pa_count))
	__3262		return;
	__3263	if (pa->pa_free != 0)
	__3264		return;
	
	If the changed equals the original,
	the return at __3264 will kill the pa which is parameter,
	no matter pa == pa-4111. It is a black hole.
	
	Second, pa may also be killed by the return at [line:3268].

	Fixing black hole was tried, but failed, by which I was fried a few days.
	
	The relationship between PA cache and kmem_cache should be
	improved in this patch by simplifying the mechanism of
	lg/inode PA cache management.

Based upon the original, lg PA cache is changed as less as possible to
be,
	that lg PA cache is managed in simple and/or naive way,
	briefly with consideration of pa_count.

	[1] when pa is created, atomic_set(&pa->pa_count,1);
	[2] before assigned to ac_pa, pa_count++;
	[3] before added to lg cache, pa_count++;
	and
	[4] after usage by ac, put_pa(pa);
	[5] after deleted from lg cache, put_pa(pa);
	[6] after deleted from group list, put_pa(pa);

And it is also applied to inode PA cache.

       -zj

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Jing Zhang <zj.barak@gmail.com>

---

--- linux-2.6.32/fs/ext4/mballoc.h	2009-12-03 11:51:22.000000000 +0800
+++ fs/ext4-black-hole/mballoc.h	2010-04-01 20:45:30.000000000 +0800
@@ -233,4 +233,17 @@ static inline ext4_fsblk_t ext4_grp_offs
 			+ le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
 	return block;
 }
+
+static inline void ext4_mb_get_pa(struct ext4_prealloc_space *pa)
+{
+	atomic_inc(&pa->pa_count);
+}
+
+static void ext4_mb_pa_callback(struct rcu_head *);
+
+static inline void ext4_mb_put_pa(struct ext4_prealloc_space *pa)
+{
+	if (atomic_dec_and_test(&pa->pa_count))
+		call_rcu(&pa->u.pa_rcu, ext4_mb_pa_callback);
+}
 #endif
--- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
+++ fs/ext4-black-hole/mballoc-02.c	2010-04-03 13:35:34.000000000 +0800
@@ -2449,8 +2449,8 @@ static void ext4_mb_cleanup_pa(struct ex
 	list_for_each_safe(cur, tmp, &grp->bb_prealloc_list) {
 		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
 		list_del(&pa->pa_group_list);
+		ext4_mb_put_pa(pa);
 		count++;
-		kmem_cache_free(ext4_pspace_cachep, pa);
 	}
 	if (count)
 		mb_debug(1, "mballoc: %u PAs left\n", count);
@@ -2898,13 +2898,7 @@ ext4_mb_normalize_request(struct ext4_al
 	list_for_each_entry_rcu(pa, &ei->i_prealloc_list, pa_inode_list) {
 		ext4_lblk_t pa_end;

-		if (pa->pa_deleted)
-			continue;
 		spin_lock(&pa->pa_lock);
-		if (pa->pa_deleted) {
-			spin_unlock(&pa->pa_lock);
-			continue;
-		}

 		pa_end = pa->pa_lstart + pa->pa_len;

@@ -2932,18 +2926,6 @@ ext4_mb_normalize_request(struct ext4_al
 	rcu_read_unlock();
 	size = end - start;

-	/* XXX: extra loop to check we really don't overlap preallocations */
-	rcu_read_lock();
-	list_for_each_entry_rcu(pa, &ei->i_prealloc_list, pa_inode_list) {
-		ext4_lblk_t pa_end;
-		spin_lock(&pa->pa_lock);
-		if (pa->pa_deleted == 0) {
-			pa_end = pa->pa_lstart + pa->pa_len;
-			BUG_ON(!(start >= pa_end || end <= pa->pa_lstart));
-		}
-		spin_unlock(&pa->pa_lock);
-	}
-	rcu_read_unlock();

 	if (start + size <= ac->ac_o_ex.fe_logical &&
 			start > ac->ac_o_ex.fe_logical) {
@@ -3071,7 +3053,7 @@ ext4_mb_check_group_pa(ext4_fsblk_t goal
 	ext4_fsblk_t cur_distance, new_distance;

 	if (cpa == NULL) {
-		atomic_inc(&pa->pa_count);
+		ext4_mb_get_pa(pa);
 		return pa;
 	}
 	cur_distance = abs(goal_block - cpa->pa_pstart);
@@ -3081,8 +3063,8 @@ ext4_mb_check_group_pa(ext4_fsblk_t goal
 		return cpa;

 	/* drop the previous reference */
-	atomic_dec(&cpa->pa_count);
-	atomic_inc(&pa->pa_count);
+	ext4_mb_put_pa(cpa);
+	ext4_mb_get_pa(pa);
 	return pa;
 }

@@ -3119,8 +3101,8 @@ ext4_mb_use_preallocated(struct ext4_all

 		/* found preallocated blocks, use them */
 		spin_lock(&pa->pa_lock);
-		if (pa->pa_deleted == 0 && pa->pa_free) {
-			atomic_inc(&pa->pa_count);
+		if (pa->pa_free) {
+			ext4_mb_get_pa(pa);
 			ext4_mb_use_inode_pa(ac, pa);
 			spin_unlock(&pa->pa_lock);
 			ac->ac_criteria = 10;
@@ -3156,8 +3138,7 @@ ext4_mb_use_preallocated(struct ext4_all
 		list_for_each_entry_rcu(pa, &lg->lg_prealloc_list[i],
 					pa_inode_list) {
 			spin_lock(&pa->pa_lock);
-			if (pa->pa_deleted == 0 &&
-					pa->pa_free >= ac->ac_o_ex.fe_len) {
+			if (pa->pa_free >= ac->ac_o_ex.fe_len) {

 				cpa = ext4_mb_check_group_pa(goal_block,
 								pa, cpa);
@@ -3249,64 +3230,6 @@ static void ext4_mb_pa_callback(struct r
 }

 /*
- * drops a reference to preallocated space descriptor
- * if this was the last reference and the space is consumed
- */
-static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
-			struct super_block *sb, struct ext4_prealloc_space *pa)
-{
-	ext4_group_t grp;
-	ext4_fsblk_t grp_blk;
-
-	if (!atomic_dec_and_test(&pa->pa_count) || pa->pa_free != 0)
-		return;
-
-	/* in this short window concurrent discard can set pa_deleted */
-	spin_lock(&pa->pa_lock);
-	if (pa->pa_deleted == 1) {
-		spin_unlock(&pa->pa_lock);
-		return;
-	}
-
-	pa->pa_deleted = 1;
-	spin_unlock(&pa->pa_lock);
-
-	grp_blk = pa->pa_pstart;
-	/*
-	 * If doing group-based preallocation, pa_pstart may be in the
-	 * next group when pa is used up
-	 */
-	if (pa->pa_type == MB_GROUP_PA)
-		grp_blk--;
-
-	ext4_get_group_no_and_offset(sb, grp_blk, &grp, NULL);
-
-	/*
-	 * possible race:
-	 *
-	 *  P1 (buddy init)			P2 (regular allocation)
-	 *					find block B in PA
-	 *  copy on-disk bitmap to buddy
-	 *  					mark B in on-disk bitmap
-	 *					drop PA from group
-	 *  mark all PAs in buddy
-	 *
-	 * thus, P1 initializes buddy with B available. to prevent this
-	 * we make "copy" and "mark all PAs" atomic and serialize "drop PA"
-	 * against that pair
-	 */
-	ext4_lock_group(sb, grp);
-	list_del(&pa->pa_group_list);
-	ext4_unlock_group(sb, grp);
-
-	spin_lock(pa->pa_obj_lock);
-	list_del_rcu(&pa->pa_inode_list);
-	spin_unlock(pa->pa_obj_lock);
-
-	call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
-}
-
-/*
  * creates new preallocated space for given inode
  */
 static noinline_for_stack int
@@ -3377,6 +3300,7 @@ ext4_mb_new_inode_pa(struct ext4_allocat
 			pa->pa_pstart, pa->pa_len, pa->pa_lstart);
 	trace_ext4_mb_new_inode_pa(ac, pa);

+	ext4_mb_get_pa(pa);
 	ext4_mb_use_inode_pa(ac, pa);
 	atomic_add(pa->pa_free, &EXT4_SB(sb)->s_mb_preallocated);

@@ -3390,6 +3314,7 @@ ext4_mb_new_inode_pa(struct ext4_allocat
 	list_add(&pa->pa_group_list, &grp->bb_prealloc_list);
 	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);

+	ext4_mb_get_pa(pa);
 	spin_lock(pa->pa_obj_lock);
 	list_add_rcu(&pa->pa_inode_list, &ei->i_prealloc_list);
 	spin_unlock(pa->pa_obj_lock);
@@ -3437,6 +3362,7 @@ ext4_mb_new_group_pa(struct ext4_allocat
 			pa->pa_pstart, pa->pa_len, pa->pa_lstart);
 	trace_ext4_mb_new_group_pa(ac, pa);

+	ext4_mb_get_pa(pa);
 	ext4_mb_use_group_pa(ac, pa);
 	atomic_add(pa->pa_free, &EXT4_SB(sb)->s_mb_preallocated);

@@ -3493,7 +3419,6 @@ ext4_mb_release_inode_pa(struct ext4_bud
 	int err = 0;
 	int free = 0;

-	BUG_ON(pa->pa_deleted == 0);
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
 	grp_blk_start = pa->pa_pstart - bit;
 	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
@@ -3557,7 +3482,6 @@ ext4_mb_release_group_pa(struct ext4_bud
 	ext4_grpblk_t bit;

 	trace_ext4_mb_release_group_pa(ac, pa);
-	BUG_ON(pa->pa_deleted == 0);
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
 	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
 	mb_free_blocks(pa->pa_inode, e4b, bit, pa->pa_len);
@@ -3593,14 +3517,14 @@ ext4_mb_discard_group_preallocations(str
 	struct buffer_head *bitmap_bh = NULL;
 	struct ext4_prealloc_space *pa, *tmp;
 	struct ext4_allocation_context *ac;
-	struct list_head list;
 	struct ext4_buddy e4b;
 	int err;
-	int busy = 0;
 	int free = 0;

 	mb_debug(1, "discard preallocation for group %u\n", group);

+	if (needed <= 0)
+		return free;
 	if (list_empty(&grp->bb_prealloc_list))
 		return 0;

@@ -3622,74 +3546,33 @@ ext4_mb_discard_group_preallocations(str
 	if (needed == 0)
 		needed = EXT4_BLOCKS_PER_GROUP(sb) + 1;

-	INIT_LIST_HEAD(&list);
 	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
 	if (ac)
 		ac->ac_sb = sb;
-repeat:
+
 	ext4_lock_group(sb, group);
-	list_for_each_entry_safe(pa, tmp,
+	/* it is LRU */
+	list_for_each_entry_safe_reverse(pa, tmp,
 				&grp->bb_prealloc_list, pa_group_list) {
 		spin_lock(&pa->pa_lock);
-		if (atomic_read(&pa->pa_count)) {
-			spin_unlock(&pa->pa_lock);
-			busy = 1;
-			continue;
-		}
-		if (pa->pa_deleted) {
-			spin_unlock(&pa->pa_lock);
-			continue;
-		}
-
-		/* seems this one can be freed ... */
-		pa->pa_deleted = 1;
-
 		/* we can trust pa_free ... */
 		free += pa->pa_free;
-
 		spin_unlock(&pa->pa_lock);

-		list_del(&pa->pa_group_list);
-		list_add(&pa->u.pa_tmp_list, &list);
-	}
-
-	/* if we still need more blocks and some PAs were used, try again */
-	if (free < needed && busy) {
-		busy = 0;
-		ext4_unlock_group(sb, group);
-		/*
-		 * Yield the CPU here so that we don't get soft lockup
-		 * in non preempt case.
-		 */
-		yield();
-		goto repeat;
-	}
-
-	/* found anything to free? */
-	if (list_empty(&list)) {
-		BUG_ON(free != 0);
-		goto out;
-	}
-
-	/* now free all selected PAs */
-	list_for_each_entry_safe(pa, tmp, &list, u.pa_tmp_list) {
-
-		/* remove from object (inode or locality group) */
-		spin_lock(pa->pa_obj_lock);
-		list_del_rcu(&pa->pa_inode_list);
-		spin_unlock(pa->pa_obj_lock);
-
+		list_del_init(&pa->pa_group_list);
 		if (pa->pa_type == MB_GROUP_PA)
 			ext4_mb_release_group_pa(&e4b, pa, ac);
 		else
-			ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa, ac);
-
-		list_del(&pa->u.pa_tmp_list);
-		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
+			ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa, ac);		
+		ext4_mb_put_pa(pa);
+		/*
+		 * no suck, please, just do the needed.
+		 */
+		if (free >= needed)
+			break;
 	}
-
-out:
 	ext4_unlock_group(sb, group);
+
 	if (ac)
 		kmem_cache_free(ext4_ac_cachep, ac);
 	ext4_mb_release_desc(&e4b);
@@ -3709,110 +3592,23 @@ out:
 void ext4_discard_preallocations(struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	struct super_block *sb = inode->i_sb;
-	struct buffer_head *bitmap_bh = NULL;
 	struct ext4_prealloc_space *pa, *tmp;
-	struct ext4_allocation_context *ac;
-	ext4_group_t group = 0;
-	struct list_head list;
-	struct ext4_buddy e4b;
-	int err;

 	if (!S_ISREG(inode->i_mode)) {
-		/*BUG_ON(!list_empty(&ei->i_prealloc_list));*/
 		return;
 	}

 	mb_debug(1, "discard preallocation for inode %lu\n", inode->i_ino);
 	trace_ext4_discard_preallocations(inode);

-	INIT_LIST_HEAD(&list);
-
-	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
-	if (ac) {
-		ac->ac_sb = sb;
-		ac->ac_inode = inode;
-	}
-repeat:
-	/* first, collect all pa's in the inode */
 	spin_lock(&ei->i_prealloc_lock);
 	while (!list_empty(&ei->i_prealloc_list)) {
 		pa = list_entry(ei->i_prealloc_list.next,
 				struct ext4_prealloc_space, pa_inode_list);
-		BUG_ON(pa->pa_obj_lock != &ei->i_prealloc_lock);
-		spin_lock(&pa->pa_lock);
-		if (atomic_read(&pa->pa_count)) {
-			/* this shouldn't happen often - nobody should
-			 * use preallocation while we're discarding it */
-			spin_unlock(&pa->pa_lock);
-			spin_unlock(&ei->i_prealloc_lock);
-			printk(KERN_ERR "uh-oh! used pa while discarding\n");
-			WARN_ON(1);
-			schedule_timeout_uninterruptible(HZ);
-			goto repeat;
-
-		}
-		if (pa->pa_deleted == 0) {
-			pa->pa_deleted = 1;
-			spin_unlock(&pa->pa_lock);
-			list_del_rcu(&pa->pa_inode_list);
-			list_add(&pa->u.pa_tmp_list, &list);
-			continue;
-		}
-
-		/* someone is deleting pa right now */
-		spin_unlock(&pa->pa_lock);
-		spin_unlock(&ei->i_prealloc_lock);
-
-		/* we have to wait here because pa_deleted
-		 * doesn't mean pa is already unlinked from
-		 * the list. as we might be called from
-		 * ->clear_inode() the inode will get freed
-		 * and concurrent thread which is unlinking
-		 * pa from inode's list may access already
-		 * freed memory, bad-bad-bad */
-
-		/* XXX: if this happens too often, we can
-		 * add a flag to force wait only in case
-		 * of ->clear_inode(), but not in case of
-		 * regular truncate */
-		schedule_timeout_uninterruptible(HZ);
-		goto repeat;
+		list_del_rcu(&pa->pa_inode_list);
+		ext4_mb_put_pa(pa);
 	}
 	spin_unlock(&ei->i_prealloc_lock);
-
-	list_for_each_entry_safe(pa, tmp, &list, u.pa_tmp_list) {
-		BUG_ON(pa->pa_type != MB_INODE_PA);
-		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
-
-		err = ext4_mb_load_buddy(sb, group, &e4b);
-		if (err) {
-			ext4_error(sb, __func__, "Error in loading buddy "
-					"information for %u", group);
-			continue;
-		}
-
-		bitmap_bh = ext4_read_block_bitmap(sb, group);
-		if (bitmap_bh == NULL) {
-			ext4_error(sb, __func__, "Error in reading block "
-					"bitmap for %u", group);
-			ext4_mb_release_desc(&e4b);
-			continue;
-		}
-
-		ext4_lock_group(sb, group);
-		list_del(&pa->pa_group_list);
-		ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa, ac);
-		ext4_unlock_group(sb, group);
-
-		ext4_mb_release_desc(&e4b);
-		put_bh(bitmap_bh);
-
-		list_del(&pa->u.pa_tmp_list);
-		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
-	}
-	if (ac)
-		kmem_cache_free(ext4_ac_cachep, ac);
 }

 /*
@@ -3998,85 +3794,6 @@ ext4_mb_initialize_context(struct ext4_a

 }

-static noinline_for_stack void
-ext4_mb_discard_lg_preallocations(struct super_block *sb,
-					struct ext4_locality_group *lg,
-					int order, int total_entries)
-{
-	ext4_group_t group = 0;
-	struct ext4_buddy e4b;
-	struct list_head discard_list;
-	struct ext4_prealloc_space *pa, *tmp;
-	struct ext4_allocation_context *ac;
-
-	mb_debug(1, "discard locality group preallocation\n");
-
-	INIT_LIST_HEAD(&discard_list);
-	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
-	if (ac)
-		ac->ac_sb = sb;
-
-	spin_lock(&lg->lg_prealloc_lock);
-	list_for_each_entry_rcu(pa, &lg->lg_prealloc_list[order],
-						pa_inode_list) {
-		spin_lock(&pa->pa_lock);
-		if (atomic_read(&pa->pa_count)) {
-			/*
-			 * This is the pa that we just used
-			 * for block allocation. So don't
-			 * free that
-			 */
-			spin_unlock(&pa->pa_lock);
-			continue;
-		}
-		if (pa->pa_deleted) {
-			spin_unlock(&pa->pa_lock);
-			continue;
-		}
-		/* only lg prealloc space */
-		BUG_ON(pa->pa_type != MB_GROUP_PA);
-
-		/* seems this one can be freed ... */
-		pa->pa_deleted = 1;
-		spin_unlock(&pa->pa_lock);
-
-		list_del_rcu(&pa->pa_inode_list);
-		list_add(&pa->u.pa_tmp_list, &discard_list);
-
-		total_entries--;
-		if (total_entries <= 5) {
-			/*
-			 * we want to keep only 5 entries
-			 * allowing it to grow to 8. This
-			 * mak sure we don't call discard
-			 * soon for this list.
-			 */
-			break;
-		}
-	}
-	spin_unlock(&lg->lg_prealloc_lock);
-
-	list_for_each_entry_safe(pa, tmp, &discard_list, u.pa_tmp_list) {
-
-		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
-		if (ext4_mb_load_buddy(sb, group, &e4b)) {
-			ext4_error(sb, __func__, "Error in loading buddy "
-					"information for %u", group);
-			continue;
-		}
-		ext4_lock_group(sb, group);
-		list_del(&pa->pa_group_list);
-		ext4_mb_release_group_pa(&e4b, pa, ac);
-		ext4_unlock_group(sb, group);
-
-		ext4_mb_release_desc(&e4b);
-		list_del(&pa->u.pa_tmp_list);
-		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
-	}
-	if (ac)
-		kmem_cache_free(ext4_ac_cachep, ac);
-}
-
 /*
  * We have incremented pa_count. So it cannot be freed at this
  * point. Also we hold lg_mutex. So no parallel allocation is
@@ -4089,48 +3806,48 @@ ext4_mb_discard_lg_preallocations(struct
 static void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
 {
 	int order, added = 0, lg_prealloc_count = 1;
-	struct super_block *sb = ac->ac_sb;
 	struct ext4_locality_group *lg = ac->ac_lg;
 	struct ext4_prealloc_space *tmp_pa, *pa = ac->ac_pa;
+	/* is in cache already? */
+	int needed = list_empty(&pa->pa_inode_list);

 	order = fls(pa->pa_free) - 1;
 	if (order > PREALLOC_TB_SIZE - 1)
 		/* The max size of hash table is PREALLOC_TB_SIZE */
 		order = PREALLOC_TB_SIZE - 1;
-	/* Add the prealloc space to lg */
-	rcu_read_lock();
+
+	/* why not &lg->lg_prealloc_list[order].lock? */
+	spin_lock(&lg->lg_prealloc_lock);
+
+#define __lg_cache_wm 5 /* water mark */
+
 	list_for_each_entry_rcu(tmp_pa, &lg->lg_prealloc_list[order],
-						pa_inode_list) {
-		spin_lock(&tmp_pa->pa_lock);
-		if (tmp_pa->pa_deleted) {
-			spin_unlock(&tmp_pa->pa_lock);
-			continue;
-		}
-		if (!added && pa->pa_free < tmp_pa->pa_free) {
-			/* Add to the tail of the previous entry */
-			list_add_tail_rcu(&pa->pa_inode_list,
-						&tmp_pa->pa_inode_list);
-			added = 1;
-			/*
-			 * we want to count the total
-			 * number of entries in the list
-			 */
+					pa_inode_list) {
+		if (lg_prealloc_count++ <= __lg_cache_wm) {
+			if (needed && ! added && pa->pa_free) {
+				spin_lock(&tmp_pa->pa_lock);
+				if (pa->pa_free < tmp_pa->pa_free) {
+					ext4_mb_get_pa(pa);
+					list_add_tail_rcu(&pa->pa_inode_list,
+							&tmp_pa->pa_inode_list);
+					added = 1;
+				}
+				spin_unlock(&tmp_pa->pa_lock);
+			}
+		} else {
+			list_del_rcu(&tmp_pa->pa_inode_list);
+			ext4_mb_put_pa(tmp_pa);
 		}
-		spin_unlock(&tmp_pa->pa_lock);
-		lg_prealloc_count++;
 	}
-	if (!added)
-		list_add_tail_rcu(&pa->pa_inode_list,
-					&lg->lg_prealloc_list[order]);
-	rcu_read_unlock();
-
-	/* Now trim the list to be not more than 8 elements */
-	if (lg_prealloc_count > 8) {
-		ext4_mb_discard_lg_preallocations(sb, lg,
-						order, lg_prealloc_count);
-		return;
+	if (needed && !added && pa->pa_free) {
+		ext4_mb_get_pa(pa);
+		list_add_rcu(&pa->pa_inode_list,
+				&lg->lg_prealloc_list[order]);
 	}
-	return ;
+
+#undef __lg_cache_wm
+
+	spin_unlock(&lg->lg_prealloc_lock);
 }

 /*
@@ -4153,20 +3870,11 @@ static int ext4_mb_release_context(struc
 	if (ac->alloc_semp)
 		up_read(ac->alloc_semp);
 	if (pa) {
-		/*
-		 * We want to add the pa to the right bucket.
-		 * Remove it from the list and while adding
-		 * make sure the list to which we are adding
-		 * doesn't grow big.  We need to release
-		 * alloc_semp before calling ext4_mb_add_n_trim()
-		 */
-		if ((pa->pa_type == MB_GROUP_PA) && likely(pa->pa_free)) {
-			spin_lock(pa->pa_obj_lock);
-			list_del_rcu(&pa->pa_inode_list);
-			spin_unlock(pa->pa_obj_lock);
+		if (pa->pa_type == MB_GROUP_PA) {
+			/* we have to update lg PA cache */
 			ext4_mb_add_n_trim(ac);
 		}
-		ext4_mb_put_pa(ac, ac->ac_sb, pa);
+		ext4_mb_put_pa(pa);
 	}
 	if (ac->ac_bitmap_page)
 		page_cache_release(ac->ac_bitmap_page);
