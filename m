From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Fri, 20 Dec 2013 10:46:54 +1100
Message-ID: <20131219234653.GD31386@dastard>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com>
 <20131217223050.GB20579@dastard>
 <20131218023143.GA24491@parisc-linux.org>
 <20131218123319.GH31386@dastard>
 <20131218152234.GB9207@parisc-linux.org>
 <20131219004831.GU31386@dastard>
 <20131219010530.GA17545@parisc-linux.org>
 <20131219015843.GE20579@dastard>
 <20131219153213.GC19166@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:5057 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755993Ab3LSXrA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Dec 2013 18:47:00 -0500
Content-Disposition: inline
In-Reply-To: <20131219153213.GC19166@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 19, 2013 at 08:32:13AM -0700, Matthew Wilcox wrote:
> On Thu, Dec 19, 2013 at 12:58:44PM +1100, Dave Chinner wrote:
> > > +			retval = get_block(inode, block, bh, 0);
> > > +			if (retval)
> > > +				break;
> > > +			if (buffer_mapped(bh))
> > > +				hole = false;
> > > +			else
> > > +				hole = true;
> > > +			if (rw == WRITE && hole) {
> > > +				bh->b_size = ALIGN(end - offset, PAGE_SIZE);
> > > +				retval = get_block(inode, block, bh, 1);
> > > +				if (retval)
> > > +					break;
> > > +			} 
> > 
> > Why do two write mappings here? If it's a write, then we always want
> > to fill a hole, so the create value sent to getblock is:
> 
> Yeah, there's a missing piece here.  At the moment, I'm supposed to take
> the stupid xip_sparse_mutex before filling a hole, and call __xip_unmap
> after filling it.  I think that has to go away, and once that's done,
> I agree with your optimisation.

Then perhaps we need to get rid of the xip_sparse_mutex first? :/

> > > +/*
> > > + * Perform I/O to an XIP file.  We follow the same rules as
> > > + * __blockdev_direct_IO with respect to locking
> > > + */
> > 
> > OK, that's interesting, because it means that it will be different
> > to normal buffered page cache IO. It will allow concurrent
> > overlapping reads and writes - something that POSIX does not allow -
> > and places the burden of synchronising concurrent reads and writes
> > on the application.
> > 
> > That is different to the current XIP, which serialises writes
> > against each other, but not against reads. That's not strictly POSIX
> > compliant, either, but it prevents concurrent overlapping writes
> > from occurring and so behaves more like applications expect buffered
> > IO to work.
> > 
> > For persistent memory, I'd prefer that we have concurrent write Io
> > capabilities from the start, but I'm not sure we should just do this
> > without first talking about it....
> 
> I think you're right.  Let's drag this topic out to lkml and make sure
> Linus is aware before we go too much further.

Sure.

Keep in mind we've been discussing making normal buffered IO have
the same concurrency model as direct IO, but with the additional
provision that concurrent IO to the same range is serialised (i.e.
the IO range locks we've preveiously mentioned in the truncate/mmap
discussion). They would also be used for direct IO to avoid the
overallping IO issue there, too.


> > > +	/* Protects against truncate */
> > > +	atomic_inc(&inode->i_dio_count);
> > > +
> > > +	retval = __xip_io(rw, inode, iov, offset, end, nr_segs, get_block, &bh);
> > 
> > Can we avoid using "__" prefixes for new code? xip_do_direct_io() is
> > a much better name....
> 
> Then it won't fit on a single line ;-)  I have no attachment to the name,
> but isn't all xip IO direct?

mmap based IO does not use the "direct IO" path....

> > > +	if ((flags & DIO_LOCKING) && (rw == READ))
> > > +		mutex_unlock(&inode->i_mutex);
> > > +
> > > +	inode_dio_done(inode);
> > > +
> > > +	if (end_io)
> > > +		end_io(iocb, offset, transferred, bh.b_private);
> > 
> > And that solves the unwritten extent problem for the IO path. Now we
> > just need to solve it for the mmap path. That, I suspect will
> > require a custom .page_mkwrite handler....
> 
> No, page_mkwrite() never gets called.  At this point, I'm thinking a
> custom ->fault handler that looks something like this:

And that's another difference to the normal filesystem mmap paths.
.fault is a read-only operation for filesystems and
.page-mkwrite is the write-fault modification path. i.e.
.fault is only supposed to populate the page into the page
cache by reading it from disk via ->readpage(s). It does not do
block allocation - if the fault is over a hole then a new, zeroed
page is placed in the page cache regardless of whether it is a read
or write page fault.

->page_mkwrite is then used by page fault infrstructure to inform
filesystem that a write fault has occurred and they may need to
allocate backing store for the page, or convert unwritten extents to
written.

What xip_file_fault() does is ask the fielsystem to allocate blocks
for writeable mappings, rather than just inserting a sparse page
over holes and unwritten extents. That fails to handle unwritten
extents correctly - they remain unwritten despite the fact that
userspace can now write to the page.

IOWs, xip_file_fault() needs to drop the allocation of blocks and
only ever insert mappings for pages that have data in them or sprase
pages for holes and unwritten extents. Then the filesystem needs to
provide it's own ->page_mkwrite callout to do block allocation and
unwritten extent conversion on write page faults, and the XIP code
needs to provide a helper function to replace the sparse page in the
mappings with the correct page mapped from the backing device after
allocation or unwritten extent conversion.

That will make XIP behave almost identically to the normal page
cache based page fault path, requiring only a small addition to the
filesystem page_mkwrite handler to support XIP...


> static int ext4_xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> {
> 	return xip_fault(vma, vmf, ext4_get_block_write, ext4_end_io_dio);
> }

I think the xip fault handler should be generic as there's no reason
for it to do anything other that read-only operations. It's the
page_mkwrite callout that needs custom code for each filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
