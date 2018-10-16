Return-Path: <SRS0=eFe4=M4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48842 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726636AbeJPRc2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 16 Oct 2018 13:32:28 -0400
From: Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd2: Avoid long hold times of j_state_lock while committing a transaction
Date: Tue, 16 Oct 2018 11:42:48 +0200
Message-Id: <20181016094248.21359-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We can hold j_state_lock for writing at the beginning of
jbd2_journal_commit_transaction() for a rather long time (reportedly for
30 ms) due cleaning revoke bits of all revoked buffers under it. The
handling of revoke tables as well as cleaning of t_reserved_list, and
checkpoint lists does not need j_state_lock for anything. Furthermore
the transaction is in T_LOCKED state and we waited for all outstanding
handles so nobody is going to be adding anything to the transaction.

Just drop the lock for unnecessary operations.

Reported-and-tested-by: Adrian Hunter <adrian.hunter@intel.com>
Suggested-by: "Theodore Y. Ts'o" <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/commit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 150cc030b4d7..356b75fa3101 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -422,6 +422,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 				       stats.run.rs_locked);
 	stats.run.rs_running = jbd2_time_diff(commit_transaction->t_start,
 					      stats.run.rs_locked);
+	write_unlock(&journal->j_state_lock);
 
 	spin_lock(&commit_transaction->t_handle_lock);
 	while (atomic_read(&commit_transaction->t_updates)) {
@@ -431,9 +432,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 					TASK_UNINTERRUPTIBLE);
 		if (atomic_read(&commit_transaction->t_updates)) {
 			spin_unlock(&commit_transaction->t_handle_lock);
-			write_unlock(&journal->j_state_lock);
 			schedule();
-			write_lock(&journal->j_state_lock);
 			spin_lock(&commit_transaction->t_handle_lock);
 		}
 		finish_wait(&journal->j_wait_updates, &wait);
@@ -505,6 +504,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	atomic_sub(atomic_read(&journal->j_reserved_credits),
 		   &commit_transaction->t_outstanding_credits);
 
+	write_lock(&journal->j_state_lock);
 	trace_jbd2_commit_flushing(journal, commit_transaction);
 	stats.run.rs_flushing = jiffies;
 	stats.run.rs_locked = jbd2_time_diff(stats.run.rs_locked,
-- 
2.16.4
