From: Dave Chinner <david@fromorbit.com>
Subject: Re: BLKZEROOUT + pread should return zeroes, right?
Date: Tue, 14 Oct 2014 15:27:11 +1100
Message-ID: <20141014042711.GJ5267@dastard>
References: <20141014030132.GA12013@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141014030132.GA12013@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 13, 2014 at 08:01:32PM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> What's the intended behavior if I issue BLKZEROOUT against a range of disk
> sectors and immediately re-read the sectors into a buffer?

Should return zeros.

[...]

> I boiled the whole thing down into the attached test program, which can
> reproduce the symptoms in a few loop iterations.  If I insert "sleep(1);"
> before the pread64, I pread zeroes every time; otherwise, I only pread zeroes
> part of the time.  If I call "ioctl(fd, BLKFLSBUF);" before the BLKZEROOUT, the
> chances of preading zeroes increases dramatically, but is still not 100%.

Hint #1: buffered IO == data in page cache.
Hint #2: BLKZEROOUT operates at the bio level.

> So, uh, is this a bug?  Or is that just how BLKZEROOUT works?  Or did I fubar
> the ioctl call?

Broken usage, IMO. If you are going to use the block layer ioctls to
manipulate data int eh block device, you should be using direct Io
for all your data IO to the block device. Otherwise, coherency
problems occur....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
