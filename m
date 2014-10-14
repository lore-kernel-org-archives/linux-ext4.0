From: Dave Chinner <david@fromorbit.com>
Subject: Re: BLKZEROOUT + pread should return zeroes, right?
Date: Wed, 15 Oct 2014 07:21:47 +1100
Message-ID: <20141014202147.GI17506@dastard>
References: <20141014030132.GA12013@birch.djwong.org>
 <20141014042711.GJ5267@dastard>
 <20141014092128.GA23656@infradead.org>
 <20141014185753.GA6838@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Zach Brown <zab@zabbo.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141014185753.GA6838@lenny.home.zabbo.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 14, 2014 at 11:57:53AM -0700, Zach Brown wrote:
> On Tue, Oct 14, 2014 at 02:21:28AM -0700, Christoph Hellwig wrote:
> > On Tue, Oct 14, 2014 at 03:27:11PM +1100, Dave Chinner wrote:
> > > Broken usage, IMO. If you are going to use the block layer ioctls to
> > > manipulate data int eh block device, you should be using direct Io
> > > for all your data IO to the block device. Otherwise, coherency
> > > problems occur....
> > 
> > I'd say BLKZEROOUT semantics are broken.  Having an ioctl exposed
> > that maniulates on-disk data without cache coherence is a nightmare
> > that people trip over easily.  Even experienced people like Darrick.
> 
> I'm definitely with Christoph on this one.  Coherent writes should be
> the norm.

I don't care what happens to the block layer ioctls w.r.t. cache
coherency. If people want to make them fully cache coherent for
buffered IO, go right ahead.

But that doesn't change the fact that if you want your application
to work sanely on existing kernels, then using direct IO is the only
option...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
