From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC] jbd: don't wake kjournald unnecessarily
Date: Wed, 19 Dec 2012 02:27:10 +0100
Message-ID: <20121219012710.GF5987@quack.suse.cz>
References: <50D0A1FD.7040203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Dave Wysochanski <dwysocha@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010Ab2LSB1W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Dec 2012 20:27:22 -0500
Content-Disposition: inline
In-Reply-To: <50D0A1FD.7040203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 18-12-12 11:03:57, Eric Sandeen wrote:
> Commit d9b0193 jbd: fix fsync() tid wraparound bug
> changed the logic for whether __log_start_commit() should wake up
> kjournald.
> 
> After backporting this to RHEL6, I had a report of a performance regression
> on a large benchmark, and it was narrowed down to the change above.
  Strange. I wonder what really happened that those additional wakeups had
influence on performance. They should be pretty cheap.

> I did a little investigation of jbd behavior while running xfstest
> 013, which just does a large fsstress run, and found that we were
> waking up kjournald more often than before; specifically,
> in the case where
> 
> 	target == j_commit_request == journal->j_running_transaction
> 
> It seems to me that the wakeup is not needed if we already have
> the right target on the commit request, so I tested with the
> additional condition added in the patch below; this brought
> performance back up to prior levels.
  Correct.

> I also tested it with tid_t defined to a u8, to get frequent wraps.
> If I back out the wraparound patch, it will easily provoke
> the original ASSERT that prompted the prior commit.  With
> the commit in place and the patch below, I survived running
> fsstress for 10 hours without problems even with a frequently-wrapping
> tid_t.
  Thanks for throughout testing!

> A couple questions remain:
> 
> With a u8 tid_t, the "else" clause from commit d9b0193 fires
> frequently; I really think the underlying problem is that tid_geq()
> etc does not properly handle wraparounds - if, say, target is 255
> and j_commit_request is 0, we don't know if j_commit_request
> is 255 tids behind, or 1 tid ahead.  I have to think about that
> some more, unless it's obvious to someone else.
  Well, there's no way to handle wraps better AFAICT. Tids eventually wrap
and if someone has stored away tid of a transaction he wants committed and
keeps it for a long time before using it, it can end up being anywhere
before / after current j_commit_request. The hope was that it takes long
enough to wrap around 32-bit tids. If this happens often in practice we may
have to switch to 64-bit tids (in memory, on disk 32-bit tids are enough
because of limited journal size).

> FWIW, some people have indeed seen that else clause fire upstream,
> both in the case where j_commit_request is > 2^31 and the 
> target is 0.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=46031
> http://forums.debian.net/viewtopic.php?f=5&t=80741
  This is actually curious. The fact that i_datasync_tid was 0 means that
either journal was not initialized during ext3_iget() or j_commit_sequence
was 0 during ext3_iget() - note that j_commit_sequence is initialized to
j_transaction_sequence in journal_reset()... Hum, but in a case when
ext3_load_journal() calls journal_wipe() and that finds j_tail != 0, we
call journal_skip_recovery(). That ends up setting j_transaction_sequence
to the last transaction in the log but j_commit_sequence is left at 0.
I see that explains how we could hit the warning. I think we should
initialize j_commit_sequence properly also when skipping recovery and that
will solve the problem.

BTW if we find j_tail == 0 in journal_wipe(), we skip setting
j_transaction_sequence to the last transaction in the journal.  So
j_transaction_sequence ends up being 0 but j_tail_sequence is set by
load_superblock() to sb->s_sequence so there's a mismatch between reality
and what j_tail_sequence claims to be the oldest transaction in the log.
That reminds me of the report where bogus journal replay corrupted a
filesystem...

I'll fix both these issues.

> Anyway, I think this patch helps on the "don't send extra wakeups"
> side of things.  Does anyone see a problem with it?
  The patch is fine. I'll queue it up.

								Honza
> =============
> [PATCH] jbd: don't wake kjournald unnecessarily
> 
> Don't send an extra wakeup to kjournald in the case where we
> already have the proper target in j_commit_request, i.e. that
> commit has already been requested for commit.
> 
> commit d9b0193 "jbd: fix fsync() tid wraparound bug" changed
> the logic leading to a wakeup, but it caused some extra wakeups
> which were found to lead to a measurable performance regression.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index a286233..81cc7ea 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -446,7 +446,8 @@ int __log_start_commit(journal_t *journal, tid_t target)
>  	 * currently running transaction (if it exists).  Otherwise,
>  	 * the target tid must be an old one.
>  	 */
> -	if (journal->j_running_transaction &&
> +	if (journal->j_commit_request != target &&
> +	    journal->j_running_transaction &&
>  	    journal->j_running_transaction->t_tid == target) {
>  		/*
>  		 * We want a new commit: OK, mark the request and wakeup the
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
