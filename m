From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [RFC] [PATCH] vfs: Call filesystem callback when backing device caches should be flushed
Date: Wed, 21 Jan 2009 23:55:31 +0000
Message-ID: <20090121235531.GB20407@shareable.org>
References: <20090120160527.GA17067@duck.suse.cz> <20090120231647.GC2392@mail.oracle.com> <20090121125537.GB3186@duck.suse.cz> <20090121214748.GE16133@shareable.org> <20090121232524.GQ10158@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:59715 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbZAUXzg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jan 2009 18:55:36 -0500
Content-Disposition: inline
In-Reply-To: <20090121232524.GQ10158@disturbed>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dave Chinner wrote:
> If the inode is dirty and fsync does nothing, then that filesystem
> is *broken*. If writing to the inode doesn't dirty it, then the
> filesystem is broken. Fix the broken filesystem.

*Wrong*  Very, very wrong.

You do not write totally unchanged inode bytes just for the sake of
causing a NOP transaction to make the disk write the fsync as a
side-effect of a broken paradigm.  That's _three_ pointless I/Os (one
redundant barrier and two writes), and probably 50x slowdown in write
performance due to seeking.  Now who's filesystem is broken?

> > For efficient fdatasync() you _never_ want a transaction if possible,
> > because it forces the disk head to seek between alternating regions of
> > the disk, two seeks per fsync().
> 
> If there is dirty metadata that is need to be logged or flushed,
> then fdatasync() needs to do something. If it doesn't do it
> correctly, then that *filesystem is broken*. Fix the broken
> filesystem.

A series of a writes over existing data and fdatasync() should *never*
write to the transaction log, unless you mounted something like ext3
data=journal, which isn't usual.

There is no dirty metadata to write.  It is data only.  fdatasync()
*means* "do NOT write metadata that is not needed for data retrieval",
that's it's whole point.  A filesystem which keeps seeking to its
inode area _and_ its journal area _and_ the data area on every
fdatasync() is a poor design indeed.

> > So you can't rely on journalling transactions to flush.
> 
> The VFS doesn't even know about transactions....

Whoever brought them up said they can be relied on to flush writes
during fsync/fdatasync.  Just saying they can't, is all...

> > >   Finally, I prefer maintainers of the filesystems themselves to
> > >   decide whether their filesystem needs flushing and thus
> > >   knowingly impose this performance penalty on them...
> > 
> > I say it should flush be default unless a filesystem hooks an
> > alternative strategy.  Certainly, it's silly to have the same code
> > duplicated in nearly every filesystem
> 
> So write a *generic helper* for those filesystems that do the same
> thing and hook it to their ->fsync method. Don't hard code it in the
> VFS so other filesystem dev's have to come along afterwards and turn
> it off.

Are there any at the moment which would turn it off?
If so that's a fine idea.

-- Jamie
