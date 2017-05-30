From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH] ext4: change sequential discard handling on commit complete
 phase into parallel manner
Date: Tue, 30 May 2017 12:06:06 +0900
Message-ID: <1496113566-18899-1-git-send-email-daeho.jeong@samsung.com>
References: <CGME20170530030551epcas5p327c9acbabf266842887bcc86cac43cba@epcas5p3.samsung.com>
Cc: Daeho Jeong <daeho.jeong@samsung.com>
To: jack@suse.com, hch@infradead.org, tytso@mit.edu,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:13466 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbdE3DFy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 29 May 2017 23:05:54 -0400
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
---
 fs/ext4/ext4_jbd2.h |   5 ++-
 fs/ext4/mballoc.c   | 108 +++++++++++++++++++++++++++++++++++++++-------------
 fs/ext4/mballoc.h   |   4 ++
 fs/ext4/super.c     |  14 ++++++-
 4 files changed, 102 insertions(+), 29 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index f976111..7c952c2 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -149,7 +149,8 @@ struct ext4_journal_cb_entry {
 
 	/*  Function to call with this callback structure */
 	void (*jce_func)(struct super_block *sb,
-			 struct ext4_journal_cb_entry *jce, int error);
+			 struct ext4_journal_cb_entry *jce, int error,
+			 struct list_head *post_cb_list);
 
 	/* user data goes here */
 };
