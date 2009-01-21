From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] [PATCH] vfs: Call filesystem callback when backing
	device caches should be flushed
Date: Wed, 21 Jan 2009 16:05:57 +0100
Message-ID: <20090121150557.GC3186@duck.suse.cz>
References: <20090120160527.GA17067@duck.suse.cz> <20090120231647.GC2392@mail.oracle.com> <20090121001630.GA32645@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@MIT.EDU>
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090121001630.GA32645@shareable.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 21-01-09 00:16:30, Jamie Lokier wrote:
> Joel Becker wrote:
> > On Tue, Jan 20, 2009 at 05:05:27PM +0100, Jan Kara wrote:
> > >   we noted in our testing that ext2 (and it seems some other filesystems as
> > > well) don't flush disk's write caches on cases like fsync() or changing
> > > DIRSYNC directory. This is my attempt to solve the problem in a generic way
> > > by calling a filesystem callback from VFS at appropriate place as Andrew
> > > suggested. For ext2 what I did is enough (it just then fills in
> > > block_flush_device() as .flush_device callback) and I think it could be
> > > fine for other filesystems as well.
> > 
> > 	The only question I have is why this would be optional.  It
> > would seem that this would be the preferred default behavior for all
> > block filesystems.  We have the backing_dev_info and a way to override
> > the default if a filesystem needs something special.
> 
> I agree, it should be done by default.  Not only that, if you have
> several concurrent fsync() calls (could be unrelated but on the same
> disk), it could perhaps delay slightly and coalesce the flushes for
> better throughput.
  Well, that would be nice but you cannot return from fsync() until you've
done the flush. So you have to be careful not to wait for too long. JBD
actually plays these tricks with sync transaction batching and it's not
trivial to get this right. So I'd rather avoid it.

> What about O_SYNC writes though?  A device flush after each one would
> be expensive, but that's what equivalence to fsync() implies is
> needed.
  Yes.

> O_DIRECT writes shouldn't do block_flush_device(), but an app may
> still need a way to commit data for integrity.  So fsync() or
> fdatasync() called after a series of O_DIRECT writes should call
> block_flush_device() _even_ though there's no page-cache dirty data to
> commit, and even if there's no inode change to commit.
  Hmm, this is an interesting point. You're right that we currently miss
the flushes and we probably need some dirty inode flag like needs_flush or
so.

> Since you want to avoid issuing two device flushes in a row (they're
> not free), and a journalling fs may issue one separately, as Joel says
> a filesystem could override this.
  Yes, journalling filesystems usually take care themselves.

> But I suspect it would be better to keep the generic call to
> block_flush_device() from fsync(), and at the block layer discard
> duplicate flushes that have no writes in between.
  Hmm, probably this won't be too hard to implement. OTOH it won't catch
those cases where some other process manages to squeeze in some writes
between the two flushes. So I'm not sure if we really want to design things
this way unless really necessary.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
