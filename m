From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: remove __jbd2_journal_clean_checkpoint_list to
 solve scalability issue
Date: Tue, 16 Sep 2014 13:05:25 +0200
Message-ID: <20140916110525.GB1205@quack.suse.cz>
References: <1410430193-6112-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20140911135147.GD30901@quack.suse.cz>
 <20140911154539.GK3052@yliu-dev.sh.intel.com>
 <20140912094054.GA5958@quack.suse.cz>
 <20140915033852.GL3052@yliu-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Andi Kleen <ak@linux.intel.com>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116AbaIPOPZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Sep 2014 10:15:25 -0400
Content-Disposition: inline
In-Reply-To: <20140915033852.GL3052@yliu-dev.sh.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 15-09-14 11:38:52, Yuanhan Liu wrote:
> On Fri, Sep 12, 2014 at 11:40:54AM +0200, Jan Kara wrote:
> > On Thu 11-09-14 23:45:39, Yuanhan Liu wrote:
> > > On Thu, Sep 11, 2014 at 03:51:47PM +0200, Jan Kara wrote:
> > > > On Thu 11-09-14 18:09:53, Yuanhan Liu wrote:
> > > > > Firstly, if I read the code correctly(I have a feeling I missed something),
> > > > > __jbd2_journal_clean_checkpoint_list is not necessary. jbd2_log_do_checkpoint
> > > > > will remove them for the checkpointed transaction. In another word,
> > > > > __jbd2_journal_clean_checkpoint_list can't drop an transaction if it's not
> > > > > checkpointed.
> > > >   Yes, that's correct. __jbd2_journal_clean_checkpoint_list() is there only
> > > > to free up buffers that were already checkpointed.
> > > 
> > > Yes, and that might be something I missed: if a transaction is
> > > checkpointed, those buffers attached to the transaction should also be
> > > released, right? If that's ture, what __jbd2_journal_clean_checkpoint_list()
> > > is for?
> >   They aren't released unless memory reclaim wants to free the
> > corresponding pagecache page. So they need to be detached from the
> > transaction somehow once they are written so that the transaction can be
> > eventually freed which frees the space in the journal. Currently we do this
> > detaching either in __jbd2_journal_clean_checkpoint_list() or in
> > jbd2_log_do_checkpoint(). However the latter function gets called only when
> > we really run out of space in the journal and thus everything in the
> > filesystem waits for some space to be reclaimed. So relying on that function
> > isn't good for performance either...
> > 
> > One possibility is to remove buffer from transaction on IO completion.
> 
> Yes, that's the same thing I thought of. b_end_io hook is the first
> thing I thought of, and I tried it. Badly, it was never being invoked.
> 
> I then realised that it should be written by page cache(writeback or
> page reclaim as you mentioned), and that's the stuff I missed before.
> So, my patch was wrong and sorry for that.
  No problem :).

> > However that's likely going to bounce j_list_lock between CPUs badly. So
> 
> I checked __jbd2_journal_remove_checkpoint(jh) again, which is the
> entrance to free a journal buffer. It has two main parts:
> 
> 	__buffer_unlink(jh)
> 
> 	drop_transaction() if all jh are written
> 
> The two are all protected by j_list_lock. IMO, we can split it, say
> let __buffer_unlink(jh) be protected by a per-transaction spin lock,
> and let drop_transaction() be protected by by j_list_lock as it was.
> 
> As drop_transaction() doesn't happen frequently as __buffer_unlink(jh),
> it should alleviate the lock contention a bit.
  Yes, drop_transaction() isn't really an issue. But when doing
__buffer_unlink() during IO completion, making the checkpoint list lock
per-transaction one won't help the contention for the common case where
transactions are reasonably large.

I was thinking about it for a while. I was thinking about various clever
solutions but in the end what I think would be the best is just
to change __jbd2_journal_clean_checkpoint_list() to bail out once it spots
a transaction it cannot free. That will deal with the pointless scanning of
checkpointing lists you are hitting with your workload, it will also do all
the cleanup that is necessary for transactions to be eventually cleaned up
from the journal without having to wait in log_do_checkpoint().

