From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: BLKZEROOUT + pread should return zeroes, right?
Date: Tue, 14 Oct 2014 09:44:00 -0400
Message-ID: <yq1zjcy936n.fsf@sermon.lab.mkp.net>
References: <20141014030132.GA12013@birch.djwong.org>
	<20141014042711.GJ5267@dastard> <20141014092128.GA23656@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20141014092128.GA23656@infradead.org> (Christoph Hellwig's
	message of "Tue, 14 Oct 2014 02:21:28 -0700")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

>> Broken usage, IMO. If you are going to use the block layer ioctls to
>> manipulate data int eh block device, you should be using direct Io
>> for all your data IO to the block device. Otherwise, coherency
>> problems occur....

Christoph> I'd say BLKZEROOUT semantics are broken.  Having an ioctl
Christoph> exposed that maniulates on-disk data without cache coherence
Christoph> is a nightmare that people trip over easily.

I agree it's suboptimal but it's not different from how the other block
ioctls are working (discard, etc.).

The main issue is that the blkdev_issue_foobar() calls were designed for
in-kernel use and the calling filesystems were supposed to know what
they were doing with those pages. And for convenience we just wired up
the same calls as ioctls.

I'm undecided as to which hammer would be best.

-- 
Martin K. Petersen	Oracle Linux Engineering
