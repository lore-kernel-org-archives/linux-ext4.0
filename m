From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: avoid lockdep warning when inheriting encryption
 context
Date: Mon, 21 Nov 2016 11:59:29 -0500
Message-ID: <20161121165929.y7yltuht2jtapnnw@thunk.org>
References: <1479157416-144246-1-git-send-email-ebiggers@google.com>
 <20161116154738.bje52n5gwyve352p@thunk.org>
 <20161121141813.GE8207@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers@google.com>, linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39664 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754595AbcKUQ7d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 21 Nov 2016 11:59:33 -0500
Content-Disposition: inline
In-Reply-To: <20161121141813.GE8207@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 21, 2016 at 03:18:13PM +0100, Jan Kara wrote:
> On Wed 16-11-16 10:47:38, Ted Tso wrote:
> > On Mon, Nov 14, 2016 at 01:03:36PM -0800, Eric Biggers wrote:
> > > If the task actually were to wait for the journal to commit in this
> > > case, then it would deadlock because a handle remains open from
> > > __ext4_new_inode(), so the running transaction can't be committed yet.
> > > Fortunately, __jbd2_journal_force_commit() avoids the deadlock by not
> > > allowing the running transaction to be committed while the current task
> > > has it open.  However, the above lockdep warning is still triggered.
> > 
> > So this is a false positive introduced by
> > 
> >    1eaa566d368b: jbd2: track more dependencies on transaction commit
> > 
> > Instead of working around the problem here, perhaps it would be better
> > to fix __jbd2_journal_force_commit() so that it calls a newly created
> > __jbd2_log_wait_commit() which skips the jbd2_might_wait_for_commit()
> > (and then have jbd2_log_wait_commit call __jbd2_log_wait_commit with
> > the might_wait_for_commit check)?
> > 
> > This isn't the only place where jbd2_journal_force_commit() is called
> > so if the problem is with the lockdep check, maybe we should just fix
> > the logic in the jbd2 layer, hmm?
> 
> So it is a false positive in the sense that it is not a deadlock
> possibility. OTOH it is a valid report in the sense that the code does not
> do what it is intended to - i.e., force a transaction commit to free some
> blocks and retry block allocation. So I find the original fix actually
> worthwhile.

OK, I'll take Eric's patch.  Thanks!!

> Looking into ext4 codebase there are only 3 callsites of
> jbd2_journal_force_commit_nested() - all in some kind of retry loops and
> two of the call sites actually should not need the "nested" variant. Just
> ext4_should_retry_alloc() may be called when a transaction is held open and
> then the caller likely wanted something else anyway so it would be good to
> find these cases and fix them and then get rid of the "nested" variant of
> forcing a commit since that is easy to use in a wrong way.

Fair enough.  The original use case was for undo access, which we're
not using any more since we added mballoc.  It looks like we can
remove all of the support for get_undo_access while we're at it.

						- Ted
