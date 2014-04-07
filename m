From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 performance falloff
Date: Mon, 7 Apr 2014 16:19:35 +0200
Message-ID: <20140407141935.GA22171@quack.suse.cz>
References: <533EE547.3030504@numascale.com>
 <20140404205604.GC10275@thunk.org>
 <533F7851.30803@numascale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Steffen Persvold <sp@numascale.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Daniel J Blueman <daniel@numascale.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945AbaDGOTj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Apr 2014 10:19:39 -0400
Content-Disposition: inline
In-Reply-To: <533F7851.30803@numascale.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 05-04-14 11:28:17, Daniel J Blueman wrote:
> On 04/05/2014 04:56 AM, Theodore Ts'o wrote:
> >On Sat, Apr 05, 2014 at 01:00:55AM +0800, Daniel J Blueman wrote:
> >>On a larger system 1728 cores/4.5TB memory and 3.13.9, I'm seeing very low
> >>600KB/s cached write performance to a local ext4 filesystem:
> 
> > Thanks for the heads up.  Most (all?) of the ext4 don't have systems
> > with thousands of cores, so these issues generally don't come up for
> > us, and so we're not likely (hell, very unlikely!) to notice potential
> > problems cause by these sorts of uber-large systems.
> 
> Hehe. It's not every day we get access to these systems also.
> 
> >>Analysis shows that ext4 is reading from all cores' cpu-local data (thus
> >>expensive off-NUMA-node access) for each block written:
> >>
> >>if (free_clusters - (nclusters + rsv + dirty_clusters) <
> >>				EXT4_FREECLUSTERS_WATERMARK) {
> >>	free_clusters  = percpu_counter_sum_positive(fcc);
> >>	dirty_clusters = percpu_counter_sum_positive(dcc);
> >>}
> >>
> >>This threshold is defined as:
> >>
> >>#define EXT4_FREECLUSTERS_WATERMARK (4 * (percpu_counter_batch *
> >>nr_cpu_ids))
> ...
> >The problem we are trying to solve here is that when we do delayed
> >allocation, we're making an implicit promise that there will be space
> >available
> >
> >I've done the calculations, and 4 * 32 * 1728 cores = 221184 blocks,
> >or 864 megabytes.  That would mean that the file system is over 98%
> >full, so that's actually pretty reasonable; most of the time there's
> >more free space than that.
> 
> The filesystem is empty after the mkfs; the approach here may make
> sense if we want to allow all cores to write to this FS, but here we
> have one.
> 
> Instrumenting shows that free_clusters=16464621 nclusters=1
> rsv=842790 dirty_clusters=0 percpu_counter_batch=3456
> nr_cpu_ids=1728; below 91GB space, we'd hit this issue. It feels
> more sensible to start this behaviour when the FS is say 98% full,
> irrespective of the number of cores, but that's not why the
> behaviour is there.
  Yeah, percpu_counter_batch = max(32, nr*2) so the value you observe is
correct and EXT4_FREECLUSTERS_WATERMARK is then 23887872 ~= 95 GB. Clearly
we have to try to be more clever on these large systems.

> Since these block devices are attached to a single NUMA node's IO
> link, there is a scaling limitation there anyway, so there may be
> rationale in limiting this to use min(256,nr_cpu_ids) maybe?
  Well, but when you get something "allocated" from the counter, we rely on
the space being really available in the filesystem (so that delayed
allocated blocks can be allocated and written out). With this limitation to
256 if there is more that 256*percpu_counter_patch accumulated in the
percpu part of the counter, we could promise allocating something we don't
really have space for. And I understand this is unlikely but when we speak
about "your data is lost", even unlikely doesn't sound good to people. They
want "this can never happen" promises :)

What we really need is a counter where we can better estimate counts
accumulated in the percpu part of it. As the counter approaches zero, it's
CPU overhead will have to become that of a single locked variable but when
the value of counter is relatively high, we want it to be fast as the
percpu one. Possibly, each CPU could "reserve" part of the value in the
counter (by just decrementing the total value; how large that part should
be really needs to depend to the total value of the counter and number of
CPUs - in this regard we really differ from classical percpu couters) and
allocate/free using that part. If CPU cannot reserve what it is asked for
anymore, it would go and steal from parts other CPUs have accumulated,
returning them to global pool until it can satisfy the allocation.

But someone would need to try whether this really works out reasonably fast
:).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
