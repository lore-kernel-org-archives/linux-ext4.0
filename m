From: Zach Brown <zab@zabbo.net>
Subject: Re: BLKZEROOUT + pread should return zeroes, right?
Date: Tue, 14 Oct 2014 11:57:53 -0700
Message-ID: <20141014185753.GA6838@lenny.home.zabbo.net>
References: <20141014030132.GA12013@birch.djwong.org>
 <20141014042711.GJ5267@dastard>
 <20141014092128.GA23656@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141014092128.GA23656@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 14, 2014 at 02:21:28AM -0700, Christoph Hellwig wrote:
> On Tue, Oct 14, 2014 at 03:27:11PM +1100, Dave Chinner wrote:
> > Broken usage, IMO. If you are going to use the block layer ioctls to
> > manipulate data int eh block device, you should be using direct Io
> > for all your data IO to the block device. Otherwise, coherency
> > problems occur....
> 
> I'd say BLKZEROOUT semantics are broken.  Having an ioctl exposed
> that maniulates on-disk data without cache coherence is a nightmare
> that people trip over easily.  Even experienced people like Darrick.

I'm definitely with Christoph on this one.  Coherent writes should be
the norm.

- z
