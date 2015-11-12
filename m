From: Alexandru Moise <00moses.alexander00@gmail.com>
Subject: [PATCH] jbd2: redefine jbd2_get_transaction to jbd2_init_transaction
Date: Thu, 12 Nov 2015 22:25:06 +0200
Message-ID: <20151112202506.GA25827@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch follows the same logic of a 2012 patch to jbd
(prior to ext3 removal). Yuanhan Liu renamed the jbd
get_transaction() function to init_transaction(), as the function
was as an initialization function, as it is mostly in our case.

Also remove the return value as it is unused.

Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
---
 fs/jbd2/transaction.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 89463ee..3fd597b 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -65,7 +65,7 @@ void jbd2_journal_free_transaction(transaction_t *transaction)
 }
 
 /*
- * jbd2_get_transaction: obtain a new transaction_t object.
+ * jbd2_init_transaction: obtain a new transaction_t object.
  *
  * Simply allocate and initialise a new transaction.  Create it in
  * RUNNING state and add it to the current journal (which should not
@@ -79,8 +79,8 @@ void jbd2_journal_free_transaction(transaction_t *transaction)
  *
  */
 
-static transaction_t *
-jbd2_get_transaction(journal_t *journal, transaction_t *transaction)
+static void
+jbd2_init_transaction(journal_t *journal, transaction_t *transaction)
 {
 	transaction->t_journal = journal;
 	transaction->t_state = T_RUNNING;
@@ -104,8 +104,6 @@ jbd2_get_transaction(journal_t *journal, transaction_t *transaction)
 	transaction->t_max_wait = 0;
 	transaction->t_start = jiffies;
 	transaction->t_requested = 0;
-
-	return transaction;
 }
 
 /*
@@ -343,7 +341,7 @@ repeat:
 		write_lock(&journal->j_state_lock);
 		if (!journal->j_running_transaction &&
 		    (handle->h_reserved || !journal->j_barrier_count)) {
-			jbd2_get_transaction(journal, new_transaction);
+			jbd2_init_transaction(journal, new_transaction);
 			new_transaction = NULL;
 		}
 		write_unlock(&journal->j_state_lock);
-- 
2.6.2
