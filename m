From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] improve jbd fsync batching
Date: Tue, 4 Nov 2008 10:41:24 -0500
Message-ID: <20081104154123.GB28058@unused.rdu.redhat.com>
References: <20081028201614.GA21600@unused.rdu.redhat.com> <20081103122729.60582692.akpm@linux-foundation.org> <20081103202442.GA25736@unused.rdu.redhat.com> <20081103125509.41e55529.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42667 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975AbYKDPx2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Nov 2008 10:53:28 -0500
Content-Disposition: inline
In-Reply-To: <20081103125509.41e55529.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 03, 2008 at 12:55:09PM -0800, Andrew Morton wrote:
> On Mon, 3 Nov 2008 15:24:43 -0500
> Josef Bacik <jbacik@redhat.com> wrote:
> 
> > > please fix.
> > 
> > I see you already pulled this into -mm, would you like me to repost with the
> > same changelog and the patch updated, or just reply to this with the updated
> > patch?  Thanks,
> 
> Either works for me at this stage.  If it's a replacement then I'll turn
> it into an incremental so I can see what changed, which takes me about 2.15
> seconds.
> 
> If it had been a large patch or if it had been under test in someone's
> tree for a while then a replacement patch would be unwelcome.  But for a
> small, fresh patch like this one it's no big deal either way.
>

Ok here is a replacement patch with the comments as requested, as well as a
comment for j_last_sync_writer.  Thank you,

Josef

 
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 25719d9..3fbffb1 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -306,6 +306,8 @@ void journal_commit_transaction(journal_t *journal)
 	int flags;
 	int err;
 	unsigned long blocknr;
+	ktime_t start_time;
+	u64 commit_time;
 	char *tagp = NULL;
 	journal_header_t *header;
 	journal_block_tag_t *tag = NULL;
@@ -418,6 +420,7 @@ void journal_commit_transaction(journal_t *journal)
 	commit_transaction->t_state = T_FLUSH;
 	journal->j_committing_transaction = commit_transaction;
 	journal->j_running_transaction = NULL;
+	start_time = ktime_get();
 	commit_transaction->t_log_start = journal->j_head;
 	wake_up(&journal->j_wait_transaction_locked);
 	spin_unlock(&journal->j_state_lock);
@@ -913,6 +916,18 @@ restart_loop:
 	J_ASSERT(commit_transaction == journal->j_committing_transaction);
 	journal->j_commit_sequence = commit_transaction->t_tid;
 	journal->j_committing_transaction = NULL;
+	commit_time = ktime_to_ns(ktime_sub(ktime_get(), start_time));
+
+	/*
+	 * weight the commit time higher than the average time so we don't
+	 * react too strongly to vast changes in commit time
+	 */
+	if (likely(journal->j_average_commit_time))
+		journal->j_average_commit_time = (commit_time*3 +
+				journal->j_average_commit_time) / 4;
+	else
+		journal->j_average_commit_time = commit_time;
+
 	spin_unlock(&journal->j_state_lock);
 
 	if (commit_transaction->t_checkpoint_list == NULL &&
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index d15cd6e..90c2cd4 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -25,6 +25,7 @@
 #include <linux/timer.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/hrtimer.h>
 
 static void __journal_temp_unlink_buffer(struct journal_head *jh);
 
@@ -49,6 +50,7 @@ get_transaction(journal_t *journal, transaction_t *transaction)
 {
 	transaction->t_journal = journal;
 	transaction->t_state = T_RUNNING;
+	transaction->t_start_time = ktime_get();
 	transaction->t_tid = journal->j_transaction_sequence++;
 	transaction->t_expires = jiffies + journal->j_commit_interval;
 	spin_lock_init(&transaction->t_handle_lock);
@@ -1371,7 +1373,7 @@ int journal_stop(handle_t *handle)
 {
 	transaction_t *transaction = handle->h_transaction;
 	journal_t *journal = transaction->t_journal;
-	int old_handle_count, err;
+	int err;
 	pid_t pid;
 
 	J_ASSERT(journal_current_handle() == handle);
@@ -1400,6 +1402,17 @@ int journal_stop(handle_t *handle)
 	 * on IO anyway.  Speeds up many-threaded, many-dir operations
 	 * by 30x or more...
 	 *
+	 * We try and optimize the sleep time against what the underlying disk
+	 * can do, instead of having a static sleep time.  This is usefull for
+	 * the case where our storage is so fast that it is more optimal to go
+	 * ahead and force a flush and wait for the transaction to be committed
+	 * than it is to wait for an arbitrary amount of time for new writers to
+	 * join the transaction.  We acheive this by measuring how long it takes
+	 * to commit a transaction, and compare it with how long this
+	 * transaction has been running, and if run time < commit time then we
+	 * sleep for the delta and commit.  This greatly helps super fast disks
+	 * that would see slowdowns as more threads started doing fsyncs.
+	 *
 	 * But don't do this if this process was the most recent one to
 	 * perform a synchronous write.  We do this to detect the case where a
 	 * single process is doing a stream of sync writes.  No point in waiting
@@ -1407,11 +1420,26 @@ int journal_stop(handle_t *handle)
 	 */
 	pid = current->pid;
 	if (handle->h_sync && journal->j_last_sync_writer != pid) {
+		u64 commit_time, trans_time;
+
 		journal->j_last_sync_writer = pid;
-		do {
-			old_handle_count = transaction->t_handle_count;
-			schedule_timeout_uninterruptible(1);
-		} while (old_handle_count != transaction->t_handle_count);
+
+		spin_lock(&journal->j_state_lock);
+		commit_time = journal->j_average_commit_time;
+		spin_unlock(&journal->j_state_lock);
+
+		trans_time = ktime_to_ns(ktime_sub(ktime_get(),
+						   transaction->t_start_time));
+
+		commit_time = min_t(u64, commit_time,
+				    1000*jiffies_to_usecs(1));
+
+		if (trans_time < commit_time) {
+			ktime_t expires = ktime_add_ns(ktime_get(),
+						       commit_time);
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_hrtimeout(&expires, HRTIMER_MODE_ABS);
+		}
 	}
 
 	current->journal_info = NULL;
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 346e2b8..6384b19 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -543,6 +543,11 @@ struct transaction_s
 	unsigned long		t_expires;
 
 	/*
+	 * When this transaction started, in nanoseconds [no locking]
+	 */
+	ktime_t			t_start_time;
+
+	/*
 	 * How many handles used this transaction? [t_handle_lock]
 	 */
 	int t_handle_count;
@@ -798,9 +803,19 @@ struct journal_s
 	struct buffer_head	**j_wbuf;
 	int			j_wbufsize;
 
+	/*
+	 * this is the pid of the last person to run a synchronous operation
+	 * through the journal.
+	 */
 	pid_t			j_last_sync_writer;
 
 	/*
+	 * the average amount of time in nanoseconds it takes to commit a
+	 * transaction to the disk.  [j_state_lock]
+	 */
+	u64			j_average_commit_time;
+
+	/*
 	 * An opaque pointer to fs-private information.  ext3 puts its
 	 * superblock pointer here
 	 */
