From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Mon, 23 Dec 2013 14:36:41 +1100
Message-ID: <20131223033641.GF3220@dastard>
References: <20131219020759.GA27469@thunk.org>
 <20131219041240.GA19166@parisc-linux.org>
 <20131219054303.GA4391@thunk.org>
 <20131219152049.GB19166@parisc-linux.org>
 <20131219161728.GA9130@thunk.org>
 <20131219171201.GD19166@parisc-linux.org>
 <20131219171848.GC9130@thunk.org>
 <20131220181731.GG19166@parisc-linux.org>
 <20131220193455.GA6912@thunk.org>
 <20131220201059.GH19166@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:15857 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756617Ab3LWDgr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Dec 2013 22:36:47 -0500
Content-Disposition: inline
In-Reply-To: <20131220201059.GH19166@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 20, 2013 at 01:11:00PM -0700, Matthew Wilcox wrote:
> On Fri, Dec 20, 2013 at 02:34:55PM -0500, Theodore Ts'o wrote:
> > On Fri, Dec 20, 2013 at 11:17:31AM -0700, Matthew Wilcox wrote:
> > > Maybe.  We have a tension here between wanting to avoid unnecessary
> > > writes to the media (as you say, wear is going to be important for some
> > > media, if not all) and wanting to not fragment files (both for extent
> > > tree compactness and so that we can use PMD or even PGD mappings if the
> > > stars align).  It'll be up to the filesystem whether it chooses to satisfy
> > > the get_block request with something prezeroed, or something that aligns
> > > nicely.  Ideally, it'll be able to find a block of storage that does both!
> > > 
> > > Actually, I now see a second way to read what you wrote.  If you meant
> > > "we can map in ZERO_PAGE or one of its analogs", then no.  The amount
> > > of cruft that optimisation added to the filemap_xip code is horrendous.
> > > I don't think it's a particularly common workload (mmap a holey file,
> > > read lots of zeroes out of it without ever writing to it), so I think
> > > it's far better to allocate a page of storage and zero it.
> > 
> > It seems that you're primarily focused about allocated versus
> > unallocated blocks, and what I think Dave and I are trying to point
> > out is the distinction between initialized and uninitialized blocks
> > (which are already allocated).
> 
> I understand the difference for filesystems on block devices; filesystem
> blocks can be:
> 
>  * allocated, initialised (eg: after they've been written to)
>  * allocated, uninitialised (eg: after fallocate)

* allocated, encoded (e.g. encrypted, compressed, deduplicated, etc)

>  * unallocated, initialised (eg: written to in the page cache)

i thikn you are refering to delayed allocation here? i.e. the blocks
are reserved, and since they aren't allocated they can't be
considered initialised or uninitialised.

IOWs, I think you are conflating "page cache dirty" with "filesystem
block initialised" but you can't do that because no filesystem
blocks have been allocated.

>  * unallocated, uninitialised

That's called free space, and the page cache/XIP will never see
that.

> A filesystem on top of an XIP device can't have an unallocated,
> initialised block.  There's no page cache to buffer the write in, so at
> the point where you're going to store to it, you have to allocate.

Like I've consistently said: XIP needs to support page cache
buffering.

> You also can't mmap() an allocated, uninitialised block.  It's got to
> be initialised before we can insert a PTE that points to it.

No, the memory that mmap() points to needs to be initialised.
Whether that's the same thing as the backing store is another
matter. If we are using persistent memory, we can use XIP if the
backing store allows it, otherwise we need to use the page cache to
buffer the mmap() operations.

> > So I was thinking about the case where the blocks were already
> > allocated and mapped --- so we have a logical -> physical block
> > mapping already established.  However, if the blocks were allocated
> > via fallocate(2), so they are unallocated, although they will be
> > well-aligned.
> > 
> > Which means that if you pre-zero at read time, at that point you will
> > be fragmenting the extent tree, and the blocks are already
> > well-aligned so it's in fact better to fault in a zero page at read
> > time when we are dealing with an allocated, but not-yet-initialized
> > block.
> 
> Just to check here, you mean a ZERO_PAGE, right?  Or a page cache page
> that has been zeroed?
> 
> > Also, one of the ways which we handle fragmentation is via delayed
> > allocation.  That is, we don't make the allocation decision until the
> > last possible second.  We do lose this optimization for direct I/O,
> > since that's part of the nature of the beast --- but there's no reason
> > not to have it for XIP writes --- especially if the goal is to be able
> > to support persistent memory storage devices in a first class way,
> > instead of a one-off hack for demonstration purposes....
> 
> I think it's also the nature of the beast that you lose this optimisation
> for XIP writes.  Sure, there are multiple ways we could do _not exactly_
> XIP to take advantage of persistent memory, and I think we should discuss
> them, but we should leave XIP as meaning XIP.  I have some great ideas
> about how a hybrid approach could work ...

The problem is that you can't do generic, system wide XIP without
considering all different possibilities. How do you do XIP on a COW
based filesystem, where the block mapping changes every time a block
is written? You can do XIP for read, but you can't for write, and
write needs to invalidate read XIP mappings.  Indeed, some hardware
types can do XIP for read, but cannot do it for write (e.g. flash).
They need buffering to allow writes to be done for XIP mappings.

What I'm trying to say is that I think the whole idea of XIP is
separate from the page cache is completely the wrong way to go about
fixing it. XIP should simply be a method of mapping backing device
pages into the existing per-inode mapping tree.  If we need to
encode, remap, etc because of constraints of the configuration (be
it filesystem implementation or block device encodings) then we just
use the normal buffered IO path, with the ->writepages path hitting
the block layer to do the memcpy or encoding into persistent
memory. Otherwise we just hit the direct IO path we've been talking
about up to this point...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
