From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd: Refine commit writeout logic
Date: Tue, 27 Mar 2012 23:31:05 +0200
Message-ID: <1332883865-15969-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab2C0Vb1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Mar 2012 17:31:27 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 560768FE69
	for <linux-ext4@vger.kernel.org>; Tue, 27 Mar 2012 23:31:26 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we write out all journal buffers in WRITE_SYNC mode. This improves
performance for fsync heavy workloads but hinders performance when writes
are mostly asynchronous, most noticably it slows down readers and users
complain about slow desktop response etc.

So submit writes as asynchronous in the normal case and only submit writes as
WRITE_SYNC if we detect someone is waiting for current transaction commit.

I've gathered some numbers to back this change. The first is the read latency
test. It measures time to read 1 MB after several seconds of sleeping in
presence of streaming writes.

Top 10 times (out of 90) in us:
Before		After
2131586		697473
1709932		557487
1564598		535642
1480462		347573
1478579		323153
1408496		222181
1388960		181273
1329565		181070
1252486		172832
1223265		172278

Average:
619377		82180

So the improvement in both maximum and average latency is massive.

I've measured fsync throughput by:
fs_mark -n 100 -t 1 -s 16384 -d /mnt/fsync/ -S 1 -L 4

in presence of streaming reader. The numbers (fsyncs/s) are:
Before		After
9.9		6.3
6.8		6.0
6.3		6.2
5.8		6.1

So fsync performance seems unharmed by this change.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/commit.c            |   10 +++++++---
 fs/jbd/journal.c           |    2 ++
 fs/jbd/transaction.c       |    2 --
 include/linux/jbd.h        |   15 +++++++++------
 include/trace/events/jbd.h |   24 ++++++++----------------
 5 files changed, 26 insertions(+), 27 deletions(-)

 I plan to push this change to my tree... I'll also have a look at equivalent
ext4 change but there it's not that important because journal thread doesn't
do that much work as in ext3 with data=ordered by far.

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index f2b9a57..9d31e6a 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -298,6 +298,7 @@ void journal_commit_transaction(journal_t *journal)
 	int tag_flag;
 	int i;
 	struct blk_plug plug;
+	int write_op = WRITE;
 
 	/*
 	 * First job: lock down the current transaction and wait for
@@ -413,13 +414,16 @@ void journal_commit_transaction(journal_t *journal)
 
 	jbd_debug (3, "JBD: commit phase 2\n");
 
+	if (tid_geq(journal->j_commit_waited, commit_transaction->t_tid))
+		write_op = WRITE_SYNC;
+
 	/*
 	 * Now start flushing things to disk, in the order they appear
 	 * on the transaction lists.  Data blocks go first.
 	 */
 	blk_start_plug(&plug);
 	err = journal_submit_data_buffers(journal, commit_transaction,
-					  WRITE_SYNC);
+					  write_op);
 	blk_finish_plug(&plug);
 
 	/*
@@ -478,7 +482,7 @@ void journal_commit_transaction(journal_t *journal)
 
 	blk_start_plug(&plug);
 
-	journal_write_revoke_records(journal, commit_transaction, WRITE_SYNC);
+	journal_write_revoke_records(journal, commit_transaction, write_op);
 
 	/*
 	 * If we found any dirty or locked buffers, then we should have
@@ -649,7 +653,7 @@ start_journal_io:
 				clear_buffer_dirty(bh);
 				set_buffer_uptodate(bh);
 				bh->b_end_io = journal_end_buffer_io_sync;
-				submit_bh(WRITE_SYNC, bh);
+				submit_bh(write_op, bh);
 			}
 			cond_resched();
 
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 59c09f9..28101bb 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -561,6 +561,8 @@ int log_wait_commit(journal_t *journal, tid_t tid)
 	spin_unlock(&journal->j_state_lock);
 #endif
 	spin_lock(&journal->j_state_lock);
+	if (!tid_geq(journal->j_commit_waited, tid))
+		journal->j_commit_waited = tid;
 	while (tid_gt(tid, journal->j_commit_sequence)) {
 		jbd_debug(1, "JBD: want %d, j_commit_sequence=%d\n",
 				  tid, journal->j_commit_sequence);
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 7fce94b..478ecb6 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1433,8 +1433,6 @@ int journal_stop(handle_t *handle)
 		}
 	}
 
-	if (handle->h_sync)
-		transaction->t_synchronous_commit = 1;
 	current->journal_info = NULL;
 	spin_lock(&journal->j_state_lock);
 	spin_lock(&transaction->t_handle_lock);
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index d211732..f265682 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -479,12 +479,6 @@ struct transaction_s
 	 * How many handles used this transaction? [t_handle_lock]
 	 */
 	int t_handle_count;
