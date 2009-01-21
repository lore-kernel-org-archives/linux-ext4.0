From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [RFC] [PATCH] vfs: Call filesystem callback when backing device caches should be flushed
Date: Wed, 21 Jan 2009 21:47:48 +0000
Message-ID: <20090121214748.GE16133@shareable.org>
References: <20090120160527.GA17067@duck.suse.cz> <20090120231647.GC2392@mail.oracle.com> <20090121125537.GB3186@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@MIT.EDU>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090121125537.GB3186@duck.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jan Kara wrote:
> On Tue 20-01-09 15:16:48, Joel Becker wrote:
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
>   The reason why I've decided for NOP to be the default is that
> filesystems doing proper journalling with barriers should not need
> this (as the barrier in the transaction commit already does the job
> for them).

No, that doesn't work.

fsync() doesn't always cause a transaction.  If there's no inode
change, there may not be a transaction.  Writing does not always dirty
mtime, if it's within mtime granularity.

For efficient fdatasync() you _never_ want a transaction if possible,
because it forces the disk head to seek between alternating regions of
the disk, two seeks per fsync().

So you can't rely on journalling transactions to flush.

>   Finally, I prefer maintainers of the filesystems themselves to decide
> whether their filesystem needs flushing and thus knowingly impose this
> performance penalty on them...

I say it should flush be default unless a filesystem hooks an
alternative strategy.  Certainly, it's silly to have the same code
duplicated in nearly every filesystem

-- Jamie
