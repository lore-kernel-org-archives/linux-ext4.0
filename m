From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] jbd2: use mutex_lock_io() for journal->j_checkpoint_mutex
Date: Fri, 28 Oct 2016 12:58:12 -0400
Message-ID: <1477673892-28940-5-git-send-email-tj@kernel.org>
References: <1477673892-28940-1-git-send-email-tj@kernel.org>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com, mingbo@fb.com,
        Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, axboe@kernel.dk,
        tytso@mit.edu, jack@suse.com, adilger.kernel@dilger.ca
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1477673892-28940-1-git-send-email-tj@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When an ext4 fs is bogged down by a lot of metadata IOs (in the
reported case, it was deletion of millions of files, but any massive
amount of journal writes would do), after the journal is filled up,
tasks which try to access the filesystem and aren't currently
performing the journal writes end up waiting in
__jbd2_log_wait_for_space() for journal->j_checkpoint_mutex.

Because those mutex sleeps aren't marked as iowait, this condition can
lead to misleadingly low iowait and /proc/stat:procs_blocked.  While
iowait propagation is far from strict, this condition can be triggered
fairly easily and annotating these sleeps correctly helps initial
diagnosis quite a bit.

Use the new mutex_lock_io() for journal->j_checkpoint_mutex so that
these sleeps are properly marked as iowait.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Mingbo Wan <mingbo@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
---
 fs/jbd2/commit.c  |  2 +-
 fs/jbd2/journal.c | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 31f8ca0..e772881 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -392,7 +392,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	/* Do we need to erase the effects of a prior jbd2_journal_flush? */
 	if (journal->j_flags & JBD2_FLUSHED) {
 		jbd_debug(3, "super block updated\n");
-		mutex_lock(&journal->j_checkpoint_mutex);
+		mutex_lock_io(&journal->j_checkpoint_mutex);
 		/*
 		 * We hold j_checkpoint_mutex so tail cannot change under us.
 		 * We don't need any special data guarantees for writing sb
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 927da49..0aa7d06 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -944,7 +944,7 @@ int __jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block)
  */
 void jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block)
 {
-	mutex_lock(&journal->j_checkpoint_mutex);
+	mutex_lock_io(&journal->j_checkpoint_mutex);
 	if (tid_gt(tid, journal->j_tail_sequence))
 		__jbd2_update_log_tail(journal, tid, block);
 	mutex_unlock(&journal->j_checkpoint_mutex);
@@ -1304,7 +1304,7 @@ static int journal_reset(journal_t *journal)
 		journal->j_flags |= JBD2_FLUSHED;
 	} else {
 		/* Lock here to make assertions happy... */
-		mutex_lock(&journal->j_checkpoint_mutex);
+		mutex_lock_io(&journal->j_checkpoint_mutex);
 		/*
 		 * Update log tail information. We use WRITE_FUA since new
 		 * transaction will start reusing journal space and so we
@@ -1691,7 +1691,7 @@ int jbd2_journal_destroy(journal_t *journal)
 	spin_lock(&journal->j_list_lock);
 	while (journal->j_checkpoint_transactions != NULL) {
 		spin_unlock(&journal->j_list_lock);
-		mutex_lock(&journal->j_checkpoint_mutex);
+		mutex_lock_io(&journal->j_checkpoint_mutex);
 		err = jbd2_log_do_checkpoint(journal);
 		mutex_unlock(&journal->j_checkpoint_mutex);
 		/*
@@ -1713,7 +1713,7 @@ int jbd2_journal_destroy(journal_t *journal)
 
 	if (journal->j_sb_buffer) {
 		if (!is_journal_aborted(journal)) {
-			mutex_lock(&journal->j_checkpoint_mutex);
+			mutex_lock_io(&journal->j_checkpoint_mutex);
 
 			write_lock(&journal->j_state_lock);
 			journal->j_tail_sequence =
@@ -1954,7 +1954,7 @@ int jbd2_journal_flush(journal_t *journal)
 	spin_lock(&journal->j_list_lock);
 	while (!err && journal->j_checkpoint_transactions != NULL) {
 		spin_unlock(&journal->j_list_lock);
-		mutex_lock(&journal->j_checkpoint_mutex);
+		mutex_lock_io(&journal->j_checkpoint_mutex);
 		err = jbd2_log_do_checkpoint(journal);
 		mutex_unlock(&journal->j_checkpoint_mutex);
 		spin_lock(&journal->j_list_lock);
@@ -1964,7 +1964,7 @@ int jbd2_journal_flush(journal_t *journal)
 	if (is_journal_aborted(journal))
 		return -EIO;
 
-	mutex_lock(&journal->j_checkpoint_mutex);
+	mutex_lock_io(&journal->j_checkpoint_mutex);
 	if (!err) {
 		err = jbd2_cleanup_journal_tail(journal);
 		if (err < 0) {
@@ -2024,7 +2024,7 @@ int jbd2_journal_wipe(journal_t *journal, int write)
 	err = jbd2_journal_skip_recovery(journal);
 	if (write) {
 		/* Lock to make assertions happy... */
-		mutex_lock(&journal->j_checkpoint_mutex);
+		mutex_lock_io(&journal->j_checkpoint_mutex);
 		jbd2_mark_journal_empty(journal, WRITE_FUA);
 		mutex_unlock(&journal->j_checkpoint_mutex);
 	}
-- 
2.7.4

