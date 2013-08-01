From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 2/4] jbd: relocate assert after state lock in journal_commit_transaction()
Date: Thu, 1 Aug 2013 15:01:06 -0400
Message-ID: <1375383668-8072-3-git-send-email-paul.gortmaker@windriver.com>
References: <1375383668-8072-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andrew Morton <akpm@linux-foundation.org>,
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1375383668-8072-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Backport of jbd2 commit 3ca841c106fd6cd2c942985977a5d126434a8dd6
("jbd2: relocate assert after state lock in journal_commit_transaction()")

Quoting that commit:
 ---------------
 The state lock is taken after we are doing an assert on the state
 value, not before.  So we might in fact be doing an assert on a
 transient value.  Ensure the state check is within the scope of
 the state lock being taken.
 ---------------

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/jbd/commit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 11bb11f..bb217dc 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -340,13 +340,13 @@ void journal_commit_transaction(journal_t *journal)
 	J_ASSERT(journal->j_committing_transaction == NULL);
 
 	commit_transaction = journal->j_running_transaction;
-	J_ASSERT(commit_transaction->t_state == T_RUNNING);
 
 	trace_jbd_start_commit(journal, commit_transaction);
 	jbd_debug(1, "JBD: starting commit of transaction %d\n",
 			commit_transaction->t_tid);
 
 	spin_lock(&journal->j_state_lock);
+	J_ASSERT(commit_transaction->t_state == T_RUNNING);
 	commit_transaction->t_state = T_LOCKED;
 
 	trace_jbd_commit_locking(journal, commit_transaction);
-- 
1.8.1.2
