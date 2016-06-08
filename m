From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: optimize ext4_should_retry_alloc() to improve ENOSPC performance
Date: Tue,  7 Jun 2016 22:36:58 -0400
Message-ID: <1465353418-12897-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54230 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbcFHChD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jun 2016 22:37:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If there are pending blocks to be released after a commit, retrying
the allocation after a journal commit has no hope of helping.  So
track how many pending deleted blocks there might be, and don't retry
if there are no pending blocks.

Reported-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/balloc.c    |  9 ++++++++-
 fs/ext4/ext4.h      |  1 +
 fs/ext4/ext4_jbd2.h | 10 +++++++++-
 fs/ext4/fsync.c     |  5 +++--
 fs/ext4/mballoc.c   | 12 ++++++++++--
 5 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 3020fd7..371ac63 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -603,7 +603,14 @@ int ext4_claim_free_clusters(struct ext4_sb_info *sbi,
  */
 int ext4_should_retry_alloc(struct super_block *sb, int *retries)
 {
-	if (!ext4_has_free_clusters(EXT4_SB(sb), 1, 0) ||
+	unsigned int pending_blocks;
+
+	spin_lock(&EXT4_SB(sb)->s_md_lock);
+	pending_blocks = EXT4_SB(sb)->s_mb_free_pending;
+	spin_unlock(&EXT4_SB(sb)->s_md_lock);
+
+	if (pending_blocks == 0 ||
+	    !ext4_has_free_clusters(EXT4_SB(sb), 1, 0) ||
 	    (*retries)++ > 3 ||
 	    !EXT4_SB(sb)->s_journal)
 		return 0;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b84aa1c..96c73e6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1430,6 +1430,7 @@ struct ext4_sb_info {
 	unsigned short *s_mb_offsets;
 	unsigned int *s_mb_maxs;
 	unsigned int s_group_info_size;
+	unsigned int s_mb_free_pending;
 
 	/* tunables */
 	unsigned long s_stripe;
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 09c1ef3..b1d52c1 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -175,6 +175,13 @@ struct ext4_journal_cb_entry {
  * There is no guaranteed calling order of multiple registered callbacks on
  * the same transaction.
  */
+static inline void _ext4_journal_callback_add(handle_t *handle,
+			struct ext4_journal_cb_entry *jce)
+{
+	/* Add the jce to transaction's private list */
+	list_add_tail(&jce->jce_list, &handle->h_transaction->t_private_list);
+}
+
 static inline void ext4_journal_callback_add(handle_t *handle,
 			void (*func)(struct super_block *sb,
 				     struct ext4_journal_cb_entry *jce,
@@ -187,10 +194,11 @@ static inline void ext4_journal_callback_add(handle_t *handle,
 	/* Add the jce to transaction's private list */
 	jce->jce_func = func;
 	spin_lock(&sbi->s_md_lock);
-	list_add_tail(&jce->jce_list, &handle->h_transaction->t_private_list);
+	_ext4_journal_callback_add(handle, jce);
 	spin_unlock(&sbi->s_md_lock);
 }
 
+
 /**
  * ext4_journal_callback_del: delete a registered callback
  * @handle: active journal transaction handle on which callback was registered
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 8850254..7ee4abd 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -106,10 +106,10 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	}
 
 	if (!journal) {
-		ret = generic_file_fsync(file, start, end, datasync);
+		ret = __generic_file_fsync(file, start, end, datasync);
 		if (!ret && !hlist_empty(&inode->i_dentry))
 			ret = ext4_sync_parent(inode);
-		goto out;
+		goto issue_flush;
 	}
 
 	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
@@ -140,6 +140,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		needs_barrier = true;
 	ret = jbd2_complete_transaction(journal, commit_tid);
 	if (needs_barrier) {
+	issue_flush:
 		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
 		if (!ret)
 			ret = err;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c1ab3ec..77249e1 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2627,6 +2627,7 @@ int ext4_mb_init(struct super_block *sb)
 
 	spin_lock_init(&sbi->s_md_lock);
 	spin_lock_init(&sbi->s_bal_lock);
+	sbi->s_mb_free_pending = 0;
 
 	sbi->s_mb_max_to_scan = MB_DEFAULT_MAX_TO_SCAN;
 	sbi->s_mb_min_to_scan = MB_DEFAULT_MIN_TO_SCAN;
@@ -2814,6 +2815,9 @@ static void ext4_free_data_callback(struct super_block *sb,
 	/* we expect to find existing buddy because it's pinned */
 	BUG_ON(err != 0);
 
+	spin_lock(&EXT4_SB(sb)->s_md_lock);
+	EXT4_SB(sb)->s_mb_free_pending -= entry->efd_count;
+	spin_unlock(&EXT4_SB(sb)->s_md_lock);
 
 	db = e4b.bd_info;
 	/* there are blocks to put in buddy to make them really free */
@@ -4583,6 +4587,7 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 {
 	ext4_group_t group = e4b->bd_group;
 	ext4_grpblk_t cluster;
+	ext4_grpblk_t clusters = new_entry->efd_count;
 	struct ext4_free_data *entry;
 	struct ext4_group_info *db = e4b->bd_info;
 	struct super_block *sb = e4b->bd_sb;
@@ -4649,8 +4654,11 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 		}
 	}
 	/* Add the extent to transaction's private list */
-	ext4_journal_callback_add(handle, ext4_free_data_callback,
-				  &new_entry->efd_jce);
+	new_entry->efd_jce.jce_func = ext4_free_data_callback;
+	spin_lock(&sbi->s_md_lock);
+	_ext4_journal_callback_add(handle, &new_entry->efd_jce);
+	sbi->s_mb_free_pending += clusters;
+	spin_unlock(&sbi->s_md_lock);
 	return 0;
 }
 
-- 
2.5.0

