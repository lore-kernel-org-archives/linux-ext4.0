From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: BLKZEROOUT + pread should return zeroes, right?
Date: Mon, 13 Oct 2014 23:02:42 -0700
Message-ID: <20141014060242.GA22878@birch.djwong.org>
References: <20141014030132.GA12013@birch.djwong.org>
 <20141014042711.GJ5267@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29794 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbaJNGCx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Oct 2014 02:02:53 -0400
Content-Disposition: inline
In-Reply-To: <20141014042711.GJ5267@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 14, 2014 at 03:27:11PM +1100, Dave Chinner wrote:
> On Mon, Oct 13, 2014 at 08:01:32PM -0700, Darrick J. Wong wrote:
> > Hi everyone,
> > 
> > What's the intended behavior if I issue BLKZEROOUT against a range of disk
> > sectors and immediately re-read the sectors into a buffer?
> 
> Should return zeros.
> 
> [...]
> 
> > I boiled the whole thing down into the attached test program, which can
> > reproduce the symptoms in a few loop iterations.  If I insert "sleep(1);"
> > before the pread64, I pread zeroes every time; otherwise, I only pread zeroes
> > part of the time.  If I call "ioctl(fd, BLKFLSBUF);" before the BLKZEROOUT, the
> > chances of preading zeroes increases dramatically, but is still not 100%.
> 
> Hint #1: buffered IO == data in page cache.
> Hint #2: BLKZEROOUT operates at the bio level.

Yeah, I forgot about that little quirk where the page cache is left in the
dark.  Thank you for the sanity check, Dave.

> > So, uh, is this a bug?  Or is that just how BLKZEROOUT works?  Or did I fubar
> > the ioctl call?
> 
> Broken usage, IMO. If you are going to use the block layer ioctls to
> manipulate data int eh block device, you should be using direct Io
> for all your data IO to the block device. Otherwise, coherency
> problems occur....

So... if these ioctls require direct IO read and write for any sane use model,
why doesn't the kernel fail the request if the fd isn't in O_DIRECT mode?  Or,
if we do want to allow the ioctls to run on an fd that's opened in buffered IO
mode, can we simply invalidate that part of the page cache after calling
ZEROOUT?

Something idiotic like fsync_bdev() -> blkdev_issue_zeroout -> invalidate_bdev
-> invalidate_inode_pages2 seems to smooth things over, but that's a big dumb
hammer.

Tired of this for now, going to bed.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
