From: Theodore Tso <tytso@mit.edu>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 04:41:21 -0400
Message-ID: <20090511084121.GB29082@mit.edu>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org> <20090511081216.GK4694@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <willy@linux.intel.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090511081216.GK4694@kernel.dk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 11, 2009 at 10:12:16AM +0200, Jens Axboe wrote:
> 
> I largely agree with this. I think that trims should be queued and
> postponed until the drive is largely idle. I don't want to put this IO
> tracking in the block layer though, it's going to slow down our iops
> rates for writes. Providing the functionality in the block layer does
> make sense though, since it sits between that and the fs anyway. So just
> not part of the generic IO path, but a set of helpers on the side.

Yes, I agree.  However, in that case, we need two things from the
block I/O path.  (A) The discard management layer needs a way of
knowing that the block device has become idle, and (B) ideally there
should be a more efficient method for sending trim requests to the I/O
submission path.  If we batch the results, when we *do* send the
discard requests, we may be sending several hundred discards, and it
would be useful if we could pass into the I/O submission path a linked
list of regions, so the queue can be drained *once*, and then a whole
series of discards can be sent to the device all at once.

Does that make sense to you?

						- Ted
