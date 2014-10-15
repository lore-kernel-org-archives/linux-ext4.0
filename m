From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: BLKZEROOUT + pread should return zeroes, right?
Date: Tue, 14 Oct 2014 18:25:34 -0700
Message-ID: <20141015012534.GB12013@birch.djwong.org>
References: <20141014030132.GA12013@birch.djwong.org>
 <20141014042711.GJ5267@dastard>
 <20141014060242.GA22878@birch.djwong.org>
 <20141014063210.GK9738@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31288 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbaJOBZo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Oct 2014 21:25:44 -0400
Content-Disposition: inline
In-Reply-To: <20141014063210.GK9738@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 14, 2014 at 02:32:10AM -0400, Theodore Ts'o wrote:
> The bottom line is for most of the use cases we are talking about,
> we're only zero'ing one or two 4k blocks at a time, so I've never been
> convinced that it's worth it to use BLKZEROOUT.
> 
> We could add page cache coherency features to BLKZEROOUT, but I'm not
> entirely sure it's worth the effort.  No user space program would be
> able to take advantage of adding coherency for several years, or

Well then let's change BLKZEROOUT to require O_DIRECT instead of hiding the
coherency problem, and introduce BLKZEROOUT_INV which issues the zero out and
then takes care of page cache coherency.

(Or at least the first part...)

> adding feature tests, etc., and is it worth the upside of being able
> to use WRITE SAME for a few 4k or 8k writes?  (Which the vast majority
> of storage devices don't support anyway....)

I've converted mke2fs and e2fsck to use BLKZEROOUT to zero the journal and the
inode tables when they want something to really be zero, and ext2fs_fallocate
uses it to zero the fallocated range.  I suspect those three will zero long
runs of sectors each call.

As for WRITE_SAME support, if it's there, why ignore it?  The ioctl exists;
someone else is bound to use it sooner or later.

A further optimization to mke2fs would be to detect that we've run
discard-with-zeroes and therefore can skip issuing subsequent zeroouts on the
same ranges, but I'm wary that discard-zeroes-data does what it purports to do.
If it /does/ work reliably, though, ext2fs_zero_blocks() could be rerouted to
use discard instead.  Really my reason for wanting to use zeroout is that in
guaranteeing the zero-read behavior afterwards it seems like it ought to be
less problematic than discard has been.

--D
> 
> Cheers,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
