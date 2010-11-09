From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Date: Tue, 9 Nov 2010 15:42:42 +1100
Message-ID: <20101109044242.GH2715@dastard>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
 <20101109011222.GD2715@dastard>
 <20101109033038.GF3099@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>, Josef Bacik <josef@redhat.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:49692 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752484Ab0KIEnT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Nov 2010 23:43:19 -0500
Content-Disposition: inline
In-Reply-To: <20101109033038.GF3099@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 08, 2010 at 10:30:38PM -0500, Ted Ts'o wrote:
> On Tue, Nov 09, 2010 at 12:12:22PM +1100, Dave Chinner wrote:
> > Hole punching was not included originally in fallocate() for a
> > variety of reasons. IIRC, they were along the lines of:
> > 
> > 	1 de-allocating of blocks in an allocation syscall is wrong.
> > 	  People wanted a new syscall for this functionality.
....
> > I guess that leaves #1 to be debated;
> > I don't think there is any problem with doing what you propose.
> 
> I don't have a problem either.
> 
> As a completely separate proposal, what do people think about an
> FALLOCATE_FL_ZEROIZE after which time the blocks are allocated, but
> reading from them returns zero.

That's exactly the new XFS_IOC_ZERO_RANGE ioctl in 2.6.36 does
(commit 447223520520b17d3b6d0631aa4838fbaf8eddb4 "xfs: Introduce
XFS_IOC_ZERO_RANGE") The git commit I pointed to in the last email
is the rudimentary fallocate() interface support I have for that
code which goes along with an xfs_io patch I have. Given that there
seems to be interest for this operation, I'll flesh it out into a
proper patch....

> This could be done either by (a)
> sending a discard in the case of devices where discard_zeros_data is
> true and discard_granularty is less than the fs block size, or (b) by
> setting the uninitialized flag in the extent tree.

Implementation is up to the filesystem. However, XFS does (b)
because:

	1) it was extremely simple to implement (one of the
	   advantages of having an exceedingly complex allocation
	   interface to begin with :P)
	2) conversion is atomic, fast and reliable
	3) it is independent of the underlying storage; and
	4) reads of unwritten extents operate at memory speed,
	   not disk speed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
