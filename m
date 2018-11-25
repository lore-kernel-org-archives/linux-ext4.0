Return-Path: <SRS0=jmd0=OE=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:51068 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727428AbeKYT1C (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 25 Nov 2018 14:27:02 -0500
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: jack@suse.cz, Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH v2] jbd2: fix deadlock while checkpoint thread waits commit thread to finish
Date: Sun, 25 Nov 2018 16:36:06 +0800
Message-Id: <20181125083606.5273-1-xiaoguang.wang@linux.alibaba.com>
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

To fix this issue, drop j_checkpoint_mutex in jbd2_log_do_checkpoint()
when we are going to wait for transaction commit.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

----------------
v2:
    1, modify patch's subsys name from ext4 to jbd2
    2, do not modify initial logic about whether transaction is gone in
       jbd2_log_do_checkpoint();
---
 fs/jbd2/checkpoint.c | 17 +++++++++++++++--
 fs/jbd2/journal.c    |  2 +-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 26f8d7e46462..02e0b79753e7 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -113,7 +113,7 @@ void __jbd2_log_wait_for_space(journal_t *journal)
 	nblocks = jbd2_space_needed(journal);
 	while (jbd2_log_space_left(journal) < nblocks) {
 		write_unlock(&journal->j_state_lock);
-		mutex_lock(&journal->j_checkpoint_mutex);
+		mutex_lock_io(&journal->j_checkpoint_mutex);
 
 		/*
 		 * Test again, another process may have checkpointed while we
@@ -276,9 +276,22 @@ int jbd2_log_do_checkpoint(journal_t *journal)
 		"JBD2: %s: Waiting for Godot: block %llu\n",
 		journal->j_devname, (unsigned long long) bh->b_blocknr);
 
+			if (batch_count)
+				__flush_batch(journal, &batch_count);
 			jbd2_log_start_commit(journal, tid);
+			/*
+			 * jbd2_journal_commit_transaction() may want
+			 * to take the checkpoint_mutex if JBD2_FLUSHED
+			 * is set, jbd2_update_log_tail() called by
+			 * jbd2_journal_commit_transaction() may also take
+			 * checkpoint_mutex.  So we need to temporarily
+			 * drop it.
+			 */
+			mutex_unlock(&journal->j_checkpoint_mutex);
 			jbd2_log_wait_commit(journal, tid);
-			goto retry;
+			mutex_lock_io(&journal->j_checkpoint_mutex);
+			spin_lock(&journal->j_list_lock);
+			goto restart;
 		}
 		if (!buffer_dirty(bh)) {
 			if (unlikely(buffer_write_io_error(bh)) && !result)
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 8ef6b6daaa7a..88d8f22d2cba 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2067,7 +2067,7 @@ int jbd2_journal_wipe(journal_t *journal, int write)
 	err = jbd2_journal_skip_recovery(journal);
 	if (write) {
 		/* Lock to make assertions happy... */
-		mutex_lock(&journal->j_checkpoint_mutex);
+		mutex_lock_io(&journal->j_checkpoint_mutex);
 		jbd2_mark_journal_empty(journal, REQ_SYNC | REQ_FUA);
 		mutex_unlock(&journal->j_checkpoint_mutex);
 	}
-- 
2.17.2
