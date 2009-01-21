From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [RFC] [PATCH] vfs: Call filesystem callback when backing device caches should be flushed
Date: Wed, 21 Jan 2009 21:41:32 +0000
Message-ID: <20090121214132.GD16133@shareable.org>
References: <20090120160527.GA17067@duck.suse.cz> <20090120231647.GC2392@mail.oracle.com> <20090121001630.GA32645@shareable.org> <20090121150557.GC3186@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@MIT.EDU>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090121150557.GC3186@duck.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jan Kara wrote:
>   Well, that would be nice but you cannot return from fsync() until you've
> done the flush. So you have to be careful not to wait for too long. JBD
> actually plays these tricks with sync transaction batching and it's not
> trivial to get this right. So I'd rather avoid it.

Didn't extN for some N do/did something similar?

> > What about O_SYNC writes though?  A device flush after each one would
> > be expensive, but that's what equivalence to fsync() implies is
> > needed.
>   Yes.
> 
> > O_DIRECT writes shouldn't do block_flush_device(), but an app may
> > still need a way to commit data for integrity.  So fsync() or
> > fdatasync() called after a series of O_DIRECT writes should call
> > block_flush_device() _even_ though there's no page-cache dirty data to
> > commit, and even if there's no inode change to commit.
>   Hmm, this is an interesting point. You're right that we currently miss
> the flushes and we probably need some dirty inode flag like needs_flush or
> so.

Proposal (both together):

  1. per-device-queue flag needs_flush.

     Set on write queued, clear on flush queued.  When clear, flushes
     are discarded instead of being queued.  Waiting on the discarded
     flush waits instead for the last flush which was queued, if it's
     still in flight.  So the queue will also track that last flush.

  2. per-inode flag needs_flush.

     Set on write queued from this file (writeback), cleared on flush
     sent from this file (i.e. the thing fsync/fdatasync/O_SYNC should
     be calling).  As above, flushes aren't sent from this file when
     this flag is clear, and waiting on a discarded flush waits
     instead on the last flush sent for this file, if it's still in
     flight.  So the file will track that last flush command in
     addition to needs_flush.

Implement both.  The first doee right thing optimising away
unnecessary journal/tree-log barriers.  The second further optimises
individual files.

You *could* have a needs_flush bit per page, to tune it further, in
the same way that fsync_range() and O_DIRECT invalidations etc. are
getting better at working with ranges, but that may be pointless
overengineering (I've no idea).

> > Since you want to avoid issuing two device flushes in a row (they're
> > not free), and a journalling fs may issue one separately, as Joel says
> > a filesystem could override this.
>   Yes, journalling filesystems usually take care themselves.
> 
> > But I suspect it would be better to keep the generic call to
> > block_flush_device() from fsync(), and at the block layer discard
> > duplicate flushes that have no writes in between.

>   Hmm, probably this won't be too hard to implement. OTOH it won't catch
> those cases where some other process manages to squeeze in some writes
> between the two flushes. So I'm not sure if we really want to design things
> this way unless really necessary.

Let me put it this way.  ext3 is a journalling fs, and it does _not_
provide integrity with fsync() or fdatasync() in all cases, even with
barriers and data=ordered turned on.

We should have something which provides flushes generically, with the
possibility for the fs to override it with a smarter method when it
knows better.

-- Jamie
