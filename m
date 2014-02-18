From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for
 fallocate
Date: Tue, 18 Feb 2014 19:33:24 +1100
Message-ID: <20140218083324.GB28666@dastard>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
 <20140218010138.GE13997@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:51808 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754473AbaBRIdr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Feb 2014 03:33:47 -0500
Content-Disposition: inline
In-Reply-To: <20140218010138.GE13997@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 18, 2014 at 12:01:38PM +1100, Dave Chinner wrote:
> On Mon, Feb 17, 2014 at 04:08:17PM +0100, Lukas Czerner wrote:
> > Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
> > functionality as xfs ioctl XFS_IOC_ZERO_RANGE.
> > 
> > It can be used to convert a range of file to zeros preferably without
> > issuing data IO. Blocks should be preallocated for the regions that span
> > holes in the file, and the entire range is preferable converted to
> > unwritten extents - even though file system may choose to zero out the
> > extent or do whatever which will result in reading zeros from the range
> > while the range remains allocated for the file.
> > 
> > This can be also used to preallocate blocks past EOF in the same way as
> > with fallocate. Flag FALLOC_FL_KEEP_SIZE which should cause the inode
> > size to remain the same.
> > 
> > You can test this feature yourself using xfstests, of fallocate(1) however
> > you'll need patches for util_linux, xfsprogs and xfstests which you
> > can find here:
> > 
> > http://people.redhat.com/lczerner/zero_range/
> > 
> > I'll post the patches after we agree and merge the kernel functionality.
> > 
> > I tested this mostly with a subset of xfstests using fsx and fsstress and
> > even with new generic/290 which is just a copy of xfs/290 usinz fzero
> > command for xfs_io instead of zero (which uses ioctl). I was testing on
> > x86_64 and ppc64 with block sizes of 1024, 2048 and 4096.
> 
> You also want to convert xfs/242 to be a generic test - it uses the
> _generic_test_punch helper to test all the corner cases across
> different extent type transitions.
> 
> > ./check generic/076 generic/232 generic/013 generic/070 generic/269 generic/083 generic/117 generic/068 generic/231 generic/127 generic/091 generic/075 generic/112 generic/263 generic/091 generic/075 generic/256 generic/255 generic/316 generic/300 generic/290;

FWIW. if that's a group of tests you consider good for testing
extent tree modifications, then can you create a test group for
these by adding "extent" to each of the tests in the group file?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
