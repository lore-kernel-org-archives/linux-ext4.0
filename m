From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: Fix dbench4 performance regression for 'nobarrier'
 mounts
Date: Tue, 2 May 2017 11:36:54 +0200
Message-ID: <20170502093654.GC13916@quack2.suse.cz>
References: <20170428095934.11583-1-jack@suse.cz>
 <20170428150324.GA20122@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170428150324.GA20122@infradead.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 28-04-17 08:03:24, Christoph Hellwig wrote:
> On Fri, Apr 28, 2017 at 11:59:34AM +0200, Jan Kara wrote:
> > Fix the problem by making sure journal superblock writes are always
> > treated as synchronous since they generally block progress of the
> > journalling machinery and thus the whole filesystem.
> 
> The callchains leading down to jbd2_write_superblock looks a little
> suspicious to me.  It seems like jbd2_journal_commit_transaction
> will actually call without FUA in the JBD2_FLUSHED case. Is that
> really intentional, and if yes should it be documented?

I guess you mean this:

                /*
                 * We hold j_checkpoint_mutex so tail cannot change under us.
                 * We don't need any special data guarantees for writing sb
                 * since journal is empty and it is ok for write to be
                 * flushed only with transaction commit.
                 */
                jbd2_journal_update_sb_log_tail(journal,
                                                journal->j_tail_sequence,
                                                journal->j_tail,
                                                REQ_SYNC);

And yes, omitting REQ_FUA is intentional and the comment mentions it as "We
don't need any special data guarantees...". Maybe I could add there an
explicit mentioning of REQ_FUA and REQ_PREFLUSH so that it is clearer what
we are talking about.

> Except for that it would seem more useful to move to a "bool preflush"
> argument passed down.

Well, we can call jbd2_write_superblock() with REQ_FUA, REQ_PREFLUSH |
REQ_FUA, REQ_SYNC. So one bool argument won't be enough. However I do agree
that it would be cleaner to pass REQ_SYNC directly from all the places
which set some flags which are eventually passed down to
jbd2_write_superblock(). I'll create a cleanup patch for that.

> But I guess we'll need a quick fix first, for that:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
