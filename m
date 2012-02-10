From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/6] jbd2: Issue cache flush after checkpointing even
 with internal journal
Date: Fri, 10 Feb 2012 14:55:12 +0100
Message-ID: <20120210135512.GI10509@quack.suse.cz>
References: <1326241872-20142-1-git-send-email-jack@suse.cz>
 <1326241872-20142-2-git-send-email-jack@suse.cz>
 <20120111124918.GD26337@quack.suse.cz>
 <20120209030551.GH18461@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759326Ab2BJNzO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Feb 2012 08:55:14 -0500
Content-Disposition: inline
In-Reply-To: <20120209030551.GH18461@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Ted,

On Wed 08-02-12 22:05:51, Ted Tso wrote:
> Am I missing something?  In the original code, we figure out the block
> # of the tail of the journal while holding the j_state_lock for
> writing, and we hold the lock until journal->j_tail is updated.
  Yes.

> In your proposed replacement code, you call
> jbd2_journal_get_log_tail() to determine the block #, but you aren't
> holding any locks.  jbd2_journal_get_log_tail() grabs a read lock to
> figure out the block number, but then drops the lock before it
> returns.  So then journal->j_tail gets updated by
> jbd2_journal_update_tail() --- using the block # determined by
> jbd2_journal_get_log_tail(), but we've released the lock, so can we
> guarantee the block number is still accurate?
  The code in jbd2_journal_update_tail() does:
       write_lock(&journal->j_state_lock);
       /* Are there transactions to erase? */
       if (tid_gt(tid, journal->j_tail_sequence)) {
          ... do the update
       }

  So we end up updating the log tail to our computed value only if someone
else didn't update it to a later transaction while the lock was dropped.

> In particular, since jbd2_cleanup_journal_tail() is now not holding
> any locks, what if it is racing against itself?  I can't quite see
> race that would lead to something horrible happening, but my spidey
> sense is tingling....
  The idea is that we always update log tail to the latest transaction
someone can "prove" is checkpointed. So the logic looks correct to me. But
I guess I should explain it more in the comment.

> Also:
> 
> > +/*
> > + * Update information in journal about log tail. The function returns 1 if
> > + * tail was updated, 0 otherwise. If 1 is returned, caller *must* write
> > + * journal superblock before next transaction commit is started.
> > + */
> 
> If jbd2_update_log_tail() returns 1, how is this enforced?  The caller
> can issue a journal superblocok update, sure, but there's no locking
> to prevent some other process from immediately starting a new
> transaction?
  Hum, indeed, you are right. We must update the superblock so that if the
new transaction uses journal space we already marked as free in in-memory
copy of journal superblock, we also have this information on disk so that
in case of crash we don't try to replay garbage (a mix of old and new
partially written transactions). Fixing this doesn't look trivial. I have to
think for a while how to do this best.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
