From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -v2] ext4: Group meta-data blocks together.
Date: Tue, 20 May 2008 02:06:56 +0530
Message-ID: <1211229416-11570-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:33687 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYESUhD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 May 2008 16:37:03 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m4JKbeJV014230
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 06:37:40 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4JKamDR4722748
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 06:36:48 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4JKb0EM026952
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 06:37:00 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This adds a per inode meta-block prealloc space from which
meta-data block requests are served. This help in making
sure meta-data block are closer. This is needed to speedup
unlink of the file. Any new prealloc space is allocated near
the goal block specified. The goal block is the last block
allocated for the file. So we don't keep the data-block and
meta-data block far apart.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c  |    6 +-
 fs/ext4/ext4.h    |   22 +++--
 fs/ext4/ext4_i.h  |    1 +
 fs/ext4/extents.c |    4 +-
 fs/ext4/mballoc.c |  266 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/ext4/mballoc.h |    7 +-
 fs/ext4/super.c   |    1 +
 7 files changed, 267 insertions(+), 40 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 322571b..899a3eb 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1930,6 +1930,7 @@ ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
 	ar.inode = inode;
 	ar.goal = goal;
 	ar.len = 1;
+	ar.flags = EXT4_MB_HINT_META_DATA;
 	ret = ext4_mb_new_blocks(handle, &ar, errp);
 	return ret;
 }
@@ -1948,6 +1949,7 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 	ar.inode = inode;
 	ar.goal = goal;
 	ar.len = *count;
+	ar.flags = EXT4_MB_HINT_META_DATA;
 	ret = ext4_mb_new_blocks(handle, &ar, errp);
 	*count = ar.len;
 	return ret;
@@ -1977,10 +1979,10 @@ ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 	ar.len = *count;
 	ar.logical = iblock;
 	if (S_ISREG(inode->i_mode))
-		ar.flags = EXT4_MB_HINT_DATA;
+		ar.flags = EXT4_MB_HINT_FILE_DATA;
 	else
 		/* disable in-core preallocation for non-regular files */
-		ar.flags = 0;
+		ar.flags = EXT4_MB_HINT_DIR_DATA;
 	ret = ext4_mb_new_blocks(handle, &ar, errp);
 	*count = ar.len;
 	return ret;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index cf5919d..0796ed8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -55,25 +55,27 @@
 #define EXT4_MULTIBLOCK_ALLOCATOR	1
 
 /* prefer goal again. length */
-#define EXT4_MB_HINT_MERGE		1
+#define EXT4_MB_HINT_MERGE		0x001
 /* blocks already reserved */
-#define EXT4_MB_HINT_RESERVED		2
+#define EXT4_MB_HINT_RESERVED		0x002
 /* metadata is being allocated */
-#define EXT4_MB_HINT_METADATA		4
+#define EXT4_MB_HINT_METADATA		0x004
 /* first blocks in the file */
-#define EXT4_MB_HINT_FIRST		8
+#define EXT4_MB_HINT_FIRST		0x008
 /* search for the best chunk */
-#define EXT4_MB_HINT_BEST		16
+#define EXT4_MB_HINT_BEST		0x010
 /* data is being allocated */
-#define EXT4_MB_HINT_DATA		32
+#define EXT4_MB_HINT_FILE_DATA		0x020
+#define EXT4_MB_HINT_DIR_DATA		0x040
+#define EXT4_MB_HINT_META_DATA		0x080
 /* don't preallocate (for tails) */
-#define EXT4_MB_HINT_NOPREALLOC		64
+#define EXT4_MB_HINT_NOPREALLOC		0x100
 /* allocate for locality group */
-#define EXT4_MB_HINT_GROUP_ALLOC	128
+#define EXT4_MB_HINT_GROUP_ALLOC	0x200
 /* allocate goal blocks or none */
-#define EXT4_MB_HINT_GOAL_ONLY		256
+#define EXT4_MB_HINT_GOAL_ONLY		0x400
 /* goal is meaningful */
