Return-Path: <SRS0=dqau=MX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35962 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728157AbeJKSjL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Oct 2018 14:39:11 -0400
Date: Thu, 11 Oct 2018 13:12:23 +0200
From: Jan Kara <jack@suse.cz>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: jbd2_clear_buffer_revoked_flags() takes a long time
Message-ID: <20181011111223.GD9467@quack2.suse.cz>
References: <d2e1ec1a-0d7d-1acb-6887-c55ac30e4a3a@intel.com>
 <20181010174934.GA19601@thunk.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <20181010174934.GA19601@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 10-10-18 13:49:34, Theodore Y. Ts'o wrote:
> On Wed, Oct 10, 2018 at 04:43:27PM +0300, Adrian Hunter wrote:
> > Hi
> > 
> > I have a case on a v4.14 kernel where the EXT4 journal commit disables
> > preemption for 30ms due to jbd2_clear_buffer_revoked_flags().  That in turn
> > disables preemption on other CPUs as they come to spin waiting for the same
> > lock.  The side-effect of that is that it periodically blocks high priority
> > tasks from running.
> > 
> > I see jbd2_clear_buffer_revoked_flags() iterating 32768 times calling
> > __find_get_block().
> > 
> > Is there any way to make jbd2_clear_buffer_revoked_flags() take less time,
> > or move its work out from under write_lock(&journal->j_state_lock)?
> 
> Hmm.... I'd have to look a bit more carefully and then run some tests,
> but I *think* we can drop the j_state_lock at the beginning of JBD2
> commit phase 1, and then grab it again right before we set
> commit_transaction->t_state to T_FLUSH.
> 
> That should be safe because while the transaction state is T_LOCKED,
> we can't start any new handles, so there can't be any new blocks added
> to the revoke table.
> 
> Can you give that a try and see whether that solves your priority
> inversion problem?

Agreed. Something like attached patch (compile-tested only)?

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--zhXaljGHf11kAtnf
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-jbd2-Avoid-long-hold-times-of-j_state_lock-while-com.patch"

>From 3627b5f30996504019cd84f326402fccbb9a298b Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 11 Oct 2018 13:04:44 +0200
Subject: [PATCH] jbd2: Avoid long hold times of j_state_lock while committing
 a transaction

We can hold j_state_lock for writing at the beginning of
jbd2_journal_commit_transaction() for a rather long time (reportedly for
30 ms) due cleaning revoke bits of all revoked buffers under it. The
handling of revoke tables as well as cleaning of t_reserved_list, and
checkpoint lists does not need j_state_lock for anything. Furthermore
the transaction is in T_LOCKED state and we waited for all outstanding
handles so nobody is going to be adding anything to the transaction.

Just drop the lock for unnecessary operations.

Reported-by: Adrian Hunter <adrian.hunter@intel.com>
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


--zhXaljGHf11kAtnf--
