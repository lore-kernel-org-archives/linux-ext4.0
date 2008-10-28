From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] improve jbd fsync batching
Date: Tue, 28 Oct 2008 16:16:15 -0400
Message-ID: <20081028201614.GA21600@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com
To: linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

This is a rework of the patch I did a few months ago, taking into account some
comments from Andrew and using the new schedule_hrtimeout function (thanks
Arjan!).

There is a flaw with the way jbd handles fsync batching.  If we fsync() a file
and we were not the last person to run fsync() on this fs then we automatically
sleep for 1 jiffie in order to wait for new writers to join into the transaction
before forcing the commit.  The problem with this is that with really fast
storage (ie a Clariion) the time it takes to commit a transaction to disk is way
faster than 1 jiffie in most cases, so sleeping means waiting longer with
nothing to do than if we just committed the transaction and kept going.  Ric
Wheeler noticed this when using fs_mark with more than 1 thread, the throughput
would plummet as he added more threads.

This patch attempts to fix this problem by recording the average time in
nanoseconds that it takes to commit a transaction to disk, and what time we
started the transaction.  If we run an fsync() and we have been running for less
time than it takes to commit the transaction to disk, we sleep for the delta
amount of time and then commit to disk.  We acheive sub-jiffie sleeping using
schedule_hrtimeout.  This means that the wait time is auto-tuned to the speed of
the underlying disk, instead of having this static timeout.  I weighted the
average according to somebody's comments (Andreas Dilger I think) in order to
help normalize random outliers where we take way longer or way less time to
commit than the average.  I also have a min() check in there to make sure we
don't sleep longer than a jiffie in case our storage is super slow, this was
requested by Andrew.

I unfortunately do not have access to a Clariion, so I had to use a ramdisk to
represent a super fast array.  I tested with a SATA drive with barrier=1 to make
sure there was no regression with local disks, I tested with a 4 way multipathed
Apple Xserve RAID array and of course the ramdisk.  I ran the following command

fs_mark -d /mnt/ext3-test -s 4096 -n 2000 -D 64 -t $i

where $i was 2, 4, 8, 16 and 32.  I mkfs'ed the fs each time.  Here are my
results

type	threads		with patch	without patch
sata	2		24.6		26.3
sata	4		49.2		48.1
sata	8		70.1		67.0
sata	16		104.0		94.1
sata	32		153.6		142.7

xserve	2		246.4		222.0
xserve	4		480.0		440.8
xserve	8		829.5		730.8
xserve	16		1172.7		1026.9
xserve	32		1816.3		1650.5

ramdisk	2		2538.3		1745.6
ramdisk	4		2942.3		661.9
ramdisk	8		2882.5		999.8
ramdisk	16		2738.7		1801.9
ramdisk	32		2541.9		2394.0

All comments are welcome.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


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
index d15cd6e..59dd181 100644
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
@@ -1407,11 +1409,26 @@ int journal_stop(handle_t *handle)
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
index 346e2b8..d842230 100644
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
@@ -800,6 +805,8 @@ struct journal_s
 
 	pid_t			j_last_sync_writer;
 
+	u64			j_average_commit_time;
+
 	/*
 	 * An opaque pointer to fs-private information.  ext3 puts its
 	 * superblock pointer here
