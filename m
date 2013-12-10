From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v2 2/4] ext4: Add XIP functionality
Date: Tue, 10 Dec 2013 09:22:31 -0700
Message-ID: <20131210162231.GA11237@parisc-linux.org>
References: <1386273769-12828-1-git-send-email-ross.zwisler@linux.intel.com> <1386273769-12828-3-git-send-email-ross.zwisler@linux.intel.com> <20131206031354.GS10988@dastard> <1386558964.6872.14.camel@gala> <20131209081940.GW10988@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	carsteno@de.ibm.com, matthew.r.wilcox@intel.com,
	andreas.dilger@intel.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60594 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3LJQWd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 11:22:33 -0500
Content-Disposition: inline
In-Reply-To: <20131209081940.GW10988@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 09, 2013 at 07:19:40PM +1100, Dave Chinner wrote:
> Set up the generic XIP infrastructure in a way that allows the
> filesystem to set up post-IO callbacks at submission time and call
> them on IO completion.  We manage to do this for both buffered data
> IO and direct IO, and I don't see how XIP IO is any different from
> this perspective. XIP still costs time and latency to execute, and
> if we start to think about hardware offload of large memcpy()s (say
> like the SGI Altix machines could do years ago) asychronous
> processing in the XIP IO path is quite likely to be used in the
> near future.

While I agree there's nothing inherently synchronous about the XIP
path, I don't know that there's a real advantage to a hardware offload.
These days, memory controllers are in the CPUs, so the putative hardware
is also going to have to be in the CPU and it's going to have to bring
cachelines in from oe memory location and write them out to another
location.  Add in setup costs and it's going to have to be a pretty
damn large write() / read() to get any kind of advantage out of it.
I might try to con somebody into estimating where the break-even point
would be on a current CPU.  I bet it's large ... and if it's past 2GB,
we run into Linus' rule about not permitting I/Os larger than that.

I would bet our hardware people would just say something like "would
you like this hardware or two more completely generic cores?"  And I
know what the answer to that is.

> So, it's pretty clear to me that XIP needs to look like a normal IO
> path from a filesystem perspective - it's not necessarily
> synchronous, we need concurrent read and write support (i.e. the
> equivalent of current direct IO capabilities on XFS where we can
> already do millions of mixed read and write IOPS to the same file
> on a ram based block device), and so on. XIP doesn't fundamentally
> change the way filesystems work, and so we shoul dbe treating XIP in
> a similar fashion to how we treat buffered and direct IO.

I don't disagree with any of that.

> Indeed, the direct IO model is probably the best one to use here -
> it allows the filesystem to attach it's own private data structure
> to the kiocb, and it gets an IO completion callback with the kiocb,
> the offset and size of the IO, and we can pull the filesystem
> private data off the iocb and then pass it into existing normal IO
> completion paths.

Um, you're joking, right?  The direct IO model is pretty universally
hated.  It's ridiculously complex.  Maybe you meant "this aspect" of
direct IO, but I would never point anybody at the direct IO path as an
example of good programming practice.

> > For writes, I think that we need to potentially split the unwritten
> > extent in to up to three extents (two unwritten, one written), in the
> > spirit of the ext4_split_unwritten_extents().
> 
> You don't need to touch anything that deep in ext4 to make this
> work. What you need to do is make the XIP infrastructure allow ext4
> to track it's own IO (as it already does for direct IO and call
> ext4_put_io_end() appropriately on IO completion. XFS will use
> exactly the same mechanism, so will btrfs and every other filesystem
> we might want to add support for XIP to...
> 
> > For reads, I think we will probably have to zero the extent, mark it as
> > written, and then return the data normally.
> 
> Right now we have a "buffer_unwritten(bh)" flag that makes all the
> code treat it like a hole. You don't need to convert it to written
> until someone actually writes to it - all you need to do is
> guarantee reads return zero for that page. IOWs, for users of
> read(2) system calls, you can just zero their pages if the
> underlying region spans a hole or unwritten extent.
> 
> Again, this is infrastructure we already have in the page cache - we
> should not be using a different mechanism for XIP.

The XIP code already handles holes just fine.  Reads call __clear_user()
if it finds a hole.  Mmap load faults do some bizarre stuff to map in
a zero page that I think needs fixing, but that'll be the subject of a
future fight.

I don't actually understand what the problem is here.  ext4_get_xip_mem()
calls ext4_get_block() with the 'create' flag set or clear, depending
if it needs the page to be instantiated, or it can live with the hole.
It seems that ext4_get_xip_mem() needs to check BH_Unwritten, but other
than that things should be working the way you seem to want them to.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
