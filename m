From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH v2] ext4: change sequential discard handling on commit
 complete phase into parallel manner
Date: Thu, 08 Jun 2017 10:44:48 +0900
Message-ID: <1496886288-6290-1-git-send-email-daeho.jeong@samsung.com>
References: <CGME20170608014457epcas1p2c2f6af76eee8ab0c20f8f9d8fbcae563@epcas1p2.samsung.com>
Cc: Daeho Jeong <daeho.jeong@samsung.com>
To: jack@suse.com, tytso@mit.edu, hch@infradead.org,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:52222 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751424AbdFHBpA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Jun 2017 21:45:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now, when we mount ext4 filesystem with '-o discard' option, we have to
issue all the discard commands for the blocks to be deallocated and
wait for the completion of the commands on the commit complete phase.
Because this procedure might involve a lot of sequential combinations of
issuing discard commands and waiting for that, the delay of this
procedure might be too much long, even to half a minute in our test,
and it results in long commit delay and fsync() performance degradation.

When we converted this sequential discard handling on commit complete
phase into a parallel manner like XFS filesystem, we could enhance the
discard command handling performance. The result was such that 17.0s
delay of a single commit in the worst case has been enhanced to 4.8s.

Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
Tested-by: Hobin Woo <hobin.woo@samsung.com>
Tested-by: Kitae Lee <kitae87.lee@samsung.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h    |   3 ++
 fs/ext4/mballoc.c | 122 ++++++++++++++++++++++++++++++++++++++++--------------
 fs/ext4/mballoc.h |   9 ++--
 fs/ext4/super.c   |   3 ++
 4 files changed, 102 insertions(+), 35 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index fb69ee2..7dce2cf 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1444,6 +1444,8 @@ struct ext4_sb_info {
 	unsigned int *s_mb_maxs;
 	unsigned int s_group_info_size;
 	unsigned int s_mb_free_pending;
+	struct list_head s_freed_data_list;	/* List of blocks to be freed
+						   after commit completed */
 
 	/* tunables */
 	unsigned long s_stripe;
@@ -2434,6 +2436,7 @@ extern int ext4_mb_add_groupinfo(struct super_block *sb,
 extern int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 				ext4_fsblk_t block, unsigned long count);
 extern int ext4_trim_fs(struct super_block *, struct fstrim_range *);
+extern void ext4_process_freed_data(struct super_block *sb, tid_t commit_tid);
 
 /* inode.c */
 int ext4_inode_is_fast_symlink(struct inode *inode);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 354dc1a..ff3d037 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -367,8 +367,6 @@ static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group);
 static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
 						ext4_group_t group);
