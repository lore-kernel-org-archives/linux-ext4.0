From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [RFC] [PATCH] vfs: Call filesystem callback when backing device caches should be flushed
Date: Thu, 22 Jan 2009 03:03:22 +0000
Message-ID: <20090122030322.GA23807@shareable.org>
References: <20090120160527.GA17067@duck.suse.cz> <20090120231647.GC2392@mail.oracle.com> <20090121125537.GB3186@duck.suse.cz> <20090121214748.GE16133@shareable.org> <20090121232524.GQ10158@disturbed> <20090121235531.GB20407@shareable.org> <20090122012158.GR10158@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:35710 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667AbZAVDDZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jan 2009 22:03:25 -0500
Content-Disposition: inline
In-Reply-To: <20090122012158.GR10158@disturbed>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dave Chinner wrote:
> On Wed, Jan 21, 2009 at 11:55:31PM +0000, Jamie Lokier wrote:
> > Dave Chinner wrote:
> > > If the inode is dirty and fsync does nothing, then that filesystem
> > > is *broken*. If writing to the inode doesn't dirty it, then the
> > > filesystem is broken. Fix the broken filesystem.
> > 
> > *Wrong*  Very, very wrong.
> > 
> > You do not write totally unchanged inode bytes just for the sake of
> > causing a NOP transaction to make the disk write the fsync as a
> > side-effect of a broken paradigm.
> 
> Right, by definition, fsync shouldn't write unchanged inodes.
> 
> But I fail to see how that is even relevant to the above comment
> I made about *dirty or modified inodes*.

The "above comment" is in reference to when data has been written with
write(), to be fsync'd, but the inode itself is not modified.  It is
proper behaviour not to write the inode to disk in that case.

> > > > For efficient fdatasync() you _never_ want a transaction if possible,
> > > > because it forces the disk head to seek between alternating regions of
> > > > the disk, two seeks per fsync().
> > > 
> > > If there is dirty metadata that is need to be logged or flushed,
> > > then fdatasync() needs to do something. If it doesn't do it
> > > correctly, then that *filesystem is broken*. Fix the broken
> > > filesystem.
> > 
> > A series of a writes over existing data and fdatasync() should *never*
> > write to the transaction log, unless you mounted something like ext3
> > data=journal, which isn't usual.
> 
> Yes, but that's a specific case, not the general case you first
> raised. In this specific case, the filesystem can issue a device
> flush instead of a transaction.

Erm... You said "the filesystem is broken because it doesn't flush
dirty metadata when you do fdatasync".  That's just wrong; it's not
_supposed_ to flush dirty metadata.

fdatasync() is the case it's most worth optimising, by the way.

> Remember - transaction != device flush - they are separate
> operations and only on some filesystems does a transaction
> imply a barrier/device flush.

Right, you're saying what I've just been saying.  Are we arguing with
each other or someone else? :-)

> However, only the filesystem knows that this is the correct thing to
> do and so that is why the VFS should not be implementing device
> flushes.

True.  But it's never _wrong_ to issue a device flush, following
completion of the filesystem sync method, only suboptimal sometimes.
It does no harm except to performance.

It may be worth erring on the side of caution and always doing so.
It's difficult to test this code really gives data integrity, yet its
important, and erring on the side of caution might have negligable
performance effect.

If we start distinguishing I/O flushes from I/O barriers, by the way,
an ordinary transaction isn't enough, because a transaction barrier
(using a pure I/O barrier) is insufficient for flushing.

> > > > >   decide whether their filesystem needs flushing and thus
> > > > >   knowingly impose this performance penalty on them...
> > > > 
> > > > I say it should flush be default unless a filesystem hooks an
> > > > alternative strategy.  Certainly, it's silly to have the same code
> > > > duplicated in nearly every filesystem
> > > 
> > > So write a *generic helper* for those filesystems that do the same
> > > thing and hook it to their ->fsync method. Don't hard code it in the
> > > VFS so other filesystem dev's have to come along afterwards and turn
> > > it off.
> > 
> > Are there any at the moment which would turn it off?
> 
> XFS, for one. Probably btrfs, ext3 and ext4 would also need to turn
> it off. Any other filesystem that supports barriers properly would
> have to turn it off, too. However, I don't claim to have sufficient
> expertise about those filesystems (except for XFS) to say for
> certain what process is most optimal for sync or fsync for them.
> Similarly, the VFS shouldn't be deciding that either...

I see your reasoning.

Filesystems which have a sync method, can call an appropriate block
flush helper.  Right now ext3 is broken in this department.

Older filesystems which don't have their own sync method will need the
block flush helper always, after data is generically flushed.

-- Jamie
