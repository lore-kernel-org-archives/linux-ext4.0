From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2.4 0/3] mm/fs: Remove unnecessary waiting for stable
 pages
Date: Thu, 17 Jan 2013 17:18:51 -0800
Message-ID: <20130118011851.GM6426@blackbox.djwong.org>
References: <20130115054235.1563.12967.stgit@blackbox.djwong.org>
 <20130115144608.722180b7.akpm@linux-foundation.org>
 <20130116002246.GI6426@blackbox.djwong.org>
 <20130115163359.16d64ab4.akpm@linux-foundation.org>
 <20130117024902.GJ6426@blackbox.djwong.org>
 <20130116204352.9d343964.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	tytso@mit.edu, viro@zeniv.linux.org.uk, rminnich@sandia.gov,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	gnehzuil.liu@gmail.com, linux-kernel@vger.kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	linux-ext4@vger.kernel.org, hirofumi@mail.parknet.co.jp
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43352 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3ARBVF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2013 20:21:05 -0500
Content-Disposition: inline
In-Reply-To: <20130116204352.9d343964.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 16, 2013 at 08:43:52PM -0800, Andrew Morton wrote:
> On Wed, 16 Jan 2013 18:49:02 -0800 "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> 
> > > 
> > > The problem back in 2001 was that we held lock_page() across the
> > > duration of page writeback, so if another thread came in and tried to
> > > dirty the page, it would block on lock_page() until IO completion.  I
> > > can't remember whether writeback would also block read().  Maybe it did,
> > > in which case the effects of this patchset won't be as dramatic as were
> > > the effects of splitting PG_lock into PG_lock and PG_writeback.
> > 
> > Now that you've stirred my memory, I /do/ dimly recall that Linux waited for
> > writeback back in the old days.  At least we'll be back to that.

That was a thinko.  "...we'll be back to 2.6.39." is what I meant.

> Not really.  2.4 did writeback by walking a standalone list of
> buffer_heads, without locking their containing page.  I removed all
> that and did writeback of the page instead.  That immediately caused
> this problem, because the 2.4 writepage held lock_page() across
> writeout.  So I changed that to drop lock_page() immediately after
> submission and added PG_writeback to flag the under-writeback state. 
> The second change went in pretty much immediately - all within the
> same 2.5.x release, probably.
> 
> > As a side note, the average latency of a write to a non-DIF disk dropped down
> > to nearly nothing.
> 
> Some hard numbers in the changelog would be nice.  Did you try dbench-on-ext2?

Yes, here's the result of dbench on ext2:

3.8.0-rc3:
 Operation      Count    AvgLat    MaxLat
 ----------------------------------------
 WriteX        109347     0.028    59.817
 ReadX         347180     0.004     3.391
 Flush          15514    29.828   287.283

Throughput 57.429 MB/sec  4 clients  4 procs  max_latency=287.290 ms

3.8.0-rc3 + patches:
 WriteX        105556     0.029     4.273
 ReadX         335004     0.005     4.112
 Flush          14982    30.540   298.634

Throughput 55.4496 MB/sec  4 clients  4 procs  max_latency=298.650 ms

As you can see, for ext2 the maximum write latency decreases from ~60ms on a
laptop hard disk to ~4ms.  I'm not sure why the flush latencies increase,
though I suspect that being able to dirty pages faster gives the flusher more
work to do.

Here's what you get on ext4:

3.8.0-rc3:
 WriteX         85624     0.152    33.078
 ReadX         272090     0.010    61.210
 Flush          12129    36.219   168.260

Throughput 44.8618 MB/sec  4 clients  4 procs  max_latency=168.276 ms

3.8.0-rc3 + patches:
 WriteX         86082     0.141    30.928
 ReadX         273358     0.010    36.124
 Flush          12214    34.800   165.689

Throughput 44.9941 MB/sec  4 clients  4 procs  max_latency=165.722 ms

Here the average write latency goes down, and all maximum latencies drop too.

Just for kicks, here's XFS:

3.8.0-rc3:
 WriteX        125739     0.028   104.343
 ReadX         399070     0.005     4.115
 Flush          17851    25.004   131.390

Throughput 66.0024 MB/sec  4 clients  4 procs  max_latency=131.406 ms

3.8.0-rc3 + patches:
 WriteX        123529     0.028     6.299
 ReadX         392434     0.005     4.287
 Flush          17549    25.120   188.687

Throughput 64.9113 MB/sec  4 clients  4 procs  max_latency=188.704 ms

Hey look, dramatically lower maximum latencies for writes, though flushes seem
slower.

...and btrfs, just to round it out:

3.8.0-rc3:
 WriteX         67122     0.083    82.355
 ReadX         212719     0.005     2.828
 Flush           9547    47.561   147.418

Throughput 35.3391 MB/sec  4 clients  4 procs  max_latency=147.433 ms

3.8.0-rc3 + patches:
 WriteX         64898     0.101    71.631
 ReadX         206673     0.005     7.123
 Flush           9190    47.963   219.034

Throughput 34.0795 MB/sec  4 clients  4 procs  max_latency=219.044 ms

Same kinds of results here, though the increase in max read latency is a little
troubling.

> > > Do we generate nice kernel messages (at mount or device-probe time)
> > > which will permit people to work out which strategy their device/fs is
> > > using?
> > 
> > No.  /sys/devices/virtual/bdi/*/stable_pages_required will tell you
> > stable pages are on or not, but so far only ext3 uses snapshots and the rest
> > just wait.  Do you think a printk would be useful?
> 
> Nope, if we can query the mode under /sys then that should be sufficient.

Ok.

--D