Attached are two patches - lightly tested only. Can you try whether they
fix the contention for you? Thanks!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--mP3DRpeJDSE+ciuQ
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-jbd2-Avoid-pointless-scanning-of-checkpoint-lists.patch"

>From ee5a1b87e267a8ae8935952c3c6971fa6cc41c63 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 16 Sep 2014 12:25:20 +0200
Subject: [PATCH 1/2] jbd2: Avoid pointless scanning of checkpoint lists

Yuanhan has reported that when he is running fsync(2) heavy workload
creating new files over ramdisk, significant amount of time is spent in
__jbd2_journal_clean_checkpoint_list() trying to clean old transactions
(but they cannot be cleaned up because flusher hasn't yet checkpointed
those buffers).

Reduce the amount of scanning by stopping to scan the transaction list
once we find a transaction that cannot be checkpointed. Note that this
way of cleaning is still enough to keep freeing space in the journal
after fully checkpointed transactions.

Reported-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/checkpoint.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 7f34f4716165..e39b2d0e1079 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -478,7 +478,6 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
  * Find all the written-back checkpoint buffers in the given list and
  * release them.
  *
- * Called with the journal locked.
  * Called with j_list_lock held.
  * Returns number of buffers reaped (for debug)
  */
@@ -498,12 +497,12 @@ static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
 		jh = next_jh;
 		next_jh = jh->b_cpnext;
 		ret = __try_to_free_cp_buf(jh);
-		if (ret) {
-			freed++;
-			if (ret == 2) {
-				*released = 1;
-				return freed;
-			}
+		if (!ret)
+			return freed;
+		freed++;
+		if (ret == 2) {
+			*released = 1;
+			return freed;
 		}
 		/*
 		 * This function only frees up some memory
@@ -523,7 +522,6 @@ static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
  *
  * Find all the written-back checkpoint buffers in the journal and release them.
  *
- * Called with the journal locked.
  * Called with j_list_lock held.
  * Returns number of buffers reaped (for debug)
  */
@@ -531,7 +529,8 @@ static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
 int __jbd2_journal_clean_checkpoint_list(journal_t *journal)
 {
 	transaction_t *transaction, *last_transaction, *next_transaction;
-	int ret = 0;
+	int ret;
+	int freed = 0;
 	int released;
 
 	transaction = journal->j_checkpoint_transactions;
@@ -543,17 +542,21 @@ int __jbd2_journal_clean_checkpoint_list(journal_t *journal)
 	do {
 		transaction = next_transaction;
 		next_transaction = transaction->t_cpnext;
-		ret += journal_clean_one_cp_list(transaction->
+		ret = journal_clean_one_cp_list(transaction->
 				t_checkpoint_list, &released);
 		/*
 		 * This function only frees up some memory if possible so we
 		 * dont have an obligation to finish processing. Bail out if
 		 * preemption requested:
 		 */
-		if (need_resched())
+		if (need_resched()) {
+			freed += ret;
 			goto out;
-		if (released)
+		}
+		if (released) {
+			freed += ret;
 			continue;
+		}
 		/*
 		 * It is essential that we are as careful as in the case of
 		 * t_checkpoint_list with removing the buffer from the list as
@@ -561,11 +564,12 @@ int __jbd2_journal_clean_checkpoint_list(journal_t *journal)
 		 */
 		ret += journal_clean_one_cp_list(transaction->
 				t_checkpoint_io_list, &released);
-		if (need_resched())
+		freed += ret;
+		if (need_resched() || !ret)
 			goto out;
 	} while (transaction != last_transaction);
 out:
-	return ret;
+	return freed;
 }
 
 /*
-- 
1.8.1.4


--mP3DRpeJDSE+ciuQ
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-jbd2-Simplify-calling-convention-around-__jbd2_journ.patch"

>From 8e17e25b044489429ef27433ee83066950a202b3 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 16 Sep 2014 12:46:34 +0200
Subject: [PATCH 2/2] jbd2: Simplify calling convention around
 __jbd2_journal_clean_checkpoint_list

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


--mP3DRpeJDSE+ciuQ--
