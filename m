From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.2 and 3.1 filesystem scalability measurements
Date: Tue, 31 Jan 2012 11:14:15 +1100
Message-ID: <20120131001415.GC9090@dastard>
References: <4F261807.2060108@hp.com>
 <4F26B395.6020607@gmail.com>
 <EC79BE65-4CC7-473F-A5EF-193425F62178@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "aziro.linux.adm" <aziro.linux.adm@gmail.com>,
	Eric Whitney <eric.whitney@hp.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:37830 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903Ab2AaAOU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jan 2012 19:14:20 -0500
Content-Disposition: inline
In-Reply-To: <EC79BE65-4CC7-473F-A5EF-193425F62178@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 30, 2012 at 01:30:09PM -0700, Andreas Dilger wrote:
> On 2012-01-30, at 8:13 AM, aziro.linux.adm wrote:
> > Is it possible to be said - XFS shows the best average results over the
> > test.
> 
> Actually, I'm pleasantly surprised that ext4 does so much better than XFS
> in the large file creates workload for 48 and 192 threads.  I would have
> thought that this is XFS's bread-and-butter workload that justifies its
> added code complexity (many threads writing to a multi-disk RAID array),
> but XFS is about 25% slower in that case.  Conversely, XFS is about 25%
> faster in the large file reads in the 192 thread case, but only 15% faster
> in the 48 thread case.  Other tests show much less significant differences,
> so in summary I'd say it is about even for these benchmarks.

It appears to me from running the test locally that XFS is driving
deeper block device queues, and has a lot more writeback pages and
dirty inodes outstanding at any given point in time. That indicates
the storage array is the limiting factor to me, not the XFS code.

Typical BDI writeback state for ext4 is this:

BdiWriteback:            73344 kB
BdiReclaimable:         568960 kB
BdiDirtyThresh:         764400 kB
DirtyThresh:            764400 kB
BackgroundThresh:       382200 kB
BdiDirtied:          295613696 kB
BdiWritten:          294971648 kB
BdiWriteBandwidth:      690008 kBps
b_dirty:                    27
b_io:                       21
b_more_io:                   0
bdi_list:                    1
state:                      34

And for XFS:

BdiWriteback:           104960 kB
BdiReclaimable:         592384 kB
BdiDirtyThresh:         768876 kB
DirtyThresh:            768876 kB
BackgroundThresh:       384436 kB
BdiDirtied:          396727424 kB
BdiWritten:          396029568 kB
BdiWriteBandwidth:      668168 kBps
b_dirty:                    43
b_io:                       53
b_more_io:                   0
bdi_list:                    1
state:                      34

So XFS is has substantially more pages under writeback at any given
point in time, has more inodes dirty, but has slower throughput.  I
ran some traces on the writeback code and confirmed that the number
of writeback pages is different - ext4 is at 16-20,000, XFS is at
25-30,000 for the entire traces.

I also found this oddity on both XFS and ext4:

    flush-253:32-3400  [001] 1936151.384563: writeback_start:      bdi 253:32: sb_dev 0:0 nr_pages=-898403 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=background
    flush-253:32-3400  [005] 1936151.455845: writeback_start:      bdi 253:32: sb_dev 0:0 nr_pages=-911663 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=background
    flush-253:32-3400  [006] 1936151.596298: writeback_start:      bdi 253:32: sb_dev 0:0 nr_pages=-931332 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=background
    flush-253:32-3400  [006] 1936151.719074: writeback_start:      bdi 253:32: sb_dev 0:0 nr_pages=-951001 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=background

That's indicating the work->nr_pages is starting extremely negative,
which should not be the case. The highest I saw was around -2m.
Something is not working right there, as writeback is supposed to
terminate if work->nr_pages < 0....

As it is, writeback is being done in chunks of roughly 6400-7000 pages
per inode, which is relatively large chunks and probably all the
dirty pages on the inode because wbc->nr_to_write == 24576 is being
passed to .writepage. ext4 is slightly higher than XFS, which is no
surprise if there are less dirty inodes in memory than for XFS.

