From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RESEND][PATCH 2/2 v2] ext4: let us fully support punching hole
 feature in fallocate
Date: Sat, 26 Jan 2013 11:47:07 +1100
Message-ID: <20130126004707.GG2667@dastard>
References: <1358493381-20150-1-git-send-email-wenqing.lz@taobao.com>
 <1358493381-20150-2-git-send-email-wenqing.lz@taobao.com>
 <20130125033201.GD28908@thunk.org>
 <20130125035912.GA15806@gmail.com>
 <20130125042122.GG28908@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	xfs@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:14947 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753441Ab3AZArM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jan 2013 19:47:12 -0500
Content-Disposition: inline
In-Reply-To: <20130125042122.GG28908@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[cc xfs@oss.sgi.com]

On Thu, Jan 24, 2013 at 11:21:22PM -0500, Theodore Ts'o wrote:
> On Fri, Jan 25, 2013 at 11:59:12AM +0800, Zheng Liu wrote:
> > 
> > I wonder that maybe we need to submit a patch to let xfstest understand
> > that a filesystem supports extents or not because after applied this
> > patch indirect-based file in ext4 has supported seek_data/hole and hole
> > punching.  I usually run xfstest automatically, and every time I need
> > to check the result of #255 and #285 manually.  That is annoying for me.
> 
> I would think the right thing to do is to have xfstests make sure it
> understands that fallocate working with FALLOC_FL_PUNCH_HOLE does not
> imply that fallocate without the FALLOC_FL_PUNCH_HOLE flag OR'ed in
> will work.

We already have this capabiity in xfstests via
_require_xfs_io_falloc_punch and _require_xfs_io_falloc. That,
however,  doesn't mean the tests that use these calls do the correct
requirement checks. That's the problem with 255 - it doesn't call
_require_xfs_io_falloc.

As to 285, the seek_sanity_test does it's own check for seek
hole/data support, and error out if it fails. This needs to be
turned into an equivalent _require_seek_hole_data (e.g. by running
"seek_sanity_test -t" to test for support) and 285 needs to the call
the _require_seek_hole_data before running the test proper.

Please send patches to xfs@oss.sgi.com....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
