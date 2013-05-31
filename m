From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/26] jbd2: Remove unused waitqueues
Date: Fri, 31 May 2013 11:42:41 +0200
Message-ID: <1369993379-13017-9-git-send-email-jack@suse.cz>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab3EaJnJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 May 2013 05:43:09 -0400
In-Reply-To: <1369993379-13017-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

j_wait_logspace and j_wait_checkpoint are unused. Remove them.

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/checkpoint.c | 4 ----
 fs/jbd2/journal.c    | 2 --
 include/linux/jbd2.h | 8 --------
 3 files changed, 14 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index a572383..75a15f3 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -625,10 +625,6 @@ int __jbd2_journal_remove_checkpoint(struct journal_head *jh)
 
 	__jbd2_journal_drop_transaction(journal, transaction);
 	jbd2_journal_free_transaction(transaction);
-
-	/* Just in case anybody was waiting for more transactions to be
-           checkpointed... */
-	wake_up(&journal->j_wait_logspace);
 	ret = 1;
 out:
 	return ret;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index b8827f8..99e6ab3 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1027,9 +1027,7 @@ static journal_t * journal_init_common (void)
 		return NULL;
 
 	init_waitqueue_head(&journal->j_wait_transaction_locked);
-	init_waitqueue_head(&journal->j_wait_logspace);
 	init_waitqueue_head(&journal->j_wait_done_commit);
-	init_waitqueue_head(&journal->j_wait_checkpoint);
 	init_waitqueue_head(&journal->j_wait_commit);
 	init_waitqueue_head(&journal->j_wait_updates);
 	mutex_init(&journal->j_barrier);
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 7835719..f5b6f46 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -687,9 +687,7 @@ jbd2_time_diff(unsigned long start, unsigned long end)
  *  waiting for checkpointing
  * @j_wait_transaction_locked: Wait queue for waiting for a locked transaction
  *  to start committing, or for a barrier lock to be released
- * @j_wait_logspace: Wait queue for waiting for checkpointing to complete
  * @j_wait_done_commit: Wait queue for waiting for commit to complete
- * @j_wait_checkpoint:  Wait queue to trigger checkpointing
  * @j_wait_commit: Wait queue to trigger commit
  * @j_wait_updates: Wait queue to wait for updates to complete
  * @j_checkpoint_mutex: Mutex for locking against concurrent checkpoints
@@ -794,15 +792,9 @@ struct journal_s
 	 */
 	wait_queue_head_t	j_wait_transaction_locked;
 
-	/* Wait queue for waiting for checkpointing to complete */
-	wait_queue_head_t	j_wait_logspace;
-
 	/* Wait queue for waiting for commit to complete */
 	wait_queue_head_t	j_wait_done_commit;
 
-	/* Wait queue to trigger checkpointing */
-	wait_queue_head_t	j_wait_checkpoint;
