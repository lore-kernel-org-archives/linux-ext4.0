Return-Path: <SRS0=65gx=NY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:55547 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726245AbeKMS47 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 13 Nov 2018 13:56:59 -0500
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: jack@suse.com, tytso@mit.edu,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] ext4: fix deadlock while checkpoint thread waits commit thread to finish
Date: Tue, 13 Nov 2018 16:59:07 +0800
Message-Id: <20181113085907.22545-1-xiaoguang.wang@linux.alibaba.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This issue was found when I tried to put checkpoint work in a separate thread,
the deadlock below happened:
         Thread1                                |   Thread2
__jbd2_log_wait_for_space                       |
jbd2_log_do_checkpoint (hold j_checkpoint_mutex)|
  if (jh->b_transaction != NULL)                |
    ...                                         |
    jbd2_log_start_commit(journal, tid);        |jbd2_update_log_tail
                                                |  will lock j_checkpoint_mutex,
                                                |  but will be blocked here.
                                                |
    jbd2_log_wait_commit(journal, tid);         |
    wait_event(journal->j_wait_done_commit,     |
     !tid_gt(tid, journal->j_commit_sequence)); |
     ...                                        |wake_up(j_wait_done_commit)
  }                                             |

then deadlock occurs, Thread1 will never be waken up.

To fix this issue, here we introduce a new j_loginfo_mutex to protect
concurrent modifications to journal log tail info.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/jbd2/checkpoint.c |  2 +-
 fs/jbd2/commit.c     |  6 +++---
 fs/jbd2/journal.c    | 16 +++++++++-------
 include/linux/jbd2.h |  9 ++++++++-
 4 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index c125d662777c..1729d6298895 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -404,7 +404,7 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
 	if (journal->j_flags & JBD2_BARRIER)
 		blkdev_issue_flush(journal->j_fs_dev, GFP_NOFS, NULL);
 
-	return __jbd2_update_log_tail(journal, first_tid, blocknr);
+	return jbd2_update_log_tail(journal, first_tid, blocknr);
 }
 
 
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 150cc030b4d7..f139f5465687 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -383,9 +383,9 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	/* Do we need to erase the effects of a prior jbd2_journal_flush? */
 	if (journal->j_flags & JBD2_FLUSHED) {
 		jbd_debug(3, "super block updated\n");
-		mutex_lock_io(&journal->j_checkpoint_mutex);
+		mutex_lock_io(&journal->j_loginfo_mutex);
 		/*
-		 * We hold j_checkpoint_mutex so tail cannot change under us.
+		 * We hold j_loginfo_mutex so tail cannot change under us.
 		 * We don't need any special data guarantees for writing sb
 		 * since journal is empty and it is ok for write to be
 		 * flushed only with transaction commit.
@@ -394,7 +394,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 						journal->j_tail_sequence,
 						journal->j_tail,
 						REQ_SYNC);
-		mutex_unlock(&journal->j_checkpoint_mutex);
+		mutex_unlock(&journal->j_loginfo_mutex);
 	} else {
 		jbd_debug(3, "superblock not updated\n");
 	}
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 8ef6b6daaa7a..be2c10ff5bae 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -940,8 +940,6 @@ int __jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block)
 	unsigned long freed;
 	int ret;
 
-	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
-
 	/*
 	 * We cannot afford for write to remain in drive's caches since as
 	 * soon as we update j_tail, next transaction can start reusing journal
@@ -978,12 +976,16 @@ int __jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block)
  * provided log tail and locks j_checkpoint_mutex. So it is safe against races
  * with other threads updating log tail.
  */
-void jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block)
+int jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block)
 {
-	mutex_lock_io(&journal->j_checkpoint_mutex);
+	int ret = 0;
+
+	mutex_lock_io(&journal->j_loginfo_mutex);
 	if (tid_gt(tid, journal->j_tail_sequence))
-		__jbd2_update_log_tail(journal, tid, block);
-	mutex_unlock(&journal->j_checkpoint_mutex);
+		ret = __jbd2_update_log_tail(journal, tid, block);
+	mutex_unlock(&journal->j_loginfo_mutex);
+
+	return ret;
 }
 
 struct jbd2_stats_proc_session {
@@ -1147,6 +1149,7 @@ static journal_t *journal_init_common(struct block_device *bdev,
 	init_waitqueue_head(&journal->j_wait_reserved);
 	mutex_init(&journal->j_barrier);
 	mutex_init(&journal->j_checkpoint_mutex);
+	mutex_init(&journal->j_loginfo_mutex);
 	spin_lock_init(&journal->j_revoke_lock);
 	spin_lock_init(&journal->j_list_lock);
 	rwlock_init(&journal->j_state_lock);
@@ -1420,7 +1423,6 @@ int jbd2_journal_update_sb_log_tail(journal_t *journal, tid_t tail_tid,
 	if (is_journal_aborted(journal))
 		return -EIO;
 
-	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
 	jbd_debug(1, "JBD2: updating superblock (start %lu, seq %u)\n",
 		  tail_block, tail_tid);
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index b708e5169d1d..a9c2928aea35 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -862,6 +862,13 @@ struct journal_s
 	 */
 	struct buffer_head	*j_chkpt_bhs[JBD2_NR_BATCH];
 
+	/**
+	 * @j_loginfo_mutex:
+	 *
+	 * Semaphore for locking against concurrent update journal info.
+	 */
+	struct mutex		j_loginfo_mutex;
+
 	/**
 	 * @j_head:
 	 *
@@ -1265,7 +1272,7 @@ int jbd2_journal_next_log_block(journal_t *, unsigned long long *);
 int jbd2_journal_get_log_tail(journal_t *journal, tid_t *tid,
 			      unsigned long *block);
 int __jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block);
-void jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block);
+int jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block);
 
 /* Commit management */
 extern void jbd2_journal_commit_transaction(journal_t *);
-- 
2.14.4.44.g2045bb6
