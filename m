From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] direct-io: always call ->end_io if non-NULL
Date: Thu, 4 Feb 2016 08:14:55 +0100
Message-ID: <20160204071455.GA20002@lst.de>
References: <1454524816-11392-1-git-send-email-hch@lst.de> <1454524816-11392-2-git-send-email-hch@lst.de> <20160203195531.GJ20038@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45658 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbcBDHO6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Feb 2016 02:14:58 -0500
Content-Disposition: inline
In-Reply-To: <20160203195531.GJ20038@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 03, 2016 at 11:55:31AM -0800, Darrick J. Wong wrote:
> This will have the effect of a later error superseding an earlier error.  I'm
> under the impression that code should generally preserve the first error, since
> some side effect of that probably caused the rest of the errors.
> 
> That said, my guess is that 95% of the time err is set, retval and err will
> both be -EIO anyway.  I'm not particularly passionate about whether or not we
> preserve the first error code.

This leaves the option to the file system to pass the value through
or not.  Note that ret before the call will usually have the positive
number of bytes written, so checking if it's 'set' wouldn't be enough
even if adding some special casing in the callers.

> > +static int ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
> >  			    ssize_t size, void *private)
> >  {
> >          ext4_io_end_t *io_end = iocb->private;
> >  
> > +	if (size <= 0)
> > +		return 0;
> 
> This leaks the ext4_io_end_t, if there was one.  Granted, that only happens
> during an AIO DIO to an unwritten extent, but in any case I suggest removing
> this hunk and...

It's the same behavior as before - and if you look at ext4_ext_direct_IO
it seems to expect this and works around it.

> > +	if (bytes <= 0)
> > +		return 0;
> > +
> 
> I suspect we still need to unlock the mutexes later on in this function.
> 
> >  	/* this io's submitter should not have unlocked this before we could */
> >  	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
> >  
> > @@ -644,6 +647,8 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
> >  		level = ocfs2_iocb_rw_locked_level(iocb);
> >  		ocfs2_rw_unlock(inode, level);
> >  	}
> 
> Do we need to still have an accurate value for bytes the conditional above
> even if the IO errored out?  

Again, no changes to the old behavior.  ocfs has some magic stuffed
in iocb->private to deal with the locked state of an iocb, and while
I don't fully understand it I suspect it's to handle the existing
odd ->end_io calling conventions.  Cleaning this up would be nice,
but let's keep that a separate patch.

> >  	struct kiocb		*iocb,
> >  	loff_t			offset,
> > @@ -1655,15 +1655,19 @@ xfs_end_io_direct_write(
> >  	struct inode		*inode = file_inode(iocb->ki_filp);
> >  	struct xfs_ioend	*ioend = private;
> >  
> > +	if (size <= 0)
> > +		return 0;
> 
> Same thing here, I think we can end up leaking the ioend.

This keeps the existing behavior.  But either way, at least for
XFS all this will be properly fixed in the next patch anyway.
