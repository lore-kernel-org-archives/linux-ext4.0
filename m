From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] jbd: fix assertion failure in journal_next_log_block
Date: Thu, 31 Jan 2008 11:14:17 -0500
Message-ID: <20080131161417.GA29679@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbYAaQT2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2008 11:19:28 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

The way jbd tries to determine if there is enough space left on the journal in
order to start a new transaction is looking at the space left in the journal and
the space needed for the committing transaction, which is 1/4 of the journal +
the number of t_outstanding_credits for that transaction.  In this case its
assumed that t_outstanding_credits accurately represents the number of credits
waiting to be written to the journal, but this sometimes isn't the case.  The
transaction has two counters for buffers, t_outstanding_credits which is used in
conjunction with handles that are added to the transaction, and t_nr_buffers
which is only incremented/decremented when buffers are added/removed from the
transaction and are actually destined to be journaled.  Normally these two
counters are the same, however there are cases where the committing transaction
can have buffers moved to the next running transaction, for example any buffers
on the committing transactions t_reserved list would be moved to the next
(running) transaction, and if it had been dirtied in the process it would
immediately make it onto the t_updates list, which would increment t_nr_buffers
but not t_outstanding_credits.  So you get into this situation where
t_nr_buffers (the actual number of buffers that are on the transaction) is
greater than the number of buffers accounted for via t_outstanding_credits.
This presents a problem since as we loop through writting buffers to the
journal, we decrement t_outstanding_credits, and if t_nr_buffers is more than
t_outstanding_credits then we end up with a negative number for
t_outstanding_credits, which means we start saying we need less than 1/4 of the
journal for our committing transaction and allow more transactions than we can
handle to start, and then bam we fail because journal_next_log_block doesn't
have enough free blocks in order to handle the request.  This has been tested
and fixes the issue (which could not be reproduced by me but several other
people could get it to reproduce using postmark), and although I couldn't
reproduce the assertion, I could very easily reproduce the situation where
t_outstanding_credits was < than t_nr_buffers.


Signed-off-by: Josef Bacik <jbacik@redhat.com>


diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 31853eb..e385a5c 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -561,13 +561,6 @@ void journal_commit_transaction(journal_t *journal)
 			continue;
 		}
 
-		/*
-		 * start_this_handle() uses t_outstanding_credits to determine
-		 * the free space in the log, but this counter is changed
-		 * by journal_next_log_block() also.
-		 */
-		commit_transaction->t_outstanding_credits--;
-
 		/* Bump b_count to prevent truncate from stumbling over
                    the shadowed buffer!  @@@ This can go if we ever get
                    rid of the BJ_IO/BJ_Shadow pairing of buffers. */
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 4f302d2..c0f93f5 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -580,7 +580,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	stats.u.run.rs_logging = jiffies;
 	stats.u.run.rs_flushing = jbd2_time_diff(stats.u.run.rs_flushing,
 						 stats.u.run.rs_logging);
-	stats.u.run.rs_blocks = commit_transaction->t_outstanding_credits;
+	stats.u.run.rs_blocks = commit_transaction->t_nr_buffers;
 	stats.u.run.rs_blocks_logged = 0;
 
 	descriptor = NULL;
@@ -655,13 +655,6 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 			continue;
 		}
 
-		/*
-		 * start_this_handle() uses t_outstanding_credits to determine
-		 * the free space in the log, but this counter is changed
-		 * by jbd2_journal_next_log_block() also.
-		 */
-		commit_transaction->t_outstanding_credits--;
-
 		/* Bump b_count to prevent truncate from stumbling over
                    the shadowed buffer!  @@@ This can go if we ever get
                    rid of the BJ_IO/BJ_Shadow pairing of buffers. */
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index d9ecd13..076d1fc 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -1056,7 +1056,7 @@ static inline int jbd_space_needed(journal_t *journal)
 	int nblocks = journal->j_max_transaction_buffers;
 	if (journal->j_committing_transaction)
 		nblocks += journal->j_committing_transaction->
-					t_outstanding_credits;
+					t_nr_buffers;
 	return nblocks;
 }
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 2cbf6fd..60800a0 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1168,7 +1168,7 @@ static inline int jbd_space_needed(journal_t *journal)
 	int nblocks = journal->j_max_transaction_buffers;
 	if (journal->j_committing_transaction)
 		nblocks += journal->j_committing_transaction->
-					t_outstanding_credits;
+					t_nr_buffers;
 	return nblocks;
 }
 