-#define EXT4_MB_HINT_TRY_GOAL		512
+#define EXT4_MB_HINT_TRY_GOAL		0x800
 
 struct ext4_allocation_request {
 	/* target inode for block we're allocating */
diff --git a/fs/ext4/ext4_i.h b/fs/ext4/ext4_i.h
index abf2744..5ad313f 100644
--- a/fs/ext4/ext4_i.h
+++ b/fs/ext4/ext4_i.h
@@ -161,6 +161,7 @@ struct ext4_inode_info {
 
 	/* mballoc */
 	struct list_head i_prealloc_list;
+	struct list_head i_metaprealloc_list;
 	spinlock_t i_prealloc_lock;
 };
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5ba81b3..c58ebd8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2690,10 +2690,10 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	ar.logical = iblock;
 	ar.len = allocated;
 	if (S_ISREG(inode->i_mode))
-		ar.flags = EXT4_MB_HINT_DATA;
+		ar.flags = EXT4_MB_HINT_FILE_DATA;
 	else
 		/* disable in-core preallocation for non-regular files */
-		ar.flags = 0;
+		ar.flags =  EXT4_MB_HINT_DIR_DATA;
 	newblock = ext4_mb_new_blocks(handle, &ar, &err);
 	if (!newblock)
 		goto out2;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7897193..4f27691 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1282,7 +1282,7 @@ static void ext4_mb_use_best_found(struct ext4_allocation_context *ac,
 	get_page(ac->ac_buddy_page);
 
 	/* store last allocated for subsequent stream allocation */
-	if ((ac->ac_flags & EXT4_MB_HINT_DATA)) {
+	if ((ac->ac_flags & EXT4_MB_HINT_FILE_DATA)) {
 		spin_lock(&sbi->s_md_lock);
 		sbi->s_mb_last_group = ac->ac_f_ex.fe_group;
 		sbi->s_mb_last_start = ac->ac_f_ex.fe_start;
@@ -1723,7 +1723,7 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 		size = isize;
 
 	if (size < sbi->s_mb_stream_request &&
-			(ac->ac_flags & EXT4_MB_HINT_DATA)) {
+			(ac->ac_flags & EXT4_MB_HINT_FILE_DATA)) {
 		/* TBD: may be hot point */
 		spin_lock(&sbi->s_md_lock);
 		ac->ac_g_ex.fe_group = sbi->s_mb_last_group;
@@ -1744,7 +1744,6 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 		 * from the goal value specified
 		 */
 		group = ac->ac_g_ex.fe_group;
-
 		for (i = 0; i < EXT4_SB(sb)->s_groups_count; group++, i++) {
 			struct ext4_group_info *grp;
 			struct ext4_group_desc *desc;
@@ -2831,6 +2830,24 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	return err;
 }
 
+static void
+ext4_mb_normalize_meta_data_request(struct ext4_allocation_context *ac)
+{
+	/*
+	 * Need to find what the right nomalized block num should be
+	 */
+	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
+	/* fe_len should be power of 2 */
+	if (i_size_read(ac->ac_inode) >= sbi->s_mb_stream_request) {
+		/* large inode which is using inode prealloc */
+		ac->ac_g_ex.fe_len = 16;
+	} else {
+		ac->ac_g_ex.fe_len = 2;
+	}
+	mb_debug("#%u: goal %u blocks for meta-data group\n",
+			current->pid, ac->ac_g_ex.fe_len);
+}
+
 /*
  * here we normalize request for locality group
  * Group request are normalized to s_strip size if we set the same via mount
@@ -2868,11 +2885,6 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
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
@@ -2882,6 +2894,21 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	if (ac->ac_flags & EXT4_MB_HINT_NOPREALLOC)
 		return;
 
+	/*
+	 * Normalize only data and meta-data request
+	 * Other block requests are not preallocated
+	 */
+	if (ac->ac_flags & EXT4_MB_HINT_DIR_DATA)
+		return;
+
+	if (ac->ac_flags & EXT4_MB_HINT_META_DATA) {
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
@@ -3062,6 +3089,28 @@ static void ext4_mb_collect_stats(struct ext4_allocation_context *ac)
 
 	ext4_mb_store_history(ac);
 }
+/*
+ * use blocks preallocated to meta-data prealloc space
+ */
+static void ext4_mb_use_meta_block_pa(struct ext4_allocation_context *ac,
+				struct ext4_prealloc_space *pa)
+{
+	unsigned int len = ac->ac_o_ex.fe_len;
+	if (len > pa->pa_free)
+		len = pa->pa_free;
+
+	ext4_get_group_no_and_offset(ac->ac_sb, pa->pa_pstart,
+					&ac->ac_b_ex.fe_group,
+					&ac->ac_b_ex.fe_start);
+	ac->ac_b_ex.fe_len = len;
+	ac->ac_status = AC_STATUS_FOUND;
+	ac->ac_pa = pa;
+
+	mb_debug("use %llu/%u from meta group pa %p\n", pa->pa_pstart, len, pa);
+	pa->pa_pstart += ac->ac_b_ex.fe_len;
+	pa->pa_free -= ac->ac_b_ex.fe_len;
+	pa->pa_len -= ac->ac_b_ex.fe_len;
+}
 
 /*
  * use blocks preallocated to inode
@@ -3124,9 +3173,32 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 	struct ext4_locality_group *lg;
 	struct ext4_prealloc_space *pa;
 
-	/* only data can be preallocated */
-	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
+	/*
+	 * non-file and non-metadata always use regular allocator
+	 */
+	if (ac->ac_flags & EXT4_MB_HINT_DIR_DATA)
+		return 0;
+
+	if (ac->ac_flags & EXT4_MB_HINT_META_DATA) {
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
@@ -3279,6 +3351,58 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
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
@@ -3342,7 +3466,7 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 	atomic_set(&pa->pa_count, 1);
 	spin_lock_init(&pa->pa_lock);
 	pa->pa_deleted = 0;
-	pa->pa_linear = 0;
+	pa->pa_type = PA_INODE_PA;
 
 	mb_debug("new inode pa %p: %llu/%u for %u\n", pa,
 			pa->pa_pstart, pa->pa_len, pa->pa_lstart);
@@ -3399,7 +3523,7 @@ ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 	atomic_set(&pa->pa_count, 1);
 	spin_lock_init(&pa->pa_lock);
 	pa->pa_deleted = 0;
-	pa->pa_linear = 1;
+	pa->pa_type = PA_GROUP_PA;
 
 	mb_debug("new group pa %p: %llu/%u for %u\n", pa,
 			pa->pa_pstart, pa->pa_len, pa->pa_lstart);
@@ -3429,7 +3553,9 @@ static int ext4_mb_new_preallocation(struct ext4_allocation_context *ac)
 {
 	int err;
 
-	if (ac->ac_flags & EXT4_MB_HINT_GROUP_ALLOC)
+	if (ac->ac_flags & EXT4_MB_HINT_META_DATA)
+		err = ext4_mb_new_meta_block_pa(ac);
+	else if (ac->ac_flags & EXT4_MB_HINT_GROUP_ALLOC)
 		err = ext4_mb_new_group_pa(ac);
 	else
 		err = ext4_mb_new_inode_pa(ac);
@@ -3511,6 +3637,35 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
 
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
 
 static noinline_for_stack int
 ext4_mb_release_group_pa(struct ext4_buddy *e4b,
@@ -3641,11 +3796,18 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
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
@@ -3680,10 +3842,8 @@ void ext4_mb_discard_inode_preallocations(struct inode *inode)
 	struct ext4_buddy e4b;
 	int err;
 
-	if (!test_opt(sb, MBALLOC) || !S_ISREG(inode->i_mode)) {
-		/*BUG_ON(!list_empty(&ei->i_prealloc_list));*/
+	if (!test_opt(sb, MBALLOC))
 		return;
-	}
 
 	mb_debug("discard preallocation for inode %lu\n", inode->i_ino);
 
@@ -3693,6 +3853,49 @@ void ext4_mb_discard_inode_preallocations(struct inode *inode)
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
@@ -3739,7 +3942,6 @@ void ext4_mb_discard_inode_preallocations(struct inode *inode)
 	spin_unlock(&ei->i_prealloc_lock);
 
 	list_for_each_entry_safe(pa, tmp, &list, u.pa_tmp_list) {
-		BUG_ON(pa->pa_linear != 0);
 		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
 
 		err = ext4_mb_load_buddy(sb, group, &e4b);
@@ -3754,7 +3956,18 @@ void ext4_mb_discard_inode_preallocations(struct inode *inode)
 
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
@@ -3853,8 +4066,13 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 	int bsbits = ac->ac_sb->s_blocksize_bits;
 	loff_t size, isize;
 
-	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
+	if (!(ac->ac_flags & EXT4_MB_HINT_FILE_DATA)) {
+		/*
+		 * group and inode prealloc space is used
+		 * only for file data
+		 */
 		return;
+	}
 
 	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
 	isize = i_size_read(ac->ac_inode) >> bsbits;
@@ -3958,7 +4176,7 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
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
index 09d9359..2a36a16 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -570,6 +570,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->vfs_inode.i_version = 1;
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
+	INIT_LIST_HEAD(&ei->i_metaprealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
 	return &ei->vfs_inode;
 }
-- 
1.5.5.1.211.g65ea3.dirty

