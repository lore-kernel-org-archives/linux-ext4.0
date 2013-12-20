From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Fri, 20 Dec 2013 14:34:55 -0500
Message-ID: <20131220193455.GA6912@thunk.org>
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
Cc: Dave Chinner <david@fromorbit.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131220181731.GG19166@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 20, 2013 at 11:17:31AM -0700, Matthew Wilcox wrote:
> 
> Maybe.  We have a tension here between wanting to avoid unnecessary
> writes to the media (as you say, wear is going to be important for some
> media, if not all) and wanting to not fragment files (both for extent
> tree compactness and so that we can use PMD or even PGD mappings if the
> stars align).  It'll be up to the filesystem whether it chooses to satisfy
> the get_block request with something prezeroed, or something that aligns
> nicely.  Ideally, it'll be able to find a block of storage that does both!
> 
> Actually, I now see a second way to read what you wrote.  If you meant
> "we can map in ZERO_PAGE or one of its analogs", then no.  The amount
> of cruft that optimisation added to the filemap_xip code is horrendous.
> I don't think it's a particularly common workload (mmap a holey file,
> read lots of zeroes out of it without ever writing to it), so I think
> it's far better to allocate a page of storage and zero it.

It seems that you're primarily focused about allocated versus
unallocated blocks, and what I think Dave and I are trying to point
out is the distinction between initialized and uninitialized blocks
(which are already allocated).

So I was thinking about the case where the blocks were already
allocated and mapped --- so we have a logical -> physical block
mapping already established.  However, if the blocks were allocated
via fallocate(2), so they are unallocated, although they will be
well-aligned.

Which means that if you pre-zero at read time, at that point you will
be fragmenting the extent tree, and the blocks are already
well-aligned so it's in fact better to fault in a zero page at read
time when we are dealing with an allocated, but not-yet-initialized
block.

Also, one of the ways which we handle fragmentation is via delayed
allocation.  That is, we don't make the allocation decision until the
last possible second.  We do lose this optimization for direct I/O,
since that's part of the nature of the beast --- but there's no reason
not to have it for XIP writes --- especially if the goal is to be able
to support persistent memory storage devices in a first class way,
instead of a one-off hack for demonstration purposes....

	     	     	      		    - Ted
