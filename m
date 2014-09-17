From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] jbd2: Simplify calling convention around __jbd2_journal_clean_checkpoint_list
Date: Wed, 17 Sep 2014 11:31:30 +0200
Message-ID: <1410946290-5128-2-git-send-email-jack@suse.cz>
References: <1410946290-5128-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	Yuanhan Liu <yuanhan.liu@linux.intel.com>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709AbaIQJbg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Sep 2014 05:31:36 -0400
In-Reply-To: <1410946290-5128-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

__jbd2_journal_clean_checkpoint_list() returns number of buffers it
freed but noone was using the value so just stop doing that. This
also allows for simplifying the calling convention for
journal_clean_once_cp_list().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/checkpoint.c | 56 ++++++++++++++++++++++------------------------------
 include/linux/jbd2.h |  2 +-
 2 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index e39b2d0e1079..ef23d6f4a6a2 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -479,16 +479,15 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
  * release them.
  *
  * Called with j_list_lock held.
- * Returns number of buffers reaped (for debug)
+ * Returns 1 if we freed the transaction, 0 otherwise.
  */
-
-static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
+static int journal_clean_one_cp_list(struct journal_head *jh)
 {
 	struct journal_head *last_jh;
 	struct journal_head *next_jh = jh;
-	int ret, freed = 0;
+	int ret;
+	int freed = 0;
 
-	*released = 0;
 	if (!jh)
 		return 0;
 
@@ -499,11 +498,9 @@ static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
 		ret = __try_to_free_cp_buf(jh);
 		if (!ret)
 			return freed;
-		freed++;
-		if (ret == 2) {
-			*released = 1;
-			return freed;
-		}
+		if (ret == 2)
+			return 1;
+		freed = 1;
 		/*
 		 * This function only frees up some memory
 		 * if possible so we dont have an obligation
@@ -523,53 +520,48 @@ static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
  * Find all the written-back checkpoint buffers in the journal and release them.
  *
  * Called with j_list_lock held.
- * Returns number of buffers reaped (for debug)
  */
-
-int __jbd2_journal_clean_checkpoint_list(journal_t *journal)
+void __jbd2_journal_clean_checkpoint_list(journal_t *journal)
 {
 	transaction_t *transaction, *last_transaction, *next_transaction;
 	int ret;
-	int freed = 0;
-	int released;
 
 	transaction = journal->j_checkpoint_transactions;
 	if (!transaction)
-		goto out;
+		return;
 
 	last_transaction = transaction->t_cpprev;
 	next_transaction = transaction;
 	do {
 		transaction = next_transaction;
 		next_transaction = transaction->t_cpnext;
-		ret = journal_clean_one_cp_list(transaction->
-				t_checkpoint_list, &released);
+		ret = journal_clean_one_cp_list(transaction->t_checkpoint_list);
 		/*
 		 * This function only frees up some memory if possible so we
 		 * dont have an obligation to finish processing. Bail out if
 		 * preemption requested:
 		 */
-		if (need_resched()) {
-			freed += ret;
-			goto out;
-		}
-		if (released) {
-			freed += ret;
+		if (need_resched())
+			return;
+		if (ret)
 			continue;
-		}
 		/*
 		 * It is essential that we are as careful as in the case of
 		 * t_checkpoint_list with removing the buffer from the list as
 		 * we can possibly see not yet submitted buffers on io_list
 		 */
-		ret += journal_clean_one_cp_list(transaction->
-				t_checkpoint_io_list, &released);
-		freed += ret;
-		if (need_resched() || !ret)
-			goto out;
+		ret = journal_clean_one_cp_list(transaction->
+				t_checkpoint_io_list);
+		if (need_resched())
+			return;
+		/*
+		 * Stop scanning if we couldn't free the transaction. This
+		 * avoids pointless scanning of transactions which still
+		 * weren't checkpointed.
+		 */
+ 		if (!ret)
+			return;
 	} while (transaction != last_transaction);
-out:
-	return freed;
 }
 
 /*
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 0dae71e9971c..704b9a599b26 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1042,7 +1042,7 @@ void jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block);
 extern void jbd2_journal_commit_transaction(journal_t *);
 
 /* Checkpoint list management */
-int __jbd2_journal_clean_checkpoint_list(journal_t *journal);
+void __jbd2_journal_clean_checkpoint_list(journal_t *journal);
 int __jbd2_journal_remove_checkpoint(struct journal_head *);
 void __jbd2_journal_insert_checkpoint(struct journal_head *, transaction_t *);
 
-- 
1.8.1.4

