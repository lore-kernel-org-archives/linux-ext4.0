From: Jamie Lokier <jamie@shareable.org>
Subject: Re: get_fs_excl/put_fs_excl/has_fs_excl
Date: Mon, 27 Apr 2009 18:03:14 +0100
Message-ID: <20090427170314.GA9807@shareable.org>
References: <20090423191817.GA22521@lst.de> <20090423192123.GL4593@kernel.dk> <20090424184047.GA17001@lst.de> <20090425151656.GH13608@mit.edu> <20090427095339.GW4593@kernel.dk> <20090427113356.GC9059@mit.edu> <20090427144742.GC4885@shareable.org> <20090427162920.GA6781@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
	Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:50532 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758130AbZD0RDS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Apr 2009 13:03:18 -0400
Content-Disposition: inline
In-Reply-To: <20090427162920.GA6781@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Apr 27, 2009 at 03:47:42PM +0100, Jamie Lokier wrote:
> > Personally, I'm interested in the following:
> > 
> >     - A process with RT I/O priority and RT CPU priority is reading
> >       a series of files from disk.  It should be very reliable at this.
> > 
> >     - Other normal I/O priority and normal CPU priority processes are
> >       reading and writing the disk.
> > 
> > I would like the first process to have a guaranteed minimum I/O
> > performance: it should continuously make progress, even when it needs
> > to read some file metadata which overlaps a page affected by the other
> > processes.
> 
> That's pretty easy.  The much harder and much more interesting problem
> is if the process with RT I/O and CPU priority is *writing* a series
> of files to disk, and not just reading from disk.

...

> I can't think of a filesystem where we would block a
> read operation for long time just because someone was holding some
> kind of filesytem-wide lock.  A spinlock, maybe, but the only time it
> makes sense to worry about boosting an I/O priority is if we're going
> to be blocing a filesystem for milliseconds or more, and not just a
> few tens of microseconds.

...

> For the former, where a real-time read request gets blocked because
> the read request for that block had already been submitted --- at a
> lower priority --- that's something that should be solvable purely in
> core block layer and in the I/O scheduler layer, I would expect.

That's great to know, thanks.  I will poke at the block layer and I/O
scheduler then, see where it leads.

Thanks,
-- Jamie
