From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 4/4] ext4: call blkdev_issue_flush on fsync
Date: Tue, 20 May 2008 23:02:42 +0100
Message-ID: <20080520220242.GB27853@shareable.org>
References: <482DDA56.6000301@redhat.com> <482DDC04.7020706@redhat.com> <20080520023454.GM15035@mit.edu> <20080520154313.GI16676@shareable.org> <20080520195437.GZ22369@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080520195437.GZ22369@kernel.dk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jens Axboe wrote:
> On Tue, May 20 2008, Jamie Lokier wrote:
> > Does WRITE_BARRIER always cause a flush?  It does not have to
> > according to Documentation/block/barrier.txt.  There are caveats about
> > tagged queuing "not yet implemented" in the text, but can we rely on
> > that?  The documentation is older than the current implementation;
> > those caveats might no longer apply.
> 
> It does, if you use ordered tags then that assumes write through
> caching (or ordered tag + drain + flush after completion).

Oh.  That's really unclear from the opening paragraph of barrier.txt,
which _defines_ what I/O barriers are for, and does not mention flushing:

   I/O barrier requests are used to guarantee ordering around the barrier
   requests.  Unless you're crazy enough to use disk drives for
   implementing synchronization constructs (wow, sounds interesting...),
   the ordering is meaningful only for write requests for things like
   journal checkpoints.  All requests queued before a barrier request
   must be finished (made it to the physical medium) before the barrier
   request is started, and all requests queued after the barrier request
   must be started only after the barrier request is finished (again,
   made it to the physical medium).

So I assumed the reason flush is talked about later was only because
most devices don't offer an alternative.

Later in barrier.txt, in the section about flushing, it says:

   the reason you use I/O barriers is mainly to protect filesystem
   integrity when power failure or some other events abruptly stop the
   drive from operating and possibly make the drive lose data in its
   cache.  So, I/O barriers need to guarantee that requests actually
   get written to non-volatile medium in order

Woa!  Nothing about flushing being important, just "to guarantee
... in order".

Thus flushing looks like an implementation detail - all we could do at
the time.  It does not seem to be the _point_ of WRITE_BARRIER
(according to the text), which is to ensure journalling integrity by
ordering writes.

Really, the main reason I was confused was that I imagine some
SCSI-like devices letting you do partially ordered writes to
write-back cache - with their cache preserving ordering constraints
the same way as some CPU or database caches.  (Perhaps I've been
thinking about CPUs too long!)

Anyway, moving on....  Let's admit I am wrong about that :-)

And get back to my idea.  Ignoring actual disks for a moment ( ;-) ),
there are some I/O scheduling optimisations possible in the kernel
itself by distinguishing between barriers (for journalling) and
flushes (for fsync).

Basically, barriers can be moved around between ordered writes,
including postponing indefinitely (i.e. a "needs barrier" flag).
Unordered writes (in-place data?) can be reordered somewhat around
barriers and other writes.  Nobody should wait for a barrier to complete.

On the other hand, flushes must be issued soon, and fdatasync/fsync
wait for the result.  Reordering possibilities are different: all
writes can be moved before a flush (unless it's a barrier too), and
in-place data writes cannot be moved after one.

Both barriers and flushes can be merged if there are no intervening
writes except unordered writes.  Double flushing, e.g. calling fsync
twice, or calling blkdev_issue_flush just to be sure somewhere,
shouldn't have any overhead.

The request elevator seems a good place to apply those heuristics.
I've written earlier about how to remove some barriers from ext3/4
journalling.  This stuff seems to suggest even more I/O scheduling
optimisations with tree-like journalling (as in BTRFS?).

-- Jamie
