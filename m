From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 13:18:45 -0400
Message-ID: <1242062325.9647.4.camel@localhost.localdomain>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org>
	 <20090511081216.GK4694@kernel.dk>  <20090511084121.GB29082@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Matthew Wilcox <willy@linux.intel.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:28418 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbZEKRTI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 May 2009 13:19:08 -0400
In-Reply-To: <20090511084121.GB29082@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-05-11 at 04:41 -0400, Theodore Tso wrote: 
> On Mon, May 11, 2009 at 10:12:16AM +0200, Jens Axboe wrote:
> > 
> > I largely agree with this. I think that trims should be queued and
> > postponed until the drive is largely idle. I don't want to put this IO
> > tracking in the block layer though, it's going to slow down our iops
> > rates for writes. Providing the functionality in the block layer does
> > make sense though, since it sits between that and the fs anyway. So just
> > not part of the generic IO path, but a set of helpers on the side.
> 
> Yes, I agree.  However, in that case, we need two things from the
> block I/O path.  (A) The discard management layer needs a way of
> knowing that the block device has become idle, and (B) ideally there
> should be a more efficient method for sending trim requests to the I/O
> submission path.

Just a quick me too on the performance problem.  The way btrfs does
trims today is going to be pretty slow as well.

For both btrfs and lvm, the filesystem is going to maintain free block
information based on logical block numbers.  The generic trim layer
should probably be based on a logical address that is stored per-bdi.

Then the bdi will need a callback to turn the logical address based trim
extent into physical extents on N number of physical device.

The tricky part is how will the FS decide a given block is actually
reusable.  We'll need a call back into the FS that indicates trim is
complete on a given logical extent.

-chris
> 

