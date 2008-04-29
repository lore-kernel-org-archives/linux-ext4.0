From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH] ext4: Group meta-data blocks together.
Date: Tue, 29 Apr 2008 16:27:27 +0530
Message-ID: <1209466647-26681-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:35936 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbYD2K54 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Apr 2008 06:57:56 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m3TAvRQD016537
	for <linux-ext4@vger.kernel.org>; Tue, 29 Apr 2008 16:27:27 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3TAvKUC938154
	for <linux-ext4@vger.kernel.org>; Tue, 29 Apr 2008 16:27:20 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m3TAvQ3g025544
	for <linux-ext4@vger.kernel.org>; Tue, 29 Apr 2008 10:57:27 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

I haven't yet tested this. Let me know what you think.

-aneesh

This adds a per inode meta-block prealloc space from which
meta-data block requests are served. This help in making
sure meta-data block are closer. This is needed to speedup
unlink of the file. Any new prealloc space is allocated near
the goal block specified. The goal block is the last block
allocated for the file. So we don't keep the data-block and
meta-data block far apart.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ext4_i.h  |    1 +
 fs/ext4/mballoc.c |  247 +++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/ext4/mballoc.h |    7 +-
 fs/ext4/super.c   |    1 +
 4 files changed, 230 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/ext4_i.h b/fs/ext4/ext4_i.h
index 26a4ae2..4f11ec4 100644
--- a/fs/ext4/ext4_i.h
+++ b/fs/ext4/ext4_i.h
@@ -161,6 +161,7 @@ struct ext4_inode_info {
 
 	/* mballoc */
 	struct list_head i_prealloc_list;
+	struct list_head i_metaprealloc_list;
 	spinlock_t i_prealloc_lock;
 };
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2a6c814..0e7a9c5 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1730,10 +1730,6 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 		ac->ac_g_ex.fe_start = sbi->s_mb_last_start;
 		spin_unlock(&sbi->s_md_lock);
 	}
-
-	/* searching for the right group start from the goal value specified */
-	group = ac->ac_g_ex.fe_group;
-
 	/* Let's just scan groups to find more-less suitable blocks */
 	cr = ac->ac_2order ? 0 : 1;
 	/*
@@ -1743,6 +1739,11 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 repeat:
 	for (; cr < 4 && ac->ac_status == AC_STATUS_CONTINUE; cr++) {
 		ac->ac_criteria = cr;
+		/*
+		 * searching for the right group start
+		 * from the goal value specified
+		 */
+		group = ac->ac_g_ex.fe_group;
 		for (i = 0; i < EXT4_SB(sb)->s_groups_count; group++, i++) {
 			struct ext4_group_info *grp;
 			struct ext4_group_desc *desc;
@@ -2842,6 +2843,23 @@ out_err:
 	return err;
 }
 
+static void
+ext4_mb_normalize_meta_data_request(struct ext4_allocation_context *ac)
+{
+	/*
+	 * Need to find what the right nomalized block num should be
+	 */
+	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
+	if (i_size_read(ac->ac_inode) >= sbi->s_mb_stream_request) {
+		/* large inode which is using inode prealloc */
+		ac->ac_g_ex.fe_len = 10;
+	} else {
+		ac->ac_g_ex.fe_len = 2;
+	}
+	mb_debug("#%u: goal %lu blocks for meta-data group\n",
+			current->pid, ac->ac_g_ex.fe_len);
+}
+
 /*
  * here we normalize request for locality group
  * Group request are normalized to s_strip size if we set the same via mount
@@ -2879,11 +2897,6 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
 	struct ext4_prealloc_space *pa;
 
-	/* do normalize only data requests, metadata requests
-	   do not need preallocation */
-	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
-		return;
-
 	/* sometime caller may want exact blocks */
 	if (unlikely(ac->ac_flags & EXT4_MB_HINT_GOAL_ONLY))
 		return;
@@ -2893,6 +2906,14 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	if (ac->ac_flags & EXT4_MB_HINT_NOPREALLOC)
 		return;
 
+	if (!(ac->ac_flags & EXT4_MB_HINT_DATA)) {
+		/* meta-data preallocation space
+		 * depends on the file size.
+		 */
+		ext4_mb_normalize_meta_data_request(ac);
+		return;
+	}
+
 	if (ac->ac_flags & EXT4_MB_HINT_GROUP_ALLOC) {
 		ext4_mb_normalize_group_request(ac);
 		return ;
@@ -3074,6 +3095,26 @@ static void ext4_mb_collect_stats(struct ext4_allocation_context *ac)
 
 	ext4_mb_store_history(ac);
 }
