From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/6] jbd2/journal_commit_transaction: relocate assert after state lock
Date: Tue, 11 Jun 2013 18:44:25 -0400
Message-ID: <1370990670-49249-2-git-send-email-paul.gortmaker@windriver.com>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
 <1370990670-49249-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>, <linux-rt-users@vger.kernel.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <1370990670-49249-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The state lock is taken after we are doing an assert on the state
value, not before.  So we might in fact be doing an assert on a
transient value.  Ensure the state check is within the scope of
the state lock being taken.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/jbd2/commit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 0f53946..3263e4a 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -424,13 +424,13 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	J_ASSERT(journal->j_committing_transaction == NULL);
 
 	commit_transaction = journal->j_running_transaction;
-	J_ASSERT(commit_transaction->t_state == T_RUNNING);
 
 	trace_jbd2_start_commit(journal, commit_transaction);
 	jbd_debug(1, "JBD2: starting commit of transaction %d\n",
 			commit_transaction->t_tid);
 
 	write_lock(&journal->j_state_lock);
+	J_ASSERT(commit_transaction->t_state == T_RUNNING);
 	commit_transaction->t_state = T_LOCKED;
 
 	trace_jbd2_commit_locking(journal, commit_transaction);
-- 
1.8.1.2

