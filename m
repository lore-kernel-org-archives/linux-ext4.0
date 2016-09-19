From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd2: Fix lockdep annotation in add_transaction_credits()
Date: Mon, 19 Sep 2016 14:30:43 +0200
Message-ID: <1474288243-584-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40146 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753283AbcISMa4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 19 Sep 2016 08:30:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thomas has reported a lockdep splat hitting in
add_transaction_credits(). The problem is that that function calls
jbd2_might_wait_for_commit() while holding j_state_lock which is wrong
(we do not really wait for transaction commit while holding that lock).

Fix the problem by moving jbd2_might_wait_for_commit() into places where
we are ready to wait for transaction commit and thus j_state_lock is
unlocked.

Fixes: 1eaa566d368b214d99cbb973647c1b0b8102a9ae
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index b5bc3e249163..3d8246a9faa4 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -159,6 +159,7 @@ static void wait_transaction_locked(journal_t *journal)
 	read_unlock(&journal->j_state_lock);
 	if (need_to_start)
 		jbd2_log_start_commit(journal, tid);
+	jbd2_might_wait_for_commit(journal);
 	schedule();
 	finish_wait(&journal->j_wait_transaction_locked, &wait);
 }
@@ -182,8 +183,6 @@ static int add_transaction_credits(journal_t *journal, int blocks,
 	int needed;
 	int total = blocks + rsv_blocks;
 
-	jbd2_might_wait_for_commit(journal);
-
 	/*
 	 * If the current transaction is locked down for commit, wait
 	 * for the lock to be released.
@@ -214,6 +213,7 @@ static int add_transaction_credits(journal_t *journal, int blocks,
 		if (atomic_read(&journal->j_reserved_credits) + total >
 		    journal->j_max_transaction_buffers) {
 			read_unlock(&journal->j_state_lock);
+			jbd2_might_wait_for_commit(journal);
 			wait_event(journal->j_wait_reserved,
 				   atomic_read(&journal->j_reserved_credits) + total <=
 				   journal->j_max_transaction_buffers);
@@ -238,6 +238,7 @@ static int add_transaction_credits(journal_t *journal, int blocks,
 	if (jbd2_log_space_left(journal) < jbd2_space_needed(journal)) {
 		atomic_sub(total, &t->t_outstanding_credits);
 		read_unlock(&journal->j_state_lock);
+		jbd2_might_wait_for_commit(journal);
 		write_lock(&journal->j_state_lock);
 		if (jbd2_log_space_left(journal) < jbd2_space_needed(journal))
 			__jbd2_log_wait_for_space(journal);
@@ -255,6 +256,7 @@ static int add_transaction_credits(journal_t *journal, int blocks,
 		sub_reserved_credits(journal, rsv_blocks);
 		atomic_sub(total, &t->t_outstanding_credits);
 		read_unlock(&journal->j_state_lock);
+		jbd2_might_wait_for_commit(journal);
 		wait_event(journal->j_wait_reserved,
 			 atomic_read(&journal->j_reserved_credits) + rsv_blocks
 			 <= journal->j_max_transaction_buffers / 2);
-- 
2.6.6

