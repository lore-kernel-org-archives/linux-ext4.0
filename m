From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/4] ext4: Add XIP functionality
Date: Wed, 11 Dec 2013 10:09:40 +1100
Message-ID: <20131210230939.GZ10988@dastard>
References: <1386273769-12828-1-git-send-email-ross.zwisler@linux.intel.com>
 <1386273769-12828-3-git-send-email-ross.zwisler@linux.intel.com>
 <20131206031354.GS10988@dastard>
 <1386558964.6872.14.camel@gala>
 <20131209081940.GW10988@dastard>
 <20131210162231.GA11237@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	carsteno@de.ibm.com, matthew.r.wilcox@intel.com,
	andreas.dilger@intel.com
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:52776 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111Ab3LJXJ5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Dec 2013 18:09:57 -0500
Content-Disposition: inline
In-Reply-To: <20131210162231.GA11237@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 09:22:31AM -0700, Matthew Wilcox wrote:
> On Mon, Dec 09, 2013 at 07:19:40PM +1100, Dave Chinner wrote:
> > Set up the generic XIP infrastructure in a way that allows the
> > filesystem to set up post-IO callbacks at submission time and call
> > them on IO completion.  We manage to do this for both buffered data
> > IO and direct IO, and I don't see how XIP IO is any different from
> > this perspective. XIP still costs time and latency to execute, and
> > if we start to think about hardware offload of large memcpy()s (say
> > like the SGI Altix machines could do years ago) asychronous
> > processing in the XIP IO path is quite likely to be used in the
> > near future.
> 
> While I agree there's nothing inherently synchronous about the XIP
> path, I don't know that there's a real advantage to a hardware offload.
> These days, memory controllers are in the CPUs, so the putative hardware
> is also going to have to be in the CPU and it's going to have to bring
> cachelines in from oe memory location and write them out to another
> location.  Add in setup costs and it's going to have to be a pretty
> damn large write() / read() to get any kind of advantage out of it.
> I might try to con somebody into estimating where the break-even point
> would be on a current CPU.  I bet it's large ... and if it's past 2GB,
> we run into Linus' rule about not permitting I/Os larger than that.
> I would bet our hardware people would just say something like "would
> you like this hardware or two more completely generic cores?"  And I
> know what the answer to that is.

You're not thinking about what I'm saying - you're just taking the
literal interpretation of the example I gave and arguing about why
it's not a relevant example. You have not
considered the wider implications of what it means.

For example, replace memcpy() with a crypto offload so that when your
laptop gets stolen nobody can read your important data in persistent
memory without the decryption key...

i.e. if you think the sorts of things like encryption, snapshots,
compressions, thin provisioning, etc are not going to be part of a
persistent memory *IO path*, then I think you are being very naive.
Persistent memory may be fast and directly accessed, but it doesn't
change the fact that it is *storage* and so needs to be support all
those neat things people like to do with their persistent data....

Step outside you little Intel coloured box full of blue men,
Willy...

> > So, it's pretty clear to me that XIP needs to look like a normal IO
> > path from a filesystem perspective - it's not necessarily
> > synchronous, we need concurrent read and write support (i.e. the
> > equivalent of current direct IO capabilities on XFS where we can
> > already do millions of mixed read and write IOPS to the same file
> > on a ram based block device), and so on. XIP doesn't fundamentally
> > change the way filesystems work, and so we shoul dbe treating XIP in
> > a similar fashion to how we treat buffered and direct IO.
> 
> I don't disagree with any of that.
> 
> > Indeed, the direct IO model is probably the best one to use here -
> > it allows the filesystem to attach it's own private data structure
> > to the kiocb, and it gets an IO completion callback with the kiocb,
> > the offset and size of the IO, and we can pull the filesystem
> > private data off the iocb and then pass it into existing normal IO
> > completion paths.
> 
> Um, you're joking, right?  The direct IO model is pretty universally
> hated.  It's ridiculously complex.  Maybe you meant "this aspect" of
> direct IO, but I would never point anybody at the direct IO path as an
> example of good programming practice.

Again, you're not thinking about what I'm saying - you stopped
reading at "direct IO" and started ranting instead.  I'm talking
about the design pattern (i.e. the model) used to abstract the
direct IO code from the filesystems to provide generic
infrastructure.  i.e:

aio_write
  xfs_file_aio_write
    generic_file_direct_write
      xfs_vm_direct_IO
        attach xfs_ioend to kiocb
	__blockdev_direct_IO
	  <generic direct IO code>
