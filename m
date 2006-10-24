From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Tue, 24 Oct 2006 11:26:26 -0500
Message-ID: <1161707186.20134.26.camel@kleikamp.austin.ibm.com>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz>
	 <20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net>
	 <20061024041433.GB12506@havoc.gtf.org>
	 <20061024135928.GB11034@melbourne.sgi.com>
	 <1161701502.20134.17.camel@kleikamp.austin.ibm.com>
	 <20061024160128.GF11034@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jeff Garzik <jeff@garzik.org>, Alex Tomas <alex@clusterfs.com>,
	Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:22502 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S932390AbWJXQ1A
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Oct 2006 12:27:00 -0400
To: David Chinner <dgc@sgi.com>
In-Reply-To: <20061024160128.GF11034@melbourne.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2006-10-25 at 02:01 +1000, David Chinner wrote:
> On Tue, Oct 24, 2006 at 09:51:41AM -0500, Dave Kleikamp wrote:
> > On Tue, 2006-10-24 at 23:59 +1000, David Chinner wrote:
> > > That's the wrong way to look at it. if you want the userspace
> > > process to specify a location, then you should preallocate it first
> > > before doing anything else. There is no need to clutter a simple
> > > data mover interface with all sorts of unnecessary error handling.
> > 
> > You are implying the the 2-step interface, creating a new inode then
> > swapping the contents, is the only way to implement this.
> 
> No, it's not the only way to implement it, but it seems the cleanest
> way to me when you have to consider crash recovery. With a temporary
> inode, you can create it, hold a reference and then unlink it so
> that any crash at that point will free the inode and any extents
> it has on it.
> 
> The only way I can see anything different working is having the
> filesystem hold extents somewhere internally that provides us the
> same recovery guarantees while we copy the data and insert the new
> extents.  This is obviously a filesystem specific solution and is
> more complex to implement than a swap extent transaction. it
> probably also needs on disk format changes to support properly....

This is definitely filesystem-dependent.  I would think allocating an
extent would be like any other allocation done by the filesystem, and
there are already recovery mechanisms for that.

> > > Once you've separated the destination allocation from the data
> > > mover, the mover is basically a splice copy from source to
> > > destination, an fsync and then an atomic swap blocks/extents operation.
> > > Most of this code is generic, and a per-fs swap-extents vector
> > > could be easily provided for the one bit that is not....
> > 
> > The benefit of having such a simple data mover is negated by moving the
> > complexity into the allocator.
> 
> What complexity does it introduce that the allocator doesn't already
> have or needs to provide for the single call interface to work?

I don't see it as any more or less complex than a single interface.

> > A single interface that would move a part of a file at a time has the
> > advantage that a large file which is only fragmented in a few areas does
> > not need to be completely moved.
> 
> And the two-step process can do exactly this as well - splice can
> work on any offset within the file...

I wasn't aware of that.  That makes your proposal sound a lot better.

> > > The allocation interface, OTOH, is anything but simple and is really
> > > a filesystem specific interface. Seems logical to me to separate
> > > the two. 
> > 
> > So what then is the benefit of having a simple generic data mover if
> > every file system needs to implement it's own interface to allocate a
> > copy of the data?
> 
> I assume you meant "....allocate the space to store the copy of the data."

Yeah.

> The allocation interface needs to be be able to be  extended
> independently of the data mover interface. XFS already exposes
> allocation ioctls to userspace for preallocation and we've got plans
> to extnd this further to allow userspace controlled allocation for
> smart defrag tools for XFS. Tying allocation to the data mover
> just makes the interface less flexible and harder to do anything
> smart with....

Okay.  It would be nice to standardize the interface so we don't have
every filesystem introducing new ioctls.

> Cheers,
> 
> Dave.
-- 
David Kleikamp
IBM Linux Technology Center
