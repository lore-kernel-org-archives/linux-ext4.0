From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] jbd: fix fsync() tid wraparound bug
Date: Sat, 30 Apr 2011 13:17:11 -0400
Message-ID: <20110430171711.GA2819@thunk.org>
References: <20110425231454.GB9486@thunk.org>
 <1303777411-1316-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Martin_Zielinski@McAfee.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57411 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab1EAR6E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 May 2011 13:58:04 -0400
Content-Disposition: inline
In-Reply-To: <1303777411-1316-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

I don't know if you've been following this thread, but I was wondering
if you could review this patch, (a) for inclusion in the ext3 tree,
and (b) because I'd appreciate a second pair of eyes looking at this
patch, since I intend to push similar change to jbd2.

I'm not entirely convinced this is caused by tid's wrapping around,
since that would be a huge number of commits, but if it's not that,
somehow i_datasync_tid or i_sync_tid is either getting corrupted or
not getting set --- and I have no idea how that could be happening.
This patch should at least avoid the system from crashing when we hit
the case, and harmlessly handle the situation --- with at the worst
case, an journal commit that wouldn't otherwise be needed.

As background, I've been on this bug for months now, as it's been
reported to me as occasionally happening on Android devices that have
been using ext4.  Since I hadn't seen any reports of this in the field
in the x86 world, and this code hadn't changed in a long, long time, I
had originally assumed it was an ARM-specific bug.  However, recently,
Martin Zielinski (on this thread) has reported this problem on an x86
system --- and on a x86 system to boot.

Martin suspects it may have to do with sqllite --- which is consistent
with I've seen, since I believe Android devices use sqllite quite
heavily as well.

				- Ted

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
---
 fs/jbd/journal.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

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
 