-
-	/*
-	 * This transaction is being forced and some process is
-	 * waiting for it to finish.
-	 */
-	unsigned int t_synchronous_commit:1;
 };
 
 /**
@@ -531,6 +525,8 @@ struct transaction_s
  *  transaction
  * @j_commit_request: Sequence number of the most recent transaction wanting
  *     commit
+ * @j_commit_waited: Sequence number of the most recent transaction someone
+ *     is waiting for to commit.
  * @j_uuid: Uuid of client object.
  * @j_task: Pointer to the current commit thread for this journal
  * @j_max_transaction_buffers:  Maximum number of metadata buffers to allow in a
@@ -696,6 +692,13 @@ struct journal_s
 	tid_t			j_commit_request;
 
 	/*
+	 * Sequence number of the most recent transaction someone is waiting
+	 * for to commit.
+	 * [j_state_lock]
+	 */
+	tid_t                   j_commit_waited;
+
+	/*
 	 * Journal uuid: identifies the object (filesystem, LVM volume etc)
 	 * backed by this journal.  This will eventually be replaced by an array
 	 * of uuids, allowing us to index multiple devices within a single
diff --git a/include/trace/events/jbd.h b/include/trace/events/jbd.h
index aff64d8..9305e1b 100644
--- a/include/trace/events/jbd.h
+++ b/include/trace/events/jbd.h
@@ -36,19 +36,17 @@ DECLARE_EVENT_CLASS(jbd_commit,
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
-		__field(	char,	sync_commit		)
 		__field(	int,	transaction		)
 	),
 
 	TP_fast_assign(
 		__entry->dev		= journal->j_fs_dev->bd_dev;
-		__entry->sync_commit = commit_transaction->t_synchronous_commit;
 		__entry->transaction	= commit_transaction->t_tid;
 	),
 
-	TP_printk("dev %d,%d transaction %d sync %d",
+	TP_printk("dev %d,%d transaction %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->transaction, __entry->sync_commit)
+		  __entry->transaction)
 );
 
 DEFINE_EVENT(jbd_commit, jbd_start_commit,
@@ -87,19 +85,17 @@ TRACE_EVENT(jbd_drop_transaction,
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
-		__field(	char,	sync_commit		)
 		__field(	int,	transaction		)
 	),
 
 	TP_fast_assign(
 		__entry->dev		= journal->j_fs_dev->bd_dev;
-		__entry->sync_commit = commit_transaction->t_synchronous_commit;
 		__entry->transaction	= commit_transaction->t_tid;
 	),
 
-	TP_printk("dev %d,%d transaction %d sync %d",
+	TP_printk("dev %d,%d transaction %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->transaction, __entry->sync_commit)
+		  __entry->transaction)
 );
 
 TRACE_EVENT(jbd_end_commit,
@@ -109,21 +105,19 @@ TRACE_EVENT(jbd_end_commit,
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
-		__field(	char,	sync_commit		)
 		__field(	int,	transaction		)
 		__field(	int,	head			)
 	),
 
 	TP_fast_assign(
 		__entry->dev		= journal->j_fs_dev->bd_dev;
-		__entry->sync_commit = commit_transaction->t_synchronous_commit;
 		__entry->transaction	= commit_transaction->t_tid;
 		__entry->head		= journal->j_tail_sequence;
 	),
 
-	TP_printk("dev %d,%d transaction %d sync %d head %d",
+	TP_printk("dev %d,%d transaction %d head %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->transaction, __entry->sync_commit, __entry->head)
+		  __entry->transaction, __entry->head)
 );
 
 TRACE_EVENT(jbd_do_submit_data,
@@ -133,19 +127,17 @@ TRACE_EVENT(jbd_do_submit_data,
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
-		__field(	char,	sync_commit		)
 		__field(	int,	transaction		)
 	),
 
 	TP_fast_assign(
 		__entry->dev		= journal->j_fs_dev->bd_dev;
-		__entry->sync_commit = commit_transaction->t_synchronous_commit;
 		__entry->transaction	= commit_transaction->t_tid;
 	),
 
-	TP_printk("dev %d,%d transaction %d sync %d",
+	TP_printk("dev %d,%d transaction %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		   __entry->transaction, __entry->sync_commit)
+		   __entry->transaction)
 );
 
 TRACE_EVENT(jbd_cleanup_journal_tail,
-- 
1.7.1

