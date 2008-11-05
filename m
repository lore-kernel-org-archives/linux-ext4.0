From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH][BUG] jbd: fix the root cause of "no transactions" error in
 __log_wait_for_space()
Date: Wed, 5 Nov 2008 13:11:40 +0900
Message-ID: <20081105131140.7689f048.toshi.okajima@jp.fujitsu.com>
References: <20081017.223716.147444348.00960188@stratos.soft.fujitsu.com>
	<20081020160249.ff41f762.akpm@linux-foundation.org>
	<20081023174101.85b59177.toshi.okajima@jp.fujitsu.com>
	<20081027142657.2120aa3f.akpm@linux-foundation.org>
	<49067D03.6080609@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: akpm@linux-foundation.org, sct@redhat.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49067D03.6080609@jp.fujitsu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[abstract]
__log_wait_for_space() may call journal_abort() when all existing checkpoint
transactions are released by journal_head collectors 
 (except log_do_checkpoint()).

[details]
The value of journal->j_free is not up to date immediately after checkpoint 
transactions are actually released. In order to update it into the actual 
value, calling cleanup_journal_tail() is needed. Therefore the value of 
journal->j_free in __log_space_left() may be not up to date if 
cleanup_journal_tail() hasn't been yet called after checkpoint transactions
are released by journal_head collectors. Because journal_head collectors can
release not only a journal_head but also a checkpoint transaction. Besides it
doesn't update journal->j_free (= it doesn't call cleanup_journal_tail()).
Except, one of journal_head collectors, log_do_checkpoint() updates 
journal->j_free by calling cleanup_journal_tail(). 
Hence the value of journal->j_free in __log_space_left() may be not up to date 
after checkpoint transactions are released by journal_head collectors.

If the value of journal->j_free in __log_space_left() is not up to date,
jbd tries to release journal_heads by calling log_do_checkpoint() in
__log_wait_for_space() even if some checkpoint transactions have been released 
actually.
Therefore, if all checkpoint transactions have been released by journal_head 
collectors, __log_wait_for_space() calls journal_abort().

NOTE: The "journal mode" generates this bug the most easily of the three modes.
     Because it is only on the "journal mode" that 
     journal_try_to_free_buffers() can release a checkpoint transaction.
     (Description for ext3: 
      The direct block which has the filesystem mapping is one of 
      a checkpoint target on the "journal mode". On the other hand, the direct 
      block on the "ordered mode" or "writeback mode" is not.)

------------------------------------
journal_head collectors are:
- journal_try_to_free_buffers()
- __journal_clean_checkpoint_list()
- log_do_checkpoint()
------------------------------------

[How to fix]
<now>
 journal_head collectors can remove not only a journal_head but also 
a checkpoint transaction.
<changes>
 journal_head collectors can remove a journal_head only
(except log_do_checkpoint()).

Because journal_head collectors cannot recalculate the value of j_free.
But one of journal_head collectors, log_do_checkpoint() excepts.
(It is difficult to change to use j_free after journal_head collectors 
calculate it in __log_wait_for_space() because updating it needs to update 
the superblock with some I/O.)

Therefore jbd leaves log_do_checkpoint() to release a checkpoint transaction
which keeps remaining by journal_head collectors (except log_do_checkpoint()).

As a result, jbd can be prevented from "no transactions" error happening
 in __log_wait_for_space().

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/jbd/checkpoint.c  |   25 +++++++++++++++++++++----
 fs/jbd/commit.c      |    2 +-
 fs/jbd/transaction.c |    2 +-
 include/linux/jbd.h  |    2 +-
 4 files changed, 24 insertions(+), 7 deletions(-)