-static void ext4_free_data_callback(struct super_block *sb,
-				struct ext4_journal_cb_entry *jce, int rc);
 
 static inline void *mb_correct_addr_and_bit(int *bit, void *addr)
 {
@@ -2639,6 +2637,7 @@ int ext4_mb_init(struct super_block *sb)
 	spin_lock_init(&sbi->s_md_lock);
 	spin_lock_init(&sbi->s_bal_lock);
 	sbi->s_mb_free_pending = 0;
+	INIT_LIST_HEAD(&sbi->s_freed_data_list);
 
 	sbi->s_mb_max_to_scan = MB_DEFAULT_MAX_TO_SCAN;
 	sbi->s_mb_min_to_scan = MB_DEFAULT_MIN_TO_SCAN;
@@ -2782,7 +2781,8 @@ int ext4_mb_release(struct super_block *sb)
 }
 
 static inline int ext4_issue_discard(struct super_block *sb,
-		ext4_group_t block_group, ext4_grpblk_t cluster, int count)
+		ext4_group_t block_group, ext4_grpblk_t cluster, int count,
+		struct bio **biop)
 {
 	ext4_fsblk_t discard_block;
 
@@ -2791,18 +2791,18 @@ static inline int ext4_issue_discard(struct super_block *sb,
 	count = EXT4_C2B(EXT4_SB(sb), count);
 	trace_ext4_discard_blocks(sb,
 			(unsigned long long) discard_block, count);
-	return sb_issue_discard(sb, discard_block, count, GFP_NOFS, 0);
+	if (biop) {
+		return __blkdev_issue_discard(sb->s_bdev,
+				discard_block << (sb->s_blocksize_bits - 9),
+				count << (sb->s_blocksize_bits - 9),
+				GFP_NOFS, 0, biop);
+	} else
+		return sb_issue_discard(sb, discard_block, count, GFP_NOFS, 0);
 }
 
-/*
- * This function is called by the jbd2 layer once the commit has finished,
- * so we know we can free the blocks that were released with that commit.
- */
-static void ext4_free_data_callback(struct super_block *sb,
-				    struct ext4_journal_cb_entry *jce,
-				    int rc)
+static void ext4_free_data_in_buddy(struct super_block *sb,
+				    struct ext4_free_data *entry)
 {
-	struct ext4_free_data *entry = (struct ext4_free_data *)jce;
 	struct ext4_buddy e4b;
 	struct ext4_group_info *db;
 	int err, count = 0, count2 = 0;
@@ -2810,18 +2810,6 @@ static void ext4_free_data_callback(struct super_block *sb,
 	mb_debug(1, "gonna free %u blocks in group %u (0x%p):",
 		 entry->efd_count, entry->efd_group, entry);
 
-	if (test_opt(sb, DISCARD)) {
-		err = ext4_issue_discard(sb, entry->efd_group,
-					 entry->efd_start_cluster,
-					 entry->efd_count);
-		if (err && err != -EOPNOTSUPP)
-			ext4_msg(sb, KERN_WARNING, "discard request in"
-				 " group:%d block:%d count:%d failed"
-				 " with %d", entry->efd_group,
-				 entry->efd_start_cluster,
-				 entry->efd_count, err);
-	}
-
 	err = ext4_mb_load_buddy(sb, entry->efd_group, &e4b);
 	/* we expect to find existing buddy because it's pinned */
 	BUG_ON(err != 0);
@@ -2862,6 +2850,62 @@ static void ext4_free_data_callback(struct super_block *sb,
 	mb_debug(1, "freed %u blocks in %u structures\n", count, count2);
 }
 
+/*
+ * This function is called by the jbd2 layer once the commit has finished,
+ * so we know we can free the blocks that were released with that commit.
+ */
+void ext4_process_freed_data(struct super_block *sb, tid_t commit_tid)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_free_data *entry;
+	struct bio *discard_bio = NULL;
+	struct list_head freed_data_list;
+	struct list_head *cur;
+	struct list_head *tmp;
+	int err;
+
+	INIT_LIST_HEAD(&freed_data_list);
+
+	spin_lock(&sbi->s_md_lock);
+	list_for_each_safe(cur, tmp, &sbi->s_freed_data_list) {
+		entry = list_entry(cur, struct ext4_free_data, efd_list);
+		if (entry->efd_tid != commit_tid)
+			break;
+		entry->efd_freed = true;
+		list_del(&entry->efd_list);
+		list_add_tail(&entry->efd_list, &freed_data_list);
+	}
+	spin_unlock(&sbi->s_md_lock);
+
+	if (test_opt(sb, DISCARD)) {
+		list_for_each(cur, &freed_data_list) {
+			entry = list_entry(cur, struct ext4_free_data,
+					   efd_list);
+
+			err = ext4_issue_discard(sb, entry->efd_group,
+						 entry->efd_start_cluster,
+						 entry->efd_count,
+						 &discard_bio);
+			if (err && err != -EOPNOTSUPP) {
+				ext4_msg(sb, KERN_WARNING, "discard request in"
+					 " group:%d block:%d count:%d failed"
+					 " with %d", entry->efd_group,
+					 entry->efd_start_cluster,
+					 entry->efd_count, err);
+			} else if (err == -EOPNOTSUPP)
+				break;
+		}
+
+		if (discard_bio)
+			submit_bio_wait(discard_bio);
+	}
+
+	list_for_each_safe(cur, tmp, &freed_data_list) {
+		entry = list_entry(cur, struct ext4_free_data, efd_list);
+		ext4_free_data_in_buddy(sb, entry);
+	}
+}
+
 int __init ext4_init_mballoc(void)
 {
 	ext4_pspace_cachep = KMEM_CACHE(ext4_prealloc_space,
@@ -4588,6 +4632,21 @@ static int can_merge(struct ext4_free_data *entry1,
 	return 0;
 }
 
+static inline bool ext4_freed_data_try_del(struct ext4_sb_info *sbi,
+					   struct ext4_free_data *entry)
+{
+	bool deleted = false;
+
+	spin_lock(&sbi->s_md_lock);
+	if (!entry->efd_freed) {
+		entry->efd_freed = true;
+		list_del(&entry->efd_list);
+		deleted = true;
+	}
+	spin_unlock(&sbi->s_md_lock);
+	return deleted;
+}
+
 static noinline_for_stack int
 ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 		      struct ext4_free_data *new_entry)
@@ -4642,7 +4701,7 @@ static int can_merge(struct ext4_free_data *entry1,
 	if (node) {
 		entry = rb_entry(node, struct ext4_free_data, efd_node);
 		if (can_merge(entry, new_entry) &&
-		    ext4_journal_callback_try_del(handle, &entry->efd_jce)) {
+		    ext4_freed_data_try_del(sbi, entry)) {
 			new_entry->efd_start_cluster = entry->efd_start_cluster;
 			new_entry->efd_count += entry->efd_count;
 			rb_erase(node, &(db->bb_free_root));
@@ -4654,16 +4713,15 @@ static int can_merge(struct ext4_free_data *entry1,
 	if (node) {
 		entry = rb_entry(node, struct ext4_free_data, efd_node);
 		if (can_merge(new_entry, entry) &&
-		    ext4_journal_callback_try_del(handle, &entry->efd_jce)) {
+		    ext4_freed_data_try_del(sbi, entry)) {
 			new_entry->efd_count += entry->efd_count;
 			rb_erase(node, &(db->bb_free_root));
 			kmem_cache_free(ext4_free_data_cachep, entry);
 		}
 	}
-	/* Add the extent to transaction's private list */
-	new_entry->efd_jce.jce_func = ext4_free_data_callback;
+
 	spin_lock(&sbi->s_md_lock);
-	_ext4_journal_callback_add(handle, &new_entry->efd_jce);
+	list_add_tail(&new_entry->efd_list, &sbi->s_freed_data_list);
 	sbi->s_mb_free_pending += clusters;
 	spin_unlock(&sbi->s_md_lock);
 	return 0;
@@ -4856,6 +4914,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		new_entry->efd_group = block_group;
 		new_entry->efd_count = count_clusters;
 		new_entry->efd_tid = handle->h_transaction->t_tid;
+		new_entry->efd_freed = false;
 
 		ext4_lock_group(sb, block_group);
 		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
@@ -4866,7 +4925,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		 * them with group lock_held
 		 */
 		if (test_opt(sb, DISCARD)) {
-			err = ext4_issue_discard(sb, block_group, bit, count);
+			err = ext4_issue_discard(sb, block_group, bit, count,
+						 NULL);
 			if (err && err != -EOPNOTSUPP)
 				ext4_msg(sb, KERN_WARNING, "discard request in"
 					 " group:%d block:%d count:%lu failed"
@@ -5089,7 +5149,7 @@ static int ext4_trim_extent(struct super_block *sb, int start, int count,
 	 */
 	mb_mark_used(e4b, &ex);
 	ext4_unlock_group(sb, group);
-	ret = ext4_issue_discard(sb, group, start, count);
+	ret = ext4_issue_discard(sb, group, start, count, NULL);
 	ext4_lock_group(sb, group);
 	mb_free_blocks(NULL, e4b, start, ex.fe_len);
 	return ret;
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 1aba469..f762509 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -78,10 +78,8 @@
 
 
 struct ext4_free_data {
-	/* MUST be the first member */
-	struct ext4_journal_cb_entry	efd_jce;
-
-	/* ext4_free_data private data starts from here */
+	/* this links the free block information from sb_info */
+	struct list_head		efd_list;
 
 	/* this links the free block information from group_info */
 	struct rb_node			efd_node;
@@ -95,6 +93,9 @@ struct ext4_free_data {
 
 	/* transaction which freed this extent */
 	tid_t				efd_tid;
+
+	/* indicate whether this is already handled */
+	bool				efd_freed;
 };
 
 struct ext4_prealloc_space {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a9448db..bf95387 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -371,6 +371,9 @@ static void ext4_journal_commit_callback(journal_t *journal, transaction_t *txn)
 	struct ext4_journal_cb_entry	*jce;
 
 	BUG_ON(txn->t_state == T_FINISHED);
+
+	ext4_process_freed_data(sb, txn->t_tid);
+
 	spin_lock(&sbi->s_md_lock);
 	while (!list_empty(&txn->t_private_list)) {
 		jce = list_entry(txn->t_private_list.next,
-- 
1.9.1