So why is there a difference in performance? Well, ext4 is simply
interleaving allocations based on the next file that is written
back. i.e:

    +------------+-------------+-------------+--- ...
    | A {0,24M}  | B {0, 24M}  | C {0, 24M}  | D ....
    +------------+-------------+-------------+--- ...

And as it moves along, we end up with:

    ... +-------------+--------------+--------------+--- ...
    ... | A {24M,24M} | B {24M, 24M} | C {24M, 24M} | D ....
    ... +-------------+--------------+--------------+--- ...

The result is ext4 is avergaing 41 extents per 1GB file, but writes
are effectively sequential. That's good for bandwidth, not so good
for keeping fragmentation under control.

XFS is behaving differently. It is using speculative preallocation
to form larger than per-writeback instance extents. It results in
some interleaving of extents, but files tend to look like this:

datafile1:
 EXT: FILE-OFFSET         BLOCK-RANGE        AG AG-OFFSET             TOTAL FLAGS
   0: [0..65535]:         546520..612055      0 (546520..612055)      65536 00000
   1: [65536..131071]:    1906392..1971927    0 (1906392..1971927)    65536 00000
   2: [131072..262143]:   5445336..5576407    0 (5445336..5576407)   131072 00000
   3: [262144..524287]:   14948056..15210199  0 (14948056..15210199) 262144 00000
   4: [524288..1048575]:  34084568..34608855  0 (34084568..34608855) 524288 00000
   5: [1048576..1877407]: 68163288..68992119  0 (68163288..68992119) 828832 00000

(32MB, 32MB, 64MB, 128MB, 256MB, 420MB sized extents at sample time)

and the average number of extents per file is 6.3. Hence there is
more seeking during XFS writes because it is not allocating space
according to the exact writeback pattern that is being driven by the
VFS.

On my test setup, the difference in throughput was negliable with
ffsb reporting 683MB/s for ext4 and 672MB/s for XFS at 48 threads.
However, I tested on a machine with only 4GB of RAM, which means
that writeback is being done in much smaller chunks per file than
Eric's results. That means that XFS will be doing much larger
speculative preallocation per file before writeback begins, so will
be allocating much larger extents from the start.

This will separate the per-file writeback regions extents further
than my test, increasing seek distances and so should show more of a
seek cost on larger RAM machines given the same storage.  Therefore,
on a machine with 256GB RAM, the differential between sequential
allocation per writeback call (i.e. interleaving across inodes) as
ext4 does and the minimal fragmentation approach XFS takes will be
more significant.  We can see that from Eric's results, too.

However, given a large enough storage subsystem, this seek penalty
is effectively non-existent so is a fair tradeoff for a filesystem
that is expected to be used on machines with hundreds of drives
behind the filesystem. The seek penalty is also non-existent on
SSDs, so the lower allocation and metadata overhead of creating
larger extents is a win there as well...

Of course, the obvious measurable difference as a result of these
writeback patterans is when it comes to reading back the files. XFs
will have all 6-7 extents in-line in the inode, so require no
additional IO to read the extent list. The XFS files are more
contiguous than ext4, so sequential reads will seek less. Hence the
concurrent read loads perform better than ext4, as also seen in
Eric's tests.

> It is also interesting to see the ext4-nojournal performance as a baseline
> to show what performance is achievable on the hardware by any filesystem,
> but I don't think it is necessarily a fair comparison with the other test
> configurations, since this mode is not usable for most real systems.  It
> gives both ext4-journal and XFS a target for improvement, by reducing the
> overhead of metadata consistency.

Maximum write bandwidth is not necessarily the goal we want to
acheive. Good write bandwidth, definitely, but experience has shown
that prevention of writeback starvation and excessive fragmentation
helps to ensure we can maintain that level of performance over the
life of the filesystem. That's just as important (if not more
important) than maximising ultimate write speed for most production
deployments....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
