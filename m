From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] jbd2: fix fsync() tid wraparound bug
Date: Mon, 25 Apr 2011 20:23:30 -0400
Message-ID: <1303777411-1316-1-git-send-email-tytso@mit.edu>
References: <20110425231454.GB9486@thunk.org>
Cc: Martin_Zielinski@McAfee.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58665 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab1DZAXe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Apr 2011 20:23:34 -0400
In-Reply-To: <20110425231454.GB9486@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If an application program does not make any changes to the indirect
blocks or extent tree, i_datasync_tid will not get updated.  If there
are enough commits (i.e., 2**31) such that tid_geq()'s calculations
wrap, and there isn't a currently active transaction at the time of
the fdatasync() call, this can end up triggering a BUG_ON in
fs/jbd2/commit.c:

	J_ASSERT(journal->j_running_transaction != NULL);

It's pretty rare that this can happen, since it requires the use of
fdatasync() plus *very* frequent and excessive use of fsync().  But
with the right workload, it can.

We fix this by replacing the use of tid_geq() with an equality test
---
 fs/jbd2/journal.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index e0ec3db..a5daa5a 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -479,9 +479,12 @@ int __jbd2_log_space_left(journal_t *journal)
 int __jbd2_log_start_commit(journal_t *journal, tid_t target)
 {
 	/*
-	 * Are we already doing a recent enough commit?
+	 * The only transaction we can possibly wait upon is the
+	 * currently running transaction (if it exists).  Otherwise,
+	 * the target tid must be an old one.
 	 */
-	if (!tid_geq(journal->j_commit_request, target)) {
+	if (journal->j_running_transaction &&
+	    journal->j_running_transaction->t_tid == target) {
 		/*
 		 * We want a new commit: OK, mark the request and wakeup the
 		 * commit thread.  We do _not_ do the commit ourselves.
@@ -493,6 +496,17 @@ int __jbd2_log_start_commit(journal_t *journal, tid_t target)
 			  journal->j_commit_sequence);
 		wake_up(&journal->j_wait_commit);
 		return 1;
+	} else if (!tid_geq(journal->j_commit_request, target)) {
+		/* This should never happen, but if it does, preserve
+		   the evidence before kjournald goes into a loop and
+		   increments j_commit_sequence beyond all recognition. */
+		pr_err("jbd2: bad log_start_commit: %u %u %u\n",
+		       journal->j_commit_request, journal->j_commit_sequence,
+		       target);
+		if (journal->j_running_transaction)
+			pr_err("jbd2: current txn: %u\n",
+			       journal->j_running_transaction->t_tid);
+		WARN_ON(1);
 	}
 	return 0;
 }
-- 
1.7.3.1

