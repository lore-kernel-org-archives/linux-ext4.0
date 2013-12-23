From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Mon, 23 Dec 2013 17:56:41 +1100
Message-ID: <20131223065641.GI3220@dastard>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:47504 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756742Ab3LWG4r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Dec 2013 01:56:47 -0500
Content-Disposition: inline
In-Reply-To: <20131223034554.GA11091@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
> The problem is that you've now pushed it off on the MM people.

I didn't comment on this before, but now I've had a bit of time to
think about it, it's become obvious to me that there is a
fundamental disconnect here.  To risk stating the obvious, but
persistent memory is just memory and someone has to manage it.

I'll state up front that I do spend a fair bit of time in memory
management code - all the shrinker scaling for NUMA systems that
landed recently was stuff I originally wrote. I'm spending time
reviewing patches to get memcg awareness into the shrinkers and
filesystem caches.  Persistent memory has a lot of overlap between
the MM and FS subsystems, just like shrinkers overlap lots of
different subsystems...

So from a filesystem perspective, we move data in and out of pages
of memory that are managed by the memory management subsystem, and
we move that data to and from filesystem blocks via an IO path.

The management of the memory that filesystems use is actually
the responsibility of the memory management subsystem - allocation,
reclaim, tracking, etc are all handled by the mm subsystem. That has
tendrils down into filesystem code - writeback for cleaning pages,
shrinkers for freeing inodes, dentries and other filesystem caches,
etc.

Persistent memory may be physically different to volatile memory,
but it is still exposed as byte addressable, mappable pages of
memory to the OS. Hence it could be treated in exactly the same way
that volatile memory pages are treated.

That is, a persistent memory device could be considered to be a
block device with a page sized sector. i.e. a 1:1 mapping between
the block device address space and the persistent memory page. A
filesystem tracks sectors in the block device address space with
filesystem metadata to expose the storage in a namespace, but that's
not the same thing as using managing how persistent memory is
exposed to virtual addresses in userspace. The former is data
indexing, the latter is a data access.

In terms of data indexing, the inode mapping tree is used to track
the relationship between the file offset of the user data, the
memory backing the data and the block index in the filesystem. That
realtionship is read from filesystem metadata.

For data access, the memory backing the data is tracked via
a struct page allocated out of volatile system memory. To get that
data to/from the backing storage, we need to perform an IO
operation on the memory backing the data, and we determine where to
get that from via the data index...

In the case of XIP, we still have the same data index relationship.
The difference is in the data access - XIP gets the backing memory
from the block device rather than from the free memory the VM.
However, we don't get a struct page - we get an opaque handle we
cannot use for data indexing purposes, and hence we need unique IO
paths to deal with this difference.

If the persistent memory device can hand us struct pages rather than
mapped memory handles, we don't need to change our data indexing
methods, nor do we need to change the way data in the page cache is
accessed. mmap() gets direct access, just like the current XIP, but
we can use all of the smarts filesystems have for optimal
block allocation.

Further, if the persistent memory device implements an IO implementation
(->make_request) like brd does (brd_make_request), then we get double
buffered persistent memory that we can use for things like stacked
IO devices that encode the data that is being stored. It all ends up
completely transparent to the filesystem, the mm subsystem, the
users, etc. XIP just works automatically when it can, otherwise it
just behaves like a really fast block device....

IOWs, I don't see XIP as something that should be tacked on to the
side of the filesystems and bypass the normal IO paths. it's
somethign that should be integrated directly and used automatically
if it can be used. And that requires persistent memory to be treated
as pages just like volatile memory.

That's how I see persistent memory fitting into the FS/MM world. It
needs help from both the FS and MM subsystems, and to try to
shoe-horn it completely into one or the other just won't work in the
long run.

The reality is that you're on a steep learning curve here, Willy.
What filesystems do and the way they interact with the MM subsystem
interact is a whole lot more complex that you realised.  I know that
XIP is not a new concept (I writing XIP stuff 20 years ago on 68000s
with a whole 6MB of battery backed SRAM), but filesystems and the
page cache have got a whole lot more complex since ext2....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
