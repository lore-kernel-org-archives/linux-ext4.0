From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Thu, 26 Aug 2010 17:06:19 +1000
Message-ID: <20100826070619.GC705@dastard>
References: <1282743090.2605.3696.camel@laptop>
 <alpine.DEB.2.00.1008251340420.16484@chino.kir.corp.google.com>
 <1282769729.1975.96.camel@laptop>
 <alpine.DEB.2.00.1008251406260.20253@chino.kir.corp.google.com>
 <1282771677.1975.138.camel@laptop>
 <alpine.DEB.2.00.1008251606450.31521@chino.kir.corp.google.com>
 <20100826001901.GL4453@thunk.org>
 <alpine.DEB.2.00.1008251724360.25783@chino.kir.corp.google.com>
 <20100826014847.GQ4453@thunk.org>
 <alpine.DEB.2.00.1008251951230.7034@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>,
	Jens Axboe <jaxboe@fusionio.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"cluster-devel@redhat.com" <cluster-devel@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: David Rientjes <rientjes@google.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008251951230.7034@chino.kir.corp.google.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 25, 2010 at 08:09:21PM -0700, David Rientjes wrote:
> On Wed, 25 Aug 2010, Ted Ts'o wrote:
> > > I think it's really sad that the caller can't know what the upper bounds 
> > > of its memory requirement are ahead of time or at least be able to 
> > > implement a memory freeing function when kmalloc() returns NULL.
> > 
> > Oh, we can determine an upper bound.  You might just not like it.
> > Actually ext3/ext4 shouldn't be as bad as XFS, which Dave estimated to
> > be around 400k for a transaction.  My guess is that the worst case for
> > ext3/ext4 is probably around 256k or so; like XFS, most of the time,
> > it would be a lot less.  (At least, if data != journalled; if we are
> > doing data journalling and every single data block begins with
> > 0xc03b3998U, we'll need to allocate a 4k page for every single data
> > block written.)  We could dynamically calculate an upper bound if we
> > had to.  Of course, if ext3/ext4 is attached to a network block
> > device, then it could get a lot worse than 256k, of course.
> > 
> 
> On my 8GB machine, /proc/zoneinfo says the min watermark for ZONE_NORMAL 
> is 5086 pages, or ~20MB.  GFP_ATOMIC would allow access to ~12MB of that, 
> so perhaps we should consider this is an acceptable abuse of GFP_ATOMIC as 
> a fallback behavior when GFP_NOFS or GFP_NOIO fails?

It would take a handful of concurrent transactions in XFS with
worst case memory allocation requirements to exhaust that pool, and
then we really would be in trouble.  Alternatively, it would take a
few allocations from each of a couple of thousand concurrent
transactions to get to the same point.

Bound memory pools only work when serialised access to the pool can
be enforced and there are no dependencies on other operations in
progress for completion of the work and freeing of the memory.
This is where it becomes exceedingly difficult to guarantee
progress.

One of the ideas that has floated around (I think Mel Gorman came up
with it first) was that if hardening the filesystem is so difficult,
why not just harden a single path via a single thread? e.g. we allow
the bdi flusher thread to have a separate reserve pool of free
pages, and when memory allocations start to fail, then that thread
can dip into it's pool to complete the writeback of the dirty pages
being flushed.  When a fileystem attaches to a bdi, it can specify
the size of the reserve pool it needs. 

This can be easily tested for during allocation (say a PF_ flag) and
switched to the reserve pool as necessary. because it is per-thread,
access to the pool is guaranteed to serialised. Memory reclaim can
then refill these pools before putting pages on freelists. This
could give us a mechanism for ensuring that allocations succeed in
the ->writepage path without needing to care about filesystem
implementation details.

And in the case of ext3/4, a pool could be attached to the jbd
thread as well so that it never starves of memory when commits are
required...

So, rather than turning filesystems upside down, maybe we should
revisit per-thread reserve pools for threads that are tasked with
cleaning pages for the VM?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
