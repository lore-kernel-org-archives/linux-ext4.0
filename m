From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 10:49:41 +0200
Message-ID: <20090511084941.GN4694@kernel.dk>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org> <20090511081216.GK4694@kernel.dk> <20090511084121.GB29082@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <willy@linux.intel.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:36112 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757174AbZEKItl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 04:49:41 -0400
Content-Disposition: inline
In-Reply-To: <20090511084121.GB29082@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 11 2009, Theodore Tso wrote:
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

We don't have to inform of such a condition, the block layer can check
for existing pending trims and kick those off at an appropriate time.

> should be a more efficient method for sending trim requests to the I/O
> submission path.  If we batch the results, when we *do* send the
> discard requests, we may be sending several hundred discards, and it
> would be useful if we could pass into the I/O submission path a linked
> list of regions, so the queue can be drained *once*, and then a whole
> series of discards can be sent to the device all at once.
> 
> Does that make sense to you?

Agree, we definitely only want to do the queue quiesce once for passing
down a series of trims. With the delayed trim queuing, that isn't very
difficult.

-- 
Jens Axboe

