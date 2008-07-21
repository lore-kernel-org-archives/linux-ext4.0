From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Don't allow lg prealloc list to be grow large.
Date: Mon, 21 Jul 2008 15:10:33 +0530
Message-ID: <1216633234-24194-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:42781 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbYGUJum (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jul 2008 05:50:42 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id m6L9rKFq093516
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 19:53:20 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6L9edjI4395088
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 19:40:39 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6L9echJ014800
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 19:40:39 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The locality group prealloc list is freed only when there is a block allocation
failure. This can result in large number of per cpu locality group prealloc space
and also make the ext4_mb_use_preallocated expensive. Add a tunable max_lg_prealloc
which default to 1000. If we have more than 1000 Per-CPU prealloc space and if we
fail to find a suitable prealloc space during allocation we will now free all
the prealloc space in the locality group.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ext4_sb.h |    1 +
 fs/ext4/mballoc.c |  151 +++++++++++++++++++++++++++++++++++++++-------------
 fs/ext4/mballoc.h |    6 ++
 3 files changed, 120 insertions(+), 38 deletions(-)

diff --git a/fs/ext4/ext4_sb.h b/fs/ext4/ext4_sb.h
index 6300226..f8bf8b0 100644
--- a/fs/ext4/ext4_sb.h
+++ b/fs/ext4/ext4_sb.h
@@ -115,6 +115,7 @@ struct ext4_sb_info {
 	/* where last allocation was done - for stream allocation */
 	unsigned long s_mb_last_group;
 	unsigned long s_mb_last_start;
+	unsigned long s_mb_max_lg_prealloc;
 
 	/* history to debug policy */
 	struct ext4_mb_history *s_mb_history;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 9db0f4d..4139da0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2540,6 +2540,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	sbi->s_mb_order2_reqs = MB_DEFAULT_ORDER2_REQS;
 	sbi->s_mb_history_filter = EXT4_MB_HISTORY_DEFAULT;
 	sbi->s_mb_group_prealloc = MB_DEFAULT_GROUP_PREALLOC;
+	sbi->s_mb_max_lg_prealloc = MB_DEFAULT_LG_PREALLOC;
 
 	i = sizeof(struct ext4_locality_group) * NR_CPUS;
 	sbi->s_locality_groups = kmalloc(i, GFP_KERNEL);
@@ -2720,6 +2721,7 @@ ext4_mb_free_committed_blocks(struct super_block *sb)
 #define EXT4_MB_ORDER2_REQ		"order2_req"
 #define EXT4_MB_STREAM_REQ		"stream_req"
 #define EXT4_MB_GROUP_PREALLOC		"group_prealloc"
+#define EXT4_MB_MAX_LG_PREALLOC		"max_lg_prealloc"
 
 
 
@@ -2769,6 +2771,7 @@ MB_PROC_FOPS(min_to_scan);
 MB_PROC_FOPS(order2_reqs);
 MB_PROC_FOPS(stream_request);
 MB_PROC_FOPS(group_prealloc);
+MB_PROC_FOPS(max_lg_prealloc);
 
 #define	MB_PROC_HANDLER(name, var)					\
 do {									\
@@ -2800,11 +2803,13 @@ static int ext4_mb_init_per_dev_proc(struct super_block *sb)
 	MB_PROC_HANDLER(EXT4_MB_ORDER2_REQ, order2_reqs);
 	MB_PROC_HANDLER(EXT4_MB_STREAM_REQ, stream_request);
 	MB_PROC_HANDLER(EXT4_MB_GROUP_PREALLOC, group_prealloc);
+	MB_PROC_HANDLER(EXT4_MB_MAX_LG_PREALLOC, max_lg_prealloc);
 
 	return 0;
 
 err_out:
 	printk(KERN_ERR "EXT4-fs: Unable to create %s\n", devname);
+	remove_proc_entry(EXT4_MB_MAX_LG_PREALLOC, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_GROUP_PREALLOC, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_STREAM_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_ORDER2_REQ, sbi->s_mb_proc);
@@ -2826,6 +2831,7 @@ static int ext4_mb_destroy_per_dev_proc(struct super_block *sb)
 		return -EINVAL;
 
 	bdevname(sb->s_bdev, devname);
+	remove_proc_entry(EXT4_MB_MAX_LG_PREALLOC, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_GROUP_PREALLOC, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_STREAM_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_ORDER2_REQ, sbi->s_mb_proc);
@@ -3280,6 +3286,107 @@ static void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
 	mb_debug("use %u/%u from group pa %p\n", pa->pa_lstart-len, len, pa);
 }
 
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
+/*
+ * release the locality group prealloc space.
+ * called with lg_mutex held
+ */
+static noinline_for_stack void
+ext4_mb_discard_lg_preallocations(struct super_block *sb,
+					struct ext4_locality_group *lg)
+{
+	ext4_group_t group = 0;
+	struct list_head list;
+	struct ext4_buddy e4b;
+	struct ext4_allocation_context *ac;
+	struct ext4_prealloc_space *pa, *tmp;
+
+	INIT_LIST_HEAD(&list);
+	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
+
+	list_for_each_entry_rcu(pa, &lg->lg_prealloc_list, pa_inode_list) {
+		spin_lock(&pa->pa_lock);
+		if (atomic_read(&pa->pa_count)) {
+			/* This should not happen */
+			spin_unlock(&pa->pa_lock);
+			printk(KERN_ERR "uh-oh! used pa while discarding\n");
+			WARN_ON(1);
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
+		list_del_rcu(&pa->pa_inode_list);
+		list_add(&pa->u.pa_tmp_list, &list);
+	}
+
+	list_for_each_entry_safe(pa, tmp, &list, u.pa_tmp_list) {
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
+}
+
 /*
  * search goal blocks in preallocated space
  */
@@ -3287,8 +3394,10 @@ static void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
 ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 {
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
+	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 	struct ext4_locality_group *lg;
 	struct ext4_prealloc_space *pa;
+	unsigned long lg_prealloc_count = 0;
 
 	/* only data can be preallocated */
 	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
@@ -3339,9 +3448,13 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 			return 1;
 		}
 		spin_unlock(&pa->pa_lock);
+		lg_prealloc_count++;
 	}
 	rcu_read_unlock();
 
+	if (lg_prealloc_count > sbi->s_mb_max_lg_prealloc)
+		ext4_mb_discard_lg_preallocations(ac->ac_sb, lg);
+
 	return 0;
 }
 
@@ -3388,13 +3501,6 @@ static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
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
@@ -3676,37 +3782,6 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
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
