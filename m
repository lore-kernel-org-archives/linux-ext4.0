From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH 2/2] improve ext3 fsync batching
Date: Wed, 6 Aug 2008 15:15:36 -0400
Message-ID: <20080806191536.GI27394@unused.rdu.redhat.com>
References: <20080806190819.GH27394@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, rwheeler@redhat.com,
	tglx@linutronix.de, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbYHFTR1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Aug 2008 15:17:27 -0400
Content-Disposition: inline
In-Reply-To: <20080806190819.GH27394@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Fsync batching in ext3 is somewhat flawed when it comes to disks that are very
fast.  Now we do an unconditional sleep for 1 second, which is great on slow
disks like SATA and such, but on fast disks this means just sitting around and
waiting for nothing.  This patch measures the time it takes to commit a
transaction to the disk, and sleeps based on the speed of the underlying disk.
Using the following fs_mark command to test the speeds

./fs_mark -d /mnt/ext3-test -s 4096 -n 2000 -D 64 -t 2

I got the following results (with write cacheing turned off)

type	threads		with patch	without patch
sata	2		26.4		27.8
sata	4		44.6		44.4
sata	8		70.4		72.8
sata	16		75.2		89.6
sata	32		92.7		96.0
ram	1		2399.1		2398.8
ram	2		257.3		3603.0
ram	4		395.6		4827.9
ram	8		659.0		4721.1
ram	16		1326.4		4373.3
ram	32		1964.2		3816.3

I used a ramdisk to emulate a "fast" disk since I don't happen to have a
clariion sitting around.  I didn't test single thread in the sata case as it
should be relatively the same between the two.  Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>

Index: linux-2.6/fs/jbd/commit.c
===================================================================
--- linux-2.6.orig/fs/jbd/commit.c
+++ linux-2.6/fs/jbd/commit.c
@@ -288,6 +288,8 @@ void journal_commit_transaction(journal_
 	int flags;
 	int err;
 	unsigned long blocknr;
+	ktime_t start_time;
+	u64 commit_time;
 	char *tagp = NULL;
 	journal_header_t *header;
 	journal_block_tag_t *tag = NULL;
@@ -400,6 +402,7 @@ void journal_commit_transaction(journal_
 	commit_transaction->t_state = T_FLUSH;
 	journal->j_committing_transaction = commit_transaction;
 	journal->j_running_transaction = NULL;
+	start_time = ktime_get();
 	commit_transaction->t_log_start = journal->j_head;
 	wake_up(&journal->j_wait_transaction_locked);
 	spin_unlock(&journal->j_state_lock);
@@ -873,6 +876,18 @@ restart_loop:
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
Index: linux-2.6/fs/jbd/transaction.c
===================================================================
--- linux-2.6.orig/fs/jbd/transaction.c
+++ linux-2.6/fs/jbd/transaction.c
@@ -25,6 +25,7 @@
 #include <linux/timer.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/hrtimer.h>
 
 static void __journal_temp_unlink_buffer(struct journal_head *jh);
 
@@ -49,6 +50,7 @@ get_transaction(journal_t *journal, tran
 {
 	transaction->t_journal = journal;
 	transaction->t_state = T_RUNNING;
+	transaction->t_start_time = ktime_get();
 	transaction->t_tid = journal->j_transaction_sequence++;
 	transaction->t_expires = jiffies + journal->j_commit_interval;
 	spin_lock_init(&transaction->t_handle_lock);
@@ -1361,7 +1363,7 @@ int journal_stop(handle_t *handle)
 {
 	transaction_t *transaction = handle->h_transaction;
 	journal_t *journal = transaction->t_journal;
-	int old_handle_count, err;
+	int err;
 	pid_t pid;
 
 	J_ASSERT(journal_current_handle() == handle);
@@ -1397,11 +1399,18 @@ int journal_stop(handle_t *handle)
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
+		if (trans_time < commit_time)
+			hrtimer_sleep_ns(commit_time, 1);
 	}
 
 	current->journal_info = NULL;
Index: linux-2.6/include/linux/jbd.h
===================================================================
--- linux-2.6.orig/include/linux/jbd.h
+++ linux-2.6/include/linux/jbd.h
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
@@ -800,6 +805,8 @@ struct journal_s
 
 	pid_t			j_last_sync_writer;
 
+	u64			j_average_commit_time;
+
 	/*
 	 * An opaque pointer to fs-private information.  ext3 puts its
 	 * superblock pointer here
