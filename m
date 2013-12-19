From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Thu, 19 Dec 2013 08:32:13 -0700
Message-ID: <20131219153213.GC19166@parisc-linux.org>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com> <20131217223050.GB20579@dastard> <20131218023143.GA24491@parisc-linux.org> <20131218123319.GH31386@dastard> <20131218152234.GB9207@parisc-linux.org> <20131219004831.GU31386@dastard> <20131219010530.GA17545@parisc-linux.org> <20131219015843.GE20579@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39410 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3LSPcP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Dec 2013 10:32:15 -0500
Content-Disposition: inline
In-Reply-To: <20131219015843.GE20579@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 19, 2013 at 12:58:44PM +1100, Dave Chinner wrote:
> >  
> > -	if (unlikely(iocb->ki_filp->f_flags & O_DIRECT))
> > +	if (unlikely(iocb->ki_filp->f_flags & O_DIRECT) ||
> > +	    (mapping_is_xip(inode->i_mapping)))
> 
> I suspect a helper function a good idea here. Something like
> "is_io_direct(iocb->ki_filp)"

Seems like a good idea.

> > index 594009f..ae760d9 100644
> > --- a/fs/ext4/indirect.c
> > +++ b/fs/ext4/indirect.c
> > @@ -686,15 +686,22 @@ retry:
> >  			inode_dio_done(inode);
> >  			goto locked;
> >  		}
> > -		ret = __blockdev_direct_IO(rw, iocb, inode,
> > -				 inode->i_sb->s_bdev, iov,
> > -				 offset, nr_segs,
> > -				 ext4_get_block, NULL, NULL, 0);
> > +		if (mapping_is_xip(file->f_mapping))
> > +			ret = xip_io(rw, iocb, inode, iov, offset, nr_segs,
> > +					ext4_get_block, NULL, 0);
> 
> xip_direct_io() might be a better name here...

I you're a man who his functions verbs :-)

> > +static inline bool mapping_is_xip(struct address_space *mapping)
> > +{
> > +	return mapping->a_ops->get_xip_mem != NULL;
> > +}
> 
> I think that you should put a flag in the mapping for this, rather
> than chase pointers to do the check.

Probably.  I think we may end up without a get_xip_mem() aop by the time
we're finished.

> > +			retval = get_block(inode, block, bh, 0);
> > +			if (retval)
> > +				break;
> > +			if (buffer_mapped(bh))
> > +				hole = false;
> > +			else
> > +				hole = true;
> > +			if (rw == WRITE && hole) {
> > +				bh->b_size = ALIGN(end - offset, PAGE_SIZE);
> > +				retval = get_block(inode, block, bh, 1);
> > +				if (retval)
> > +					break;
> > +			} 
> 
> Why do two write mappings here? If it's a write, then we always want
> to fill a hole, so the create value sent to getblock is:

Yeah, there's a missing piece here.  At the moment, I'm supposed to take
the stupid xip_sparse_mutex before filling a hole, and call __xip_unmap
after filling it.  I think that has to go away, and once that's done,
I agree with your optimisation.

> > +/*
> > + * Perform I/O to an XIP file.  We follow the same rules as
> > + * __blockdev_direct_IO with respect to locking
> > + */
> 
> OK, that's interesting, because it means that it will be different
> to normal buffered page cache IO. It will allow concurrent
> overlapping reads and writes - something that POSIX does not allow -
> and places the burden of synchronising concurrent reads and writes
> on the application.
> 
> That is different to the current XIP, which serialises writes
> against each other, but not against reads. That's not strictly POSIX
> compliant, either, but it prevents concurrent overlapping writes
> from occurring and so behaves more like applications expect buffered
> IO to work.
> 
> For persistent memory, I'd prefer that we have concurrent write Io
> capabilities from the start, but I'm not sure we should just do this
> without first talking about it....

I think you're right.  Let's drag this topic out to lkml and make sure
Linus is aware before we go too much further.

> > +	/* Protects against truncate */
> > +	atomic_inc(&inode->i_dio_count);
> > +
> > +	retval = __xip_io(rw, inode, iov, offset, end, nr_segs, get_block, &bh);
> 
> Can we avoid using "__" prefixes for new code? xip_do_direct_io() is
> a much better name....

Then it won't fit on a single line ;-)  I have no attachment to the name,
but isn't all xip IO direct?

> > +
> > +	if ((flags & DIO_LOCKING) && (rw == READ))
> > +		mutex_unlock(&inode->i_mutex);
> > +
> > +	inode_dio_done(inode);
> > +
> > +	if (end_io)
> > +		end_io(iocb, offset, transferred, bh.b_private);
> 
> And that solves the unwritten extent problem for the IO path. Now we
> just need to solve it for the mmap path. That, I suspect will
> require a custom .page_mkwrite handler....

No, page_mkwrite() never gets called.  At this point, I'm thinking a
custom ->fault handler that looks something like this:

static int ext4_xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
{
	return xip_fault(vma, vmf, ext4_get_block_write, ext4_end_io_dio);
}

But I'll report back further when I've had a chance to see how it
turns out.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
