From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH] ext4: hand over jobs handling discard commands on commit
 complete phase to kworkers
Date: Tue, 16 May 2017 16:37:42 +0900
Message-ID: <1494920262-10128-1-git-send-email-daeho.jeong@samsung.com>
References: <CGME20170516073738epcas1p42daa31d04ae9d07eae07d9fcee6708a2@epcas1p4.samsung.com>
Cc: Daeho Jeong <daeho.jeong@samsung.com>
To: jack@suse.com, tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:42880 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751663AbdEPHhk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 May 2017 03:37:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now, when we mount ext4 filesystem with '-o discard' option, we have to
issue all the discard commands for the blocks to be deallocated and
wait for the completion of the commands on the commit complete phase.
Because this procedure might involve a lot of sequential combinations of
issuing discard commands and waiting for that, the delay of this
procedure might be too much long, even to half a minute in our test,
and it results in long commit delay and fsync() performance degradation.

If we process these jobs handlig discard commands with work items and
delegate the jobs to kworkers, the journaling thread doesn't need to
wait for the discard command handling anymore, and the sequentially
handled discard commands will be handled in parallel by several kworkers
and discard command handling performance also will be enhanced.
By doing this, half a minute delay of a single commit in the worst case
has been enhanced to 255ms in our test.

Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
Tested-by: Hobin Woo <hobin.woo@samsung.com>
Tested-by: Kitae Lee <kitae87.lee@samsung.com>
---
 fs/ext4/ext4.h    |  3 +++
 fs/ext4/mballoc.c | 66 ++++++++++++++++++++++++++++++++++++++-----------------
 fs/ext4/mballoc.h |  7 ++++++
 fs/ext4/super.c   | 21 ++++++++++++++++++
 4 files changed, 77 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index fb69ee2..4d0689d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1526,6 +1526,9 @@ struct ext4_sb_info {
 
 	/* Barrier between changing inodes' journal flags and writepages ops. */
 	struct percpu_rw_semaphore s_journal_flag_rwsem;
+
+	/* workqueue for deferred discard operations */
+	struct workqueue_struct *deferred_discard_wq;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 354dc1a..1f3260e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
+#include <linux/workqueue.h>
 #include <trace/events/ext4.h>
 
 #ifdef CONFIG_EXT4_DEBUG
@@ -2794,15 +2795,9 @@ static inline int ext4_issue_discard(struct super_block *sb,
 	return sb_issue_discard(sb, discard_block, count, GFP_NOFS, 0);
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
@@ -2810,18 +2805,6 @@ static void ext4_free_data_callback(struct super_block *sb,
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
@@ -2862,6 +2845,43 @@ static void ext4_free_data_callback(struct super_block *sb,
 	mb_debug(1, "freed %u blocks in %u structures\n", count, count2);
 }
 
+void ext4_deferred_discard_work(struct work_struct *work)
+{
+	struct ext4_free_data *entry = container_of(work, struct ext4_free_data,
+						    deferred_discard_work);
+	int err;
+
+	err = ext4_issue_discard(entry->efd_sb, entry->efd_group,
+				 entry->efd_start_cluster,
+				 entry->efd_count);
+	if (err && err != -EOPNOTSUPP)
+		ext4_msg(entry->efd_sb, KERN_WARNING, "discard request in"
+			 " group:%d block:%d count:%d failed"
+			 " with %d", entry->efd_group,
+			 entry->efd_start_cluster,
+			 entry->efd_count, err);
+
+	ext4_free_data_in_buddy(entry->efd_sb, entry);
+}
+
+/*
+ * This function is called by the jbd2 layer once the commit has finished,
+ * so we know we can free the blocks that were released with that commit.
+ */
+static void ext4_free_data_callback(struct super_block *sb,
+				    struct ext4_journal_cb_entry *jce,
+				    int rc)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_free_data *entry = (struct ext4_free_data *)jce;
+
+	if (test_opt(sb, DISCARD))
+		queue_work(sbi->deferred_discard_wq,
+			   &entry->deferred_discard_work);
+	else
+		ext4_free_data_in_buddy(sb, entry);
+}
+
 int __init ext4_init_mballoc(void)
 {
 	ext4_pspace_cachep = KMEM_CACHE(ext4_prealloc_space,
@@ -4857,6 +4877,12 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		new_entry->efd_count = count_clusters;
 		new_entry->efd_tid = handle->h_transaction->t_tid;
 
+		if (test_opt(sb, DISCARD)) {
+			INIT_WORK(&new_entry->deferred_discard_work,
+				  ext4_deferred_discard_work);
+			new_entry->efd_sb = sb;
+		}
+
 		ext4_lock_group(sb, block_group);
 		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
 		ext4_mb_free_metadata(handle, &e4b, new_entry);
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 1aba469..da6409f 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -95,6 +95,13 @@ struct ext4_free_data {
 
 	/* transaction which freed this extent */
 	tid_t				efd_tid;
+
+	/*
+	 * work item that will be used to trigger the deferred discard
+	 * operation
+	 */
+	struct work_struct		deferred_discard_work;
+	struct super_block		*efd_sb;
 };
 
 struct ext4_prealloc_space {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a9448db..f4d7d7e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -852,6 +852,11 @@ static void ext4_put_super(struct super_block *sb)
 	flush_workqueue(sbi->rsv_conversion_wq);
 	destroy_workqueue(sbi->rsv_conversion_wq);
 
+	if (sbi->deferred_discard_wq) {
+		flush_workqueue(sbi->deferred_discard_wq);
+		destroy_workqueue(sbi->deferred_discard_wq);
+	}
+
 	if (sbi->s_journal) {
 		aborted = is_journal_aborted(sbi->s_journal);
 		err = jbd2_journal_destroy(sbi->s_journal);
@@ -4076,6 +4081,17 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount4;
 	}
 
+	if (test_opt(sb, DISCARD)) {
+		EXT4_SB(sb)->deferred_discard_wq =
+			alloc_workqueue("ext4-deferred-discard",
+					WQ_MEM_RECLAIM | WQ_UNBOUND, 4);
+		if (!EXT4_SB(sb)->deferred_discard_wq) {
+			printk(KERN_ERR "EXT4-fs: failed to create workqueue\n");
+			ret = -ENOMEM;
+			goto failed_mount4;
+		}
+	}
+
 	/*
 	 * The jbd2_journal_load will have done any necessary log recovery,
 	 * so we can safely mount the rest of the filesystem now.
@@ -4267,6 +4283,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	ext4_msg(sb, KERN_ERR, "mount failed");
 	if (EXT4_SB(sb)->rsv_conversion_wq)
 		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
+	if (EXT4_SB(sb)->deferred_discard_wq)
+		destroy_workqueue(EXT4_SB(sb)->deferred_discard_wq);
 failed_mount_wq:
 	if (sbi->s_mb_cache) {
 		ext4_xattr_destroy_cache(sbi->s_mb_cache);
@@ -4738,6 +4756,9 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 
 	trace_ext4_sync_fs(sb, wait);
 	flush_workqueue(sbi->rsv_conversion_wq);
+	if (EXT4_SB(sb)->deferred_discard_wq)
+		flush_workqueue(sbi->deferred_discard_wq);
+
 	/*
 	 * Writeback quota in non-journalled quota case - journalled quota has
 	 * no dirty dquots
-- 
1.9.1