+/*
+ * use blocks preallocated to meta-data prealloc space
+ */
+static void ext4_mb_use_meta_block_pa(struct ext4_allocation_context *ac,
+				struct ext4_prealloc_space *pa)
+{
+	unsigned len = ac->ac_o_ex.fe_len;
+
+	ext4_get_group_no_and_offset(ac->ac_sb, pa->pa_pstart,
+					&ac->ac_b_ex.fe_group,
+					&ac->ac_b_ex.fe_start);
+	ac->ac_b_ex.fe_len = len;
+	ac->ac_status = AC_STATUS_FOUND;
+	ac->ac_pa = pa;
+
+	mb_debug("use %u/%u from meta group pa %p\n", pa->pa_pstart, len, pa);
+	pa->pa_pstart += ac->ac_b_ex.fe_len;
+	pa->pa_free -= ac->ac_b_ex.fe_len;
+	pa->pa_len -= ac->ac_b_ex.fe_len;
+}
 
 /*
  * use blocks preallocated to inode
@@ -3136,9 +3177,26 @@ static noinline int ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 	struct ext4_locality_group *lg;
 	struct ext4_prealloc_space *pa;
 
-	/* only data can be preallocated */
-	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
+	if (!(ac->ac_flags & EXT4_MB_HINT_DATA)) {
+		/* meta-data allocation request */
+		rcu_read_lock();
+		list_for_each_entry_rcu(pa, &ei->i_metaprealloc_list,
+							pa_inode_list) {
+			/* found preallocated blocks, use them */
+			spin_lock(&pa->pa_lock);
+			if (pa->pa_deleted == 0 && pa->pa_free) {
+				atomic_inc(&pa->pa_count);
+				ext4_mb_use_meta_block_pa(ac, pa);
+				spin_unlock(&pa->pa_lock);
+				ac->ac_criteria = 10;
+				rcu_read_unlock();
+				return 1;
+			}
+			spin_unlock(&pa->pa_lock);
+		}
+		rcu_read_unlock();
 		return 0;
+	}
 
 	/* first, try per-file preallocation */
 	rcu_read_lock();
@@ -3291,6 +3349,58 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 	call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
 }
 
+static noinline int
+ext4_mb_new_meta_block_pa(struct ext4_allocation_context *ac)
+{
+	struct super_block *sb = ac->ac_sb;
+	struct ext4_prealloc_space *pa;
+	struct ext4_group_info *grp;
+	struct ext4_inode_info *ei;
+
+	/* preallocate only when found space is larger then requested */
+	BUG_ON(ac->ac_o_ex.fe_len >= ac->ac_b_ex.fe_len);
+	BUG_ON(ac->ac_status != AC_STATUS_FOUND);
+
+	pa = kmem_cache_alloc(ext4_pspace_cachep, GFP_NOFS);
+	if (pa == NULL)
+		return -ENOMEM;
+
+	/* preallocation can change ac_b_ex, thus we store actually
+	 * allocated blocks for history */
+	ac->ac_f_ex = ac->ac_b_ex;
+
+	pa->pa_lstart = 0;
+	pa->pa_pstart = ext4_grp_offs_to_block(sb, &ac->ac_b_ex);
+	pa->pa_len = ac->ac_b_ex.fe_len;
+	pa->pa_free = pa->pa_len;
+	atomic_set(&pa->pa_count, 1);
+	spin_lock_init(&pa->pa_lock);
+	pa->pa_deleted = 0;
+	pa->pa_type = PA_META_PA;
+
+	mb_debug("new meta pa %p: %llu/%u\n", pa,
+				pa->pa_pstart, pa->pa_len);
+
+	ext4_mb_use_meta_block_pa(ac, pa);
+	atomic_add(pa->pa_free, &EXT4_SB(sb)->s_mb_preallocated);
+
+	ei = EXT4_I(ac->ac_inode);
+	grp = ext4_get_group_info(sb, ac->ac_b_ex.fe_group);
+
+	pa->pa_obj_lock = &ei->i_prealloc_lock;
+	pa->pa_inode = ac->ac_inode;
+
+	ext4_lock_group(sb, ac->ac_b_ex.fe_group);
+	list_add(&pa->pa_group_list, &grp->bb_prealloc_list);
+	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
+
+	spin_lock(pa->pa_obj_lock);
+	list_add_rcu(&pa->pa_inode_list, &ei->i_metaprealloc_list);
+	spin_unlock(pa->pa_obj_lock);
+
+	return 0;
+}
+
 /*
  * creates new preallocated space for given inode
  */
