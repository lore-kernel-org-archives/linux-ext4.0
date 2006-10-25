From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Wed, 25 Oct 2006 11:18:53 +1000
Message-ID: <20061025011853.GQ8394166@melbourne.sgi.com>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net> <20061024041433.GB12506@havoc.gtf.org> <20061024135928.GB11034@melbourne.sgi.com> <1161701502.20134.17.camel@kleikamp.austin.ibm.com> <20061024160128.GF11034@melbourne.sgi.com> <1161707186.20134.26.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, Jeff Garzik <jeff@garzik.org>,
	Alex Tomas <alex@clusterfs.com>, Theodore Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:40356 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1161326AbWJYBU1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Oct 2006 21:20:27 -0400
To: Dave Kleikamp <shaggy@austin.ibm.com>
Content-Disposition: inline
In-Reply-To: <1161707186.20134.26.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 24, 2006 at 11:26:26AM -0500, Dave Kleikamp wrote:
> On Wed, 2006-10-25 at 02:01 +1000, David Chinner wrote:
> > On Tue, Oct 24, 2006 at 09:51:41AM -0500, Dave Kleikamp wrote:
> > > On Tue, 2006-10-24 at 23:59 +1000, David Chinner wrote:
> > > > That's the wrong way to look at it. if you want the userspace
> > > > process to specify a location, then you should preallocate it first
> > > > before doing anything else. There is no need to clutter a simple
> > > > data mover interface with all sorts of unnecessary error handling.
> > > 
> > > You are implying the the 2-step interface, creating a new inode then
> > > swapping the contents, is the only way to implement this.
> > 
> > No, it's not the only way to implement it, but it seems the cleanest
> > way to me when you have to consider crash recovery. With a temporary
> > inode, you can create it, hold a reference and then unlink it so
> > that any crash at that point will free the inode and any extents
> > it has on it.
> > 
> > The only way I can see anything different working is having the
> > filesystem hold extents somewhere internally that provides us the
> > same recovery guarantees while we copy the data and insert the new
> > extents.  This is obviously a filesystem specific solution and is
> > more complex to implement than a swap extent transaction. it
> > probably also needs on disk format changes to support properly....
> 
> This is definitely filesystem-dependent.  I would think allocating an
> extent would be like any other allocation done by the filesystem, and
> there are already recovery mechanisms for that.

Yes, the allocation would be the same, but that isn't the problem
I was talking about.

The problem is holding a reference to the extent once it has been
allocated while it is having the data copied into it (i.e. before it
is swapped with the original extents) and then holding the original
extents until they are freed.  These references need to be
persistent so they can be freed correctly during crash recovery
i.e. rollback the allocation if the extent swap has not been
logged, or free the original blocks is the extent swap has been
logged.

The obvious way to do this is to use an unlinked (orphan) inode....

> > > > Once you've separated the destination allocation from the data
> > > > mover, the mover is basically a splice copy from source to
> > > > destination, an fsync and then an atomic swap blocks/extents operation.
> > > > Most of this code is generic, and a per-fs swap-extents vector
> > > > could be easily provided for the one bit that is not....
> > > 
> > > The benefit of having such a simple data mover is negated by moving the
> > > complexity into the allocator.
> > 
> > What complexity does it introduce that the allocator doesn't already
> > have or needs to provide for the single call interface to work?
> 
> I don't see it as any more or less complex than a single interface.

Ok, I thought I was missing something there.

> > The allocation interface needs to be be able to be  extended
> > independently of the data mover interface. XFS already exposes
> > allocation ioctls to userspace for preallocation and we've got plans
> > to extnd this further to allow userspace controlled allocation for
> > smart defrag tools for XFS. Tying allocation to the data mover
> > just makes the interface less flexible and harder to do anything
> > smart with....
> 
> Okay.  It would be nice to standardize the interface so we don't have
> every filesystem introducing new ioctls.

Well, that will be an interesting challenge. I'm sure that there
is a common subset that all filesystems can implement e.g. per
file preallocation (something like XFS's allocate/reserve/free space
ioctls) to provide kernel support for posix_fallocate(), etc.

However, we may end up exposing enough of XFS's current allocation
semantics to do things like telling the filesystem to allocate in
allocation group 6, near block number 0x32482 within the AG, falling
back to searching for the nearest match to the size requirement,
failing that look for something larger than the minimum size
specified, and then fail if you can't find a match in that AG.

That makes little sense to any filesystem but XFS, which is really
why I think that the smarter allocation interfaces are going to
remain filesystem specific....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
