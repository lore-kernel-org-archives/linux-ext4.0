From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd: Remove j_barrier mutex
Date: Thu, 22 Dec 2011 15:07:45 +0100
Message-ID: <1324562865-4720-1-git-send-email-jack@suse.cz>
Cc: akmp@suse.cz, rjw@sisk.pl, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab1LVOIP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Dec 2011 09:08:15 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

j_barrier mutex is used for serializing different journal lock operations.  The
problem with it is that e.g. FIFREEZE ioctl results in process leaving kernel
with j_barrier mutex held which makes lockdep freak out. Also hibernation code
wants to freeze filesystem but it cannot do so because it then cannot hibernate
the system because of mutex being locked.

So we remove j_barrier mutex and use direct wait on j_barrier_count instead.
Since locking journal is a rare operation we don't have to care about fairness
or such things.

CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/journal.c     |    1 -
 fs/jbd/transaction.c |   36 +++++++++++++++++++++---------------
 include/linux/jbd.h  |    4 ----
 3 files changed, 21 insertions(+), 20 deletions(-)

  I carry this patch in my tree and plan to merge it in the next merge window
unless someone objects.

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index fea8dd6..1656dc2 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -721,7 +721,6 @@ static journal_t * journal_init_common (void)
 	init_waitqueue_head(&journal->j_wait_checkpoint);
 	init_waitqueue_head(&journal->j_wait_commit);
 	init_waitqueue_head(&journal->j_wait_updates);
-	mutex_init(&journal->j_barrier);
 	mutex_init(&journal->j_checkpoint_mutex);
 	spin_lock_init(&journal->j_revoke_lock);
 	spin_lock_init(&journal->j_list_lock);
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 7e59c6e..7fce94b 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -426,17 +426,34 @@ int journal_restart(handle_t *handle, int nblocks)
  * void journal_lock_updates () - establish a transaction barrier.
  * @journal:  Journal to establish a barrier on.
  *
- * This locks out any further updates from being started, and blocks
- * until all existing updates have completed, returning only once the
- * journal is in a quiescent state with no updates running.
- *
- * The journal lock should not be held on entry.
+ * This locks out any further updates from being started, and blocks until all
+ * existing updates have completed, returning only once the journal is in a
+ * quiescent state with no updates running.
+ *
+ * We do not use simple mutex for synchronization as there are syscalls which
+ * want to return with filesystem locked and that trips up lockdep. Also
+ * hibernate needs to lock filesystem but locked mutex then blocks hibernation.
+ * Since locking filesystem is rare operation, we use simple counter and
+ * waitqueue for locking.
  */
 void journal_lock_updates(journal_t *journal)
 {
 	DEFINE_WAIT(wait);
 
+wait:
+	/* Wait for previous locked operation to finish */
+	wait_event(journal->j_wait_transaction_locked,
+		   journal->j_barrier_count == 0);
+
 	spin_lock(&journal->j_state_lock);
+	/*
+	 * Check reliably under the lock whether we are the ones winning the race
+	 * and locking the journal
+	 */
+	if (journal->j_barrier_count > 0) {
+		spin_unlock(&journal->j_state_lock);
+		goto wait;
+	}
 	++journal->j_barrier_count;
 
 	/* Wait until there are no running updates */
@@ -460,14 +477,6 @@ void journal_lock_updates(journal_t *journal)
 		spin_lock(&journal->j_state_lock);
 	}
 	spin_unlock(&journal->j_state_lock);
-
-	/*
-	 * We have now established a barrier against other normal updates, but
-	 * we also need to barrier against other journal_lock_updates() calls
-	 * to make sure that we serialise special journal-locked operations
-	 * too.
-	 */
-	mutex_lock(&journal->j_barrier);
 }
 
 /**
@@ -475,14 +484,11 @@ void journal_lock_updates(journal_t *journal)
  * @journal:  Journal to release the barrier on.
  *
  * Release a transaction barrier obtained with journal_lock_updates().
- *
- * Should be called without the journal lock held.
  */
 void journal_unlock_updates (journal_t *journal)
 {
 	J_ASSERT(journal->j_barrier_count != 0);
 
-	mutex_unlock(&journal->j_barrier);
 	spin_lock(&journal->j_state_lock);
 	--journal->j_barrier_count;
 	spin_unlock(&journal->j_state_lock);
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 492cc12..d211732 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -497,7 +497,6 @@ struct transaction_s
  * @j_format_version: Version of the superblock format
  * @j_state_lock: Protect the various scalars in the journal
  * @j_barrier_count:  Number of processes waiting to create a barrier lock
- * @j_barrier: The barrier lock itself
  * @j_running_transaction: The current running transaction..
  * @j_committing_transaction: the transaction we are pushing to disk
  * @j_checkpoint_transactions: a linked circular list of all transactions
@@ -580,9 +579,6 @@ struct journal_s
 	 */
 	int			j_barrier_count;
 
-	/* The barrier lock itself */
-	struct mutex		j_barrier;