diff -Nurp linux-2.6.28-rc2.org/fs/jbd/checkpoint.c linux-2.6.28-rc2/fs/jbd/checkpoint.c
--- linux-2.6.28-rc2.org/fs/jbd/checkpoint.c	2008-10-27 04:13:29.000000000 +0900
+++ linux-2.6.28-rc2/fs/jbd/checkpoint.c	2008-10-31 19:21:09.000000000 +0900
@@ -96,7 +96,7 @@ static int __try_to_free_cp_buf(struct j
 	if (jh->b_jlist == BJ_None && !buffer_locked(bh) &&
 	    !buffer_dirty(bh) && !buffer_write_io_error(bh)) {
 		JBUFFER_TRACE(jh, "remove from checkpoint list");
-		ret = __journal_remove_checkpoint(jh) + 1;
+		ret = __journal_remove_checkpoint(jh, false) + 1;
 		jbd_unlock_bh_state(bh);
 		journal_remove_journal_head(bh);
 		BUFFER_TRACE(bh, "release");
@@ -221,7 +221,7 @@ restart:
 		 * Now in whatever state the buffer currently is, we know that
 		 * it has been written out and so we can drop it from the list
 		 */
-		released = __journal_remove_checkpoint(jh);
+		released = __journal_remove_checkpoint(jh, true);
 		jbd_unlock_bh_state(bh);
 		journal_remove_journal_head(bh);
 		__brelse(bh);
@@ -287,7 +287,7 @@ static int __process_buffer(journal_t *j
 			ret = -EIO;
 		J_ASSERT_JH(jh, !buffer_jbddirty(bh));
 		BUFFER_TRACE(bh, "remove from checkpoint");
-		__journal_remove_checkpoint(jh);
+		__journal_remove_checkpoint(jh, true);
 		spin_unlock(&journal->j_list_lock);
 		jbd_unlock_bh_state(bh);
 		journal_remove_journal_head(bh);
@@ -366,6 +366,16 @@ restart:
 		struct journal_head *jh;
 		int retry = 0, err;
 
+		/* 
+		 * Remove an oldest checkpoint transaction only if it has no
+		 * journal head.
+		 */
+		if (transaction->t_checkpoint_list == NULL
+		   && transaction->t_checkpoint_io_list == NULL) {
+			__journal_drop_transaction(journal, transaction);
+			wake_up(&journal->j_wait_logspace);
+			goto out;
+		}
 		while (!retry && transaction->t_checkpoint_list) {
 			struct buffer_head *bh;
 
@@ -614,12 +624,16 @@ out:
  *
  * The function returns 1 if it frees the transaction, 0 otherwise.
  *
+ * can_remove: 
+ *	false - we don't remove a checkpoint transaction.
+ *	true  - we remove a checkpoint transaction.
+ *
  * This function is called with the journal locked.
  * This function is called with j_list_lock held.
  * This function is called with jbd_lock_bh_state(jh2bh(jh))
  */
 
-int __journal_remove_checkpoint(struct journal_head *jh)
+int __journal_remove_checkpoint(struct journal_head *jh, bool can_remove)
 {
 	transaction_t *transaction;
 	journal_t *journal;
@@ -636,6 +650,9 @@ int __journal_remove_checkpoint(struct j
 	__buffer_unlink(jh);
 	jh->b_cp_transaction = NULL;
 
+	if (!can_remove)
+		goto out;
+
 	if (transaction->t_checkpoint_list != NULL ||
 	    transaction->t_checkpoint_io_list != NULL)
 		goto out;
diff -Nurp linux-2.6.28-rc2.org/fs/jbd/commit.c linux-2.6.28-rc2/fs/jbd/commit.c
--- linux-2.6.28-rc2.org/fs/jbd/commit.c	2008-10-27 04:13:29.000000000 +0900
+++ linux-2.6.28-rc2/fs/jbd/commit.c	2008-10-31 18:02:37.000000000 +0900
@@ -833,7 +833,7 @@ restart_loop:
 		cp_transaction = jh->b_cp_transaction;
 		if (cp_transaction) {
 			JBUFFER_TRACE(jh, "remove from old cp transaction");
-			__journal_remove_checkpoint(jh);
+			__journal_remove_checkpoint(jh, false);
 		}
 
 		/* Only re-checkpoint the buffer_head if it is marked
diff -Nurp linux-2.6.28-rc2.org/fs/jbd/transaction.c linux-2.6.28-rc2/fs/jbd/transaction.c
--- linux-2.6.28-rc2.org/fs/jbd/transaction.c	2008-10-27 04:13:29.000000000 +0900
+++ linux-2.6.28-rc2/fs/jbd/transaction.c	2008-10-31 18:02:37.000000000 +0900
@@ -1648,7 +1648,7 @@ __journal_try_to_free_buffer(journal_t *
 		/* written-back checkpointed metadata buffer */
 		if (jh->b_jlist == BJ_None) {
 			JBUFFER_TRACE(jh, "remove from checkpoint list");
-			__journal_remove_checkpoint(jh);
+			__journal_remove_checkpoint(jh, false);
 			journal_remove_journal_head(bh);
 			__brelse(bh);
 		}
diff -Nurp linux-2.6.28-rc2.org/include/linux/jbd.h linux-2.6.28-rc2/include/linux/jbd.h
--- linux-2.6.28-rc2.org/include/linux/jbd.h	2008-10-27 04:13:29.000000000 +0900
+++ linux-2.6.28-rc2/include/linux/jbd.h	2008-10-31 18:02:37.000000000 +0900
@@ -844,7 +844,7 @@ extern void journal_commit_transaction(j
 
 /* Checkpoint list management */
 int __journal_clean_checkpoint_list(journal_t *journal);
-int __journal_remove_checkpoint(struct journal_head *);
+int __journal_remove_checkpoint(struct journal_head *, bool);
 void __journal_insert_checkpoint(struct journal_head *, transaction_t *);
 
 /* Buffer IO */