@@ -3353,7 +3463,7 @@ static noinline int ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 	atomic_set(&pa->pa_count, 1);
 	spin_lock_init(&pa->pa_lock);
 	pa->pa_deleted = 0;
-	pa->pa_linear = 0;
+	pa->pa_type = PA_INODE_PA;
 
 	mb_debug("new inode pa %p: %llu/%u for %u\n", pa,
 			pa->pa_pstart, pa->pa_len, pa->pa_lstart);
@@ -3409,7 +3519,7 @@ static noinline int ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 	atomic_set(&pa->pa_count, 1);
 	spin_lock_init(&pa->pa_lock);
 	pa->pa_deleted = 0;
-	pa->pa_linear = 1;
+	pa->pa_type = PA_GROUP_PA;
 
 	mb_debug("new group pa %p: %llu/%u for %u\n", pa,
 			pa->pa_pstart, pa->pa_len, pa->pa_lstart);
@@ -3439,7 +3549,9 @@ static int ext4_mb_new_preallocation(struct ext4_allocation_context *ac)
 {
 	int err;
 
-	if (ac->ac_flags & EXT4_MB_HINT_GROUP_ALLOC)
+	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
+		err = ext4_mb_new_meta_block_pa(ac);
+	else if (ac->ac_flags & EXT4_MB_HINT_GROUP_ALLOC)
 		err = ext4_mb_new_group_pa(ac);
 	else
 		err = ext4_mb_new_inode_pa(ac);
@@ -3521,6 +3633,35 @@ static noinline int ext4_mb_release_inode_pa(struct ext4_buddy *e4b,
 
 	return err;
 }
+static noinline int ext4_mb_release_meta_block_pa(struct ext4_buddy *e4b,
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
 
 static noinline int ext4_mb_release_group_pa(struct ext4_buddy *e4b,
 				struct ext4_prealloc_space *pa,
@@ -3649,11 +3790,18 @@ repeat:
 		list_del_rcu(&pa->pa_inode_list);
 		spin_unlock(pa->pa_obj_lock);
 
-		if (pa->pa_linear)
+		switch (pa->pa_type) {
+		case PA_META_PA:
+			ext4_mb_release_meta_block_pa(&e4b, pa, ac);
+			break;
+		case PA_GROUP_PA:
 			ext4_mb_release_group_pa(&e4b, pa, ac);
-		else
-			ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa, ac);
-
+			break;
+		case PA_INODE_PA:
+			ext4_mb_release_inode_pa(&e4b,
+						bitmap_bh, pa, ac);
+			break;
+		}
 		list_del(&pa->u.pa_tmp_list);
 		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
 	}
@@ -3688,10 +3836,8 @@ void ext4_mb_discard_inode_preallocations(struct inode *inode)
 	struct ext4_buddy e4b;
 	int err;
 
-	if (!test_opt(sb, MBALLOC) || !S_ISREG(inode->i_mode)) {
-		/*BUG_ON(!list_empty(&ei->i_prealloc_list));*/
+	if (!test_opt(sb, MBALLOC))
 		return;
-	}
 
 	mb_debug("discard preallocation for inode %lu\n", inode->i_ino);
 
@@ -3701,6 +3847,49 @@ void ext4_mb_discard_inode_preallocations(struct inode *inode)
 repeat:
 	/* first, collect all pa's in the inode */
 	spin_lock(&ei->i_prealloc_lock);
+	while (!list_empty(&ei->i_metaprealloc_list)) {
+		pa = list_entry(ei->i_metaprealloc_list.next,
+				struct ext4_prealloc_space, pa_inode_list);
+		BUG_ON(pa->pa_obj_lock != &ei->i_prealloc_lock);
+		spin_lock(&pa->pa_lock);
+		if (atomic_read(&pa->pa_count)) {
+			/* this shouldn't happen often - nobody should
+			 * use preallocation while we're discarding it */
+			spin_unlock(&pa->pa_lock);
+			spin_unlock(&ei->i_prealloc_lock);
+			printk(KERN_ERR "uh-oh! used pa while discarding\n");
+			WARN_ON(1);
+			schedule_timeout_uninterruptible(HZ);
+			goto repeat;
+
+		}
+		if (pa->pa_deleted == 0) {
+			pa->pa_deleted = 1;
+			spin_unlock(&pa->pa_lock);
+			list_del_rcu(&pa->pa_inode_list);
+			list_add(&pa->u.pa_tmp_list, &list);
+			continue;
+		}
+
+		/* someone is deleting pa right now */
+		spin_unlock(&pa->pa_lock);
+		spin_unlock(&ei->i_prealloc_lock);
+
+		/* we have to wait here because pa_deleted
+		 * doesn't mean pa is already unlinked from
+		 * the list. as we might be called from
+		 * ->clear_inode() the inode will get freed
+		 * and concurrent thread which is unlinking
+		 * pa from inode's list may access already
+		 * freed memory, bad-bad-bad */
+
+		/* XXX: if this happens too often, we can
+		 * add a flag to force wait only in case
+		 * of ->clear_inode(), but not in case of
+		 * regular truncate */
+		schedule_timeout_uninterruptible(HZ);
+		goto repeat;
+	}
 	while (!list_empty(&ei->i_prealloc_list)) {
 		pa = list_entry(ei->i_prealloc_list.next,
 				struct ext4_prealloc_space, pa_inode_list);
@@ -3747,7 +3936,6 @@ repeat:
 	spin_unlock(&ei->i_prealloc_lock);
 
 	list_for_each_entry_safe(pa, tmp, &list, u.pa_tmp_list) {
-		BUG_ON(pa->pa_linear != 0);
 		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
 
 		err = ext4_mb_load_buddy(sb, group, &e4b);
@@ -3762,7 +3950,18 @@ repeat:
 
 		ext4_lock_group(sb, group);
 		list_del(&pa->pa_group_list);
-		ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa, ac);
+
+		switch (pa->pa_type) {
+		case PA_META_PA:
+			ext4_mb_release_meta_block_pa(&e4b, pa, ac);
+			break;
+		case PA_INODE_PA:
+			ext4_mb_release_inode_pa(&e4b,
+					bitmap_bh, pa, ac);
+			break;
+		default:
+			BUG();
+		}
 		ext4_unlock_group(sb, group);
 
 		ext4_mb_release_desc(&e4b);
@@ -3966,7 +4165,7 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 static int ext4_mb_release_context(struct ext4_allocation_context *ac)
 {
 	if (ac->ac_pa) {
-		if (ac->ac_pa->pa_linear) {
+		if (ac->ac_pa->pa_type == PA_GROUP_PA) {
 			/* see comment in ext4_mb_use_group_pa() */
 			spin_lock(&ac->ac_pa->pa_lock);
 			ac->ac_pa->pa_pstart += ac->ac_b_ex.fe_len;
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index bfe6add..2cc8440 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -131,6 +131,10 @@ struct ext4_group_info {
 #define EXT4_MB_GRP_NEED_INIT(grp)	\
 	(test_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &((grp)->bb_state)))
 
+#define PA_INODE_PA 0
+#define PA_GROUP_PA 1
+#define PA_META_PA 2
+
 
 struct ext4_prealloc_space {
 	struct list_head	pa_inode_list;
@@ -146,8 +150,7 @@ struct ext4_prealloc_space {
 	ext4_lblk_t		pa_lstart;	/* log. block */
 	unsigned short		pa_len;		/* len of preallocated chunk */
 	unsigned short		pa_free;	/* how many blocks are free */
-	unsigned short		pa_linear;	/* consumed in one direction
-						 * strictly, for grp prealloc */
+	unsigned short		pa_type;	/* Trype of prealloc space */
 	spinlock_t		*pa_obj_lock;
 	struct inode		*pa_inode;	/* hack, for history only */
 };
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6d54397..6d237ad 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -571,6 +571,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->vfs_inode.i_version = 1;
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
+	INIT_LIST_HEAD(&ei->i_metaprealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
 	return &ei->vfs_inode;
 }
-- 
1.5.5.1.67.gbdb87.dirty

