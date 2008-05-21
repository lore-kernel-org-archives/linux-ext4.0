From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 4/4] ext4: call blkdev_issue_flush on fsync
Date: Wed, 21 May 2008 09:30:36 +0200
Message-ID: <20080521073036.GF2512@kernel.dk>
References: <482DDA56.6000301@redhat.com> <482DDC04.7020706@redhat.com> <20080520023454.GM15035@mit.edu> <20080520154313.GI16676@shareable.org> <20080520195437.GZ22369@kernel.dk> <20080520220242.GB27853@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080520220242.GB27853@shareable.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 20 2008, Jamie Lokier wrote:
> Jens Axboe wrote:
> > On Tue, May 20 2008, Jamie Lokier wrote:
> > > Does WRITE_BARRIER always cause a flush?  It does not have to
> > > according to Documentation/block/barrier.txt.  There are caveats about
> > > tagged queuing "not yet implemented" in the text, but can we rely on
> > > that?  The documentation is older than the current implementation;
> > > those caveats might no longer apply.
> > 
> > It does, if you use ordered tags then that assumes write through
> > caching (or ordered tag + drain + flush after completion).
> 
> Oh.  That's really unclear from the opening paragraph of barrier.txt,
> which _defines_ what I/O barriers are for, and does not mention flushing:
> 
>    I/O barrier requests are used to guarantee ordering around the barrier
>    requests.  Unless you're crazy enough to use disk drives for
>    implementing synchronization constructs (wow, sounds interesting...),
>    the ordering is meaningful only for write requests for things like
>    journal checkpoints.  All requests queued before a barrier request
>    must be finished (made it to the physical medium) before the barrier
>    request is started, and all requests queued after the barrier request
>    must be started only after the barrier request is finished (again,
>    made it to the physical medium).
> 
> So I assumed the reason flush is talked about later was only because
> most devices don't offer an alternative.

It may not mention flushing explicitly, but it does not have to since
the flushing is one way to implement what the above describes. Note how
it says that request must have made it to physical medium before
allowing others to continue? That means you have to either write through
or flush caches, otherwise you cannot make that guarentee.

> Later in barrier.txt, in the section about flushing, it says:
> 
>    the reason you use I/O barriers is mainly to protect filesystem
>    integrity when power failure or some other events abruptly stop the
>    drive from operating and possibly make the drive lose data in its
>    cache.  So, I/O barriers need to guarantee that requests actually
>    get written to non-volatile medium in order
> 
> Woa!  Nothing about flushing being important, just "to guarantee
> ... in order".
> 
> Thus flushing looks like an implementation detail - all we could do at
> the time.  It does not seem to be the _point_ of WRITE_BARRIER
> (according to the text), which is to ensure journalling integrity by
> ordering writes.

Yeah, that is precisely what it is and why it does not mention flushing
explicitly!

> Really, the main reason I was confused was that I imagine some
> SCSI-like devices letting you do partially ordered writes to
> write-back cache - with their cache preserving ordering constraints
> the same way as some CPU or database caches.  (Perhaps I've been
> thinking about CPUs too long!)

Right, that is what ordered tags give you. But if you have write back
caching enabled, then you get a completion event before the data is
actually on disk. Perhaps that is OK for some cases, perhaps not. The
Linux barrier implementation has always guarenteed that the data is
actually on platter before considering a barrier write done, as
described in the text you quote.

> Anyway, moving on....  Let's admit I am wrong about that :-)
> 
> And get back to my idea.  Ignoring actual disks for a moment ( ;-) ),
> there are some I/O scheduling optimisations possible in the kernel
> itself by distinguishing between barriers (for journalling) and
> flushes (for fsync).
> 
> Basically, barriers can be moved around between ordered writes,
> including postponing indefinitely (i.e. a "needs barrier" flag).
> Unordered writes (in-place data?) can be reordered somewhat around
> barriers and other writes.  Nobody should wait for a barrier to complete.
> 
> On the other hand, flushes must be issued soon, and fdatasync/fsync
> wait for the result.  Reordering possibilities are different: all
> writes can be moved before a flush (unless it's a barrier too), and
> in-place data writes cannot be moved after one.
> 
> Both barriers and flushes can be merged if there are no intervening
> writes except unordered writes.  Double flushing, e.g. calling fsync
> twice, or calling blkdev_issue_flush just to be sure somewhere,
> shouldn't have any overhead.
> 
> The request elevator seems a good place to apply those heuristics.
> I've written earlier about how to remove some barriers from ext3/4
> journalling.  This stuff seems to suggest even more I/O scheduling
> optimisations with tree-like journalling (as in BTRFS?).

There are some good ideas in there, I'll punt that to the fs people.
Ignoring actual disk drives makes things easier :-). While SCSI has
ordered IO with write back caching, SATA does not. You basically have to
drain and flush there, or use one of the other variants for getting data
in disk - see blkdev.h:

        /*
         * Hardbarrier is supported with one of the following methods.
         *
         * NONE         : hardbarrier unsupported
         * DRAIN        : ordering by draining is enough
         * DRAIN_FLUSH  : ordering by draining w/ pre and post flushes
         * DRAIN_FUA    : ordering by draining w/ pre flush and FUA
         * write
         * TAG          : ordering by tag is enough
         * TAG_FLUSH    : ordering by tag w/ pre and post flushes
         * TAG_FUA      : ordering by tag w/ pre flush and FUA write

-- 
Jens Axboe

