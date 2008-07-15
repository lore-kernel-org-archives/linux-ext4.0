From: Josef Bacik <jbacik@redhat.com>
Subject: Re: transaction batching performance & multi-threaded synchronous
	writers
Date: Tue, 15 Jul 2008 14:39:04 -0400
Message-ID: <20080715183904.GC30311@unused.rdu.redhat.com>
References: <487B7B9B.3020001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@sun.com
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbYGOS6D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 14:58:03 -0400
Content-Disposition: inline
In-Reply-To: <487B7B9B.3020001@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 14, 2008 at 12:15:23PM -0400, Ric Wheeler wrote:
>
> Here is a pointer to the older patch & some results:
>
> http://www.spinics.net/lists/linux-fsdevel/msg13121.html
>
> I will retry this on some updated kernels, but would not expect to see a 
> difference since the code has not been changed ;-)
>

Ok here are the numbers with the original idea I had proposed.

type	threads		base	patch	speedup
sata	1		17.9	17.3	0.97
sata	2		33.2	34.2	1.03
sata	4		58.4	63.6	1.09
sata	8		78.8	80.8	1.03
sata	16		94.4	97.6	1.16

ram	1		2394.4	1878.0	0.78
ram	2		989.6	2041.1	2.06
ram	4		1466.1	3201.8	2.18
ram	8		1858.1	3362.8	1.81
ram	16		3008.0	3227.7	1.07

I've got to find a fast disk array to test this with, but the ramdisk results
make me happy, though they were kind of irratic, so I think the fast disk array
will be a more stable measure of how well this patch does, but it definitely
doesn't hurt the slow case, and brings stability to the fast case.  Thanks much,

Josef


Index: linux-2.6/fs/jbd/commit.c
===================================================================
--- linux-2.6.orig/fs/jbd/commit.c
+++ linux-2.6/fs/jbd/commit.c
@@ -273,6 +273,15 @@ write_out_data:
 	journal_do_submit_data(wbuf, bufs);
 }
 
+static inline unsigned long elapsed_jiffies(unsigned long start,
+					    unsigned long end)
+{
+	if (end >= start)
+		return end - start;
+
+	return end + (MAX_JIFFY_OFFSET - start) + 1;
+}
+
 /*
  * journal_commit_transaction
  *
@@ -288,6 +297,7 @@ void journal_commit_transaction(journal_
 	int flags;
 	int err;
 	unsigned long blocknr;
+	unsigned long long commit_time, start_time;
 	char *tagp = NULL;
 	journal_header_t *header;
 	journal_block_tag_t *tag = NULL;
@@ -400,6 +410,7 @@ void journal_commit_transaction(journal_
 	commit_transaction->t_state = T_FLUSH;
 	journal->j_committing_transaction = commit_transaction;
 	journal->j_running_transaction = NULL;
+	start_time = jiffies;
 	commit_transaction->t_log_start = journal->j_head;
 	wake_up(&journal->j_wait_transaction_locked);
 	spin_unlock(&journal->j_state_lock);
@@ -873,6 +884,12 @@ restart_loop:
 	J_ASSERT(commit_transaction == journal->j_committing_transaction);
 	journal->j_commit_sequence = commit_transaction->t_tid;
 	journal->j_committing_transaction = NULL;
+	commit_time = elapsed_jiffies(start_time, jiffies);
+	if (unlikely(!journal->j_average_commit_time))
+		journal->j_average_commit_time = commit_time;
+	else
+		journal->j_average_commit_time = (commit_time +
+					journal->j_average_commit_time) / 2;
 	spin_unlock(&journal->j_state_lock);
 
 	if (commit_transaction->t_checkpoint_list == NULL &&
Index: linux-2.6/fs/jbd/transaction.c
===================================================================
--- linux-2.6.orig/fs/jbd/transaction.c
+++ linux-2.6/fs/jbd/transaction.c
@@ -49,6 +49,7 @@ get_transaction(journal_t *journal, tran
 {
 	transaction->t_journal = journal;
 	transaction->t_state = T_RUNNING;
+	transaction->t_start_time = jiffies;
 	transaction->t_tid = journal->j_transaction_sequence++;
 	transaction->t_expires = jiffies + journal->j_commit_interval;
 	spin_lock_init(&transaction->t_handle_lock);
@@ -1361,8 +1362,7 @@ int journal_stop(handle_t *handle)
 {
 	transaction_t *transaction = handle->h_transaction;
 	journal_t *journal = transaction->t_journal;
-	int old_handle_count, err;
-	pid_t pid;
+	int err;
 
 	J_ASSERT(journal_current_handle() == handle);
 
@@ -1395,13 +1395,17 @@ int journal_stop(handle_t *handle)
 	 * single process is doing a stream of sync writes.  No point in waiting
 	 * for joiners in that case.
 	 */
-	pid = current->pid;
-	if (handle->h_sync && journal->j_last_sync_writer != pid) {
-		journal->j_last_sync_writer = pid;
-		do {
-			old_handle_count = transaction->t_handle_count;
+	if (handle->h_sync) {
+		unsigned long commit_time;
+
+		spin_lock(&journal->j_state_lock);
+		commit_time = journal->j_average_commit_time;
+		spin_unlock(&journal->j_state_lock);
+
+		while (time_before(jiffies, commit_time +
+				   transaction->t_start_time)) {
 			schedule_timeout_uninterruptible(1);
-		} while (old_handle_count != transaction->t_handle_count);
+		}
 	}
 
 	current->journal_info = NULL;
Index: linux-2.6/include/linux/jbd.h
===================================================================
--- linux-2.6.orig/include/linux/jbd.h
+++ linux-2.6/include/linux/jbd.h
@@ -543,6 +543,11 @@ struct transaction_s
 	unsigned long		t_expires;
 
 	/*
+	 * When this transaction started, in jiffies [no locking]
+	 */
+	unsigned long		t_start_time;
+
+	/*
 	 * How many handles used this transaction? [t_handle_lock]
 	 */
 	int t_handle_count;
@@ -800,6 +805,8 @@ struct journal_s
 
 	pid_t			j_last_sync_writer;
 
+	unsigned long long	j_average_commit_time;
+
 	/*
 	 * An opaque pointer to fs-private information.  ext3 puts its
 	 * superblock pointer here
