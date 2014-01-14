From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: high write latency bug in ext3 / jbd in 3.4
Date: Mon, 13 Jan 2014 20:21:21 -0500
Message-ID: <20140114012121.GF1214@kvack.org>
References: <20140113201320.GD1214@kvack.org> <99F82313-71DA-43E6-A071-05507183D481@dilger.ca> <20140113211610.GE1214@kvack.org> <20140113225219.GD11207@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:49748 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbaANBVV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jan 2014 20:21:21 -0500
Content-Disposition: inline
In-Reply-To: <20140113225219.GD11207@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 13, 2014 at 05:52:19PM -0500, Theodore Ts'o wrote:
> On Mon, Jan 13, 2014 at 04:16:10PM -0500, Benjamin LaHaise wrote:
> > 
> > I'm leaning towards doing this.  The main reason for not doing so was 
> > primarily that a few of the tweaks that I had been made to ext3 would 
> > have to be ported to ext4.  Thankfully, I think we're still in an early 
> > enough stage of release that I should be able to do so.  The changes 
> > are pretty specific, mostly allocator tweaks to improve the on-disk 
> > layout for our specific use-case.
> 
> We have been thinking about making some changes to the block
> allocator, so I'd be interested in hearing what tweaks you made and a
> bit more about your use case that drove the need for these allocator
> tweaks.

The main layout tweak is pretty specific to the ext2/3 style indirect / 
double indirect block usage: instead of placing the ind/dind/tind blocks 
throughtout the file, they are all placed immediately before the first 
data block at fallocate() time.  With that change in place, all of the 
metadata blocks are then read at the same time the first page of the file is 
read.  The reason for doing this is that our spoolfiles have a header at 
the beginning of the file that must always be read before we can find where 
the data needed from the file is.  By pulling in the metadata at the same 
time as the first data block, the number of seeks to get data elsewhere in 
the file is reduced (as some requests are essentially random).  It also has 
a nice side effect of speeding up unlink and fsck times.

The other allocator change which is more relevant to ext4 is to not use 
orlov on subdirectories of the filesystem.  There is a notable performance 
difference when inodes are spread out across the filesystem.  Our usage 
pattern tends to be somewhat close to FIFO for the files written and later 
read & deleted.

There are some other bits I plan to post shortly as well, including a fully 
async implementation of readpage for use with ext2/3 style metadata.  It was 
necessary to make async reads fully non-blocking in order to hit the 
performance targets, as switching to helper threads incurred a significant 
amount of overhead compared to having aio completions from the interrupt 
handler of the block device.  I also did async read and readahead 
implementations tied into aio.  Development on the release I'm working on 
is mostly done now, so I should have the time over the next few weeks to 
clean up and merge these changes to 3.13.

> > I had hoped to use ext4, but the recommended fsck after changing the 
> > various feature bits is a non-starter during our upgrade process (a 22 
> > minute outage isn't acceptable).
> 
> You can move to ext4 without necessarily using those features which
> require an fsck after the upgrade process.  That's hwo we handled the
> upgrade to ext4 at Google.  New disks were formatted using ext4, but
> for legacy file systems, we enabled extents feature (maybe one or two
> other ones, but that was the main one) and then remounted those file
> systems using ext4.  We called file systems which were upgraded in
> this way "ext2-as-ext4", and our benchmarking indicated that for our
> workload, that "ext2-as-ext4" got roughly half the performance gained
> when comparing file systems still using ext2 with newly formated file
> systems using ext4.

Another reason for not being able to migrate to extents is that it breaks 
the ability of our system to be downgraded smoothly.  The previous kernel 
being used was of 2.6.18 vintage, so this is the first version of our 
product that supports using ext4.  There were also concerns about testing 
both the extent and non-extent code paths as well -- regression tests take 
months to complete, so adding a times 2 multiplier to everything is a hard 
sell.

> Given that file systems on a server got reformatted when it needs some
> kind of hardware repairs, betewen hardware refresh and disks getting
> reformatted as part of the refresh, the percentage of file systems
> running in "ext2-as-ext4" dropped fairly quickly.

Our filesystems are, unfortunately, rather long lived.

> Mike Rubin gave a presentation about this two years ago at the LF
> Collab Summit that went into a lot more detail about how ext4 was
> adopted by Google.  That presentation is available here:
> 
> 	http://www.youtube.com/watch?v=Wp5Ehw7ByuU

Thanks -- I'll pass that along to folks here at Solace.

		-ben

> Cheers,
> 
> 						- Ted

-- 
"Thought is the essence of where you are now."
