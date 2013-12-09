From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/4] ext4: Add XIP functionality
Date: Mon, 9 Dec 2013 19:19:40 +1100
Message-ID: <20131209081940.GW10988@dastard>
References: <1386273769-12828-1-git-send-email-ross.zwisler@linux.intel.com>
 <1386273769-12828-3-git-send-email-ross.zwisler@linux.intel.com>
 <20131206031354.GS10988@dastard>
 <1386558964.6872.14.camel@gala>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	carsteno@de.ibm.com, matthew.r.wilcox@intel.com,
	andreas.dilger@intel.com
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40293 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752693Ab3LIITr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Dec 2013 03:19:47 -0500
Content-Disposition: inline
In-Reply-To: <1386558964.6872.14.camel@gala>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 08, 2013 at 08:16:04PM -0700, Ross Zwisler wrote:
> On Fri, 2013-12-06 at 14:13 +1100, Dave Chinner wrote:
> > On Thu, Dec 05, 2013 at 01:02:46PM -0700, Ross Zwisler wrote:
> > > This is a port of the XIP functionality found in the current version of
> > > ext2.  This patch set is intended to achieve feature parity with XIP in
> > > ext2 rather than non-XIP in ext4.  In particular, it lacks support for
> > > splice and AIO.  We'll be submitting patches in the future to add that
> > > functionality, but we think this is a good start.
> > > 
> > > The motivation behind this work is that we believe that the XIP feature
> > > will begin to find new uses as various persistent memory devices and
> > > technologies come on to the market.  Having direct, byte-addressable
> > > access to persistent memory without having an additional copy in the
> > > page cache can be a win in terms of I/O latency and overall memory
> > > usage.
> > > 
> > > This patch applies cleanly to v3.13-rc2, and was tested using brd as our
> > > block driver.
> > 
> > I think I see a significant problem here with XIP write support:
> > unwritten extents.
> > 
> > xip_file_write() has no concept of post IO completion processing -
> > it assumes that all that is necessary is to memcpy() the data into
> > the backing memory obtained by ->get_xip_mem(), and that's all it
> > needs to do.
> > 
> > For ext4 (and other filesystems that use unwritten extents) they
> > need a callback - normally done from bio completion - to run
> > transactions to convert extent status from unwritten to written, or
> > run other post-IO completion operations.
> > 
> > I don't see any hooks into ext4 to turn off preallocation (e.g.
> > fallocate is explicitly hooked up for XIP) when XIP is in use, so I
> > can't see how XIP can work with such filesystem requirements without
> > further infrastructure being added. i.e. bypassing the need for the
> > page cache does not remove the need to post-IO completion
> > notification to the filesystem....
> > 
> > Indeed, for making filesystems like XFS be able to use XIP, we're
> > going to need such facilities to be provided by the XIP
> > infrastructure....
> > 
> > Cheers,
> > 
> > Dave.
> 
> Hi Dave,
> 
> You're absolutely correct, unwritten extents are an issue that was
> overlooked.  Thank you very much for pointing this out!
> 
> My best guess on how to fix this (as proposed by Matthew) is to wrap the
> generic code in ext4 specific code that deals with unwritten extents.

I completely disagree.

We already have a generic method in the filesystems for handling
post-IO completion processing, and we most definitely do not want to
have to implement it again in every filesystem that wants to support
XIP.

Set up the generic XIP infrastructure in a way that allows the
filesystem to set up post-IO callbacks at submission time and call
them on IO completion.  We manage to do this for both buffered data
IO and direct IO, and I don't see how XIP IO is any different from
this perspective. XIP still costs time and latency to execute, and
if we start to think about hardware offload of large memcpy()s (say
like the SGI Altix machines could do years ago) asychronous
processing in the XIP IO path is quite likely to be used in the
near future.

So, it's pretty clear to me that XIP needs to look like a normal IO
path from a filesystem perspective - it's not necessarily
synchronous, we need concurrent read and write support (i.e. the
equivalent of current direct IO capabilities on XFS where we can
already do millions of mixed read and write IOPS to the same file
on a ram based block device), and so on. XIP doesn't fundamentally
change the way filesystems work, and so we shoul dbe treating XIP in
a similar fashion to how we treat buffered and direct IO.

Indeed, the direct IO model is probably the best one to use here -
it allows the filesystem to attach it's own private data structure
to the kiocb, and it gets an IO completion callback with the kiocb,
the offset and size of the IO, and we can pull the filesystem
private data off the iocb and then pass it into existing normal IO
completion paths.

> For writes, I think that we need to potentially split the unwritten
> extent in to up to three extents (two unwritten, one written), in the
> spirit of the ext4_split_unwritten_extents().

You don't need to touch anything that deep in ext4 to make this
work. What you need to do is make the XIP infrastructure allow ext4
to track it's own IO (as it already does for direct IO and call
ext4_put_io_end() appropriately on IO completion. XFS will use
exactly the same mechanism, so will btrfs and every other filesystem
we might want to add support for XIP to...

> For reads, I think we will probably have to zero the extent, mark it as
> written, and then return the data normally.

Right now we have a "buffer_unwritten(bh)" flag that makes all the
code treat it like a hole. You don't need to convert it to written
until someone actually writes to it - all you need to do is
guarantee reads return zero for that page. IOWs, for users of
read(2) system calls, you can just zero their pages if the
underlying region spans a hole or unwritten extent.

Again, this is infrastructure we already have in the page cache - we
should not be using a different mechanism for XIP.

> For mmap, we can probably add code to the page fault handler which will
> zero the unwritten extent and mark it as written, similar to what is
> done for read.

Have you looked at how ->page_mkwrite handles the first page
fault into an unwritten region? Both XFS and ext4 end up in
__block_write_begin() with a map that says buffer_unwritten(), so it
zeros the page and marks it dirty.

So, at the completion of page_mkwrite, the page is zeroed but still
marked unwritten, so what XIP needs to do is then run an IO
completion....

> My hope is that we can do this all inline in the XIP wrappers for ext4,
> and avoid having to deal with callbacks.

We need to solve these problems by providing generic infrastructure
that executes existing code that handles these problems, not layer
on hacks to make a single filesystem work.

> Does this all sound generally correct?  I'll start work on an example 
> implementation.

IMO, no.

> Regarding fragmentation on XIP, yep, this is also an issue, but one I
> was hoping to address in a future patch set.

XFS has already solved that problem - it has the ability
to set a file's allocation granuarity (so you can match it to the
page sizes supported by the machine) and all allocations get aligned
and sized to that hint. It even turns off delayed allocation, which
makes it perfect for XIP, and it is inheritable from the parent
directory so it can be a "set at mkfs time and forget" configuration
item. But, it requires unwritten extent support and IO completions
to work, so we need XIP to support this infrastructure.

If you make XIP work just like filesystems expect, then you don't
have to reinvent the wheel.  We know how to build generic filesystem
infrastructure and it's not that hard to do. So let's do it the
right way the first time andnot force everyone to reinvent the wheel
repeatedly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
