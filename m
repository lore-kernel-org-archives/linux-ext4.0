From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Mon, 23 Dec 2013 15:32:48 +1100
Message-ID: <20131223043248.GH3220@dastard>
References: <20131219054303.GA4391@thunk.org>
 <20131219152049.GB19166@parisc-linux.org>
 <20131219161728.GA9130@thunk.org>
 <20131219171201.GD19166@parisc-linux.org>
 <20131219171848.GC9130@thunk.org>
 <20131220181731.GG19166@parisc-linux.org>
 <20131220193455.GA6912@thunk.org>
 <20131220201059.GH19166@parisc-linux.org>
 <20131223033641.GF3220@dastard>
 <20131223034554.GA11091@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131223034554.GA11091@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Dec 22, 2013 at 08:45:54PM -0700, Matthew Wilcox wrote:
> On Mon, Dec 23, 2013 at 02:36:41PM +1100, Dave Chinner wrote:
> > What I'm trying to say is that I think the whole idea of XIP is
> > separate from the page cache is completely the wrong way to go about
> > fixing it. XIP should simply be a method of mapping backing device
> > pages into the existing per-inode mapping tree.  If we need to
> > encode, remap, etc because of constraints of the configuration (be
> > it filesystem implementation or block device encodings) then we just
> > use the normal buffered IO path, with the ->writepages path hitting
> > the block layer to do the memcpy or encoding into persistent
> > memory. Otherwise we just hit the direct IO path we've been talking
> > about up to this point...
> 
> That's a very filesystem person way of thinking about the problem :-)
> The problem is that you've now pushed it off on the MM people.  A page
> in the page cache needs a struct page to represent it.  If you've got

Ever crossed you mind that perhaps persistent memory could store
them? They don't need to be in volatile RAM, especially if
persistent memory is as addressable as volatile RAM. So, problem
solved - you just use part of persistent memory to track all the
pages of persistent memory used for storage....

> 70x as much persistent memory as you have volatile memory, then you just
> filled all of your volatile memory with struct pages to describe the
> persistent memory.  I don't remember if you were around for the joys
> of dealing with 16GB+ i386 machines, but the unholy messes created to
> avoid running out of the 800MB or so of lowmem are still with us.

The lowmem/highmem problem was caused by the kernel not being able
to directly address the high memory on those machines. That's not a
problem with persistent memory - the kernel can address the
persistent memory directly, and so there is nothing stopping the
kernel from storing the indexing information in persistent memory,
even if it doesn't use the persistent nature of the memory...

> I mean, sure, it's doable.  But it's got its own tradeoffs and they
> aren't pleasant for many workloads.  We could talk about ways to work
> around it, like making struct page be able to describe larger chunks of
> memory, but I don't think I'm capable of that amount of surgery to the VM.

I don't think it requires major surgery - it should be no different
to initialising a region of volatile memory, like we do for every
node on NUMA machines....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