@@ -185,7 +186,7 @@ static inline void _ext4_journal_callback_add(handle_t *handle,
 static inline void ext4_journal_callback_add(handle_t *handle,
 			void (*func)(struct super_block *sb,
 				     struct ext4_journal_cb_entry *jce,
-				     int rc),
+				     int rc, struct list_head *post_cb_list),
 			struct ext4_journal_cb_entry *jce)
 {
 	struct ext4_sb_info *sbi =
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 354dc1a..458f086 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -368,7 +368,8 @@ static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
 						ext4_group_t group);
 static void ext4_free_data_callback(struct super_block *sb,
-				struct ext4_journal_cb_entry *jce, int rc);
+				struct ext4_journal_cb_entry *jce, int rc,
+				struct list_head *post_cb_list);
 
 static inline void *mb_correct_addr_and_bit(int *bit, void *addr)
 {
@@ -2782,7 +2783,8 @@ int ext4_mb_release(struct super_block *sb)
 }
 
 static inline int ext4_issue_discard(struct super_block *sb,
-		ext4_group_t block_group, ext4_grpblk_t cluster, int count)
+		ext4_group_t block_group, ext4_grpblk_t cluster, int count,
+		struct bio **biop)
 {
 	ext4_fsblk_t discard_block;
 
@@ -2791,18 +2793,18 @@ static inline int ext4_issue_discard(struct super_block *sb,
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
@@ -2810,18 +2812,6 @@ static void ext4_free_data_callback(struct super_block *sb,
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
@@ -2862,6 +2852,67 @@ static void ext4_free_data_callback(struct super_block *sb,
 	mb_debug(1, "freed %u blocks in %u structures\n", count, count2);
 }
 
+/*
+ * This function is called by the jbd2 layer once the commit has finished,
+ * so we know we can free the blocks that were released with that commit.
+ */
+static void ext4_free_data_callback(struct super_block *sb,
+				    struct ext4_journal_cb_entry *jce,
+				    int rc, struct list_head *post_cb_list)
+{
+	struct ext4_free_data *entry = (struct ext4_free_data *)jce;
+
+	ext4_free_data_in_buddy(sb, entry);
+}
+
+static void ext4_bio_wait_endio(struct bio *bio)
+{
+	struct completion *wait = (struct completion *)bio->bi_private;
+
+	complete(wait);
+}
+
+static void ext4_free_after_discard_callback(struct super_block *sb,
+				    struct ext4_journal_cb_entry *jce,
+				    int rc, struct list_head *post_cb_list)
+{
+	struct ext4_free_data *entry = (struct ext4_free_data *)jce;
+
+	wait_for_completion_io(&entry->efd_bio_wait);
+	ext4_free_data_in_buddy(sb, entry);
+}
+
+static void ext4_discard_callback(struct super_block *sb,
+				    struct ext4_journal_cb_entry *jce,
+				    int rc, struct list_head *post_cb_list)
+{
+	struct ext4_free_data *entry = (struct ext4_free_data *)jce;
+	int err;
+
+	err = ext4_issue_discard(sb, entry->efd_group,
+				 entry->efd_start_cluster,
+				 entry->efd_count,
+				 &entry->efd_discard_bio);
+	if (err && err != -EOPNOTSUPP) {
+		ext4_msg(sb, KERN_WARNING, "discard request in"
+			 " group:%d block:%d count:%d failed"
+			 " with %d", entry->efd_group,
+			 entry->efd_start_cluster,
+			 entry->efd_count, err);
+	}
+
+	if (entry->efd_discard_bio) {
+		init_completion(&entry->efd_bio_wait);
+		entry->efd_discard_bio->bi_end_io = ext4_bio_wait_endio;
+		entry->efd_discard_bio->bi_private = &entry->efd_bio_wait;
+		submit_bio(entry->efd_discard_bio);
+		jce->jce_func = ext4_free_after_discard_callback;
+	} else
+		jce->jce_func = ext4_free_data_callback;
+
+	list_add_tail(&jce->jce_list, post_cb_list);
+}
+
 int __init ext4_init_mballoc(void)
 {
 	ext4_pspace_cachep = KMEM_CACHE(ext4_prealloc_space,
@@ -4661,7 +4712,10 @@ static int can_merge(struct ext4_free_data *entry1,
 		}
 	}
 	/* Add the extent to transaction's private list */
-	new_entry->efd_jce.jce_func = ext4_free_data_callback;
+	if (test_opt(sb, DISCARD))
+		new_entry->efd_jce.jce_func = ext4_discard_callback;
+	else
+		new_entry->efd_jce.jce_func = ext4_free_data_callback;
 	spin_lock(&sbi->s_md_lock);
 	_ext4_journal_callback_add(handle, &new_entry->efd_jce);
 	sbi->s_mb_free_pending += clusters;
@@ -4856,6 +4910,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		new_entry->efd_group = block_group;
 		new_entry->efd_count = count_clusters;
 		new_entry->efd_tid = handle->h_transaction->t_tid;
+		new_entry->efd_discard_bio = NULL;
 
 		ext4_lock_group(sb, block_group);
 		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
@@ -4866,7 +4921,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		 * them with group lock_held
 		 */
 		if (test_opt(sb, DISCARD)) {
-			err = ext4_issue_discard(sb, block_group, bit, count);
+			err = ext4_issue_discard(sb, block_group, bit, count,
+						 NULL);
 			if (err && err != -EOPNOTSUPP)
 				ext4_msg(sb, KERN_WARNING, "discard request in"
 					 " group:%d block:%d count:%lu failed"
@@ -5089,7 +5145,7 @@ static int ext4_trim_extent(struct super_block *sb, int start, int count,
 	 */
 	mb_mark_used(e4b, &ex);
 	ext4_unlock_group(sb, group);
-	ret = ext4_issue_discard(sb, group, start, count);
+	ret = ext4_issue_discard(sb, group, start, count, NULL);
 	ext4_lock_group(sb, group);
 	mb_free_blocks(NULL, e4b, start, ex.fe_len);
 	return ret;
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 1aba469..4c780c3 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -95,6 +95,10 @@ struct ext4_free_data {
 
 	/* transaction which freed this extent */
 	tid_t				efd_tid;
+
+	/* discard bio to be submitted for this entry */
+	struct bio			*efd_discard_bio;
+	struct completion		efd_bio_wait;
 };
 
 struct ext4_prealloc_space {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a9448db..686bbcf 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -369,18 +369,30 @@ static void ext4_journal_commit_callback(journal_t *journal, transaction_t *txn)
 	struct ext4_sb_info		*sbi = EXT4_SB(sb);
 	int				error = is_journal_aborted(journal);
 	struct ext4_journal_cb_entry	*jce;
+	struct list_head		post_cb_list;
 
 	BUG_ON(txn->t_state == T_FINISHED);
+
+	INIT_LIST_HEAD(&post_cb_list);
+
 	spin_lock(&sbi->s_md_lock);
 	while (!list_empty(&txn->t_private_list)) {
 		jce = list_entry(txn->t_private_list.next,
 				 struct ext4_journal_cb_entry, jce_list);
 		list_del_init(&jce->jce_list);
 		spin_unlock(&sbi->s_md_lock);
-		jce->jce_func(sb, jce, error);
+		jce->jce_func(sb, jce, error, &post_cb_list);
 		spin_lock(&sbi->s_md_lock);
 	}
 	spin_unlock(&sbi->s_md_lock);
+
+	while (!list_empty(&post_cb_list)) {
+		jce = list_entry(post_cb_list.next,
+				 struct ext4_journal_cb_entry,
+				 jce_list);
+		list_del_init(&jce->jce_list);
+		jce->jce_func(sb, jce, error, NULL);
+	}
 }
 
 /* Deal with the reporting of failure conditions on a filesystem such as
-- 
1.9.1
