From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 15/34] libext2fs: support BLKZEROOUT/FALLOC_FL_ZERO_RANGE
 in ext2fs_zero_blocks
Date: Mon, 20 Oct 2014 16:37:56 -0700
Message-ID: <20141020233756.GA32084@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221253.13646.7723.stgit@birch.djwong.org>
 <20141018163255.GB30124@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47559 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaJTXiE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Oct 2014 19:38:04 -0400
Content-Disposition: inline
In-Reply-To: <20141018163255.GB30124@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 18, 2014 at 12:32:55PM -0400, Theodore Ts'o wrote:
> On Sat, Sep 13, 2014 at 03:12:53PM -0700, Darrick J. Wong wrote:
> > Plumb a new call into the IO manager to support translating
> > ext2fs_zero_blocks calls into the equivalent kernel-level BLKZEROOUT
> > ioctl or FALLOC_FL_ZERO_RANGE fallocate flag primitives when possible.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  contrib/fallocate.c     |   14 +++++++++
> 
> I've separated out the contrib/fallocate change and created a separate
> commit for it, since it really is a separate change.
>
> What I'd like to see for the zero_blocks change io_manager is:
> 
> (a) if we try to zero a range past the end of the file, we should just
> truncate the file to set i_size.  Similarly, if this is a regular
> file, we should try to use PUNCH_HOLE.  We already try to keep a raw
> file system image file to be sparse, so I don't see any real problems
> with this.

Done.  For files, it'll truncate if the file needs to be extended, and then
punch out the zero range.  If punch isn't supported, it'll try zero-range
as a last resort.

> (b) for a block device, if IO_FLAG_DIRECT_IO is set, it shoud be safe
> to try to use te BLKZEROOUT.  If not, we can use
> posix_fadvise(POSIX_FADV_DONTNEED) and verify that this correctly zaps
> the relevant parts of the buffer cache.  If it doesn't do the right
> thing, we can use BLKFLSBUF, which will zap the entire buffer cache
> for the device.  Which is pretty heavy weight, but I really think it
> only makes sense to use zeroout for zeroing the inode table and the
> journal file.

I agree that it makes sense not to zero-out single blocks on bdevs.

> Even if we patch the kernel to make BLKZEROOUT to automatically do
> this, we can't count on it, and in particular if it turns out we have
> to use BLKFLSBUF, we're not going to want to use this for zero'ing a
> single 4k block.  It doesn't happen that often, and I don't think
> there will be much if any measurable difference in performance if we
> use WRITE SAME vs. WRITE for a small region.
> 
> Does this make sense?
> 
> 					- Ted
> 
> P.S.  Once we do this, when using mke2fs on a file, we should really
> use punch_hole and disable lazy_itable_init, to save I/O bandwidth on
> VM's running on cloud systems.

Ok.  I think current mke2fs does this if device discard is turned on.

Curiously, it'll still zero the itable even if itable_zeroed == 1.

--D
