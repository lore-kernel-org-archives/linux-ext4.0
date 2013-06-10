From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/4] jbd2/journal_commit_transaction: relocate state lock to incorporate all users
Date: Mon, 10 Jun 2013 15:32:00 -0400
Message-ID: <1370892723-30860-2-git-send-email-paul.gortmaker@windriver.com>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-rt-users@vger.kernel.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The state lock is taken after we are doing an assert on the state
value, not before.  It is also taken after the jbd_debug() call.
Noting that jbd_debug() is implemented with two separate printk()
calls, it can lead to corrupted and misleading debug output like
the following (see lines marked with "*"):

[  290.339362] (fs/jbd2/journal.c, 203): kjournald2: kjournald2 wakes
[  290.339365] (fs/jbd2/journal.c, 155): kjournald2: commit_sequence=42103, commit_request=42104
[  290.339369] (fs/jbd2/journal.c, 158): kjournald2: OK, requests differ
[* 290.339376] (fs/jbd2/journal.c, 648): jbd2_log_wait_commit:
[* 290.339379] (fs/jbd2/commit.c, 370): jbd2_journal_commit_transaction: JBD2: want 42104, j_commit_sequence=42103
[* 290.339382] JBD2: starting commit of transaction 42104
[  290.339410] (fs/jbd2/revoke.c, 566): jbd2_journal_write_revoke_records: Wrote 0 revoke records
[  290.376555] (fs/jbd2/commit.c, 1088): jbd2_journal_commit_transaction: JBD2: commit 42104 complete, head 42079

i.e. the debug output from log_wait_commit and journal_commit_transaction
have become interleaved.  The output should have been:

(fs/jbd2/journal.c, 648): jbd2_log_wait_commit: JBD2: want 42104, j_commit_sequence=42103
(fs/jbd2/commit.c, 370): jbd2_journal_commit_transaction: JBD2: starting commit of transaction 42104

It is expected that this is not easy to replicate -- I was only able
to cause it on preempt-rt kernels, and even then only under heavy
I/O load.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/jbd2/commit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 0f53946..7e8a5fd 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -423,6 +423,8 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	J_ASSERT(journal->j_running_transaction != NULL);
 	J_ASSERT(journal->j_committing_transaction == NULL);
 
+	write_lock(&journal->j_state_lock);
+
 	commit_transaction = journal->j_running_transaction;
 	J_ASSERT(commit_transaction->t_state == T_RUNNING);
 
@@ -430,7 +432,6 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	jbd_debug(1, "JBD2: starting commit of transaction %d\n",
 			commit_transaction->t_tid);
 
-	write_lock(&journal->j_state_lock);
 	commit_transaction->t_state = T_LOCKED;
 
 	trace_jbd2_commit_locking(journal, commit_transaction);
-- 
1.8.1.2

