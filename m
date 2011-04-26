From: Ted Ts'o <tytso@mit.edu>
Subject: Re: 2.6.32 ext3 assertion j_running_transaction != NULL fails in
 commit.c
Date: Tue, 26 Apr 2011 13:20:57 -0400
Message-ID: <20110426172057.GH9486@thunk.org>
References: <BCB84D936723884B91E4CC5CA0A7C54AA4F6D082BE@EMEADALEXMB1.corp.nai.org>
 <20110425231454.GB9486@thunk.org>
 <BCB84D936723884B91E4CC5CA0A7C54AA4F6D08501@EMEADALEXMB1.corp.nai.org>
 <20110426122338.GE9486@thunk.org>
 <BCB84D936723884B91E4CC5CA0A7C54AA4F6D085B8@EMEADALEXMB1.corp.nai.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Martin_Zielinski@mcafee.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38240 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab1DZRVB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Apr 2011 13:21:01 -0400
Content-Disposition: inline
In-Reply-To: <BCB84D936723884B91E4CC5CA0A7C54AA4F6D085B8@EMEADALEXMB1.corp.nai.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 26, 2011 at 07:45:33AM -0500, Martin_Zielinski@mcafee.com wrote:

> I will port the jbd2 debugging code to jbd an will try to get the
> new kernel into production.  After a reboot we will have to wait
> several weeks. (Strange: all machines failed within 72 hours).

Great, thanks.

> With sqlite I can currently produce ~10.000.000 commits in one hour
> with a program that does nothing else.  I doubt that it is possible
> to have an overflow in such a short time that we are observing.
> Maybe the __log_start_commit commit call comes with a corrupt target
> id from elsewhere. But your patch will catch that, too.

Agreed; that's why I don't really believe the wraparound theory.  For
your convenience, this is the revised (cleaned up) patch for the
ext3/jbd (it just cleans up how we print the warning).

						- Ted

commit 4ea00445c7f5d3dfa6219262598a2a8319df07c7
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Apr 26 13:14:55 2011 -0400

    jbd: fix fsync() tid wraparound bug
    
    If an application program does not make any changes to the indirect
    blocks or extent tree, i_datasync_tid will not get updated.  If there
    are enough commits (i.e., 2**31) such that tid_geq()'s calculations
    wrap, and there isn't a currently active transaction at the time of
    the fdatasync() call, this can end up triggering a BUG_ON in
    fs/jbd/commit.c:
    
    	J_ASSERT(journal->j_running_transaction != NULL);
    
    It's pretty rare that this can happen, since it requires the use of
    fdatasync() plus *very* frequent and excessive use of fsync().  But
    with the right workload, it can.
    
    We fix this by replacing the use of tid_geq() with an equality test,
    since there's only one valid transaction id that we is valid for us to
    wait until it is commited: namely, the currently running transaction
    (if it exists).
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index b3713af..1b71ce6 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -437,9 +437,12 @@ int __log_space_left(journal_t *journal)
 int __log_start_commit(journal_t *journal, tid_t target)
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
@@ -451,7 +454,14 @@ int __log_start_commit(journal_t *journal, tid_t target)
 			  journal->j_commit_sequence);
 		wake_up(&journal->j_wait_commit);
 		return 1;
-	}
+	} else if (!tid_geq(journal->j_commit_request, target))
+		/* This should never happen, but if it does, preserve
+		   the evidence before kjournald goes into a loop and
+		   increments j_commit_sequence beyond all recognition. */
+		WARN(1, "jbd: bad log_start_commit: %u %u %u %u\n",
+		     journal->j_commit_request, journal->j_commit_sequence,
+		     target, journal->j_running_transaction ? 
+		     journal->j_running_transaction->t_tid : 0);
 	return 0;
 }
 
