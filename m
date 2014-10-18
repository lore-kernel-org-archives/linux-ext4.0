From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/34] libext2fs: support BLKZEROOUT/FALLOC_FL_ZERO_RANGE
 in ext2fs_zero_blocks
Date: Sat, 18 Oct 2014 12:32:55 -0400
Message-ID: <20141018163255.GB30124@thunk.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221253.13646.7723.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59254 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbaJSLdl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Oct 2014 07:33:41 -0400
Content-Disposition: inline
In-Reply-To: <20140913221253.13646.7723.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2014 at 03:12:53PM -0700, Darrick J. Wong wrote:
> Plumb a new call into the IO manager to support translating
> ext2fs_zero_blocks calls into the equivalent kernel-level BLKZEROOUT
> ioctl or FALLOC_FL_ZERO_RANGE fallocate flag primitives when possible.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  contrib/fallocate.c     |   14 +++++++++

I've separated out the contrib/fallocate change and created a separate
commit for it, since it really is a separate change.

What I'd like to see for the zero_blocks change io_manager is:

(a) if we try to zero a range past the end of the file, we should just
truncate the file to set i_size.  Similarly, if this is a regular
file, we should try to use PUNCH_HOLE.  We already try to keep a raw
file system image file to be sparse, so I don't see any real problems
with this.

(b) for a block device, if IO_FLAG_DIRECT_IO is set, it shoud be safe
to try to use te BLKZEROOUT.  If not, we can use
posix_fadvise(POSIX_FADV_DONTNEED) and verify that this correctly zaps
the relevant parts of the buffer cache.  If it doesn't do the right
thing, we can use BLKFLSBUF, which will zap the entire buffer cache
for the device.  Which is pretty heavy weight, but I really think it
only makes sense to use zeroout for zeroing the inode table and the
journal file.

Even if we patch the kernel to make BLKZEROOUT to automatically do
this, we can't count on it, and in particular if it turns out we have
to use BLKFLSBUF, we're not going to want to use this for zero'ing a
single 4k block.  It doesn't happen that often, and I don't think
there will be much if any measurable difference in performance if we
use WRITE SAME vs. WRITE for a small region.

Does this make sense?

					- Ted

P.S.  Once we do this, when using mke2fs on a file, we should really
use punch_hole and disable lazy_itable_init, to save I/O bandwidth on
VM's running on cloud systems.