.....
	<generic direct io completes>
	xfs_end_io_direct_write
	  pulls xfs_ioend off kiocb
	  xfs_finish_ioend_sync()
	    does file size updates, unwritten extent conversion.

At every layer, filesystems that support direct IO can set up
infrastructure to behave like they need it to.  Filesystem specific
locking and sub-block IO synchronisation  is handled at .aio_write,
filesystem IO completions are set up in .direct_IO, etc.

IOWs, XIP should look something like this:

aio_write
  xfs_file_aio_write
    generic_file_xip_write
      xfs_vm_xip_IO
        attach xfs_ioend to kiocb
	xip_file_write
	  <generic XIP write code>

.....
	<generic XIP io completes>
	xfs_end_io_xip_write
	  pulls xfs_ioend off kiocb
	  xfs_finish_ioend_sync()
	    does file size updates, unwritten extent conversion.

See what I mean? We already have a model for handling a special,
non-page cache IO path, and XIP fits it exactly with very little
extra support needed in the filesystems for it. We do not need to
reinvent a new IO model and infrastructure for XIP.

> > > For writes, I think that we need to potentially split the unwritten
> > > extent in to up to three extents (two unwritten, one written), in the
> > > spirit of the ext4_split_unwritten_extents().
> > 
> > You don't need to touch anything that deep in ext4 to make this
> > work. What you need to do is make the XIP infrastructure allow ext4
> > to track it's own IO (as it already does for direct IO and call
> > ext4_put_io_end() appropriately on IO completion. XFS will use
> > exactly the same mechanism, so will btrfs and every other filesystem
> > we might want to add support for XIP to...
> > 
> > > For reads, I think we will probably have to zero the extent, mark it as
> > > written, and then return the data normally.
> > 
> > Right now we have a "buffer_unwritten(bh)" flag that makes all the
> > code treat it like a hole. You don't need to convert it to written
> > until someone actually writes to it - all you need to do is
> > guarantee reads return zero for that page. IOWs, for users of
> > read(2) system calls, you can just zero their pages if the
> > underlying region spans a hole or unwritten extent.
> > 
> > Again, this is infrastructure we already have in the page cache - we
> > should not be using a different mechanism for XIP.
> 
> The XIP code already handles holes just fine.  Reads call __clear_user()
> if it finds a hole.  Mmap load faults do some bizarre stuff to map in
> a zero page that I think needs fixing, but that'll be the subject of a
> future fight.

Yes, I know that XIP has code to do this. Read what I said:

> > Again, this is infrastructure we already have in the page cache - we
> > should not be using a different mechanism for XIP.

Willy, I'm coming from the position of having taken a look at the
XIP code with an eye to adding support to XFS. What I've found is a
*toy* that people played with years ago that relied on a specific
block device implementation.  It simply wasn't architected for ext4
or XFS or btrfs to be implemented on top of it.

It wasn't designed with the consideration that we might need
buffering for mmap writes because we use data transformations in the
IO path (the encryption example, again).

It wasn't design to allow filesystems that require locking other than
i_mutex in the io path to work or do other operations prior to 
the write IO that might be needed to avoid stale data exposure on
extending writes.

It doesn't even serialise xip_file_read() against any other IO
operation at all, and so can race with writes, truncates, hole
punches or any other operations that might modify the underlying
file or block map. That's not just downright nasty, that's a major
security issue. The direct IO design pattern allows filesystems to
put their own locking in place to prevent these sorts of problems.
e.g. XFS holds the IOLOCK in shared mode across reads, so does not
need to rely on page locks to avoid read racing with truncate, etc.

Quite frankly the XIP infrastructure as it stands is simply
inadequate for modern filesystems like ext4 or XFS - it is so full
of holes it makes swiss cheese look positively solid.  If we are
going to make XIP a first class citizen - and we need to for
persistent memory support - then we need to architect a proper
solution for it.  When faced with the choice of "reimplement every
filesystem with custom solutions" or "add generic infrastructure for
the existing filesystem hooks", the answer is a no-brainer: generic
infrastructure improvements win every time. 

Willy, the "XIP as an IO path" infrastructure change is the critical
one that needs to be made. It's not a huge amount of work; it'd take
me a week to do it and to port XFS to support XIP, but I don't have
a week I can spare right now. Intel clearly have resources to throw
at this problem, so I'd be really happy to only have to worry about
the day it would take to do the "port XFS" part of the work.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
