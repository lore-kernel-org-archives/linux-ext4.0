From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Mon, 23 Dec 2013 14:16:16 +1100
Message-ID: <20131223031616.GE3220@dastard>
References: <20131218050127.GA15289@thunk.org>
 <20131218142749.GA9207@parisc-linux.org>
 <20131219020759.GA27469@thunk.org>
 <20131219041240.GA19166@parisc-linux.org>
 <20131219054303.GA4391@thunk.org>
 <20131219152049.GB19166@parisc-linux.org>
 <20131219161728.GA9130@thunk.org>
 <20131219171201.GD19166@parisc-linux.org>
 <20131219171848.GC9130@thunk.org>
 <20131220181731.GG19166@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:7365 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756797Ab3LWDQU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Dec 2013 22:16:20 -0500
Content-Disposition: inline
In-Reply-To: <20131220181731.GG19166@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 20, 2013 at 11:17:31AM -0700, Matthew Wilcox wrote:
> On Thu, Dec 19, 2013 at 12:18:48PM -0500, Theodore Ts'o wrote:
> > On Thu, Dec 19, 2013 at 10:12:02AM -0700, Matthew Wilcox wrote:
> > > 
> > > ... I think it'll actually be ext4_get_block_fault, not _write, and it
> > > will include code to zero the returned blocks if they're uninitialised.
> > 
> > I assume what you mean here is if we see that the blocks are
> > uninitialized, we don't need to read from the persistent memory at
> > all; we can just map in a zeroed page, hopefully one from our stock of
> > pre-zeroed pages.  Yes?
> 
> Maybe.  We have a tension here between wanting to avoid unnecessary
> writes to the media (as you say, wear is going to be important for some
> media, if not all) and wanting to not fragment files (both for extent
> tree compactness and so that we can use PMD or even PGD mappings if the
> stars align).  It'll be up to the filesystem whether it chooses to satisfy
> the get_block request with something prezeroed, or something that aligns
> nicely.  Ideally, it'll be able to find a block of storage that does both!

Yes, XFS with it's per-file extent size hints does that already.
Like I've said previously - this is a solved problem and all we need
is the IO completion callbacks to make sub-extent size IOs convert
the allocated unwritten regions appropriately...

> Actually, I now see a second way to read what you wrote.  If you meant
> "we can map in ZERO_PAGE or one of its analogs", then no.  The amount
> of cruft that optimisation added to the filemap_xip code is horrendous.
> I don't think it's a particularly common workload (mmap a holey file,
> read lots of zeroes out of it without ever writing to it), so I think
> it's far better to allocate a page of storage and zero it.

Happens far more often than you think in scientific calculations.
Sparse matrices are extremely common, and it's a valid optimistion
to walk then with mmap and have all the uninitialised vectors simply
return zero without having storage space allocated. In this sort of
situation, you really don't want to be allocating and zeroing
persistent memory just because a terabyte sized sparse identity
matrix was mmapped and read in it's entirity during a calculation....

Persistent memory needs to handle sparse files efficiently. I'd
suggest that we already have very well tested mechanism to do
that: the mapping tree on each inode. use the radix tree to index
the space, mapping either a zero page into each hole index that is
mapped read only, and replace it with an allocated, zeroed mapping
at page_mkwrite() time. i.e. use the mapping radix tree to point at
all the pages we've mapped from the backing device rather than just
mapping an anonymous memory address from the backing device
into userspace.

That also opens the door for easily retrofitting buffered writes
into persistent memory if we need them (e.g. mmap() of encrypted
persistent memory).

Once again, we don't need to re-invent the wheel because we already
have one designed specifically for this purpose....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
