From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [RFC] [PATCH] vfs: Call filesystem callback when backing device caches should be flushed
Date: Wed, 21 Jan 2009 00:16:30 +0000
Message-ID: <20090121001630.GA32645@shareable.org>
References: <20090120160527.GA17067@duck.suse.cz> <20090120231647.GC2392@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090120231647.GC2392@mail.oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Joel Becker wrote:
> On Tue, Jan 20, 2009 at 05:05:27PM +0100, Jan Kara wrote:
> >   we noted in our testing that ext2 (and it seems some other filesystems as
> > well) don't flush disk's write caches on cases like fsync() or changing
> > DIRSYNC directory. This is my attempt to solve the problem in a generic way
> > by calling a filesystem callback from VFS at appropriate place as Andrew
> > suggested. For ext2 what I did is enough (it just then fills in
> > block_flush_device() as .flush_device callback) and I think it could be
> > fine for other filesystems as well.
> 
> 	The only question I have is why this would be optional.  It
> would seem that this would be the preferred default behavior for all
> block filesystems.  We have the backing_dev_info and a way to override
> the default if a filesystem needs something special.

I agree, it should be done by default.  Not only that, if you have
several concurrent fsync() calls (could be unrelated but on the same
disk), it could perhaps delay slightly and coalesce the flushes for
better throughput.

What about O_SYNC writes though?  A device flush after each one would
be expensive, but that's what equivalence to fsync() implies is
needed.

O_DIRECT writes shouldn't do block_flush_device(), but an app may
still need a way to commit data for integrity.  So fsync() or
fdatasync() called after a series of O_DIRECT writes should call
block_flush_device() _even_ though there's no page-cache dirty data to
commit, and even if there's no inode change to commit.

Since you want to avoid issuing two device flushes in a row (they're
not free), and a journalling fs may issue one separately, as Joel says
a filesystem could override this.

But I suspect it would be better to keep the generic call to
block_flush_device() from fsync(), and at the block layer discard
duplicate flushes that have no writes in between.

-- Jamie
