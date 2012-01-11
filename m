From: Jan Kara <jack@suse.cz>
Subject: [PATCH 5/6] jbd2: Remove bh_state lock from checkpointing code
Date: Wed, 11 Jan 2012 01:31:11 +0100
Message-ID: <1326241872-20142-6-git-send-email-jack@suse.cz>
References: <1326241872-20142-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198Ab2AKAb2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jan 2012 19:31:28 -0500
In-Reply-To: <1326241872-20142-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

All accesses to checkpointing entries in journal_head are protected
by j_list_lock. Thus __jbd2_journal_remove_checkpoint() doesn't really
need bh_state lock.

Also the only part of journal head that the rest of checkpointing code
needs to check is jh->b_transaction which is safe to read under
j_list_lock.

So we can safely remove bh_state lock from all of checkpointing code which
makes it considerably prettier.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/checkpoint.c         |   59 +++++-------------------------------------
 include/linux/journal-head.h |    2 +
 2 files changed, 9 insertions(+), 52 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 3816695..7cdeb34 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -88,14 +88,13 @@ static inline void __buffer_relink_io(struct journal_head *jh)
  * whole transaction.
  *
  * Requires j_list_lock
- * Called under jbd_lock_bh_state(jh2bh(jh)), and drops it
  */
 static int __try_to_free_cp_buf(struct journal_head *jh)
 {
 	int ret = 0;
 	struct buffer_head *bh = jh2bh(jh);
 
-	if (jh->b_jlist == BJ_None && !buffer_locked(bh) &&
+	if (jh->b_transaction == NULL && !buffer_locked(bh) &&
 	    !buffer_dirty(bh) && !buffer_write_io_error(bh)) {
 		/*
 		 * Get our reference so that bh cannot be freed before
@@ -104,11 +103,8 @@ static int __try_to_free_cp_buf(struct journal_head *jh)
 		get_bh(bh);
 		JBUFFER_TRACE(jh, "remove from checkpoint list");
 		ret = __jbd2_journal_remove_checkpoint(jh) + 1;
-		jbd_unlock_bh_state(bh);
 		BUFFER_TRACE(bh, "release");
 		__brelse(bh);
-	} else {
-		jbd_unlock_bh_state(bh);
 	}
 	return ret;
 }
@@ -180,21 +176,6 @@ void __jbd2_log_wait_for_space(journal_t *journal)
 }
 
 /*
- * We were unable to perform jbd_trylock_bh_state() inside j_list_lock.
- * The caller must restart a list walk.  Wait for someone else to run
- * jbd_unlock_bh_state().
- */
-static void jbd_sync_bh(journal_t *journal, struct buffer_head *bh)
-	__releases(journal->j_list_lock)
-{
-	get_bh(bh);
-	spin_unlock(&journal->j_list_lock);
-	jbd_lock_bh_state(bh);
-	jbd_unlock_bh_state(bh);
-	put_bh(bh);
-}
-
-/*
  * Clean up transaction's list of buffers submitted for io.
  * We wait for any pending IO to complete and remove any clean
  * buffers. Note that we take the buffers in the opposite ordering
@@ -222,15 +203,9 @@ restart:
 	while (!released && transaction->t_checkpoint_io_list) {
 		jh = transaction->t_checkpoint_io_list;
 		bh = jh2bh(jh);
-		if (!jbd_trylock_bh_state(bh)) {
-			jbd_sync_bh(journal, bh);
-			spin_lock(&journal->j_list_lock);
-			goto restart;
-		}
 		get_bh(bh);
 		if (buffer_locked(bh)) {
 			spin_unlock(&journal->j_list_lock);
-			jbd_unlock_bh_state(bh);
 			wait_on_buffer(bh);
 			/* the journal_head may have gone by now */
 			BUFFER_TRACE(bh, "brelse");
@@ -246,7 +221,6 @@ restart:
 		 * it has been written out and so we can drop it from the list
 		 */
 		released = __jbd2_journal_remove_checkpoint(jh);
-		jbd_unlock_bh_state(bh);
 		__brelse(bh);
 	}
 
@@ -280,7 +254,6 @@ __flush_batch(journal_t *journal, int *batch_count)
  * be written out.
  *
  * Called with j_list_lock held and drops it if 1 is returned
- * Called under jbd_lock_bh_state(jh2bh(jh)), and drops it
  */
 static int __process_buffer(journal_t *journal, struct journal_head *jh,
 			    int *batch_count, transaction_t *transaction)
@@ -291,7 +264,6 @@ static int __process_buffer(journal_t *journal, struct journal_head *jh,
 	if (buffer_locked(bh)) {
 		get_bh(bh);
 		spin_unlock(&journal->j_list_lock);
-		jbd_unlock_bh_state(bh);
 		wait_on_buffer(bh);
 		/* the journal_head may have gone by now */
 		BUFFER_TRACE(bh, "brelse");
@@ -303,7 +275,6 @@ static int __process_buffer(journal_t *journal, struct journal_head *jh,
 
 		transaction->t_chp_stats.cs_forced_to_close++;
 		spin_unlock(&journal->j_list_lock);
-		jbd_unlock_bh_state(bh);
 		if (unlikely(journal->j_flags & JBD2_UNMOUNT))
 			/*
 			 * The journal thread is dead; so starting and
@@ -322,11 +293,9 @@ static int __process_buffer(journal_t *journal, struct journal_head *jh,
 		if (unlikely(buffer_write_io_error(bh)))
 			ret = -EIO;
 		get_bh(bh);
-		J_ASSERT_JH(jh, !buffer_jbddirty(bh));
 		BUFFER_TRACE(bh, "remove from checkpoint");
 		__jbd2_journal_remove_checkpoint(jh);
 		spin_unlock(&journal->j_list_lock);
-		jbd_unlock_bh_state(bh);
 		__brelse(bh);
 	} else {
 		/*
@@ -341,7 +310,6 @@ static int __process_buffer(journal_t *journal, struct journal_head *jh,
 		J_ASSERT_BH(bh, !buffer_jwrite(bh));
 		journal->j_chkpt_bhs[*batch_count] = bh;
 		__buffer_relink_io(jh);
-		jbd_unlock_bh_state(bh);
 		transaction->t_chp_stats.cs_written++;
 		(*batch_count)++;
 		if (*batch_count == JBD2_NR_BATCH) {
@@ -405,15 +373,7 @@ restart:
 		int retry = 0, err;
 
 		while (!retry && transaction->t_checkpoint_list) {
-			struct buffer_head *bh;
-
 			jh = transaction->t_checkpoint_list;
-			bh = jh2bh(jh);
-			if (!jbd_trylock_bh_state(bh)) {
-				jbd_sync_bh(journal, bh);
-				retry = 1;
-				break;
-			}
 			retry = __process_buffer(journal, jh, &batch_count,
 						 transaction);
 			if (retry < 0 && !result)
@@ -532,15 +492,12 @@ static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
 	do {
 		jh = next_jh;
 		next_jh = jh->b_cpnext;
-		/* Use trylock because of the ranking */
-		if (jbd_trylock_bh_state(jh2bh(jh))) {
-			ret = __try_to_free_cp_buf(jh);
-			if (ret) {
-				freed++;
-				if (ret == 2) {
-					*released = 1;
-					return freed;
-				}
+		ret = __try_to_free_cp_buf(jh);
+		if (ret) {
+			freed++;
+			if (ret == 2) {
+				*released = 1;
+				return freed;
 			}
 		}
 		/*
@@ -623,9 +580,7 @@ out:
  * The function can free jh and bh.
  *
  * This function is called with j_list_lock held.
- * This function is called with jbd_lock_bh_state(jh2bh(jh))
  */
