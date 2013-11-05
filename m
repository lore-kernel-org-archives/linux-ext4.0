From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] fs: add FIEMAP_FLAG_DISCARD support
Date: Tue, 5 Nov 2013 15:36:25 +1100
Message-ID: <20131105043625.GZ6188@dastard>
References: <1383435930-29295-1-git-send-email-tytso@mit.edu>
 <20131104100343.GA10004@infradead.org>
 <20131105005146.GA26249@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:26236 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753850Ab3KEEg3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Nov 2013 23:36:29 -0500
Content-Disposition: inline
In-Reply-To: <20131105005146.GA26249@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 04, 2013 at 07:51:46PM -0500, Theodore Ts'o wrote:
> On Mon, Nov 04, 2013 at 02:03:43AM -0800, Christoph Hellwig wrote:
> > 
> > Besides that I really miss an explanation what the intended use cases
> > are.  What does this buy us over punching a hole on an actual real
> > workload?  Where is the overhead?  Is it our shitty discard
> > implementation? If so there's tons of low hanging fruit to fix there
> > anyway that we shouldn't work around by interfaces taking shortcuts.
> > Is it problems in ext4's extent management on hole punch?  Is the
> > bit of metadata created when doing an actual hole punch too much for
> > that very specific workload?
> 
> The an application in question wants to treat a large file as if it
> were a block device --- that's hardly unprecedented; enterprise
> databases tend to prefer using raw block devices (at least for
> benchmarking purposes), but system administrators like to
> administrative convenience of using a file system.
> 
> The goal here is get the performace as close to a raw block device as
> possible.  Especially if you are using fast flash, the overhead of
> deallocating blocks using punch, only to reallocate the blocks when we
> later write into them, is just unnecessary overhead.  Also, if you
> deallocate the blocks, they could end up getting grabbed by some other
> block allocation, which means the file can end up getting very
> fragmented --- which doesn't matter that much for flash, I suppose,
> but it means the extent tree could end up growing and getting nasty
> over time.  The bottom line is why bother doing extra work when it's
> not necessary?

commit 447223520520b17d3b6d0631aa4838fbaf8eddb4
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Aug 24 12:02:11 2010 +1000

    xfs: Introduce XFS_IOC_ZERO_RANGE
    
    XFS_IOC_ZERO_RANGE is the equivalent of an atomic XFS_IOC_UNRESVSP/
    XFS_IOC_RESVSP call pair. It enabled ranges of written data to be
    turned into zeroes without requiring IO or having to free and
    reallocate the extents in the range given as would occur if we had
    to punch and then preallocate them separately.  This enables
    applications to zero parts of files very quickly without changing
    the layout of the files in any way.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>

Sounds pretty much like the same reasons to me. IOWs, we did this
more than 3 years ago on XFS but discard was not a requirement for
the cloudy guy who asked for it so we simply didn't implement it.

I agree that per-file discard is useful, but it needs to have well
defined byte-range semantics and prevent stale data exposure to
unprivileged users. FALLOC_FL_ZERO_RANGE has those semantics, while
FALLOC_FL_ZERO_RANGE|FALLOC_FL_NO_HIDE_STALE gives google the
trigger to issue discards without caring about what you get back
from the discards....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
