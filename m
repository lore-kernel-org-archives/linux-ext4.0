From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.2 and 3.1 filesystem scalability measurements
Date: Wed, 1 Feb 2012 07:40:58 +1100
Message-ID: <20120131204058.GL9090@dastard>
References: <4F261807.2060108@hp.com>
 <4F26B395.6020607@gmail.com>
 <EC79BE65-4CC7-473F-A5EF-193425F62178@dilger.ca>
 <20120131001415.GC9090@dastard>
 <20120131112726.GC3867@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"aziro.linux.adm" <aziro.linux.adm@gmail.com>,
	Eric Whitney <eric.whitney@hp.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:34669 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753213Ab2AaUlB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jan 2012 15:41:01 -0500
Content-Disposition: inline
In-Reply-To: <20120131112726.GC3867@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 31, 2012 at 07:27:26PM +0800, Wu Fengguang wrote:
> On Tue, Jan 31, 2012 at 11:14:15AM +1100, Dave Chinner wrote:
> > On Mon, Jan 30, 2012 at 01:30:09PM -0700, Andreas Dilger wrote:
> > > On 2012-01-30, at 8:13 AM, aziro.linux.adm wrote:
> > > > Is it possible to be said - XFS shows the best average results over the
> > > > test.
> > > 
> > > Actually, I'm pleasantly surprised that ext4 does so much better than XFS
> > > in the large file creates workload for 48 and 192 threads.  I would have
> > > thought that this is XFS's bread-and-butter workload that justifies its
> > > added code complexity (many threads writing to a multi-disk RAID array),
> > > but XFS is about 25% slower in that case.  Conversely, XFS is about 25%
> > > faster in the large file reads in the 192 thread case, but only 15% faster
> > > in the 48 thread case.  Other tests show much less significant differences,
> > > so in summary I'd say it is about even for these benchmarks.
> > 
> > It appears to me from running the test locally that XFS is driving
> > deeper block device queues, and has a lot more writeback pages and
> > dirty inodes outstanding at any given point in time. That indicates
> > the storage array is the limiting factor to me, not the XFS code.
> > 
> > Typical BDI writeback state for ext4 is this:
> > 
> > BdiWriteback:            73344 kB
> > BdiReclaimable:         568960 kB
> > BdiDirtyThresh:         764400 kB
> > DirtyThresh:            764400 kB
> > BackgroundThresh:       382200 kB
> > BdiDirtied:          295613696 kB
> > BdiWritten:          294971648 kB
> > BdiWriteBandwidth:      690008 kBps
> > b_dirty:                    27
> > b_io:                       21
> > b_more_io:                   0
> > bdi_list:                    1
> > state:                      34
> > 
> > And for XFS:
> > 
> > BdiWriteback:           104960 kB
> > BdiReclaimable:         592384 kB
> > BdiDirtyThresh:         768876 kB
> > DirtyThresh:            768876 kB
> > BackgroundThresh:       384436 kB
> > BdiDirtied:          396727424 kB
> > BdiWritten:          396029568 kB
> > BdiWriteBandwidth:      668168 kBps
> > b_dirty:                    43
> > b_io:                       53
> > b_more_io:                   0
> > bdi_list:                    1
> > state:                      34
> > 
> > So XFS is has substantially more pages under writeback at any given
> > point in time, has more inodes dirty, but has slower throughput.  I
> > ran some traces on the writeback code and confirmed that the number
> > of writeback pages is different - ext4 is at 16-20,000, XFS is at
> > 25-30,000 for the entire traces.
> 
> Attached are two nr_writeback (the green line) graphs for test cases
> 
>         xfs-1dd-1-3.2.0-rc3
>         ext4-1dd-1-3.2.0-rc3

The above numbers came from a 48-thread IO workload, not a single
thread, so I'm not really sure how much these will reflect the
behaviour of workload in question.

> Where I notice that the lower nr_writeback segments of XFS equal to
> the highest points of ext4, which should be decided by the block queue
> size.
> 
> XFS seems to clear PG_writeback long after (up to 0.5s) IO completion
> in big batches. This is one of the reason why XFS has higher nr_writeback
> on average.

Hmmm, that implies a possible workqueue starvation to me. IO
completions are processed in a workqueue, but that shouldn't be held
off for that long....

> The other two graphs show the writeback chunk size: ext4 is consistently
> 128MB while XFS is mostly 32MB. So it is somehow unfair comparison:
> ext4 has code to force 128MB in its write_cache_pages(), while XFS
> uses the smaller generic size "0.5s worth of data" computed in
> writeback_chunk_size().

Right - I noticed that too, but didn't really think it mattered all
that much because the actual amount of pages being written per inode
in the traces from my workload were effectively identical. i.e. the
windup was irrelevant because wbc->nr_to_write being sent by the VFS
writeback was nowhere near being exhausted.

BTW, the ext4 comment about why it does this seems a bit out of date,
too. Especially the bit about "XFS does this" but the only time XFS
did this was as a temporary work for around other writeback issues
(IIRC between .32 and .35) that have long since been fixed.

Cheers,

Dave.





-- 
Dave Chinner
david@fromorbit.com
